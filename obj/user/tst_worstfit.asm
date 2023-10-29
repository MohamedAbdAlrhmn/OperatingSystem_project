
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
  800048:	e8 14 29 00 00       	call   802961 <sys_set_uheap_strategy>
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
  80009e:	68 80 42 80 00       	push   $0x804280
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 9c 42 80 00       	push   $0x80429c
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
  8000f7:	68 b0 42 80 00       	push   $0x8042b0
  8000fc:	68 c7 42 80 00       	push   $0x8042c7
  800101:	6a 24                	push   $0x24
  800103:	68 9c 42 80 00       	push   $0x80429c
  800108:	e8 e6 0c 00 00       	call   800df3 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 04                	push   $0x4
  800112:	e8 4a 28 00 00       	call   802961 <sys_set_uheap_strategy>
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
  800168:	68 80 42 80 00       	push   $0x804280
  80016d:	6a 36                	push   $0x36
  80016f:	68 9c 42 80 00       	push   $0x80429c
  800174:	e8 7a 0c 00 00       	call   800df3 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 75 cc             	pushl  -0x34(%ebp)
  80017f:	68 dc 42 80 00       	push   $0x8042dc
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
  8001ea:	68 28 43 80 00       	push   $0x804328
  8001ef:	6a 48                	push   $0x48
  8001f1:	68 9c 42 80 00       	push   $0x80429c
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
  80020f:	e8 38 22 00 00       	call   80244c <sys_calculate_free_frames>
  800214:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800217:	e8 d0 22 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  8002af:	68 78 43 80 00       	push   $0x804378
  8002b4:	6a 5d                	push   $0x5d
  8002b6:	68 9c 42 80 00       	push   $0x80429c
  8002bb:	e8 33 0b 00 00       	call   800df3 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002c0:	e8 27 22 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  8002e3:	68 b6 43 80 00       	push   $0x8043b6
  8002e8:	6a 5f                	push   $0x5f
  8002ea:	68 9c 42 80 00       	push   $0x80429c
  8002ef:	e8 ff 0a 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002f7:	e8 50 21 00 00       	call   80244c <sys_calculate_free_frames>
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
  800319:	68 d3 43 80 00       	push   $0x8043d3
  80031e:	6a 60                	push   $0x60
  800320:	68 9c 42 80 00       	push   $0x80429c
  800325:	e8 c9 0a 00 00       	call   800df3 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80032a:	e8 1d 21 00 00       	call   80244c <sys_calculate_free_frames>
  80032f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800332:	e8 b5 21 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  800448:	e8 9f 20 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  80047b:	68 e4 43 80 00       	push   $0x8043e4
  800480:	6a 76                	push   $0x76
  800482:	68 9c 42 80 00       	push   $0x80429c
  800487:	e8 67 09 00 00       	call   800df3 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80048c:	e8 bb 1f 00 00       	call   80244c <sys_calculate_free_frames>
  800491:	89 c2                	mov    %eax,%edx
  800493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 20 44 80 00       	push   $0x804420
  8004a2:	6a 77                	push   $0x77
  8004a4:	68 9c 42 80 00       	push   $0x80429c
  8004a9:	e8 45 09 00 00       	call   800df3 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8004ae:	e8 99 1f 00 00       	call   80244c <sys_calculate_free_frames>
  8004b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b6:	e8 31 20 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  8004dd:	68 60 44 80 00       	push   $0x804460
  8004e2:	6a 7f                	push   $0x7f
  8004e4:	68 9c 42 80 00       	push   $0x80429c
  8004e9:	e8 05 09 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004ee:	e8 f9 1f 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  80050e:	68 b6 43 80 00       	push   $0x8043b6
  800513:	68 80 00 00 00       	push   $0x80
  800518:	68 9c 42 80 00       	push   $0x80429c
  80051d:	e8 d1 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800522:	e8 25 1f 00 00       	call   80244c <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 d3 43 80 00       	push   $0x8043d3
  800538:	68 81 00 00 00       	push   $0x81
  80053d:	68 9c 42 80 00       	push   $0x80429c
  800542:	e8 ac 08 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800547:	ff 45 d0             	incl   -0x30(%ebp)
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d0             	pushl  -0x30(%ebp)
  800550:	68 80 44 80 00       	push   $0x804480
  800555:	e8 4d 0b 00 00       	call   8010a7 <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 ea 1e 00 00       	call   80244c <sys_calculate_free_frames>
  800562:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 82 1f 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  80058f:	68 60 44 80 00       	push   $0x804460
  800594:	68 88 00 00 00       	push   $0x88
  800599:	68 9c 42 80 00       	push   $0x80429c
  80059e:	e8 50 08 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005a3:	e8 44 1f 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  8005c6:	68 b6 43 80 00       	push   $0x8043b6
  8005cb:	68 89 00 00 00       	push   $0x89
  8005d0:	68 9c 42 80 00       	push   $0x80429c
  8005d5:	e8 19 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005da:	e8 6d 1e 00 00       	call   80244c <sys_calculate_free_frames>
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 17                	je     8005ff <_main+0x5c7>
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 d3 43 80 00       	push   $0x8043d3
  8005f0:	68 8a 00 00 00       	push   $0x8a
  8005f5:	68 9c 42 80 00       	push   $0x80429c
  8005fa:	e8 f4 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005ff:	ff 45 d0             	incl   -0x30(%ebp)
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 d0             	pushl  -0x30(%ebp)
  800608:	68 80 44 80 00       	push   $0x804480
  80060d:	e8 95 0a 00 00       	call   8010a7 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800615:	e8 32 1e 00 00       	call   80244c <sys_calculate_free_frames>
  80061a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80061d:	e8 ca 1e 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  80064c:	68 60 44 80 00       	push   $0x804460
  800651:	68 91 00 00 00       	push   $0x91
  800656:	68 9c 42 80 00       	push   $0x80429c
  80065b:	e8 93 07 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800660:	e8 87 1e 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  800688:	68 b6 43 80 00       	push   $0x8043b6
  80068d:	68 92 00 00 00       	push   $0x92
  800692:	68 9c 42 80 00       	push   $0x80429c
  800697:	e8 57 07 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069c:	e8 ab 1d 00 00       	call   80244c <sys_calculate_free_frames>
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	74 17                	je     8006c1 <_main+0x689>
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 d3 43 80 00       	push   $0x8043d3
  8006b2:	68 93 00 00 00       	push   $0x93
  8006b7:	68 9c 42 80 00       	push   $0x80429c
  8006bc:	e8 32 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006c1:	ff 45 d0             	incl   -0x30(%ebp)
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ca:	68 80 44 80 00       	push   $0x804480
  8006cf:	e8 d3 09 00 00       	call   8010a7 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006d7:	e8 70 1d 00 00       	call   80244c <sys_calculate_free_frames>
  8006dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006df:	e8 08 1e 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  80070d:	68 60 44 80 00       	push   $0x804460
  800712:	68 9a 00 00 00       	push   $0x9a
  800717:	68 9c 42 80 00       	push   $0x80429c
  80071c:	e8 d2 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800721:	e8 c6 1d 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  800748:	68 b6 43 80 00       	push   $0x8043b6
  80074d:	68 9b 00 00 00       	push   $0x9b
  800752:	68 9c 42 80 00       	push   $0x80429c
  800757:	e8 97 06 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80075c:	e8 eb 1c 00 00       	call   80244c <sys_calculate_free_frames>
  800761:	89 c2                	mov    %eax,%edx
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	39 c2                	cmp    %eax,%edx
  800768:	74 17                	je     800781 <_main+0x749>
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 d3 43 80 00       	push   $0x8043d3
  800772:	68 9c 00 00 00       	push   $0x9c
  800777:	68 9c 42 80 00       	push   $0x80429c
  80077c:	e8 72 06 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800781:	ff 45 d0             	incl   -0x30(%ebp)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d0             	pushl  -0x30(%ebp)
  80078a:	68 80 44 80 00       	push   $0x804480
  80078f:	e8 13 09 00 00       	call   8010a7 <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800797:	e8 b0 1c 00 00       	call   80244c <sys_calculate_free_frames>
  80079c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80079f:	e8 48 1d 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  8007c9:	68 60 44 80 00       	push   $0x804460
  8007ce:	68 a3 00 00 00       	push   $0xa3
  8007d3:	68 9c 42 80 00       	push   $0x80429c
  8007d8:	e8 16 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007dd:	e8 0a 1d 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  800800:	68 b6 43 80 00       	push   $0x8043b6
  800805:	68 a4 00 00 00       	push   $0xa4
  80080a:	68 9c 42 80 00       	push   $0x80429c
  80080f:	e8 df 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800814:	e8 33 1c 00 00       	call   80244c <sys_calculate_free_frames>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 17                	je     800839 <_main+0x801>
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 d3 43 80 00       	push   $0x8043d3
  80082a:	68 a5 00 00 00       	push   $0xa5
  80082f:	68 9c 42 80 00       	push   $0x80429c
  800834:	e8 ba 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800839:	ff 45 d0             	incl   -0x30(%ebp)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 d0             	pushl  -0x30(%ebp)
  800842:	68 80 44 80 00       	push   $0x804480
  800847:	e8 5b 08 00 00       	call   8010a7 <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80084f:	e8 f8 1b 00 00       	call   80244c <sys_calculate_free_frames>
  800854:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800857:	e8 90 1c 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  800880:	68 60 44 80 00       	push   $0x804460
  800885:	68 ac 00 00 00       	push   $0xac
  80088a:	68 9c 42 80 00       	push   $0x80429c
  80088f:	e8 5f 05 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800894:	e8 53 1c 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  8008b6:	68 b6 43 80 00       	push   $0x8043b6
  8008bb:	68 ad 00 00 00       	push   $0xad
  8008c0:	68 9c 42 80 00       	push   $0x80429c
  8008c5:	e8 29 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008ca:	e8 7d 1b 00 00       	call   80244c <sys_calculate_free_frames>
  8008cf:	89 c2                	mov    %eax,%edx
  8008d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 17                	je     8008ef <_main+0x8b7>
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 d3 43 80 00       	push   $0x8043d3
  8008e0:	68 ae 00 00 00       	push   $0xae
  8008e5:	68 9c 42 80 00       	push   $0x80429c
  8008ea:	e8 04 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ef:	ff 45 d0             	incl   -0x30(%ebp)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 d0             	pushl  -0x30(%ebp)
  8008f8:	68 80 44 80 00       	push   $0x804480
  8008fd:	e8 a5 07 00 00       	call   8010a7 <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800905:	e8 42 1b 00 00       	call   80244c <sys_calculate_free_frames>
  80090a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090d:	e8 da 1b 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  80093e:	68 60 44 80 00       	push   $0x804460
  800943:	68 b5 00 00 00       	push   $0xb5
  800948:	68 9c 42 80 00       	push   $0x80429c
  80094d:	e8 a1 04 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800952:	e8 95 1b 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  80097c:	68 b6 43 80 00       	push   $0x8043b6
  800981:	68 b6 00 00 00       	push   $0xb6
  800986:	68 9c 42 80 00       	push   $0x80429c
  80098b:	e8 63 04 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800990:	e8 b7 1a 00 00       	call   80244c <sys_calculate_free_frames>
  800995:	89 c2                	mov    %eax,%edx
  800997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 17                	je     8009b5 <_main+0x97d>
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	68 d3 43 80 00       	push   $0x8043d3
  8009a6:	68 b7 00 00 00       	push   $0xb7
  8009ab:	68 9c 42 80 00       	push   $0x80429c
  8009b0:	e8 3e 04 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009b5:	ff 45 d0             	incl   -0x30(%ebp)
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8009be:	68 80 44 80 00       	push   $0x804480
  8009c3:	e8 df 06 00 00       	call   8010a7 <cprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 7c 1a 00 00       	call   80244c <sys_calculate_free_frames>
  8009d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 14 1b 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  8009fd:	68 60 44 80 00       	push   $0x804460
  800a02:	68 be 00 00 00       	push   $0xbe
  800a07:	68 9c 42 80 00       	push   $0x80429c
  800a0c:	e8 e2 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a11:	e8 d6 1a 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  800a34:	68 b6 43 80 00       	push   $0x8043b6
  800a39:	68 bf 00 00 00       	push   $0xbf
  800a3e:	68 9c 42 80 00       	push   $0x80429c
  800a43:	e8 ab 03 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a48:	e8 ff 19 00 00       	call   80244c <sys_calculate_free_frames>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 17                	je     800a6d <_main+0xa35>
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 d3 43 80 00       	push   $0x8043d3
  800a5e:	68 c0 00 00 00       	push   $0xc0
  800a63:	68 9c 42 80 00       	push   $0x80429c
  800a68:	e8 86 03 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a6d:	ff 45 d0             	incl   -0x30(%ebp)
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 d0             	pushl  -0x30(%ebp)
  800a76:	68 80 44 80 00       	push   $0x804480
  800a7b:	e8 27 06 00 00       	call   8010a7 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 c4 19 00 00       	call   80244c <sys_calculate_free_frames>
  800a88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 5c 1a 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  800ab2:	68 60 44 80 00       	push   $0x804460
  800ab7:	68 c7 00 00 00       	push   $0xc7
  800abc:	68 9c 42 80 00       	push   $0x80429c
  800ac1:	e8 2d 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800ac6:	e8 21 1a 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  800ae9:	68 b6 43 80 00       	push   $0x8043b6
  800aee:	68 c8 00 00 00       	push   $0xc8
  800af3:	68 9c 42 80 00       	push   $0x80429c
  800af8:	e8 f6 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800afd:	e8 4a 19 00 00       	call   80244c <sys_calculate_free_frames>
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 d3 43 80 00       	push   $0x8043d3
  800b13:	68 c9 00 00 00       	push   $0xc9
  800b18:	68 9c 42 80 00       	push   $0x80429c
  800b1d:	e8 d1 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b22:	ff 45 d0             	incl   -0x30(%ebp)
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 d0             	pushl  -0x30(%ebp)
  800b2b:	68 80 44 80 00       	push   $0x804480
  800b30:	e8 72 05 00 00       	call   8010a7 <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800b38:	e8 0f 19 00 00       	call   80244c <sys_calculate_free_frames>
  800b3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b40:	e8 a7 19 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  800b72:	68 60 44 80 00       	push   $0x804460
  800b77:	68 d0 00 00 00       	push   $0xd0
  800b7c:	68 9c 42 80 00       	push   $0x80429c
  800b81:	e8 6d 02 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800b86:	e8 61 19 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  800bb1:	68 b6 43 80 00       	push   $0x8043b6
  800bb6:	68 d1 00 00 00       	push   $0xd1
  800bbb:	68 9c 42 80 00       	push   $0x80429c
  800bc0:	e8 2e 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bc5:	e8 82 18 00 00       	call   80244c <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 d3 43 80 00       	push   $0x8043d3
  800bdb:	68 d2 00 00 00       	push   $0xd2
  800be0:	68 9c 42 80 00       	push   $0x80429c
  800be5:	e8 09 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bea:	ff 45 d0             	incl   -0x30(%ebp)
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  800bf3:	68 80 44 80 00       	push   $0x804480
  800bf8:	e8 aa 04 00 00       	call   8010a7 <cprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800c00:	e8 47 18 00 00       	call   80244c <sys_calculate_free_frames>
  800c05:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800c08:	e8 df 18 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
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
  800c2f:	68 60 44 80 00       	push   $0x804460
  800c34:	68 da 00 00 00       	push   $0xda
  800c39:	68 9c 42 80 00       	push   $0x80429c
  800c3e:	e8 b0 01 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c43:	e8 a4 18 00 00       	call   8024ec <sys_pf_calculate_allocated_pages>
  800c48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800c4b:	74 17                	je     800c64 <_main+0xc2c>
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	68 b6 43 80 00       	push   $0x8043b6
  800c55:	68 db 00 00 00       	push   $0xdb
  800c5a:	68 9c 42 80 00       	push   $0x80429c
  800c5f:	e8 8f 01 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800c64:	e8 e3 17 00 00       	call   80244c <sys_calculate_free_frames>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6e:	39 c2                	cmp    %eax,%edx
  800c70:	74 17                	je     800c89 <_main+0xc51>
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	68 d3 43 80 00       	push   $0x8043d3
  800c7a:	68 dc 00 00 00       	push   $0xdc
  800c7f:	68 9c 42 80 00       	push   $0x80429c
  800c84:	e8 6a 01 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800c89:	ff 45 d0             	incl   -0x30(%ebp)
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c92:	68 80 44 80 00       	push   $0x804480
  800c97:	e8 0b 04 00 00       	call   8010a7 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	68 94 44 80 00       	push   $0x804494
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
  800cbd:	e8 6a 1a 00 00       	call   80272c <sys_getenvindex>
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
  800d28:	e8 0c 18 00 00       	call   802539 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	68 e8 44 80 00       	push   $0x8044e8
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
  800d58:	68 10 45 80 00       	push   $0x804510
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
  800d89:	68 38 45 80 00       	push   $0x804538
  800d8e:	e8 14 03 00 00       	call   8010a7 <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d96:	a1 20 50 80 00       	mov    0x805020,%eax
  800d9b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	50                   	push   %eax
  800da5:	68 90 45 80 00       	push   $0x804590
  800daa:	e8 f8 02 00 00       	call   8010a7 <cprintf>
  800daf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	68 e8 44 80 00       	push   $0x8044e8
  800dba:	e8 e8 02 00 00       	call   8010a7 <cprintf>
  800dbf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800dc2:	e8 8c 17 00 00       	call   802553 <sys_enable_interrupt>

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
  800dda:	e8 19 19 00 00       	call   8026f8 <sys_destroy_env>
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
  800deb:	e8 6e 19 00 00       	call   80275e <sys_exit_env>
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
  800e14:	68 a4 45 80 00       	push   $0x8045a4
  800e19:	e8 89 02 00 00       	call   8010a7 <cprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800e21:	a1 00 50 80 00       	mov    0x805000,%eax
  800e26:	ff 75 0c             	pushl  0xc(%ebp)
  800e29:	ff 75 08             	pushl  0x8(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	68 a9 45 80 00       	push   $0x8045a9
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
  800e51:	68 c5 45 80 00       	push   $0x8045c5
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
  800e7d:	68 c8 45 80 00       	push   $0x8045c8
  800e82:	6a 26                	push   $0x26
  800e84:	68 14 46 80 00       	push   $0x804614
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
  800f4f:	68 20 46 80 00       	push   $0x804620
  800f54:	6a 3a                	push   $0x3a
  800f56:	68 14 46 80 00       	push   $0x804614
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
  800fbf:	68 74 46 80 00       	push   $0x804674
  800fc4:	6a 44                	push   $0x44
  800fc6:	68 14 46 80 00       	push   $0x804614
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
  801019:	e8 6d 13 00 00       	call   80238b <sys_cputs>
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
  801090:	e8 f6 12 00 00       	call   80238b <sys_cputs>
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
  8010da:	e8 5a 14 00 00       	call   802539 <sys_disable_interrupt>
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
  8010fa:	e8 54 14 00 00       	call   802553 <sys_enable_interrupt>
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
  801144:	e8 c7 2e 00 00       	call   804010 <__udivdi3>
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
  801194:	e8 87 2f 00 00       	call   804120 <__umoddi3>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	05 d4 48 80 00       	add    $0x8048d4,%eax
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
  8012ef:	8b 04 85 f8 48 80 00 	mov    0x8048f8(,%eax,4),%eax
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
  8013d0:	8b 34 9d 40 47 80 00 	mov    0x804740(,%ebx,4),%esi
  8013d7:	85 f6                	test   %esi,%esi
  8013d9:	75 19                	jne    8013f4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8013db:	53                   	push   %ebx
  8013dc:	68 e5 48 80 00       	push   $0x8048e5
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
  8013f5:	68 ee 48 80 00       	push   $0x8048ee
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
  801422:	be f1 48 80 00       	mov    $0x8048f1,%esi
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
  801e48:	68 50 4a 80 00       	push   $0x804a50
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
  801f18:	e8 b2 05 00 00       	call   8024cf <sys_allocate_chunk>
  801f1d:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801f20:	a1 20 51 80 00       	mov    0x805120,%eax
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	50                   	push   %eax
  801f29:	e8 27 0c 00 00       	call   802b55 <initialize_MemBlocksList>
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
  801f56:	68 75 4a 80 00       	push   $0x804a75
  801f5b:	6a 33                	push   $0x33
  801f5d:	68 93 4a 80 00       	push   $0x804a93
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
  801fd5:	68 a0 4a 80 00       	push   $0x804aa0
  801fda:	6a 34                	push   $0x34
  801fdc:	68 93 4a 80 00       	push   $0x804a93
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
  80206d:	e8 2b 08 00 00       	call   80289d <sys_isUHeapPlacementStrategyFIRSTFIT>
  802072:	85 c0                	test   %eax,%eax
  802074:	74 11                	je     802087 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  802076:	83 ec 0c             	sub    $0xc,%esp
  802079:	ff 75 e8             	pushl  -0x18(%ebp)
  80207c:	e8 96 0e 00 00       	call   802f17 <alloc_block_FF>
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
  802093:	e8 f2 0b 00 00       	call   802c8a <insert_sorted_allocList>
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
  8020ad:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	83 ec 08             	sub    $0x8,%esp
  8020b6:	50                   	push   %eax
  8020b7:	68 40 50 80 00       	push   $0x805040
  8020bc:	e8 71 0b 00 00       	call   802c32 <find_block>
  8020c1:	83 c4 10             	add    $0x10,%esp
  8020c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8020c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020cb:	0f 84 a6 00 00 00    	je     802177 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	8b 50 0c             	mov    0xc(%eax),%edx
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	8b 40 08             	mov    0x8(%eax),%eax
  8020dd:	83 ec 08             	sub    $0x8,%esp
  8020e0:	52                   	push   %edx
  8020e1:	50                   	push   %eax
  8020e2:	e8 b0 03 00 00       	call   802497 <sys_free_user_mem>
  8020e7:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8020ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ee:	75 14                	jne    802104 <free+0x5a>
  8020f0:	83 ec 04             	sub    $0x4,%esp
  8020f3:	68 75 4a 80 00       	push   $0x804a75
  8020f8:	6a 74                	push   $0x74
  8020fa:	68 93 4a 80 00       	push   $0x804a93
  8020ff:	e8 ef ec ff ff       	call   800df3 <_panic>
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	8b 00                	mov    (%eax),%eax
  802109:	85 c0                	test   %eax,%eax
  80210b:	74 10                	je     80211d <free+0x73>
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	8b 00                	mov    (%eax),%eax
  802112:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802115:	8b 52 04             	mov    0x4(%edx),%edx
  802118:	89 50 04             	mov    %edx,0x4(%eax)
  80211b:	eb 0b                	jmp    802128 <free+0x7e>
  80211d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802120:	8b 40 04             	mov    0x4(%eax),%eax
  802123:	a3 44 50 80 00       	mov    %eax,0x805044
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	8b 40 04             	mov    0x4(%eax),%eax
  80212e:	85 c0                	test   %eax,%eax
  802130:	74 0f                	je     802141 <free+0x97>
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	8b 40 04             	mov    0x4(%eax),%eax
  802138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213b:	8b 12                	mov    (%edx),%edx
  80213d:	89 10                	mov    %edx,(%eax)
  80213f:	eb 0a                	jmp    80214b <free+0xa1>
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	8b 00                	mov    (%eax),%eax
  802146:	a3 40 50 80 00       	mov    %eax,0x805040
  80214b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80215e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802163:	48                   	dec    %eax
  802164:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  802169:	83 ec 0c             	sub    $0xc,%esp
  80216c:	ff 75 f4             	pushl  -0xc(%ebp)
  80216f:	e8 4e 17 00 00       	call   8038c2 <insert_sorted_with_merge_freeList>
  802174:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	83 ec 08             	sub    $0x8,%esp
  8020b6:	50                   	push   %eax
  8020b7:	68 40 50 80 00       	push   $0x805040
  8020bc:	e8 71 0b 00 00       	call   802c32 <find_block>
  8020c1:	83 c4 10             	add    $0x10,%esp
  8020c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  8020c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020cb:	0f 84 a6 00 00 00    	je     802177 <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	8b 50 0c             	mov    0xc(%eax),%edx
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	8b 40 08             	mov    0x8(%eax),%eax
  8020dd:	83 ec 08             	sub    $0x8,%esp
  8020e0:	52                   	push   %edx
  8020e1:	50                   	push   %eax
  8020e2:	e8 b0 03 00 00       	call   802497 <sys_free_user_mem>
  8020e7:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  8020ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ee:	75 14                	jne    802104 <free+0x5a>
  8020f0:	83 ec 04             	sub    $0x4,%esp
  8020f3:	68 75 4a 80 00       	push   $0x804a75
  8020f8:	6a 7a                	push   $0x7a
  8020fa:	68 93 4a 80 00       	push   $0x804a93
  8020ff:	e8 ef ec ff ff       	call   800df3 <_panic>
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	8b 00                	mov    (%eax),%eax
  802109:	85 c0                	test   %eax,%eax
  80210b:	74 10                	je     80211d <free+0x73>
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	8b 00                	mov    (%eax),%eax
  802112:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802115:	8b 52 04             	mov    0x4(%edx),%edx
  802118:	89 50 04             	mov    %edx,0x4(%eax)
  80211b:	eb 0b                	jmp    802128 <free+0x7e>
  80211d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802120:	8b 40 04             	mov    0x4(%eax),%eax
  802123:	a3 44 50 80 00       	mov    %eax,0x805044
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	8b 40 04             	mov    0x4(%eax),%eax
  80212e:	85 c0                	test   %eax,%eax
  802130:	74 0f                	je     802141 <free+0x97>
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	8b 40 04             	mov    0x4(%eax),%eax
  802138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213b:	8b 12                	mov    (%edx),%edx
  80213d:	89 10                	mov    %edx,(%eax)
  80213f:	eb 0a                	jmp    80214b <free+0xa1>
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	8b 00                	mov    (%eax),%eax
  802146:	a3 40 50 80 00       	mov    %eax,0x805040
  80214b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80215e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802163:	48                   	dec    %eax
  802164:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  802169:	83 ec 0c             	sub    $0xc,%esp
  80216c:	ff 75 f4             	pushl  -0xc(%ebp)
  80216f:	e8 4e 17 00 00       	call   8038c2 <insert_sorted_with_merge_freeList>
  802174:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  802177:	90                   	nop
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	83 ec 38             	sub    $0x38,%esp
  802180:	8b 45 10             	mov    0x10(%ebp),%eax
  802183:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802186:	e8 a6 fc ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  80218b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80218f:	75 0a                	jne    80219b <smalloc+0x21>
  802191:	b8 00 00 00 00       	mov    $0x0,%eax
  802196:	e9 8b 00 00 00       	jmp    802226 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80219b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8021a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a8:	01 d0                	add    %edx,%eax
  8021aa:	48                   	dec    %eax
  8021ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b6:	f7 75 f0             	divl   -0x10(%ebp)
  8021b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021bc:	29 d0                	sub    %edx,%eax
  8021be:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8021c1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8021c8:	e8 d0 06 00 00       	call   80289d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	74 11                	je     8021e2 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8021d1:	83 ec 0c             	sub    $0xc,%esp
  8021d4:	ff 75 e8             	pushl  -0x18(%ebp)
  8021d7:	e8 3b 0d 00 00       	call   802f17 <alloc_block_FF>
  8021dc:	83 c4 10             	add    $0x10,%esp
  8021df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8021e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e6:	74 39                	je     802221 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	8b 40 08             	mov    0x8(%eax),%eax
  8021ee:	89 c2                	mov    %eax,%edx
  8021f0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8021f4:	52                   	push   %edx
  8021f5:	50                   	push   %eax
  8021f6:	ff 75 0c             	pushl  0xc(%ebp)
  8021f9:	ff 75 08             	pushl  0x8(%ebp)
  8021fc:	e8 21 04 00 00       	call   802622 <sys_createSharedObject>
  802201:	83 c4 10             	add    $0x10,%esp
  802204:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  802207:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80220b:	74 14                	je     802221 <smalloc+0xa7>
  80220d:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  802211:	74 0e                	je     802221 <smalloc+0xa7>
  802213:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  802217:	74 08                	je     802221 <smalloc+0xa7>
			return (void*) mem_block->sva;
  802219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221c:	8b 40 08             	mov    0x8(%eax),%eax
  80221f:	eb 05                	jmp    802226 <smalloc+0xac>
	}
	return NULL;
  802221:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80222e:	e8 fe fb ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802233:	83 ec 08             	sub    $0x8,%esp
  802236:	ff 75 0c             	pushl  0xc(%ebp)
  802239:	ff 75 08             	pushl  0x8(%ebp)
  80223c:	e8 0b 04 00 00       	call   80264c <sys_getSizeOfSharedObject>
  802241:	83 c4 10             	add    $0x10,%esp
  802244:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  802247:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80224b:	74 76                	je     8022c3 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80224d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802254:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802257:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80225a:	01 d0                	add    %edx,%eax
  80225c:	48                   	dec    %eax
  80225d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802263:	ba 00 00 00 00       	mov    $0x0,%edx
  802268:	f7 75 ec             	divl   -0x14(%ebp)
  80226b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80226e:	29 d0                	sub    %edx,%eax
  802270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  802273:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80227a:	e8 1e 06 00 00       	call   80289d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80227f:	85 c0                	test   %eax,%eax
  802281:	74 11                	je     802294 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  802283:	83 ec 0c             	sub    $0xc,%esp
  802286:	ff 75 e4             	pushl  -0x1c(%ebp)
  802289:	e8 89 0c 00 00       	call   802f17 <alloc_block_FF>
  80228e:	83 c4 10             	add    $0x10,%esp
  802291:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  802294:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802298:	74 29                	je     8022c3 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 40 08             	mov    0x8(%eax),%eax
  8022a0:	83 ec 04             	sub    $0x4,%esp
  8022a3:	50                   	push   %eax
  8022a4:	ff 75 0c             	pushl  0xc(%ebp)
  8022a7:	ff 75 08             	pushl  0x8(%ebp)
  8022aa:	e8 ba 03 00 00       	call   802669 <sys_getSharedObject>
  8022af:	83 c4 10             	add    $0x10,%esp
  8022b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8022b5:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8022b9:	74 08                	je     8022c3 <sget+0x9b>
				return (void *)mem_block->sva;
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 40 08             	mov    0x8(%eax),%eax
  8022c1:	eb 05                	jmp    8022c8 <sget+0xa0>
		}
	}
	return NULL;
  8022c3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8022d0:	e8 5c fb ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8022d5:	83 ec 04             	sub    $0x4,%esp
  8022d8:	68 c4 4a 80 00       	push   $0x804ac4
<<<<<<< HEAD
  8022dd:	68 fc 00 00 00       	push   $0xfc
=======
  8022dd:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8022e2:	68 93 4a 80 00       	push   $0x804a93
  8022e7:	e8 07 eb ff ff       	call   800df3 <_panic>

008022ec <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8022f2:	83 ec 04             	sub    $0x4,%esp
  8022f5:	68 ec 4a 80 00       	push   $0x804aec
<<<<<<< HEAD
  8022fa:	68 10 01 00 00       	push   $0x110
=======
  8022fa:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8022ff:	68 93 4a 80 00       	push   $0x804a93
  802304:	e8 ea ea ff ff       	call   800df3 <_panic>

00802309 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80230f:	83 ec 04             	sub    $0x4,%esp
  802312:	68 10 4b 80 00       	push   $0x804b10
<<<<<<< HEAD
  802317:	68 1b 01 00 00       	push   $0x11b
=======
  802317:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  80231c:	68 93 4a 80 00       	push   $0x804a93
  802321:	e8 cd ea ff ff       	call   800df3 <_panic>

00802326 <shrink>:

}
void shrink(uint32 newSize)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80232c:	83 ec 04             	sub    $0x4,%esp
  80232f:	68 10 4b 80 00       	push   $0x804b10
<<<<<<< HEAD
  802334:	68 20 01 00 00       	push   $0x120
=======
  802334:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  802339:	68 93 4a 80 00       	push   $0x804a93
  80233e:	e8 b0 ea ff ff       	call   800df3 <_panic>

00802343 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802349:	83 ec 04             	sub    $0x4,%esp
  80234c:	68 10 4b 80 00       	push   $0x804b10
<<<<<<< HEAD
  802351:	68 25 01 00 00       	push   $0x125
=======
  802351:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  802356:	68 93 4a 80 00       	push   $0x804a93
  80235b:	e8 93 ea ff ff       	call   800df3 <_panic>

00802360 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	57                   	push   %edi
  802364:	56                   	push   %esi
  802365:	53                   	push   %ebx
  802366:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802372:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802375:	8b 7d 18             	mov    0x18(%ebp),%edi
  802378:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80237b:	cd 30                	int    $0x30
  80237d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802380:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802383:	83 c4 10             	add    $0x10,%esp
  802386:	5b                   	pop    %ebx
  802387:	5e                   	pop    %esi
  802388:	5f                   	pop    %edi
  802389:	5d                   	pop    %ebp
  80238a:	c3                   	ret    

0080238b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 04             	sub    $0x4,%esp
  802391:	8b 45 10             	mov    0x10(%ebp),%eax
  802394:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802397:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	52                   	push   %edx
  8023a3:	ff 75 0c             	pushl  0xc(%ebp)
  8023a6:	50                   	push   %eax
  8023a7:	6a 00                	push   $0x0
  8023a9:	e8 b2 ff ff ff       	call   802360 <syscall>
  8023ae:	83 c4 18             	add    $0x18,%esp
}
  8023b1:	90                   	nop
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 01                	push   $0x1
  8023c3:	e8 98 ff ff ff       	call   802360 <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8023d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	52                   	push   %edx
  8023dd:	50                   	push   %eax
  8023de:	6a 05                	push   $0x5
  8023e0:	e8 7b ff ff ff       	call   802360 <syscall>
  8023e5:	83 c4 18             	add    $0x18,%esp
}
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
  8023ed:	56                   	push   %esi
  8023ee:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8023ef:	8b 75 18             	mov    0x18(%ebp),%esi
  8023f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	56                   	push   %esi
  8023ff:	53                   	push   %ebx
  802400:	51                   	push   %ecx
  802401:	52                   	push   %edx
  802402:	50                   	push   %eax
  802403:	6a 06                	push   $0x6
  802405:	e8 56 ff ff ff       	call   802360 <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
}
  80240d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802410:	5b                   	pop    %ebx
  802411:	5e                   	pop    %esi
  802412:	5d                   	pop    %ebp
  802413:	c3                   	ret    

00802414 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802417:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	52                   	push   %edx
  802424:	50                   	push   %eax
  802425:	6a 07                	push   $0x7
  802427:	e8 34 ff ff ff       	call   802360 <syscall>
  80242c:	83 c4 18             	add    $0x18,%esp
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	ff 75 0c             	pushl  0xc(%ebp)
  80243d:	ff 75 08             	pushl  0x8(%ebp)
  802440:	6a 08                	push   $0x8
  802442:	e8 19 ff ff ff       	call   802360 <syscall>
  802447:	83 c4 18             	add    $0x18,%esp
}
  80244a:	c9                   	leave  
  80244b:	c3                   	ret    

0080244c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 09                	push   $0x9
  80245b:	e8 00 ff ff ff       	call   802360 <syscall>
  802460:	83 c4 18             	add    $0x18,%esp
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 0a                	push   $0xa
  802474:	e8 e7 fe ff ff       	call   802360 <syscall>
  802479:	83 c4 18             	add    $0x18,%esp
}
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    

0080247e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80247e:	55                   	push   %ebp
  80247f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 0b                	push   $0xb
  80248d:	e8 ce fe ff ff       	call   802360 <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	ff 75 0c             	pushl  0xc(%ebp)
  8024a3:	ff 75 08             	pushl  0x8(%ebp)
  8024a6:	6a 0f                	push   $0xf
  8024a8:	e8 b3 fe ff ff       	call   802360 <syscall>
  8024ad:	83 c4 18             	add    $0x18,%esp
	return;
  8024b0:	90                   	nop
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	ff 75 0c             	pushl  0xc(%ebp)
  8024bf:	ff 75 08             	pushl  0x8(%ebp)
  8024c2:	6a 10                	push   $0x10
  8024c4:	e8 97 fe ff ff       	call   802360 <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024cc:	90                   	nop
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	ff 75 10             	pushl  0x10(%ebp)
  8024d9:	ff 75 0c             	pushl  0xc(%ebp)
  8024dc:	ff 75 08             	pushl  0x8(%ebp)
  8024df:	6a 11                	push   $0x11
  8024e1:	e8 7a fe ff ff       	call   802360 <syscall>
  8024e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e9:	90                   	nop
}
  8024ea:	c9                   	leave  
  8024eb:	c3                   	ret    

008024ec <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 0c                	push   $0xc
  8024fb:	e8 60 fe ff ff       	call   802360 <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	ff 75 08             	pushl  0x8(%ebp)
  802513:	6a 0d                	push   $0xd
  802515:	e8 46 fe ff ff       	call   802360 <syscall>
  80251a:	83 c4 18             	add    $0x18,%esp
}
  80251d:	c9                   	leave  
  80251e:	c3                   	ret    

0080251f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80251f:	55                   	push   %ebp
  802520:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 0e                	push   $0xe
  80252e:	e8 2d fe ff ff       	call   802360 <syscall>
  802533:	83 c4 18             	add    $0x18,%esp
}
  802536:	90                   	nop
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 13                	push   $0x13
  802548:	e8 13 fe ff ff       	call   802360 <syscall>
  80254d:	83 c4 18             	add    $0x18,%esp
}
  802550:	90                   	nop
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 00                	push   $0x0
  80255c:	6a 00                	push   $0x0
  80255e:	6a 00                	push   $0x0
  802560:	6a 14                	push   $0x14
  802562:	e8 f9 fd ff ff       	call   802360 <syscall>
  802567:	83 c4 18             	add    $0x18,%esp
}
  80256a:	90                   	nop
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <sys_cputc>:


void
sys_cputc(const char c)
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
  802570:	83 ec 04             	sub    $0x4,%esp
  802573:	8b 45 08             	mov    0x8(%ebp),%eax
  802576:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802579:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	50                   	push   %eax
  802586:	6a 15                	push   $0x15
  802588:	e8 d3 fd ff ff       	call   802360 <syscall>
  80258d:	83 c4 18             	add    $0x18,%esp
}
  802590:	90                   	nop
  802591:	c9                   	leave  
  802592:	c3                   	ret    

00802593 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802593:	55                   	push   %ebp
  802594:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 16                	push   $0x16
  8025a2:	e8 b9 fd ff ff       	call   802360 <syscall>
  8025a7:	83 c4 18             	add    $0x18,%esp
}
  8025aa:	90                   	nop
  8025ab:	c9                   	leave  
  8025ac:	c3                   	ret    

008025ad <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8025ad:	55                   	push   %ebp
  8025ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8025b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	ff 75 0c             	pushl  0xc(%ebp)
  8025bc:	50                   	push   %eax
  8025bd:	6a 17                	push   $0x17
  8025bf:	e8 9c fd ff ff       	call   802360 <syscall>
  8025c4:	83 c4 18             	add    $0x18,%esp
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	52                   	push   %edx
  8025d9:	50                   	push   %eax
  8025da:	6a 1a                	push   $0x1a
  8025dc:	e8 7f fd ff ff       	call   802360 <syscall>
  8025e1:	83 c4 18             	add    $0x18,%esp
}
  8025e4:	c9                   	leave  
  8025e5:	c3                   	ret    

008025e6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8025e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	52                   	push   %edx
  8025f6:	50                   	push   %eax
  8025f7:	6a 18                	push   $0x18
  8025f9:	e8 62 fd ff ff       	call   802360 <syscall>
  8025fe:	83 c4 18             	add    $0x18,%esp
}
  802601:	90                   	nop
  802602:	c9                   	leave  
  802603:	c3                   	ret    

00802604 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802604:	55                   	push   %ebp
  802605:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	52                   	push   %edx
  802614:	50                   	push   %eax
  802615:	6a 19                	push   $0x19
  802617:	e8 44 fd ff ff       	call   802360 <syscall>
  80261c:	83 c4 18             	add    $0x18,%esp
}
  80261f:	90                   	nop
  802620:	c9                   	leave  
  802621:	c3                   	ret    

00802622 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802622:	55                   	push   %ebp
  802623:	89 e5                	mov    %esp,%ebp
  802625:	83 ec 04             	sub    $0x4,%esp
  802628:	8b 45 10             	mov    0x10(%ebp),%eax
  80262b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80262e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802631:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802635:	8b 45 08             	mov    0x8(%ebp),%eax
  802638:	6a 00                	push   $0x0
  80263a:	51                   	push   %ecx
  80263b:	52                   	push   %edx
  80263c:	ff 75 0c             	pushl  0xc(%ebp)
  80263f:	50                   	push   %eax
  802640:	6a 1b                	push   $0x1b
  802642:	e8 19 fd ff ff       	call   802360 <syscall>
  802647:	83 c4 18             	add    $0x18,%esp
}
  80264a:	c9                   	leave  
  80264b:	c3                   	ret    

0080264c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80264f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	52                   	push   %edx
  80265c:	50                   	push   %eax
  80265d:	6a 1c                	push   $0x1c
  80265f:	e8 fc fc ff ff       	call   802360 <syscall>
  802664:	83 c4 18             	add    $0x18,%esp
}
  802667:	c9                   	leave  
  802668:	c3                   	ret    

00802669 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80266c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80266f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	51                   	push   %ecx
  80267a:	52                   	push   %edx
  80267b:	50                   	push   %eax
  80267c:	6a 1d                	push   $0x1d
  80267e:	e8 dd fc ff ff       	call   802360 <syscall>
  802683:	83 c4 18             	add    $0x18,%esp
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80268b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80268e:	8b 45 08             	mov    0x8(%ebp),%eax
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	52                   	push   %edx
  802698:	50                   	push   %eax
  802699:	6a 1e                	push   $0x1e
  80269b:	e8 c0 fc ff ff       	call   802360 <syscall>
  8026a0:	83 c4 18             	add    $0x18,%esp
}
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 1f                	push   $0x1f
  8026b4:	e8 a7 fc ff ff       	call   802360 <syscall>
  8026b9:	83 c4 18             	add    $0x18,%esp
}
  8026bc:	c9                   	leave  
  8026bd:	c3                   	ret    

008026be <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	6a 00                	push   $0x0
  8026c6:	ff 75 14             	pushl  0x14(%ebp)
  8026c9:	ff 75 10             	pushl  0x10(%ebp)
  8026cc:	ff 75 0c             	pushl  0xc(%ebp)
  8026cf:	50                   	push   %eax
  8026d0:	6a 20                	push   $0x20
  8026d2:	e8 89 fc ff ff       	call   802360 <syscall>
  8026d7:	83 c4 18             	add    $0x18,%esp
}
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	50                   	push   %eax
  8026eb:	6a 21                	push   $0x21
  8026ed:	e8 6e fc ff ff       	call   802360 <syscall>
  8026f2:	83 c4 18             	add    $0x18,%esp
}
  8026f5:	90                   	nop
  8026f6:	c9                   	leave  
  8026f7:	c3                   	ret    

008026f8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8026f8:	55                   	push   %ebp
  8026f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8026fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 00                	push   $0x0
  802706:	50                   	push   %eax
  802707:	6a 22                	push   $0x22
  802709:	e8 52 fc ff ff       	call   802360 <syscall>
  80270e:	83 c4 18             	add    $0x18,%esp
}
  802711:	c9                   	leave  
  802712:	c3                   	ret    

00802713 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802713:	55                   	push   %ebp
  802714:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	6a 02                	push   $0x2
  802722:	e8 39 fc ff ff       	call   802360 <syscall>
  802727:	83 c4 18             	add    $0x18,%esp
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	6a 00                	push   $0x0
  802735:	6a 00                	push   $0x0
  802737:	6a 00                	push   $0x0
  802739:	6a 03                	push   $0x3
  80273b:	e8 20 fc ff ff       	call   802360 <syscall>
  802740:	83 c4 18             	add    $0x18,%esp
}
  802743:	c9                   	leave  
  802744:	c3                   	ret    

00802745 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802748:	6a 00                	push   $0x0
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	6a 00                	push   $0x0
  802752:	6a 04                	push   $0x4
  802754:	e8 07 fc ff ff       	call   802360 <syscall>
  802759:	83 c4 18             	add    $0x18,%esp
}
  80275c:	c9                   	leave  
  80275d:	c3                   	ret    

0080275e <sys_exit_env>:


void sys_exit_env(void)
{
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 23                	push   $0x23
  80276d:	e8 ee fb ff ff       	call   802360 <syscall>
  802772:	83 c4 18             	add    $0x18,%esp
}
  802775:	90                   	nop
  802776:	c9                   	leave  
  802777:	c3                   	ret    

00802778 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
  80277b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80277e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802781:	8d 50 04             	lea    0x4(%eax),%edx
  802784:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	52                   	push   %edx
  80278e:	50                   	push   %eax
  80278f:	6a 24                	push   $0x24
  802791:	e8 ca fb ff ff       	call   802360 <syscall>
  802796:	83 c4 18             	add    $0x18,%esp
	return result;
  802799:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80279c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80279f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027a2:	89 01                	mov    %eax,(%ecx)
  8027a4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8027a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027aa:	c9                   	leave  
  8027ab:	c2 04 00             	ret    $0x4

008027ae <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 00                	push   $0x0
  8027b5:	ff 75 10             	pushl  0x10(%ebp)
  8027b8:	ff 75 0c             	pushl  0xc(%ebp)
  8027bb:	ff 75 08             	pushl  0x8(%ebp)
  8027be:	6a 12                	push   $0x12
  8027c0:	e8 9b fb ff ff       	call   802360 <syscall>
  8027c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c8:	90                   	nop
}
  8027c9:	c9                   	leave  
  8027ca:	c3                   	ret    

008027cb <sys_rcr2>:
uint32 sys_rcr2()
{
  8027cb:	55                   	push   %ebp
  8027cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8027ce:	6a 00                	push   $0x0
  8027d0:	6a 00                	push   $0x0
  8027d2:	6a 00                	push   $0x0
  8027d4:	6a 00                	push   $0x0
  8027d6:	6a 00                	push   $0x0
  8027d8:	6a 25                	push   $0x25
  8027da:	e8 81 fb ff ff       	call   802360 <syscall>
  8027df:	83 c4 18             	add    $0x18,%esp
}
  8027e2:	c9                   	leave  
  8027e3:	c3                   	ret    

008027e4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8027e4:	55                   	push   %ebp
  8027e5:	89 e5                	mov    %esp,%ebp
  8027e7:	83 ec 04             	sub    $0x4,%esp
  8027ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8027f0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 00                	push   $0x0
  8027fa:	6a 00                	push   $0x0
  8027fc:	50                   	push   %eax
  8027fd:	6a 26                	push   $0x26
  8027ff:	e8 5c fb ff ff       	call   802360 <syscall>
  802804:	83 c4 18             	add    $0x18,%esp
	return ;
  802807:	90                   	nop
}
  802808:	c9                   	leave  
  802809:	c3                   	ret    

0080280a <rsttst>:
void rsttst()
{
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80280d:	6a 00                	push   $0x0
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 28                	push   $0x28
  802819:	e8 42 fb ff ff       	call   802360 <syscall>
  80281e:	83 c4 18             	add    $0x18,%esp
	return ;
  802821:	90                   	nop
}
  802822:	c9                   	leave  
  802823:	c3                   	ret    

00802824 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802824:	55                   	push   %ebp
  802825:	89 e5                	mov    %esp,%ebp
  802827:	83 ec 04             	sub    $0x4,%esp
  80282a:	8b 45 14             	mov    0x14(%ebp),%eax
  80282d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802830:	8b 55 18             	mov    0x18(%ebp),%edx
  802833:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802837:	52                   	push   %edx
  802838:	50                   	push   %eax
  802839:	ff 75 10             	pushl  0x10(%ebp)
  80283c:	ff 75 0c             	pushl  0xc(%ebp)
  80283f:	ff 75 08             	pushl  0x8(%ebp)
  802842:	6a 27                	push   $0x27
  802844:	e8 17 fb ff ff       	call   802360 <syscall>
  802849:	83 c4 18             	add    $0x18,%esp
	return ;
  80284c:	90                   	nop
}
  80284d:	c9                   	leave  
  80284e:	c3                   	ret    

0080284f <chktst>:
void chktst(uint32 n)
{
  80284f:	55                   	push   %ebp
  802850:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802852:	6a 00                	push   $0x0
  802854:	6a 00                	push   $0x0
  802856:	6a 00                	push   $0x0
  802858:	6a 00                	push   $0x0
  80285a:	ff 75 08             	pushl  0x8(%ebp)
  80285d:	6a 29                	push   $0x29
  80285f:	e8 fc fa ff ff       	call   802360 <syscall>
  802864:	83 c4 18             	add    $0x18,%esp
	return ;
  802867:	90                   	nop
}
  802868:	c9                   	leave  
  802869:	c3                   	ret    

0080286a <inctst>:

void inctst()
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80286d:	6a 00                	push   $0x0
  80286f:	6a 00                	push   $0x0
  802871:	6a 00                	push   $0x0
  802873:	6a 00                	push   $0x0
  802875:	6a 00                	push   $0x0
  802877:	6a 2a                	push   $0x2a
  802879:	e8 e2 fa ff ff       	call   802360 <syscall>
  80287e:	83 c4 18             	add    $0x18,%esp
	return ;
  802881:	90                   	nop
}
  802882:	c9                   	leave  
  802883:	c3                   	ret    

00802884 <gettst>:
uint32 gettst()
{
  802884:	55                   	push   %ebp
  802885:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802887:	6a 00                	push   $0x0
  802889:	6a 00                	push   $0x0
  80288b:	6a 00                	push   $0x0
  80288d:	6a 00                	push   $0x0
  80288f:	6a 00                	push   $0x0
  802891:	6a 2b                	push   $0x2b
  802893:	e8 c8 fa ff ff       	call   802360 <syscall>
  802898:	83 c4 18             	add    $0x18,%esp
}
  80289b:	c9                   	leave  
  80289c:	c3                   	ret    

0080289d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80289d:	55                   	push   %ebp
  80289e:	89 e5                	mov    %esp,%ebp
  8028a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028a3:	6a 00                	push   $0x0
  8028a5:	6a 00                	push   $0x0
  8028a7:	6a 00                	push   $0x0
  8028a9:	6a 00                	push   $0x0
  8028ab:	6a 00                	push   $0x0
  8028ad:	6a 2c                	push   $0x2c
  8028af:	e8 ac fa ff ff       	call   802360 <syscall>
  8028b4:	83 c4 18             	add    $0x18,%esp
  8028b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8028ba:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8028be:	75 07                	jne    8028c7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8028c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8028c5:	eb 05                	jmp    8028cc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8028c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028cc:	c9                   	leave  
  8028cd:	c3                   	ret    

008028ce <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8028ce:	55                   	push   %ebp
  8028cf:	89 e5                	mov    %esp,%ebp
  8028d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8028d4:	6a 00                	push   $0x0
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	6a 00                	push   $0x0
  8028de:	6a 2c                	push   $0x2c
  8028e0:	e8 7b fa ff ff       	call   802360 <syscall>
  8028e5:	83 c4 18             	add    $0x18,%esp
  8028e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8028eb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8028ef:	75 07                	jne    8028f8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8028f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f6:	eb 05                	jmp    8028fd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8028f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028fd:	c9                   	leave  
  8028fe:	c3                   	ret    

008028ff <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8028ff:	55                   	push   %ebp
  802900:	89 e5                	mov    %esp,%ebp
  802902:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802905:	6a 00                	push   $0x0
  802907:	6a 00                	push   $0x0
  802909:	6a 00                	push   $0x0
  80290b:	6a 00                	push   $0x0
  80290d:	6a 00                	push   $0x0
  80290f:	6a 2c                	push   $0x2c
  802911:	e8 4a fa ff ff       	call   802360 <syscall>
  802916:	83 c4 18             	add    $0x18,%esp
  802919:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80291c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802920:	75 07                	jne    802929 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802922:	b8 01 00 00 00       	mov    $0x1,%eax
  802927:	eb 05                	jmp    80292e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802929:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80292e:	c9                   	leave  
  80292f:	c3                   	ret    

00802930 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802930:	55                   	push   %ebp
  802931:	89 e5                	mov    %esp,%ebp
  802933:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802936:	6a 00                	push   $0x0
  802938:	6a 00                	push   $0x0
  80293a:	6a 00                	push   $0x0
  80293c:	6a 00                	push   $0x0
  80293e:	6a 00                	push   $0x0
  802940:	6a 2c                	push   $0x2c
  802942:	e8 19 fa ff ff       	call   802360 <syscall>
  802947:	83 c4 18             	add    $0x18,%esp
  80294a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80294d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802951:	75 07                	jne    80295a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802953:	b8 01 00 00 00       	mov    $0x1,%eax
  802958:	eb 05                	jmp    80295f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80295a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80295f:	c9                   	leave  
  802960:	c3                   	ret    

00802961 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802961:	55                   	push   %ebp
  802962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802964:	6a 00                	push   $0x0
  802966:	6a 00                	push   $0x0
  802968:	6a 00                	push   $0x0
  80296a:	6a 00                	push   $0x0
  80296c:	ff 75 08             	pushl  0x8(%ebp)
  80296f:	6a 2d                	push   $0x2d
  802971:	e8 ea f9 ff ff       	call   802360 <syscall>
  802976:	83 c4 18             	add    $0x18,%esp
	return ;
  802979:	90                   	nop
}
  80297a:	c9                   	leave  
  80297b:	c3                   	ret    

0080297c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80297c:	55                   	push   %ebp
  80297d:	89 e5                	mov    %esp,%ebp
  80297f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802980:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802983:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802986:	8b 55 0c             	mov    0xc(%ebp),%edx
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	6a 00                	push   $0x0
  80298e:	53                   	push   %ebx
  80298f:	51                   	push   %ecx
  802990:	52                   	push   %edx
  802991:	50                   	push   %eax
  802992:	6a 2e                	push   $0x2e
  802994:	e8 c7 f9 ff ff       	call   802360 <syscall>
  802999:	83 c4 18             	add    $0x18,%esp
}
  80299c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80299f:	c9                   	leave  
  8029a0:	c3                   	ret    

008029a1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8029a1:	55                   	push   %ebp
  8029a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8029a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	6a 00                	push   $0x0
  8029ac:	6a 00                	push   $0x0
  8029ae:	6a 00                	push   $0x0
  8029b0:	52                   	push   %edx
  8029b1:	50                   	push   %eax
  8029b2:	6a 2f                	push   $0x2f
  8029b4:	e8 a7 f9 ff ff       	call   802360 <syscall>
  8029b9:	83 c4 18             	add    $0x18,%esp
}
  8029bc:	c9                   	leave  
  8029bd:	c3                   	ret    

008029be <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8029be:	55                   	push   %ebp
  8029bf:	89 e5                	mov    %esp,%ebp
  8029c1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8029c4:	83 ec 0c             	sub    $0xc,%esp
  8029c7:	68 20 4b 80 00       	push   $0x804b20
  8029cc:	e8 d6 e6 ff ff       	call   8010a7 <cprintf>
  8029d1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8029d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8029db:	83 ec 0c             	sub    $0xc,%esp
  8029de:	68 4c 4b 80 00       	push   $0x804b4c
  8029e3:	e8 bf e6 ff ff       	call   8010a7 <cprintf>
  8029e8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8029eb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8029ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8029f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f7:	eb 56                	jmp    802a4f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029fd:	74 1c                	je     802a1b <print_mem_block_lists+0x5d>
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 50 08             	mov    0x8(%eax),%edx
  802a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a08:	8b 48 08             	mov    0x8(%eax),%ecx
  802a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a11:	01 c8                	add    %ecx,%eax
  802a13:	39 c2                	cmp    %eax,%edx
  802a15:	73 04                	jae    802a1b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802a17:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 50 08             	mov    0x8(%eax),%edx
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 0c             	mov    0xc(%eax),%eax
  802a27:	01 c2                	add    %eax,%edx
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 40 08             	mov    0x8(%eax),%eax
  802a2f:	83 ec 04             	sub    $0x4,%esp
  802a32:	52                   	push   %edx
  802a33:	50                   	push   %eax
  802a34:	68 61 4b 80 00       	push   $0x804b61
  802a39:	e8 69 e6 ff ff       	call   8010a7 <cprintf>
  802a3e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802a47:	a1 40 51 80 00       	mov    0x805140,%eax
  802a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a53:	74 07                	je     802a5c <print_mem_block_lists+0x9e>
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	eb 05                	jmp    802a61 <print_mem_block_lists+0xa3>
  802a5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a61:	a3 40 51 80 00       	mov    %eax,0x805140
  802a66:	a1 40 51 80 00       	mov    0x805140,%eax
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	75 8a                	jne    8029f9 <print_mem_block_lists+0x3b>
  802a6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a73:	75 84                	jne    8029f9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802a75:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a79:	75 10                	jne    802a8b <print_mem_block_lists+0xcd>
  802a7b:	83 ec 0c             	sub    $0xc,%esp
  802a7e:	68 70 4b 80 00       	push   $0x804b70
  802a83:	e8 1f e6 ff ff       	call   8010a7 <cprintf>
  802a88:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802a8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802a92:	83 ec 0c             	sub    $0xc,%esp
  802a95:	68 94 4b 80 00       	push   $0x804b94
  802a9a:	e8 08 e6 ff ff       	call   8010a7 <cprintf>
  802a9f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802aa2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802aa6:	a1 40 50 80 00       	mov    0x805040,%eax
  802aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aae:	eb 56                	jmp    802b06 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802ab0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ab4:	74 1c                	je     802ad2 <print_mem_block_lists+0x114>
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 50 08             	mov    0x8(%eax),%edx
  802abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abf:	8b 48 08             	mov    0x8(%eax),%ecx
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac8:	01 c8                	add    %ecx,%eax
  802aca:	39 c2                	cmp    %eax,%edx
  802acc:	73 04                	jae    802ad2 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802ace:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 50 08             	mov    0x8(%eax),%edx
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ade:	01 c2                	add    %eax,%edx
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 40 08             	mov    0x8(%eax),%eax
  802ae6:	83 ec 04             	sub    $0x4,%esp
  802ae9:	52                   	push   %edx
  802aea:	50                   	push   %eax
  802aeb:	68 61 4b 80 00       	push   $0x804b61
  802af0:	e8 b2 e5 ff ff       	call   8010a7 <cprintf>
  802af5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802afe:	a1 48 50 80 00       	mov    0x805048,%eax
  802b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0a:	74 07                	je     802b13 <print_mem_block_lists+0x155>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	eb 05                	jmp    802b18 <print_mem_block_lists+0x15a>
  802b13:	b8 00 00 00 00       	mov    $0x0,%eax
  802b18:	a3 48 50 80 00       	mov    %eax,0x805048
  802b1d:	a1 48 50 80 00       	mov    0x805048,%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	75 8a                	jne    802ab0 <print_mem_block_lists+0xf2>
  802b26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2a:	75 84                	jne    802ab0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802b2c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802b30:	75 10                	jne    802b42 <print_mem_block_lists+0x184>
  802b32:	83 ec 0c             	sub    $0xc,%esp
  802b35:	68 ac 4b 80 00       	push   $0x804bac
  802b3a:	e8 68 e5 ff ff       	call   8010a7 <cprintf>
  802b3f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802b42:	83 ec 0c             	sub    $0xc,%esp
  802b45:	68 20 4b 80 00       	push   $0x804b20
  802b4a:	e8 58 e5 ff ff       	call   8010a7 <cprintf>
  802b4f:	83 c4 10             	add    $0x10,%esp

}
  802b52:	90                   	nop
  802b53:	c9                   	leave  
  802b54:	c3                   	ret    

00802b55 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802b55:	55                   	push   %ebp
  802b56:	89 e5                	mov    %esp,%ebp
  802b58:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802b5b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802b62:	00 00 00 
  802b65:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802b6c:	00 00 00 
  802b6f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802b76:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802b80:	e9 9e 00 00 00       	jmp    802c23 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802b85:	a1 50 50 80 00       	mov    0x805050,%eax
  802b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8d:	c1 e2 04             	shl    $0x4,%edx
  802b90:	01 d0                	add    %edx,%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	75 14                	jne    802baa <initialize_MemBlocksList+0x55>
  802b96:	83 ec 04             	sub    $0x4,%esp
  802b99:	68 d4 4b 80 00       	push   $0x804bd4
  802b9e:	6a 46                	push   $0x46
  802ba0:	68 f7 4b 80 00       	push   $0x804bf7
  802ba5:	e8 49 e2 ff ff       	call   800df3 <_panic>
  802baa:	a1 50 50 80 00       	mov    0x805050,%eax
  802baf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb2:	c1 e2 04             	shl    $0x4,%edx
  802bb5:	01 d0                	add    %edx,%eax
  802bb7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802bbd:	89 10                	mov    %edx,(%eax)
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	74 18                	je     802bdd <initialize_MemBlocksList+0x88>
  802bc5:	a1 48 51 80 00       	mov    0x805148,%eax
  802bca:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802bd0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802bd3:	c1 e1 04             	shl    $0x4,%ecx
  802bd6:	01 ca                	add    %ecx,%edx
  802bd8:	89 50 04             	mov    %edx,0x4(%eax)
  802bdb:	eb 12                	jmp    802bef <initialize_MemBlocksList+0x9a>
  802bdd:	a1 50 50 80 00       	mov    0x805050,%eax
  802be2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be5:	c1 e2 04             	shl    $0x4,%edx
  802be8:	01 d0                	add    %edx,%eax
  802bea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bef:	a1 50 50 80 00       	mov    0x805050,%eax
  802bf4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf7:	c1 e2 04             	shl    $0x4,%edx
  802bfa:	01 d0                	add    %edx,%eax
  802bfc:	a3 48 51 80 00       	mov    %eax,0x805148
  802c01:	a1 50 50 80 00       	mov    0x805050,%eax
  802c06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c09:	c1 e2 04             	shl    $0x4,%edx
  802c0c:	01 d0                	add    %edx,%eax
  802c0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c15:	a1 54 51 80 00       	mov    0x805154,%eax
  802c1a:	40                   	inc    %eax
  802c1b:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802c20:	ff 45 f4             	incl   -0xc(%ebp)
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c29:	0f 82 56 ff ff ff    	jb     802b85 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802c2f:	90                   	nop
  802c30:	c9                   	leave  
  802c31:	c3                   	ret    

00802c32 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802c32:	55                   	push   %ebp
  802c33:	89 e5                	mov    %esp,%ebp
  802c35:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c40:	eb 19                	jmp    802c5b <find_block+0x29>
	{
		if(va==point->sva)
  802c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c45:	8b 40 08             	mov    0x8(%eax),%eax
  802c48:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802c4b:	75 05                	jne    802c52 <find_block+0x20>
		   return point;
  802c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c50:	eb 36                	jmp    802c88 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	8b 40 08             	mov    0x8(%eax),%eax
  802c58:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802c5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c5f:	74 07                	je     802c68 <find_block+0x36>
  802c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	eb 05                	jmp    802c6d <find_block+0x3b>
  802c68:	b8 00 00 00 00       	mov    $0x0,%eax
  802c6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c70:	89 42 08             	mov    %eax,0x8(%edx)
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	8b 40 08             	mov    0x8(%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	75 c5                	jne    802c42 <find_block+0x10>
  802c7d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802c81:	75 bf                	jne    802c42 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c88:	c9                   	leave  
  802c89:	c3                   	ret    

00802c8a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802c8a:	55                   	push   %ebp
  802c8b:	89 e5                	mov    %esp,%ebp
  802c8d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802c90:	a1 40 50 80 00       	mov    0x805040,%eax
  802c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802c98:	a1 44 50 80 00       	mov    0x805044,%eax
  802c9d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802ca6:	74 24                	je     802ccc <insert_sorted_allocList+0x42>
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	8b 50 08             	mov    0x8(%eax),%edx
  802cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb1:	8b 40 08             	mov    0x8(%eax),%eax
  802cb4:	39 c2                	cmp    %eax,%edx
  802cb6:	76 14                	jbe    802ccc <insert_sorted_allocList+0x42>
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	8b 50 08             	mov    0x8(%eax),%edx
  802cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc1:	8b 40 08             	mov    0x8(%eax),%eax
  802cc4:	39 c2                	cmp    %eax,%edx
  802cc6:	0f 82 60 01 00 00    	jb     802e2c <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802ccc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd0:	75 65                	jne    802d37 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802cd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd6:	75 14                	jne    802cec <insert_sorted_allocList+0x62>
  802cd8:	83 ec 04             	sub    $0x4,%esp
  802cdb:	68 d4 4b 80 00       	push   $0x804bd4
  802ce0:	6a 6b                	push   $0x6b
  802ce2:	68 f7 4b 80 00       	push   $0x804bf7
  802ce7:	e8 07 e1 ff ff       	call   800df3 <_panic>
  802cec:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	89 10                	mov    %edx,(%eax)
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	74 0d                	je     802d0d <insert_sorted_allocList+0x83>
  802d00:	a1 40 50 80 00       	mov    0x805040,%eax
  802d05:	8b 55 08             	mov    0x8(%ebp),%edx
  802d08:	89 50 04             	mov    %edx,0x4(%eax)
  802d0b:	eb 08                	jmp    802d15 <insert_sorted_allocList+0x8b>
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	a3 44 50 80 00       	mov    %eax,0x805044
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	a3 40 50 80 00       	mov    %eax,0x805040
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d27:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d2c:	40                   	inc    %eax
  802d2d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d32:	e9 dc 01 00 00       	jmp    802f13 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	8b 50 08             	mov    0x8(%eax),%edx
  802d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d40:	8b 40 08             	mov    0x8(%eax),%eax
  802d43:	39 c2                	cmp    %eax,%edx
  802d45:	77 6c                	ja     802db3 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802d47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d4b:	74 06                	je     802d53 <insert_sorted_allocList+0xc9>
  802d4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d51:	75 14                	jne    802d67 <insert_sorted_allocList+0xdd>
  802d53:	83 ec 04             	sub    $0x4,%esp
  802d56:	68 10 4c 80 00       	push   $0x804c10
  802d5b:	6a 6f                	push   $0x6f
  802d5d:	68 f7 4b 80 00       	push   $0x804bf7
  802d62:	e8 8c e0 ff ff       	call   800df3 <_panic>
  802d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6a:	8b 50 04             	mov    0x4(%eax),%edx
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	89 50 04             	mov    %edx,0x4(%eax)
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d79:	89 10                	mov    %edx,(%eax)
  802d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7e:	8b 40 04             	mov    0x4(%eax),%eax
  802d81:	85 c0                	test   %eax,%eax
  802d83:	74 0d                	je     802d92 <insert_sorted_allocList+0x108>
  802d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d88:	8b 40 04             	mov    0x4(%eax),%eax
  802d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8e:	89 10                	mov    %edx,(%eax)
  802d90:	eb 08                	jmp    802d9a <insert_sorted_allocList+0x110>
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	a3 40 50 80 00       	mov    %eax,0x805040
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802da0:	89 50 04             	mov    %edx,0x4(%eax)
  802da3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802da8:	40                   	inc    %eax
  802da9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802dae:	e9 60 01 00 00       	jmp    802f13 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	8b 50 08             	mov    0x8(%eax),%edx
  802db9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbc:	8b 40 08             	mov    0x8(%eax),%eax
  802dbf:	39 c2                	cmp    %eax,%edx
  802dc1:	0f 82 4c 01 00 00    	jb     802f13 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dcb:	75 14                	jne    802de1 <insert_sorted_allocList+0x157>
  802dcd:	83 ec 04             	sub    $0x4,%esp
  802dd0:	68 48 4c 80 00       	push   $0x804c48
  802dd5:	6a 73                	push   $0x73
  802dd7:	68 f7 4b 80 00       	push   $0x804bf7
  802ddc:	e8 12 e0 ff ff       	call   800df3 <_panic>
  802de1:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802de7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dea:	89 50 04             	mov    %edx,0x4(%eax)
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	8b 40 04             	mov    0x4(%eax),%eax
  802df3:	85 c0                	test   %eax,%eax
  802df5:	74 0c                	je     802e03 <insert_sorted_allocList+0x179>
  802df7:	a1 44 50 80 00       	mov    0x805044,%eax
  802dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  802dff:	89 10                	mov    %edx,(%eax)
  802e01:	eb 08                	jmp    802e0b <insert_sorted_allocList+0x181>
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	a3 40 50 80 00       	mov    %eax,0x805040
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	a3 44 50 80 00       	mov    %eax,0x805044
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e21:	40                   	inc    %eax
  802e22:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802e27:	e9 e7 00 00 00       	jmp    802f13 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802e32:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802e39:	a1 40 50 80 00       	mov    0x805040,%eax
  802e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e41:	e9 9d 00 00 00       	jmp    802ee3 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	8b 50 08             	mov    0x8(%eax),%edx
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 40 08             	mov    0x8(%eax),%eax
  802e5a:	39 c2                	cmp    %eax,%edx
  802e5c:	76 7d                	jbe    802edb <insert_sorted_allocList+0x251>
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	8b 50 08             	mov    0x8(%eax),%edx
  802e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e67:	8b 40 08             	mov    0x8(%eax),%eax
  802e6a:	39 c2                	cmp    %eax,%edx
  802e6c:	73 6d                	jae    802edb <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802e6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e72:	74 06                	je     802e7a <insert_sorted_allocList+0x1f0>
  802e74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e78:	75 14                	jne    802e8e <insert_sorted_allocList+0x204>
  802e7a:	83 ec 04             	sub    $0x4,%esp
  802e7d:	68 6c 4c 80 00       	push   $0x804c6c
  802e82:	6a 7f                	push   $0x7f
  802e84:	68 f7 4b 80 00       	push   $0x804bf7
  802e89:	e8 65 df ff ff       	call   800df3 <_panic>
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	8b 10                	mov    (%eax),%edx
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	89 10                	mov    %edx,(%eax)
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	85 c0                	test   %eax,%eax
  802e9f:	74 0b                	je     802eac <insert_sorted_allocList+0x222>
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	8b 00                	mov    (%eax),%eax
  802ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea9:	89 50 04             	mov    %edx,0x4(%eax)
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb2:	89 10                	mov    %edx,(%eax)
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eba:	89 50 04             	mov    %edx,0x4(%eax)
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	85 c0                	test   %eax,%eax
  802ec4:	75 08                	jne    802ece <insert_sorted_allocList+0x244>
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	a3 44 50 80 00       	mov    %eax,0x805044
  802ece:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ed3:	40                   	inc    %eax
  802ed4:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802ed9:	eb 39                	jmp    802f14 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802edb:	a1 48 50 80 00       	mov    0x805048,%eax
  802ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee7:	74 07                	je     802ef0 <insert_sorted_allocList+0x266>
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	eb 05                	jmp    802ef5 <insert_sorted_allocList+0x26b>
  802ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef5:	a3 48 50 80 00       	mov    %eax,0x805048
  802efa:	a1 48 50 80 00       	mov    0x805048,%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	0f 85 3f ff ff ff    	jne    802e46 <insert_sorted_allocList+0x1bc>
  802f07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0b:	0f 85 35 ff ff ff    	jne    802e46 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802f11:	eb 01                	jmp    802f14 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802f13:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802f14:	90                   	nop
  802f15:	c9                   	leave  
  802f16:	c3                   	ret    

00802f17 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802f17:	55                   	push   %ebp
  802f18:	89 e5                	mov    %esp,%ebp
  802f1a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802f1d:	a1 38 51 80 00       	mov    0x805138,%eax
  802f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f25:	e9 85 01 00 00       	jmp    8030af <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f30:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f33:	0f 82 6e 01 00 00    	jb     8030a7 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f42:	0f 85 8a 00 00 00    	jne    802fd2 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802f48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4c:	75 17                	jne    802f65 <alloc_block_FF+0x4e>
  802f4e:	83 ec 04             	sub    $0x4,%esp
  802f51:	68 a0 4c 80 00       	push   $0x804ca0
  802f56:	68 93 00 00 00       	push   $0x93
  802f5b:	68 f7 4b 80 00       	push   $0x804bf7
  802f60:	e8 8e de ff ff       	call   800df3 <_panic>
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	8b 00                	mov    (%eax),%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	74 10                	je     802f7e <alloc_block_FF+0x67>
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	8b 00                	mov    (%eax),%eax
  802f73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f76:	8b 52 04             	mov    0x4(%edx),%edx
  802f79:	89 50 04             	mov    %edx,0x4(%eax)
  802f7c:	eb 0b                	jmp    802f89 <alloc_block_FF+0x72>
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 40 04             	mov    0x4(%eax),%eax
  802f84:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	8b 40 04             	mov    0x4(%eax),%eax
  802f8f:	85 c0                	test   %eax,%eax
  802f91:	74 0f                	je     802fa2 <alloc_block_FF+0x8b>
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	8b 40 04             	mov    0x4(%eax),%eax
  802f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9c:	8b 12                	mov    (%edx),%edx
  802f9e:	89 10                	mov    %edx,(%eax)
  802fa0:	eb 0a                	jmp    802fac <alloc_block_FF+0x95>
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 00                	mov    (%eax),%eax
  802fa7:	a3 38 51 80 00       	mov    %eax,0x805138
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbf:	a1 44 51 80 00       	mov    0x805144,%eax
  802fc4:	48                   	dec    %eax
  802fc5:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	e9 10 01 00 00       	jmp    8030e2 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fdb:	0f 86 c6 00 00 00    	jbe    8030a7 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fe1:	a1 48 51 80 00       	mov    0x805148,%eax
  802fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 50 08             	mov    0x8(%eax),%edx
  802fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff2:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffb:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ffe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803002:	75 17                	jne    80301b <alloc_block_FF+0x104>
  803004:	83 ec 04             	sub    $0x4,%esp
  803007:	68 a0 4c 80 00       	push   $0x804ca0
  80300c:	68 9b 00 00 00       	push   $0x9b
  803011:	68 f7 4b 80 00       	push   $0x804bf7
  803016:	e8 d8 dd ff ff       	call   800df3 <_panic>
  80301b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	74 10                	je     803034 <alloc_block_FF+0x11d>
  803024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803027:	8b 00                	mov    (%eax),%eax
  803029:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80302c:	8b 52 04             	mov    0x4(%edx),%edx
  80302f:	89 50 04             	mov    %edx,0x4(%eax)
  803032:	eb 0b                	jmp    80303f <alloc_block_FF+0x128>
  803034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803037:	8b 40 04             	mov    0x4(%eax),%eax
  80303a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80303f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	74 0f                	je     803058 <alloc_block_FF+0x141>
  803049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304c:	8b 40 04             	mov    0x4(%eax),%eax
  80304f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803052:	8b 12                	mov    (%edx),%edx
  803054:	89 10                	mov    %edx,(%eax)
  803056:	eb 0a                	jmp    803062 <alloc_block_FF+0x14b>
  803058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	a3 48 51 80 00       	mov    %eax,0x805148
  803062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803065:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803075:	a1 54 51 80 00       	mov    0x805154,%eax
  80307a:	48                   	dec    %eax
  80307b:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 50 08             	mov    0x8(%eax),%edx
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	01 c2                	add    %eax,%edx
  80308b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	8b 40 0c             	mov    0xc(%eax),%eax
  803097:	2b 45 08             	sub    0x8(%ebp),%eax
  80309a:	89 c2                	mov    %eax,%edx
  80309c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8030a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a5:	eb 3b                	jmp    8030e2 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8030a7:	a1 40 51 80 00       	mov    0x805140,%eax
  8030ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b3:	74 07                	je     8030bc <alloc_block_FF+0x1a5>
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 00                	mov    (%eax),%eax
  8030ba:	eb 05                	jmp    8030c1 <alloc_block_FF+0x1aa>
  8030bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c1:	a3 40 51 80 00       	mov    %eax,0x805140
  8030c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8030cb:	85 c0                	test   %eax,%eax
  8030cd:	0f 85 57 fe ff ff    	jne    802f2a <alloc_block_FF+0x13>
  8030d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d7:	0f 85 4d fe ff ff    	jne    802f2a <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8030dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030e2:	c9                   	leave  
  8030e3:	c3                   	ret    

008030e4 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8030e4:	55                   	push   %ebp
  8030e5:	89 e5                	mov    %esp,%ebp
  8030e7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8030ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8030f1:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f9:	e9 df 00 00 00       	jmp    8031dd <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803101:	8b 40 0c             	mov    0xc(%eax),%eax
  803104:	3b 45 08             	cmp    0x8(%ebp),%eax
  803107:	0f 82 c8 00 00 00    	jb     8031d5 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803110:	8b 40 0c             	mov    0xc(%eax),%eax
  803113:	3b 45 08             	cmp    0x8(%ebp),%eax
  803116:	0f 85 8a 00 00 00    	jne    8031a6 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80311c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803120:	75 17                	jne    803139 <alloc_block_BF+0x55>
  803122:	83 ec 04             	sub    $0x4,%esp
  803125:	68 a0 4c 80 00       	push   $0x804ca0
  80312a:	68 b7 00 00 00       	push   $0xb7
  80312f:	68 f7 4b 80 00       	push   $0x804bf7
  803134:	e8 ba dc ff ff       	call   800df3 <_panic>
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	74 10                	je     803152 <alloc_block_BF+0x6e>
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80314a:	8b 52 04             	mov    0x4(%edx),%edx
  80314d:	89 50 04             	mov    %edx,0x4(%eax)
  803150:	eb 0b                	jmp    80315d <alloc_block_BF+0x79>
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 40 04             	mov    0x4(%eax),%eax
  803158:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	8b 40 04             	mov    0x4(%eax),%eax
  803163:	85 c0                	test   %eax,%eax
  803165:	74 0f                	je     803176 <alloc_block_BF+0x92>
  803167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316a:	8b 40 04             	mov    0x4(%eax),%eax
  80316d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803170:	8b 12                	mov    (%edx),%edx
  803172:	89 10                	mov    %edx,(%eax)
  803174:	eb 0a                	jmp    803180 <alloc_block_BF+0x9c>
  803176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803179:	8b 00                	mov    (%eax),%eax
  80317b:	a3 38 51 80 00       	mov    %eax,0x805138
  803180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803183:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803193:	a1 44 51 80 00       	mov    0x805144,%eax
  803198:	48                   	dec    %eax
  803199:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80319e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a1:	e9 4d 01 00 00       	jmp    8032f3 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031af:	76 24                	jbe    8031d5 <alloc_block_BF+0xf1>
  8031b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031ba:	73 19                	jae    8031d5 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8031bc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	8b 40 08             	mov    0x8(%eax),%eax
  8031d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8031d5:	a1 40 51 80 00       	mov    0x805140,%eax
  8031da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e1:	74 07                	je     8031ea <alloc_block_BF+0x106>
  8031e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	eb 05                	jmp    8031ef <alloc_block_BF+0x10b>
  8031ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8031ef:	a3 40 51 80 00       	mov    %eax,0x805140
  8031f4:	a1 40 51 80 00       	mov    0x805140,%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	0f 85 fd fe ff ff    	jne    8030fe <alloc_block_BF+0x1a>
  803201:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803205:	0f 85 f3 fe ff ff    	jne    8030fe <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80320b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80320f:	0f 84 d9 00 00 00    	je     8032ee <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803215:	a1 48 51 80 00       	mov    0x805148,%eax
  80321a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80321d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803220:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803223:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803229:	8b 55 08             	mov    0x8(%ebp),%edx
  80322c:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80322f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803233:	75 17                	jne    80324c <alloc_block_BF+0x168>
  803235:	83 ec 04             	sub    $0x4,%esp
  803238:	68 a0 4c 80 00       	push   $0x804ca0
  80323d:	68 c7 00 00 00       	push   $0xc7
  803242:	68 f7 4b 80 00       	push   $0x804bf7
  803247:	e8 a7 db ff ff       	call   800df3 <_panic>
  80324c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324f:	8b 00                	mov    (%eax),%eax
  803251:	85 c0                	test   %eax,%eax
  803253:	74 10                	je     803265 <alloc_block_BF+0x181>
  803255:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803258:	8b 00                	mov    (%eax),%eax
  80325a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80325d:	8b 52 04             	mov    0x4(%edx),%edx
  803260:	89 50 04             	mov    %edx,0x4(%eax)
  803263:	eb 0b                	jmp    803270 <alloc_block_BF+0x18c>
  803265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803268:	8b 40 04             	mov    0x4(%eax),%eax
  80326b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803273:	8b 40 04             	mov    0x4(%eax),%eax
  803276:	85 c0                	test   %eax,%eax
  803278:	74 0f                	je     803289 <alloc_block_BF+0x1a5>
  80327a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327d:	8b 40 04             	mov    0x4(%eax),%eax
  803280:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803283:	8b 12                	mov    (%edx),%edx
  803285:	89 10                	mov    %edx,(%eax)
  803287:	eb 0a                	jmp    803293 <alloc_block_BF+0x1af>
  803289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328c:	8b 00                	mov    (%eax),%eax
  80328e:	a3 48 51 80 00       	mov    %eax,0x805148
  803293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80329f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ab:	48                   	dec    %eax
  8032ac:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8032b1:	83 ec 08             	sub    $0x8,%esp
  8032b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8032b7:	68 38 51 80 00       	push   $0x805138
  8032bc:	e8 71 f9 ff ff       	call   802c32 <find_block>
  8032c1:	83 c4 10             	add    $0x10,%esp
  8032c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8032c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ca:	8b 50 08             	mov    0x8(%eax),%edx
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	01 c2                	add    %eax,%edx
  8032d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d5:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8032d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032db:	8b 40 0c             	mov    0xc(%eax),%eax
  8032de:	2b 45 08             	sub    0x8(%ebp),%eax
  8032e1:	89 c2                	mov    %eax,%edx
  8032e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e6:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8032e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ec:	eb 05                	jmp    8032f3 <alloc_block_BF+0x20f>
	}
	return NULL;
  8032ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032f3:	c9                   	leave  
  8032f4:	c3                   	ret    

008032f5 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8032f5:	55                   	push   %ebp
  8032f6:	89 e5                	mov    %esp,%ebp
  8032f8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8032fb:	a1 28 50 80 00       	mov    0x805028,%eax
  803300:	85 c0                	test   %eax,%eax
  803302:	0f 85 de 01 00 00    	jne    8034e6 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803308:	a1 38 51 80 00       	mov    0x805138,%eax
  80330d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803310:	e9 9e 01 00 00       	jmp    8034b3 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803318:	8b 40 0c             	mov    0xc(%eax),%eax
  80331b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80331e:	0f 82 87 01 00 00    	jb     8034ab <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	8b 40 0c             	mov    0xc(%eax),%eax
  80332a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80332d:	0f 85 95 00 00 00    	jne    8033c8 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803337:	75 17                	jne    803350 <alloc_block_NF+0x5b>
  803339:	83 ec 04             	sub    $0x4,%esp
  80333c:	68 a0 4c 80 00       	push   $0x804ca0
  803341:	68 e0 00 00 00       	push   $0xe0
  803346:	68 f7 4b 80 00       	push   $0x804bf7
  80334b:	e8 a3 da ff ff       	call   800df3 <_panic>
  803350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803353:	8b 00                	mov    (%eax),%eax
  803355:	85 c0                	test   %eax,%eax
  803357:	74 10                	je     803369 <alloc_block_NF+0x74>
  803359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803361:	8b 52 04             	mov    0x4(%edx),%edx
  803364:	89 50 04             	mov    %edx,0x4(%eax)
  803367:	eb 0b                	jmp    803374 <alloc_block_NF+0x7f>
  803369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336c:	8b 40 04             	mov    0x4(%eax),%eax
  80336f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803377:	8b 40 04             	mov    0x4(%eax),%eax
  80337a:	85 c0                	test   %eax,%eax
  80337c:	74 0f                	je     80338d <alloc_block_NF+0x98>
  80337e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803381:	8b 40 04             	mov    0x4(%eax),%eax
  803384:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803387:	8b 12                	mov    (%edx),%edx
  803389:	89 10                	mov    %edx,(%eax)
  80338b:	eb 0a                	jmp    803397 <alloc_block_NF+0xa2>
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	8b 00                	mov    (%eax),%eax
  803392:	a3 38 51 80 00       	mov    %eax,0x805138
  803397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8033af:	48                   	dec    %eax
  8033b0:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b8:	8b 40 08             	mov    0x8(%eax),%eax
  8033bb:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8033c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c3:	e9 f8 04 00 00       	jmp    8038c0 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8033c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033d1:	0f 86 d4 00 00 00    	jbe    8034ab <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8033d7:	a1 48 51 80 00       	mov    0x805148,%eax
  8033dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8033df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e2:	8b 50 08             	mov    0x8(%eax),%edx
  8033e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e8:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8033eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f1:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8033f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033f8:	75 17                	jne    803411 <alloc_block_NF+0x11c>
  8033fa:	83 ec 04             	sub    $0x4,%esp
  8033fd:	68 a0 4c 80 00       	push   $0x804ca0
  803402:	68 e9 00 00 00       	push   $0xe9
  803407:	68 f7 4b 80 00       	push   $0x804bf7
  80340c:	e8 e2 d9 ff ff       	call   800df3 <_panic>
  803411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803414:	8b 00                	mov    (%eax),%eax
  803416:	85 c0                	test   %eax,%eax
  803418:	74 10                	je     80342a <alloc_block_NF+0x135>
  80341a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341d:	8b 00                	mov    (%eax),%eax
  80341f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803422:	8b 52 04             	mov    0x4(%edx),%edx
  803425:	89 50 04             	mov    %edx,0x4(%eax)
  803428:	eb 0b                	jmp    803435 <alloc_block_NF+0x140>
  80342a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342d:	8b 40 04             	mov    0x4(%eax),%eax
  803430:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803438:	8b 40 04             	mov    0x4(%eax),%eax
  80343b:	85 c0                	test   %eax,%eax
  80343d:	74 0f                	je     80344e <alloc_block_NF+0x159>
  80343f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803442:	8b 40 04             	mov    0x4(%eax),%eax
  803445:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803448:	8b 12                	mov    (%edx),%edx
  80344a:	89 10                	mov    %edx,(%eax)
  80344c:	eb 0a                	jmp    803458 <alloc_block_NF+0x163>
  80344e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803451:	8b 00                	mov    (%eax),%eax
  803453:	a3 48 51 80 00       	mov    %eax,0x805148
  803458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803464:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346b:	a1 54 51 80 00       	mov    0x805154,%eax
  803470:	48                   	dec    %eax
  803471:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803479:	8b 40 08             	mov    0x8(%eax),%eax
  80347c:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803484:	8b 50 08             	mov    0x8(%eax),%edx
  803487:	8b 45 08             	mov    0x8(%ebp),%eax
  80348a:	01 c2                	add    %eax,%edx
  80348c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803495:	8b 40 0c             	mov    0xc(%eax),%eax
  803498:	2b 45 08             	sub    0x8(%ebp),%eax
  80349b:	89 c2                	mov    %eax,%edx
  80349d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a0:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8034a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a6:	e9 15 04 00 00       	jmp    8038c0 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8034ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8034b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b7:	74 07                	je     8034c0 <alloc_block_NF+0x1cb>
  8034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bc:	8b 00                	mov    (%eax),%eax
  8034be:	eb 05                	jmp    8034c5 <alloc_block_NF+0x1d0>
  8034c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c5:	a3 40 51 80 00       	mov    %eax,0x805140
  8034ca:	a1 40 51 80 00       	mov    0x805140,%eax
  8034cf:	85 c0                	test   %eax,%eax
  8034d1:	0f 85 3e fe ff ff    	jne    803315 <alloc_block_NF+0x20>
  8034d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034db:	0f 85 34 fe ff ff    	jne    803315 <alloc_block_NF+0x20>
  8034e1:	e9 d5 03 00 00       	jmp    8038bb <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8034e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8034eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034ee:	e9 b1 01 00 00       	jmp    8036a4 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f6:	8b 50 08             	mov    0x8(%eax),%edx
  8034f9:	a1 28 50 80 00       	mov    0x805028,%eax
  8034fe:	39 c2                	cmp    %eax,%edx
  803500:	0f 82 96 01 00 00    	jb     80369c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803509:	8b 40 0c             	mov    0xc(%eax),%eax
  80350c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80350f:	0f 82 87 01 00 00    	jb     80369c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803518:	8b 40 0c             	mov    0xc(%eax),%eax
  80351b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80351e:	0f 85 95 00 00 00    	jne    8035b9 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803528:	75 17                	jne    803541 <alloc_block_NF+0x24c>
  80352a:	83 ec 04             	sub    $0x4,%esp
  80352d:	68 a0 4c 80 00       	push   $0x804ca0
  803532:	68 fc 00 00 00       	push   $0xfc
  803537:	68 f7 4b 80 00       	push   $0x804bf7
  80353c:	e8 b2 d8 ff ff       	call   800df3 <_panic>
  803541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803544:	8b 00                	mov    (%eax),%eax
  803546:	85 c0                	test   %eax,%eax
  803548:	74 10                	je     80355a <alloc_block_NF+0x265>
  80354a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354d:	8b 00                	mov    (%eax),%eax
  80354f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803552:	8b 52 04             	mov    0x4(%edx),%edx
  803555:	89 50 04             	mov    %edx,0x4(%eax)
  803558:	eb 0b                	jmp    803565 <alloc_block_NF+0x270>
  80355a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355d:	8b 40 04             	mov    0x4(%eax),%eax
  803560:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803568:	8b 40 04             	mov    0x4(%eax),%eax
  80356b:	85 c0                	test   %eax,%eax
  80356d:	74 0f                	je     80357e <alloc_block_NF+0x289>
  80356f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803572:	8b 40 04             	mov    0x4(%eax),%eax
  803575:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803578:	8b 12                	mov    (%edx),%edx
  80357a:	89 10                	mov    %edx,(%eax)
  80357c:	eb 0a                	jmp    803588 <alloc_block_NF+0x293>
  80357e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803581:	8b 00                	mov    (%eax),%eax
  803583:	a3 38 51 80 00       	mov    %eax,0x805138
  803588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803594:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80359b:	a1 44 51 80 00       	mov    0x805144,%eax
  8035a0:	48                   	dec    %eax
  8035a1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8035a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a9:	8b 40 08             	mov    0x8(%eax),%eax
  8035ac:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8035b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b4:	e9 07 03 00 00       	jmp    8038c0 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8035b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8035bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035c2:	0f 86 d4 00 00 00    	jbe    80369c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8035c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8035cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d3:	8b 50 08             	mov    0x8(%eax),%edx
  8035d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8035dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035df:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8035e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035e9:	75 17                	jne    803602 <alloc_block_NF+0x30d>
  8035eb:	83 ec 04             	sub    $0x4,%esp
  8035ee:	68 a0 4c 80 00       	push   $0x804ca0
  8035f3:	68 04 01 00 00       	push   $0x104
  8035f8:	68 f7 4b 80 00       	push   $0x804bf7
  8035fd:	e8 f1 d7 ff ff       	call   800df3 <_panic>
  803602:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803605:	8b 00                	mov    (%eax),%eax
  803607:	85 c0                	test   %eax,%eax
  803609:	74 10                	je     80361b <alloc_block_NF+0x326>
  80360b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80360e:	8b 00                	mov    (%eax),%eax
  803610:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803613:	8b 52 04             	mov    0x4(%edx),%edx
  803616:	89 50 04             	mov    %edx,0x4(%eax)
  803619:	eb 0b                	jmp    803626 <alloc_block_NF+0x331>
  80361b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361e:	8b 40 04             	mov    0x4(%eax),%eax
  803621:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803626:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803629:	8b 40 04             	mov    0x4(%eax),%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	74 0f                	je     80363f <alloc_block_NF+0x34a>
  803630:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803633:	8b 40 04             	mov    0x4(%eax),%eax
  803636:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803639:	8b 12                	mov    (%edx),%edx
  80363b:	89 10                	mov    %edx,(%eax)
  80363d:	eb 0a                	jmp    803649 <alloc_block_NF+0x354>
  80363f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803642:	8b 00                	mov    (%eax),%eax
  803644:	a3 48 51 80 00       	mov    %eax,0x805148
  803649:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803652:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803655:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365c:	a1 54 51 80 00       	mov    0x805154,%eax
  803661:	48                   	dec    %eax
  803662:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803667:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366a:	8b 40 08             	mov    0x8(%eax),%eax
  80366d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803675:	8b 50 08             	mov    0x8(%eax),%edx
  803678:	8b 45 08             	mov    0x8(%ebp),%eax
  80367b:	01 c2                	add    %eax,%edx
  80367d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803680:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803686:	8b 40 0c             	mov    0xc(%eax),%eax
  803689:	2b 45 08             	sub    0x8(%ebp),%eax
  80368c:	89 c2                	mov    %eax,%edx
  80368e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803691:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803694:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803697:	e9 24 02 00 00       	jmp    8038c0 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80369c:	a1 40 51 80 00       	mov    0x805140,%eax
  8036a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a8:	74 07                	je     8036b1 <alloc_block_NF+0x3bc>
  8036aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	eb 05                	jmp    8036b6 <alloc_block_NF+0x3c1>
  8036b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036b6:	a3 40 51 80 00       	mov    %eax,0x805140
  8036bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8036c0:	85 c0                	test   %eax,%eax
  8036c2:	0f 85 2b fe ff ff    	jne    8034f3 <alloc_block_NF+0x1fe>
  8036c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036cc:	0f 85 21 fe ff ff    	jne    8034f3 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8036d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8036d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036da:	e9 ae 01 00 00       	jmp    80388d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8036df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e2:	8b 50 08             	mov    0x8(%eax),%edx
  8036e5:	a1 28 50 80 00       	mov    0x805028,%eax
  8036ea:	39 c2                	cmp    %eax,%edx
  8036ec:	0f 83 93 01 00 00    	jae    803885 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8036fb:	0f 82 84 01 00 00    	jb     803885 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803704:	8b 40 0c             	mov    0xc(%eax),%eax
  803707:	3b 45 08             	cmp    0x8(%ebp),%eax
  80370a:	0f 85 95 00 00 00    	jne    8037a5 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803710:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803714:	75 17                	jne    80372d <alloc_block_NF+0x438>
  803716:	83 ec 04             	sub    $0x4,%esp
  803719:	68 a0 4c 80 00       	push   $0x804ca0
  80371e:	68 14 01 00 00       	push   $0x114
  803723:	68 f7 4b 80 00       	push   $0x804bf7
  803728:	e8 c6 d6 ff ff       	call   800df3 <_panic>
  80372d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803730:	8b 00                	mov    (%eax),%eax
  803732:	85 c0                	test   %eax,%eax
  803734:	74 10                	je     803746 <alloc_block_NF+0x451>
  803736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803739:	8b 00                	mov    (%eax),%eax
  80373b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80373e:	8b 52 04             	mov    0x4(%edx),%edx
  803741:	89 50 04             	mov    %edx,0x4(%eax)
  803744:	eb 0b                	jmp    803751 <alloc_block_NF+0x45c>
  803746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803749:	8b 40 04             	mov    0x4(%eax),%eax
  80374c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803754:	8b 40 04             	mov    0x4(%eax),%eax
  803757:	85 c0                	test   %eax,%eax
  803759:	74 0f                	je     80376a <alloc_block_NF+0x475>
  80375b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375e:	8b 40 04             	mov    0x4(%eax),%eax
  803761:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803764:	8b 12                	mov    (%edx),%edx
  803766:	89 10                	mov    %edx,(%eax)
  803768:	eb 0a                	jmp    803774 <alloc_block_NF+0x47f>
  80376a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376d:	8b 00                	mov    (%eax),%eax
  80376f:	a3 38 51 80 00       	mov    %eax,0x805138
  803774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803777:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803780:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803787:	a1 44 51 80 00       	mov    0x805144,%eax
  80378c:	48                   	dec    %eax
  80378d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803795:	8b 40 08             	mov    0x8(%eax),%eax
  803798:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80379d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a0:	e9 1b 01 00 00       	jmp    8038c0 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8037a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8037ae:	0f 86 d1 00 00 00    	jbe    803885 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8037b4:	a1 48 51 80 00       	mov    0x805148,%eax
  8037b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8037bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bf:	8b 50 08             	mov    0x8(%eax),%edx
  8037c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037c5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8037c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ce:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8037d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037d5:	75 17                	jne    8037ee <alloc_block_NF+0x4f9>
  8037d7:	83 ec 04             	sub    $0x4,%esp
  8037da:	68 a0 4c 80 00       	push   $0x804ca0
  8037df:	68 1c 01 00 00       	push   $0x11c
  8037e4:	68 f7 4b 80 00       	push   $0x804bf7
  8037e9:	e8 05 d6 ff ff       	call   800df3 <_panic>
  8037ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f1:	8b 00                	mov    (%eax),%eax
  8037f3:	85 c0                	test   %eax,%eax
  8037f5:	74 10                	je     803807 <alloc_block_NF+0x512>
  8037f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037fa:	8b 00                	mov    (%eax),%eax
  8037fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037ff:	8b 52 04             	mov    0x4(%edx),%edx
  803802:	89 50 04             	mov    %edx,0x4(%eax)
  803805:	eb 0b                	jmp    803812 <alloc_block_NF+0x51d>
  803807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380a:	8b 40 04             	mov    0x4(%eax),%eax
  80380d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803815:	8b 40 04             	mov    0x4(%eax),%eax
  803818:	85 c0                	test   %eax,%eax
  80381a:	74 0f                	je     80382b <alloc_block_NF+0x536>
  80381c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80381f:	8b 40 04             	mov    0x4(%eax),%eax
  803822:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803825:	8b 12                	mov    (%edx),%edx
  803827:	89 10                	mov    %edx,(%eax)
  803829:	eb 0a                	jmp    803835 <alloc_block_NF+0x540>
  80382b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80382e:	8b 00                	mov    (%eax),%eax
  803830:	a3 48 51 80 00       	mov    %eax,0x805148
  803835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803838:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80383e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803841:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803848:	a1 54 51 80 00       	mov    0x805154,%eax
  80384d:	48                   	dec    %eax
  80384e:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803853:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803856:	8b 40 08             	mov    0x8(%eax),%eax
  803859:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80385e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803861:	8b 50 08             	mov    0x8(%eax),%edx
  803864:	8b 45 08             	mov    0x8(%ebp),%eax
  803867:	01 c2                	add    %eax,%edx
  803869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80386f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803872:	8b 40 0c             	mov    0xc(%eax),%eax
  803875:	2b 45 08             	sub    0x8(%ebp),%eax
  803878:	89 c2                	mov    %eax,%edx
  80387a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803880:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803883:	eb 3b                	jmp    8038c0 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803885:	a1 40 51 80 00       	mov    0x805140,%eax
  80388a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80388d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803891:	74 07                	je     80389a <alloc_block_NF+0x5a5>
  803893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803896:	8b 00                	mov    (%eax),%eax
  803898:	eb 05                	jmp    80389f <alloc_block_NF+0x5aa>
  80389a:	b8 00 00 00 00       	mov    $0x0,%eax
  80389f:	a3 40 51 80 00       	mov    %eax,0x805140
  8038a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8038a9:	85 c0                	test   %eax,%eax
  8038ab:	0f 85 2e fe ff ff    	jne    8036df <alloc_block_NF+0x3ea>
  8038b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038b5:	0f 85 24 fe ff ff    	jne    8036df <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8038bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038c0:	c9                   	leave  
  8038c1:	c3                   	ret    

008038c2 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8038c2:	55                   	push   %ebp
  8038c3:	89 e5                	mov    %esp,%ebp
  8038c5:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8038c8:	a1 38 51 80 00       	mov    0x805138,%eax
  8038cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8038d0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8038d5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8038d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8038dd:	85 c0                	test   %eax,%eax
  8038df:	74 14                	je     8038f5 <insert_sorted_with_merge_freeList+0x33>
  8038e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e4:	8b 50 08             	mov    0x8(%eax),%edx
  8038e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ea:	8b 40 08             	mov    0x8(%eax),%eax
  8038ed:	39 c2                	cmp    %eax,%edx
  8038ef:	0f 87 9b 01 00 00    	ja     803a90 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8038f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038f9:	75 17                	jne    803912 <insert_sorted_with_merge_freeList+0x50>
  8038fb:	83 ec 04             	sub    $0x4,%esp
  8038fe:	68 d4 4b 80 00       	push   $0x804bd4
  803903:	68 38 01 00 00       	push   $0x138
  803908:	68 f7 4b 80 00       	push   $0x804bf7
  80390d:	e8 e1 d4 ff ff       	call   800df3 <_panic>
  803912:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803918:	8b 45 08             	mov    0x8(%ebp),%eax
  80391b:	89 10                	mov    %edx,(%eax)
  80391d:	8b 45 08             	mov    0x8(%ebp),%eax
  803920:	8b 00                	mov    (%eax),%eax
  803922:	85 c0                	test   %eax,%eax
  803924:	74 0d                	je     803933 <insert_sorted_with_merge_freeList+0x71>
  803926:	a1 38 51 80 00       	mov    0x805138,%eax
  80392b:	8b 55 08             	mov    0x8(%ebp),%edx
  80392e:	89 50 04             	mov    %edx,0x4(%eax)
  803931:	eb 08                	jmp    80393b <insert_sorted_with_merge_freeList+0x79>
  803933:	8b 45 08             	mov    0x8(%ebp),%eax
  803936:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
  80393e:	a3 38 51 80 00       	mov    %eax,0x805138
  803943:	8b 45 08             	mov    0x8(%ebp),%eax
  803946:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80394d:	a1 44 51 80 00       	mov    0x805144,%eax
  803952:	40                   	inc    %eax
  803953:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803958:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80395c:	0f 84 a8 06 00 00    	je     80400a <insert_sorted_with_merge_freeList+0x748>
  803962:	8b 45 08             	mov    0x8(%ebp),%eax
  803965:	8b 50 08             	mov    0x8(%eax),%edx
  803968:	8b 45 08             	mov    0x8(%ebp),%eax
  80396b:	8b 40 0c             	mov    0xc(%eax),%eax
  80396e:	01 c2                	add    %eax,%edx
  803970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803973:	8b 40 08             	mov    0x8(%eax),%eax
  803976:	39 c2                	cmp    %eax,%edx
  803978:	0f 85 8c 06 00 00    	jne    80400a <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80397e:	8b 45 08             	mov    0x8(%ebp),%eax
  803981:	8b 50 0c             	mov    0xc(%eax),%edx
  803984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803987:	8b 40 0c             	mov    0xc(%eax),%eax
  80398a:	01 c2                	add    %eax,%edx
  80398c:	8b 45 08             	mov    0x8(%ebp),%eax
  80398f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803992:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803996:	75 17                	jne    8039af <insert_sorted_with_merge_freeList+0xed>
  803998:	83 ec 04             	sub    $0x4,%esp
  80399b:	68 a0 4c 80 00       	push   $0x804ca0
  8039a0:	68 3c 01 00 00       	push   $0x13c
  8039a5:	68 f7 4b 80 00       	push   $0x804bf7
  8039aa:	e8 44 d4 ff ff       	call   800df3 <_panic>
  8039af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039b2:	8b 00                	mov    (%eax),%eax
  8039b4:	85 c0                	test   %eax,%eax
  8039b6:	74 10                	je     8039c8 <insert_sorted_with_merge_freeList+0x106>
  8039b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039bb:	8b 00                	mov    (%eax),%eax
  8039bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039c0:	8b 52 04             	mov    0x4(%edx),%edx
  8039c3:	89 50 04             	mov    %edx,0x4(%eax)
  8039c6:	eb 0b                	jmp    8039d3 <insert_sorted_with_merge_freeList+0x111>
  8039c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039cb:	8b 40 04             	mov    0x4(%eax),%eax
  8039ce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039d6:	8b 40 04             	mov    0x4(%eax),%eax
  8039d9:	85 c0                	test   %eax,%eax
  8039db:	74 0f                	je     8039ec <insert_sorted_with_merge_freeList+0x12a>
  8039dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039e0:	8b 40 04             	mov    0x4(%eax),%eax
  8039e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8039e6:	8b 12                	mov    (%edx),%edx
  8039e8:	89 10                	mov    %edx,(%eax)
  8039ea:	eb 0a                	jmp    8039f6 <insert_sorted_with_merge_freeList+0x134>
  8039ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039ef:	8b 00                	mov    (%eax),%eax
  8039f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8039f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a09:	a1 44 51 80 00       	mov    0x805144,%eax
  803a0e:	48                   	dec    %eax
  803a0f:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803a28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a2c:	75 17                	jne    803a45 <insert_sorted_with_merge_freeList+0x183>
  803a2e:	83 ec 04             	sub    $0x4,%esp
  803a31:	68 d4 4b 80 00       	push   $0x804bd4
  803a36:	68 3f 01 00 00       	push   $0x13f
  803a3b:	68 f7 4b 80 00       	push   $0x804bf7
  803a40:	e8 ae d3 ff ff       	call   800df3 <_panic>
  803a45:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a4e:	89 10                	mov    %edx,(%eax)
  803a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a53:	8b 00                	mov    (%eax),%eax
  803a55:	85 c0                	test   %eax,%eax
  803a57:	74 0d                	je     803a66 <insert_sorted_with_merge_freeList+0x1a4>
  803a59:	a1 48 51 80 00       	mov    0x805148,%eax
  803a5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a61:	89 50 04             	mov    %edx,0x4(%eax)
  803a64:	eb 08                	jmp    803a6e <insert_sorted_with_merge_freeList+0x1ac>
  803a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a69:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a71:	a3 48 51 80 00       	mov    %eax,0x805148
  803a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a80:	a1 54 51 80 00       	mov    0x805154,%eax
  803a85:	40                   	inc    %eax
  803a86:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803a8b:	e9 7a 05 00 00       	jmp    80400a <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803a90:	8b 45 08             	mov    0x8(%ebp),%eax
  803a93:	8b 50 08             	mov    0x8(%eax),%edx
  803a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a99:	8b 40 08             	mov    0x8(%eax),%eax
  803a9c:	39 c2                	cmp    %eax,%edx
  803a9e:	0f 82 14 01 00 00    	jb     803bb8 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aa7:	8b 50 08             	mov    0x8(%eax),%edx
  803aaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aad:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab0:	01 c2                	add    %eax,%edx
  803ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab5:	8b 40 08             	mov    0x8(%eax),%eax
  803ab8:	39 c2                	cmp    %eax,%edx
  803aba:	0f 85 90 00 00 00    	jne    803b50 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ac3:	8b 50 0c             	mov    0xc(%eax),%edx
  803ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac9:	8b 40 0c             	mov    0xc(%eax),%eax
  803acc:	01 c2                	add    %eax,%edx
  803ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ad1:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803ade:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803ae8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aec:	75 17                	jne    803b05 <insert_sorted_with_merge_freeList+0x243>
  803aee:	83 ec 04             	sub    $0x4,%esp
  803af1:	68 d4 4b 80 00       	push   $0x804bd4
  803af6:	68 49 01 00 00       	push   $0x149
  803afb:	68 f7 4b 80 00       	push   $0x804bf7
  803b00:	e8 ee d2 ff ff       	call   800df3 <_panic>
  803b05:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0e:	89 10                	mov    %edx,(%eax)
  803b10:	8b 45 08             	mov    0x8(%ebp),%eax
  803b13:	8b 00                	mov    (%eax),%eax
  803b15:	85 c0                	test   %eax,%eax
  803b17:	74 0d                	je     803b26 <insert_sorted_with_merge_freeList+0x264>
  803b19:	a1 48 51 80 00       	mov    0x805148,%eax
  803b1e:	8b 55 08             	mov    0x8(%ebp),%edx
  803b21:	89 50 04             	mov    %edx,0x4(%eax)
  803b24:	eb 08                	jmp    803b2e <insert_sorted_with_merge_freeList+0x26c>
  803b26:	8b 45 08             	mov    0x8(%ebp),%eax
  803b29:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  803b31:	a3 48 51 80 00       	mov    %eax,0x805148
  803b36:	8b 45 08             	mov    0x8(%ebp),%eax
  803b39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b40:	a1 54 51 80 00       	mov    0x805154,%eax
  803b45:	40                   	inc    %eax
  803b46:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803b4b:	e9 bb 04 00 00       	jmp    80400b <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803b50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b54:	75 17                	jne    803b6d <insert_sorted_with_merge_freeList+0x2ab>
  803b56:	83 ec 04             	sub    $0x4,%esp
  803b59:	68 48 4c 80 00       	push   $0x804c48
  803b5e:	68 4c 01 00 00       	push   $0x14c
  803b63:	68 f7 4b 80 00       	push   $0x804bf7
  803b68:	e8 86 d2 ff ff       	call   800df3 <_panic>
  803b6d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803b73:	8b 45 08             	mov    0x8(%ebp),%eax
  803b76:	89 50 04             	mov    %edx,0x4(%eax)
  803b79:	8b 45 08             	mov    0x8(%ebp),%eax
  803b7c:	8b 40 04             	mov    0x4(%eax),%eax
  803b7f:	85 c0                	test   %eax,%eax
  803b81:	74 0c                	je     803b8f <insert_sorted_with_merge_freeList+0x2cd>
  803b83:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803b88:	8b 55 08             	mov    0x8(%ebp),%edx
  803b8b:	89 10                	mov    %edx,(%eax)
  803b8d:	eb 08                	jmp    803b97 <insert_sorted_with_merge_freeList+0x2d5>
  803b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b92:	a3 38 51 80 00       	mov    %eax,0x805138
  803b97:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ba8:	a1 44 51 80 00       	mov    0x805144,%eax
  803bad:	40                   	inc    %eax
  803bae:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803bb3:	e9 53 04 00 00       	jmp    80400b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803bb8:	a1 38 51 80 00       	mov    0x805138,%eax
  803bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bc0:	e9 15 04 00 00       	jmp    803fda <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc8:	8b 00                	mov    (%eax),%eax
  803bca:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd0:	8b 50 08             	mov    0x8(%eax),%edx
  803bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd6:	8b 40 08             	mov    0x8(%eax),%eax
  803bd9:	39 c2                	cmp    %eax,%edx
  803bdb:	0f 86 f1 03 00 00    	jbe    803fd2 <insert_sorted_with_merge_freeList+0x710>
  803be1:	8b 45 08             	mov    0x8(%ebp),%eax
  803be4:	8b 50 08             	mov    0x8(%eax),%edx
  803be7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bea:	8b 40 08             	mov    0x8(%eax),%eax
  803bed:	39 c2                	cmp    %eax,%edx
  803bef:	0f 83 dd 03 00 00    	jae    803fd2 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf8:	8b 50 08             	mov    0x8(%eax),%edx
  803bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bfe:	8b 40 0c             	mov    0xc(%eax),%eax
  803c01:	01 c2                	add    %eax,%edx
  803c03:	8b 45 08             	mov    0x8(%ebp),%eax
  803c06:	8b 40 08             	mov    0x8(%eax),%eax
  803c09:	39 c2                	cmp    %eax,%edx
  803c0b:	0f 85 b9 01 00 00    	jne    803dca <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803c11:	8b 45 08             	mov    0x8(%ebp),%eax
  803c14:	8b 50 08             	mov    0x8(%eax),%edx
  803c17:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1a:	8b 40 0c             	mov    0xc(%eax),%eax
  803c1d:	01 c2                	add    %eax,%edx
  803c1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c22:	8b 40 08             	mov    0x8(%eax),%eax
  803c25:	39 c2                	cmp    %eax,%edx
  803c27:	0f 85 0d 01 00 00    	jne    803d3a <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c30:	8b 50 0c             	mov    0xc(%eax),%edx
  803c33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c36:	8b 40 0c             	mov    0xc(%eax),%eax
  803c39:	01 c2                	add    %eax,%edx
  803c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c3e:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803c41:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c45:	75 17                	jne    803c5e <insert_sorted_with_merge_freeList+0x39c>
  803c47:	83 ec 04             	sub    $0x4,%esp
  803c4a:	68 a0 4c 80 00       	push   $0x804ca0
  803c4f:	68 5c 01 00 00       	push   $0x15c
  803c54:	68 f7 4b 80 00       	push   $0x804bf7
  803c59:	e8 95 d1 ff ff       	call   800df3 <_panic>
  803c5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c61:	8b 00                	mov    (%eax),%eax
  803c63:	85 c0                	test   %eax,%eax
  803c65:	74 10                	je     803c77 <insert_sorted_with_merge_freeList+0x3b5>
  803c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6a:	8b 00                	mov    (%eax),%eax
  803c6c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c6f:	8b 52 04             	mov    0x4(%edx),%edx
  803c72:	89 50 04             	mov    %edx,0x4(%eax)
  803c75:	eb 0b                	jmp    803c82 <insert_sorted_with_merge_freeList+0x3c0>
  803c77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c7a:	8b 40 04             	mov    0x4(%eax),%eax
  803c7d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c85:	8b 40 04             	mov    0x4(%eax),%eax
  803c88:	85 c0                	test   %eax,%eax
  803c8a:	74 0f                	je     803c9b <insert_sorted_with_merge_freeList+0x3d9>
  803c8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c8f:	8b 40 04             	mov    0x4(%eax),%eax
  803c92:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c95:	8b 12                	mov    (%edx),%edx
  803c97:	89 10                	mov    %edx,(%eax)
  803c99:	eb 0a                	jmp    803ca5 <insert_sorted_with_merge_freeList+0x3e3>
  803c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c9e:	8b 00                	mov    (%eax),%eax
  803ca0:	a3 38 51 80 00       	mov    %eax,0x805138
  803ca5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cb8:	a1 44 51 80 00       	mov    0x805144,%eax
  803cbd:	48                   	dec    %eax
  803cbe:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803cc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803ccd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803cd7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803cdb:	75 17                	jne    803cf4 <insert_sorted_with_merge_freeList+0x432>
  803cdd:	83 ec 04             	sub    $0x4,%esp
  803ce0:	68 d4 4b 80 00       	push   $0x804bd4
  803ce5:	68 5f 01 00 00       	push   $0x15f
  803cea:	68 f7 4b 80 00       	push   $0x804bf7
  803cef:	e8 ff d0 ff ff       	call   800df3 <_panic>
  803cf4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803cfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cfd:	89 10                	mov    %edx,(%eax)
  803cff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d02:	8b 00                	mov    (%eax),%eax
  803d04:	85 c0                	test   %eax,%eax
  803d06:	74 0d                	je     803d15 <insert_sorted_with_merge_freeList+0x453>
  803d08:	a1 48 51 80 00       	mov    0x805148,%eax
  803d0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d10:	89 50 04             	mov    %edx,0x4(%eax)
  803d13:	eb 08                	jmp    803d1d <insert_sorted_with_merge_freeList+0x45b>
  803d15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d18:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d20:	a3 48 51 80 00       	mov    %eax,0x805148
  803d25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d2f:	a1 54 51 80 00       	mov    0x805154,%eax
  803d34:	40                   	inc    %eax
  803d35:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3d:	8b 50 0c             	mov    0xc(%eax),%edx
  803d40:	8b 45 08             	mov    0x8(%ebp),%eax
  803d43:	8b 40 0c             	mov    0xc(%eax),%eax
  803d46:	01 c2                	add    %eax,%edx
  803d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803d51:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803d58:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803d62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d66:	75 17                	jne    803d7f <insert_sorted_with_merge_freeList+0x4bd>
  803d68:	83 ec 04             	sub    $0x4,%esp
  803d6b:	68 d4 4b 80 00       	push   $0x804bd4
  803d70:	68 64 01 00 00       	push   $0x164
  803d75:	68 f7 4b 80 00       	push   $0x804bf7
  803d7a:	e8 74 d0 ff ff       	call   800df3 <_panic>
  803d7f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d85:	8b 45 08             	mov    0x8(%ebp),%eax
  803d88:	89 10                	mov    %edx,(%eax)
  803d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8d:	8b 00                	mov    (%eax),%eax
  803d8f:	85 c0                	test   %eax,%eax
  803d91:	74 0d                	je     803da0 <insert_sorted_with_merge_freeList+0x4de>
  803d93:	a1 48 51 80 00       	mov    0x805148,%eax
  803d98:	8b 55 08             	mov    0x8(%ebp),%edx
  803d9b:	89 50 04             	mov    %edx,0x4(%eax)
  803d9e:	eb 08                	jmp    803da8 <insert_sorted_with_merge_freeList+0x4e6>
  803da0:	8b 45 08             	mov    0x8(%ebp),%eax
  803da3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803da8:	8b 45 08             	mov    0x8(%ebp),%eax
  803dab:	a3 48 51 80 00       	mov    %eax,0x805148
  803db0:	8b 45 08             	mov    0x8(%ebp),%eax
  803db3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dba:	a1 54 51 80 00       	mov    0x805154,%eax
  803dbf:	40                   	inc    %eax
  803dc0:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803dc5:	e9 41 02 00 00       	jmp    80400b <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803dca:	8b 45 08             	mov    0x8(%ebp),%eax
  803dcd:	8b 50 08             	mov    0x8(%eax),%edx
  803dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd3:	8b 40 0c             	mov    0xc(%eax),%eax
  803dd6:	01 c2                	add    %eax,%edx
  803dd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ddb:	8b 40 08             	mov    0x8(%eax),%eax
  803dde:	39 c2                	cmp    %eax,%edx
  803de0:	0f 85 7c 01 00 00    	jne    803f62 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803de6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803dea:	74 06                	je     803df2 <insert_sorted_with_merge_freeList+0x530>
  803dec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803df0:	75 17                	jne    803e09 <insert_sorted_with_merge_freeList+0x547>
  803df2:	83 ec 04             	sub    $0x4,%esp
  803df5:	68 10 4c 80 00       	push   $0x804c10
  803dfa:	68 69 01 00 00       	push   $0x169
  803dff:	68 f7 4b 80 00       	push   $0x804bf7
  803e04:	e8 ea cf ff ff       	call   800df3 <_panic>
  803e09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e0c:	8b 50 04             	mov    0x4(%eax),%edx
  803e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e12:	89 50 04             	mov    %edx,0x4(%eax)
  803e15:	8b 45 08             	mov    0x8(%ebp),%eax
  803e18:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e1b:	89 10                	mov    %edx,(%eax)
  803e1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e20:	8b 40 04             	mov    0x4(%eax),%eax
  803e23:	85 c0                	test   %eax,%eax
  803e25:	74 0d                	je     803e34 <insert_sorted_with_merge_freeList+0x572>
  803e27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e2a:	8b 40 04             	mov    0x4(%eax),%eax
  803e2d:	8b 55 08             	mov    0x8(%ebp),%edx
  803e30:	89 10                	mov    %edx,(%eax)
  803e32:	eb 08                	jmp    803e3c <insert_sorted_with_merge_freeList+0x57a>
  803e34:	8b 45 08             	mov    0x8(%ebp),%eax
  803e37:	a3 38 51 80 00       	mov    %eax,0x805138
  803e3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  803e42:	89 50 04             	mov    %edx,0x4(%eax)
  803e45:	a1 44 51 80 00       	mov    0x805144,%eax
  803e4a:	40                   	inc    %eax
  803e4b:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803e50:	8b 45 08             	mov    0x8(%ebp),%eax
  803e53:	8b 50 0c             	mov    0xc(%eax),%edx
  803e56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e59:	8b 40 0c             	mov    0xc(%eax),%eax
  803e5c:	01 c2                	add    %eax,%edx
  803e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e61:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803e64:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803e68:	75 17                	jne    803e81 <insert_sorted_with_merge_freeList+0x5bf>
  803e6a:	83 ec 04             	sub    $0x4,%esp
  803e6d:	68 a0 4c 80 00       	push   $0x804ca0
  803e72:	68 6b 01 00 00       	push   $0x16b
  803e77:	68 f7 4b 80 00       	push   $0x804bf7
  803e7c:	e8 72 cf ff ff       	call   800df3 <_panic>
  803e81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e84:	8b 00                	mov    (%eax),%eax
  803e86:	85 c0                	test   %eax,%eax
  803e88:	74 10                	je     803e9a <insert_sorted_with_merge_freeList+0x5d8>
  803e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e8d:	8b 00                	mov    (%eax),%eax
  803e8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e92:	8b 52 04             	mov    0x4(%edx),%edx
  803e95:	89 50 04             	mov    %edx,0x4(%eax)
  803e98:	eb 0b                	jmp    803ea5 <insert_sorted_with_merge_freeList+0x5e3>
  803e9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e9d:	8b 40 04             	mov    0x4(%eax),%eax
  803ea0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ea5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ea8:	8b 40 04             	mov    0x4(%eax),%eax
  803eab:	85 c0                	test   %eax,%eax
  803ead:	74 0f                	je     803ebe <insert_sorted_with_merge_freeList+0x5fc>
  803eaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eb2:	8b 40 04             	mov    0x4(%eax),%eax
  803eb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803eb8:	8b 12                	mov    (%edx),%edx
  803eba:	89 10                	mov    %edx,(%eax)
  803ebc:	eb 0a                	jmp    803ec8 <insert_sorted_with_merge_freeList+0x606>
  803ebe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ec1:	8b 00                	mov    (%eax),%eax
  803ec3:	a3 38 51 80 00       	mov    %eax,0x805138
  803ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ecb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ed1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ed4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803edb:	a1 44 51 80 00       	mov    0x805144,%eax
  803ee0:	48                   	dec    %eax
  803ee1:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803ee6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ee9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803ef0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ef3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803efa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803efe:	75 17                	jne    803f17 <insert_sorted_with_merge_freeList+0x655>
  803f00:	83 ec 04             	sub    $0x4,%esp
  803f03:	68 d4 4b 80 00       	push   $0x804bd4
  803f08:	68 6e 01 00 00       	push   $0x16e
  803f0d:	68 f7 4b 80 00       	push   $0x804bf7
  803f12:	e8 dc ce ff ff       	call   800df3 <_panic>
  803f17:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803f1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f20:	89 10                	mov    %edx,(%eax)
  803f22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f25:	8b 00                	mov    (%eax),%eax
  803f27:	85 c0                	test   %eax,%eax
  803f29:	74 0d                	je     803f38 <insert_sorted_with_merge_freeList+0x676>
  803f2b:	a1 48 51 80 00       	mov    0x805148,%eax
  803f30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f33:	89 50 04             	mov    %edx,0x4(%eax)
  803f36:	eb 08                	jmp    803f40 <insert_sorted_with_merge_freeList+0x67e>
  803f38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f3b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803f40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f43:	a3 48 51 80 00       	mov    %eax,0x805148
  803f48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f52:	a1 54 51 80 00       	mov    0x805154,%eax
  803f57:	40                   	inc    %eax
  803f58:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803f5d:	e9 a9 00 00 00       	jmp    80400b <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803f62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f66:	74 06                	je     803f6e <insert_sorted_with_merge_freeList+0x6ac>
  803f68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f6c:	75 17                	jne    803f85 <insert_sorted_with_merge_freeList+0x6c3>
  803f6e:	83 ec 04             	sub    $0x4,%esp
  803f71:	68 6c 4c 80 00       	push   $0x804c6c
  803f76:	68 73 01 00 00       	push   $0x173
  803f7b:	68 f7 4b 80 00       	push   $0x804bf7
  803f80:	e8 6e ce ff ff       	call   800df3 <_panic>
  803f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f88:	8b 10                	mov    (%eax),%edx
  803f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f8d:	89 10                	mov    %edx,(%eax)
  803f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803f92:	8b 00                	mov    (%eax),%eax
  803f94:	85 c0                	test   %eax,%eax
  803f96:	74 0b                	je     803fa3 <insert_sorted_with_merge_freeList+0x6e1>
  803f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f9b:	8b 00                	mov    (%eax),%eax
  803f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  803fa0:	89 50 04             	mov    %edx,0x4(%eax)
  803fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  803fa9:	89 10                	mov    %edx,(%eax)
  803fab:	8b 45 08             	mov    0x8(%ebp),%eax
  803fae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803fb1:	89 50 04             	mov    %edx,0x4(%eax)
  803fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb7:	8b 00                	mov    (%eax),%eax
  803fb9:	85 c0                	test   %eax,%eax
  803fbb:	75 08                	jne    803fc5 <insert_sorted_with_merge_freeList+0x703>
  803fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  803fc0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803fc5:	a1 44 51 80 00       	mov    0x805144,%eax
  803fca:	40                   	inc    %eax
  803fcb:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803fd0:	eb 39                	jmp    80400b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803fd2:	a1 40 51 80 00       	mov    0x805140,%eax
  803fd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803fda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fde:	74 07                	je     803fe7 <insert_sorted_with_merge_freeList+0x725>
  803fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe3:	8b 00                	mov    (%eax),%eax
  803fe5:	eb 05                	jmp    803fec <insert_sorted_with_merge_freeList+0x72a>
  803fe7:	b8 00 00 00 00       	mov    $0x0,%eax
  803fec:	a3 40 51 80 00       	mov    %eax,0x805140
  803ff1:	a1 40 51 80 00       	mov    0x805140,%eax
  803ff6:	85 c0                	test   %eax,%eax
  803ff8:	0f 85 c7 fb ff ff    	jne    803bc5 <insert_sorted_with_merge_freeList+0x303>
  803ffe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804002:	0f 85 bd fb ff ff    	jne    803bc5 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  804008:	eb 01                	jmp    80400b <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80400a:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80400b:	90                   	nop
  80400c:	c9                   	leave  
  80400d:	c3                   	ret    
  80400e:	66 90                	xchg   %ax,%ax

00804010 <__udivdi3>:
  804010:	55                   	push   %ebp
  804011:	57                   	push   %edi
  804012:	56                   	push   %esi
  804013:	53                   	push   %ebx
  804014:	83 ec 1c             	sub    $0x1c,%esp
  804017:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80401b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80401f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804023:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804027:	89 ca                	mov    %ecx,%edx
  804029:	89 f8                	mov    %edi,%eax
  80402b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80402f:	85 f6                	test   %esi,%esi
  804031:	75 2d                	jne    804060 <__udivdi3+0x50>
  804033:	39 cf                	cmp    %ecx,%edi
  804035:	77 65                	ja     80409c <__udivdi3+0x8c>
  804037:	89 fd                	mov    %edi,%ebp
  804039:	85 ff                	test   %edi,%edi
  80403b:	75 0b                	jne    804048 <__udivdi3+0x38>
  80403d:	b8 01 00 00 00       	mov    $0x1,%eax
  804042:	31 d2                	xor    %edx,%edx
  804044:	f7 f7                	div    %edi
  804046:	89 c5                	mov    %eax,%ebp
  804048:	31 d2                	xor    %edx,%edx
  80404a:	89 c8                	mov    %ecx,%eax
  80404c:	f7 f5                	div    %ebp
  80404e:	89 c1                	mov    %eax,%ecx
  804050:	89 d8                	mov    %ebx,%eax
  804052:	f7 f5                	div    %ebp
  804054:	89 cf                	mov    %ecx,%edi
  804056:	89 fa                	mov    %edi,%edx
  804058:	83 c4 1c             	add    $0x1c,%esp
  80405b:	5b                   	pop    %ebx
  80405c:	5e                   	pop    %esi
  80405d:	5f                   	pop    %edi
  80405e:	5d                   	pop    %ebp
  80405f:	c3                   	ret    
  804060:	39 ce                	cmp    %ecx,%esi
  804062:	77 28                	ja     80408c <__udivdi3+0x7c>
  804064:	0f bd fe             	bsr    %esi,%edi
  804067:	83 f7 1f             	xor    $0x1f,%edi
  80406a:	75 40                	jne    8040ac <__udivdi3+0x9c>
  80406c:	39 ce                	cmp    %ecx,%esi
  80406e:	72 0a                	jb     80407a <__udivdi3+0x6a>
  804070:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804074:	0f 87 9e 00 00 00    	ja     804118 <__udivdi3+0x108>
  80407a:	b8 01 00 00 00       	mov    $0x1,%eax
  80407f:	89 fa                	mov    %edi,%edx
  804081:	83 c4 1c             	add    $0x1c,%esp
  804084:	5b                   	pop    %ebx
  804085:	5e                   	pop    %esi
  804086:	5f                   	pop    %edi
  804087:	5d                   	pop    %ebp
  804088:	c3                   	ret    
  804089:	8d 76 00             	lea    0x0(%esi),%esi
  80408c:	31 ff                	xor    %edi,%edi
  80408e:	31 c0                	xor    %eax,%eax
  804090:	89 fa                	mov    %edi,%edx
  804092:	83 c4 1c             	add    $0x1c,%esp
  804095:	5b                   	pop    %ebx
  804096:	5e                   	pop    %esi
  804097:	5f                   	pop    %edi
  804098:	5d                   	pop    %ebp
  804099:	c3                   	ret    
  80409a:	66 90                	xchg   %ax,%ax
  80409c:	89 d8                	mov    %ebx,%eax
  80409e:	f7 f7                	div    %edi
  8040a0:	31 ff                	xor    %edi,%edi
  8040a2:	89 fa                	mov    %edi,%edx
  8040a4:	83 c4 1c             	add    $0x1c,%esp
  8040a7:	5b                   	pop    %ebx
  8040a8:	5e                   	pop    %esi
  8040a9:	5f                   	pop    %edi
  8040aa:	5d                   	pop    %ebp
  8040ab:	c3                   	ret    
  8040ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8040b1:	89 eb                	mov    %ebp,%ebx
  8040b3:	29 fb                	sub    %edi,%ebx
  8040b5:	89 f9                	mov    %edi,%ecx
  8040b7:	d3 e6                	shl    %cl,%esi
  8040b9:	89 c5                	mov    %eax,%ebp
  8040bb:	88 d9                	mov    %bl,%cl
  8040bd:	d3 ed                	shr    %cl,%ebp
  8040bf:	89 e9                	mov    %ebp,%ecx
  8040c1:	09 f1                	or     %esi,%ecx
  8040c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8040c7:	89 f9                	mov    %edi,%ecx
  8040c9:	d3 e0                	shl    %cl,%eax
  8040cb:	89 c5                	mov    %eax,%ebp
  8040cd:	89 d6                	mov    %edx,%esi
  8040cf:	88 d9                	mov    %bl,%cl
  8040d1:	d3 ee                	shr    %cl,%esi
  8040d3:	89 f9                	mov    %edi,%ecx
  8040d5:	d3 e2                	shl    %cl,%edx
  8040d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8040db:	88 d9                	mov    %bl,%cl
  8040dd:	d3 e8                	shr    %cl,%eax
  8040df:	09 c2                	or     %eax,%edx
  8040e1:	89 d0                	mov    %edx,%eax
  8040e3:	89 f2                	mov    %esi,%edx
  8040e5:	f7 74 24 0c          	divl   0xc(%esp)
  8040e9:	89 d6                	mov    %edx,%esi
  8040eb:	89 c3                	mov    %eax,%ebx
  8040ed:	f7 e5                	mul    %ebp
  8040ef:	39 d6                	cmp    %edx,%esi
  8040f1:	72 19                	jb     80410c <__udivdi3+0xfc>
  8040f3:	74 0b                	je     804100 <__udivdi3+0xf0>
  8040f5:	89 d8                	mov    %ebx,%eax
  8040f7:	31 ff                	xor    %edi,%edi
  8040f9:	e9 58 ff ff ff       	jmp    804056 <__udivdi3+0x46>
  8040fe:	66 90                	xchg   %ax,%ax
  804100:	8b 54 24 08          	mov    0x8(%esp),%edx
  804104:	89 f9                	mov    %edi,%ecx
  804106:	d3 e2                	shl    %cl,%edx
  804108:	39 c2                	cmp    %eax,%edx
  80410a:	73 e9                	jae    8040f5 <__udivdi3+0xe5>
  80410c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80410f:	31 ff                	xor    %edi,%edi
  804111:	e9 40 ff ff ff       	jmp    804056 <__udivdi3+0x46>
  804116:	66 90                	xchg   %ax,%ax
  804118:	31 c0                	xor    %eax,%eax
  80411a:	e9 37 ff ff ff       	jmp    804056 <__udivdi3+0x46>
  80411f:	90                   	nop

00804120 <__umoddi3>:
  804120:	55                   	push   %ebp
  804121:	57                   	push   %edi
  804122:	56                   	push   %esi
  804123:	53                   	push   %ebx
  804124:	83 ec 1c             	sub    $0x1c,%esp
  804127:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80412b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80412f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804133:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80413b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80413f:	89 f3                	mov    %esi,%ebx
  804141:	89 fa                	mov    %edi,%edx
  804143:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804147:	89 34 24             	mov    %esi,(%esp)
  80414a:	85 c0                	test   %eax,%eax
  80414c:	75 1a                	jne    804168 <__umoddi3+0x48>
  80414e:	39 f7                	cmp    %esi,%edi
  804150:	0f 86 a2 00 00 00    	jbe    8041f8 <__umoddi3+0xd8>
  804156:	89 c8                	mov    %ecx,%eax
  804158:	89 f2                	mov    %esi,%edx
  80415a:	f7 f7                	div    %edi
  80415c:	89 d0                	mov    %edx,%eax
  80415e:	31 d2                	xor    %edx,%edx
  804160:	83 c4 1c             	add    $0x1c,%esp
  804163:	5b                   	pop    %ebx
  804164:	5e                   	pop    %esi
  804165:	5f                   	pop    %edi
  804166:	5d                   	pop    %ebp
  804167:	c3                   	ret    
  804168:	39 f0                	cmp    %esi,%eax
  80416a:	0f 87 ac 00 00 00    	ja     80421c <__umoddi3+0xfc>
  804170:	0f bd e8             	bsr    %eax,%ebp
  804173:	83 f5 1f             	xor    $0x1f,%ebp
  804176:	0f 84 ac 00 00 00    	je     804228 <__umoddi3+0x108>
  80417c:	bf 20 00 00 00       	mov    $0x20,%edi
  804181:	29 ef                	sub    %ebp,%edi
  804183:	89 fe                	mov    %edi,%esi
  804185:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804189:	89 e9                	mov    %ebp,%ecx
  80418b:	d3 e0                	shl    %cl,%eax
  80418d:	89 d7                	mov    %edx,%edi
  80418f:	89 f1                	mov    %esi,%ecx
  804191:	d3 ef                	shr    %cl,%edi
  804193:	09 c7                	or     %eax,%edi
  804195:	89 e9                	mov    %ebp,%ecx
  804197:	d3 e2                	shl    %cl,%edx
  804199:	89 14 24             	mov    %edx,(%esp)
  80419c:	89 d8                	mov    %ebx,%eax
  80419e:	d3 e0                	shl    %cl,%eax
  8041a0:	89 c2                	mov    %eax,%edx
  8041a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041a6:	d3 e0                	shl    %cl,%eax
  8041a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041b0:	89 f1                	mov    %esi,%ecx
  8041b2:	d3 e8                	shr    %cl,%eax
  8041b4:	09 d0                	or     %edx,%eax
  8041b6:	d3 eb                	shr    %cl,%ebx
  8041b8:	89 da                	mov    %ebx,%edx
  8041ba:	f7 f7                	div    %edi
  8041bc:	89 d3                	mov    %edx,%ebx
  8041be:	f7 24 24             	mull   (%esp)
  8041c1:	89 c6                	mov    %eax,%esi
  8041c3:	89 d1                	mov    %edx,%ecx
  8041c5:	39 d3                	cmp    %edx,%ebx
  8041c7:	0f 82 87 00 00 00    	jb     804254 <__umoddi3+0x134>
  8041cd:	0f 84 91 00 00 00    	je     804264 <__umoddi3+0x144>
  8041d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8041d7:	29 f2                	sub    %esi,%edx
  8041d9:	19 cb                	sbb    %ecx,%ebx
  8041db:	89 d8                	mov    %ebx,%eax
  8041dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8041e1:	d3 e0                	shl    %cl,%eax
  8041e3:	89 e9                	mov    %ebp,%ecx
  8041e5:	d3 ea                	shr    %cl,%edx
  8041e7:	09 d0                	or     %edx,%eax
  8041e9:	89 e9                	mov    %ebp,%ecx
  8041eb:	d3 eb                	shr    %cl,%ebx
  8041ed:	89 da                	mov    %ebx,%edx
  8041ef:	83 c4 1c             	add    $0x1c,%esp
  8041f2:	5b                   	pop    %ebx
  8041f3:	5e                   	pop    %esi
  8041f4:	5f                   	pop    %edi
  8041f5:	5d                   	pop    %ebp
  8041f6:	c3                   	ret    
  8041f7:	90                   	nop
  8041f8:	89 fd                	mov    %edi,%ebp
  8041fa:	85 ff                	test   %edi,%edi
  8041fc:	75 0b                	jne    804209 <__umoddi3+0xe9>
  8041fe:	b8 01 00 00 00       	mov    $0x1,%eax
  804203:	31 d2                	xor    %edx,%edx
  804205:	f7 f7                	div    %edi
  804207:	89 c5                	mov    %eax,%ebp
  804209:	89 f0                	mov    %esi,%eax
  80420b:	31 d2                	xor    %edx,%edx
  80420d:	f7 f5                	div    %ebp
  80420f:	89 c8                	mov    %ecx,%eax
  804211:	f7 f5                	div    %ebp
  804213:	89 d0                	mov    %edx,%eax
  804215:	e9 44 ff ff ff       	jmp    80415e <__umoddi3+0x3e>
  80421a:	66 90                	xchg   %ax,%ax
  80421c:	89 c8                	mov    %ecx,%eax
  80421e:	89 f2                	mov    %esi,%edx
  804220:	83 c4 1c             	add    $0x1c,%esp
  804223:	5b                   	pop    %ebx
  804224:	5e                   	pop    %esi
  804225:	5f                   	pop    %edi
  804226:	5d                   	pop    %ebp
  804227:	c3                   	ret    
  804228:	3b 04 24             	cmp    (%esp),%eax
  80422b:	72 06                	jb     804233 <__umoddi3+0x113>
  80422d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804231:	77 0f                	ja     804242 <__umoddi3+0x122>
  804233:	89 f2                	mov    %esi,%edx
  804235:	29 f9                	sub    %edi,%ecx
  804237:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80423b:	89 14 24             	mov    %edx,(%esp)
  80423e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804242:	8b 44 24 04          	mov    0x4(%esp),%eax
  804246:	8b 14 24             	mov    (%esp),%edx
  804249:	83 c4 1c             	add    $0x1c,%esp
  80424c:	5b                   	pop    %ebx
  80424d:	5e                   	pop    %esi
  80424e:	5f                   	pop    %edi
  80424f:	5d                   	pop    %ebp
  804250:	c3                   	ret    
  804251:	8d 76 00             	lea    0x0(%esi),%esi
  804254:	2b 04 24             	sub    (%esp),%eax
  804257:	19 fa                	sbb    %edi,%edx
  804259:	89 d1                	mov    %edx,%ecx
  80425b:	89 c6                	mov    %eax,%esi
  80425d:	e9 71 ff ff ff       	jmp    8041d3 <__umoddi3+0xb3>
  804262:	66 90                	xchg   %ax,%ax
  804264:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804268:	72 ea                	jb     804254 <__umoddi3+0x134>
  80426a:	89 d9                	mov    %ebx,%ecx
  80426c:	e9 62 ff ff ff       	jmp    8041d3 <__umoddi3+0xb3>
