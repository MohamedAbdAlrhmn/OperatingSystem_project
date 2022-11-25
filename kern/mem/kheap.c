#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"

//==================================================================//
//==================================================================//
//NOTE: All kernel heap allocations are multiples of PAGE_SIZE (4KB)//
//==================================================================//
//==================================================================//

void initialize_dyn_block_system()
{
//TODO: [PROJECT MS2] [KERNEL HEAP] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//kpanic_into_prompt("initialize_dyn_block_system() is not implemented yet...!!");

	//1.Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
	LIST_INIT(&FreeMemBlocksList);
	uint32 arr_size = 0;

#if STATIC_MEMBLOCK_ALLOC
	//DO NOTHING
#else
	 //Dynamically allocate the array of MemBlockNodes remember to:

	 //2. set MAX_MEM_BLOCK_CNT with the chosen size of the array
	 MAX_MEM_BLOCK_CNT = (KERNEL_HEAP_MAX-KERNEL_HEAP_START)/PAGE_SIZE;

	 //3. assign starting address of MemBlockNodes array
	 MemBlockNodes  =(struct MemBlock*) KERNEL_HEAP_START;

	 //4.calculate the total size of memory required for the MemBlockNodes array (size of all the Structs)
	 arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);

	 //5. allocate_chunk for this total memory size, with correct startAddress
	 allocate_chunk(ptr_page_directory, KERNEL_HEAP_START , arr_size , PERM_WRITEABLE | PERM_PRESENT);
	 //HINT: can use alloc_chunk(...) function
#endif
	//6.Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
	//7. Take a block from the AvailableMemBlocksList and fill its size with all of the heap size (without size allocated for the array) and think what should the start address be?
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
	NewBlock->sva = KERNEL_HEAP_START + arr_size;
	NewBlock->size = (KERNEL_HEAP_MAX-KERNEL_HEAP_START) - arr_size;
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
	//8. Insert a new MemBlock with the remaining heap size into the FreeMemBlocksList
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);

}

void* kmalloc(unsigned int size)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kmalloc
	// your code is here, remove the panic and write your code
	//kpanic_into_prompt("kmalloc() is not implemented yet...!!");
	uint32 allocate_size=ROUNDUP(size,PAGE_SIZE);
	struct MemBlock * mem_block;

	if(isKHeapPlacementStrategyFIRSTFIT())
		mem_block = alloc_block_FF(allocate_size);
	else if (isKHeapPlacementStrategyBESTFIT())
		mem_block = alloc_block_BF(allocate_size);
	else
		mem_block = alloc_block_NF(allocate_size);

	if (mem_block != NULL )
	{
		int result = allocate_chunk(ptr_page_directory,mem_block->sva,allocate_size,PERM_WRITEABLE| PERM_PRESENT);
		if (result == 0)
		{
			//LIST_INSERT_HEAD(&AllocMemBlocksList, mem_block);
			insert_sorted_allocList(mem_block);
			return (uint32 *) mem_block->sva;
		}
		else
			return 	NULL;
	}
	return NULL;
}
void kfree(void* virtual_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kfree
	// Write your code here, remove the panic and write your code
	//panic("kfree() is not implemented yet...!!");
	struct MemBlock * mem_block = find_block(&AllocMemBlocksList,(uint32)virtual_address);
	if(mem_block != NULL)
	{
		LIST_REMOVE(&AllocMemBlocksList,mem_block);
		uint32 start = ROUNDDOWN(mem_block->sva,PAGE_SIZE);
		uint32 end = ROUNDUP(mem_block->sva+mem_block->size,PAGE_SIZE);

		for(uint32 i = start ; i < end; i += PAGE_SIZE)
			unmap_frame(ptr_page_directory , i);

		insert_sorted_with_merge_freeList(mem_block);
	}
}

unsigned int kheap_virtual_address(unsigned int physical_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kheap_virtual_address
	// Write your code here, remove the panic and write your code
//	panic("kheap_virtual_address() is not implemented yet...!!");

	struct FrameInfo *convert_to_va=to_frame_info(physical_address);
	if(convert_to_va!=NULL)
		return convert_to_va->va;
	else
		return 0;
	//return the virtual address corresponding to given physical_address
	//refer to the project presentation and documentation for details
	//EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED ==================
}

unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//TODO: [PROJECT MS2] [KERNEL HEAP] kheap_physical_address
	// Write your code here, remove the panic and write your code
	//panic("kheap_physical_address() is not implemented yet...!!");
	uint32 *ptr_page=NULL;
	struct FrameInfo *frame_of_the_va = get_frame_info(ptr_page_directory,virtual_address,&ptr_page);
	uint32 address_physical=to_physical_address(frame_of_the_va);

	if(frame_of_the_va != NULL)
		return address_physical;
	return 0;

	//return the physical address corresponding to given virtual_address
	//refer to the project presentation and documentation for details
}


void kfreeall()
{
	panic("Not implemented!");

}

void kshrink(uint32 newSize)
{
	panic("Not implemented!");
}

void kexpand(uint32 newSize)
{
	panic("Not implemented!");
}




//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

void *krealloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT MS2 - BONUS] [KERNEL HEAP] krealloc
	// Write your code here, remove the panic and write your code
	panic("krealloc() is not implemented yet...!!");
}
