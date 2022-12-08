
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
  800048:	e8 17 27 00 00       	call   802764 <sys_set_uheap_strategy>
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
  80009e:	68 80 40 80 00       	push   $0x804080
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 9c 40 80 00       	push   $0x80409c
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
  8000f7:	68 b0 40 80 00       	push   $0x8040b0
  8000fc:	68 c7 40 80 00       	push   $0x8040c7
  800101:	6a 24                	push   $0x24
  800103:	68 9c 40 80 00       	push   $0x80409c
  800108:	e8 e6 0c 00 00       	call   800df3 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 04                	push   $0x4
  800112:	e8 4d 26 00 00       	call   802764 <sys_set_uheap_strategy>
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
  800168:	68 80 40 80 00       	push   $0x804080
  80016d:	6a 36                	push   $0x36
  80016f:	68 9c 40 80 00       	push   $0x80409c
  800174:	e8 7a 0c 00 00       	call   800df3 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 75 cc             	pushl  -0x34(%ebp)
  80017f:	68 dc 40 80 00       	push   $0x8040dc
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
  8001ea:	68 28 41 80 00       	push   $0x804128
  8001ef:	6a 48                	push   $0x48
  8001f1:	68 9c 40 80 00       	push   $0x80409c
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
  80020f:	e8 3b 20 00 00       	call   80224f <sys_calculate_free_frames>
  800214:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800217:	e8 d3 20 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  8002af:	68 78 41 80 00       	push   $0x804178
  8002b4:	6a 5d                	push   $0x5d
  8002b6:	68 9c 40 80 00       	push   $0x80409c
  8002bb:	e8 33 0b 00 00       	call   800df3 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002c0:	e8 2a 20 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  8002e3:	68 b6 41 80 00       	push   $0x8041b6
  8002e8:	6a 5f                	push   $0x5f
  8002ea:	68 9c 40 80 00       	push   $0x80409c
  8002ef:	e8 ff 0a 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002f7:	e8 53 1f 00 00       	call   80224f <sys_calculate_free_frames>
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
  800319:	68 d3 41 80 00       	push   $0x8041d3
  80031e:	6a 60                	push   $0x60
  800320:	68 9c 40 80 00       	push   $0x80409c
  800325:	e8 c9 0a 00 00       	call   800df3 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80032a:	e8 20 1f 00 00       	call   80224f <sys_calculate_free_frames>
  80032f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800332:	e8 b8 1f 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  800448:	e8 a2 1e 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  80047b:	68 e4 41 80 00       	push   $0x8041e4
  800480:	6a 76                	push   $0x76
  800482:	68 9c 40 80 00       	push   $0x80409c
  800487:	e8 67 09 00 00       	call   800df3 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80048c:	e8 be 1d 00 00       	call   80224f <sys_calculate_free_frames>
  800491:	89 c2                	mov    %eax,%edx
  800493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 20 42 80 00       	push   $0x804220
  8004a2:	6a 77                	push   $0x77
  8004a4:	68 9c 40 80 00       	push   $0x80409c
  8004a9:	e8 45 09 00 00       	call   800df3 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8004ae:	e8 9c 1d 00 00       	call   80224f <sys_calculate_free_frames>
  8004b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b6:	e8 34 1e 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  8004dd:	68 60 42 80 00       	push   $0x804260
  8004e2:	6a 7f                	push   $0x7f
  8004e4:	68 9c 40 80 00       	push   $0x80409c
  8004e9:	e8 05 09 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004ee:	e8 fc 1d 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  80050e:	68 b6 41 80 00       	push   $0x8041b6
  800513:	68 80 00 00 00       	push   $0x80
  800518:	68 9c 40 80 00       	push   $0x80409c
  80051d:	e8 d1 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800522:	e8 28 1d 00 00       	call   80224f <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 d3 41 80 00       	push   $0x8041d3
  800538:	68 81 00 00 00       	push   $0x81
  80053d:	68 9c 40 80 00       	push   $0x80409c
  800542:	e8 ac 08 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800547:	ff 45 d0             	incl   -0x30(%ebp)
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d0             	pushl  -0x30(%ebp)
  800550:	68 80 42 80 00       	push   $0x804280
  800555:	e8 4d 0b 00 00       	call   8010a7 <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 ed 1c 00 00       	call   80224f <sys_calculate_free_frames>
  800562:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 85 1d 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  80058f:	68 60 42 80 00       	push   $0x804260
  800594:	68 88 00 00 00       	push   $0x88
  800599:	68 9c 40 80 00       	push   $0x80409c
  80059e:	e8 50 08 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005a3:	e8 47 1d 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  8005c6:	68 b6 41 80 00       	push   $0x8041b6
  8005cb:	68 89 00 00 00       	push   $0x89
  8005d0:	68 9c 40 80 00       	push   $0x80409c
  8005d5:	e8 19 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005da:	e8 70 1c 00 00       	call   80224f <sys_calculate_free_frames>
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 17                	je     8005ff <_main+0x5c7>
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 d3 41 80 00       	push   $0x8041d3
  8005f0:	68 8a 00 00 00       	push   $0x8a
  8005f5:	68 9c 40 80 00       	push   $0x80409c
  8005fa:	e8 f4 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005ff:	ff 45 d0             	incl   -0x30(%ebp)
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 d0             	pushl  -0x30(%ebp)
  800608:	68 80 42 80 00       	push   $0x804280
  80060d:	e8 95 0a 00 00       	call   8010a7 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800615:	e8 35 1c 00 00       	call   80224f <sys_calculate_free_frames>
  80061a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80061d:	e8 cd 1c 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  80064c:	68 60 42 80 00       	push   $0x804260
  800651:	68 91 00 00 00       	push   $0x91
  800656:	68 9c 40 80 00       	push   $0x80409c
  80065b:	e8 93 07 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800660:	e8 8a 1c 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  800688:	68 b6 41 80 00       	push   $0x8041b6
  80068d:	68 92 00 00 00       	push   $0x92
  800692:	68 9c 40 80 00       	push   $0x80409c
  800697:	e8 57 07 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069c:	e8 ae 1b 00 00       	call   80224f <sys_calculate_free_frames>
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	74 17                	je     8006c1 <_main+0x689>
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 d3 41 80 00       	push   $0x8041d3
  8006b2:	68 93 00 00 00       	push   $0x93
  8006b7:	68 9c 40 80 00       	push   $0x80409c
  8006bc:	e8 32 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006c1:	ff 45 d0             	incl   -0x30(%ebp)
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ca:	68 80 42 80 00       	push   $0x804280
  8006cf:	e8 d3 09 00 00       	call   8010a7 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006d7:	e8 73 1b 00 00       	call   80224f <sys_calculate_free_frames>
  8006dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006df:	e8 0b 1c 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  80070d:	68 60 42 80 00       	push   $0x804260
  800712:	68 9a 00 00 00       	push   $0x9a
  800717:	68 9c 40 80 00       	push   $0x80409c
  80071c:	e8 d2 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800721:	e8 c9 1b 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  800748:	68 b6 41 80 00       	push   $0x8041b6
  80074d:	68 9b 00 00 00       	push   $0x9b
  800752:	68 9c 40 80 00       	push   $0x80409c
  800757:	e8 97 06 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80075c:	e8 ee 1a 00 00       	call   80224f <sys_calculate_free_frames>
  800761:	89 c2                	mov    %eax,%edx
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	39 c2                	cmp    %eax,%edx
  800768:	74 17                	je     800781 <_main+0x749>
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 d3 41 80 00       	push   $0x8041d3
  800772:	68 9c 00 00 00       	push   $0x9c
  800777:	68 9c 40 80 00       	push   $0x80409c
  80077c:	e8 72 06 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800781:	ff 45 d0             	incl   -0x30(%ebp)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d0             	pushl  -0x30(%ebp)
  80078a:	68 80 42 80 00       	push   $0x804280
  80078f:	e8 13 09 00 00       	call   8010a7 <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800797:	e8 b3 1a 00 00       	call   80224f <sys_calculate_free_frames>
  80079c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80079f:	e8 4b 1b 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  8007c9:	68 60 42 80 00       	push   $0x804260
  8007ce:	68 a3 00 00 00       	push   $0xa3
  8007d3:	68 9c 40 80 00       	push   $0x80409c
  8007d8:	e8 16 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007dd:	e8 0d 1b 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  800800:	68 b6 41 80 00       	push   $0x8041b6
  800805:	68 a4 00 00 00       	push   $0xa4
  80080a:	68 9c 40 80 00       	push   $0x80409c
  80080f:	e8 df 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800814:	e8 36 1a 00 00       	call   80224f <sys_calculate_free_frames>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 17                	je     800839 <_main+0x801>
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 d3 41 80 00       	push   $0x8041d3
  80082a:	68 a5 00 00 00       	push   $0xa5
  80082f:	68 9c 40 80 00       	push   $0x80409c
  800834:	e8 ba 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800839:	ff 45 d0             	incl   -0x30(%ebp)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 d0             	pushl  -0x30(%ebp)
  800842:	68 80 42 80 00       	push   $0x804280
  800847:	e8 5b 08 00 00       	call   8010a7 <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80084f:	e8 fb 19 00 00       	call   80224f <sys_calculate_free_frames>
  800854:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800857:	e8 93 1a 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  800880:	68 60 42 80 00       	push   $0x804260
  800885:	68 ac 00 00 00       	push   $0xac
  80088a:	68 9c 40 80 00       	push   $0x80409c
  80088f:	e8 5f 05 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800894:	e8 56 1a 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  8008b6:	68 b6 41 80 00       	push   $0x8041b6
  8008bb:	68 ad 00 00 00       	push   $0xad
  8008c0:	68 9c 40 80 00       	push   $0x80409c
  8008c5:	e8 29 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008ca:	e8 80 19 00 00       	call   80224f <sys_calculate_free_frames>
  8008cf:	89 c2                	mov    %eax,%edx
  8008d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 17                	je     8008ef <_main+0x8b7>
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 d3 41 80 00       	push   $0x8041d3
  8008e0:	68 ae 00 00 00       	push   $0xae
  8008e5:	68 9c 40 80 00       	push   $0x80409c
  8008ea:	e8 04 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ef:	ff 45 d0             	incl   -0x30(%ebp)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 d0             	pushl  -0x30(%ebp)
  8008f8:	68 80 42 80 00       	push   $0x804280
  8008fd:	e8 a5 07 00 00       	call   8010a7 <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800905:	e8 45 19 00 00       	call   80224f <sys_calculate_free_frames>
  80090a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090d:	e8 dd 19 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  80093e:	68 60 42 80 00       	push   $0x804260
  800943:	68 b5 00 00 00       	push   $0xb5
  800948:	68 9c 40 80 00       	push   $0x80409c
  80094d:	e8 a1 04 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800952:	e8 98 19 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  80097c:	68 b6 41 80 00       	push   $0x8041b6
  800981:	68 b6 00 00 00       	push   $0xb6
  800986:	68 9c 40 80 00       	push   $0x80409c
  80098b:	e8 63 04 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800990:	e8 ba 18 00 00       	call   80224f <sys_calculate_free_frames>
  800995:	89 c2                	mov    %eax,%edx
  800997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 17                	je     8009b5 <_main+0x97d>
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	68 d3 41 80 00       	push   $0x8041d3
  8009a6:	68 b7 00 00 00       	push   $0xb7
  8009ab:	68 9c 40 80 00       	push   $0x80409c
  8009b0:	e8 3e 04 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009b5:	ff 45 d0             	incl   -0x30(%ebp)
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8009be:	68 80 42 80 00       	push   $0x804280
  8009c3:	e8 df 06 00 00       	call   8010a7 <cprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 7f 18 00 00       	call   80224f <sys_calculate_free_frames>
  8009d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 17 19 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  8009fd:	68 60 42 80 00       	push   $0x804260
  800a02:	68 be 00 00 00       	push   $0xbe
  800a07:	68 9c 40 80 00       	push   $0x80409c
  800a0c:	e8 e2 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a11:	e8 d9 18 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  800a34:	68 b6 41 80 00       	push   $0x8041b6
  800a39:	68 bf 00 00 00       	push   $0xbf
  800a3e:	68 9c 40 80 00       	push   $0x80409c
  800a43:	e8 ab 03 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a48:	e8 02 18 00 00       	call   80224f <sys_calculate_free_frames>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 17                	je     800a6d <_main+0xa35>
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 d3 41 80 00       	push   $0x8041d3
  800a5e:	68 c0 00 00 00       	push   $0xc0
  800a63:	68 9c 40 80 00       	push   $0x80409c
  800a68:	e8 86 03 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a6d:	ff 45 d0             	incl   -0x30(%ebp)
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 d0             	pushl  -0x30(%ebp)
  800a76:	68 80 42 80 00       	push   $0x804280
  800a7b:	e8 27 06 00 00       	call   8010a7 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 c7 17 00 00       	call   80224f <sys_calculate_free_frames>
  800a88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 5f 18 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  800ab2:	68 60 42 80 00       	push   $0x804260
  800ab7:	68 c7 00 00 00       	push   $0xc7
  800abc:	68 9c 40 80 00       	push   $0x80409c
  800ac1:	e8 2d 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800ac6:	e8 24 18 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  800ae9:	68 b6 41 80 00       	push   $0x8041b6
  800aee:	68 c8 00 00 00       	push   $0xc8
  800af3:	68 9c 40 80 00       	push   $0x80409c
  800af8:	e8 f6 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800afd:	e8 4d 17 00 00       	call   80224f <sys_calculate_free_frames>
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 d3 41 80 00       	push   $0x8041d3
  800b13:	68 c9 00 00 00       	push   $0xc9
  800b18:	68 9c 40 80 00       	push   $0x80409c
  800b1d:	e8 d1 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b22:	ff 45 d0             	incl   -0x30(%ebp)
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 d0             	pushl  -0x30(%ebp)
  800b2b:	68 80 42 80 00       	push   $0x804280
  800b30:	e8 72 05 00 00       	call   8010a7 <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800b38:	e8 12 17 00 00       	call   80224f <sys_calculate_free_frames>
  800b3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b40:	e8 aa 17 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  800b72:	68 60 42 80 00       	push   $0x804260
  800b77:	68 d0 00 00 00       	push   $0xd0
  800b7c:	68 9c 40 80 00       	push   $0x80409c
  800b81:	e8 6d 02 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800b86:	e8 64 17 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  800bb1:	68 b6 41 80 00       	push   $0x8041b6
  800bb6:	68 d1 00 00 00       	push   $0xd1
  800bbb:	68 9c 40 80 00       	push   $0x80409c
  800bc0:	e8 2e 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bc5:	e8 85 16 00 00       	call   80224f <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 d3 41 80 00       	push   $0x8041d3
  800bdb:	68 d2 00 00 00       	push   $0xd2
  800be0:	68 9c 40 80 00       	push   $0x80409c
  800be5:	e8 09 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bea:	ff 45 d0             	incl   -0x30(%ebp)
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  800bf3:	68 80 42 80 00       	push   $0x804280
  800bf8:	e8 aa 04 00 00       	call   8010a7 <cprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800c00:	e8 4a 16 00 00       	call   80224f <sys_calculate_free_frames>
  800c05:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800c08:	e8 e2 16 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
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
  800c2f:	68 60 42 80 00       	push   $0x804260
  800c34:	68 da 00 00 00       	push   $0xda
  800c39:	68 9c 40 80 00       	push   $0x80409c
  800c3e:	e8 b0 01 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c43:	e8 a7 16 00 00       	call   8022ef <sys_pf_calculate_allocated_pages>
  800c48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800c4b:	74 17                	je     800c64 <_main+0xc2c>
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	68 b6 41 80 00       	push   $0x8041b6
  800c55:	68 db 00 00 00       	push   $0xdb
  800c5a:	68 9c 40 80 00       	push   $0x80409c
  800c5f:	e8 8f 01 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800c64:	e8 e6 15 00 00       	call   80224f <sys_calculate_free_frames>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6e:	39 c2                	cmp    %eax,%edx
  800c70:	74 17                	je     800c89 <_main+0xc51>
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	68 d3 41 80 00       	push   $0x8041d3
  800c7a:	68 dc 00 00 00       	push   $0xdc
  800c7f:	68 9c 40 80 00       	push   $0x80409c
  800c84:	e8 6a 01 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800c89:	ff 45 d0             	incl   -0x30(%ebp)
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c92:	68 80 42 80 00       	push   $0x804280
  800c97:	e8 0b 04 00 00       	call   8010a7 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	68 94 42 80 00       	push   $0x804294
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
  800cbd:	e8 6d 18 00 00       	call   80252f <sys_getenvindex>
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
  800d28:	e8 0f 16 00 00       	call   80233c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	68 e8 42 80 00       	push   $0x8042e8
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
  800d58:	68 10 43 80 00       	push   $0x804310
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
  800d89:	68 38 43 80 00       	push   $0x804338
  800d8e:	e8 14 03 00 00       	call   8010a7 <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d96:	a1 20 50 80 00       	mov    0x805020,%eax
  800d9b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	50                   	push   %eax
  800da5:	68 90 43 80 00       	push   $0x804390
  800daa:	e8 f8 02 00 00       	call   8010a7 <cprintf>
  800daf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	68 e8 42 80 00       	push   $0x8042e8
  800dba:	e8 e8 02 00 00       	call   8010a7 <cprintf>
  800dbf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800dc2:	e8 8f 15 00 00       	call   802356 <sys_enable_interrupt>

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
  800dda:	e8 1c 17 00 00       	call   8024fb <sys_destroy_env>
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
  800deb:	e8 71 17 00 00       	call   802561 <sys_exit_env>
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
  800e14:	68 a4 43 80 00       	push   $0x8043a4
  800e19:	e8 89 02 00 00       	call   8010a7 <cprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800e21:	a1 00 50 80 00       	mov    0x805000,%eax
  800e26:	ff 75 0c             	pushl  0xc(%ebp)
  800e29:	ff 75 08             	pushl  0x8(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	68 a9 43 80 00       	push   $0x8043a9
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
  800e51:	68 c5 43 80 00       	push   $0x8043c5
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
  800e7d:	68 c8 43 80 00       	push   $0x8043c8
  800e82:	6a 26                	push   $0x26
  800e84:	68 14 44 80 00       	push   $0x804414
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
  800f4f:	68 20 44 80 00       	push   $0x804420
  800f54:	6a 3a                	push   $0x3a
  800f56:	68 14 44 80 00       	push   $0x804414
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
  800fbf:	68 74 44 80 00       	push   $0x804474
  800fc4:	6a 44                	push   $0x44
  800fc6:	68 14 44 80 00       	push   $0x804414
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
  801019:	e8 70 11 00 00       	call   80218e <sys_cputs>
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
  801090:	e8 f9 10 00 00       	call   80218e <sys_cputs>
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
  8010da:	e8 5d 12 00 00       	call   80233c <sys_disable_interrupt>
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
  8010fa:	e8 57 12 00 00       	call   802356 <sys_enable_interrupt>
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
  801144:	e8 cb 2c 00 00       	call   803e14 <__udivdi3>
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
  801194:	e8 8b 2d 00 00       	call   803f24 <__umoddi3>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	05 d4 46 80 00       	add    $0x8046d4,%eax
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
  8012ef:	8b 04 85 f8 46 80 00 	mov    0x8046f8(,%eax,4),%eax
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
  8013d0:	8b 34 9d 40 45 80 00 	mov    0x804540(,%ebx,4),%esi
  8013d7:	85 f6                	test   %esi,%esi
  8013d9:	75 19                	jne    8013f4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8013db:	53                   	push   %ebx
  8013dc:	68 e5 46 80 00       	push   $0x8046e5
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
  8013f5:	68 ee 46 80 00       	push   $0x8046ee
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
  801422:	be f1 46 80 00       	mov    $0x8046f1,%esi
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
  801e48:	68 50 48 80 00       	push   $0x804850
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
  801f18:	e8 b5 03 00 00       	call   8022d2 <sys_allocate_chunk>
  801f1d:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801f20:	a1 20 51 80 00       	mov    0x805120,%eax
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	50                   	push   %eax
  801f29:	e8 2a 0a 00 00       	call   802958 <initialize_MemBlocksList>
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
  801f56:	68 75 48 80 00       	push   $0x804875
  801f5b:	6a 33                	push   $0x33
  801f5d:	68 93 48 80 00       	push   $0x804893
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
  801fd5:	68 a0 48 80 00       	push   $0x8048a0
  801fda:	6a 34                	push   $0x34
  801fdc:	68 93 48 80 00       	push   $0x804893
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
  80204a:	68 c4 48 80 00       	push   $0x8048c4
  80204f:	6a 46                	push   $0x46
  802051:	68 93 48 80 00       	push   $0x804893
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
  802066:	68 ec 48 80 00       	push   $0x8048ec
  80206b:	6a 61                	push   $0x61
  80206d:	68 93 48 80 00       	push   $0x804893
  802072:	e8 7c ed ff ff       	call   800df3 <_panic>

00802077 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 18             	sub    $0x18,%esp
  80207d:	8b 45 10             	mov    0x10(%ebp),%eax
  802080:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802083:	e8 a9 fd ff ff       	call   801e31 <InitializeUHeap>
	if (size == 0) return NULL ;
  802088:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80208c:	75 07                	jne    802095 <smalloc+0x1e>
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	eb 14                	jmp    8020a9 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  802095:	83 ec 04             	sub    $0x4,%esp
  802098:	68 10 49 80 00       	push   $0x804910
  80209d:	6a 76                	push   $0x76
  80209f:	68 93 48 80 00       	push   $0x804893
  8020a4:	e8 4a ed ff ff       	call   800df3 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020b1:	e8 7b fd ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8020b6:	83 ec 04             	sub    $0x4,%esp
  8020b9:	68 38 49 80 00       	push   $0x804938
  8020be:	68 93 00 00 00       	push   $0x93
  8020c3:	68 93 48 80 00       	push   $0x804893
  8020c8:	e8 26 ed ff ff       	call   800df3 <_panic>

008020cd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020d3:	e8 59 fd ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	68 5c 49 80 00       	push   $0x80495c
  8020e0:	68 c5 00 00 00       	push   $0xc5
  8020e5:	68 93 48 80 00       	push   $0x804893
  8020ea:	e8 04 ed ff ff       	call   800df3 <_panic>

008020ef <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020f5:	83 ec 04             	sub    $0x4,%esp
  8020f8:	68 84 49 80 00       	push   $0x804984
  8020fd:	68 d9 00 00 00       	push   $0xd9
  802102:	68 93 48 80 00       	push   $0x804893
  802107:	e8 e7 ec ff ff       	call   800df3 <_panic>

0080210c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802112:	83 ec 04             	sub    $0x4,%esp
  802115:	68 a8 49 80 00       	push   $0x8049a8
  80211a:	68 e4 00 00 00       	push   $0xe4
  80211f:	68 93 48 80 00       	push   $0x804893
  802124:	e8 ca ec ff ff       	call   800df3 <_panic>

00802129 <shrink>:

}
void shrink(uint32 newSize)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80212f:	83 ec 04             	sub    $0x4,%esp
  802132:	68 a8 49 80 00       	push   $0x8049a8
  802137:	68 e9 00 00 00       	push   $0xe9
  80213c:	68 93 48 80 00       	push   $0x804893
  802141:	e8 ad ec ff ff       	call   800df3 <_panic>

00802146 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80214c:	83 ec 04             	sub    $0x4,%esp
  80214f:	68 a8 49 80 00       	push   $0x8049a8
  802154:	68 ee 00 00 00       	push   $0xee
  802159:	68 93 48 80 00       	push   $0x804893
  80215e:	e8 90 ec ff ff       	call   800df3 <_panic>

00802163 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	57                   	push   %edi
  802167:	56                   	push   %esi
  802168:	53                   	push   %ebx
  802169:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802172:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802175:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802178:	8b 7d 18             	mov    0x18(%ebp),%edi
  80217b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80217e:	cd 30                	int    $0x30
  802180:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802183:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	5b                   	pop    %ebx
  80218a:	5e                   	pop    %esi
  80218b:	5f                   	pop    %edi
  80218c:	5d                   	pop    %ebp
  80218d:	c3                   	ret    

0080218e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	8b 45 10             	mov    0x10(%ebp),%eax
  802197:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80219a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	52                   	push   %edx
  8021a6:	ff 75 0c             	pushl  0xc(%ebp)
  8021a9:	50                   	push   %eax
  8021aa:	6a 00                	push   $0x0
  8021ac:	e8 b2 ff ff ff       	call   802163 <syscall>
  8021b1:	83 c4 18             	add    $0x18,%esp
}
  8021b4:	90                   	nop
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 01                	push   $0x1
  8021c6:	e8 98 ff ff ff       	call   802163 <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	52                   	push   %edx
  8021e0:	50                   	push   %eax
  8021e1:	6a 05                	push   $0x5
  8021e3:	e8 7b ff ff ff       	call   802163 <syscall>
  8021e8:	83 c4 18             	add    $0x18,%esp
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	56                   	push   %esi
  8021f1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021f2:	8b 75 18             	mov    0x18(%ebp),%esi
  8021f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	56                   	push   %esi
  802202:	53                   	push   %ebx
  802203:	51                   	push   %ecx
  802204:	52                   	push   %edx
  802205:	50                   	push   %eax
  802206:	6a 06                	push   $0x6
  802208:	e8 56 ff ff ff       	call   802163 <syscall>
  80220d:	83 c4 18             	add    $0x18,%esp
}
  802210:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802213:	5b                   	pop    %ebx
  802214:	5e                   	pop    %esi
  802215:	5d                   	pop    %ebp
  802216:	c3                   	ret    

00802217 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80221a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	52                   	push   %edx
  802227:	50                   	push   %eax
  802228:	6a 07                	push   $0x7
  80222a:	e8 34 ff ff ff       	call   802163 <syscall>
  80222f:	83 c4 18             	add    $0x18,%esp
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	ff 75 0c             	pushl  0xc(%ebp)
  802240:	ff 75 08             	pushl  0x8(%ebp)
  802243:	6a 08                	push   $0x8
  802245:	e8 19 ff ff ff       	call   802163 <syscall>
  80224a:	83 c4 18             	add    $0x18,%esp
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 09                	push   $0x9
  80225e:	e8 00 ff ff ff       	call   802163 <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 0a                	push   $0xa
  802277:	e8 e7 fe ff ff       	call   802163 <syscall>
  80227c:	83 c4 18             	add    $0x18,%esp
}
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 0b                	push   $0xb
  802290:	e8 ce fe ff ff       	call   802163 <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	ff 75 0c             	pushl  0xc(%ebp)
  8022a6:	ff 75 08             	pushl  0x8(%ebp)
  8022a9:	6a 0f                	push   $0xf
  8022ab:	e8 b3 fe ff ff       	call   802163 <syscall>
  8022b0:	83 c4 18             	add    $0x18,%esp
	return;
  8022b3:	90                   	nop
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	ff 75 0c             	pushl  0xc(%ebp)
  8022c2:	ff 75 08             	pushl  0x8(%ebp)
  8022c5:	6a 10                	push   $0x10
  8022c7:	e8 97 fe ff ff       	call   802163 <syscall>
  8022cc:	83 c4 18             	add    $0x18,%esp
	return ;
  8022cf:	90                   	nop
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	ff 75 10             	pushl  0x10(%ebp)
  8022dc:	ff 75 0c             	pushl  0xc(%ebp)
  8022df:	ff 75 08             	pushl  0x8(%ebp)
  8022e2:	6a 11                	push   $0x11
  8022e4:	e8 7a fe ff ff       	call   802163 <syscall>
  8022e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ec:	90                   	nop
}
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 0c                	push   $0xc
  8022fe:	e8 60 fe ff ff       	call   802163 <syscall>
  802303:	83 c4 18             	add    $0x18,%esp
}
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	ff 75 08             	pushl  0x8(%ebp)
  802316:	6a 0d                	push   $0xd
  802318:	e8 46 fe ff ff       	call   802163 <syscall>
  80231d:	83 c4 18             	add    $0x18,%esp
}
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 0e                	push   $0xe
  802331:	e8 2d fe ff ff       	call   802163 <syscall>
  802336:	83 c4 18             	add    $0x18,%esp
}
  802339:	90                   	nop
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 13                	push   $0x13
  80234b:	e8 13 fe ff ff       	call   802163 <syscall>
  802350:	83 c4 18             	add    $0x18,%esp
}
  802353:	90                   	nop
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 14                	push   $0x14
  802365:	e8 f9 fd ff ff       	call   802163 <syscall>
  80236a:	83 c4 18             	add    $0x18,%esp
}
  80236d:	90                   	nop
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <sys_cputc>:


void
sys_cputc(const char c)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 04             	sub    $0x4,%esp
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80237c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	50                   	push   %eax
  802389:	6a 15                	push   $0x15
  80238b:	e8 d3 fd ff ff       	call   802163 <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
}
  802393:	90                   	nop
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 16                	push   $0x16
  8023a5:	e8 b9 fd ff ff       	call   802163 <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
}
  8023ad:	90                   	nop
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	6a 00                	push   $0x0
  8023bc:	ff 75 0c             	pushl  0xc(%ebp)
  8023bf:	50                   	push   %eax
  8023c0:	6a 17                	push   $0x17
  8023c2:	e8 9c fd ff ff       	call   802163 <syscall>
  8023c7:	83 c4 18             	add    $0x18,%esp
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	52                   	push   %edx
  8023dc:	50                   	push   %eax
  8023dd:	6a 1a                	push   $0x1a
  8023df:	e8 7f fd ff ff       	call   802163 <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
}
  8023e7:	c9                   	leave  
  8023e8:	c3                   	ret    

008023e9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	52                   	push   %edx
  8023f9:	50                   	push   %eax
  8023fa:	6a 18                	push   $0x18
  8023fc:	e8 62 fd ff ff       	call   802163 <syscall>
  802401:	83 c4 18             	add    $0x18,%esp
}
  802404:	90                   	nop
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80240a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	52                   	push   %edx
  802417:	50                   	push   %eax
  802418:	6a 19                	push   $0x19
  80241a:	e8 44 fd ff ff       	call   802163 <syscall>
  80241f:	83 c4 18             	add    $0x18,%esp
}
  802422:	90                   	nop
  802423:	c9                   	leave  
  802424:	c3                   	ret    

00802425 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
  802428:	83 ec 04             	sub    $0x4,%esp
  80242b:	8b 45 10             	mov    0x10(%ebp),%eax
  80242e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802431:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802434:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	6a 00                	push   $0x0
  80243d:	51                   	push   %ecx
  80243e:	52                   	push   %edx
  80243f:	ff 75 0c             	pushl  0xc(%ebp)
  802442:	50                   	push   %eax
  802443:	6a 1b                	push   $0x1b
  802445:	e8 19 fd ff ff       	call   802163 <syscall>
  80244a:	83 c4 18             	add    $0x18,%esp
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802452:	8b 55 0c             	mov    0xc(%ebp),%edx
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	52                   	push   %edx
  80245f:	50                   	push   %eax
  802460:	6a 1c                	push   $0x1c
  802462:	e8 fc fc ff ff       	call   802163 <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80246f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802472:	8b 55 0c             	mov    0xc(%ebp),%edx
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	51                   	push   %ecx
  80247d:	52                   	push   %edx
  80247e:	50                   	push   %eax
  80247f:	6a 1d                	push   $0x1d
  802481:	e8 dd fc ff ff       	call   802163 <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80248e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	52                   	push   %edx
  80249b:	50                   	push   %eax
  80249c:	6a 1e                	push   $0x1e
  80249e:	e8 c0 fc ff ff       	call   802163 <syscall>
  8024a3:	83 c4 18             	add    $0x18,%esp
}
  8024a6:	c9                   	leave  
  8024a7:	c3                   	ret    

008024a8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 1f                	push   $0x1f
  8024b7:	e8 a7 fc ff ff       	call   802163 <syscall>
  8024bc:	83 c4 18             	add    $0x18,%esp
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	6a 00                	push   $0x0
  8024c9:	ff 75 14             	pushl  0x14(%ebp)
  8024cc:	ff 75 10             	pushl  0x10(%ebp)
  8024cf:	ff 75 0c             	pushl  0xc(%ebp)
  8024d2:	50                   	push   %eax
  8024d3:	6a 20                	push   $0x20
  8024d5:	e8 89 fc ff ff       	call   802163 <syscall>
  8024da:	83 c4 18             	add    $0x18,%esp
}
  8024dd:	c9                   	leave  
  8024de:	c3                   	ret    

008024df <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8024df:	55                   	push   %ebp
  8024e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	50                   	push   %eax
  8024ee:	6a 21                	push   $0x21
  8024f0:	e8 6e fc ff ff       	call   802163 <syscall>
  8024f5:	83 c4 18             	add    $0x18,%esp
}
  8024f8:	90                   	nop
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	50                   	push   %eax
  80250a:	6a 22                	push   $0x22
  80250c:	e8 52 fc ff ff       	call   802163 <syscall>
  802511:	83 c4 18             	add    $0x18,%esp
}
  802514:	c9                   	leave  
  802515:	c3                   	ret    

00802516 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802516:	55                   	push   %ebp
  802517:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	6a 02                	push   $0x2
  802525:	e8 39 fc ff ff       	call   802163 <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 03                	push   $0x3
  80253e:	e8 20 fc ff ff       	call   802163 <syscall>
  802543:	83 c4 18             	add    $0x18,%esp
}
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	6a 04                	push   $0x4
  802557:	e8 07 fc ff ff       	call   802163 <syscall>
  80255c:	83 c4 18             	add    $0x18,%esp
}
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <sys_exit_env>:


void sys_exit_env(void)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 23                	push   $0x23
  802570:	e8 ee fb ff ff       	call   802163 <syscall>
  802575:	83 c4 18             	add    $0x18,%esp
}
  802578:	90                   	nop
  802579:	c9                   	leave  
  80257a:	c3                   	ret    

0080257b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
  80257e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802581:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802584:	8d 50 04             	lea    0x4(%eax),%edx
  802587:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	52                   	push   %edx
  802591:	50                   	push   %eax
  802592:	6a 24                	push   $0x24
  802594:	e8 ca fb ff ff       	call   802163 <syscall>
  802599:	83 c4 18             	add    $0x18,%esp
	return result;
  80259c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80259f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025a5:	89 01                	mov    %eax,(%ecx)
  8025a7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	c9                   	leave  
  8025ae:	c2 04 00             	ret    $0x4

008025b1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8025b1:	55                   	push   %ebp
  8025b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	ff 75 10             	pushl  0x10(%ebp)
  8025bb:	ff 75 0c             	pushl  0xc(%ebp)
  8025be:	ff 75 08             	pushl  0x8(%ebp)
  8025c1:	6a 12                	push   $0x12
  8025c3:	e8 9b fb ff ff       	call   802163 <syscall>
  8025c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8025cb:	90                   	nop
}
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    

008025ce <sys_rcr2>:
uint32 sys_rcr2()
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 25                	push   $0x25
  8025dd:	e8 81 fb ff ff       	call   802163 <syscall>
  8025e2:	83 c4 18             	add    $0x18,%esp
}
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
  8025ea:	83 ec 04             	sub    $0x4,%esp
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025f3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 00                	push   $0x0
  8025ff:	50                   	push   %eax
  802600:	6a 26                	push   $0x26
  802602:	e8 5c fb ff ff       	call   802163 <syscall>
  802607:	83 c4 18             	add    $0x18,%esp
	return ;
  80260a:	90                   	nop
}
  80260b:	c9                   	leave  
  80260c:	c3                   	ret    

0080260d <rsttst>:
void rsttst()
{
  80260d:	55                   	push   %ebp
  80260e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 28                	push   $0x28
  80261c:	e8 42 fb ff ff       	call   802163 <syscall>
  802621:	83 c4 18             	add    $0x18,%esp
	return ;
  802624:	90                   	nop
}
  802625:	c9                   	leave  
  802626:	c3                   	ret    

00802627 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802627:	55                   	push   %ebp
  802628:	89 e5                	mov    %esp,%ebp
  80262a:	83 ec 04             	sub    $0x4,%esp
  80262d:	8b 45 14             	mov    0x14(%ebp),%eax
  802630:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802633:	8b 55 18             	mov    0x18(%ebp),%edx
  802636:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80263a:	52                   	push   %edx
  80263b:	50                   	push   %eax
  80263c:	ff 75 10             	pushl  0x10(%ebp)
  80263f:	ff 75 0c             	pushl  0xc(%ebp)
  802642:	ff 75 08             	pushl  0x8(%ebp)
  802645:	6a 27                	push   $0x27
  802647:	e8 17 fb ff ff       	call   802163 <syscall>
  80264c:	83 c4 18             	add    $0x18,%esp
	return ;
  80264f:	90                   	nop
}
  802650:	c9                   	leave  
  802651:	c3                   	ret    

00802652 <chktst>:
void chktst(uint32 n)
{
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	ff 75 08             	pushl  0x8(%ebp)
  802660:	6a 29                	push   $0x29
  802662:	e8 fc fa ff ff       	call   802163 <syscall>
  802667:	83 c4 18             	add    $0x18,%esp
	return ;
  80266a:	90                   	nop
}
  80266b:	c9                   	leave  
  80266c:	c3                   	ret    

0080266d <inctst>:

void inctst()
{
  80266d:	55                   	push   %ebp
  80266e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802670:	6a 00                	push   $0x0
  802672:	6a 00                	push   $0x0
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 2a                	push   $0x2a
  80267c:	e8 e2 fa ff ff       	call   802163 <syscall>
  802681:	83 c4 18             	add    $0x18,%esp
	return ;
  802684:	90                   	nop
}
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <gettst>:
uint32 gettst()
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 2b                	push   $0x2b
  802696:	e8 c8 fa ff ff       	call   802163 <syscall>
  80269b:	83 c4 18             	add    $0x18,%esp
}
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
  8026a3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 00                	push   $0x0
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 2c                	push   $0x2c
  8026b2:	e8 ac fa ff ff       	call   802163 <syscall>
  8026b7:	83 c4 18             	add    $0x18,%esp
  8026ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8026bd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8026c1:	75 07                	jne    8026ca <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8026c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c8:	eb 05                	jmp    8026cf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8026ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
  8026d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026d7:	6a 00                	push   $0x0
  8026d9:	6a 00                	push   $0x0
  8026db:	6a 00                	push   $0x0
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 2c                	push   $0x2c
  8026e3:	e8 7b fa ff ff       	call   802163 <syscall>
  8026e8:	83 c4 18             	add    $0x18,%esp
  8026eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026ee:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026f2:	75 07                	jne    8026fb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f9:	eb 05                	jmp    802700 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802700:	c9                   	leave  
  802701:	c3                   	ret    

00802702 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802702:	55                   	push   %ebp
  802703:	89 e5                	mov    %esp,%ebp
  802705:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	6a 2c                	push   $0x2c
  802714:	e8 4a fa ff ff       	call   802163 <syscall>
  802719:	83 c4 18             	add    $0x18,%esp
  80271c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80271f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802723:	75 07                	jne    80272c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802725:	b8 01 00 00 00       	mov    $0x1,%eax
  80272a:	eb 05                	jmp    802731 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802731:	c9                   	leave  
  802732:	c3                   	ret    

00802733 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802733:	55                   	push   %ebp
  802734:	89 e5                	mov    %esp,%ebp
  802736:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 2c                	push   $0x2c
  802745:	e8 19 fa ff ff       	call   802163 <syscall>
  80274a:	83 c4 18             	add    $0x18,%esp
  80274d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802750:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802754:	75 07                	jne    80275d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802756:	b8 01 00 00 00       	mov    $0x1,%eax
  80275b:	eb 05                	jmp    802762 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80275d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802762:	c9                   	leave  
  802763:	c3                   	ret    

00802764 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802764:	55                   	push   %ebp
  802765:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802767:	6a 00                	push   $0x0
  802769:	6a 00                	push   $0x0
  80276b:	6a 00                	push   $0x0
  80276d:	6a 00                	push   $0x0
  80276f:	ff 75 08             	pushl  0x8(%ebp)
  802772:	6a 2d                	push   $0x2d
  802774:	e8 ea f9 ff ff       	call   802163 <syscall>
  802779:	83 c4 18             	add    $0x18,%esp
	return ;
  80277c:	90                   	nop
}
  80277d:	c9                   	leave  
  80277e:	c3                   	ret    

0080277f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80277f:	55                   	push   %ebp
  802780:	89 e5                	mov    %esp,%ebp
  802782:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802783:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802786:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802789:	8b 55 0c             	mov    0xc(%ebp),%edx
  80278c:	8b 45 08             	mov    0x8(%ebp),%eax
  80278f:	6a 00                	push   $0x0
  802791:	53                   	push   %ebx
  802792:	51                   	push   %ecx
  802793:	52                   	push   %edx
  802794:	50                   	push   %eax
  802795:	6a 2e                	push   $0x2e
  802797:	e8 c7 f9 ff ff       	call   802163 <syscall>
  80279c:	83 c4 18             	add    $0x18,%esp
}
  80279f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027a2:	c9                   	leave  
  8027a3:	c3                   	ret    

008027a4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8027a4:	55                   	push   %ebp
  8027a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8027a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ad:	6a 00                	push   $0x0
  8027af:	6a 00                	push   $0x0
  8027b1:	6a 00                	push   $0x0
  8027b3:	52                   	push   %edx
  8027b4:	50                   	push   %eax
  8027b5:	6a 2f                	push   $0x2f
  8027b7:	e8 a7 f9 ff ff       	call   802163 <syscall>
  8027bc:	83 c4 18             	add    $0x18,%esp
}
  8027bf:	c9                   	leave  
  8027c0:	c3                   	ret    

008027c1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8027c1:	55                   	push   %ebp
  8027c2:	89 e5                	mov    %esp,%ebp
  8027c4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8027c7:	83 ec 0c             	sub    $0xc,%esp
  8027ca:	68 b8 49 80 00       	push   $0x8049b8
  8027cf:	e8 d3 e8 ff ff       	call   8010a7 <cprintf>
  8027d4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8027d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8027de:	83 ec 0c             	sub    $0xc,%esp
  8027e1:	68 e4 49 80 00       	push   $0x8049e4
  8027e6:	e8 bc e8 ff ff       	call   8010a7 <cprintf>
  8027eb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8027ee:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8027f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fa:	eb 56                	jmp    802852 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802800:	74 1c                	je     80281e <print_mem_block_lists+0x5d>
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 50 08             	mov    0x8(%eax),%edx
  802808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280b:	8b 48 08             	mov    0x8(%eax),%ecx
  80280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802811:	8b 40 0c             	mov    0xc(%eax),%eax
  802814:	01 c8                	add    %ecx,%eax
  802816:	39 c2                	cmp    %eax,%edx
  802818:	73 04                	jae    80281e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80281a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 50 08             	mov    0x8(%eax),%edx
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 40 0c             	mov    0xc(%eax),%eax
  80282a:	01 c2                	add    %eax,%edx
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 40 08             	mov    0x8(%eax),%eax
  802832:	83 ec 04             	sub    $0x4,%esp
  802835:	52                   	push   %edx
  802836:	50                   	push   %eax
  802837:	68 f9 49 80 00       	push   $0x8049f9
  80283c:	e8 66 e8 ff ff       	call   8010a7 <cprintf>
  802841:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80284a:	a1 40 51 80 00       	mov    0x805140,%eax
  80284f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802852:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802856:	74 07                	je     80285f <print_mem_block_lists+0x9e>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	eb 05                	jmp    802864 <print_mem_block_lists+0xa3>
  80285f:	b8 00 00 00 00       	mov    $0x0,%eax
  802864:	a3 40 51 80 00       	mov    %eax,0x805140
  802869:	a1 40 51 80 00       	mov    0x805140,%eax
  80286e:	85 c0                	test   %eax,%eax
  802870:	75 8a                	jne    8027fc <print_mem_block_lists+0x3b>
  802872:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802876:	75 84                	jne    8027fc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802878:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80287c:	75 10                	jne    80288e <print_mem_block_lists+0xcd>
  80287e:	83 ec 0c             	sub    $0xc,%esp
  802881:	68 08 4a 80 00       	push   $0x804a08
  802886:	e8 1c e8 ff ff       	call   8010a7 <cprintf>
  80288b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80288e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802895:	83 ec 0c             	sub    $0xc,%esp
  802898:	68 2c 4a 80 00       	push   $0x804a2c
  80289d:	e8 05 e8 ff ff       	call   8010a7 <cprintf>
  8028a2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8028a5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028a9:	a1 40 50 80 00       	mov    0x805040,%eax
  8028ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b1:	eb 56                	jmp    802909 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b7:	74 1c                	je     8028d5 <print_mem_block_lists+0x114>
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 50 08             	mov    0x8(%eax),%edx
  8028bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c2:	8b 48 08             	mov    0x8(%eax),%ecx
  8028c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cb:	01 c8                	add    %ecx,%eax
  8028cd:	39 c2                	cmp    %eax,%edx
  8028cf:	73 04                	jae    8028d5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8028d1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 50 08             	mov    0x8(%eax),%edx
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e1:	01 c2                	add    %eax,%edx
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	8b 40 08             	mov    0x8(%eax),%eax
  8028e9:	83 ec 04             	sub    $0x4,%esp
  8028ec:	52                   	push   %edx
  8028ed:	50                   	push   %eax
  8028ee:	68 f9 49 80 00       	push   $0x8049f9
  8028f3:	e8 af e7 ff ff       	call   8010a7 <cprintf>
  8028f8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802901:	a1 48 50 80 00       	mov    0x805048,%eax
  802906:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802909:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290d:	74 07                	je     802916 <print_mem_block_lists+0x155>
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	eb 05                	jmp    80291b <print_mem_block_lists+0x15a>
  802916:	b8 00 00 00 00       	mov    $0x0,%eax
  80291b:	a3 48 50 80 00       	mov    %eax,0x805048
  802920:	a1 48 50 80 00       	mov    0x805048,%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	75 8a                	jne    8028b3 <print_mem_block_lists+0xf2>
  802929:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292d:	75 84                	jne    8028b3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80292f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802933:	75 10                	jne    802945 <print_mem_block_lists+0x184>
  802935:	83 ec 0c             	sub    $0xc,%esp
  802938:	68 44 4a 80 00       	push   $0x804a44
  80293d:	e8 65 e7 ff ff       	call   8010a7 <cprintf>
  802942:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802945:	83 ec 0c             	sub    $0xc,%esp
  802948:	68 b8 49 80 00       	push   $0x8049b8
  80294d:	e8 55 e7 ff ff       	call   8010a7 <cprintf>
  802952:	83 c4 10             	add    $0x10,%esp

}
  802955:	90                   	nop
  802956:	c9                   	leave  
  802957:	c3                   	ret    

00802958 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802958:	55                   	push   %ebp
  802959:	89 e5                	mov    %esp,%ebp
  80295b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80295e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802965:	00 00 00 
  802968:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80296f:	00 00 00 
  802972:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802979:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80297c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802983:	e9 9e 00 00 00       	jmp    802a26 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802988:	a1 50 50 80 00       	mov    0x805050,%eax
  80298d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802990:	c1 e2 04             	shl    $0x4,%edx
  802993:	01 d0                	add    %edx,%eax
  802995:	85 c0                	test   %eax,%eax
  802997:	75 14                	jne    8029ad <initialize_MemBlocksList+0x55>
  802999:	83 ec 04             	sub    $0x4,%esp
  80299c:	68 6c 4a 80 00       	push   $0x804a6c
  8029a1:	6a 46                	push   $0x46
  8029a3:	68 8f 4a 80 00       	push   $0x804a8f
  8029a8:	e8 46 e4 ff ff       	call   800df3 <_panic>
  8029ad:	a1 50 50 80 00       	mov    0x805050,%eax
  8029b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b5:	c1 e2 04             	shl    $0x4,%edx
  8029b8:	01 d0                	add    %edx,%eax
  8029ba:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8029c0:	89 10                	mov    %edx,(%eax)
  8029c2:	8b 00                	mov    (%eax),%eax
  8029c4:	85 c0                	test   %eax,%eax
  8029c6:	74 18                	je     8029e0 <initialize_MemBlocksList+0x88>
  8029c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8029cd:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8029d3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8029d6:	c1 e1 04             	shl    $0x4,%ecx
  8029d9:	01 ca                	add    %ecx,%edx
  8029db:	89 50 04             	mov    %edx,0x4(%eax)
  8029de:	eb 12                	jmp    8029f2 <initialize_MemBlocksList+0x9a>
  8029e0:	a1 50 50 80 00       	mov    0x805050,%eax
  8029e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e8:	c1 e2 04             	shl    $0x4,%edx
  8029eb:	01 d0                	add    %edx,%eax
  8029ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029f2:	a1 50 50 80 00       	mov    0x805050,%eax
  8029f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029fa:	c1 e2 04             	shl    $0x4,%edx
  8029fd:	01 d0                	add    %edx,%eax
  8029ff:	a3 48 51 80 00       	mov    %eax,0x805148
  802a04:	a1 50 50 80 00       	mov    0x805050,%eax
  802a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0c:	c1 e2 04             	shl    $0x4,%edx
  802a0f:	01 d0                	add    %edx,%eax
  802a11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a18:	a1 54 51 80 00       	mov    0x805154,%eax
  802a1d:	40                   	inc    %eax
  802a1e:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802a23:	ff 45 f4             	incl   -0xc(%ebp)
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2c:	0f 82 56 ff ff ff    	jb     802988 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802a32:	90                   	nop
  802a33:	c9                   	leave  
  802a34:	c3                   	ret    

00802a35 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802a35:	55                   	push   %ebp
  802a36:	89 e5                	mov    %esp,%ebp
  802a38:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a43:	eb 19                	jmp    802a5e <find_block+0x29>
	{
		if(va==point->sva)
  802a45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a48:	8b 40 08             	mov    0x8(%eax),%eax
  802a4b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a4e:	75 05                	jne    802a55 <find_block+0x20>
		   return point;
  802a50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a53:	eb 36                	jmp    802a8b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	8b 40 08             	mov    0x8(%eax),%eax
  802a5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a62:	74 07                	je     802a6b <find_block+0x36>
  802a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	eb 05                	jmp    802a70 <find_block+0x3b>
  802a6b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a70:	8b 55 08             	mov    0x8(%ebp),%edx
  802a73:	89 42 08             	mov    %eax,0x8(%edx)
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	8b 40 08             	mov    0x8(%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	75 c5                	jne    802a45 <find_block+0x10>
  802a80:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a84:	75 bf                	jne    802a45 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802a86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a8b:	c9                   	leave  
  802a8c:	c3                   	ret    

00802a8d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802a8d:	55                   	push   %ebp
  802a8e:	89 e5                	mov    %esp,%ebp
  802a90:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802a93:	a1 40 50 80 00       	mov    0x805040,%eax
  802a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802a9b:	a1 44 50 80 00       	mov    0x805044,%eax
  802aa0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802aa9:	74 24                	je     802acf <insert_sorted_allocList+0x42>
  802aab:	8b 45 08             	mov    0x8(%ebp),%eax
  802aae:	8b 50 08             	mov    0x8(%eax),%edx
  802ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab4:	8b 40 08             	mov    0x8(%eax),%eax
  802ab7:	39 c2                	cmp    %eax,%edx
  802ab9:	76 14                	jbe    802acf <insert_sorted_allocList+0x42>
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	8b 50 08             	mov    0x8(%eax),%edx
  802ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac4:	8b 40 08             	mov    0x8(%eax),%eax
  802ac7:	39 c2                	cmp    %eax,%edx
  802ac9:	0f 82 60 01 00 00    	jb     802c2f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802acf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad3:	75 65                	jne    802b3a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802ad5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad9:	75 14                	jne    802aef <insert_sorted_allocList+0x62>
  802adb:	83 ec 04             	sub    $0x4,%esp
  802ade:	68 6c 4a 80 00       	push   $0x804a6c
  802ae3:	6a 6b                	push   $0x6b
  802ae5:	68 8f 4a 80 00       	push   $0x804a8f
  802aea:	e8 04 e3 ff ff       	call   800df3 <_panic>
  802aef:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	89 10                	mov    %edx,(%eax)
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	8b 00                	mov    (%eax),%eax
  802aff:	85 c0                	test   %eax,%eax
  802b01:	74 0d                	je     802b10 <insert_sorted_allocList+0x83>
  802b03:	a1 40 50 80 00       	mov    0x805040,%eax
  802b08:	8b 55 08             	mov    0x8(%ebp),%edx
  802b0b:	89 50 04             	mov    %edx,0x4(%eax)
  802b0e:	eb 08                	jmp    802b18 <insert_sorted_allocList+0x8b>
  802b10:	8b 45 08             	mov    0x8(%ebp),%eax
  802b13:	a3 44 50 80 00       	mov    %eax,0x805044
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	a3 40 50 80 00       	mov    %eax,0x805040
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b2f:	40                   	inc    %eax
  802b30:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b35:	e9 dc 01 00 00       	jmp    802d16 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3d:	8b 50 08             	mov    0x8(%eax),%edx
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	8b 40 08             	mov    0x8(%eax),%eax
  802b46:	39 c2                	cmp    %eax,%edx
  802b48:	77 6c                	ja     802bb6 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802b4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4e:	74 06                	je     802b56 <insert_sorted_allocList+0xc9>
  802b50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b54:	75 14                	jne    802b6a <insert_sorted_allocList+0xdd>
  802b56:	83 ec 04             	sub    $0x4,%esp
  802b59:	68 a8 4a 80 00       	push   $0x804aa8
  802b5e:	6a 6f                	push   $0x6f
  802b60:	68 8f 4a 80 00       	push   $0x804a8f
  802b65:	e8 89 e2 ff ff       	call   800df3 <_panic>
  802b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6d:	8b 50 04             	mov    0x4(%eax),%edx
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	89 50 04             	mov    %edx,0x4(%eax)
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b7c:	89 10                	mov    %edx,(%eax)
  802b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b81:	8b 40 04             	mov    0x4(%eax),%eax
  802b84:	85 c0                	test   %eax,%eax
  802b86:	74 0d                	je     802b95 <insert_sorted_allocList+0x108>
  802b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8b:	8b 40 04             	mov    0x4(%eax),%eax
  802b8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b91:	89 10                	mov    %edx,(%eax)
  802b93:	eb 08                	jmp    802b9d <insert_sorted_allocList+0x110>
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	a3 40 50 80 00       	mov    %eax,0x805040
  802b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba3:	89 50 04             	mov    %edx,0x4(%eax)
  802ba6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bab:	40                   	inc    %eax
  802bac:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802bb1:	e9 60 01 00 00       	jmp    802d16 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbf:	8b 40 08             	mov    0x8(%eax),%eax
  802bc2:	39 c2                	cmp    %eax,%edx
  802bc4:	0f 82 4c 01 00 00    	jb     802d16 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802bca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bce:	75 14                	jne    802be4 <insert_sorted_allocList+0x157>
  802bd0:	83 ec 04             	sub    $0x4,%esp
  802bd3:	68 e0 4a 80 00       	push   $0x804ae0
  802bd8:	6a 73                	push   $0x73
  802bda:	68 8f 4a 80 00       	push   $0x804a8f
  802bdf:	e8 0f e2 ff ff       	call   800df3 <_panic>
  802be4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	89 50 04             	mov    %edx,0x4(%eax)
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	8b 40 04             	mov    0x4(%eax),%eax
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	74 0c                	je     802c06 <insert_sorted_allocList+0x179>
  802bfa:	a1 44 50 80 00       	mov    0x805044,%eax
  802bff:	8b 55 08             	mov    0x8(%ebp),%edx
  802c02:	89 10                	mov    %edx,(%eax)
  802c04:	eb 08                	jmp    802c0e <insert_sorted_allocList+0x181>
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	a3 40 50 80 00       	mov    %eax,0x805040
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	a3 44 50 80 00       	mov    %eax,0x805044
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c24:	40                   	inc    %eax
  802c25:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c2a:	e9 e7 00 00 00       	jmp    802d16 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802c35:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802c3c:	a1 40 50 80 00       	mov    0x805040,%eax
  802c41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c44:	e9 9d 00 00 00       	jmp    802ce6 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 00                	mov    (%eax),%eax
  802c4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	8b 50 08             	mov    0x8(%eax),%edx
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 40 08             	mov    0x8(%eax),%eax
  802c5d:	39 c2                	cmp    %eax,%edx
  802c5f:	76 7d                	jbe    802cde <insert_sorted_allocList+0x251>
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	8b 50 08             	mov    0x8(%eax),%edx
  802c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c6a:	8b 40 08             	mov    0x8(%eax),%eax
  802c6d:	39 c2                	cmp    %eax,%edx
  802c6f:	73 6d                	jae    802cde <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802c71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c75:	74 06                	je     802c7d <insert_sorted_allocList+0x1f0>
  802c77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c7b:	75 14                	jne    802c91 <insert_sorted_allocList+0x204>
  802c7d:	83 ec 04             	sub    $0x4,%esp
  802c80:	68 04 4b 80 00       	push   $0x804b04
  802c85:	6a 7f                	push   $0x7f
  802c87:	68 8f 4a 80 00       	push   $0x804a8f
  802c8c:	e8 62 e1 ff ff       	call   800df3 <_panic>
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 10                	mov    (%eax),%edx
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	89 10                	mov    %edx,(%eax)
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	8b 00                	mov    (%eax),%eax
  802ca0:	85 c0                	test   %eax,%eax
  802ca2:	74 0b                	je     802caf <insert_sorted_allocList+0x222>
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 00                	mov    (%eax),%eax
  802ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cac:	89 50 04             	mov    %edx,0x4(%eax)
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb5:	89 10                	mov    %edx,(%eax)
  802cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbd:	89 50 04             	mov    %edx,0x4(%eax)
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	8b 00                	mov    (%eax),%eax
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	75 08                	jne    802cd1 <insert_sorted_allocList+0x244>
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	a3 44 50 80 00       	mov    %eax,0x805044
  802cd1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cd6:	40                   	inc    %eax
  802cd7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802cdc:	eb 39                	jmp    802d17 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802cde:	a1 48 50 80 00       	mov    0x805048,%eax
  802ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cea:	74 07                	je     802cf3 <insert_sorted_allocList+0x266>
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	eb 05                	jmp    802cf8 <insert_sorted_allocList+0x26b>
  802cf3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf8:	a3 48 50 80 00       	mov    %eax,0x805048
  802cfd:	a1 48 50 80 00       	mov    0x805048,%eax
  802d02:	85 c0                	test   %eax,%eax
  802d04:	0f 85 3f ff ff ff    	jne    802c49 <insert_sorted_allocList+0x1bc>
  802d0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0e:	0f 85 35 ff ff ff    	jne    802c49 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802d14:	eb 01                	jmp    802d17 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d16:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802d17:	90                   	nop
  802d18:	c9                   	leave  
  802d19:	c3                   	ret    

00802d1a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d1a:	55                   	push   %ebp
  802d1b:	89 e5                	mov    %esp,%ebp
  802d1d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802d20:	a1 38 51 80 00       	mov    0x805138,%eax
  802d25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d28:	e9 85 01 00 00       	jmp    802eb2 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 40 0c             	mov    0xc(%eax),%eax
  802d33:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d36:	0f 82 6e 01 00 00    	jb     802eaa <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d42:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d45:	0f 85 8a 00 00 00    	jne    802dd5 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802d4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4f:	75 17                	jne    802d68 <alloc_block_FF+0x4e>
  802d51:	83 ec 04             	sub    $0x4,%esp
  802d54:	68 38 4b 80 00       	push   $0x804b38
  802d59:	68 93 00 00 00       	push   $0x93
  802d5e:	68 8f 4a 80 00       	push   $0x804a8f
  802d63:	e8 8b e0 ff ff       	call   800df3 <_panic>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	85 c0                	test   %eax,%eax
  802d6f:	74 10                	je     802d81 <alloc_block_FF+0x67>
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 00                	mov    (%eax),%eax
  802d76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d79:	8b 52 04             	mov    0x4(%edx),%edx
  802d7c:	89 50 04             	mov    %edx,0x4(%eax)
  802d7f:	eb 0b                	jmp    802d8c <alloc_block_FF+0x72>
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 40 04             	mov    0x4(%eax),%eax
  802d87:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 40 04             	mov    0x4(%eax),%eax
  802d92:	85 c0                	test   %eax,%eax
  802d94:	74 0f                	je     802da5 <alloc_block_FF+0x8b>
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 40 04             	mov    0x4(%eax),%eax
  802d9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d9f:	8b 12                	mov    (%edx),%edx
  802da1:	89 10                	mov    %edx,(%eax)
  802da3:	eb 0a                	jmp    802daf <alloc_block_FF+0x95>
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	a3 38 51 80 00       	mov    %eax,0x805138
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc2:	a1 44 51 80 00       	mov    0x805144,%eax
  802dc7:	48                   	dec    %eax
  802dc8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	e9 10 01 00 00       	jmp    802ee5 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dde:	0f 86 c6 00 00 00    	jbe    802eaa <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802de4:	a1 48 51 80 00       	mov    0x805148,%eax
  802de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 50 08             	mov    0x8(%eax),%edx
  802df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df5:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfe:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e05:	75 17                	jne    802e1e <alloc_block_FF+0x104>
  802e07:	83 ec 04             	sub    $0x4,%esp
  802e0a:	68 38 4b 80 00       	push   $0x804b38
  802e0f:	68 9b 00 00 00       	push   $0x9b
  802e14:	68 8f 4a 80 00       	push   $0x804a8f
  802e19:	e8 d5 df ff ff       	call   800df3 <_panic>
  802e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	85 c0                	test   %eax,%eax
  802e25:	74 10                	je     802e37 <alloc_block_FF+0x11d>
  802e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2a:	8b 00                	mov    (%eax),%eax
  802e2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e2f:	8b 52 04             	mov    0x4(%edx),%edx
  802e32:	89 50 04             	mov    %edx,0x4(%eax)
  802e35:	eb 0b                	jmp    802e42 <alloc_block_FF+0x128>
  802e37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3a:	8b 40 04             	mov    0x4(%eax),%eax
  802e3d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e45:	8b 40 04             	mov    0x4(%eax),%eax
  802e48:	85 c0                	test   %eax,%eax
  802e4a:	74 0f                	je     802e5b <alloc_block_FF+0x141>
  802e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4f:	8b 40 04             	mov    0x4(%eax),%eax
  802e52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e55:	8b 12                	mov    (%edx),%edx
  802e57:	89 10                	mov    %edx,(%eax)
  802e59:	eb 0a                	jmp    802e65 <alloc_block_FF+0x14b>
  802e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5e:	8b 00                	mov    (%eax),%eax
  802e60:	a3 48 51 80 00       	mov    %eax,0x805148
  802e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e78:	a1 54 51 80 00       	mov    0x805154,%eax
  802e7d:	48                   	dec    %eax
  802e7e:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 50 08             	mov    0x8(%eax),%edx
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	01 c2                	add    %eax,%edx
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9a:	2b 45 08             	sub    0x8(%ebp),%eax
  802e9d:	89 c2                	mov    %eax,%edx
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea8:	eb 3b                	jmp    802ee5 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802eaa:	a1 40 51 80 00       	mov    0x805140,%eax
  802eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb6:	74 07                	je     802ebf <alloc_block_FF+0x1a5>
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 00                	mov    (%eax),%eax
  802ebd:	eb 05                	jmp    802ec4 <alloc_block_FF+0x1aa>
  802ebf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ec4:	a3 40 51 80 00       	mov    %eax,0x805140
  802ec9:	a1 40 51 80 00       	mov    0x805140,%eax
  802ece:	85 c0                	test   %eax,%eax
  802ed0:	0f 85 57 fe ff ff    	jne    802d2d <alloc_block_FF+0x13>
  802ed6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eda:	0f 85 4d fe ff ff    	jne    802d2d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802ee0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ee5:	c9                   	leave  
  802ee6:	c3                   	ret    

00802ee7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ee7:	55                   	push   %ebp
  802ee8:	89 e5                	mov    %esp,%ebp
  802eea:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802eed:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802ef4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802efc:	e9 df 00 00 00       	jmp    802fe0 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 40 0c             	mov    0xc(%eax),%eax
  802f07:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f0a:	0f 82 c8 00 00 00    	jb     802fd8 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	8b 40 0c             	mov    0xc(%eax),%eax
  802f16:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f19:	0f 85 8a 00 00 00    	jne    802fa9 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802f1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f23:	75 17                	jne    802f3c <alloc_block_BF+0x55>
  802f25:	83 ec 04             	sub    $0x4,%esp
  802f28:	68 38 4b 80 00       	push   $0x804b38
  802f2d:	68 b7 00 00 00       	push   $0xb7
  802f32:	68 8f 4a 80 00       	push   $0x804a8f
  802f37:	e8 b7 de ff ff       	call   800df3 <_panic>
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	8b 00                	mov    (%eax),%eax
  802f41:	85 c0                	test   %eax,%eax
  802f43:	74 10                	je     802f55 <alloc_block_BF+0x6e>
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4d:	8b 52 04             	mov    0x4(%edx),%edx
  802f50:	89 50 04             	mov    %edx,0x4(%eax)
  802f53:	eb 0b                	jmp    802f60 <alloc_block_BF+0x79>
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	8b 40 04             	mov    0x4(%eax),%eax
  802f5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 40 04             	mov    0x4(%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 0f                	je     802f79 <alloc_block_BF+0x92>
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	8b 40 04             	mov    0x4(%eax),%eax
  802f70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f73:	8b 12                	mov    (%edx),%edx
  802f75:	89 10                	mov    %edx,(%eax)
  802f77:	eb 0a                	jmp    802f83 <alloc_block_BF+0x9c>
  802f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	a3 38 51 80 00       	mov    %eax,0x805138
  802f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f96:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9b:	48                   	dec    %eax
  802f9c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	e9 4d 01 00 00       	jmp    8030f6 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	8b 40 0c             	mov    0xc(%eax),%eax
  802faf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fb2:	76 24                	jbe    802fd8 <alloc_block_BF+0xf1>
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802fbd:	73 19                	jae    802fd8 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802fbf:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd2:	8b 40 08             	mov    0x8(%eax),%eax
  802fd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802fd8:	a1 40 51 80 00       	mov    0x805140,%eax
  802fdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe4:	74 07                	je     802fed <alloc_block_BF+0x106>
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	eb 05                	jmp    802ff2 <alloc_block_BF+0x10b>
  802fed:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff2:	a3 40 51 80 00       	mov    %eax,0x805140
  802ff7:	a1 40 51 80 00       	mov    0x805140,%eax
  802ffc:	85 c0                	test   %eax,%eax
  802ffe:	0f 85 fd fe ff ff    	jne    802f01 <alloc_block_BF+0x1a>
  803004:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803008:	0f 85 f3 fe ff ff    	jne    802f01 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80300e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803012:	0f 84 d9 00 00 00    	je     8030f1 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803018:	a1 48 51 80 00       	mov    0x805148,%eax
  80301d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  803020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803023:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803026:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  803029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302c:	8b 55 08             	mov    0x8(%ebp),%edx
  80302f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  803032:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803036:	75 17                	jne    80304f <alloc_block_BF+0x168>
  803038:	83 ec 04             	sub    $0x4,%esp
  80303b:	68 38 4b 80 00       	push   $0x804b38
  803040:	68 c7 00 00 00       	push   $0xc7
  803045:	68 8f 4a 80 00       	push   $0x804a8f
  80304a:	e8 a4 dd ff ff       	call   800df3 <_panic>
  80304f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803052:	8b 00                	mov    (%eax),%eax
  803054:	85 c0                	test   %eax,%eax
  803056:	74 10                	je     803068 <alloc_block_BF+0x181>
  803058:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803060:	8b 52 04             	mov    0x4(%edx),%edx
  803063:	89 50 04             	mov    %edx,0x4(%eax)
  803066:	eb 0b                	jmp    803073 <alloc_block_BF+0x18c>
  803068:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306b:	8b 40 04             	mov    0x4(%eax),%eax
  80306e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803076:	8b 40 04             	mov    0x4(%eax),%eax
  803079:	85 c0                	test   %eax,%eax
  80307b:	74 0f                	je     80308c <alloc_block_BF+0x1a5>
  80307d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803080:	8b 40 04             	mov    0x4(%eax),%eax
  803083:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803086:	8b 12                	mov    (%edx),%edx
  803088:	89 10                	mov    %edx,(%eax)
  80308a:	eb 0a                	jmp    803096 <alloc_block_BF+0x1af>
  80308c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	a3 48 51 80 00       	mov    %eax,0x805148
  803096:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803099:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a9:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ae:	48                   	dec    %eax
  8030af:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8030b4:	83 ec 08             	sub    $0x8,%esp
  8030b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8030ba:	68 38 51 80 00       	push   $0x805138
  8030bf:	e8 71 f9 ff ff       	call   802a35 <find_block>
  8030c4:	83 c4 10             	add    $0x10,%esp
  8030c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8030ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030cd:	8b 50 08             	mov    0x8(%eax),%edx
  8030d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d3:	01 c2                	add    %eax,%edx
  8030d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030d8:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8030db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030de:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e1:	2b 45 08             	sub    0x8(%ebp),%eax
  8030e4:	89 c2                	mov    %eax,%edx
  8030e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e9:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8030ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ef:	eb 05                	jmp    8030f6 <alloc_block_BF+0x20f>
	}
	return NULL;
  8030f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030f6:	c9                   	leave  
  8030f7:	c3                   	ret    

008030f8 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8030f8:	55                   	push   %ebp
  8030f9:	89 e5                	mov    %esp,%ebp
  8030fb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8030fe:	a1 28 50 80 00       	mov    0x805028,%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	0f 85 de 01 00 00    	jne    8032e9 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80310b:	a1 38 51 80 00       	mov    0x805138,%eax
  803110:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803113:	e9 9e 01 00 00       	jmp    8032b6 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311b:	8b 40 0c             	mov    0xc(%eax),%eax
  80311e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803121:	0f 82 87 01 00 00    	jb     8032ae <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	8b 40 0c             	mov    0xc(%eax),%eax
  80312d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803130:	0f 85 95 00 00 00    	jne    8031cb <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  803136:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313a:	75 17                	jne    803153 <alloc_block_NF+0x5b>
  80313c:	83 ec 04             	sub    $0x4,%esp
  80313f:	68 38 4b 80 00       	push   $0x804b38
  803144:	68 e0 00 00 00       	push   $0xe0
  803149:	68 8f 4a 80 00       	push   $0x804a8f
  80314e:	e8 a0 dc ff ff       	call   800df3 <_panic>
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	8b 00                	mov    (%eax),%eax
  803158:	85 c0                	test   %eax,%eax
  80315a:	74 10                	je     80316c <alloc_block_NF+0x74>
  80315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803164:	8b 52 04             	mov    0x4(%edx),%edx
  803167:	89 50 04             	mov    %edx,0x4(%eax)
  80316a:	eb 0b                	jmp    803177 <alloc_block_NF+0x7f>
  80316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316f:	8b 40 04             	mov    0x4(%eax),%eax
  803172:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	8b 40 04             	mov    0x4(%eax),%eax
  80317d:	85 c0                	test   %eax,%eax
  80317f:	74 0f                	je     803190 <alloc_block_NF+0x98>
  803181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803184:	8b 40 04             	mov    0x4(%eax),%eax
  803187:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80318a:	8b 12                	mov    (%edx),%edx
  80318c:	89 10                	mov    %edx,(%eax)
  80318e:	eb 0a                	jmp    80319a <alloc_block_NF+0xa2>
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	8b 00                	mov    (%eax),%eax
  803195:	a3 38 51 80 00       	mov    %eax,0x805138
  80319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b2:	48                   	dec    %eax
  8031b3:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8031b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bb:	8b 40 08             	mov    0x8(%eax),%eax
  8031be:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	e9 f8 04 00 00       	jmp    8036c3 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8031cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d4:	0f 86 d4 00 00 00    	jbe    8032ae <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8031da:	a1 48 51 80 00       	mov    0x805148,%eax
  8031df:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8031e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e5:	8b 50 08             	mov    0x8(%eax),%edx
  8031e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031eb:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8031ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f4:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8031f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031fb:	75 17                	jne    803214 <alloc_block_NF+0x11c>
  8031fd:	83 ec 04             	sub    $0x4,%esp
  803200:	68 38 4b 80 00       	push   $0x804b38
  803205:	68 e9 00 00 00       	push   $0xe9
  80320a:	68 8f 4a 80 00       	push   $0x804a8f
  80320f:	e8 df db ff ff       	call   800df3 <_panic>
  803214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803217:	8b 00                	mov    (%eax),%eax
  803219:	85 c0                	test   %eax,%eax
  80321b:	74 10                	je     80322d <alloc_block_NF+0x135>
  80321d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803220:	8b 00                	mov    (%eax),%eax
  803222:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803225:	8b 52 04             	mov    0x4(%edx),%edx
  803228:	89 50 04             	mov    %edx,0x4(%eax)
  80322b:	eb 0b                	jmp    803238 <alloc_block_NF+0x140>
  80322d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803230:	8b 40 04             	mov    0x4(%eax),%eax
  803233:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323b:	8b 40 04             	mov    0x4(%eax),%eax
  80323e:	85 c0                	test   %eax,%eax
  803240:	74 0f                	je     803251 <alloc_block_NF+0x159>
  803242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803245:	8b 40 04             	mov    0x4(%eax),%eax
  803248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80324b:	8b 12                	mov    (%edx),%edx
  80324d:	89 10                	mov    %edx,(%eax)
  80324f:	eb 0a                	jmp    80325b <alloc_block_NF+0x163>
  803251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803254:	8b 00                	mov    (%eax),%eax
  803256:	a3 48 51 80 00       	mov    %eax,0x805148
  80325b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803267:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326e:	a1 54 51 80 00       	mov    0x805154,%eax
  803273:	48                   	dec    %eax
  803274:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327c:	8b 40 08             	mov    0x8(%eax),%eax
  80327f:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803287:	8b 50 08             	mov    0x8(%eax),%edx
  80328a:	8b 45 08             	mov    0x8(%ebp),%eax
  80328d:	01 c2                	add    %eax,%edx
  80328f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803292:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803298:	8b 40 0c             	mov    0xc(%eax),%eax
  80329b:	2b 45 08             	sub    0x8(%ebp),%eax
  80329e:	89 c2                	mov    %eax,%edx
  8032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a3:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8032a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a9:	e9 15 04 00 00       	jmp    8036c3 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8032ae:	a1 40 51 80 00       	mov    0x805140,%eax
  8032b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ba:	74 07                	je     8032c3 <alloc_block_NF+0x1cb>
  8032bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bf:	8b 00                	mov    (%eax),%eax
  8032c1:	eb 05                	jmp    8032c8 <alloc_block_NF+0x1d0>
  8032c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c8:	a3 40 51 80 00       	mov    %eax,0x805140
  8032cd:	a1 40 51 80 00       	mov    0x805140,%eax
  8032d2:	85 c0                	test   %eax,%eax
  8032d4:	0f 85 3e fe ff ff    	jne    803118 <alloc_block_NF+0x20>
  8032da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032de:	0f 85 34 fe ff ff    	jne    803118 <alloc_block_NF+0x20>
  8032e4:	e9 d5 03 00 00       	jmp    8036be <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032e9:	a1 38 51 80 00       	mov    0x805138,%eax
  8032ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f1:	e9 b1 01 00 00       	jmp    8034a7 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8032f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f9:	8b 50 08             	mov    0x8(%eax),%edx
  8032fc:	a1 28 50 80 00       	mov    0x805028,%eax
  803301:	39 c2                	cmp    %eax,%edx
  803303:	0f 82 96 01 00 00    	jb     80349f <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330c:	8b 40 0c             	mov    0xc(%eax),%eax
  80330f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803312:	0f 82 87 01 00 00    	jb     80349f <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331b:	8b 40 0c             	mov    0xc(%eax),%eax
  80331e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803321:	0f 85 95 00 00 00    	jne    8033bc <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803327:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80332b:	75 17                	jne    803344 <alloc_block_NF+0x24c>
  80332d:	83 ec 04             	sub    $0x4,%esp
  803330:	68 38 4b 80 00       	push   $0x804b38
  803335:	68 fc 00 00 00       	push   $0xfc
  80333a:	68 8f 4a 80 00       	push   $0x804a8f
  80333f:	e8 af da ff ff       	call   800df3 <_panic>
  803344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803347:	8b 00                	mov    (%eax),%eax
  803349:	85 c0                	test   %eax,%eax
  80334b:	74 10                	je     80335d <alloc_block_NF+0x265>
  80334d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803350:	8b 00                	mov    (%eax),%eax
  803352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803355:	8b 52 04             	mov    0x4(%edx),%edx
  803358:	89 50 04             	mov    %edx,0x4(%eax)
  80335b:	eb 0b                	jmp    803368 <alloc_block_NF+0x270>
  80335d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803360:	8b 40 04             	mov    0x4(%eax),%eax
  803363:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336b:	8b 40 04             	mov    0x4(%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	74 0f                	je     803381 <alloc_block_NF+0x289>
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	8b 40 04             	mov    0x4(%eax),%eax
  803378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80337b:	8b 12                	mov    (%edx),%edx
  80337d:	89 10                	mov    %edx,(%eax)
  80337f:	eb 0a                	jmp    80338b <alloc_block_NF+0x293>
  803381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803384:	8b 00                	mov    (%eax),%eax
  803386:	a3 38 51 80 00       	mov    %eax,0x805138
  80338b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339e:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a3:	48                   	dec    %eax
  8033a4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	8b 40 08             	mov    0x8(%eax),%eax
  8033af:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8033b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b7:	e9 07 03 00 00       	jmp    8036c3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033c5:	0f 86 d4 00 00 00    	jbe    80349f <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8033cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8033d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8033d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d6:	8b 50 08             	mov    0x8(%eax),%edx
  8033d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dc:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8033df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8033e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033ec:	75 17                	jne    803405 <alloc_block_NF+0x30d>
  8033ee:	83 ec 04             	sub    $0x4,%esp
  8033f1:	68 38 4b 80 00       	push   $0x804b38
  8033f6:	68 04 01 00 00       	push   $0x104
  8033fb:	68 8f 4a 80 00       	push   $0x804a8f
  803400:	e8 ee d9 ff ff       	call   800df3 <_panic>
  803405:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803408:	8b 00                	mov    (%eax),%eax
  80340a:	85 c0                	test   %eax,%eax
  80340c:	74 10                	je     80341e <alloc_block_NF+0x326>
  80340e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803411:	8b 00                	mov    (%eax),%eax
  803413:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803416:	8b 52 04             	mov    0x4(%edx),%edx
  803419:	89 50 04             	mov    %edx,0x4(%eax)
  80341c:	eb 0b                	jmp    803429 <alloc_block_NF+0x331>
  80341e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803421:	8b 40 04             	mov    0x4(%eax),%eax
  803424:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803429:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342c:	8b 40 04             	mov    0x4(%eax),%eax
  80342f:	85 c0                	test   %eax,%eax
  803431:	74 0f                	je     803442 <alloc_block_NF+0x34a>
  803433:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803436:	8b 40 04             	mov    0x4(%eax),%eax
  803439:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80343c:	8b 12                	mov    (%edx),%edx
  80343e:	89 10                	mov    %edx,(%eax)
  803440:	eb 0a                	jmp    80344c <alloc_block_NF+0x354>
  803442:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803445:	8b 00                	mov    (%eax),%eax
  803447:	a3 48 51 80 00       	mov    %eax,0x805148
  80344c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803458:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80345f:	a1 54 51 80 00       	mov    0x805154,%eax
  803464:	48                   	dec    %eax
  803465:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80346a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346d:	8b 40 08             	mov    0x8(%eax),%eax
  803470:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803478:	8b 50 08             	mov    0x8(%eax),%edx
  80347b:	8b 45 08             	mov    0x8(%ebp),%eax
  80347e:	01 c2                	add    %eax,%edx
  803480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803483:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	8b 40 0c             	mov    0xc(%eax),%eax
  80348c:	2b 45 08             	sub    0x8(%ebp),%eax
  80348f:	89 c2                	mov    %eax,%edx
  803491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803494:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803497:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349a:	e9 24 02 00 00       	jmp    8036c3 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80349f:	a1 40 51 80 00       	mov    0x805140,%eax
  8034a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ab:	74 07                	je     8034b4 <alloc_block_NF+0x3bc>
  8034ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b0:	8b 00                	mov    (%eax),%eax
  8034b2:	eb 05                	jmp    8034b9 <alloc_block_NF+0x3c1>
  8034b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b9:	a3 40 51 80 00       	mov    %eax,0x805140
  8034be:	a1 40 51 80 00       	mov    0x805140,%eax
  8034c3:	85 c0                	test   %eax,%eax
  8034c5:	0f 85 2b fe ff ff    	jne    8032f6 <alloc_block_NF+0x1fe>
  8034cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034cf:	0f 85 21 fe ff ff    	jne    8032f6 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8034d5:	a1 38 51 80 00       	mov    0x805138,%eax
  8034da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034dd:	e9 ae 01 00 00       	jmp    803690 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8034e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e5:	8b 50 08             	mov    0x8(%eax),%edx
  8034e8:	a1 28 50 80 00       	mov    0x805028,%eax
  8034ed:	39 c2                	cmp    %eax,%edx
  8034ef:	0f 83 93 01 00 00    	jae    803688 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8034f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8034fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034fe:	0f 82 84 01 00 00    	jb     803688 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803507:	8b 40 0c             	mov    0xc(%eax),%eax
  80350a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80350d:	0f 85 95 00 00 00    	jne    8035a8 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803517:	75 17                	jne    803530 <alloc_block_NF+0x438>
  803519:	83 ec 04             	sub    $0x4,%esp
  80351c:	68 38 4b 80 00       	push   $0x804b38
  803521:	68 14 01 00 00       	push   $0x114
  803526:	68 8f 4a 80 00       	push   $0x804a8f
  80352b:	e8 c3 d8 ff ff       	call   800df3 <_panic>
  803530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803533:	8b 00                	mov    (%eax),%eax
  803535:	85 c0                	test   %eax,%eax
  803537:	74 10                	je     803549 <alloc_block_NF+0x451>
  803539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353c:	8b 00                	mov    (%eax),%eax
  80353e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803541:	8b 52 04             	mov    0x4(%edx),%edx
  803544:	89 50 04             	mov    %edx,0x4(%eax)
  803547:	eb 0b                	jmp    803554 <alloc_block_NF+0x45c>
  803549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354c:	8b 40 04             	mov    0x4(%eax),%eax
  80354f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803557:	8b 40 04             	mov    0x4(%eax),%eax
  80355a:	85 c0                	test   %eax,%eax
  80355c:	74 0f                	je     80356d <alloc_block_NF+0x475>
  80355e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803561:	8b 40 04             	mov    0x4(%eax),%eax
  803564:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803567:	8b 12                	mov    (%edx),%edx
  803569:	89 10                	mov    %edx,(%eax)
  80356b:	eb 0a                	jmp    803577 <alloc_block_NF+0x47f>
  80356d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803570:	8b 00                	mov    (%eax),%eax
  803572:	a3 38 51 80 00       	mov    %eax,0x805138
  803577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803583:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358a:	a1 44 51 80 00       	mov    0x805144,%eax
  80358f:	48                   	dec    %eax
  803590:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803598:	8b 40 08             	mov    0x8(%eax),%eax
  80359b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8035a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a3:	e9 1b 01 00 00       	jmp    8036c3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8035a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035b1:	0f 86 d1 00 00 00    	jbe    803688 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8035b7:	a1 48 51 80 00       	mov    0x805148,%eax
  8035bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8035bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c2:	8b 50 08             	mov    0x8(%eax),%edx
  8035c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035c8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8035cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8035d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035d8:	75 17                	jne    8035f1 <alloc_block_NF+0x4f9>
  8035da:	83 ec 04             	sub    $0x4,%esp
  8035dd:	68 38 4b 80 00       	push   $0x804b38
  8035e2:	68 1c 01 00 00       	push   $0x11c
  8035e7:	68 8f 4a 80 00       	push   $0x804a8f
  8035ec:	e8 02 d8 ff ff       	call   800df3 <_panic>
  8035f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f4:	8b 00                	mov    (%eax),%eax
  8035f6:	85 c0                	test   %eax,%eax
  8035f8:	74 10                	je     80360a <alloc_block_NF+0x512>
  8035fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fd:	8b 00                	mov    (%eax),%eax
  8035ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803602:	8b 52 04             	mov    0x4(%edx),%edx
  803605:	89 50 04             	mov    %edx,0x4(%eax)
  803608:	eb 0b                	jmp    803615 <alloc_block_NF+0x51d>
  80360a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80360d:	8b 40 04             	mov    0x4(%eax),%eax
  803610:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803618:	8b 40 04             	mov    0x4(%eax),%eax
  80361b:	85 c0                	test   %eax,%eax
  80361d:	74 0f                	je     80362e <alloc_block_NF+0x536>
  80361f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803622:	8b 40 04             	mov    0x4(%eax),%eax
  803625:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803628:	8b 12                	mov    (%edx),%edx
  80362a:	89 10                	mov    %edx,(%eax)
  80362c:	eb 0a                	jmp    803638 <alloc_block_NF+0x540>
  80362e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803631:	8b 00                	mov    (%eax),%eax
  803633:	a3 48 51 80 00       	mov    %eax,0x805148
  803638:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80363b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803644:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80364b:	a1 54 51 80 00       	mov    0x805154,%eax
  803650:	48                   	dec    %eax
  803651:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803659:	8b 40 08             	mov    0x8(%eax),%eax
  80365c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803664:	8b 50 08             	mov    0x8(%eax),%edx
  803667:	8b 45 08             	mov    0x8(%ebp),%eax
  80366a:	01 c2                	add    %eax,%edx
  80366c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803675:	8b 40 0c             	mov    0xc(%eax),%eax
  803678:	2b 45 08             	sub    0x8(%ebp),%eax
  80367b:	89 c2                	mov    %eax,%edx
  80367d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803680:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803683:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803686:	eb 3b                	jmp    8036c3 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803688:	a1 40 51 80 00       	mov    0x805140,%eax
  80368d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803690:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803694:	74 07                	je     80369d <alloc_block_NF+0x5a5>
  803696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803699:	8b 00                	mov    (%eax),%eax
  80369b:	eb 05                	jmp    8036a2 <alloc_block_NF+0x5aa>
  80369d:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a2:	a3 40 51 80 00       	mov    %eax,0x805140
  8036a7:	a1 40 51 80 00       	mov    0x805140,%eax
  8036ac:	85 c0                	test   %eax,%eax
  8036ae:	0f 85 2e fe ff ff    	jne    8034e2 <alloc_block_NF+0x3ea>
  8036b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b8:	0f 85 24 fe ff ff    	jne    8034e2 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8036be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8036c3:	c9                   	leave  
  8036c4:	c3                   	ret    

008036c5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8036c5:	55                   	push   %ebp
  8036c6:	89 e5                	mov    %esp,%ebp
  8036c8:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8036cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8036d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8036d3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8036d8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8036db:	a1 38 51 80 00       	mov    0x805138,%eax
  8036e0:	85 c0                	test   %eax,%eax
  8036e2:	74 14                	je     8036f8 <insert_sorted_with_merge_freeList+0x33>
  8036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e7:	8b 50 08             	mov    0x8(%eax),%edx
  8036ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ed:	8b 40 08             	mov    0x8(%eax),%eax
  8036f0:	39 c2                	cmp    %eax,%edx
  8036f2:	0f 87 9b 01 00 00    	ja     803893 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8036f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036fc:	75 17                	jne    803715 <insert_sorted_with_merge_freeList+0x50>
  8036fe:	83 ec 04             	sub    $0x4,%esp
  803701:	68 6c 4a 80 00       	push   $0x804a6c
  803706:	68 38 01 00 00       	push   $0x138
  80370b:	68 8f 4a 80 00       	push   $0x804a8f
  803710:	e8 de d6 ff ff       	call   800df3 <_panic>
  803715:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	89 10                	mov    %edx,(%eax)
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	8b 00                	mov    (%eax),%eax
  803725:	85 c0                	test   %eax,%eax
  803727:	74 0d                	je     803736 <insert_sorted_with_merge_freeList+0x71>
  803729:	a1 38 51 80 00       	mov    0x805138,%eax
  80372e:	8b 55 08             	mov    0x8(%ebp),%edx
  803731:	89 50 04             	mov    %edx,0x4(%eax)
  803734:	eb 08                	jmp    80373e <insert_sorted_with_merge_freeList+0x79>
  803736:	8b 45 08             	mov    0x8(%ebp),%eax
  803739:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	a3 38 51 80 00       	mov    %eax,0x805138
  803746:	8b 45 08             	mov    0x8(%ebp),%eax
  803749:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803750:	a1 44 51 80 00       	mov    0x805144,%eax
  803755:	40                   	inc    %eax
  803756:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80375b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80375f:	0f 84 a8 06 00 00    	je     803e0d <insert_sorted_with_merge_freeList+0x748>
  803765:	8b 45 08             	mov    0x8(%ebp),%eax
  803768:	8b 50 08             	mov    0x8(%eax),%edx
  80376b:	8b 45 08             	mov    0x8(%ebp),%eax
  80376e:	8b 40 0c             	mov    0xc(%eax),%eax
  803771:	01 c2                	add    %eax,%edx
  803773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803776:	8b 40 08             	mov    0x8(%eax),%eax
  803779:	39 c2                	cmp    %eax,%edx
  80377b:	0f 85 8c 06 00 00    	jne    803e0d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803781:	8b 45 08             	mov    0x8(%ebp),%eax
  803784:	8b 50 0c             	mov    0xc(%eax),%edx
  803787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378a:	8b 40 0c             	mov    0xc(%eax),%eax
  80378d:	01 c2                	add    %eax,%edx
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803795:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803799:	75 17                	jne    8037b2 <insert_sorted_with_merge_freeList+0xed>
  80379b:	83 ec 04             	sub    $0x4,%esp
  80379e:	68 38 4b 80 00       	push   $0x804b38
  8037a3:	68 3c 01 00 00       	push   $0x13c
  8037a8:	68 8f 4a 80 00       	push   $0x804a8f
  8037ad:	e8 41 d6 ff ff       	call   800df3 <_panic>
  8037b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b5:	8b 00                	mov    (%eax),%eax
  8037b7:	85 c0                	test   %eax,%eax
  8037b9:	74 10                	je     8037cb <insert_sorted_with_merge_freeList+0x106>
  8037bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037be:	8b 00                	mov    (%eax),%eax
  8037c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037c3:	8b 52 04             	mov    0x4(%edx),%edx
  8037c6:	89 50 04             	mov    %edx,0x4(%eax)
  8037c9:	eb 0b                	jmp    8037d6 <insert_sorted_with_merge_freeList+0x111>
  8037cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ce:	8b 40 04             	mov    0x4(%eax),%eax
  8037d1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d9:	8b 40 04             	mov    0x4(%eax),%eax
  8037dc:	85 c0                	test   %eax,%eax
  8037de:	74 0f                	je     8037ef <insert_sorted_with_merge_freeList+0x12a>
  8037e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e3:	8b 40 04             	mov    0x4(%eax),%eax
  8037e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037e9:	8b 12                	mov    (%edx),%edx
  8037eb:	89 10                	mov    %edx,(%eax)
  8037ed:	eb 0a                	jmp    8037f9 <insert_sorted_with_merge_freeList+0x134>
  8037ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f2:	8b 00                	mov    (%eax),%eax
  8037f4:	a3 38 51 80 00       	mov    %eax,0x805138
  8037f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803805:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80380c:	a1 44 51 80 00       	mov    0x805144,%eax
  803811:	48                   	dec    %eax
  803812:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80381a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803824:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  80382b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80382f:	75 17                	jne    803848 <insert_sorted_with_merge_freeList+0x183>
  803831:	83 ec 04             	sub    $0x4,%esp
  803834:	68 6c 4a 80 00       	push   $0x804a6c
  803839:	68 3f 01 00 00       	push   $0x13f
  80383e:	68 8f 4a 80 00       	push   $0x804a8f
  803843:	e8 ab d5 ff ff       	call   800df3 <_panic>
  803848:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80384e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803851:	89 10                	mov    %edx,(%eax)
  803853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803856:	8b 00                	mov    (%eax),%eax
  803858:	85 c0                	test   %eax,%eax
  80385a:	74 0d                	je     803869 <insert_sorted_with_merge_freeList+0x1a4>
  80385c:	a1 48 51 80 00       	mov    0x805148,%eax
  803861:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803864:	89 50 04             	mov    %edx,0x4(%eax)
  803867:	eb 08                	jmp    803871 <insert_sorted_with_merge_freeList+0x1ac>
  803869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803874:	a3 48 51 80 00       	mov    %eax,0x805148
  803879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80387c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803883:	a1 54 51 80 00       	mov    0x805154,%eax
  803888:	40                   	inc    %eax
  803889:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80388e:	e9 7a 05 00 00       	jmp    803e0d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803893:	8b 45 08             	mov    0x8(%ebp),%eax
  803896:	8b 50 08             	mov    0x8(%eax),%edx
  803899:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80389c:	8b 40 08             	mov    0x8(%eax),%eax
  80389f:	39 c2                	cmp    %eax,%edx
  8038a1:	0f 82 14 01 00 00    	jb     8039bb <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8038a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038aa:	8b 50 08             	mov    0x8(%eax),%edx
  8038ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b3:	01 c2                	add    %eax,%edx
  8038b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b8:	8b 40 08             	mov    0x8(%eax),%eax
  8038bb:	39 c2                	cmp    %eax,%edx
  8038bd:	0f 85 90 00 00 00    	jne    803953 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8038c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8038c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8038cf:	01 c2                	add    %eax,%edx
  8038d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038d4:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  8038d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038da:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8038e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8038eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038ef:	75 17                	jne    803908 <insert_sorted_with_merge_freeList+0x243>
  8038f1:	83 ec 04             	sub    $0x4,%esp
  8038f4:	68 6c 4a 80 00       	push   $0x804a6c
  8038f9:	68 49 01 00 00       	push   $0x149
  8038fe:	68 8f 4a 80 00       	push   $0x804a8f
  803903:	e8 eb d4 ff ff       	call   800df3 <_panic>
  803908:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80390e:	8b 45 08             	mov    0x8(%ebp),%eax
  803911:	89 10                	mov    %edx,(%eax)
  803913:	8b 45 08             	mov    0x8(%ebp),%eax
  803916:	8b 00                	mov    (%eax),%eax
  803918:	85 c0                	test   %eax,%eax
  80391a:	74 0d                	je     803929 <insert_sorted_with_merge_freeList+0x264>
  80391c:	a1 48 51 80 00       	mov    0x805148,%eax
  803921:	8b 55 08             	mov    0x8(%ebp),%edx
  803924:	89 50 04             	mov    %edx,0x4(%eax)
  803927:	eb 08                	jmp    803931 <insert_sorted_with_merge_freeList+0x26c>
  803929:	8b 45 08             	mov    0x8(%ebp),%eax
  80392c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803931:	8b 45 08             	mov    0x8(%ebp),%eax
  803934:	a3 48 51 80 00       	mov    %eax,0x805148
  803939:	8b 45 08             	mov    0x8(%ebp),%eax
  80393c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803943:	a1 54 51 80 00       	mov    0x805154,%eax
  803948:	40                   	inc    %eax
  803949:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80394e:	e9 bb 04 00 00       	jmp    803e0e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803953:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803957:	75 17                	jne    803970 <insert_sorted_with_merge_freeList+0x2ab>
  803959:	83 ec 04             	sub    $0x4,%esp
  80395c:	68 e0 4a 80 00       	push   $0x804ae0
  803961:	68 4c 01 00 00       	push   $0x14c
  803966:	68 8f 4a 80 00       	push   $0x804a8f
  80396b:	e8 83 d4 ff ff       	call   800df3 <_panic>
  803970:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803976:	8b 45 08             	mov    0x8(%ebp),%eax
  803979:	89 50 04             	mov    %edx,0x4(%eax)
  80397c:	8b 45 08             	mov    0x8(%ebp),%eax
  80397f:	8b 40 04             	mov    0x4(%eax),%eax
  803982:	85 c0                	test   %eax,%eax
  803984:	74 0c                	je     803992 <insert_sorted_with_merge_freeList+0x2cd>
  803986:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80398b:	8b 55 08             	mov    0x8(%ebp),%edx
  80398e:	89 10                	mov    %edx,(%eax)
  803990:	eb 08                	jmp    80399a <insert_sorted_with_merge_freeList+0x2d5>
  803992:	8b 45 08             	mov    0x8(%ebp),%eax
  803995:	a3 38 51 80 00       	mov    %eax,0x805138
  80399a:	8b 45 08             	mov    0x8(%ebp),%eax
  80399d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ab:	a1 44 51 80 00       	mov    0x805144,%eax
  8039b0:	40                   	inc    %eax
  8039b1:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039b6:	e9 53 04 00 00       	jmp    803e0e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8039bb:	a1 38 51 80 00       	mov    0x805138,%eax
  8039c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039c3:	e9 15 04 00 00       	jmp    803ddd <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8039c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cb:	8b 00                	mov    (%eax),%eax
  8039cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8039d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d3:	8b 50 08             	mov    0x8(%eax),%edx
  8039d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d9:	8b 40 08             	mov    0x8(%eax),%eax
  8039dc:	39 c2                	cmp    %eax,%edx
  8039de:	0f 86 f1 03 00 00    	jbe    803dd5 <insert_sorted_with_merge_freeList+0x710>
  8039e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e7:	8b 50 08             	mov    0x8(%eax),%edx
  8039ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039ed:	8b 40 08             	mov    0x8(%eax),%eax
  8039f0:	39 c2                	cmp    %eax,%edx
  8039f2:	0f 83 dd 03 00 00    	jae    803dd5 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8039f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039fb:	8b 50 08             	mov    0x8(%eax),%edx
  8039fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a01:	8b 40 0c             	mov    0xc(%eax),%eax
  803a04:	01 c2                	add    %eax,%edx
  803a06:	8b 45 08             	mov    0x8(%ebp),%eax
  803a09:	8b 40 08             	mov    0x8(%eax),%eax
  803a0c:	39 c2                	cmp    %eax,%edx
  803a0e:	0f 85 b9 01 00 00    	jne    803bcd <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803a14:	8b 45 08             	mov    0x8(%ebp),%eax
  803a17:	8b 50 08             	mov    0x8(%eax),%edx
  803a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1d:	8b 40 0c             	mov    0xc(%eax),%eax
  803a20:	01 c2                	add    %eax,%edx
  803a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a25:	8b 40 08             	mov    0x8(%eax),%eax
  803a28:	39 c2                	cmp    %eax,%edx
  803a2a:	0f 85 0d 01 00 00    	jne    803b3d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a33:	8b 50 0c             	mov    0xc(%eax),%edx
  803a36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a39:	8b 40 0c             	mov    0xc(%eax),%eax
  803a3c:	01 c2                	add    %eax,%edx
  803a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a41:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803a44:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a48:	75 17                	jne    803a61 <insert_sorted_with_merge_freeList+0x39c>
  803a4a:	83 ec 04             	sub    $0x4,%esp
  803a4d:	68 38 4b 80 00       	push   $0x804b38
  803a52:	68 5c 01 00 00       	push   $0x15c
  803a57:	68 8f 4a 80 00       	push   $0x804a8f
  803a5c:	e8 92 d3 ff ff       	call   800df3 <_panic>
  803a61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a64:	8b 00                	mov    (%eax),%eax
  803a66:	85 c0                	test   %eax,%eax
  803a68:	74 10                	je     803a7a <insert_sorted_with_merge_freeList+0x3b5>
  803a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6d:	8b 00                	mov    (%eax),%eax
  803a6f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a72:	8b 52 04             	mov    0x4(%edx),%edx
  803a75:	89 50 04             	mov    %edx,0x4(%eax)
  803a78:	eb 0b                	jmp    803a85 <insert_sorted_with_merge_freeList+0x3c0>
  803a7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a7d:	8b 40 04             	mov    0x4(%eax),%eax
  803a80:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a88:	8b 40 04             	mov    0x4(%eax),%eax
  803a8b:	85 c0                	test   %eax,%eax
  803a8d:	74 0f                	je     803a9e <insert_sorted_with_merge_freeList+0x3d9>
  803a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a92:	8b 40 04             	mov    0x4(%eax),%eax
  803a95:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a98:	8b 12                	mov    (%edx),%edx
  803a9a:	89 10                	mov    %edx,(%eax)
  803a9c:	eb 0a                	jmp    803aa8 <insert_sorted_with_merge_freeList+0x3e3>
  803a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa1:	8b 00                	mov    (%eax),%eax
  803aa3:	a3 38 51 80 00       	mov    %eax,0x805138
  803aa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ab1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803abb:	a1 44 51 80 00       	mov    0x805144,%eax
  803ac0:	48                   	dec    %eax
  803ac1:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803ac6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ad3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803ada:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ade:	75 17                	jne    803af7 <insert_sorted_with_merge_freeList+0x432>
  803ae0:	83 ec 04             	sub    $0x4,%esp
  803ae3:	68 6c 4a 80 00       	push   $0x804a6c
  803ae8:	68 5f 01 00 00       	push   $0x15f
  803aed:	68 8f 4a 80 00       	push   $0x804a8f
  803af2:	e8 fc d2 ff ff       	call   800df3 <_panic>
  803af7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803afd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b00:	89 10                	mov    %edx,(%eax)
  803b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b05:	8b 00                	mov    (%eax),%eax
  803b07:	85 c0                	test   %eax,%eax
  803b09:	74 0d                	je     803b18 <insert_sorted_with_merge_freeList+0x453>
  803b0b:	a1 48 51 80 00       	mov    0x805148,%eax
  803b10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b13:	89 50 04             	mov    %edx,0x4(%eax)
  803b16:	eb 08                	jmp    803b20 <insert_sorted_with_merge_freeList+0x45b>
  803b18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b1b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b23:	a3 48 51 80 00       	mov    %eax,0x805148
  803b28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b32:	a1 54 51 80 00       	mov    0x805154,%eax
  803b37:	40                   	inc    %eax
  803b38:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b40:	8b 50 0c             	mov    0xc(%eax),%edx
  803b43:	8b 45 08             	mov    0x8(%ebp),%eax
  803b46:	8b 40 0c             	mov    0xc(%eax),%eax
  803b49:	01 c2                	add    %eax,%edx
  803b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b4e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803b51:	8b 45 08             	mov    0x8(%ebp),%eax
  803b54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803b65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b69:	75 17                	jne    803b82 <insert_sorted_with_merge_freeList+0x4bd>
  803b6b:	83 ec 04             	sub    $0x4,%esp
  803b6e:	68 6c 4a 80 00       	push   $0x804a6c
  803b73:	68 64 01 00 00       	push   $0x164
  803b78:	68 8f 4a 80 00       	push   $0x804a8f
  803b7d:	e8 71 d2 ff ff       	call   800df3 <_panic>
  803b82:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b88:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8b:	89 10                	mov    %edx,(%eax)
  803b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b90:	8b 00                	mov    (%eax),%eax
  803b92:	85 c0                	test   %eax,%eax
  803b94:	74 0d                	je     803ba3 <insert_sorted_with_merge_freeList+0x4de>
  803b96:	a1 48 51 80 00       	mov    0x805148,%eax
  803b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  803b9e:	89 50 04             	mov    %edx,0x4(%eax)
  803ba1:	eb 08                	jmp    803bab <insert_sorted_with_merge_freeList+0x4e6>
  803ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ba6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803bab:	8b 45 08             	mov    0x8(%ebp),%eax
  803bae:	a3 48 51 80 00       	mov    %eax,0x805148
  803bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bbd:	a1 54 51 80 00       	mov    0x805154,%eax
  803bc2:	40                   	inc    %eax
  803bc3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803bc8:	e9 41 02 00 00       	jmp    803e0e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd0:	8b 50 08             	mov    0x8(%eax),%edx
  803bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd6:	8b 40 0c             	mov    0xc(%eax),%eax
  803bd9:	01 c2                	add    %eax,%edx
  803bdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bde:	8b 40 08             	mov    0x8(%eax),%eax
  803be1:	39 c2                	cmp    %eax,%edx
  803be3:	0f 85 7c 01 00 00    	jne    803d65 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803be9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bed:	74 06                	je     803bf5 <insert_sorted_with_merge_freeList+0x530>
  803bef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bf3:	75 17                	jne    803c0c <insert_sorted_with_merge_freeList+0x547>
  803bf5:	83 ec 04             	sub    $0x4,%esp
  803bf8:	68 a8 4a 80 00       	push   $0x804aa8
  803bfd:	68 69 01 00 00       	push   $0x169
  803c02:	68 8f 4a 80 00       	push   $0x804a8f
  803c07:	e8 e7 d1 ff ff       	call   800df3 <_panic>
  803c0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0f:	8b 50 04             	mov    0x4(%eax),%edx
  803c12:	8b 45 08             	mov    0x8(%ebp),%eax
  803c15:	89 50 04             	mov    %edx,0x4(%eax)
  803c18:	8b 45 08             	mov    0x8(%ebp),%eax
  803c1b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c1e:	89 10                	mov    %edx,(%eax)
  803c20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c23:	8b 40 04             	mov    0x4(%eax),%eax
  803c26:	85 c0                	test   %eax,%eax
  803c28:	74 0d                	je     803c37 <insert_sorted_with_merge_freeList+0x572>
  803c2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c2d:	8b 40 04             	mov    0x4(%eax),%eax
  803c30:	8b 55 08             	mov    0x8(%ebp),%edx
  803c33:	89 10                	mov    %edx,(%eax)
  803c35:	eb 08                	jmp    803c3f <insert_sorted_with_merge_freeList+0x57a>
  803c37:	8b 45 08             	mov    0x8(%ebp),%eax
  803c3a:	a3 38 51 80 00       	mov    %eax,0x805138
  803c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c42:	8b 55 08             	mov    0x8(%ebp),%edx
  803c45:	89 50 04             	mov    %edx,0x4(%eax)
  803c48:	a1 44 51 80 00       	mov    0x805144,%eax
  803c4d:	40                   	inc    %eax
  803c4e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803c53:	8b 45 08             	mov    0x8(%ebp),%eax
  803c56:	8b 50 0c             	mov    0xc(%eax),%edx
  803c59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5c:	8b 40 0c             	mov    0xc(%eax),%eax
  803c5f:	01 c2                	add    %eax,%edx
  803c61:	8b 45 08             	mov    0x8(%ebp),%eax
  803c64:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803c67:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c6b:	75 17                	jne    803c84 <insert_sorted_with_merge_freeList+0x5bf>
  803c6d:	83 ec 04             	sub    $0x4,%esp
  803c70:	68 38 4b 80 00       	push   $0x804b38
  803c75:	68 6b 01 00 00       	push   $0x16b
  803c7a:	68 8f 4a 80 00       	push   $0x804a8f
  803c7f:	e8 6f d1 ff ff       	call   800df3 <_panic>
  803c84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c87:	8b 00                	mov    (%eax),%eax
  803c89:	85 c0                	test   %eax,%eax
  803c8b:	74 10                	je     803c9d <insert_sorted_with_merge_freeList+0x5d8>
  803c8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c90:	8b 00                	mov    (%eax),%eax
  803c92:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c95:	8b 52 04             	mov    0x4(%edx),%edx
  803c98:	89 50 04             	mov    %edx,0x4(%eax)
  803c9b:	eb 0b                	jmp    803ca8 <insert_sorted_with_merge_freeList+0x5e3>
  803c9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca0:	8b 40 04             	mov    0x4(%eax),%eax
  803ca3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803ca8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cab:	8b 40 04             	mov    0x4(%eax),%eax
  803cae:	85 c0                	test   %eax,%eax
  803cb0:	74 0f                	je     803cc1 <insert_sorted_with_merge_freeList+0x5fc>
  803cb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cb5:	8b 40 04             	mov    0x4(%eax),%eax
  803cb8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cbb:	8b 12                	mov    (%edx),%edx
  803cbd:	89 10                	mov    %edx,(%eax)
  803cbf:	eb 0a                	jmp    803ccb <insert_sorted_with_merge_freeList+0x606>
  803cc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc4:	8b 00                	mov    (%eax),%eax
  803cc6:	a3 38 51 80 00       	mov    %eax,0x805138
  803ccb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cde:	a1 44 51 80 00       	mov    0x805144,%eax
  803ce3:	48                   	dec    %eax
  803ce4:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803ce9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803cf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803cfd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d01:	75 17                	jne    803d1a <insert_sorted_with_merge_freeList+0x655>
  803d03:	83 ec 04             	sub    $0x4,%esp
  803d06:	68 6c 4a 80 00       	push   $0x804a6c
  803d0b:	68 6e 01 00 00       	push   $0x16e
  803d10:	68 8f 4a 80 00       	push   $0x804a8f
  803d15:	e8 d9 d0 ff ff       	call   800df3 <_panic>
  803d1a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d23:	89 10                	mov    %edx,(%eax)
  803d25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d28:	8b 00                	mov    (%eax),%eax
  803d2a:	85 c0                	test   %eax,%eax
  803d2c:	74 0d                	je     803d3b <insert_sorted_with_merge_freeList+0x676>
  803d2e:	a1 48 51 80 00       	mov    0x805148,%eax
  803d33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d36:	89 50 04             	mov    %edx,0x4(%eax)
  803d39:	eb 08                	jmp    803d43 <insert_sorted_with_merge_freeList+0x67e>
  803d3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d46:	a3 48 51 80 00       	mov    %eax,0x805148
  803d4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d55:	a1 54 51 80 00       	mov    0x805154,%eax
  803d5a:	40                   	inc    %eax
  803d5b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803d60:	e9 a9 00 00 00       	jmp    803e0e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803d65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d69:	74 06                	je     803d71 <insert_sorted_with_merge_freeList+0x6ac>
  803d6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d6f:	75 17                	jne    803d88 <insert_sorted_with_merge_freeList+0x6c3>
  803d71:	83 ec 04             	sub    $0x4,%esp
  803d74:	68 04 4b 80 00       	push   $0x804b04
  803d79:	68 73 01 00 00       	push   $0x173
  803d7e:	68 8f 4a 80 00       	push   $0x804a8f
  803d83:	e8 6b d0 ff ff       	call   800df3 <_panic>
  803d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8b:	8b 10                	mov    (%eax),%edx
  803d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d90:	89 10                	mov    %edx,(%eax)
  803d92:	8b 45 08             	mov    0x8(%ebp),%eax
  803d95:	8b 00                	mov    (%eax),%eax
  803d97:	85 c0                	test   %eax,%eax
  803d99:	74 0b                	je     803da6 <insert_sorted_with_merge_freeList+0x6e1>
  803d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d9e:	8b 00                	mov    (%eax),%eax
  803da0:	8b 55 08             	mov    0x8(%ebp),%edx
  803da3:	89 50 04             	mov    %edx,0x4(%eax)
  803da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da9:	8b 55 08             	mov    0x8(%ebp),%edx
  803dac:	89 10                	mov    %edx,(%eax)
  803dae:	8b 45 08             	mov    0x8(%ebp),%eax
  803db1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803db4:	89 50 04             	mov    %edx,0x4(%eax)
  803db7:	8b 45 08             	mov    0x8(%ebp),%eax
  803dba:	8b 00                	mov    (%eax),%eax
  803dbc:	85 c0                	test   %eax,%eax
  803dbe:	75 08                	jne    803dc8 <insert_sorted_with_merge_freeList+0x703>
  803dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803dc8:	a1 44 51 80 00       	mov    0x805144,%eax
  803dcd:	40                   	inc    %eax
  803dce:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803dd3:	eb 39                	jmp    803e0e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803dd5:	a1 40 51 80 00       	mov    0x805140,%eax
  803dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803ddd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803de1:	74 07                	je     803dea <insert_sorted_with_merge_freeList+0x725>
  803de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803de6:	8b 00                	mov    (%eax),%eax
  803de8:	eb 05                	jmp    803def <insert_sorted_with_merge_freeList+0x72a>
  803dea:	b8 00 00 00 00       	mov    $0x0,%eax
  803def:	a3 40 51 80 00       	mov    %eax,0x805140
  803df4:	a1 40 51 80 00       	mov    0x805140,%eax
  803df9:	85 c0                	test   %eax,%eax
  803dfb:	0f 85 c7 fb ff ff    	jne    8039c8 <insert_sorted_with_merge_freeList+0x303>
  803e01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e05:	0f 85 bd fb ff ff    	jne    8039c8 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e0b:	eb 01                	jmp    803e0e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803e0d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e0e:	90                   	nop
  803e0f:	c9                   	leave  
  803e10:	c3                   	ret    
  803e11:	66 90                	xchg   %ax,%ax
  803e13:	90                   	nop

00803e14 <__udivdi3>:
  803e14:	55                   	push   %ebp
  803e15:	57                   	push   %edi
  803e16:	56                   	push   %esi
  803e17:	53                   	push   %ebx
  803e18:	83 ec 1c             	sub    $0x1c,%esp
  803e1b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e1f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e27:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803e2b:	89 ca                	mov    %ecx,%edx
  803e2d:	89 f8                	mov    %edi,%eax
  803e2f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803e33:	85 f6                	test   %esi,%esi
  803e35:	75 2d                	jne    803e64 <__udivdi3+0x50>
  803e37:	39 cf                	cmp    %ecx,%edi
  803e39:	77 65                	ja     803ea0 <__udivdi3+0x8c>
  803e3b:	89 fd                	mov    %edi,%ebp
  803e3d:	85 ff                	test   %edi,%edi
  803e3f:	75 0b                	jne    803e4c <__udivdi3+0x38>
  803e41:	b8 01 00 00 00       	mov    $0x1,%eax
  803e46:	31 d2                	xor    %edx,%edx
  803e48:	f7 f7                	div    %edi
  803e4a:	89 c5                	mov    %eax,%ebp
  803e4c:	31 d2                	xor    %edx,%edx
  803e4e:	89 c8                	mov    %ecx,%eax
  803e50:	f7 f5                	div    %ebp
  803e52:	89 c1                	mov    %eax,%ecx
  803e54:	89 d8                	mov    %ebx,%eax
  803e56:	f7 f5                	div    %ebp
  803e58:	89 cf                	mov    %ecx,%edi
  803e5a:	89 fa                	mov    %edi,%edx
  803e5c:	83 c4 1c             	add    $0x1c,%esp
  803e5f:	5b                   	pop    %ebx
  803e60:	5e                   	pop    %esi
  803e61:	5f                   	pop    %edi
  803e62:	5d                   	pop    %ebp
  803e63:	c3                   	ret    
  803e64:	39 ce                	cmp    %ecx,%esi
  803e66:	77 28                	ja     803e90 <__udivdi3+0x7c>
  803e68:	0f bd fe             	bsr    %esi,%edi
  803e6b:	83 f7 1f             	xor    $0x1f,%edi
  803e6e:	75 40                	jne    803eb0 <__udivdi3+0x9c>
  803e70:	39 ce                	cmp    %ecx,%esi
  803e72:	72 0a                	jb     803e7e <__udivdi3+0x6a>
  803e74:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e78:	0f 87 9e 00 00 00    	ja     803f1c <__udivdi3+0x108>
  803e7e:	b8 01 00 00 00       	mov    $0x1,%eax
  803e83:	89 fa                	mov    %edi,%edx
  803e85:	83 c4 1c             	add    $0x1c,%esp
  803e88:	5b                   	pop    %ebx
  803e89:	5e                   	pop    %esi
  803e8a:	5f                   	pop    %edi
  803e8b:	5d                   	pop    %ebp
  803e8c:	c3                   	ret    
  803e8d:	8d 76 00             	lea    0x0(%esi),%esi
  803e90:	31 ff                	xor    %edi,%edi
  803e92:	31 c0                	xor    %eax,%eax
  803e94:	89 fa                	mov    %edi,%edx
  803e96:	83 c4 1c             	add    $0x1c,%esp
  803e99:	5b                   	pop    %ebx
  803e9a:	5e                   	pop    %esi
  803e9b:	5f                   	pop    %edi
  803e9c:	5d                   	pop    %ebp
  803e9d:	c3                   	ret    
  803e9e:	66 90                	xchg   %ax,%ax
  803ea0:	89 d8                	mov    %ebx,%eax
  803ea2:	f7 f7                	div    %edi
  803ea4:	31 ff                	xor    %edi,%edi
  803ea6:	89 fa                	mov    %edi,%edx
  803ea8:	83 c4 1c             	add    $0x1c,%esp
  803eab:	5b                   	pop    %ebx
  803eac:	5e                   	pop    %esi
  803ead:	5f                   	pop    %edi
  803eae:	5d                   	pop    %ebp
  803eaf:	c3                   	ret    
  803eb0:	bd 20 00 00 00       	mov    $0x20,%ebp
  803eb5:	89 eb                	mov    %ebp,%ebx
  803eb7:	29 fb                	sub    %edi,%ebx
  803eb9:	89 f9                	mov    %edi,%ecx
  803ebb:	d3 e6                	shl    %cl,%esi
  803ebd:	89 c5                	mov    %eax,%ebp
  803ebf:	88 d9                	mov    %bl,%cl
  803ec1:	d3 ed                	shr    %cl,%ebp
  803ec3:	89 e9                	mov    %ebp,%ecx
  803ec5:	09 f1                	or     %esi,%ecx
  803ec7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ecb:	89 f9                	mov    %edi,%ecx
  803ecd:	d3 e0                	shl    %cl,%eax
  803ecf:	89 c5                	mov    %eax,%ebp
  803ed1:	89 d6                	mov    %edx,%esi
  803ed3:	88 d9                	mov    %bl,%cl
  803ed5:	d3 ee                	shr    %cl,%esi
  803ed7:	89 f9                	mov    %edi,%ecx
  803ed9:	d3 e2                	shl    %cl,%edx
  803edb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803edf:	88 d9                	mov    %bl,%cl
  803ee1:	d3 e8                	shr    %cl,%eax
  803ee3:	09 c2                	or     %eax,%edx
  803ee5:	89 d0                	mov    %edx,%eax
  803ee7:	89 f2                	mov    %esi,%edx
  803ee9:	f7 74 24 0c          	divl   0xc(%esp)
  803eed:	89 d6                	mov    %edx,%esi
  803eef:	89 c3                	mov    %eax,%ebx
  803ef1:	f7 e5                	mul    %ebp
  803ef3:	39 d6                	cmp    %edx,%esi
  803ef5:	72 19                	jb     803f10 <__udivdi3+0xfc>
  803ef7:	74 0b                	je     803f04 <__udivdi3+0xf0>
  803ef9:	89 d8                	mov    %ebx,%eax
  803efb:	31 ff                	xor    %edi,%edi
  803efd:	e9 58 ff ff ff       	jmp    803e5a <__udivdi3+0x46>
  803f02:	66 90                	xchg   %ax,%ax
  803f04:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f08:	89 f9                	mov    %edi,%ecx
  803f0a:	d3 e2                	shl    %cl,%edx
  803f0c:	39 c2                	cmp    %eax,%edx
  803f0e:	73 e9                	jae    803ef9 <__udivdi3+0xe5>
  803f10:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f13:	31 ff                	xor    %edi,%edi
  803f15:	e9 40 ff ff ff       	jmp    803e5a <__udivdi3+0x46>
  803f1a:	66 90                	xchg   %ax,%ax
  803f1c:	31 c0                	xor    %eax,%eax
  803f1e:	e9 37 ff ff ff       	jmp    803e5a <__udivdi3+0x46>
  803f23:	90                   	nop

00803f24 <__umoddi3>:
  803f24:	55                   	push   %ebp
  803f25:	57                   	push   %edi
  803f26:	56                   	push   %esi
  803f27:	53                   	push   %ebx
  803f28:	83 ec 1c             	sub    $0x1c,%esp
  803f2b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803f2f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803f33:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803f37:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803f3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803f3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f43:	89 f3                	mov    %esi,%ebx
  803f45:	89 fa                	mov    %edi,%edx
  803f47:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f4b:	89 34 24             	mov    %esi,(%esp)
  803f4e:	85 c0                	test   %eax,%eax
  803f50:	75 1a                	jne    803f6c <__umoddi3+0x48>
  803f52:	39 f7                	cmp    %esi,%edi
  803f54:	0f 86 a2 00 00 00    	jbe    803ffc <__umoddi3+0xd8>
  803f5a:	89 c8                	mov    %ecx,%eax
  803f5c:	89 f2                	mov    %esi,%edx
  803f5e:	f7 f7                	div    %edi
  803f60:	89 d0                	mov    %edx,%eax
  803f62:	31 d2                	xor    %edx,%edx
  803f64:	83 c4 1c             	add    $0x1c,%esp
  803f67:	5b                   	pop    %ebx
  803f68:	5e                   	pop    %esi
  803f69:	5f                   	pop    %edi
  803f6a:	5d                   	pop    %ebp
  803f6b:	c3                   	ret    
  803f6c:	39 f0                	cmp    %esi,%eax
  803f6e:	0f 87 ac 00 00 00    	ja     804020 <__umoddi3+0xfc>
  803f74:	0f bd e8             	bsr    %eax,%ebp
  803f77:	83 f5 1f             	xor    $0x1f,%ebp
  803f7a:	0f 84 ac 00 00 00    	je     80402c <__umoddi3+0x108>
  803f80:	bf 20 00 00 00       	mov    $0x20,%edi
  803f85:	29 ef                	sub    %ebp,%edi
  803f87:	89 fe                	mov    %edi,%esi
  803f89:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f8d:	89 e9                	mov    %ebp,%ecx
  803f8f:	d3 e0                	shl    %cl,%eax
  803f91:	89 d7                	mov    %edx,%edi
  803f93:	89 f1                	mov    %esi,%ecx
  803f95:	d3 ef                	shr    %cl,%edi
  803f97:	09 c7                	or     %eax,%edi
  803f99:	89 e9                	mov    %ebp,%ecx
  803f9b:	d3 e2                	shl    %cl,%edx
  803f9d:	89 14 24             	mov    %edx,(%esp)
  803fa0:	89 d8                	mov    %ebx,%eax
  803fa2:	d3 e0                	shl    %cl,%eax
  803fa4:	89 c2                	mov    %eax,%edx
  803fa6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803faa:	d3 e0                	shl    %cl,%eax
  803fac:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fb0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803fb4:	89 f1                	mov    %esi,%ecx
  803fb6:	d3 e8                	shr    %cl,%eax
  803fb8:	09 d0                	or     %edx,%eax
  803fba:	d3 eb                	shr    %cl,%ebx
  803fbc:	89 da                	mov    %ebx,%edx
  803fbe:	f7 f7                	div    %edi
  803fc0:	89 d3                	mov    %edx,%ebx
  803fc2:	f7 24 24             	mull   (%esp)
  803fc5:	89 c6                	mov    %eax,%esi
  803fc7:	89 d1                	mov    %edx,%ecx
  803fc9:	39 d3                	cmp    %edx,%ebx
  803fcb:	0f 82 87 00 00 00    	jb     804058 <__umoddi3+0x134>
  803fd1:	0f 84 91 00 00 00    	je     804068 <__umoddi3+0x144>
  803fd7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803fdb:	29 f2                	sub    %esi,%edx
  803fdd:	19 cb                	sbb    %ecx,%ebx
  803fdf:	89 d8                	mov    %ebx,%eax
  803fe1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803fe5:	d3 e0                	shl    %cl,%eax
  803fe7:	89 e9                	mov    %ebp,%ecx
  803fe9:	d3 ea                	shr    %cl,%edx
  803feb:	09 d0                	or     %edx,%eax
  803fed:	89 e9                	mov    %ebp,%ecx
  803fef:	d3 eb                	shr    %cl,%ebx
  803ff1:	89 da                	mov    %ebx,%edx
  803ff3:	83 c4 1c             	add    $0x1c,%esp
  803ff6:	5b                   	pop    %ebx
  803ff7:	5e                   	pop    %esi
  803ff8:	5f                   	pop    %edi
  803ff9:	5d                   	pop    %ebp
  803ffa:	c3                   	ret    
  803ffb:	90                   	nop
  803ffc:	89 fd                	mov    %edi,%ebp
  803ffe:	85 ff                	test   %edi,%edi
  804000:	75 0b                	jne    80400d <__umoddi3+0xe9>
  804002:	b8 01 00 00 00       	mov    $0x1,%eax
  804007:	31 d2                	xor    %edx,%edx
  804009:	f7 f7                	div    %edi
  80400b:	89 c5                	mov    %eax,%ebp
  80400d:	89 f0                	mov    %esi,%eax
  80400f:	31 d2                	xor    %edx,%edx
  804011:	f7 f5                	div    %ebp
  804013:	89 c8                	mov    %ecx,%eax
  804015:	f7 f5                	div    %ebp
  804017:	89 d0                	mov    %edx,%eax
  804019:	e9 44 ff ff ff       	jmp    803f62 <__umoddi3+0x3e>
  80401e:	66 90                	xchg   %ax,%ax
  804020:	89 c8                	mov    %ecx,%eax
  804022:	89 f2                	mov    %esi,%edx
  804024:	83 c4 1c             	add    $0x1c,%esp
  804027:	5b                   	pop    %ebx
  804028:	5e                   	pop    %esi
  804029:	5f                   	pop    %edi
  80402a:	5d                   	pop    %ebp
  80402b:	c3                   	ret    
  80402c:	3b 04 24             	cmp    (%esp),%eax
  80402f:	72 06                	jb     804037 <__umoddi3+0x113>
  804031:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804035:	77 0f                	ja     804046 <__umoddi3+0x122>
  804037:	89 f2                	mov    %esi,%edx
  804039:	29 f9                	sub    %edi,%ecx
  80403b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80403f:	89 14 24             	mov    %edx,(%esp)
  804042:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804046:	8b 44 24 04          	mov    0x4(%esp),%eax
  80404a:	8b 14 24             	mov    (%esp),%edx
  80404d:	83 c4 1c             	add    $0x1c,%esp
  804050:	5b                   	pop    %ebx
  804051:	5e                   	pop    %esi
  804052:	5f                   	pop    %edi
  804053:	5d                   	pop    %ebp
  804054:	c3                   	ret    
  804055:	8d 76 00             	lea    0x0(%esi),%esi
  804058:	2b 04 24             	sub    (%esp),%eax
  80405b:	19 fa                	sbb    %edi,%edx
  80405d:	89 d1                	mov    %edx,%ecx
  80405f:	89 c6                	mov    %eax,%esi
  804061:	e9 71 ff ff ff       	jmp    803fd7 <__umoddi3+0xb3>
  804066:	66 90                	xchg   %ax,%ax
  804068:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80406c:	72 ea                	jb     804058 <__umoddi3+0x134>
  80406e:	89 d9                	mov    %ebx,%ecx
  804070:	e9 62 ff ff ff       	jmp    803fd7 <__umoddi3+0xb3>
