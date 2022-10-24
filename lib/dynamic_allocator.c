/*
 * dyn_block_management.c
 *
 *  Created on: Sep 21, 2022
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"


//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
	cprintf("\n=========================================\n");

}

//********************************************************************************//
//********************************************************************************//

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
		for(int y=0;y<numOfBlocks;y++)
		{
			LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));

		}



}

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
//	panic("find_block() is not implemented yet...!!");

	struct MemBlock *point;
	LIST_FOREACH(point,blockList)
	{
		if(va==point->sva)
		{
		   return point;
		   break;

		}



	}
	return NULL;

}

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	/*uint32 result_1;
		uint32 result_2;
		uint32 space = blockToInsert->size + blockToInsert->sva;
		uint32 size = LIST_SIZE(&(AllocMemBlocksList));
		if (size == 0)
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock *element;
			struct MemBlock *next_element;
			LIST_FOREACH(element, &AllocMemBlocksList)
			{
				result_1 = element->size +element->sva;
				next_element = LIST_NEXT(element);
				result_2 = next_element->size + next_element->sva;
				if (space > result_1 && space < result_2)
				{
					element->prev_next_info.le_next = blockToInsert;
					next_element->prev_next_info.le_prev =blockToInsert;
					blockToInsert->prev_next_info.le_prev = element;
					break;
				}
				else if (space < result_1)
				{
					blockToInsert->prev_next_info.le_next = element;
					element->prev_next_info.le_prev = blockToInsert;
					LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
					break;
				}
				else if (next_element == NULL)
				{
					LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert);
					break;
				}
			}
		}*/
		struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
		struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

		if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
		{
			if(head == NULL )
			{
				LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
			}
			else if (blockToInsert->sva <= head->sva)
			{
				LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
			}
			else if (blockToInsert->sva >= tail->sva )
			{
				LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
			}
		}
		else
		{
			struct MemBlock *current_block = head;
			struct MemBlock *next_block = NULL;
			LIST_FOREACH (current_block, &AllocMemBlocksList)
			{
				next_block = LIST_NEXT(current_block);
				if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva )
				{
					LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
					break;
				}
			}
		}
}

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_FF() is not implemented yet...!!");
}

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_BF() is not implemented yet...!!");
}


//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");

}

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");



	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();

}

