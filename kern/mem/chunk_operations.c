/*
 * chunk_operations.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include <kern/trap/fault_handler.h>
#include <kern/disk/pagefile_manager.h>
#include "kheap.h"
#include "memory_manager.h"


/******************************/
/*[1] RAM CHUNKS MANIPULATION */
/******************************/

//===============================
// 1) CUT-PASTE PAGES IN RAM:
//===============================
//This function should cut-paste the given number of pages from source_va to dest_va
//if the page table at any destination page in the range is not exist, it should create it
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int cut_paste_pages(uint32* page_directory, uint32 source_va, uint32 dest_va, uint32 num_of_pages)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] cut_paste_pages
	// Write your code here, remove the panic and write your code
	uint32 new_dest_va = dest_va;
	uint32 new_source_va = source_va;

	if(dest_va%PAGE_SIZE!=0)
		new_dest_va = ROUNDDOWN(dest_va,PAGE_SIZE);

	if(source_va%PAGE_SIZE!=0)
		new_source_va = ROUNDDOWN(source_va,PAGE_SIZE);
	uint32 max_size = (PAGE_SIZE * num_of_pages) + new_dest_va;

	for(uint32 i = new_dest_va; i < max_size; i += PAGE_SIZE)
	{
		uint32 *ptr_page_table_dest = NULL;
		get_page_table(page_directory,i,&ptr_page_table_dest);
		struct FrameInfo *dest_frame = get_frame_info(page_directory,i,&ptr_page_table_dest);

		if(dest_frame!=NULL)
			return -1;
	}
	for(uint32 i = new_dest_va; i < max_size; i += PAGE_SIZE)
	{
		uint32 *ptr_page_table_dest = NULL;
		get_page_table(page_directory,i,&ptr_page_table_dest);

		if(ptr_page_table_dest == NULL)
			ptr_page_table_dest = create_page_table(page_directory,i);

		struct FrameInfo *dest_frame = get_frame_info(page_directory,i,&ptr_page_table_dest);

		int source_perm = pt_get_page_permissions(page_directory,new_source_va);

		unmap_frame(page_directory,new_source_va);
		uint32 ret = allocate_frame(&dest_frame);
		map_frame(page_directory, dest_frame, i,source_perm);

		new_source_va += PAGE_SIZE;
	}
	return 0;
}

//===============================
// 2) COPY-PASTE RANGE IN RAM:
//===============================
//This function should copy-paste the given size from source_va to dest_va
//if the page table at any destination page in the range is not exist, it should create it
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int copy_paste_chunk(uint32* page_directory, uint32 source_va, uint32 dest_va, uint32 size)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] copy_paste_chunk
	// Write your code here, remove the panic and write your code
	//panic("copy_paste_chunk() is not implemented yet...!!");
	uint32 *page_table=NULL;
	uint32 new_dest_va = dest_va;
	uint32 new_source_va = source_va;
	for(uint32 i=dest_va;i<dest_va+size ;i+=PAGE_SIZE)
	{
	   get_page_table(page_directory,i,&page_table);
	   if(page_table==NULL)
		   page_table=create_page_table(page_directory,i);

	   struct FrameInfo *frame_info=get_frame_info(page_directory,i,&page_table);
	   uint32 perm =pt_get_page_permissions(page_directory,i);

	   if((frame_info != NULL) && (( perm & PERM_WRITEABLE) !=PERM_WRITEABLE))
			return -1;
	   else
	   {
		   if(frame_info == NULL)
		   {
			   uint32 perms =pt_get_page_permissions(page_directory,new_source_va);
			   uint32 user_perm = (perms & PERM_USER)|PERM_WRITEABLE;
			   allocate_frame(&frame_info);
			   map_frame(page_directory,frame_info,i,user_perm);
		   }
	   }
	   new_source_va += PAGE_SIZE;
	}
	uint32 *frame = (uint32*)dest_va;
    uint32 *page = (uint32*)source_va;
    for (uint32 i = source_va; i < source_va+size ;i+=4)
    {
	    *frame= *page;
	    frame++;
	    page++;
    }
	return 0;
}

//===============================
// 3) SHARE RANGE IN RAM:
//===============================
//This function should share the given size from dest_va with the source_va
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int share_chunk(uint32* page_directory, uint32 source_va,uint32 dest_va, uint32 size, uint32 perms)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] share_chunk
	// Write your code here, remove the panic and write your code
	uint32 *page_table=NULL;
    uint32 va_dest=ROUNDDOWN(dest_va,PAGE_SIZE);
    uint32 max_va_des=ROUNDUP(dest_va+size,PAGE_SIZE);



   for(uint32 i=va_dest;i<max_va_des ;i+=PAGE_SIZE)
    {
        get_page_table(page_directory,i,&page_table);
        if(page_table==NULL)
           page_table=create_page_table(page_directory,i);



      struct FrameInfo *frame_info=get_frame_info(page_directory,i,&page_table);
       if (frame_info != NULL)
           return -1;



       uint32 *page_table_source = NULL;
        get_page_table(page_directory,source_va,&page_table_source);
        struct FrameInfo *page_info=get_frame_info(page_directory,source_va,&page_table_source);



       map_frame(page_directory,page_info,i,perms);



       source_va += PAGE_SIZE;
    }
    return 0;
}

//===============================
// 4) ALLOCATE CHUNK IN RAM:
//===============================
//This function should allocate in RAM the given range [va, va+size)
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int allocate_chunk(uint32* page_directory, uint32 va, uint32 size, uint32 perms)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] allocate_chunk
	// Write your code here, remove the panic and write your code
	uint32 virtual_address=0;
	uint32 range_page=va+size;
	uint32 virtual_range=0;
	struct FrameInfo *sb_chunck= NULL ;
	uint32 *page_table_point=NULL;
    uint32 result=0;

	virtual_address=ROUNDDOWN(va,PAGE_SIZE);
	virtual_range=ROUNDUP(range_page,PAGE_SIZE);
	uint32 new_virtual_address;
	for(uint32 count=virtual_address;count<virtual_range;count+=PAGE_SIZE)
	{
		new_virtual_address=count;
		get_page_table(page_directory,new_virtual_address,&page_table_point);
		if(page_table_point==NULL)
		{
		   page_table_point=create_page_table(page_directory,new_virtual_address);
		}
	    sb_chunck=get_frame_info(page_directory,new_virtual_address,&page_table_point);
		if(sb_chunck!=NULL)
		{
			return -1;
		}
	    result= allocate_frame(&sb_chunck);
		if(result != E_NO_MEM)
		{
			sb_chunck->va = new_virtual_address;
			result=map_frame(page_directory,sb_chunck,new_virtual_address,perms);
		}
	}
	return 0;
}

/*BONUS*/
//=====================================
// 5) CALCULATE ALLOCATED SPACE IN RAM:
//=====================================
void calculate_allocated_space(uint32* page_directory, uint32 sva, uint32 eva, uint32 *num_tables, uint32 *num_pages)
{
	//TODO: [PROJECT MS2 - BONUS] [CHUNK OPERATIONS] calculate_allocated_space
	// Write your code here, remove the panic and write your code
	panic("calculate_allocated_space() is not implemented yet...!!");
}

/*BONUS*/
//=====================================
// 6) CALCULATE REQUIRED FRAMES IN RAM:
//=====================================
// calculate_required_frames:
// calculates the new allocation size required for given address+size,
// we are not interested in knowing if pages or tables actually exist in memory or the page file,
// we are interested in knowing whether they are allocated or not.
uint32 calculate_required_frames(uint32* page_directory, uint32 sva, uint32 size)
{
	//TODO: [PROJECT MS2 - BONUS] [CHUNK OPERATIONS] calculate_required_frames
	// Write your code here, remove the panic and write your code
	panic("calculate_required_frames() is not implemented yet...!!");
}

//=================================================================================//
//===========================END RAM CHUNKS MANIPULATION ==========================//
//=================================================================================//

/*******************************/
/*[2] USER CHUNKS MANIPULATION */
/*******************************/

//======================================================
/// functions used for USER HEAP (malloc, free, ...)
//======================================================

//=====================================
// 1) ALLOCATE USER MEMORY:
//=====================================
void allocate_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{
	// Write your code here, remove the panic and write your code
	panic("allocate_user_mem() is not implemented yet...!!");
}

//=====================================
// 2) FREE USER MEMORY:
//=====================================
void free_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{
	//TODO: [PROJECT MS3] [USER HEAP - KERNEL SIDE] free_user_mem
	// Write your code here, remove the panic and write your code
	panic("free_user_mem() is not implemented yet...!!");

	//This function should:
	//1. Free ALL pages of the given range from the Page File
	//2. Free ONLY pages that are resident in the working set from the memory
	//3. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
}

//=====================================
// 2) FREE USER MEMORY (BUFFERING):
//=====================================
void __free_user_mem_with_buffering(struct Env* e, uint32 virtual_address, uint32 size)
{
	// your code is here, remove the panic and write your code
	panic("__free_user_mem_with_buffering() is not implemented yet...!!");

	//This function should:
	//1. Free ALL pages of the given range from the Page File
	//2. Free ONLY pages that are resident in the working set from the memory
	//3. Free any BUFFERED pages in the given range
	//4. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
}

//=====================================
// 3) MOVE USER MEMORY:
//=====================================
void move_user_mem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - KERNEL SIDE] move_user_mem
	//your code is here, remove the panic and write your code
	panic("move_user_mem() is not implemented yet...!!");

	// This function should move all pages from "src_virtual_address" to "dst_virtual_address"
	// with the given size
	// After finished, the src_virtual_address must no longer be accessed/exist in either page file
	// or main memory

	/**/
}

//=================================================================================//
//========================== END USER CHUNKS MANIPULATION =========================//
//=================================================================================//

