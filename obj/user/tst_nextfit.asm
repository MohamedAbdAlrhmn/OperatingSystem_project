
obj/user/tst_nextfit:     file format elf32-i386


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
  800031:	e8 b6 0b 00 00       	call   800bec <libmain>
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
	int Mega = 1024*1024;
  800043:	c7 45 d8 00 00 10 00 	movl   $0x100000,-0x28(%ebp)
	int kilo = 1024;
  80004a:	c7 45 d4 00 04 00 00 	movl   $0x400,-0x2c(%ebp)
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  800051:	83 ec 0c             	sub    $0xc,%esp
  800054:	6a 03                	push   $0x3
  800056:	e8 cb 26 00 00       	call   802726 <sys_set_uheap_strategy>
  80005b:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80005e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800062:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800069:	eb 29                	jmp    800094 <_main+0x5c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80006b:	a1 20 50 80 00       	mov    0x805020,%eax
  800070:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800076:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800079:	89 d0                	mov    %edx,%eax
  80007b:	01 c0                	add    %eax,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	c1 e0 03             	shl    $0x3,%eax
  800082:	01 c8                	add    %ecx,%eax
  800084:	8a 40 04             	mov    0x4(%eax),%al
  800087:	84 c0                	test   %al,%al
  800089:	74 06                	je     800091 <_main+0x59>
			{
				fullWS = 0;
  80008b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80008f:	eb 12                	jmp    8000a3 <_main+0x6b>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800091:	ff 45 f0             	incl   -0x10(%ebp)
  800094:	a1 20 50 80 00       	mov    0x805020,%eax
  800099:	8b 50 74             	mov    0x74(%eax),%edx
  80009c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009f:	39 c2                	cmp    %eax,%edx
  8000a1:	77 c8                	ja     80006b <_main+0x33>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  8000a3:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  8000a7:	74 14                	je     8000bd <_main+0x85>
  8000a9:	83 ec 04             	sub    $0x4,%esp
  8000ac:	68 40 40 80 00       	push   $0x804040
  8000b1:	6a 18                	push   $0x18
  8000b3:	68 5c 40 80 00       	push   $0x80405c
  8000b8:	e8 6b 0c 00 00       	call   800d28 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	6a 00                	push   $0x0
  8000c2:	e8 9d 1e 00 00       	call   801f64 <malloc>
  8000c7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	//Make sure that the heap size is 512 MB
	int numOf2MBsInHeap = (USER_HEAP_MAX - USER_HEAP_START) / (2*Mega);
  8000ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000cd:	01 c0                	add    %eax,%eax
  8000cf:	89 c7                	mov    %eax,%edi
  8000d1:	b8 00 00 00 20       	mov    $0x20000000,%eax
  8000d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8000db:	f7 f7                	div    %edi
  8000dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
	assert(numOf2MBsInHeap == 256);
  8000e0:	81 7d d0 00 01 00 00 	cmpl   $0x100,-0x30(%ebp)
  8000e7:	74 16                	je     8000ff <_main+0xc7>
  8000e9:	68 6f 40 80 00       	push   $0x80406f
  8000ee:	68 86 40 80 00       	push   $0x804086
  8000f3:	6a 20                	push   $0x20
  8000f5:	68 5c 40 80 00       	push   $0x80405c
  8000fa:	e8 29 0c 00 00       	call   800d28 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 03                	push   $0x3
  800104:	e8 1d 26 00 00       	call   802726 <sys_set_uheap_strategy>
  800109:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80010c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800110:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800117:	eb 29                	jmp    800142 <_main+0x10a>
		{
			if (myEnv->__uptr_pws[i].empty)
  800119:	a1 20 50 80 00       	mov    0x805020,%eax
  80011e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800124:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800127:	89 d0                	mov    %edx,%eax
  800129:	01 c0                	add    %eax,%eax
  80012b:	01 d0                	add    %edx,%eax
  80012d:	c1 e0 03             	shl    $0x3,%eax
  800130:	01 c8                	add    %ecx,%eax
  800132:	8a 40 04             	mov    0x4(%eax),%al
  800135:	84 c0                	test   %al,%al
  800137:	74 06                	je     80013f <_main+0x107>
			{
				fullWS = 0;
  800139:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
				break;
  80013d:	eb 12                	jmp    800151 <_main+0x119>
	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80013f:	ff 45 e8             	incl   -0x18(%ebp)
  800142:	a1 20 50 80 00       	mov    0x805020,%eax
  800147:	8b 50 74             	mov    0x74(%eax),%edx
  80014a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80014d:	39 c2                	cmp    %eax,%edx
  80014f:	77 c8                	ja     800119 <_main+0xe1>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800151:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  800155:	74 14                	je     80016b <_main+0x133>
  800157:	83 ec 04             	sub    $0x4,%esp
  80015a:	68 40 40 80 00       	push   $0x804040
  80015f:	6a 32                	push   $0x32
  800161:	68 5c 40 80 00       	push   $0x80405c
  800166:	e8 bd 0b 00 00       	call   800d28 <_panic>

	int freeFrames ;
	int usedDiskPages;

	//[0] Make sure there're available places in the WS
	int w = 0 ;
  80016b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	int requiredNumOfEmptyWSLocs = 2;
  800172:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
	int numOfEmptyWSLocs = 0;
  800179:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  800180:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800187:	eb 26                	jmp    8001af <_main+0x177>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
  800189:	a1 20 50 80 00       	mov    0x805020,%eax
  80018e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800197:	89 d0                	mov    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	c1 e0 03             	shl    $0x3,%eax
  8001a0:	01 c8                	add    %ecx,%eax
  8001a2:	8a 40 04             	mov    0x4(%eax),%al
  8001a5:	3c 01                	cmp    $0x1,%al
  8001a7:	75 03                	jne    8001ac <_main+0x174>
			numOfEmptyWSLocs++;
  8001a9:	ff 45 e0             	incl   -0x20(%ebp)

	//[0] Make sure there're available places in the WS
	int w = 0 ;
	int requiredNumOfEmptyWSLocs = 2;
	int numOfEmptyWSLocs = 0;
	for (w = 0 ; w < myEnv->page_WS_max_size ; w++)
  8001ac:	ff 45 e4             	incl   -0x1c(%ebp)
  8001af:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b4:	8b 50 74             	mov    0x74(%eax),%edx
  8001b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ba:	39 c2                	cmp    %eax,%edx
  8001bc:	77 cb                	ja     800189 <_main+0x151>
	{
		if( myEnv->__uptr_pws[w].empty == 1)
			numOfEmptyWSLocs++;
	}
	if (numOfEmptyWSLocs < requiredNumOfEmptyWSLocs)
  8001be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c1:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c4:	7d 14                	jge    8001da <_main+0x1a2>
		panic("Insufficient number of WS empty locations! please increase the PAGE_WS_MAX_SIZE");
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 9c 40 80 00       	push   $0x80409c
  8001ce:	6a 43                	push   $0x43
  8001d0:	68 5c 40 80 00       	push   $0x80405c
  8001d5:	e8 4e 0b 00 00       	call   800d28 <_panic>


	void* ptr_allocations[512] = {0};
  8001da:	8d 95 c0 f7 ff ff    	lea    -0x840(%ebp),%edx
  8001e0:	b9 00 02 00 00       	mov    $0x200,%ecx
  8001e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001ea:	89 d7                	mov    %edx,%edi
  8001ec:	f3 ab                	rep stos %eax,%es:(%edi)
	int i;

	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	68 ec 40 80 00       	push   $0x8040ec
  8001f6:	e8 e1 0d 00 00       	call   800fdc <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 0e 20 00 00       	call   802211 <sys_calculate_free_frames>
  800203:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 a6 20 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  80020b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	for(i = 0; i< 256;i++)
  80020e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800215:	eb 20                	jmp    800237 <_main+0x1ff>
	{
		ptr_allocations[i] = malloc(2*Mega);
  800217:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	83 ec 0c             	sub    $0xc,%esp
  80021f:	50                   	push   %eax
  800220:	e8 3f 1d 00 00       	call   801f64 <malloc>
  800225:	83 c4 10             	add    $0x10,%esp
  800228:	89 c2                	mov    %eax,%edx
  80022a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022d:	89 94 85 c0 f7 ff ff 	mov    %edx,-0x840(%ebp,%eax,4)
	cprintf("This test has THREE cases. A pass message will be displayed after each one.\n");

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
	usedDiskPages = sys_pf_calculate_allocated_pages();
	for(i = 0; i< 256;i++)
  800234:	ff 45 dc             	incl   -0x24(%ebp)
  800237:	81 7d dc ff 00 00 00 	cmpl   $0xff,-0x24(%ebp)
  80023e:	7e d7                	jle    800217 <_main+0x1df>
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800240:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  800246:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80024b:	75 5b                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
  80024d:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
	{
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
  800253:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800258:	75 4e                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80025a:	8b 85 e0 f7 ff ff    	mov    -0x820(%ebp),%eax
		ptr_allocations[i] = malloc(2*Mega);
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
  800260:	3d 00 00 00 81       	cmp    $0x81000000,%eax
  800265:	75 41                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  800267:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
	}

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
  80026d:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  800272:	75 34                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800274:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax

	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
  80027a:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80027f:	75 27                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800281:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
	// randomly check the addresses of the allocation
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
  800287:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  80028c:	75 1a                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  80028e:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
	if( 	(uint32)ptr_allocations[0] != 0x80000000 ||
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
  800294:	3d 00 00 20 83       	cmp    $0x83200000,%eax
  800299:	75 0d                	jne    8002a8 <_main+0x270>
			(uint32)ptr_allocations[25] != 0x83200000 ||
			(uint32)ptr_allocations[255] != 0x9FE00000)
  80029b:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
			(uint32)ptr_allocations[2] != 0x80400000 ||
			(uint32)ptr_allocations[8] != 0x81000000 ||
			(uint32)ptr_allocations[10] != 0x81400000 ||
			(uint32)ptr_allocations[15] != 0x81e00000 ||
			(uint32)ptr_allocations[20] != 0x82800000 ||
			(uint32)ptr_allocations[25] != 0x83200000 ||
  8002a1:	3d 00 00 e0 9f       	cmp    $0x9fe00000,%eax
  8002a6:	74 14                	je     8002bc <_main+0x284>
			(uint32)ptr_allocations[255] != 0x9FE00000)
		panic("Wrong allocation, Check fitting strategy is working correctly");
  8002a8:	83 ec 04             	sub    $0x4,%esp
  8002ab:	68 3c 41 80 00       	push   $0x80413c
  8002b0:	6a 5c                	push   $0x5c
  8002b2:	68 5c 40 80 00       	push   $0x80405c
  8002b7:	e8 6c 0a 00 00       	call   800d28 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002bc:	e8 f0 1f 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  8002c1:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8002c4:	89 c2                	mov    %eax,%edx
  8002c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c9:	c1 e0 09             	shl    $0x9,%eax
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	79 05                	jns    8002d5 <_main+0x29d>
  8002d0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8002d5:	c1 f8 0c             	sar    $0xc,%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 7a 41 80 00       	push   $0x80417a
  8002e4:	6a 5e                	push   $0x5e
  8002e6:	68 5c 40 80 00       	push   $0x80405c
  8002eb:	e8 38 0a 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  8002f3:	e8 19 1f 00 00       	call   802211 <sys_calculate_free_frames>
  8002f8:	29 c3                	sub    %eax,%ebx
  8002fa:	89 da                	mov    %ebx,%edx
  8002fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ff:	c1 e0 09             	shl    $0x9,%eax
  800302:	85 c0                	test   %eax,%eax
  800304:	79 05                	jns    80030b <_main+0x2d3>
  800306:	05 ff ff 3f 00       	add    $0x3fffff,%eax
  80030b:	c1 f8 16             	sar    $0x16,%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	74 14                	je     800326 <_main+0x2ee>
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 97 41 80 00       	push   $0x804197
  80031a:	6a 5f                	push   $0x5f
  80031c:	68 5c 40 80 00       	push   $0x80405c
  800321:	e8 02 0a 00 00       	call   800d28 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  800326:	e8 e6 1e 00 00       	call   802211 <sys_calculate_free_frames>
  80032b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80032e:	e8 7e 1f 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800333:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  800336:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	e8 4d 1c 00 00       	call   801f92 <free>
  800345:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  800348:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	50                   	push   %eax
  800352:	e8 3b 1c 00 00       	call   801f92 <free>
  800357:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035a:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	50                   	push   %eax
  800364:	e8 29 1c 00 00       	call   801f92 <free>
  800369:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[5]);		// Hole 3 = 2 M
  80036c:	8b 85 d4 f7 ff ff    	mov    -0x82c(%ebp),%eax
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	50                   	push   %eax
  800376:	e8 17 1c 00 00       	call   801f92 <free>
  80037b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 4 = 6 M
  80037e:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	e8 05 1c 00 00       	call   801f92 <free>
  80038d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800390:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	50                   	push   %eax
  80039a:	e8 f3 1b 00 00       	call   801f92 <free>
  80039f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  8003a2:	8b 85 ec f7 ff ff    	mov    -0x814(%ebp),%eax
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	50                   	push   %eax
  8003ac:	e8 e1 1b 00 00       	call   801f92 <free>
  8003b1:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[20]);		// Hole 5 = 2 M
  8003b4:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	50                   	push   %eax
  8003be:	e8 cf 1b 00 00       	call   801f92 <free>
  8003c3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[25]);		// Hole 6 = 2 M
  8003c6:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	50                   	push   %eax
  8003d0:	e8 bd 1b 00 00       	call   801f92 <free>
  8003d5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[255]);		// Hole 7 = 2 M
  8003d8:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	50                   	push   %eax
  8003e2:	e8 ab 1b 00 00       	call   801f92 <free>
  8003e7:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 10*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8003ea:	e8 c2 1e 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  8003ef:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003f2:	89 d1                	mov    %edx,%ecx
  8003f4:	29 c1                	sub    %eax,%ecx
  8003f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	c1 e0 02             	shl    $0x2,%eax
  8003fe:	01 d0                	add    %edx,%eax
  800400:	c1 e0 02             	shl    $0x2,%eax
  800403:	85 c0                	test   %eax,%eax
  800405:	79 05                	jns    80040c <_main+0x3d4>
  800407:	05 ff 0f 00 00       	add    $0xfff,%eax
  80040c:	c1 f8 0c             	sar    $0xc,%eax
  80040f:	39 c1                	cmp    %eax,%ecx
  800411:	74 14                	je     800427 <_main+0x3ef>
  800413:	83 ec 04             	sub    $0x4,%esp
  800416:	68 a8 41 80 00       	push   $0x8041a8
  80041b:	6a 70                	push   $0x70
  80041d:	68 5c 40 80 00       	push   $0x80405c
  800422:	e8 01 09 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800427:	e8 e5 1d 00 00       	call   802211 <sys_calculate_free_frames>
  80042c:	89 c2                	mov    %eax,%edx
  80042e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800431:	39 c2                	cmp    %eax,%edx
  800433:	74 14                	je     800449 <_main+0x411>
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 e4 41 80 00       	push   $0x8041e4
  80043d:	6a 71                	push   $0x71
  80043f:	68 5c 40 80 00       	push   $0x80405c
  800444:	e8 df 08 00 00       	call   800d28 <_panic>

	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  800449:	e8 c3 1d 00 00       	call   802211 <sys_calculate_free_frames>
  80044e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800451:	e8 5b 1e 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800456:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	void* tempAddress = malloc(Mega-kilo);		// Use Hole 1 -> Hole 1 = 1 M
  800459:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80045c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80045f:	83 ec 0c             	sub    $0xc,%esp
  800462:	50                   	push   %eax
  800463:	e8 fc 1a 00 00       	call   801f64 <malloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80000000)
  80046e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800471:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800476:	74 14                	je     80048c <_main+0x454>
		panic("Next Fit not working correctly");
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	68 24 42 80 00       	push   $0x804224
  800480:	6a 79                	push   $0x79
  800482:	68 5c 40 80 00       	push   $0x80405c
  800487:	e8 9c 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80048c:	e8 20 1e 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800491:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800494:	89 c2                	mov    %eax,%edx
  800496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800499:	85 c0                	test   %eax,%eax
  80049b:	79 05                	jns    8004a2 <_main+0x46a>
  80049d:	05 ff 0f 00 00       	add    $0xfff,%eax
  8004a2:	c1 f8 0c             	sar    $0xc,%eax
  8004a5:	39 c2                	cmp    %eax,%edx
  8004a7:	74 14                	je     8004bd <_main+0x485>
  8004a9:	83 ec 04             	sub    $0x4,%esp
  8004ac:	68 7a 41 80 00       	push   $0x80417a
  8004b1:	6a 7a                	push   $0x7a
  8004b3:	68 5c 40 80 00       	push   $0x80405c
  8004b8:	e8 6b 08 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004bd:	e8 4f 1d 00 00       	call   802211 <sys_calculate_free_frames>
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 97 41 80 00       	push   $0x804197
  8004d3:	6a 7b                	push   $0x7b
  8004d5:	68 5c 40 80 00       	push   $0x80405c
  8004da:	e8 49 08 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8004df:	e8 2d 1d 00 00       	call   802211 <sys_calculate_free_frames>
  8004e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e7:	e8 c5 1d 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  8004ec:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo);					// Use Hole 1 -> Hole 1 = 1 M - Kilo
  8004ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	50                   	push   %eax
  8004f6:	e8 69 1a 00 00       	call   801f64 <malloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80100000)
  800501:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800504:	3d 00 00 10 80       	cmp    $0x80100000,%eax
  800509:	74 17                	je     800522 <_main+0x4ea>
		panic("Next Fit not working correctly");
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	68 24 42 80 00       	push   $0x804224
  800513:	68 81 00 00 00       	push   $0x81
  800518:	68 5c 40 80 00       	push   $0x80405c
  80051d:	e8 06 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800522:	e8 8a 1d 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800527:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80052a:	89 c2                	mov    %eax,%edx
  80052c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052f:	c1 e0 02             	shl    $0x2,%eax
  800532:	85 c0                	test   %eax,%eax
  800534:	79 05                	jns    80053b <_main+0x503>
  800536:	05 ff 0f 00 00       	add    $0xfff,%eax
  80053b:	c1 f8 0c             	sar    $0xc,%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 17                	je     800559 <_main+0x521>
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 7a 41 80 00       	push   $0x80417a
  80054a:	68 82 00 00 00       	push   $0x82
  80054f:	68 5c 40 80 00       	push   $0x80405c
  800554:	e8 cf 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800559:	e8 b3 1c 00 00       	call   802211 <sys_calculate_free_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 17                	je     80057e <_main+0x546>
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 97 41 80 00       	push   $0x804197
  80056f:	68 83 00 00 00       	push   $0x83
  800574:	68 5c 40 80 00       	push   $0x80405c
  800579:	e8 aa 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80057e:	e8 8e 1c 00 00       	call   802211 <sys_calculate_free_frames>
  800583:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800586:	e8 26 1d 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  80058b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(5*Mega); 			   // Use Hole 4 -> Hole 4 = 1 M
  80058e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800591:	89 d0                	mov    %edx,%eax
  800593:	c1 e0 02             	shl    $0x2,%eax
  800596:	01 d0                	add    %edx,%eax
  800598:	83 ec 0c             	sub    $0xc,%esp
  80059b:	50                   	push   %eax
  80059c:	e8 c3 19 00 00       	call   801f64 <malloc>
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81400000)
  8005a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005aa:	3d 00 00 40 81       	cmp    $0x81400000,%eax
  8005af:	74 17                	je     8005c8 <_main+0x590>
		panic("Next Fit not working correctly");
  8005b1:	83 ec 04             	sub    $0x4,%esp
  8005b4:	68 24 42 80 00       	push   $0x804224
  8005b9:	68 89 00 00 00       	push   $0x89
  8005be:	68 5c 40 80 00       	push   $0x80405c
  8005c3:	e8 60 07 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005c8:	e8 e4 1c 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  8005cd:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8005d0:	89 c1                	mov    %eax,%ecx
  8005d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d5:	89 d0                	mov    %edx,%eax
  8005d7:	c1 e0 02             	shl    $0x2,%eax
  8005da:	01 d0                	add    %edx,%eax
  8005dc:	85 c0                	test   %eax,%eax
  8005de:	79 05                	jns    8005e5 <_main+0x5ad>
  8005e0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005e5:	c1 f8 0c             	sar    $0xc,%eax
  8005e8:	39 c1                	cmp    %eax,%ecx
  8005ea:	74 17                	je     800603 <_main+0x5cb>
  8005ec:	83 ec 04             	sub    $0x4,%esp
  8005ef:	68 7a 41 80 00       	push   $0x80417a
  8005f4:	68 8a 00 00 00       	push   $0x8a
  8005f9:	68 5c 40 80 00       	push   $0x80405c
  8005fe:	e8 25 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800603:	e8 09 1c 00 00       	call   802211 <sys_calculate_free_frames>
  800608:	89 c2                	mov    %eax,%edx
  80060a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	74 17                	je     800628 <_main+0x5f0>
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	68 97 41 80 00       	push   $0x804197
  800619:	68 8b 00 00 00       	push   $0x8b
  80061e:	68 5c 40 80 00       	push   $0x80405c
  800623:	e8 00 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800628:	e8 e4 1b 00 00       	call   802211 <sys_calculate_free_frames>
  80062d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800630:	e8 7c 1c 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800635:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(1*Mega); 			   // Use Hole 4 -> Hole 4 = 0 M
  800638:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063b:	83 ec 0c             	sub    $0xc,%esp
  80063e:	50                   	push   %eax
  80063f:	e8 20 19 00 00       	call   801f64 <malloc>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81900000)
  80064a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80064d:	3d 00 00 90 81       	cmp    $0x81900000,%eax
  800652:	74 17                	je     80066b <_main+0x633>
		panic("Next Fit not working correctly");
  800654:	83 ec 04             	sub    $0x4,%esp
  800657:	68 24 42 80 00       	push   $0x804224
  80065c:	68 91 00 00 00       	push   $0x91
  800661:	68 5c 40 80 00       	push   $0x80405c
  800666:	e8 bd 06 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80066b:	e8 41 1c 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800670:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800673:	89 c2                	mov    %eax,%edx
  800675:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800678:	85 c0                	test   %eax,%eax
  80067a:	79 05                	jns    800681 <_main+0x649>
  80067c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800681:	c1 f8 0c             	sar    $0xc,%eax
  800684:	39 c2                	cmp    %eax,%edx
  800686:	74 17                	je     80069f <_main+0x667>
  800688:	83 ec 04             	sub    $0x4,%esp
  80068b:	68 7a 41 80 00       	push   $0x80417a
  800690:	68 92 00 00 00       	push   $0x92
  800695:	68 5c 40 80 00       	push   $0x80405c
  80069a:	e8 89 06 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069f:	e8 6d 1b 00 00       	call   802211 <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 97 41 80 00       	push   $0x804197
  8006b5:	68 93 00 00 00       	push   $0x93
  8006ba:	68 5c 40 80 00       	push   $0x80405c
  8006bf:	e8 64 06 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 48 1b 00 00       	call   802211 <sys_calculate_free_frames>
  8006c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 e0 1b 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  8006d4:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	50                   	push   %eax
  8006de:	e8 af 18 00 00       	call   801f92 <free>
  8006e3:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e6:	e8 c6 1b 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  8006eb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006ee:	29 c2                	sub    %eax,%edx
  8006f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006f3:	01 c0                	add    %eax,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	79 05                	jns    8006fe <_main+0x6c6>
  8006f9:	05 ff 0f 00 00       	add    $0xfff,%eax
  8006fe:	c1 f8 0c             	sar    $0xc,%eax
  800701:	39 c2                	cmp    %eax,%edx
  800703:	74 17                	je     80071c <_main+0x6e4>
  800705:	83 ec 04             	sub    $0x4,%esp
  800708:	68 a8 41 80 00       	push   $0x8041a8
  80070d:	68 99 00 00 00       	push   $0x99
  800712:	68 5c 40 80 00       	push   $0x80405c
  800717:	e8 0c 06 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80071c:	e8 f0 1a 00 00       	call   802211 <sys_calculate_free_frames>
  800721:	89 c2                	mov    %eax,%edx
  800723:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800726:	39 c2                	cmp    %eax,%edx
  800728:	74 17                	je     800741 <_main+0x709>
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	68 e4 41 80 00       	push   $0x8041e4
  800732:	68 9a 00 00 00       	push   $0x9a
  800737:	68 5c 40 80 00       	push   $0x80405c
  80073c:	e8 e7 05 00 00       	call   800d28 <_panic>

	//[NEXT FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  800741:	e8 cb 1a 00 00       	call   802211 <sys_calculate_free_frames>
  800746:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800749:	e8 63 1b 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  80074e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(kilo); 			   // Use new Hole = 2 M - 4 kilo
  800751:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800754:	83 ec 0c             	sub    $0xc,%esp
  800757:	50                   	push   %eax
  800758:	e8 07 18 00 00       	call   801f64 <malloc>
  80075d:	83 c4 10             	add    $0x10,%esp
  800760:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E00000)
  800763:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800766:	3d 00 00 e0 81       	cmp    $0x81e00000,%eax
  80076b:	74 17                	je     800784 <_main+0x74c>
		panic("Next Fit not working correctly");
  80076d:	83 ec 04             	sub    $0x4,%esp
  800770:	68 24 42 80 00       	push   $0x804224
  800775:	68 a1 00 00 00       	push   $0xa1
  80077a:	68 5c 40 80 00       	push   $0x80405c
  80077f:	e8 a4 05 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800784:	e8 28 1b 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800789:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80078c:	89 c2                	mov    %eax,%edx
  80078e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800791:	c1 e0 02             	shl    $0x2,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	79 05                	jns    80079d <_main+0x765>
  800798:	05 ff 0f 00 00       	add    $0xfff,%eax
  80079d:	c1 f8 0c             	sar    $0xc,%eax
  8007a0:	39 c2                	cmp    %eax,%edx
  8007a2:	74 17                	je     8007bb <_main+0x783>
  8007a4:	83 ec 04             	sub    $0x4,%esp
  8007a7:	68 7a 41 80 00       	push   $0x80417a
  8007ac:	68 a2 00 00 00       	push   $0xa2
  8007b1:	68 5c 40 80 00       	push   $0x80405c
  8007b6:	e8 6d 05 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007bb:	e8 51 1a 00 00       	call   802211 <sys_calculate_free_frames>
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c5:	39 c2                	cmp    %eax,%edx
  8007c7:	74 17                	je     8007e0 <_main+0x7a8>
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	68 97 41 80 00       	push   $0x804197
  8007d1:	68 a3 00 00 00       	push   $0xa3
  8007d6:	68 5c 40 80 00       	push   $0x80405c
  8007db:	e8 48 05 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8007e0:	e8 2c 1a 00 00       	call   802211 <sys_calculate_free_frames>
  8007e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e8:	e8 c4 1a 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  8007ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(Mega + 1016*kilo); 	// Use new Hole = 4 kilo
  8007f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007f3:	c1 e0 03             	shl    $0x3,%eax
  8007f6:	89 c2                	mov    %eax,%edx
  8007f8:	c1 e2 07             	shl    $0x7,%edx
  8007fb:	29 c2                	sub    %eax,%edx
  8007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800800:	01 d0                	add    %edx,%eax
  800802:	83 ec 0c             	sub    $0xc,%esp
  800805:	50                   	push   %eax
  800806:	e8 59 17 00 00       	call   801f64 <malloc>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x81E01000)
  800811:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800814:	3d 00 10 e0 81       	cmp    $0x81e01000,%eax
  800819:	74 17                	je     800832 <_main+0x7fa>
		panic("Next Fit not working correctly");
  80081b:	83 ec 04             	sub    $0x4,%esp
  80081e:	68 24 42 80 00       	push   $0x804224
  800823:	68 a9 00 00 00       	push   $0xa9
  800828:	68 5c 40 80 00       	push   $0x80405c
  80082d:	e8 f6 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800832:	e8 7a 1a 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800837:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  80083a:	89 c2                	mov    %eax,%edx
  80083c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80083f:	c1 e0 03             	shl    $0x3,%eax
  800842:	89 c1                	mov    %eax,%ecx
  800844:	c1 e1 07             	shl    $0x7,%ecx
  800847:	29 c1                	sub    %eax,%ecx
  800849:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80084c:	01 c8                	add    %ecx,%eax
  80084e:	85 c0                	test   %eax,%eax
  800850:	79 05                	jns    800857 <_main+0x81f>
  800852:	05 ff 0f 00 00       	add    $0xfff,%eax
  800857:	c1 f8 0c             	sar    $0xc,%eax
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	74 17                	je     800875 <_main+0x83d>
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	68 7a 41 80 00       	push   $0x80417a
  800866:	68 aa 00 00 00       	push   $0xaa
  80086b:	68 5c 40 80 00       	push   $0x80405c
  800870:	e8 b3 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800875:	e8 97 19 00 00       	call   802211 <sys_calculate_free_frames>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	74 17                	je     80089a <_main+0x862>
  800883:	83 ec 04             	sub    $0x4,%esp
  800886:	68 97 41 80 00       	push   $0x804197
  80088b:	68 ab 00 00 00       	push   $0xab
  800890:	68 5c 40 80 00       	push   $0x80405c
  800895:	e8 8e 04 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80089a:	e8 72 19 00 00       	call   802211 <sys_calculate_free_frames>
  80089f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a2:	e8 0a 1a 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  8008a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(512*kilo); 			   // Use Hole 5 -> Hole 5 = 1.5 M
  8008aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ad:	c1 e0 09             	shl    $0x9,%eax
  8008b0:	83 ec 0c             	sub    $0xc,%esp
  8008b3:	50                   	push   %eax
  8008b4:	e8 ab 16 00 00       	call   801f64 <malloc>
  8008b9:	83 c4 10             	add    $0x10,%esp
  8008bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x82800000)
  8008bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008c2:	3d 00 00 80 82       	cmp    $0x82800000,%eax
  8008c7:	74 17                	je     8008e0 <_main+0x8a8>
		panic("Next Fit not working correctly");
  8008c9:	83 ec 04             	sub    $0x4,%esp
  8008cc:	68 24 42 80 00       	push   $0x804224
  8008d1:	68 b1 00 00 00       	push   $0xb1
  8008d6:	68 5c 40 80 00       	push   $0x80405c
  8008db:	e8 48 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8008e0:	e8 cc 19 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  8008e5:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8008e8:	89 c2                	mov    %eax,%edx
  8008ea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008ed:	c1 e0 09             	shl    $0x9,%eax
  8008f0:	85 c0                	test   %eax,%eax
  8008f2:	79 05                	jns    8008f9 <_main+0x8c1>
  8008f4:	05 ff 0f 00 00       	add    $0xfff,%eax
  8008f9:	c1 f8 0c             	sar    $0xc,%eax
  8008fc:	39 c2                	cmp    %eax,%edx
  8008fe:	74 17                	je     800917 <_main+0x8df>
  800900:	83 ec 04             	sub    $0x4,%esp
  800903:	68 7a 41 80 00       	push   $0x80417a
  800908:	68 b2 00 00 00       	push   $0xb2
  80090d:	68 5c 40 80 00       	push   $0x80405c
  800912:	e8 11 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800917:	e8 f5 18 00 00       	call   802211 <sys_calculate_free_frames>
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	74 17                	je     80093c <_main+0x904>
  800925:	83 ec 04             	sub    $0x4,%esp
  800928:	68 97 41 80 00       	push   $0x804197
  80092d:	68 b3 00 00 00       	push   $0xb3
  800932:	68 5c 40 80 00       	push   $0x80405c
  800937:	e8 ec 03 00 00       	call   800d28 <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	68 44 42 80 00       	push   $0x804244
  800944:	e8 93 06 00 00       	call   800fdc <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  80094c:	e8 c0 18 00 00       	call   802211 <sys_calculate_free_frames>
  800951:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800954:	e8 58 19 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800959:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(3*Mega + 512*kilo); 			   // Use Hole 2 -> Hole 2 = 0.5 M
  80095c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80095f:	89 c2                	mov    %eax,%edx
  800961:	01 d2                	add    %edx,%edx
  800963:	01 c2                	add    %eax,%edx
  800965:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800968:	c1 e0 09             	shl    $0x9,%eax
  80096b:	01 d0                	add    %edx,%eax
  80096d:	83 ec 0c             	sub    $0xc,%esp
  800970:	50                   	push   %eax
  800971:	e8 ee 15 00 00       	call   801f64 <malloc>
  800976:	83 c4 10             	add    $0x10,%esp
  800979:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x80400000)
  80097c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80097f:	3d 00 00 40 80       	cmp    $0x80400000,%eax
  800984:	74 17                	je     80099d <_main+0x965>
		panic("Next Fit not working correctly");
  800986:	83 ec 04             	sub    $0x4,%esp
  800989:	68 24 42 80 00       	push   $0x804224
  80098e:	68 bc 00 00 00       	push   $0xbc
  800993:	68 5c 40 80 00       	push   $0x80405c
  800998:	e8 8b 03 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80099d:	e8 0f 19 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  8009a2:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  8009a5:	89 c2                	mov    %eax,%edx
  8009a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009aa:	89 c1                	mov    %eax,%ecx
  8009ac:	01 c9                	add    %ecx,%ecx
  8009ae:	01 c1                	add    %eax,%ecx
  8009b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009b3:	c1 e0 09             	shl    $0x9,%eax
  8009b6:	01 c8                	add    %ecx,%eax
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	79 05                	jns    8009c1 <_main+0x989>
  8009bc:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009c1:	c1 f8 0c             	sar    $0xc,%eax
  8009c4:	39 c2                	cmp    %eax,%edx
  8009c6:	74 17                	je     8009df <_main+0x9a7>
  8009c8:	83 ec 04             	sub    $0x4,%esp
  8009cb:	68 7a 41 80 00       	push   $0x80417a
  8009d0:	68 bd 00 00 00       	push   $0xbd
  8009d5:	68 5c 40 80 00       	push   $0x80405c
  8009da:	e8 49 03 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009df:	e8 2d 18 00 00       	call   802211 <sys_calculate_free_frames>
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 17                	je     800a04 <_main+0x9cc>
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 97 41 80 00       	push   $0x804197
  8009f5:	68 be 00 00 00       	push   $0xbe
  8009fa:	68 5c 40 80 00       	push   $0x80405c
  8009ff:	e8 24 03 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a04:	e8 08 18 00 00       	call   802211 <sys_calculate_free_frames>
  800a09:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a0c:	e8 a0 18 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800a11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  800a14:	8b 85 20 f8 ff ff    	mov    -0x7e0(%ebp),%eax
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	50                   	push   %eax
  800a1e:	e8 6f 15 00 00       	call   801f92 <free>
  800a23:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800a26:	e8 86 18 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800a2b:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a2e:	29 c2                	sub    %eax,%edx
  800a30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a33:	01 c0                	add    %eax,%eax
  800a35:	85 c0                	test   %eax,%eax
  800a37:	79 05                	jns    800a3e <_main+0xa06>
  800a39:	05 ff 0f 00 00       	add    $0xfff,%eax
  800a3e:	c1 f8 0c             	sar    $0xc,%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	74 17                	je     800a5c <_main+0xa24>
  800a45:	83 ec 04             	sub    $0x4,%esp
  800a48:	68 a8 41 80 00       	push   $0x8041a8
  800a4d:	68 c4 00 00 00       	push   $0xc4
  800a52:	68 5c 40 80 00       	push   $0x80405c
  800a57:	e8 cc 02 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800a5c:	e8 b0 17 00 00       	call   802211 <sys_calculate_free_frames>
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a66:	39 c2                	cmp    %eax,%edx
  800a68:	74 17                	je     800a81 <_main+0xa49>
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	68 e4 41 80 00       	push   $0x8041e4
  800a72:	68 c5 00 00 00       	push   $0xc5
  800a77:	68 5c 40 80 00       	push   $0x80405c
  800a7c:	e8 a7 02 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a81:	e8 8b 17 00 00       	call   802211 <sys_calculate_free_frames>
  800a86:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a89:	e8 23 18 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800a8e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(4*Mega-kilo);		// Use Hole 6 -> Hole 6 = 0 M
  800a91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800a94:	c1 e0 02             	shl    $0x2,%eax
  800a97:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800a9a:	83 ec 0c             	sub    $0xc,%esp
  800a9d:	50                   	push   %eax
  800a9e:	e8 c1 14 00 00       	call   801f64 <malloc>
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x83000000)
  800aa9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800aac:	3d 00 00 00 83       	cmp    $0x83000000,%eax
  800ab1:	74 17                	je     800aca <_main+0xa92>
		panic("Next Fit not working correctly");
  800ab3:	83 ec 04             	sub    $0x4,%esp
  800ab6:	68 24 42 80 00       	push   $0x804224
  800abb:	68 cc 00 00 00       	push   $0xcc
  800ac0:	68 5c 40 80 00       	push   $0x80405c
  800ac5:	e8 5e 02 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800aca:	e8 e2 17 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800acf:	2b 45 c4             	sub    -0x3c(%ebp),%eax
  800ad2:	89 c2                	mov    %eax,%edx
  800ad4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ad7:	c1 e0 02             	shl    $0x2,%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	79 05                	jns    800ae3 <_main+0xaab>
  800ade:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ae3:	c1 f8 0c             	sar    $0xc,%eax
  800ae6:	39 c2                	cmp    %eax,%edx
  800ae8:	74 17                	je     800b01 <_main+0xac9>
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	68 7a 41 80 00       	push   $0x80417a
  800af2:	68 cd 00 00 00       	push   $0xcd
  800af7:	68 5c 40 80 00       	push   $0x80405c
  800afc:	e8 27 02 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b01:	e8 0b 17 00 00       	call   802211 <sys_calculate_free_frames>
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	74 17                	je     800b26 <_main+0xaee>
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	68 97 41 80 00       	push   $0x804197
  800b17:	68 ce 00 00 00       	push   $0xce
  800b1c:	68 5c 40 80 00       	push   $0x80405c
  800b21:	e8 02 02 00 00       	call   800d28 <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	68 80 42 80 00       	push   $0x804280
  800b2e:	e8 a9 04 00 00       	call   800fdc <cprintf>
  800b33:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800b36:	e8 d6 16 00 00       	call   802211 <sys_calculate_free_frames>
  800b3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b3e:	e8 6e 17 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800b43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	tempAddress = malloc(6*Mega); 			   // No Suitable Hole is available
  800b46:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b49:	89 d0                	mov    %edx,%eax
  800b4b:	01 c0                	add    %eax,%eax
  800b4d:	01 d0                	add    %edx,%eax
  800b4f:	01 c0                	add    %eax,%eax
  800b51:	83 ec 0c             	sub    $0xc,%esp
  800b54:	50                   	push   %eax
  800b55:	e8 0a 14 00 00       	call   801f64 <malloc>
  800b5a:	83 c4 10             	add    $0x10,%esp
  800b5d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	if((uint32)tempAddress != 0x0)
  800b60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b63:	85 c0                	test   %eax,%eax
  800b65:	74 17                	je     800b7e <_main+0xb46>
		panic("Next Fit not working correctly");
  800b67:	83 ec 04             	sub    $0x4,%esp
  800b6a:	68 24 42 80 00       	push   $0x804224
  800b6f:	68 d7 00 00 00       	push   $0xd7
  800b74:	68 5c 40 80 00       	push   $0x80405c
  800b79:	e8 aa 01 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b7e:	e8 2e 17 00 00       	call   8022b1 <sys_pf_calculate_allocated_pages>
  800b83:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b86:	74 17                	je     800b9f <_main+0xb67>
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	68 7a 41 80 00       	push   $0x80417a
  800b90:	68 d8 00 00 00       	push   $0xd8
  800b95:	68 5c 40 80 00       	push   $0x80405c
  800b9a:	e8 89 01 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b9f:	e8 6d 16 00 00       	call   802211 <sys_calculate_free_frames>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	74 17                	je     800bc4 <_main+0xb8c>
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	68 97 41 80 00       	push   $0x804197
  800bb5:	68 d9 00 00 00       	push   $0xd9
  800bba:	68 5c 40 80 00       	push   $0x80405c
  800bbf:	e8 64 01 00 00       	call   800d28 <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	68 b8 42 80 00       	push   $0x8042b8
  800bcc:	e8 0b 04 00 00       	call   800fdc <cprintf>
  800bd1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	68 f4 42 80 00       	push   $0x8042f4
  800bdc:	e8 fb 03 00 00       	call   800fdc <cprintf>
  800be1:	83 c4 10             	add    $0x10,%esp

	return;
  800be4:	90                   	nop
}
  800be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be8:	5b                   	pop    %ebx
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800bf2:	e8 fa 18 00 00       	call   8024f1 <sys_getenvindex>
  800bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfd:	89 d0                	mov    %edx,%eax
  800bff:	c1 e0 03             	shl    $0x3,%eax
  800c02:	01 d0                	add    %edx,%eax
  800c04:	01 c0                	add    %eax,%eax
  800c06:	01 d0                	add    %edx,%eax
  800c08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c0f:	01 d0                	add    %edx,%eax
  800c11:	c1 e0 04             	shl    $0x4,%eax
  800c14:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800c19:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800c1e:	a1 20 50 80 00       	mov    0x805020,%eax
  800c23:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	74 0f                	je     800c3c <libmain+0x50>
		binaryname = myEnv->prog_name;
  800c2d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c32:	05 5c 05 00 00       	add    $0x55c,%eax
  800c37:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c40:	7e 0a                	jle    800c4c <libmain+0x60>
		binaryname = argv[0];
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8b 00                	mov    (%eax),%eax
  800c47:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 08             	pushl  0x8(%ebp)
  800c55:	e8 de f3 ff ff       	call   800038 <_main>
  800c5a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800c5d:	e8 9c 16 00 00       	call   8022fe <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	68 48 43 80 00       	push   $0x804348
  800c6a:	e8 6d 03 00 00       	call   800fdc <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800c72:	a1 20 50 80 00       	mov    0x805020,%eax
  800c77:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800c7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800c82:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800c88:	83 ec 04             	sub    $0x4,%esp
  800c8b:	52                   	push   %edx
  800c8c:	50                   	push   %eax
  800c8d:	68 70 43 80 00       	push   $0x804370
  800c92:	e8 45 03 00 00       	call   800fdc <cprintf>
  800c97:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800c9a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c9f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800ca5:	a1 20 50 80 00       	mov    0x805020,%eax
  800caa:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800cb0:	a1 20 50 80 00       	mov    0x805020,%eax
  800cb5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800cbb:	51                   	push   %ecx
  800cbc:	52                   	push   %edx
  800cbd:	50                   	push   %eax
  800cbe:	68 98 43 80 00       	push   $0x804398
  800cc3:	e8 14 03 00 00       	call   800fdc <cprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ccb:	a1 20 50 80 00       	mov    0x805020,%eax
  800cd0:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	50                   	push   %eax
  800cda:	68 f0 43 80 00       	push   $0x8043f0
  800cdf:	e8 f8 02 00 00       	call   800fdc <cprintf>
  800ce4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	68 48 43 80 00       	push   $0x804348
  800cef:	e8 e8 02 00 00       	call   800fdc <cprintf>
  800cf4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800cf7:	e8 1c 16 00 00       	call   802318 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800cfc:	e8 19 00 00 00       	call   800d1a <exit>
}
  800d01:	90                   	nop
  800d02:	c9                   	leave  
  800d03:	c3                   	ret    

00800d04 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800d0a:	83 ec 0c             	sub    $0xc,%esp
  800d0d:	6a 00                	push   $0x0
  800d0f:	e8 a9 17 00 00       	call   8024bd <sys_destroy_env>
  800d14:	83 c4 10             	add    $0x10,%esp
}
  800d17:	90                   	nop
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <exit>:

void
exit(void)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800d20:	e8 fe 17 00 00       	call   802523 <sys_exit_env>
}
  800d25:	90                   	nop
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800d2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800d31:	83 c0 04             	add    $0x4,%eax
  800d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800d37:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	74 16                	je     800d56 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800d40:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	50                   	push   %eax
  800d49:	68 04 44 80 00       	push   $0x804404
  800d4e:	e8 89 02 00 00       	call   800fdc <cprintf>
  800d53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d56:	a1 00 50 80 00       	mov    0x805000,%eax
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	50                   	push   %eax
  800d62:	68 09 44 80 00       	push   $0x804409
  800d67:	e8 70 02 00 00       	call   800fdc <cprintf>
  800d6c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	ff 75 f4             	pushl  -0xc(%ebp)
  800d78:	50                   	push   %eax
  800d79:	e8 f3 01 00 00       	call   800f71 <vcprintf>
  800d7e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	6a 00                	push   $0x0
  800d86:	68 25 44 80 00       	push   $0x804425
  800d8b:	e8 e1 01 00 00       	call   800f71 <vcprintf>
  800d90:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800d93:	e8 82 ff ff ff       	call   800d1a <exit>

	// should not return here
	while (1) ;
  800d98:	eb fe                	jmp    800d98 <_panic+0x70>

00800d9a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800da0:	a1 20 50 80 00       	mov    0x805020,%eax
  800da5:	8b 50 74             	mov    0x74(%eax),%edx
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	39 c2                	cmp    %eax,%edx
  800dad:	74 14                	je     800dc3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800daf:	83 ec 04             	sub    $0x4,%esp
  800db2:	68 28 44 80 00       	push   $0x804428
  800db7:	6a 26                	push   $0x26
  800db9:	68 74 44 80 00       	push   $0x804474
  800dbe:	e8 65 ff ff ff       	call   800d28 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800dc3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800dca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd1:	e9 c2 00 00 00       	jmp    800e98 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	8b 00                	mov    (%eax),%eax
  800de7:	85 c0                	test   %eax,%eax
  800de9:	75 08                	jne    800df3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800deb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800dee:	e9 a2 00 00 00       	jmp    800e95 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800df3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800e01:	eb 69                	jmp    800e6c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800e03:	a1 20 50 80 00       	mov    0x805020,%eax
  800e08:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e11:	89 d0                	mov    %edx,%eax
  800e13:	01 c0                	add    %eax,%eax
  800e15:	01 d0                	add    %edx,%eax
  800e17:	c1 e0 03             	shl    $0x3,%eax
  800e1a:	01 c8                	add    %ecx,%eax
  800e1c:	8a 40 04             	mov    0x4(%eax),%al
  800e1f:	84 c0                	test   %al,%al
  800e21:	75 46                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e23:	a1 20 50 80 00       	mov    0x805020,%eax
  800e28:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e2e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	c1 e0 03             	shl    $0x3,%eax
  800e3a:	01 c8                	add    %ecx,%eax
  800e3c:	8b 00                	mov    (%eax),%eax
  800e3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e49:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e4e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	01 c8                	add    %ecx,%eax
  800e5a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800e5c:	39 c2                	cmp    %eax,%edx
  800e5e:	75 09                	jne    800e69 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800e60:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800e67:	eb 12                	jmp    800e7b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e69:	ff 45 e8             	incl   -0x18(%ebp)
  800e6c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e71:	8b 50 74             	mov    0x74(%eax),%edx
  800e74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800e77:	39 c2                	cmp    %eax,%edx
  800e79:	77 88                	ja     800e03 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800e7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800e7f:	75 14                	jne    800e95 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800e81:	83 ec 04             	sub    $0x4,%esp
  800e84:	68 80 44 80 00       	push   $0x804480
  800e89:	6a 3a                	push   $0x3a
  800e8b:	68 74 44 80 00       	push   $0x804474
  800e90:	e8 93 fe ff ff       	call   800d28 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800e95:	ff 45 f0             	incl   -0x10(%ebp)
  800e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800e9e:	0f 8c 32 ff ff ff    	jl     800dd6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ea4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800eab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800eb2:	eb 26                	jmp    800eda <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800eb4:	a1 20 50 80 00       	mov    0x805020,%eax
  800eb9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ebf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d0                	add    %edx,%eax
  800ec8:	c1 e0 03             	shl    $0x3,%eax
  800ecb:	01 c8                	add    %ecx,%eax
  800ecd:	8a 40 04             	mov    0x4(%eax),%al
  800ed0:	3c 01                	cmp    $0x1,%al
  800ed2:	75 03                	jne    800ed7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ed4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ed7:	ff 45 e0             	incl   -0x20(%ebp)
  800eda:	a1 20 50 80 00       	mov    0x805020,%eax
  800edf:	8b 50 74             	mov    0x74(%eax),%edx
  800ee2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee5:	39 c2                	cmp    %eax,%edx
  800ee7:	77 cb                	ja     800eb4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800eef:	74 14                	je     800f05 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ef1:	83 ec 04             	sub    $0x4,%esp
  800ef4:	68 d4 44 80 00       	push   $0x8044d4
  800ef9:	6a 44                	push   $0x44
  800efb:	68 74 44 80 00       	push   $0x804474
  800f00:	e8 23 fe ff ff       	call   800d28 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800f05:	90                   	nop
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	8b 00                	mov    (%eax),%eax
  800f13:	8d 48 01             	lea    0x1(%eax),%ecx
  800f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f19:	89 0a                	mov    %ecx,(%edx)
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	88 d1                	mov    %dl,%cl
  800f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f23:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8b 00                	mov    (%eax),%eax
  800f2c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800f31:	75 2c                	jne    800f5f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800f33:	a0 24 50 80 00       	mov    0x805024,%al
  800f38:	0f b6 c0             	movzbl %al,%eax
  800f3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3e:	8b 12                	mov    (%edx),%edx
  800f40:	89 d1                	mov    %edx,%ecx
  800f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f45:	83 c2 08             	add    $0x8,%edx
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	50                   	push   %eax
  800f4c:	51                   	push   %ecx
  800f4d:	52                   	push   %edx
  800f4e:	e8 fd 11 00 00       	call   802150 <sys_cputs>
  800f53:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 40 04             	mov    0x4(%eax),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800f6e:	90                   	nop
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800f7a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800f81:	00 00 00 
	b.cnt = 0;
  800f84:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800f8b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	ff 75 08             	pushl  0x8(%ebp)
  800f94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f9a:	50                   	push   %eax
  800f9b:	68 08 0f 80 00       	push   $0x800f08
  800fa0:	e8 11 02 00 00       	call   8011b6 <vprintfmt>
  800fa5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800fa8:	a0 24 50 80 00       	mov    0x805024,%al
  800fad:	0f b6 c0             	movzbl %al,%eax
  800fb0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	50                   	push   %eax
  800fba:	52                   	push   %edx
  800fbb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800fc1:	83 c0 08             	add    $0x8,%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 86 11 00 00       	call   802150 <sys_cputs>
  800fca:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800fcd:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800fd4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <cprintf>:

int cprintf(const char *fmt, ...) {
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800fe2:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800fe9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	83 ec 08             	sub    $0x8,%esp
  800ff5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ff8:	50                   	push   %eax
  800ff9:	e8 73 ff ff ff       	call   800f71 <vcprintf>
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801004:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801007:	c9                   	leave  
  801008:	c3                   	ret    

00801009 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80100f:	e8 ea 12 00 00       	call   8022fe <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801014:	8d 45 0c             	lea    0xc(%ebp),%eax
  801017:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	83 ec 08             	sub    $0x8,%esp
  801020:	ff 75 f4             	pushl  -0xc(%ebp)
  801023:	50                   	push   %eax
  801024:	e8 48 ff ff ff       	call   800f71 <vcprintf>
  801029:	83 c4 10             	add    $0x10,%esp
  80102c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80102f:	e8 e4 12 00 00       	call   802318 <sys_enable_interrupt>
	return cnt;
  801034:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	53                   	push   %ebx
  80103d:	83 ec 14             	sub    $0x14,%esp
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801046:	8b 45 14             	mov    0x14(%ebp),%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80104c:	8b 45 18             	mov    0x18(%ebp),%eax
  80104f:	ba 00 00 00 00       	mov    $0x0,%edx
  801054:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801057:	77 55                	ja     8010ae <printnum+0x75>
  801059:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80105c:	72 05                	jb     801063 <printnum+0x2a>
  80105e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801061:	77 4b                	ja     8010ae <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801063:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801066:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801069:	8b 45 18             	mov    0x18(%ebp),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
  801071:	52                   	push   %edx
  801072:	50                   	push   %eax
  801073:	ff 75 f4             	pushl  -0xc(%ebp)
  801076:	ff 75 f0             	pushl  -0x10(%ebp)
  801079:	e8 56 2d 00 00       	call   803dd4 <__udivdi3>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	ff 75 20             	pushl  0x20(%ebp)
  801087:	53                   	push   %ebx
  801088:	ff 75 18             	pushl  0x18(%ebp)
  80108b:	52                   	push   %edx
  80108c:	50                   	push   %eax
  80108d:	ff 75 0c             	pushl  0xc(%ebp)
  801090:	ff 75 08             	pushl  0x8(%ebp)
  801093:	e8 a1 ff ff ff       	call   801039 <printnum>
  801098:	83 c4 20             	add    $0x20,%esp
  80109b:	eb 1a                	jmp    8010b7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 20             	pushl  0x20(%ebp)
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	ff d0                	call   *%eax
  8010ab:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8010ae:	ff 4d 1c             	decl   0x1c(%ebp)
  8010b1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8010b5:	7f e6                	jg     80109d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8010b7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8010ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c5:	53                   	push   %ebx
  8010c6:	51                   	push   %ecx
  8010c7:	52                   	push   %edx
  8010c8:	50                   	push   %eax
  8010c9:	e8 16 2e 00 00       	call   803ee4 <__umoddi3>
  8010ce:	83 c4 10             	add    $0x10,%esp
  8010d1:	05 34 47 80 00       	add    $0x804734,%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	0f be c0             	movsbl %al,%eax
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	ff 75 0c             	pushl  0xc(%ebp)
  8010e1:	50                   	push   %eax
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	ff d0                	call   *%eax
  8010e7:	83 c4 10             	add    $0x10,%esp
}
  8010ea:	90                   	nop
  8010eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010f7:	7e 1c                	jle    801115 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fc:	8b 00                	mov    (%eax),%eax
  8010fe:	8d 50 08             	lea    0x8(%eax),%edx
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	89 10                	mov    %edx,(%eax)
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8b 00                	mov    (%eax),%eax
  80110b:	83 e8 08             	sub    $0x8,%eax
  80110e:	8b 50 04             	mov    0x4(%eax),%edx
  801111:	8b 00                	mov    (%eax),%eax
  801113:	eb 40                	jmp    801155 <getuint+0x65>
	else if (lflag)
  801115:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801119:	74 1e                	je     801139 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8b 00                	mov    (%eax),%eax
  801120:	8d 50 04             	lea    0x4(%eax),%edx
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	89 10                	mov    %edx,(%eax)
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8b 00                	mov    (%eax),%eax
  80112d:	83 e8 04             	sub    $0x4,%eax
  801130:	8b 00                	mov    (%eax),%eax
  801132:	ba 00 00 00 00       	mov    $0x0,%edx
  801137:	eb 1c                	jmp    801155 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8b 00                	mov    (%eax),%eax
  80113e:	8d 50 04             	lea    0x4(%eax),%edx
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	89 10                	mov    %edx,(%eax)
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	8b 00                	mov    (%eax),%eax
  80114b:	83 e8 04             	sub    $0x4,%eax
  80114e:	8b 00                	mov    (%eax),%eax
  801150:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80115a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80115e:	7e 1c                	jle    80117c <getint+0x25>
		return va_arg(*ap, long long);
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	8b 00                	mov    (%eax),%eax
  801165:	8d 50 08             	lea    0x8(%eax),%edx
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	89 10                	mov    %edx,(%eax)
  80116d:	8b 45 08             	mov    0x8(%ebp),%eax
  801170:	8b 00                	mov    (%eax),%eax
  801172:	83 e8 08             	sub    $0x8,%eax
  801175:	8b 50 04             	mov    0x4(%eax),%edx
  801178:	8b 00                	mov    (%eax),%eax
  80117a:	eb 38                	jmp    8011b4 <getint+0x5d>
	else if (lflag)
  80117c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801180:	74 1a                	je     80119c <getint+0x45>
		return va_arg(*ap, long);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8b 00                	mov    (%eax),%eax
  801187:	8d 50 04             	lea    0x4(%eax),%edx
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	89 10                	mov    %edx,(%eax)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8b 00                	mov    (%eax),%eax
  801194:	83 e8 04             	sub    $0x4,%eax
  801197:	8b 00                	mov    (%eax),%eax
  801199:	99                   	cltd   
  80119a:	eb 18                	jmp    8011b4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80119c:	8b 45 08             	mov    0x8(%ebp),%eax
  80119f:	8b 00                	mov    (%eax),%eax
  8011a1:	8d 50 04             	lea    0x4(%eax),%edx
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	89 10                	mov    %edx,(%eax)
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8b 00                	mov    (%eax),%eax
  8011ae:	83 e8 04             	sub    $0x4,%eax
  8011b1:	8b 00                	mov    (%eax),%eax
  8011b3:	99                   	cltd   
}
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011be:	eb 17                	jmp    8011d7 <vprintfmt+0x21>
			if (ch == '\0')
  8011c0:	85 db                	test   %ebx,%ebx
  8011c2:	0f 84 af 03 00 00    	je     801577 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	ff 75 0c             	pushl  0xc(%ebp)
  8011ce:	53                   	push   %ebx
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	ff d0                	call   *%eax
  8011d4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	8d 50 01             	lea    0x1(%eax),%edx
  8011dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d8             	movzbl %al,%ebx
  8011e5:	83 fb 25             	cmp    $0x25,%ebx
  8011e8:	75 d6                	jne    8011c0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8011ea:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8011ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8011f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8011fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801203:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80120a:	8b 45 10             	mov    0x10(%ebp),%eax
  80120d:	8d 50 01             	lea    0x1(%eax),%edx
  801210:	89 55 10             	mov    %edx,0x10(%ebp)
  801213:	8a 00                	mov    (%eax),%al
  801215:	0f b6 d8             	movzbl %al,%ebx
  801218:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80121b:	83 f8 55             	cmp    $0x55,%eax
  80121e:	0f 87 2b 03 00 00    	ja     80154f <vprintfmt+0x399>
  801224:	8b 04 85 58 47 80 00 	mov    0x804758(,%eax,4),%eax
  80122b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80122d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801231:	eb d7                	jmp    80120a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801233:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801237:	eb d1                	jmp    80120a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801239:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801240:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801243:	89 d0                	mov    %edx,%eax
  801245:	c1 e0 02             	shl    $0x2,%eax
  801248:	01 d0                	add    %edx,%eax
  80124a:	01 c0                	add    %eax,%eax
  80124c:	01 d8                	add    %ebx,%eax
  80124e:	83 e8 30             	sub    $0x30,%eax
  801251:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801254:	8b 45 10             	mov    0x10(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80125c:	83 fb 2f             	cmp    $0x2f,%ebx
  80125f:	7e 3e                	jle    80129f <vprintfmt+0xe9>
  801261:	83 fb 39             	cmp    $0x39,%ebx
  801264:	7f 39                	jg     80129f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801266:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801269:	eb d5                	jmp    801240 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80126b:	8b 45 14             	mov    0x14(%ebp),%eax
  80126e:	83 c0 04             	add    $0x4,%eax
  801271:	89 45 14             	mov    %eax,0x14(%ebp)
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	83 e8 04             	sub    $0x4,%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80127f:	eb 1f                	jmp    8012a0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801281:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801285:	79 83                	jns    80120a <vprintfmt+0x54>
				width = 0;
  801287:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80128e:	e9 77 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801293:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80129a:	e9 6b ff ff ff       	jmp    80120a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80129f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8012a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012a4:	0f 89 60 ff ff ff    	jns    80120a <vprintfmt+0x54>
				width = precision, precision = -1;
  8012aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8012b7:	e9 4e ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8012bc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8012bf:	e9 46 ff ff ff       	jmp    80120a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8012c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c7:	83 c0 04             	add    $0x4,%eax
  8012ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8012cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d0:	83 e8 04             	sub    $0x4,%eax
  8012d3:	8b 00                	mov    (%eax),%eax
  8012d5:	83 ec 08             	sub    $0x8,%esp
  8012d8:	ff 75 0c             	pushl  0xc(%ebp)
  8012db:	50                   	push   %eax
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	ff d0                	call   *%eax
  8012e1:	83 c4 10             	add    $0x10,%esp
			break;
  8012e4:	e9 89 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8012e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ec:	83 c0 04             	add    $0x4,%eax
  8012ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8012f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f5:	83 e8 04             	sub    $0x4,%eax
  8012f8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8012fa:	85 db                	test   %ebx,%ebx
  8012fc:	79 02                	jns    801300 <vprintfmt+0x14a>
				err = -err;
  8012fe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801300:	83 fb 64             	cmp    $0x64,%ebx
  801303:	7f 0b                	jg     801310 <vprintfmt+0x15a>
  801305:	8b 34 9d a0 45 80 00 	mov    0x8045a0(,%ebx,4),%esi
  80130c:	85 f6                	test   %esi,%esi
  80130e:	75 19                	jne    801329 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801310:	53                   	push   %ebx
  801311:	68 45 47 80 00       	push   $0x804745
  801316:	ff 75 0c             	pushl  0xc(%ebp)
  801319:	ff 75 08             	pushl  0x8(%ebp)
  80131c:	e8 5e 02 00 00       	call   80157f <printfmt>
  801321:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801324:	e9 49 02 00 00       	jmp    801572 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801329:	56                   	push   %esi
  80132a:	68 4e 47 80 00       	push   $0x80474e
  80132f:	ff 75 0c             	pushl  0xc(%ebp)
  801332:	ff 75 08             	pushl  0x8(%ebp)
  801335:	e8 45 02 00 00       	call   80157f <printfmt>
  80133a:	83 c4 10             	add    $0x10,%esp
			break;
  80133d:	e9 30 02 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801342:	8b 45 14             	mov    0x14(%ebp),%eax
  801345:	83 c0 04             	add    $0x4,%eax
  801348:	89 45 14             	mov    %eax,0x14(%ebp)
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	83 e8 04             	sub    $0x4,%eax
  801351:	8b 30                	mov    (%eax),%esi
  801353:	85 f6                	test   %esi,%esi
  801355:	75 05                	jne    80135c <vprintfmt+0x1a6>
				p = "(null)";
  801357:	be 51 47 80 00       	mov    $0x804751,%esi
			if (width > 0 && padc != '-')
  80135c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801360:	7e 6d                	jle    8013cf <vprintfmt+0x219>
  801362:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801366:	74 67                	je     8013cf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	50                   	push   %eax
  80136f:	56                   	push   %esi
  801370:	e8 0c 03 00 00       	call   801681 <strnlen>
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80137b:	eb 16                	jmp    801393 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80137d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801381:	83 ec 08             	sub    $0x8,%esp
  801384:	ff 75 0c             	pushl  0xc(%ebp)
  801387:	50                   	push   %eax
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	ff d0                	call   *%eax
  80138d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801390:	ff 4d e4             	decl   -0x1c(%ebp)
  801393:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801397:	7f e4                	jg     80137d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801399:	eb 34                	jmp    8013cf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80139b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80139f:	74 1c                	je     8013bd <vprintfmt+0x207>
  8013a1:	83 fb 1f             	cmp    $0x1f,%ebx
  8013a4:	7e 05                	jle    8013ab <vprintfmt+0x1f5>
  8013a6:	83 fb 7e             	cmp    $0x7e,%ebx
  8013a9:	7e 12                	jle    8013bd <vprintfmt+0x207>
					putch('?', putdat);
  8013ab:	83 ec 08             	sub    $0x8,%esp
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	6a 3f                	push   $0x3f
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	ff d0                	call   *%eax
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	eb 0f                	jmp    8013cc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	53                   	push   %ebx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	ff d0                	call   *%eax
  8013c9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8013cc:	ff 4d e4             	decl   -0x1c(%ebp)
  8013cf:	89 f0                	mov    %esi,%eax
  8013d1:	8d 70 01             	lea    0x1(%eax),%esi
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be d8             	movsbl %al,%ebx
  8013d9:	85 db                	test   %ebx,%ebx
  8013db:	74 24                	je     801401 <vprintfmt+0x24b>
  8013dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013e1:	78 b8                	js     80139b <vprintfmt+0x1e5>
  8013e3:	ff 4d e0             	decl   -0x20(%ebp)
  8013e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ea:	79 af                	jns    80139b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013ec:	eb 13                	jmp    801401 <vprintfmt+0x24b>
				putch(' ', putdat);
  8013ee:	83 ec 08             	sub    $0x8,%esp
  8013f1:	ff 75 0c             	pushl  0xc(%ebp)
  8013f4:	6a 20                	push   $0x20
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	ff d0                	call   *%eax
  8013fb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8013fe:	ff 4d e4             	decl   -0x1c(%ebp)
  801401:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801405:	7f e7                	jg     8013ee <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801407:	e9 66 01 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	ff 75 e8             	pushl  -0x18(%ebp)
  801412:	8d 45 14             	lea    0x14(%ebp),%eax
  801415:	50                   	push   %eax
  801416:	e8 3c fd ff ff       	call   801157 <getint>
  80141b:	83 c4 10             	add    $0x10,%esp
  80141e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801421:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142a:	85 d2                	test   %edx,%edx
  80142c:	79 23                	jns    801451 <vprintfmt+0x29b>
				putch('-', putdat);
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	ff 75 0c             	pushl  0xc(%ebp)
  801434:	6a 2d                	push   $0x2d
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	ff d0                	call   *%eax
  80143b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80143e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801444:	f7 d8                	neg    %eax
  801446:	83 d2 00             	adc    $0x0,%edx
  801449:	f7 da                	neg    %edx
  80144b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80144e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801451:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801458:	e9 bc 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80145d:	83 ec 08             	sub    $0x8,%esp
  801460:	ff 75 e8             	pushl  -0x18(%ebp)
  801463:	8d 45 14             	lea    0x14(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	e8 84 fc ff ff       	call   8010f0 <getuint>
  80146c:	83 c4 10             	add    $0x10,%esp
  80146f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801472:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801475:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80147c:	e9 98 00 00 00       	jmp    801519 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	ff 75 0c             	pushl  0xc(%ebp)
  801487:	6a 58                	push   $0x58
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	ff d0                	call   *%eax
  80148e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	6a 58                	push   $0x58
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	ff d0                	call   *%eax
  80149e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	6a 58                	push   $0x58
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	ff d0                	call   *%eax
  8014ae:	83 c4 10             	add    $0x10,%esp
			break;
  8014b1:	e9 bc 00 00 00       	jmp    801572 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8014b6:	83 ec 08             	sub    $0x8,%esp
  8014b9:	ff 75 0c             	pushl  0xc(%ebp)
  8014bc:	6a 30                	push   $0x30
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	ff d0                	call   *%eax
  8014c3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8014c6:	83 ec 08             	sub    $0x8,%esp
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	6a 78                	push   $0x78
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	ff d0                	call   *%eax
  8014d3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8014d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d9:	83 c0 04             	add    $0x4,%eax
  8014dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8014df:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e2:	83 e8 04             	sub    $0x4,%eax
  8014e5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8014e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8014f1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8014f8:	eb 1f                	jmp    801519 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8014fa:	83 ec 08             	sub    $0x8,%esp
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	8d 45 14             	lea    0x14(%ebp),%eax
  801503:	50                   	push   %eax
  801504:	e8 e7 fb ff ff       	call   8010f0 <getuint>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80150f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801512:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801519:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80151d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801520:	83 ec 04             	sub    $0x4,%esp
  801523:	52                   	push   %edx
  801524:	ff 75 e4             	pushl  -0x1c(%ebp)
  801527:	50                   	push   %eax
  801528:	ff 75 f4             	pushl  -0xc(%ebp)
  80152b:	ff 75 f0             	pushl  -0x10(%ebp)
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	ff 75 08             	pushl  0x8(%ebp)
  801534:	e8 00 fb ff ff       	call   801039 <printnum>
  801539:	83 c4 20             	add    $0x20,%esp
			break;
  80153c:	eb 34                	jmp    801572 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	ff 75 0c             	pushl  0xc(%ebp)
  801544:	53                   	push   %ebx
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	ff d0                	call   *%eax
  80154a:	83 c4 10             	add    $0x10,%esp
			break;
  80154d:	eb 23                	jmp    801572 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	ff 75 0c             	pushl  0xc(%ebp)
  801555:	6a 25                	push   $0x25
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	ff d0                	call   *%eax
  80155c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80155f:	ff 4d 10             	decl   0x10(%ebp)
  801562:	eb 03                	jmp    801567 <vprintfmt+0x3b1>
  801564:	ff 4d 10             	decl   0x10(%ebp)
  801567:	8b 45 10             	mov    0x10(%ebp),%eax
  80156a:	48                   	dec    %eax
  80156b:	8a 00                	mov    (%eax),%al
  80156d:	3c 25                	cmp    $0x25,%al
  80156f:	75 f3                	jne    801564 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801571:	90                   	nop
		}
	}
  801572:	e9 47 fc ff ff       	jmp    8011be <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801577:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801578:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80157b:	5b                   	pop    %ebx
  80157c:	5e                   	pop    %esi
  80157d:	5d                   	pop    %ebp
  80157e:	c3                   	ret    

0080157f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801585:	8d 45 10             	lea    0x10(%ebp),%eax
  801588:	83 c0 04             	add    $0x4,%eax
  80158b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80158e:	8b 45 10             	mov    0x10(%ebp),%eax
  801591:	ff 75 f4             	pushl  -0xc(%ebp)
  801594:	50                   	push   %eax
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	ff 75 08             	pushl  0x8(%ebp)
  80159b:	e8 16 fc ff ff       	call   8011b6 <vprintfmt>
  8015a0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8015a3:	90                   	nop
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	8b 40 08             	mov    0x8(%eax),%eax
  8015af:	8d 50 01             	lea    0x1(%eax),%edx
  8015b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	8b 10                	mov    (%eax),%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	8b 40 04             	mov    0x4(%eax),%eax
  8015c3:	39 c2                	cmp    %eax,%edx
  8015c5:	73 12                	jae    8015d9 <sprintputch+0x33>
		*b->buf++ = ch;
  8015c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	89 0a                	mov    %ecx,(%edx)
  8015d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d7:	88 10                	mov    %dl,(%eax)
}
  8015d9:	90                   	nop
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f1:	01 d0                	add    %edx,%eax
  8015f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8015fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801601:	74 06                	je     801609 <vsnprintf+0x2d>
  801603:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801607:	7f 07                	jg     801610 <vsnprintf+0x34>
		return -E_INVAL;
  801609:	b8 03 00 00 00       	mov    $0x3,%eax
  80160e:	eb 20                	jmp    801630 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801610:	ff 75 14             	pushl  0x14(%ebp)
  801613:	ff 75 10             	pushl  0x10(%ebp)
  801616:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801619:	50                   	push   %eax
  80161a:	68 a6 15 80 00       	push   $0x8015a6
  80161f:	e8 92 fb ff ff       	call   8011b6 <vprintfmt>
  801624:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801638:	8d 45 10             	lea    0x10(%ebp),%eax
  80163b:	83 c0 04             	add    $0x4,%eax
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	50                   	push   %eax
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	ff 75 08             	pushl  0x8(%ebp)
  80164e:	e8 89 ff ff ff       	call   8015dc <vsnprintf>
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801659:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801664:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80166b:	eb 06                	jmp    801673 <strlen+0x15>
		n++;
  80166d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801670:	ff 45 08             	incl   0x8(%ebp)
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	84 c0                	test   %al,%al
  80167a:	75 f1                	jne    80166d <strlen+0xf>
		n++;
	return n;
  80167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801687:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80168e:	eb 09                	jmp    801699 <strnlen+0x18>
		n++;
  801690:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801693:	ff 45 08             	incl   0x8(%ebp)
  801696:	ff 4d 0c             	decl   0xc(%ebp)
  801699:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80169d:	74 09                	je     8016a8 <strnlen+0x27>
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	84 c0                	test   %al,%al
  8016a6:	75 e8                	jne    801690 <strnlen+0xf>
		n++;
	return n;
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8016b9:	90                   	nop
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8d 50 01             	lea    0x1(%eax),%edx
  8016c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8016c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016cc:	8a 12                	mov    (%edx),%dl
  8016ce:	88 10                	mov    %dl,(%eax)
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	84 c0                	test   %al,%al
  8016d4:	75 e4                	jne    8016ba <strcpy+0xd>
		/* do nothing */;
	return ret;
  8016d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8016e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8016ee:	eb 1f                	jmp    80170f <strncpy+0x34>
		*dst++ = *src;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8d 50 01             	lea    0x1(%eax),%edx
  8016f6:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fc:	8a 12                	mov    (%edx),%dl
  8016fe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801700:	8b 45 0c             	mov    0xc(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	84 c0                	test   %al,%al
  801707:	74 03                	je     80170c <strncpy+0x31>
			src++;
  801709:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80170c:	ff 45 fc             	incl   -0x4(%ebp)
  80170f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801712:	3b 45 10             	cmp    0x10(%ebp),%eax
  801715:	72 d9                	jb     8016f0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801717:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80172c:	74 30                	je     80175e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80172e:	eb 16                	jmp    801746 <strlcpy+0x2a>
			*dst++ = *src++;
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	8d 50 01             	lea    0x1(%eax),%edx
  801736:	89 55 08             	mov    %edx,0x8(%ebp)
  801739:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80173f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801742:	8a 12                	mov    (%edx),%dl
  801744:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801746:	ff 4d 10             	decl   0x10(%ebp)
  801749:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80174d:	74 09                	je     801758 <strlcpy+0x3c>
  80174f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801752:	8a 00                	mov    (%eax),%al
  801754:	84 c0                	test   %al,%al
  801756:	75 d8                	jne    801730 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80175e:	8b 55 08             	mov    0x8(%ebp),%edx
  801761:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801764:	29 c2                	sub    %eax,%edx
  801766:	89 d0                	mov    %edx,%eax
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80176d:	eb 06                	jmp    801775 <strcmp+0xb>
		p++, q++;
  80176f:	ff 45 08             	incl   0x8(%ebp)
  801772:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	8a 00                	mov    (%eax),%al
  80177a:	84 c0                	test   %al,%al
  80177c:	74 0e                	je     80178c <strcmp+0x22>
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8a 10                	mov    (%eax),%dl
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	8a 00                	mov    (%eax),%al
  801788:	38 c2                	cmp    %al,%dl
  80178a:	74 e3                	je     80176f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	0f b6 d0             	movzbl %al,%edx
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	0f b6 c0             	movzbl %al,%eax
  80179c:	29 c2                	sub    %eax,%edx
  80179e:	89 d0                	mov    %edx,%eax
}
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8017a5:	eb 09                	jmp    8017b0 <strncmp+0xe>
		n--, p++, q++;
  8017a7:	ff 4d 10             	decl   0x10(%ebp)
  8017aa:	ff 45 08             	incl   0x8(%ebp)
  8017ad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8017b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b4:	74 17                	je     8017cd <strncmp+0x2b>
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	84 c0                	test   %al,%al
  8017bd:	74 0e                	je     8017cd <strncmp+0x2b>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 10                	mov    (%eax),%dl
  8017c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c7:	8a 00                	mov    (%eax),%al
  8017c9:	38 c2                	cmp    %al,%dl
  8017cb:	74 da                	je     8017a7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8017cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d1:	75 07                	jne    8017da <strncmp+0x38>
		return 0;
  8017d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d8:	eb 14                	jmp    8017ee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	8a 00                	mov    (%eax),%al
  8017df:	0f b6 d0             	movzbl %al,%edx
  8017e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	0f b6 c0             	movzbl %al,%eax
  8017ea:	29 c2                	sub    %eax,%edx
  8017ec:	89 d0                	mov    %edx,%eax
}
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 04             	sub    $0x4,%esp
  8017f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8017fc:	eb 12                	jmp    801810 <strchr+0x20>
		if (*s == c)
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	8a 00                	mov    (%eax),%al
  801803:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801806:	75 05                	jne    80180d <strchr+0x1d>
			return (char *) s;
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	eb 11                	jmp    80181e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80180d:	ff 45 08             	incl   0x8(%ebp)
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	8a 00                	mov    (%eax),%al
  801815:	84 c0                	test   %al,%al
  801817:	75 e5                	jne    8017fe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 04             	sub    $0x4,%esp
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80182c:	eb 0d                	jmp    80183b <strfind+0x1b>
		if (*s == c)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8a 00                	mov    (%eax),%al
  801833:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801836:	74 0e                	je     801846 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801838:	ff 45 08             	incl   0x8(%ebp)
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	84 c0                	test   %al,%al
  801842:	75 ea                	jne    80182e <strfind+0xe>
  801844:	eb 01                	jmp    801847 <strfind+0x27>
		if (*s == c)
			break;
  801846:	90                   	nop
	return (char *) s;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801858:	8b 45 10             	mov    0x10(%ebp),%eax
  80185b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80185e:	eb 0e                	jmp    80186e <memset+0x22>
		*p++ = c;
  801860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801863:	8d 50 01             	lea    0x1(%eax),%edx
  801866:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80186e:	ff 4d f8             	decl   -0x8(%ebp)
  801871:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801875:	79 e9                	jns    801860 <memset+0x14>
		*p++ = c;

	return v;
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801882:	8b 45 0c             	mov    0xc(%ebp),%eax
  801885:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80188e:	eb 16                	jmp    8018a6 <memcpy+0x2a>
		*d++ = *s++;
  801890:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801893:	8d 50 01             	lea    0x1(%eax),%edx
  801896:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801899:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80189c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80189f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8018a2:	8a 12                	mov    (%edx),%dl
  8018a4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8018a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018ac:	89 55 10             	mov    %edx,0x10(%ebp)
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	75 dd                	jne    801890 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8018be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018d0:	73 50                	jae    801922 <memmove+0x6a>
  8018d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d8:	01 d0                	add    %edx,%eax
  8018da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8018dd:	76 43                	jbe    801922 <memmove+0x6a>
		s += n;
  8018df:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8018eb:	eb 10                	jmp    8018fd <memmove+0x45>
			*--d = *--s;
  8018ed:	ff 4d f8             	decl   -0x8(%ebp)
  8018f0:	ff 4d fc             	decl   -0x4(%ebp)
  8018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f6:	8a 10                	mov    (%eax),%dl
  8018f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018fb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8018fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801900:	8d 50 ff             	lea    -0x1(%eax),%edx
  801903:	89 55 10             	mov    %edx,0x10(%ebp)
  801906:	85 c0                	test   %eax,%eax
  801908:	75 e3                	jne    8018ed <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80190a:	eb 23                	jmp    80192f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80190c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190f:	8d 50 01             	lea    0x1(%eax),%edx
  801912:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801915:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801918:	8d 4a 01             	lea    0x1(%edx),%ecx
  80191b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80191e:	8a 12                	mov    (%edx),%dl
  801920:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	8d 50 ff             	lea    -0x1(%eax),%edx
  801928:	89 55 10             	mov    %edx,0x10(%ebp)
  80192b:	85 c0                	test   %eax,%eax
  80192d:	75 dd                	jne    80190c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801946:	eb 2a                	jmp    801972 <memcmp+0x3e>
		if (*s1 != *s2)
  801948:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80194b:	8a 10                	mov    (%eax),%dl
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	8a 00                	mov    (%eax),%al
  801952:	38 c2                	cmp    %al,%dl
  801954:	74 16                	je     80196c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801956:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	0f b6 d0             	movzbl %al,%edx
  80195e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	0f b6 c0             	movzbl %al,%eax
  801966:	29 c2                	sub    %eax,%edx
  801968:	89 d0                	mov    %edx,%eax
  80196a:	eb 18                	jmp    801984 <memcmp+0x50>
		s1++, s2++;
  80196c:	ff 45 fc             	incl   -0x4(%ebp)
  80196f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801972:	8b 45 10             	mov    0x10(%ebp),%eax
  801975:	8d 50 ff             	lea    -0x1(%eax),%edx
  801978:	89 55 10             	mov    %edx,0x10(%ebp)
  80197b:	85 c0                	test   %eax,%eax
  80197d:	75 c9                	jne    801948 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80197f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80198c:	8b 55 08             	mov    0x8(%ebp),%edx
  80198f:	8b 45 10             	mov    0x10(%ebp),%eax
  801992:	01 d0                	add    %edx,%eax
  801994:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801997:	eb 15                	jmp    8019ae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f b6 d0             	movzbl %al,%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	0f b6 c0             	movzbl %al,%eax
  8019a7:	39 c2                	cmp    %eax,%edx
  8019a9:	74 0d                	je     8019b8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8019ab:	ff 45 08             	incl   0x8(%ebp)
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8019b4:	72 e3                	jb     801999 <memfind+0x13>
  8019b6:	eb 01                	jmp    8019b9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8019b8:	90                   	nop
	return (void *) s;
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8019c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8019cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d2:	eb 03                	jmp    8019d7 <strtol+0x19>
		s++;
  8019d4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	8a 00                	mov    (%eax),%al
  8019dc:	3c 20                	cmp    $0x20,%al
  8019de:	74 f4                	je     8019d4 <strtol+0x16>
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	8a 00                	mov    (%eax),%al
  8019e5:	3c 09                	cmp    $0x9,%al
  8019e7:	74 eb                	je     8019d4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8a 00                	mov    (%eax),%al
  8019ee:	3c 2b                	cmp    $0x2b,%al
  8019f0:	75 05                	jne    8019f7 <strtol+0x39>
		s++;
  8019f2:	ff 45 08             	incl   0x8(%ebp)
  8019f5:	eb 13                	jmp    801a0a <strtol+0x4c>
	else if (*s == '-')
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	8a 00                	mov    (%eax),%al
  8019fc:	3c 2d                	cmp    $0x2d,%al
  8019fe:	75 0a                	jne    801a0a <strtol+0x4c>
		s++, neg = 1;
  801a00:	ff 45 08             	incl   0x8(%ebp)
  801a03:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a0e:	74 06                	je     801a16 <strtol+0x58>
  801a10:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801a14:	75 20                	jne    801a36 <strtol+0x78>
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8a 00                	mov    (%eax),%al
  801a1b:	3c 30                	cmp    $0x30,%al
  801a1d:	75 17                	jne    801a36 <strtol+0x78>
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	40                   	inc    %eax
  801a23:	8a 00                	mov    (%eax),%al
  801a25:	3c 78                	cmp    $0x78,%al
  801a27:	75 0d                	jne    801a36 <strtol+0x78>
		s += 2, base = 16;
  801a29:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801a2d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801a34:	eb 28                	jmp    801a5e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801a36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a3a:	75 15                	jne    801a51 <strtol+0x93>
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	3c 30                	cmp    $0x30,%al
  801a43:	75 0c                	jne    801a51 <strtol+0x93>
		s++, base = 8;
  801a45:	ff 45 08             	incl   0x8(%ebp)
  801a48:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801a4f:	eb 0d                	jmp    801a5e <strtol+0xa0>
	else if (base == 0)
  801a51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a55:	75 07                	jne    801a5e <strtol+0xa0>
		base = 10;
  801a57:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	8a 00                	mov    (%eax),%al
  801a63:	3c 2f                	cmp    $0x2f,%al
  801a65:	7e 19                	jle    801a80 <strtol+0xc2>
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	8a 00                	mov    (%eax),%al
  801a6c:	3c 39                	cmp    $0x39,%al
  801a6e:	7f 10                	jg     801a80 <strtol+0xc2>
			dig = *s - '0';
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8a 00                	mov    (%eax),%al
  801a75:	0f be c0             	movsbl %al,%eax
  801a78:	83 e8 30             	sub    $0x30,%eax
  801a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a7e:	eb 42                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	8a 00                	mov    (%eax),%al
  801a85:	3c 60                	cmp    $0x60,%al
  801a87:	7e 19                	jle    801aa2 <strtol+0xe4>
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	8a 00                	mov    (%eax),%al
  801a8e:	3c 7a                	cmp    $0x7a,%al
  801a90:	7f 10                	jg     801aa2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	8a 00                	mov    (%eax),%al
  801a97:	0f be c0             	movsbl %al,%eax
  801a9a:	83 e8 57             	sub    $0x57,%eax
  801a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801aa0:	eb 20                	jmp    801ac2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	3c 40                	cmp    $0x40,%al
  801aa9:	7e 39                	jle    801ae4 <strtol+0x126>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	3c 5a                	cmp    $0x5a,%al
  801ab2:	7f 30                	jg     801ae4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	8a 00                	mov    (%eax),%al
  801ab9:	0f be c0             	movsbl %al,%eax
  801abc:	83 e8 37             	sub    $0x37,%eax
  801abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac5:	3b 45 10             	cmp    0x10(%ebp),%eax
  801ac8:	7d 19                	jge    801ae3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801aca:	ff 45 08             	incl   0x8(%ebp)
  801acd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad0:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ad4:	89 c2                	mov    %eax,%edx
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	01 d0                	add    %edx,%eax
  801adb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801ade:	e9 7b ff ff ff       	jmp    801a5e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801ae3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801ae4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ae8:	74 08                	je     801af2 <strtol+0x134>
		*endptr = (char *) s;
  801aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aed:	8b 55 08             	mov    0x8(%ebp),%edx
  801af0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801af2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801af6:	74 07                	je     801aff <strtol+0x141>
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	f7 d8                	neg    %eax
  801afd:	eb 03                	jmp    801b02 <strtol+0x144>
  801aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <ltostr>:

void
ltostr(long value, char *str)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801b0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801b11:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b1c:	79 13                	jns    801b31 <ltostr+0x2d>
	{
		neg = 1;
  801b1e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b28:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801b2b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801b2e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801b39:	99                   	cltd   
  801b3a:	f7 f9                	idiv   %ecx
  801b3c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b42:	8d 50 01             	lea    0x1(%eax),%edx
  801b45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801b48:	89 c2                	mov    %eax,%edx
  801b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4d:	01 d0                	add    %edx,%eax
  801b4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801b52:	83 c2 30             	add    $0x30,%edx
  801b55:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801b57:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b5f:	f7 e9                	imul   %ecx
  801b61:	c1 fa 02             	sar    $0x2,%edx
  801b64:	89 c8                	mov    %ecx,%eax
  801b66:	c1 f8 1f             	sar    $0x1f,%eax
  801b69:	29 c2                	sub    %eax,%edx
  801b6b:	89 d0                	mov    %edx,%eax
  801b6d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801b70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b73:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801b78:	f7 e9                	imul   %ecx
  801b7a:	c1 fa 02             	sar    $0x2,%edx
  801b7d:	89 c8                	mov    %ecx,%eax
  801b7f:	c1 f8 1f             	sar    $0x1f,%eax
  801b82:	29 c2                	sub    %eax,%edx
  801b84:	89 d0                	mov    %edx,%eax
  801b86:	c1 e0 02             	shl    $0x2,%eax
  801b89:	01 d0                	add    %edx,%eax
  801b8b:	01 c0                	add    %eax,%eax
  801b8d:	29 c1                	sub    %eax,%ecx
  801b8f:	89 ca                	mov    %ecx,%edx
  801b91:	85 d2                	test   %edx,%edx
  801b93:	75 9c                	jne    801b31 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9f:	48                   	dec    %eax
  801ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801ba3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ba7:	74 3d                	je     801be6 <ltostr+0xe2>
		start = 1 ;
  801ba9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801bb0:	eb 34                	jmp    801be6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb8:	01 d0                	add    %edx,%eax
  801bba:	8a 00                	mov    (%eax),%al
  801bbc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801bbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	01 c2                	add    %eax,%edx
  801bc7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcd:	01 c8                	add    %ecx,%eax
  801bcf:	8a 00                	mov    (%eax),%al
  801bd1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801bd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd9:	01 c2                	add    %eax,%edx
  801bdb:	8a 45 eb             	mov    -0x15(%ebp),%al
  801bde:	88 02                	mov    %al,(%edx)
		start++ ;
  801be0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801be3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801bec:	7c c4                	jl     801bb2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801bee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	01 d0                	add    %edx,%eax
  801bf6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	e8 54 fa ff ff       	call   80165e <strlen>
  801c0a:	83 c4 04             	add    $0x4,%esp
  801c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	e8 46 fa ff ff       	call   80165e <strlen>
  801c18:	83 c4 04             	add    $0x4,%esp
  801c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801c1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c2c:	eb 17                	jmp    801c45 <strcconcat+0x49>
		final[s] = str1[s] ;
  801c2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c31:	8b 45 10             	mov    0x10(%ebp),%eax
  801c34:	01 c2                	add    %eax,%edx
  801c36:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	01 c8                	add    %ecx,%eax
  801c3e:	8a 00                	mov    (%eax),%al
  801c40:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801c42:	ff 45 fc             	incl   -0x4(%ebp)
  801c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c48:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801c4b:	7c e1                	jl     801c2e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801c4d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801c54:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801c5b:	eb 1f                	jmp    801c7c <strcconcat+0x80>
		final[s++] = str2[i] ;
  801c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c60:	8d 50 01             	lea    0x1(%eax),%edx
  801c63:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801c66:	89 c2                	mov    %eax,%edx
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	01 c2                	add    %eax,%edx
  801c6d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	01 c8                	add    %ecx,%eax
  801c75:	8a 00                	mov    (%eax),%al
  801c77:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801c79:	ff 45 f8             	incl   -0x8(%ebp)
  801c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801c82:	7c d9                	jl     801c5d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801c84:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c87:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8a:	01 d0                	add    %edx,%eax
  801c8c:	c6 00 00             	movb   $0x0,(%eax)
}
  801c8f:	90                   	nop
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801c95:	8b 45 14             	mov    0x14(%ebp),%eax
  801c98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801caa:	8b 45 10             	mov    0x10(%ebp),%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cb5:	eb 0c                	jmp    801cc3 <strsplit+0x31>
			*string++ = 0;
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	8d 50 01             	lea    0x1(%eax),%edx
  801cbd:	89 55 08             	mov    %edx,0x8(%ebp)
  801cc0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	8a 00                	mov    (%eax),%al
  801cc8:	84 c0                	test   %al,%al
  801cca:	74 18                	je     801ce4 <strsplit+0x52>
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	8a 00                	mov    (%eax),%al
  801cd1:	0f be c0             	movsbl %al,%eax
  801cd4:	50                   	push   %eax
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	e8 13 fb ff ff       	call   8017f0 <strchr>
  801cdd:	83 c4 08             	add    $0x8,%esp
  801ce0:	85 c0                	test   %eax,%eax
  801ce2:	75 d3                	jne    801cb7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	8a 00                	mov    (%eax),%al
  801ce9:	84 c0                	test   %al,%al
  801ceb:	74 5a                	je     801d47 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801ced:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf0:	8b 00                	mov    (%eax),%eax
  801cf2:	83 f8 0f             	cmp    $0xf,%eax
  801cf5:	75 07                	jne    801cfe <strsplit+0x6c>
		{
			return 0;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfc:	eb 66                	jmp    801d64 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  801d01:	8b 00                	mov    (%eax),%eax
  801d03:	8d 48 01             	lea    0x1(%eax),%ecx
  801d06:	8b 55 14             	mov    0x14(%ebp),%edx
  801d09:	89 0a                	mov    %ecx,(%edx)
  801d0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d12:	8b 45 10             	mov    0x10(%ebp),%eax
  801d15:	01 c2                	add    %eax,%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d1c:	eb 03                	jmp    801d21 <strsplit+0x8f>
			string++;
  801d1e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	8a 00                	mov    (%eax),%al
  801d26:	84 c0                	test   %al,%al
  801d28:	74 8b                	je     801cb5 <strsplit+0x23>
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8a 00                	mov    (%eax),%al
  801d2f:	0f be c0             	movsbl %al,%eax
  801d32:	50                   	push   %eax
  801d33:	ff 75 0c             	pushl  0xc(%ebp)
  801d36:	e8 b5 fa ff ff       	call   8017f0 <strchr>
  801d3b:	83 c4 08             	add    $0x8,%esp
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	74 dc                	je     801d1e <strsplit+0x8c>
			string++;
	}
  801d42:	e9 6e ff ff ff       	jmp    801cb5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801d47:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801d48:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	01 d0                	add    %edx,%eax
  801d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801d5f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801d6c:	a1 04 50 80 00       	mov    0x805004,%eax
  801d71:	85 c0                	test   %eax,%eax
  801d73:	74 1f                	je     801d94 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801d75:	e8 1d 00 00 00       	call   801d97 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	68 b0 48 80 00       	push   $0x8048b0
  801d82:	e8 55 f2 ff ff       	call   800fdc <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801d8a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801d91:	00 00 00 
	}
}
  801d94:	90                   	nop
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801d9d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801da4:	00 00 00 
  801da7:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801dae:	00 00 00 
  801db1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801db8:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801dbb:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801dc2:	00 00 00 
  801dc5:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801dcc:	00 00 00 
  801dcf:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801dd6:	00 00 00 
	uint32 arr_size = 0;
  801dd9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801de0:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801def:	2d 00 10 00 00       	sub    $0x1000,%eax
  801df4:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801df9:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801e00:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801e03:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e0a:	a1 20 51 80 00       	mov    0x805120,%eax
  801e0f:	c1 e0 04             	shl    $0x4,%eax
  801e12:	89 c2                	mov    %eax,%edx
  801e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e17:	01 d0                	add    %edx,%eax
  801e19:	48                   	dec    %eax
  801e1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e20:	ba 00 00 00 00       	mov    $0x0,%edx
  801e25:	f7 75 ec             	divl   -0x14(%ebp)
  801e28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e2b:	29 d0                	sub    %edx,%eax
  801e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801e30:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e3f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e44:	83 ec 04             	sub    $0x4,%esp
  801e47:	6a 06                	push   $0x6
  801e49:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4c:	50                   	push   %eax
  801e4d:	e8 42 04 00 00       	call   802294 <sys_allocate_chunk>
  801e52:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801e55:	a1 20 51 80 00       	mov    0x805120,%eax
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	50                   	push   %eax
  801e5e:	e8 b7 0a 00 00       	call   80291a <initialize_MemBlocksList>
  801e63:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801e66:	a1 48 51 80 00       	mov    0x805148,%eax
  801e6b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801e6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e71:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801e78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e7b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801e82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e86:	75 14                	jne    801e9c <initialize_dyn_block_system+0x105>
  801e88:	83 ec 04             	sub    $0x4,%esp
  801e8b:	68 d5 48 80 00       	push   $0x8048d5
  801e90:	6a 33                	push   $0x33
  801e92:	68 f3 48 80 00       	push   $0x8048f3
  801e97:	e8 8c ee ff ff       	call   800d28 <_panic>
  801e9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e9f:	8b 00                	mov    (%eax),%eax
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	74 10                	je     801eb5 <initialize_dyn_block_system+0x11e>
  801ea5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea8:	8b 00                	mov    (%eax),%eax
  801eaa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ead:	8b 52 04             	mov    0x4(%edx),%edx
  801eb0:	89 50 04             	mov    %edx,0x4(%eax)
  801eb3:	eb 0b                	jmp    801ec0 <initialize_dyn_block_system+0x129>
  801eb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eb8:	8b 40 04             	mov    0x4(%eax),%eax
  801ebb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec3:	8b 40 04             	mov    0x4(%eax),%eax
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	74 0f                	je     801ed9 <initialize_dyn_block_system+0x142>
  801eca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ecd:	8b 40 04             	mov    0x4(%eax),%eax
  801ed0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ed3:	8b 12                	mov    (%edx),%edx
  801ed5:	89 10                	mov    %edx,(%eax)
  801ed7:	eb 0a                	jmp    801ee3 <initialize_dyn_block_system+0x14c>
  801ed9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801edc:	8b 00                	mov    (%eax),%eax
  801ede:	a3 48 51 80 00       	mov    %eax,0x805148
  801ee3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ee6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801eec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ef6:	a1 54 51 80 00       	mov    0x805154,%eax
  801efb:	48                   	dec    %eax
  801efc:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801f01:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f05:	75 14                	jne    801f1b <initialize_dyn_block_system+0x184>
  801f07:	83 ec 04             	sub    $0x4,%esp
  801f0a:	68 00 49 80 00       	push   $0x804900
  801f0f:	6a 34                	push   $0x34
  801f11:	68 f3 48 80 00       	push   $0x8048f3
  801f16:	e8 0d ee ff ff       	call   800d28 <_panic>
  801f1b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801f21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f24:	89 10                	mov    %edx,(%eax)
  801f26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f29:	8b 00                	mov    (%eax),%eax
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	74 0d                	je     801f3c <initialize_dyn_block_system+0x1a5>
  801f2f:	a1 38 51 80 00       	mov    0x805138,%eax
  801f34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f37:	89 50 04             	mov    %edx,0x4(%eax)
  801f3a:	eb 08                	jmp    801f44 <initialize_dyn_block_system+0x1ad>
  801f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f3f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f47:	a3 38 51 80 00       	mov    %eax,0x805138
  801f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f56:	a1 44 51 80 00       	mov    0x805144,%eax
  801f5b:	40                   	inc    %eax
  801f5c:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801f61:	90                   	nop
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f6a:	e8 f7 fd ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f73:	75 07                	jne    801f7c <malloc+0x18>
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7a:	eb 14                	jmp    801f90 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801f7c:	83 ec 04             	sub    $0x4,%esp
  801f7f:	68 24 49 80 00       	push   $0x804924
  801f84:	6a 46                	push   $0x46
  801f86:	68 f3 48 80 00       	push   $0x8048f3
  801f8b:	e8 98 ed ff ff       	call   800d28 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801f98:	83 ec 04             	sub    $0x4,%esp
  801f9b:	68 4c 49 80 00       	push   $0x80494c
  801fa0:	6a 61                	push   $0x61
  801fa2:	68 f3 48 80 00       	push   $0x8048f3
  801fa7:	e8 7c ed ff ff       	call   800d28 <_panic>

00801fac <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 38             	sub    $0x38,%esp
  801fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb5:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fb8:	e8 a9 fd ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  801fbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fc1:	75 0a                	jne    801fcd <smalloc+0x21>
  801fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc8:	e9 9e 00 00 00       	jmp    80206b <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801fcd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801fd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fda:	01 d0                	add    %edx,%eax
  801fdc:	48                   	dec    %eax
  801fdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe8:	f7 75 f0             	divl   -0x10(%ebp)
  801feb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fee:	29 d0                	sub    %edx,%eax
  801ff0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801ff3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801ffa:	e8 63 06 00 00       	call   802662 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fff:	85 c0                	test   %eax,%eax
  802001:	74 11                	je     802014 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	ff 75 e8             	pushl  -0x18(%ebp)
  802009:	e8 ce 0c 00 00       	call   802cdc <alloc_block_FF>
  80200e:	83 c4 10             	add    $0x10,%esp
  802011:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  802014:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802018:	74 4c                	je     802066 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	8b 40 08             	mov    0x8(%eax),%eax
  802020:	89 c2                	mov    %eax,%edx
  802022:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802026:	52                   	push   %edx
  802027:	50                   	push   %eax
  802028:	ff 75 0c             	pushl  0xc(%ebp)
  80202b:	ff 75 08             	pushl  0x8(%ebp)
  80202e:	e8 b4 03 00 00       	call   8023e7 <sys_createSharedObject>
  802033:	83 c4 10             	add    $0x10,%esp
  802036:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  802039:	83 ec 08             	sub    $0x8,%esp
  80203c:	ff 75 e0             	pushl  -0x20(%ebp)
  80203f:	68 6f 49 80 00       	push   $0x80496f
  802044:	e8 93 ef ff ff       	call   800fdc <cprintf>
  802049:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80204c:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802050:	74 14                	je     802066 <smalloc+0xba>
  802052:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  802056:	74 0e                	je     802066 <smalloc+0xba>
  802058:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80205c:	74 08                	je     802066 <smalloc+0xba>
			return (void*) mem_block->sva;
  80205e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802061:	8b 40 08             	mov    0x8(%eax),%eax
  802064:	eb 05                	jmp    80206b <smalloc+0xbf>
	}
	return NULL;
  802066:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802073:	e8 ee fc ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	68 84 49 80 00       	push   $0x804984
  802080:	68 ab 00 00 00       	push   $0xab
  802085:	68 f3 48 80 00       	push   $0x8048f3
  80208a:	e8 99 ec ff ff       	call   800d28 <_panic>

0080208f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802095:	e8 cc fc ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80209a:	83 ec 04             	sub    $0x4,%esp
  80209d:	68 a8 49 80 00       	push   $0x8049a8
  8020a2:	68 ef 00 00 00       	push   $0xef
  8020a7:	68 f3 48 80 00       	push   $0x8048f3
  8020ac:	e8 77 ec ff ff       	call   800d28 <_panic>

008020b1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8020b7:	83 ec 04             	sub    $0x4,%esp
  8020ba:	68 d0 49 80 00       	push   $0x8049d0
  8020bf:	68 03 01 00 00       	push   $0x103
  8020c4:	68 f3 48 80 00       	push   $0x8048f3
  8020c9:	e8 5a ec ff ff       	call   800d28 <_panic>

008020ce <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020d4:	83 ec 04             	sub    $0x4,%esp
  8020d7:	68 f4 49 80 00       	push   $0x8049f4
  8020dc:	68 0e 01 00 00       	push   $0x10e
  8020e1:	68 f3 48 80 00       	push   $0x8048f3
  8020e6:	e8 3d ec ff ff       	call   800d28 <_panic>

008020eb <shrink>:

}
void shrink(uint32 newSize)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020f1:	83 ec 04             	sub    $0x4,%esp
  8020f4:	68 f4 49 80 00       	push   $0x8049f4
  8020f9:	68 13 01 00 00       	push   $0x113
  8020fe:	68 f3 48 80 00       	push   $0x8048f3
  802103:	e8 20 ec ff ff       	call   800d28 <_panic>

00802108 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80210e:	83 ec 04             	sub    $0x4,%esp
  802111:	68 f4 49 80 00       	push   $0x8049f4
  802116:	68 18 01 00 00       	push   $0x118
  80211b:	68 f3 48 80 00       	push   $0x8048f3
  802120:	e8 03 ec ff ff       	call   800d28 <_panic>

00802125 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	57                   	push   %edi
  802129:	56                   	push   %esi
  80212a:	53                   	push   %ebx
  80212b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	8b 55 0c             	mov    0xc(%ebp),%edx
  802134:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802137:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80213a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80213d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802140:	cd 30                	int    $0x30
  802142:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802145:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802148:	83 c4 10             	add    $0x10,%esp
  80214b:	5b                   	pop    %ebx
  80214c:	5e                   	pop    %esi
  80214d:	5f                   	pop    %edi
  80214e:	5d                   	pop    %ebp
  80214f:	c3                   	ret    

00802150 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 04             	sub    $0x4,%esp
  802156:	8b 45 10             	mov    0x10(%ebp),%eax
  802159:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80215c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	52                   	push   %edx
  802168:	ff 75 0c             	pushl  0xc(%ebp)
  80216b:	50                   	push   %eax
  80216c:	6a 00                	push   $0x0
  80216e:	e8 b2 ff ff ff       	call   802125 <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
}
  802176:	90                   	nop
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_cgetc>:

int
sys_cgetc(void)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 01                	push   $0x1
  802188:	e8 98 ff ff ff       	call   802125 <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802195:	8b 55 0c             	mov    0xc(%ebp),%edx
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	52                   	push   %edx
  8021a2:	50                   	push   %eax
  8021a3:	6a 05                	push   $0x5
  8021a5:	e8 7b ff ff ff       	call   802125 <syscall>
  8021aa:	83 c4 18             	add    $0x18,%esp
}
  8021ad:	c9                   	leave  
  8021ae:	c3                   	ret    

008021af <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021af:	55                   	push   %ebp
  8021b0:	89 e5                	mov    %esp,%ebp
  8021b2:	56                   	push   %esi
  8021b3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021b4:	8b 75 18             	mov    0x18(%ebp),%esi
  8021b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	56                   	push   %esi
  8021c4:	53                   	push   %ebx
  8021c5:	51                   	push   %ecx
  8021c6:	52                   	push   %edx
  8021c7:	50                   	push   %eax
  8021c8:	6a 06                	push   $0x6
  8021ca:	e8 56 ff ff ff       	call   802125 <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
}
  8021d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021d5:	5b                   	pop    %ebx
  8021d6:	5e                   	pop    %esi
  8021d7:	5d                   	pop    %ebp
  8021d8:	c3                   	ret    

008021d9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	52                   	push   %edx
  8021e9:	50                   	push   %eax
  8021ea:	6a 07                	push   $0x7
  8021ec:	e8 34 ff ff ff       	call   802125 <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	ff 75 0c             	pushl  0xc(%ebp)
  802202:	ff 75 08             	pushl  0x8(%ebp)
  802205:	6a 08                	push   $0x8
  802207:	e8 19 ff ff ff       	call   802125 <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 09                	push   $0x9
  802220:	e8 00 ff ff ff       	call   802125 <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 0a                	push   $0xa
  802239:	e8 e7 fe ff ff       	call   802125 <syscall>
  80223e:	83 c4 18             	add    $0x18,%esp
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 0b                	push   $0xb
  802252:	e8 ce fe ff ff       	call   802125 <syscall>
  802257:	83 c4 18             	add    $0x18,%esp
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	ff 75 0c             	pushl  0xc(%ebp)
  802268:	ff 75 08             	pushl  0x8(%ebp)
  80226b:	6a 0f                	push   $0xf
  80226d:	e8 b3 fe ff ff       	call   802125 <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
	return;
  802275:	90                   	nop
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	ff 75 0c             	pushl  0xc(%ebp)
  802284:	ff 75 08             	pushl  0x8(%ebp)
  802287:	6a 10                	push   $0x10
  802289:	e8 97 fe ff ff       	call   802125 <syscall>
  80228e:	83 c4 18             	add    $0x18,%esp
	return ;
  802291:	90                   	nop
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	ff 75 10             	pushl  0x10(%ebp)
  80229e:	ff 75 0c             	pushl  0xc(%ebp)
  8022a1:	ff 75 08             	pushl  0x8(%ebp)
  8022a4:	6a 11                	push   $0x11
  8022a6:	e8 7a fe ff ff       	call   802125 <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ae:	90                   	nop
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 0c                	push   $0xc
  8022c0:	e8 60 fe ff ff       	call   802125 <syscall>
  8022c5:	83 c4 18             	add    $0x18,%esp
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	ff 75 08             	pushl  0x8(%ebp)
  8022d8:	6a 0d                	push   $0xd
  8022da:	e8 46 fe ff ff       	call   802125 <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 0e                	push   $0xe
  8022f3:	e8 2d fe ff ff       	call   802125 <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
}
  8022fb:	90                   	nop
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 13                	push   $0x13
  80230d:	e8 13 fe ff ff       	call   802125 <syscall>
  802312:	83 c4 18             	add    $0x18,%esp
}
  802315:	90                   	nop
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 14                	push   $0x14
  802327:	e8 f9 fd ff ff       	call   802125 <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
}
  80232f:	90                   	nop
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <sys_cputc>:


void
sys_cputc(const char c)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	83 ec 04             	sub    $0x4,%esp
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80233e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	50                   	push   %eax
  80234b:	6a 15                	push   $0x15
  80234d:	e8 d3 fd ff ff       	call   802125 <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
}
  802355:	90                   	nop
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 16                	push   $0x16
  802367:	e8 b9 fd ff ff       	call   802125 <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
}
  80236f:	90                   	nop
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	ff 75 0c             	pushl  0xc(%ebp)
  802381:	50                   	push   %eax
  802382:	6a 17                	push   $0x17
  802384:	e8 9c fd ff ff       	call   802125 <syscall>
  802389:	83 c4 18             	add    $0x18,%esp
}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802391:	8b 55 0c             	mov    0xc(%ebp),%edx
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	52                   	push   %edx
  80239e:	50                   	push   %eax
  80239f:	6a 1a                	push   $0x1a
  8023a1:	e8 7f fd ff ff       	call   802125 <syscall>
  8023a6:	83 c4 18             	add    $0x18,%esp
}
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	6a 00                	push   $0x0
  8023ba:	52                   	push   %edx
  8023bb:	50                   	push   %eax
  8023bc:	6a 18                	push   $0x18
  8023be:	e8 62 fd ff ff       	call   802125 <syscall>
  8023c3:	83 c4 18             	add    $0x18,%esp
}
  8023c6:	90                   	nop
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	52                   	push   %edx
  8023d9:	50                   	push   %eax
  8023da:	6a 19                	push   $0x19
  8023dc:	e8 44 fd ff ff       	call   802125 <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
}
  8023e4:	90                   	nop
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	83 ec 04             	sub    $0x4,%esp
  8023ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023f3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	6a 00                	push   $0x0
  8023ff:	51                   	push   %ecx
  802400:	52                   	push   %edx
  802401:	ff 75 0c             	pushl  0xc(%ebp)
  802404:	50                   	push   %eax
  802405:	6a 1b                	push   $0x1b
  802407:	e8 19 fd ff ff       	call   802125 <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802414:	8b 55 0c             	mov    0xc(%ebp),%edx
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	52                   	push   %edx
  802421:	50                   	push   %eax
  802422:	6a 1c                	push   $0x1c
  802424:	e8 fc fc ff ff       	call   802125 <syscall>
  802429:	83 c4 18             	add    $0x18,%esp
}
  80242c:	c9                   	leave  
  80242d:	c3                   	ret    

0080242e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802431:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802434:	8b 55 0c             	mov    0xc(%ebp),%edx
  802437:	8b 45 08             	mov    0x8(%ebp),%eax
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	51                   	push   %ecx
  80243f:	52                   	push   %edx
  802440:	50                   	push   %eax
  802441:	6a 1d                	push   $0x1d
  802443:	e8 dd fc ff ff       	call   802125 <syscall>
  802448:	83 c4 18             	add    $0x18,%esp
}
  80244b:	c9                   	leave  
  80244c:	c3                   	ret    

0080244d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802450:	8b 55 0c             	mov    0xc(%ebp),%edx
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	52                   	push   %edx
  80245d:	50                   	push   %eax
  80245e:	6a 1e                	push   $0x1e
  802460:	e8 c0 fc ff ff       	call   802125 <syscall>
  802465:	83 c4 18             	add    $0x18,%esp
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 1f                	push   $0x1f
  802479:	e8 a7 fc ff ff       	call   802125 <syscall>
  80247e:	83 c4 18             	add    $0x18,%esp
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	6a 00                	push   $0x0
  80248b:	ff 75 14             	pushl  0x14(%ebp)
  80248e:	ff 75 10             	pushl  0x10(%ebp)
  802491:	ff 75 0c             	pushl  0xc(%ebp)
  802494:	50                   	push   %eax
  802495:	6a 20                	push   $0x20
  802497:	e8 89 fc ff ff       	call   802125 <syscall>
  80249c:	83 c4 18             	add    $0x18,%esp
}
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    

008024a1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	50                   	push   %eax
  8024b0:	6a 21                	push   $0x21
  8024b2:	e8 6e fc ff ff       	call   802125 <syscall>
  8024b7:	83 c4 18             	add    $0x18,%esp
}
  8024ba:	90                   	nop
  8024bb:	c9                   	leave  
  8024bc:	c3                   	ret    

008024bd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	50                   	push   %eax
  8024cc:	6a 22                	push   $0x22
  8024ce:	e8 52 fc ff ff       	call   802125 <syscall>
  8024d3:	83 c4 18             	add    $0x18,%esp
}
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 02                	push   $0x2
  8024e7:	e8 39 fc ff ff       	call   802125 <syscall>
  8024ec:	83 c4 18             	add    $0x18,%esp
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 03                	push   $0x3
  802500:	e8 20 fc ff ff       	call   802125 <syscall>
  802505:	83 c4 18             	add    $0x18,%esp
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 04                	push   $0x4
  802519:	e8 07 fc ff ff       	call   802125 <syscall>
  80251e:	83 c4 18             	add    $0x18,%esp
}
  802521:	c9                   	leave  
  802522:	c3                   	ret    

00802523 <sys_exit_env>:


void sys_exit_env(void)
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 23                	push   $0x23
  802532:	e8 ee fb ff ff       	call   802125 <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
}
  80253a:	90                   	nop
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
  802540:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802543:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802546:	8d 50 04             	lea    0x4(%eax),%edx
  802549:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	52                   	push   %edx
  802553:	50                   	push   %eax
  802554:	6a 24                	push   $0x24
  802556:	e8 ca fb ff ff       	call   802125 <syscall>
  80255b:	83 c4 18             	add    $0x18,%esp
	return result;
  80255e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802561:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802564:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802567:	89 01                	mov    %eax,(%ecx)
  802569:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	c9                   	leave  
  802570:	c2 04 00             	ret    $0x4

00802573 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	ff 75 10             	pushl  0x10(%ebp)
  80257d:	ff 75 0c             	pushl  0xc(%ebp)
  802580:	ff 75 08             	pushl  0x8(%ebp)
  802583:	6a 12                	push   $0x12
  802585:	e8 9b fb ff ff       	call   802125 <syscall>
  80258a:	83 c4 18             	add    $0x18,%esp
	return ;
  80258d:	90                   	nop
}
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <sys_rcr2>:
uint32 sys_rcr2()
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 25                	push   $0x25
  80259f:	e8 81 fb ff ff       	call   802125 <syscall>
  8025a4:	83 c4 18             	add    $0x18,%esp
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
  8025ac:	83 ec 04             	sub    $0x4,%esp
  8025af:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8025b5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	50                   	push   %eax
  8025c2:	6a 26                	push   $0x26
  8025c4:	e8 5c fb ff ff       	call   802125 <syscall>
  8025c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8025cc:	90                   	nop
}
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    

008025cf <rsttst>:
void rsttst()
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 28                	push   $0x28
  8025de:	e8 42 fb ff ff       	call   802125 <syscall>
  8025e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e6:	90                   	nop
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
  8025ec:	83 ec 04             	sub    $0x4,%esp
  8025ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8025f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025f5:	8b 55 18             	mov    0x18(%ebp),%edx
  8025f8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025fc:	52                   	push   %edx
  8025fd:	50                   	push   %eax
  8025fe:	ff 75 10             	pushl  0x10(%ebp)
  802601:	ff 75 0c             	pushl  0xc(%ebp)
  802604:	ff 75 08             	pushl  0x8(%ebp)
  802607:	6a 27                	push   $0x27
  802609:	e8 17 fb ff ff       	call   802125 <syscall>
  80260e:	83 c4 18             	add    $0x18,%esp
	return ;
  802611:	90                   	nop
}
  802612:	c9                   	leave  
  802613:	c3                   	ret    

00802614 <chktst>:
void chktst(uint32 n)
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	ff 75 08             	pushl  0x8(%ebp)
  802622:	6a 29                	push   $0x29
  802624:	e8 fc fa ff ff       	call   802125 <syscall>
  802629:	83 c4 18             	add    $0x18,%esp
	return ;
  80262c:	90                   	nop
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <inctst>:

void inctst()
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802632:	6a 00                	push   $0x0
  802634:	6a 00                	push   $0x0
  802636:	6a 00                	push   $0x0
  802638:	6a 00                	push   $0x0
  80263a:	6a 00                	push   $0x0
  80263c:	6a 2a                	push   $0x2a
  80263e:	e8 e2 fa ff ff       	call   802125 <syscall>
  802643:	83 c4 18             	add    $0x18,%esp
	return ;
  802646:	90                   	nop
}
  802647:	c9                   	leave  
  802648:	c3                   	ret    

00802649 <gettst>:
uint32 gettst()
{
  802649:	55                   	push   %ebp
  80264a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 00                	push   $0x0
  802656:	6a 2b                	push   $0x2b
  802658:	e8 c8 fa ff ff       	call   802125 <syscall>
  80265d:	83 c4 18             	add    $0x18,%esp
}
  802660:	c9                   	leave  
  802661:	c3                   	ret    

00802662 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802662:	55                   	push   %ebp
  802663:	89 e5                	mov    %esp,%ebp
  802665:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802668:	6a 00                	push   $0x0
  80266a:	6a 00                	push   $0x0
  80266c:	6a 00                	push   $0x0
  80266e:	6a 00                	push   $0x0
  802670:	6a 00                	push   $0x0
  802672:	6a 2c                	push   $0x2c
  802674:	e8 ac fa ff ff       	call   802125 <syscall>
  802679:	83 c4 18             	add    $0x18,%esp
  80267c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80267f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802683:	75 07                	jne    80268c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802685:	b8 01 00 00 00       	mov    $0x1,%eax
  80268a:	eb 05                	jmp    802691 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802691:	c9                   	leave  
  802692:	c3                   	ret    

00802693 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
  802696:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802699:	6a 00                	push   $0x0
  80269b:	6a 00                	push   $0x0
  80269d:	6a 00                	push   $0x0
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 2c                	push   $0x2c
  8026a5:	e8 7b fa ff ff       	call   802125 <syscall>
  8026aa:	83 c4 18             	add    $0x18,%esp
  8026ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8026b0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8026b4:	75 07                	jne    8026bd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8026b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026bb:	eb 05                	jmp    8026c2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
  8026c7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026ca:	6a 00                	push   $0x0
  8026cc:	6a 00                	push   $0x0
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 2c                	push   $0x2c
  8026d6:	e8 4a fa ff ff       	call   802125 <syscall>
  8026db:	83 c4 18             	add    $0x18,%esp
  8026de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026e1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026e5:	75 07                	jne    8026ee <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ec:	eb 05                	jmp    8026f3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f3:	c9                   	leave  
  8026f4:	c3                   	ret    

008026f5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026f5:	55                   	push   %ebp
  8026f6:	89 e5                	mov    %esp,%ebp
  8026f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026fb:	6a 00                	push   $0x0
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 2c                	push   $0x2c
  802707:	e8 19 fa ff ff       	call   802125 <syscall>
  80270c:	83 c4 18             	add    $0x18,%esp
  80270f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802712:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802716:	75 07                	jne    80271f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802718:	b8 01 00 00 00       	mov    $0x1,%eax
  80271d:	eb 05                	jmp    802724 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802724:	c9                   	leave  
  802725:	c3                   	ret    

00802726 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802729:	6a 00                	push   $0x0
  80272b:	6a 00                	push   $0x0
  80272d:	6a 00                	push   $0x0
  80272f:	6a 00                	push   $0x0
  802731:	ff 75 08             	pushl  0x8(%ebp)
  802734:	6a 2d                	push   $0x2d
  802736:	e8 ea f9 ff ff       	call   802125 <syscall>
  80273b:	83 c4 18             	add    $0x18,%esp
	return ;
  80273e:	90                   	nop
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
  802744:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802745:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802748:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80274b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80274e:	8b 45 08             	mov    0x8(%ebp),%eax
  802751:	6a 00                	push   $0x0
  802753:	53                   	push   %ebx
  802754:	51                   	push   %ecx
  802755:	52                   	push   %edx
  802756:	50                   	push   %eax
  802757:	6a 2e                	push   $0x2e
  802759:	e8 c7 f9 ff ff       	call   802125 <syscall>
  80275e:	83 c4 18             	add    $0x18,%esp
}
  802761:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80276c:	8b 45 08             	mov    0x8(%ebp),%eax
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	52                   	push   %edx
  802776:	50                   	push   %eax
  802777:	6a 2f                	push   $0x2f
  802779:	e8 a7 f9 ff ff       	call   802125 <syscall>
  80277e:	83 c4 18             	add    $0x18,%esp
}
  802781:	c9                   	leave  
  802782:	c3                   	ret    

00802783 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
  802786:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802789:	83 ec 0c             	sub    $0xc,%esp
  80278c:	68 04 4a 80 00       	push   $0x804a04
  802791:	e8 46 e8 ff ff       	call   800fdc <cprintf>
  802796:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802799:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8027a0:	83 ec 0c             	sub    $0xc,%esp
  8027a3:	68 30 4a 80 00       	push   $0x804a30
  8027a8:	e8 2f e8 ff ff       	call   800fdc <cprintf>
  8027ad:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8027b0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027b4:	a1 38 51 80 00       	mov    0x805138,%eax
  8027b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027bc:	eb 56                	jmp    802814 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c2:	74 1c                	je     8027e0 <print_mem_block_lists+0x5d>
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	8b 50 08             	mov    0x8(%eax),%edx
  8027ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cd:	8b 48 08             	mov    0x8(%eax),%ecx
  8027d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d6:	01 c8                	add    %ecx,%eax
  8027d8:	39 c2                	cmp    %eax,%edx
  8027da:	73 04                	jae    8027e0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8027dc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	8b 50 08             	mov    0x8(%eax),%edx
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ec:	01 c2                	add    %eax,%edx
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 40 08             	mov    0x8(%eax),%eax
  8027f4:	83 ec 04             	sub    $0x4,%esp
  8027f7:	52                   	push   %edx
  8027f8:	50                   	push   %eax
  8027f9:	68 45 4a 80 00       	push   $0x804a45
  8027fe:	e8 d9 e7 ff ff       	call   800fdc <cprintf>
  802803:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80280c:	a1 40 51 80 00       	mov    0x805140,%eax
  802811:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802814:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802818:	74 07                	je     802821 <print_mem_block_lists+0x9e>
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 00                	mov    (%eax),%eax
  80281f:	eb 05                	jmp    802826 <print_mem_block_lists+0xa3>
  802821:	b8 00 00 00 00       	mov    $0x0,%eax
  802826:	a3 40 51 80 00       	mov    %eax,0x805140
  80282b:	a1 40 51 80 00       	mov    0x805140,%eax
  802830:	85 c0                	test   %eax,%eax
  802832:	75 8a                	jne    8027be <print_mem_block_lists+0x3b>
  802834:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802838:	75 84                	jne    8027be <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80283a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80283e:	75 10                	jne    802850 <print_mem_block_lists+0xcd>
  802840:	83 ec 0c             	sub    $0xc,%esp
  802843:	68 54 4a 80 00       	push   $0x804a54
  802848:	e8 8f e7 ff ff       	call   800fdc <cprintf>
  80284d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802850:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802857:	83 ec 0c             	sub    $0xc,%esp
  80285a:	68 78 4a 80 00       	push   $0x804a78
  80285f:	e8 78 e7 ff ff       	call   800fdc <cprintf>
  802864:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802867:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80286b:	a1 40 50 80 00       	mov    0x805040,%eax
  802870:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802873:	eb 56                	jmp    8028cb <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802875:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802879:	74 1c                	je     802897 <print_mem_block_lists+0x114>
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 50 08             	mov    0x8(%eax),%edx
  802881:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802884:	8b 48 08             	mov    0x8(%eax),%ecx
  802887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288a:	8b 40 0c             	mov    0xc(%eax),%eax
  80288d:	01 c8                	add    %ecx,%eax
  80288f:	39 c2                	cmp    %eax,%edx
  802891:	73 04                	jae    802897 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802893:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	8b 50 08             	mov    0x8(%eax),%edx
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a3:	01 c2                	add    %eax,%edx
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 40 08             	mov    0x8(%eax),%eax
  8028ab:	83 ec 04             	sub    $0x4,%esp
  8028ae:	52                   	push   %edx
  8028af:	50                   	push   %eax
  8028b0:	68 45 4a 80 00       	push   $0x804a45
  8028b5:	e8 22 e7 ff ff       	call   800fdc <cprintf>
  8028ba:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028c3:	a1 48 50 80 00       	mov    0x805048,%eax
  8028c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cf:	74 07                	je     8028d8 <print_mem_block_lists+0x155>
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	eb 05                	jmp    8028dd <print_mem_block_lists+0x15a>
  8028d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028dd:	a3 48 50 80 00       	mov    %eax,0x805048
  8028e2:	a1 48 50 80 00       	mov    0x805048,%eax
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	75 8a                	jne    802875 <print_mem_block_lists+0xf2>
  8028eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ef:	75 84                	jne    802875 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8028f1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028f5:	75 10                	jne    802907 <print_mem_block_lists+0x184>
  8028f7:	83 ec 0c             	sub    $0xc,%esp
  8028fa:	68 90 4a 80 00       	push   $0x804a90
  8028ff:	e8 d8 e6 ff ff       	call   800fdc <cprintf>
  802904:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802907:	83 ec 0c             	sub    $0xc,%esp
  80290a:	68 04 4a 80 00       	push   $0x804a04
  80290f:	e8 c8 e6 ff ff       	call   800fdc <cprintf>
  802914:	83 c4 10             	add    $0x10,%esp

}
  802917:	90                   	nop
  802918:	c9                   	leave  
  802919:	c3                   	ret    

0080291a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80291a:	55                   	push   %ebp
  80291b:	89 e5                	mov    %esp,%ebp
  80291d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802920:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802927:	00 00 00 
  80292a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802931:	00 00 00 
  802934:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80293b:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80293e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802945:	e9 9e 00 00 00       	jmp    8029e8 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80294a:	a1 50 50 80 00       	mov    0x805050,%eax
  80294f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802952:	c1 e2 04             	shl    $0x4,%edx
  802955:	01 d0                	add    %edx,%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	75 14                	jne    80296f <initialize_MemBlocksList+0x55>
  80295b:	83 ec 04             	sub    $0x4,%esp
  80295e:	68 b8 4a 80 00       	push   $0x804ab8
  802963:	6a 46                	push   $0x46
  802965:	68 db 4a 80 00       	push   $0x804adb
  80296a:	e8 b9 e3 ff ff       	call   800d28 <_panic>
  80296f:	a1 50 50 80 00       	mov    0x805050,%eax
  802974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802977:	c1 e2 04             	shl    $0x4,%edx
  80297a:	01 d0                	add    %edx,%eax
  80297c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802982:	89 10                	mov    %edx,(%eax)
  802984:	8b 00                	mov    (%eax),%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	74 18                	je     8029a2 <initialize_MemBlocksList+0x88>
  80298a:	a1 48 51 80 00       	mov    0x805148,%eax
  80298f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802995:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802998:	c1 e1 04             	shl    $0x4,%ecx
  80299b:	01 ca                	add    %ecx,%edx
  80299d:	89 50 04             	mov    %edx,0x4(%eax)
  8029a0:	eb 12                	jmp    8029b4 <initialize_MemBlocksList+0x9a>
  8029a2:	a1 50 50 80 00       	mov    0x805050,%eax
  8029a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029aa:	c1 e2 04             	shl    $0x4,%edx
  8029ad:	01 d0                	add    %edx,%eax
  8029af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029b4:	a1 50 50 80 00       	mov    0x805050,%eax
  8029b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029bc:	c1 e2 04             	shl    $0x4,%edx
  8029bf:	01 d0                	add    %edx,%eax
  8029c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8029c6:	a1 50 50 80 00       	mov    0x805050,%eax
  8029cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ce:	c1 e2 04             	shl    $0x4,%edx
  8029d1:	01 d0                	add    %edx,%eax
  8029d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029da:	a1 54 51 80 00       	mov    0x805154,%eax
  8029df:	40                   	inc    %eax
  8029e0:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8029e5:	ff 45 f4             	incl   -0xc(%ebp)
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ee:	0f 82 56 ff ff ff    	jb     80294a <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8029f4:	90                   	nop
  8029f5:	c9                   	leave  
  8029f6:	c3                   	ret    

008029f7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8029f7:	55                   	push   %ebp
  8029f8:	89 e5                	mov    %esp,%ebp
  8029fa:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a05:	eb 19                	jmp    802a20 <find_block+0x29>
	{
		if(va==point->sva)
  802a07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a0a:	8b 40 08             	mov    0x8(%eax),%eax
  802a0d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a10:	75 05                	jne    802a17 <find_block+0x20>
		   return point;
  802a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a15:	eb 36                	jmp    802a4d <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	8b 40 08             	mov    0x8(%eax),%eax
  802a1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a20:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a24:	74 07                	je     802a2d <find_block+0x36>
  802a26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	eb 05                	jmp    802a32 <find_block+0x3b>
  802a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a32:	8b 55 08             	mov    0x8(%ebp),%edx
  802a35:	89 42 08             	mov    %eax,0x8(%edx)
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	8b 40 08             	mov    0x8(%eax),%eax
  802a3e:	85 c0                	test   %eax,%eax
  802a40:	75 c5                	jne    802a07 <find_block+0x10>
  802a42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a46:	75 bf                	jne    802a07 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802a48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a4d:	c9                   	leave  
  802a4e:	c3                   	ret    

00802a4f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802a4f:	55                   	push   %ebp
  802a50:	89 e5                	mov    %esp,%ebp
  802a52:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802a55:	a1 40 50 80 00       	mov    0x805040,%eax
  802a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802a5d:	a1 44 50 80 00       	mov    0x805044,%eax
  802a62:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a68:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a6b:	74 24                	je     802a91 <insert_sorted_allocList+0x42>
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	8b 50 08             	mov    0x8(%eax),%edx
  802a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a76:	8b 40 08             	mov    0x8(%eax),%eax
  802a79:	39 c2                	cmp    %eax,%edx
  802a7b:	76 14                	jbe    802a91 <insert_sorted_allocList+0x42>
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	8b 50 08             	mov    0x8(%eax),%edx
  802a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a86:	8b 40 08             	mov    0x8(%eax),%eax
  802a89:	39 c2                	cmp    %eax,%edx
  802a8b:	0f 82 60 01 00 00    	jb     802bf1 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802a91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a95:	75 65                	jne    802afc <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802a97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9b:	75 14                	jne    802ab1 <insert_sorted_allocList+0x62>
  802a9d:	83 ec 04             	sub    $0x4,%esp
  802aa0:	68 b8 4a 80 00       	push   $0x804ab8
  802aa5:	6a 6b                	push   $0x6b
  802aa7:	68 db 4a 80 00       	push   $0x804adb
  802aac:	e8 77 e2 ff ff       	call   800d28 <_panic>
  802ab1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	89 10                	mov    %edx,(%eax)
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	8b 00                	mov    (%eax),%eax
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	74 0d                	je     802ad2 <insert_sorted_allocList+0x83>
  802ac5:	a1 40 50 80 00       	mov    0x805040,%eax
  802aca:	8b 55 08             	mov    0x8(%ebp),%edx
  802acd:	89 50 04             	mov    %edx,0x4(%eax)
  802ad0:	eb 08                	jmp    802ada <insert_sorted_allocList+0x8b>
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	a3 44 50 80 00       	mov    %eax,0x805044
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	a3 40 50 80 00       	mov    %eax,0x805040
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aec:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802af1:	40                   	inc    %eax
  802af2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802af7:	e9 dc 01 00 00       	jmp    802cd8 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	8b 50 08             	mov    0x8(%eax),%edx
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b05:	8b 40 08             	mov    0x8(%eax),%eax
  802b08:	39 c2                	cmp    %eax,%edx
  802b0a:	77 6c                	ja     802b78 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802b0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b10:	74 06                	je     802b18 <insert_sorted_allocList+0xc9>
  802b12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b16:	75 14                	jne    802b2c <insert_sorted_allocList+0xdd>
  802b18:	83 ec 04             	sub    $0x4,%esp
  802b1b:	68 f4 4a 80 00       	push   $0x804af4
  802b20:	6a 6f                	push   $0x6f
  802b22:	68 db 4a 80 00       	push   $0x804adb
  802b27:	e8 fc e1 ff ff       	call   800d28 <_panic>
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	8b 50 04             	mov    0x4(%eax),%edx
  802b32:	8b 45 08             	mov    0x8(%ebp),%eax
  802b35:	89 50 04             	mov    %edx,0x4(%eax)
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3e:	89 10                	mov    %edx,(%eax)
  802b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b43:	8b 40 04             	mov    0x4(%eax),%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	74 0d                	je     802b57 <insert_sorted_allocList+0x108>
  802b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4d:	8b 40 04             	mov    0x4(%eax),%eax
  802b50:	8b 55 08             	mov    0x8(%ebp),%edx
  802b53:	89 10                	mov    %edx,(%eax)
  802b55:	eb 08                	jmp    802b5f <insert_sorted_allocList+0x110>
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	a3 40 50 80 00       	mov    %eax,0x805040
  802b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b62:	8b 55 08             	mov    0x8(%ebp),%edx
  802b65:	89 50 04             	mov    %edx,0x4(%eax)
  802b68:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b6d:	40                   	inc    %eax
  802b6e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b73:	e9 60 01 00 00       	jmp    802cd8 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	8b 50 08             	mov    0x8(%eax),%edx
  802b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b81:	8b 40 08             	mov    0x8(%eax),%eax
  802b84:	39 c2                	cmp    %eax,%edx
  802b86:	0f 82 4c 01 00 00    	jb     802cd8 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802b8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b90:	75 14                	jne    802ba6 <insert_sorted_allocList+0x157>
  802b92:	83 ec 04             	sub    $0x4,%esp
  802b95:	68 2c 4b 80 00       	push   $0x804b2c
  802b9a:	6a 73                	push   $0x73
  802b9c:	68 db 4a 80 00       	push   $0x804adb
  802ba1:	e8 82 e1 ff ff       	call   800d28 <_panic>
  802ba6:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	89 50 04             	mov    %edx,0x4(%eax)
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	8b 40 04             	mov    0x4(%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	74 0c                	je     802bc8 <insert_sorted_allocList+0x179>
  802bbc:	a1 44 50 80 00       	mov    0x805044,%eax
  802bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc4:	89 10                	mov    %edx,(%eax)
  802bc6:	eb 08                	jmp    802bd0 <insert_sorted_allocList+0x181>
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	a3 40 50 80 00       	mov    %eax,0x805040
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	a3 44 50 80 00       	mov    %eax,0x805044
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802be6:	40                   	inc    %eax
  802be7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802bec:	e9 e7 00 00 00       	jmp    802cd8 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802bf7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802bfe:	a1 40 50 80 00       	mov    0x805040,%eax
  802c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c06:	e9 9d 00 00 00       	jmp    802ca8 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	8b 50 08             	mov    0x8(%eax),%edx
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 40 08             	mov    0x8(%eax),%eax
  802c1f:	39 c2                	cmp    %eax,%edx
  802c21:	76 7d                	jbe    802ca0 <insert_sorted_allocList+0x251>
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	8b 50 08             	mov    0x8(%eax),%edx
  802c29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2c:	8b 40 08             	mov    0x8(%eax),%eax
  802c2f:	39 c2                	cmp    %eax,%edx
  802c31:	73 6d                	jae    802ca0 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802c33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c37:	74 06                	je     802c3f <insert_sorted_allocList+0x1f0>
  802c39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3d:	75 14                	jne    802c53 <insert_sorted_allocList+0x204>
  802c3f:	83 ec 04             	sub    $0x4,%esp
  802c42:	68 50 4b 80 00       	push   $0x804b50
  802c47:	6a 7f                	push   $0x7f
  802c49:	68 db 4a 80 00       	push   $0x804adb
  802c4e:	e8 d5 e0 ff ff       	call   800d28 <_panic>
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 10                	mov    (%eax),%edx
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	89 10                	mov    %edx,(%eax)
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	85 c0                	test   %eax,%eax
  802c64:	74 0b                	je     802c71 <insert_sorted_allocList+0x222>
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6e:	89 50 04             	mov    %edx,0x4(%eax)
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	8b 55 08             	mov    0x8(%ebp),%edx
  802c77:	89 10                	mov    %edx,(%eax)
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c7f:	89 50 04             	mov    %edx,0x4(%eax)
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	8b 00                	mov    (%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	75 08                	jne    802c93 <insert_sorted_allocList+0x244>
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	a3 44 50 80 00       	mov    %eax,0x805044
  802c93:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c98:	40                   	inc    %eax
  802c99:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802c9e:	eb 39                	jmp    802cd9 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802ca0:	a1 48 50 80 00       	mov    0x805048,%eax
  802ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cac:	74 07                	je     802cb5 <insert_sorted_allocList+0x266>
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	eb 05                	jmp    802cba <insert_sorted_allocList+0x26b>
  802cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cba:	a3 48 50 80 00       	mov    %eax,0x805048
  802cbf:	a1 48 50 80 00       	mov    0x805048,%eax
  802cc4:	85 c0                	test   %eax,%eax
  802cc6:	0f 85 3f ff ff ff    	jne    802c0b <insert_sorted_allocList+0x1bc>
  802ccc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd0:	0f 85 35 ff ff ff    	jne    802c0b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802cd6:	eb 01                	jmp    802cd9 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802cd8:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802cd9:	90                   	nop
  802cda:	c9                   	leave  
  802cdb:	c3                   	ret    

00802cdc <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802cdc:	55                   	push   %ebp
  802cdd:	89 e5                	mov    %esp,%ebp
  802cdf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802ce2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cea:	e9 85 01 00 00       	jmp    802e74 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf8:	0f 82 6e 01 00 00    	jb     802e6c <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 40 0c             	mov    0xc(%eax),%eax
  802d04:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d07:	0f 85 8a 00 00 00    	jne    802d97 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802d0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d11:	75 17                	jne    802d2a <alloc_block_FF+0x4e>
  802d13:	83 ec 04             	sub    $0x4,%esp
  802d16:	68 84 4b 80 00       	push   $0x804b84
  802d1b:	68 93 00 00 00       	push   $0x93
  802d20:	68 db 4a 80 00       	push   $0x804adb
  802d25:	e8 fe df ff ff       	call   800d28 <_panic>
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	74 10                	je     802d43 <alloc_block_FF+0x67>
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 00                	mov    (%eax),%eax
  802d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3b:	8b 52 04             	mov    0x4(%edx),%edx
  802d3e:	89 50 04             	mov    %edx,0x4(%eax)
  802d41:	eb 0b                	jmp    802d4e <alloc_block_FF+0x72>
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	8b 40 04             	mov    0x4(%eax),%eax
  802d49:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	8b 40 04             	mov    0x4(%eax),%eax
  802d54:	85 c0                	test   %eax,%eax
  802d56:	74 0f                	je     802d67 <alloc_block_FF+0x8b>
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 40 04             	mov    0x4(%eax),%eax
  802d5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d61:	8b 12                	mov    (%edx),%edx
  802d63:	89 10                	mov    %edx,(%eax)
  802d65:	eb 0a                	jmp    802d71 <alloc_block_FF+0x95>
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 00                	mov    (%eax),%eax
  802d6c:	a3 38 51 80 00       	mov    %eax,0x805138
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d84:	a1 44 51 80 00       	mov    0x805144,%eax
  802d89:	48                   	dec    %eax
  802d8a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	e9 10 01 00 00       	jmp    802ea7 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802da0:	0f 86 c6 00 00 00    	jbe    802e6c <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802da6:	a1 48 51 80 00       	mov    0x805148,%eax
  802dab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	8b 50 08             	mov    0x8(%eax),%edx
  802db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db7:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc0:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802dc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc7:	75 17                	jne    802de0 <alloc_block_FF+0x104>
  802dc9:	83 ec 04             	sub    $0x4,%esp
  802dcc:	68 84 4b 80 00       	push   $0x804b84
  802dd1:	68 9b 00 00 00       	push   $0x9b
  802dd6:	68 db 4a 80 00       	push   $0x804adb
  802ddb:	e8 48 df ff ff       	call   800d28 <_panic>
  802de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	85 c0                	test   %eax,%eax
  802de7:	74 10                	je     802df9 <alloc_block_FF+0x11d>
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	8b 00                	mov    (%eax),%eax
  802dee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df1:	8b 52 04             	mov    0x4(%edx),%edx
  802df4:	89 50 04             	mov    %edx,0x4(%eax)
  802df7:	eb 0b                	jmp    802e04 <alloc_block_FF+0x128>
  802df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfc:	8b 40 04             	mov    0x4(%eax),%eax
  802dff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	8b 40 04             	mov    0x4(%eax),%eax
  802e0a:	85 c0                	test   %eax,%eax
  802e0c:	74 0f                	je     802e1d <alloc_block_FF+0x141>
  802e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e17:	8b 12                	mov    (%edx),%edx
  802e19:	89 10                	mov    %edx,(%eax)
  802e1b:	eb 0a                	jmp    802e27 <alloc_block_FF+0x14b>
  802e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e20:	8b 00                	mov    (%eax),%eax
  802e22:	a3 48 51 80 00       	mov    %eax,0x805148
  802e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e3f:	48                   	dec    %eax
  802e40:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 50 08             	mov    0x8(%eax),%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	01 c2                	add    %eax,%edx
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5c:	2b 45 08             	sub    0x8(%ebp),%eax
  802e5f:	89 c2                	mov    %eax,%edx
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6a:	eb 3b                	jmp    802ea7 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802e6c:	a1 40 51 80 00       	mov    0x805140,%eax
  802e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e78:	74 07                	je     802e81 <alloc_block_FF+0x1a5>
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 00                	mov    (%eax),%eax
  802e7f:	eb 05                	jmp    802e86 <alloc_block_FF+0x1aa>
  802e81:	b8 00 00 00 00       	mov    $0x0,%eax
  802e86:	a3 40 51 80 00       	mov    %eax,0x805140
  802e8b:	a1 40 51 80 00       	mov    0x805140,%eax
  802e90:	85 c0                	test   %eax,%eax
  802e92:	0f 85 57 fe ff ff    	jne    802cef <alloc_block_FF+0x13>
  802e98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9c:	0f 85 4d fe ff ff    	jne    802cef <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802ea2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ea7:	c9                   	leave  
  802ea8:	c3                   	ret    

00802ea9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ea9:	55                   	push   %ebp
  802eaa:	89 e5                	mov    %esp,%ebp
  802eac:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802eaf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802eb6:	a1 38 51 80 00       	mov    0x805138,%eax
  802ebb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebe:	e9 df 00 00 00       	jmp    802fa2 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ecc:	0f 82 c8 00 00 00    	jb     802f9a <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802edb:	0f 85 8a 00 00 00    	jne    802f6b <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802ee1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee5:	75 17                	jne    802efe <alloc_block_BF+0x55>
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	68 84 4b 80 00       	push   $0x804b84
  802eef:	68 b7 00 00 00       	push   $0xb7
  802ef4:	68 db 4a 80 00       	push   $0x804adb
  802ef9:	e8 2a de ff ff       	call   800d28 <_panic>
  802efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	85 c0                	test   %eax,%eax
  802f05:	74 10                	je     802f17 <alloc_block_BF+0x6e>
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0f:	8b 52 04             	mov    0x4(%edx),%edx
  802f12:	89 50 04             	mov    %edx,0x4(%eax)
  802f15:	eb 0b                	jmp    802f22 <alloc_block_BF+0x79>
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	8b 40 04             	mov    0x4(%eax),%eax
  802f1d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	74 0f                	je     802f3b <alloc_block_BF+0x92>
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	8b 40 04             	mov    0x4(%eax),%eax
  802f32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f35:	8b 12                	mov    (%edx),%edx
  802f37:	89 10                	mov    %edx,(%eax)
  802f39:	eb 0a                	jmp    802f45 <alloc_block_BF+0x9c>
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	a3 38 51 80 00       	mov    %eax,0x805138
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f58:	a1 44 51 80 00       	mov    0x805144,%eax
  802f5d:	48                   	dec    %eax
  802f5e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	e9 4d 01 00 00       	jmp    8030b8 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f71:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f74:	76 24                	jbe    802f9a <alloc_block_BF+0xf1>
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f7f:	73 19                	jae    802f9a <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802f81:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	8b 40 08             	mov    0x8(%eax),%eax
  802f97:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802f9a:	a1 40 51 80 00       	mov    0x805140,%eax
  802f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa6:	74 07                	je     802faf <alloc_block_BF+0x106>
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	eb 05                	jmp    802fb4 <alloc_block_BF+0x10b>
  802faf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb4:	a3 40 51 80 00       	mov    %eax,0x805140
  802fb9:	a1 40 51 80 00       	mov    0x805140,%eax
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	0f 85 fd fe ff ff    	jne    802ec3 <alloc_block_BF+0x1a>
  802fc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fca:	0f 85 f3 fe ff ff    	jne    802ec3 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802fd0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd4:	0f 84 d9 00 00 00    	je     8030b3 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fda:	a1 48 51 80 00       	mov    0x805148,%eax
  802fdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802fe2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fe8:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802feb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fee:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff1:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802ff4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ff8:	75 17                	jne    803011 <alloc_block_BF+0x168>
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	68 84 4b 80 00       	push   $0x804b84
  803002:	68 c7 00 00 00       	push   $0xc7
  803007:	68 db 4a 80 00       	push   $0x804adb
  80300c:	e8 17 dd ff ff       	call   800d28 <_panic>
  803011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803014:	8b 00                	mov    (%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 10                	je     80302a <alloc_block_BF+0x181>
  80301a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301d:	8b 00                	mov    (%eax),%eax
  80301f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803022:	8b 52 04             	mov    0x4(%edx),%edx
  803025:	89 50 04             	mov    %edx,0x4(%eax)
  803028:	eb 0b                	jmp    803035 <alloc_block_BF+0x18c>
  80302a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302d:	8b 40 04             	mov    0x4(%eax),%eax
  803030:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803035:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803038:	8b 40 04             	mov    0x4(%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 0f                	je     80304e <alloc_block_BF+0x1a5>
  80303f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803048:	8b 12                	mov    (%edx),%edx
  80304a:	89 10                	mov    %edx,(%eax)
  80304c:	eb 0a                	jmp    803058 <alloc_block_BF+0x1af>
  80304e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	a3 48 51 80 00       	mov    %eax,0x805148
  803058:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803064:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306b:	a1 54 51 80 00       	mov    0x805154,%eax
  803070:	48                   	dec    %eax
  803071:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803076:	83 ec 08             	sub    $0x8,%esp
  803079:	ff 75 ec             	pushl  -0x14(%ebp)
  80307c:	68 38 51 80 00       	push   $0x805138
  803081:	e8 71 f9 ff ff       	call   8029f7 <find_block>
  803086:	83 c4 10             	add    $0x10,%esp
  803089:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80308c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80308f:	8b 50 08             	mov    0x8(%eax),%edx
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	01 c2                	add    %eax,%edx
  803097:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80309a:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80309d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a3:	2b 45 08             	sub    0x8(%ebp),%eax
  8030a6:	89 c2                	mov    %eax,%edx
  8030a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ab:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8030ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b1:	eb 05                	jmp    8030b8 <alloc_block_BF+0x20f>
	}
	return NULL;
  8030b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030b8:	c9                   	leave  
  8030b9:	c3                   	ret    

008030ba <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8030ba:	55                   	push   %ebp
  8030bb:	89 e5                	mov    %esp,%ebp
  8030bd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8030c0:	a1 28 50 80 00       	mov    0x805028,%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	0f 85 de 01 00 00    	jne    8032ab <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8030cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d5:	e9 9e 01 00 00       	jmp    803278 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030e3:	0f 82 87 01 00 00    	jb     803270 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8030e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f2:	0f 85 95 00 00 00    	jne    80318d <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8030f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030fc:	75 17                	jne    803115 <alloc_block_NF+0x5b>
  8030fe:	83 ec 04             	sub    $0x4,%esp
  803101:	68 84 4b 80 00       	push   $0x804b84
  803106:	68 e0 00 00 00       	push   $0xe0
  80310b:	68 db 4a 80 00       	push   $0x804adb
  803110:	e8 13 dc ff ff       	call   800d28 <_panic>
  803115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803118:	8b 00                	mov    (%eax),%eax
  80311a:	85 c0                	test   %eax,%eax
  80311c:	74 10                	je     80312e <alloc_block_NF+0x74>
  80311e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803121:	8b 00                	mov    (%eax),%eax
  803123:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803126:	8b 52 04             	mov    0x4(%edx),%edx
  803129:	89 50 04             	mov    %edx,0x4(%eax)
  80312c:	eb 0b                	jmp    803139 <alloc_block_NF+0x7f>
  80312e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803131:	8b 40 04             	mov    0x4(%eax),%eax
  803134:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	8b 40 04             	mov    0x4(%eax),%eax
  80313f:	85 c0                	test   %eax,%eax
  803141:	74 0f                	je     803152 <alloc_block_NF+0x98>
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	8b 40 04             	mov    0x4(%eax),%eax
  803149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80314c:	8b 12                	mov    (%edx),%edx
  80314e:	89 10                	mov    %edx,(%eax)
  803150:	eb 0a                	jmp    80315c <alloc_block_NF+0xa2>
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	a3 38 51 80 00       	mov    %eax,0x805138
  80315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803168:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316f:	a1 44 51 80 00       	mov    0x805144,%eax
  803174:	48                   	dec    %eax
  803175:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317d:	8b 40 08             	mov    0x8(%eax),%eax
  803180:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  803185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803188:	e9 f8 04 00 00       	jmp    803685 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80318d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803190:	8b 40 0c             	mov    0xc(%eax),%eax
  803193:	3b 45 08             	cmp    0x8(%ebp),%eax
  803196:	0f 86 d4 00 00 00    	jbe    803270 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80319c:	a1 48 51 80 00       	mov    0x805148,%eax
  8031a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8031a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a7:	8b 50 08             	mov    0x8(%eax),%edx
  8031aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ad:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8031b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b6:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8031b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031bd:	75 17                	jne    8031d6 <alloc_block_NF+0x11c>
  8031bf:	83 ec 04             	sub    $0x4,%esp
  8031c2:	68 84 4b 80 00       	push   $0x804b84
  8031c7:	68 e9 00 00 00       	push   $0xe9
  8031cc:	68 db 4a 80 00       	push   $0x804adb
  8031d1:	e8 52 db ff ff       	call   800d28 <_panic>
  8031d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d9:	8b 00                	mov    (%eax),%eax
  8031db:	85 c0                	test   %eax,%eax
  8031dd:	74 10                	je     8031ef <alloc_block_NF+0x135>
  8031df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e2:	8b 00                	mov    (%eax),%eax
  8031e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031e7:	8b 52 04             	mov    0x4(%edx),%edx
  8031ea:	89 50 04             	mov    %edx,0x4(%eax)
  8031ed:	eb 0b                	jmp    8031fa <alloc_block_NF+0x140>
  8031ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f2:	8b 40 04             	mov    0x4(%eax),%eax
  8031f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fd:	8b 40 04             	mov    0x4(%eax),%eax
  803200:	85 c0                	test   %eax,%eax
  803202:	74 0f                	je     803213 <alloc_block_NF+0x159>
  803204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803207:	8b 40 04             	mov    0x4(%eax),%eax
  80320a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80320d:	8b 12                	mov    (%edx),%edx
  80320f:	89 10                	mov    %edx,(%eax)
  803211:	eb 0a                	jmp    80321d <alloc_block_NF+0x163>
  803213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803216:	8b 00                	mov    (%eax),%eax
  803218:	a3 48 51 80 00       	mov    %eax,0x805148
  80321d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803229:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803230:	a1 54 51 80 00       	mov    0x805154,%eax
  803235:	48                   	dec    %eax
  803236:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80323b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323e:	8b 40 08             	mov    0x8(%eax),%eax
  803241:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803249:	8b 50 08             	mov    0x8(%eax),%edx
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	01 c2                	add    %eax,%edx
  803251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803254:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325a:	8b 40 0c             	mov    0xc(%eax),%eax
  80325d:	2b 45 08             	sub    0x8(%ebp),%eax
  803260:	89 c2                	mov    %eax,%edx
  803262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803265:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326b:	e9 15 04 00 00       	jmp    803685 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803270:	a1 40 51 80 00       	mov    0x805140,%eax
  803275:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327c:	74 07                	je     803285 <alloc_block_NF+0x1cb>
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	8b 00                	mov    (%eax),%eax
  803283:	eb 05                	jmp    80328a <alloc_block_NF+0x1d0>
  803285:	b8 00 00 00 00       	mov    $0x0,%eax
  80328a:	a3 40 51 80 00       	mov    %eax,0x805140
  80328f:	a1 40 51 80 00       	mov    0x805140,%eax
  803294:	85 c0                	test   %eax,%eax
  803296:	0f 85 3e fe ff ff    	jne    8030da <alloc_block_NF+0x20>
  80329c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a0:	0f 85 34 fe ff ff    	jne    8030da <alloc_block_NF+0x20>
  8032a6:	e9 d5 03 00 00       	jmp    803680 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8032ab:	a1 38 51 80 00       	mov    0x805138,%eax
  8032b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032b3:	e9 b1 01 00 00       	jmp    803469 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	8b 50 08             	mov    0x8(%eax),%edx
  8032be:	a1 28 50 80 00       	mov    0x805028,%eax
  8032c3:	39 c2                	cmp    %eax,%edx
  8032c5:	0f 82 96 01 00 00    	jb     803461 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032d4:	0f 82 87 01 00 00    	jb     803461 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032e3:	0f 85 95 00 00 00    	jne    80337e <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8032e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ed:	75 17                	jne    803306 <alloc_block_NF+0x24c>
  8032ef:	83 ec 04             	sub    $0x4,%esp
  8032f2:	68 84 4b 80 00       	push   $0x804b84
  8032f7:	68 fc 00 00 00       	push   $0xfc
  8032fc:	68 db 4a 80 00       	push   $0x804adb
  803301:	e8 22 da ff ff       	call   800d28 <_panic>
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	8b 00                	mov    (%eax),%eax
  80330b:	85 c0                	test   %eax,%eax
  80330d:	74 10                	je     80331f <alloc_block_NF+0x265>
  80330f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803312:	8b 00                	mov    (%eax),%eax
  803314:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803317:	8b 52 04             	mov    0x4(%edx),%edx
  80331a:	89 50 04             	mov    %edx,0x4(%eax)
  80331d:	eb 0b                	jmp    80332a <alloc_block_NF+0x270>
  80331f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803322:	8b 40 04             	mov    0x4(%eax),%eax
  803325:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332d:	8b 40 04             	mov    0x4(%eax),%eax
  803330:	85 c0                	test   %eax,%eax
  803332:	74 0f                	je     803343 <alloc_block_NF+0x289>
  803334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803337:	8b 40 04             	mov    0x4(%eax),%eax
  80333a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80333d:	8b 12                	mov    (%edx),%edx
  80333f:	89 10                	mov    %edx,(%eax)
  803341:	eb 0a                	jmp    80334d <alloc_block_NF+0x293>
  803343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803346:	8b 00                	mov    (%eax),%eax
  803348:	a3 38 51 80 00       	mov    %eax,0x805138
  80334d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803359:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803360:	a1 44 51 80 00       	mov    0x805144,%eax
  803365:	48                   	dec    %eax
  803366:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80336b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336e:	8b 40 08             	mov    0x8(%eax),%eax
  803371:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803379:	e9 07 03 00 00       	jmp    803685 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80337e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803381:	8b 40 0c             	mov    0xc(%eax),%eax
  803384:	3b 45 08             	cmp    0x8(%ebp),%eax
  803387:	0f 86 d4 00 00 00    	jbe    803461 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80338d:	a1 48 51 80 00       	mov    0x805148,%eax
  803392:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803398:	8b 50 08             	mov    0x8(%eax),%edx
  80339b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8033a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8033aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033ae:	75 17                	jne    8033c7 <alloc_block_NF+0x30d>
  8033b0:	83 ec 04             	sub    $0x4,%esp
  8033b3:	68 84 4b 80 00       	push   $0x804b84
  8033b8:	68 04 01 00 00       	push   $0x104
  8033bd:	68 db 4a 80 00       	push   $0x804adb
  8033c2:	e8 61 d9 ff ff       	call   800d28 <_panic>
  8033c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	85 c0                	test   %eax,%eax
  8033ce:	74 10                	je     8033e0 <alloc_block_NF+0x326>
  8033d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d3:	8b 00                	mov    (%eax),%eax
  8033d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d8:	8b 52 04             	mov    0x4(%edx),%edx
  8033db:	89 50 04             	mov    %edx,0x4(%eax)
  8033de:	eb 0b                	jmp    8033eb <alloc_block_NF+0x331>
  8033e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e3:	8b 40 04             	mov    0x4(%eax),%eax
  8033e6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ee:	8b 40 04             	mov    0x4(%eax),%eax
  8033f1:	85 c0                	test   %eax,%eax
  8033f3:	74 0f                	je     803404 <alloc_block_NF+0x34a>
  8033f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f8:	8b 40 04             	mov    0x4(%eax),%eax
  8033fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033fe:	8b 12                	mov    (%edx),%edx
  803400:	89 10                	mov    %edx,(%eax)
  803402:	eb 0a                	jmp    80340e <alloc_block_NF+0x354>
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	8b 00                	mov    (%eax),%eax
  803409:	a3 48 51 80 00       	mov    %eax,0x805148
  80340e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803417:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803421:	a1 54 51 80 00       	mov    0x805154,%eax
  803426:	48                   	dec    %eax
  803427:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80342c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342f:	8b 40 08             	mov    0x8(%eax),%eax
  803432:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343a:	8b 50 08             	mov    0x8(%eax),%edx
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	01 c2                	add    %eax,%edx
  803442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803445:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344b:	8b 40 0c             	mov    0xc(%eax),%eax
  80344e:	2b 45 08             	sub    0x8(%ebp),%eax
  803451:	89 c2                	mov    %eax,%edx
  803453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803456:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345c:	e9 24 02 00 00       	jmp    803685 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803461:	a1 40 51 80 00       	mov    0x805140,%eax
  803466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803469:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346d:	74 07                	je     803476 <alloc_block_NF+0x3bc>
  80346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803472:	8b 00                	mov    (%eax),%eax
  803474:	eb 05                	jmp    80347b <alloc_block_NF+0x3c1>
  803476:	b8 00 00 00 00       	mov    $0x0,%eax
  80347b:	a3 40 51 80 00       	mov    %eax,0x805140
  803480:	a1 40 51 80 00       	mov    0x805140,%eax
  803485:	85 c0                	test   %eax,%eax
  803487:	0f 85 2b fe ff ff    	jne    8032b8 <alloc_block_NF+0x1fe>
  80348d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803491:	0f 85 21 fe ff ff    	jne    8032b8 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803497:	a1 38 51 80 00       	mov    0x805138,%eax
  80349c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80349f:	e9 ae 01 00 00       	jmp    803652 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8034a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a7:	8b 50 08             	mov    0x8(%eax),%edx
  8034aa:	a1 28 50 80 00       	mov    0x805028,%eax
  8034af:	39 c2                	cmp    %eax,%edx
  8034b1:	0f 83 93 01 00 00    	jae    80364a <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8034b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8034bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034c0:	0f 82 84 01 00 00    	jb     80364a <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8034c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034cf:	0f 85 95 00 00 00    	jne    80356a <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8034d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d9:	75 17                	jne    8034f2 <alloc_block_NF+0x438>
  8034db:	83 ec 04             	sub    $0x4,%esp
  8034de:	68 84 4b 80 00       	push   $0x804b84
  8034e3:	68 14 01 00 00       	push   $0x114
  8034e8:	68 db 4a 80 00       	push   $0x804adb
  8034ed:	e8 36 d8 ff ff       	call   800d28 <_panic>
  8034f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f5:	8b 00                	mov    (%eax),%eax
  8034f7:	85 c0                	test   %eax,%eax
  8034f9:	74 10                	je     80350b <alloc_block_NF+0x451>
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	8b 00                	mov    (%eax),%eax
  803500:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803503:	8b 52 04             	mov    0x4(%edx),%edx
  803506:	89 50 04             	mov    %edx,0x4(%eax)
  803509:	eb 0b                	jmp    803516 <alloc_block_NF+0x45c>
  80350b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350e:	8b 40 04             	mov    0x4(%eax),%eax
  803511:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803519:	8b 40 04             	mov    0x4(%eax),%eax
  80351c:	85 c0                	test   %eax,%eax
  80351e:	74 0f                	je     80352f <alloc_block_NF+0x475>
  803520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803523:	8b 40 04             	mov    0x4(%eax),%eax
  803526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803529:	8b 12                	mov    (%edx),%edx
  80352b:	89 10                	mov    %edx,(%eax)
  80352d:	eb 0a                	jmp    803539 <alloc_block_NF+0x47f>
  80352f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803532:	8b 00                	mov    (%eax),%eax
  803534:	a3 38 51 80 00       	mov    %eax,0x805138
  803539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80354c:	a1 44 51 80 00       	mov    0x805144,%eax
  803551:	48                   	dec    %eax
  803552:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355a:	8b 40 08             	mov    0x8(%eax),%eax
  80355d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803565:	e9 1b 01 00 00       	jmp    803685 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80356a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356d:	8b 40 0c             	mov    0xc(%eax),%eax
  803570:	3b 45 08             	cmp    0x8(%ebp),%eax
  803573:	0f 86 d1 00 00 00    	jbe    80364a <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803579:	a1 48 51 80 00       	mov    0x805148,%eax
  80357e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  803581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803584:	8b 50 08             	mov    0x8(%eax),%edx
  803587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80358d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803590:	8b 55 08             	mov    0x8(%ebp),%edx
  803593:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803596:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80359a:	75 17                	jne    8035b3 <alloc_block_NF+0x4f9>
  80359c:	83 ec 04             	sub    $0x4,%esp
  80359f:	68 84 4b 80 00       	push   $0x804b84
  8035a4:	68 1c 01 00 00       	push   $0x11c
  8035a9:	68 db 4a 80 00       	push   $0x804adb
  8035ae:	e8 75 d7 ff ff       	call   800d28 <_panic>
  8035b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b6:	8b 00                	mov    (%eax),%eax
  8035b8:	85 c0                	test   %eax,%eax
  8035ba:	74 10                	je     8035cc <alloc_block_NF+0x512>
  8035bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035c4:	8b 52 04             	mov    0x4(%edx),%edx
  8035c7:	89 50 04             	mov    %edx,0x4(%eax)
  8035ca:	eb 0b                	jmp    8035d7 <alloc_block_NF+0x51d>
  8035cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035cf:	8b 40 04             	mov    0x4(%eax),%eax
  8035d2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035da:	8b 40 04             	mov    0x4(%eax),%eax
  8035dd:	85 c0                	test   %eax,%eax
  8035df:	74 0f                	je     8035f0 <alloc_block_NF+0x536>
  8035e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e4:	8b 40 04             	mov    0x4(%eax),%eax
  8035e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035ea:	8b 12                	mov    (%edx),%edx
  8035ec:	89 10                	mov    %edx,(%eax)
  8035ee:	eb 0a                	jmp    8035fa <alloc_block_NF+0x540>
  8035f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f3:	8b 00                	mov    (%eax),%eax
  8035f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8035fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803603:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803606:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80360d:	a1 54 51 80 00       	mov    0x805154,%eax
  803612:	48                   	dec    %eax
  803613:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803618:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80361b:	8b 40 08             	mov    0x8(%eax),%eax
  80361e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803626:	8b 50 08             	mov    0x8(%eax),%edx
  803629:	8b 45 08             	mov    0x8(%ebp),%eax
  80362c:	01 c2                	add    %eax,%edx
  80362e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803631:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803637:	8b 40 0c             	mov    0xc(%eax),%eax
  80363a:	2b 45 08             	sub    0x8(%ebp),%eax
  80363d:	89 c2                	mov    %eax,%edx
  80363f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803642:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803645:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803648:	eb 3b                	jmp    803685 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80364a:	a1 40 51 80 00       	mov    0x805140,%eax
  80364f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803656:	74 07                	je     80365f <alloc_block_NF+0x5a5>
  803658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365b:	8b 00                	mov    (%eax),%eax
  80365d:	eb 05                	jmp    803664 <alloc_block_NF+0x5aa>
  80365f:	b8 00 00 00 00       	mov    $0x0,%eax
  803664:	a3 40 51 80 00       	mov    %eax,0x805140
  803669:	a1 40 51 80 00       	mov    0x805140,%eax
  80366e:	85 c0                	test   %eax,%eax
  803670:	0f 85 2e fe ff ff    	jne    8034a4 <alloc_block_NF+0x3ea>
  803676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367a:	0f 85 24 fe ff ff    	jne    8034a4 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  803680:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803685:	c9                   	leave  
  803686:	c3                   	ret    

00803687 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803687:	55                   	push   %ebp
  803688:	89 e5                	mov    %esp,%ebp
  80368a:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80368d:	a1 38 51 80 00       	mov    0x805138,%eax
  803692:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803695:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80369a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80369d:	a1 38 51 80 00       	mov    0x805138,%eax
  8036a2:	85 c0                	test   %eax,%eax
  8036a4:	74 14                	je     8036ba <insert_sorted_with_merge_freeList+0x33>
  8036a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a9:	8b 50 08             	mov    0x8(%eax),%edx
  8036ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036af:	8b 40 08             	mov    0x8(%eax),%eax
  8036b2:	39 c2                	cmp    %eax,%edx
  8036b4:	0f 87 9b 01 00 00    	ja     803855 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8036ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036be:	75 17                	jne    8036d7 <insert_sorted_with_merge_freeList+0x50>
  8036c0:	83 ec 04             	sub    $0x4,%esp
  8036c3:	68 b8 4a 80 00       	push   $0x804ab8
  8036c8:	68 38 01 00 00       	push   $0x138
  8036cd:	68 db 4a 80 00       	push   $0x804adb
  8036d2:	e8 51 d6 ff ff       	call   800d28 <_panic>
  8036d7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8036dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e0:	89 10                	mov    %edx,(%eax)
  8036e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e5:	8b 00                	mov    (%eax),%eax
  8036e7:	85 c0                	test   %eax,%eax
  8036e9:	74 0d                	je     8036f8 <insert_sorted_with_merge_freeList+0x71>
  8036eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8036f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8036f3:	89 50 04             	mov    %edx,0x4(%eax)
  8036f6:	eb 08                	jmp    803700 <insert_sorted_with_merge_freeList+0x79>
  8036f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803700:	8b 45 08             	mov    0x8(%ebp),%eax
  803703:	a3 38 51 80 00       	mov    %eax,0x805138
  803708:	8b 45 08             	mov    0x8(%ebp),%eax
  80370b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803712:	a1 44 51 80 00       	mov    0x805144,%eax
  803717:	40                   	inc    %eax
  803718:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80371d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803721:	0f 84 a8 06 00 00    	je     803dcf <insert_sorted_with_merge_freeList+0x748>
  803727:	8b 45 08             	mov    0x8(%ebp),%eax
  80372a:	8b 50 08             	mov    0x8(%eax),%edx
  80372d:	8b 45 08             	mov    0x8(%ebp),%eax
  803730:	8b 40 0c             	mov    0xc(%eax),%eax
  803733:	01 c2                	add    %eax,%edx
  803735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803738:	8b 40 08             	mov    0x8(%eax),%eax
  80373b:	39 c2                	cmp    %eax,%edx
  80373d:	0f 85 8c 06 00 00    	jne    803dcf <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  803743:	8b 45 08             	mov    0x8(%ebp),%eax
  803746:	8b 50 0c             	mov    0xc(%eax),%edx
  803749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374c:	8b 40 0c             	mov    0xc(%eax),%eax
  80374f:	01 c2                	add    %eax,%edx
  803751:	8b 45 08             	mov    0x8(%ebp),%eax
  803754:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803757:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80375b:	75 17                	jne    803774 <insert_sorted_with_merge_freeList+0xed>
  80375d:	83 ec 04             	sub    $0x4,%esp
  803760:	68 84 4b 80 00       	push   $0x804b84
  803765:	68 3c 01 00 00       	push   $0x13c
  80376a:	68 db 4a 80 00       	push   $0x804adb
  80376f:	e8 b4 d5 ff ff       	call   800d28 <_panic>
  803774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803777:	8b 00                	mov    (%eax),%eax
  803779:	85 c0                	test   %eax,%eax
  80377b:	74 10                	je     80378d <insert_sorted_with_merge_freeList+0x106>
  80377d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803780:	8b 00                	mov    (%eax),%eax
  803782:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803785:	8b 52 04             	mov    0x4(%edx),%edx
  803788:	89 50 04             	mov    %edx,0x4(%eax)
  80378b:	eb 0b                	jmp    803798 <insert_sorted_with_merge_freeList+0x111>
  80378d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803790:	8b 40 04             	mov    0x4(%eax),%eax
  803793:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379b:	8b 40 04             	mov    0x4(%eax),%eax
  80379e:	85 c0                	test   %eax,%eax
  8037a0:	74 0f                	je     8037b1 <insert_sorted_with_merge_freeList+0x12a>
  8037a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a5:	8b 40 04             	mov    0x4(%eax),%eax
  8037a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037ab:	8b 12                	mov    (%edx),%edx
  8037ad:	89 10                	mov    %edx,(%eax)
  8037af:	eb 0a                	jmp    8037bb <insert_sorted_with_merge_freeList+0x134>
  8037b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b4:	8b 00                	mov    (%eax),%eax
  8037b6:	a3 38 51 80 00       	mov    %eax,0x805138
  8037bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8037d3:	48                   	dec    %eax
  8037d4:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8037d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8037e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8037ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037f1:	75 17                	jne    80380a <insert_sorted_with_merge_freeList+0x183>
  8037f3:	83 ec 04             	sub    $0x4,%esp
  8037f6:	68 b8 4a 80 00       	push   $0x804ab8
  8037fb:	68 3f 01 00 00       	push   $0x13f
  803800:	68 db 4a 80 00       	push   $0x804adb
  803805:	e8 1e d5 ff ff       	call   800d28 <_panic>
  80380a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803813:	89 10                	mov    %edx,(%eax)
  803815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803818:	8b 00                	mov    (%eax),%eax
  80381a:	85 c0                	test   %eax,%eax
  80381c:	74 0d                	je     80382b <insert_sorted_with_merge_freeList+0x1a4>
  80381e:	a1 48 51 80 00       	mov    0x805148,%eax
  803823:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803826:	89 50 04             	mov    %edx,0x4(%eax)
  803829:	eb 08                	jmp    803833 <insert_sorted_with_merge_freeList+0x1ac>
  80382b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803836:	a3 48 51 80 00       	mov    %eax,0x805148
  80383b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80383e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803845:	a1 54 51 80 00       	mov    0x805154,%eax
  80384a:	40                   	inc    %eax
  80384b:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803850:	e9 7a 05 00 00       	jmp    803dcf <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803855:	8b 45 08             	mov    0x8(%ebp),%eax
  803858:	8b 50 08             	mov    0x8(%eax),%edx
  80385b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80385e:	8b 40 08             	mov    0x8(%eax),%eax
  803861:	39 c2                	cmp    %eax,%edx
  803863:	0f 82 14 01 00 00    	jb     80397d <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803869:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80386c:	8b 50 08             	mov    0x8(%eax),%edx
  80386f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803872:	8b 40 0c             	mov    0xc(%eax),%eax
  803875:	01 c2                	add    %eax,%edx
  803877:	8b 45 08             	mov    0x8(%ebp),%eax
  80387a:	8b 40 08             	mov    0x8(%eax),%eax
  80387d:	39 c2                	cmp    %eax,%edx
  80387f:	0f 85 90 00 00 00    	jne    803915 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803888:	8b 50 0c             	mov    0xc(%eax),%edx
  80388b:	8b 45 08             	mov    0x8(%ebp),%eax
  80388e:	8b 40 0c             	mov    0xc(%eax),%eax
  803891:	01 c2                	add    %eax,%edx
  803893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803896:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803899:	8b 45 08             	mov    0x8(%ebp),%eax
  80389c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  8038a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8038ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038b1:	75 17                	jne    8038ca <insert_sorted_with_merge_freeList+0x243>
  8038b3:	83 ec 04             	sub    $0x4,%esp
  8038b6:	68 b8 4a 80 00       	push   $0x804ab8
  8038bb:	68 49 01 00 00       	push   $0x149
  8038c0:	68 db 4a 80 00       	push   $0x804adb
  8038c5:	e8 5e d4 ff ff       	call   800d28 <_panic>
  8038ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d3:	89 10                	mov    %edx,(%eax)
  8038d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d8:	8b 00                	mov    (%eax),%eax
  8038da:	85 c0                	test   %eax,%eax
  8038dc:	74 0d                	je     8038eb <insert_sorted_with_merge_freeList+0x264>
  8038de:	a1 48 51 80 00       	mov    0x805148,%eax
  8038e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8038e6:	89 50 04             	mov    %edx,0x4(%eax)
  8038e9:	eb 08                	jmp    8038f3 <insert_sorted_with_merge_freeList+0x26c>
  8038eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8038fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803905:	a1 54 51 80 00       	mov    0x805154,%eax
  80390a:	40                   	inc    %eax
  80390b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803910:	e9 bb 04 00 00       	jmp    803dd0 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803915:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803919:	75 17                	jne    803932 <insert_sorted_with_merge_freeList+0x2ab>
  80391b:	83 ec 04             	sub    $0x4,%esp
  80391e:	68 2c 4b 80 00       	push   $0x804b2c
  803923:	68 4c 01 00 00       	push   $0x14c
  803928:	68 db 4a 80 00       	push   $0x804adb
  80392d:	e8 f6 d3 ff ff       	call   800d28 <_panic>
  803932:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803938:	8b 45 08             	mov    0x8(%ebp),%eax
  80393b:	89 50 04             	mov    %edx,0x4(%eax)
  80393e:	8b 45 08             	mov    0x8(%ebp),%eax
  803941:	8b 40 04             	mov    0x4(%eax),%eax
  803944:	85 c0                	test   %eax,%eax
  803946:	74 0c                	je     803954 <insert_sorted_with_merge_freeList+0x2cd>
  803948:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80394d:	8b 55 08             	mov    0x8(%ebp),%edx
  803950:	89 10                	mov    %edx,(%eax)
  803952:	eb 08                	jmp    80395c <insert_sorted_with_merge_freeList+0x2d5>
  803954:	8b 45 08             	mov    0x8(%ebp),%eax
  803957:	a3 38 51 80 00       	mov    %eax,0x805138
  80395c:	8b 45 08             	mov    0x8(%ebp),%eax
  80395f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803964:	8b 45 08             	mov    0x8(%ebp),%eax
  803967:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80396d:	a1 44 51 80 00       	mov    0x805144,%eax
  803972:	40                   	inc    %eax
  803973:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803978:	e9 53 04 00 00       	jmp    803dd0 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80397d:	a1 38 51 80 00       	mov    0x805138,%eax
  803982:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803985:	e9 15 04 00 00       	jmp    803d9f <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80398a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80398d:	8b 00                	mov    (%eax),%eax
  80398f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803992:	8b 45 08             	mov    0x8(%ebp),%eax
  803995:	8b 50 08             	mov    0x8(%eax),%edx
  803998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399b:	8b 40 08             	mov    0x8(%eax),%eax
  80399e:	39 c2                	cmp    %eax,%edx
  8039a0:	0f 86 f1 03 00 00    	jbe    803d97 <insert_sorted_with_merge_freeList+0x710>
  8039a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a9:	8b 50 08             	mov    0x8(%eax),%edx
  8039ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039af:	8b 40 08             	mov    0x8(%eax),%eax
  8039b2:	39 c2                	cmp    %eax,%edx
  8039b4:	0f 83 dd 03 00 00    	jae    803d97 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8039ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bd:	8b 50 08             	mov    0x8(%eax),%edx
  8039c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8039c6:	01 c2                	add    %eax,%edx
  8039c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039cb:	8b 40 08             	mov    0x8(%eax),%eax
  8039ce:	39 c2                	cmp    %eax,%edx
  8039d0:	0f 85 b9 01 00 00    	jne    803b8f <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8039d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d9:	8b 50 08             	mov    0x8(%eax),%edx
  8039dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039df:	8b 40 0c             	mov    0xc(%eax),%eax
  8039e2:	01 c2                	add    %eax,%edx
  8039e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e7:	8b 40 08             	mov    0x8(%eax),%eax
  8039ea:	39 c2                	cmp    %eax,%edx
  8039ec:	0f 85 0d 01 00 00    	jne    803aff <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8039f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f5:	8b 50 0c             	mov    0xc(%eax),%edx
  8039f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8039fe:	01 c2                	add    %eax,%edx
  803a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a03:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803a06:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a0a:	75 17                	jne    803a23 <insert_sorted_with_merge_freeList+0x39c>
  803a0c:	83 ec 04             	sub    $0x4,%esp
  803a0f:	68 84 4b 80 00       	push   $0x804b84
  803a14:	68 5c 01 00 00       	push   $0x15c
  803a19:	68 db 4a 80 00       	push   $0x804adb
  803a1e:	e8 05 d3 ff ff       	call   800d28 <_panic>
  803a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a26:	8b 00                	mov    (%eax),%eax
  803a28:	85 c0                	test   %eax,%eax
  803a2a:	74 10                	je     803a3c <insert_sorted_with_merge_freeList+0x3b5>
  803a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2f:	8b 00                	mov    (%eax),%eax
  803a31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a34:	8b 52 04             	mov    0x4(%edx),%edx
  803a37:	89 50 04             	mov    %edx,0x4(%eax)
  803a3a:	eb 0b                	jmp    803a47 <insert_sorted_with_merge_freeList+0x3c0>
  803a3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3f:	8b 40 04             	mov    0x4(%eax),%eax
  803a42:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a4a:	8b 40 04             	mov    0x4(%eax),%eax
  803a4d:	85 c0                	test   %eax,%eax
  803a4f:	74 0f                	je     803a60 <insert_sorted_with_merge_freeList+0x3d9>
  803a51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a54:	8b 40 04             	mov    0x4(%eax),%eax
  803a57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a5a:	8b 12                	mov    (%edx),%edx
  803a5c:	89 10                	mov    %edx,(%eax)
  803a5e:	eb 0a                	jmp    803a6a <insert_sorted_with_merge_freeList+0x3e3>
  803a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a63:	8b 00                	mov    (%eax),%eax
  803a65:	a3 38 51 80 00       	mov    %eax,0x805138
  803a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a7d:	a1 44 51 80 00       	mov    0x805144,%eax
  803a82:	48                   	dec    %eax
  803a83:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a8b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a95:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803aa0:	75 17                	jne    803ab9 <insert_sorted_with_merge_freeList+0x432>
  803aa2:	83 ec 04             	sub    $0x4,%esp
  803aa5:	68 b8 4a 80 00       	push   $0x804ab8
  803aaa:	68 5f 01 00 00       	push   $0x15f
  803aaf:	68 db 4a 80 00       	push   $0x804adb
  803ab4:	e8 6f d2 ff ff       	call   800d28 <_panic>
  803ab9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803abf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac2:	89 10                	mov    %edx,(%eax)
  803ac4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac7:	8b 00                	mov    (%eax),%eax
  803ac9:	85 c0                	test   %eax,%eax
  803acb:	74 0d                	je     803ada <insert_sorted_with_merge_freeList+0x453>
  803acd:	a1 48 51 80 00       	mov    0x805148,%eax
  803ad2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ad5:	89 50 04             	mov    %edx,0x4(%eax)
  803ad8:	eb 08                	jmp    803ae2 <insert_sorted_with_merge_freeList+0x45b>
  803ada:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803add:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ae2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae5:	a3 48 51 80 00       	mov    %eax,0x805148
  803aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af4:	a1 54 51 80 00       	mov    0x805154,%eax
  803af9:	40                   	inc    %eax
  803afa:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b02:	8b 50 0c             	mov    0xc(%eax),%edx
  803b05:	8b 45 08             	mov    0x8(%ebp),%eax
  803b08:	8b 40 0c             	mov    0xc(%eax),%eax
  803b0b:	01 c2                	add    %eax,%edx
  803b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b10:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803b13:	8b 45 08             	mov    0x8(%ebp),%eax
  803b16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803b27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b2b:	75 17                	jne    803b44 <insert_sorted_with_merge_freeList+0x4bd>
  803b2d:	83 ec 04             	sub    $0x4,%esp
  803b30:	68 b8 4a 80 00       	push   $0x804ab8
  803b35:	68 64 01 00 00       	push   $0x164
  803b3a:	68 db 4a 80 00       	push   $0x804adb
  803b3f:	e8 e4 d1 ff ff       	call   800d28 <_panic>
  803b44:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4d:	89 10                	mov    %edx,(%eax)
  803b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b52:	8b 00                	mov    (%eax),%eax
  803b54:	85 c0                	test   %eax,%eax
  803b56:	74 0d                	je     803b65 <insert_sorted_with_merge_freeList+0x4de>
  803b58:	a1 48 51 80 00       	mov    0x805148,%eax
  803b5d:	8b 55 08             	mov    0x8(%ebp),%edx
  803b60:	89 50 04             	mov    %edx,0x4(%eax)
  803b63:	eb 08                	jmp    803b6d <insert_sorted_with_merge_freeList+0x4e6>
  803b65:	8b 45 08             	mov    0x8(%ebp),%eax
  803b68:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b70:	a3 48 51 80 00       	mov    %eax,0x805148
  803b75:	8b 45 08             	mov    0x8(%ebp),%eax
  803b78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b7f:	a1 54 51 80 00       	mov    0x805154,%eax
  803b84:	40                   	inc    %eax
  803b85:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803b8a:	e9 41 02 00 00       	jmp    803dd0 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b92:	8b 50 08             	mov    0x8(%eax),%edx
  803b95:	8b 45 08             	mov    0x8(%ebp),%eax
  803b98:	8b 40 0c             	mov    0xc(%eax),%eax
  803b9b:	01 c2                	add    %eax,%edx
  803b9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba0:	8b 40 08             	mov    0x8(%eax),%eax
  803ba3:	39 c2                	cmp    %eax,%edx
  803ba5:	0f 85 7c 01 00 00    	jne    803d27 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803bab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803baf:	74 06                	je     803bb7 <insert_sorted_with_merge_freeList+0x530>
  803bb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803bb5:	75 17                	jne    803bce <insert_sorted_with_merge_freeList+0x547>
  803bb7:	83 ec 04             	sub    $0x4,%esp
  803bba:	68 f4 4a 80 00       	push   $0x804af4
  803bbf:	68 69 01 00 00       	push   $0x169
  803bc4:	68 db 4a 80 00       	push   $0x804adb
  803bc9:	e8 5a d1 ff ff       	call   800d28 <_panic>
  803bce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd1:	8b 50 04             	mov    0x4(%eax),%edx
  803bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd7:	89 50 04             	mov    %edx,0x4(%eax)
  803bda:	8b 45 08             	mov    0x8(%ebp),%eax
  803bdd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803be0:	89 10                	mov    %edx,(%eax)
  803be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be5:	8b 40 04             	mov    0x4(%eax),%eax
  803be8:	85 c0                	test   %eax,%eax
  803bea:	74 0d                	je     803bf9 <insert_sorted_with_merge_freeList+0x572>
  803bec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bef:	8b 40 04             	mov    0x4(%eax),%eax
  803bf2:	8b 55 08             	mov    0x8(%ebp),%edx
  803bf5:	89 10                	mov    %edx,(%eax)
  803bf7:	eb 08                	jmp    803c01 <insert_sorted_with_merge_freeList+0x57a>
  803bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bfc:	a3 38 51 80 00       	mov    %eax,0x805138
  803c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c04:	8b 55 08             	mov    0x8(%ebp),%edx
  803c07:	89 50 04             	mov    %edx,0x4(%eax)
  803c0a:	a1 44 51 80 00       	mov    0x805144,%eax
  803c0f:	40                   	inc    %eax
  803c10:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803c15:	8b 45 08             	mov    0x8(%ebp),%eax
  803c18:	8b 50 0c             	mov    0xc(%eax),%edx
  803c1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c1e:	8b 40 0c             	mov    0xc(%eax),%eax
  803c21:	01 c2                	add    %eax,%edx
  803c23:	8b 45 08             	mov    0x8(%ebp),%eax
  803c26:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803c29:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c2d:	75 17                	jne    803c46 <insert_sorted_with_merge_freeList+0x5bf>
  803c2f:	83 ec 04             	sub    $0x4,%esp
  803c32:	68 84 4b 80 00       	push   $0x804b84
  803c37:	68 6b 01 00 00       	push   $0x16b
  803c3c:	68 db 4a 80 00       	push   $0x804adb
  803c41:	e8 e2 d0 ff ff       	call   800d28 <_panic>
  803c46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c49:	8b 00                	mov    (%eax),%eax
  803c4b:	85 c0                	test   %eax,%eax
  803c4d:	74 10                	je     803c5f <insert_sorted_with_merge_freeList+0x5d8>
  803c4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c52:	8b 00                	mov    (%eax),%eax
  803c54:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c57:	8b 52 04             	mov    0x4(%edx),%edx
  803c5a:	89 50 04             	mov    %edx,0x4(%eax)
  803c5d:	eb 0b                	jmp    803c6a <insert_sorted_with_merge_freeList+0x5e3>
  803c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c62:	8b 40 04             	mov    0x4(%eax),%eax
  803c65:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6d:	8b 40 04             	mov    0x4(%eax),%eax
  803c70:	85 c0                	test   %eax,%eax
  803c72:	74 0f                	je     803c83 <insert_sorted_with_merge_freeList+0x5fc>
  803c74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c77:	8b 40 04             	mov    0x4(%eax),%eax
  803c7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c7d:	8b 12                	mov    (%edx),%edx
  803c7f:	89 10                	mov    %edx,(%eax)
  803c81:	eb 0a                	jmp    803c8d <insert_sorted_with_merge_freeList+0x606>
  803c83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c86:	8b 00                	mov    (%eax),%eax
  803c88:	a3 38 51 80 00       	mov    %eax,0x805138
  803c8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ca0:	a1 44 51 80 00       	mov    0x805144,%eax
  803ca5:	48                   	dec    %eax
  803ca6:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cb8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803cbf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803cc3:	75 17                	jne    803cdc <insert_sorted_with_merge_freeList+0x655>
  803cc5:	83 ec 04             	sub    $0x4,%esp
  803cc8:	68 b8 4a 80 00       	push   $0x804ab8
  803ccd:	68 6e 01 00 00       	push   $0x16e
  803cd2:	68 db 4a 80 00       	push   $0x804adb
  803cd7:	e8 4c d0 ff ff       	call   800d28 <_panic>
  803cdc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ce5:	89 10                	mov    %edx,(%eax)
  803ce7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cea:	8b 00                	mov    (%eax),%eax
  803cec:	85 c0                	test   %eax,%eax
  803cee:	74 0d                	je     803cfd <insert_sorted_with_merge_freeList+0x676>
  803cf0:	a1 48 51 80 00       	mov    0x805148,%eax
  803cf5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cf8:	89 50 04             	mov    %edx,0x4(%eax)
  803cfb:	eb 08                	jmp    803d05 <insert_sorted_with_merge_freeList+0x67e>
  803cfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d00:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803d05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d08:	a3 48 51 80 00       	mov    %eax,0x805148
  803d0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d17:	a1 54 51 80 00       	mov    0x805154,%eax
  803d1c:	40                   	inc    %eax
  803d1d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803d22:	e9 a9 00 00 00       	jmp    803dd0 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803d27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d2b:	74 06                	je     803d33 <insert_sorted_with_merge_freeList+0x6ac>
  803d2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d31:	75 17                	jne    803d4a <insert_sorted_with_merge_freeList+0x6c3>
  803d33:	83 ec 04             	sub    $0x4,%esp
  803d36:	68 50 4b 80 00       	push   $0x804b50
  803d3b:	68 73 01 00 00       	push   $0x173
  803d40:	68 db 4a 80 00       	push   $0x804adb
  803d45:	e8 de cf ff ff       	call   800d28 <_panic>
  803d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4d:	8b 10                	mov    (%eax),%edx
  803d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d52:	89 10                	mov    %edx,(%eax)
  803d54:	8b 45 08             	mov    0x8(%ebp),%eax
  803d57:	8b 00                	mov    (%eax),%eax
  803d59:	85 c0                	test   %eax,%eax
  803d5b:	74 0b                	je     803d68 <insert_sorted_with_merge_freeList+0x6e1>
  803d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d60:	8b 00                	mov    (%eax),%eax
  803d62:	8b 55 08             	mov    0x8(%ebp),%edx
  803d65:	89 50 04             	mov    %edx,0x4(%eax)
  803d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  803d6e:	89 10                	mov    %edx,(%eax)
  803d70:	8b 45 08             	mov    0x8(%ebp),%eax
  803d73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d76:	89 50 04             	mov    %edx,0x4(%eax)
  803d79:	8b 45 08             	mov    0x8(%ebp),%eax
  803d7c:	8b 00                	mov    (%eax),%eax
  803d7e:	85 c0                	test   %eax,%eax
  803d80:	75 08                	jne    803d8a <insert_sorted_with_merge_freeList+0x703>
  803d82:	8b 45 08             	mov    0x8(%ebp),%eax
  803d85:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803d8a:	a1 44 51 80 00       	mov    0x805144,%eax
  803d8f:	40                   	inc    %eax
  803d90:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803d95:	eb 39                	jmp    803dd0 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803d97:	a1 40 51 80 00       	mov    0x805140,%eax
  803d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803da3:	74 07                	je     803dac <insert_sorted_with_merge_freeList+0x725>
  803da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da8:	8b 00                	mov    (%eax),%eax
  803daa:	eb 05                	jmp    803db1 <insert_sorted_with_merge_freeList+0x72a>
  803dac:	b8 00 00 00 00       	mov    $0x0,%eax
  803db1:	a3 40 51 80 00       	mov    %eax,0x805140
  803db6:	a1 40 51 80 00       	mov    0x805140,%eax
  803dbb:	85 c0                	test   %eax,%eax
  803dbd:	0f 85 c7 fb ff ff    	jne    80398a <insert_sorted_with_merge_freeList+0x303>
  803dc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803dc7:	0f 85 bd fb ff ff    	jne    80398a <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803dcd:	eb 01                	jmp    803dd0 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803dcf:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803dd0:	90                   	nop
  803dd1:	c9                   	leave  
  803dd2:	c3                   	ret    
  803dd3:	90                   	nop

00803dd4 <__udivdi3>:
  803dd4:	55                   	push   %ebp
  803dd5:	57                   	push   %edi
  803dd6:	56                   	push   %esi
  803dd7:	53                   	push   %ebx
  803dd8:	83 ec 1c             	sub    $0x1c,%esp
  803ddb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ddf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803de3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803de7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803deb:	89 ca                	mov    %ecx,%edx
  803ded:	89 f8                	mov    %edi,%eax
  803def:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803df3:	85 f6                	test   %esi,%esi
  803df5:	75 2d                	jne    803e24 <__udivdi3+0x50>
  803df7:	39 cf                	cmp    %ecx,%edi
  803df9:	77 65                	ja     803e60 <__udivdi3+0x8c>
  803dfb:	89 fd                	mov    %edi,%ebp
  803dfd:	85 ff                	test   %edi,%edi
  803dff:	75 0b                	jne    803e0c <__udivdi3+0x38>
  803e01:	b8 01 00 00 00       	mov    $0x1,%eax
  803e06:	31 d2                	xor    %edx,%edx
  803e08:	f7 f7                	div    %edi
  803e0a:	89 c5                	mov    %eax,%ebp
  803e0c:	31 d2                	xor    %edx,%edx
  803e0e:	89 c8                	mov    %ecx,%eax
  803e10:	f7 f5                	div    %ebp
  803e12:	89 c1                	mov    %eax,%ecx
  803e14:	89 d8                	mov    %ebx,%eax
  803e16:	f7 f5                	div    %ebp
  803e18:	89 cf                	mov    %ecx,%edi
  803e1a:	89 fa                	mov    %edi,%edx
  803e1c:	83 c4 1c             	add    $0x1c,%esp
  803e1f:	5b                   	pop    %ebx
  803e20:	5e                   	pop    %esi
  803e21:	5f                   	pop    %edi
  803e22:	5d                   	pop    %ebp
  803e23:	c3                   	ret    
  803e24:	39 ce                	cmp    %ecx,%esi
  803e26:	77 28                	ja     803e50 <__udivdi3+0x7c>
  803e28:	0f bd fe             	bsr    %esi,%edi
  803e2b:	83 f7 1f             	xor    $0x1f,%edi
  803e2e:	75 40                	jne    803e70 <__udivdi3+0x9c>
  803e30:	39 ce                	cmp    %ecx,%esi
  803e32:	72 0a                	jb     803e3e <__udivdi3+0x6a>
  803e34:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e38:	0f 87 9e 00 00 00    	ja     803edc <__udivdi3+0x108>
  803e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  803e43:	89 fa                	mov    %edi,%edx
  803e45:	83 c4 1c             	add    $0x1c,%esp
  803e48:	5b                   	pop    %ebx
  803e49:	5e                   	pop    %esi
  803e4a:	5f                   	pop    %edi
  803e4b:	5d                   	pop    %ebp
  803e4c:	c3                   	ret    
  803e4d:	8d 76 00             	lea    0x0(%esi),%esi
  803e50:	31 ff                	xor    %edi,%edi
  803e52:	31 c0                	xor    %eax,%eax
  803e54:	89 fa                	mov    %edi,%edx
  803e56:	83 c4 1c             	add    $0x1c,%esp
  803e59:	5b                   	pop    %ebx
  803e5a:	5e                   	pop    %esi
  803e5b:	5f                   	pop    %edi
  803e5c:	5d                   	pop    %ebp
  803e5d:	c3                   	ret    
  803e5e:	66 90                	xchg   %ax,%ax
  803e60:	89 d8                	mov    %ebx,%eax
  803e62:	f7 f7                	div    %edi
  803e64:	31 ff                	xor    %edi,%edi
  803e66:	89 fa                	mov    %edi,%edx
  803e68:	83 c4 1c             	add    $0x1c,%esp
  803e6b:	5b                   	pop    %ebx
  803e6c:	5e                   	pop    %esi
  803e6d:	5f                   	pop    %edi
  803e6e:	5d                   	pop    %ebp
  803e6f:	c3                   	ret    
  803e70:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e75:	89 eb                	mov    %ebp,%ebx
  803e77:	29 fb                	sub    %edi,%ebx
  803e79:	89 f9                	mov    %edi,%ecx
  803e7b:	d3 e6                	shl    %cl,%esi
  803e7d:	89 c5                	mov    %eax,%ebp
  803e7f:	88 d9                	mov    %bl,%cl
  803e81:	d3 ed                	shr    %cl,%ebp
  803e83:	89 e9                	mov    %ebp,%ecx
  803e85:	09 f1                	or     %esi,%ecx
  803e87:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e8b:	89 f9                	mov    %edi,%ecx
  803e8d:	d3 e0                	shl    %cl,%eax
  803e8f:	89 c5                	mov    %eax,%ebp
  803e91:	89 d6                	mov    %edx,%esi
  803e93:	88 d9                	mov    %bl,%cl
  803e95:	d3 ee                	shr    %cl,%esi
  803e97:	89 f9                	mov    %edi,%ecx
  803e99:	d3 e2                	shl    %cl,%edx
  803e9b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e9f:	88 d9                	mov    %bl,%cl
  803ea1:	d3 e8                	shr    %cl,%eax
  803ea3:	09 c2                	or     %eax,%edx
  803ea5:	89 d0                	mov    %edx,%eax
  803ea7:	89 f2                	mov    %esi,%edx
  803ea9:	f7 74 24 0c          	divl   0xc(%esp)
  803ead:	89 d6                	mov    %edx,%esi
  803eaf:	89 c3                	mov    %eax,%ebx
  803eb1:	f7 e5                	mul    %ebp
  803eb3:	39 d6                	cmp    %edx,%esi
  803eb5:	72 19                	jb     803ed0 <__udivdi3+0xfc>
  803eb7:	74 0b                	je     803ec4 <__udivdi3+0xf0>
  803eb9:	89 d8                	mov    %ebx,%eax
  803ebb:	31 ff                	xor    %edi,%edi
  803ebd:	e9 58 ff ff ff       	jmp    803e1a <__udivdi3+0x46>
  803ec2:	66 90                	xchg   %ax,%ax
  803ec4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ec8:	89 f9                	mov    %edi,%ecx
  803eca:	d3 e2                	shl    %cl,%edx
  803ecc:	39 c2                	cmp    %eax,%edx
  803ece:	73 e9                	jae    803eb9 <__udivdi3+0xe5>
  803ed0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803ed3:	31 ff                	xor    %edi,%edi
  803ed5:	e9 40 ff ff ff       	jmp    803e1a <__udivdi3+0x46>
  803eda:	66 90                	xchg   %ax,%ax
  803edc:	31 c0                	xor    %eax,%eax
  803ede:	e9 37 ff ff ff       	jmp    803e1a <__udivdi3+0x46>
  803ee3:	90                   	nop

00803ee4 <__umoddi3>:
  803ee4:	55                   	push   %ebp
  803ee5:	57                   	push   %edi
  803ee6:	56                   	push   %esi
  803ee7:	53                   	push   %ebx
  803ee8:	83 ec 1c             	sub    $0x1c,%esp
  803eeb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803eef:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ef3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ef7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803efb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803eff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803f03:	89 f3                	mov    %esi,%ebx
  803f05:	89 fa                	mov    %edi,%edx
  803f07:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f0b:	89 34 24             	mov    %esi,(%esp)
  803f0e:	85 c0                	test   %eax,%eax
  803f10:	75 1a                	jne    803f2c <__umoddi3+0x48>
  803f12:	39 f7                	cmp    %esi,%edi
  803f14:	0f 86 a2 00 00 00    	jbe    803fbc <__umoddi3+0xd8>
  803f1a:	89 c8                	mov    %ecx,%eax
  803f1c:	89 f2                	mov    %esi,%edx
  803f1e:	f7 f7                	div    %edi
  803f20:	89 d0                	mov    %edx,%eax
  803f22:	31 d2                	xor    %edx,%edx
  803f24:	83 c4 1c             	add    $0x1c,%esp
  803f27:	5b                   	pop    %ebx
  803f28:	5e                   	pop    %esi
  803f29:	5f                   	pop    %edi
  803f2a:	5d                   	pop    %ebp
  803f2b:	c3                   	ret    
  803f2c:	39 f0                	cmp    %esi,%eax
  803f2e:	0f 87 ac 00 00 00    	ja     803fe0 <__umoddi3+0xfc>
  803f34:	0f bd e8             	bsr    %eax,%ebp
  803f37:	83 f5 1f             	xor    $0x1f,%ebp
  803f3a:	0f 84 ac 00 00 00    	je     803fec <__umoddi3+0x108>
  803f40:	bf 20 00 00 00       	mov    $0x20,%edi
  803f45:	29 ef                	sub    %ebp,%edi
  803f47:	89 fe                	mov    %edi,%esi
  803f49:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f4d:	89 e9                	mov    %ebp,%ecx
  803f4f:	d3 e0                	shl    %cl,%eax
  803f51:	89 d7                	mov    %edx,%edi
  803f53:	89 f1                	mov    %esi,%ecx
  803f55:	d3 ef                	shr    %cl,%edi
  803f57:	09 c7                	or     %eax,%edi
  803f59:	89 e9                	mov    %ebp,%ecx
  803f5b:	d3 e2                	shl    %cl,%edx
  803f5d:	89 14 24             	mov    %edx,(%esp)
  803f60:	89 d8                	mov    %ebx,%eax
  803f62:	d3 e0                	shl    %cl,%eax
  803f64:	89 c2                	mov    %eax,%edx
  803f66:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f6a:	d3 e0                	shl    %cl,%eax
  803f6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f70:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f74:	89 f1                	mov    %esi,%ecx
  803f76:	d3 e8                	shr    %cl,%eax
  803f78:	09 d0                	or     %edx,%eax
  803f7a:	d3 eb                	shr    %cl,%ebx
  803f7c:	89 da                	mov    %ebx,%edx
  803f7e:	f7 f7                	div    %edi
  803f80:	89 d3                	mov    %edx,%ebx
  803f82:	f7 24 24             	mull   (%esp)
  803f85:	89 c6                	mov    %eax,%esi
  803f87:	89 d1                	mov    %edx,%ecx
  803f89:	39 d3                	cmp    %edx,%ebx
  803f8b:	0f 82 87 00 00 00    	jb     804018 <__umoddi3+0x134>
  803f91:	0f 84 91 00 00 00    	je     804028 <__umoddi3+0x144>
  803f97:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f9b:	29 f2                	sub    %esi,%edx
  803f9d:	19 cb                	sbb    %ecx,%ebx
  803f9f:	89 d8                	mov    %ebx,%eax
  803fa1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803fa5:	d3 e0                	shl    %cl,%eax
  803fa7:	89 e9                	mov    %ebp,%ecx
  803fa9:	d3 ea                	shr    %cl,%edx
  803fab:	09 d0                	or     %edx,%eax
  803fad:	89 e9                	mov    %ebp,%ecx
  803faf:	d3 eb                	shr    %cl,%ebx
  803fb1:	89 da                	mov    %ebx,%edx
  803fb3:	83 c4 1c             	add    $0x1c,%esp
  803fb6:	5b                   	pop    %ebx
  803fb7:	5e                   	pop    %esi
  803fb8:	5f                   	pop    %edi
  803fb9:	5d                   	pop    %ebp
  803fba:	c3                   	ret    
  803fbb:	90                   	nop
  803fbc:	89 fd                	mov    %edi,%ebp
  803fbe:	85 ff                	test   %edi,%edi
  803fc0:	75 0b                	jne    803fcd <__umoddi3+0xe9>
  803fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  803fc7:	31 d2                	xor    %edx,%edx
  803fc9:	f7 f7                	div    %edi
  803fcb:	89 c5                	mov    %eax,%ebp
  803fcd:	89 f0                	mov    %esi,%eax
  803fcf:	31 d2                	xor    %edx,%edx
  803fd1:	f7 f5                	div    %ebp
  803fd3:	89 c8                	mov    %ecx,%eax
  803fd5:	f7 f5                	div    %ebp
  803fd7:	89 d0                	mov    %edx,%eax
  803fd9:	e9 44 ff ff ff       	jmp    803f22 <__umoddi3+0x3e>
  803fde:	66 90                	xchg   %ax,%ax
  803fe0:	89 c8                	mov    %ecx,%eax
  803fe2:	89 f2                	mov    %esi,%edx
  803fe4:	83 c4 1c             	add    $0x1c,%esp
  803fe7:	5b                   	pop    %ebx
  803fe8:	5e                   	pop    %esi
  803fe9:	5f                   	pop    %edi
  803fea:	5d                   	pop    %ebp
  803feb:	c3                   	ret    
  803fec:	3b 04 24             	cmp    (%esp),%eax
  803fef:	72 06                	jb     803ff7 <__umoddi3+0x113>
  803ff1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ff5:	77 0f                	ja     804006 <__umoddi3+0x122>
  803ff7:	89 f2                	mov    %esi,%edx
  803ff9:	29 f9                	sub    %edi,%ecx
  803ffb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803fff:	89 14 24             	mov    %edx,(%esp)
  804002:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804006:	8b 44 24 04          	mov    0x4(%esp),%eax
  80400a:	8b 14 24             	mov    (%esp),%edx
  80400d:	83 c4 1c             	add    $0x1c,%esp
  804010:	5b                   	pop    %ebx
  804011:	5e                   	pop    %esi
  804012:	5f                   	pop    %edi
  804013:	5d                   	pop    %ebp
  804014:	c3                   	ret    
  804015:	8d 76 00             	lea    0x0(%esi),%esi
  804018:	2b 04 24             	sub    (%esp),%eax
  80401b:	19 fa                	sbb    %edi,%edx
  80401d:	89 d1                	mov    %edx,%ecx
  80401f:	89 c6                	mov    %eax,%esi
  804021:	e9 71 ff ff ff       	jmp    803f97 <__umoddi3+0xb3>
  804026:	66 90                	xchg   %ax,%ax
  804028:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80402c:	72 ea                	jb     804018 <__umoddi3+0x134>
  80402e:	89 d9                	mov    %ebx,%ecx
  804030:	e9 62 ff ff ff       	jmp    803f97 <__umoddi3+0xb3>
