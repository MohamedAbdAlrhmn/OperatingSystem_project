/* *********************************************************** */
/* MAKE SURE PAGE_WS_MAX_SIZE =  12 */
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
	int kilo = 1024;
	int Mega = 1024*1024;

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
		char *x = malloc(sizeof( char)*size) ;

		char *y = malloc(sizeof( char)*size) ;


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;

		x[1]=-1;

		x[5*Mega]=-1;

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
		*p1 = -1 ;

		y[1*Mega]=-1;

		x[8*Mega] = -1;

		x[12*Mega]=-1;


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;
		free(x);
		free(y);
		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
		x = malloc(sizeof(char)*size) ;
		//Access VA 0x200000
		*p1 = -1 ;
		x[1]=-2;
		x[5*Mega]=-2;
		x[8*Mega] = -2;
//		x[12*Mega]=-2;
		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
		;
		int i = 0, j ;

		int count = 1;
		for (; i < 7; i++)
		{
			int found = 0 ;
			count++;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");


	return;
}

