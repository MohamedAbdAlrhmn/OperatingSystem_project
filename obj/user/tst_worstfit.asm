
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
  800048:	e8 cc 27 00 00       	call   802819 <sys_set_uheap_strategy>
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
  80009e:	68 40 41 80 00       	push   $0x804140
  8000a3:	6a 16                	push   $0x16
  8000a5:	68 5c 41 80 00       	push   $0x80415c
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
  8000f7:	68 70 41 80 00       	push   $0x804170
  8000fc:	68 87 41 80 00       	push   $0x804187
  800101:	6a 24                	push   $0x24
  800103:	68 5c 41 80 00       	push   $0x80415c
  800108:	e8 e6 0c 00 00       	call   800df3 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_WORSTFIT);
  80010d:	83 ec 0c             	sub    $0xc,%esp
  800110:	6a 04                	push   $0x4
  800112:	e8 02 27 00 00       	call   802819 <sys_set_uheap_strategy>
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
  800168:	68 40 41 80 00       	push   $0x804140
  80016d:	6a 36                	push   $0x36
  80016f:	68 5c 41 80 00       	push   $0x80415c
  800174:	e8 7a 0c 00 00       	call   800df3 <_panic>
	}

	int freeFrames ;
	int usedDiskPages;

	cprintf("This test has %d tests. A pass message will be displayed after each one.\n", totalNumberOfTests);
  800179:	83 ec 08             	sub    $0x8,%esp
  80017c:	ff 75 cc             	pushl  -0x34(%ebp)
  80017f:	68 9c 41 80 00       	push   $0x80419c
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
  8001ea:	68 e8 41 80 00       	push   $0x8041e8
  8001ef:	6a 48                	push   $0x48
  8001f1:	68 5c 41 80 00       	push   $0x80415c
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
  80020f:	e8 f0 20 00 00       	call   802304 <sys_calculate_free_frames>
  800214:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800217:	e8 88 21 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  8002af:	68 38 42 80 00       	push   $0x804238
  8002b4:	6a 5d                	push   $0x5d
  8002b6:	68 5c 41 80 00       	push   $0x80415c
  8002bb:	e8 33 0b 00 00       	call   800df3 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002c0:	e8 df 20 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  8002e3:	68 76 42 80 00       	push   $0x804276
  8002e8:	6a 5f                	push   $0x5f
  8002ea:	68 5c 41 80 00       	push   $0x80415c
  8002ef:	e8 ff 0a 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f4:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8002f7:	e8 08 20 00 00       	call   802304 <sys_calculate_free_frames>
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
  800319:	68 93 42 80 00       	push   $0x804293
  80031e:	6a 60                	push   $0x60
  800320:	68 5c 41 80 00       	push   $0x80415c
  800325:	e8 c9 0a 00 00       	call   800df3 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  80032a:	e8 d5 1f 00 00       	call   802304 <sys_calculate_free_frames>
  80032f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800332:	e8 6d 20 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  800448:	e8 57 1f 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  80047b:	68 a4 42 80 00       	push   $0x8042a4
  800480:	6a 76                	push   $0x76
  800482:	68 5c 41 80 00       	push   $0x80415c
  800487:	e8 67 09 00 00       	call   800df3 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80048c:	e8 73 1e 00 00       	call   802304 <sys_calculate_free_frames>
  800491:	89 c2                	mov    %eax,%edx
  800493:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800496:	39 c2                	cmp    %eax,%edx
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 e0 42 80 00       	push   $0x8042e0
  8004a2:	6a 77                	push   $0x77
  8004a4:	68 5c 41 80 00       	push   $0x80415c
  8004a9:	e8 45 09 00 00       	call   800df3 <_panic>

	// Test worst fit
	//[WORST FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  8004ae:	e8 51 1e 00 00       	call   802304 <sys_calculate_free_frames>
  8004b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004b6:	e8 e9 1e 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  8004dd:	68 20 43 80 00       	push   $0x804320
  8004e2:	6a 7f                	push   $0x7f
  8004e4:	68 5c 41 80 00       	push   $0x80415c
  8004e9:	e8 05 09 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8004ee:	e8 b1 1e 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  80050e:	68 76 42 80 00       	push   $0x804276
  800513:	68 80 00 00 00       	push   $0x80
  800518:	68 5c 41 80 00       	push   $0x80415c
  80051d:	e8 d1 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800522:	e8 dd 1d 00 00       	call   802304 <sys_calculate_free_frames>
  800527:	89 c2                	mov    %eax,%edx
  800529:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052c:	39 c2                	cmp    %eax,%edx
  80052e:	74 17                	je     800547 <_main+0x50f>
  800530:	83 ec 04             	sub    $0x4,%esp
  800533:	68 93 42 80 00       	push   $0x804293
  800538:	68 81 00 00 00       	push   $0x81
  80053d:	68 5c 41 80 00       	push   $0x80415c
  800542:	e8 ac 08 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800547:	ff 45 d0             	incl   -0x30(%ebp)
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	ff 75 d0             	pushl  -0x30(%ebp)
  800550:	68 40 43 80 00       	push   $0x804340
  800555:	e8 4d 0b 00 00       	call   8010a7 <cprintf>
  80055a:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80055d:	e8 a2 1d 00 00       	call   802304 <sys_calculate_free_frames>
  800562:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800565:	e8 3a 1e 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  80058f:	68 20 43 80 00       	push   $0x804320
  800594:	68 88 00 00 00       	push   $0x88
  800599:	68 5c 41 80 00       	push   $0x80415c
  80059e:	e8 50 08 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005a3:	e8 fc 1d 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  8005c6:	68 76 42 80 00       	push   $0x804276
  8005cb:	68 89 00 00 00       	push   $0x89
  8005d0:	68 5c 41 80 00       	push   $0x80415c
  8005d5:	e8 19 08 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8005da:	e8 25 1d 00 00       	call   802304 <sys_calculate_free_frames>
  8005df:	89 c2                	mov    %eax,%edx
  8005e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e4:	39 c2                	cmp    %eax,%edx
  8005e6:	74 17                	je     8005ff <_main+0x5c7>
  8005e8:	83 ec 04             	sub    $0x4,%esp
  8005eb:	68 93 42 80 00       	push   $0x804293
  8005f0:	68 8a 00 00 00       	push   $0x8a
  8005f5:	68 5c 41 80 00       	push   $0x80415c
  8005fa:	e8 f4 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8005ff:	ff 45 d0             	incl   -0x30(%ebp)
  800602:	83 ec 08             	sub    $0x8,%esp
  800605:	ff 75 d0             	pushl  -0x30(%ebp)
  800608:	68 40 43 80 00       	push   $0x804340
  80060d:	e8 95 0a 00 00       	call   8010a7 <cprintf>
  800612:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800615:	e8 ea 1c 00 00       	call   802304 <sys_calculate_free_frames>
  80061a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80061d:	e8 82 1d 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  80064c:	68 20 43 80 00       	push   $0x804320
  800651:	68 91 00 00 00       	push   $0x91
  800656:	68 5c 41 80 00       	push   $0x80415c
  80065b:	e8 93 07 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  6*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800660:	e8 3f 1d 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  800688:	68 76 42 80 00       	push   $0x804276
  80068d:	68 92 00 00 00       	push   $0x92
  800692:	68 5c 41 80 00       	push   $0x80415c
  800697:	e8 57 07 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069c:	e8 63 1c 00 00       	call   802304 <sys_calculate_free_frames>
  8006a1:	89 c2                	mov    %eax,%edx
  8006a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	74 17                	je     8006c1 <_main+0x689>
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	68 93 42 80 00       	push   $0x804293
  8006b2:	68 93 00 00 00       	push   $0x93
  8006b7:	68 5c 41 80 00       	push   $0x80415c
  8006bc:	e8 32 07 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8006c1:	ff 45 d0             	incl   -0x30(%ebp)
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8006ca:	68 40 43 80 00       	push   $0x804340
  8006cf:	e8 d3 09 00 00       	call   8010a7 <cprintf>
  8006d4:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8006d7:	e8 28 1c 00 00       	call   802304 <sys_calculate_free_frames>
  8006dc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006df:	e8 c0 1c 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  80070d:	68 20 43 80 00       	push   $0x804320
  800712:	68 9a 00 00 00       	push   $0x9a
  800717:	68 5c 41 80 00       	push   $0x80415c
  80071c:	e8 d2 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800721:	e8 7e 1c 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  800748:	68 76 42 80 00       	push   $0x804276
  80074d:	68 9b 00 00 00       	push   $0x9b
  800752:	68 5c 41 80 00       	push   $0x80415c
  800757:	e8 97 06 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80075c:	e8 a3 1b 00 00       	call   802304 <sys_calculate_free_frames>
  800761:	89 c2                	mov    %eax,%edx
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	39 c2                	cmp    %eax,%edx
  800768:	74 17                	je     800781 <_main+0x749>
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	68 93 42 80 00       	push   $0x804293
  800772:	68 9c 00 00 00       	push   $0x9c
  800777:	68 5c 41 80 00       	push   $0x80415c
  80077c:	e8 72 06 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800781:	ff 45 d0             	incl   -0x30(%ebp)
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	ff 75 d0             	pushl  -0x30(%ebp)
  80078a:	68 40 43 80 00       	push   $0x804340
  80078f:	e8 13 09 00 00       	call   8010a7 <cprintf>
  800794:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800797:	e8 68 1b 00 00       	call   802304 <sys_calculate_free_frames>
  80079c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80079f:	e8 00 1c 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  8007c9:	68 20 43 80 00       	push   $0x804320
  8007ce:	68 a3 00 00 00       	push   $0xa3
  8007d3:	68 5c 41 80 00       	push   $0x80415c
  8007d8:	e8 16 06 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8007dd:	e8 c2 1b 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  800800:	68 76 42 80 00       	push   $0x804276
  800805:	68 a4 00 00 00       	push   $0xa4
  80080a:	68 5c 41 80 00       	push   $0x80415c
  80080f:	e8 df 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800814:	e8 eb 1a 00 00       	call   802304 <sys_calculate_free_frames>
  800819:	89 c2                	mov    %eax,%edx
  80081b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 17                	je     800839 <_main+0x801>
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 93 42 80 00       	push   $0x804293
  80082a:	68 a5 00 00 00       	push   $0xa5
  80082f:	68 5c 41 80 00       	push   $0x80415c
  800834:	e8 ba 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800839:	ff 45 d0             	incl   -0x30(%ebp)
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 d0             	pushl  -0x30(%ebp)
  800842:	68 40 43 80 00       	push   $0x804340
  800847:	e8 5b 08 00 00       	call   8010a7 <cprintf>
  80084c:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  80084f:	e8 b0 1a 00 00       	call   802304 <sys_calculate_free_frames>
  800854:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800857:	e8 48 1b 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  800880:	68 20 43 80 00       	push   $0x804320
  800885:	68 ac 00 00 00       	push   $0xac
  80088a:	68 5c 41 80 00       	push   $0x80415c
  80088f:	e8 5f 05 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800894:	e8 0b 1b 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  8008b6:	68 76 42 80 00       	push   $0x804276
  8008bb:	68 ad 00 00 00       	push   $0xad
  8008c0:	68 5c 41 80 00       	push   $0x80415c
  8008c5:	e8 29 05 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8008ca:	e8 35 1a 00 00       	call   802304 <sys_calculate_free_frames>
  8008cf:	89 c2                	mov    %eax,%edx
  8008d1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008d4:	39 c2                	cmp    %eax,%edx
  8008d6:	74 17                	je     8008ef <_main+0x8b7>
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 93 42 80 00       	push   $0x804293
  8008e0:	68 ae 00 00 00       	push   $0xae
  8008e5:	68 5c 41 80 00       	push   $0x80415c
  8008ea:	e8 04 05 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8008ef:	ff 45 d0             	incl   -0x30(%ebp)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	ff 75 d0             	pushl  -0x30(%ebp)
  8008f8:	68 40 43 80 00       	push   $0x804340
  8008fd:	e8 a5 07 00 00       	call   8010a7 <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800905:	e8 fa 19 00 00       	call   802304 <sys_calculate_free_frames>
  80090a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80090d:	e8 92 1a 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  80093e:	68 20 43 80 00       	push   $0x804320
  800943:	68 b5 00 00 00       	push   $0xb5
  800948:	68 5c 41 80 00       	push   $0x80415c
  80094d:	e8 a1 04 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega + 512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800952:	e8 4d 1a 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  80097c:	68 76 42 80 00       	push   $0x804276
  800981:	68 b6 00 00 00       	push   $0xb6
  800986:	68 5c 41 80 00       	push   $0x80415c
  80098b:	e8 63 04 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800990:	e8 6f 19 00 00       	call   802304 <sys_calculate_free_frames>
  800995:	89 c2                	mov    %eax,%edx
  800997:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80099a:	39 c2                	cmp    %eax,%edx
  80099c:	74 17                	je     8009b5 <_main+0x97d>
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	68 93 42 80 00       	push   $0x804293
  8009a6:	68 b7 00 00 00       	push   $0xb7
  8009ab:	68 5c 41 80 00       	push   $0x80415c
  8009b0:	e8 3e 04 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  8009b5:	ff 45 d0             	incl   -0x30(%ebp)
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8009be:	68 40 43 80 00       	push   $0x804340
  8009c3:	e8 df 06 00 00       	call   8010a7 <cprintf>
  8009c8:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  8009cb:	e8 34 19 00 00       	call   802304 <sys_calculate_free_frames>
  8009d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8009d3:	e8 cc 19 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  8009fd:	68 20 43 80 00       	push   $0x804320
  800a02:	68 be 00 00 00       	push   $0xbe
  800a07:	68 5c 41 80 00       	push   $0x80415c
  800a0c:	e8 e2 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800a11:	e8 8e 19 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  800a34:	68 76 42 80 00       	push   $0x804276
  800a39:	68 bf 00 00 00       	push   $0xbf
  800a3e:	68 5c 41 80 00       	push   $0x80415c
  800a43:	e8 ab 03 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800a48:	e8 b7 18 00 00       	call   802304 <sys_calculate_free_frames>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a52:	39 c2                	cmp    %eax,%edx
  800a54:	74 17                	je     800a6d <_main+0xa35>
  800a56:	83 ec 04             	sub    $0x4,%esp
  800a59:	68 93 42 80 00       	push   $0x804293
  800a5e:	68 c0 00 00 00       	push   $0xc0
  800a63:	68 5c 41 80 00       	push   $0x80415c
  800a68:	e8 86 03 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800a6d:	ff 45 d0             	incl   -0x30(%ebp)
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 d0             	pushl  -0x30(%ebp)
  800a76:	68 40 43 80 00       	push   $0x804340
  800a7b:	e8 27 06 00 00       	call   8010a7 <cprintf>
  800a80:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 7c 18 00 00       	call   802304 <sys_calculate_free_frames>
  800a88:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 14 19 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  800ab2:	68 20 43 80 00       	push   $0x804320
  800ab7:	68 c7 00 00 00       	push   $0xc7
  800abc:	68 5c 41 80 00       	push   $0x80415c
  800ac1:	e8 2d 03 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800ac6:	e8 d9 18 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  800ae9:	68 76 42 80 00       	push   $0x804276
  800aee:	68 c8 00 00 00       	push   $0xc8
  800af3:	68 5c 41 80 00       	push   $0x80415c
  800af8:	e8 f6 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800afd:	e8 02 18 00 00       	call   802304 <sys_calculate_free_frames>
  800b02:	89 c2                	mov    %eax,%edx
  800b04:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b07:	39 c2                	cmp    %eax,%edx
  800b09:	74 17                	je     800b22 <_main+0xaea>
  800b0b:	83 ec 04             	sub    $0x4,%esp
  800b0e:	68 93 42 80 00       	push   $0x804293
  800b13:	68 c9 00 00 00       	push   $0xc9
  800b18:	68 5c 41 80 00       	push   $0x80415c
  800b1d:	e8 d1 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800b22:	ff 45 d0             	incl   -0x30(%ebp)
  800b25:	83 ec 08             	sub    $0x8,%esp
  800b28:	ff 75 d0             	pushl  -0x30(%ebp)
  800b2b:	68 40 43 80 00       	push   $0x804340
  800b30:	e8 72 05 00 00       	call   8010a7 <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp

	freeFrames = sys_calculate_free_frames() ;
  800b38:	e8 c7 17 00 00       	call   802304 <sys_calculate_free_frames>
  800b3d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b40:	e8 5f 18 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  800b72:	68 20 43 80 00       	push   $0x804320
  800b77:	68 d0 00 00 00       	push   $0xd0
  800b7c:	68 5c 41 80 00       	push   $0x80415c
  800b81:	e8 6d 02 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (2*Mega - 4*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800b86:	e8 19 18 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  800bb1:	68 76 42 80 00       	push   $0x804276
  800bb6:	68 d1 00 00 00       	push   $0xd1
  800bbb:	68 5c 41 80 00       	push   $0x80415c
  800bc0:	e8 2e 02 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800bc5:	e8 3a 17 00 00       	call   802304 <sys_calculate_free_frames>
  800bca:	89 c2                	mov    %eax,%edx
  800bcc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	74 17                	je     800bea <_main+0xbb2>
  800bd3:	83 ec 04             	sub    $0x4,%esp
  800bd6:	68 93 42 80 00       	push   $0x804293
  800bdb:	68 d2 00 00 00       	push   $0xd2
  800be0:	68 5c 41 80 00       	push   $0x80415c
  800be5:	e8 09 02 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800bea:	ff 45 d0             	incl   -0x30(%ebp)
  800bed:	83 ec 08             	sub    $0x8,%esp
  800bf0:	ff 75 d0             	pushl  -0x30(%ebp)
  800bf3:	68 40 43 80 00       	push   $0x804340
  800bf8:	e8 aa 04 00 00       	call   8010a7 <cprintf>
  800bfd:	83 c4 10             	add    $0x10,%esp

	// Check that worst fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800c00:	e8 ff 16 00 00       	call   802304 <sys_calculate_free_frames>
  800c05:	89 45 c0             	mov    %eax,-0x40(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800c08:	e8 97 17 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
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
  800c2f:	68 20 43 80 00       	push   $0x804320
  800c34:	68 da 00 00 00       	push   $0xda
  800c39:	68 5c 41 80 00       	push   $0x80415c
  800c3e:	e8 b0 01 00 00       	call   800df3 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c43:	e8 5c 17 00 00       	call   8023a4 <sys_pf_calculate_allocated_pages>
  800c48:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800c4b:	74 17                	je     800c64 <_main+0xc2c>
  800c4d:	83 ec 04             	sub    $0x4,%esp
  800c50:	68 76 42 80 00       	push   $0x804276
  800c55:	68 db 00 00 00       	push   $0xdb
  800c5a:	68 5c 41 80 00       	push   $0x80415c
  800c5f:	e8 8f 01 00 00       	call   800df3 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800c64:	e8 9b 16 00 00       	call   802304 <sys_calculate_free_frames>
  800c69:	89 c2                	mov    %eax,%edx
  800c6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6e:	39 c2                	cmp    %eax,%edx
  800c70:	74 17                	je     800c89 <_main+0xc51>
  800c72:	83 ec 04             	sub    $0x4,%esp
  800c75:	68 93 42 80 00       	push   $0x804293
  800c7a:	68 dc 00 00 00       	push   $0xdc
  800c7f:	68 5c 41 80 00       	push   $0x80415c
  800c84:	e8 6a 01 00 00       	call   800df3 <_panic>
	cprintf("Test %d Passed \n", ++count);
  800c89:	ff 45 d0             	incl   -0x30(%ebp)
  800c8c:	83 ec 08             	sub    $0x8,%esp
  800c8f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c92:	68 40 43 80 00       	push   $0x804340
  800c97:	e8 0b 04 00 00       	call   8010a7 <cprintf>
  800c9c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Worst Fit completed successfully.\n");
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	68 54 43 80 00       	push   $0x804354
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
  800cbd:	e8 22 19 00 00       	call   8025e4 <sys_getenvindex>
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
  800d28:	e8 c4 16 00 00       	call   8023f1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800d2d:	83 ec 0c             	sub    $0xc,%esp
  800d30:	68 a8 43 80 00       	push   $0x8043a8
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
  800d58:	68 d0 43 80 00       	push   $0x8043d0
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
  800d89:	68 f8 43 80 00       	push   $0x8043f8
  800d8e:	e8 14 03 00 00       	call   8010a7 <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800d96:	a1 20 50 80 00       	mov    0x805020,%eax
  800d9b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	50                   	push   %eax
  800da5:	68 50 44 80 00       	push   $0x804450
  800daa:	e8 f8 02 00 00       	call   8010a7 <cprintf>
  800daf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	68 a8 43 80 00       	push   $0x8043a8
  800dba:	e8 e8 02 00 00       	call   8010a7 <cprintf>
  800dbf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800dc2:	e8 44 16 00 00       	call   80240b <sys_enable_interrupt>

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
  800dda:	e8 d1 17 00 00       	call   8025b0 <sys_destroy_env>
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
  800deb:	e8 26 18 00 00       	call   802616 <sys_exit_env>
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
  800e14:	68 64 44 80 00       	push   $0x804464
  800e19:	e8 89 02 00 00       	call   8010a7 <cprintf>
  800e1e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800e21:	a1 00 50 80 00       	mov    0x805000,%eax
  800e26:	ff 75 0c             	pushl  0xc(%ebp)
  800e29:	ff 75 08             	pushl  0x8(%ebp)
  800e2c:	50                   	push   %eax
  800e2d:	68 69 44 80 00       	push   $0x804469
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
  800e51:	68 85 44 80 00       	push   $0x804485
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
  800e7d:	68 88 44 80 00       	push   $0x804488
  800e82:	6a 26                	push   $0x26
  800e84:	68 d4 44 80 00       	push   $0x8044d4
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
  800f4f:	68 e0 44 80 00       	push   $0x8044e0
  800f54:	6a 3a                	push   $0x3a
  800f56:	68 d4 44 80 00       	push   $0x8044d4
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
  800fbf:	68 34 45 80 00       	push   $0x804534
  800fc4:	6a 44                	push   $0x44
  800fc6:	68 d4 44 80 00       	push   $0x8044d4
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
  801019:	e8 25 12 00 00       	call   802243 <sys_cputs>
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
  801090:	e8 ae 11 00 00       	call   802243 <sys_cputs>
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
  8010da:	e8 12 13 00 00       	call   8023f1 <sys_disable_interrupt>
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
  8010fa:	e8 0c 13 00 00       	call   80240b <sys_enable_interrupt>
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
  801144:	e8 7f 2d 00 00       	call   803ec8 <__udivdi3>
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
  801194:	e8 3f 2e 00 00       	call   803fd8 <__umoddi3>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	05 94 47 80 00       	add    $0x804794,%eax
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
  8012ef:	8b 04 85 b8 47 80 00 	mov    0x8047b8(,%eax,4),%eax
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
  8013d0:	8b 34 9d 00 46 80 00 	mov    0x804600(,%ebx,4),%esi
  8013d7:	85 f6                	test   %esi,%esi
  8013d9:	75 19                	jne    8013f4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8013db:	53                   	push   %ebx
  8013dc:	68 a5 47 80 00       	push   $0x8047a5
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
  8013f5:	68 ae 47 80 00       	push   $0x8047ae
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
  801422:	be b1 47 80 00       	mov    $0x8047b1,%esi
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
  801e48:	68 10 49 80 00       	push   $0x804910
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
  801f18:	e8 6a 04 00 00       	call   802387 <sys_allocate_chunk>
  801f1d:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801f20:	a1 20 51 80 00       	mov    0x805120,%eax
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	50                   	push   %eax
  801f29:	e8 df 0a 00 00       	call   802a0d <initialize_MemBlocksList>
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
  801f56:	68 35 49 80 00       	push   $0x804935
  801f5b:	6a 33                	push   $0x33
  801f5d:	68 53 49 80 00       	push   $0x804953
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
  801fd5:	68 60 49 80 00       	push   $0x804960
  801fda:	6a 34                	push   $0x34
  801fdc:	68 53 49 80 00       	push   $0x804953
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
  80206d:	e8 e3 06 00 00       	call   802755 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802072:	85 c0                	test   %eax,%eax
  802074:	74 11                	je     802087 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  802076:	83 ec 0c             	sub    $0xc,%esp
  802079:	ff 75 e8             	pushl  -0x18(%ebp)
  80207c:	e8 4e 0d 00 00       	call   802dcf <alloc_block_FF>
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
  802093:	e8 aa 0a 00 00       	call   802b42 <insert_sorted_allocList>
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
  8020b3:	68 84 49 80 00       	push   $0x804984
  8020b8:	6a 6f                	push   $0x6f
  8020ba:	68 53 49 80 00       	push   $0x804953
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
  8020d9:	75 07                	jne    8020e2 <smalloc+0x1e>
  8020db:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e0:	eb 7c                	jmp    80215e <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8020e2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8020e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ef:	01 d0                	add    %edx,%eax
  8020f1:	48                   	dec    %eax
  8020f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8020fd:	f7 75 f0             	divl   -0x10(%ebp)
  802100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802103:	29 d0                	sub    %edx,%eax
  802105:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802108:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80210f:	e8 41 06 00 00       	call   802755 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802114:	85 c0                	test   %eax,%eax
  802116:	74 11                	je     802129 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  802118:	83 ec 0c             	sub    $0xc,%esp
  80211b:	ff 75 e8             	pushl  -0x18(%ebp)
  80211e:	e8 ac 0c 00 00       	call   802dcf <alloc_block_FF>
  802123:	83 c4 10             	add    $0x10,%esp
  802126:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  802129:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212d:	74 2a                	je     802159 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	8b 40 08             	mov    0x8(%eax),%eax
  802135:	89 c2                	mov    %eax,%edx
  802137:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80213b:	52                   	push   %edx
  80213c:	50                   	push   %eax
  80213d:	ff 75 0c             	pushl  0xc(%ebp)
  802140:	ff 75 08             	pushl  0x8(%ebp)
  802143:	e8 92 03 00 00       	call   8024da <sys_createSharedObject>
  802148:	83 c4 10             	add    $0x10,%esp
  80214b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80214e:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  802152:	74 05                	je     802159 <smalloc+0x95>
			return (void*)virtual_address;
  802154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802157:	eb 05                	jmp    80215e <smalloc+0x9a>
	}
	return NULL;
  802159:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802166:	e8 c6 fc ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80216b:	83 ec 04             	sub    $0x4,%esp
  80216e:	68 a8 49 80 00       	push   $0x8049a8
  802173:	68 b0 00 00 00       	push   $0xb0
  802178:	68 53 49 80 00       	push   $0x804953
  80217d:	e8 71 ec ff ff       	call   800df3 <_panic>

00802182 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802188:	e8 a4 fc ff ff       	call   801e31 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80218d:	83 ec 04             	sub    $0x4,%esp
  802190:	68 cc 49 80 00       	push   $0x8049cc
  802195:	68 f4 00 00 00       	push   $0xf4
  80219a:	68 53 49 80 00       	push   $0x804953
  80219f:	e8 4f ec ff ff       	call   800df3 <_panic>

008021a4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8021aa:	83 ec 04             	sub    $0x4,%esp
  8021ad:	68 f4 49 80 00       	push   $0x8049f4
  8021b2:	68 08 01 00 00       	push   $0x108
  8021b7:	68 53 49 80 00       	push   $0x804953
  8021bc:	e8 32 ec ff ff       	call   800df3 <_panic>

008021c1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8021c1:	55                   	push   %ebp
  8021c2:	89 e5                	mov    %esp,%ebp
  8021c4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	68 18 4a 80 00       	push   $0x804a18
  8021cf:	68 13 01 00 00       	push   $0x113
  8021d4:	68 53 49 80 00       	push   $0x804953
  8021d9:	e8 15 ec ff ff       	call   800df3 <_panic>

008021de <shrink>:

}
void shrink(uint32 newSize)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021e4:	83 ec 04             	sub    $0x4,%esp
  8021e7:	68 18 4a 80 00       	push   $0x804a18
  8021ec:	68 18 01 00 00       	push   $0x118
  8021f1:	68 53 49 80 00       	push   $0x804953
  8021f6:	e8 f8 eb ff ff       	call   800df3 <_panic>

008021fb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802201:	83 ec 04             	sub    $0x4,%esp
  802204:	68 18 4a 80 00       	push   $0x804a18
  802209:	68 1d 01 00 00       	push   $0x11d
  80220e:	68 53 49 80 00       	push   $0x804953
  802213:	e8 db eb ff ff       	call   800df3 <_panic>

00802218 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	57                   	push   %edi
  80221c:	56                   	push   %esi
  80221d:	53                   	push   %ebx
  80221e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	8b 55 0c             	mov    0xc(%ebp),%edx
  802227:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80222a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80222d:	8b 7d 18             	mov    0x18(%ebp),%edi
  802230:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802233:	cd 30                	int    $0x30
  802235:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80223b:	83 c4 10             	add    $0x10,%esp
  80223e:	5b                   	pop    %ebx
  80223f:	5e                   	pop    %esi
  802240:	5f                   	pop    %edi
  802241:	5d                   	pop    %ebp
  802242:	c3                   	ret    

00802243 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
  802246:	83 ec 04             	sub    $0x4,%esp
  802249:	8b 45 10             	mov    0x10(%ebp),%eax
  80224c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80224f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	52                   	push   %edx
  80225b:	ff 75 0c             	pushl  0xc(%ebp)
  80225e:	50                   	push   %eax
  80225f:	6a 00                	push   $0x0
  802261:	e8 b2 ff ff ff       	call   802218 <syscall>
  802266:	83 c4 18             	add    $0x18,%esp
}
  802269:	90                   	nop
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <sys_cgetc>:

int
sys_cgetc(void)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 01                	push   $0x1
  80227b:	e8 98 ff ff ff       	call   802218 <syscall>
  802280:	83 c4 18             	add    $0x18,%esp
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802288:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	52                   	push   %edx
  802295:	50                   	push   %eax
  802296:	6a 05                	push   $0x5
  802298:	e8 7b ff ff ff       	call   802218 <syscall>
  80229d:	83 c4 18             	add    $0x18,%esp
}
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	56                   	push   %esi
  8022a6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022a7:	8b 75 18             	mov    0x18(%ebp),%esi
  8022aa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	56                   	push   %esi
  8022b7:	53                   	push   %ebx
  8022b8:	51                   	push   %ecx
  8022b9:	52                   	push   %edx
  8022ba:	50                   	push   %eax
  8022bb:	6a 06                	push   $0x6
  8022bd:	e8 56 ff ff ff       	call   802218 <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022c8:	5b                   	pop    %ebx
  8022c9:	5e                   	pop    %esi
  8022ca:	5d                   	pop    %ebp
  8022cb:	c3                   	ret    

008022cc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	52                   	push   %edx
  8022dc:	50                   	push   %eax
  8022dd:	6a 07                	push   $0x7
  8022df:	e8 34 ff ff ff       	call   802218 <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	ff 75 0c             	pushl  0xc(%ebp)
  8022f5:	ff 75 08             	pushl  0x8(%ebp)
  8022f8:	6a 08                	push   $0x8
  8022fa:	e8 19 ff ff ff       	call   802218 <syscall>
  8022ff:	83 c4 18             	add    $0x18,%esp
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 09                	push   $0x9
  802313:	e8 00 ff ff ff       	call   802218 <syscall>
  802318:	83 c4 18             	add    $0x18,%esp
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 0a                	push   $0xa
  80232c:	e8 e7 fe ff ff       	call   802218 <syscall>
  802331:	83 c4 18             	add    $0x18,%esp
}
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 0b                	push   $0xb
  802345:	e8 ce fe ff ff       	call   802218 <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	ff 75 0c             	pushl  0xc(%ebp)
  80235b:	ff 75 08             	pushl  0x8(%ebp)
  80235e:	6a 0f                	push   $0xf
  802360:	e8 b3 fe ff ff       	call   802218 <syscall>
  802365:	83 c4 18             	add    $0x18,%esp
	return;
  802368:	90                   	nop
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	ff 75 0c             	pushl  0xc(%ebp)
  802377:	ff 75 08             	pushl  0x8(%ebp)
  80237a:	6a 10                	push   $0x10
  80237c:	e8 97 fe ff ff       	call   802218 <syscall>
  802381:	83 c4 18             	add    $0x18,%esp
	return ;
  802384:	90                   	nop
}
  802385:	c9                   	leave  
  802386:	c3                   	ret    

00802387 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	ff 75 10             	pushl  0x10(%ebp)
  802391:	ff 75 0c             	pushl  0xc(%ebp)
  802394:	ff 75 08             	pushl  0x8(%ebp)
  802397:	6a 11                	push   $0x11
  802399:	e8 7a fe ff ff       	call   802218 <syscall>
  80239e:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a1:	90                   	nop
}
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 0c                	push   $0xc
  8023b3:	e8 60 fe ff ff       	call   802218 <syscall>
  8023b8:	83 c4 18             	add    $0x18,%esp
}
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	ff 75 08             	pushl  0x8(%ebp)
  8023cb:	6a 0d                	push   $0xd
  8023cd:	e8 46 fe ff ff       	call   802218 <syscall>
  8023d2:	83 c4 18             	add    $0x18,%esp
}
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

008023d7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 0e                	push   $0xe
  8023e6:	e8 2d fe ff ff       	call   802218 <syscall>
  8023eb:	83 c4 18             	add    $0x18,%esp
}
  8023ee:	90                   	nop
  8023ef:	c9                   	leave  
  8023f0:	c3                   	ret    

008023f1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 13                	push   $0x13
  802400:	e8 13 fe ff ff       	call   802218 <syscall>
  802405:	83 c4 18             	add    $0x18,%esp
}
  802408:	90                   	nop
  802409:	c9                   	leave  
  80240a:	c3                   	ret    

0080240b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 14                	push   $0x14
  80241a:	e8 f9 fd ff ff       	call   802218 <syscall>
  80241f:	83 c4 18             	add    $0x18,%esp
}
  802422:	90                   	nop
  802423:	c9                   	leave  
  802424:	c3                   	ret    

00802425 <sys_cputc>:


void
sys_cputc(const char c)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
  802428:	83 ec 04             	sub    $0x4,%esp
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802431:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	50                   	push   %eax
  80243e:	6a 15                	push   $0x15
  802440:	e8 d3 fd ff ff       	call   802218 <syscall>
  802445:	83 c4 18             	add    $0x18,%esp
}
  802448:	90                   	nop
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 16                	push   $0x16
  80245a:	e8 b9 fd ff ff       	call   802218 <syscall>
  80245f:	83 c4 18             	add    $0x18,%esp
}
  802462:	90                   	nop
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	ff 75 0c             	pushl  0xc(%ebp)
  802474:	50                   	push   %eax
  802475:	6a 17                	push   $0x17
  802477:	e8 9c fd ff ff       	call   802218 <syscall>
  80247c:	83 c4 18             	add    $0x18,%esp
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802484:	8b 55 0c             	mov    0xc(%ebp),%edx
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	6a 00                	push   $0x0
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	52                   	push   %edx
  802491:	50                   	push   %eax
  802492:	6a 1a                	push   $0x1a
  802494:	e8 7f fd ff ff       	call   802218 <syscall>
  802499:	83 c4 18             	add    $0x18,%esp
}
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	52                   	push   %edx
  8024ae:	50                   	push   %eax
  8024af:	6a 18                	push   $0x18
  8024b1:	e8 62 fd ff ff       	call   802218 <syscall>
  8024b6:	83 c4 18             	add    $0x18,%esp
}
  8024b9:	90                   	nop
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	52                   	push   %edx
  8024cc:	50                   	push   %eax
  8024cd:	6a 19                	push   $0x19
  8024cf:	e8 44 fd ff ff       	call   802218 <syscall>
  8024d4:	83 c4 18             	add    $0x18,%esp
}
  8024d7:	90                   	nop
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 04             	sub    $0x4,%esp
  8024e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024e6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024e9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	6a 00                	push   $0x0
  8024f2:	51                   	push   %ecx
  8024f3:	52                   	push   %edx
  8024f4:	ff 75 0c             	pushl  0xc(%ebp)
  8024f7:	50                   	push   %eax
  8024f8:	6a 1b                	push   $0x1b
  8024fa:	e8 19 fd ff ff       	call   802218 <syscall>
  8024ff:	83 c4 18             	add    $0x18,%esp
}
  802502:	c9                   	leave  
  802503:	c3                   	ret    

00802504 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802507:	8b 55 0c             	mov    0xc(%ebp),%edx
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	52                   	push   %edx
  802514:	50                   	push   %eax
  802515:	6a 1c                	push   $0x1c
  802517:	e8 fc fc ff ff       	call   802218 <syscall>
  80251c:	83 c4 18             	add    $0x18,%esp
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802524:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802527:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	51                   	push   %ecx
  802532:	52                   	push   %edx
  802533:	50                   	push   %eax
  802534:	6a 1d                	push   $0x1d
  802536:	e8 dd fc ff ff       	call   802218 <syscall>
  80253b:	83 c4 18             	add    $0x18,%esp
}
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    

00802540 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802543:	8b 55 0c             	mov    0xc(%ebp),%edx
  802546:	8b 45 08             	mov    0x8(%ebp),%eax
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	52                   	push   %edx
  802550:	50                   	push   %eax
  802551:	6a 1e                	push   $0x1e
  802553:	e8 c0 fc ff ff       	call   802218 <syscall>
  802558:	83 c4 18             	add    $0x18,%esp
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	6a 00                	push   $0x0
  802568:	6a 00                	push   $0x0
  80256a:	6a 1f                	push   $0x1f
  80256c:	e8 a7 fc ff ff       	call   802218 <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	6a 00                	push   $0x0
  80257e:	ff 75 14             	pushl  0x14(%ebp)
  802581:	ff 75 10             	pushl  0x10(%ebp)
  802584:	ff 75 0c             	pushl  0xc(%ebp)
  802587:	50                   	push   %eax
  802588:	6a 20                	push   $0x20
  80258a:	e8 89 fc ff ff       	call   802218 <syscall>
  80258f:	83 c4 18             	add    $0x18,%esp
}
  802592:	c9                   	leave  
  802593:	c3                   	ret    

00802594 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802594:	55                   	push   %ebp
  802595:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	50                   	push   %eax
  8025a3:	6a 21                	push   $0x21
  8025a5:	e8 6e fc ff ff       	call   802218 <syscall>
  8025aa:	83 c4 18             	add    $0x18,%esp
}
  8025ad:	90                   	nop
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	50                   	push   %eax
  8025bf:	6a 22                	push   $0x22
  8025c1:	e8 52 fc ff ff       	call   802218 <syscall>
  8025c6:	83 c4 18             	add    $0x18,%esp
}
  8025c9:	c9                   	leave  
  8025ca:	c3                   	ret    

008025cb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 02                	push   $0x2
  8025da:	e8 39 fc ff ff       	call   802218 <syscall>
  8025df:	83 c4 18             	add    $0x18,%esp
}
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 03                	push   $0x3
  8025f3:	e8 20 fc ff ff       	call   802218 <syscall>
  8025f8:	83 c4 18             	add    $0x18,%esp
}
  8025fb:	c9                   	leave  
  8025fc:	c3                   	ret    

008025fd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025fd:	55                   	push   %ebp
  8025fe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 04                	push   $0x4
  80260c:	e8 07 fc ff ff       	call   802218 <syscall>
  802611:	83 c4 18             	add    $0x18,%esp
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <sys_exit_env>:


void sys_exit_env(void)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 23                	push   $0x23
  802625:	e8 ee fb ff ff       	call   802218 <syscall>
  80262a:	83 c4 18             	add    $0x18,%esp
}
  80262d:	90                   	nop
  80262e:	c9                   	leave  
  80262f:	c3                   	ret    

00802630 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802636:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802639:	8d 50 04             	lea    0x4(%eax),%edx
  80263c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	52                   	push   %edx
  802646:	50                   	push   %eax
  802647:	6a 24                	push   $0x24
  802649:	e8 ca fb ff ff       	call   802218 <syscall>
  80264e:	83 c4 18             	add    $0x18,%esp
	return result;
  802651:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802654:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802657:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80265a:	89 01                	mov    %eax,(%ecx)
  80265c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	c9                   	leave  
  802663:	c2 04 00             	ret    $0x4

00802666 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802669:	6a 00                	push   $0x0
  80266b:	6a 00                	push   $0x0
  80266d:	ff 75 10             	pushl  0x10(%ebp)
  802670:	ff 75 0c             	pushl  0xc(%ebp)
  802673:	ff 75 08             	pushl  0x8(%ebp)
  802676:	6a 12                	push   $0x12
  802678:	e8 9b fb ff ff       	call   802218 <syscall>
  80267d:	83 c4 18             	add    $0x18,%esp
	return ;
  802680:	90                   	nop
}
  802681:	c9                   	leave  
  802682:	c3                   	ret    

00802683 <sys_rcr2>:
uint32 sys_rcr2()
{
  802683:	55                   	push   %ebp
  802684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 25                	push   $0x25
  802692:	e8 81 fb ff ff       	call   802218 <syscall>
  802697:	83 c4 18             	add    $0x18,%esp
}
  80269a:	c9                   	leave  
  80269b:	c3                   	ret    

0080269c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
  80269f:	83 ec 04             	sub    $0x4,%esp
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026a8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	50                   	push   %eax
  8026b5:	6a 26                	push   $0x26
  8026b7:	e8 5c fb ff ff       	call   802218 <syscall>
  8026bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8026bf:	90                   	nop
}
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

008026c2 <rsttst>:
void rsttst()
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 00                	push   $0x0
  8026c9:	6a 00                	push   $0x0
  8026cb:	6a 00                	push   $0x0
  8026cd:	6a 00                	push   $0x0
  8026cf:	6a 28                	push   $0x28
  8026d1:	e8 42 fb ff ff       	call   802218 <syscall>
  8026d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d9:	90                   	nop
}
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	83 ec 04             	sub    $0x4,%esp
  8026e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8026e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026e8:	8b 55 18             	mov    0x18(%ebp),%edx
  8026eb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026ef:	52                   	push   %edx
  8026f0:	50                   	push   %eax
  8026f1:	ff 75 10             	pushl  0x10(%ebp)
  8026f4:	ff 75 0c             	pushl  0xc(%ebp)
  8026f7:	ff 75 08             	pushl  0x8(%ebp)
  8026fa:	6a 27                	push   $0x27
  8026fc:	e8 17 fb ff ff       	call   802218 <syscall>
  802701:	83 c4 18             	add    $0x18,%esp
	return ;
  802704:	90                   	nop
}
  802705:	c9                   	leave  
  802706:	c3                   	ret    

00802707 <chktst>:
void chktst(uint32 n)
{
  802707:	55                   	push   %ebp
  802708:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 00                	push   $0x0
  802712:	ff 75 08             	pushl  0x8(%ebp)
  802715:	6a 29                	push   $0x29
  802717:	e8 fc fa ff ff       	call   802218 <syscall>
  80271c:	83 c4 18             	add    $0x18,%esp
	return ;
  80271f:	90                   	nop
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <inctst>:

void inctst()
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	6a 2a                	push   $0x2a
  802731:	e8 e2 fa ff ff       	call   802218 <syscall>
  802736:	83 c4 18             	add    $0x18,%esp
	return ;
  802739:	90                   	nop
}
  80273a:	c9                   	leave  
  80273b:	c3                   	ret    

0080273c <gettst>:
uint32 gettst()
{
  80273c:	55                   	push   %ebp
  80273d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 00                	push   $0x0
  802745:	6a 00                	push   $0x0
  802747:	6a 00                	push   $0x0
  802749:	6a 2b                	push   $0x2b
  80274b:	e8 c8 fa ff ff       	call   802218 <syscall>
  802750:	83 c4 18             	add    $0x18,%esp
}
  802753:	c9                   	leave  
  802754:	c3                   	ret    

00802755 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
  802758:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80275b:	6a 00                	push   $0x0
  80275d:	6a 00                	push   $0x0
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 2c                	push   $0x2c
  802767:	e8 ac fa ff ff       	call   802218 <syscall>
  80276c:	83 c4 18             	add    $0x18,%esp
  80276f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802772:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802776:	75 07                	jne    80277f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802778:	b8 01 00 00 00       	mov    $0x1,%eax
  80277d:	eb 05                	jmp    802784 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 2c                	push   $0x2c
  802798:	e8 7b fa ff ff       	call   802218 <syscall>
  80279d:	83 c4 18             	add    $0x18,%esp
  8027a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8027a3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8027a7:	75 07                	jne    8027b0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ae:	eb 05                	jmp    8027b5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 2c                	push   $0x2c
  8027c9:	e8 4a fa ff ff       	call   802218 <syscall>
  8027ce:	83 c4 18             	add    $0x18,%esp
  8027d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027d4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027d8:	75 07                	jne    8027e1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027da:	b8 01 00 00 00       	mov    $0x1,%eax
  8027df:	eb 05                	jmp    8027e6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e6:	c9                   	leave  
  8027e7:	c3                   	ret    

008027e8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
  8027eb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027ee:	6a 00                	push   $0x0
  8027f0:	6a 00                	push   $0x0
  8027f2:	6a 00                	push   $0x0
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 2c                	push   $0x2c
  8027fa:	e8 19 fa ff ff       	call   802218 <syscall>
  8027ff:	83 c4 18             	add    $0x18,%esp
  802802:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802805:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802809:	75 07                	jne    802812 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80280b:	b8 01 00 00 00       	mov    $0x1,%eax
  802810:	eb 05                	jmp    802817 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802812:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802817:	c9                   	leave  
  802818:	c3                   	ret    

00802819 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80281c:	6a 00                	push   $0x0
  80281e:	6a 00                	push   $0x0
  802820:	6a 00                	push   $0x0
  802822:	6a 00                	push   $0x0
  802824:	ff 75 08             	pushl  0x8(%ebp)
  802827:	6a 2d                	push   $0x2d
  802829:	e8 ea f9 ff ff       	call   802218 <syscall>
  80282e:	83 c4 18             	add    $0x18,%esp
	return ;
  802831:	90                   	nop
}
  802832:	c9                   	leave  
  802833:	c3                   	ret    

00802834 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802834:	55                   	push   %ebp
  802835:	89 e5                	mov    %esp,%ebp
  802837:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802838:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80283b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80283e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802841:	8b 45 08             	mov    0x8(%ebp),%eax
  802844:	6a 00                	push   $0x0
  802846:	53                   	push   %ebx
  802847:	51                   	push   %ecx
  802848:	52                   	push   %edx
  802849:	50                   	push   %eax
  80284a:	6a 2e                	push   $0x2e
  80284c:	e8 c7 f9 ff ff       	call   802218 <syscall>
  802851:	83 c4 18             	add    $0x18,%esp
}
  802854:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802857:	c9                   	leave  
  802858:	c3                   	ret    

00802859 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802859:	55                   	push   %ebp
  80285a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80285c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	52                   	push   %edx
  802869:	50                   	push   %eax
  80286a:	6a 2f                	push   $0x2f
  80286c:	e8 a7 f9 ff ff       	call   802218 <syscall>
  802871:	83 c4 18             	add    $0x18,%esp
}
  802874:	c9                   	leave  
  802875:	c3                   	ret    

00802876 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
  802879:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80287c:	83 ec 0c             	sub    $0xc,%esp
  80287f:	68 28 4a 80 00       	push   $0x804a28
  802884:	e8 1e e8 ff ff       	call   8010a7 <cprintf>
  802889:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80288c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802893:	83 ec 0c             	sub    $0xc,%esp
  802896:	68 54 4a 80 00       	push   $0x804a54
  80289b:	e8 07 e8 ff ff       	call   8010a7 <cprintf>
  8028a0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8028a3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028a7:	a1 38 51 80 00       	mov    0x805138,%eax
  8028ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028af:	eb 56                	jmp    802907 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b5:	74 1c                	je     8028d3 <print_mem_block_lists+0x5d>
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 50 08             	mov    0x8(%eax),%edx
  8028bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c0:	8b 48 08             	mov    0x8(%eax),%ecx
  8028c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c9:	01 c8                	add    %ecx,%eax
  8028cb:	39 c2                	cmp    %eax,%edx
  8028cd:	73 04                	jae    8028d3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8028cf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 50 08             	mov    0x8(%eax),%edx
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028df:	01 c2                	add    %eax,%edx
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	8b 40 08             	mov    0x8(%eax),%eax
  8028e7:	83 ec 04             	sub    $0x4,%esp
  8028ea:	52                   	push   %edx
  8028eb:	50                   	push   %eax
  8028ec:	68 69 4a 80 00       	push   $0x804a69
  8028f1:	e8 b1 e7 ff ff       	call   8010a7 <cprintf>
  8028f6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028ff:	a1 40 51 80 00       	mov    0x805140,%eax
  802904:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290b:	74 07                	je     802914 <print_mem_block_lists+0x9e>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	eb 05                	jmp    802919 <print_mem_block_lists+0xa3>
  802914:	b8 00 00 00 00       	mov    $0x0,%eax
  802919:	a3 40 51 80 00       	mov    %eax,0x805140
  80291e:	a1 40 51 80 00       	mov    0x805140,%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	75 8a                	jne    8028b1 <print_mem_block_lists+0x3b>
  802927:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292b:	75 84                	jne    8028b1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80292d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802931:	75 10                	jne    802943 <print_mem_block_lists+0xcd>
  802933:	83 ec 0c             	sub    $0xc,%esp
  802936:	68 78 4a 80 00       	push   $0x804a78
  80293b:	e8 67 e7 ff ff       	call   8010a7 <cprintf>
  802940:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802943:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80294a:	83 ec 0c             	sub    $0xc,%esp
  80294d:	68 9c 4a 80 00       	push   $0x804a9c
  802952:	e8 50 e7 ff ff       	call   8010a7 <cprintf>
  802957:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80295a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80295e:	a1 40 50 80 00       	mov    0x805040,%eax
  802963:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802966:	eb 56                	jmp    8029be <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802968:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80296c:	74 1c                	je     80298a <print_mem_block_lists+0x114>
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 50 08             	mov    0x8(%eax),%edx
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	8b 48 08             	mov    0x8(%eax),%ecx
  80297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297d:	8b 40 0c             	mov    0xc(%eax),%eax
  802980:	01 c8                	add    %ecx,%eax
  802982:	39 c2                	cmp    %eax,%edx
  802984:	73 04                	jae    80298a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802986:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 50 08             	mov    0x8(%eax),%edx
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 40 0c             	mov    0xc(%eax),%eax
  802996:	01 c2                	add    %eax,%edx
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 40 08             	mov    0x8(%eax),%eax
  80299e:	83 ec 04             	sub    $0x4,%esp
  8029a1:	52                   	push   %edx
  8029a2:	50                   	push   %eax
  8029a3:	68 69 4a 80 00       	push   $0x804a69
  8029a8:	e8 fa e6 ff ff       	call   8010a7 <cprintf>
  8029ad:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029b6:	a1 48 50 80 00       	mov    0x805048,%eax
  8029bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c2:	74 07                	je     8029cb <print_mem_block_lists+0x155>
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	eb 05                	jmp    8029d0 <print_mem_block_lists+0x15a>
  8029cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d0:	a3 48 50 80 00       	mov    %eax,0x805048
  8029d5:	a1 48 50 80 00       	mov    0x805048,%eax
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	75 8a                	jne    802968 <print_mem_block_lists+0xf2>
  8029de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e2:	75 84                	jne    802968 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8029e4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029e8:	75 10                	jne    8029fa <print_mem_block_lists+0x184>
  8029ea:	83 ec 0c             	sub    $0xc,%esp
  8029ed:	68 b4 4a 80 00       	push   $0x804ab4
  8029f2:	e8 b0 e6 ff ff       	call   8010a7 <cprintf>
  8029f7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029fa:	83 ec 0c             	sub    $0xc,%esp
  8029fd:	68 28 4a 80 00       	push   $0x804a28
  802a02:	e8 a0 e6 ff ff       	call   8010a7 <cprintf>
  802a07:	83 c4 10             	add    $0x10,%esp

}
  802a0a:	90                   	nop
  802a0b:	c9                   	leave  
  802a0c:	c3                   	ret    

00802a0d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a0d:	55                   	push   %ebp
  802a0e:	89 e5                	mov    %esp,%ebp
  802a10:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802a13:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a1a:	00 00 00 
  802a1d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802a24:	00 00 00 
  802a27:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802a2e:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802a31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a38:	e9 9e 00 00 00       	jmp    802adb <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802a3d:	a1 50 50 80 00       	mov    0x805050,%eax
  802a42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a45:	c1 e2 04             	shl    $0x4,%edx
  802a48:	01 d0                	add    %edx,%eax
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	75 14                	jne    802a62 <initialize_MemBlocksList+0x55>
  802a4e:	83 ec 04             	sub    $0x4,%esp
  802a51:	68 dc 4a 80 00       	push   $0x804adc
  802a56:	6a 46                	push   $0x46
  802a58:	68 ff 4a 80 00       	push   $0x804aff
  802a5d:	e8 91 e3 ff ff       	call   800df3 <_panic>
  802a62:	a1 50 50 80 00       	mov    0x805050,%eax
  802a67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6a:	c1 e2 04             	shl    $0x4,%edx
  802a6d:	01 d0                	add    %edx,%eax
  802a6f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a75:	89 10                	mov    %edx,(%eax)
  802a77:	8b 00                	mov    (%eax),%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	74 18                	je     802a95 <initialize_MemBlocksList+0x88>
  802a7d:	a1 48 51 80 00       	mov    0x805148,%eax
  802a82:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a88:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a8b:	c1 e1 04             	shl    $0x4,%ecx
  802a8e:	01 ca                	add    %ecx,%edx
  802a90:	89 50 04             	mov    %edx,0x4(%eax)
  802a93:	eb 12                	jmp    802aa7 <initialize_MemBlocksList+0x9a>
  802a95:	a1 50 50 80 00       	mov    0x805050,%eax
  802a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9d:	c1 e2 04             	shl    $0x4,%edx
  802aa0:	01 d0                	add    %edx,%eax
  802aa2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aa7:	a1 50 50 80 00       	mov    0x805050,%eax
  802aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aaf:	c1 e2 04             	shl    $0x4,%edx
  802ab2:	01 d0                	add    %edx,%eax
  802ab4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ab9:	a1 50 50 80 00       	mov    0x805050,%eax
  802abe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac1:	c1 e2 04             	shl    $0x4,%edx
  802ac4:	01 d0                	add    %edx,%eax
  802ac6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acd:	a1 54 51 80 00       	mov    0x805154,%eax
  802ad2:	40                   	inc    %eax
  802ad3:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802ad8:	ff 45 f4             	incl   -0xc(%ebp)
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae1:	0f 82 56 ff ff ff    	jb     802a3d <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802ae7:	90                   	nop
  802ae8:	c9                   	leave  
  802ae9:	c3                   	ret    

00802aea <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802aea:	55                   	push   %ebp
  802aeb:	89 e5                	mov    %esp,%ebp
  802aed:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802af0:	8b 45 08             	mov    0x8(%ebp),%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802af8:	eb 19                	jmp    802b13 <find_block+0x29>
	{
		if(va==point->sva)
  802afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802afd:	8b 40 08             	mov    0x8(%eax),%eax
  802b00:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b03:	75 05                	jne    802b0a <find_block+0x20>
		   return point;
  802b05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b08:	eb 36                	jmp    802b40 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	8b 40 08             	mov    0x8(%eax),%eax
  802b10:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802b13:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b17:	74 07                	je     802b20 <find_block+0x36>
  802b19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b1c:	8b 00                	mov    (%eax),%eax
  802b1e:	eb 05                	jmp    802b25 <find_block+0x3b>
  802b20:	b8 00 00 00 00       	mov    $0x0,%eax
  802b25:	8b 55 08             	mov    0x8(%ebp),%edx
  802b28:	89 42 08             	mov    %eax,0x8(%edx)
  802b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2e:	8b 40 08             	mov    0x8(%eax),%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	75 c5                	jne    802afa <find_block+0x10>
  802b35:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b39:	75 bf                	jne    802afa <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802b3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b40:	c9                   	leave  
  802b41:	c3                   	ret    

00802b42 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b42:	55                   	push   %ebp
  802b43:	89 e5                	mov    %esp,%ebp
  802b45:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802b48:	a1 40 50 80 00       	mov    0x805040,%eax
  802b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802b50:	a1 44 50 80 00       	mov    0x805044,%eax
  802b55:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b5e:	74 24                	je     802b84 <insert_sorted_allocList+0x42>
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	8b 50 08             	mov    0x8(%eax),%edx
  802b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b69:	8b 40 08             	mov    0x8(%eax),%eax
  802b6c:	39 c2                	cmp    %eax,%edx
  802b6e:	76 14                	jbe    802b84 <insert_sorted_allocList+0x42>
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	8b 50 08             	mov    0x8(%eax),%edx
  802b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b79:	8b 40 08             	mov    0x8(%eax),%eax
  802b7c:	39 c2                	cmp    %eax,%edx
  802b7e:	0f 82 60 01 00 00    	jb     802ce4 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802b84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b88:	75 65                	jne    802bef <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802b8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8e:	75 14                	jne    802ba4 <insert_sorted_allocList+0x62>
  802b90:	83 ec 04             	sub    $0x4,%esp
  802b93:	68 dc 4a 80 00       	push   $0x804adc
  802b98:	6a 6b                	push   $0x6b
  802b9a:	68 ff 4a 80 00       	push   $0x804aff
  802b9f:	e8 4f e2 ff ff       	call   800df3 <_panic>
  802ba4:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	89 10                	mov    %edx,(%eax)
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	85 c0                	test   %eax,%eax
  802bb6:	74 0d                	je     802bc5 <insert_sorted_allocList+0x83>
  802bb8:	a1 40 50 80 00       	mov    0x805040,%eax
  802bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc0:	89 50 04             	mov    %edx,0x4(%eax)
  802bc3:	eb 08                	jmp    802bcd <insert_sorted_allocList+0x8b>
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	a3 44 50 80 00       	mov    %eax,0x805044
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	a3 40 50 80 00       	mov    %eax,0x805040
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802be4:	40                   	inc    %eax
  802be5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802bea:	e9 dc 01 00 00       	jmp    802dcb <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	8b 50 08             	mov    0x8(%eax),%edx
  802bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf8:	8b 40 08             	mov    0x8(%eax),%eax
  802bfb:	39 c2                	cmp    %eax,%edx
  802bfd:	77 6c                	ja     802c6b <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802bff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c03:	74 06                	je     802c0b <insert_sorted_allocList+0xc9>
  802c05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c09:	75 14                	jne    802c1f <insert_sorted_allocList+0xdd>
  802c0b:	83 ec 04             	sub    $0x4,%esp
  802c0e:	68 18 4b 80 00       	push   $0x804b18
  802c13:	6a 6f                	push   $0x6f
  802c15:	68 ff 4a 80 00       	push   $0x804aff
  802c1a:	e8 d4 e1 ff ff       	call   800df3 <_panic>
  802c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c22:	8b 50 04             	mov    0x4(%eax),%edx
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	89 50 04             	mov    %edx,0x4(%eax)
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c31:	89 10                	mov    %edx,(%eax)
  802c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c36:	8b 40 04             	mov    0x4(%eax),%eax
  802c39:	85 c0                	test   %eax,%eax
  802c3b:	74 0d                	je     802c4a <insert_sorted_allocList+0x108>
  802c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c40:	8b 40 04             	mov    0x4(%eax),%eax
  802c43:	8b 55 08             	mov    0x8(%ebp),%edx
  802c46:	89 10                	mov    %edx,(%eax)
  802c48:	eb 08                	jmp    802c52 <insert_sorted_allocList+0x110>
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	a3 40 50 80 00       	mov    %eax,0x805040
  802c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c55:	8b 55 08             	mov    0x8(%ebp),%edx
  802c58:	89 50 04             	mov    %edx,0x4(%eax)
  802c5b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c60:	40                   	inc    %eax
  802c61:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c66:	e9 60 01 00 00       	jmp    802dcb <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	8b 50 08             	mov    0x8(%eax),%edx
  802c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c74:	8b 40 08             	mov    0x8(%eax),%eax
  802c77:	39 c2                	cmp    %eax,%edx
  802c79:	0f 82 4c 01 00 00    	jb     802dcb <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802c7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c83:	75 14                	jne    802c99 <insert_sorted_allocList+0x157>
  802c85:	83 ec 04             	sub    $0x4,%esp
  802c88:	68 50 4b 80 00       	push   $0x804b50
  802c8d:	6a 73                	push   $0x73
  802c8f:	68 ff 4a 80 00       	push   $0x804aff
  802c94:	e8 5a e1 ff ff       	call   800df3 <_panic>
  802c99:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	89 50 04             	mov    %edx,0x4(%eax)
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	8b 40 04             	mov    0x4(%eax),%eax
  802cab:	85 c0                	test   %eax,%eax
  802cad:	74 0c                	je     802cbb <insert_sorted_allocList+0x179>
  802caf:	a1 44 50 80 00       	mov    0x805044,%eax
  802cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb7:	89 10                	mov    %edx,(%eax)
  802cb9:	eb 08                	jmp    802cc3 <insert_sorted_allocList+0x181>
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	a3 40 50 80 00       	mov    %eax,0x805040
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	a3 44 50 80 00       	mov    %eax,0x805044
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cd9:	40                   	inc    %eax
  802cda:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802cdf:	e9 e7 00 00 00       	jmp    802dcb <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802cea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802cf1:	a1 40 50 80 00       	mov    0x805040,%eax
  802cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf9:	e9 9d 00 00 00       	jmp    802d9b <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	8b 50 08             	mov    0x8(%eax),%edx
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 40 08             	mov    0x8(%eax),%eax
  802d12:	39 c2                	cmp    %eax,%edx
  802d14:	76 7d                	jbe    802d93 <insert_sorted_allocList+0x251>
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	8b 50 08             	mov    0x8(%eax),%edx
  802d1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1f:	8b 40 08             	mov    0x8(%eax),%eax
  802d22:	39 c2                	cmp    %eax,%edx
  802d24:	73 6d                	jae    802d93 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2a:	74 06                	je     802d32 <insert_sorted_allocList+0x1f0>
  802d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d30:	75 14                	jne    802d46 <insert_sorted_allocList+0x204>
  802d32:	83 ec 04             	sub    $0x4,%esp
  802d35:	68 74 4b 80 00       	push   $0x804b74
  802d3a:	6a 7f                	push   $0x7f
  802d3c:	68 ff 4a 80 00       	push   $0x804aff
  802d41:	e8 ad e0 ff ff       	call   800df3 <_panic>
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	8b 10                	mov    (%eax),%edx
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	89 10                	mov    %edx,(%eax)
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	8b 00                	mov    (%eax),%eax
  802d55:	85 c0                	test   %eax,%eax
  802d57:	74 0b                	je     802d64 <insert_sorted_allocList+0x222>
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 00                	mov    (%eax),%eax
  802d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d61:	89 50 04             	mov    %edx,0x4(%eax)
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6a:	89 10                	mov    %edx,(%eax)
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d72:	89 50 04             	mov    %edx,0x4(%eax)
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	8b 00                	mov    (%eax),%eax
  802d7a:	85 c0                	test   %eax,%eax
  802d7c:	75 08                	jne    802d86 <insert_sorted_allocList+0x244>
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	a3 44 50 80 00       	mov    %eax,0x805044
  802d86:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d8b:	40                   	inc    %eax
  802d8c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802d91:	eb 39                	jmp    802dcc <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802d93:	a1 48 50 80 00       	mov    0x805048,%eax
  802d98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9f:	74 07                	je     802da8 <insert_sorted_allocList+0x266>
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	eb 05                	jmp    802dad <insert_sorted_allocList+0x26b>
  802da8:	b8 00 00 00 00       	mov    $0x0,%eax
  802dad:	a3 48 50 80 00       	mov    %eax,0x805048
  802db2:	a1 48 50 80 00       	mov    0x805048,%eax
  802db7:	85 c0                	test   %eax,%eax
  802db9:	0f 85 3f ff ff ff    	jne    802cfe <insert_sorted_allocList+0x1bc>
  802dbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc3:	0f 85 35 ff ff ff    	jne    802cfe <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802dc9:	eb 01                	jmp    802dcc <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802dcb:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802dcc:	90                   	nop
  802dcd:	c9                   	leave  
  802dce:	c3                   	ret    

00802dcf <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802dcf:	55                   	push   %ebp
  802dd0:	89 e5                	mov    %esp,%ebp
  802dd2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802dd5:	a1 38 51 80 00       	mov    0x805138,%eax
  802dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ddd:	e9 85 01 00 00       	jmp    802f67 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 40 0c             	mov    0xc(%eax),%eax
  802de8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802deb:	0f 82 6e 01 00 00    	jb     802f5f <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 40 0c             	mov    0xc(%eax),%eax
  802df7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dfa:	0f 85 8a 00 00 00    	jne    802e8a <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802e00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e04:	75 17                	jne    802e1d <alloc_block_FF+0x4e>
  802e06:	83 ec 04             	sub    $0x4,%esp
  802e09:	68 a8 4b 80 00       	push   $0x804ba8
  802e0e:	68 93 00 00 00       	push   $0x93
  802e13:	68 ff 4a 80 00       	push   $0x804aff
  802e18:	e8 d6 df ff ff       	call   800df3 <_panic>
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 00                	mov    (%eax),%eax
  802e22:	85 c0                	test   %eax,%eax
  802e24:	74 10                	je     802e36 <alloc_block_FF+0x67>
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 00                	mov    (%eax),%eax
  802e2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2e:	8b 52 04             	mov    0x4(%edx),%edx
  802e31:	89 50 04             	mov    %edx,0x4(%eax)
  802e34:	eb 0b                	jmp    802e41 <alloc_block_FF+0x72>
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	8b 40 04             	mov    0x4(%eax),%eax
  802e3c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 40 04             	mov    0x4(%eax),%eax
  802e47:	85 c0                	test   %eax,%eax
  802e49:	74 0f                	je     802e5a <alloc_block_FF+0x8b>
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 40 04             	mov    0x4(%eax),%eax
  802e51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e54:	8b 12                	mov    (%edx),%edx
  802e56:	89 10                	mov    %edx,(%eax)
  802e58:	eb 0a                	jmp    802e64 <alloc_block_FF+0x95>
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 00                	mov    (%eax),%eax
  802e5f:	a3 38 51 80 00       	mov    %eax,0x805138
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e77:	a1 44 51 80 00       	mov    0x805144,%eax
  802e7c:	48                   	dec    %eax
  802e7d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	e9 10 01 00 00       	jmp    802f9a <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e90:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e93:	0f 86 c6 00 00 00    	jbe    802f5f <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e99:	a1 48 51 80 00       	mov    0x805148,%eax
  802e9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	8b 50 08             	mov    0x8(%eax),%edx
  802ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eaa:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb3:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802eb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eba:	75 17                	jne    802ed3 <alloc_block_FF+0x104>
  802ebc:	83 ec 04             	sub    $0x4,%esp
  802ebf:	68 a8 4b 80 00       	push   $0x804ba8
  802ec4:	68 9b 00 00 00       	push   $0x9b
  802ec9:	68 ff 4a 80 00       	push   $0x804aff
  802ece:	e8 20 df ff ff       	call   800df3 <_panic>
  802ed3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	85 c0                	test   %eax,%eax
  802eda:	74 10                	je     802eec <alloc_block_FF+0x11d>
  802edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee4:	8b 52 04             	mov    0x4(%edx),%edx
  802ee7:	89 50 04             	mov    %edx,0x4(%eax)
  802eea:	eb 0b                	jmp    802ef7 <alloc_block_FF+0x128>
  802eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eef:	8b 40 04             	mov    0x4(%eax),%eax
  802ef2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efa:	8b 40 04             	mov    0x4(%eax),%eax
  802efd:	85 c0                	test   %eax,%eax
  802eff:	74 0f                	je     802f10 <alloc_block_FF+0x141>
  802f01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f04:	8b 40 04             	mov    0x4(%eax),%eax
  802f07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f0a:	8b 12                	mov    (%edx),%edx
  802f0c:	89 10                	mov    %edx,(%eax)
  802f0e:	eb 0a                	jmp    802f1a <alloc_block_FF+0x14b>
  802f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f13:	8b 00                	mov    (%eax),%eax
  802f15:	a3 48 51 80 00       	mov    %eax,0x805148
  802f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2d:	a1 54 51 80 00       	mov    0x805154,%eax
  802f32:	48                   	dec    %eax
  802f33:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 50 08             	mov    0x8(%eax),%edx
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	01 c2                	add    %eax,%edx
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4f:	2b 45 08             	sub    0x8(%ebp),%eax
  802f52:	89 c2                	mov    %eax,%edx
  802f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f57:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5d:	eb 3b                	jmp    802f9a <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802f5f:	a1 40 51 80 00       	mov    0x805140,%eax
  802f64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6b:	74 07                	je     802f74 <alloc_block_FF+0x1a5>
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	eb 05                	jmp    802f79 <alloc_block_FF+0x1aa>
  802f74:	b8 00 00 00 00       	mov    $0x0,%eax
  802f79:	a3 40 51 80 00       	mov    %eax,0x805140
  802f7e:	a1 40 51 80 00       	mov    0x805140,%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	0f 85 57 fe ff ff    	jne    802de2 <alloc_block_FF+0x13>
  802f8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8f:	0f 85 4d fe ff ff    	jne    802de2 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802f95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f9a:	c9                   	leave  
  802f9b:	c3                   	ret    

00802f9c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802f9c:	55                   	push   %ebp
  802f9d:	89 e5                	mov    %esp,%ebp
  802f9f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802fa2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802fa9:	a1 38 51 80 00       	mov    0x805138,%eax
  802fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb1:	e9 df 00 00 00       	jmp    803095 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fbf:	0f 82 c8 00 00 00    	jb     80308d <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fce:	0f 85 8a 00 00 00    	jne    80305e <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802fd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd8:	75 17                	jne    802ff1 <alloc_block_BF+0x55>
  802fda:	83 ec 04             	sub    $0x4,%esp
  802fdd:	68 a8 4b 80 00       	push   $0x804ba8
  802fe2:	68 b7 00 00 00       	push   $0xb7
  802fe7:	68 ff 4a 80 00       	push   $0x804aff
  802fec:	e8 02 de ff ff       	call   800df3 <_panic>
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	8b 00                	mov    (%eax),%eax
  802ff6:	85 c0                	test   %eax,%eax
  802ff8:	74 10                	je     80300a <alloc_block_BF+0x6e>
  802ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803002:	8b 52 04             	mov    0x4(%edx),%edx
  803005:	89 50 04             	mov    %edx,0x4(%eax)
  803008:	eb 0b                	jmp    803015 <alloc_block_BF+0x79>
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	8b 40 04             	mov    0x4(%eax),%eax
  803010:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 40 04             	mov    0x4(%eax),%eax
  80301b:	85 c0                	test   %eax,%eax
  80301d:	74 0f                	je     80302e <alloc_block_BF+0x92>
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	8b 40 04             	mov    0x4(%eax),%eax
  803025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803028:	8b 12                	mov    (%edx),%edx
  80302a:	89 10                	mov    %edx,(%eax)
  80302c:	eb 0a                	jmp    803038 <alloc_block_BF+0x9c>
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 00                	mov    (%eax),%eax
  803033:	a3 38 51 80 00       	mov    %eax,0x805138
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803044:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304b:	a1 44 51 80 00       	mov    0x805144,%eax
  803050:	48                   	dec    %eax
  803051:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  803056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803059:	e9 4d 01 00 00       	jmp    8031ab <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803061:	8b 40 0c             	mov    0xc(%eax),%eax
  803064:	3b 45 08             	cmp    0x8(%ebp),%eax
  803067:	76 24                	jbe    80308d <alloc_block_BF+0xf1>
  803069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306c:	8b 40 0c             	mov    0xc(%eax),%eax
  80306f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803072:	73 19                	jae    80308d <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  803074:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 40 0c             	mov    0xc(%eax),%eax
  803081:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 40 08             	mov    0x8(%eax),%eax
  80308a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80308d:	a1 40 51 80 00       	mov    0x805140,%eax
  803092:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803095:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803099:	74 07                	je     8030a2 <alloc_block_BF+0x106>
  80309b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309e:	8b 00                	mov    (%eax),%eax
  8030a0:	eb 05                	jmp    8030a7 <alloc_block_BF+0x10b>
  8030a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a7:	a3 40 51 80 00       	mov    %eax,0x805140
  8030ac:	a1 40 51 80 00       	mov    0x805140,%eax
  8030b1:	85 c0                	test   %eax,%eax
  8030b3:	0f 85 fd fe ff ff    	jne    802fb6 <alloc_block_BF+0x1a>
  8030b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bd:	0f 85 f3 fe ff ff    	jne    802fb6 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8030c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030c7:	0f 84 d9 00 00 00    	je     8031a6 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8030cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8030d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8030d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030db:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8030de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e4:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8030e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030eb:	75 17                	jne    803104 <alloc_block_BF+0x168>
  8030ed:	83 ec 04             	sub    $0x4,%esp
  8030f0:	68 a8 4b 80 00       	push   $0x804ba8
  8030f5:	68 c7 00 00 00       	push   $0xc7
  8030fa:	68 ff 4a 80 00       	push   $0x804aff
  8030ff:	e8 ef dc ff ff       	call   800df3 <_panic>
  803104:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803107:	8b 00                	mov    (%eax),%eax
  803109:	85 c0                	test   %eax,%eax
  80310b:	74 10                	je     80311d <alloc_block_BF+0x181>
  80310d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803110:	8b 00                	mov    (%eax),%eax
  803112:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803115:	8b 52 04             	mov    0x4(%edx),%edx
  803118:	89 50 04             	mov    %edx,0x4(%eax)
  80311b:	eb 0b                	jmp    803128 <alloc_block_BF+0x18c>
  80311d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803120:	8b 40 04             	mov    0x4(%eax),%eax
  803123:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312b:	8b 40 04             	mov    0x4(%eax),%eax
  80312e:	85 c0                	test   %eax,%eax
  803130:	74 0f                	je     803141 <alloc_block_BF+0x1a5>
  803132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803135:	8b 40 04             	mov    0x4(%eax),%eax
  803138:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80313b:	8b 12                	mov    (%edx),%edx
  80313d:	89 10                	mov    %edx,(%eax)
  80313f:	eb 0a                	jmp    80314b <alloc_block_BF+0x1af>
  803141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803144:	8b 00                	mov    (%eax),%eax
  803146:	a3 48 51 80 00       	mov    %eax,0x805148
  80314b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803157:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315e:	a1 54 51 80 00       	mov    0x805154,%eax
  803163:	48                   	dec    %eax
  803164:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803169:	83 ec 08             	sub    $0x8,%esp
  80316c:	ff 75 ec             	pushl  -0x14(%ebp)
  80316f:	68 38 51 80 00       	push   $0x805138
  803174:	e8 71 f9 ff ff       	call   802aea <find_block>
  803179:	83 c4 10             	add    $0x10,%esp
  80317c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80317f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803182:	8b 50 08             	mov    0x8(%eax),%edx
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	01 c2                	add    %eax,%edx
  80318a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80318d:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803190:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803193:	8b 40 0c             	mov    0xc(%eax),%eax
  803196:	2b 45 08             	sub    0x8(%ebp),%eax
  803199:	89 c2                	mov    %eax,%edx
  80319b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80319e:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8031a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a4:	eb 05                	jmp    8031ab <alloc_block_BF+0x20f>
	}
	return NULL;
  8031a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031ab:	c9                   	leave  
  8031ac:	c3                   	ret    

008031ad <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8031ad:	55                   	push   %ebp
  8031ae:	89 e5                	mov    %esp,%ebp
  8031b0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8031b3:	a1 28 50 80 00       	mov    0x805028,%eax
  8031b8:	85 c0                	test   %eax,%eax
  8031ba:	0f 85 de 01 00 00    	jne    80339e <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8031c0:	a1 38 51 80 00       	mov    0x805138,%eax
  8031c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c8:	e9 9e 01 00 00       	jmp    80336b <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8031cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031d6:	0f 82 87 01 00 00    	jb     803363 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031e5:	0f 85 95 00 00 00    	jne    803280 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8031eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ef:	75 17                	jne    803208 <alloc_block_NF+0x5b>
  8031f1:	83 ec 04             	sub    $0x4,%esp
  8031f4:	68 a8 4b 80 00       	push   $0x804ba8
  8031f9:	68 e0 00 00 00       	push   $0xe0
  8031fe:	68 ff 4a 80 00       	push   $0x804aff
  803203:	e8 eb db ff ff       	call   800df3 <_panic>
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	8b 00                	mov    (%eax),%eax
  80320d:	85 c0                	test   %eax,%eax
  80320f:	74 10                	je     803221 <alloc_block_NF+0x74>
  803211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803219:	8b 52 04             	mov    0x4(%edx),%edx
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	eb 0b                	jmp    80322c <alloc_block_NF+0x7f>
  803221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803224:	8b 40 04             	mov    0x4(%eax),%eax
  803227:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80322c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322f:	8b 40 04             	mov    0x4(%eax),%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	74 0f                	je     803245 <alloc_block_NF+0x98>
  803236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803239:	8b 40 04             	mov    0x4(%eax),%eax
  80323c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80323f:	8b 12                	mov    (%edx),%edx
  803241:	89 10                	mov    %edx,(%eax)
  803243:	eb 0a                	jmp    80324f <alloc_block_NF+0xa2>
  803245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803248:	8b 00                	mov    (%eax),%eax
  80324a:	a3 38 51 80 00       	mov    %eax,0x805138
  80324f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803252:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803262:	a1 44 51 80 00       	mov    0x805144,%eax
  803267:	48                   	dec    %eax
  803268:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	8b 40 08             	mov    0x8(%eax),%eax
  803273:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  803278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327b:	e9 f8 04 00 00       	jmp    803778 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803283:	8b 40 0c             	mov    0xc(%eax),%eax
  803286:	3b 45 08             	cmp    0x8(%ebp),%eax
  803289:	0f 86 d4 00 00 00    	jbe    803363 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80328f:	a1 48 51 80 00       	mov    0x805148,%eax
  803294:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329a:	8b 50 08             	mov    0x8(%eax),%edx
  80329d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a0:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8032a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a9:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8032ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032b0:	75 17                	jne    8032c9 <alloc_block_NF+0x11c>
  8032b2:	83 ec 04             	sub    $0x4,%esp
  8032b5:	68 a8 4b 80 00       	push   $0x804ba8
  8032ba:	68 e9 00 00 00       	push   $0xe9
  8032bf:	68 ff 4a 80 00       	push   $0x804aff
  8032c4:	e8 2a db ff ff       	call   800df3 <_panic>
  8032c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cc:	8b 00                	mov    (%eax),%eax
  8032ce:	85 c0                	test   %eax,%eax
  8032d0:	74 10                	je     8032e2 <alloc_block_NF+0x135>
  8032d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d5:	8b 00                	mov    (%eax),%eax
  8032d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032da:	8b 52 04             	mov    0x4(%edx),%edx
  8032dd:	89 50 04             	mov    %edx,0x4(%eax)
  8032e0:	eb 0b                	jmp    8032ed <alloc_block_NF+0x140>
  8032e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e5:	8b 40 04             	mov    0x4(%eax),%eax
  8032e8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f0:	8b 40 04             	mov    0x4(%eax),%eax
  8032f3:	85 c0                	test   %eax,%eax
  8032f5:	74 0f                	je     803306 <alloc_block_NF+0x159>
  8032f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fa:	8b 40 04             	mov    0x4(%eax),%eax
  8032fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803300:	8b 12                	mov    (%edx),%edx
  803302:	89 10                	mov    %edx,(%eax)
  803304:	eb 0a                	jmp    803310 <alloc_block_NF+0x163>
  803306:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803309:	8b 00                	mov    (%eax),%eax
  80330b:	a3 48 51 80 00       	mov    %eax,0x805148
  803310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803313:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803319:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803323:	a1 54 51 80 00       	mov    0x805154,%eax
  803328:	48                   	dec    %eax
  803329:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80332e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803331:	8b 40 08             	mov    0x8(%eax),%eax
  803334:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333c:	8b 50 08             	mov    0x8(%eax),%edx
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	01 c2                	add    %eax,%edx
  803344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803347:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80334a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334d:	8b 40 0c             	mov    0xc(%eax),%eax
  803350:	2b 45 08             	sub    0x8(%ebp),%eax
  803353:	89 c2                	mov    %eax,%edx
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80335b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80335e:	e9 15 04 00 00       	jmp    803778 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803363:	a1 40 51 80 00       	mov    0x805140,%eax
  803368:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336f:	74 07                	je     803378 <alloc_block_NF+0x1cb>
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	eb 05                	jmp    80337d <alloc_block_NF+0x1d0>
  803378:	b8 00 00 00 00       	mov    $0x0,%eax
  80337d:	a3 40 51 80 00       	mov    %eax,0x805140
  803382:	a1 40 51 80 00       	mov    0x805140,%eax
  803387:	85 c0                	test   %eax,%eax
  803389:	0f 85 3e fe ff ff    	jne    8031cd <alloc_block_NF+0x20>
  80338f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803393:	0f 85 34 fe ff ff    	jne    8031cd <alloc_block_NF+0x20>
  803399:	e9 d5 03 00 00       	jmp    803773 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80339e:	a1 38 51 80 00       	mov    0x805138,%eax
  8033a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a6:	e9 b1 01 00 00       	jmp    80355c <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8033ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ae:	8b 50 08             	mov    0x8(%eax),%edx
  8033b1:	a1 28 50 80 00       	mov    0x805028,%eax
  8033b6:	39 c2                	cmp    %eax,%edx
  8033b8:	0f 82 96 01 00 00    	jb     803554 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8033be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033c7:	0f 82 87 01 00 00    	jb     803554 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8033cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033d6:	0f 85 95 00 00 00    	jne    803471 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8033dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e0:	75 17                	jne    8033f9 <alloc_block_NF+0x24c>
  8033e2:	83 ec 04             	sub    $0x4,%esp
  8033e5:	68 a8 4b 80 00       	push   $0x804ba8
  8033ea:	68 fc 00 00 00       	push   $0xfc
  8033ef:	68 ff 4a 80 00       	push   $0x804aff
  8033f4:	e8 fa d9 ff ff       	call   800df3 <_panic>
  8033f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fc:	8b 00                	mov    (%eax),%eax
  8033fe:	85 c0                	test   %eax,%eax
  803400:	74 10                	je     803412 <alloc_block_NF+0x265>
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	8b 00                	mov    (%eax),%eax
  803407:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80340a:	8b 52 04             	mov    0x4(%edx),%edx
  80340d:	89 50 04             	mov    %edx,0x4(%eax)
  803410:	eb 0b                	jmp    80341d <alloc_block_NF+0x270>
  803412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803415:	8b 40 04             	mov    0x4(%eax),%eax
  803418:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80341d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803420:	8b 40 04             	mov    0x4(%eax),%eax
  803423:	85 c0                	test   %eax,%eax
  803425:	74 0f                	je     803436 <alloc_block_NF+0x289>
  803427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342a:	8b 40 04             	mov    0x4(%eax),%eax
  80342d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803430:	8b 12                	mov    (%edx),%edx
  803432:	89 10                	mov    %edx,(%eax)
  803434:	eb 0a                	jmp    803440 <alloc_block_NF+0x293>
  803436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803439:	8b 00                	mov    (%eax),%eax
  80343b:	a3 38 51 80 00       	mov    %eax,0x805138
  803440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803443:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803453:	a1 44 51 80 00       	mov    0x805144,%eax
  803458:	48                   	dec    %eax
  803459:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80345e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803461:	8b 40 08             	mov    0x8(%eax),%eax
  803464:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346c:	e9 07 03 00 00       	jmp    803778 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803474:	8b 40 0c             	mov    0xc(%eax),%eax
  803477:	3b 45 08             	cmp    0x8(%ebp),%eax
  80347a:	0f 86 d4 00 00 00    	jbe    803554 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803480:	a1 48 51 80 00       	mov    0x805148,%eax
  803485:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348b:	8b 50 08             	mov    0x8(%eax),%edx
  80348e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803491:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803494:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803497:	8b 55 08             	mov    0x8(%ebp),%edx
  80349a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80349d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034a1:	75 17                	jne    8034ba <alloc_block_NF+0x30d>
  8034a3:	83 ec 04             	sub    $0x4,%esp
  8034a6:	68 a8 4b 80 00       	push   $0x804ba8
  8034ab:	68 04 01 00 00       	push   $0x104
  8034b0:	68 ff 4a 80 00       	push   $0x804aff
  8034b5:	e8 39 d9 ff ff       	call   800df3 <_panic>
  8034ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034bd:	8b 00                	mov    (%eax),%eax
  8034bf:	85 c0                	test   %eax,%eax
  8034c1:	74 10                	je     8034d3 <alloc_block_NF+0x326>
  8034c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c6:	8b 00                	mov    (%eax),%eax
  8034c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034cb:	8b 52 04             	mov    0x4(%edx),%edx
  8034ce:	89 50 04             	mov    %edx,0x4(%eax)
  8034d1:	eb 0b                	jmp    8034de <alloc_block_NF+0x331>
  8034d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d6:	8b 40 04             	mov    0x4(%eax),%eax
  8034d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e1:	8b 40 04             	mov    0x4(%eax),%eax
  8034e4:	85 c0                	test   %eax,%eax
  8034e6:	74 0f                	je     8034f7 <alloc_block_NF+0x34a>
  8034e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034eb:	8b 40 04             	mov    0x4(%eax),%eax
  8034ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034f1:	8b 12                	mov    (%edx),%edx
  8034f3:	89 10                	mov    %edx,(%eax)
  8034f5:	eb 0a                	jmp    803501 <alloc_block_NF+0x354>
  8034f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fa:	8b 00                	mov    (%eax),%eax
  8034fc:	a3 48 51 80 00       	mov    %eax,0x805148
  803501:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80350a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803514:	a1 54 51 80 00       	mov    0x805154,%eax
  803519:	48                   	dec    %eax
  80351a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80351f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803522:	8b 40 08             	mov    0x8(%eax),%eax
  803525:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  80352a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352d:	8b 50 08             	mov    0x8(%eax),%edx
  803530:	8b 45 08             	mov    0x8(%ebp),%eax
  803533:	01 c2                	add    %eax,%edx
  803535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803538:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80353b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353e:	8b 40 0c             	mov    0xc(%eax),%eax
  803541:	2b 45 08             	sub    0x8(%ebp),%eax
  803544:	89 c2                	mov    %eax,%edx
  803546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803549:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80354c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354f:	e9 24 02 00 00       	jmp    803778 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803554:	a1 40 51 80 00       	mov    0x805140,%eax
  803559:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80355c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803560:	74 07                	je     803569 <alloc_block_NF+0x3bc>
  803562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803565:	8b 00                	mov    (%eax),%eax
  803567:	eb 05                	jmp    80356e <alloc_block_NF+0x3c1>
  803569:	b8 00 00 00 00       	mov    $0x0,%eax
  80356e:	a3 40 51 80 00       	mov    %eax,0x805140
  803573:	a1 40 51 80 00       	mov    0x805140,%eax
  803578:	85 c0                	test   %eax,%eax
  80357a:	0f 85 2b fe ff ff    	jne    8033ab <alloc_block_NF+0x1fe>
  803580:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803584:	0f 85 21 fe ff ff    	jne    8033ab <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80358a:	a1 38 51 80 00       	mov    0x805138,%eax
  80358f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803592:	e9 ae 01 00 00       	jmp    803745 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359a:	8b 50 08             	mov    0x8(%eax),%edx
  80359d:	a1 28 50 80 00       	mov    0x805028,%eax
  8035a2:	39 c2                	cmp    %eax,%edx
  8035a4:	0f 83 93 01 00 00    	jae    80373d <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8035aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035b3:	0f 82 84 01 00 00    	jb     80373d <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8035b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8035bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035c2:	0f 85 95 00 00 00    	jne    80365d <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8035c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035cc:	75 17                	jne    8035e5 <alloc_block_NF+0x438>
  8035ce:	83 ec 04             	sub    $0x4,%esp
  8035d1:	68 a8 4b 80 00       	push   $0x804ba8
  8035d6:	68 14 01 00 00       	push   $0x114
  8035db:	68 ff 4a 80 00       	push   $0x804aff
  8035e0:	e8 0e d8 ff ff       	call   800df3 <_panic>
  8035e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e8:	8b 00                	mov    (%eax),%eax
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	74 10                	je     8035fe <alloc_block_NF+0x451>
  8035ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f1:	8b 00                	mov    (%eax),%eax
  8035f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f6:	8b 52 04             	mov    0x4(%edx),%edx
  8035f9:	89 50 04             	mov    %edx,0x4(%eax)
  8035fc:	eb 0b                	jmp    803609 <alloc_block_NF+0x45c>
  8035fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803601:	8b 40 04             	mov    0x4(%eax),%eax
  803604:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360c:	8b 40 04             	mov    0x4(%eax),%eax
  80360f:	85 c0                	test   %eax,%eax
  803611:	74 0f                	je     803622 <alloc_block_NF+0x475>
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	8b 40 04             	mov    0x4(%eax),%eax
  803619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80361c:	8b 12                	mov    (%edx),%edx
  80361e:	89 10                	mov    %edx,(%eax)
  803620:	eb 0a                	jmp    80362c <alloc_block_NF+0x47f>
  803622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803625:	8b 00                	mov    (%eax),%eax
  803627:	a3 38 51 80 00       	mov    %eax,0x805138
  80362c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803638:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363f:	a1 44 51 80 00       	mov    0x805144,%eax
  803644:	48                   	dec    %eax
  803645:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80364a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364d:	8b 40 08             	mov    0x8(%eax),%eax
  803650:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803658:	e9 1b 01 00 00       	jmp    803778 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80365d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803660:	8b 40 0c             	mov    0xc(%eax),%eax
  803663:	3b 45 08             	cmp    0x8(%ebp),%eax
  803666:	0f 86 d1 00 00 00    	jbe    80373d <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80366c:	a1 48 51 80 00       	mov    0x805148,%eax
  803671:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803677:	8b 50 08             	mov    0x8(%eax),%edx
  80367a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80367d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803680:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803683:	8b 55 08             	mov    0x8(%ebp),%edx
  803686:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803689:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80368d:	75 17                	jne    8036a6 <alloc_block_NF+0x4f9>
  80368f:	83 ec 04             	sub    $0x4,%esp
  803692:	68 a8 4b 80 00       	push   $0x804ba8
  803697:	68 1c 01 00 00       	push   $0x11c
  80369c:	68 ff 4a 80 00       	push   $0x804aff
  8036a1:	e8 4d d7 ff ff       	call   800df3 <_panic>
  8036a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036a9:	8b 00                	mov    (%eax),%eax
  8036ab:	85 c0                	test   %eax,%eax
  8036ad:	74 10                	je     8036bf <alloc_block_NF+0x512>
  8036af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b2:	8b 00                	mov    (%eax),%eax
  8036b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036b7:	8b 52 04             	mov    0x4(%edx),%edx
  8036ba:	89 50 04             	mov    %edx,0x4(%eax)
  8036bd:	eb 0b                	jmp    8036ca <alloc_block_NF+0x51d>
  8036bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c2:	8b 40 04             	mov    0x4(%eax),%eax
  8036c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036cd:	8b 40 04             	mov    0x4(%eax),%eax
  8036d0:	85 c0                	test   %eax,%eax
  8036d2:	74 0f                	je     8036e3 <alloc_block_NF+0x536>
  8036d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d7:	8b 40 04             	mov    0x4(%eax),%eax
  8036da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036dd:	8b 12                	mov    (%edx),%edx
  8036df:	89 10                	mov    %edx,(%eax)
  8036e1:	eb 0a                	jmp    8036ed <alloc_block_NF+0x540>
  8036e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036e6:	8b 00                	mov    (%eax),%eax
  8036e8:	a3 48 51 80 00       	mov    %eax,0x805148
  8036ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803700:	a1 54 51 80 00       	mov    0x805154,%eax
  803705:	48                   	dec    %eax
  803706:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80370b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80370e:	8b 40 08             	mov    0x8(%eax),%eax
  803711:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803719:	8b 50 08             	mov    0x8(%eax),%edx
  80371c:	8b 45 08             	mov    0x8(%ebp),%eax
  80371f:	01 c2                	add    %eax,%edx
  803721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803724:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372a:	8b 40 0c             	mov    0xc(%eax),%eax
  80372d:	2b 45 08             	sub    0x8(%ebp),%eax
  803730:	89 c2                	mov    %eax,%edx
  803732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803735:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80373b:	eb 3b                	jmp    803778 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80373d:	a1 40 51 80 00       	mov    0x805140,%eax
  803742:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803745:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803749:	74 07                	je     803752 <alloc_block_NF+0x5a5>
  80374b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374e:	8b 00                	mov    (%eax),%eax
  803750:	eb 05                	jmp    803757 <alloc_block_NF+0x5aa>
  803752:	b8 00 00 00 00       	mov    $0x0,%eax
  803757:	a3 40 51 80 00       	mov    %eax,0x805140
  80375c:	a1 40 51 80 00       	mov    0x805140,%eax
  803761:	85 c0                	test   %eax,%eax
  803763:	0f 85 2e fe ff ff    	jne    803597 <alloc_block_NF+0x3ea>
  803769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80376d:	0f 85 24 fe ff ff    	jne    803597 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803773:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803778:	c9                   	leave  
  803779:	c3                   	ret    

0080377a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80377a:	55                   	push   %ebp
  80377b:	89 e5                	mov    %esp,%ebp
  80377d:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803780:	a1 38 51 80 00       	mov    0x805138,%eax
  803785:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803788:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80378d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803790:	a1 38 51 80 00       	mov    0x805138,%eax
  803795:	85 c0                	test   %eax,%eax
  803797:	74 14                	je     8037ad <insert_sorted_with_merge_freeList+0x33>
  803799:	8b 45 08             	mov    0x8(%ebp),%eax
  80379c:	8b 50 08             	mov    0x8(%eax),%edx
  80379f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a2:	8b 40 08             	mov    0x8(%eax),%eax
  8037a5:	39 c2                	cmp    %eax,%edx
  8037a7:	0f 87 9b 01 00 00    	ja     803948 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8037ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037b1:	75 17                	jne    8037ca <insert_sorted_with_merge_freeList+0x50>
  8037b3:	83 ec 04             	sub    $0x4,%esp
  8037b6:	68 dc 4a 80 00       	push   $0x804adc
  8037bb:	68 38 01 00 00       	push   $0x138
  8037c0:	68 ff 4a 80 00       	push   $0x804aff
  8037c5:	e8 29 d6 ff ff       	call   800df3 <_panic>
  8037ca:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8037d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d3:	89 10                	mov    %edx,(%eax)
  8037d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d8:	8b 00                	mov    (%eax),%eax
  8037da:	85 c0                	test   %eax,%eax
  8037dc:	74 0d                	je     8037eb <insert_sorted_with_merge_freeList+0x71>
  8037de:	a1 38 51 80 00       	mov    0x805138,%eax
  8037e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8037e6:	89 50 04             	mov    %edx,0x4(%eax)
  8037e9:	eb 08                	jmp    8037f3 <insert_sorted_with_merge_freeList+0x79>
  8037eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f6:	a3 38 51 80 00       	mov    %eax,0x805138
  8037fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803805:	a1 44 51 80 00       	mov    0x805144,%eax
  80380a:	40                   	inc    %eax
  80380b:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803810:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803814:	0f 84 a8 06 00 00    	je     803ec2 <insert_sorted_with_merge_freeList+0x748>
  80381a:	8b 45 08             	mov    0x8(%ebp),%eax
  80381d:	8b 50 08             	mov    0x8(%eax),%edx
  803820:	8b 45 08             	mov    0x8(%ebp),%eax
  803823:	8b 40 0c             	mov    0xc(%eax),%eax
  803826:	01 c2                	add    %eax,%edx
  803828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382b:	8b 40 08             	mov    0x8(%eax),%eax
  80382e:	39 c2                	cmp    %eax,%edx
  803830:	0f 85 8c 06 00 00    	jne    803ec2 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803836:	8b 45 08             	mov    0x8(%ebp),%eax
  803839:	8b 50 0c             	mov    0xc(%eax),%edx
  80383c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80383f:	8b 40 0c             	mov    0xc(%eax),%eax
  803842:	01 c2                	add    %eax,%edx
  803844:	8b 45 08             	mov    0x8(%ebp),%eax
  803847:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  80384a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80384e:	75 17                	jne    803867 <insert_sorted_with_merge_freeList+0xed>
  803850:	83 ec 04             	sub    $0x4,%esp
  803853:	68 a8 4b 80 00       	push   $0x804ba8
  803858:	68 3c 01 00 00       	push   $0x13c
  80385d:	68 ff 4a 80 00       	push   $0x804aff
  803862:	e8 8c d5 ff ff       	call   800df3 <_panic>
  803867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386a:	8b 00                	mov    (%eax),%eax
  80386c:	85 c0                	test   %eax,%eax
  80386e:	74 10                	je     803880 <insert_sorted_with_merge_freeList+0x106>
  803870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803873:	8b 00                	mov    (%eax),%eax
  803875:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803878:	8b 52 04             	mov    0x4(%edx),%edx
  80387b:	89 50 04             	mov    %edx,0x4(%eax)
  80387e:	eb 0b                	jmp    80388b <insert_sorted_with_merge_freeList+0x111>
  803880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803883:	8b 40 04             	mov    0x4(%eax),%eax
  803886:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80388b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80388e:	8b 40 04             	mov    0x4(%eax),%eax
  803891:	85 c0                	test   %eax,%eax
  803893:	74 0f                	je     8038a4 <insert_sorted_with_merge_freeList+0x12a>
  803895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803898:	8b 40 04             	mov    0x4(%eax),%eax
  80389b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80389e:	8b 12                	mov    (%edx),%edx
  8038a0:	89 10                	mov    %edx,(%eax)
  8038a2:	eb 0a                	jmp    8038ae <insert_sorted_with_merge_freeList+0x134>
  8038a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a7:	8b 00                	mov    (%eax),%eax
  8038a9:	a3 38 51 80 00       	mov    %eax,0x805138
  8038ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8038c6:	48                   	dec    %eax
  8038c7:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8038cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038cf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8038d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8038e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038e4:	75 17                	jne    8038fd <insert_sorted_with_merge_freeList+0x183>
  8038e6:	83 ec 04             	sub    $0x4,%esp
  8038e9:	68 dc 4a 80 00       	push   $0x804adc
  8038ee:	68 3f 01 00 00       	push   $0x13f
  8038f3:	68 ff 4a 80 00       	push   $0x804aff
  8038f8:	e8 f6 d4 ff ff       	call   800df3 <_panic>
  8038fd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803906:	89 10                	mov    %edx,(%eax)
  803908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80390b:	8b 00                	mov    (%eax),%eax
  80390d:	85 c0                	test   %eax,%eax
  80390f:	74 0d                	je     80391e <insert_sorted_with_merge_freeList+0x1a4>
  803911:	a1 48 51 80 00       	mov    0x805148,%eax
  803916:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803919:	89 50 04             	mov    %edx,0x4(%eax)
  80391c:	eb 08                	jmp    803926 <insert_sorted_with_merge_freeList+0x1ac>
  80391e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803921:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803929:	a3 48 51 80 00       	mov    %eax,0x805148
  80392e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803931:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803938:	a1 54 51 80 00       	mov    0x805154,%eax
  80393d:	40                   	inc    %eax
  80393e:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803943:	e9 7a 05 00 00       	jmp    803ec2 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803948:	8b 45 08             	mov    0x8(%ebp),%eax
  80394b:	8b 50 08             	mov    0x8(%eax),%edx
  80394e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803951:	8b 40 08             	mov    0x8(%eax),%eax
  803954:	39 c2                	cmp    %eax,%edx
  803956:	0f 82 14 01 00 00    	jb     803a70 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80395c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80395f:	8b 50 08             	mov    0x8(%eax),%edx
  803962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803965:	8b 40 0c             	mov    0xc(%eax),%eax
  803968:	01 c2                	add    %eax,%edx
  80396a:	8b 45 08             	mov    0x8(%ebp),%eax
  80396d:	8b 40 08             	mov    0x8(%eax),%eax
  803970:	39 c2                	cmp    %eax,%edx
  803972:	0f 85 90 00 00 00    	jne    803a08 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80397b:	8b 50 0c             	mov    0xc(%eax),%edx
  80397e:	8b 45 08             	mov    0x8(%ebp),%eax
  803981:	8b 40 0c             	mov    0xc(%eax),%eax
  803984:	01 c2                	add    %eax,%edx
  803986:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803989:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80398c:	8b 45 08             	mov    0x8(%ebp),%eax
  80398f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803996:	8b 45 08             	mov    0x8(%ebp),%eax
  803999:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8039a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039a4:	75 17                	jne    8039bd <insert_sorted_with_merge_freeList+0x243>
  8039a6:	83 ec 04             	sub    $0x4,%esp
  8039a9:	68 dc 4a 80 00       	push   $0x804adc
  8039ae:	68 49 01 00 00       	push   $0x149
  8039b3:	68 ff 4a 80 00       	push   $0x804aff
  8039b8:	e8 36 d4 ff ff       	call   800df3 <_panic>
  8039bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c6:	89 10                	mov    %edx,(%eax)
  8039c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cb:	8b 00                	mov    (%eax),%eax
  8039cd:	85 c0                	test   %eax,%eax
  8039cf:	74 0d                	je     8039de <insert_sorted_with_merge_freeList+0x264>
  8039d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8039d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8039d9:	89 50 04             	mov    %edx,0x4(%eax)
  8039dc:	eb 08                	jmp    8039e6 <insert_sorted_with_merge_freeList+0x26c>
  8039de:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8039ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8039fd:	40                   	inc    %eax
  8039fe:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a03:	e9 bb 04 00 00       	jmp    803ec3 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803a08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a0c:	75 17                	jne    803a25 <insert_sorted_with_merge_freeList+0x2ab>
  803a0e:	83 ec 04             	sub    $0x4,%esp
  803a11:	68 50 4b 80 00       	push   $0x804b50
  803a16:	68 4c 01 00 00       	push   $0x14c
  803a1b:	68 ff 4a 80 00       	push   $0x804aff
  803a20:	e8 ce d3 ff ff       	call   800df3 <_panic>
  803a25:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2e:	89 50 04             	mov    %edx,0x4(%eax)
  803a31:	8b 45 08             	mov    0x8(%ebp),%eax
  803a34:	8b 40 04             	mov    0x4(%eax),%eax
  803a37:	85 c0                	test   %eax,%eax
  803a39:	74 0c                	je     803a47 <insert_sorted_with_merge_freeList+0x2cd>
  803a3b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803a40:	8b 55 08             	mov    0x8(%ebp),%edx
  803a43:	89 10                	mov    %edx,(%eax)
  803a45:	eb 08                	jmp    803a4f <insert_sorted_with_merge_freeList+0x2d5>
  803a47:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4a:	a3 38 51 80 00       	mov    %eax,0x805138
  803a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a52:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a57:	8b 45 08             	mov    0x8(%ebp),%eax
  803a5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a60:	a1 44 51 80 00       	mov    0x805144,%eax
  803a65:	40                   	inc    %eax
  803a66:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a6b:	e9 53 04 00 00       	jmp    803ec3 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a70:	a1 38 51 80 00       	mov    0x805138,%eax
  803a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a78:	e9 15 04 00 00       	jmp    803e92 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a80:	8b 00                	mov    (%eax),%eax
  803a82:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803a85:	8b 45 08             	mov    0x8(%ebp),%eax
  803a88:	8b 50 08             	mov    0x8(%eax),%edx
  803a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8e:	8b 40 08             	mov    0x8(%eax),%eax
  803a91:	39 c2                	cmp    %eax,%edx
  803a93:	0f 86 f1 03 00 00    	jbe    803e8a <insert_sorted_with_merge_freeList+0x710>
  803a99:	8b 45 08             	mov    0x8(%ebp),%eax
  803a9c:	8b 50 08             	mov    0x8(%eax),%edx
  803a9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa2:	8b 40 08             	mov    0x8(%eax),%eax
  803aa5:	39 c2                	cmp    %eax,%edx
  803aa7:	0f 83 dd 03 00 00    	jae    803e8a <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab0:	8b 50 08             	mov    0x8(%eax),%edx
  803ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab6:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab9:	01 c2                	add    %eax,%edx
  803abb:	8b 45 08             	mov    0x8(%ebp),%eax
  803abe:	8b 40 08             	mov    0x8(%eax),%eax
  803ac1:	39 c2                	cmp    %eax,%edx
  803ac3:	0f 85 b9 01 00 00    	jne    803c82 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  803acc:	8b 50 08             	mov    0x8(%eax),%edx
  803acf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad2:	8b 40 0c             	mov    0xc(%eax),%eax
  803ad5:	01 c2                	add    %eax,%edx
  803ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ada:	8b 40 08             	mov    0x8(%eax),%eax
  803add:	39 c2                	cmp    %eax,%edx
  803adf:	0f 85 0d 01 00 00    	jne    803bf2 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae8:	8b 50 0c             	mov    0xc(%eax),%edx
  803aeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aee:	8b 40 0c             	mov    0xc(%eax),%eax
  803af1:	01 c2                	add    %eax,%edx
  803af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af6:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803af9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803afd:	75 17                	jne    803b16 <insert_sorted_with_merge_freeList+0x39c>
  803aff:	83 ec 04             	sub    $0x4,%esp
  803b02:	68 a8 4b 80 00       	push   $0x804ba8
  803b07:	68 5c 01 00 00       	push   $0x15c
  803b0c:	68 ff 4a 80 00       	push   $0x804aff
  803b11:	e8 dd d2 ff ff       	call   800df3 <_panic>
  803b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b19:	8b 00                	mov    (%eax),%eax
  803b1b:	85 c0                	test   %eax,%eax
  803b1d:	74 10                	je     803b2f <insert_sorted_with_merge_freeList+0x3b5>
  803b1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b22:	8b 00                	mov    (%eax),%eax
  803b24:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b27:	8b 52 04             	mov    0x4(%edx),%edx
  803b2a:	89 50 04             	mov    %edx,0x4(%eax)
  803b2d:	eb 0b                	jmp    803b3a <insert_sorted_with_merge_freeList+0x3c0>
  803b2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b32:	8b 40 04             	mov    0x4(%eax),%eax
  803b35:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b3d:	8b 40 04             	mov    0x4(%eax),%eax
  803b40:	85 c0                	test   %eax,%eax
  803b42:	74 0f                	je     803b53 <insert_sorted_with_merge_freeList+0x3d9>
  803b44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b47:	8b 40 04             	mov    0x4(%eax),%eax
  803b4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b4d:	8b 12                	mov    (%edx),%edx
  803b4f:	89 10                	mov    %edx,(%eax)
  803b51:	eb 0a                	jmp    803b5d <insert_sorted_with_merge_freeList+0x3e3>
  803b53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b56:	8b 00                	mov    (%eax),%eax
  803b58:	a3 38 51 80 00       	mov    %eax,0x805138
  803b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b70:	a1 44 51 80 00       	mov    0x805144,%eax
  803b75:	48                   	dec    %eax
  803b76:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803b85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b88:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803b8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b93:	75 17                	jne    803bac <insert_sorted_with_merge_freeList+0x432>
  803b95:	83 ec 04             	sub    $0x4,%esp
  803b98:	68 dc 4a 80 00       	push   $0x804adc
  803b9d:	68 5f 01 00 00       	push   $0x15f
  803ba2:	68 ff 4a 80 00       	push   $0x804aff
  803ba7:	e8 47 d2 ff ff       	call   800df3 <_panic>
  803bac:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bb5:	89 10                	mov    %edx,(%eax)
  803bb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bba:	8b 00                	mov    (%eax),%eax
  803bbc:	85 c0                	test   %eax,%eax
  803bbe:	74 0d                	je     803bcd <insert_sorted_with_merge_freeList+0x453>
  803bc0:	a1 48 51 80 00       	mov    0x805148,%eax
  803bc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bc8:	89 50 04             	mov    %edx,0x4(%eax)
  803bcb:	eb 08                	jmp    803bd5 <insert_sorted_with_merge_freeList+0x45b>
  803bcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803bd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd8:	a3 48 51 80 00       	mov    %eax,0x805148
  803bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803be7:	a1 54 51 80 00       	mov    0x805154,%eax
  803bec:	40                   	inc    %eax
  803bed:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf5:	8b 50 0c             	mov    0xc(%eax),%edx
  803bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfb:	8b 40 0c             	mov    0xc(%eax),%eax
  803bfe:	01 c2                	add    %eax,%edx
  803c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c03:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803c06:	8b 45 08             	mov    0x8(%ebp),%eax
  803c09:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803c10:	8b 45 08             	mov    0x8(%ebp),%eax
  803c13:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c1e:	75 17                	jne    803c37 <insert_sorted_with_merge_freeList+0x4bd>
  803c20:	83 ec 04             	sub    $0x4,%esp
  803c23:	68 dc 4a 80 00       	push   $0x804adc
  803c28:	68 64 01 00 00       	push   $0x164
  803c2d:	68 ff 4a 80 00       	push   $0x804aff
  803c32:	e8 bc d1 ff ff       	call   800df3 <_panic>
  803c37:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803c40:	89 10                	mov    %edx,(%eax)
  803c42:	8b 45 08             	mov    0x8(%ebp),%eax
  803c45:	8b 00                	mov    (%eax),%eax
  803c47:	85 c0                	test   %eax,%eax
  803c49:	74 0d                	je     803c58 <insert_sorted_with_merge_freeList+0x4de>
  803c4b:	a1 48 51 80 00       	mov    0x805148,%eax
  803c50:	8b 55 08             	mov    0x8(%ebp),%edx
  803c53:	89 50 04             	mov    %edx,0x4(%eax)
  803c56:	eb 08                	jmp    803c60 <insert_sorted_with_merge_freeList+0x4e6>
  803c58:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c60:	8b 45 08             	mov    0x8(%ebp),%eax
  803c63:	a3 48 51 80 00       	mov    %eax,0x805148
  803c68:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c72:	a1 54 51 80 00       	mov    0x805154,%eax
  803c77:	40                   	inc    %eax
  803c78:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c7d:	e9 41 02 00 00       	jmp    803ec3 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803c82:	8b 45 08             	mov    0x8(%ebp),%eax
  803c85:	8b 50 08             	mov    0x8(%eax),%edx
  803c88:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8b:	8b 40 0c             	mov    0xc(%eax),%eax
  803c8e:	01 c2                	add    %eax,%edx
  803c90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c93:	8b 40 08             	mov    0x8(%eax),%eax
  803c96:	39 c2                	cmp    %eax,%edx
  803c98:	0f 85 7c 01 00 00    	jne    803e1a <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803c9e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ca2:	74 06                	je     803caa <insert_sorted_with_merge_freeList+0x530>
  803ca4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ca8:	75 17                	jne    803cc1 <insert_sorted_with_merge_freeList+0x547>
  803caa:	83 ec 04             	sub    $0x4,%esp
  803cad:	68 18 4b 80 00       	push   $0x804b18
  803cb2:	68 69 01 00 00       	push   $0x169
  803cb7:	68 ff 4a 80 00       	push   $0x804aff
  803cbc:	e8 32 d1 ff ff       	call   800df3 <_panic>
  803cc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc4:	8b 50 04             	mov    0x4(%eax),%edx
  803cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cca:	89 50 04             	mov    %edx,0x4(%eax)
  803ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cd3:	89 10                	mov    %edx,(%eax)
  803cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd8:	8b 40 04             	mov    0x4(%eax),%eax
  803cdb:	85 c0                	test   %eax,%eax
  803cdd:	74 0d                	je     803cec <insert_sorted_with_merge_freeList+0x572>
  803cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ce2:	8b 40 04             	mov    0x4(%eax),%eax
  803ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  803ce8:	89 10                	mov    %edx,(%eax)
  803cea:	eb 08                	jmp    803cf4 <insert_sorted_with_merge_freeList+0x57a>
  803cec:	8b 45 08             	mov    0x8(%ebp),%eax
  803cef:	a3 38 51 80 00       	mov    %eax,0x805138
  803cf4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  803cfa:	89 50 04             	mov    %edx,0x4(%eax)
  803cfd:	a1 44 51 80 00       	mov    0x805144,%eax
  803d02:	40                   	inc    %eax
  803d03:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803d08:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0b:	8b 50 0c             	mov    0xc(%eax),%edx
  803d0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d11:	8b 40 0c             	mov    0xc(%eax),%eax
  803d14:	01 c2                	add    %eax,%edx
  803d16:	8b 45 08             	mov    0x8(%ebp),%eax
  803d19:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803d1c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d20:	75 17                	jne    803d39 <insert_sorted_with_merge_freeList+0x5bf>
  803d22:	83 ec 04             	sub    $0x4,%esp
  803d25:	68 a8 4b 80 00       	push   $0x804ba8
  803d2a:	68 6b 01 00 00       	push   $0x16b
  803d2f:	68 ff 4a 80 00       	push   $0x804aff
  803d34:	e8 ba d0 ff ff       	call   800df3 <_panic>
  803d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d3c:	8b 00                	mov    (%eax),%eax
  803d3e:	85 c0                	test   %eax,%eax
  803d40:	74 10                	je     803d52 <insert_sorted_with_merge_freeList+0x5d8>
  803d42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d45:	8b 00                	mov    (%eax),%eax
  803d47:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d4a:	8b 52 04             	mov    0x4(%edx),%edx
  803d4d:	89 50 04             	mov    %edx,0x4(%eax)
  803d50:	eb 0b                	jmp    803d5d <insert_sorted_with_merge_freeList+0x5e3>
  803d52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d55:	8b 40 04             	mov    0x4(%eax),%eax
  803d58:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d60:	8b 40 04             	mov    0x4(%eax),%eax
  803d63:	85 c0                	test   %eax,%eax
  803d65:	74 0f                	je     803d76 <insert_sorted_with_merge_freeList+0x5fc>
  803d67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d6a:	8b 40 04             	mov    0x4(%eax),%eax
  803d6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d70:	8b 12                	mov    (%edx),%edx
  803d72:	89 10                	mov    %edx,(%eax)
  803d74:	eb 0a                	jmp    803d80 <insert_sorted_with_merge_freeList+0x606>
  803d76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d79:	8b 00                	mov    (%eax),%eax
  803d7b:	a3 38 51 80 00       	mov    %eax,0x805138
  803d80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d93:	a1 44 51 80 00       	mov    0x805144,%eax
  803d98:	48                   	dec    %eax
  803d99:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803da1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803db2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803db6:	75 17                	jne    803dcf <insert_sorted_with_merge_freeList+0x655>
  803db8:	83 ec 04             	sub    $0x4,%esp
  803dbb:	68 dc 4a 80 00       	push   $0x804adc
  803dc0:	68 6e 01 00 00       	push   $0x16e
  803dc5:	68 ff 4a 80 00       	push   $0x804aff
  803dca:	e8 24 d0 ff ff       	call   800df3 <_panic>
  803dcf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dd8:	89 10                	mov    %edx,(%eax)
  803dda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ddd:	8b 00                	mov    (%eax),%eax
  803ddf:	85 c0                	test   %eax,%eax
  803de1:	74 0d                	je     803df0 <insert_sorted_with_merge_freeList+0x676>
  803de3:	a1 48 51 80 00       	mov    0x805148,%eax
  803de8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803deb:	89 50 04             	mov    %edx,0x4(%eax)
  803dee:	eb 08                	jmp    803df8 <insert_sorted_with_merge_freeList+0x67e>
  803df0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803df3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dfb:	a3 48 51 80 00       	mov    %eax,0x805148
  803e00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803e03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e0a:	a1 54 51 80 00       	mov    0x805154,%eax
  803e0f:	40                   	inc    %eax
  803e10:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803e15:	e9 a9 00 00 00       	jmp    803ec3 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803e1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e1e:	74 06                	je     803e26 <insert_sorted_with_merge_freeList+0x6ac>
  803e20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e24:	75 17                	jne    803e3d <insert_sorted_with_merge_freeList+0x6c3>
  803e26:	83 ec 04             	sub    $0x4,%esp
  803e29:	68 74 4b 80 00       	push   $0x804b74
  803e2e:	68 73 01 00 00       	push   $0x173
  803e33:	68 ff 4a 80 00       	push   $0x804aff
  803e38:	e8 b6 cf ff ff       	call   800df3 <_panic>
  803e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e40:	8b 10                	mov    (%eax),%edx
  803e42:	8b 45 08             	mov    0x8(%ebp),%eax
  803e45:	89 10                	mov    %edx,(%eax)
  803e47:	8b 45 08             	mov    0x8(%ebp),%eax
  803e4a:	8b 00                	mov    (%eax),%eax
  803e4c:	85 c0                	test   %eax,%eax
  803e4e:	74 0b                	je     803e5b <insert_sorted_with_merge_freeList+0x6e1>
  803e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e53:	8b 00                	mov    (%eax),%eax
  803e55:	8b 55 08             	mov    0x8(%ebp),%edx
  803e58:	89 50 04             	mov    %edx,0x4(%eax)
  803e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  803e61:	89 10                	mov    %edx,(%eax)
  803e63:	8b 45 08             	mov    0x8(%ebp),%eax
  803e66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e69:	89 50 04             	mov    %edx,0x4(%eax)
  803e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e6f:	8b 00                	mov    (%eax),%eax
  803e71:	85 c0                	test   %eax,%eax
  803e73:	75 08                	jne    803e7d <insert_sorted_with_merge_freeList+0x703>
  803e75:	8b 45 08             	mov    0x8(%ebp),%eax
  803e78:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803e7d:	a1 44 51 80 00       	mov    0x805144,%eax
  803e82:	40                   	inc    %eax
  803e83:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803e88:	eb 39                	jmp    803ec3 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803e8a:	a1 40 51 80 00       	mov    0x805140,%eax
  803e8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e96:	74 07                	je     803e9f <insert_sorted_with_merge_freeList+0x725>
  803e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e9b:	8b 00                	mov    (%eax),%eax
  803e9d:	eb 05                	jmp    803ea4 <insert_sorted_with_merge_freeList+0x72a>
  803e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  803ea4:	a3 40 51 80 00       	mov    %eax,0x805140
  803ea9:	a1 40 51 80 00       	mov    0x805140,%eax
  803eae:	85 c0                	test   %eax,%eax
  803eb0:	0f 85 c7 fb ff ff    	jne    803a7d <insert_sorted_with_merge_freeList+0x303>
  803eb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803eba:	0f 85 bd fb ff ff    	jne    803a7d <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803ec0:	eb 01                	jmp    803ec3 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803ec2:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803ec3:	90                   	nop
  803ec4:	c9                   	leave  
  803ec5:	c3                   	ret    
  803ec6:	66 90                	xchg   %ax,%ax

00803ec8 <__udivdi3>:
  803ec8:	55                   	push   %ebp
  803ec9:	57                   	push   %edi
  803eca:	56                   	push   %esi
  803ecb:	53                   	push   %ebx
  803ecc:	83 ec 1c             	sub    $0x1c,%esp
  803ecf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ed3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ed7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803edb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803edf:	89 ca                	mov    %ecx,%edx
  803ee1:	89 f8                	mov    %edi,%eax
  803ee3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803ee7:	85 f6                	test   %esi,%esi
  803ee9:	75 2d                	jne    803f18 <__udivdi3+0x50>
  803eeb:	39 cf                	cmp    %ecx,%edi
  803eed:	77 65                	ja     803f54 <__udivdi3+0x8c>
  803eef:	89 fd                	mov    %edi,%ebp
  803ef1:	85 ff                	test   %edi,%edi
  803ef3:	75 0b                	jne    803f00 <__udivdi3+0x38>
  803ef5:	b8 01 00 00 00       	mov    $0x1,%eax
  803efa:	31 d2                	xor    %edx,%edx
  803efc:	f7 f7                	div    %edi
  803efe:	89 c5                	mov    %eax,%ebp
  803f00:	31 d2                	xor    %edx,%edx
  803f02:	89 c8                	mov    %ecx,%eax
  803f04:	f7 f5                	div    %ebp
  803f06:	89 c1                	mov    %eax,%ecx
  803f08:	89 d8                	mov    %ebx,%eax
  803f0a:	f7 f5                	div    %ebp
  803f0c:	89 cf                	mov    %ecx,%edi
  803f0e:	89 fa                	mov    %edi,%edx
  803f10:	83 c4 1c             	add    $0x1c,%esp
  803f13:	5b                   	pop    %ebx
  803f14:	5e                   	pop    %esi
  803f15:	5f                   	pop    %edi
  803f16:	5d                   	pop    %ebp
  803f17:	c3                   	ret    
  803f18:	39 ce                	cmp    %ecx,%esi
  803f1a:	77 28                	ja     803f44 <__udivdi3+0x7c>
  803f1c:	0f bd fe             	bsr    %esi,%edi
  803f1f:	83 f7 1f             	xor    $0x1f,%edi
  803f22:	75 40                	jne    803f64 <__udivdi3+0x9c>
  803f24:	39 ce                	cmp    %ecx,%esi
  803f26:	72 0a                	jb     803f32 <__udivdi3+0x6a>
  803f28:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803f2c:	0f 87 9e 00 00 00    	ja     803fd0 <__udivdi3+0x108>
  803f32:	b8 01 00 00 00       	mov    $0x1,%eax
  803f37:	89 fa                	mov    %edi,%edx
  803f39:	83 c4 1c             	add    $0x1c,%esp
  803f3c:	5b                   	pop    %ebx
  803f3d:	5e                   	pop    %esi
  803f3e:	5f                   	pop    %edi
  803f3f:	5d                   	pop    %ebp
  803f40:	c3                   	ret    
  803f41:	8d 76 00             	lea    0x0(%esi),%esi
  803f44:	31 ff                	xor    %edi,%edi
  803f46:	31 c0                	xor    %eax,%eax
  803f48:	89 fa                	mov    %edi,%edx
  803f4a:	83 c4 1c             	add    $0x1c,%esp
  803f4d:	5b                   	pop    %ebx
  803f4e:	5e                   	pop    %esi
  803f4f:	5f                   	pop    %edi
  803f50:	5d                   	pop    %ebp
  803f51:	c3                   	ret    
  803f52:	66 90                	xchg   %ax,%ax
  803f54:	89 d8                	mov    %ebx,%eax
  803f56:	f7 f7                	div    %edi
  803f58:	31 ff                	xor    %edi,%edi
  803f5a:	89 fa                	mov    %edi,%edx
  803f5c:	83 c4 1c             	add    $0x1c,%esp
  803f5f:	5b                   	pop    %ebx
  803f60:	5e                   	pop    %esi
  803f61:	5f                   	pop    %edi
  803f62:	5d                   	pop    %ebp
  803f63:	c3                   	ret    
  803f64:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f69:	89 eb                	mov    %ebp,%ebx
  803f6b:	29 fb                	sub    %edi,%ebx
  803f6d:	89 f9                	mov    %edi,%ecx
  803f6f:	d3 e6                	shl    %cl,%esi
  803f71:	89 c5                	mov    %eax,%ebp
  803f73:	88 d9                	mov    %bl,%cl
  803f75:	d3 ed                	shr    %cl,%ebp
  803f77:	89 e9                	mov    %ebp,%ecx
  803f79:	09 f1                	or     %esi,%ecx
  803f7b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f7f:	89 f9                	mov    %edi,%ecx
  803f81:	d3 e0                	shl    %cl,%eax
  803f83:	89 c5                	mov    %eax,%ebp
  803f85:	89 d6                	mov    %edx,%esi
  803f87:	88 d9                	mov    %bl,%cl
  803f89:	d3 ee                	shr    %cl,%esi
  803f8b:	89 f9                	mov    %edi,%ecx
  803f8d:	d3 e2                	shl    %cl,%edx
  803f8f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f93:	88 d9                	mov    %bl,%cl
  803f95:	d3 e8                	shr    %cl,%eax
  803f97:	09 c2                	or     %eax,%edx
  803f99:	89 d0                	mov    %edx,%eax
  803f9b:	89 f2                	mov    %esi,%edx
  803f9d:	f7 74 24 0c          	divl   0xc(%esp)
  803fa1:	89 d6                	mov    %edx,%esi
  803fa3:	89 c3                	mov    %eax,%ebx
  803fa5:	f7 e5                	mul    %ebp
  803fa7:	39 d6                	cmp    %edx,%esi
  803fa9:	72 19                	jb     803fc4 <__udivdi3+0xfc>
  803fab:	74 0b                	je     803fb8 <__udivdi3+0xf0>
  803fad:	89 d8                	mov    %ebx,%eax
  803faf:	31 ff                	xor    %edi,%edi
  803fb1:	e9 58 ff ff ff       	jmp    803f0e <__udivdi3+0x46>
  803fb6:	66 90                	xchg   %ax,%ax
  803fb8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803fbc:	89 f9                	mov    %edi,%ecx
  803fbe:	d3 e2                	shl    %cl,%edx
  803fc0:	39 c2                	cmp    %eax,%edx
  803fc2:	73 e9                	jae    803fad <__udivdi3+0xe5>
  803fc4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803fc7:	31 ff                	xor    %edi,%edi
  803fc9:	e9 40 ff ff ff       	jmp    803f0e <__udivdi3+0x46>
  803fce:	66 90                	xchg   %ax,%ax
  803fd0:	31 c0                	xor    %eax,%eax
  803fd2:	e9 37 ff ff ff       	jmp    803f0e <__udivdi3+0x46>
  803fd7:	90                   	nop

00803fd8 <__umoddi3>:
  803fd8:	55                   	push   %ebp
  803fd9:	57                   	push   %edi
  803fda:	56                   	push   %esi
  803fdb:	53                   	push   %ebx
  803fdc:	83 ec 1c             	sub    $0x1c,%esp
  803fdf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803fe3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803fe7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803feb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803fef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ff3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ff7:	89 f3                	mov    %esi,%ebx
  803ff9:	89 fa                	mov    %edi,%edx
  803ffb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fff:	89 34 24             	mov    %esi,(%esp)
  804002:	85 c0                	test   %eax,%eax
  804004:	75 1a                	jne    804020 <__umoddi3+0x48>
  804006:	39 f7                	cmp    %esi,%edi
  804008:	0f 86 a2 00 00 00    	jbe    8040b0 <__umoddi3+0xd8>
  80400e:	89 c8                	mov    %ecx,%eax
  804010:	89 f2                	mov    %esi,%edx
  804012:	f7 f7                	div    %edi
  804014:	89 d0                	mov    %edx,%eax
  804016:	31 d2                	xor    %edx,%edx
  804018:	83 c4 1c             	add    $0x1c,%esp
  80401b:	5b                   	pop    %ebx
  80401c:	5e                   	pop    %esi
  80401d:	5f                   	pop    %edi
  80401e:	5d                   	pop    %ebp
  80401f:	c3                   	ret    
  804020:	39 f0                	cmp    %esi,%eax
  804022:	0f 87 ac 00 00 00    	ja     8040d4 <__umoddi3+0xfc>
  804028:	0f bd e8             	bsr    %eax,%ebp
  80402b:	83 f5 1f             	xor    $0x1f,%ebp
  80402e:	0f 84 ac 00 00 00    	je     8040e0 <__umoddi3+0x108>
  804034:	bf 20 00 00 00       	mov    $0x20,%edi
  804039:	29 ef                	sub    %ebp,%edi
  80403b:	89 fe                	mov    %edi,%esi
  80403d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804041:	89 e9                	mov    %ebp,%ecx
  804043:	d3 e0                	shl    %cl,%eax
  804045:	89 d7                	mov    %edx,%edi
  804047:	89 f1                	mov    %esi,%ecx
  804049:	d3 ef                	shr    %cl,%edi
  80404b:	09 c7                	or     %eax,%edi
  80404d:	89 e9                	mov    %ebp,%ecx
  80404f:	d3 e2                	shl    %cl,%edx
  804051:	89 14 24             	mov    %edx,(%esp)
  804054:	89 d8                	mov    %ebx,%eax
  804056:	d3 e0                	shl    %cl,%eax
  804058:	89 c2                	mov    %eax,%edx
  80405a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80405e:	d3 e0                	shl    %cl,%eax
  804060:	89 44 24 04          	mov    %eax,0x4(%esp)
  804064:	8b 44 24 08          	mov    0x8(%esp),%eax
  804068:	89 f1                	mov    %esi,%ecx
  80406a:	d3 e8                	shr    %cl,%eax
  80406c:	09 d0                	or     %edx,%eax
  80406e:	d3 eb                	shr    %cl,%ebx
  804070:	89 da                	mov    %ebx,%edx
  804072:	f7 f7                	div    %edi
  804074:	89 d3                	mov    %edx,%ebx
  804076:	f7 24 24             	mull   (%esp)
  804079:	89 c6                	mov    %eax,%esi
  80407b:	89 d1                	mov    %edx,%ecx
  80407d:	39 d3                	cmp    %edx,%ebx
  80407f:	0f 82 87 00 00 00    	jb     80410c <__umoddi3+0x134>
  804085:	0f 84 91 00 00 00    	je     80411c <__umoddi3+0x144>
  80408b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80408f:	29 f2                	sub    %esi,%edx
  804091:	19 cb                	sbb    %ecx,%ebx
  804093:	89 d8                	mov    %ebx,%eax
  804095:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804099:	d3 e0                	shl    %cl,%eax
  80409b:	89 e9                	mov    %ebp,%ecx
  80409d:	d3 ea                	shr    %cl,%edx
  80409f:	09 d0                	or     %edx,%eax
  8040a1:	89 e9                	mov    %ebp,%ecx
  8040a3:	d3 eb                	shr    %cl,%ebx
  8040a5:	89 da                	mov    %ebx,%edx
  8040a7:	83 c4 1c             	add    $0x1c,%esp
  8040aa:	5b                   	pop    %ebx
  8040ab:	5e                   	pop    %esi
  8040ac:	5f                   	pop    %edi
  8040ad:	5d                   	pop    %ebp
  8040ae:	c3                   	ret    
  8040af:	90                   	nop
  8040b0:	89 fd                	mov    %edi,%ebp
  8040b2:	85 ff                	test   %edi,%edi
  8040b4:	75 0b                	jne    8040c1 <__umoddi3+0xe9>
  8040b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8040bb:	31 d2                	xor    %edx,%edx
  8040bd:	f7 f7                	div    %edi
  8040bf:	89 c5                	mov    %eax,%ebp
  8040c1:	89 f0                	mov    %esi,%eax
  8040c3:	31 d2                	xor    %edx,%edx
  8040c5:	f7 f5                	div    %ebp
  8040c7:	89 c8                	mov    %ecx,%eax
  8040c9:	f7 f5                	div    %ebp
  8040cb:	89 d0                	mov    %edx,%eax
  8040cd:	e9 44 ff ff ff       	jmp    804016 <__umoddi3+0x3e>
  8040d2:	66 90                	xchg   %ax,%ax
  8040d4:	89 c8                	mov    %ecx,%eax
  8040d6:	89 f2                	mov    %esi,%edx
  8040d8:	83 c4 1c             	add    $0x1c,%esp
  8040db:	5b                   	pop    %ebx
  8040dc:	5e                   	pop    %esi
  8040dd:	5f                   	pop    %edi
  8040de:	5d                   	pop    %ebp
  8040df:	c3                   	ret    
  8040e0:	3b 04 24             	cmp    (%esp),%eax
  8040e3:	72 06                	jb     8040eb <__umoddi3+0x113>
  8040e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040e9:	77 0f                	ja     8040fa <__umoddi3+0x122>
  8040eb:	89 f2                	mov    %esi,%edx
  8040ed:	29 f9                	sub    %edi,%ecx
  8040ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040f3:	89 14 24             	mov    %edx,(%esp)
  8040f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040fe:	8b 14 24             	mov    (%esp),%edx
  804101:	83 c4 1c             	add    $0x1c,%esp
  804104:	5b                   	pop    %ebx
  804105:	5e                   	pop    %esi
  804106:	5f                   	pop    %edi
  804107:	5d                   	pop    %ebp
  804108:	c3                   	ret    
  804109:	8d 76 00             	lea    0x0(%esi),%esi
  80410c:	2b 04 24             	sub    (%esp),%eax
  80410f:	19 fa                	sbb    %edi,%edx
  804111:	89 d1                	mov    %edx,%ecx
  804113:	89 c6                	mov    %eax,%esi
  804115:	e9 71 ff ff ff       	jmp    80408b <__umoddi3+0xb3>
  80411a:	66 90                	xchg   %ax,%ax
  80411c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804120:	72 ea                	jb     80410c <__umoddi3+0x134>
  804122:	89 d9                	mov    %ebx,%ecx
  804124:	e9 62 ff ff ff       	jmp    80408b <__umoddi3+0xb3>
