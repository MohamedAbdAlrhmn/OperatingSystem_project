#include <inc/memlayout.h>
#include "shared_memory_manager.h"

#include <inc/mmu.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>
#include <inc/environment_definitions.h>

#include <kern/proc/user_environment.h>
#include <kern/trap/syscall.h>
#include "kheap.h"
#include "memory_manager.h"

//2017

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//===========================
// [1] Create "shares" array:
//===========================
//Dynamically allocate the array of shared objects
//initialize the array of shared objects by 0's and empty = 1
void create_shares_array(uint32 numOfElements)
{
#if USE_KHEAP
	MAX_SHARES  = numOfElements ;
	shares = kmalloc(numOfElements*sizeof(struct Share));
	if (shares == NULL)
	{
		panic("Kernel runs out of memory\nCan't create the array of shared objects.");
	}
#endif
	for (int i = 0; i < MAX_SHARES; ++i)
	{
		memset(&(shares[i]), 0, sizeof(struct Share));
		shares[i].empty = 1;
	}
}

//===========================
// [2] Allocate Share Object:
//===========================
//Allocates a new (empty) shared object from the "shares" array
//It dynamically creates the "framesStorage"
//Return:
//	a) if succeed:
//		1. allocatedObject (pointer to struct Share) passed by reference
//		2. sharedObjectID (its index in the array) as a return parameter
//	b) E_NO_SHARE if the the array of shares is full (i.e. reaches "MAX_SHARES")
int allocate_share_object(struct Share **allocatedObject)
{
	int32 sharedObjectID = -1 ;
	for (int i = 0; i < MAX_SHARES; ++i)
	{
		if (shares[i].empty)
		{
			sharedObjectID = i;
			break;
		}
	}

	if (sharedObjectID == -1)
	{
		return E_NO_SHARE ;
/*		//try to increase double the size of the "shares" array
#if USE_KHEAP
		{
			shares = krealloc(shares, 2*MAX_SHARES);
			if (shares == NULL)
			{
				*allocatedObject = NULL;
				return E_NO_SHARE;
			}
			else
			{
				sharedObjectID = MAX_SHARES;
				MAX_SHARES *= 2;
			}
		}
#else
		{
			panic("Attempt to dynamically allocate space inside kernel while kheap is disabled .. ");
			*allocatedObject = NULL;
			return E_NO_SHARE;
		}
#endif
*/
	}

	*allocatedObject = &(shares[sharedObjectID]);
	shares[sharedObjectID].empty = 0;

#if USE_KHEAP
	{
		shares[sharedObjectID].framesStorage = create_frames_storage();
	}
#endif
	memset(shares[sharedObjectID].framesStorage, 0, PAGE_SIZE);

	return sharedObjectID;
}

//=========================
// [3] Get Share Object ID:
//=========================
//Search for the given shared object in the "shares" array
//Return:
//	a) if found: SharedObjectID (index of the shared object in the array)
//	b) else: E_SHARED_MEM_NOT_EXISTS
int get_share_object_ID(int32 ownerID, char* name)
{
	int i=0;

	for(; i< MAX_SHARES; ++i)
	{
		if (shares[i].empty)
			continue;

		//cprintf("shared var name = %s compared with %s\n", name, shares[i].name);
		if(shares[i].ownerID == ownerID && strcmp(name, shares[i].name)==0)
		{
			//cprintf("%s found\n", name);
			return i;
		}
	}
	return E_SHARED_MEM_NOT_EXISTS;
}

//=========================
// [4] Delete Share Object:
//=========================
//delete the given sharedObjectID from the "shares" array
//Return:
//	a) 0 if succeed
//	b) E_SHARED_MEM_NOT_EXISTS if the shared object is not exists
int free_share_object(uint32 sharedObjectID)
{
	if (sharedObjectID >= MAX_SHARES)
		return E_SHARED_MEM_NOT_EXISTS;

	//panic("deleteSharedObject: not implemented yet");
	clear_frames_storage(shares[sharedObjectID].framesStorage);
#if USE_KHEAP
	kfree(shares[sharedObjectID].framesStorage);
#endif
	memset(&(shares[sharedObjectID]), 0, sizeof(struct Share));
	shares[sharedObjectID].empty = 1;

	return 0;
}

// 2014 - edited in 2017
//===========================
// [5] Create frames_storage:
//===========================
// if KHEAP = 1: Create the frames_storage by allocating a PAGE for its directory
inline uint32* create_frames_storage()
{
	uint32* frames_storage = kmalloc(PAGE_SIZE);
	if(frames_storage == NULL)
	{
		panic("NOT ENOUGH KERNEL HEAP SPACE");
	}
	return frames_storage;
}
//===========================
// [6] Add frame to storage:
//===========================
// Add a frame info to the storage of frames at the given index
inline void add_frame_to_storage(uint32* frames_storage, struct FrameInfo* ptr_frame_info, uint32 index)
{
	uint32 va = index * PAGE_SIZE ;
	uint32 *ptr_page_table;
	int r = get_page_table(frames_storage,  va, &ptr_page_table);
	if(r == TABLE_NOT_EXIST)
	{
#if USE_KHEAP
		{
			ptr_page_table = create_page_table(frames_storage, (uint32)va);
		}
#else
		{
			__static_cpt(frames_storage, (uint32)va, &ptr_page_table);

		}
#endif
	}
	ptr_page_table[PTX(va)] = CONSTRUCT_ENTRY(to_physical_address(ptr_frame_info), 0 | PERM_PRESENT);
}

//===========================
// [7] Get frame from storage:
//===========================
// Get a frame info from the storage of frames at the given index
inline struct FrameInfo* get_frame_from_storage(uint32* frames_storage, uint32 index)
{
	struct FrameInfo* ptr_frame_info;
	uint32 *ptr_page_table ;
	uint32 va = index * PAGE_SIZE ;
	ptr_frame_info = get_frame_info(frames_storage,  va, &ptr_page_table);
	return ptr_frame_info;
}

//===========================
// [8] Clear the frames_storage:
//===========================
inline void clear_frames_storage(uint32* frames_storage)
{
	int fourMega = 1024 * PAGE_SIZE ;
	int i ;
	for (i = 0 ; i < 1024 ; i++)
	{
		if (frames_storage[i] != 0)
		{
#if USE_KHEAP
			{
				kfree((void*)kheap_virtual_address(EXTRACT_ADDRESS(frames_storage[i])));
			}
#else
			{
				free_frame(to_frame_info(EXTRACT_ADDRESS(frames_storage[i])));
			}
#endif
			frames_storage[i] = 0;
		}
	}
}


//==============================
// [9] Get Size of Share Object:
//==============================
int getSizeOfSharedObject(int32 ownerID, char* shareName)
{
	// your code is here, remove the panic and write your code
	//panic("getSizeOfSharedObject() is not implemented yet...!!");

	// This function should return the size of the given shared object
	// RETURN:
	//	a) If found, return size of shared object
	//	b) Else, return E_SHARED_MEM_NOT_EXISTS
	//

	int shareObjectID = get_share_object_ID(ownerID, shareName);
	if (shareObjectID == E_SHARED_MEM_NOT_EXISTS)
		return E_SHARED_MEM_NOT_EXISTS;
	else
		return shares[shareObjectID].size;

	return 0;
}

//********************************************************************************//

//===========================================================


//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//=========================
// [1] Create Share Object:
//=========================
int createSharedObject(int32 ownerID, char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
	//TODO: [PROJECT MS3] [SHARING - KERNEL SIDE] createSharedObject()
	// your code is here, remove the panic and write your code
	//panic("createSharedObject() is not implemented yet...!!");
	// This function should create the shared object at the given virtual address with the given size
	// and return the ShareObjectID
	// RETURN:
	//	a) ShareObjectID (its index in "shares" array) if success
	//	b) E_SHARED_MEM_EXISTS if the shared object already exists
	//	c) E_NO_SHARE if the number of shared objects reaches max "MAX_SHARES"
	struct Env* myenv = curenv; //The calling environment

	//Check if the shared object already exists
	int shared_Result = get_share_object_ID(ownerID , shareName);
	if (shared_Result != E_SHARED_MEM_NOT_EXISTS)
		return E_SHARED_MEM_EXISTS;

	//Check if any shared object available
	struct Share * allocatedObject = NULL;
	int sharedObj_index = allocate_share_object(&allocatedObject);
	if(sharedObj_index == E_NO_SHARE)
		return E_NO_SHARE;

	//Allocate Frames for each page
	uint32 va = (uint32) virtual_address;
	uint32 Rounded_Size = ROUNDUP(size,PAGE_SIZE);
	struct FrameInfo *sb_chunck;
	int j = 0;
	for(uint32 i = 0; i < Rounded_Size; i += PAGE_SIZE)
	{
		sb_chunck= NULL;
		int result= allocate_frame(&sb_chunck);
		if(result != E_NO_MEM)
		{
			sb_chunck->va = va;
			map_frame(curenv->env_page_directory ,sb_chunck ,va, PERM_WRITEABLE | PERM_USER);
			add_frame_to_storage(shares[sharedObj_index].framesStorage , sb_chunck , j);
			j++;
			va += PAGE_SIZE;
		}
		else
			return -1;
	}

	//Initialize the shared object infos
	shares[sharedObj_index].ownerID = ownerID;
	strcpy(shares[sharedObj_index].name,shareName);
	shares[sharedObj_index].references = 1;
	shares[sharedObj_index].size = size;
	shares[sharedObj_index].isWritable = isWritable;
	shares[sharedObj_index].empty = 0;
	return sharedObj_index;
}

//======================
// [2] Get Share Object:
//======================
int getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
	//TODO: [PROJECT MS3] [SHARING - KERNEL SIDE] getSharedObject()
	// your code is here, remove the panic and write your code
	//panic("getSharedObject() is not implemented yet...!!");

	struct Env* myenv = curenv; //The calling environment

	// 	This function should share the required object in the heap of the current environment
	//	starting from the given virtual_address with the specified permissions of the object: read_only/writable
	// 	and return the ShareObjectID
	// RETURN:
	//	a) sharedObjectID (its index in the array) if success
	//	b) E_SHARED_MEM_NOT_EXISTS if the shared object is not exists

	uint32 va = (uint32) virtual_address;

	uint32 shared_index = get_share_object_ID(ownerID,shareName);
	if(shared_index == E_SHARED_MEM_NOT_EXISTS)
		return E_SHARED_MEM_NOT_EXISTS;

	int size_count = ROUNDUP(shares[shared_index].size,PAGE_SIZE) / PAGE_SIZE;
	for(int index_of_page = 0; index_of_page < size_count; index_of_page++)
	{
		struct FrameInfo* frame = get_frame_from_storage(shares[shared_index].framesStorage, index_of_page);
		if(shares[shared_index].isWritable == 1)
			map_frame(myenv->env_page_directory, frame, va, PERM_WRITEABLE | PERM_USER | PERM_PRESENT);
		else
			map_frame(myenv->env_page_directory, frame, va, PERM_USER | PERM_PRESENT);
		va += PAGE_SIZE;
	}
	return shared_index;
}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//

//===================
// Free Share Object:
//===================
int freeSharedObject(int32 sharedObjectID, void *startVA)
{
	//TODO: [PROJECT MS3 - BONUS] [SHARING - KERNEL SIDE] freeSharedObject()
	// your code is here, remove the panic and write your code
	//panic("freeSharedObject() is not implemented yet...!!");

	struct Env* myenv = curenv; //The calling environment
	uint32 check ;
	startVA= ROUNDDOWN(startVA,PAGE_SIZE);
	int size_count = ROUNDUP(shares[sharedObjectID].size,PAGE_SIZE) / PAGE_SIZE;
	for(int index_of_page = 0; index_of_page < size_count; index_of_page++)
	{

		struct FrameInfo* frame = get_frame_from_storage(shares[index_of_page].framesStorage, index_of_page);
		unmap_frame(curenv->env_page_directory,frame->va);
		uint32* ptr_page = NULL;
		get_page_table(curenv->env_page_directory,(uint32)startVA,&ptr_page);

		if (ptr_page != NULL)
		{
			int index = 0;
			do
			{
				if(ptr_page[index] != 0)
				{
					check = 1;
					break;
				}
				index ++;
			}while((index % 1024) != 0);
			if(check == 0)
			{
				pd_clear_page_dir_entry(curenv->env_page_directory,(uint32) startVA);
				kfree((void *)ptr_page);
			}
		}
		startVA += PAGE_SIZE;

	}
	shares[sharedObjectID].references -- ;
	struct Share Last_element;
	Last_element = shares[MAX_SHARES-1];
	uint32 y;
	if(shares[sharedObjectID].name == Last_element.name )
	{
		y = free_share_object(sharedObjectID);
		if (y == E_SHARED_MEM_NOT_EXISTS )
			return y;
	}
	return 0;

	// This function should free (delete) the shared object from the User Heapof the current environment
	// If this is the last shared env, then the "frames_store" should be cleared and the shared object should be deleted
	// RETURN:
	//	a) 0 if success
	//	b) E_SHARED_MEM_NOT_EXISTS if the shared object is not exists

	// Steps:
	//	1) Get the shared object from the "shares" array (use get_share_object_ID())
	//	2) Unmap it from the current environment "myenv"
	//	3) If one or more table becomes empty, remove it
	//	4) Update references
	//	5) If this is the last share, delete the share object (use free_share_object())
	//	6) Flush the cache "tlbflush()"
}
