
obj/user/tst_worstfit:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 81 0c 00 00       	call   800cb7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 40 08 00 00    	sub    $0x840,%esp
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  800043:	83 ec 0c             	sub    $0xc,%esp
  800046:	6a 04                	push   $0x4
  800048:	e8 7f 27 00 00       	call   8027cc <sys_set_uheap_strategy>
  80004d:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800050:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800054:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80005b:	eb 29                	jmp    800086 <_main+0x4e>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005d:	a1 20 50 80 00       	mov    0x805020,%eax
  800062:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800068:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80006b:	89 d0                	mov    %edx,%eax
  80006d:	01 c0                	add    %eax,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	c1 e0 03             	shl    $0x3,%eax
  800074:	01 c8                	add    %ecx,%eax
  800076:	8a 40 04             	mov    0x4(%eax),%al
  800079:	84 c0                	test   %al,%al
  80007b:	74 06                	je     800083 <_main+0x4b>
			{
				fullWS = 0;
  80007d:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800081:	eb 12                	jmp    800095 <_main+0x5d>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800083:	ff 45 f0             	incl   -0x10(%ebp)
  800086:	a1 20 50 80 00       	mov    0x805020,%eax
  80008b:	8b 50 74             	mov    0x74(%eax),%edx
  80008e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800091:	39 c2                	cmp    %eax,%edx
  800093:	77 c8                	ja     80005d <_main+0x25>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800095:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800099:	74 14                	je     8000af <_main+0x77>
  80009b:	83 ec 04             	sub    $0x4,%esp
  80009e:	68 e0 40 80 00       	push   $0x8040e0
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 fc 40 80 00       	push   $0x8040fc
  8000aa:	e8 44 0d 00 00       	call   800df3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	6a 00                	push   $0x0
  8000b4:	e8 76 1f 00 00       	call   80202f <malloc>
  8000b9:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000bc:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  8000c3:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)

	int count = 0;
  8000ca:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int totalNumberOfTests = 11;
  8000d1:	c7 45 cc 0b 00 00 00 	movl   $0xb,-0x34(%ebp)

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000db:	01 c0                	add    %eax,%eax
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e9:	f7 f7                	div    %edi
  8000eb:	89 45 c8             	mov    %eax,-0x38(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000ee:	81 7d c8 00 01 00 00 	cmpl   $0x100,-0x38(%ebp)
  8000f5:	74 16                	je     80010d <_main+0xd5>
  8000f7:	68 10 41 80 00       	push   $0x804110
  8000fc:	68 27 41 80 00       	push   $0x804127
  800101:	6a 24                	push   $0x24
  800103:	68 fc 40 80 00       	push   $0x8040fc
  800108:	e8 e6 0c 00 00       	call   800df3 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 04                	push   $0x4
  800112:	e8 b5 26 00 00       	call   8027cc <sys_set_uheap_strategy>
  800117:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80011a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80011e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800125:	eb 29                	jmp    800150 <_main+0x118>
		{
			if (myEnv->__uptr_pws[i].empty)
  800127:	a1 20 50 80 00       	mov    0x805020,%eax
  80012c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800132:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800135:	89 d0                	mov    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	c1 e0 03             	shl    $0x3,%eax
  80013e:	01 c8                	add    %ecx,%eax
  800140:	8a 40 04             	mov    0x4(%eax),%al
  800143:	84 c0                	test   %al,%al
  800145:	74 06                	je     80014d <_main+0x115>
			{
				fullWS = 0;
  800147:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80014b:	eb 12                	jmp    80015f <_main+0x127>
	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80014d:	ff 45 e8             	incl   -0x18(%ebp)
  800150:	a1 20 50 80 00       	mov    0x805020,%eax
  800155:	8b 50 74             	mov    0x74(%eax),%edx
  800158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015b:	39 c2                	cmp    %eax,%edx
  80015d:	77 c8                	ja     800127 <_main+0xef>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80015f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800163:	74 14                	je     800179 <_main+0x141>
  800165:	83 ec 04             	sub    $0x4,%esp
  800168:	68 e0 40 80 00       	push   $0x8040e0
  80016d:	6a 36                	push   $0x36
  80016f:	68 fc 40 80 00       	push   $0x8040fc
  800174:	e8 7a 0c 00 00       	call   800df3 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 75 cc             	pushl  -0x34(%ebp)
  80017f:	68 3c 41 80 00       	push   $0x80413c
  800184:	e8 1e 0f 00 00       	call   8010a7 <cprintf>
  800189:	83 c4 10             	add    $0x10,%esp

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80018c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800193:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
	int numOfEmptyWSLocs = 0;
  80019a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8001a8:	eb 26                	jmp    8001d0 <_main+0x198>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  8001aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8001af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001b8:	89 d0                	mov    %edx,%eax
  8001ba:	01 c0                	add    %eax,%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	c1 e0 03             	shl    $0x3,%eax
  8001c1:	01 c8                	add    %ecx,%eax
  8001c3:	8a 40 04             	mov    0x4(%eax),%al
  8001c6:	3c 01                	cmp    $0x1,%al
  8001c8:	75 03                	jne    8001cd <_main+0x195>
			numOfEmptyWSLocs++;
  8001ca:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size; w++)
  8001cd:	ff 45 e4             	incl   -0x1c(%ebp)
  8001d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d5:	8b 50 74             	mov    0x74(%eax),%edx
  8001d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	77 cb                	ja     8001aa <_main+0x172>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e2:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8001e5:	7d 14                	jge    8001fb <_main+0x1c3>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 88 41 80 00       	push   $0x804188
  8001ef:	6a 48                	push   $0x48
  8001f1:	68 fc 40 80 00       	push   $0x8040fc
  8001f6:	e8 f8 0b 00 00       	call   800df3 <_panic>

	void* ptr_allocations[512] = {0};
  8001fb:	8d 95 b8 f7 ff ff    	lea    -0x848(%ebp),%edx
  800201:	b9 00 02 00 00       	mov    $0x200,%ecx
  800206:	b8 00 00 00 00       	mov    $0x0,%eax
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  80020f:	e8 a3 20 00 00       	call   8022b7 <sys_calculate_free_frames>
  800214:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800217:	e8 3b 21 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  80021c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	for(i = 0; i< 256;i++)
  80021f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800226:	eb 20                	jmp    800248 <_main+0x210>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800228:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80022b:	01 c0                	add    %eax,%eax
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	50                   	push   %eax
  800231:	e8 f9 1d 00 00       	call   80202f <malloc>
  800236:	83 c4 10             	add    $0x10,%esp
  800239:	89 c2                	mov    %eax,%edx
  80023b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80023e:	89 94 85 b8 f7 ff ff 	mov    %edx,-0x848(%ebp,%eax,4)
	int i;

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800245:	ff 45 dc             	incl   -0x24(%ebp)
  800248:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80024f:	7e d7                	jle    800228 <_main+0x1f0>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800251:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800257:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80025c:	75 4e                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80025e:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
  800264:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800269:	75 41                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026b:	8b 85 d8 f7 ff ff    	mov    -0x828(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800271:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800276:	75 34                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  800278:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80027e:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  800283:	75 27                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800285:	8b 85 10 fa ff ff    	mov    -0x5f0(%ebp),%eax

	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
  80028b:	3d 00 00 c0 92       	cmp    $0x92c00000,%eax
  800290:	75 1a                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  800292:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
	// randomly check the addresses of the allocation
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
  800298:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  80029d:	75 0d                	jne    8002ac <_main+0x274>
			(uint32)ptr_allocations[200] != 0x99000000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029f:	8b 85 b4 fb ff ff    	mov    -0x44c(%ebp),%eax
	if( (uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[100] != 0x8C800000 ||
			(uint32)ptr_allocations[150] != 0x92C00000 ||
			(uint32)ptr_allocations[200] != 0x99000000 ||
  8002a5:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002aa:	74 14                	je     8002c0 <_main+0x288>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	68 d8 41 80 00       	push   $0x8041d8
  8002b4:	6a 5d                	push   $0x5d
  8002b6:	68 fc 40 80 00       	push   $0x8040fc
  8002bb:	e8 33 0b 00 00       	call   800df3 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002c0:	e8 92 20 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  8002c5:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8002c8:	89 c2                	mov    %eax,%edx
  8002ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002cd:	c1 e0 09             	shl    $0x9,%eax
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	79 05                	jns    8002d9 <_main+0x2a1>
  8002d4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d9:	c1 f8 0c             	sar    $0xc,%eax
  8002dc:	39 c2                	cmp    %eax,%edx
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 16 42 80 00       	push   $0x804216
  8002e8:	6a 5f                	push   $0x5f
  8002ea:	68 fc 40 80 00       	push   $0x8040fc
  8002ef:	e8 ff 0a 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002f7:	e8 bb 1f 00 00       	call   8022b7 <sys_calculate_free_frames>
  8002fc:	29 c3                	sub    %eax,%ebx
  8002fe:	89 da                	mov    %ebx,%edx
  800300:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800303:	c1 e0 09             	shl    $0x9,%eax
  800306:	85 c0                	test   %eax,%eax
  800308:	79 05                	jns    80030f <_main+0x2d7>
  80030a:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030f:	c1 f8 16             	sar    $0x16,%eax
  800312:	39 c2                	cmp    %eax,%edx
  800314:	74 14                	je     80032a <_main+0x2f2>
  800316:	83 ec 04             	sub    $0x4,%esp
  800319:	68 33 42 80 00       	push   $0x804233
  80031e:	6a 60                	push   $0x60
  800320:	68 fc 40 80 00       	push   $0x8040fc
  800325:	e8 c9 0a 00 00       	call   800df3 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80032a:	e8 88 1f 00 00       	call   8022b7 <sys_calculate_free_frames>
  80032f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800332:	e8 20 20 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800337:	89 45 bc             	mov    %eax,-0x44(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  80033a:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	50                   	push   %eax
  800344:	e8 14 1d 00 00       	call   80205d <free>
  800349:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  80034c:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	50                   	push   %eax
  800356:	e8 02 1d 00 00       	call   80205d <free>
  80035b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035e:	8b 85 c4 f7 ff ff    	mov    -0x83c(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	50                   	push   %eax
  800368:	e8 f0 1c 00 00       	call   80205d <free>
  80036d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 3 = 6 M
  800370:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	50                   	push   %eax
  80037a:	e8 de 1c 00 00       	call   80205d <free>
  80037f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800382:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 cc 1c 00 00       	call   80205d <free>
  800391:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  800394:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	50                   	push   %eax
  80039e:	e8 ba 1c 00 00       	call   80205d <free>
  8003a3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[100]);		// Hole 4 = 10 M
  8003a6:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	50                   	push   %eax
  8003b0:	e8 a8 1c 00 00       	call   80205d <free>
  8003b5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[104]);
  8003b8:	8b 85 58 f9 ff ff    	mov    -0x6a8(%ebp),%eax
  8003be:	83 ec 0c             	sub    $0xc,%esp
  8003c1:	50                   	push   %eax
  8003c2:	e8 96 1c 00 00       	call   80205d <free>
  8003c7:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[103]);
  8003ca:	8b 85 54 f9 ff ff    	mov    -0x6ac(%ebp),%eax
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	50                   	push   %eax
  8003d4:	e8 84 1c 00 00       	call   80205d <free>
  8003d9:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[102]);
  8003dc:	8b 85 50 f9 ff ff    	mov    -0x6b0(%ebp),%eax
  8003e2:	83 ec 0c             	sub    $0xc,%esp
  8003e5:	50                   	push   %eax
  8003e6:	e8 72 1c 00 00       	call   80205d <free>
  8003eb:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[101]);
  8003ee:	8b 85 4c f9 ff ff    	mov    -0x6b4(%ebp),%eax
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	50                   	push   %eax
  8003f8:	e8 60 1c 00 00       	call   80205d <free>
  8003fd:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[200]);		// Hole 5 = 8 M
  800400:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
  800406:	83 ec 0c             	sub    $0xc,%esp
  800409:	50                   	push   %eax
  80040a:	e8 4e 1c 00 00       	call   80205d <free>
  80040f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[201]);
  800412:	8b 85 dc fa ff ff    	mov    -0x524(%ebp),%eax
  800418:	83 ec 0c             	sub    $0xc,%esp
  80041b:	50                   	push   %eax
  80041c:	e8 3c 1c 00 00       	call   80205d <free>
  800421:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[202]);
  800424:	8b 85 e0 fa ff ff    	mov    -0x520(%ebp),%eax
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	50                   	push   %eax
  80042e:	e8 2a 1c 00 00       	call   80205d <free>
  800433:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[203]);
  800436:	8b 85 e4 fa ff ff    	mov    -0x51c(%ebp),%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	50                   	push   %eax
  800440:	e8 18 1c 00 00       	call   80205d <free>
  800445:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 15*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800448:	e8 0a 1f 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  80044d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800450:	89 d1                	mov    %edx,%ecx
  800452:	29 c1                	sub    %eax,%ecx
  800454:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800464:	01 d0                	add    %edx,%eax
  800466:	01 c0                	add    %eax,%eax
  800468:	85 c0                	test   %eax,%eax
  80046a:	79 05                	jns    800471 <_main+0x439>
  80046c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800471:	c1 f8 0c             	sar    $0xc,%eax
  800474:	39 c1                	cmp    %eax,%ecx
  800476:	74 14                	je     80048c <_main+0x454>
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 44 42 80 00       	push   $0x804244
  800480:	6a 76                	push   $0x76
  800482:	68 fc 40 80 00       	push   $0x8040fc
  800487:	e8 67 09 00 00       	call   800df3 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80048c:	e8 26 1e 00 00       	call   8022b7 <sys_calculate_free_frames>
  800491:	89 c2                	mov    %eax,%edx
  800493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 80 42 80 00       	push   $0x804280
  8004a2:	6a 77                	push   $0x77
  8004a4:	68 fc 40 80 00       	push   $0x8040fc
  8004a9:	e8 45 09 00 00       	call   800df3 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8004ae:	e8 04 1e 00 00       	call   8022b7 <sys_calculate_free_frames>
  8004b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b6:	e8 9c 1e 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  8004bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
	void* tempAddress = malloc(Mega);		// Use Hole 4 -> Hole 4 = 9 M
  8004be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004c1:	83 ec 0c             	sub    $0xc,%esp
  8004c4:	50                   	push   %eax
  8004c5:	e8 65 1b 00 00       	call   80202f <malloc>
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C800000)
  8004d0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004d3:	3d 00 00 80 8c       	cmp    $0x8c800000,%eax
  8004d8:	74 14                	je     8004ee <_main+0x4b6>
		panic("Worst Fit not working correctly");
  8004da:	83 ec 04             	sub    $0x4,%esp
  8004dd:	68 c0 42 80 00       	push   $0x8042c0
  8004e2:	6a 7f                	push   $0x7f
  8004e4:	68 fc 40 80 00       	push   $0x8040fc
  8004e9:	e8 05 09 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004ee:	e8 64 1e 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  8004f3:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8004f6:	89 c2                	mov    %eax,%edx
  8004f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004fb:	85 c0                	test   %eax,%eax
  8004fd:	79 05                	jns    800504 <_main+0x4cc>
  8004ff:	05 ff 0f 00 00       	add    $0xfff,%eax
  800504:	c1 f8 0c             	sar    $0xc,%eax
  800507:	39 c2                	cmp    %eax,%edx
  800509:	74 17                	je     800522 <_main+0x4ea>
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 16 42 80 00       	push   $0x804216
  800513:	68 80 00 00 00       	push   $0x80
  800518:	68 fc 40 80 00       	push   $0x8040fc
  80051d:	e8 d1 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800522:	e8 90 1d 00 00       	call   8022b7 <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 33 42 80 00       	push   $0x804233
  800538:	68 81 00 00 00       	push   $0x81
  80053d:	68 fc 40 80 00       	push   $0x8040fc
  800542:	e8 ac 08 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800547:	ff 45 d0             	incl   -0x30(%ebp)
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d0             	pushl  -0x30(%ebp)
  800550:	68 e0 42 80 00       	push   $0x8042e0
  800555:	e8 4d 0b 00 00       	call   8010a7 <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 55 1d 00 00       	call   8022b7 <sys_calculate_free_frames>
  800562:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 ed 1d 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  80056a:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4 * Mega);			// Use Hole 4 -> Hole 4 = 5 M
  80056d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800570:	c1 e0 02             	shl    $0x2,%eax
  800573:	83 ec 0c             	sub    $0xc,%esp
  800576:	50                   	push   %eax
  800577:	e8 b3 1a 00 00       	call   80202f <malloc>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8C900000)
  800582:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800585:	3d 00 00 90 8c       	cmp    $0x8c900000,%eax
  80058a:	74 17                	je     8005a3 <_main+0x56b>
		panic("Worst Fit not working correctly");
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	68 c0 42 80 00       	push   $0x8042c0
  800594:	68 88 00 00 00       	push   $0x88
  800599:	68 fc 40 80 00       	push   $0x8040fc
  80059e:	e8 50 08 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005a3:	e8 af 1d 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  8005a8:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8005ab:	89 c2                	mov    %eax,%edx
  8005ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005b0:	c1 e0 02             	shl    $0x2,%eax
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	79 05                	jns    8005bc <_main+0x584>
  8005b7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005bc:	c1 f8 0c             	sar    $0xc,%eax
  8005bf:	39 c2                	cmp    %eax,%edx
  8005c1:	74 17                	je     8005da <_main+0x5a2>
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	68 16 42 80 00       	push   $0x804216
  8005cb:	68 89 00 00 00       	push   $0x89
  8005d0:	68 fc 40 80 00       	push   $0x8040fc
  8005d5:	e8 19 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005da:	e8 d8 1c 00 00       	call   8022b7 <sys_calculate_free_frames>
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 17                	je     8005ff <_main+0x5c7>
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 33 42 80 00       	push   $0x804233
  8005f0:	68 8a 00 00 00       	push   $0x8a
  8005f5:	68 fc 40 80 00       	push   $0x8040fc
  8005fa:	e8 f4 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005ff:	ff 45 d0             	incl   -0x30(%ebp)
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 d0             	pushl  -0x30(%ebp)
  800608:	68 e0 42 80 00       	push   $0x8042e0
  80060d:	e8 95 0a 00 00       	call   8010a7 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800615:	e8 9d 1c 00 00       	call   8022b7 <sys_calculate_free_frames>
  80061a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80061d:	e8 35 1d 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800622:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(6*Mega); 			   // Use Hole 5 -> Hole 5 = 2 M
  800625:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800628:	89 d0                	mov    %edx,%eax
  80062a:	01 c0                	add    %eax,%eax
  80062c:	01 d0                	add    %edx,%eax
  80062e:	01 c0                	add    %eax,%eax
  800630:	83 ec 0c             	sub    $0xc,%esp
  800633:	50                   	push   %eax
  800634:	e8 f6 19 00 00       	call   80202f <malloc>
  800639:	83 c4 10             	add    $0x10,%esp
  80063c:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99000000)
  80063f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800642:	3d 00 00 00 99       	cmp    $0x99000000,%eax
  800647:	74 17                	je     800660 <_main+0x628>
		panic("Worst Fit not working correctly");
  800649:	83 ec 04             	sub    $0x4,%esp
  80064c:	68 c0 42 80 00       	push   $0x8042c0
  800651:	68 91 00 00 00       	push   $0x91
  800656:	68 fc 40 80 00       	push   $0x8040fc
  80065b:	e8 93 07 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800660:	e8 f2 1c 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800665:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800668:	89 c1                	mov    %eax,%ecx
  80066a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80066d:	89 d0                	mov    %edx,%eax
  80066f:	01 c0                	add    %eax,%eax
  800671:	01 d0                	add    %edx,%eax
  800673:	01 c0                	add    %eax,%eax
  800675:	85 c0                	test   %eax,%eax
  800677:	79 05                	jns    80067e <_main+0x646>
  800679:	05 ff 0f 00 00       	add    $0xfff,%eax
  80067e:	c1 f8 0c             	sar    $0xc,%eax
  800681:	39 c1                	cmp    %eax,%ecx
  800683:	74 17                	je     80069c <_main+0x664>
  800685:	83 ec 04             	sub    $0x4,%esp
  800688:	68 16 42 80 00       	push   $0x804216
  80068d:	68 92 00 00 00       	push   $0x92
  800692:	68 fc 40 80 00       	push   $0x8040fc
  800697:	e8 57 07 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069c:	e8 16 1c 00 00       	call   8022b7 <sys_calculate_free_frames>
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	74 17                	je     8006c1 <_main+0x689>
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 33 42 80 00       	push   $0x804233
  8006b2:	68 93 00 00 00       	push   $0x93
  8006b7:	68 fc 40 80 00       	push   $0x8040fc
  8006bc:	e8 32 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006c1:	ff 45 d0             	incl   -0x30(%ebp)
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ca:	68 e0 42 80 00       	push   $0x8042e0
  8006cf:	e8 d3 09 00 00       	call   8010a7 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006d7:	e8 db 1b 00 00       	call   8022b7 <sys_calculate_free_frames>
  8006dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006df:	e8 73 1c 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  8006e4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 3 -> Hole 3 = 1 M
  8006e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006ea:	89 d0                	mov    %edx,%eax
  8006ec:	c1 e0 02             	shl    $0x2,%eax
  8006ef:	01 d0                	add    %edx,%eax
  8006f1:	83 ec 0c             	sub    $0xc,%esp
  8006f4:	50                   	push   %eax
  8006f5:	e8 35 19 00 00       	call   80202f <malloc>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x81400000)
  800700:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800703:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800708:	74 17                	je     800721 <_main+0x6e9>
		panic("Worst Fit not working correctly");
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 c0 42 80 00       	push   $0x8042c0
  800712:	68 9a 00 00 00       	push   $0x9a
  800717:	68 fc 40 80 00       	push   $0x8040fc
  80071c:	e8 d2 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800721:	e8 31 1c 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800726:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800729:	89 c1                	mov    %eax,%ecx
  80072b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80072e:	89 d0                	mov    %edx,%eax
  800730:	c1 e0 02             	shl    $0x2,%eax
  800733:	01 d0                	add    %edx,%eax
  800735:	85 c0                	test   %eax,%eax
  800737:	79 05                	jns    80073e <_main+0x706>
  800739:	05 ff 0f 00 00       	add    $0xfff,%eax
  80073e:	c1 f8 0c             	sar    $0xc,%eax
  800741:	39 c1                	cmp    %eax,%ecx
  800743:	74 17                	je     80075c <_main+0x724>
  800745:	83 ec 04             	sub    $0x4,%esp
  800748:	68 16 42 80 00       	push   $0x804216
  80074d:	68 9b 00 00 00       	push   $0x9b
  800752:	68 fc 40 80 00       	push   $0x8040fc
  800757:	e8 97 06 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80075c:	e8 56 1b 00 00       	call   8022b7 <sys_calculate_free_frames>
  800761:	89 c2                	mov    %eax,%edx
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	39 c2                	cmp    %eax,%edx
  800768:	74 17                	je     800781 <_main+0x749>
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 33 42 80 00       	push   $0x804233
  800772:	68 9c 00 00 00       	push   $0x9c
  800777:	68 fc 40 80 00       	push   $0x8040fc
  80077c:	e8 72 06 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800781:	ff 45 d0             	incl   -0x30(%ebp)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d0             	pushl  -0x30(%ebp)
  80078a:	68 e0 42 80 00       	push   $0x8042e0
  80078f:	e8 13 09 00 00       	call   8010a7 <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800797:	e8 1b 1b 00 00       	call   8022b7 <sys_calculate_free_frames>
  80079c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80079f:	e8 b3 1b 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  8007a4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  8007a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007aa:	c1 e0 02             	shl    $0x2,%eax
  8007ad:	83 ec 0c             	sub    $0xc,%esp
  8007b0:	50                   	push   %eax
  8007b1:	e8 79 18 00 00       	call   80202f <malloc>
  8007b6:	83 c4 10             	add    $0x10,%esp
  8007b9:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x8CD00000)
  8007bc:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8007bf:	3d 00 00 d0 8c       	cmp    $0x8cd00000,%eax
  8007c4:	74 17                	je     8007dd <_main+0x7a5>
		panic("Worst Fit not working correctly");
  8007c6:	83 ec 04             	sub    $0x4,%esp
  8007c9:	68 c0 42 80 00       	push   $0x8042c0
  8007ce:	68 a3 00 00 00       	push   $0xa3
  8007d3:	68 fc 40 80 00       	push   $0x8040fc
  8007d8:	e8 16 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007dd:	e8 75 1b 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  8007e2:	2b 45 bc             	sub    -0x44(%ebp),%eax
  8007e5:	89 c2                	mov    %eax,%edx
  8007e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ea:	c1 e0 02             	shl    $0x2,%eax
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	79 05                	jns    8007f6 <_main+0x7be>
  8007f1:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007f6:	c1 f8 0c             	sar    $0xc,%eax
  8007f9:	39 c2                	cmp    %eax,%edx
  8007fb:	74 17                	je     800814 <_main+0x7dc>
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	68 16 42 80 00       	push   $0x804216
  800805:	68 a4 00 00 00       	push   $0xa4
  80080a:	68 fc 40 80 00       	push   $0x8040fc
  80080f:	e8 df 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800814:	e8 9e 1a 00 00       	call   8022b7 <sys_calculate_free_frames>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 17                	je     800839 <_main+0x801>
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 33 42 80 00       	push   $0x804233
  80082a:	68 a5 00 00 00       	push   $0xa5
  80082f:	68 fc 40 80 00       	push   $0x8040fc
  800834:	e8 ba 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800839:	ff 45 d0             	incl   -0x30(%ebp)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 d0             	pushl  -0x30(%ebp)
  800842:	68 e0 42 80 00       	push   $0x8042e0
  800847:	e8 5b 08 00 00       	call   8010a7 <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80084f:	e8 63 1a 00 00       	call   8022b7 <sys_calculate_free_frames>
  800854:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800857:	e8 fb 1a 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  80085c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2 * Mega); 			// Use Hole 2 -> Hole 2 = 2 M
  80085f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800862:	01 c0                	add    %eax,%eax
  800864:	83 ec 0c             	sub    $0xc,%esp
  800867:	50                   	push   %eax
  800868:	e8 c2 17 00 00       	call   80202f <malloc>
  80086d:	83 c4 10             	add    $0x10,%esp
  800870:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80400000)
  800873:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800876:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  80087b:	74 17                	je     800894 <_main+0x85c>
		panic("Worst Fit not working correctly");
  80087d:	83 ec 04             	sub    $0x4,%esp
  800880:	68 c0 42 80 00       	push   $0x8042c0
  800885:	68 ac 00 00 00       	push   $0xac
  80088a:	68 fc 40 80 00       	push   $0x8040fc
  80088f:	e8 5f 05 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800894:	e8 be 1a 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800899:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80089c:	89 c2                	mov    %eax,%edx
  80089e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008a1:	01 c0                	add    %eax,%eax
  8008a3:	85 c0                	test   %eax,%eax
  8008a5:	79 05                	jns    8008ac <_main+0x874>
  8008a7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008ac:	c1 f8 0c             	sar    $0xc,%eax
  8008af:	39 c2                	cmp    %eax,%edx
  8008b1:	74 17                	je     8008ca <_main+0x892>
  8008b3:	83 ec 04             	sub    $0x4,%esp
  8008b6:	68 16 42 80 00       	push   $0x804216
  8008bb:	68 ad 00 00 00       	push   $0xad
  8008c0:	68 fc 40 80 00       	push   $0x8040fc
  8008c5:	e8 29 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008ca:	e8 e8 19 00 00       	call   8022b7 <sys_calculate_free_frames>
  8008cf:	89 c2                	mov    %eax,%edx
  8008d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 17                	je     8008ef <_main+0x8b7>
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 33 42 80 00       	push   $0x804233
  8008e0:	68 ae 00 00 00       	push   $0xae
  8008e5:	68 fc 40 80 00       	push   $0x8040fc
  8008ea:	e8 04 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ef:	ff 45 d0             	incl   -0x30(%ebp)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 d0             	pushl  -0x30(%ebp)
  8008f8:	68 e0 42 80 00       	push   $0x8042e0
  8008fd:	e8 a5 07 00 00       	call   8010a7 <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800905:	e8 ad 19 00 00       	call   8022b7 <sys_calculate_free_frames>
  80090a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090d:	e8 45 1a 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800912:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(1*Mega + 512*kilo);    // Use Hole 1 -> Hole 1 = 0.5 M
  800915:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800918:	c1 e0 09             	shl    $0x9,%eax
  80091b:	89 c2                	mov    %eax,%edx
  80091d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800920:	01 d0                	add    %edx,%eax
  800922:	83 ec 0c             	sub    $0xc,%esp
  800925:	50                   	push   %eax
  800926:	e8 04 17 00 00       	call   80202f <malloc>
  80092b:	83 c4 10             	add    $0x10,%esp
  80092e:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80000000)
  800931:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800934:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800939:	74 17                	je     800952 <_main+0x91a>
		panic("Worst Fit not working correctly");
  80093b:	83 ec 04             	sub    $0x4,%esp
  80093e:	68 c0 42 80 00       	push   $0x8042c0
  800943:	68 b5 00 00 00       	push   $0xb5
  800948:	68 fc 40 80 00       	push   $0x8040fc
  80094d:	e8 a1 04 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800952:	e8 00 1a 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800957:	2b 45 bc             	sub    -0x44(%ebp),%eax
  80095a:	89 c2                	mov    %eax,%edx
  80095c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80095f:	c1 e0 09             	shl    $0x9,%eax
  800962:	89 c1                	mov    %eax,%ecx
  800964:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800967:	01 c8                	add    %ecx,%eax
  800969:	85 c0                	test   %eax,%eax
  80096b:	79 05                	jns    800972 <_main+0x93a>
  80096d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800972:	c1 f8 0c             	sar    $0xc,%eax
  800975:	39 c2                	cmp    %eax,%edx
  800977:	74 17                	je     800990 <_main+0x958>
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	68 16 42 80 00       	push   $0x804216
  800981:	68 b6 00 00 00       	push   $0xb6
  800986:	68 fc 40 80 00       	push   $0x8040fc
  80098b:	e8 63 04 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800990:	e8 22 19 00 00       	call   8022b7 <sys_calculate_free_frames>
  800995:	89 c2                	mov    %eax,%edx
  800997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 17                	je     8009b5 <_main+0x97d>
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	68 33 42 80 00       	push   $0x804233
  8009a6:	68 b7 00 00 00       	push   $0xb7
  8009ab:	68 fc 40 80 00       	push   $0x8040fc
  8009b0:	e8 3e 04 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009b5:	ff 45 d0             	incl   -0x30(%ebp)
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8009be:	68 e0 42 80 00       	push   $0x8042e0
  8009c3:	e8 df 06 00 00       	call   8010a7 <cprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 e7 18 00 00       	call   8022b7 <sys_calculate_free_frames>
  8009d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 7f 19 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  8009d8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 2 -> Hole 2 = 1.5 M
  8009db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009de:	c1 e0 09             	shl    $0x9,%eax
  8009e1:	83 ec 0c             	sub    $0xc,%esp
  8009e4:	50                   	push   %eax
  8009e5:	e8 45 16 00 00       	call   80202f <malloc>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x80600000)
  8009f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009f3:	3d 00 00 60 80       	cmp    $0x80600000,%eax
  8009f8:	74 17                	je     800a11 <_main+0x9d9>
		panic("Worst Fit not working correctly");
  8009fa:	83 ec 04             	sub    $0x4,%esp
  8009fd:	68 c0 42 80 00       	push   $0x8042c0
  800a02:	68 be 00 00 00       	push   $0xbe
  800a07:	68 fc 40 80 00       	push   $0x8040fc
  800a0c:	e8 e2 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a11:	e8 41 19 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800a16:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800a19:	89 c2                	mov    %eax,%edx
  800a1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a1e:	c1 e0 09             	shl    $0x9,%eax
  800a21:	85 c0                	test   %eax,%eax
  800a23:	79 05                	jns    800a2a <_main+0x9f2>
  800a25:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a2a:	c1 f8 0c             	sar    $0xc,%eax
  800a2d:	39 c2                	cmp    %eax,%edx
  800a2f:	74 17                	je     800a48 <_main+0xa10>
  800a31:	83 ec 04             	sub    $0x4,%esp
  800a34:	68 16 42 80 00       	push   $0x804216
  800a39:	68 bf 00 00 00       	push   $0xbf
  800a3e:	68 fc 40 80 00       	push   $0x8040fc
  800a43:	e8 ab 03 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a48:	e8 6a 18 00 00       	call   8022b7 <sys_calculate_free_frames>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 17                	je     800a6d <_main+0xa35>
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 33 42 80 00       	push   $0x804233
  800a5e:	68 c0 00 00 00       	push   $0xc0
  800a63:	68 fc 40 80 00       	push   $0x8040fc
  800a68:	e8 86 03 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a6d:	ff 45 d0             	incl   -0x30(%ebp)
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 d0             	pushl  -0x30(%ebp)
  800a76:	68 e0 42 80 00       	push   $0x8042e0
  800a7b:	e8 27 06 00 00       	call   8010a7 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 2f 18 00 00       	call   8022b7 <sys_calculate_free_frames>
  800a88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 c7 18 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800a90:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(kilo); 			   // Use Hole 5 -> Hole 5 = 2 M - K
  800a93:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 90 15 00 00       	call   80202f <malloc>
  800a9f:	83 c4 10             	add    $0x10,%esp
  800aa2:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99600000)
  800aa5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800aa8:	3d 00 00 60 99       	cmp    $0x99600000,%eax
  800aad:	74 17                	je     800ac6 <_main+0xa8e>
		panic("Worst Fit not working correctly");
  800aaf:	83 ec 04             	sub    $0x4,%esp
  800ab2:	68 c0 42 80 00       	push   $0x8042c0
  800ab7:	68 c7 00 00 00       	push   $0xc7
  800abc:	68 fc 40 80 00       	push   $0x8040fc
  800ac1:	e8 2d 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800ac6:	e8 8c 18 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800acb:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800ace:	89 c2                	mov    %eax,%edx
  800ad0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ad3:	c1 e0 02             	shl    $0x2,%eax
  800ad6:	85 c0                	test   %eax,%eax
  800ad8:	79 05                	jns    800adf <_main+0xaa7>
  800ada:	05 ff 0f 00 00       	add    $0xfff,%eax
  800adf:	c1 f8 0c             	sar    $0xc,%eax
  800ae2:	39 c2                	cmp    %eax,%edx
  800ae4:	74 17                	je     800afd <_main+0xac5>
  800ae6:	83 ec 04             	sub    $0x4,%esp
  800ae9:	68 16 42 80 00       	push   $0x804216
  800aee:	68 c8 00 00 00       	push   $0xc8
  800af3:	68 fc 40 80 00       	push   $0x8040fc
  800af8:	e8 f6 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800afd:	e8 b5 17 00 00       	call   8022b7 <sys_calculate_free_frames>
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 33 42 80 00       	push   $0x804233
  800b13:	68 c9 00 00 00       	push   $0xc9
  800b18:	68 fc 40 80 00       	push   $0x8040fc
  800b1d:	e8 d1 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b22:	ff 45 d0             	incl   -0x30(%ebp)
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 d0             	pushl  -0x30(%ebp)
  800b2b:	68 e0 42 80 00       	push   $0x8042e0
  800b30:	e8 72 05 00 00       	call   8010a7 <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800b38:	e8 7a 17 00 00       	call   8022b7 <sys_calculate_free_frames>
  800b3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b40:	e8 12 18 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800b45:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(2*Mega - 4*kilo); 		// Use Hole 5 -> Hole 5 = 0
  800b48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b52:	29 d0                	sub    %edx,%eax
  800b54:	01 c0                	add    %eax,%eax
  800b56:	83 ec 0c             	sub    $0xc,%esp
  800b59:	50                   	push   %eax
  800b5a:	e8 d0 14 00 00       	call   80202f <malloc>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x99601000)
  800b65:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b68:	3d 00 10 60 99       	cmp    $0x99601000,%eax
  800b6d:	74 17                	je     800b86 <_main+0xb4e>
		panic("Worst Fit not working correctly");
  800b6f:	83 ec 04             	sub    $0x4,%esp
  800b72:	68 c0 42 80 00       	push   $0x8042c0
  800b77:	68 d0 00 00 00       	push   $0xd0
  800b7c:	68 fc 40 80 00       	push   $0x8040fc
  800b81:	e8 6d 02 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800b86:	e8 cc 17 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800b8b:	2b 45 bc             	sub    -0x44(%ebp),%eax
  800b8e:	89 c2                	mov    %eax,%edx
  800b90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b93:	01 c0                	add    %eax,%eax
  800b95:	89 c1                	mov    %eax,%ecx
  800b97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b9a:	29 c8                	sub    %ecx,%eax
  800b9c:	01 c0                	add    %eax,%eax
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	79 05                	jns    800ba7 <_main+0xb6f>
  800ba2:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ba7:	c1 f8 0c             	sar    $0xc,%eax
  800baa:	39 c2                	cmp    %eax,%edx
  800bac:	74 17                	je     800bc5 <_main+0xb8d>
  800bae:	83 ec 04             	sub    $0x4,%esp
  800bb1:	68 16 42 80 00       	push   $0x804216
  800bb6:	68 d1 00 00 00       	push   $0xd1
  800bbb:	68 fc 40 80 00       	push   $0x8040fc
  800bc0:	e8 2e 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bc5:	e8 ed 16 00 00       	call   8022b7 <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 33 42 80 00       	push   $0x804233
  800bdb:	68 d2 00 00 00       	push   $0xd2
  800be0:	68 fc 40 80 00       	push   $0x8040fc
  800be5:	e8 09 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bea:	ff 45 d0             	incl   -0x30(%ebp)
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  800bf3:	68 e0 42 80 00       	push   $0x8042e0
  800bf8:	e8 aa 04 00 00       	call   8010a7 <cprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800c00:	e8 b2 16 00 00       	call   8022b7 <sys_calculate_free_frames>
  800c05:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800c08:	e8 4a 17 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800c0d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	tempAddress = malloc(4*Mega); 		//No Suitable hole
  800c10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c13:	c1 e0 02             	shl    $0x2,%eax
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	50                   	push   %eax
  800c1a:	e8 10 14 00 00       	call   80202f <malloc>
  800c1f:	83 c4 10             	add    $0x10,%esp
  800c22:	89 45 b8             	mov    %eax,-0x48(%ebp)
	if((uint32)tempAddress != 0x0)
  800c25:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	74 17                	je     800c43 <_main+0xc0b>
		panic("Worst Fit not working correctly");
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	68 c0 42 80 00       	push   $0x8042c0
  800c34:	68 da 00 00 00       	push   $0xda
  800c39:	68 fc 40 80 00       	push   $0x8040fc
  800c3e:	e8 b0 01 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c43:	e8 0f 17 00 00       	call   802357 <sys_pf_calculate_allocated_pages>
  800c48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800c4b:	74 17                	je     800c64 <_main+0xc2c>
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	68 16 42 80 00       	push   $0x804216
  800c55:	68 db 00 00 00       	push   $0xdb
  800c5a:	68 fc 40 80 00       	push   $0x8040fc
  800c5f:	e8 8f 01 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800c64:	e8 4e 16 00 00       	call   8022b7 <sys_calculate_free_frames>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6e:	39 c2                	cmp    %eax,%edx
  800c70:	74 17                	je     800c89 <_main+0xc51>
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	68 33 42 80 00       	push   $0x804233
  800c7a:	68 dc 00 00 00       	push   $0xdc
  800c7f:	68 fc 40 80 00       	push   $0x8040fc
  800c84:	e8 6a 01 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800c89:	ff 45 d0             	incl   -0x30(%ebp)
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c92:	68 e0 42 80 00       	push   $0x8042e0
  800c97:	e8 0b 04 00 00       	call   8010a7 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	68 f4 42 80 00       	push   $0x8042f4
  800ca7:	e8 fb 03 00 00       	call   8010a7 <cprintf>
  800cac:	83 c4 10             	add    $0x10,%esp

	return;
  800caf:	90                   	nop
}
  800cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb3:	5b                   	pop    %ebx
  800cb4:	5f                   	pop    %edi
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
  800cba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800cbd:	e8 d5 18 00 00       	call   802597 <sys_getenvindex>
  800cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800cc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc8:	89 d0                	mov    %edx,%eax
  800cca:	c1 e0 03             	shl    $0x3,%eax
  800ccd:	01 d0                	add    %edx,%eax
  800ccf:	01 c0                	add    %eax,%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cda:	01 d0                	add    %edx,%eax
  800cdc:	c1 e0 04             	shl    $0x4,%eax
  800cdf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ce4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800ce9:	a1 20 50 80 00       	mov    0x805020,%eax
  800cee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	74 0f                	je     800d07 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800cf8:	a1 20 50 80 00       	mov    0x805020,%eax
  800cfd:	05 5c 05 00 00       	add    $0x55c,%eax
  800d02:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800d07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d0b:	7e 0a                	jle    800d17 <libmain+0x60>
		binaryname = argv[0];
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 08             	pushl  0x8(%ebp)
  800d20:	e8 13 f3 ff ff       	call   800038 <_main>
  800d25:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800d28:	e8 77 16 00 00       	call   8023a4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	68 48 43 80 00       	push   $0x804348
  800d35:	e8 6d 03 00 00       	call   8010a7 <cprintf>
  800d3a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800d3d:	a1 20 50 80 00       	mov    0x805020,%eax
  800d42:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800d48:	a1 20 50 80 00       	mov    0x805020,%eax
  800d4d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800d53:	83 ec 04             	sub    $0x4,%esp
  800d56:	52                   	push   %edx
  800d57:	50                   	push   %eax
  800d58:	68 70 43 80 00       	push   $0x804370
  800d5d:	e8 45 03 00 00       	call   8010a7 <cprintf>
  800d62:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800d65:	a1 20 50 80 00       	mov    0x805020,%eax
  800d6a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800d70:	a1 20 50 80 00       	mov    0x805020,%eax
  800d75:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800d7b:	a1 20 50 80 00       	mov    0x805020,%eax
  800d80:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800d86:	51                   	push   %ecx
  800d87:	52                   	push   %edx
  800d88:	50                   	push   %eax
  800d89:	68 98 43 80 00       	push   $0x804398
  800d8e:	e8 14 03 00 00       	call   8010a7 <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d96:	a1 20 50 80 00       	mov    0x805020,%eax
  800d9b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	50                   	push   %eax
  800da5:	68 f0 43 80 00       	push   $0x8043f0
  800daa:	e8 f8 02 00 00       	call   8010a7 <cprintf>
  800daf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	68 48 43 80 00       	push   $0x804348
  800dba:	e8 e8 02 00 00       	call   8010a7 <cprintf>
  800dbf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800dc2:	e8 f7 15 00 00       	call   8023be <sys_enable_interrupt>

	// exit gracefully
	exit();
  800dc7:	e8 19 00 00 00       	call   800de5 <exit>
}
  800dcc:	90                   	nop
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	6a 00                	push   $0x0
  800dda:	e8 84 17 00 00       	call   802563 <sys_destroy_env>
  800ddf:	83 c4 10             	add    $0x10,%esp
}
  800de2:	90                   	nop
  800de3:	c9                   	leave  
  800de4:	c3                   	ret    

00800de5 <exit>:

void
exit(void)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800deb:	e8 d9 17 00 00       	call   8025c9 <sys_exit_env>
}
  800df0:	90                   	nop
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800df9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfc:	83 c0 04             	add    $0x4,%eax
  800dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800e02:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e07:	85 c0                	test   %eax,%eax
  800e09:	74 16                	je     800e21 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800e0b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800e10:	83 ec 08             	sub    $0x8,%esp
  800e13:	50                   	push   %eax
  800e14:	68 04 44 80 00       	push   $0x804404
  800e19:	e8 89 02 00 00       	call   8010a7 <cprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800e21:	a1 00 50 80 00       	mov    0x805000,%eax
  800e26:	ff 75 0c             	pushl  0xc(%ebp)
  800e29:	ff 75 08             	pushl  0x8(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	68 09 44 80 00       	push   $0x804409
  800e32:	e8 70 02 00 00       	call   8010a7 <cprintf>
  800e37:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 f4             	pushl  -0xc(%ebp)
  800e43:	50                   	push   %eax
  800e44:	e8 f3 01 00 00       	call   80103c <vcprintf>
  800e49:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800e4c:	83 ec 08             	sub    $0x8,%esp
  800e4f:	6a 00                	push   $0x0
  800e51:	68 25 44 80 00       	push   $0x804425
  800e56:	e8 e1 01 00 00       	call   80103c <vcprintf>
  800e5b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800e5e:	e8 82 ff ff ff       	call   800de5 <exit>

	// should not return here
	while (1) ;
  800e63:	eb fe                	jmp    800e63 <_panic+0x70>

00800e65 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800e6b:	a1 20 50 80 00       	mov    0x805020,%eax
  800e70:	8b 50 74             	mov    0x74(%eax),%edx
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	39 c2                	cmp    %eax,%edx
  800e78:	74 14                	je     800e8e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800e7a:	83 ec 04             	sub    $0x4,%esp
  800e7d:	68 28 44 80 00       	push   $0x804428
  800e82:	6a 26                	push   $0x26
  800e84:	68 74 44 80 00       	push   $0x804474
  800e89:	e8 65 ff ff ff       	call   800df3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800e8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800e95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9c:	e9 c2 00 00 00       	jmp    800f63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ea4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	01 d0                	add    %edx,%eax
  800eb0:	8b 00                	mov    (%eax),%eax
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	75 08                	jne    800ebe <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800eb6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800eb9:	e9 a2 00 00 00       	jmp    800f60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800ebe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ec5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800ecc:	eb 69                	jmp    800f37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800ece:	a1 20 50 80 00       	mov    0x805020,%eax
  800ed3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ed9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800edc:	89 d0                	mov    %edx,%eax
  800ede:	01 c0                	add    %eax,%eax
  800ee0:	01 d0                	add    %edx,%eax
  800ee2:	c1 e0 03             	shl    $0x3,%eax
  800ee5:	01 c8                	add    %ecx,%eax
  800ee7:	8a 40 04             	mov    0x4(%eax),%al
  800eea:	84 c0                	test   %al,%al
  800eec:	75 46                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800eee:	a1 20 50 80 00       	mov    0x805020,%eax
  800ef3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ef9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800efc:	89 d0                	mov    %edx,%eax
  800efe:	01 c0                	add    %eax,%eax
  800f00:	01 d0                	add    %edx,%eax
  800f02:	c1 e0 03             	shl    $0x3,%eax
  800f05:	01 c8                	add    %ecx,%eax
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800f0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	01 c8                	add    %ecx,%eax
  800f25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800f27:	39 c2                	cmp    %eax,%edx
  800f29:	75 09                	jne    800f34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800f2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800f32:	eb 12                	jmp    800f46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f34:	ff 45 e8             	incl   -0x18(%ebp)
  800f37:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3c:	8b 50 74             	mov    0x74(%eax),%edx
  800f3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f42:	39 c2                	cmp    %eax,%edx
  800f44:	77 88                	ja     800ece <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800f46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800f4a:	75 14                	jne    800f60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800f4c:	83 ec 04             	sub    $0x4,%esp
  800f4f:	68 80 44 80 00       	push   $0x804480
  800f54:	6a 3a                	push   $0x3a
  800f56:	68 74 44 80 00       	push   $0x804474
  800f5b:	e8 93 fe ff ff       	call   800df3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800f60:	ff 45 f0             	incl   -0x10(%ebp)
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f69:	0f 8c 32 ff ff ff    	jl     800ea1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800f6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800f7d:	eb 26                	jmp    800fa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800f7f:	a1 20 50 80 00       	mov    0x805020,%eax
  800f84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800f8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f8d:	89 d0                	mov    %edx,%eax
  800f8f:	01 c0                	add    %eax,%eax
  800f91:	01 d0                	add    %edx,%eax
  800f93:	c1 e0 03             	shl    $0x3,%eax
  800f96:	01 c8                	add    %ecx,%eax
  800f98:	8a 40 04             	mov    0x4(%eax),%al
  800f9b:	3c 01                	cmp    $0x1,%al
  800f9d:	75 03                	jne    800fa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800f9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800fa2:	ff 45 e0             	incl   -0x20(%ebp)
  800fa5:	a1 20 50 80 00       	mov    0x805020,%eax
  800faa:	8b 50 74             	mov    0x74(%eax),%edx
  800fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb0:	39 c2                	cmp    %eax,%edx
  800fb2:	77 cb                	ja     800f7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800fba:	74 14                	je     800fd0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800fbc:	83 ec 04             	sub    $0x4,%esp
  800fbf:	68 d4 44 80 00       	push   $0x8044d4
  800fc4:	6a 44                	push   $0x44
  800fc6:	68 74 44 80 00       	push   $0x804474
  800fcb:	e8 23 fe ff ff       	call   800df3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800fd0:	90                   	nop
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	8b 00                	mov    (%eax),%eax
  800fde:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fe4:	89 0a                	mov    %ecx,(%edx)
  800fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe9:	88 d1                	mov    %dl,%cl
  800feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff5:	8b 00                	mov    (%eax),%eax
  800ff7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ffc:	75 2c                	jne    80102a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ffe:	a0 24 50 80 00       	mov    0x805024,%al
  801003:	0f b6 c0             	movzbl %al,%eax
  801006:	8b 55 0c             	mov    0xc(%ebp),%edx
  801009:	8b 12                	mov    (%edx),%edx
  80100b:	89 d1                	mov    %edx,%ecx
  80100d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801010:	83 c2 08             	add    $0x8,%edx
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	50                   	push   %eax
  801017:	51                   	push   %ecx
  801018:	52                   	push   %edx
  801019:	e8 d8 11 00 00       	call   8021f6 <sys_cputs>
  80101e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	8b 40 04             	mov    0x4(%eax),%eax
  801030:	8d 50 01             	lea    0x1(%eax),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	89 50 04             	mov    %edx,0x4(%eax)
}
  801039:	90                   	nop
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801045:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80104c:	00 00 00 
	b.cnt = 0;
  80104f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801056:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801059:	ff 75 0c             	pushl  0xc(%ebp)
  80105c:	ff 75 08             	pushl  0x8(%ebp)
  80105f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801065:	50                   	push   %eax
  801066:	68 d3 0f 80 00       	push   $0x800fd3
  80106b:	e8 11 02 00 00       	call   801281 <vprintfmt>
  801070:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801073:	a0 24 50 80 00       	mov    0x805024,%al
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	50                   	push   %eax
  801085:	52                   	push   %edx
  801086:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80108c:	83 c0 08             	add    $0x8,%eax
  80108f:	50                   	push   %eax
  801090:	e8 61 11 00 00       	call   8021f6 <sys_cputs>
  801095:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801098:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80109f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <cprintf>:

int cprintf(const char *fmt, ...) {
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8010ad:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8010b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	83 ec 08             	sub    $0x8,%esp
  8010c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8010c3:	50                   	push   %eax
  8010c4:	e8 73 ff ff ff       	call   80103c <vcprintf>
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8010cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8010da:	e8 c5 12 00 00       	call   8023a4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8010df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8010e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	83 ec 08             	sub    $0x8,%esp
  8010eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ee:	50                   	push   %eax
  8010ef:	e8 48 ff ff ff       	call   80103c <vcprintf>
  8010f4:	83 c4 10             	add    $0x10,%esp
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8010fa:	e8 bf 12 00 00       	call   8023be <sys_enable_interrupt>
	return cnt;
  8010ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	53                   	push   %ebx
  801108:	83 ec 14             	sub    $0x14,%esp
  80110b:	8b 45 10             	mov    0x10(%ebp),%eax
  80110e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801111:	8b 45 14             	mov    0x14(%ebp),%eax
  801114:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801117:	8b 45 18             	mov    0x18(%ebp),%eax
  80111a:	ba 00 00 00 00       	mov    $0x0,%edx
  80111f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801122:	77 55                	ja     801179 <printnum+0x75>
  801124:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801127:	72 05                	jb     80112e <printnum+0x2a>
  801129:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80112c:	77 4b                	ja     801179 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80112e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801131:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801134:	8b 45 18             	mov    0x18(%ebp),%eax
  801137:	ba 00 00 00 00       	mov    $0x0,%edx
  80113c:	52                   	push   %edx
  80113d:	50                   	push   %eax
  80113e:	ff 75 f4             	pushl  -0xc(%ebp)
  801141:	ff 75 f0             	pushl  -0x10(%ebp)
  801144:	e8 33 2d 00 00       	call   803e7c <__udivdi3>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	ff 75 20             	pushl  0x20(%ebp)
  801152:	53                   	push   %ebx
  801153:	ff 75 18             	pushl  0x18(%ebp)
  801156:	52                   	push   %edx
  801157:	50                   	push   %eax
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	ff 75 08             	pushl  0x8(%ebp)
  80115e:	e8 a1 ff ff ff       	call   801104 <printnum>
  801163:	83 c4 20             	add    $0x20,%esp
  801166:	eb 1a                	jmp    801182 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801168:	83 ec 08             	sub    $0x8,%esp
  80116b:	ff 75 0c             	pushl  0xc(%ebp)
  80116e:	ff 75 20             	pushl  0x20(%ebp)
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	ff d0                	call   *%eax
  801176:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801179:	ff 4d 1c             	decl   0x1c(%ebp)
  80117c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801180:	7f e6                	jg     801168 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801182:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801185:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801190:	53                   	push   %ebx
  801191:	51                   	push   %ecx
  801192:	52                   	push   %edx
  801193:	50                   	push   %eax
  801194:	e8 f3 2d 00 00       	call   803f8c <__umoddi3>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	05 34 47 80 00       	add    $0x804734,%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	0f be c0             	movsbl %al,%eax
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	50                   	push   %eax
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	ff d0                	call   *%eax
  8011b2:	83 c4 10             	add    $0x10,%esp
}
  8011b5:	90                   	nop
  8011b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8011be:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8011c2:	7e 1c                	jle    8011e0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8b 00                	mov    (%eax),%eax
  8011c9:	8d 50 08             	lea    0x8(%eax),%edx
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	89 10                	mov    %edx,(%eax)
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	83 e8 08             	sub    $0x8,%eax
  8011d9:	8b 50 04             	mov    0x4(%eax),%edx
  8011dc:	8b 00                	mov    (%eax),%eax
  8011de:	eb 40                	jmp    801220 <getuint+0x65>
	else if (lflag)
  8011e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e4:	74 1e                	je     801204 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	8d 50 04             	lea    0x4(%eax),%edx
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	89 10                	mov    %edx,(%eax)
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8b 00                	mov    (%eax),%eax
  8011f8:	83 e8 04             	sub    $0x4,%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801202:	eb 1c                	jmp    801220 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	8b 00                	mov    (%eax),%eax
  801209:	8d 50 04             	lea    0x4(%eax),%edx
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	89 10                	mov    %edx,(%eax)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	83 e8 04             	sub    $0x4,%eax
  801219:	8b 00                	mov    (%eax),%eax
  80121b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801220:	5d                   	pop    %ebp
  801221:	c3                   	ret    

00801222 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801225:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801229:	7e 1c                	jle    801247 <getint+0x25>
		return va_arg(*ap, long long);
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8b 00                	mov    (%eax),%eax
  801230:	8d 50 08             	lea    0x8(%eax),%edx
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	89 10                	mov    %edx,(%eax)
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8b 00                	mov    (%eax),%eax
  80123d:	83 e8 08             	sub    $0x8,%eax
  801240:	8b 50 04             	mov    0x4(%eax),%edx
  801243:	8b 00                	mov    (%eax),%eax
  801245:	eb 38                	jmp    80127f <getint+0x5d>
	else if (lflag)
  801247:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80124b:	74 1a                	je     801267 <getint+0x45>
		return va_arg(*ap, long);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 50 04             	lea    0x4(%eax),%edx
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	89 10                	mov    %edx,(%eax)
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	83 e8 04             	sub    $0x4,%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	99                   	cltd   
  801265:	eb 18                	jmp    80127f <getint+0x5d>
	else
		return va_arg(*ap, int);
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8b 00                	mov    (%eax),%eax
  80126c:	8d 50 04             	lea    0x4(%eax),%edx
  80126f:	8b 45 08             	mov    0x8(%ebp),%eax
  801272:	89 10                	mov    %edx,(%eax)
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8b 00                	mov    (%eax),%eax
  801279:	83 e8 04             	sub    $0x4,%eax
  80127c:	8b 00                	mov    (%eax),%eax
  80127e:	99                   	cltd   
}
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801289:	eb 17                	jmp    8012a2 <vprintfmt+0x21>
			if (ch == '\0')
  80128b:	85 db                	test   %ebx,%ebx
  80128d:	0f 84 af 03 00 00    	je     801642 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	53                   	push   %ebx
  80129a:	8b 45 08             	mov    0x8(%ebp),%eax
  80129d:	ff d0                	call   *%eax
  80129f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8012a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a5:	8d 50 01             	lea    0x1(%eax),%edx
  8012a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	0f b6 d8             	movzbl %al,%ebx
  8012b0:	83 fb 25             	cmp    $0x25,%ebx
  8012b3:	75 d6                	jne    80128b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8012b5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8012b9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8012c0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8012c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8012ce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	8d 50 01             	lea    0x1(%eax),%edx
  8012db:	89 55 10             	mov    %edx,0x10(%ebp)
  8012de:	8a 00                	mov    (%eax),%al
  8012e0:	0f b6 d8             	movzbl %al,%ebx
  8012e3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8012e6:	83 f8 55             	cmp    $0x55,%eax
  8012e9:	0f 87 2b 03 00 00    	ja     80161a <vprintfmt+0x399>
  8012ef:	8b 04 85 58 47 80 00 	mov    0x804758(,%eax,4),%eax
  8012f6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8012f8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8012fc:	eb d7                	jmp    8012d5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8012fe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801302:	eb d1                	jmp    8012d5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801304:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80130b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80130e:	89 d0                	mov    %edx,%eax
  801310:	c1 e0 02             	shl    $0x2,%eax
  801313:	01 d0                	add    %edx,%eax
  801315:	01 c0                	add    %eax,%eax
  801317:	01 d8                	add    %ebx,%eax
  801319:	83 e8 30             	sub    $0x30,%eax
  80131c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801327:	83 fb 2f             	cmp    $0x2f,%ebx
  80132a:	7e 3e                	jle    80136a <vprintfmt+0xe9>
  80132c:	83 fb 39             	cmp    $0x39,%ebx
  80132f:	7f 39                	jg     80136a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801331:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801334:	eb d5                	jmp    80130b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801336:	8b 45 14             	mov    0x14(%ebp),%eax
  801339:	83 c0 04             	add    $0x4,%eax
  80133c:	89 45 14             	mov    %eax,0x14(%ebp)
  80133f:	8b 45 14             	mov    0x14(%ebp),%eax
  801342:	83 e8 04             	sub    $0x4,%eax
  801345:	8b 00                	mov    (%eax),%eax
  801347:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80134a:	eb 1f                	jmp    80136b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80134c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801350:	79 83                	jns    8012d5 <vprintfmt+0x54>
				width = 0;
  801352:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801359:	e9 77 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80135e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801365:	e9 6b ff ff ff       	jmp    8012d5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80136a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80136b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80136f:	0f 89 60 ff ff ff    	jns    8012d5 <vprintfmt+0x54>
				width = precision, precision = -1;
  801375:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80137b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801382:	e9 4e ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801387:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80138a:	e9 46 ff ff ff       	jmp    8012d5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80138f:	8b 45 14             	mov    0x14(%ebp),%eax
  801392:	83 c0 04             	add    $0x4,%eax
  801395:	89 45 14             	mov    %eax,0x14(%ebp)
  801398:	8b 45 14             	mov    0x14(%ebp),%eax
  80139b:	83 e8 04             	sub    $0x4,%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	83 ec 08             	sub    $0x8,%esp
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	50                   	push   %eax
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	ff d0                	call   *%eax
  8013ac:	83 c4 10             	add    $0x10,%esp
			break;
  8013af:	e9 89 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8013b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b7:	83 c0 04             	add    $0x4,%eax
  8013ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	83 e8 04             	sub    $0x4,%eax
  8013c3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8013c5:	85 db                	test   %ebx,%ebx
  8013c7:	79 02                	jns    8013cb <vprintfmt+0x14a>
				err = -err;
  8013c9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8013cb:	83 fb 64             	cmp    $0x64,%ebx
  8013ce:	7f 0b                	jg     8013db <vprintfmt+0x15a>
  8013d0:	8b 34 9d a0 45 80 00 	mov    0x8045a0(,%ebx,4),%esi
  8013d7:	85 f6                	test   %esi,%esi
  8013d9:	75 19                	jne    8013f4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8013db:	53                   	push   %ebx
  8013dc:	68 45 47 80 00       	push   $0x804745
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	ff 75 08             	pushl  0x8(%ebp)
  8013e7:	e8 5e 02 00 00       	call   80164a <printfmt>
  8013ec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8013ef:	e9 49 02 00 00       	jmp    80163d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8013f4:	56                   	push   %esi
  8013f5:	68 4e 47 80 00       	push   $0x80474e
  8013fa:	ff 75 0c             	pushl  0xc(%ebp)
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	e8 45 02 00 00       	call   80164a <printfmt>
  801405:	83 c4 10             	add    $0x10,%esp
			break;
  801408:	e9 30 02 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80140d:	8b 45 14             	mov    0x14(%ebp),%eax
  801410:	83 c0 04             	add    $0x4,%eax
  801413:	89 45 14             	mov    %eax,0x14(%ebp)
  801416:	8b 45 14             	mov    0x14(%ebp),%eax
  801419:	83 e8 04             	sub    $0x4,%eax
  80141c:	8b 30                	mov    (%eax),%esi
  80141e:	85 f6                	test   %esi,%esi
  801420:	75 05                	jne    801427 <vprintfmt+0x1a6>
				p = "(null)";
  801422:	be 51 47 80 00       	mov    $0x804751,%esi
			if (width > 0 && padc != '-')
  801427:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80142b:	7e 6d                	jle    80149a <vprintfmt+0x219>
  80142d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801431:	74 67                	je     80149a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	83 ec 08             	sub    $0x8,%esp
  801439:	50                   	push   %eax
  80143a:	56                   	push   %esi
  80143b:	e8 0c 03 00 00       	call   80174c <strnlen>
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801446:	eb 16                	jmp    80145e <vprintfmt+0x1dd>
					putch(padc, putdat);
  801448:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80144c:	83 ec 08             	sub    $0x8,%esp
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	50                   	push   %eax
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	ff d0                	call   *%eax
  801458:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80145b:	ff 4d e4             	decl   -0x1c(%ebp)
  80145e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801462:	7f e4                	jg     801448 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801464:	eb 34                	jmp    80149a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801466:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80146a:	74 1c                	je     801488 <vprintfmt+0x207>
  80146c:	83 fb 1f             	cmp    $0x1f,%ebx
  80146f:	7e 05                	jle    801476 <vprintfmt+0x1f5>
  801471:	83 fb 7e             	cmp    $0x7e,%ebx
  801474:	7e 12                	jle    801488 <vprintfmt+0x207>
					putch('?', putdat);
  801476:	83 ec 08             	sub    $0x8,%esp
  801479:	ff 75 0c             	pushl  0xc(%ebp)
  80147c:	6a 3f                	push   $0x3f
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	ff d0                	call   *%eax
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	eb 0f                	jmp    801497 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801488:	83 ec 08             	sub    $0x8,%esp
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	53                   	push   %ebx
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	ff d0                	call   *%eax
  801494:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801497:	ff 4d e4             	decl   -0x1c(%ebp)
  80149a:	89 f0                	mov    %esi,%eax
  80149c:	8d 70 01             	lea    0x1(%eax),%esi
  80149f:	8a 00                	mov    (%eax),%al
  8014a1:	0f be d8             	movsbl %al,%ebx
  8014a4:	85 db                	test   %ebx,%ebx
  8014a6:	74 24                	je     8014cc <vprintfmt+0x24b>
  8014a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014ac:	78 b8                	js     801466 <vprintfmt+0x1e5>
  8014ae:	ff 4d e0             	decl   -0x20(%ebp)
  8014b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014b5:	79 af                	jns    801466 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014b7:	eb 13                	jmp    8014cc <vprintfmt+0x24b>
				putch(' ', putdat);
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	ff 75 0c             	pushl  0xc(%ebp)
  8014bf:	6a 20                	push   $0x20
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	ff d0                	call   *%eax
  8014c6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8014c9:	ff 4d e4             	decl   -0x1c(%ebp)
  8014cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014d0:	7f e7                	jg     8014b9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8014d2:	e9 66 01 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8014d7:	83 ec 08             	sub    $0x8,%esp
  8014da:	ff 75 e8             	pushl  -0x18(%ebp)
  8014dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8014e0:	50                   	push   %eax
  8014e1:	e8 3c fd ff ff       	call   801222 <getint>
  8014e6:	83 c4 10             	add    $0x10,%esp
  8014e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f5:	85 d2                	test   %edx,%edx
  8014f7:	79 23                	jns    80151c <vprintfmt+0x29b>
				putch('-', putdat);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	ff 75 0c             	pushl  0xc(%ebp)
  8014ff:	6a 2d                	push   $0x2d
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	ff d0                	call   *%eax
  801506:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150f:	f7 d8                	neg    %eax
  801511:	83 d2 00             	adc    $0x0,%edx
  801514:	f7 da                	neg    %edx
  801516:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801519:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80151c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801523:	e9 bc 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	ff 75 e8             	pushl  -0x18(%ebp)
  80152e:	8d 45 14             	lea    0x14(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	e8 84 fc ff ff       	call   8011bb <getuint>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80153d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801540:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801547:	e9 98 00 00 00       	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80154c:	83 ec 08             	sub    $0x8,%esp
  80154f:	ff 75 0c             	pushl  0xc(%ebp)
  801552:	6a 58                	push   $0x58
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	ff d0                	call   *%eax
  801559:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80155c:	83 ec 08             	sub    $0x8,%esp
  80155f:	ff 75 0c             	pushl  0xc(%ebp)
  801562:	6a 58                	push   $0x58
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	ff d0                	call   *%eax
  801569:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	6a 58                	push   $0x58
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	ff d0                	call   *%eax
  801579:	83 c4 10             	add    $0x10,%esp
			break;
  80157c:	e9 bc 00 00 00       	jmp    80163d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	ff 75 0c             	pushl  0xc(%ebp)
  801587:	6a 30                	push   $0x30
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	ff d0                	call   *%eax
  80158e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	ff 75 0c             	pushl  0xc(%ebp)
  801597:	6a 78                	push   $0x78
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	ff d0                	call   *%eax
  80159e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8015a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a4:	83 c0 04             	add    $0x4,%eax
  8015a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	83 e8 04             	sub    $0x4,%eax
  8015b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8015b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8015bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8015c3:	eb 1f                	jmp    8015e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8015c5:	83 ec 08             	sub    $0x8,%esp
  8015c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8015cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8015ce:	50                   	push   %eax
  8015cf:	e8 e7 fb ff ff       	call   8011bb <getuint>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8015dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8015e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8015e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015eb:	83 ec 04             	sub    $0x4,%esp
  8015ee:	52                   	push   %edx
  8015ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015f2:	50                   	push   %eax
  8015f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f9:	ff 75 0c             	pushl  0xc(%ebp)
  8015fc:	ff 75 08             	pushl  0x8(%ebp)
  8015ff:	e8 00 fb ff ff       	call   801104 <printnum>
  801604:	83 c4 20             	add    $0x20,%esp
			break;
  801607:	eb 34                	jmp    80163d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801609:	83 ec 08             	sub    $0x8,%esp
  80160c:	ff 75 0c             	pushl  0xc(%ebp)
  80160f:	53                   	push   %ebx
  801610:	8b 45 08             	mov    0x8(%ebp),%eax
  801613:	ff d0                	call   *%eax
  801615:	83 c4 10             	add    $0x10,%esp
			break;
  801618:	eb 23                	jmp    80163d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	6a 25                	push   $0x25
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	ff d0                	call   *%eax
  801627:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80162a:	ff 4d 10             	decl   0x10(%ebp)
  80162d:	eb 03                	jmp    801632 <vprintfmt+0x3b1>
  80162f:	ff 4d 10             	decl   0x10(%ebp)
  801632:	8b 45 10             	mov    0x10(%ebp),%eax
  801635:	48                   	dec    %eax
  801636:	8a 00                	mov    (%eax),%al
  801638:	3c 25                	cmp    $0x25,%al
  80163a:	75 f3                	jne    80162f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80163c:	90                   	nop
		}
	}
  80163d:	e9 47 fc ff ff       	jmp    801289 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801642:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801643:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801646:	5b                   	pop    %ebx
  801647:	5e                   	pop    %esi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    

0080164a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801650:	8d 45 10             	lea    0x10(%ebp),%eax
  801653:	83 c0 04             	add    $0x4,%eax
  801656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801659:	8b 45 10             	mov    0x10(%ebp),%eax
  80165c:	ff 75 f4             	pushl  -0xc(%ebp)
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	ff 75 08             	pushl  0x8(%ebp)
  801666:	e8 16 fc ff ff       	call   801281 <vprintfmt>
  80166b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80166e:	90                   	nop
  80166f:	c9                   	leave  
  801670:	c3                   	ret    

00801671 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801671:	55                   	push   %ebp
  801672:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801674:	8b 45 0c             	mov    0xc(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	8d 50 01             	lea    0x1(%eax),%edx
  80167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801680:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801683:	8b 45 0c             	mov    0xc(%ebp),%eax
  801686:	8b 10                	mov    (%eax),%edx
  801688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168b:	8b 40 04             	mov    0x4(%eax),%eax
  80168e:	39 c2                	cmp    %eax,%edx
  801690:	73 12                	jae    8016a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	8b 00                	mov    (%eax),%eax
  801697:	8d 48 01             	lea    0x1(%eax),%ecx
  80169a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169d:	89 0a                	mov    %ecx,(%edx)
  80169f:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a2:	88 10                	mov    %dl,(%eax)
}
  8016a4:	90                   	nop
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	01 d0                	add    %edx,%eax
  8016be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8016c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016cc:	74 06                	je     8016d4 <vsnprintf+0x2d>
  8016ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d2:	7f 07                	jg     8016db <vsnprintf+0x34>
		return -E_INVAL;
  8016d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d9:	eb 20                	jmp    8016fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8016db:	ff 75 14             	pushl  0x14(%ebp)
  8016de:	ff 75 10             	pushl  0x10(%ebp)
  8016e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8016e4:	50                   	push   %eax
  8016e5:	68 71 16 80 00       	push   $0x801671
  8016ea:	e8 92 fb ff ff       	call   801281 <vprintfmt>
  8016ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8016f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8016f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801703:	8d 45 10             	lea    0x10(%ebp),%eax
  801706:	83 c0 04             	add    $0x4,%eax
  801709:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80170c:	8b 45 10             	mov    0x10(%ebp),%eax
  80170f:	ff 75 f4             	pushl  -0xc(%ebp)
  801712:	50                   	push   %eax
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	ff 75 08             	pushl  0x8(%ebp)
  801719:	e8 89 ff ff ff       	call   8016a7 <vsnprintf>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801724:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80172f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801736:	eb 06                	jmp    80173e <strlen+0x15>
		n++;
  801738:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80173b:	ff 45 08             	incl   0x8(%ebp)
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	84 c0                	test   %al,%al
  801745:	75 f1                	jne    801738 <strlen+0xf>
		n++;
	return n;
  801747:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801759:	eb 09                	jmp    801764 <strnlen+0x18>
		n++;
  80175b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80175e:	ff 45 08             	incl   0x8(%ebp)
  801761:	ff 4d 0c             	decl   0xc(%ebp)
  801764:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801768:	74 09                	je     801773 <strnlen+0x27>
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8a 00                	mov    (%eax),%al
  80176f:	84 c0                	test   %al,%al
  801771:	75 e8                	jne    80175b <strnlen+0xf>
		n++;
	return n;
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801784:	90                   	nop
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	8d 50 01             	lea    0x1(%eax),%edx
  80178b:	89 55 08             	mov    %edx,0x8(%ebp)
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8d 4a 01             	lea    0x1(%edx),%ecx
  801794:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801797:	8a 12                	mov    (%edx),%dl
  801799:	88 10                	mov    %dl,(%eax)
  80179b:	8a 00                	mov    (%eax),%al
  80179d:	84 c0                	test   %al,%al
  80179f:	75 e4                	jne    801785 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8017a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8017b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017b9:	eb 1f                	jmp    8017da <strncpy+0x34>
		*dst++ = *src;
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8d 50 01             	lea    0x1(%eax),%edx
  8017c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8017c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c7:	8a 12                	mov    (%edx),%dl
  8017c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8017cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	84 c0                	test   %al,%al
  8017d2:	74 03                	je     8017d7 <strncpy+0x31>
			src++;
  8017d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8017d7:	ff 45 fc             	incl   -0x4(%ebp)
  8017da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017e0:	72 d9                	jb     8017bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8017e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8017f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017f7:	74 30                	je     801829 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8017f9:	eb 16                	jmp    801811 <strlcpy+0x2a>
			*dst++ = *src++;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8d 50 01             	lea    0x1(%eax),%edx
  801801:	89 55 08             	mov    %edx,0x8(%ebp)
  801804:	8b 55 0c             	mov    0xc(%ebp),%edx
  801807:	8d 4a 01             	lea    0x1(%edx),%ecx
  80180a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80180d:	8a 12                	mov    (%edx),%dl
  80180f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801811:	ff 4d 10             	decl   0x10(%ebp)
  801814:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801818:	74 09                	je     801823 <strlcpy+0x3c>
  80181a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181d:	8a 00                	mov    (%eax),%al
  80181f:	84 c0                	test   %al,%al
  801821:	75 d8                	jne    8017fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801829:	8b 55 08             	mov    0x8(%ebp),%edx
  80182c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182f:	29 c2                	sub    %eax,%edx
  801831:	89 d0                	mov    %edx,%eax
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801838:	eb 06                	jmp    801840 <strcmp+0xb>
		p++, q++;
  80183a:	ff 45 08             	incl   0x8(%ebp)
  80183d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	8a 00                	mov    (%eax),%al
  801845:	84 c0                	test   %al,%al
  801847:	74 0e                	je     801857 <strcmp+0x22>
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	8a 10                	mov    (%eax),%dl
  80184e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801851:	8a 00                	mov    (%eax),%al
  801853:	38 c2                	cmp    %al,%dl
  801855:	74 e3                	je     80183a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	0f b6 d0             	movzbl %al,%edx
  80185f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	0f b6 c0             	movzbl %al,%eax
  801867:	29 c2                	sub    %eax,%edx
  801869:	89 d0                	mov    %edx,%eax
}
  80186b:	5d                   	pop    %ebp
  80186c:	c3                   	ret    

0080186d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801870:	eb 09                	jmp    80187b <strncmp+0xe>
		n--, p++, q++;
  801872:	ff 4d 10             	decl   0x10(%ebp)
  801875:	ff 45 08             	incl   0x8(%ebp)
  801878:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80187b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80187f:	74 17                	je     801898 <strncmp+0x2b>
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	84 c0                	test   %al,%al
  801888:	74 0e                	je     801898 <strncmp+0x2b>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 10                	mov    (%eax),%dl
  80188f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801892:	8a 00                	mov    (%eax),%al
  801894:	38 c2                	cmp    %al,%dl
  801896:	74 da                	je     801872 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801898:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189c:	75 07                	jne    8018a5 <strncmp+0x38>
		return 0;
  80189e:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a3:	eb 14                	jmp    8018b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	8a 00                	mov    (%eax),%al
  8018aa:	0f b6 d0             	movzbl %al,%edx
  8018ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b0:	8a 00                	mov    (%eax),%al
  8018b2:	0f b6 c0             	movzbl %al,%eax
  8018b5:	29 c2                	sub    %eax,%edx
  8018b7:	89 d0                	mov    %edx,%eax
}
  8018b9:	5d                   	pop    %ebp
  8018ba:	c3                   	ret    

008018bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018c7:	eb 12                	jmp    8018db <strchr+0x20>
		if (*s == c)
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8a 00                	mov    (%eax),%al
  8018ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8018d1:	75 05                	jne    8018d8 <strchr+0x1d>
			return (char *) s;
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	eb 11                	jmp    8018e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8018d8:	ff 45 08             	incl   0x8(%ebp)
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8a 00                	mov    (%eax),%al
  8018e0:	84 c0                	test   %al,%al
  8018e2:	75 e5                	jne    8018c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8018f7:	eb 0d                	jmp    801906 <strfind+0x1b>
		if (*s == c)
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	8a 00                	mov    (%eax),%al
  8018fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801901:	74 0e                	je     801911 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801903:	ff 45 08             	incl   0x8(%ebp)
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	8a 00                	mov    (%eax),%al
  80190b:	84 c0                	test   %al,%al
  80190d:	75 ea                	jne    8018f9 <strfind+0xe>
  80190f:	eb 01                	jmp    801912 <strfind+0x27>
		if (*s == c)
			break;
  801911:	90                   	nop
	return (char *) s;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801923:	8b 45 10             	mov    0x10(%ebp),%eax
  801926:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801929:	eb 0e                	jmp    801939 <memset+0x22>
		*p++ = c;
  80192b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80192e:	8d 50 01             	lea    0x1(%eax),%edx
  801931:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801934:	8b 55 0c             	mov    0xc(%ebp),%edx
  801937:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801939:	ff 4d f8             	decl   -0x8(%ebp)
  80193c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801940:	79 e9                	jns    80192b <memset+0x14>
		*p++ = c;

	return v;
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80194d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801950:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801959:	eb 16                	jmp    801971 <memcpy+0x2a>
		*d++ = *s++;
  80195b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195e:	8d 50 01             	lea    0x1(%eax),%edx
  801961:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801964:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801967:	8d 4a 01             	lea    0x1(%edx),%ecx
  80196a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80196d:	8a 12                	mov    (%edx),%dl
  80196f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	8d 50 ff             	lea    -0x1(%eax),%edx
  801977:	89 55 10             	mov    %edx,0x10(%ebp)
  80197a:	85 c0                	test   %eax,%eax
  80197c:	75 dd                	jne    80195b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801998:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80199b:	73 50                	jae    8019ed <memmove+0x6a>
  80199d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a3:	01 d0                	add    %edx,%eax
  8019a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8019a8:	76 43                	jbe    8019ed <memmove+0x6a>
		s += n;
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8019b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8019b6:	eb 10                	jmp    8019c8 <memmove+0x45>
			*--d = *--s;
  8019b8:	ff 4d f8             	decl   -0x8(%ebp)
  8019bb:	ff 4d fc             	decl   -0x4(%ebp)
  8019be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c1:	8a 10                	mov    (%eax),%dl
  8019c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8019c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8019d1:	85 c0                	test   %eax,%eax
  8019d3:	75 e3                	jne    8019b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019d5:	eb 23                	jmp    8019fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8019d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019da:	8d 50 01             	lea    0x1(%eax),%edx
  8019dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8019e9:	8a 12                	mov    (%edx),%dl
  8019eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8019ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8019f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	75 dd                	jne    8019d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801a11:	eb 2a                	jmp    801a3d <memcmp+0x3e>
		if (*s1 != *s2)
  801a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a16:	8a 10                	mov    (%eax),%dl
  801a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1b:	8a 00                	mov    (%eax),%al
  801a1d:	38 c2                	cmp    %al,%dl
  801a1f:	74 16                	je     801a37 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a24:	8a 00                	mov    (%eax),%al
  801a26:	0f b6 d0             	movzbl %al,%edx
  801a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	0f b6 c0             	movzbl %al,%eax
  801a31:	29 c2                	sub    %eax,%edx
  801a33:	89 d0                	mov    %edx,%eax
  801a35:	eb 18                	jmp    801a4f <memcmp+0x50>
		s1++, s2++;
  801a37:	ff 45 fc             	incl   -0x4(%ebp)
  801a3a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a40:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a43:	89 55 10             	mov    %edx,0x10(%ebp)
  801a46:	85 c0                	test   %eax,%eax
  801a48:	75 c9                	jne    801a13 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801a4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801a57:	8b 55 08             	mov    0x8(%ebp),%edx
  801a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5d:	01 d0                	add    %edx,%eax
  801a5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801a62:	eb 15                	jmp    801a79 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	0f b6 d0             	movzbl %al,%edx
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	0f b6 c0             	movzbl %al,%eax
  801a72:	39 c2                	cmp    %eax,%edx
  801a74:	74 0d                	je     801a83 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801a76:	ff 45 08             	incl   0x8(%ebp)
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801a7f:	72 e3                	jb     801a64 <memfind+0x13>
  801a81:	eb 01                	jmp    801a84 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801a83:	90                   	nop
	return (void *) s;
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801a8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801a96:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a9d:	eb 03                	jmp    801aa2 <strtol+0x19>
		s++;
  801a9f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 20                	cmp    $0x20,%al
  801aa9:	74 f4                	je     801a9f <strtol+0x16>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 09                	cmp    $0x9,%al
  801ab2:	74 eb                	je     801a9f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	3c 2b                	cmp    $0x2b,%al
  801abb:	75 05                	jne    801ac2 <strtol+0x39>
		s++;
  801abd:	ff 45 08             	incl   0x8(%ebp)
  801ac0:	eb 13                	jmp    801ad5 <strtol+0x4c>
	else if (*s == '-')
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	8a 00                	mov    (%eax),%al
  801ac7:	3c 2d                	cmp    $0x2d,%al
  801ac9:	75 0a                	jne    801ad5 <strtol+0x4c>
		s++, neg = 1;
  801acb:	ff 45 08             	incl   0x8(%ebp)
  801ace:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ad5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad9:	74 06                	je     801ae1 <strtol+0x58>
  801adb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801adf:	75 20                	jne    801b01 <strtol+0x78>
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	8a 00                	mov    (%eax),%al
  801ae6:	3c 30                	cmp    $0x30,%al
  801ae8:	75 17                	jne    801b01 <strtol+0x78>
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	40                   	inc    %eax
  801aee:	8a 00                	mov    (%eax),%al
  801af0:	3c 78                	cmp    $0x78,%al
  801af2:	75 0d                	jne    801b01 <strtol+0x78>
		s += 2, base = 16;
  801af4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801af8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801aff:	eb 28                	jmp    801b29 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801b01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b05:	75 15                	jne    801b1c <strtol+0x93>
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	8a 00                	mov    (%eax),%al
  801b0c:	3c 30                	cmp    $0x30,%al
  801b0e:	75 0c                	jne    801b1c <strtol+0x93>
		s++, base = 8;
  801b10:	ff 45 08             	incl   0x8(%ebp)
  801b13:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801b1a:	eb 0d                	jmp    801b29 <strtol+0xa0>
	else if (base == 0)
  801b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b20:	75 07                	jne    801b29 <strtol+0xa0>
		base = 10;
  801b22:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	8a 00                	mov    (%eax),%al
  801b2e:	3c 2f                	cmp    $0x2f,%al
  801b30:	7e 19                	jle    801b4b <strtol+0xc2>
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	8a 00                	mov    (%eax),%al
  801b37:	3c 39                	cmp    $0x39,%al
  801b39:	7f 10                	jg     801b4b <strtol+0xc2>
			dig = *s - '0';
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	8a 00                	mov    (%eax),%al
  801b40:	0f be c0             	movsbl %al,%eax
  801b43:	83 e8 30             	sub    $0x30,%eax
  801b46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b49:	eb 42                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	8a 00                	mov    (%eax),%al
  801b50:	3c 60                	cmp    $0x60,%al
  801b52:	7e 19                	jle    801b6d <strtol+0xe4>
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	8a 00                	mov    (%eax),%al
  801b59:	3c 7a                	cmp    $0x7a,%al
  801b5b:	7f 10                	jg     801b6d <strtol+0xe4>
			dig = *s - 'a' + 10;
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	8a 00                	mov    (%eax),%al
  801b62:	0f be c0             	movsbl %al,%eax
  801b65:	83 e8 57             	sub    $0x57,%eax
  801b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b6b:	eb 20                	jmp    801b8d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	8a 00                	mov    (%eax),%al
  801b72:	3c 40                	cmp    $0x40,%al
  801b74:	7e 39                	jle    801baf <strtol+0x126>
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	8a 00                	mov    (%eax),%al
  801b7b:	3c 5a                	cmp    $0x5a,%al
  801b7d:	7f 30                	jg     801baf <strtol+0x126>
			dig = *s - 'A' + 10;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	8a 00                	mov    (%eax),%al
  801b84:	0f be c0             	movsbl %al,%eax
  801b87:	83 e8 37             	sub    $0x37,%eax
  801b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  801b93:	7d 19                	jge    801bae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801b95:	ff 45 08             	incl   0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b9f:	89 c2                	mov    %eax,%edx
  801ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba4:	01 d0                	add    %edx,%eax
  801ba6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ba9:	e9 7b ff ff ff       	jmp    801b29 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801bae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bb3:	74 08                	je     801bbd <strtol+0x134>
		*endptr = (char *) s;
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  801bbb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801bbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801bc1:	74 07                	je     801bca <strtol+0x141>
  801bc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc6:	f7 d8                	neg    %eax
  801bc8:	eb 03                	jmp    801bcd <strtol+0x144>
  801bca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <ltostr>:

void
ltostr(long value, char *str)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801bd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801bdc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801be3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be7:	79 13                	jns    801bfc <ltostr+0x2d>
	{
		neg = 1;
  801be9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801bf6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801bf9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801c04:	99                   	cltd   
  801c05:	f7 f9                	idiv   %ecx
  801c07:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801c0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c0d:	8d 50 01             	lea    0x1(%eax),%edx
  801c10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c13:	89 c2                	mov    %eax,%edx
  801c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c18:	01 d0                	add    %edx,%eax
  801c1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801c1d:	83 c2 30             	add    $0x30,%edx
  801c20:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801c22:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c25:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c2a:	f7 e9                	imul   %ecx
  801c2c:	c1 fa 02             	sar    $0x2,%edx
  801c2f:	89 c8                	mov    %ecx,%eax
  801c31:	c1 f8 1f             	sar    $0x1f,%eax
  801c34:	29 c2                	sub    %eax,%edx
  801c36:	89 d0                	mov    %edx,%eax
  801c38:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c3e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801c43:	f7 e9                	imul   %ecx
  801c45:	c1 fa 02             	sar    $0x2,%edx
  801c48:	89 c8                	mov    %ecx,%eax
  801c4a:	c1 f8 1f             	sar    $0x1f,%eax
  801c4d:	29 c2                	sub    %eax,%edx
  801c4f:	89 d0                	mov    %edx,%eax
  801c51:	c1 e0 02             	shl    $0x2,%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	01 c0                	add    %eax,%eax
  801c58:	29 c1                	sub    %eax,%ecx
  801c5a:	89 ca                	mov    %ecx,%edx
  801c5c:	85 d2                	test   %edx,%edx
  801c5e:	75 9c                	jne    801bfc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801c60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	48                   	dec    %eax
  801c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801c6e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c72:	74 3d                	je     801cb1 <ltostr+0xe2>
		start = 1 ;
  801c74:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801c7b:	eb 34                	jmp    801cb1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c83:	01 d0                	add    %edx,%eax
  801c85:	8a 00                	mov    (%eax),%al
  801c87:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c90:	01 c2                	add    %eax,%edx
  801c92:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	01 c8                	add    %ecx,%eax
  801c9a:	8a 00                	mov    (%eax),%al
  801c9c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca4:	01 c2                	add    %eax,%edx
  801ca6:	8a 45 eb             	mov    -0x15(%ebp),%al
  801ca9:	88 02                	mov    %al,(%edx)
		start++ ;
  801cab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801cae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801cb7:	7c c4                	jl     801c7d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801cb9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	01 d0                	add    %edx,%eax
  801cc1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801cc4:	90                   	nop
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	e8 54 fa ff ff       	call   801729 <strlen>
  801cd5:	83 c4 04             	add    $0x4,%esp
  801cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	e8 46 fa ff ff       	call   801729 <strlen>
  801ce3:	83 c4 04             	add    $0x4,%esp
  801ce6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801ce9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801cf0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801cf7:	eb 17                	jmp    801d10 <strcconcat+0x49>
		final[s] = str1[s] ;
  801cf9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cff:	01 c2                	add    %eax,%edx
  801d01:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	01 c8                	add    %ecx,%eax
  801d09:	8a 00                	mov    (%eax),%al
  801d0b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801d0d:	ff 45 fc             	incl   -0x4(%ebp)
  801d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d13:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d16:	7c e1                	jl     801cf9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801d18:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801d1f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801d26:	eb 1f                	jmp    801d47 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801d28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d2b:	8d 50 01             	lea    0x1(%eax),%edx
  801d2e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801d31:	89 c2                	mov    %eax,%edx
  801d33:	8b 45 10             	mov    0x10(%ebp),%eax
  801d36:	01 c2                	add    %eax,%edx
  801d38:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	01 c8                	add    %ecx,%eax
  801d40:	8a 00                	mov    (%eax),%al
  801d42:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801d44:	ff 45 f8             	incl   -0x8(%ebp)
  801d47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d4a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d4d:	7c d9                	jl     801d28 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801d4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d52:	8b 45 10             	mov    0x10(%ebp),%eax
  801d55:	01 d0                	add    %edx,%eax
  801d57:	c6 00 00             	movb   $0x0,(%eax)
}
  801d5a:	90                   	nop
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801d60:	8b 45 14             	mov    0x14(%ebp),%eax
  801d63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801d69:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d75:	8b 45 10             	mov    0x10(%ebp),%eax
  801d78:	01 d0                	add    %edx,%eax
  801d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d80:	eb 0c                	jmp    801d8e <strsplit+0x31>
			*string++ = 0;
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	8d 50 01             	lea    0x1(%eax),%edx
  801d88:	89 55 08             	mov    %edx,0x8(%ebp)
  801d8b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	8a 00                	mov    (%eax),%al
  801d93:	84 c0                	test   %al,%al
  801d95:	74 18                	je     801daf <strsplit+0x52>
  801d97:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9a:	8a 00                	mov    (%eax),%al
  801d9c:	0f be c0             	movsbl %al,%eax
  801d9f:	50                   	push   %eax
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	e8 13 fb ff ff       	call   8018bb <strchr>
  801da8:	83 c4 08             	add    $0x8,%esp
  801dab:	85 c0                	test   %eax,%eax
  801dad:	75 d3                	jne    801d82 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801daf:	8b 45 08             	mov    0x8(%ebp),%eax
  801db2:	8a 00                	mov    (%eax),%al
  801db4:	84 c0                	test   %al,%al
  801db6:	74 5a                	je     801e12 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801db8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbb:	8b 00                	mov    (%eax),%eax
  801dbd:	83 f8 0f             	cmp    $0xf,%eax
  801dc0:	75 07                	jne    801dc9 <strsplit+0x6c>
		{
			return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc7:	eb 66                	jmp    801e2f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801dc9:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcc:	8b 00                	mov    (%eax),%eax
  801dce:	8d 48 01             	lea    0x1(%eax),%ecx
  801dd1:	8b 55 14             	mov    0x14(%ebp),%edx
  801dd4:	89 0a                	mov    %ecx,(%edx)
  801dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  801de0:	01 c2                	add    %eax,%edx
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801de7:	eb 03                	jmp    801dec <strsplit+0x8f>
			string++;
  801de9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	8a 00                	mov    (%eax),%al
  801df1:	84 c0                	test   %al,%al
  801df3:	74 8b                	je     801d80 <strsplit+0x23>
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	8a 00                	mov    (%eax),%al
  801dfa:	0f be c0             	movsbl %al,%eax
  801dfd:	50                   	push   %eax
  801dfe:	ff 75 0c             	pushl  0xc(%ebp)
  801e01:	e8 b5 fa ff ff       	call   8018bb <strchr>
  801e06:	83 c4 08             	add    $0x8,%esp
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	74 dc                	je     801de9 <strsplit+0x8c>
			string++;
	}
  801e0d:	e9 6e ff ff ff       	jmp    801d80 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801e12:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801e13:	8b 45 14             	mov    0x14(%ebp),%eax
  801e16:	8b 00                	mov    (%eax),%eax
  801e18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e22:	01 d0                	add    %edx,%eax
  801e24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801e37:	a1 04 50 80 00       	mov    0x805004,%eax
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	74 1f                	je     801e5f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801e40:	e8 1d 00 00 00       	call   801e62 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	68 b0 48 80 00       	push   $0x8048b0
  801e4d:	e8 55 f2 ff ff       	call   8010a7 <cprintf>
  801e52:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801e55:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801e5c:	00 00 00 
	}
}
  801e5f:	90                   	nop
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801e68:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801e6f:	00 00 00 
  801e72:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801e79:	00 00 00 
  801e7c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801e83:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801e86:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801e8d:	00 00 00 
  801e90:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801e97:	00 00 00 
  801e9a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801ea1:	00 00 00 
	uint32 arr_size = 0;
  801ea4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801eab:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801eba:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ebf:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801ec4:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801ecb:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801ece:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ed5:	a1 20 51 80 00       	mov    0x805120,%eax
  801eda:	c1 e0 04             	shl    $0x4,%eax
  801edd:	89 c2                	mov    %eax,%edx
  801edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee2:	01 d0                	add    %edx,%eax
  801ee4:	48                   	dec    %eax
  801ee5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801eeb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef0:	f7 75 ec             	divl   -0x14(%ebp)
  801ef3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ef6:	29 d0                	sub    %edx,%eax
  801ef8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801efb:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801f02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f05:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f0a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f0f:	83 ec 04             	sub    $0x4,%esp
  801f12:	6a 06                	push   $0x6
  801f14:	ff 75 f4             	pushl  -0xc(%ebp)
  801f17:	50                   	push   %eax
  801f18:	e8 1d 04 00 00       	call   80233a <sys_allocate_chunk>
  801f1d:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801f20:	a1 20 51 80 00       	mov    0x805120,%eax
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	50                   	push   %eax
  801f29:	e8 92 0a 00 00       	call   8029c0 <initialize_MemBlocksList>
  801f2e:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801f31:	a1 48 51 80 00       	mov    0x805148,%eax
  801f36:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801f39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f3c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f46:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801f4d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f51:	75 14                	jne    801f67 <initialize_dyn_block_system+0x105>
  801f53:	83 ec 04             	sub    $0x4,%esp
  801f56:	68 d5 48 80 00       	push   $0x8048d5
  801f5b:	6a 33                	push   $0x33
  801f5d:	68 f3 48 80 00       	push   $0x8048f3
  801f62:	e8 8c ee ff ff       	call   800df3 <_panic>
  801f67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f6a:	8b 00                	mov    (%eax),%eax
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	74 10                	je     801f80 <initialize_dyn_block_system+0x11e>
  801f70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f73:	8b 00                	mov    (%eax),%eax
  801f75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f78:	8b 52 04             	mov    0x4(%edx),%edx
  801f7b:	89 50 04             	mov    %edx,0x4(%eax)
  801f7e:	eb 0b                	jmp    801f8b <initialize_dyn_block_system+0x129>
  801f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f83:	8b 40 04             	mov    0x4(%eax),%eax
  801f86:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f8e:	8b 40 04             	mov    0x4(%eax),%eax
  801f91:	85 c0                	test   %eax,%eax
  801f93:	74 0f                	je     801fa4 <initialize_dyn_block_system+0x142>
  801f95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f98:	8b 40 04             	mov    0x4(%eax),%eax
  801f9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f9e:	8b 12                	mov    (%edx),%edx
  801fa0:	89 10                	mov    %edx,(%eax)
  801fa2:	eb 0a                	jmp    801fae <initialize_dyn_block_system+0x14c>
  801fa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fa7:	8b 00                	mov    (%eax),%eax
  801fa9:	a3 48 51 80 00       	mov    %eax,0x805148
  801fae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc1:	a1 54 51 80 00       	mov    0x805154,%eax
  801fc6:	48                   	dec    %eax
  801fc7:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801fcc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801fd0:	75 14                	jne    801fe6 <initialize_dyn_block_system+0x184>
  801fd2:	83 ec 04             	sub    $0x4,%esp
  801fd5:	68 00 49 80 00       	push   $0x804900
  801fda:	6a 34                	push   $0x34
  801fdc:	68 f3 48 80 00       	push   $0x8048f3
  801fe1:	e8 0d ee ff ff       	call   800df3 <_panic>
  801fe6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801fec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fef:	89 10                	mov    %edx,(%eax)
  801ff1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ff4:	8b 00                	mov    (%eax),%eax
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	74 0d                	je     802007 <initialize_dyn_block_system+0x1a5>
  801ffa:	a1 38 51 80 00       	mov    0x805138,%eax
  801fff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802002:	89 50 04             	mov    %edx,0x4(%eax)
  802005:	eb 08                	jmp    80200f <initialize_dyn_block_system+0x1ad>
  802007:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80200a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80200f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802012:	a3 38 51 80 00       	mov    %eax,0x805138
  802017:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80201a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802021:	a1 44 51 80 00       	mov    0x805144,%eax
  802026:	40                   	inc    %eax
  802027:	a3 44 51 80 00       	mov    %eax,0x805144
}
  80202c:	90                   	nop
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802035:	e8 f7 fd ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  80203a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80203e:	75 07                	jne    802047 <malloc+0x18>
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
  802045:	eb 14                	jmp    80205b <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  802047:	83 ec 04             	sub    $0x4,%esp
  80204a:	68 24 49 80 00       	push   $0x804924
  80204f:	6a 46                	push   $0x46
  802051:	68 f3 48 80 00       	push   $0x8048f3
  802056:	e8 98 ed ff ff       	call   800df3 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80205b:	c9                   	leave  
  80205c:	c3                   	ret    

0080205d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  802063:	83 ec 04             	sub    $0x4,%esp
  802066:	68 4c 49 80 00       	push   $0x80494c
  80206b:	6a 61                	push   $0x61
  80206d:	68 f3 48 80 00       	push   $0x8048f3
  802072:	e8 7c ed ff ff       	call   800df3 <_panic>

00802077 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 38             	sub    $0x38,%esp
  80207d:	8b 45 10             	mov    0x10(%ebp),%eax
  802080:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802083:	e8 a9 fd ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  802088:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80208c:	75 07                	jne    802095 <smalloc+0x1e>
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	eb 7c                	jmp    802111 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802095:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80209c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a2:	01 d0                	add    %edx,%eax
  8020a4:	48                   	dec    %eax
  8020a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8020b0:	f7 75 f0             	divl   -0x10(%ebp)
  8020b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b6:	29 d0                	sub    %edx,%eax
  8020b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8020bb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8020c2:	e8 41 06 00 00       	call   802708 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	74 11                	je     8020dc <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8020cb:	83 ec 0c             	sub    $0xc,%esp
  8020ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8020d1:	e8 ac 0c 00 00       	call   802d82 <alloc_block_FF>
  8020d6:	83 c4 10             	add    $0x10,%esp
  8020d9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8020dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e0:	74 2a                	je     80210c <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 40 08             	mov    0x8(%eax),%eax
  8020e8:	89 c2                	mov    %eax,%edx
  8020ea:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8020ee:	52                   	push   %edx
  8020ef:	50                   	push   %eax
  8020f0:	ff 75 0c             	pushl  0xc(%ebp)
  8020f3:	ff 75 08             	pushl  0x8(%ebp)
  8020f6:	e8 92 03 00 00       	call   80248d <sys_createSharedObject>
  8020fb:	83 c4 10             	add    $0x10,%esp
  8020fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  802101:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802105:	74 05                	je     80210c <smalloc+0x95>
			return (void*)virtual_address;
  802107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80210a:	eb 05                	jmp    802111 <smalloc+0x9a>
	}
	return NULL;
  80210c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802119:	e8 13 fd ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80211e:	83 ec 04             	sub    $0x4,%esp
  802121:	68 70 49 80 00       	push   $0x804970
  802126:	68 a2 00 00 00       	push   $0xa2
  80212b:	68 f3 48 80 00       	push   $0x8048f3
  802130:	e8 be ec ff ff       	call   800df3 <_panic>

00802135 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80213b:	e8 f1 fc ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802140:	83 ec 04             	sub    $0x4,%esp
  802143:	68 94 49 80 00       	push   $0x804994
  802148:	68 e6 00 00 00       	push   $0xe6
  80214d:	68 f3 48 80 00       	push   $0x8048f3
  802152:	e8 9c ec ff ff       	call   800df3 <_panic>

00802157 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80215d:	83 ec 04             	sub    $0x4,%esp
  802160:	68 bc 49 80 00       	push   $0x8049bc
  802165:	68 fa 00 00 00       	push   $0xfa
  80216a:	68 f3 48 80 00       	push   $0x8048f3
  80216f:	e8 7f ec ff ff       	call   800df3 <_panic>

00802174 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	68 e0 49 80 00       	push   $0x8049e0
  802182:	68 05 01 00 00       	push   $0x105
  802187:	68 f3 48 80 00       	push   $0x8048f3
  80218c:	e8 62 ec ff ff       	call   800df3 <_panic>

00802191 <shrink>:

}
void shrink(uint32 newSize)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802197:	83 ec 04             	sub    $0x4,%esp
  80219a:	68 e0 49 80 00       	push   $0x8049e0
  80219f:	68 0a 01 00 00       	push   $0x10a
  8021a4:	68 f3 48 80 00       	push   $0x8048f3
  8021a9:	e8 45 ec ff ff       	call   800df3 <_panic>

008021ae <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021b4:	83 ec 04             	sub    $0x4,%esp
  8021b7:	68 e0 49 80 00       	push   $0x8049e0
  8021bc:	68 0f 01 00 00       	push   $0x10f
  8021c1:	68 f3 48 80 00       	push   $0x8048f3
  8021c6:	e8 28 ec ff ff       	call   800df3 <_panic>

008021cb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	57                   	push   %edi
  8021cf:	56                   	push   %esi
  8021d0:	53                   	push   %ebx
  8021d1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021e0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021e3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021e6:	cd 30                	int    $0x30
  8021e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021ee:	83 c4 10             	add    $0x10,%esp
  8021f1:	5b                   	pop    %ebx
  8021f2:	5e                   	pop    %esi
  8021f3:	5f                   	pop    %edi
  8021f4:	5d                   	pop    %ebp
  8021f5:	c3                   	ret    

008021f6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 04             	sub    $0x4,%esp
  8021fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802202:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	52                   	push   %edx
  80220e:	ff 75 0c             	pushl  0xc(%ebp)
  802211:	50                   	push   %eax
  802212:	6a 00                	push   $0x0
  802214:	e8 b2 ff ff ff       	call   8021cb <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
}
  80221c:	90                   	nop
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <sys_cgetc>:

int
sys_cgetc(void)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 01                	push   $0x1
  80222e:	e8 98 ff ff ff       	call   8021cb <syscall>
  802233:	83 c4 18             	add    $0x18,%esp
}
  802236:	c9                   	leave  
  802237:	c3                   	ret    

00802238 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802238:	55                   	push   %ebp
  802239:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80223b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	52                   	push   %edx
  802248:	50                   	push   %eax
  802249:	6a 05                	push   $0x5
  80224b:	e8 7b ff ff ff       	call   8021cb <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	56                   	push   %esi
  802259:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80225a:	8b 75 18             	mov    0x18(%ebp),%esi
  80225d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802260:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802263:	8b 55 0c             	mov    0xc(%ebp),%edx
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	56                   	push   %esi
  80226a:	53                   	push   %ebx
  80226b:	51                   	push   %ecx
  80226c:	52                   	push   %edx
  80226d:	50                   	push   %eax
  80226e:	6a 06                	push   $0x6
  802270:	e8 56 ff ff ff       	call   8021cb <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
}
  802278:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80227b:	5b                   	pop    %ebx
  80227c:	5e                   	pop    %esi
  80227d:	5d                   	pop    %ebp
  80227e:	c3                   	ret    

0080227f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80227f:	55                   	push   %ebp
  802280:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802282:	8b 55 0c             	mov    0xc(%ebp),%edx
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	52                   	push   %edx
  80228f:	50                   	push   %eax
  802290:	6a 07                	push   $0x7
  802292:	e8 34 ff ff ff       	call   8021cb <syscall>
  802297:	83 c4 18             	add    $0x18,%esp
}
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	ff 75 0c             	pushl  0xc(%ebp)
  8022a8:	ff 75 08             	pushl  0x8(%ebp)
  8022ab:	6a 08                	push   $0x8
  8022ad:	e8 19 ff ff ff       	call   8021cb <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 09                	push   $0x9
  8022c6:	e8 00 ff ff ff       	call   8021cb <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 0a                	push   $0xa
  8022df:	e8 e7 fe ff ff       	call   8021cb <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 0b                	push   $0xb
  8022f8:	e8 ce fe ff ff       	call   8021cb <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	ff 75 0c             	pushl  0xc(%ebp)
  80230e:	ff 75 08             	pushl  0x8(%ebp)
  802311:	6a 0f                	push   $0xf
  802313:	e8 b3 fe ff ff       	call   8021cb <syscall>
  802318:	83 c4 18             	add    $0x18,%esp
	return;
  80231b:	90                   	nop
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	ff 75 0c             	pushl  0xc(%ebp)
  80232a:	ff 75 08             	pushl  0x8(%ebp)
  80232d:	6a 10                	push   $0x10
  80232f:	e8 97 fe ff ff       	call   8021cb <syscall>
  802334:	83 c4 18             	add    $0x18,%esp
	return ;
  802337:	90                   	nop
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	ff 75 10             	pushl  0x10(%ebp)
  802344:	ff 75 0c             	pushl  0xc(%ebp)
  802347:	ff 75 08             	pushl  0x8(%ebp)
  80234a:	6a 11                	push   $0x11
  80234c:	e8 7a fe ff ff       	call   8021cb <syscall>
  802351:	83 c4 18             	add    $0x18,%esp
	return ;
  802354:	90                   	nop
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 0c                	push   $0xc
  802366:	e8 60 fe ff ff       	call   8021cb <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	ff 75 08             	pushl  0x8(%ebp)
  80237e:	6a 0d                	push   $0xd
  802380:	e8 46 fe ff ff       	call   8021cb <syscall>
  802385:	83 c4 18             	add    $0x18,%esp
}
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 0e                	push   $0xe
  802399:	e8 2d fe ff ff       	call   8021cb <syscall>
  80239e:	83 c4 18             	add    $0x18,%esp
}
  8023a1:	90                   	nop
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 13                	push   $0x13
  8023b3:	e8 13 fe ff ff       	call   8021cb <syscall>
  8023b8:	83 c4 18             	add    $0x18,%esp
}
  8023bb:	90                   	nop
  8023bc:	c9                   	leave  
  8023bd:	c3                   	ret    

008023be <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 14                	push   $0x14
  8023cd:	e8 f9 fd ff ff       	call   8021cb <syscall>
  8023d2:	83 c4 18             	add    $0x18,%esp
}
  8023d5:	90                   	nop
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <sys_cputc>:


void
sys_cputc(const char c)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	83 ec 04             	sub    $0x4,%esp
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	50                   	push   %eax
  8023f1:	6a 15                	push   $0x15
  8023f3:	e8 d3 fd ff ff       	call   8021cb <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
}
  8023fb:	90                   	nop
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 16                	push   $0x16
  80240d:	e8 b9 fd ff ff       	call   8021cb <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
}
  802415:	90                   	nop
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	ff 75 0c             	pushl  0xc(%ebp)
  802427:	50                   	push   %eax
  802428:	6a 17                	push   $0x17
  80242a:	e8 9c fd ff ff       	call   8021cb <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
}
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802437:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	52                   	push   %edx
  802444:	50                   	push   %eax
  802445:	6a 1a                	push   $0x1a
  802447:	e8 7f fd ff ff       	call   8021cb <syscall>
  80244c:	83 c4 18             	add    $0x18,%esp
}
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802454:	8b 55 0c             	mov    0xc(%ebp),%edx
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	52                   	push   %edx
  802461:	50                   	push   %eax
  802462:	6a 18                	push   $0x18
  802464:	e8 62 fd ff ff       	call   8021cb <syscall>
  802469:	83 c4 18             	add    $0x18,%esp
}
  80246c:	90                   	nop
  80246d:	c9                   	leave  
  80246e:	c3                   	ret    

0080246f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802472:	8b 55 0c             	mov    0xc(%ebp),%edx
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	52                   	push   %edx
  80247f:	50                   	push   %eax
  802480:	6a 19                	push   $0x19
  802482:	e8 44 fd ff ff       	call   8021cb <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
}
  80248a:	90                   	nop
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	8b 45 10             	mov    0x10(%ebp),%eax
  802496:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802499:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80249c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	6a 00                	push   $0x0
  8024a5:	51                   	push   %ecx
  8024a6:	52                   	push   %edx
  8024a7:	ff 75 0c             	pushl  0xc(%ebp)
  8024aa:	50                   	push   %eax
  8024ab:	6a 1b                	push   $0x1b
  8024ad:	e8 19 fd ff ff       	call   8021cb <syscall>
  8024b2:	83 c4 18             	add    $0x18,%esp
}
  8024b5:	c9                   	leave  
  8024b6:	c3                   	ret    

008024b7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	52                   	push   %edx
  8024c7:	50                   	push   %eax
  8024c8:	6a 1c                	push   $0x1c
  8024ca:	e8 fc fc ff ff       	call   8021cb <syscall>
  8024cf:	83 c4 18             	add    $0x18,%esp
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8024d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	51                   	push   %ecx
  8024e5:	52                   	push   %edx
  8024e6:	50                   	push   %eax
  8024e7:	6a 1d                	push   $0x1d
  8024e9:	e8 dd fc ff ff       	call   8021cb <syscall>
  8024ee:	83 c4 18             	add    $0x18,%esp
}
  8024f1:	c9                   	leave  
  8024f2:	c3                   	ret    

008024f3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8024f3:	55                   	push   %ebp
  8024f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8024f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	52                   	push   %edx
  802503:	50                   	push   %eax
  802504:	6a 1e                	push   $0x1e
  802506:	e8 c0 fc ff ff       	call   8021cb <syscall>
  80250b:	83 c4 18             	add    $0x18,%esp
}
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 1f                	push   $0x1f
  80251f:	e8 a7 fc ff ff       	call   8021cb <syscall>
  802524:	83 c4 18             	add    $0x18,%esp
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80252c:	8b 45 08             	mov    0x8(%ebp),%eax
  80252f:	6a 00                	push   $0x0
  802531:	ff 75 14             	pushl  0x14(%ebp)
  802534:	ff 75 10             	pushl  0x10(%ebp)
  802537:	ff 75 0c             	pushl  0xc(%ebp)
  80253a:	50                   	push   %eax
  80253b:	6a 20                	push   $0x20
  80253d:	e8 89 fc ff ff       	call   8021cb <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	50                   	push   %eax
  802556:	6a 21                	push   $0x21
  802558:	e8 6e fc ff ff       	call   8021cb <syscall>
  80255d:	83 c4 18             	add    $0x18,%esp
}
  802560:	90                   	nop
  802561:	c9                   	leave  
  802562:	c3                   	ret    

00802563 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802563:	55                   	push   %ebp
  802564:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802566:	8b 45 08             	mov    0x8(%ebp),%eax
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	50                   	push   %eax
  802572:	6a 22                	push   $0x22
  802574:	e8 52 fc ff ff       	call   8021cb <syscall>
  802579:	83 c4 18             	add    $0x18,%esp
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	6a 00                	push   $0x0
  802589:	6a 00                	push   $0x0
  80258b:	6a 02                	push   $0x2
  80258d:	e8 39 fc ff ff       	call   8021cb <syscall>
  802592:	83 c4 18             	add    $0x18,%esp
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 03                	push   $0x3
  8025a6:	e8 20 fc ff ff       	call   8021cb <syscall>
  8025ab:	83 c4 18             	add    $0x18,%esp
}
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 04                	push   $0x4
  8025bf:	e8 07 fc ff ff       	call   8021cb <syscall>
  8025c4:	83 c4 18             	add    $0x18,%esp
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <sys_exit_env>:


void sys_exit_env(void)
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025cc:	6a 00                	push   $0x0
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 23                	push   $0x23
  8025d8:	e8 ee fb ff ff       	call   8021cb <syscall>
  8025dd:	83 c4 18             	add    $0x18,%esp
}
  8025e0:	90                   	nop
  8025e1:	c9                   	leave  
  8025e2:	c3                   	ret    

008025e3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025e9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025ec:	8d 50 04             	lea    0x4(%eax),%edx
  8025ef:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	52                   	push   %edx
  8025f9:	50                   	push   %eax
  8025fa:	6a 24                	push   $0x24
  8025fc:	e8 ca fb ff ff       	call   8021cb <syscall>
  802601:	83 c4 18             	add    $0x18,%esp
	return result;
  802604:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802607:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80260a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80260d:	89 01                	mov    %eax,(%ecx)
  80260f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802612:	8b 45 08             	mov    0x8(%ebp),%eax
  802615:	c9                   	leave  
  802616:	c2 04 00             	ret    $0x4

00802619 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802619:	55                   	push   %ebp
  80261a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	ff 75 10             	pushl  0x10(%ebp)
  802623:	ff 75 0c             	pushl  0xc(%ebp)
  802626:	ff 75 08             	pushl  0x8(%ebp)
  802629:	6a 12                	push   $0x12
  80262b:	e8 9b fb ff ff       	call   8021cb <syscall>
  802630:	83 c4 18             	add    $0x18,%esp
	return ;
  802633:	90                   	nop
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <sys_rcr2>:
uint32 sys_rcr2()
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 00                	push   $0x0
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	6a 25                	push   $0x25
  802645:	e8 81 fb ff ff       	call   8021cb <syscall>
  80264a:	83 c4 18             	add    $0x18,%esp
}
  80264d:	c9                   	leave  
  80264e:	c3                   	ret    

0080264f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80264f:	55                   	push   %ebp
  802650:	89 e5                	mov    %esp,%ebp
  802652:	83 ec 04             	sub    $0x4,%esp
  802655:	8b 45 08             	mov    0x8(%ebp),%eax
  802658:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80265b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 00                	push   $0x0
  802667:	50                   	push   %eax
  802668:	6a 26                	push   $0x26
  80266a:	e8 5c fb ff ff       	call   8021cb <syscall>
  80266f:	83 c4 18             	add    $0x18,%esp
	return ;
  802672:	90                   	nop
}
  802673:	c9                   	leave  
  802674:	c3                   	ret    

00802675 <rsttst>:
void rsttst()
{
  802675:	55                   	push   %ebp
  802676:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 28                	push   $0x28
  802684:	e8 42 fb ff ff       	call   8021cb <syscall>
  802689:	83 c4 18             	add    $0x18,%esp
	return ;
  80268c:	90                   	nop
}
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
  802692:	83 ec 04             	sub    $0x4,%esp
  802695:	8b 45 14             	mov    0x14(%ebp),%eax
  802698:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80269b:	8b 55 18             	mov    0x18(%ebp),%edx
  80269e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026a2:	52                   	push   %edx
  8026a3:	50                   	push   %eax
  8026a4:	ff 75 10             	pushl  0x10(%ebp)
  8026a7:	ff 75 0c             	pushl  0xc(%ebp)
  8026aa:	ff 75 08             	pushl  0x8(%ebp)
  8026ad:	6a 27                	push   $0x27
  8026af:	e8 17 fb ff ff       	call   8021cb <syscall>
  8026b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b7:	90                   	nop
}
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

008026ba <chktst>:
void chktst(uint32 n)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	ff 75 08             	pushl  0x8(%ebp)
  8026c8:	6a 29                	push   $0x29
  8026ca:	e8 fc fa ff ff       	call   8021cb <syscall>
  8026cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d2:	90                   	nop
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <inctst>:

void inctst()
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 00                	push   $0x0
  8026e2:	6a 2a                	push   $0x2a
  8026e4:	e8 e2 fa ff ff       	call   8021cb <syscall>
  8026e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ec:	90                   	nop
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <gettst>:
uint32 gettst()
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 2b                	push   $0x2b
  8026fe:	e8 c8 fa ff ff       	call   8021cb <syscall>
  802703:	83 c4 18             	add    $0x18,%esp
}
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 2c                	push   $0x2c
  80271a:	e8 ac fa ff ff       	call   8021cb <syscall>
  80271f:	83 c4 18             	add    $0x18,%esp
  802722:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802725:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802729:	75 07                	jne    802732 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80272b:	b8 01 00 00 00       	mov    $0x1,%eax
  802730:	eb 05                	jmp    802737 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802732:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802737:	c9                   	leave  
  802738:	c3                   	ret    

00802739 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
  80273c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 00                	push   $0x0
  802747:	6a 00                	push   $0x0
  802749:	6a 2c                	push   $0x2c
  80274b:	e8 7b fa ff ff       	call   8021cb <syscall>
  802750:	83 c4 18             	add    $0x18,%esp
  802753:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802756:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80275a:	75 07                	jne    802763 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80275c:	b8 01 00 00 00       	mov    $0x1,%eax
  802761:	eb 05                	jmp    802768 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 2c                	push   $0x2c
  80277c:	e8 4a fa ff ff       	call   8021cb <syscall>
  802781:	83 c4 18             	add    $0x18,%esp
  802784:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802787:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80278b:	75 07                	jne    802794 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80278d:	b8 01 00 00 00       	mov    $0x1,%eax
  802792:	eb 05                	jmp    802799 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802794:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802799:	c9                   	leave  
  80279a:	c3                   	ret    

0080279b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80279b:	55                   	push   %ebp
  80279c:	89 e5                	mov    %esp,%ebp
  80279e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	6a 00                	push   $0x0
  8027a9:	6a 00                	push   $0x0
  8027ab:	6a 2c                	push   $0x2c
  8027ad:	e8 19 fa ff ff       	call   8021cb <syscall>
  8027b2:	83 c4 18             	add    $0x18,%esp
  8027b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027b8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027bc:	75 07                	jne    8027c5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027be:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c3:	eb 05                	jmp    8027ca <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ca:	c9                   	leave  
  8027cb:	c3                   	ret    

008027cc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	ff 75 08             	pushl  0x8(%ebp)
  8027da:	6a 2d                	push   $0x2d
  8027dc:	e8 ea f9 ff ff       	call   8021cb <syscall>
  8027e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8027e4:	90                   	nop
}
  8027e5:	c9                   	leave  
  8027e6:	c3                   	ret    

008027e7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027e7:	55                   	push   %ebp
  8027e8:	89 e5                	mov    %esp,%ebp
  8027ea:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027eb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	6a 00                	push   $0x0
  8027f9:	53                   	push   %ebx
  8027fa:	51                   	push   %ecx
  8027fb:	52                   	push   %edx
  8027fc:	50                   	push   %eax
  8027fd:	6a 2e                	push   $0x2e
  8027ff:	e8 c7 f9 ff ff       	call   8021cb <syscall>
  802804:	83 c4 18             	add    $0x18,%esp
}
  802807:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80280f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 00                	push   $0x0
  80281b:	52                   	push   %edx
  80281c:	50                   	push   %eax
  80281d:	6a 2f                	push   $0x2f
  80281f:	e8 a7 f9 ff ff       	call   8021cb <syscall>
  802824:	83 c4 18             	add    $0x18,%esp
}
  802827:	c9                   	leave  
  802828:	c3                   	ret    

00802829 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802829:	55                   	push   %ebp
  80282a:	89 e5                	mov    %esp,%ebp
  80282c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80282f:	83 ec 0c             	sub    $0xc,%esp
  802832:	68 f0 49 80 00       	push   $0x8049f0
  802837:	e8 6b e8 ff ff       	call   8010a7 <cprintf>
  80283c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80283f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802846:	83 ec 0c             	sub    $0xc,%esp
  802849:	68 1c 4a 80 00       	push   $0x804a1c
  80284e:	e8 54 e8 ff ff       	call   8010a7 <cprintf>
  802853:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802856:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80285a:	a1 38 51 80 00       	mov    0x805138,%eax
  80285f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802862:	eb 56                	jmp    8028ba <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802864:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802868:	74 1c                	je     802886 <print_mem_block_lists+0x5d>
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 50 08             	mov    0x8(%eax),%edx
  802870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802873:	8b 48 08             	mov    0x8(%eax),%ecx
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	8b 40 0c             	mov    0xc(%eax),%eax
  80287c:	01 c8                	add    %ecx,%eax
  80287e:	39 c2                	cmp    %eax,%edx
  802880:	73 04                	jae    802886 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802882:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 50 08             	mov    0x8(%eax),%edx
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 0c             	mov    0xc(%eax),%eax
  802892:	01 c2                	add    %eax,%edx
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 40 08             	mov    0x8(%eax),%eax
  80289a:	83 ec 04             	sub    $0x4,%esp
  80289d:	52                   	push   %edx
  80289e:	50                   	push   %eax
  80289f:	68 31 4a 80 00       	push   $0x804a31
  8028a4:	e8 fe e7 ff ff       	call   8010a7 <cprintf>
  8028a9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028b2:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028be:	74 07                	je     8028c7 <print_mem_block_lists+0x9e>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	eb 05                	jmp    8028cc <print_mem_block_lists+0xa3>
  8028c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cc:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	75 8a                	jne    802864 <print_mem_block_lists+0x3b>
  8028da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028de:	75 84                	jne    802864 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8028e0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028e4:	75 10                	jne    8028f6 <print_mem_block_lists+0xcd>
  8028e6:	83 ec 0c             	sub    $0xc,%esp
  8028e9:	68 40 4a 80 00       	push   $0x804a40
  8028ee:	e8 b4 e7 ff ff       	call   8010a7 <cprintf>
  8028f3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8028f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8028fd:	83 ec 0c             	sub    $0xc,%esp
  802900:	68 64 4a 80 00       	push   $0x804a64
  802905:	e8 9d e7 ff ff       	call   8010a7 <cprintf>
  80290a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80290d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802911:	a1 40 50 80 00       	mov    0x805040,%eax
  802916:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802919:	eb 56                	jmp    802971 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80291b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80291f:	74 1c                	je     80293d <print_mem_block_lists+0x114>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 50 08             	mov    0x8(%eax),%edx
  802927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292a:	8b 48 08             	mov    0x8(%eax),%ecx
  80292d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802930:	8b 40 0c             	mov    0xc(%eax),%eax
  802933:	01 c8                	add    %ecx,%eax
  802935:	39 c2                	cmp    %eax,%edx
  802937:	73 04                	jae    80293d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802939:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	8b 50 08             	mov    0x8(%eax),%edx
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 40 0c             	mov    0xc(%eax),%eax
  802949:	01 c2                	add    %eax,%edx
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	8b 40 08             	mov    0x8(%eax),%eax
  802951:	83 ec 04             	sub    $0x4,%esp
  802954:	52                   	push   %edx
  802955:	50                   	push   %eax
  802956:	68 31 4a 80 00       	push   $0x804a31
  80295b:	e8 47 e7 ff ff       	call   8010a7 <cprintf>
  802960:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802969:	a1 48 50 80 00       	mov    0x805048,%eax
  80296e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802971:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802975:	74 07                	je     80297e <print_mem_block_lists+0x155>
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 00                	mov    (%eax),%eax
  80297c:	eb 05                	jmp    802983 <print_mem_block_lists+0x15a>
  80297e:	b8 00 00 00 00       	mov    $0x0,%eax
  802983:	a3 48 50 80 00       	mov    %eax,0x805048
  802988:	a1 48 50 80 00       	mov    0x805048,%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	75 8a                	jne    80291b <print_mem_block_lists+0xf2>
  802991:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802995:	75 84                	jne    80291b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802997:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80299b:	75 10                	jne    8029ad <print_mem_block_lists+0x184>
  80299d:	83 ec 0c             	sub    $0xc,%esp
  8029a0:	68 7c 4a 80 00       	push   $0x804a7c
  8029a5:	e8 fd e6 ff ff       	call   8010a7 <cprintf>
  8029aa:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029ad:	83 ec 0c             	sub    $0xc,%esp
  8029b0:	68 f0 49 80 00       	push   $0x8049f0
  8029b5:	e8 ed e6 ff ff       	call   8010a7 <cprintf>
  8029ba:	83 c4 10             	add    $0x10,%esp

}
  8029bd:	90                   	nop
  8029be:	c9                   	leave  
  8029bf:	c3                   	ret    

008029c0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8029c0:	55                   	push   %ebp
  8029c1:	89 e5                	mov    %esp,%ebp
  8029c3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8029c6:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8029cd:	00 00 00 
  8029d0:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8029d7:	00 00 00 
  8029da:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8029e1:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8029e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029eb:	e9 9e 00 00 00       	jmp    802a8e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8029f0:	a1 50 50 80 00       	mov    0x805050,%eax
  8029f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f8:	c1 e2 04             	shl    $0x4,%edx
  8029fb:	01 d0                	add    %edx,%eax
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	75 14                	jne    802a15 <initialize_MemBlocksList+0x55>
  802a01:	83 ec 04             	sub    $0x4,%esp
  802a04:	68 a4 4a 80 00       	push   $0x804aa4
  802a09:	6a 46                	push   $0x46
  802a0b:	68 c7 4a 80 00       	push   $0x804ac7
  802a10:	e8 de e3 ff ff       	call   800df3 <_panic>
  802a15:	a1 50 50 80 00       	mov    0x805050,%eax
  802a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1d:	c1 e2 04             	shl    $0x4,%edx
  802a20:	01 d0                	add    %edx,%eax
  802a22:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a28:	89 10                	mov    %edx,(%eax)
  802a2a:	8b 00                	mov    (%eax),%eax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	74 18                	je     802a48 <initialize_MemBlocksList+0x88>
  802a30:	a1 48 51 80 00       	mov    0x805148,%eax
  802a35:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a3b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a3e:	c1 e1 04             	shl    $0x4,%ecx
  802a41:	01 ca                	add    %ecx,%edx
  802a43:	89 50 04             	mov    %edx,0x4(%eax)
  802a46:	eb 12                	jmp    802a5a <initialize_MemBlocksList+0x9a>
  802a48:	a1 50 50 80 00       	mov    0x805050,%eax
  802a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a50:	c1 e2 04             	shl    $0x4,%edx
  802a53:	01 d0                	add    %edx,%eax
  802a55:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a5a:	a1 50 50 80 00       	mov    0x805050,%eax
  802a5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a62:	c1 e2 04             	shl    $0x4,%edx
  802a65:	01 d0                	add    %edx,%eax
  802a67:	a3 48 51 80 00       	mov    %eax,0x805148
  802a6c:	a1 50 50 80 00       	mov    0x805050,%eax
  802a71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a74:	c1 e2 04             	shl    $0x4,%edx
  802a77:	01 d0                	add    %edx,%eax
  802a79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a80:	a1 54 51 80 00       	mov    0x805154,%eax
  802a85:	40                   	inc    %eax
  802a86:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802a8b:	ff 45 f4             	incl   -0xc(%ebp)
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a94:	0f 82 56 ff ff ff    	jb     8029f0 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802a9a:	90                   	nop
  802a9b:	c9                   	leave  
  802a9c:	c3                   	ret    

00802a9d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802a9d:	55                   	push   %ebp
  802a9e:	89 e5                	mov    %esp,%ebp
  802aa0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	8b 00                	mov    (%eax),%eax
  802aa8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802aab:	eb 19                	jmp    802ac6 <find_block+0x29>
	{
		if(va==point->sva)
  802aad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ab0:	8b 40 08             	mov    0x8(%eax),%eax
  802ab3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ab6:	75 05                	jne    802abd <find_block+0x20>
		   return point;
  802ab8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802abb:	eb 36                	jmp    802af3 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	8b 40 08             	mov    0x8(%eax),%eax
  802ac3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ac6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802aca:	74 07                	je     802ad3 <find_block+0x36>
  802acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	eb 05                	jmp    802ad8 <find_block+0x3b>
  802ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad8:	8b 55 08             	mov    0x8(%ebp),%edx
  802adb:	89 42 08             	mov    %eax,0x8(%edx)
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	8b 40 08             	mov    0x8(%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	75 c5                	jne    802aad <find_block+0x10>
  802ae8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802aec:	75 bf                	jne    802aad <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802aee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802af3:	c9                   	leave  
  802af4:	c3                   	ret    

00802af5 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802af5:	55                   	push   %ebp
  802af6:	89 e5                	mov    %esp,%ebp
  802af8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802afb:	a1 40 50 80 00       	mov    0x805040,%eax
  802b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802b03:	a1 44 50 80 00       	mov    0x805044,%eax
  802b08:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b11:	74 24                	je     802b37 <insert_sorted_allocList+0x42>
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	8b 50 08             	mov    0x8(%eax),%edx
  802b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1c:	8b 40 08             	mov    0x8(%eax),%eax
  802b1f:	39 c2                	cmp    %eax,%edx
  802b21:	76 14                	jbe    802b37 <insert_sorted_allocList+0x42>
  802b23:	8b 45 08             	mov    0x8(%ebp),%eax
  802b26:	8b 50 08             	mov    0x8(%eax),%edx
  802b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2c:	8b 40 08             	mov    0x8(%eax),%eax
  802b2f:	39 c2                	cmp    %eax,%edx
  802b31:	0f 82 60 01 00 00    	jb     802c97 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802b37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b3b:	75 65                	jne    802ba2 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802b3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b41:	75 14                	jne    802b57 <insert_sorted_allocList+0x62>
  802b43:	83 ec 04             	sub    $0x4,%esp
  802b46:	68 a4 4a 80 00       	push   $0x804aa4
  802b4b:	6a 6b                	push   $0x6b
  802b4d:	68 c7 4a 80 00       	push   $0x804ac7
  802b52:	e8 9c e2 ff ff       	call   800df3 <_panic>
  802b57:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	89 10                	mov    %edx,(%eax)
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	85 c0                	test   %eax,%eax
  802b69:	74 0d                	je     802b78 <insert_sorted_allocList+0x83>
  802b6b:	a1 40 50 80 00       	mov    0x805040,%eax
  802b70:	8b 55 08             	mov    0x8(%ebp),%edx
  802b73:	89 50 04             	mov    %edx,0x4(%eax)
  802b76:	eb 08                	jmp    802b80 <insert_sorted_allocList+0x8b>
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	a3 44 50 80 00       	mov    %eax,0x805044
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	a3 40 50 80 00       	mov    %eax,0x805040
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b92:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b97:	40                   	inc    %eax
  802b98:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b9d:	e9 dc 01 00 00       	jmp    802d7e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	8b 50 08             	mov    0x8(%eax),%edx
  802ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bab:	8b 40 08             	mov    0x8(%eax),%eax
  802bae:	39 c2                	cmp    %eax,%edx
  802bb0:	77 6c                	ja     802c1e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802bb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb6:	74 06                	je     802bbe <insert_sorted_allocList+0xc9>
  802bb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bbc:	75 14                	jne    802bd2 <insert_sorted_allocList+0xdd>
  802bbe:	83 ec 04             	sub    $0x4,%esp
  802bc1:	68 e0 4a 80 00       	push   $0x804ae0
  802bc6:	6a 6f                	push   $0x6f
  802bc8:	68 c7 4a 80 00       	push   $0x804ac7
  802bcd:	e8 21 e2 ff ff       	call   800df3 <_panic>
  802bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd5:	8b 50 04             	mov    0x4(%eax),%edx
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	89 50 04             	mov    %edx,0x4(%eax)
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802be4:	89 10                	mov    %edx,(%eax)
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	8b 40 04             	mov    0x4(%eax),%eax
  802bec:	85 c0                	test   %eax,%eax
  802bee:	74 0d                	je     802bfd <insert_sorted_allocList+0x108>
  802bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf3:	8b 40 04             	mov    0x4(%eax),%eax
  802bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf9:	89 10                	mov    %edx,(%eax)
  802bfb:	eb 08                	jmp    802c05 <insert_sorted_allocList+0x110>
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	a3 40 50 80 00       	mov    %eax,0x805040
  802c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c08:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0b:	89 50 04             	mov    %edx,0x4(%eax)
  802c0e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c13:	40                   	inc    %eax
  802c14:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c19:	e9 60 01 00 00       	jmp    802d7e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	8b 50 08             	mov    0x8(%eax),%edx
  802c24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c27:	8b 40 08             	mov    0x8(%eax),%eax
  802c2a:	39 c2                	cmp    %eax,%edx
  802c2c:	0f 82 4c 01 00 00    	jb     802d7e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802c32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c36:	75 14                	jne    802c4c <insert_sorted_allocList+0x157>
  802c38:	83 ec 04             	sub    $0x4,%esp
  802c3b:	68 18 4b 80 00       	push   $0x804b18
  802c40:	6a 73                	push   $0x73
  802c42:	68 c7 4a 80 00       	push   $0x804ac7
  802c47:	e8 a7 e1 ff ff       	call   800df3 <_panic>
  802c4c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	89 50 04             	mov    %edx,0x4(%eax)
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	74 0c                	je     802c6e <insert_sorted_allocList+0x179>
  802c62:	a1 44 50 80 00       	mov    0x805044,%eax
  802c67:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6a:	89 10                	mov    %edx,(%eax)
  802c6c:	eb 08                	jmp    802c76 <insert_sorted_allocList+0x181>
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	a3 40 50 80 00       	mov    %eax,0x805040
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	a3 44 50 80 00       	mov    %eax,0x805044
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c87:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c8c:	40                   	inc    %eax
  802c8d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c92:	e9 e7 00 00 00       	jmp    802d7e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802c9d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802ca4:	a1 40 50 80 00       	mov    0x805040,%eax
  802ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cac:	e9 9d 00 00 00       	jmp    802d4e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	8b 50 08             	mov    0x8(%eax),%edx
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 40 08             	mov    0x8(%eax),%eax
  802cc5:	39 c2                	cmp    %eax,%edx
  802cc7:	76 7d                	jbe    802d46 <insert_sorted_allocList+0x251>
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	8b 50 08             	mov    0x8(%eax),%edx
  802ccf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd2:	8b 40 08             	mov    0x8(%eax),%eax
  802cd5:	39 c2                	cmp    %eax,%edx
  802cd7:	73 6d                	jae    802d46 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdd:	74 06                	je     802ce5 <insert_sorted_allocList+0x1f0>
  802cdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce3:	75 14                	jne    802cf9 <insert_sorted_allocList+0x204>
  802ce5:	83 ec 04             	sub    $0x4,%esp
  802ce8:	68 3c 4b 80 00       	push   $0x804b3c
  802ced:	6a 7f                	push   $0x7f
  802cef:	68 c7 4a 80 00       	push   $0x804ac7
  802cf4:	e8 fa e0 ff ff       	call   800df3 <_panic>
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 10                	mov    (%eax),%edx
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	89 10                	mov    %edx,(%eax)
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	8b 00                	mov    (%eax),%eax
  802d08:	85 c0                	test   %eax,%eax
  802d0a:	74 0b                	je     802d17 <insert_sorted_allocList+0x222>
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 00                	mov    (%eax),%eax
  802d11:	8b 55 08             	mov    0x8(%ebp),%edx
  802d14:	89 50 04             	mov    %edx,0x4(%eax)
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1d:	89 10                	mov    %edx,(%eax)
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d25:	89 50 04             	mov    %edx,0x4(%eax)
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	8b 00                	mov    (%eax),%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	75 08                	jne    802d39 <insert_sorted_allocList+0x244>
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	a3 44 50 80 00       	mov    %eax,0x805044
  802d39:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d3e:	40                   	inc    %eax
  802d3f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802d44:	eb 39                	jmp    802d7f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802d46:	a1 48 50 80 00       	mov    0x805048,%eax
  802d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d52:	74 07                	je     802d5b <insert_sorted_allocList+0x266>
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 00                	mov    (%eax),%eax
  802d59:	eb 05                	jmp    802d60 <insert_sorted_allocList+0x26b>
  802d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d60:	a3 48 50 80 00       	mov    %eax,0x805048
  802d65:	a1 48 50 80 00       	mov    0x805048,%eax
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	0f 85 3f ff ff ff    	jne    802cb1 <insert_sorted_allocList+0x1bc>
  802d72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d76:	0f 85 35 ff ff ff    	jne    802cb1 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802d7c:	eb 01                	jmp    802d7f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d7e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802d7f:	90                   	nop
  802d80:	c9                   	leave  
  802d81:	c3                   	ret    

00802d82 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d82:	55                   	push   %ebp
  802d83:	89 e5                	mov    %esp,%ebp
  802d85:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802d88:	a1 38 51 80 00       	mov    0x805138,%eax
  802d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d90:	e9 85 01 00 00       	jmp    802f1a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d9e:	0f 82 6e 01 00 00    	jb     802f12 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 40 0c             	mov    0xc(%eax),%eax
  802daa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dad:	0f 85 8a 00 00 00    	jne    802e3d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db7:	75 17                	jne    802dd0 <alloc_block_FF+0x4e>
  802db9:	83 ec 04             	sub    $0x4,%esp
  802dbc:	68 70 4b 80 00       	push   $0x804b70
  802dc1:	68 93 00 00 00       	push   $0x93
  802dc6:	68 c7 4a 80 00       	push   $0x804ac7
  802dcb:	e8 23 e0 ff ff       	call   800df3 <_panic>
  802dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	74 10                	je     802de9 <alloc_block_FF+0x67>
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 00                	mov    (%eax),%eax
  802dde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de1:	8b 52 04             	mov    0x4(%edx),%edx
  802de4:	89 50 04             	mov    %edx,0x4(%eax)
  802de7:	eb 0b                	jmp    802df4 <alloc_block_FF+0x72>
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	8b 40 04             	mov    0x4(%eax),%eax
  802def:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	8b 40 04             	mov    0x4(%eax),%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	74 0f                	je     802e0d <alloc_block_FF+0x8b>
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 40 04             	mov    0x4(%eax),%eax
  802e04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e07:	8b 12                	mov    (%edx),%edx
  802e09:	89 10                	mov    %edx,(%eax)
  802e0b:	eb 0a                	jmp    802e17 <alloc_block_FF+0x95>
  802e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e10:	8b 00                	mov    (%eax),%eax
  802e12:	a3 38 51 80 00       	mov    %eax,0x805138
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2a:	a1 44 51 80 00       	mov    0x805144,%eax
  802e2f:	48                   	dec    %eax
  802e30:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	e9 10 01 00 00       	jmp    802f4d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 40 0c             	mov    0xc(%eax),%eax
  802e43:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e46:	0f 86 c6 00 00 00    	jbe    802f12 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e4c:	a1 48 51 80 00       	mov    0x805148,%eax
  802e51:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 50 08             	mov    0x8(%eax),%edx
  802e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e63:	8b 55 08             	mov    0x8(%ebp),%edx
  802e66:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e6d:	75 17                	jne    802e86 <alloc_block_FF+0x104>
  802e6f:	83 ec 04             	sub    $0x4,%esp
  802e72:	68 70 4b 80 00       	push   $0x804b70
  802e77:	68 9b 00 00 00       	push   $0x9b
  802e7c:	68 c7 4a 80 00       	push   $0x804ac7
  802e81:	e8 6d df ff ff       	call   800df3 <_panic>
  802e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	85 c0                	test   %eax,%eax
  802e8d:	74 10                	je     802e9f <alloc_block_FF+0x11d>
  802e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e92:	8b 00                	mov    (%eax),%eax
  802e94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e97:	8b 52 04             	mov    0x4(%edx),%edx
  802e9a:	89 50 04             	mov    %edx,0x4(%eax)
  802e9d:	eb 0b                	jmp    802eaa <alloc_block_FF+0x128>
  802e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea2:	8b 40 04             	mov    0x4(%eax),%eax
  802ea5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ead:	8b 40 04             	mov    0x4(%eax),%eax
  802eb0:	85 c0                	test   %eax,%eax
  802eb2:	74 0f                	je     802ec3 <alloc_block_FF+0x141>
  802eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb7:	8b 40 04             	mov    0x4(%eax),%eax
  802eba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ebd:	8b 12                	mov    (%edx),%edx
  802ebf:	89 10                	mov    %edx,(%eax)
  802ec1:	eb 0a                	jmp    802ecd <alloc_block_FF+0x14b>
  802ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec6:	8b 00                	mov    (%eax),%eax
  802ec8:	a3 48 51 80 00       	mov    %eax,0x805148
  802ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ee5:	48                   	dec    %eax
  802ee6:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eee:	8b 50 08             	mov    0x8(%eax),%edx
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	01 c2                	add    %eax,%edx
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 40 0c             	mov    0xc(%eax),%eax
  802f02:	2b 45 08             	sub    0x8(%ebp),%eax
  802f05:	89 c2                	mov    %eax,%edx
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f10:	eb 3b                	jmp    802f4d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802f12:	a1 40 51 80 00       	mov    0x805140,%eax
  802f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f1e:	74 07                	je     802f27 <alloc_block_FF+0x1a5>
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	8b 00                	mov    (%eax),%eax
  802f25:	eb 05                	jmp    802f2c <alloc_block_FF+0x1aa>
  802f27:	b8 00 00 00 00       	mov    $0x0,%eax
  802f2c:	a3 40 51 80 00       	mov    %eax,0x805140
  802f31:	a1 40 51 80 00       	mov    0x805140,%eax
  802f36:	85 c0                	test   %eax,%eax
  802f38:	0f 85 57 fe ff ff    	jne    802d95 <alloc_block_FF+0x13>
  802f3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f42:	0f 85 4d fe ff ff    	jne    802d95 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802f48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f4d:	c9                   	leave  
  802f4e:	c3                   	ret    

00802f4f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802f4f:	55                   	push   %ebp
  802f50:	89 e5                	mov    %esp,%ebp
  802f52:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802f55:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802f5c:	a1 38 51 80 00       	mov    0x805138,%eax
  802f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f64:	e9 df 00 00 00       	jmp    803048 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f72:	0f 82 c8 00 00 00    	jb     803040 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f81:	0f 85 8a 00 00 00    	jne    803011 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802f87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8b:	75 17                	jne    802fa4 <alloc_block_BF+0x55>
  802f8d:	83 ec 04             	sub    $0x4,%esp
  802f90:	68 70 4b 80 00       	push   $0x804b70
  802f95:	68 b7 00 00 00       	push   $0xb7
  802f9a:	68 c7 4a 80 00       	push   $0x804ac7
  802f9f:	e8 4f de ff ff       	call   800df3 <_panic>
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 00                	mov    (%eax),%eax
  802fa9:	85 c0                	test   %eax,%eax
  802fab:	74 10                	je     802fbd <alloc_block_BF+0x6e>
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb5:	8b 52 04             	mov    0x4(%edx),%edx
  802fb8:	89 50 04             	mov    %edx,0x4(%eax)
  802fbb:	eb 0b                	jmp    802fc8 <alloc_block_BF+0x79>
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	8b 40 04             	mov    0x4(%eax),%eax
  802fc3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 40 04             	mov    0x4(%eax),%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	74 0f                	je     802fe1 <alloc_block_BF+0x92>
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 40 04             	mov    0x4(%eax),%eax
  802fd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fdb:	8b 12                	mov    (%edx),%edx
  802fdd:	89 10                	mov    %edx,(%eax)
  802fdf:	eb 0a                	jmp    802feb <alloc_block_BF+0x9c>
  802fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe4:	8b 00                	mov    (%eax),%eax
  802fe6:	a3 38 51 80 00       	mov    %eax,0x805138
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffe:	a1 44 51 80 00       	mov    0x805144,%eax
  803003:	48                   	dec    %eax
  803004:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	e9 4d 01 00 00       	jmp    80315e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 40 0c             	mov    0xc(%eax),%eax
  803017:	3b 45 08             	cmp    0x8(%ebp),%eax
  80301a:	76 24                	jbe    803040 <alloc_block_BF+0xf1>
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	8b 40 0c             	mov    0xc(%eax),%eax
  803022:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803025:	73 19                	jae    803040 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803027:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 40 0c             	mov    0xc(%eax),%eax
  803034:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 40 08             	mov    0x8(%eax),%eax
  80303d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803040:	a1 40 51 80 00       	mov    0x805140,%eax
  803045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803048:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304c:	74 07                	je     803055 <alloc_block_BF+0x106>
  80304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	eb 05                	jmp    80305a <alloc_block_BF+0x10b>
  803055:	b8 00 00 00 00       	mov    $0x0,%eax
  80305a:	a3 40 51 80 00       	mov    %eax,0x805140
  80305f:	a1 40 51 80 00       	mov    0x805140,%eax
  803064:	85 c0                	test   %eax,%eax
  803066:	0f 85 fd fe ff ff    	jne    802f69 <alloc_block_BF+0x1a>
  80306c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803070:	0f 85 f3 fe ff ff    	jne    802f69 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803076:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80307a:	0f 84 d9 00 00 00    	je     803159 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803080:	a1 48 51 80 00       	mov    0x805148,%eax
  803085:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803088:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80308b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80308e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803091:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803094:	8b 55 08             	mov    0x8(%ebp),%edx
  803097:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80309a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80309e:	75 17                	jne    8030b7 <alloc_block_BF+0x168>
  8030a0:	83 ec 04             	sub    $0x4,%esp
  8030a3:	68 70 4b 80 00       	push   $0x804b70
  8030a8:	68 c7 00 00 00       	push   $0xc7
  8030ad:	68 c7 4a 80 00       	push   $0x804ac7
  8030b2:	e8 3c dd ff ff       	call   800df3 <_panic>
  8030b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ba:	8b 00                	mov    (%eax),%eax
  8030bc:	85 c0                	test   %eax,%eax
  8030be:	74 10                	je     8030d0 <alloc_block_BF+0x181>
  8030c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030c8:	8b 52 04             	mov    0x4(%edx),%edx
  8030cb:	89 50 04             	mov    %edx,0x4(%eax)
  8030ce:	eb 0b                	jmp    8030db <alloc_block_BF+0x18c>
  8030d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d3:	8b 40 04             	mov    0x4(%eax),%eax
  8030d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030de:	8b 40 04             	mov    0x4(%eax),%eax
  8030e1:	85 c0                	test   %eax,%eax
  8030e3:	74 0f                	je     8030f4 <alloc_block_BF+0x1a5>
  8030e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e8:	8b 40 04             	mov    0x4(%eax),%eax
  8030eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ee:	8b 12                	mov    (%edx),%edx
  8030f0:	89 10                	mov    %edx,(%eax)
  8030f2:	eb 0a                	jmp    8030fe <alloc_block_BF+0x1af>
  8030f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8030fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803101:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80310a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803111:	a1 54 51 80 00       	mov    0x805154,%eax
  803116:	48                   	dec    %eax
  803117:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80311c:	83 ec 08             	sub    $0x8,%esp
  80311f:	ff 75 ec             	pushl  -0x14(%ebp)
  803122:	68 38 51 80 00       	push   $0x805138
  803127:	e8 71 f9 ff ff       	call   802a9d <find_block>
  80312c:	83 c4 10             	add    $0x10,%esp
  80312f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803132:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803135:	8b 50 08             	mov    0x8(%eax),%edx
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	01 c2                	add    %eax,%edx
  80313d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803140:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803143:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803146:	8b 40 0c             	mov    0xc(%eax),%eax
  803149:	2b 45 08             	sub    0x8(%ebp),%eax
  80314c:	89 c2                	mov    %eax,%edx
  80314e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803151:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803157:	eb 05                	jmp    80315e <alloc_block_BF+0x20f>
	}
	return NULL;
  803159:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80315e:	c9                   	leave  
  80315f:	c3                   	ret    

00803160 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803160:	55                   	push   %ebp
  803161:	89 e5                	mov    %esp,%ebp
  803163:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803166:	a1 28 50 80 00       	mov    0x805028,%eax
  80316b:	85 c0                	test   %eax,%eax
  80316d:	0f 85 de 01 00 00    	jne    803351 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803173:	a1 38 51 80 00       	mov    0x805138,%eax
  803178:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80317b:	e9 9e 01 00 00       	jmp    80331e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803183:	8b 40 0c             	mov    0xc(%eax),%eax
  803186:	3b 45 08             	cmp    0x8(%ebp),%eax
  803189:	0f 82 87 01 00 00    	jb     803316 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80318f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803192:	8b 40 0c             	mov    0xc(%eax),%eax
  803195:	3b 45 08             	cmp    0x8(%ebp),%eax
  803198:	0f 85 95 00 00 00    	jne    803233 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80319e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a2:	75 17                	jne    8031bb <alloc_block_NF+0x5b>
  8031a4:	83 ec 04             	sub    $0x4,%esp
  8031a7:	68 70 4b 80 00       	push   $0x804b70
  8031ac:	68 e0 00 00 00       	push   $0xe0
  8031b1:	68 c7 4a 80 00       	push   $0x804ac7
  8031b6:	e8 38 dc ff ff       	call   800df3 <_panic>
  8031bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031be:	8b 00                	mov    (%eax),%eax
  8031c0:	85 c0                	test   %eax,%eax
  8031c2:	74 10                	je     8031d4 <alloc_block_NF+0x74>
  8031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031cc:	8b 52 04             	mov    0x4(%edx),%edx
  8031cf:	89 50 04             	mov    %edx,0x4(%eax)
  8031d2:	eb 0b                	jmp    8031df <alloc_block_NF+0x7f>
  8031d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d7:	8b 40 04             	mov    0x4(%eax),%eax
  8031da:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e2:	8b 40 04             	mov    0x4(%eax),%eax
  8031e5:	85 c0                	test   %eax,%eax
  8031e7:	74 0f                	je     8031f8 <alloc_block_NF+0x98>
  8031e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ec:	8b 40 04             	mov    0x4(%eax),%eax
  8031ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f2:	8b 12                	mov    (%edx),%edx
  8031f4:	89 10                	mov    %edx,(%eax)
  8031f6:	eb 0a                	jmp    803202 <alloc_block_NF+0xa2>
  8031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fb:	8b 00                	mov    (%eax),%eax
  8031fd:	a3 38 51 80 00       	mov    %eax,0x805138
  803202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803205:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803215:	a1 44 51 80 00       	mov    0x805144,%eax
  80321a:	48                   	dec    %eax
  80321b:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803223:	8b 40 08             	mov    0x8(%eax),%eax
  803226:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	e9 f8 04 00 00       	jmp    80372b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803236:	8b 40 0c             	mov    0xc(%eax),%eax
  803239:	3b 45 08             	cmp    0x8(%ebp),%eax
  80323c:	0f 86 d4 00 00 00    	jbe    803316 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803242:	a1 48 51 80 00       	mov    0x805148,%eax
  803247:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324d:	8b 50 08             	mov    0x8(%eax),%edx
  803250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803253:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803259:	8b 55 08             	mov    0x8(%ebp),%edx
  80325c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80325f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803263:	75 17                	jne    80327c <alloc_block_NF+0x11c>
  803265:	83 ec 04             	sub    $0x4,%esp
  803268:	68 70 4b 80 00       	push   $0x804b70
  80326d:	68 e9 00 00 00       	push   $0xe9
  803272:	68 c7 4a 80 00       	push   $0x804ac7
  803277:	e8 77 db ff ff       	call   800df3 <_panic>
  80327c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327f:	8b 00                	mov    (%eax),%eax
  803281:	85 c0                	test   %eax,%eax
  803283:	74 10                	je     803295 <alloc_block_NF+0x135>
  803285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803288:	8b 00                	mov    (%eax),%eax
  80328a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80328d:	8b 52 04             	mov    0x4(%edx),%edx
  803290:	89 50 04             	mov    %edx,0x4(%eax)
  803293:	eb 0b                	jmp    8032a0 <alloc_block_NF+0x140>
  803295:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803298:	8b 40 04             	mov    0x4(%eax),%eax
  80329b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a3:	8b 40 04             	mov    0x4(%eax),%eax
  8032a6:	85 c0                	test   %eax,%eax
  8032a8:	74 0f                	je     8032b9 <alloc_block_NF+0x159>
  8032aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ad:	8b 40 04             	mov    0x4(%eax),%eax
  8032b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032b3:	8b 12                	mov    (%edx),%edx
  8032b5:	89 10                	mov    %edx,(%eax)
  8032b7:	eb 0a                	jmp    8032c3 <alloc_block_NF+0x163>
  8032b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032bc:	8b 00                	mov    (%eax),%eax
  8032be:	a3 48 51 80 00       	mov    %eax,0x805148
  8032c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8032db:	48                   	dec    %eax
  8032dc:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8032e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e4:	8b 40 08             	mov    0x8(%eax),%eax
  8032e7:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8032ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ef:	8b 50 08             	mov    0x8(%eax),%edx
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	01 c2                	add    %eax,%edx
  8032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fa:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	8b 40 0c             	mov    0xc(%eax),%eax
  803303:	2b 45 08             	sub    0x8(%ebp),%eax
  803306:	89 c2                	mov    %eax,%edx
  803308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80330e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803311:	e9 15 04 00 00       	jmp    80372b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803316:	a1 40 51 80 00       	mov    0x805140,%eax
  80331b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80331e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803322:	74 07                	je     80332b <alloc_block_NF+0x1cb>
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	8b 00                	mov    (%eax),%eax
  803329:	eb 05                	jmp    803330 <alloc_block_NF+0x1d0>
  80332b:	b8 00 00 00 00       	mov    $0x0,%eax
  803330:	a3 40 51 80 00       	mov    %eax,0x805140
  803335:	a1 40 51 80 00       	mov    0x805140,%eax
  80333a:	85 c0                	test   %eax,%eax
  80333c:	0f 85 3e fe ff ff    	jne    803180 <alloc_block_NF+0x20>
  803342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803346:	0f 85 34 fe ff ff    	jne    803180 <alloc_block_NF+0x20>
  80334c:	e9 d5 03 00 00       	jmp    803726 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803351:	a1 38 51 80 00       	mov    0x805138,%eax
  803356:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803359:	e9 b1 01 00 00       	jmp    80350f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 50 08             	mov    0x8(%eax),%edx
  803364:	a1 28 50 80 00       	mov    0x805028,%eax
  803369:	39 c2                	cmp    %eax,%edx
  80336b:	0f 82 96 01 00 00    	jb     803507 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	8b 40 0c             	mov    0xc(%eax),%eax
  803377:	3b 45 08             	cmp    0x8(%ebp),%eax
  80337a:	0f 82 87 01 00 00    	jb     803507 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	8b 40 0c             	mov    0xc(%eax),%eax
  803386:	3b 45 08             	cmp    0x8(%ebp),%eax
  803389:	0f 85 95 00 00 00    	jne    803424 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80338f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803393:	75 17                	jne    8033ac <alloc_block_NF+0x24c>
  803395:	83 ec 04             	sub    $0x4,%esp
  803398:	68 70 4b 80 00       	push   $0x804b70
  80339d:	68 fc 00 00 00       	push   $0xfc
  8033a2:	68 c7 4a 80 00       	push   $0x804ac7
  8033a7:	e8 47 da ff ff       	call   800df3 <_panic>
  8033ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	85 c0                	test   %eax,%eax
  8033b3:	74 10                	je     8033c5 <alloc_block_NF+0x265>
  8033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b8:	8b 00                	mov    (%eax),%eax
  8033ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033bd:	8b 52 04             	mov    0x4(%edx),%edx
  8033c0:	89 50 04             	mov    %edx,0x4(%eax)
  8033c3:	eb 0b                	jmp    8033d0 <alloc_block_NF+0x270>
  8033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c8:	8b 40 04             	mov    0x4(%eax),%eax
  8033cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d3:	8b 40 04             	mov    0x4(%eax),%eax
  8033d6:	85 c0                	test   %eax,%eax
  8033d8:	74 0f                	je     8033e9 <alloc_block_NF+0x289>
  8033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dd:	8b 40 04             	mov    0x4(%eax),%eax
  8033e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e3:	8b 12                	mov    (%edx),%edx
  8033e5:	89 10                	mov    %edx,(%eax)
  8033e7:	eb 0a                	jmp    8033f3 <alloc_block_NF+0x293>
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803406:	a1 44 51 80 00       	mov    0x805144,%eax
  80340b:	48                   	dec    %eax
  80340c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803414:	8b 40 08             	mov    0x8(%eax),%eax
  803417:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80341c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341f:	e9 07 03 00 00       	jmp    80372b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803427:	8b 40 0c             	mov    0xc(%eax),%eax
  80342a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80342d:	0f 86 d4 00 00 00    	jbe    803507 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803433:	a1 48 51 80 00       	mov    0x805148,%eax
  803438:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80343b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343e:	8b 50 08             	mov    0x8(%eax),%edx
  803441:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803444:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344a:	8b 55 08             	mov    0x8(%ebp),%edx
  80344d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803450:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803454:	75 17                	jne    80346d <alloc_block_NF+0x30d>
  803456:	83 ec 04             	sub    $0x4,%esp
  803459:	68 70 4b 80 00       	push   $0x804b70
  80345e:	68 04 01 00 00       	push   $0x104
  803463:	68 c7 4a 80 00       	push   $0x804ac7
  803468:	e8 86 d9 ff ff       	call   800df3 <_panic>
  80346d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803470:	8b 00                	mov    (%eax),%eax
  803472:	85 c0                	test   %eax,%eax
  803474:	74 10                	je     803486 <alloc_block_NF+0x326>
  803476:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803479:	8b 00                	mov    (%eax),%eax
  80347b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80347e:	8b 52 04             	mov    0x4(%edx),%edx
  803481:	89 50 04             	mov    %edx,0x4(%eax)
  803484:	eb 0b                	jmp    803491 <alloc_block_NF+0x331>
  803486:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803489:	8b 40 04             	mov    0x4(%eax),%eax
  80348c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803491:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803494:	8b 40 04             	mov    0x4(%eax),%eax
  803497:	85 c0                	test   %eax,%eax
  803499:	74 0f                	je     8034aa <alloc_block_NF+0x34a>
  80349b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349e:	8b 40 04             	mov    0x4(%eax),%eax
  8034a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a4:	8b 12                	mov    (%edx),%edx
  8034a6:	89 10                	mov    %edx,(%eax)
  8034a8:	eb 0a                	jmp    8034b4 <alloc_block_NF+0x354>
  8034aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ad:	8b 00                	mov    (%eax),%eax
  8034af:	a3 48 51 80 00       	mov    %eax,0x805148
  8034b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8034cc:	48                   	dec    %eax
  8034cd:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8034d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d5:	8b 40 08             	mov    0x8(%eax),%eax
  8034d8:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8034dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e0:	8b 50 08             	mov    0x8(%eax),%edx
  8034e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e6:	01 c2                	add    %eax,%edx
  8034e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034eb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8034ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f4:	2b 45 08             	sub    0x8(%ebp),%eax
  8034f7:	89 c2                	mov    %eax,%edx
  8034f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8034ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803502:	e9 24 02 00 00       	jmp    80372b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803507:	a1 40 51 80 00       	mov    0x805140,%eax
  80350c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80350f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803513:	74 07                	je     80351c <alloc_block_NF+0x3bc>
  803515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803518:	8b 00                	mov    (%eax),%eax
  80351a:	eb 05                	jmp    803521 <alloc_block_NF+0x3c1>
  80351c:	b8 00 00 00 00       	mov    $0x0,%eax
  803521:	a3 40 51 80 00       	mov    %eax,0x805140
  803526:	a1 40 51 80 00       	mov    0x805140,%eax
  80352b:	85 c0                	test   %eax,%eax
  80352d:	0f 85 2b fe ff ff    	jne    80335e <alloc_block_NF+0x1fe>
  803533:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803537:	0f 85 21 fe ff ff    	jne    80335e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80353d:	a1 38 51 80 00       	mov    0x805138,%eax
  803542:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803545:	e9 ae 01 00 00       	jmp    8036f8 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80354a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354d:	8b 50 08             	mov    0x8(%eax),%edx
  803550:	a1 28 50 80 00       	mov    0x805028,%eax
  803555:	39 c2                	cmp    %eax,%edx
  803557:	0f 83 93 01 00 00    	jae    8036f0 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80355d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803560:	8b 40 0c             	mov    0xc(%eax),%eax
  803563:	3b 45 08             	cmp    0x8(%ebp),%eax
  803566:	0f 82 84 01 00 00    	jb     8036f0 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 40 0c             	mov    0xc(%eax),%eax
  803572:	3b 45 08             	cmp    0x8(%ebp),%eax
  803575:	0f 85 95 00 00 00    	jne    803610 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80357b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80357f:	75 17                	jne    803598 <alloc_block_NF+0x438>
  803581:	83 ec 04             	sub    $0x4,%esp
  803584:	68 70 4b 80 00       	push   $0x804b70
  803589:	68 14 01 00 00       	push   $0x114
  80358e:	68 c7 4a 80 00       	push   $0x804ac7
  803593:	e8 5b d8 ff ff       	call   800df3 <_panic>
  803598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359b:	8b 00                	mov    (%eax),%eax
  80359d:	85 c0                	test   %eax,%eax
  80359f:	74 10                	je     8035b1 <alloc_block_NF+0x451>
  8035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a4:	8b 00                	mov    (%eax),%eax
  8035a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035a9:	8b 52 04             	mov    0x4(%edx),%edx
  8035ac:	89 50 04             	mov    %edx,0x4(%eax)
  8035af:	eb 0b                	jmp    8035bc <alloc_block_NF+0x45c>
  8035b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b4:	8b 40 04             	mov    0x4(%eax),%eax
  8035b7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bf:	8b 40 04             	mov    0x4(%eax),%eax
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	74 0f                	je     8035d5 <alloc_block_NF+0x475>
  8035c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c9:	8b 40 04             	mov    0x4(%eax),%eax
  8035cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035cf:	8b 12                	mov    (%edx),%edx
  8035d1:	89 10                	mov    %edx,(%eax)
  8035d3:	eb 0a                	jmp    8035df <alloc_block_NF+0x47f>
  8035d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d8:	8b 00                	mov    (%eax),%eax
  8035da:	a3 38 51 80 00       	mov    %eax,0x805138
  8035df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8035f7:	48                   	dec    %eax
  8035f8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	8b 40 08             	mov    0x8(%eax),%eax
  803603:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	e9 1b 01 00 00       	jmp    80372b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803613:	8b 40 0c             	mov    0xc(%eax),%eax
  803616:	3b 45 08             	cmp    0x8(%ebp),%eax
  803619:	0f 86 d1 00 00 00    	jbe    8036f0 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80361f:	a1 48 51 80 00       	mov    0x805148,%eax
  803624:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362a:	8b 50 08             	mov    0x8(%eax),%edx
  80362d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803630:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803633:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803636:	8b 55 08             	mov    0x8(%ebp),%edx
  803639:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80363c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803640:	75 17                	jne    803659 <alloc_block_NF+0x4f9>
  803642:	83 ec 04             	sub    $0x4,%esp
  803645:	68 70 4b 80 00       	push   $0x804b70
  80364a:	68 1c 01 00 00       	push   $0x11c
  80364f:	68 c7 4a 80 00       	push   $0x804ac7
  803654:	e8 9a d7 ff ff       	call   800df3 <_panic>
  803659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80365c:	8b 00                	mov    (%eax),%eax
  80365e:	85 c0                	test   %eax,%eax
  803660:	74 10                	je     803672 <alloc_block_NF+0x512>
  803662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803665:	8b 00                	mov    (%eax),%eax
  803667:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80366a:	8b 52 04             	mov    0x4(%edx),%edx
  80366d:	89 50 04             	mov    %edx,0x4(%eax)
  803670:	eb 0b                	jmp    80367d <alloc_block_NF+0x51d>
  803672:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803675:	8b 40 04             	mov    0x4(%eax),%eax
  803678:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80367d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803680:	8b 40 04             	mov    0x4(%eax),%eax
  803683:	85 c0                	test   %eax,%eax
  803685:	74 0f                	je     803696 <alloc_block_NF+0x536>
  803687:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80368a:	8b 40 04             	mov    0x4(%eax),%eax
  80368d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803690:	8b 12                	mov    (%edx),%edx
  803692:	89 10                	mov    %edx,(%eax)
  803694:	eb 0a                	jmp    8036a0 <alloc_block_NF+0x540>
  803696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803699:	8b 00                	mov    (%eax),%eax
  80369b:	a3 48 51 80 00       	mov    %eax,0x805148
  8036a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036b3:	a1 54 51 80 00       	mov    0x805154,%eax
  8036b8:	48                   	dec    %eax
  8036b9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8036be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c1:	8b 40 08             	mov    0x8(%eax),%eax
  8036c4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8036c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cc:	8b 50 08             	mov    0x8(%eax),%edx
  8036cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d2:	01 c2                	add    %eax,%edx
  8036d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8036da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8036e0:	2b 45 08             	sub    0x8(%ebp),%eax
  8036e3:	89 c2                	mov    %eax,%edx
  8036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8036eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ee:	eb 3b                	jmp    80372b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8036f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8036f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036fc:	74 07                	je     803705 <alloc_block_NF+0x5a5>
  8036fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803701:	8b 00                	mov    (%eax),%eax
  803703:	eb 05                	jmp    80370a <alloc_block_NF+0x5aa>
  803705:	b8 00 00 00 00       	mov    $0x0,%eax
  80370a:	a3 40 51 80 00       	mov    %eax,0x805140
  80370f:	a1 40 51 80 00       	mov    0x805140,%eax
  803714:	85 c0                	test   %eax,%eax
  803716:	0f 85 2e fe ff ff    	jne    80354a <alloc_block_NF+0x3ea>
  80371c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803720:	0f 85 24 fe ff ff    	jne    80354a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803726:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80372b:	c9                   	leave  
  80372c:	c3                   	ret    

0080372d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80372d:	55                   	push   %ebp
  80372e:	89 e5                	mov    %esp,%ebp
  803730:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803733:	a1 38 51 80 00       	mov    0x805138,%eax
  803738:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80373b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803740:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803743:	a1 38 51 80 00       	mov    0x805138,%eax
  803748:	85 c0                	test   %eax,%eax
  80374a:	74 14                	je     803760 <insert_sorted_with_merge_freeList+0x33>
  80374c:	8b 45 08             	mov    0x8(%ebp),%eax
  80374f:	8b 50 08             	mov    0x8(%eax),%edx
  803752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803755:	8b 40 08             	mov    0x8(%eax),%eax
  803758:	39 c2                	cmp    %eax,%edx
  80375a:	0f 87 9b 01 00 00    	ja     8038fb <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803760:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803764:	75 17                	jne    80377d <insert_sorted_with_merge_freeList+0x50>
  803766:	83 ec 04             	sub    $0x4,%esp
  803769:	68 a4 4a 80 00       	push   $0x804aa4
  80376e:	68 38 01 00 00       	push   $0x138
  803773:	68 c7 4a 80 00       	push   $0x804ac7
  803778:	e8 76 d6 ff ff       	call   800df3 <_panic>
  80377d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803783:	8b 45 08             	mov    0x8(%ebp),%eax
  803786:	89 10                	mov    %edx,(%eax)
  803788:	8b 45 08             	mov    0x8(%ebp),%eax
  80378b:	8b 00                	mov    (%eax),%eax
  80378d:	85 c0                	test   %eax,%eax
  80378f:	74 0d                	je     80379e <insert_sorted_with_merge_freeList+0x71>
  803791:	a1 38 51 80 00       	mov    0x805138,%eax
  803796:	8b 55 08             	mov    0x8(%ebp),%edx
  803799:	89 50 04             	mov    %edx,0x4(%eax)
  80379c:	eb 08                	jmp    8037a6 <insert_sorted_with_merge_freeList+0x79>
  80379e:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8037ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b8:	a1 44 51 80 00       	mov    0x805144,%eax
  8037bd:	40                   	inc    %eax
  8037be:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037c7:	0f 84 a8 06 00 00    	je     803e75 <insert_sorted_with_merge_freeList+0x748>
  8037cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d0:	8b 50 08             	mov    0x8(%eax),%edx
  8037d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d9:	01 c2                	add    %eax,%edx
  8037db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037de:	8b 40 08             	mov    0x8(%eax),%eax
  8037e1:	39 c2                	cmp    %eax,%edx
  8037e3:	0f 85 8c 06 00 00    	jne    803e75 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8037e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8037ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f5:	01 c2                	add    %eax,%edx
  8037f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fa:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8037fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803801:	75 17                	jne    80381a <insert_sorted_with_merge_freeList+0xed>
  803803:	83 ec 04             	sub    $0x4,%esp
  803806:	68 70 4b 80 00       	push   $0x804b70
  80380b:	68 3c 01 00 00       	push   $0x13c
  803810:	68 c7 4a 80 00       	push   $0x804ac7
  803815:	e8 d9 d5 ff ff       	call   800df3 <_panic>
  80381a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80381d:	8b 00                	mov    (%eax),%eax
  80381f:	85 c0                	test   %eax,%eax
  803821:	74 10                	je     803833 <insert_sorted_with_merge_freeList+0x106>
  803823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803826:	8b 00                	mov    (%eax),%eax
  803828:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80382b:	8b 52 04             	mov    0x4(%edx),%edx
  80382e:	89 50 04             	mov    %edx,0x4(%eax)
  803831:	eb 0b                	jmp    80383e <insert_sorted_with_merge_freeList+0x111>
  803833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803836:	8b 40 04             	mov    0x4(%eax),%eax
  803839:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80383e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803841:	8b 40 04             	mov    0x4(%eax),%eax
  803844:	85 c0                	test   %eax,%eax
  803846:	74 0f                	je     803857 <insert_sorted_with_merge_freeList+0x12a>
  803848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384b:	8b 40 04             	mov    0x4(%eax),%eax
  80384e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803851:	8b 12                	mov    (%edx),%edx
  803853:	89 10                	mov    %edx,(%eax)
  803855:	eb 0a                	jmp    803861 <insert_sorted_with_merge_freeList+0x134>
  803857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385a:	8b 00                	mov    (%eax),%eax
  80385c:	a3 38 51 80 00       	mov    %eax,0x805138
  803861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803864:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80386a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803874:	a1 44 51 80 00       	mov    0x805144,%eax
  803879:	48                   	dec    %eax
  80387a:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80387f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803882:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80388c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803893:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803897:	75 17                	jne    8038b0 <insert_sorted_with_merge_freeList+0x183>
  803899:	83 ec 04             	sub    $0x4,%esp
  80389c:	68 a4 4a 80 00       	push   $0x804aa4
  8038a1:	68 3f 01 00 00       	push   $0x13f
  8038a6:	68 c7 4a 80 00       	push   $0x804ac7
  8038ab:	e8 43 d5 ff ff       	call   800df3 <_panic>
  8038b0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b9:	89 10                	mov    %edx,(%eax)
  8038bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038be:	8b 00                	mov    (%eax),%eax
  8038c0:	85 c0                	test   %eax,%eax
  8038c2:	74 0d                	je     8038d1 <insert_sorted_with_merge_freeList+0x1a4>
  8038c4:	a1 48 51 80 00       	mov    0x805148,%eax
  8038c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038cc:	89 50 04             	mov    %edx,0x4(%eax)
  8038cf:	eb 08                	jmp    8038d9 <insert_sorted_with_merge_freeList+0x1ac>
  8038d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8038e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038eb:	a1 54 51 80 00       	mov    0x805154,%eax
  8038f0:	40                   	inc    %eax
  8038f1:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8038f6:	e9 7a 05 00 00       	jmp    803e75 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8038fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fe:	8b 50 08             	mov    0x8(%eax),%edx
  803901:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803904:	8b 40 08             	mov    0x8(%eax),%eax
  803907:	39 c2                	cmp    %eax,%edx
  803909:	0f 82 14 01 00 00    	jb     803a23 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80390f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803912:	8b 50 08             	mov    0x8(%eax),%edx
  803915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803918:	8b 40 0c             	mov    0xc(%eax),%eax
  80391b:	01 c2                	add    %eax,%edx
  80391d:	8b 45 08             	mov    0x8(%ebp),%eax
  803920:	8b 40 08             	mov    0x8(%eax),%eax
  803923:	39 c2                	cmp    %eax,%edx
  803925:	0f 85 90 00 00 00    	jne    8039bb <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80392b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80392e:	8b 50 0c             	mov    0xc(%eax),%edx
  803931:	8b 45 08             	mov    0x8(%ebp),%eax
  803934:	8b 40 0c             	mov    0xc(%eax),%eax
  803937:	01 c2                	add    %eax,%edx
  803939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80393c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80393f:	8b 45 08             	mov    0x8(%ebp),%eax
  803942:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803949:	8b 45 08             	mov    0x8(%ebp),%eax
  80394c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803953:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803957:	75 17                	jne    803970 <insert_sorted_with_merge_freeList+0x243>
  803959:	83 ec 04             	sub    $0x4,%esp
  80395c:	68 a4 4a 80 00       	push   $0x804aa4
  803961:	68 49 01 00 00       	push   $0x149
  803966:	68 c7 4a 80 00       	push   $0x804ac7
  80396b:	e8 83 d4 ff ff       	call   800df3 <_panic>
  803970:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803976:	8b 45 08             	mov    0x8(%ebp),%eax
  803979:	89 10                	mov    %edx,(%eax)
  80397b:	8b 45 08             	mov    0x8(%ebp),%eax
  80397e:	8b 00                	mov    (%eax),%eax
  803980:	85 c0                	test   %eax,%eax
  803982:	74 0d                	je     803991 <insert_sorted_with_merge_freeList+0x264>
  803984:	a1 48 51 80 00       	mov    0x805148,%eax
  803989:	8b 55 08             	mov    0x8(%ebp),%edx
  80398c:	89 50 04             	mov    %edx,0x4(%eax)
  80398f:	eb 08                	jmp    803999 <insert_sorted_with_merge_freeList+0x26c>
  803991:	8b 45 08             	mov    0x8(%ebp),%eax
  803994:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803999:	8b 45 08             	mov    0x8(%ebp),%eax
  80399c:	a3 48 51 80 00       	mov    %eax,0x805148
  8039a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8039b0:	40                   	inc    %eax
  8039b1:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039b6:	e9 bb 04 00 00       	jmp    803e76 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8039bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039bf:	75 17                	jne    8039d8 <insert_sorted_with_merge_freeList+0x2ab>
  8039c1:	83 ec 04             	sub    $0x4,%esp
  8039c4:	68 18 4b 80 00       	push   $0x804b18
  8039c9:	68 4c 01 00 00       	push   $0x14c
  8039ce:	68 c7 4a 80 00       	push   $0x804ac7
  8039d3:	e8 1b d4 ff ff       	call   800df3 <_panic>
  8039d8:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8039de:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e1:	89 50 04             	mov    %edx,0x4(%eax)
  8039e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e7:	8b 40 04             	mov    0x4(%eax),%eax
  8039ea:	85 c0                	test   %eax,%eax
  8039ec:	74 0c                	je     8039fa <insert_sorted_with_merge_freeList+0x2cd>
  8039ee:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8039f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8039f6:	89 10                	mov    %edx,(%eax)
  8039f8:	eb 08                	jmp    803a02 <insert_sorted_with_merge_freeList+0x2d5>
  8039fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fd:	a3 38 51 80 00       	mov    %eax,0x805138
  803a02:	8b 45 08             	mov    0x8(%ebp),%eax
  803a05:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a13:	a1 44 51 80 00       	mov    0x805144,%eax
  803a18:	40                   	inc    %eax
  803a19:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a1e:	e9 53 04 00 00       	jmp    803e76 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a23:	a1 38 51 80 00       	mov    0x805138,%eax
  803a28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a2b:	e9 15 04 00 00       	jmp    803e45 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a33:	8b 00                	mov    (%eax),%eax
  803a35:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803a38:	8b 45 08             	mov    0x8(%ebp),%eax
  803a3b:	8b 50 08             	mov    0x8(%eax),%edx
  803a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a41:	8b 40 08             	mov    0x8(%eax),%eax
  803a44:	39 c2                	cmp    %eax,%edx
  803a46:	0f 86 f1 03 00 00    	jbe    803e3d <insert_sorted_with_merge_freeList+0x710>
  803a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4f:	8b 50 08             	mov    0x8(%eax),%edx
  803a52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a55:	8b 40 08             	mov    0x8(%eax),%eax
  803a58:	39 c2                	cmp    %eax,%edx
  803a5a:	0f 83 dd 03 00 00    	jae    803e3d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a63:	8b 50 08             	mov    0x8(%eax),%edx
  803a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a69:	8b 40 0c             	mov    0xc(%eax),%eax
  803a6c:	01 c2                	add    %eax,%edx
  803a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a71:	8b 40 08             	mov    0x8(%eax),%eax
  803a74:	39 c2                	cmp    %eax,%edx
  803a76:	0f 85 b9 01 00 00    	jne    803c35 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7f:	8b 50 08             	mov    0x8(%eax),%edx
  803a82:	8b 45 08             	mov    0x8(%ebp),%eax
  803a85:	8b 40 0c             	mov    0xc(%eax),%eax
  803a88:	01 c2                	add    %eax,%edx
  803a8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a8d:	8b 40 08             	mov    0x8(%eax),%eax
  803a90:	39 c2                	cmp    %eax,%edx
  803a92:	0f 85 0d 01 00 00    	jne    803ba5 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9b:	8b 50 0c             	mov    0xc(%eax),%edx
  803a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa1:	8b 40 0c             	mov    0xc(%eax),%eax
  803aa4:	01 c2                	add    %eax,%edx
  803aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa9:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803aac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ab0:	75 17                	jne    803ac9 <insert_sorted_with_merge_freeList+0x39c>
  803ab2:	83 ec 04             	sub    $0x4,%esp
  803ab5:	68 70 4b 80 00       	push   $0x804b70
  803aba:	68 5c 01 00 00       	push   $0x15c
  803abf:	68 c7 4a 80 00       	push   $0x804ac7
  803ac4:	e8 2a d3 ff ff       	call   800df3 <_panic>
  803ac9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803acc:	8b 00                	mov    (%eax),%eax
  803ace:	85 c0                	test   %eax,%eax
  803ad0:	74 10                	je     803ae2 <insert_sorted_with_merge_freeList+0x3b5>
  803ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ad5:	8b 00                	mov    (%eax),%eax
  803ad7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ada:	8b 52 04             	mov    0x4(%edx),%edx
  803add:	89 50 04             	mov    %edx,0x4(%eax)
  803ae0:	eb 0b                	jmp    803aed <insert_sorted_with_merge_freeList+0x3c0>
  803ae2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae5:	8b 40 04             	mov    0x4(%eax),%eax
  803ae8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803aed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af0:	8b 40 04             	mov    0x4(%eax),%eax
  803af3:	85 c0                	test   %eax,%eax
  803af5:	74 0f                	je     803b06 <insert_sorted_with_merge_freeList+0x3d9>
  803af7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803afa:	8b 40 04             	mov    0x4(%eax),%eax
  803afd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b00:	8b 12                	mov    (%edx),%edx
  803b02:	89 10                	mov    %edx,(%eax)
  803b04:	eb 0a                	jmp    803b10 <insert_sorted_with_merge_freeList+0x3e3>
  803b06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b09:	8b 00                	mov    (%eax),%eax
  803b0b:	a3 38 51 80 00       	mov    %eax,0x805138
  803b10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b23:	a1 44 51 80 00       	mov    0x805144,%eax
  803b28:	48                   	dec    %eax
  803b29:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803b38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b3b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803b42:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b46:	75 17                	jne    803b5f <insert_sorted_with_merge_freeList+0x432>
  803b48:	83 ec 04             	sub    $0x4,%esp
  803b4b:	68 a4 4a 80 00       	push   $0x804aa4
  803b50:	68 5f 01 00 00       	push   $0x15f
  803b55:	68 c7 4a 80 00       	push   $0x804ac7
  803b5a:	e8 94 d2 ff ff       	call   800df3 <_panic>
  803b5f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b68:	89 10                	mov    %edx,(%eax)
  803b6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6d:	8b 00                	mov    (%eax),%eax
  803b6f:	85 c0                	test   %eax,%eax
  803b71:	74 0d                	je     803b80 <insert_sorted_with_merge_freeList+0x453>
  803b73:	a1 48 51 80 00       	mov    0x805148,%eax
  803b78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b7b:	89 50 04             	mov    %edx,0x4(%eax)
  803b7e:	eb 08                	jmp    803b88 <insert_sorted_with_merge_freeList+0x45b>
  803b80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b83:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b8b:	a3 48 51 80 00       	mov    %eax,0x805148
  803b90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b9a:	a1 54 51 80 00       	mov    0x805154,%eax
  803b9f:	40                   	inc    %eax
  803ba0:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba8:	8b 50 0c             	mov    0xc(%eax),%edx
  803bab:	8b 45 08             	mov    0x8(%ebp),%eax
  803bae:	8b 40 0c             	mov    0xc(%eax),%eax
  803bb1:	01 c2                	add    %eax,%edx
  803bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb6:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803bcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bd1:	75 17                	jne    803bea <insert_sorted_with_merge_freeList+0x4bd>
  803bd3:	83 ec 04             	sub    $0x4,%esp
  803bd6:	68 a4 4a 80 00       	push   $0x804aa4
  803bdb:	68 64 01 00 00       	push   $0x164
  803be0:	68 c7 4a 80 00       	push   $0x804ac7
  803be5:	e8 09 d2 ff ff       	call   800df3 <_panic>
  803bea:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf3:	89 10                	mov    %edx,(%eax)
  803bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf8:	8b 00                	mov    (%eax),%eax
  803bfa:	85 c0                	test   %eax,%eax
  803bfc:	74 0d                	je     803c0b <insert_sorted_with_merge_freeList+0x4de>
  803bfe:	a1 48 51 80 00       	mov    0x805148,%eax
  803c03:	8b 55 08             	mov    0x8(%ebp),%edx
  803c06:	89 50 04             	mov    %edx,0x4(%eax)
  803c09:	eb 08                	jmp    803c13 <insert_sorted_with_merge_freeList+0x4e6>
  803c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c13:	8b 45 08             	mov    0x8(%ebp),%eax
  803c16:	a3 48 51 80 00       	mov    %eax,0x805148
  803c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c25:	a1 54 51 80 00       	mov    0x805154,%eax
  803c2a:	40                   	inc    %eax
  803c2b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c30:	e9 41 02 00 00       	jmp    803e76 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803c35:	8b 45 08             	mov    0x8(%ebp),%eax
  803c38:	8b 50 08             	mov    0x8(%eax),%edx
  803c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3e:	8b 40 0c             	mov    0xc(%eax),%eax
  803c41:	01 c2                	add    %eax,%edx
  803c43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c46:	8b 40 08             	mov    0x8(%eax),%eax
  803c49:	39 c2                	cmp    %eax,%edx
  803c4b:	0f 85 7c 01 00 00    	jne    803dcd <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803c51:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c55:	74 06                	je     803c5d <insert_sorted_with_merge_freeList+0x530>
  803c57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c5b:	75 17                	jne    803c74 <insert_sorted_with_merge_freeList+0x547>
  803c5d:	83 ec 04             	sub    $0x4,%esp
  803c60:	68 e0 4a 80 00       	push   $0x804ae0
  803c65:	68 69 01 00 00       	push   $0x169
  803c6a:	68 c7 4a 80 00       	push   $0x804ac7
  803c6f:	e8 7f d1 ff ff       	call   800df3 <_panic>
  803c74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c77:	8b 50 04             	mov    0x4(%eax),%edx
  803c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c7d:	89 50 04             	mov    %edx,0x4(%eax)
  803c80:	8b 45 08             	mov    0x8(%ebp),%eax
  803c83:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c86:	89 10                	mov    %edx,(%eax)
  803c88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c8b:	8b 40 04             	mov    0x4(%eax),%eax
  803c8e:	85 c0                	test   %eax,%eax
  803c90:	74 0d                	je     803c9f <insert_sorted_with_merge_freeList+0x572>
  803c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c95:	8b 40 04             	mov    0x4(%eax),%eax
  803c98:	8b 55 08             	mov    0x8(%ebp),%edx
  803c9b:	89 10                	mov    %edx,(%eax)
  803c9d:	eb 08                	jmp    803ca7 <insert_sorted_with_merge_freeList+0x57a>
  803c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca2:	a3 38 51 80 00       	mov    %eax,0x805138
  803ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803caa:	8b 55 08             	mov    0x8(%ebp),%edx
  803cad:	89 50 04             	mov    %edx,0x4(%eax)
  803cb0:	a1 44 51 80 00       	mov    0x805144,%eax
  803cb5:	40                   	inc    %eax
  803cb6:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  803cbe:	8b 50 0c             	mov    0xc(%eax),%edx
  803cc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc4:	8b 40 0c             	mov    0xc(%eax),%eax
  803cc7:	01 c2                	add    %eax,%edx
  803cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  803ccc:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803ccf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803cd3:	75 17                	jne    803cec <insert_sorted_with_merge_freeList+0x5bf>
  803cd5:	83 ec 04             	sub    $0x4,%esp
  803cd8:	68 70 4b 80 00       	push   $0x804b70
  803cdd:	68 6b 01 00 00       	push   $0x16b
  803ce2:	68 c7 4a 80 00       	push   $0x804ac7
  803ce7:	e8 07 d1 ff ff       	call   800df3 <_panic>
  803cec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cef:	8b 00                	mov    (%eax),%eax
  803cf1:	85 c0                	test   %eax,%eax
  803cf3:	74 10                	je     803d05 <insert_sorted_with_merge_freeList+0x5d8>
  803cf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf8:	8b 00                	mov    (%eax),%eax
  803cfa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cfd:	8b 52 04             	mov    0x4(%edx),%edx
  803d00:	89 50 04             	mov    %edx,0x4(%eax)
  803d03:	eb 0b                	jmp    803d10 <insert_sorted_with_merge_freeList+0x5e3>
  803d05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d08:	8b 40 04             	mov    0x4(%eax),%eax
  803d0b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803d10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d13:	8b 40 04             	mov    0x4(%eax),%eax
  803d16:	85 c0                	test   %eax,%eax
  803d18:	74 0f                	je     803d29 <insert_sorted_with_merge_freeList+0x5fc>
  803d1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d1d:	8b 40 04             	mov    0x4(%eax),%eax
  803d20:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d23:	8b 12                	mov    (%edx),%edx
  803d25:	89 10                	mov    %edx,(%eax)
  803d27:	eb 0a                	jmp    803d33 <insert_sorted_with_merge_freeList+0x606>
  803d29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d2c:	8b 00                	mov    (%eax),%eax
  803d2e:	a3 38 51 80 00       	mov    %eax,0x805138
  803d33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d46:	a1 44 51 80 00       	mov    0x805144,%eax
  803d4b:	48                   	dec    %eax
  803d4c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803d51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803d5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d5e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803d65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d69:	75 17                	jne    803d82 <insert_sorted_with_merge_freeList+0x655>
  803d6b:	83 ec 04             	sub    $0x4,%esp
  803d6e:	68 a4 4a 80 00       	push   $0x804aa4
  803d73:	68 6e 01 00 00       	push   $0x16e
  803d78:	68 c7 4a 80 00       	push   $0x804ac7
  803d7d:	e8 71 d0 ff ff       	call   800df3 <_panic>
  803d82:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d8b:	89 10                	mov    %edx,(%eax)
  803d8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d90:	8b 00                	mov    (%eax),%eax
  803d92:	85 c0                	test   %eax,%eax
  803d94:	74 0d                	je     803da3 <insert_sorted_with_merge_freeList+0x676>
  803d96:	a1 48 51 80 00       	mov    0x805148,%eax
  803d9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d9e:	89 50 04             	mov    %edx,0x4(%eax)
  803da1:	eb 08                	jmp    803dab <insert_sorted_with_merge_freeList+0x67e>
  803da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803da6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803dab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dae:	a3 48 51 80 00       	mov    %eax,0x805148
  803db3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803db6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dbd:	a1 54 51 80 00       	mov    0x805154,%eax
  803dc2:	40                   	inc    %eax
  803dc3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803dc8:	e9 a9 00 00 00       	jmp    803e76 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803dcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dd1:	74 06                	je     803dd9 <insert_sorted_with_merge_freeList+0x6ac>
  803dd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803dd7:	75 17                	jne    803df0 <insert_sorted_with_merge_freeList+0x6c3>
  803dd9:	83 ec 04             	sub    $0x4,%esp
  803ddc:	68 3c 4b 80 00       	push   $0x804b3c
  803de1:	68 73 01 00 00       	push   $0x173
  803de6:	68 c7 4a 80 00       	push   $0x804ac7
  803deb:	e8 03 d0 ff ff       	call   800df3 <_panic>
  803df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803df3:	8b 10                	mov    (%eax),%edx
  803df5:	8b 45 08             	mov    0x8(%ebp),%eax
  803df8:	89 10                	mov    %edx,(%eax)
  803dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  803dfd:	8b 00                	mov    (%eax),%eax
  803dff:	85 c0                	test   %eax,%eax
  803e01:	74 0b                	je     803e0e <insert_sorted_with_merge_freeList+0x6e1>
  803e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e06:	8b 00                	mov    (%eax),%eax
  803e08:	8b 55 08             	mov    0x8(%ebp),%edx
  803e0b:	89 50 04             	mov    %edx,0x4(%eax)
  803e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e11:	8b 55 08             	mov    0x8(%ebp),%edx
  803e14:	89 10                	mov    %edx,(%eax)
  803e16:	8b 45 08             	mov    0x8(%ebp),%eax
  803e19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e1c:	89 50 04             	mov    %edx,0x4(%eax)
  803e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e22:	8b 00                	mov    (%eax),%eax
  803e24:	85 c0                	test   %eax,%eax
  803e26:	75 08                	jne    803e30 <insert_sorted_with_merge_freeList+0x703>
  803e28:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803e30:	a1 44 51 80 00       	mov    0x805144,%eax
  803e35:	40                   	inc    %eax
  803e36:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803e3b:	eb 39                	jmp    803e76 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803e3d:	a1 40 51 80 00       	mov    0x805140,%eax
  803e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e49:	74 07                	je     803e52 <insert_sorted_with_merge_freeList+0x725>
  803e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e4e:	8b 00                	mov    (%eax),%eax
  803e50:	eb 05                	jmp    803e57 <insert_sorted_with_merge_freeList+0x72a>
  803e52:	b8 00 00 00 00       	mov    $0x0,%eax
  803e57:	a3 40 51 80 00       	mov    %eax,0x805140
  803e5c:	a1 40 51 80 00       	mov    0x805140,%eax
  803e61:	85 c0                	test   %eax,%eax
  803e63:	0f 85 c7 fb ff ff    	jne    803a30 <insert_sorted_with_merge_freeList+0x303>
  803e69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e6d:	0f 85 bd fb ff ff    	jne    803a30 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e73:	eb 01                	jmp    803e76 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803e75:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e76:	90                   	nop
  803e77:	c9                   	leave  
  803e78:	c3                   	ret    
  803e79:	66 90                	xchg   %ax,%ax
  803e7b:	90                   	nop

00803e7c <__udivdi3>:
  803e7c:	55                   	push   %ebp
  803e7d:	57                   	push   %edi
  803e7e:	56                   	push   %esi
  803e7f:	53                   	push   %ebx
  803e80:	83 ec 1c             	sub    $0x1c,%esp
  803e83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e93:	89 ca                	mov    %ecx,%edx
  803e95:	89 f8                	mov    %edi,%eax
  803e97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e9b:	85 f6                	test   %esi,%esi
  803e9d:	75 2d                	jne    803ecc <__udivdi3+0x50>
  803e9f:	39 cf                	cmp    %ecx,%edi
  803ea1:	77 65                	ja     803f08 <__udivdi3+0x8c>
  803ea3:	89 fd                	mov    %edi,%ebp
  803ea5:	85 ff                	test   %edi,%edi
  803ea7:	75 0b                	jne    803eb4 <__udivdi3+0x38>
  803ea9:	b8 01 00 00 00       	mov    $0x1,%eax
  803eae:	31 d2                	xor    %edx,%edx
  803eb0:	f7 f7                	div    %edi
  803eb2:	89 c5                	mov    %eax,%ebp
  803eb4:	31 d2                	xor    %edx,%edx
  803eb6:	89 c8                	mov    %ecx,%eax
  803eb8:	f7 f5                	div    %ebp
  803eba:	89 c1                	mov    %eax,%ecx
  803ebc:	89 d8                	mov    %ebx,%eax
  803ebe:	f7 f5                	div    %ebp
  803ec0:	89 cf                	mov    %ecx,%edi
  803ec2:	89 fa                	mov    %edi,%edx
  803ec4:	83 c4 1c             	add    $0x1c,%esp
  803ec7:	5b                   	pop    %ebx
  803ec8:	5e                   	pop    %esi
  803ec9:	5f                   	pop    %edi
  803eca:	5d                   	pop    %ebp
  803ecb:	c3                   	ret    
  803ecc:	39 ce                	cmp    %ecx,%esi
  803ece:	77 28                	ja     803ef8 <__udivdi3+0x7c>
  803ed0:	0f bd fe             	bsr    %esi,%edi
  803ed3:	83 f7 1f             	xor    $0x1f,%edi
  803ed6:	75 40                	jne    803f18 <__udivdi3+0x9c>
  803ed8:	39 ce                	cmp    %ecx,%esi
  803eda:	72 0a                	jb     803ee6 <__udivdi3+0x6a>
  803edc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ee0:	0f 87 9e 00 00 00    	ja     803f84 <__udivdi3+0x108>
  803ee6:	b8 01 00 00 00       	mov    $0x1,%eax
  803eeb:	89 fa                	mov    %edi,%edx
  803eed:	83 c4 1c             	add    $0x1c,%esp
  803ef0:	5b                   	pop    %ebx
  803ef1:	5e                   	pop    %esi
  803ef2:	5f                   	pop    %edi
  803ef3:	5d                   	pop    %ebp
  803ef4:	c3                   	ret    
  803ef5:	8d 76 00             	lea    0x0(%esi),%esi
  803ef8:	31 ff                	xor    %edi,%edi
  803efa:	31 c0                	xor    %eax,%eax
  803efc:	89 fa                	mov    %edi,%edx
  803efe:	83 c4 1c             	add    $0x1c,%esp
  803f01:	5b                   	pop    %ebx
  803f02:	5e                   	pop    %esi
  803f03:	5f                   	pop    %edi
  803f04:	5d                   	pop    %ebp
  803f05:	c3                   	ret    
  803f06:	66 90                	xchg   %ax,%ax
  803f08:	89 d8                	mov    %ebx,%eax
  803f0a:	f7 f7                	div    %edi
  803f0c:	31 ff                	xor    %edi,%edi
  803f0e:	89 fa                	mov    %edi,%edx
  803f10:	83 c4 1c             	add    $0x1c,%esp
  803f13:	5b                   	pop    %ebx
  803f14:	5e                   	pop    %esi
  803f15:	5f                   	pop    %edi
  803f16:	5d                   	pop    %ebp
  803f17:	c3                   	ret    
  803f18:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f1d:	89 eb                	mov    %ebp,%ebx
  803f1f:	29 fb                	sub    %edi,%ebx
  803f21:	89 f9                	mov    %edi,%ecx
  803f23:	d3 e6                	shl    %cl,%esi
  803f25:	89 c5                	mov    %eax,%ebp
  803f27:	88 d9                	mov    %bl,%cl
  803f29:	d3 ed                	shr    %cl,%ebp
  803f2b:	89 e9                	mov    %ebp,%ecx
  803f2d:	09 f1                	or     %esi,%ecx
  803f2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f33:	89 f9                	mov    %edi,%ecx
  803f35:	d3 e0                	shl    %cl,%eax
  803f37:	89 c5                	mov    %eax,%ebp
  803f39:	89 d6                	mov    %edx,%esi
  803f3b:	88 d9                	mov    %bl,%cl
  803f3d:	d3 ee                	shr    %cl,%esi
  803f3f:	89 f9                	mov    %edi,%ecx
  803f41:	d3 e2                	shl    %cl,%edx
  803f43:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f47:	88 d9                	mov    %bl,%cl
  803f49:	d3 e8                	shr    %cl,%eax
  803f4b:	09 c2                	or     %eax,%edx
  803f4d:	89 d0                	mov    %edx,%eax
  803f4f:	89 f2                	mov    %esi,%edx
  803f51:	f7 74 24 0c          	divl   0xc(%esp)
  803f55:	89 d6                	mov    %edx,%esi
  803f57:	89 c3                	mov    %eax,%ebx
  803f59:	f7 e5                	mul    %ebp
  803f5b:	39 d6                	cmp    %edx,%esi
  803f5d:	72 19                	jb     803f78 <__udivdi3+0xfc>
  803f5f:	74 0b                	je     803f6c <__udivdi3+0xf0>
  803f61:	89 d8                	mov    %ebx,%eax
  803f63:	31 ff                	xor    %edi,%edi
  803f65:	e9 58 ff ff ff       	jmp    803ec2 <__udivdi3+0x46>
  803f6a:	66 90                	xchg   %ax,%ax
  803f6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f70:	89 f9                	mov    %edi,%ecx
  803f72:	d3 e2                	shl    %cl,%edx
  803f74:	39 c2                	cmp    %eax,%edx
  803f76:	73 e9                	jae    803f61 <__udivdi3+0xe5>
  803f78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f7b:	31 ff                	xor    %edi,%edi
  803f7d:	e9 40 ff ff ff       	jmp    803ec2 <__udivdi3+0x46>
  803f82:	66 90                	xchg   %ax,%ax
  803f84:	31 c0                	xor    %eax,%eax
  803f86:	e9 37 ff ff ff       	jmp    803ec2 <__udivdi3+0x46>
  803f8b:	90                   	nop

00803f8c <__umoddi3>:
  803f8c:	55                   	push   %ebp
  803f8d:	57                   	push   %edi
  803f8e:	56                   	push   %esi
  803f8f:	53                   	push   %ebx
  803f90:	83 ec 1c             	sub    $0x1c,%esp
  803f93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f97:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803fa3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803fa7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fab:	89 f3                	mov    %esi,%ebx
  803fad:	89 fa                	mov    %edi,%edx
  803faf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fb3:	89 34 24             	mov    %esi,(%esp)
  803fb6:	85 c0                	test   %eax,%eax
  803fb8:	75 1a                	jne    803fd4 <__umoddi3+0x48>
  803fba:	39 f7                	cmp    %esi,%edi
  803fbc:	0f 86 a2 00 00 00    	jbe    804064 <__umoddi3+0xd8>
  803fc2:	89 c8                	mov    %ecx,%eax
  803fc4:	89 f2                	mov    %esi,%edx
  803fc6:	f7 f7                	div    %edi
  803fc8:	89 d0                	mov    %edx,%eax
  803fca:	31 d2                	xor    %edx,%edx
  803fcc:	83 c4 1c             	add    $0x1c,%esp
  803fcf:	5b                   	pop    %ebx
  803fd0:	5e                   	pop    %esi
  803fd1:	5f                   	pop    %edi
  803fd2:	5d                   	pop    %ebp
  803fd3:	c3                   	ret    
  803fd4:	39 f0                	cmp    %esi,%eax
  803fd6:	0f 87 ac 00 00 00    	ja     804088 <__umoddi3+0xfc>
  803fdc:	0f bd e8             	bsr    %eax,%ebp
  803fdf:	83 f5 1f             	xor    $0x1f,%ebp
  803fe2:	0f 84 ac 00 00 00    	je     804094 <__umoddi3+0x108>
  803fe8:	bf 20 00 00 00       	mov    $0x20,%edi
  803fed:	29 ef                	sub    %ebp,%edi
  803fef:	89 fe                	mov    %edi,%esi
  803ff1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ff5:	89 e9                	mov    %ebp,%ecx
  803ff7:	d3 e0                	shl    %cl,%eax
  803ff9:	89 d7                	mov    %edx,%edi
  803ffb:	89 f1                	mov    %esi,%ecx
  803ffd:	d3 ef                	shr    %cl,%edi
  803fff:	09 c7                	or     %eax,%edi
  804001:	89 e9                	mov    %ebp,%ecx
  804003:	d3 e2                	shl    %cl,%edx
  804005:	89 14 24             	mov    %edx,(%esp)
  804008:	89 d8                	mov    %ebx,%eax
  80400a:	d3 e0                	shl    %cl,%eax
  80400c:	89 c2                	mov    %eax,%edx
  80400e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804012:	d3 e0                	shl    %cl,%eax
  804014:	89 44 24 04          	mov    %eax,0x4(%esp)
  804018:	8b 44 24 08          	mov    0x8(%esp),%eax
  80401c:	89 f1                	mov    %esi,%ecx
  80401e:	d3 e8                	shr    %cl,%eax
  804020:	09 d0                	or     %edx,%eax
  804022:	d3 eb                	shr    %cl,%ebx
  804024:	89 da                	mov    %ebx,%edx
  804026:	f7 f7                	div    %edi
  804028:	89 d3                	mov    %edx,%ebx
  80402a:	f7 24 24             	mull   (%esp)
  80402d:	89 c6                	mov    %eax,%esi
  80402f:	89 d1                	mov    %edx,%ecx
  804031:	39 d3                	cmp    %edx,%ebx
  804033:	0f 82 87 00 00 00    	jb     8040c0 <__umoddi3+0x134>
  804039:	0f 84 91 00 00 00    	je     8040d0 <__umoddi3+0x144>
  80403f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804043:	29 f2                	sub    %esi,%edx
  804045:	19 cb                	sbb    %ecx,%ebx
  804047:	89 d8                	mov    %ebx,%eax
  804049:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80404d:	d3 e0                	shl    %cl,%eax
  80404f:	89 e9                	mov    %ebp,%ecx
  804051:	d3 ea                	shr    %cl,%edx
  804053:	09 d0                	or     %edx,%eax
  804055:	89 e9                	mov    %ebp,%ecx
  804057:	d3 eb                	shr    %cl,%ebx
  804059:	89 da                	mov    %ebx,%edx
  80405b:	83 c4 1c             	add    $0x1c,%esp
  80405e:	5b                   	pop    %ebx
  80405f:	5e                   	pop    %esi
  804060:	5f                   	pop    %edi
  804061:	5d                   	pop    %ebp
  804062:	c3                   	ret    
  804063:	90                   	nop
  804064:	89 fd                	mov    %edi,%ebp
  804066:	85 ff                	test   %edi,%edi
  804068:	75 0b                	jne    804075 <__umoddi3+0xe9>
  80406a:	b8 01 00 00 00       	mov    $0x1,%eax
  80406f:	31 d2                	xor    %edx,%edx
  804071:	f7 f7                	div    %edi
  804073:	89 c5                	mov    %eax,%ebp
  804075:	89 f0                	mov    %esi,%eax
  804077:	31 d2                	xor    %edx,%edx
  804079:	f7 f5                	div    %ebp
  80407b:	89 c8                	mov    %ecx,%eax
  80407d:	f7 f5                	div    %ebp
  80407f:	89 d0                	mov    %edx,%eax
  804081:	e9 44 ff ff ff       	jmp    803fca <__umoddi3+0x3e>
  804086:	66 90                	xchg   %ax,%ax
  804088:	89 c8                	mov    %ecx,%eax
  80408a:	89 f2                	mov    %esi,%edx
  80408c:	83 c4 1c             	add    $0x1c,%esp
  80408f:	5b                   	pop    %ebx
  804090:	5e                   	pop    %esi
  804091:	5f                   	pop    %edi
  804092:	5d                   	pop    %ebp
  804093:	c3                   	ret    
  804094:	3b 04 24             	cmp    (%esp),%eax
  804097:	72 06                	jb     80409f <__umoddi3+0x113>
  804099:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80409d:	77 0f                	ja     8040ae <__umoddi3+0x122>
  80409f:	89 f2                	mov    %esi,%edx
  8040a1:	29 f9                	sub    %edi,%ecx
  8040a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040a7:	89 14 24             	mov    %edx,(%esp)
  8040aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040b2:	8b 14 24             	mov    (%esp),%edx
  8040b5:	83 c4 1c             	add    $0x1c,%esp
  8040b8:	5b                   	pop    %ebx
  8040b9:	5e                   	pop    %esi
  8040ba:	5f                   	pop    %edi
  8040bb:	5d                   	pop    %ebp
  8040bc:	c3                   	ret    
  8040bd:	8d 76 00             	lea    0x0(%esi),%esi
  8040c0:	2b 04 24             	sub    (%esp),%eax
  8040c3:	19 fa                	sbb    %edi,%edx
  8040c5:	89 d1                	mov    %edx,%ecx
  8040c7:	89 c6                	mov    %eax,%esi
  8040c9:	e9 71 ff ff ff       	jmp    80403f <__umoddi3+0xb3>
  8040ce:	66 90                	xchg   %ax,%ax
  8040d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040d4:	72 ea                	jb     8040c0 <__umoddi3+0x134>
  8040d6:	89 d9                	mov    %ebx,%ecx
  8040d8:	e9 62 ff ff ff       	jmp    80403f <__umoddi3+0xb3>
