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
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
	{
		if(va==point->sva)
		   return point;
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
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
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
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
	{
		if(size <= point->size)
		{
		   if(size == point->size){
			   LIST_REMOVE(&FreeMemBlocksList,point);
			   return  point;
			   break;
		   }
		   else if (size < point->size){
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
			   ReturnedBlock->sva = point->sva;
			   ReturnedBlock->size = size;
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
			   point->sva += size;
			   point->size -= size;
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
}

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
	{
		if(size <= currentMemBlock->size)
		{
		   if(size == currentMemBlock->size)
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
			   return currentMemBlock;
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
		   {
			   isFound = 1==1;
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
		foundBlock->sva = svaOfMinSize;
		foundBlock->size = size;
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
		cMemBlock->sva += size;
		cMemBlock->size -= size;
		return foundBlock;
	}
	return NULL;
}

uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
		{
			if(size <= point->size)
			{
			   if(size == point->size){
				   LIST_REMOVE(&FreeMemBlocksList,point);
				   svaOfNF = point->sva;
				   return  point;
				   break;
			   }
			   else if (size < point->size){
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
				   ReturnedBlock->sva = point->sva;
				   ReturnedBlock->size = size;
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
				   svaOfNF = ReturnedBlock->sva;
				   point->sva += size;
				   point->size -= size;
				   return ReturnedBlock;
				   break;
			   }
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
		{
			if(point->sva >= svaOfNF)
			{
				if(size <= point->size)
				{
				   if(size == point->size){
					   LIST_REMOVE(&FreeMemBlocksList,point);
					   svaOfNF = point->sva;
					   return  point;
				   }
				   else if (size < point->size){
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
					   ReturnedBlock->sva = point->sva;
					   ReturnedBlock->size = size;
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
					   svaOfNF = ReturnedBlock->sva;
					   point->sva += size;
					   point->size -= size;
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
		{
			if(point->sva < svaOfNF)
			{
				if(size <= point->size)
				{
				   if(size == point->size){
					   LIST_REMOVE(&FreeMemBlocksList,point);
					   svaOfNF = point->sva;
					   return  point;
				   }
				   else if (size < point->size){
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
					   ReturnedBlock->sva = point->sva;
					   ReturnedBlock->size = size;
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
					   svaOfNF = ReturnedBlock->sva;
					   point->sva += size;
					   point->size -= size;
					   return ReturnedBlock;
				   }
				}
			}
		}
	}
	return NULL;
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
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
		{
			blockToInsert->size += head->size;
			LIST_REMOVE(&FreeMemBlocksList, head);
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
	{
		if(tail->sva + tail->size == blockToInsert->sva)
		{
			tail->size += blockToInsert->size;
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
		{
			nextBlock = LIST_NEXT(currentBlock);
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
					{
						currentBlock->size += nextBlock->size;
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
						nextBlock->sva = 0;
						nextBlock->size = 0;
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
					}
					currentBlock->size += blockToInsert->size;
					blockToInsert->sva = 0;
					blockToInsert->size = 0;
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
					break;
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
					blockToInsert->size += nextBlock->size;
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
					nextBlock->sva = 0;
					nextBlock->size = 0;
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
					break;
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
					break;
				}
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}

