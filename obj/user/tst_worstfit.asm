
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
  800048:	e8 5e 28 00 00       	call   8028ab <sys_set_uheap_strategy>
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
  80009e:	68 c0 41 80 00       	push   $0x8041c0
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 dc 41 80 00       	push   $0x8041dc
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
  8000f7:	68 f0 41 80 00       	push   $0x8041f0
  8000fc:	68 07 42 80 00       	push   $0x804207
  800101:	6a 24                	push   $0x24
  800103:	68 dc 41 80 00       	push   $0x8041dc
  800108:	e8 e6 0c 00 00       	call   800df3 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 04                	push   $0x4
  800112:	e8 94 27 00 00       	call   8028ab <sys_set_uheap_strategy>
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
  800168:	68 c0 41 80 00       	push   $0x8041c0
  80016d:	6a 36                	push   $0x36
  80016f:	68 dc 41 80 00       	push   $0x8041dc
  800174:	e8 7a 0c 00 00       	call   800df3 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 75 cc             	pushl  -0x34(%ebp)
  80017f:	68 1c 42 80 00       	push   $0x80421c
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
  8001ea:	68 68 42 80 00       	push   $0x804268
  8001ef:	6a 48                	push   $0x48
  8001f1:	68 dc 41 80 00       	push   $0x8041dc
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
  80020f:	e8 82 21 00 00       	call   802396 <sys_calculate_free_frames>
  800214:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800217:	e8 1a 22 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  8002af:	68 b8 42 80 00       	push   $0x8042b8
  8002b4:	6a 5d                	push   $0x5d
  8002b6:	68 dc 41 80 00       	push   $0x8041dc
  8002bb:	e8 33 0b 00 00       	call   800df3 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002c0:	e8 71 21 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  8002e3:	68 f6 42 80 00       	push   $0x8042f6
  8002e8:	6a 5f                	push   $0x5f
  8002ea:	68 dc 41 80 00       	push   $0x8041dc
  8002ef:	e8 ff 0a 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002f7:	e8 9a 20 00 00       	call   802396 <sys_calculate_free_frames>
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
  800319:	68 13 43 80 00       	push   $0x804313
  80031e:	6a 60                	push   $0x60
  800320:	68 dc 41 80 00       	push   $0x8041dc
  800325:	e8 c9 0a 00 00       	call   800df3 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80032a:	e8 67 20 00 00       	call   802396 <sys_calculate_free_frames>
  80032f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800332:	e8 ff 20 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
  800337:	89 45 bc             	mov    %eax,-0x44(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  80033a:	8b 85 b8 f7 ff ff    	mov    -0x848(%ebp),%eax
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	50                   	push   %eax
  800344:	e8 61 1d 00 00       	call   8020aa <free>
  800349:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  80034c:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800352:	83 ec 0c             	sub    $0xc,%esp
  800355:	50                   	push   %eax
  800356:	e8 4f 1d 00 00       	call   8020aa <free>
  80035b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035e:	8b 85 c4 f7 ff ff    	mov    -0x83c(%ebp),%eax
  800364:	83 ec 0c             	sub    $0xc,%esp
  800367:	50                   	push   %eax
  800368:	e8 3d 1d 00 00       	call   8020aa <free>
  80036d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 3 = 6 M
  800370:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	50                   	push   %eax
  80037a:	e8 2b 1d 00 00       	call   8020aa <free>
  80037f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800382:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	50                   	push   %eax
  80038c:	e8 19 1d 00 00       	call   8020aa <free>
  800391:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  800394:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	50                   	push   %eax
  80039e:	e8 07 1d 00 00       	call   8020aa <free>
  8003a3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[100]);		// Hole 4 = 10 M
  8003a6:	8b 85 48 f9 ff ff    	mov    -0x6b8(%ebp),%eax
  8003ac:	83 ec 0c             	sub    $0xc,%esp
  8003af:	50                   	push   %eax
  8003b0:	e8 f5 1c 00 00       	call   8020aa <free>
  8003b5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[104]);
  8003b8:	8b 85 58 f9 ff ff    	mov    -0x6a8(%ebp),%eax
  8003be:	83 ec 0c             	sub    $0xc,%esp
  8003c1:	50                   	push   %eax
  8003c2:	e8 e3 1c 00 00       	call   8020aa <free>
  8003c7:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[103]);
  8003ca:	8b 85 54 f9 ff ff    	mov    -0x6ac(%ebp),%eax
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	50                   	push   %eax
  8003d4:	e8 d1 1c 00 00       	call   8020aa <free>
  8003d9:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[102]);
  8003dc:	8b 85 50 f9 ff ff    	mov    -0x6b0(%ebp),%eax
  8003e2:	83 ec 0c             	sub    $0xc,%esp
  8003e5:	50                   	push   %eax
  8003e6:	e8 bf 1c 00 00       	call   8020aa <free>
  8003eb:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[101]);
  8003ee:	8b 85 4c f9 ff ff    	mov    -0x6b4(%ebp),%eax
  8003f4:	83 ec 0c             	sub    $0xc,%esp
  8003f7:	50                   	push   %eax
  8003f8:	e8 ad 1c 00 00       	call   8020aa <free>
  8003fd:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[200]);		// Hole 5 = 8 M
  800400:	8b 85 d8 fa ff ff    	mov    -0x528(%ebp),%eax
  800406:	83 ec 0c             	sub    $0xc,%esp
  800409:	50                   	push   %eax
  80040a:	e8 9b 1c 00 00       	call   8020aa <free>
  80040f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[201]);
  800412:	8b 85 dc fa ff ff    	mov    -0x524(%ebp),%eax
  800418:	83 ec 0c             	sub    $0xc,%esp
  80041b:	50                   	push   %eax
  80041c:	e8 89 1c 00 00       	call   8020aa <free>
  800421:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[202]);
  800424:	8b 85 e0 fa ff ff    	mov    -0x520(%ebp),%eax
  80042a:	83 ec 0c             	sub    $0xc,%esp
  80042d:	50                   	push   %eax
  80042e:	e8 77 1c 00 00       	call   8020aa <free>
  800433:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[203]);
  800436:	8b 85 e4 fa ff ff    	mov    -0x51c(%ebp),%eax
  80043c:	83 ec 0c             	sub    $0xc,%esp
  80043f:	50                   	push   %eax
  800440:	e8 65 1c 00 00       	call   8020aa <free>
  800445:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 15*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800448:	e8 e9 1f 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  80047b:	68 24 43 80 00       	push   $0x804324
  800480:	6a 76                	push   $0x76
  800482:	68 dc 41 80 00       	push   $0x8041dc
  800487:	e8 67 09 00 00       	call   800df3 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80048c:	e8 05 1f 00 00       	call   802396 <sys_calculate_free_frames>
  800491:	89 c2                	mov    %eax,%edx
  800493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 60 43 80 00       	push   $0x804360
  8004a2:	6a 77                	push   $0x77
  8004a4:	68 dc 41 80 00       	push   $0x8041dc
  8004a9:	e8 45 09 00 00       	call   800df3 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8004ae:	e8 e3 1e 00 00       	call   802396 <sys_calculate_free_frames>
  8004b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b6:	e8 7b 1f 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  8004dd:	68 a0 43 80 00       	push   $0x8043a0
  8004e2:	6a 7f                	push   $0x7f
  8004e4:	68 dc 41 80 00       	push   $0x8041dc
  8004e9:	e8 05 09 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004ee:	e8 43 1f 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  80050e:	68 f6 42 80 00       	push   $0x8042f6
  800513:	68 80 00 00 00       	push   $0x80
  800518:	68 dc 41 80 00       	push   $0x8041dc
  80051d:	e8 d1 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800522:	e8 6f 1e 00 00       	call   802396 <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 13 43 80 00       	push   $0x804313
  800538:	68 81 00 00 00       	push   $0x81
  80053d:	68 dc 41 80 00       	push   $0x8041dc
  800542:	e8 ac 08 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800547:	ff 45 d0             	incl   -0x30(%ebp)
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d0             	pushl  -0x30(%ebp)
  800550:	68 c0 43 80 00       	push   $0x8043c0
  800555:	e8 4d 0b 00 00       	call   8010a7 <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 34 1e 00 00       	call   802396 <sys_calculate_free_frames>
  800562:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 cc 1e 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  80058f:	68 a0 43 80 00       	push   $0x8043a0
  800594:	68 88 00 00 00       	push   $0x88
  800599:	68 dc 41 80 00       	push   $0x8041dc
  80059e:	e8 50 08 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005a3:	e8 8e 1e 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  8005c6:	68 f6 42 80 00       	push   $0x8042f6
  8005cb:	68 89 00 00 00       	push   $0x89
  8005d0:	68 dc 41 80 00       	push   $0x8041dc
  8005d5:	e8 19 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005da:	e8 b7 1d 00 00       	call   802396 <sys_calculate_free_frames>
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 17                	je     8005ff <_main+0x5c7>
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 13 43 80 00       	push   $0x804313
  8005f0:	68 8a 00 00 00       	push   $0x8a
  8005f5:	68 dc 41 80 00       	push   $0x8041dc
  8005fa:	e8 f4 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005ff:	ff 45 d0             	incl   -0x30(%ebp)
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 d0             	pushl  -0x30(%ebp)
  800608:	68 c0 43 80 00       	push   $0x8043c0
  80060d:	e8 95 0a 00 00       	call   8010a7 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800615:	e8 7c 1d 00 00       	call   802396 <sys_calculate_free_frames>
  80061a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80061d:	e8 14 1e 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  80064c:	68 a0 43 80 00       	push   $0x8043a0
  800651:	68 91 00 00 00       	push   $0x91
  800656:	68 dc 41 80 00       	push   $0x8041dc
  80065b:	e8 93 07 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800660:	e8 d1 1d 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  800688:	68 f6 42 80 00       	push   $0x8042f6
  80068d:	68 92 00 00 00       	push   $0x92
  800692:	68 dc 41 80 00       	push   $0x8041dc
  800697:	e8 57 07 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069c:	e8 f5 1c 00 00       	call   802396 <sys_calculate_free_frames>
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	74 17                	je     8006c1 <_main+0x689>
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 13 43 80 00       	push   $0x804313
  8006b2:	68 93 00 00 00       	push   $0x93
  8006b7:	68 dc 41 80 00       	push   $0x8041dc
  8006bc:	e8 32 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006c1:	ff 45 d0             	incl   -0x30(%ebp)
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ca:	68 c0 43 80 00       	push   $0x8043c0
  8006cf:	e8 d3 09 00 00       	call   8010a7 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006d7:	e8 ba 1c 00 00       	call   802396 <sys_calculate_free_frames>
  8006dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006df:	e8 52 1d 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  80070d:	68 a0 43 80 00       	push   $0x8043a0
  800712:	68 9a 00 00 00       	push   $0x9a
  800717:	68 dc 41 80 00       	push   $0x8041dc
  80071c:	e8 d2 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800721:	e8 10 1d 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  800748:	68 f6 42 80 00       	push   $0x8042f6
  80074d:	68 9b 00 00 00       	push   $0x9b
  800752:	68 dc 41 80 00       	push   $0x8041dc
  800757:	e8 97 06 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80075c:	e8 35 1c 00 00       	call   802396 <sys_calculate_free_frames>
  800761:	89 c2                	mov    %eax,%edx
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	39 c2                	cmp    %eax,%edx
  800768:	74 17                	je     800781 <_main+0x749>
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 13 43 80 00       	push   $0x804313
  800772:	68 9c 00 00 00       	push   $0x9c
  800777:	68 dc 41 80 00       	push   $0x8041dc
  80077c:	e8 72 06 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800781:	ff 45 d0             	incl   -0x30(%ebp)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d0             	pushl  -0x30(%ebp)
  80078a:	68 c0 43 80 00       	push   $0x8043c0
  80078f:	e8 13 09 00 00       	call   8010a7 <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800797:	e8 fa 1b 00 00       	call   802396 <sys_calculate_free_frames>
  80079c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80079f:	e8 92 1c 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  8007c9:	68 a0 43 80 00       	push   $0x8043a0
  8007ce:	68 a3 00 00 00       	push   $0xa3
  8007d3:	68 dc 41 80 00       	push   $0x8041dc
  8007d8:	e8 16 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007dd:	e8 54 1c 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  800800:	68 f6 42 80 00       	push   $0x8042f6
  800805:	68 a4 00 00 00       	push   $0xa4
  80080a:	68 dc 41 80 00       	push   $0x8041dc
  80080f:	e8 df 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800814:	e8 7d 1b 00 00       	call   802396 <sys_calculate_free_frames>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 17                	je     800839 <_main+0x801>
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 13 43 80 00       	push   $0x804313
  80082a:	68 a5 00 00 00       	push   $0xa5
  80082f:	68 dc 41 80 00       	push   $0x8041dc
  800834:	e8 ba 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800839:	ff 45 d0             	incl   -0x30(%ebp)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 d0             	pushl  -0x30(%ebp)
  800842:	68 c0 43 80 00       	push   $0x8043c0
  800847:	e8 5b 08 00 00       	call   8010a7 <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80084f:	e8 42 1b 00 00       	call   802396 <sys_calculate_free_frames>
  800854:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800857:	e8 da 1b 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  800880:	68 a0 43 80 00       	push   $0x8043a0
  800885:	68 ac 00 00 00       	push   $0xac
  80088a:	68 dc 41 80 00       	push   $0x8041dc
  80088f:	e8 5f 05 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800894:	e8 9d 1b 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  8008b6:	68 f6 42 80 00       	push   $0x8042f6
  8008bb:	68 ad 00 00 00       	push   $0xad
  8008c0:	68 dc 41 80 00       	push   $0x8041dc
  8008c5:	e8 29 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008ca:	e8 c7 1a 00 00       	call   802396 <sys_calculate_free_frames>
  8008cf:	89 c2                	mov    %eax,%edx
  8008d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 17                	je     8008ef <_main+0x8b7>
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 13 43 80 00       	push   $0x804313
  8008e0:	68 ae 00 00 00       	push   $0xae
  8008e5:	68 dc 41 80 00       	push   $0x8041dc
  8008ea:	e8 04 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ef:	ff 45 d0             	incl   -0x30(%ebp)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 d0             	pushl  -0x30(%ebp)
  8008f8:	68 c0 43 80 00       	push   $0x8043c0
  8008fd:	e8 a5 07 00 00       	call   8010a7 <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800905:	e8 8c 1a 00 00       	call   802396 <sys_calculate_free_frames>
  80090a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090d:	e8 24 1b 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  80093e:	68 a0 43 80 00       	push   $0x8043a0
  800943:	68 b5 00 00 00       	push   $0xb5
  800948:	68 dc 41 80 00       	push   $0x8041dc
  80094d:	e8 a1 04 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800952:	e8 df 1a 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  80097c:	68 f6 42 80 00       	push   $0x8042f6
  800981:	68 b6 00 00 00       	push   $0xb6
  800986:	68 dc 41 80 00       	push   $0x8041dc
  80098b:	e8 63 04 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800990:	e8 01 1a 00 00       	call   802396 <sys_calculate_free_frames>
  800995:	89 c2                	mov    %eax,%edx
  800997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 17                	je     8009b5 <_main+0x97d>
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	68 13 43 80 00       	push   $0x804313
  8009a6:	68 b7 00 00 00       	push   $0xb7
  8009ab:	68 dc 41 80 00       	push   $0x8041dc
  8009b0:	e8 3e 04 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009b5:	ff 45 d0             	incl   -0x30(%ebp)
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8009be:	68 c0 43 80 00       	push   $0x8043c0
  8009c3:	e8 df 06 00 00       	call   8010a7 <cprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 c6 19 00 00       	call   802396 <sys_calculate_free_frames>
  8009d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 5e 1a 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  8009fd:	68 a0 43 80 00       	push   $0x8043a0
  800a02:	68 be 00 00 00       	push   $0xbe
  800a07:	68 dc 41 80 00       	push   $0x8041dc
  800a0c:	e8 e2 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a11:	e8 20 1a 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  800a34:	68 f6 42 80 00       	push   $0x8042f6
  800a39:	68 bf 00 00 00       	push   $0xbf
  800a3e:	68 dc 41 80 00       	push   $0x8041dc
  800a43:	e8 ab 03 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a48:	e8 49 19 00 00       	call   802396 <sys_calculate_free_frames>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 17                	je     800a6d <_main+0xa35>
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 13 43 80 00       	push   $0x804313
  800a5e:	68 c0 00 00 00       	push   $0xc0
  800a63:	68 dc 41 80 00       	push   $0x8041dc
  800a68:	e8 86 03 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a6d:	ff 45 d0             	incl   -0x30(%ebp)
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 d0             	pushl  -0x30(%ebp)
  800a76:	68 c0 43 80 00       	push   $0x8043c0
  800a7b:	e8 27 06 00 00       	call   8010a7 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 0e 19 00 00       	call   802396 <sys_calculate_free_frames>
  800a88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 a6 19 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  800ab2:	68 a0 43 80 00       	push   $0x8043a0
  800ab7:	68 c7 00 00 00       	push   $0xc7
  800abc:	68 dc 41 80 00       	push   $0x8041dc
  800ac1:	e8 2d 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800ac6:	e8 6b 19 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  800ae9:	68 f6 42 80 00       	push   $0x8042f6
  800aee:	68 c8 00 00 00       	push   $0xc8
  800af3:	68 dc 41 80 00       	push   $0x8041dc
  800af8:	e8 f6 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800afd:	e8 94 18 00 00       	call   802396 <sys_calculate_free_frames>
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 13 43 80 00       	push   $0x804313
  800b13:	68 c9 00 00 00       	push   $0xc9
  800b18:	68 dc 41 80 00       	push   $0x8041dc
  800b1d:	e8 d1 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b22:	ff 45 d0             	incl   -0x30(%ebp)
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 d0             	pushl  -0x30(%ebp)
  800b2b:	68 c0 43 80 00       	push   $0x8043c0
  800b30:	e8 72 05 00 00       	call   8010a7 <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800b38:	e8 59 18 00 00       	call   802396 <sys_calculate_free_frames>
  800b3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b40:	e8 f1 18 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  800b72:	68 a0 43 80 00       	push   $0x8043a0
  800b77:	68 d0 00 00 00       	push   $0xd0
  800b7c:	68 dc 41 80 00       	push   $0x8041dc
  800b81:	e8 6d 02 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800b86:	e8 ab 18 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  800bb1:	68 f6 42 80 00       	push   $0x8042f6
  800bb6:	68 d1 00 00 00       	push   $0xd1
  800bbb:	68 dc 41 80 00       	push   $0x8041dc
  800bc0:	e8 2e 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bc5:	e8 cc 17 00 00       	call   802396 <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 13 43 80 00       	push   $0x804313
  800bdb:	68 d2 00 00 00       	push   $0xd2
  800be0:	68 dc 41 80 00       	push   $0x8041dc
  800be5:	e8 09 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bea:	ff 45 d0             	incl   -0x30(%ebp)
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  800bf3:	68 c0 43 80 00       	push   $0x8043c0
  800bf8:	e8 aa 04 00 00       	call   8010a7 <cprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800c00:	e8 91 17 00 00       	call   802396 <sys_calculate_free_frames>
  800c05:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800c08:	e8 29 18 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
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
  800c2f:	68 a0 43 80 00       	push   $0x8043a0
  800c34:	68 da 00 00 00       	push   $0xda
  800c39:	68 dc 41 80 00       	push   $0x8041dc
  800c3e:	e8 b0 01 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c43:	e8 ee 17 00 00       	call   802436 <sys_pf_calculate_allocated_pages>
  800c48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800c4b:	74 17                	je     800c64 <_main+0xc2c>
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	68 f6 42 80 00       	push   $0x8042f6
  800c55:	68 db 00 00 00       	push   $0xdb
  800c5a:	68 dc 41 80 00       	push   $0x8041dc
  800c5f:	e8 8f 01 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800c64:	e8 2d 17 00 00       	call   802396 <sys_calculate_free_frames>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6e:	39 c2                	cmp    %eax,%edx
  800c70:	74 17                	je     800c89 <_main+0xc51>
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	68 13 43 80 00       	push   $0x804313
  800c7a:	68 dc 00 00 00       	push   $0xdc
  800c7f:	68 dc 41 80 00       	push   $0x8041dc
  800c84:	e8 6a 01 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800c89:	ff 45 d0             	incl   -0x30(%ebp)
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c92:	68 c0 43 80 00       	push   $0x8043c0
  800c97:	e8 0b 04 00 00       	call   8010a7 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	68 d4 43 80 00       	push   $0x8043d4
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
  800cbd:	e8 b4 19 00 00       	call   802676 <sys_getenvindex>
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
  800d28:	e8 56 17 00 00       	call   802483 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	68 28 44 80 00       	push   $0x804428
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
  800d58:	68 50 44 80 00       	push   $0x804450
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
  800d89:	68 78 44 80 00       	push   $0x804478
  800d8e:	e8 14 03 00 00       	call   8010a7 <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d96:	a1 20 50 80 00       	mov    0x805020,%eax
  800d9b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	50                   	push   %eax
  800da5:	68 d0 44 80 00       	push   $0x8044d0
  800daa:	e8 f8 02 00 00       	call   8010a7 <cprintf>
  800daf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	68 28 44 80 00       	push   $0x804428
  800dba:	e8 e8 02 00 00       	call   8010a7 <cprintf>
  800dbf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800dc2:	e8 d6 16 00 00       	call   80249d <sys_enable_interrupt>

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
  800dda:	e8 63 18 00 00       	call   802642 <sys_destroy_env>
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
  800deb:	e8 b8 18 00 00       	call   8026a8 <sys_exit_env>
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
  800e14:	68 e4 44 80 00       	push   $0x8044e4
  800e19:	e8 89 02 00 00       	call   8010a7 <cprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800e21:	a1 00 50 80 00       	mov    0x805000,%eax
  800e26:	ff 75 0c             	pushl  0xc(%ebp)
  800e29:	ff 75 08             	pushl  0x8(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	68 e9 44 80 00       	push   $0x8044e9
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
  800e51:	68 05 45 80 00       	push   $0x804505
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
  800e7d:	68 08 45 80 00       	push   $0x804508
  800e82:	6a 26                	push   $0x26
  800e84:	68 54 45 80 00       	push   $0x804554
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
  800f4f:	68 60 45 80 00       	push   $0x804560
  800f54:	6a 3a                	push   $0x3a
  800f56:	68 54 45 80 00       	push   $0x804554
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
  800fbf:	68 b4 45 80 00       	push   $0x8045b4
  800fc4:	6a 44                	push   $0x44
  800fc6:	68 54 45 80 00       	push   $0x804554
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
  801019:	e8 b7 12 00 00       	call   8022d5 <sys_cputs>
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
  801090:	e8 40 12 00 00       	call   8022d5 <sys_cputs>
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
  8010da:	e8 a4 13 00 00       	call   802483 <sys_disable_interrupt>
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
  8010fa:	e8 9e 13 00 00       	call   80249d <sys_enable_interrupt>
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
  801144:	e8 0f 2e 00 00       	call   803f58 <__udivdi3>
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
  801194:	e8 cf 2e 00 00       	call   804068 <__umoddi3>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	05 14 48 80 00       	add    $0x804814,%eax
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
  8012ef:	8b 04 85 38 48 80 00 	mov    0x804838(,%eax,4),%eax
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
  8013d0:	8b 34 9d 80 46 80 00 	mov    0x804680(,%ebx,4),%esi
  8013d7:	85 f6                	test   %esi,%esi
  8013d9:	75 19                	jne    8013f4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8013db:	53                   	push   %ebx
  8013dc:	68 25 48 80 00       	push   $0x804825
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
  8013f5:	68 2e 48 80 00       	push   $0x80482e
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
  801422:	be 31 48 80 00       	mov    $0x804831,%esi
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
  801e48:	68 90 49 80 00       	push   $0x804990
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
  801f18:	e8 fc 04 00 00       	call   802419 <sys_allocate_chunk>
  801f1d:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801f20:	a1 20 51 80 00       	mov    0x805120,%eax
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	50                   	push   %eax
  801f29:	e8 71 0b 00 00       	call   802a9f <initialize_MemBlocksList>
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
  801f56:	68 b5 49 80 00       	push   $0x8049b5
  801f5b:	6a 33                	push   $0x33
  801f5d:	68 d3 49 80 00       	push   $0x8049d3
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
  801fd5:	68 e0 49 80 00       	push   $0x8049e0
  801fda:	6a 34                	push   $0x34
  801fdc:	68 d3 49 80 00       	push   $0x8049d3
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
  802032:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802035:	e8 f7 fd ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  80203a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80203e:	75 07                	jne    802047 <malloc+0x18>
  802040:	b8 00 00 00 00       	mov    $0x0,%eax
  802045:	eb 61                	jmp    8020a8 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  802047:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80204e:	8b 55 08             	mov    0x8(%ebp),%edx
  802051:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802054:	01 d0                	add    %edx,%eax
  802056:	48                   	dec    %eax
  802057:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80205a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205d:	ba 00 00 00 00       	mov    $0x0,%edx
  802062:	f7 75 f0             	divl   -0x10(%ebp)
  802065:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802068:	29 d0                	sub    %edx,%eax
  80206a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80206d:	e8 75 07 00 00       	call   8027e7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802072:	85 c0                	test   %eax,%eax
  802074:	74 11                	je     802087 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  802076:	83 ec 0c             	sub    $0xc,%esp
  802079:	ff 75 e8             	pushl  -0x18(%ebp)
  80207c:	e8 e0 0d 00 00       	call   802e61 <alloc_block_FF>
  802081:	83 c4 10             	add    $0x10,%esp
  802084:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  802087:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208b:	74 16                	je     8020a3 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80208d:	83 ec 0c             	sub    $0xc,%esp
  802090:	ff 75 f4             	pushl  -0xc(%ebp)
  802093:	e8 3c 0b 00 00       	call   802bd4 <insert_sorted_allocList>
  802098:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80209b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209e:	8b 40 08             	mov    0x8(%eax),%eax
  8020a1:	eb 05                	jmp    8020a8 <malloc+0x79>
	}

    return NULL;
  8020a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8020b0:	83 ec 04             	sub    $0x4,%esp
  8020b3:	68 04 4a 80 00       	push   $0x804a04
  8020b8:	6a 6f                	push   $0x6f
  8020ba:	68 d3 49 80 00       	push   $0x8049d3
  8020bf:	e8 2f ed ff ff       	call   800df3 <_panic>

008020c4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 38             	sub    $0x38,%esp
  8020ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cd:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020d0:	e8 5c fd ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  8020d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020d9:	75 0a                	jne    8020e5 <smalloc+0x21>
  8020db:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e0:	e9 8b 00 00 00       	jmp    802170 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8020e5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8020ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f2:	01 d0                	add    %edx,%eax
  8020f4:	48                   	dec    %eax
  8020f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802100:	f7 75 f0             	divl   -0x10(%ebp)
  802103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802106:	29 d0                	sub    %edx,%eax
  802108:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80210b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802112:	e8 d0 06 00 00       	call   8027e7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802117:	85 c0                	test   %eax,%eax
  802119:	74 11                	je     80212c <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80211b:	83 ec 0c             	sub    $0xc,%esp
  80211e:	ff 75 e8             	pushl  -0x18(%ebp)
  802121:	e8 3b 0d 00 00       	call   802e61 <alloc_block_FF>
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80212c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802130:	74 39                	je     80216b <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	8b 40 08             	mov    0x8(%eax),%eax
  802138:	89 c2                	mov    %eax,%edx
  80213a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80213e:	52                   	push   %edx
  80213f:	50                   	push   %eax
  802140:	ff 75 0c             	pushl  0xc(%ebp)
  802143:	ff 75 08             	pushl  0x8(%ebp)
  802146:	e8 21 04 00 00       	call   80256c <sys_createSharedObject>
  80214b:	83 c4 10             	add    $0x10,%esp
  80214e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  802151:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802155:	74 14                	je     80216b <smalloc+0xa7>
  802157:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80215b:	74 0e                	je     80216b <smalloc+0xa7>
  80215d:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  802161:	74 08                	je     80216b <smalloc+0xa7>
			return (void*) mem_block->sva;
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	8b 40 08             	mov    0x8(%eax),%eax
  802169:	eb 05                	jmp    802170 <smalloc+0xac>
	}
	return NULL;
  80216b:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802170:	c9                   	leave  
  802171:	c3                   	ret    

00802172 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802172:	55                   	push   %ebp
  802173:	89 e5                	mov    %esp,%ebp
  802175:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802178:	e8 b4 fc ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80217d:	83 ec 08             	sub    $0x8,%esp
  802180:	ff 75 0c             	pushl  0xc(%ebp)
  802183:	ff 75 08             	pushl  0x8(%ebp)
  802186:	e8 0b 04 00 00       	call   802596 <sys_getSizeOfSharedObject>
  80218b:	83 c4 10             	add    $0x10,%esp
  80218e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  802191:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  802195:	74 76                	je     80220d <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  802197:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80219e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a4:	01 d0                	add    %edx,%eax
  8021a6:	48                   	dec    %eax
  8021a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8021aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b2:	f7 75 ec             	divl   -0x14(%ebp)
  8021b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021b8:	29 d0                	sub    %edx,%eax
  8021ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8021bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8021c4:	e8 1e 06 00 00       	call   8027e7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8021c9:	85 c0                	test   %eax,%eax
  8021cb:	74 11                	je     8021de <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8021cd:	83 ec 0c             	sub    $0xc,%esp
  8021d0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8021d3:	e8 89 0c 00 00       	call   802e61 <alloc_block_FF>
  8021d8:	83 c4 10             	add    $0x10,%esp
  8021db:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8021de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e2:	74 29                	je     80220d <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	8b 40 08             	mov    0x8(%eax),%eax
  8021ea:	83 ec 04             	sub    $0x4,%esp
  8021ed:	50                   	push   %eax
  8021ee:	ff 75 0c             	pushl  0xc(%ebp)
  8021f1:	ff 75 08             	pushl  0x8(%ebp)
  8021f4:	e8 ba 03 00 00       	call   8025b3 <sys_getSharedObject>
  8021f9:	83 c4 10             	add    $0x10,%esp
  8021fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8021ff:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  802203:	74 08                	je     80220d <sget+0x9b>
				return (void *)mem_block->sva;
  802205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802208:	8b 40 08             	mov    0x8(%eax),%eax
  80220b:	eb 05                	jmp    802212 <sget+0xa0>
		}
	}
	return (void *)NULL;
  80220d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80221a:	e8 12 fc ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80221f:	83 ec 04             	sub    $0x4,%esp
  802222:	68 28 4a 80 00       	push   $0x804a28
  802227:	68 f1 00 00 00       	push   $0xf1
  80222c:	68 d3 49 80 00       	push   $0x8049d3
  802231:	e8 bd eb ff ff       	call   800df3 <_panic>

00802236 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80223c:	83 ec 04             	sub    $0x4,%esp
  80223f:	68 50 4a 80 00       	push   $0x804a50
  802244:	68 05 01 00 00       	push   $0x105
  802249:	68 d3 49 80 00       	push   $0x8049d3
  80224e:	e8 a0 eb ff ff       	call   800df3 <_panic>

00802253 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	68 74 4a 80 00       	push   $0x804a74
  802261:	68 10 01 00 00       	push   $0x110
  802266:	68 d3 49 80 00       	push   $0x8049d3
  80226b:	e8 83 eb ff ff       	call   800df3 <_panic>

00802270 <shrink>:

}
void shrink(uint32 newSize)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802276:	83 ec 04             	sub    $0x4,%esp
  802279:	68 74 4a 80 00       	push   $0x804a74
  80227e:	68 15 01 00 00       	push   $0x115
  802283:	68 d3 49 80 00       	push   $0x8049d3
  802288:	e8 66 eb ff ff       	call   800df3 <_panic>

0080228d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	68 74 4a 80 00       	push   $0x804a74
  80229b:	68 1a 01 00 00       	push   $0x11a
  8022a0:	68 d3 49 80 00       	push   $0x8049d3
  8022a5:	e8 49 eb ff ff       	call   800df3 <_panic>

008022aa <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	57                   	push   %edi
  8022ae:	56                   	push   %esi
  8022af:	53                   	push   %ebx
  8022b0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022bf:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022c2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022c5:	cd 30                	int    $0x30
  8022c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022cd:	83 c4 10             	add    $0x10,%esp
  8022d0:	5b                   	pop    %ebx
  8022d1:	5e                   	pop    %esi
  8022d2:	5f                   	pop    %edi
  8022d3:	5d                   	pop    %ebp
  8022d4:	c3                   	ret    

008022d5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
  8022d8:	83 ec 04             	sub    $0x4,%esp
  8022db:	8b 45 10             	mov    0x10(%ebp),%eax
  8022de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8022e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	52                   	push   %edx
  8022ed:	ff 75 0c             	pushl  0xc(%ebp)
  8022f0:	50                   	push   %eax
  8022f1:	6a 00                	push   $0x0
  8022f3:	e8 b2 ff ff ff       	call   8022aa <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
}
  8022fb:	90                   	nop
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <sys_cgetc>:

int
sys_cgetc(void)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 01                	push   $0x1
  80230d:	e8 98 ff ff ff       	call   8022aa <syscall>
  802312:	83 c4 18             	add    $0x18,%esp
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80231a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	52                   	push   %edx
  802327:	50                   	push   %eax
  802328:	6a 05                	push   $0x5
  80232a:	e8 7b ff ff ff       	call   8022aa <syscall>
  80232f:	83 c4 18             	add    $0x18,%esp
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	56                   	push   %esi
  802338:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802339:	8b 75 18             	mov    0x18(%ebp),%esi
  80233c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80233f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802342:	8b 55 0c             	mov    0xc(%ebp),%edx
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	56                   	push   %esi
  802349:	53                   	push   %ebx
  80234a:	51                   	push   %ecx
  80234b:	52                   	push   %edx
  80234c:	50                   	push   %eax
  80234d:	6a 06                	push   $0x6
  80234f:	e8 56 ff ff ff       	call   8022aa <syscall>
  802354:	83 c4 18             	add    $0x18,%esp
}
  802357:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80235a:	5b                   	pop    %ebx
  80235b:	5e                   	pop    %esi
  80235c:	5d                   	pop    %ebp
  80235d:	c3                   	ret    

0080235e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802361:	8b 55 0c             	mov    0xc(%ebp),%edx
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	52                   	push   %edx
  80236e:	50                   	push   %eax
  80236f:	6a 07                	push   $0x7
  802371:	e8 34 ff ff ff       	call   8022aa <syscall>
  802376:	83 c4 18             	add    $0x18,%esp
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	ff 75 0c             	pushl  0xc(%ebp)
  802387:	ff 75 08             	pushl  0x8(%ebp)
  80238a:	6a 08                	push   $0x8
  80238c:	e8 19 ff ff ff       	call   8022aa <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 09                	push   $0x9
  8023a5:	e8 00 ff ff ff       	call   8022aa <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
}
  8023ad:	c9                   	leave  
  8023ae:	c3                   	ret    

008023af <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 0a                	push   $0xa
  8023be:	e8 e7 fe ff ff       	call   8022aa <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
}
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 0b                	push   $0xb
  8023d7:	e8 ce fe ff ff       	call   8022aa <syscall>
  8023dc:	83 c4 18             	add    $0x18,%esp
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	ff 75 0c             	pushl  0xc(%ebp)
  8023ed:	ff 75 08             	pushl  0x8(%ebp)
  8023f0:	6a 0f                	push   $0xf
  8023f2:	e8 b3 fe ff ff       	call   8022aa <syscall>
  8023f7:	83 c4 18             	add    $0x18,%esp
	return;
  8023fa:	90                   	nop
}
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	ff 75 0c             	pushl  0xc(%ebp)
  802409:	ff 75 08             	pushl  0x8(%ebp)
  80240c:	6a 10                	push   $0x10
  80240e:	e8 97 fe ff ff       	call   8022aa <syscall>
  802413:	83 c4 18             	add    $0x18,%esp
	return ;
  802416:	90                   	nop
}
  802417:	c9                   	leave  
  802418:	c3                   	ret    

00802419 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	ff 75 10             	pushl  0x10(%ebp)
  802423:	ff 75 0c             	pushl  0xc(%ebp)
  802426:	ff 75 08             	pushl  0x8(%ebp)
  802429:	6a 11                	push   $0x11
  80242b:	e8 7a fe ff ff       	call   8022aa <syscall>
  802430:	83 c4 18             	add    $0x18,%esp
	return ;
  802433:	90                   	nop
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 0c                	push   $0xc
  802445:	e8 60 fe ff ff       	call   8022aa <syscall>
  80244a:	83 c4 18             	add    $0x18,%esp
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	ff 75 08             	pushl  0x8(%ebp)
  80245d:	6a 0d                	push   $0xd
  80245f:	e8 46 fe ff ff       	call   8022aa <syscall>
  802464:	83 c4 18             	add    $0x18,%esp
}
  802467:	c9                   	leave  
  802468:	c3                   	ret    

00802469 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 0e                	push   $0xe
  802478:	e8 2d fe ff ff       	call   8022aa <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
}
  802480:	90                   	nop
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 13                	push   $0x13
  802492:	e8 13 fe ff ff       	call   8022aa <syscall>
  802497:	83 c4 18             	add    $0x18,%esp
}
  80249a:	90                   	nop
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 14                	push   $0x14
  8024ac:	e8 f9 fd ff ff       	call   8022aa <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
}
  8024b4:	90                   	nop
  8024b5:	c9                   	leave  
  8024b6:	c3                   	ret    

008024b7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
  8024ba:	83 ec 04             	sub    $0x4,%esp
  8024bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024c3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	50                   	push   %eax
  8024d0:	6a 15                	push   $0x15
  8024d2:	e8 d3 fd ff ff       	call   8022aa <syscall>
  8024d7:	83 c4 18             	add    $0x18,%esp
}
  8024da:	90                   	nop
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	6a 00                	push   $0x0
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 16                	push   $0x16
  8024ec:	e8 b9 fd ff ff       	call   8022aa <syscall>
  8024f1:	83 c4 18             	add    $0x18,%esp
}
  8024f4:	90                   	nop
  8024f5:	c9                   	leave  
  8024f6:	c3                   	ret    

008024f7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	ff 75 0c             	pushl  0xc(%ebp)
  802506:	50                   	push   %eax
  802507:	6a 17                	push   $0x17
  802509:	e8 9c fd ff ff       	call   8022aa <syscall>
  80250e:	83 c4 18             	add    $0x18,%esp
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802516:	8b 55 0c             	mov    0xc(%ebp),%edx
  802519:	8b 45 08             	mov    0x8(%ebp),%eax
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	52                   	push   %edx
  802523:	50                   	push   %eax
  802524:	6a 1a                	push   $0x1a
  802526:	e8 7f fd ff ff       	call   8022aa <syscall>
  80252b:	83 c4 18             	add    $0x18,%esp
}
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802533:	8b 55 0c             	mov    0xc(%ebp),%edx
  802536:	8b 45 08             	mov    0x8(%ebp),%eax
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	52                   	push   %edx
  802540:	50                   	push   %eax
  802541:	6a 18                	push   $0x18
  802543:	e8 62 fd ff ff       	call   8022aa <syscall>
  802548:	83 c4 18             	add    $0x18,%esp
}
  80254b:	90                   	nop
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802551:	8b 55 0c             	mov    0xc(%ebp),%edx
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	52                   	push   %edx
  80255e:	50                   	push   %eax
  80255f:	6a 19                	push   $0x19
  802561:	e8 44 fd ff ff       	call   8022aa <syscall>
  802566:	83 c4 18             	add    $0x18,%esp
}
  802569:	90                   	nop
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    

0080256c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
  80256f:	83 ec 04             	sub    $0x4,%esp
  802572:	8b 45 10             	mov    0x10(%ebp),%eax
  802575:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802578:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80257b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80257f:	8b 45 08             	mov    0x8(%ebp),%eax
  802582:	6a 00                	push   $0x0
  802584:	51                   	push   %ecx
  802585:	52                   	push   %edx
  802586:	ff 75 0c             	pushl  0xc(%ebp)
  802589:	50                   	push   %eax
  80258a:	6a 1b                	push   $0x1b
  80258c:	e8 19 fd ff ff       	call   8022aa <syscall>
  802591:	83 c4 18             	add    $0x18,%esp
}
  802594:	c9                   	leave  
  802595:	c3                   	ret    

00802596 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802599:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259c:	8b 45 08             	mov    0x8(%ebp),%eax
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	52                   	push   %edx
  8025a6:	50                   	push   %eax
  8025a7:	6a 1c                	push   $0x1c
  8025a9:	e8 fc fc ff ff       	call   8022aa <syscall>
  8025ae:	83 c4 18             	add    $0x18,%esp
}
  8025b1:	c9                   	leave  
  8025b2:	c3                   	ret    

008025b3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8025b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	51                   	push   %ecx
  8025c4:	52                   	push   %edx
  8025c5:	50                   	push   %eax
  8025c6:	6a 1d                	push   $0x1d
  8025c8:	e8 dd fc ff ff       	call   8022aa <syscall>
  8025cd:	83 c4 18             	add    $0x18,%esp
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	52                   	push   %edx
  8025e2:	50                   	push   %eax
  8025e3:	6a 1e                	push   $0x1e
  8025e5:	e8 c0 fc ff ff       	call   8022aa <syscall>
  8025ea:	83 c4 18             	add    $0x18,%esp
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	6a 00                	push   $0x0
  8025fc:	6a 1f                	push   $0x1f
  8025fe:	e8 a7 fc ff ff       	call   8022aa <syscall>
  802603:	83 c4 18             	add    $0x18,%esp
}
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	6a 00                	push   $0x0
  802610:	ff 75 14             	pushl  0x14(%ebp)
  802613:	ff 75 10             	pushl  0x10(%ebp)
  802616:	ff 75 0c             	pushl  0xc(%ebp)
  802619:	50                   	push   %eax
  80261a:	6a 20                	push   $0x20
  80261c:	e8 89 fc ff ff       	call   8022aa <syscall>
  802621:	83 c4 18             	add    $0x18,%esp
}
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	50                   	push   %eax
  802635:	6a 21                	push   $0x21
  802637:	e8 6e fc ff ff       	call   8022aa <syscall>
  80263c:	83 c4 18             	add    $0x18,%esp
}
  80263f:	90                   	nop
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802645:	8b 45 08             	mov    0x8(%ebp),%eax
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	50                   	push   %eax
  802651:	6a 22                	push   $0x22
  802653:	e8 52 fc ff ff       	call   8022aa <syscall>
  802658:	83 c4 18             	add    $0x18,%esp
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    

0080265d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 00                	push   $0x0
  802666:	6a 00                	push   $0x0
  802668:	6a 00                	push   $0x0
  80266a:	6a 02                	push   $0x2
  80266c:	e8 39 fc ff ff       	call   8022aa <syscall>
  802671:	83 c4 18             	add    $0x18,%esp
}
  802674:	c9                   	leave  
  802675:	c3                   	ret    

00802676 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802679:	6a 00                	push   $0x0
  80267b:	6a 00                	push   $0x0
  80267d:	6a 00                	push   $0x0
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 03                	push   $0x3
  802685:	e8 20 fc ff ff       	call   8022aa <syscall>
  80268a:	83 c4 18             	add    $0x18,%esp
}
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    

0080268f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80268f:	55                   	push   %ebp
  802690:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 00                	push   $0x0
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 04                	push   $0x4
  80269e:	e8 07 fc ff ff       	call   8022aa <syscall>
  8026a3:	83 c4 18             	add    $0x18,%esp
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <sys_exit_env>:


void sys_exit_env(void)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 00                	push   $0x0
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 23                	push   $0x23
  8026b7:	e8 ee fb ff ff       	call   8022aa <syscall>
  8026bc:	83 c4 18             	add    $0x18,%esp
}
  8026bf:	90                   	nop
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

008026c2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
  8026c5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8026c8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026cb:	8d 50 04             	lea    0x4(%eax),%edx
  8026ce:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	52                   	push   %edx
  8026d8:	50                   	push   %eax
  8026d9:	6a 24                	push   $0x24
  8026db:	e8 ca fb ff ff       	call   8022aa <syscall>
  8026e0:	83 c4 18             	add    $0x18,%esp
	return result;
  8026e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026ec:	89 01                	mov    %eax,(%ecx)
  8026ee:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f4:	c9                   	leave  
  8026f5:	c2 04 00             	ret    $0x4

008026f8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026f8:	55                   	push   %ebp
  8026f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 00                	push   $0x0
  8026ff:	ff 75 10             	pushl  0x10(%ebp)
  802702:	ff 75 0c             	pushl  0xc(%ebp)
  802705:	ff 75 08             	pushl  0x8(%ebp)
  802708:	6a 12                	push   $0x12
  80270a:	e8 9b fb ff ff       	call   8022aa <syscall>
  80270f:	83 c4 18             	add    $0x18,%esp
	return ;
  802712:	90                   	nop
}
  802713:	c9                   	leave  
  802714:	c3                   	ret    

00802715 <sys_rcr2>:
uint32 sys_rcr2()
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 00                	push   $0x0
  802722:	6a 25                	push   $0x25
  802724:	e8 81 fb ff ff       	call   8022aa <syscall>
  802729:	83 c4 18             	add    $0x18,%esp
}
  80272c:	c9                   	leave  
  80272d:	c3                   	ret    

0080272e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80272e:	55                   	push   %ebp
  80272f:	89 e5                	mov    %esp,%ebp
  802731:	83 ec 04             	sub    $0x4,%esp
  802734:	8b 45 08             	mov    0x8(%ebp),%eax
  802737:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80273a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80273e:	6a 00                	push   $0x0
  802740:	6a 00                	push   $0x0
  802742:	6a 00                	push   $0x0
  802744:	6a 00                	push   $0x0
  802746:	50                   	push   %eax
  802747:	6a 26                	push   $0x26
  802749:	e8 5c fb ff ff       	call   8022aa <syscall>
  80274e:	83 c4 18             	add    $0x18,%esp
	return ;
  802751:	90                   	nop
}
  802752:	c9                   	leave  
  802753:	c3                   	ret    

00802754 <rsttst>:
void rsttst()
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 28                	push   $0x28
  802763:	e8 42 fb ff ff       	call   8022aa <syscall>
  802768:	83 c4 18             	add    $0x18,%esp
	return ;
  80276b:	90                   	nop
}
  80276c:	c9                   	leave  
  80276d:	c3                   	ret    

0080276e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	83 ec 04             	sub    $0x4,%esp
  802774:	8b 45 14             	mov    0x14(%ebp),%eax
  802777:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80277a:	8b 55 18             	mov    0x18(%ebp),%edx
  80277d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802781:	52                   	push   %edx
  802782:	50                   	push   %eax
  802783:	ff 75 10             	pushl  0x10(%ebp)
  802786:	ff 75 0c             	pushl  0xc(%ebp)
  802789:	ff 75 08             	pushl  0x8(%ebp)
  80278c:	6a 27                	push   $0x27
  80278e:	e8 17 fb ff ff       	call   8022aa <syscall>
  802793:	83 c4 18             	add    $0x18,%esp
	return ;
  802796:	90                   	nop
}
  802797:	c9                   	leave  
  802798:	c3                   	ret    

00802799 <chktst>:
void chktst(uint32 n)
{
  802799:	55                   	push   %ebp
  80279a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80279c:	6a 00                	push   $0x0
  80279e:	6a 00                	push   $0x0
  8027a0:	6a 00                	push   $0x0
  8027a2:	6a 00                	push   $0x0
  8027a4:	ff 75 08             	pushl  0x8(%ebp)
  8027a7:	6a 29                	push   $0x29
  8027a9:	e8 fc fa ff ff       	call   8022aa <syscall>
  8027ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8027b1:	90                   	nop
}
  8027b2:	c9                   	leave  
  8027b3:	c3                   	ret    

008027b4 <inctst>:

void inctst()
{
  8027b4:	55                   	push   %ebp
  8027b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 2a                	push   $0x2a
  8027c3:	e8 e2 fa ff ff       	call   8022aa <syscall>
  8027c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8027cb:	90                   	nop
}
  8027cc:	c9                   	leave  
  8027cd:	c3                   	ret    

008027ce <gettst>:
uint32 gettst()
{
  8027ce:	55                   	push   %ebp
  8027cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 00                	push   $0x0
  8027db:	6a 2b                	push   $0x2b
  8027dd:	e8 c8 fa ff ff       	call   8022aa <syscall>
  8027e2:	83 c4 18             	add    $0x18,%esp
}
  8027e5:	c9                   	leave  
  8027e6:	c3                   	ret    

008027e7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8027e7:	55                   	push   %ebp
  8027e8:	89 e5                	mov    %esp,%ebp
  8027ea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027ed:	6a 00                	push   $0x0
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	6a 2c                	push   $0x2c
  8027f9:	e8 ac fa ff ff       	call   8022aa <syscall>
  8027fe:	83 c4 18             	add    $0x18,%esp
  802801:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802804:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802808:	75 07                	jne    802811 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80280a:	b8 01 00 00 00       	mov    $0x1,%eax
  80280f:	eb 05                	jmp    802816 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802811:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802816:	c9                   	leave  
  802817:	c3                   	ret    

00802818 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80281e:	6a 00                	push   $0x0
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	6a 00                	push   $0x0
  802826:	6a 00                	push   $0x0
  802828:	6a 2c                	push   $0x2c
  80282a:	e8 7b fa ff ff       	call   8022aa <syscall>
  80282f:	83 c4 18             	add    $0x18,%esp
  802832:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802835:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802839:	75 07                	jne    802842 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80283b:	b8 01 00 00 00       	mov    $0x1,%eax
  802840:	eb 05                	jmp    802847 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802842:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802847:	c9                   	leave  
  802848:	c3                   	ret    

00802849 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802849:	55                   	push   %ebp
  80284a:	89 e5                	mov    %esp,%ebp
  80284c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	6a 00                	push   $0x0
  802857:	6a 00                	push   $0x0
  802859:	6a 2c                	push   $0x2c
  80285b:	e8 4a fa ff ff       	call   8022aa <syscall>
  802860:	83 c4 18             	add    $0x18,%esp
  802863:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802866:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80286a:	75 07                	jne    802873 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80286c:	b8 01 00 00 00       	mov    $0x1,%eax
  802871:	eb 05                	jmp    802878 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802873:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802878:	c9                   	leave  
  802879:	c3                   	ret    

0080287a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
  80287d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802880:	6a 00                	push   $0x0
  802882:	6a 00                	push   $0x0
  802884:	6a 00                	push   $0x0
  802886:	6a 00                	push   $0x0
  802888:	6a 00                	push   $0x0
  80288a:	6a 2c                	push   $0x2c
  80288c:	e8 19 fa ff ff       	call   8022aa <syscall>
  802891:	83 c4 18             	add    $0x18,%esp
  802894:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802897:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80289b:	75 07                	jne    8028a4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80289d:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a2:	eb 05                	jmp    8028a9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8028a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a9:	c9                   	leave  
  8028aa:	c3                   	ret    

008028ab <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8028ae:	6a 00                	push   $0x0
  8028b0:	6a 00                	push   $0x0
  8028b2:	6a 00                	push   $0x0
  8028b4:	6a 00                	push   $0x0
  8028b6:	ff 75 08             	pushl  0x8(%ebp)
  8028b9:	6a 2d                	push   $0x2d
  8028bb:	e8 ea f9 ff ff       	call   8022aa <syscall>
  8028c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8028c3:	90                   	nop
}
  8028c4:	c9                   	leave  
  8028c5:	c3                   	ret    

008028c6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
  8028c9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8028ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	6a 00                	push   $0x0
  8028d8:	53                   	push   %ebx
  8028d9:	51                   	push   %ecx
  8028da:	52                   	push   %edx
  8028db:	50                   	push   %eax
  8028dc:	6a 2e                	push   $0x2e
  8028de:	e8 c7 f9 ff ff       	call   8022aa <syscall>
  8028e3:	83 c4 18             	add    $0x18,%esp
}
  8028e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028e9:	c9                   	leave  
  8028ea:	c3                   	ret    

008028eb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8028eb:	55                   	push   %ebp
  8028ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8028ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	6a 00                	push   $0x0
  8028f6:	6a 00                	push   $0x0
  8028f8:	6a 00                	push   $0x0
  8028fa:	52                   	push   %edx
  8028fb:	50                   	push   %eax
  8028fc:	6a 2f                	push   $0x2f
  8028fe:	e8 a7 f9 ff ff       	call   8022aa <syscall>
  802903:	83 c4 18             	add    $0x18,%esp
}
  802906:	c9                   	leave  
  802907:	c3                   	ret    

00802908 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802908:	55                   	push   %ebp
  802909:	89 e5                	mov    %esp,%ebp
  80290b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80290e:	83 ec 0c             	sub    $0xc,%esp
  802911:	68 84 4a 80 00       	push   $0x804a84
  802916:	e8 8c e7 ff ff       	call   8010a7 <cprintf>
  80291b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80291e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802925:	83 ec 0c             	sub    $0xc,%esp
  802928:	68 b0 4a 80 00       	push   $0x804ab0
  80292d:	e8 75 e7 ff ff       	call   8010a7 <cprintf>
  802932:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802935:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802939:	a1 38 51 80 00       	mov    0x805138,%eax
  80293e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802941:	eb 56                	jmp    802999 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802943:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802947:	74 1c                	je     802965 <print_mem_block_lists+0x5d>
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 50 08             	mov    0x8(%eax),%edx
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	8b 48 08             	mov    0x8(%eax),%ecx
  802955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802958:	8b 40 0c             	mov    0xc(%eax),%eax
  80295b:	01 c8                	add    %ecx,%eax
  80295d:	39 c2                	cmp    %eax,%edx
  80295f:	73 04                	jae    802965 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802961:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 50 08             	mov    0x8(%eax),%edx
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 40 0c             	mov    0xc(%eax),%eax
  802971:	01 c2                	add    %eax,%edx
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 40 08             	mov    0x8(%eax),%eax
  802979:	83 ec 04             	sub    $0x4,%esp
  80297c:	52                   	push   %edx
  80297d:	50                   	push   %eax
  80297e:	68 c5 4a 80 00       	push   $0x804ac5
  802983:	e8 1f e7 ff ff       	call   8010a7 <cprintf>
  802988:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802991:	a1 40 51 80 00       	mov    0x805140,%eax
  802996:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802999:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299d:	74 07                	je     8029a6 <print_mem_block_lists+0x9e>
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 00                	mov    (%eax),%eax
  8029a4:	eb 05                	jmp    8029ab <print_mem_block_lists+0xa3>
  8029a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ab:	a3 40 51 80 00       	mov    %eax,0x805140
  8029b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	75 8a                	jne    802943 <print_mem_block_lists+0x3b>
  8029b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029bd:	75 84                	jne    802943 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8029bf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029c3:	75 10                	jne    8029d5 <print_mem_block_lists+0xcd>
  8029c5:	83 ec 0c             	sub    $0xc,%esp
  8029c8:	68 d4 4a 80 00       	push   $0x804ad4
  8029cd:	e8 d5 e6 ff ff       	call   8010a7 <cprintf>
  8029d2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8029d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8029dc:	83 ec 0c             	sub    $0xc,%esp
  8029df:	68 f8 4a 80 00       	push   $0x804af8
  8029e4:	e8 be e6 ff ff       	call   8010a7 <cprintf>
  8029e9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8029ec:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029f0:	a1 40 50 80 00       	mov    0x805040,%eax
  8029f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f8:	eb 56                	jmp    802a50 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029fe:	74 1c                	je     802a1c <print_mem_block_lists+0x114>
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 50 08             	mov    0x8(%eax),%edx
  802a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a09:	8b 48 08             	mov    0x8(%eax),%ecx
  802a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a12:	01 c8                	add    %ecx,%eax
  802a14:	39 c2                	cmp    %eax,%edx
  802a16:	73 04                	jae    802a1c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802a18:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 50 08             	mov    0x8(%eax),%edx
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 40 0c             	mov    0xc(%eax),%eax
  802a28:	01 c2                	add    %eax,%edx
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 40 08             	mov    0x8(%eax),%eax
  802a30:	83 ec 04             	sub    $0x4,%esp
  802a33:	52                   	push   %edx
  802a34:	50                   	push   %eax
  802a35:	68 c5 4a 80 00       	push   $0x804ac5
  802a3a:	e8 68 e6 ff ff       	call   8010a7 <cprintf>
  802a3f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a48:	a1 48 50 80 00       	mov    0x805048,%eax
  802a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a54:	74 07                	je     802a5d <print_mem_block_lists+0x155>
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 00                	mov    (%eax),%eax
  802a5b:	eb 05                	jmp    802a62 <print_mem_block_lists+0x15a>
  802a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a62:	a3 48 50 80 00       	mov    %eax,0x805048
  802a67:	a1 48 50 80 00       	mov    0x805048,%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	75 8a                	jne    8029fa <print_mem_block_lists+0xf2>
  802a70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a74:	75 84                	jne    8029fa <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802a76:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a7a:	75 10                	jne    802a8c <print_mem_block_lists+0x184>
  802a7c:	83 ec 0c             	sub    $0xc,%esp
  802a7f:	68 10 4b 80 00       	push   $0x804b10
  802a84:	e8 1e e6 ff ff       	call   8010a7 <cprintf>
  802a89:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802a8c:	83 ec 0c             	sub    $0xc,%esp
  802a8f:	68 84 4a 80 00       	push   $0x804a84
  802a94:	e8 0e e6 ff ff       	call   8010a7 <cprintf>
  802a99:	83 c4 10             	add    $0x10,%esp

}
  802a9c:	90                   	nop
  802a9d:	c9                   	leave  
  802a9e:	c3                   	ret    

00802a9f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a9f:	55                   	push   %ebp
  802aa0:	89 e5                	mov    %esp,%ebp
  802aa2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802aa5:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802aac:	00 00 00 
  802aaf:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802ab6:	00 00 00 
  802ab9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802ac0:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802ac3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802aca:	e9 9e 00 00 00       	jmp    802b6d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802acf:	a1 50 50 80 00       	mov    0x805050,%eax
  802ad4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad7:	c1 e2 04             	shl    $0x4,%edx
  802ada:	01 d0                	add    %edx,%eax
  802adc:	85 c0                	test   %eax,%eax
  802ade:	75 14                	jne    802af4 <initialize_MemBlocksList+0x55>
  802ae0:	83 ec 04             	sub    $0x4,%esp
  802ae3:	68 38 4b 80 00       	push   $0x804b38
  802ae8:	6a 46                	push   $0x46
  802aea:	68 5b 4b 80 00       	push   $0x804b5b
  802aef:	e8 ff e2 ff ff       	call   800df3 <_panic>
  802af4:	a1 50 50 80 00       	mov    0x805050,%eax
  802af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afc:	c1 e2 04             	shl    $0x4,%edx
  802aff:	01 d0                	add    %edx,%eax
  802b01:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802b07:	89 10                	mov    %edx,(%eax)
  802b09:	8b 00                	mov    (%eax),%eax
  802b0b:	85 c0                	test   %eax,%eax
  802b0d:	74 18                	je     802b27 <initialize_MemBlocksList+0x88>
  802b0f:	a1 48 51 80 00       	mov    0x805148,%eax
  802b14:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802b1a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802b1d:	c1 e1 04             	shl    $0x4,%ecx
  802b20:	01 ca                	add    %ecx,%edx
  802b22:	89 50 04             	mov    %edx,0x4(%eax)
  802b25:	eb 12                	jmp    802b39 <initialize_MemBlocksList+0x9a>
  802b27:	a1 50 50 80 00       	mov    0x805050,%eax
  802b2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2f:	c1 e2 04             	shl    $0x4,%edx
  802b32:	01 d0                	add    %edx,%eax
  802b34:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b39:	a1 50 50 80 00       	mov    0x805050,%eax
  802b3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b41:	c1 e2 04             	shl    $0x4,%edx
  802b44:	01 d0                	add    %edx,%eax
  802b46:	a3 48 51 80 00       	mov    %eax,0x805148
  802b4b:	a1 50 50 80 00       	mov    0x805050,%eax
  802b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b53:	c1 e2 04             	shl    $0x4,%edx
  802b56:	01 d0                	add    %edx,%eax
  802b58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5f:	a1 54 51 80 00       	mov    0x805154,%eax
  802b64:	40                   	inc    %eax
  802b65:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802b6a:	ff 45 f4             	incl   -0xc(%ebp)
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b73:	0f 82 56 ff ff ff    	jb     802acf <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802b79:	90                   	nop
  802b7a:	c9                   	leave  
  802b7b:	c3                   	ret    

00802b7c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802b7c:	55                   	push   %ebp
  802b7d:	89 e5                	mov    %esp,%ebp
  802b7f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b8a:	eb 19                	jmp    802ba5 <find_block+0x29>
	{
		if(va==point->sva)
  802b8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b8f:	8b 40 08             	mov    0x8(%eax),%eax
  802b92:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b95:	75 05                	jne    802b9c <find_block+0x20>
		   return point;
  802b97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b9a:	eb 36                	jmp    802bd2 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ba2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ba5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ba9:	74 07                	je     802bb2 <find_block+0x36>
  802bab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802bae:	8b 00                	mov    (%eax),%eax
  802bb0:	eb 05                	jmp    802bb7 <find_block+0x3b>
  802bb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802bba:	89 42 08             	mov    %eax,0x8(%edx)
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	8b 40 08             	mov    0x8(%eax),%eax
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	75 c5                	jne    802b8c <find_block+0x10>
  802bc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802bcb:	75 bf                	jne    802b8c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802bcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd2:	c9                   	leave  
  802bd3:	c3                   	ret    

00802bd4 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802bd4:	55                   	push   %ebp
  802bd5:	89 e5                	mov    %esp,%ebp
  802bd7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802bda:	a1 40 50 80 00       	mov    0x805040,%eax
  802bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802be2:	a1 44 50 80 00       	mov    0x805044,%eax
  802be7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802bf0:	74 24                	je     802c16 <insert_sorted_allocList+0x42>
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 50 08             	mov    0x8(%eax),%edx
  802bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfb:	8b 40 08             	mov    0x8(%eax),%eax
  802bfe:	39 c2                	cmp    %eax,%edx
  802c00:	76 14                	jbe    802c16 <insert_sorted_allocList+0x42>
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	8b 50 08             	mov    0x8(%eax),%edx
  802c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0b:	8b 40 08             	mov    0x8(%eax),%eax
  802c0e:	39 c2                	cmp    %eax,%edx
  802c10:	0f 82 60 01 00 00    	jb     802d76 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802c16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c1a:	75 65                	jne    802c81 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802c1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c20:	75 14                	jne    802c36 <insert_sorted_allocList+0x62>
  802c22:	83 ec 04             	sub    $0x4,%esp
  802c25:	68 38 4b 80 00       	push   $0x804b38
  802c2a:	6a 6b                	push   $0x6b
  802c2c:	68 5b 4b 80 00       	push   $0x804b5b
  802c31:	e8 bd e1 ff ff       	call   800df3 <_panic>
  802c36:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	89 10                	mov    %edx,(%eax)
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	85 c0                	test   %eax,%eax
  802c48:	74 0d                	je     802c57 <insert_sorted_allocList+0x83>
  802c4a:	a1 40 50 80 00       	mov    0x805040,%eax
  802c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c52:	89 50 04             	mov    %edx,0x4(%eax)
  802c55:	eb 08                	jmp    802c5f <insert_sorted_allocList+0x8b>
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	a3 44 50 80 00       	mov    %eax,0x805044
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	a3 40 50 80 00       	mov    %eax,0x805040
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c71:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c76:	40                   	inc    %eax
  802c77:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c7c:	e9 dc 01 00 00       	jmp    802e5d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	8b 50 08             	mov    0x8(%eax),%edx
  802c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8a:	8b 40 08             	mov    0x8(%eax),%eax
  802c8d:	39 c2                	cmp    %eax,%edx
  802c8f:	77 6c                	ja     802cfd <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802c91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c95:	74 06                	je     802c9d <insert_sorted_allocList+0xc9>
  802c97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9b:	75 14                	jne    802cb1 <insert_sorted_allocList+0xdd>
  802c9d:	83 ec 04             	sub    $0x4,%esp
  802ca0:	68 74 4b 80 00       	push   $0x804b74
  802ca5:	6a 6f                	push   $0x6f
  802ca7:	68 5b 4b 80 00       	push   $0x804b5b
  802cac:	e8 42 e1 ff ff       	call   800df3 <_panic>
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	8b 50 04             	mov    0x4(%eax),%edx
  802cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cba:	89 50 04             	mov    %edx,0x4(%eax)
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc3:	89 10                	mov    %edx,(%eax)
  802cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc8:	8b 40 04             	mov    0x4(%eax),%eax
  802ccb:	85 c0                	test   %eax,%eax
  802ccd:	74 0d                	je     802cdc <insert_sorted_allocList+0x108>
  802ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd2:	8b 40 04             	mov    0x4(%eax),%eax
  802cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd8:	89 10                	mov    %edx,(%eax)
  802cda:	eb 08                	jmp    802ce4 <insert_sorted_allocList+0x110>
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	a3 40 50 80 00       	mov    %eax,0x805040
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cea:	89 50 04             	mov    %edx,0x4(%eax)
  802ced:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cf2:	40                   	inc    %eax
  802cf3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802cf8:	e9 60 01 00 00       	jmp    802e5d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	8b 50 08             	mov    0x8(%eax),%edx
  802d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d06:	8b 40 08             	mov    0x8(%eax),%eax
  802d09:	39 c2                	cmp    %eax,%edx
  802d0b:	0f 82 4c 01 00 00    	jb     802e5d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802d11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d15:	75 14                	jne    802d2b <insert_sorted_allocList+0x157>
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	68 ac 4b 80 00       	push   $0x804bac
  802d1f:	6a 73                	push   $0x73
  802d21:	68 5b 4b 80 00       	push   $0x804b5b
  802d26:	e8 c8 e0 ff ff       	call   800df3 <_panic>
  802d2b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	89 50 04             	mov    %edx,0x4(%eax)
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	8b 40 04             	mov    0x4(%eax),%eax
  802d3d:	85 c0                	test   %eax,%eax
  802d3f:	74 0c                	je     802d4d <insert_sorted_allocList+0x179>
  802d41:	a1 44 50 80 00       	mov    0x805044,%eax
  802d46:	8b 55 08             	mov    0x8(%ebp),%edx
  802d49:	89 10                	mov    %edx,(%eax)
  802d4b:	eb 08                	jmp    802d55 <insert_sorted_allocList+0x181>
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	a3 40 50 80 00       	mov    %eax,0x805040
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	a3 44 50 80 00       	mov    %eax,0x805044
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d66:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d6b:	40                   	inc    %eax
  802d6c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d71:	e9 e7 00 00 00       	jmp    802e5d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802d7c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802d83:	a1 40 50 80 00       	mov    0x805040,%eax
  802d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d8b:	e9 9d 00 00 00       	jmp    802e2d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	8b 50 08             	mov    0x8(%eax),%edx
  802d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da1:	8b 40 08             	mov    0x8(%eax),%eax
  802da4:	39 c2                	cmp    %eax,%edx
  802da6:	76 7d                	jbe    802e25 <insert_sorted_allocList+0x251>
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	8b 50 08             	mov    0x8(%eax),%edx
  802dae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db1:	8b 40 08             	mov    0x8(%eax),%eax
  802db4:	39 c2                	cmp    %eax,%edx
  802db6:	73 6d                	jae    802e25 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802db8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbc:	74 06                	je     802dc4 <insert_sorted_allocList+0x1f0>
  802dbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc2:	75 14                	jne    802dd8 <insert_sorted_allocList+0x204>
  802dc4:	83 ec 04             	sub    $0x4,%esp
  802dc7:	68 d0 4b 80 00       	push   $0x804bd0
  802dcc:	6a 7f                	push   $0x7f
  802dce:	68 5b 4b 80 00       	push   $0x804b5b
  802dd3:	e8 1b e0 ff ff       	call   800df3 <_panic>
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 10                	mov    (%eax),%edx
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	89 10                	mov    %edx,(%eax)
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	8b 00                	mov    (%eax),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	74 0b                	je     802df6 <insert_sorted_allocList+0x222>
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	8b 00                	mov    (%eax),%eax
  802df0:	8b 55 08             	mov    0x8(%ebp),%edx
  802df3:	89 50 04             	mov    %edx,0x4(%eax)
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfc:	89 10                	mov    %edx,(%eax)
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e04:	89 50 04             	mov    %edx,0x4(%eax)
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	75 08                	jne    802e18 <insert_sorted_allocList+0x244>
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	a3 44 50 80 00       	mov    %eax,0x805044
  802e18:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e1d:	40                   	inc    %eax
  802e1e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802e23:	eb 39                	jmp    802e5e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802e25:	a1 48 50 80 00       	mov    0x805048,%eax
  802e2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e31:	74 07                	je     802e3a <insert_sorted_allocList+0x266>
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	eb 05                	jmp    802e3f <insert_sorted_allocList+0x26b>
  802e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3f:	a3 48 50 80 00       	mov    %eax,0x805048
  802e44:	a1 48 50 80 00       	mov    0x805048,%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	0f 85 3f ff ff ff    	jne    802d90 <insert_sorted_allocList+0x1bc>
  802e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e55:	0f 85 35 ff ff ff    	jne    802d90 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802e5b:	eb 01                	jmp    802e5e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802e5d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802e5e:	90                   	nop
  802e5f:	c9                   	leave  
  802e60:	c3                   	ret    

00802e61 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802e61:	55                   	push   %ebp
  802e62:	89 e5                	mov    %esp,%ebp
  802e64:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802e67:	a1 38 51 80 00       	mov    0x805138,%eax
  802e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e6f:	e9 85 01 00 00       	jmp    802ff9 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e7d:	0f 82 6e 01 00 00    	jb     802ff1 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 40 0c             	mov    0xc(%eax),%eax
  802e89:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e8c:	0f 85 8a 00 00 00    	jne    802f1c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802e92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e96:	75 17                	jne    802eaf <alloc_block_FF+0x4e>
  802e98:	83 ec 04             	sub    $0x4,%esp
  802e9b:	68 04 4c 80 00       	push   $0x804c04
  802ea0:	68 93 00 00 00       	push   $0x93
  802ea5:	68 5b 4b 80 00       	push   $0x804b5b
  802eaa:	e8 44 df ff ff       	call   800df3 <_panic>
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 00                	mov    (%eax),%eax
  802eb4:	85 c0                	test   %eax,%eax
  802eb6:	74 10                	je     802ec8 <alloc_block_FF+0x67>
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 00                	mov    (%eax),%eax
  802ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec0:	8b 52 04             	mov    0x4(%edx),%edx
  802ec3:	89 50 04             	mov    %edx,0x4(%eax)
  802ec6:	eb 0b                	jmp    802ed3 <alloc_block_FF+0x72>
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 40 04             	mov    0x4(%eax),%eax
  802ece:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 40 04             	mov    0x4(%eax),%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	74 0f                	je     802eec <alloc_block_FF+0x8b>
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	8b 40 04             	mov    0x4(%eax),%eax
  802ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee6:	8b 12                	mov    (%edx),%edx
  802ee8:	89 10                	mov    %edx,(%eax)
  802eea:	eb 0a                	jmp    802ef6 <alloc_block_FF+0x95>
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	8b 00                	mov    (%eax),%eax
  802ef1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f09:	a1 44 51 80 00       	mov    0x805144,%eax
  802f0e:	48                   	dec    %eax
  802f0f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	e9 10 01 00 00       	jmp    80302c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f22:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f25:	0f 86 c6 00 00 00    	jbe    802ff1 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f2b:	a1 48 51 80 00       	mov    0x805148,%eax
  802f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 50 08             	mov    0x8(%eax),%edx
  802f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f42:	8b 55 08             	mov    0x8(%ebp),%edx
  802f45:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802f48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4c:	75 17                	jne    802f65 <alloc_block_FF+0x104>
  802f4e:	83 ec 04             	sub    $0x4,%esp
  802f51:	68 04 4c 80 00       	push   $0x804c04
  802f56:	68 9b 00 00 00       	push   $0x9b
  802f5b:	68 5b 4b 80 00       	push   $0x804b5b
  802f60:	e8 8e de ff ff       	call   800df3 <_panic>
  802f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f68:	8b 00                	mov    (%eax),%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	74 10                	je     802f7e <alloc_block_FF+0x11d>
  802f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f71:	8b 00                	mov    (%eax),%eax
  802f73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f76:	8b 52 04             	mov    0x4(%edx),%edx
  802f79:	89 50 04             	mov    %edx,0x4(%eax)
  802f7c:	eb 0b                	jmp    802f89 <alloc_block_FF+0x128>
  802f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f81:	8b 40 04             	mov    0x4(%eax),%eax
  802f84:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8c:	8b 40 04             	mov    0x4(%eax),%eax
  802f8f:	85 c0                	test   %eax,%eax
  802f91:	74 0f                	je     802fa2 <alloc_block_FF+0x141>
  802f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f96:	8b 40 04             	mov    0x4(%eax),%eax
  802f99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f9c:	8b 12                	mov    (%edx),%edx
  802f9e:	89 10                	mov    %edx,(%eax)
  802fa0:	eb 0a                	jmp    802fac <alloc_block_FF+0x14b>
  802fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa5:	8b 00                	mov    (%eax),%eax
  802fa7:	a3 48 51 80 00       	mov    %eax,0x805148
  802fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802faf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbf:	a1 54 51 80 00       	mov    0x805154,%eax
  802fc4:	48                   	dec    %eax
  802fc5:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	8b 50 08             	mov    0x8(%eax),%edx
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	01 c2                	add    %eax,%edx
  802fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd8:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe1:	2b 45 08             	sub    0x8(%ebp),%eax
  802fe4:	89 c2                	mov    %eax,%edx
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fef:	eb 3b                	jmp    80302c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802ff1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ff6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ffd:	74 07                	je     803006 <alloc_block_FF+0x1a5>
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 00                	mov    (%eax),%eax
  803004:	eb 05                	jmp    80300b <alloc_block_FF+0x1aa>
  803006:	b8 00 00 00 00       	mov    $0x0,%eax
  80300b:	a3 40 51 80 00       	mov    %eax,0x805140
  803010:	a1 40 51 80 00       	mov    0x805140,%eax
  803015:	85 c0                	test   %eax,%eax
  803017:	0f 85 57 fe ff ff    	jne    802e74 <alloc_block_FF+0x13>
  80301d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803021:	0f 85 4d fe ff ff    	jne    802e74 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  803027:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80302c:	c9                   	leave  
  80302d:	c3                   	ret    

0080302e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80302e:	55                   	push   %ebp
  80302f:	89 e5                	mov    %esp,%ebp
  803031:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  803034:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80303b:	a1 38 51 80 00       	mov    0x805138,%eax
  803040:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803043:	e9 df 00 00 00       	jmp    803127 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 40 0c             	mov    0xc(%eax),%eax
  80304e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803051:	0f 82 c8 00 00 00    	jb     80311f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  803057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305a:	8b 40 0c             	mov    0xc(%eax),%eax
  80305d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803060:	0f 85 8a 00 00 00    	jne    8030f0 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  803066:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80306a:	75 17                	jne    803083 <alloc_block_BF+0x55>
  80306c:	83 ec 04             	sub    $0x4,%esp
  80306f:	68 04 4c 80 00       	push   $0x804c04
  803074:	68 b7 00 00 00       	push   $0xb7
  803079:	68 5b 4b 80 00       	push   $0x804b5b
  80307e:	e8 70 dd ff ff       	call   800df3 <_panic>
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	85 c0                	test   %eax,%eax
  80308a:	74 10                	je     80309c <alloc_block_BF+0x6e>
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803094:	8b 52 04             	mov    0x4(%edx),%edx
  803097:	89 50 04             	mov    %edx,0x4(%eax)
  80309a:	eb 0b                	jmp    8030a7 <alloc_block_BF+0x79>
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	8b 40 04             	mov    0x4(%eax),%eax
  8030a2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030aa:	8b 40 04             	mov    0x4(%eax),%eax
  8030ad:	85 c0                	test   %eax,%eax
  8030af:	74 0f                	je     8030c0 <alloc_block_BF+0x92>
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	8b 40 04             	mov    0x4(%eax),%eax
  8030b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ba:	8b 12                	mov    (%edx),%edx
  8030bc:	89 10                	mov    %edx,(%eax)
  8030be:	eb 0a                	jmp    8030ca <alloc_block_BF+0x9c>
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e2:	48                   	dec    %eax
  8030e3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8030e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030eb:	e9 4d 01 00 00       	jmp    80323d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f9:	76 24                	jbe    80311f <alloc_block_BF+0xf1>
  8030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803101:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803104:	73 19                	jae    80311f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803106:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803110:	8b 40 0c             	mov    0xc(%eax),%eax
  803113:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803119:	8b 40 08             	mov    0x8(%eax),%eax
  80311c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80311f:	a1 40 51 80 00       	mov    0x805140,%eax
  803124:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803127:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312b:	74 07                	je     803134 <alloc_block_BF+0x106>
  80312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803130:	8b 00                	mov    (%eax),%eax
  803132:	eb 05                	jmp    803139 <alloc_block_BF+0x10b>
  803134:	b8 00 00 00 00       	mov    $0x0,%eax
  803139:	a3 40 51 80 00       	mov    %eax,0x805140
  80313e:	a1 40 51 80 00       	mov    0x805140,%eax
  803143:	85 c0                	test   %eax,%eax
  803145:	0f 85 fd fe ff ff    	jne    803048 <alloc_block_BF+0x1a>
  80314b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80314f:	0f 85 f3 fe ff ff    	jne    803048 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  803155:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803159:	0f 84 d9 00 00 00    	je     803238 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80315f:	a1 48 51 80 00       	mov    0x805148,%eax
  803164:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803167:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80316d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803170:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803173:	8b 55 08             	mov    0x8(%ebp),%edx
  803176:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803179:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80317d:	75 17                	jne    803196 <alloc_block_BF+0x168>
  80317f:	83 ec 04             	sub    $0x4,%esp
  803182:	68 04 4c 80 00       	push   $0x804c04
  803187:	68 c7 00 00 00       	push   $0xc7
  80318c:	68 5b 4b 80 00       	push   $0x804b5b
  803191:	e8 5d dc ff ff       	call   800df3 <_panic>
  803196:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	74 10                	je     8031af <alloc_block_BF+0x181>
  80319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a2:	8b 00                	mov    (%eax),%eax
  8031a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031a7:	8b 52 04             	mov    0x4(%edx),%edx
  8031aa:	89 50 04             	mov    %edx,0x4(%eax)
  8031ad:	eb 0b                	jmp    8031ba <alloc_block_BF+0x18c>
  8031af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b2:	8b 40 04             	mov    0x4(%eax),%eax
  8031b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031bd:	8b 40 04             	mov    0x4(%eax),%eax
  8031c0:	85 c0                	test   %eax,%eax
  8031c2:	74 0f                	je     8031d3 <alloc_block_BF+0x1a5>
  8031c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031cd:	8b 12                	mov    (%edx),%edx
  8031cf:	89 10                	mov    %edx,(%eax)
  8031d1:	eb 0a                	jmp    8031dd <alloc_block_BF+0x1af>
  8031d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d6:	8b 00                	mov    (%eax),%eax
  8031d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8031dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f5:	48                   	dec    %eax
  8031f6:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8031fb:	83 ec 08             	sub    $0x8,%esp
  8031fe:	ff 75 ec             	pushl  -0x14(%ebp)
  803201:	68 38 51 80 00       	push   $0x805138
  803206:	e8 71 f9 ff ff       	call   802b7c <find_block>
  80320b:	83 c4 10             	add    $0x10,%esp
  80320e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803211:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803214:	8b 50 08             	mov    0x8(%eax),%edx
  803217:	8b 45 08             	mov    0x8(%ebp),%eax
  80321a:	01 c2                	add    %eax,%edx
  80321c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80321f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803225:	8b 40 0c             	mov    0xc(%eax),%eax
  803228:	2b 45 08             	sub    0x8(%ebp),%eax
  80322b:	89 c2                	mov    %eax,%edx
  80322d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803230:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803236:	eb 05                	jmp    80323d <alloc_block_BF+0x20f>
	}
	return NULL;
  803238:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80323d:	c9                   	leave  
  80323e:	c3                   	ret    

0080323f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80323f:	55                   	push   %ebp
  803240:	89 e5                	mov    %esp,%ebp
  803242:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803245:	a1 28 50 80 00       	mov    0x805028,%eax
  80324a:	85 c0                	test   %eax,%eax
  80324c:	0f 85 de 01 00 00    	jne    803430 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803252:	a1 38 51 80 00       	mov    0x805138,%eax
  803257:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80325a:	e9 9e 01 00 00       	jmp    8033fd <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803262:	8b 40 0c             	mov    0xc(%eax),%eax
  803265:	3b 45 08             	cmp    0x8(%ebp),%eax
  803268:	0f 82 87 01 00 00    	jb     8033f5 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 40 0c             	mov    0xc(%eax),%eax
  803274:	3b 45 08             	cmp    0x8(%ebp),%eax
  803277:	0f 85 95 00 00 00    	jne    803312 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80327d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803281:	75 17                	jne    80329a <alloc_block_NF+0x5b>
  803283:	83 ec 04             	sub    $0x4,%esp
  803286:	68 04 4c 80 00       	push   $0x804c04
  80328b:	68 e0 00 00 00       	push   $0xe0
  803290:	68 5b 4b 80 00       	push   $0x804b5b
  803295:	e8 59 db ff ff       	call   800df3 <_panic>
  80329a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329d:	8b 00                	mov    (%eax),%eax
  80329f:	85 c0                	test   %eax,%eax
  8032a1:	74 10                	je     8032b3 <alloc_block_NF+0x74>
  8032a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a6:	8b 00                	mov    (%eax),%eax
  8032a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ab:	8b 52 04             	mov    0x4(%edx),%edx
  8032ae:	89 50 04             	mov    %edx,0x4(%eax)
  8032b1:	eb 0b                	jmp    8032be <alloc_block_NF+0x7f>
  8032b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b6:	8b 40 04             	mov    0x4(%eax),%eax
  8032b9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c1:	8b 40 04             	mov    0x4(%eax),%eax
  8032c4:	85 c0                	test   %eax,%eax
  8032c6:	74 0f                	je     8032d7 <alloc_block_NF+0x98>
  8032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d1:	8b 12                	mov    (%edx),%edx
  8032d3:	89 10                	mov    %edx,(%eax)
  8032d5:	eb 0a                	jmp    8032e1 <alloc_block_NF+0xa2>
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	8b 00                	mov    (%eax),%eax
  8032dc:	a3 38 51 80 00       	mov    %eax,0x805138
  8032e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f4:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f9:	48                   	dec    %eax
  8032fa:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8032ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803302:	8b 40 08             	mov    0x8(%eax),%eax
  803305:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80330a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330d:	e9 f8 04 00 00       	jmp    80380a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803315:	8b 40 0c             	mov    0xc(%eax),%eax
  803318:	3b 45 08             	cmp    0x8(%ebp),%eax
  80331b:	0f 86 d4 00 00 00    	jbe    8033f5 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803321:	a1 48 51 80 00       	mov    0x805148,%eax
  803326:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332c:	8b 50 08             	mov    0x8(%eax),%edx
  80332f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803332:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803335:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803338:	8b 55 08             	mov    0x8(%ebp),%edx
  80333b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80333e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803342:	75 17                	jne    80335b <alloc_block_NF+0x11c>
  803344:	83 ec 04             	sub    $0x4,%esp
  803347:	68 04 4c 80 00       	push   $0x804c04
  80334c:	68 e9 00 00 00       	push   $0xe9
  803351:	68 5b 4b 80 00       	push   $0x804b5b
  803356:	e8 98 da ff ff       	call   800df3 <_panic>
  80335b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335e:	8b 00                	mov    (%eax),%eax
  803360:	85 c0                	test   %eax,%eax
  803362:	74 10                	je     803374 <alloc_block_NF+0x135>
  803364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803367:	8b 00                	mov    (%eax),%eax
  803369:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80336c:	8b 52 04             	mov    0x4(%edx),%edx
  80336f:	89 50 04             	mov    %edx,0x4(%eax)
  803372:	eb 0b                	jmp    80337f <alloc_block_NF+0x140>
  803374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803377:	8b 40 04             	mov    0x4(%eax),%eax
  80337a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80337f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803382:	8b 40 04             	mov    0x4(%eax),%eax
  803385:	85 c0                	test   %eax,%eax
  803387:	74 0f                	je     803398 <alloc_block_NF+0x159>
  803389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80338c:	8b 40 04             	mov    0x4(%eax),%eax
  80338f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803392:	8b 12                	mov    (%edx),%edx
  803394:	89 10                	mov    %edx,(%eax)
  803396:	eb 0a                	jmp    8033a2 <alloc_block_NF+0x163>
  803398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339b:	8b 00                	mov    (%eax),%eax
  80339d:	a3 48 51 80 00       	mov    %eax,0x805148
  8033a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ba:	48                   	dec    %eax
  8033bb:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8033c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c3:	8b 40 08             	mov    0x8(%eax),%eax
  8033c6:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ce:	8b 50 08             	mov    0x8(%eax),%edx
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	01 c2                	add    %eax,%edx
  8033d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d9:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8033dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033df:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e2:	2b 45 08             	sub    0x8(%ebp),%eax
  8033e5:	89 c2                	mov    %eax,%edx
  8033e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ea:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8033ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f0:	e9 15 04 00 00       	jmp    80380a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8033f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8033fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803401:	74 07                	je     80340a <alloc_block_NF+0x1cb>
  803403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803406:	8b 00                	mov    (%eax),%eax
  803408:	eb 05                	jmp    80340f <alloc_block_NF+0x1d0>
  80340a:	b8 00 00 00 00       	mov    $0x0,%eax
  80340f:	a3 40 51 80 00       	mov    %eax,0x805140
  803414:	a1 40 51 80 00       	mov    0x805140,%eax
  803419:	85 c0                	test   %eax,%eax
  80341b:	0f 85 3e fe ff ff    	jne    80325f <alloc_block_NF+0x20>
  803421:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803425:	0f 85 34 fe ff ff    	jne    80325f <alloc_block_NF+0x20>
  80342b:	e9 d5 03 00 00       	jmp    803805 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803430:	a1 38 51 80 00       	mov    0x805138,%eax
  803435:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803438:	e9 b1 01 00 00       	jmp    8035ee <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80343d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803440:	8b 50 08             	mov    0x8(%eax),%edx
  803443:	a1 28 50 80 00       	mov    0x805028,%eax
  803448:	39 c2                	cmp    %eax,%edx
  80344a:	0f 82 96 01 00 00    	jb     8035e6 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803453:	8b 40 0c             	mov    0xc(%eax),%eax
  803456:	3b 45 08             	cmp    0x8(%ebp),%eax
  803459:	0f 82 87 01 00 00    	jb     8035e6 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80345f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803462:	8b 40 0c             	mov    0xc(%eax),%eax
  803465:	3b 45 08             	cmp    0x8(%ebp),%eax
  803468:	0f 85 95 00 00 00    	jne    803503 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80346e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803472:	75 17                	jne    80348b <alloc_block_NF+0x24c>
  803474:	83 ec 04             	sub    $0x4,%esp
  803477:	68 04 4c 80 00       	push   $0x804c04
  80347c:	68 fc 00 00 00       	push   $0xfc
  803481:	68 5b 4b 80 00       	push   $0x804b5b
  803486:	e8 68 d9 ff ff       	call   800df3 <_panic>
  80348b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348e:	8b 00                	mov    (%eax),%eax
  803490:	85 c0                	test   %eax,%eax
  803492:	74 10                	je     8034a4 <alloc_block_NF+0x265>
  803494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803497:	8b 00                	mov    (%eax),%eax
  803499:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80349c:	8b 52 04             	mov    0x4(%edx),%edx
  80349f:	89 50 04             	mov    %edx,0x4(%eax)
  8034a2:	eb 0b                	jmp    8034af <alloc_block_NF+0x270>
  8034a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a7:	8b 40 04             	mov    0x4(%eax),%eax
  8034aa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b2:	8b 40 04             	mov    0x4(%eax),%eax
  8034b5:	85 c0                	test   %eax,%eax
  8034b7:	74 0f                	je     8034c8 <alloc_block_NF+0x289>
  8034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bc:	8b 40 04             	mov    0x4(%eax),%eax
  8034bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c2:	8b 12                	mov    (%edx),%edx
  8034c4:	89 10                	mov    %edx,(%eax)
  8034c6:	eb 0a                	jmp    8034d2 <alloc_block_NF+0x293>
  8034c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cb:	8b 00                	mov    (%eax),%eax
  8034cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8034d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e5:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ea:	48                   	dec    %eax
  8034eb:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8034f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f3:	8b 40 08             	mov    0x8(%eax),%eax
  8034f6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	e9 07 03 00 00       	jmp    80380a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803506:	8b 40 0c             	mov    0xc(%eax),%eax
  803509:	3b 45 08             	cmp    0x8(%ebp),%eax
  80350c:	0f 86 d4 00 00 00    	jbe    8035e6 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803512:	a1 48 51 80 00       	mov    0x805148,%eax
  803517:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80351a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351d:	8b 50 08             	mov    0x8(%eax),%edx
  803520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803523:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803526:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803529:	8b 55 08             	mov    0x8(%ebp),%edx
  80352c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80352f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803533:	75 17                	jne    80354c <alloc_block_NF+0x30d>
  803535:	83 ec 04             	sub    $0x4,%esp
  803538:	68 04 4c 80 00       	push   $0x804c04
  80353d:	68 04 01 00 00       	push   $0x104
  803542:	68 5b 4b 80 00       	push   $0x804b5b
  803547:	e8 a7 d8 ff ff       	call   800df3 <_panic>
  80354c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354f:	8b 00                	mov    (%eax),%eax
  803551:	85 c0                	test   %eax,%eax
  803553:	74 10                	je     803565 <alloc_block_NF+0x326>
  803555:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803558:	8b 00                	mov    (%eax),%eax
  80355a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80355d:	8b 52 04             	mov    0x4(%edx),%edx
  803560:	89 50 04             	mov    %edx,0x4(%eax)
  803563:	eb 0b                	jmp    803570 <alloc_block_NF+0x331>
  803565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803568:	8b 40 04             	mov    0x4(%eax),%eax
  80356b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803570:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803573:	8b 40 04             	mov    0x4(%eax),%eax
  803576:	85 c0                	test   %eax,%eax
  803578:	74 0f                	je     803589 <alloc_block_NF+0x34a>
  80357a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357d:	8b 40 04             	mov    0x4(%eax),%eax
  803580:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803583:	8b 12                	mov    (%edx),%edx
  803585:	89 10                	mov    %edx,(%eax)
  803587:	eb 0a                	jmp    803593 <alloc_block_NF+0x354>
  803589:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358c:	8b 00                	mov    (%eax),%eax
  80358e:	a3 48 51 80 00       	mov    %eax,0x805148
  803593:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803596:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80359c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80359f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8035ab:	48                   	dec    %eax
  8035ac:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8035b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b4:	8b 40 08             	mov    0x8(%eax),%eax
  8035b7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8035bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bf:	8b 50 08             	mov    0x8(%eax),%edx
  8035c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c5:	01 c2                	add    %eax,%edx
  8035c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ca:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d3:	2b 45 08             	sub    0x8(%ebp),%eax
  8035d6:	89 c2                	mov    %eax,%edx
  8035d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035db:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8035de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e1:	e9 24 02 00 00       	jmp    80380a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8035e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8035eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f2:	74 07                	je     8035fb <alloc_block_NF+0x3bc>
  8035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f7:	8b 00                	mov    (%eax),%eax
  8035f9:	eb 05                	jmp    803600 <alloc_block_NF+0x3c1>
  8035fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803600:	a3 40 51 80 00       	mov    %eax,0x805140
  803605:	a1 40 51 80 00       	mov    0x805140,%eax
  80360a:	85 c0                	test   %eax,%eax
  80360c:	0f 85 2b fe ff ff    	jne    80343d <alloc_block_NF+0x1fe>
  803612:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803616:	0f 85 21 fe ff ff    	jne    80343d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80361c:	a1 38 51 80 00       	mov    0x805138,%eax
  803621:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803624:	e9 ae 01 00 00       	jmp    8037d7 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362c:	8b 50 08             	mov    0x8(%eax),%edx
  80362f:	a1 28 50 80 00       	mov    0x805028,%eax
  803634:	39 c2                	cmp    %eax,%edx
  803636:	0f 83 93 01 00 00    	jae    8037cf <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80363c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363f:	8b 40 0c             	mov    0xc(%eax),%eax
  803642:	3b 45 08             	cmp    0x8(%ebp),%eax
  803645:	0f 82 84 01 00 00    	jb     8037cf <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80364b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364e:	8b 40 0c             	mov    0xc(%eax),%eax
  803651:	3b 45 08             	cmp    0x8(%ebp),%eax
  803654:	0f 85 95 00 00 00    	jne    8036ef <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80365a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80365e:	75 17                	jne    803677 <alloc_block_NF+0x438>
  803660:	83 ec 04             	sub    $0x4,%esp
  803663:	68 04 4c 80 00       	push   $0x804c04
  803668:	68 14 01 00 00       	push   $0x114
  80366d:	68 5b 4b 80 00       	push   $0x804b5b
  803672:	e8 7c d7 ff ff       	call   800df3 <_panic>
  803677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367a:	8b 00                	mov    (%eax),%eax
  80367c:	85 c0                	test   %eax,%eax
  80367e:	74 10                	je     803690 <alloc_block_NF+0x451>
  803680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803683:	8b 00                	mov    (%eax),%eax
  803685:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803688:	8b 52 04             	mov    0x4(%edx),%edx
  80368b:	89 50 04             	mov    %edx,0x4(%eax)
  80368e:	eb 0b                	jmp    80369b <alloc_block_NF+0x45c>
  803690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803693:	8b 40 04             	mov    0x4(%eax),%eax
  803696:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80369b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369e:	8b 40 04             	mov    0x4(%eax),%eax
  8036a1:	85 c0                	test   %eax,%eax
  8036a3:	74 0f                	je     8036b4 <alloc_block_NF+0x475>
  8036a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a8:	8b 40 04             	mov    0x4(%eax),%eax
  8036ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ae:	8b 12                	mov    (%edx),%edx
  8036b0:	89 10                	mov    %edx,(%eax)
  8036b2:	eb 0a                	jmp    8036be <alloc_block_NF+0x47f>
  8036b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b7:	8b 00                	mov    (%eax),%eax
  8036b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8036be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8036d6:	48                   	dec    %eax
  8036d7:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8036dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036df:	8b 40 08             	mov    0x8(%eax),%eax
  8036e2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8036e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ea:	e9 1b 01 00 00       	jmp    80380a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8036ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036f8:	0f 86 d1 00 00 00    	jbe    8037cf <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8036fe:	a1 48 51 80 00       	mov    0x805148,%eax
  803703:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803709:	8b 50 08             	mov    0x8(%eax),%edx
  80370c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80370f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803712:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803715:	8b 55 08             	mov    0x8(%ebp),%edx
  803718:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80371b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80371f:	75 17                	jne    803738 <alloc_block_NF+0x4f9>
  803721:	83 ec 04             	sub    $0x4,%esp
  803724:	68 04 4c 80 00       	push   $0x804c04
  803729:	68 1c 01 00 00       	push   $0x11c
  80372e:	68 5b 4b 80 00       	push   $0x804b5b
  803733:	e8 bb d6 ff ff       	call   800df3 <_panic>
  803738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80373b:	8b 00                	mov    (%eax),%eax
  80373d:	85 c0                	test   %eax,%eax
  80373f:	74 10                	je     803751 <alloc_block_NF+0x512>
  803741:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803744:	8b 00                	mov    (%eax),%eax
  803746:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803749:	8b 52 04             	mov    0x4(%edx),%edx
  80374c:	89 50 04             	mov    %edx,0x4(%eax)
  80374f:	eb 0b                	jmp    80375c <alloc_block_NF+0x51d>
  803751:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803754:	8b 40 04             	mov    0x4(%eax),%eax
  803757:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80375c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80375f:	8b 40 04             	mov    0x4(%eax),%eax
  803762:	85 c0                	test   %eax,%eax
  803764:	74 0f                	je     803775 <alloc_block_NF+0x536>
  803766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803769:	8b 40 04             	mov    0x4(%eax),%eax
  80376c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80376f:	8b 12                	mov    (%edx),%edx
  803771:	89 10                	mov    %edx,(%eax)
  803773:	eb 0a                	jmp    80377f <alloc_block_NF+0x540>
  803775:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803778:	8b 00                	mov    (%eax),%eax
  80377a:	a3 48 51 80 00       	mov    %eax,0x805148
  80377f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803782:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803788:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80378b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803792:	a1 54 51 80 00       	mov    0x805154,%eax
  803797:	48                   	dec    %eax
  803798:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80379d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a0:	8b 40 08             	mov    0x8(%eax),%eax
  8037a3:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8037a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ab:	8b 50 08             	mov    0x8(%eax),%edx
  8037ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b1:	01 c2                	add    %eax,%edx
  8037b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8037b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8037bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8037c2:	89 c2                	mov    %eax,%edx
  8037c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8037ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037cd:	eb 3b                	jmp    80380a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8037cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8037d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037db:	74 07                	je     8037e4 <alloc_block_NF+0x5a5>
  8037dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e0:	8b 00                	mov    (%eax),%eax
  8037e2:	eb 05                	jmp    8037e9 <alloc_block_NF+0x5aa>
  8037e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8037e9:	a3 40 51 80 00       	mov    %eax,0x805140
  8037ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8037f3:	85 c0                	test   %eax,%eax
  8037f5:	0f 85 2e fe ff ff    	jne    803629 <alloc_block_NF+0x3ea>
  8037fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037ff:	0f 85 24 fe ff ff    	jne    803629 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803805:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80380a:	c9                   	leave  
  80380b:	c3                   	ret    

0080380c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80380c:	55                   	push   %ebp
  80380d:	89 e5                	mov    %esp,%ebp
  80380f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803812:	a1 38 51 80 00       	mov    0x805138,%eax
  803817:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80381a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80381f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803822:	a1 38 51 80 00       	mov    0x805138,%eax
  803827:	85 c0                	test   %eax,%eax
  803829:	74 14                	je     80383f <insert_sorted_with_merge_freeList+0x33>
  80382b:	8b 45 08             	mov    0x8(%ebp),%eax
  80382e:	8b 50 08             	mov    0x8(%eax),%edx
  803831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803834:	8b 40 08             	mov    0x8(%eax),%eax
  803837:	39 c2                	cmp    %eax,%edx
  803839:	0f 87 9b 01 00 00    	ja     8039da <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80383f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803843:	75 17                	jne    80385c <insert_sorted_with_merge_freeList+0x50>
  803845:	83 ec 04             	sub    $0x4,%esp
  803848:	68 38 4b 80 00       	push   $0x804b38
  80384d:	68 38 01 00 00       	push   $0x138
  803852:	68 5b 4b 80 00       	push   $0x804b5b
  803857:	e8 97 d5 ff ff       	call   800df3 <_panic>
  80385c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803862:	8b 45 08             	mov    0x8(%ebp),%eax
  803865:	89 10                	mov    %edx,(%eax)
  803867:	8b 45 08             	mov    0x8(%ebp),%eax
  80386a:	8b 00                	mov    (%eax),%eax
  80386c:	85 c0                	test   %eax,%eax
  80386e:	74 0d                	je     80387d <insert_sorted_with_merge_freeList+0x71>
  803870:	a1 38 51 80 00       	mov    0x805138,%eax
  803875:	8b 55 08             	mov    0x8(%ebp),%edx
  803878:	89 50 04             	mov    %edx,0x4(%eax)
  80387b:	eb 08                	jmp    803885 <insert_sorted_with_merge_freeList+0x79>
  80387d:	8b 45 08             	mov    0x8(%ebp),%eax
  803880:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803885:	8b 45 08             	mov    0x8(%ebp),%eax
  803888:	a3 38 51 80 00       	mov    %eax,0x805138
  80388d:	8b 45 08             	mov    0x8(%ebp),%eax
  803890:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803897:	a1 44 51 80 00       	mov    0x805144,%eax
  80389c:	40                   	inc    %eax
  80389d:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8038a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038a6:	0f 84 a8 06 00 00    	je     803f54 <insert_sorted_with_merge_freeList+0x748>
  8038ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8038af:	8b 50 08             	mov    0x8(%eax),%edx
  8038b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b8:	01 c2                	add    %eax,%edx
  8038ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038bd:	8b 40 08             	mov    0x8(%eax),%eax
  8038c0:	39 c2                	cmp    %eax,%edx
  8038c2:	0f 85 8c 06 00 00    	jne    803f54 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8038c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8038ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8038d4:	01 c2                	add    %eax,%edx
  8038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d9:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8038dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038e0:	75 17                	jne    8038f9 <insert_sorted_with_merge_freeList+0xed>
  8038e2:	83 ec 04             	sub    $0x4,%esp
  8038e5:	68 04 4c 80 00       	push   $0x804c04
  8038ea:	68 3c 01 00 00       	push   $0x13c
  8038ef:	68 5b 4b 80 00       	push   $0x804b5b
  8038f4:	e8 fa d4 ff ff       	call   800df3 <_panic>
  8038f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038fc:	8b 00                	mov    (%eax),%eax
  8038fe:	85 c0                	test   %eax,%eax
  803900:	74 10                	je     803912 <insert_sorted_with_merge_freeList+0x106>
  803902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803905:	8b 00                	mov    (%eax),%eax
  803907:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80390a:	8b 52 04             	mov    0x4(%edx),%edx
  80390d:	89 50 04             	mov    %edx,0x4(%eax)
  803910:	eb 0b                	jmp    80391d <insert_sorted_with_merge_freeList+0x111>
  803912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803915:	8b 40 04             	mov    0x4(%eax),%eax
  803918:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80391d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803920:	8b 40 04             	mov    0x4(%eax),%eax
  803923:	85 c0                	test   %eax,%eax
  803925:	74 0f                	je     803936 <insert_sorted_with_merge_freeList+0x12a>
  803927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392a:	8b 40 04             	mov    0x4(%eax),%eax
  80392d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803930:	8b 12                	mov    (%edx),%edx
  803932:	89 10                	mov    %edx,(%eax)
  803934:	eb 0a                	jmp    803940 <insert_sorted_with_merge_freeList+0x134>
  803936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803939:	8b 00                	mov    (%eax),%eax
  80393b:	a3 38 51 80 00       	mov    %eax,0x805138
  803940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803943:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80394c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803953:	a1 44 51 80 00       	mov    0x805144,%eax
  803958:	48                   	dec    %eax
  803959:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80395e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803961:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80396b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803972:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803976:	75 17                	jne    80398f <insert_sorted_with_merge_freeList+0x183>
  803978:	83 ec 04             	sub    $0x4,%esp
  80397b:	68 38 4b 80 00       	push   $0x804b38
  803980:	68 3f 01 00 00       	push   $0x13f
  803985:	68 5b 4b 80 00       	push   $0x804b5b
  80398a:	e8 64 d4 ff ff       	call   800df3 <_panic>
  80398f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803998:	89 10                	mov    %edx,(%eax)
  80399a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80399d:	8b 00                	mov    (%eax),%eax
  80399f:	85 c0                	test   %eax,%eax
  8039a1:	74 0d                	je     8039b0 <insert_sorted_with_merge_freeList+0x1a4>
  8039a3:	a1 48 51 80 00       	mov    0x805148,%eax
  8039a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039ab:	89 50 04             	mov    %edx,0x4(%eax)
  8039ae:	eb 08                	jmp    8039b8 <insert_sorted_with_merge_freeList+0x1ac>
  8039b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8039c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8039cf:	40                   	inc    %eax
  8039d0:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8039d5:	e9 7a 05 00 00       	jmp    803f54 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8039da:	8b 45 08             	mov    0x8(%ebp),%eax
  8039dd:	8b 50 08             	mov    0x8(%eax),%edx
  8039e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039e3:	8b 40 08             	mov    0x8(%eax),%eax
  8039e6:	39 c2                	cmp    %eax,%edx
  8039e8:	0f 82 14 01 00 00    	jb     803b02 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8039ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039f1:	8b 50 08             	mov    0x8(%eax),%edx
  8039f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8039fa:	01 c2                	add    %eax,%edx
  8039fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ff:	8b 40 08             	mov    0x8(%eax),%eax
  803a02:	39 c2                	cmp    %eax,%edx
  803a04:	0f 85 90 00 00 00    	jne    803a9a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803a0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a0d:	8b 50 0c             	mov    0xc(%eax),%edx
  803a10:	8b 45 08             	mov    0x8(%ebp),%eax
  803a13:	8b 40 0c             	mov    0xc(%eax),%eax
  803a16:	01 c2                	add    %eax,%edx
  803a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a1b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a21:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803a28:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a36:	75 17                	jne    803a4f <insert_sorted_with_merge_freeList+0x243>
  803a38:	83 ec 04             	sub    $0x4,%esp
  803a3b:	68 38 4b 80 00       	push   $0x804b38
  803a40:	68 49 01 00 00       	push   $0x149
  803a45:	68 5b 4b 80 00       	push   $0x804b5b
  803a4a:	e8 a4 d3 ff ff       	call   800df3 <_panic>
  803a4f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a55:	8b 45 08             	mov    0x8(%ebp),%eax
  803a58:	89 10                	mov    %edx,(%eax)
  803a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5d:	8b 00                	mov    (%eax),%eax
  803a5f:	85 c0                	test   %eax,%eax
  803a61:	74 0d                	je     803a70 <insert_sorted_with_merge_freeList+0x264>
  803a63:	a1 48 51 80 00       	mov    0x805148,%eax
  803a68:	8b 55 08             	mov    0x8(%ebp),%edx
  803a6b:	89 50 04             	mov    %edx,0x4(%eax)
  803a6e:	eb 08                	jmp    803a78 <insert_sorted_with_merge_freeList+0x26c>
  803a70:	8b 45 08             	mov    0x8(%ebp),%eax
  803a73:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a78:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7b:	a3 48 51 80 00       	mov    %eax,0x805148
  803a80:	8b 45 08             	mov    0x8(%ebp),%eax
  803a83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a8a:	a1 54 51 80 00       	mov    0x805154,%eax
  803a8f:	40                   	inc    %eax
  803a90:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a95:	e9 bb 04 00 00       	jmp    803f55 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a9e:	75 17                	jne    803ab7 <insert_sorted_with_merge_freeList+0x2ab>
  803aa0:	83 ec 04             	sub    $0x4,%esp
  803aa3:	68 ac 4b 80 00       	push   $0x804bac
  803aa8:	68 4c 01 00 00       	push   $0x14c
  803aad:	68 5b 4b 80 00       	push   $0x804b5b
  803ab2:	e8 3c d3 ff ff       	call   800df3 <_panic>
  803ab7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803abd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac0:	89 50 04             	mov    %edx,0x4(%eax)
  803ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac6:	8b 40 04             	mov    0x4(%eax),%eax
  803ac9:	85 c0                	test   %eax,%eax
  803acb:	74 0c                	je     803ad9 <insert_sorted_with_merge_freeList+0x2cd>
  803acd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  803ad5:	89 10                	mov    %edx,(%eax)
  803ad7:	eb 08                	jmp    803ae1 <insert_sorted_with_merge_freeList+0x2d5>
  803ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  803adc:	a3 38 51 80 00       	mov    %eax,0x805138
  803ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803af2:	a1 44 51 80 00       	mov    0x805144,%eax
  803af7:	40                   	inc    %eax
  803af8:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803afd:	e9 53 04 00 00       	jmp    803f55 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803b02:	a1 38 51 80 00       	mov    0x805138,%eax
  803b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803b0a:	e9 15 04 00 00       	jmp    803f24 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b12:	8b 00                	mov    (%eax),%eax
  803b14:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803b17:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1a:	8b 50 08             	mov    0x8(%eax),%edx
  803b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b20:	8b 40 08             	mov    0x8(%eax),%eax
  803b23:	39 c2                	cmp    %eax,%edx
  803b25:	0f 86 f1 03 00 00    	jbe    803f1c <insert_sorted_with_merge_freeList+0x710>
  803b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2e:	8b 50 08             	mov    0x8(%eax),%edx
  803b31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b34:	8b 40 08             	mov    0x8(%eax),%eax
  803b37:	39 c2                	cmp    %eax,%edx
  803b39:	0f 83 dd 03 00 00    	jae    803f1c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b42:	8b 50 08             	mov    0x8(%eax),%edx
  803b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b48:	8b 40 0c             	mov    0xc(%eax),%eax
  803b4b:	01 c2                	add    %eax,%edx
  803b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b50:	8b 40 08             	mov    0x8(%eax),%eax
  803b53:	39 c2                	cmp    %eax,%edx
  803b55:	0f 85 b9 01 00 00    	jne    803d14 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5e:	8b 50 08             	mov    0x8(%eax),%edx
  803b61:	8b 45 08             	mov    0x8(%ebp),%eax
  803b64:	8b 40 0c             	mov    0xc(%eax),%eax
  803b67:	01 c2                	add    %eax,%edx
  803b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b6c:	8b 40 08             	mov    0x8(%eax),%eax
  803b6f:	39 c2                	cmp    %eax,%edx
  803b71:	0f 85 0d 01 00 00    	jne    803c84 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b7a:	8b 50 0c             	mov    0xc(%eax),%edx
  803b7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b80:	8b 40 0c             	mov    0xc(%eax),%eax
  803b83:	01 c2                	add    %eax,%edx
  803b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b88:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b8b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b8f:	75 17                	jne    803ba8 <insert_sorted_with_merge_freeList+0x39c>
  803b91:	83 ec 04             	sub    $0x4,%esp
  803b94:	68 04 4c 80 00       	push   $0x804c04
  803b99:	68 5c 01 00 00       	push   $0x15c
  803b9e:	68 5b 4b 80 00       	push   $0x804b5b
  803ba3:	e8 4b d2 ff ff       	call   800df3 <_panic>
  803ba8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bab:	8b 00                	mov    (%eax),%eax
  803bad:	85 c0                	test   %eax,%eax
  803baf:	74 10                	je     803bc1 <insert_sorted_with_merge_freeList+0x3b5>
  803bb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb4:	8b 00                	mov    (%eax),%eax
  803bb6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bb9:	8b 52 04             	mov    0x4(%edx),%edx
  803bbc:	89 50 04             	mov    %edx,0x4(%eax)
  803bbf:	eb 0b                	jmp    803bcc <insert_sorted_with_merge_freeList+0x3c0>
  803bc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc4:	8b 40 04             	mov    0x4(%eax),%eax
  803bc7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bcf:	8b 40 04             	mov    0x4(%eax),%eax
  803bd2:	85 c0                	test   %eax,%eax
  803bd4:	74 0f                	je     803be5 <insert_sorted_with_merge_freeList+0x3d9>
  803bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd9:	8b 40 04             	mov    0x4(%eax),%eax
  803bdc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bdf:	8b 12                	mov    (%edx),%edx
  803be1:	89 10                	mov    %edx,(%eax)
  803be3:	eb 0a                	jmp    803bef <insert_sorted_with_merge_freeList+0x3e3>
  803be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be8:	8b 00                	mov    (%eax),%eax
  803bea:	a3 38 51 80 00       	mov    %eax,0x805138
  803bef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bf8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c02:	a1 44 51 80 00       	mov    0x805144,%eax
  803c07:	48                   	dec    %eax
  803c08:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803c0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c10:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803c17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803c21:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c25:	75 17                	jne    803c3e <insert_sorted_with_merge_freeList+0x432>
  803c27:	83 ec 04             	sub    $0x4,%esp
  803c2a:	68 38 4b 80 00       	push   $0x804b38
  803c2f:	68 5f 01 00 00       	push   $0x15f
  803c34:	68 5b 4b 80 00       	push   $0x804b5b
  803c39:	e8 b5 d1 ff ff       	call   800df3 <_panic>
  803c3e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c47:	89 10                	mov    %edx,(%eax)
  803c49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c4c:	8b 00                	mov    (%eax),%eax
  803c4e:	85 c0                	test   %eax,%eax
  803c50:	74 0d                	je     803c5f <insert_sorted_with_merge_freeList+0x453>
  803c52:	a1 48 51 80 00       	mov    0x805148,%eax
  803c57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c5a:	89 50 04             	mov    %edx,0x4(%eax)
  803c5d:	eb 08                	jmp    803c67 <insert_sorted_with_merge_freeList+0x45b>
  803c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c62:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6a:	a3 48 51 80 00       	mov    %eax,0x805148
  803c6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c79:	a1 54 51 80 00       	mov    0x805154,%eax
  803c7e:	40                   	inc    %eax
  803c7f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c87:	8b 50 0c             	mov    0xc(%eax),%edx
  803c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  803c90:	01 c2                	add    %eax,%edx
  803c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c95:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803c98:	8b 45 08             	mov    0x8(%ebp),%eax
  803c9b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ca5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803cac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cb0:	75 17                	jne    803cc9 <insert_sorted_with_merge_freeList+0x4bd>
  803cb2:	83 ec 04             	sub    $0x4,%esp
  803cb5:	68 38 4b 80 00       	push   $0x804b38
  803cba:	68 64 01 00 00       	push   $0x164
  803cbf:	68 5b 4b 80 00       	push   $0x804b5b
  803cc4:	e8 2a d1 ff ff       	call   800df3 <_panic>
  803cc9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd2:	89 10                	mov    %edx,(%eax)
  803cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd7:	8b 00                	mov    (%eax),%eax
  803cd9:	85 c0                	test   %eax,%eax
  803cdb:	74 0d                	je     803cea <insert_sorted_with_merge_freeList+0x4de>
  803cdd:	a1 48 51 80 00       	mov    0x805148,%eax
  803ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  803ce5:	89 50 04             	mov    %edx,0x4(%eax)
  803ce8:	eb 08                	jmp    803cf2 <insert_sorted_with_merge_freeList+0x4e6>
  803cea:	8b 45 08             	mov    0x8(%ebp),%eax
  803ced:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf5:	a3 48 51 80 00       	mov    %eax,0x805148
  803cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d04:	a1 54 51 80 00       	mov    0x805154,%eax
  803d09:	40                   	inc    %eax
  803d0a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803d0f:	e9 41 02 00 00       	jmp    803f55 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803d14:	8b 45 08             	mov    0x8(%ebp),%eax
  803d17:	8b 50 08             	mov    0x8(%eax),%edx
  803d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d1d:	8b 40 0c             	mov    0xc(%eax),%eax
  803d20:	01 c2                	add    %eax,%edx
  803d22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d25:	8b 40 08             	mov    0x8(%eax),%eax
  803d28:	39 c2                	cmp    %eax,%edx
  803d2a:	0f 85 7c 01 00 00    	jne    803eac <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803d30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d34:	74 06                	je     803d3c <insert_sorted_with_merge_freeList+0x530>
  803d36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d3a:	75 17                	jne    803d53 <insert_sorted_with_merge_freeList+0x547>
  803d3c:	83 ec 04             	sub    $0x4,%esp
  803d3f:	68 74 4b 80 00       	push   $0x804b74
  803d44:	68 69 01 00 00       	push   $0x169
  803d49:	68 5b 4b 80 00       	push   $0x804b5b
  803d4e:	e8 a0 d0 ff ff       	call   800df3 <_panic>
  803d53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d56:	8b 50 04             	mov    0x4(%eax),%edx
  803d59:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5c:	89 50 04             	mov    %edx,0x4(%eax)
  803d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d62:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d65:	89 10                	mov    %edx,(%eax)
  803d67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d6a:	8b 40 04             	mov    0x4(%eax),%eax
  803d6d:	85 c0                	test   %eax,%eax
  803d6f:	74 0d                	je     803d7e <insert_sorted_with_merge_freeList+0x572>
  803d71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d74:	8b 40 04             	mov    0x4(%eax),%eax
  803d77:	8b 55 08             	mov    0x8(%ebp),%edx
  803d7a:	89 10                	mov    %edx,(%eax)
  803d7c:	eb 08                	jmp    803d86 <insert_sorted_with_merge_freeList+0x57a>
  803d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d81:	a3 38 51 80 00       	mov    %eax,0x805138
  803d86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d89:	8b 55 08             	mov    0x8(%ebp),%edx
  803d8c:	89 50 04             	mov    %edx,0x4(%eax)
  803d8f:	a1 44 51 80 00       	mov    0x805144,%eax
  803d94:	40                   	inc    %eax
  803d95:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9d:	8b 50 0c             	mov    0xc(%eax),%edx
  803da0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803da3:	8b 40 0c             	mov    0xc(%eax),%eax
  803da6:	01 c2                	add    %eax,%edx
  803da8:	8b 45 08             	mov    0x8(%ebp),%eax
  803dab:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803dae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803db2:	75 17                	jne    803dcb <insert_sorted_with_merge_freeList+0x5bf>
  803db4:	83 ec 04             	sub    $0x4,%esp
  803db7:	68 04 4c 80 00       	push   $0x804c04
  803dbc:	68 6b 01 00 00       	push   $0x16b
  803dc1:	68 5b 4b 80 00       	push   $0x804b5b
  803dc6:	e8 28 d0 ff ff       	call   800df3 <_panic>
  803dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dce:	8b 00                	mov    (%eax),%eax
  803dd0:	85 c0                	test   %eax,%eax
  803dd2:	74 10                	je     803de4 <insert_sorted_with_merge_freeList+0x5d8>
  803dd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dd7:	8b 00                	mov    (%eax),%eax
  803dd9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ddc:	8b 52 04             	mov    0x4(%edx),%edx
  803ddf:	89 50 04             	mov    %edx,0x4(%eax)
  803de2:	eb 0b                	jmp    803def <insert_sorted_with_merge_freeList+0x5e3>
  803de4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803de7:	8b 40 04             	mov    0x4(%eax),%eax
  803dea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803def:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803df2:	8b 40 04             	mov    0x4(%eax),%eax
  803df5:	85 c0                	test   %eax,%eax
  803df7:	74 0f                	je     803e08 <insert_sorted_with_merge_freeList+0x5fc>
  803df9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dfc:	8b 40 04             	mov    0x4(%eax),%eax
  803dff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e02:	8b 12                	mov    (%edx),%edx
  803e04:	89 10                	mov    %edx,(%eax)
  803e06:	eb 0a                	jmp    803e12 <insert_sorted_with_merge_freeList+0x606>
  803e08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e0b:	8b 00                	mov    (%eax),%eax
  803e0d:	a3 38 51 80 00       	mov    %eax,0x805138
  803e12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e25:	a1 44 51 80 00       	mov    0x805144,%eax
  803e2a:	48                   	dec    %eax
  803e2b:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803e30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e33:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803e3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e3d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803e44:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803e48:	75 17                	jne    803e61 <insert_sorted_with_merge_freeList+0x655>
  803e4a:	83 ec 04             	sub    $0x4,%esp
  803e4d:	68 38 4b 80 00       	push   $0x804b38
  803e52:	68 6e 01 00 00       	push   $0x16e
  803e57:	68 5b 4b 80 00       	push   $0x804b5b
  803e5c:	e8 92 cf ff ff       	call   800df3 <_panic>
  803e61:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e6a:	89 10                	mov    %edx,(%eax)
  803e6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e6f:	8b 00                	mov    (%eax),%eax
  803e71:	85 c0                	test   %eax,%eax
  803e73:	74 0d                	je     803e82 <insert_sorted_with_merge_freeList+0x676>
  803e75:	a1 48 51 80 00       	mov    0x805148,%eax
  803e7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e7d:	89 50 04             	mov    %edx,0x4(%eax)
  803e80:	eb 08                	jmp    803e8a <insert_sorted_with_merge_freeList+0x67e>
  803e82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e85:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e8d:	a3 48 51 80 00       	mov    %eax,0x805148
  803e92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e9c:	a1 54 51 80 00       	mov    0x805154,%eax
  803ea1:	40                   	inc    %eax
  803ea2:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ea7:	e9 a9 00 00 00       	jmp    803f55 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803eac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eb0:	74 06                	je     803eb8 <insert_sorted_with_merge_freeList+0x6ac>
  803eb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803eb6:	75 17                	jne    803ecf <insert_sorted_with_merge_freeList+0x6c3>
  803eb8:	83 ec 04             	sub    $0x4,%esp
  803ebb:	68 d0 4b 80 00       	push   $0x804bd0
  803ec0:	68 73 01 00 00       	push   $0x173
  803ec5:	68 5b 4b 80 00       	push   $0x804b5b
  803eca:	e8 24 cf ff ff       	call   800df3 <_panic>
  803ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ed2:	8b 10                	mov    (%eax),%edx
  803ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed7:	89 10                	mov    %edx,(%eax)
  803ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  803edc:	8b 00                	mov    (%eax),%eax
  803ede:	85 c0                	test   %eax,%eax
  803ee0:	74 0b                	je     803eed <insert_sorted_with_merge_freeList+0x6e1>
  803ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ee5:	8b 00                	mov    (%eax),%eax
  803ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  803eea:	89 50 04             	mov    %edx,0x4(%eax)
  803eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  803ef3:	89 10                	mov    %edx,(%eax)
  803ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803efb:	89 50 04             	mov    %edx,0x4(%eax)
  803efe:	8b 45 08             	mov    0x8(%ebp),%eax
  803f01:	8b 00                	mov    (%eax),%eax
  803f03:	85 c0                	test   %eax,%eax
  803f05:	75 08                	jne    803f0f <insert_sorted_with_merge_freeList+0x703>
  803f07:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803f0f:	a1 44 51 80 00       	mov    0x805144,%eax
  803f14:	40                   	inc    %eax
  803f15:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803f1a:	eb 39                	jmp    803f55 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803f1c:	a1 40 51 80 00       	mov    0x805140,%eax
  803f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803f24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f28:	74 07                	je     803f31 <insert_sorted_with_merge_freeList+0x725>
  803f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f2d:	8b 00                	mov    (%eax),%eax
  803f2f:	eb 05                	jmp    803f36 <insert_sorted_with_merge_freeList+0x72a>
  803f31:	b8 00 00 00 00       	mov    $0x0,%eax
  803f36:	a3 40 51 80 00       	mov    %eax,0x805140
  803f3b:	a1 40 51 80 00       	mov    0x805140,%eax
  803f40:	85 c0                	test   %eax,%eax
  803f42:	0f 85 c7 fb ff ff    	jne    803b0f <insert_sorted_with_merge_freeList+0x303>
  803f48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f4c:	0f 85 bd fb ff ff    	jne    803b0f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803f52:	eb 01                	jmp    803f55 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803f54:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803f55:	90                   	nop
  803f56:	c9                   	leave  
  803f57:	c3                   	ret    

00803f58 <__udivdi3>:
  803f58:	55                   	push   %ebp
  803f59:	57                   	push   %edi
  803f5a:	56                   	push   %esi
  803f5b:	53                   	push   %ebx
  803f5c:	83 ec 1c             	sub    $0x1c,%esp
  803f5f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803f63:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803f67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f6b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f6f:	89 ca                	mov    %ecx,%edx
  803f71:	89 f8                	mov    %edi,%eax
  803f73:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803f77:	85 f6                	test   %esi,%esi
  803f79:	75 2d                	jne    803fa8 <__udivdi3+0x50>
  803f7b:	39 cf                	cmp    %ecx,%edi
  803f7d:	77 65                	ja     803fe4 <__udivdi3+0x8c>
  803f7f:	89 fd                	mov    %edi,%ebp
  803f81:	85 ff                	test   %edi,%edi
  803f83:	75 0b                	jne    803f90 <__udivdi3+0x38>
  803f85:	b8 01 00 00 00       	mov    $0x1,%eax
  803f8a:	31 d2                	xor    %edx,%edx
  803f8c:	f7 f7                	div    %edi
  803f8e:	89 c5                	mov    %eax,%ebp
  803f90:	31 d2                	xor    %edx,%edx
  803f92:	89 c8                	mov    %ecx,%eax
  803f94:	f7 f5                	div    %ebp
  803f96:	89 c1                	mov    %eax,%ecx
  803f98:	89 d8                	mov    %ebx,%eax
  803f9a:	f7 f5                	div    %ebp
  803f9c:	89 cf                	mov    %ecx,%edi
  803f9e:	89 fa                	mov    %edi,%edx
  803fa0:	83 c4 1c             	add    $0x1c,%esp
  803fa3:	5b                   	pop    %ebx
  803fa4:	5e                   	pop    %esi
  803fa5:	5f                   	pop    %edi
  803fa6:	5d                   	pop    %ebp
  803fa7:	c3                   	ret    
  803fa8:	39 ce                	cmp    %ecx,%esi
  803faa:	77 28                	ja     803fd4 <__udivdi3+0x7c>
  803fac:	0f bd fe             	bsr    %esi,%edi
  803faf:	83 f7 1f             	xor    $0x1f,%edi
  803fb2:	75 40                	jne    803ff4 <__udivdi3+0x9c>
  803fb4:	39 ce                	cmp    %ecx,%esi
  803fb6:	72 0a                	jb     803fc2 <__udivdi3+0x6a>
  803fb8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803fbc:	0f 87 9e 00 00 00    	ja     804060 <__udivdi3+0x108>
  803fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803fc7:	89 fa                	mov    %edi,%edx
  803fc9:	83 c4 1c             	add    $0x1c,%esp
  803fcc:	5b                   	pop    %ebx
  803fcd:	5e                   	pop    %esi
  803fce:	5f                   	pop    %edi
  803fcf:	5d                   	pop    %ebp
  803fd0:	c3                   	ret    
  803fd1:	8d 76 00             	lea    0x0(%esi),%esi
  803fd4:	31 ff                	xor    %edi,%edi
  803fd6:	31 c0                	xor    %eax,%eax
  803fd8:	89 fa                	mov    %edi,%edx
  803fda:	83 c4 1c             	add    $0x1c,%esp
  803fdd:	5b                   	pop    %ebx
  803fde:	5e                   	pop    %esi
  803fdf:	5f                   	pop    %edi
  803fe0:	5d                   	pop    %ebp
  803fe1:	c3                   	ret    
  803fe2:	66 90                	xchg   %ax,%ax
  803fe4:	89 d8                	mov    %ebx,%eax
  803fe6:	f7 f7                	div    %edi
  803fe8:	31 ff                	xor    %edi,%edi
  803fea:	89 fa                	mov    %edi,%edx
  803fec:	83 c4 1c             	add    $0x1c,%esp
  803fef:	5b                   	pop    %ebx
  803ff0:	5e                   	pop    %esi
  803ff1:	5f                   	pop    %edi
  803ff2:	5d                   	pop    %ebp
  803ff3:	c3                   	ret    
  803ff4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803ff9:	89 eb                	mov    %ebp,%ebx
  803ffb:	29 fb                	sub    %edi,%ebx
  803ffd:	89 f9                	mov    %edi,%ecx
  803fff:	d3 e6                	shl    %cl,%esi
  804001:	89 c5                	mov    %eax,%ebp
  804003:	88 d9                	mov    %bl,%cl
  804005:	d3 ed                	shr    %cl,%ebp
  804007:	89 e9                	mov    %ebp,%ecx
  804009:	09 f1                	or     %esi,%ecx
  80400b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80400f:	89 f9                	mov    %edi,%ecx
  804011:	d3 e0                	shl    %cl,%eax
  804013:	89 c5                	mov    %eax,%ebp
  804015:	89 d6                	mov    %edx,%esi
  804017:	88 d9                	mov    %bl,%cl
  804019:	d3 ee                	shr    %cl,%esi
  80401b:	89 f9                	mov    %edi,%ecx
  80401d:	d3 e2                	shl    %cl,%edx
  80401f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804023:	88 d9                	mov    %bl,%cl
  804025:	d3 e8                	shr    %cl,%eax
  804027:	09 c2                	or     %eax,%edx
  804029:	89 d0                	mov    %edx,%eax
  80402b:	89 f2                	mov    %esi,%edx
  80402d:	f7 74 24 0c          	divl   0xc(%esp)
  804031:	89 d6                	mov    %edx,%esi
  804033:	89 c3                	mov    %eax,%ebx
  804035:	f7 e5                	mul    %ebp
  804037:	39 d6                	cmp    %edx,%esi
  804039:	72 19                	jb     804054 <__udivdi3+0xfc>
  80403b:	74 0b                	je     804048 <__udivdi3+0xf0>
  80403d:	89 d8                	mov    %ebx,%eax
  80403f:	31 ff                	xor    %edi,%edi
  804041:	e9 58 ff ff ff       	jmp    803f9e <__udivdi3+0x46>
  804046:	66 90                	xchg   %ax,%ax
  804048:	8b 54 24 08          	mov    0x8(%esp),%edx
  80404c:	89 f9                	mov    %edi,%ecx
  80404e:	d3 e2                	shl    %cl,%edx
  804050:	39 c2                	cmp    %eax,%edx
  804052:	73 e9                	jae    80403d <__udivdi3+0xe5>
  804054:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804057:	31 ff                	xor    %edi,%edi
  804059:	e9 40 ff ff ff       	jmp    803f9e <__udivdi3+0x46>
  80405e:	66 90                	xchg   %ax,%ax
  804060:	31 c0                	xor    %eax,%eax
  804062:	e9 37 ff ff ff       	jmp    803f9e <__udivdi3+0x46>
  804067:	90                   	nop

00804068 <__umoddi3>:
  804068:	55                   	push   %ebp
  804069:	57                   	push   %edi
  80406a:	56                   	push   %esi
  80406b:	53                   	push   %ebx
  80406c:	83 ec 1c             	sub    $0x1c,%esp
  80406f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804073:	8b 74 24 34          	mov    0x34(%esp),%esi
  804077:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80407b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80407f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804083:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804087:	89 f3                	mov    %esi,%ebx
  804089:	89 fa                	mov    %edi,%edx
  80408b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80408f:	89 34 24             	mov    %esi,(%esp)
  804092:	85 c0                	test   %eax,%eax
  804094:	75 1a                	jne    8040b0 <__umoddi3+0x48>
  804096:	39 f7                	cmp    %esi,%edi
  804098:	0f 86 a2 00 00 00    	jbe    804140 <__umoddi3+0xd8>
  80409e:	89 c8                	mov    %ecx,%eax
  8040a0:	89 f2                	mov    %esi,%edx
  8040a2:	f7 f7                	div    %edi
  8040a4:	89 d0                	mov    %edx,%eax
  8040a6:	31 d2                	xor    %edx,%edx
  8040a8:	83 c4 1c             	add    $0x1c,%esp
  8040ab:	5b                   	pop    %ebx
  8040ac:	5e                   	pop    %esi
  8040ad:	5f                   	pop    %edi
  8040ae:	5d                   	pop    %ebp
  8040af:	c3                   	ret    
  8040b0:	39 f0                	cmp    %esi,%eax
  8040b2:	0f 87 ac 00 00 00    	ja     804164 <__umoddi3+0xfc>
  8040b8:	0f bd e8             	bsr    %eax,%ebp
  8040bb:	83 f5 1f             	xor    $0x1f,%ebp
  8040be:	0f 84 ac 00 00 00    	je     804170 <__umoddi3+0x108>
  8040c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8040c9:	29 ef                	sub    %ebp,%edi
  8040cb:	89 fe                	mov    %edi,%esi
  8040cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8040d1:	89 e9                	mov    %ebp,%ecx
  8040d3:	d3 e0                	shl    %cl,%eax
  8040d5:	89 d7                	mov    %edx,%edi
  8040d7:	89 f1                	mov    %esi,%ecx
  8040d9:	d3 ef                	shr    %cl,%edi
  8040db:	09 c7                	or     %eax,%edi
  8040dd:	89 e9                	mov    %ebp,%ecx
  8040df:	d3 e2                	shl    %cl,%edx
  8040e1:	89 14 24             	mov    %edx,(%esp)
  8040e4:	89 d8                	mov    %ebx,%eax
  8040e6:	d3 e0                	shl    %cl,%eax
  8040e8:	89 c2                	mov    %eax,%edx
  8040ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040ee:	d3 e0                	shl    %cl,%eax
  8040f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040f8:	89 f1                	mov    %esi,%ecx
  8040fa:	d3 e8                	shr    %cl,%eax
  8040fc:	09 d0                	or     %edx,%eax
  8040fe:	d3 eb                	shr    %cl,%ebx
  804100:	89 da                	mov    %ebx,%edx
  804102:	f7 f7                	div    %edi
  804104:	89 d3                	mov    %edx,%ebx
  804106:	f7 24 24             	mull   (%esp)
  804109:	89 c6                	mov    %eax,%esi
  80410b:	89 d1                	mov    %edx,%ecx
  80410d:	39 d3                	cmp    %edx,%ebx
  80410f:	0f 82 87 00 00 00    	jb     80419c <__umoddi3+0x134>
  804115:	0f 84 91 00 00 00    	je     8041ac <__umoddi3+0x144>
  80411b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80411f:	29 f2                	sub    %esi,%edx
  804121:	19 cb                	sbb    %ecx,%ebx
  804123:	89 d8                	mov    %ebx,%eax
  804125:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804129:	d3 e0                	shl    %cl,%eax
  80412b:	89 e9                	mov    %ebp,%ecx
  80412d:	d3 ea                	shr    %cl,%edx
  80412f:	09 d0                	or     %edx,%eax
  804131:	89 e9                	mov    %ebp,%ecx
  804133:	d3 eb                	shr    %cl,%ebx
  804135:	89 da                	mov    %ebx,%edx
  804137:	83 c4 1c             	add    $0x1c,%esp
  80413a:	5b                   	pop    %ebx
  80413b:	5e                   	pop    %esi
  80413c:	5f                   	pop    %edi
  80413d:	5d                   	pop    %ebp
  80413e:	c3                   	ret    
  80413f:	90                   	nop
  804140:	89 fd                	mov    %edi,%ebp
  804142:	85 ff                	test   %edi,%edi
  804144:	75 0b                	jne    804151 <__umoddi3+0xe9>
  804146:	b8 01 00 00 00       	mov    $0x1,%eax
  80414b:	31 d2                	xor    %edx,%edx
  80414d:	f7 f7                	div    %edi
  80414f:	89 c5                	mov    %eax,%ebp
  804151:	89 f0                	mov    %esi,%eax
  804153:	31 d2                	xor    %edx,%edx
  804155:	f7 f5                	div    %ebp
  804157:	89 c8                	mov    %ecx,%eax
  804159:	f7 f5                	div    %ebp
  80415b:	89 d0                	mov    %edx,%eax
  80415d:	e9 44 ff ff ff       	jmp    8040a6 <__umoddi3+0x3e>
  804162:	66 90                	xchg   %ax,%ax
  804164:	89 c8                	mov    %ecx,%eax
  804166:	89 f2                	mov    %esi,%edx
  804168:	83 c4 1c             	add    $0x1c,%esp
  80416b:	5b                   	pop    %ebx
  80416c:	5e                   	pop    %esi
  80416d:	5f                   	pop    %edi
  80416e:	5d                   	pop    %ebp
  80416f:	c3                   	ret    
  804170:	3b 04 24             	cmp    (%esp),%eax
  804173:	72 06                	jb     80417b <__umoddi3+0x113>
  804175:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804179:	77 0f                	ja     80418a <__umoddi3+0x122>
  80417b:	89 f2                	mov    %esi,%edx
  80417d:	29 f9                	sub    %edi,%ecx
  80417f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804183:	89 14 24             	mov    %edx,(%esp)
  804186:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80418a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80418e:	8b 14 24             	mov    (%esp),%edx
  804191:	83 c4 1c             	add    $0x1c,%esp
  804194:	5b                   	pop    %ebx
  804195:	5e                   	pop    %esi
  804196:	5f                   	pop    %edi
  804197:	5d                   	pop    %ebp
  804198:	c3                   	ret    
  804199:	8d 76 00             	lea    0x0(%esi),%esi
  80419c:	2b 04 24             	sub    (%esp),%eax
  80419f:	19 fa                	sbb    %edi,%edx
  8041a1:	89 d1                	mov    %edx,%ecx
  8041a3:	89 c6                	mov    %eax,%esi
  8041a5:	e9 71 ff ff ff       	jmp    80411b <__umoddi3+0xb3>
  8041aa:	66 90                	xchg   %ax,%ax
  8041ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8041b0:	72 ea                	jb     80419c <__umoddi3+0x134>
  8041b2:	89 d9                	mov    %ebx,%ecx
  8041b4:	e9 62 ff ff ff       	jmp    80411b <__umoddi3+0xb3>
