
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
  800056:	e8 a6 26 00 00       	call   802701 <sys_set_uheap_strategy>
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
  8000ac:	68 20 40 80 00       	push   $0x804020
  8000b1:	6a 18                	push   $0x18
  8000b3:	68 3c 40 80 00       	push   $0x80403c
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
  8000e9:	68 4f 40 80 00       	push   $0x80404f
  8000ee:	68 66 40 80 00       	push   $0x804066
  8000f3:	6a 20                	push   $0x20
  8000f5:	68 3c 40 80 00       	push   $0x80403c
  8000fa:	e8 29 0c 00 00       	call   800d28 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 03                	push   $0x3
  800104:	e8 f8 25 00 00       	call   802701 <sys_set_uheap_strategy>
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
  80015a:	68 20 40 80 00       	push   $0x804020
  80015f:	6a 32                	push   $0x32
  800161:	68 3c 40 80 00       	push   $0x80403c
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
  8001c9:	68 7c 40 80 00       	push   $0x80407c
  8001ce:	6a 43                	push   $0x43
  8001d0:	68 3c 40 80 00       	push   $0x80403c
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
  8001f1:	68 cc 40 80 00       	push   $0x8040cc
  8001f6:	e8 e1 0d 00 00       	call   800fdc <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 e9 1f 00 00       	call   8021ec <sys_calculate_free_frames>
  800203:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 81 20 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  8002ab:	68 1c 41 80 00       	push   $0x80411c
  8002b0:	6a 5c                	push   $0x5c
  8002b2:	68 3c 40 80 00       	push   $0x80403c
  8002b7:	e8 6c 0a 00 00       	call   800d28 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002bc:	e8 cb 1f 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  8002df:	68 5a 41 80 00       	push   $0x80415a
  8002e4:	6a 5e                	push   $0x5e
  8002e6:	68 3c 40 80 00       	push   $0x80403c
  8002eb:	e8 38 0a 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  8002f3:	e8 f4 1e 00 00       	call   8021ec <sys_calculate_free_frames>
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
  800315:	68 77 41 80 00       	push   $0x804177
  80031a:	6a 5f                	push   $0x5f
  80031c:	68 3c 40 80 00       	push   $0x80403c
  800321:	e8 02 0a 00 00       	call   800d28 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  800326:	e8 c1 1e 00 00       	call   8021ec <sys_calculate_free_frames>
  80032b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80032e:	e8 59 1f 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  8003ea:	e8 9d 1e 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  800416:	68 88 41 80 00       	push   $0x804188
  80041b:	6a 70                	push   $0x70
  80041d:	68 3c 40 80 00       	push   $0x80403c
  800422:	e8 01 09 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800427:	e8 c0 1d 00 00       	call   8021ec <sys_calculate_free_frames>
  80042c:	89 c2                	mov    %eax,%edx
  80042e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800431:	39 c2                	cmp    %eax,%edx
  800433:	74 14                	je     800449 <_main+0x411>
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 c4 41 80 00       	push   $0x8041c4
  80043d:	6a 71                	push   $0x71
  80043f:	68 3c 40 80 00       	push   $0x80403c
  800444:	e8 df 08 00 00       	call   800d28 <_panic>

	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  800449:	e8 9e 1d 00 00       	call   8021ec <sys_calculate_free_frames>
  80044e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800451:	e8 36 1e 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  80047b:	68 04 42 80 00       	push   $0x804204
  800480:	6a 79                	push   $0x79
  800482:	68 3c 40 80 00       	push   $0x80403c
  800487:	e8 9c 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80048c:	e8 fb 1d 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  8004ac:	68 5a 41 80 00       	push   $0x80415a
  8004b1:	6a 7a                	push   $0x7a
  8004b3:	68 3c 40 80 00       	push   $0x80403c
  8004b8:	e8 6b 08 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004bd:	e8 2a 1d 00 00       	call   8021ec <sys_calculate_free_frames>
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 77 41 80 00       	push   $0x804177
  8004d3:	6a 7b                	push   $0x7b
  8004d5:	68 3c 40 80 00       	push   $0x80403c
  8004da:	e8 49 08 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8004df:	e8 08 1d 00 00       	call   8021ec <sys_calculate_free_frames>
  8004e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e7:	e8 a0 1d 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  80050e:	68 04 42 80 00       	push   $0x804204
  800513:	68 81 00 00 00       	push   $0x81
  800518:	68 3c 40 80 00       	push   $0x80403c
  80051d:	e8 06 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800522:	e8 65 1d 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  800545:	68 5a 41 80 00       	push   $0x80415a
  80054a:	68 82 00 00 00       	push   $0x82
  80054f:	68 3c 40 80 00       	push   $0x80403c
  800554:	e8 cf 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800559:	e8 8e 1c 00 00       	call   8021ec <sys_calculate_free_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 17                	je     80057e <_main+0x546>
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 77 41 80 00       	push   $0x804177
  80056f:	68 83 00 00 00       	push   $0x83
  800574:	68 3c 40 80 00       	push   $0x80403c
  800579:	e8 aa 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80057e:	e8 69 1c 00 00       	call   8021ec <sys_calculate_free_frames>
  800583:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800586:	e8 01 1d 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  8005b4:	68 04 42 80 00       	push   $0x804204
  8005b9:	68 89 00 00 00       	push   $0x89
  8005be:	68 3c 40 80 00       	push   $0x80403c
  8005c3:	e8 60 07 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005c8:	e8 bf 1c 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  8005ef:	68 5a 41 80 00       	push   $0x80415a
  8005f4:	68 8a 00 00 00       	push   $0x8a
  8005f9:	68 3c 40 80 00       	push   $0x80403c
  8005fe:	e8 25 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800603:	e8 e4 1b 00 00       	call   8021ec <sys_calculate_free_frames>
  800608:	89 c2                	mov    %eax,%edx
  80060a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	74 17                	je     800628 <_main+0x5f0>
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	68 77 41 80 00       	push   $0x804177
  800619:	68 8b 00 00 00       	push   $0x8b
  80061e:	68 3c 40 80 00       	push   $0x80403c
  800623:	e8 00 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800628:	e8 bf 1b 00 00       	call   8021ec <sys_calculate_free_frames>
  80062d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800630:	e8 57 1c 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  800657:	68 04 42 80 00       	push   $0x804204
  80065c:	68 91 00 00 00       	push   $0x91
  800661:	68 3c 40 80 00       	push   $0x80403c
  800666:	e8 bd 06 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80066b:	e8 1c 1c 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  80068b:	68 5a 41 80 00       	push   $0x80415a
  800690:	68 92 00 00 00       	push   $0x92
  800695:	68 3c 40 80 00       	push   $0x80403c
  80069a:	e8 89 06 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069f:	e8 48 1b 00 00       	call   8021ec <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 77 41 80 00       	push   $0x804177
  8006b5:	68 93 00 00 00       	push   $0x93
  8006ba:	68 3c 40 80 00       	push   $0x80403c
  8006bf:	e8 64 06 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 23 1b 00 00       	call   8021ec <sys_calculate_free_frames>
  8006c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 bb 1b 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  8006d4:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	50                   	push   %eax
  8006de:	e8 af 18 00 00       	call   801f92 <free>
  8006e3:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e6:	e8 a1 1b 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  800708:	68 88 41 80 00       	push   $0x804188
  80070d:	68 99 00 00 00       	push   $0x99
  800712:	68 3c 40 80 00       	push   $0x80403c
  800717:	e8 0c 06 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80071c:	e8 cb 1a 00 00       	call   8021ec <sys_calculate_free_frames>
  800721:	89 c2                	mov    %eax,%edx
  800723:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800726:	39 c2                	cmp    %eax,%edx
  800728:	74 17                	je     800741 <_main+0x709>
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	68 c4 41 80 00       	push   $0x8041c4
  800732:	68 9a 00 00 00       	push   $0x9a
  800737:	68 3c 40 80 00       	push   $0x80403c
  80073c:	e8 e7 05 00 00       	call   800d28 <_panic>

	//[NEXT FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  800741:	e8 a6 1a 00 00       	call   8021ec <sys_calculate_free_frames>
  800746:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800749:	e8 3e 1b 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  800770:	68 04 42 80 00       	push   $0x804204
  800775:	68 a1 00 00 00       	push   $0xa1
  80077a:	68 3c 40 80 00       	push   $0x80403c
  80077f:	e8 a4 05 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800784:	e8 03 1b 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  8007a7:	68 5a 41 80 00       	push   $0x80415a
  8007ac:	68 a2 00 00 00       	push   $0xa2
  8007b1:	68 3c 40 80 00       	push   $0x80403c
  8007b6:	e8 6d 05 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007bb:	e8 2c 1a 00 00       	call   8021ec <sys_calculate_free_frames>
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c5:	39 c2                	cmp    %eax,%edx
  8007c7:	74 17                	je     8007e0 <_main+0x7a8>
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	68 77 41 80 00       	push   $0x804177
  8007d1:	68 a3 00 00 00       	push   $0xa3
  8007d6:	68 3c 40 80 00       	push   $0x80403c
  8007db:	e8 48 05 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8007e0:	e8 07 1a 00 00       	call   8021ec <sys_calculate_free_frames>
  8007e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e8:	e8 9f 1a 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  80081e:	68 04 42 80 00       	push   $0x804204
  800823:	68 a9 00 00 00       	push   $0xa9
  800828:	68 3c 40 80 00       	push   $0x80403c
  80082d:	e8 f6 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800832:	e8 55 1a 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  800861:	68 5a 41 80 00       	push   $0x80415a
  800866:	68 aa 00 00 00       	push   $0xaa
  80086b:	68 3c 40 80 00       	push   $0x80403c
  800870:	e8 b3 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800875:	e8 72 19 00 00       	call   8021ec <sys_calculate_free_frames>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	74 17                	je     80089a <_main+0x862>
  800883:	83 ec 04             	sub    $0x4,%esp
  800886:	68 77 41 80 00       	push   $0x804177
  80088b:	68 ab 00 00 00       	push   $0xab
  800890:	68 3c 40 80 00       	push   $0x80403c
  800895:	e8 8e 04 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80089a:	e8 4d 19 00 00       	call   8021ec <sys_calculate_free_frames>
  80089f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a2:	e8 e5 19 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  8008cc:	68 04 42 80 00       	push   $0x804204
  8008d1:	68 b1 00 00 00       	push   $0xb1
  8008d6:	68 3c 40 80 00       	push   $0x80403c
  8008db:	e8 48 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8008e0:	e8 a7 19 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  800903:	68 5a 41 80 00       	push   $0x80415a
  800908:	68 b2 00 00 00       	push   $0xb2
  80090d:	68 3c 40 80 00       	push   $0x80403c
  800912:	e8 11 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800917:	e8 d0 18 00 00       	call   8021ec <sys_calculate_free_frames>
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	74 17                	je     80093c <_main+0x904>
  800925:	83 ec 04             	sub    $0x4,%esp
  800928:	68 77 41 80 00       	push   $0x804177
  80092d:	68 b3 00 00 00       	push   $0xb3
  800932:	68 3c 40 80 00       	push   $0x80403c
  800937:	e8 ec 03 00 00       	call   800d28 <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	68 24 42 80 00       	push   $0x804224
  800944:	e8 93 06 00 00       	call   800fdc <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  80094c:	e8 9b 18 00 00       	call   8021ec <sys_calculate_free_frames>
  800951:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800954:	e8 33 19 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  800989:	68 04 42 80 00       	push   $0x804204
  80098e:	68 bc 00 00 00       	push   $0xbc
  800993:	68 3c 40 80 00       	push   $0x80403c
  800998:	e8 8b 03 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80099d:	e8 ea 18 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  8009cb:	68 5a 41 80 00       	push   $0x80415a
  8009d0:	68 bd 00 00 00       	push   $0xbd
  8009d5:	68 3c 40 80 00       	push   $0x80403c
  8009da:	e8 49 03 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009df:	e8 08 18 00 00       	call   8021ec <sys_calculate_free_frames>
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 17                	je     800a04 <_main+0x9cc>
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 77 41 80 00       	push   $0x804177
  8009f5:	68 be 00 00 00       	push   $0xbe
  8009fa:	68 3c 40 80 00       	push   $0x80403c
  8009ff:	e8 24 03 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a04:	e8 e3 17 00 00       	call   8021ec <sys_calculate_free_frames>
  800a09:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a0c:	e8 7b 18 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
  800a11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  800a14:	8b 85 20 f8 ff ff    	mov    -0x7e0(%ebp),%eax
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	50                   	push   %eax
  800a1e:	e8 6f 15 00 00       	call   801f92 <free>
  800a23:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800a26:	e8 61 18 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  800a48:	68 88 41 80 00       	push   $0x804188
  800a4d:	68 c4 00 00 00       	push   $0xc4
  800a52:	68 3c 40 80 00       	push   $0x80403c
  800a57:	e8 cc 02 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800a5c:	e8 8b 17 00 00       	call   8021ec <sys_calculate_free_frames>
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a66:	39 c2                	cmp    %eax,%edx
  800a68:	74 17                	je     800a81 <_main+0xa49>
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	68 c4 41 80 00       	push   $0x8041c4
  800a72:	68 c5 00 00 00       	push   $0xc5
  800a77:	68 3c 40 80 00       	push   $0x80403c
  800a7c:	e8 a7 02 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a81:	e8 66 17 00 00       	call   8021ec <sys_calculate_free_frames>
  800a86:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a89:	e8 fe 17 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  800ab6:	68 04 42 80 00       	push   $0x804204
  800abb:	68 cc 00 00 00       	push   $0xcc
  800ac0:	68 3c 40 80 00       	push   $0x80403c
  800ac5:	e8 5e 02 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800aca:	e8 bd 17 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  800aed:	68 5a 41 80 00       	push   $0x80415a
  800af2:	68 cd 00 00 00       	push   $0xcd
  800af7:	68 3c 40 80 00       	push   $0x80403c
  800afc:	e8 27 02 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b01:	e8 e6 16 00 00       	call   8021ec <sys_calculate_free_frames>
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	74 17                	je     800b26 <_main+0xaee>
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	68 77 41 80 00       	push   $0x804177
  800b17:	68 ce 00 00 00       	push   $0xce
  800b1c:	68 3c 40 80 00       	push   $0x80403c
  800b21:	e8 02 02 00 00       	call   800d28 <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	68 60 42 80 00       	push   $0x804260
  800b2e:	e8 a9 04 00 00       	call   800fdc <cprintf>
  800b33:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800b36:	e8 b1 16 00 00       	call   8021ec <sys_calculate_free_frames>
  800b3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b3e:	e8 49 17 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
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
  800b6a:	68 04 42 80 00       	push   $0x804204
  800b6f:	68 d7 00 00 00       	push   $0xd7
  800b74:	68 3c 40 80 00       	push   $0x80403c
  800b79:	e8 aa 01 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b7e:	e8 09 17 00 00       	call   80228c <sys_pf_calculate_allocated_pages>
  800b83:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b86:	74 17                	je     800b9f <_main+0xb67>
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	68 5a 41 80 00       	push   $0x80415a
  800b90:	68 d8 00 00 00       	push   $0xd8
  800b95:	68 3c 40 80 00       	push   $0x80403c
  800b9a:	e8 89 01 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b9f:	e8 48 16 00 00       	call   8021ec <sys_calculate_free_frames>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	74 17                	je     800bc4 <_main+0xb8c>
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	68 77 41 80 00       	push   $0x804177
  800bb5:	68 d9 00 00 00       	push   $0xd9
  800bba:	68 3c 40 80 00       	push   $0x80403c
  800bbf:	e8 64 01 00 00       	call   800d28 <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	68 98 42 80 00       	push   $0x804298
  800bcc:	e8 0b 04 00 00       	call   800fdc <cprintf>
  800bd1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	68 d4 42 80 00       	push   $0x8042d4
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
  800bf2:	e8 d5 18 00 00       	call   8024cc <sys_getenvindex>
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
  800c5d:	e8 77 16 00 00       	call   8022d9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	68 28 43 80 00       	push   $0x804328
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
  800c8d:	68 50 43 80 00       	push   $0x804350
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
  800cbe:	68 78 43 80 00       	push   $0x804378
  800cc3:	e8 14 03 00 00       	call   800fdc <cprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ccb:	a1 20 50 80 00       	mov    0x805020,%eax
  800cd0:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	50                   	push   %eax
  800cda:	68 d0 43 80 00       	push   $0x8043d0
  800cdf:	e8 f8 02 00 00       	call   800fdc <cprintf>
  800ce4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	68 28 43 80 00       	push   $0x804328
  800cef:	e8 e8 02 00 00       	call   800fdc <cprintf>
  800cf4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800cf7:	e8 f7 15 00 00       	call   8022f3 <sys_enable_interrupt>

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
  800d0f:	e8 84 17 00 00       	call   802498 <sys_destroy_env>
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
  800d20:	e8 d9 17 00 00       	call   8024fe <sys_exit_env>
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
  800d49:	68 e4 43 80 00       	push   $0x8043e4
  800d4e:	e8 89 02 00 00       	call   800fdc <cprintf>
  800d53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d56:	a1 00 50 80 00       	mov    0x805000,%eax
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	50                   	push   %eax
  800d62:	68 e9 43 80 00       	push   $0x8043e9
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
  800d86:	68 05 44 80 00       	push   $0x804405
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
  800db2:	68 08 44 80 00       	push   $0x804408
  800db7:	6a 26                	push   $0x26
  800db9:	68 54 44 80 00       	push   $0x804454
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
  800e84:	68 60 44 80 00       	push   $0x804460
  800e89:	6a 3a                	push   $0x3a
  800e8b:	68 54 44 80 00       	push   $0x804454
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
  800ef4:	68 b4 44 80 00       	push   $0x8044b4
  800ef9:	6a 44                	push   $0x44
  800efb:	68 54 44 80 00       	push   $0x804454
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
  800f4e:	e8 d8 11 00 00       	call   80212b <sys_cputs>
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
  800fc5:	e8 61 11 00 00       	call   80212b <sys_cputs>
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
  80100f:	e8 c5 12 00 00       	call   8022d9 <sys_disable_interrupt>
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
  80102f:	e8 bf 12 00 00       	call   8022f3 <sys_enable_interrupt>
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
  801079:	e8 32 2d 00 00       	call   803db0 <__udivdi3>
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
  8010c9:	e8 f2 2d 00 00       	call   803ec0 <__umoddi3>
  8010ce:	83 c4 10             	add    $0x10,%esp
  8010d1:	05 14 47 80 00       	add    $0x804714,%eax
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
  801224:	8b 04 85 38 47 80 00 	mov    0x804738(,%eax,4),%eax
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
  801305:	8b 34 9d 80 45 80 00 	mov    0x804580(,%ebx,4),%esi
  80130c:	85 f6                	test   %esi,%esi
  80130e:	75 19                	jne    801329 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801310:	53                   	push   %ebx
  801311:	68 25 47 80 00       	push   $0x804725
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
  80132a:	68 2e 47 80 00       	push   $0x80472e
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
  801357:	be 31 47 80 00       	mov    $0x804731,%esi
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
  801d7d:	68 90 48 80 00       	push   $0x804890
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
  801e4d:	e8 1d 04 00 00       	call   80226f <sys_allocate_chunk>
  801e52:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801e55:	a1 20 51 80 00       	mov    0x805120,%eax
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	50                   	push   %eax
  801e5e:	e8 92 0a 00 00       	call   8028f5 <initialize_MemBlocksList>
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
  801e8b:	68 b5 48 80 00       	push   $0x8048b5
  801e90:	6a 33                	push   $0x33
  801e92:	68 d3 48 80 00       	push   $0x8048d3
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
  801f0a:	68 e0 48 80 00       	push   $0x8048e0
  801f0f:	6a 34                	push   $0x34
  801f11:	68 d3 48 80 00       	push   $0x8048d3
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
  801f7f:	68 04 49 80 00       	push   $0x804904
  801f84:	6a 46                	push   $0x46
  801f86:	68 d3 48 80 00       	push   $0x8048d3
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
  801f9b:	68 2c 49 80 00       	push   $0x80492c
  801fa0:	6a 61                	push   $0x61
  801fa2:	68 d3 48 80 00       	push   $0x8048d3
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
  801fc1:	75 07                	jne    801fca <smalloc+0x1e>
  801fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc8:	eb 7c                	jmp    802046 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801fca:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd7:	01 d0                	add    %edx,%eax
  801fd9:	48                   	dec    %eax
  801fda:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe0:	ba 00 00 00 00       	mov    $0x0,%edx
  801fe5:	f7 75 f0             	divl   -0x10(%ebp)
  801fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801feb:	29 d0                	sub    %edx,%eax
  801fed:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801ff0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801ff7:	e8 41 06 00 00       	call   80263d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	74 11                	je     802011 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  802000:	83 ec 0c             	sub    $0xc,%esp
  802003:	ff 75 e8             	pushl  -0x18(%ebp)
  802006:	e8 ac 0c 00 00       	call   802cb7 <alloc_block_FF>
  80200b:	83 c4 10             	add    $0x10,%esp
  80200e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  802011:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802015:	74 2a                	je     802041 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  802017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201a:	8b 40 08             	mov    0x8(%eax),%eax
  80201d:	89 c2                	mov    %eax,%edx
  80201f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802023:	52                   	push   %edx
  802024:	50                   	push   %eax
  802025:	ff 75 0c             	pushl  0xc(%ebp)
  802028:	ff 75 08             	pushl  0x8(%ebp)
  80202b:	e8 92 03 00 00       	call   8023c2 <sys_createSharedObject>
  802030:	83 c4 10             	add    $0x10,%esp
  802033:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  802036:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80203a:	74 05                	je     802041 <smalloc+0x95>
			return (void*)virtual_address;
  80203c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80203f:	eb 05                	jmp    802046 <smalloc+0x9a>
	}
	return NULL;
  802041:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80204e:	e8 13 fd ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  802053:	83 ec 04             	sub    $0x4,%esp
  802056:	68 50 49 80 00       	push   $0x804950
  80205b:	68 a2 00 00 00       	push   $0xa2
  802060:	68 d3 48 80 00       	push   $0x8048d3
  802065:	e8 be ec ff ff       	call   800d28 <_panic>

0080206a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802070:	e8 f1 fc ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802075:	83 ec 04             	sub    $0x4,%esp
  802078:	68 74 49 80 00       	push   $0x804974
  80207d:	68 e6 00 00 00       	push   $0xe6
  802082:	68 d3 48 80 00       	push   $0x8048d3
  802087:	e8 9c ec ff ff       	call   800d28 <_panic>

0080208c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
  80208f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802092:	83 ec 04             	sub    $0x4,%esp
  802095:	68 9c 49 80 00       	push   $0x80499c
  80209a:	68 fa 00 00 00       	push   $0xfa
  80209f:	68 d3 48 80 00       	push   $0x8048d3
  8020a4:	e8 7f ec ff ff       	call   800d28 <_panic>

008020a9 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020af:	83 ec 04             	sub    $0x4,%esp
  8020b2:	68 c0 49 80 00       	push   $0x8049c0
  8020b7:	68 05 01 00 00       	push   $0x105
  8020bc:	68 d3 48 80 00       	push   $0x8048d3
  8020c1:	e8 62 ec ff ff       	call   800d28 <_panic>

008020c6 <shrink>:

}
void shrink(uint32 newSize)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020cc:	83 ec 04             	sub    $0x4,%esp
  8020cf:	68 c0 49 80 00       	push   $0x8049c0
  8020d4:	68 0a 01 00 00       	push   $0x10a
  8020d9:	68 d3 48 80 00       	push   $0x8048d3
  8020de:	e8 45 ec ff ff       	call   800d28 <_panic>

008020e3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020e9:	83 ec 04             	sub    $0x4,%esp
  8020ec:	68 c0 49 80 00       	push   $0x8049c0
  8020f1:	68 0f 01 00 00       	push   $0x10f
  8020f6:	68 d3 48 80 00       	push   $0x8048d3
  8020fb:	e8 28 ec ff ff       	call   800d28 <_panic>

00802100 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	57                   	push   %edi
  802104:	56                   	push   %esi
  802105:	53                   	push   %ebx
  802106:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802112:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802115:	8b 7d 18             	mov    0x18(%ebp),%edi
  802118:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80211b:	cd 30                	int    $0x30
  80211d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802120:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802123:	83 c4 10             	add    $0x10,%esp
  802126:	5b                   	pop    %ebx
  802127:	5e                   	pop    %esi
  802128:	5f                   	pop    %edi
  802129:	5d                   	pop    %ebp
  80212a:	c3                   	ret    

0080212b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	83 ec 04             	sub    $0x4,%esp
  802131:	8b 45 10             	mov    0x10(%ebp),%eax
  802134:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802137:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	52                   	push   %edx
  802143:	ff 75 0c             	pushl  0xc(%ebp)
  802146:	50                   	push   %eax
  802147:	6a 00                	push   $0x0
  802149:	e8 b2 ff ff ff       	call   802100 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	90                   	nop
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <sys_cgetc>:

int
sys_cgetc(void)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 01                	push   $0x1
  802163:	e8 98 ff ff ff       	call   802100 <syscall>
  802168:	83 c4 18             	add    $0x18,%esp
}
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802170:	8b 55 0c             	mov    0xc(%ebp),%edx
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	52                   	push   %edx
  80217d:	50                   	push   %eax
  80217e:	6a 05                	push   $0x5
  802180:	e8 7b ff ff ff       	call   802100 <syscall>
  802185:	83 c4 18             	add    $0x18,%esp
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	56                   	push   %esi
  80218e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80218f:	8b 75 18             	mov    0x18(%ebp),%esi
  802192:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802195:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802198:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	56                   	push   %esi
  80219f:	53                   	push   %ebx
  8021a0:	51                   	push   %ecx
  8021a1:	52                   	push   %edx
  8021a2:	50                   	push   %eax
  8021a3:	6a 06                	push   $0x6
  8021a5:	e8 56 ff ff ff       	call   802100 <syscall>
  8021aa:	83 c4 18             	add    $0x18,%esp
}
  8021ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021b0:	5b                   	pop    %ebx
  8021b1:	5e                   	pop    %esi
  8021b2:	5d                   	pop    %ebp
  8021b3:	c3                   	ret    

008021b4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	52                   	push   %edx
  8021c4:	50                   	push   %eax
  8021c5:	6a 07                	push   $0x7
  8021c7:	e8 34 ff ff ff       	call   802100 <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	ff 75 0c             	pushl  0xc(%ebp)
  8021dd:	ff 75 08             	pushl  0x8(%ebp)
  8021e0:	6a 08                	push   $0x8
  8021e2:	e8 19 ff ff ff       	call   802100 <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 09                	push   $0x9
  8021fb:	e8 00 ff ff ff       	call   802100 <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 0a                	push   $0xa
  802214:	e8 e7 fe ff ff       	call   802100 <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 0b                	push   $0xb
  80222d:	e8 ce fe ff ff       	call   802100 <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	ff 75 0c             	pushl  0xc(%ebp)
  802243:	ff 75 08             	pushl  0x8(%ebp)
  802246:	6a 0f                	push   $0xf
  802248:	e8 b3 fe ff ff       	call   802100 <syscall>
  80224d:	83 c4 18             	add    $0x18,%esp
	return;
  802250:	90                   	nop
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	ff 75 0c             	pushl  0xc(%ebp)
  80225f:	ff 75 08             	pushl  0x8(%ebp)
  802262:	6a 10                	push   $0x10
  802264:	e8 97 fe ff ff       	call   802100 <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
	return ;
  80226c:	90                   	nop
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	ff 75 10             	pushl  0x10(%ebp)
  802279:	ff 75 0c             	pushl  0xc(%ebp)
  80227c:	ff 75 08             	pushl  0x8(%ebp)
  80227f:	6a 11                	push   $0x11
  802281:	e8 7a fe ff ff       	call   802100 <syscall>
  802286:	83 c4 18             	add    $0x18,%esp
	return ;
  802289:	90                   	nop
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 0c                	push   $0xc
  80229b:	e8 60 fe ff ff       	call   802100 <syscall>
  8022a0:	83 c4 18             	add    $0x18,%esp
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	ff 75 08             	pushl  0x8(%ebp)
  8022b3:	6a 0d                	push   $0xd
  8022b5:	e8 46 fe ff ff       	call   802100 <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 0e                	push   $0xe
  8022ce:	e8 2d fe ff ff       	call   802100 <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
}
  8022d6:	90                   	nop
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 13                	push   $0x13
  8022e8:	e8 13 fe ff ff       	call   802100 <syscall>
  8022ed:	83 c4 18             	add    $0x18,%esp
}
  8022f0:	90                   	nop
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 14                	push   $0x14
  802302:	e8 f9 fd ff ff       	call   802100 <syscall>
  802307:	83 c4 18             	add    $0x18,%esp
}
  80230a:	90                   	nop
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <sys_cputc>:


void
sys_cputc(const char c)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 04             	sub    $0x4,%esp
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802319:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	50                   	push   %eax
  802326:	6a 15                	push   $0x15
  802328:	e8 d3 fd ff ff       	call   802100 <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
}
  802330:	90                   	nop
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 16                	push   $0x16
  802342:	e8 b9 fd ff ff       	call   802100 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
}
  80234a:	90                   	nop
  80234b:	c9                   	leave  
  80234c:	c3                   	ret    

0080234d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80234d:	55                   	push   %ebp
  80234e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	ff 75 0c             	pushl  0xc(%ebp)
  80235c:	50                   	push   %eax
  80235d:	6a 17                	push   $0x17
  80235f:	e8 9c fd ff ff       	call   802100 <syscall>
  802364:	83 c4 18             	add    $0x18,%esp
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80236c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	52                   	push   %edx
  802379:	50                   	push   %eax
  80237a:	6a 1a                	push   $0x1a
  80237c:	e8 7f fd ff ff       	call   802100 <syscall>
  802381:	83 c4 18             	add    $0x18,%esp
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	52                   	push   %edx
  802396:	50                   	push   %eax
  802397:	6a 18                	push   $0x18
  802399:	e8 62 fd ff ff       	call   802100 <syscall>
  80239e:	83 c4 18             	add    $0x18,%esp
}
  8023a1:	90                   	nop
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	52                   	push   %edx
  8023b4:	50                   	push   %eax
  8023b5:	6a 19                	push   $0x19
  8023b7:	e8 44 fd ff ff       	call   802100 <syscall>
  8023bc:	83 c4 18             	add    $0x18,%esp
}
  8023bf:	90                   	nop
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8023cb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023d1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	6a 00                	push   $0x0
  8023da:	51                   	push   %ecx
  8023db:	52                   	push   %edx
  8023dc:	ff 75 0c             	pushl  0xc(%ebp)
  8023df:	50                   	push   %eax
  8023e0:	6a 1b                	push   $0x1b
  8023e2:	e8 19 fd ff ff       	call   802100 <syscall>
  8023e7:	83 c4 18             	add    $0x18,%esp
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	52                   	push   %edx
  8023fc:	50                   	push   %eax
  8023fd:	6a 1c                	push   $0x1c
  8023ff:	e8 fc fc ff ff       	call   802100 <syscall>
  802404:	83 c4 18             	add    $0x18,%esp
}
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80240c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80240f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	51                   	push   %ecx
  80241a:	52                   	push   %edx
  80241b:	50                   	push   %eax
  80241c:	6a 1d                	push   $0x1d
  80241e:	e8 dd fc ff ff       	call   802100 <syscall>
  802423:	83 c4 18             	add    $0x18,%esp
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80242b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	52                   	push   %edx
  802438:	50                   	push   %eax
  802439:	6a 1e                	push   $0x1e
  80243b:	e8 c0 fc ff ff       	call   802100 <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
}
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 1f                	push   $0x1f
  802454:	e8 a7 fc ff ff       	call   802100 <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	6a 00                	push   $0x0
  802466:	ff 75 14             	pushl  0x14(%ebp)
  802469:	ff 75 10             	pushl  0x10(%ebp)
  80246c:	ff 75 0c             	pushl  0xc(%ebp)
  80246f:	50                   	push   %eax
  802470:	6a 20                	push   $0x20
  802472:	e8 89 fc ff ff       	call   802100 <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	50                   	push   %eax
  80248b:	6a 21                	push   $0x21
  80248d:	e8 6e fc ff ff       	call   802100 <syscall>
  802492:	83 c4 18             	add    $0x18,%esp
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	50                   	push   %eax
  8024a7:	6a 22                	push   $0x22
  8024a9:	e8 52 fc ff ff       	call   802100 <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 02                	push   $0x2
  8024c2:	e8 39 fc ff ff       	call   802100 <syscall>
  8024c7:	83 c4 18             	add    $0x18,%esp
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 03                	push   $0x3
  8024db:	e8 20 fc ff ff       	call   802100 <syscall>
  8024e0:	83 c4 18             	add    $0x18,%esp
}
  8024e3:	c9                   	leave  
  8024e4:	c3                   	ret    

008024e5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024e5:	55                   	push   %ebp
  8024e6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024e8:	6a 00                	push   $0x0
  8024ea:	6a 00                	push   $0x0
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 04                	push   $0x4
  8024f4:	e8 07 fc ff ff       	call   802100 <syscall>
  8024f9:	83 c4 18             	add    $0x18,%esp
}
  8024fc:	c9                   	leave  
  8024fd:	c3                   	ret    

008024fe <sys_exit_env>:


void sys_exit_env(void)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	6a 23                	push   $0x23
  80250d:	e8 ee fb ff ff       	call   802100 <syscall>
  802512:	83 c4 18             	add    $0x18,%esp
}
  802515:	90                   	nop
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80251e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802521:	8d 50 04             	lea    0x4(%eax),%edx
  802524:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	52                   	push   %edx
  80252e:	50                   	push   %eax
  80252f:	6a 24                	push   $0x24
  802531:	e8 ca fb ff ff       	call   802100 <syscall>
  802536:	83 c4 18             	add    $0x18,%esp
	return result;
  802539:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80253c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80253f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802542:	89 01                	mov    %eax,(%ecx)
  802544:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802547:	8b 45 08             	mov    0x8(%ebp),%eax
  80254a:	c9                   	leave  
  80254b:	c2 04 00             	ret    $0x4

0080254e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802551:	6a 00                	push   $0x0
  802553:	6a 00                	push   $0x0
  802555:	ff 75 10             	pushl  0x10(%ebp)
  802558:	ff 75 0c             	pushl  0xc(%ebp)
  80255b:	ff 75 08             	pushl  0x8(%ebp)
  80255e:	6a 12                	push   $0x12
  802560:	e8 9b fb ff ff       	call   802100 <syscall>
  802565:	83 c4 18             	add    $0x18,%esp
	return ;
  802568:	90                   	nop
}
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <sys_rcr2>:
uint32 sys_rcr2()
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 25                	push   $0x25
  80257a:	e8 81 fb ff ff       	call   802100 <syscall>
  80257f:	83 c4 18             	add    $0x18,%esp
}
  802582:	c9                   	leave  
  802583:	c3                   	ret    

00802584 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	83 ec 04             	sub    $0x4,%esp
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802590:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	50                   	push   %eax
  80259d:	6a 26                	push   $0x26
  80259f:	e8 5c fb ff ff       	call   802100 <syscall>
  8025a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a7:	90                   	nop
}
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    

008025aa <rsttst>:
void rsttst()
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 00                	push   $0x0
  8025b1:	6a 00                	push   $0x0
  8025b3:	6a 00                	push   $0x0
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 28                	push   $0x28
  8025b9:	e8 42 fb ff ff       	call   802100 <syscall>
  8025be:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c1:	90                   	nop
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 04             	sub    $0x4,%esp
  8025ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8025cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025d0:	8b 55 18             	mov    0x18(%ebp),%edx
  8025d3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025d7:	52                   	push   %edx
  8025d8:	50                   	push   %eax
  8025d9:	ff 75 10             	pushl  0x10(%ebp)
  8025dc:	ff 75 0c             	pushl  0xc(%ebp)
  8025df:	ff 75 08             	pushl  0x8(%ebp)
  8025e2:	6a 27                	push   $0x27
  8025e4:	e8 17 fb ff ff       	call   802100 <syscall>
  8025e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ec:	90                   	nop
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <chktst>:
void chktst(uint32 n)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 00                	push   $0x0
  8025f8:	6a 00                	push   $0x0
  8025fa:	ff 75 08             	pushl  0x8(%ebp)
  8025fd:	6a 29                	push   $0x29
  8025ff:	e8 fc fa ff ff       	call   802100 <syscall>
  802604:	83 c4 18             	add    $0x18,%esp
	return ;
  802607:	90                   	nop
}
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <inctst>:

void inctst()
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	6a 2a                	push   $0x2a
  802619:	e8 e2 fa ff ff       	call   802100 <syscall>
  80261e:	83 c4 18             	add    $0x18,%esp
	return ;
  802621:	90                   	nop
}
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <gettst>:
uint32 gettst()
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 2b                	push   $0x2b
  802633:	e8 c8 fa ff ff       	call   802100 <syscall>
  802638:	83 c4 18             	add    $0x18,%esp
}
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	6a 2c                	push   $0x2c
  80264f:	e8 ac fa ff ff       	call   802100 <syscall>
  802654:	83 c4 18             	add    $0x18,%esp
  802657:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80265a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80265e:	75 07                	jne    802667 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802660:	b8 01 00 00 00       	mov    $0x1,%eax
  802665:	eb 05                	jmp    80266c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266c:	c9                   	leave  
  80266d:	c3                   	ret    

0080266e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 2c                	push   $0x2c
  802680:	e8 7b fa ff ff       	call   802100 <syscall>
  802685:	83 c4 18             	add    $0x18,%esp
  802688:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80268b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80268f:	75 07                	jne    802698 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802691:	b8 01 00 00 00       	mov    $0x1,%eax
  802696:	eb 05                	jmp    80269d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802698:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80269d:	c9                   	leave  
  80269e:	c3                   	ret    

0080269f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
  8026a2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 00                	push   $0x0
  8026af:	6a 2c                	push   $0x2c
  8026b1:	e8 4a fa ff ff       	call   802100 <syscall>
  8026b6:	83 c4 18             	add    $0x18,%esp
  8026b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026bc:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026c0:	75 07                	jne    8026c9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c7:	eb 05                	jmp    8026ce <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ce:	c9                   	leave  
  8026cf:	c3                   	ret    

008026d0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
  8026d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 00                	push   $0x0
  8026e0:	6a 2c                	push   $0x2c
  8026e2:	e8 19 fa ff ff       	call   802100 <syscall>
  8026e7:	83 c4 18             	add    $0x18,%esp
  8026ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026ed:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026f1:	75 07                	jne    8026fa <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f8:	eb 05                	jmp    8026ff <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ff:	c9                   	leave  
  802700:	c3                   	ret    

00802701 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802701:	55                   	push   %ebp
  802702:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802704:	6a 00                	push   $0x0
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	ff 75 08             	pushl  0x8(%ebp)
  80270f:	6a 2d                	push   $0x2d
  802711:	e8 ea f9 ff ff       	call   802100 <syscall>
  802716:	83 c4 18             	add    $0x18,%esp
	return ;
  802719:	90                   	nop
}
  80271a:	c9                   	leave  
  80271b:	c3                   	ret    

0080271c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
  80271f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802720:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802723:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802726:	8b 55 0c             	mov    0xc(%ebp),%edx
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	6a 00                	push   $0x0
  80272e:	53                   	push   %ebx
  80272f:	51                   	push   %ecx
  802730:	52                   	push   %edx
  802731:	50                   	push   %eax
  802732:	6a 2e                	push   $0x2e
  802734:	e8 c7 f9 ff ff       	call   802100 <syscall>
  802739:	83 c4 18             	add    $0x18,%esp
}
  80273c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802744:	8b 55 0c             	mov    0xc(%ebp),%edx
  802747:	8b 45 08             	mov    0x8(%ebp),%eax
  80274a:	6a 00                	push   $0x0
  80274c:	6a 00                	push   $0x0
  80274e:	6a 00                	push   $0x0
  802750:	52                   	push   %edx
  802751:	50                   	push   %eax
  802752:	6a 2f                	push   $0x2f
  802754:	e8 a7 f9 ff ff       	call   802100 <syscall>
  802759:	83 c4 18             	add    $0x18,%esp
}
  80275c:	c9                   	leave  
  80275d:	c3                   	ret    

0080275e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80275e:	55                   	push   %ebp
  80275f:	89 e5                	mov    %esp,%ebp
  802761:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802764:	83 ec 0c             	sub    $0xc,%esp
  802767:	68 d0 49 80 00       	push   $0x8049d0
  80276c:	e8 6b e8 ff ff       	call   800fdc <cprintf>
  802771:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802774:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80277b:	83 ec 0c             	sub    $0xc,%esp
  80277e:	68 fc 49 80 00       	push   $0x8049fc
  802783:	e8 54 e8 ff ff       	call   800fdc <cprintf>
  802788:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80278b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80278f:	a1 38 51 80 00       	mov    0x805138,%eax
  802794:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802797:	eb 56                	jmp    8027ef <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802799:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80279d:	74 1c                	je     8027bb <print_mem_block_lists+0x5d>
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	8b 50 08             	mov    0x8(%eax),%edx
  8027a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a8:	8b 48 08             	mov    0x8(%eax),%ecx
  8027ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b1:	01 c8                	add    %ecx,%eax
  8027b3:	39 c2                	cmp    %eax,%edx
  8027b5:	73 04                	jae    8027bb <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8027b7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 50 08             	mov    0x8(%eax),%edx
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c7:	01 c2                	add    %eax,%edx
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 40 08             	mov    0x8(%eax),%eax
  8027cf:	83 ec 04             	sub    $0x4,%esp
  8027d2:	52                   	push   %edx
  8027d3:	50                   	push   %eax
  8027d4:	68 11 4a 80 00       	push   $0x804a11
  8027d9:	e8 fe e7 ff ff       	call   800fdc <cprintf>
  8027de:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027e7:	a1 40 51 80 00       	mov    0x805140,%eax
  8027ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f3:	74 07                	je     8027fc <print_mem_block_lists+0x9e>
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	eb 05                	jmp    802801 <print_mem_block_lists+0xa3>
  8027fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802801:	a3 40 51 80 00       	mov    %eax,0x805140
  802806:	a1 40 51 80 00       	mov    0x805140,%eax
  80280b:	85 c0                	test   %eax,%eax
  80280d:	75 8a                	jne    802799 <print_mem_block_lists+0x3b>
  80280f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802813:	75 84                	jne    802799 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802815:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802819:	75 10                	jne    80282b <print_mem_block_lists+0xcd>
  80281b:	83 ec 0c             	sub    $0xc,%esp
  80281e:	68 20 4a 80 00       	push   $0x804a20
  802823:	e8 b4 e7 ff ff       	call   800fdc <cprintf>
  802828:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80282b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802832:	83 ec 0c             	sub    $0xc,%esp
  802835:	68 44 4a 80 00       	push   $0x804a44
  80283a:	e8 9d e7 ff ff       	call   800fdc <cprintf>
  80283f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802842:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802846:	a1 40 50 80 00       	mov    0x805040,%eax
  80284b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80284e:	eb 56                	jmp    8028a6 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802850:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802854:	74 1c                	je     802872 <print_mem_block_lists+0x114>
  802856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802859:	8b 50 08             	mov    0x8(%eax),%edx
  80285c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285f:	8b 48 08             	mov    0x8(%eax),%ecx
  802862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802865:	8b 40 0c             	mov    0xc(%eax),%eax
  802868:	01 c8                	add    %ecx,%eax
  80286a:	39 c2                	cmp    %eax,%edx
  80286c:	73 04                	jae    802872 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80286e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 50 08             	mov    0x8(%eax),%edx
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 40 0c             	mov    0xc(%eax),%eax
  80287e:	01 c2                	add    %eax,%edx
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 40 08             	mov    0x8(%eax),%eax
  802886:	83 ec 04             	sub    $0x4,%esp
  802889:	52                   	push   %edx
  80288a:	50                   	push   %eax
  80288b:	68 11 4a 80 00       	push   $0x804a11
  802890:	e8 47 e7 ff ff       	call   800fdc <cprintf>
  802895:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80289e:	a1 48 50 80 00       	mov    0x805048,%eax
  8028a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028aa:	74 07                	je     8028b3 <print_mem_block_lists+0x155>
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	eb 05                	jmp    8028b8 <print_mem_block_lists+0x15a>
  8028b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b8:	a3 48 50 80 00       	mov    %eax,0x805048
  8028bd:	a1 48 50 80 00       	mov    0x805048,%eax
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	75 8a                	jne    802850 <print_mem_block_lists+0xf2>
  8028c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ca:	75 84                	jne    802850 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8028cc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028d0:	75 10                	jne    8028e2 <print_mem_block_lists+0x184>
  8028d2:	83 ec 0c             	sub    $0xc,%esp
  8028d5:	68 5c 4a 80 00       	push   $0x804a5c
  8028da:	e8 fd e6 ff ff       	call   800fdc <cprintf>
  8028df:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8028e2:	83 ec 0c             	sub    $0xc,%esp
  8028e5:	68 d0 49 80 00       	push   $0x8049d0
  8028ea:	e8 ed e6 ff ff       	call   800fdc <cprintf>
  8028ef:	83 c4 10             	add    $0x10,%esp

}
  8028f2:	90                   	nop
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
  8028f8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8028fb:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802902:	00 00 00 
  802905:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80290c:	00 00 00 
  80290f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802916:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802919:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802920:	e9 9e 00 00 00       	jmp    8029c3 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802925:	a1 50 50 80 00       	mov    0x805050,%eax
  80292a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292d:	c1 e2 04             	shl    $0x4,%edx
  802930:	01 d0                	add    %edx,%eax
  802932:	85 c0                	test   %eax,%eax
  802934:	75 14                	jne    80294a <initialize_MemBlocksList+0x55>
  802936:	83 ec 04             	sub    $0x4,%esp
  802939:	68 84 4a 80 00       	push   $0x804a84
  80293e:	6a 46                	push   $0x46
  802940:	68 a7 4a 80 00       	push   $0x804aa7
  802945:	e8 de e3 ff ff       	call   800d28 <_panic>
  80294a:	a1 50 50 80 00       	mov    0x805050,%eax
  80294f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802952:	c1 e2 04             	shl    $0x4,%edx
  802955:	01 d0                	add    %edx,%eax
  802957:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80295d:	89 10                	mov    %edx,(%eax)
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 18                	je     80297d <initialize_MemBlocksList+0x88>
  802965:	a1 48 51 80 00       	mov    0x805148,%eax
  80296a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802970:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802973:	c1 e1 04             	shl    $0x4,%ecx
  802976:	01 ca                	add    %ecx,%edx
  802978:	89 50 04             	mov    %edx,0x4(%eax)
  80297b:	eb 12                	jmp    80298f <initialize_MemBlocksList+0x9a>
  80297d:	a1 50 50 80 00       	mov    0x805050,%eax
  802982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802985:	c1 e2 04             	shl    $0x4,%edx
  802988:	01 d0                	add    %edx,%eax
  80298a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80298f:	a1 50 50 80 00       	mov    0x805050,%eax
  802994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802997:	c1 e2 04             	shl    $0x4,%edx
  80299a:	01 d0                	add    %edx,%eax
  80299c:	a3 48 51 80 00       	mov    %eax,0x805148
  8029a1:	a1 50 50 80 00       	mov    0x805050,%eax
  8029a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a9:	c1 e2 04             	shl    $0x4,%edx
  8029ac:	01 d0                	add    %edx,%eax
  8029ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8029ba:	40                   	inc    %eax
  8029bb:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8029c0:	ff 45 f4             	incl   -0xc(%ebp)
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c9:	0f 82 56 ff ff ff    	jb     802925 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8029cf:	90                   	nop
  8029d0:	c9                   	leave  
  8029d1:	c3                   	ret    

008029d2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8029d2:	55                   	push   %ebp
  8029d3:	89 e5                	mov    %esp,%ebp
  8029d5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	8b 00                	mov    (%eax),%eax
  8029dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029e0:	eb 19                	jmp    8029fb <find_block+0x29>
	{
		if(va==point->sva)
  8029e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029e5:	8b 40 08             	mov    0x8(%eax),%eax
  8029e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029eb:	75 05                	jne    8029f2 <find_block+0x20>
		   return point;
  8029ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029f0:	eb 36                	jmp    802a28 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	8b 40 08             	mov    0x8(%eax),%eax
  8029f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029ff:	74 07                	je     802a08 <find_block+0x36>
  802a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	eb 05                	jmp    802a0d <find_block+0x3b>
  802a08:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a10:	89 42 08             	mov    %eax,0x8(%edx)
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	8b 40 08             	mov    0x8(%eax),%eax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	75 c5                	jne    8029e2 <find_block+0x10>
  802a1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a21:	75 bf                	jne    8029e2 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802a23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a28:	c9                   	leave  
  802a29:	c3                   	ret    

00802a2a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802a2a:	55                   	push   %ebp
  802a2b:	89 e5                	mov    %esp,%ebp
  802a2d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802a30:	a1 40 50 80 00       	mov    0x805040,%eax
  802a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802a38:	a1 44 50 80 00       	mov    0x805044,%eax
  802a3d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a43:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a46:	74 24                	je     802a6c <insert_sorted_allocList+0x42>
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	8b 50 08             	mov    0x8(%eax),%edx
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	8b 40 08             	mov    0x8(%eax),%eax
  802a54:	39 c2                	cmp    %eax,%edx
  802a56:	76 14                	jbe    802a6c <insert_sorted_allocList+0x42>
  802a58:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5b:	8b 50 08             	mov    0x8(%eax),%edx
  802a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a61:	8b 40 08             	mov    0x8(%eax),%eax
  802a64:	39 c2                	cmp    %eax,%edx
  802a66:	0f 82 60 01 00 00    	jb     802bcc <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802a6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a70:	75 65                	jne    802ad7 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802a72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a76:	75 14                	jne    802a8c <insert_sorted_allocList+0x62>
  802a78:	83 ec 04             	sub    $0x4,%esp
  802a7b:	68 84 4a 80 00       	push   $0x804a84
  802a80:	6a 6b                	push   $0x6b
  802a82:	68 a7 4a 80 00       	push   $0x804aa7
  802a87:	e8 9c e2 ff ff       	call   800d28 <_panic>
  802a8c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	89 10                	mov    %edx,(%eax)
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	85 c0                	test   %eax,%eax
  802a9e:	74 0d                	je     802aad <insert_sorted_allocList+0x83>
  802aa0:	a1 40 50 80 00       	mov    0x805040,%eax
  802aa5:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa8:	89 50 04             	mov    %edx,0x4(%eax)
  802aab:	eb 08                	jmp    802ab5 <insert_sorted_allocList+0x8b>
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	a3 44 50 80 00       	mov    %eax,0x805044
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	a3 40 50 80 00       	mov    %eax,0x805040
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802acc:	40                   	inc    %eax
  802acd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ad2:	e9 dc 01 00 00       	jmp    802cb3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	8b 50 08             	mov    0x8(%eax),%edx
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	8b 40 08             	mov    0x8(%eax),%eax
  802ae3:	39 c2                	cmp    %eax,%edx
  802ae5:	77 6c                	ja     802b53 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802ae7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aeb:	74 06                	je     802af3 <insert_sorted_allocList+0xc9>
  802aed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af1:	75 14                	jne    802b07 <insert_sorted_allocList+0xdd>
  802af3:	83 ec 04             	sub    $0x4,%esp
  802af6:	68 c0 4a 80 00       	push   $0x804ac0
  802afb:	6a 6f                	push   $0x6f
  802afd:	68 a7 4a 80 00       	push   $0x804aa7
  802b02:	e8 21 e2 ff ff       	call   800d28 <_panic>
  802b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0a:	8b 50 04             	mov    0x4(%eax),%edx
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	89 50 04             	mov    %edx,0x4(%eax)
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b19:	89 10                	mov    %edx,(%eax)
  802b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1e:	8b 40 04             	mov    0x4(%eax),%eax
  802b21:	85 c0                	test   %eax,%eax
  802b23:	74 0d                	je     802b32 <insert_sorted_allocList+0x108>
  802b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b28:	8b 40 04             	mov    0x4(%eax),%eax
  802b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2e:	89 10                	mov    %edx,(%eax)
  802b30:	eb 08                	jmp    802b3a <insert_sorted_allocList+0x110>
  802b32:	8b 45 08             	mov    0x8(%ebp),%eax
  802b35:	a3 40 50 80 00       	mov    %eax,0x805040
  802b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b40:	89 50 04             	mov    %edx,0x4(%eax)
  802b43:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b48:	40                   	inc    %eax
  802b49:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b4e:	e9 60 01 00 00       	jmp    802cb3 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	8b 50 08             	mov    0x8(%eax),%edx
  802b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5c:	8b 40 08             	mov    0x8(%eax),%eax
  802b5f:	39 c2                	cmp    %eax,%edx
  802b61:	0f 82 4c 01 00 00    	jb     802cb3 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802b67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b6b:	75 14                	jne    802b81 <insert_sorted_allocList+0x157>
  802b6d:	83 ec 04             	sub    $0x4,%esp
  802b70:	68 f8 4a 80 00       	push   $0x804af8
  802b75:	6a 73                	push   $0x73
  802b77:	68 a7 4a 80 00       	push   $0x804aa7
  802b7c:	e8 a7 e1 ff ff       	call   800d28 <_panic>
  802b81:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	89 50 04             	mov    %edx,0x4(%eax)
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	8b 40 04             	mov    0x4(%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 0c                	je     802ba3 <insert_sorted_allocList+0x179>
  802b97:	a1 44 50 80 00       	mov    0x805044,%eax
  802b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9f:	89 10                	mov    %edx,(%eax)
  802ba1:	eb 08                	jmp    802bab <insert_sorted_allocList+0x181>
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	a3 40 50 80 00       	mov    %eax,0x805040
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	a3 44 50 80 00       	mov    %eax,0x805044
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bc1:	40                   	inc    %eax
  802bc2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802bc7:	e9 e7 00 00 00       	jmp    802cb3 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802bd2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802bd9:	a1 40 50 80 00       	mov    0x805040,%eax
  802bde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be1:	e9 9d 00 00 00       	jmp    802c83 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	8b 50 08             	mov    0x8(%eax),%edx
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 40 08             	mov    0x8(%eax),%eax
  802bfa:	39 c2                	cmp    %eax,%edx
  802bfc:	76 7d                	jbe    802c7b <insert_sorted_allocList+0x251>
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	8b 50 08             	mov    0x8(%eax),%edx
  802c04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c07:	8b 40 08             	mov    0x8(%eax),%eax
  802c0a:	39 c2                	cmp    %eax,%edx
  802c0c:	73 6d                	jae    802c7b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802c0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c12:	74 06                	je     802c1a <insert_sorted_allocList+0x1f0>
  802c14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c18:	75 14                	jne    802c2e <insert_sorted_allocList+0x204>
  802c1a:	83 ec 04             	sub    $0x4,%esp
  802c1d:	68 1c 4b 80 00       	push   $0x804b1c
  802c22:	6a 7f                	push   $0x7f
  802c24:	68 a7 4a 80 00       	push   $0x804aa7
  802c29:	e8 fa e0 ff ff       	call   800d28 <_panic>
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 10                	mov    (%eax),%edx
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	89 10                	mov    %edx,(%eax)
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	8b 00                	mov    (%eax),%eax
  802c3d:	85 c0                	test   %eax,%eax
  802c3f:	74 0b                	je     802c4c <insert_sorted_allocList+0x222>
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	8b 55 08             	mov    0x8(%ebp),%edx
  802c49:	89 50 04             	mov    %edx,0x4(%eax)
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c52:	89 10                	mov    %edx,(%eax)
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5a:	89 50 04             	mov    %edx,0x4(%eax)
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	8b 00                	mov    (%eax),%eax
  802c62:	85 c0                	test   %eax,%eax
  802c64:	75 08                	jne    802c6e <insert_sorted_allocList+0x244>
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	a3 44 50 80 00       	mov    %eax,0x805044
  802c6e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c73:	40                   	inc    %eax
  802c74:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802c79:	eb 39                	jmp    802cb4 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802c7b:	a1 48 50 80 00       	mov    0x805048,%eax
  802c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c87:	74 07                	je     802c90 <insert_sorted_allocList+0x266>
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	eb 05                	jmp    802c95 <insert_sorted_allocList+0x26b>
  802c90:	b8 00 00 00 00       	mov    $0x0,%eax
  802c95:	a3 48 50 80 00       	mov    %eax,0x805048
  802c9a:	a1 48 50 80 00       	mov    0x805048,%eax
  802c9f:	85 c0                	test   %eax,%eax
  802ca1:	0f 85 3f ff ff ff    	jne    802be6 <insert_sorted_allocList+0x1bc>
  802ca7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cab:	0f 85 35 ff ff ff    	jne    802be6 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802cb1:	eb 01                	jmp    802cb4 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802cb3:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802cb4:	90                   	nop
  802cb5:	c9                   	leave  
  802cb6:	c3                   	ret    

00802cb7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802cb7:	55                   	push   %ebp
  802cb8:	89 e5                	mov    %esp,%ebp
  802cba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802cbd:	a1 38 51 80 00       	mov    0x805138,%eax
  802cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc5:	e9 85 01 00 00       	jmp    802e4f <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd3:	0f 82 6e 01 00 00    	jb     802e47 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce2:	0f 85 8a 00 00 00    	jne    802d72 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802ce8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cec:	75 17                	jne    802d05 <alloc_block_FF+0x4e>
  802cee:	83 ec 04             	sub    $0x4,%esp
  802cf1:	68 50 4b 80 00       	push   $0x804b50
  802cf6:	68 93 00 00 00       	push   $0x93
  802cfb:	68 a7 4a 80 00       	push   $0x804aa7
  802d00:	e8 23 e0 ff ff       	call   800d28 <_panic>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 00                	mov    (%eax),%eax
  802d0a:	85 c0                	test   %eax,%eax
  802d0c:	74 10                	je     802d1e <alloc_block_FF+0x67>
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 00                	mov    (%eax),%eax
  802d13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d16:	8b 52 04             	mov    0x4(%edx),%edx
  802d19:	89 50 04             	mov    %edx,0x4(%eax)
  802d1c:	eb 0b                	jmp    802d29 <alloc_block_FF+0x72>
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 40 04             	mov    0x4(%eax),%eax
  802d24:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 40 04             	mov    0x4(%eax),%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	74 0f                	je     802d42 <alloc_block_FF+0x8b>
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 40 04             	mov    0x4(%eax),%eax
  802d39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d3c:	8b 12                	mov    (%edx),%edx
  802d3e:	89 10                	mov    %edx,(%eax)
  802d40:	eb 0a                	jmp    802d4c <alloc_block_FF+0x95>
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	a3 38 51 80 00       	mov    %eax,0x805138
  802d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d64:	48                   	dec    %eax
  802d65:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	e9 10 01 00 00       	jmp    802e82 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 40 0c             	mov    0xc(%eax),%eax
  802d78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d7b:	0f 86 c6 00 00 00    	jbe    802e47 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d81:	a1 48 51 80 00       	mov    0x805148,%eax
  802d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	8b 50 08             	mov    0x8(%eax),%edx
  802d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d92:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d98:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9b:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da2:	75 17                	jne    802dbb <alloc_block_FF+0x104>
  802da4:	83 ec 04             	sub    $0x4,%esp
  802da7:	68 50 4b 80 00       	push   $0x804b50
  802dac:	68 9b 00 00 00       	push   $0x9b
  802db1:	68 a7 4a 80 00       	push   $0x804aa7
  802db6:	e8 6d df ff ff       	call   800d28 <_panic>
  802dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbe:	8b 00                	mov    (%eax),%eax
  802dc0:	85 c0                	test   %eax,%eax
  802dc2:	74 10                	je     802dd4 <alloc_block_FF+0x11d>
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	8b 00                	mov    (%eax),%eax
  802dc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dcc:	8b 52 04             	mov    0x4(%edx),%edx
  802dcf:	89 50 04             	mov    %edx,0x4(%eax)
  802dd2:	eb 0b                	jmp    802ddf <alloc_block_FF+0x128>
  802dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd7:	8b 40 04             	mov    0x4(%eax),%eax
  802dda:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de2:	8b 40 04             	mov    0x4(%eax),%eax
  802de5:	85 c0                	test   %eax,%eax
  802de7:	74 0f                	je     802df8 <alloc_block_FF+0x141>
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	8b 40 04             	mov    0x4(%eax),%eax
  802def:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df2:	8b 12                	mov    (%edx),%edx
  802df4:	89 10                	mov    %edx,(%eax)
  802df6:	eb 0a                	jmp    802e02 <alloc_block_FF+0x14b>
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	8b 00                	mov    (%eax),%eax
  802dfd:	a3 48 51 80 00       	mov    %eax,0x805148
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e15:	a1 54 51 80 00       	mov    0x805154,%eax
  802e1a:	48                   	dec    %eax
  802e1b:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	8b 50 08             	mov    0x8(%eax),%edx
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	01 c2                	add    %eax,%edx
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 40 0c             	mov    0xc(%eax),%eax
  802e37:	2b 45 08             	sub    0x8(%ebp),%eax
  802e3a:	89 c2                	mov    %eax,%edx
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e45:	eb 3b                	jmp    802e82 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802e47:	a1 40 51 80 00       	mov    0x805140,%eax
  802e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e53:	74 07                	je     802e5c <alloc_block_FF+0x1a5>
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	eb 05                	jmp    802e61 <alloc_block_FF+0x1aa>
  802e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802e61:	a3 40 51 80 00       	mov    %eax,0x805140
  802e66:	a1 40 51 80 00       	mov    0x805140,%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	0f 85 57 fe ff ff    	jne    802cca <alloc_block_FF+0x13>
  802e73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e77:	0f 85 4d fe ff ff    	jne    802cca <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802e7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e82:	c9                   	leave  
  802e83:	c3                   	ret    

00802e84 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e84:	55                   	push   %ebp
  802e85:	89 e5                	mov    %esp,%ebp
  802e87:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802e8a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802e91:	a1 38 51 80 00       	mov    0x805138,%eax
  802e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e99:	e9 df 00 00 00       	jmp    802f7d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ea7:	0f 82 c8 00 00 00    	jb     802f75 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb6:	0f 85 8a 00 00 00    	jne    802f46 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802ebc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec0:	75 17                	jne    802ed9 <alloc_block_BF+0x55>
  802ec2:	83 ec 04             	sub    $0x4,%esp
  802ec5:	68 50 4b 80 00       	push   $0x804b50
  802eca:	68 b7 00 00 00       	push   $0xb7
  802ecf:	68 a7 4a 80 00       	push   $0x804aa7
  802ed4:	e8 4f de ff ff       	call   800d28 <_panic>
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 00                	mov    (%eax),%eax
  802ede:	85 c0                	test   %eax,%eax
  802ee0:	74 10                	je     802ef2 <alloc_block_BF+0x6e>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eea:	8b 52 04             	mov    0x4(%edx),%edx
  802eed:	89 50 04             	mov    %edx,0x4(%eax)
  802ef0:	eb 0b                	jmp    802efd <alloc_block_BF+0x79>
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 04             	mov    0x4(%eax),%eax
  802ef8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 40 04             	mov    0x4(%eax),%eax
  802f03:	85 c0                	test   %eax,%eax
  802f05:	74 0f                	je     802f16 <alloc_block_BF+0x92>
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 40 04             	mov    0x4(%eax),%eax
  802f0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f10:	8b 12                	mov    (%edx),%edx
  802f12:	89 10                	mov    %edx,(%eax)
  802f14:	eb 0a                	jmp    802f20 <alloc_block_BF+0x9c>
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	8b 00                	mov    (%eax),%eax
  802f1b:	a3 38 51 80 00       	mov    %eax,0x805138
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f33:	a1 44 51 80 00       	mov    0x805144,%eax
  802f38:	48                   	dec    %eax
  802f39:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	e9 4d 01 00 00       	jmp    803093 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f4f:	76 24                	jbe    802f75 <alloc_block_BF+0xf1>
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	8b 40 0c             	mov    0xc(%eax),%eax
  802f57:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f5a:	73 19                	jae    802f75 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802f5c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 40 0c             	mov    0xc(%eax),%eax
  802f69:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 40 08             	mov    0x8(%eax),%eax
  802f72:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802f75:	a1 40 51 80 00       	mov    0x805140,%eax
  802f7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f81:	74 07                	je     802f8a <alloc_block_BF+0x106>
  802f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f86:	8b 00                	mov    (%eax),%eax
  802f88:	eb 05                	jmp    802f8f <alloc_block_BF+0x10b>
  802f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8f:	a3 40 51 80 00       	mov    %eax,0x805140
  802f94:	a1 40 51 80 00       	mov    0x805140,%eax
  802f99:	85 c0                	test   %eax,%eax
  802f9b:	0f 85 fd fe ff ff    	jne    802e9e <alloc_block_BF+0x1a>
  802fa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa5:	0f 85 f3 fe ff ff    	jne    802e9e <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802fab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802faf:	0f 84 d9 00 00 00    	je     80308e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802fb5:	a1 48 51 80 00       	mov    0x805148,%eax
  802fba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802fbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fc3:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802fc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fcc:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802fcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fd3:	75 17                	jne    802fec <alloc_block_BF+0x168>
  802fd5:	83 ec 04             	sub    $0x4,%esp
  802fd8:	68 50 4b 80 00       	push   $0x804b50
  802fdd:	68 c7 00 00 00       	push   $0xc7
  802fe2:	68 a7 4a 80 00       	push   $0x804aa7
  802fe7:	e8 3c dd ff ff       	call   800d28 <_panic>
  802fec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	85 c0                	test   %eax,%eax
  802ff3:	74 10                	je     803005 <alloc_block_BF+0x181>
  802ff5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ffd:	8b 52 04             	mov    0x4(%edx),%edx
  803000:	89 50 04             	mov    %edx,0x4(%eax)
  803003:	eb 0b                	jmp    803010 <alloc_block_BF+0x18c>
  803005:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803008:	8b 40 04             	mov    0x4(%eax),%eax
  80300b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803010:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803013:	8b 40 04             	mov    0x4(%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 0f                	je     803029 <alloc_block_BF+0x1a5>
  80301a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301d:	8b 40 04             	mov    0x4(%eax),%eax
  803020:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803023:	8b 12                	mov    (%edx),%edx
  803025:	89 10                	mov    %edx,(%eax)
  803027:	eb 0a                	jmp    803033 <alloc_block_BF+0x1af>
  803029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	a3 48 51 80 00       	mov    %eax,0x805148
  803033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803036:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803046:	a1 54 51 80 00       	mov    0x805154,%eax
  80304b:	48                   	dec    %eax
  80304c:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803051:	83 ec 08             	sub    $0x8,%esp
  803054:	ff 75 ec             	pushl  -0x14(%ebp)
  803057:	68 38 51 80 00       	push   $0x805138
  80305c:	e8 71 f9 ff ff       	call   8029d2 <find_block>
  803061:	83 c4 10             	add    $0x10,%esp
  803064:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803067:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80306a:	8b 50 08             	mov    0x8(%eax),%edx
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	01 c2                	add    %eax,%edx
  803072:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803075:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803078:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80307b:	8b 40 0c             	mov    0xc(%eax),%eax
  80307e:	2b 45 08             	sub    0x8(%ebp),%eax
  803081:	89 c2                	mov    %eax,%edx
  803083:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803086:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80308c:	eb 05                	jmp    803093 <alloc_block_BF+0x20f>
	}
	return NULL;
  80308e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803093:	c9                   	leave  
  803094:	c3                   	ret    

00803095 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803095:	55                   	push   %ebp
  803096:	89 e5                	mov    %esp,%ebp
  803098:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80309b:	a1 28 50 80 00       	mov    0x805028,%eax
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	0f 85 de 01 00 00    	jne    803286 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8030a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b0:	e9 9e 01 00 00       	jmp    803253 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030be:	0f 82 87 01 00 00    	jb     80324b <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8030c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030cd:	0f 85 95 00 00 00    	jne    803168 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8030d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d7:	75 17                	jne    8030f0 <alloc_block_NF+0x5b>
  8030d9:	83 ec 04             	sub    $0x4,%esp
  8030dc:	68 50 4b 80 00       	push   $0x804b50
  8030e1:	68 e0 00 00 00       	push   $0xe0
  8030e6:	68 a7 4a 80 00       	push   $0x804aa7
  8030eb:	e8 38 dc ff ff       	call   800d28 <_panic>
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	8b 00                	mov    (%eax),%eax
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	74 10                	je     803109 <alloc_block_NF+0x74>
  8030f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fc:	8b 00                	mov    (%eax),%eax
  8030fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803101:	8b 52 04             	mov    0x4(%edx),%edx
  803104:	89 50 04             	mov    %edx,0x4(%eax)
  803107:	eb 0b                	jmp    803114 <alloc_block_NF+0x7f>
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	8b 40 04             	mov    0x4(%eax),%eax
  80310f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803117:	8b 40 04             	mov    0x4(%eax),%eax
  80311a:	85 c0                	test   %eax,%eax
  80311c:	74 0f                	je     80312d <alloc_block_NF+0x98>
  80311e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803121:	8b 40 04             	mov    0x4(%eax),%eax
  803124:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803127:	8b 12                	mov    (%edx),%edx
  803129:	89 10                	mov    %edx,(%eax)
  80312b:	eb 0a                	jmp    803137 <alloc_block_NF+0xa2>
  80312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803130:	8b 00                	mov    (%eax),%eax
  803132:	a3 38 51 80 00       	mov    %eax,0x805138
  803137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803143:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314a:	a1 44 51 80 00       	mov    0x805144,%eax
  80314f:	48                   	dec    %eax
  803150:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 40 08             	mov    0x8(%eax),%eax
  80315b:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	e9 f8 04 00 00       	jmp    803660 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	8b 40 0c             	mov    0xc(%eax),%eax
  80316e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803171:	0f 86 d4 00 00 00    	jbe    80324b <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803177:	a1 48 51 80 00       	mov    0x805148,%eax
  80317c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80317f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803182:	8b 50 08             	mov    0x8(%eax),%edx
  803185:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803188:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318e:	8b 55 08             	mov    0x8(%ebp),%edx
  803191:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803194:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803198:	75 17                	jne    8031b1 <alloc_block_NF+0x11c>
  80319a:	83 ec 04             	sub    $0x4,%esp
  80319d:	68 50 4b 80 00       	push   $0x804b50
  8031a2:	68 e9 00 00 00       	push   $0xe9
  8031a7:	68 a7 4a 80 00       	push   $0x804aa7
  8031ac:	e8 77 db ff ff       	call   800d28 <_panic>
  8031b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b4:	8b 00                	mov    (%eax),%eax
  8031b6:	85 c0                	test   %eax,%eax
  8031b8:	74 10                	je     8031ca <alloc_block_NF+0x135>
  8031ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bd:	8b 00                	mov    (%eax),%eax
  8031bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031c2:	8b 52 04             	mov    0x4(%edx),%edx
  8031c5:	89 50 04             	mov    %edx,0x4(%eax)
  8031c8:	eb 0b                	jmp    8031d5 <alloc_block_NF+0x140>
  8031ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cd:	8b 40 04             	mov    0x4(%eax),%eax
  8031d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d8:	8b 40 04             	mov    0x4(%eax),%eax
  8031db:	85 c0                	test   %eax,%eax
  8031dd:	74 0f                	je     8031ee <alloc_block_NF+0x159>
  8031df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e2:	8b 40 04             	mov    0x4(%eax),%eax
  8031e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031e8:	8b 12                	mov    (%edx),%edx
  8031ea:	89 10                	mov    %edx,(%eax)
  8031ec:	eb 0a                	jmp    8031f8 <alloc_block_NF+0x163>
  8031ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f1:	8b 00                	mov    (%eax),%eax
  8031f3:	a3 48 51 80 00       	mov    %eax,0x805148
  8031f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803204:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320b:	a1 54 51 80 00       	mov    0x805154,%eax
  803210:	48                   	dec    %eax
  803211:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  803216:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803219:	8b 40 08             	mov    0x8(%eax),%eax
  80321c:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803224:	8b 50 08             	mov    0x8(%eax),%edx
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	01 c2                	add    %eax,%edx
  80322c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322f:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	8b 40 0c             	mov    0xc(%eax),%eax
  803238:	2b 45 08             	sub    0x8(%ebp),%eax
  80323b:	89 c2                	mov    %eax,%edx
  80323d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803240:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803246:	e9 15 04 00 00       	jmp    803660 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80324b:	a1 40 51 80 00       	mov    0x805140,%eax
  803250:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803253:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803257:	74 07                	je     803260 <alloc_block_NF+0x1cb>
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	8b 00                	mov    (%eax),%eax
  80325e:	eb 05                	jmp    803265 <alloc_block_NF+0x1d0>
  803260:	b8 00 00 00 00       	mov    $0x0,%eax
  803265:	a3 40 51 80 00       	mov    %eax,0x805140
  80326a:	a1 40 51 80 00       	mov    0x805140,%eax
  80326f:	85 c0                	test   %eax,%eax
  803271:	0f 85 3e fe ff ff    	jne    8030b5 <alloc_block_NF+0x20>
  803277:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327b:	0f 85 34 fe ff ff    	jne    8030b5 <alloc_block_NF+0x20>
  803281:	e9 d5 03 00 00       	jmp    80365b <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803286:	a1 38 51 80 00       	mov    0x805138,%eax
  80328b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80328e:	e9 b1 01 00 00       	jmp    803444 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803296:	8b 50 08             	mov    0x8(%eax),%edx
  803299:	a1 28 50 80 00       	mov    0x805028,%eax
  80329e:	39 c2                	cmp    %eax,%edx
  8032a0:	0f 82 96 01 00 00    	jb     80343c <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032af:	0f 82 87 01 00 00    	jb     80343c <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8032b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032be:	0f 85 95 00 00 00    	jne    803359 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8032c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c8:	75 17                	jne    8032e1 <alloc_block_NF+0x24c>
  8032ca:	83 ec 04             	sub    $0x4,%esp
  8032cd:	68 50 4b 80 00       	push   $0x804b50
  8032d2:	68 fc 00 00 00       	push   $0xfc
  8032d7:	68 a7 4a 80 00       	push   $0x804aa7
  8032dc:	e8 47 da ff ff       	call   800d28 <_panic>
  8032e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e4:	8b 00                	mov    (%eax),%eax
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	74 10                	je     8032fa <alloc_block_NF+0x265>
  8032ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ed:	8b 00                	mov    (%eax),%eax
  8032ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f2:	8b 52 04             	mov    0x4(%edx),%edx
  8032f5:	89 50 04             	mov    %edx,0x4(%eax)
  8032f8:	eb 0b                	jmp    803305 <alloc_block_NF+0x270>
  8032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fd:	8b 40 04             	mov    0x4(%eax),%eax
  803300:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803308:	8b 40 04             	mov    0x4(%eax),%eax
  80330b:	85 c0                	test   %eax,%eax
  80330d:	74 0f                	je     80331e <alloc_block_NF+0x289>
  80330f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803312:	8b 40 04             	mov    0x4(%eax),%eax
  803315:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803318:	8b 12                	mov    (%edx),%edx
  80331a:	89 10                	mov    %edx,(%eax)
  80331c:	eb 0a                	jmp    803328 <alloc_block_NF+0x293>
  80331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803321:	8b 00                	mov    (%eax),%eax
  803323:	a3 38 51 80 00       	mov    %eax,0x805138
  803328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803334:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333b:	a1 44 51 80 00       	mov    0x805144,%eax
  803340:	48                   	dec    %eax
  803341:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803349:	8b 40 08             	mov    0x8(%eax),%eax
  80334c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803354:	e9 07 03 00 00       	jmp    803660 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335c:	8b 40 0c             	mov    0xc(%eax),%eax
  80335f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803362:	0f 86 d4 00 00 00    	jbe    80343c <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803368:	a1 48 51 80 00       	mov    0x805148,%eax
  80336d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803373:	8b 50 08             	mov    0x8(%eax),%edx
  803376:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803379:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80337c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337f:	8b 55 08             	mov    0x8(%ebp),%edx
  803382:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803385:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803389:	75 17                	jne    8033a2 <alloc_block_NF+0x30d>
  80338b:	83 ec 04             	sub    $0x4,%esp
  80338e:	68 50 4b 80 00       	push   $0x804b50
  803393:	68 04 01 00 00       	push   $0x104
  803398:	68 a7 4a 80 00       	push   $0x804aa7
  80339d:	e8 86 d9 ff ff       	call   800d28 <_panic>
  8033a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a5:	8b 00                	mov    (%eax),%eax
  8033a7:	85 c0                	test   %eax,%eax
  8033a9:	74 10                	je     8033bb <alloc_block_NF+0x326>
  8033ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ae:	8b 00                	mov    (%eax),%eax
  8033b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b3:	8b 52 04             	mov    0x4(%edx),%edx
  8033b6:	89 50 04             	mov    %edx,0x4(%eax)
  8033b9:	eb 0b                	jmp    8033c6 <alloc_block_NF+0x331>
  8033bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033be:	8b 40 04             	mov    0x4(%eax),%eax
  8033c1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c9:	8b 40 04             	mov    0x4(%eax),%eax
  8033cc:	85 c0                	test   %eax,%eax
  8033ce:	74 0f                	je     8033df <alloc_block_NF+0x34a>
  8033d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d3:	8b 40 04             	mov    0x4(%eax),%eax
  8033d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d9:	8b 12                	mov    (%edx),%edx
  8033db:	89 10                	mov    %edx,(%eax)
  8033dd:	eb 0a                	jmp    8033e9 <alloc_block_NF+0x354>
  8033df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e2:	8b 00                	mov    (%eax),%eax
  8033e4:	a3 48 51 80 00       	mov    %eax,0x805148
  8033e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033fc:	a1 54 51 80 00       	mov    0x805154,%eax
  803401:	48                   	dec    %eax
  803402:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  803407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340a:	8b 40 08             	mov    0x8(%eax),%eax
  80340d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803415:	8b 50 08             	mov    0x8(%eax),%edx
  803418:	8b 45 08             	mov    0x8(%ebp),%eax
  80341b:	01 c2                	add    %eax,%edx
  80341d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803420:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803426:	8b 40 0c             	mov    0xc(%eax),%eax
  803429:	2b 45 08             	sub    0x8(%ebp),%eax
  80342c:	89 c2                	mov    %eax,%edx
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803437:	e9 24 02 00 00       	jmp    803660 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80343c:	a1 40 51 80 00       	mov    0x805140,%eax
  803441:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803444:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803448:	74 07                	je     803451 <alloc_block_NF+0x3bc>
  80344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344d:	8b 00                	mov    (%eax),%eax
  80344f:	eb 05                	jmp    803456 <alloc_block_NF+0x3c1>
  803451:	b8 00 00 00 00       	mov    $0x0,%eax
  803456:	a3 40 51 80 00       	mov    %eax,0x805140
  80345b:	a1 40 51 80 00       	mov    0x805140,%eax
  803460:	85 c0                	test   %eax,%eax
  803462:	0f 85 2b fe ff ff    	jne    803293 <alloc_block_NF+0x1fe>
  803468:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346c:	0f 85 21 fe ff ff    	jne    803293 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803472:	a1 38 51 80 00       	mov    0x805138,%eax
  803477:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80347a:	e9 ae 01 00 00       	jmp    80362d <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	8b 50 08             	mov    0x8(%eax),%edx
  803485:	a1 28 50 80 00       	mov    0x805028,%eax
  80348a:	39 c2                	cmp    %eax,%edx
  80348c:	0f 83 93 01 00 00    	jae    803625 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803495:	8b 40 0c             	mov    0xc(%eax),%eax
  803498:	3b 45 08             	cmp    0x8(%ebp),%eax
  80349b:	0f 82 84 01 00 00    	jb     803625 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034aa:	0f 85 95 00 00 00    	jne    803545 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8034b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b4:	75 17                	jne    8034cd <alloc_block_NF+0x438>
  8034b6:	83 ec 04             	sub    $0x4,%esp
  8034b9:	68 50 4b 80 00       	push   $0x804b50
  8034be:	68 14 01 00 00       	push   $0x114
  8034c3:	68 a7 4a 80 00       	push   $0x804aa7
  8034c8:	e8 5b d8 ff ff       	call   800d28 <_panic>
  8034cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d0:	8b 00                	mov    (%eax),%eax
  8034d2:	85 c0                	test   %eax,%eax
  8034d4:	74 10                	je     8034e6 <alloc_block_NF+0x451>
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	8b 00                	mov    (%eax),%eax
  8034db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034de:	8b 52 04             	mov    0x4(%edx),%edx
  8034e1:	89 50 04             	mov    %edx,0x4(%eax)
  8034e4:	eb 0b                	jmp    8034f1 <alloc_block_NF+0x45c>
  8034e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e9:	8b 40 04             	mov    0x4(%eax),%eax
  8034ec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f4:	8b 40 04             	mov    0x4(%eax),%eax
  8034f7:	85 c0                	test   %eax,%eax
  8034f9:	74 0f                	je     80350a <alloc_block_NF+0x475>
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	8b 40 04             	mov    0x4(%eax),%eax
  803501:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803504:	8b 12                	mov    (%edx),%edx
  803506:	89 10                	mov    %edx,(%eax)
  803508:	eb 0a                	jmp    803514 <alloc_block_NF+0x47f>
  80350a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350d:	8b 00                	mov    (%eax),%eax
  80350f:	a3 38 51 80 00       	mov    %eax,0x805138
  803514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803517:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80351d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803520:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803527:	a1 44 51 80 00       	mov    0x805144,%eax
  80352c:	48                   	dec    %eax
  80352d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803535:	8b 40 08             	mov    0x8(%eax),%eax
  803538:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80353d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803540:	e9 1b 01 00 00       	jmp    803660 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803548:	8b 40 0c             	mov    0xc(%eax),%eax
  80354b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80354e:	0f 86 d1 00 00 00    	jbe    803625 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803554:	a1 48 51 80 00       	mov    0x805148,%eax
  803559:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80355c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355f:	8b 50 08             	mov    0x8(%eax),%edx
  803562:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803565:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356b:	8b 55 08             	mov    0x8(%ebp),%edx
  80356e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803571:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803575:	75 17                	jne    80358e <alloc_block_NF+0x4f9>
  803577:	83 ec 04             	sub    $0x4,%esp
  80357a:	68 50 4b 80 00       	push   $0x804b50
  80357f:	68 1c 01 00 00       	push   $0x11c
  803584:	68 a7 4a 80 00       	push   $0x804aa7
  803589:	e8 9a d7 ff ff       	call   800d28 <_panic>
  80358e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803591:	8b 00                	mov    (%eax),%eax
  803593:	85 c0                	test   %eax,%eax
  803595:	74 10                	je     8035a7 <alloc_block_NF+0x512>
  803597:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80359a:	8b 00                	mov    (%eax),%eax
  80359c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80359f:	8b 52 04             	mov    0x4(%edx),%edx
  8035a2:	89 50 04             	mov    %edx,0x4(%eax)
  8035a5:	eb 0b                	jmp    8035b2 <alloc_block_NF+0x51d>
  8035a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035aa:	8b 40 04             	mov    0x4(%eax),%eax
  8035ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b5:	8b 40 04             	mov    0x4(%eax),%eax
  8035b8:	85 c0                	test   %eax,%eax
  8035ba:	74 0f                	je     8035cb <alloc_block_NF+0x536>
  8035bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bf:	8b 40 04             	mov    0x4(%eax),%eax
  8035c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8035c5:	8b 12                	mov    (%edx),%edx
  8035c7:	89 10                	mov    %edx,(%eax)
  8035c9:	eb 0a                	jmp    8035d5 <alloc_block_NF+0x540>
  8035cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ce:	8b 00                	mov    (%eax),%eax
  8035d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8035d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8035ed:	48                   	dec    %eax
  8035ee:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8035f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035f6:	8b 40 08             	mov    0x8(%eax),%eax
  8035f9:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8035fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803601:	8b 50 08             	mov    0x8(%eax),%edx
  803604:	8b 45 08             	mov    0x8(%ebp),%eax
  803607:	01 c2                	add    %eax,%edx
  803609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80360f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803612:	8b 40 0c             	mov    0xc(%eax),%eax
  803615:	2b 45 08             	sub    0x8(%ebp),%eax
  803618:	89 c2                	mov    %eax,%edx
  80361a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803620:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803623:	eb 3b                	jmp    803660 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803625:	a1 40 51 80 00       	mov    0x805140,%eax
  80362a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80362d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803631:	74 07                	je     80363a <alloc_block_NF+0x5a5>
  803633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803636:	8b 00                	mov    (%eax),%eax
  803638:	eb 05                	jmp    80363f <alloc_block_NF+0x5aa>
  80363a:	b8 00 00 00 00       	mov    $0x0,%eax
  80363f:	a3 40 51 80 00       	mov    %eax,0x805140
  803644:	a1 40 51 80 00       	mov    0x805140,%eax
  803649:	85 c0                	test   %eax,%eax
  80364b:	0f 85 2e fe ff ff    	jne    80347f <alloc_block_NF+0x3ea>
  803651:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803655:	0f 85 24 fe ff ff    	jne    80347f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80365b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803660:	c9                   	leave  
  803661:	c3                   	ret    

00803662 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803662:	55                   	push   %ebp
  803663:	89 e5                	mov    %esp,%ebp
  803665:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803668:	a1 38 51 80 00       	mov    0x805138,%eax
  80366d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803670:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803675:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803678:	a1 38 51 80 00       	mov    0x805138,%eax
  80367d:	85 c0                	test   %eax,%eax
  80367f:	74 14                	je     803695 <insert_sorted_with_merge_freeList+0x33>
  803681:	8b 45 08             	mov    0x8(%ebp),%eax
  803684:	8b 50 08             	mov    0x8(%eax),%edx
  803687:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80368a:	8b 40 08             	mov    0x8(%eax),%eax
  80368d:	39 c2                	cmp    %eax,%edx
  80368f:	0f 87 9b 01 00 00    	ja     803830 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803695:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803699:	75 17                	jne    8036b2 <insert_sorted_with_merge_freeList+0x50>
  80369b:	83 ec 04             	sub    $0x4,%esp
  80369e:	68 84 4a 80 00       	push   $0x804a84
  8036a3:	68 38 01 00 00       	push   $0x138
  8036a8:	68 a7 4a 80 00       	push   $0x804aa7
  8036ad:	e8 76 d6 ff ff       	call   800d28 <_panic>
  8036b2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8036b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bb:	89 10                	mov    %edx,(%eax)
  8036bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c0:	8b 00                	mov    (%eax),%eax
  8036c2:	85 c0                	test   %eax,%eax
  8036c4:	74 0d                	je     8036d3 <insert_sorted_with_merge_freeList+0x71>
  8036c6:	a1 38 51 80 00       	mov    0x805138,%eax
  8036cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ce:	89 50 04             	mov    %edx,0x4(%eax)
  8036d1:	eb 08                	jmp    8036db <insert_sorted_with_merge_freeList+0x79>
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036db:	8b 45 08             	mov    0x8(%ebp),%eax
  8036de:	a3 38 51 80 00       	mov    %eax,0x805138
  8036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8036f2:	40                   	inc    %eax
  8036f3:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8036f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036fc:	0f 84 a8 06 00 00    	je     803daa <insert_sorted_with_merge_freeList+0x748>
  803702:	8b 45 08             	mov    0x8(%ebp),%eax
  803705:	8b 50 08             	mov    0x8(%eax),%edx
  803708:	8b 45 08             	mov    0x8(%ebp),%eax
  80370b:	8b 40 0c             	mov    0xc(%eax),%eax
  80370e:	01 c2                	add    %eax,%edx
  803710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803713:	8b 40 08             	mov    0x8(%eax),%eax
  803716:	39 c2                	cmp    %eax,%edx
  803718:	0f 85 8c 06 00 00    	jne    803daa <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  80371e:	8b 45 08             	mov    0x8(%ebp),%eax
  803721:	8b 50 0c             	mov    0xc(%eax),%edx
  803724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803727:	8b 40 0c             	mov    0xc(%eax),%eax
  80372a:	01 c2                	add    %eax,%edx
  80372c:	8b 45 08             	mov    0x8(%ebp),%eax
  80372f:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803732:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803736:	75 17                	jne    80374f <insert_sorted_with_merge_freeList+0xed>
  803738:	83 ec 04             	sub    $0x4,%esp
  80373b:	68 50 4b 80 00       	push   $0x804b50
  803740:	68 3c 01 00 00       	push   $0x13c
  803745:	68 a7 4a 80 00       	push   $0x804aa7
  80374a:	e8 d9 d5 ff ff       	call   800d28 <_panic>
  80374f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803752:	8b 00                	mov    (%eax),%eax
  803754:	85 c0                	test   %eax,%eax
  803756:	74 10                	je     803768 <insert_sorted_with_merge_freeList+0x106>
  803758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375b:	8b 00                	mov    (%eax),%eax
  80375d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803760:	8b 52 04             	mov    0x4(%edx),%edx
  803763:	89 50 04             	mov    %edx,0x4(%eax)
  803766:	eb 0b                	jmp    803773 <insert_sorted_with_merge_freeList+0x111>
  803768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80376b:	8b 40 04             	mov    0x4(%eax),%eax
  80376e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803776:	8b 40 04             	mov    0x4(%eax),%eax
  803779:	85 c0                	test   %eax,%eax
  80377b:	74 0f                	je     80378c <insert_sorted_with_merge_freeList+0x12a>
  80377d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803780:	8b 40 04             	mov    0x4(%eax),%eax
  803783:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803786:	8b 12                	mov    (%edx),%edx
  803788:	89 10                	mov    %edx,(%eax)
  80378a:	eb 0a                	jmp    803796 <insert_sorted_with_merge_freeList+0x134>
  80378c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378f:	8b 00                	mov    (%eax),%eax
  803791:	a3 38 51 80 00       	mov    %eax,0x805138
  803796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803799:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a9:	a1 44 51 80 00       	mov    0x805144,%eax
  8037ae:	48                   	dec    %eax
  8037af:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  8037b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  8037be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8037c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037cc:	75 17                	jne    8037e5 <insert_sorted_with_merge_freeList+0x183>
  8037ce:	83 ec 04             	sub    $0x4,%esp
  8037d1:	68 84 4a 80 00       	push   $0x804a84
  8037d6:	68 3f 01 00 00       	push   $0x13f
  8037db:	68 a7 4a 80 00       	push   $0x804aa7
  8037e0:	e8 43 d5 ff ff       	call   800d28 <_panic>
  8037e5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037ee:	89 10                	mov    %edx,(%eax)
  8037f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f3:	8b 00                	mov    (%eax),%eax
  8037f5:	85 c0                	test   %eax,%eax
  8037f7:	74 0d                	je     803806 <insert_sorted_with_merge_freeList+0x1a4>
  8037f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8037fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803801:	89 50 04             	mov    %edx,0x4(%eax)
  803804:	eb 08                	jmp    80380e <insert_sorted_with_merge_freeList+0x1ac>
  803806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803809:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80380e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803811:	a3 48 51 80 00       	mov    %eax,0x805148
  803816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803819:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803820:	a1 54 51 80 00       	mov    0x805154,%eax
  803825:	40                   	inc    %eax
  803826:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80382b:	e9 7a 05 00 00       	jmp    803daa <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803830:	8b 45 08             	mov    0x8(%ebp),%eax
  803833:	8b 50 08             	mov    0x8(%eax),%edx
  803836:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803839:	8b 40 08             	mov    0x8(%eax),%eax
  80383c:	39 c2                	cmp    %eax,%edx
  80383e:	0f 82 14 01 00 00    	jb     803958 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803847:	8b 50 08             	mov    0x8(%eax),%edx
  80384a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80384d:	8b 40 0c             	mov    0xc(%eax),%eax
  803850:	01 c2                	add    %eax,%edx
  803852:	8b 45 08             	mov    0x8(%ebp),%eax
  803855:	8b 40 08             	mov    0x8(%eax),%eax
  803858:	39 c2                	cmp    %eax,%edx
  80385a:	0f 85 90 00 00 00    	jne    8038f0 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803863:	8b 50 0c             	mov    0xc(%eax),%edx
  803866:	8b 45 08             	mov    0x8(%ebp),%eax
  803869:	8b 40 0c             	mov    0xc(%eax),%eax
  80386c:	01 c2                	add    %eax,%edx
  80386e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803871:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803874:	8b 45 08             	mov    0x8(%ebp),%eax
  803877:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80387e:	8b 45 08             	mov    0x8(%ebp),%eax
  803881:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803888:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80388c:	75 17                	jne    8038a5 <insert_sorted_with_merge_freeList+0x243>
  80388e:	83 ec 04             	sub    $0x4,%esp
  803891:	68 84 4a 80 00       	push   $0x804a84
  803896:	68 49 01 00 00       	push   $0x149
  80389b:	68 a7 4a 80 00       	push   $0x804aa7
  8038a0:	e8 83 d4 ff ff       	call   800d28 <_panic>
  8038a5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ae:	89 10                	mov    %edx,(%eax)
  8038b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b3:	8b 00                	mov    (%eax),%eax
  8038b5:	85 c0                	test   %eax,%eax
  8038b7:	74 0d                	je     8038c6 <insert_sorted_with_merge_freeList+0x264>
  8038b9:	a1 48 51 80 00       	mov    0x805148,%eax
  8038be:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c1:	89 50 04             	mov    %edx,0x4(%eax)
  8038c4:	eb 08                	jmp    8038ce <insert_sorted_with_merge_freeList+0x26c>
  8038c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d1:	a3 48 51 80 00       	mov    %eax,0x805148
  8038d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038e0:	a1 54 51 80 00       	mov    0x805154,%eax
  8038e5:	40                   	inc    %eax
  8038e6:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038eb:	e9 bb 04 00 00       	jmp    803dab <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8038f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038f4:	75 17                	jne    80390d <insert_sorted_with_merge_freeList+0x2ab>
  8038f6:	83 ec 04             	sub    $0x4,%esp
  8038f9:	68 f8 4a 80 00       	push   $0x804af8
  8038fe:	68 4c 01 00 00       	push   $0x14c
  803903:	68 a7 4a 80 00       	push   $0x804aa7
  803908:	e8 1b d4 ff ff       	call   800d28 <_panic>
  80390d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803913:	8b 45 08             	mov    0x8(%ebp),%eax
  803916:	89 50 04             	mov    %edx,0x4(%eax)
  803919:	8b 45 08             	mov    0x8(%ebp),%eax
  80391c:	8b 40 04             	mov    0x4(%eax),%eax
  80391f:	85 c0                	test   %eax,%eax
  803921:	74 0c                	je     80392f <insert_sorted_with_merge_freeList+0x2cd>
  803923:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803928:	8b 55 08             	mov    0x8(%ebp),%edx
  80392b:	89 10                	mov    %edx,(%eax)
  80392d:	eb 08                	jmp    803937 <insert_sorted_with_merge_freeList+0x2d5>
  80392f:	8b 45 08             	mov    0x8(%ebp),%eax
  803932:	a3 38 51 80 00       	mov    %eax,0x805138
  803937:	8b 45 08             	mov    0x8(%ebp),%eax
  80393a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80393f:	8b 45 08             	mov    0x8(%ebp),%eax
  803942:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803948:	a1 44 51 80 00       	mov    0x805144,%eax
  80394d:	40                   	inc    %eax
  80394e:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803953:	e9 53 04 00 00       	jmp    803dab <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803958:	a1 38 51 80 00       	mov    0x805138,%eax
  80395d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803960:	e9 15 04 00 00       	jmp    803d7a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803968:	8b 00                	mov    (%eax),%eax
  80396a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80396d:	8b 45 08             	mov    0x8(%ebp),%eax
  803970:	8b 50 08             	mov    0x8(%eax),%edx
  803973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803976:	8b 40 08             	mov    0x8(%eax),%eax
  803979:	39 c2                	cmp    %eax,%edx
  80397b:	0f 86 f1 03 00 00    	jbe    803d72 <insert_sorted_with_merge_freeList+0x710>
  803981:	8b 45 08             	mov    0x8(%ebp),%eax
  803984:	8b 50 08             	mov    0x8(%eax),%edx
  803987:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398a:	8b 40 08             	mov    0x8(%eax),%eax
  80398d:	39 c2                	cmp    %eax,%edx
  80398f:	0f 83 dd 03 00 00    	jae    803d72 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803998:	8b 50 08             	mov    0x8(%eax),%edx
  80399b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80399e:	8b 40 0c             	mov    0xc(%eax),%eax
  8039a1:	01 c2                	add    %eax,%edx
  8039a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a6:	8b 40 08             	mov    0x8(%eax),%eax
  8039a9:	39 c2                	cmp    %eax,%edx
  8039ab:	0f 85 b9 01 00 00    	jne    803b6a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8039b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b4:	8b 50 08             	mov    0x8(%eax),%edx
  8039b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8039bd:	01 c2                	add    %eax,%edx
  8039bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c2:	8b 40 08             	mov    0x8(%eax),%eax
  8039c5:	39 c2                	cmp    %eax,%edx
  8039c7:	0f 85 0d 01 00 00    	jne    803ada <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8039cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d0:	8b 50 0c             	mov    0xc(%eax),%edx
  8039d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8039d9:	01 c2                	add    %eax,%edx
  8039db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039de:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8039e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8039e5:	75 17                	jne    8039fe <insert_sorted_with_merge_freeList+0x39c>
  8039e7:	83 ec 04             	sub    $0x4,%esp
  8039ea:	68 50 4b 80 00       	push   $0x804b50
  8039ef:	68 5c 01 00 00       	push   $0x15c
  8039f4:	68 a7 4a 80 00       	push   $0x804aa7
  8039f9:	e8 2a d3 ff ff       	call   800d28 <_panic>
  8039fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a01:	8b 00                	mov    (%eax),%eax
  803a03:	85 c0                	test   %eax,%eax
  803a05:	74 10                	je     803a17 <insert_sorted_with_merge_freeList+0x3b5>
  803a07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a0a:	8b 00                	mov    (%eax),%eax
  803a0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a0f:	8b 52 04             	mov    0x4(%edx),%edx
  803a12:	89 50 04             	mov    %edx,0x4(%eax)
  803a15:	eb 0b                	jmp    803a22 <insert_sorted_with_merge_freeList+0x3c0>
  803a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a1a:	8b 40 04             	mov    0x4(%eax),%eax
  803a1d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a25:	8b 40 04             	mov    0x4(%eax),%eax
  803a28:	85 c0                	test   %eax,%eax
  803a2a:	74 0f                	je     803a3b <insert_sorted_with_merge_freeList+0x3d9>
  803a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a2f:	8b 40 04             	mov    0x4(%eax),%eax
  803a32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a35:	8b 12                	mov    (%edx),%edx
  803a37:	89 10                	mov    %edx,(%eax)
  803a39:	eb 0a                	jmp    803a45 <insert_sorted_with_merge_freeList+0x3e3>
  803a3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3e:	8b 00                	mov    (%eax),%eax
  803a40:	a3 38 51 80 00       	mov    %eax,0x805138
  803a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a58:	a1 44 51 80 00       	mov    0x805144,%eax
  803a5d:	48                   	dec    %eax
  803a5e:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803a63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a66:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a7b:	75 17                	jne    803a94 <insert_sorted_with_merge_freeList+0x432>
  803a7d:	83 ec 04             	sub    $0x4,%esp
  803a80:	68 84 4a 80 00       	push   $0x804a84
  803a85:	68 5f 01 00 00       	push   $0x15f
  803a8a:	68 a7 4a 80 00       	push   $0x804aa7
  803a8f:	e8 94 d2 ff ff       	call   800d28 <_panic>
  803a94:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9d:	89 10                	mov    %edx,(%eax)
  803a9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa2:	8b 00                	mov    (%eax),%eax
  803aa4:	85 c0                	test   %eax,%eax
  803aa6:	74 0d                	je     803ab5 <insert_sorted_with_merge_freeList+0x453>
  803aa8:	a1 48 51 80 00       	mov    0x805148,%eax
  803aad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803ab0:	89 50 04             	mov    %edx,0x4(%eax)
  803ab3:	eb 08                	jmp    803abd <insert_sorted_with_merge_freeList+0x45b>
  803ab5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac0:	a3 48 51 80 00       	mov    %eax,0x805148
  803ac5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ac8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803acf:	a1 54 51 80 00       	mov    0x805154,%eax
  803ad4:	40                   	inc    %eax
  803ad5:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803add:	8b 50 0c             	mov    0xc(%eax),%edx
  803ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae3:	8b 40 0c             	mov    0xc(%eax),%eax
  803ae6:	01 c2                	add    %eax,%edx
  803ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aeb:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803aee:	8b 45 08             	mov    0x8(%ebp),%eax
  803af1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803af8:	8b 45 08             	mov    0x8(%ebp),%eax
  803afb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803b02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b06:	75 17                	jne    803b1f <insert_sorted_with_merge_freeList+0x4bd>
  803b08:	83 ec 04             	sub    $0x4,%esp
  803b0b:	68 84 4a 80 00       	push   $0x804a84
  803b10:	68 64 01 00 00       	push   $0x164
  803b15:	68 a7 4a 80 00       	push   $0x804aa7
  803b1a:	e8 09 d2 ff ff       	call   800d28 <_panic>
  803b1f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b25:	8b 45 08             	mov    0x8(%ebp),%eax
  803b28:	89 10                	mov    %edx,(%eax)
  803b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2d:	8b 00                	mov    (%eax),%eax
  803b2f:	85 c0                	test   %eax,%eax
  803b31:	74 0d                	je     803b40 <insert_sorted_with_merge_freeList+0x4de>
  803b33:	a1 48 51 80 00       	mov    0x805148,%eax
  803b38:	8b 55 08             	mov    0x8(%ebp),%edx
  803b3b:	89 50 04             	mov    %edx,0x4(%eax)
  803b3e:	eb 08                	jmp    803b48 <insert_sorted_with_merge_freeList+0x4e6>
  803b40:	8b 45 08             	mov    0x8(%ebp),%eax
  803b43:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b48:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4b:	a3 48 51 80 00       	mov    %eax,0x805148
  803b50:	8b 45 08             	mov    0x8(%ebp),%eax
  803b53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b5a:	a1 54 51 80 00       	mov    0x805154,%eax
  803b5f:	40                   	inc    %eax
  803b60:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803b65:	e9 41 02 00 00       	jmp    803dab <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6d:	8b 50 08             	mov    0x8(%eax),%edx
  803b70:	8b 45 08             	mov    0x8(%ebp),%eax
  803b73:	8b 40 0c             	mov    0xc(%eax),%eax
  803b76:	01 c2                	add    %eax,%edx
  803b78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7b:	8b 40 08             	mov    0x8(%eax),%eax
  803b7e:	39 c2                	cmp    %eax,%edx
  803b80:	0f 85 7c 01 00 00    	jne    803d02 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803b86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b8a:	74 06                	je     803b92 <insert_sorted_with_merge_freeList+0x530>
  803b8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b90:	75 17                	jne    803ba9 <insert_sorted_with_merge_freeList+0x547>
  803b92:	83 ec 04             	sub    $0x4,%esp
  803b95:	68 c0 4a 80 00       	push   $0x804ac0
  803b9a:	68 69 01 00 00       	push   $0x169
  803b9f:	68 a7 4a 80 00       	push   $0x804aa7
  803ba4:	e8 7f d1 ff ff       	call   800d28 <_panic>
  803ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bac:	8b 50 04             	mov    0x4(%eax),%edx
  803baf:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb2:	89 50 04             	mov    %edx,0x4(%eax)
  803bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bbb:	89 10                	mov    %edx,(%eax)
  803bbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc0:	8b 40 04             	mov    0x4(%eax),%eax
  803bc3:	85 c0                	test   %eax,%eax
  803bc5:	74 0d                	je     803bd4 <insert_sorted_with_merge_freeList+0x572>
  803bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bca:	8b 40 04             	mov    0x4(%eax),%eax
  803bcd:	8b 55 08             	mov    0x8(%ebp),%edx
  803bd0:	89 10                	mov    %edx,(%eax)
  803bd2:	eb 08                	jmp    803bdc <insert_sorted_with_merge_freeList+0x57a>
  803bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd7:	a3 38 51 80 00       	mov    %eax,0x805138
  803bdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  803be2:	89 50 04             	mov    %edx,0x4(%eax)
  803be5:	a1 44 51 80 00       	mov    0x805144,%eax
  803bea:	40                   	inc    %eax
  803beb:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf3:	8b 50 0c             	mov    0xc(%eax),%edx
  803bf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf9:	8b 40 0c             	mov    0xc(%eax),%eax
  803bfc:	01 c2                	add    %eax,%edx
  803bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  803c01:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803c04:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c08:	75 17                	jne    803c21 <insert_sorted_with_merge_freeList+0x5bf>
  803c0a:	83 ec 04             	sub    $0x4,%esp
  803c0d:	68 50 4b 80 00       	push   $0x804b50
  803c12:	68 6b 01 00 00       	push   $0x16b
  803c17:	68 a7 4a 80 00       	push   $0x804aa7
  803c1c:	e8 07 d1 ff ff       	call   800d28 <_panic>
  803c21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c24:	8b 00                	mov    (%eax),%eax
  803c26:	85 c0                	test   %eax,%eax
  803c28:	74 10                	je     803c3a <insert_sorted_with_merge_freeList+0x5d8>
  803c2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c2d:	8b 00                	mov    (%eax),%eax
  803c2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c32:	8b 52 04             	mov    0x4(%edx),%edx
  803c35:	89 50 04             	mov    %edx,0x4(%eax)
  803c38:	eb 0b                	jmp    803c45 <insert_sorted_with_merge_freeList+0x5e3>
  803c3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c3d:	8b 40 04             	mov    0x4(%eax),%eax
  803c40:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803c45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c48:	8b 40 04             	mov    0x4(%eax),%eax
  803c4b:	85 c0                	test   %eax,%eax
  803c4d:	74 0f                	je     803c5e <insert_sorted_with_merge_freeList+0x5fc>
  803c4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c52:	8b 40 04             	mov    0x4(%eax),%eax
  803c55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c58:	8b 12                	mov    (%edx),%edx
  803c5a:	89 10                	mov    %edx,(%eax)
  803c5c:	eb 0a                	jmp    803c68 <insert_sorted_with_merge_freeList+0x606>
  803c5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c61:	8b 00                	mov    (%eax),%eax
  803c63:	a3 38 51 80 00       	mov    %eax,0x805138
  803c68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c7b:	a1 44 51 80 00       	mov    0x805144,%eax
  803c80:	48                   	dec    %eax
  803c81:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803c86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c89:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803c90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c93:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803c9a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c9e:	75 17                	jne    803cb7 <insert_sorted_with_merge_freeList+0x655>
  803ca0:	83 ec 04             	sub    $0x4,%esp
  803ca3:	68 84 4a 80 00       	push   $0x804a84
  803ca8:	68 6e 01 00 00       	push   $0x16e
  803cad:	68 a7 4a 80 00       	push   $0x804aa7
  803cb2:	e8 71 d0 ff ff       	call   800d28 <_panic>
  803cb7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803cbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc0:	89 10                	mov    %edx,(%eax)
  803cc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cc5:	8b 00                	mov    (%eax),%eax
  803cc7:	85 c0                	test   %eax,%eax
  803cc9:	74 0d                	je     803cd8 <insert_sorted_with_merge_freeList+0x676>
  803ccb:	a1 48 51 80 00       	mov    0x805148,%eax
  803cd0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cd3:	89 50 04             	mov    %edx,0x4(%eax)
  803cd6:	eb 08                	jmp    803ce0 <insert_sorted_with_merge_freeList+0x67e>
  803cd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cdb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ce0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ce3:	a3 48 51 80 00       	mov    %eax,0x805148
  803ce8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ceb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cf2:	a1 54 51 80 00       	mov    0x805154,%eax
  803cf7:	40                   	inc    %eax
  803cf8:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803cfd:	e9 a9 00 00 00       	jmp    803dab <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803d02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d06:	74 06                	je     803d0e <insert_sorted_with_merge_freeList+0x6ac>
  803d08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d0c:	75 17                	jne    803d25 <insert_sorted_with_merge_freeList+0x6c3>
  803d0e:	83 ec 04             	sub    $0x4,%esp
  803d11:	68 1c 4b 80 00       	push   $0x804b1c
  803d16:	68 73 01 00 00       	push   $0x173
  803d1b:	68 a7 4a 80 00       	push   $0x804aa7
  803d20:	e8 03 d0 ff ff       	call   800d28 <_panic>
  803d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d28:	8b 10                	mov    (%eax),%edx
  803d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d2d:	89 10                	mov    %edx,(%eax)
  803d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803d32:	8b 00                	mov    (%eax),%eax
  803d34:	85 c0                	test   %eax,%eax
  803d36:	74 0b                	je     803d43 <insert_sorted_with_merge_freeList+0x6e1>
  803d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3b:	8b 00                	mov    (%eax),%eax
  803d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  803d40:	89 50 04             	mov    %edx,0x4(%eax)
  803d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d46:	8b 55 08             	mov    0x8(%ebp),%edx
  803d49:	89 10                	mov    %edx,(%eax)
  803d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d51:	89 50 04             	mov    %edx,0x4(%eax)
  803d54:	8b 45 08             	mov    0x8(%ebp),%eax
  803d57:	8b 00                	mov    (%eax),%eax
  803d59:	85 c0                	test   %eax,%eax
  803d5b:	75 08                	jne    803d65 <insert_sorted_with_merge_freeList+0x703>
  803d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d60:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803d65:	a1 44 51 80 00       	mov    0x805144,%eax
  803d6a:	40                   	inc    %eax
  803d6b:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803d70:	eb 39                	jmp    803dab <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803d72:	a1 40 51 80 00       	mov    0x805140,%eax
  803d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d7e:	74 07                	je     803d87 <insert_sorted_with_merge_freeList+0x725>
  803d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d83:	8b 00                	mov    (%eax),%eax
  803d85:	eb 05                	jmp    803d8c <insert_sorted_with_merge_freeList+0x72a>
  803d87:	b8 00 00 00 00       	mov    $0x0,%eax
  803d8c:	a3 40 51 80 00       	mov    %eax,0x805140
  803d91:	a1 40 51 80 00       	mov    0x805140,%eax
  803d96:	85 c0                	test   %eax,%eax
  803d98:	0f 85 c7 fb ff ff    	jne    803965 <insert_sorted_with_merge_freeList+0x303>
  803d9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803da2:	0f 85 bd fb ff ff    	jne    803965 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803da8:	eb 01                	jmp    803dab <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803daa:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803dab:	90                   	nop
  803dac:	c9                   	leave  
  803dad:	c3                   	ret    
  803dae:	66 90                	xchg   %ax,%ax

00803db0 <__udivdi3>:
  803db0:	55                   	push   %ebp
  803db1:	57                   	push   %edi
  803db2:	56                   	push   %esi
  803db3:	53                   	push   %ebx
  803db4:	83 ec 1c             	sub    $0x1c,%esp
  803db7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803dbb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803dbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803dc3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803dc7:	89 ca                	mov    %ecx,%edx
  803dc9:	89 f8                	mov    %edi,%eax
  803dcb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803dcf:	85 f6                	test   %esi,%esi
  803dd1:	75 2d                	jne    803e00 <__udivdi3+0x50>
  803dd3:	39 cf                	cmp    %ecx,%edi
  803dd5:	77 65                	ja     803e3c <__udivdi3+0x8c>
  803dd7:	89 fd                	mov    %edi,%ebp
  803dd9:	85 ff                	test   %edi,%edi
  803ddb:	75 0b                	jne    803de8 <__udivdi3+0x38>
  803ddd:	b8 01 00 00 00       	mov    $0x1,%eax
  803de2:	31 d2                	xor    %edx,%edx
  803de4:	f7 f7                	div    %edi
  803de6:	89 c5                	mov    %eax,%ebp
  803de8:	31 d2                	xor    %edx,%edx
  803dea:	89 c8                	mov    %ecx,%eax
  803dec:	f7 f5                	div    %ebp
  803dee:	89 c1                	mov    %eax,%ecx
  803df0:	89 d8                	mov    %ebx,%eax
  803df2:	f7 f5                	div    %ebp
  803df4:	89 cf                	mov    %ecx,%edi
  803df6:	89 fa                	mov    %edi,%edx
  803df8:	83 c4 1c             	add    $0x1c,%esp
  803dfb:	5b                   	pop    %ebx
  803dfc:	5e                   	pop    %esi
  803dfd:	5f                   	pop    %edi
  803dfe:	5d                   	pop    %ebp
  803dff:	c3                   	ret    
  803e00:	39 ce                	cmp    %ecx,%esi
  803e02:	77 28                	ja     803e2c <__udivdi3+0x7c>
  803e04:	0f bd fe             	bsr    %esi,%edi
  803e07:	83 f7 1f             	xor    $0x1f,%edi
  803e0a:	75 40                	jne    803e4c <__udivdi3+0x9c>
  803e0c:	39 ce                	cmp    %ecx,%esi
  803e0e:	72 0a                	jb     803e1a <__udivdi3+0x6a>
  803e10:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803e14:	0f 87 9e 00 00 00    	ja     803eb8 <__udivdi3+0x108>
  803e1a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e1f:	89 fa                	mov    %edi,%edx
  803e21:	83 c4 1c             	add    $0x1c,%esp
  803e24:	5b                   	pop    %ebx
  803e25:	5e                   	pop    %esi
  803e26:	5f                   	pop    %edi
  803e27:	5d                   	pop    %ebp
  803e28:	c3                   	ret    
  803e29:	8d 76 00             	lea    0x0(%esi),%esi
  803e2c:	31 ff                	xor    %edi,%edi
  803e2e:	31 c0                	xor    %eax,%eax
  803e30:	89 fa                	mov    %edi,%edx
  803e32:	83 c4 1c             	add    $0x1c,%esp
  803e35:	5b                   	pop    %ebx
  803e36:	5e                   	pop    %esi
  803e37:	5f                   	pop    %edi
  803e38:	5d                   	pop    %ebp
  803e39:	c3                   	ret    
  803e3a:	66 90                	xchg   %ax,%ax
  803e3c:	89 d8                	mov    %ebx,%eax
  803e3e:	f7 f7                	div    %edi
  803e40:	31 ff                	xor    %edi,%edi
  803e42:	89 fa                	mov    %edi,%edx
  803e44:	83 c4 1c             	add    $0x1c,%esp
  803e47:	5b                   	pop    %ebx
  803e48:	5e                   	pop    %esi
  803e49:	5f                   	pop    %edi
  803e4a:	5d                   	pop    %ebp
  803e4b:	c3                   	ret    
  803e4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803e51:	89 eb                	mov    %ebp,%ebx
  803e53:	29 fb                	sub    %edi,%ebx
  803e55:	89 f9                	mov    %edi,%ecx
  803e57:	d3 e6                	shl    %cl,%esi
  803e59:	89 c5                	mov    %eax,%ebp
  803e5b:	88 d9                	mov    %bl,%cl
  803e5d:	d3 ed                	shr    %cl,%ebp
  803e5f:	89 e9                	mov    %ebp,%ecx
  803e61:	09 f1                	or     %esi,%ecx
  803e63:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803e67:	89 f9                	mov    %edi,%ecx
  803e69:	d3 e0                	shl    %cl,%eax
  803e6b:	89 c5                	mov    %eax,%ebp
  803e6d:	89 d6                	mov    %edx,%esi
  803e6f:	88 d9                	mov    %bl,%cl
  803e71:	d3 ee                	shr    %cl,%esi
  803e73:	89 f9                	mov    %edi,%ecx
  803e75:	d3 e2                	shl    %cl,%edx
  803e77:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e7b:	88 d9                	mov    %bl,%cl
  803e7d:	d3 e8                	shr    %cl,%eax
  803e7f:	09 c2                	or     %eax,%edx
  803e81:	89 d0                	mov    %edx,%eax
  803e83:	89 f2                	mov    %esi,%edx
  803e85:	f7 74 24 0c          	divl   0xc(%esp)
  803e89:	89 d6                	mov    %edx,%esi
  803e8b:	89 c3                	mov    %eax,%ebx
  803e8d:	f7 e5                	mul    %ebp
  803e8f:	39 d6                	cmp    %edx,%esi
  803e91:	72 19                	jb     803eac <__udivdi3+0xfc>
  803e93:	74 0b                	je     803ea0 <__udivdi3+0xf0>
  803e95:	89 d8                	mov    %ebx,%eax
  803e97:	31 ff                	xor    %edi,%edi
  803e99:	e9 58 ff ff ff       	jmp    803df6 <__udivdi3+0x46>
  803e9e:	66 90                	xchg   %ax,%ax
  803ea0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803ea4:	89 f9                	mov    %edi,%ecx
  803ea6:	d3 e2                	shl    %cl,%edx
  803ea8:	39 c2                	cmp    %eax,%edx
  803eaa:	73 e9                	jae    803e95 <__udivdi3+0xe5>
  803eac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803eaf:	31 ff                	xor    %edi,%edi
  803eb1:	e9 40 ff ff ff       	jmp    803df6 <__udivdi3+0x46>
  803eb6:	66 90                	xchg   %ax,%ax
  803eb8:	31 c0                	xor    %eax,%eax
  803eba:	e9 37 ff ff ff       	jmp    803df6 <__udivdi3+0x46>
  803ebf:	90                   	nop

00803ec0 <__umoddi3>:
  803ec0:	55                   	push   %ebp
  803ec1:	57                   	push   %edi
  803ec2:	56                   	push   %esi
  803ec3:	53                   	push   %ebx
  803ec4:	83 ec 1c             	sub    $0x1c,%esp
  803ec7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803ecb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803ecf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ed3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803ed7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803edb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803edf:	89 f3                	mov    %esi,%ebx
  803ee1:	89 fa                	mov    %edi,%edx
  803ee3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ee7:	89 34 24             	mov    %esi,(%esp)
  803eea:	85 c0                	test   %eax,%eax
  803eec:	75 1a                	jne    803f08 <__umoddi3+0x48>
  803eee:	39 f7                	cmp    %esi,%edi
  803ef0:	0f 86 a2 00 00 00    	jbe    803f98 <__umoddi3+0xd8>
  803ef6:	89 c8                	mov    %ecx,%eax
  803ef8:	89 f2                	mov    %esi,%edx
  803efa:	f7 f7                	div    %edi
  803efc:	89 d0                	mov    %edx,%eax
  803efe:	31 d2                	xor    %edx,%edx
  803f00:	83 c4 1c             	add    $0x1c,%esp
  803f03:	5b                   	pop    %ebx
  803f04:	5e                   	pop    %esi
  803f05:	5f                   	pop    %edi
  803f06:	5d                   	pop    %ebp
  803f07:	c3                   	ret    
  803f08:	39 f0                	cmp    %esi,%eax
  803f0a:	0f 87 ac 00 00 00    	ja     803fbc <__umoddi3+0xfc>
  803f10:	0f bd e8             	bsr    %eax,%ebp
  803f13:	83 f5 1f             	xor    $0x1f,%ebp
  803f16:	0f 84 ac 00 00 00    	je     803fc8 <__umoddi3+0x108>
  803f1c:	bf 20 00 00 00       	mov    $0x20,%edi
  803f21:	29 ef                	sub    %ebp,%edi
  803f23:	89 fe                	mov    %edi,%esi
  803f25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803f29:	89 e9                	mov    %ebp,%ecx
  803f2b:	d3 e0                	shl    %cl,%eax
  803f2d:	89 d7                	mov    %edx,%edi
  803f2f:	89 f1                	mov    %esi,%ecx
  803f31:	d3 ef                	shr    %cl,%edi
  803f33:	09 c7                	or     %eax,%edi
  803f35:	89 e9                	mov    %ebp,%ecx
  803f37:	d3 e2                	shl    %cl,%edx
  803f39:	89 14 24             	mov    %edx,(%esp)
  803f3c:	89 d8                	mov    %ebx,%eax
  803f3e:	d3 e0                	shl    %cl,%eax
  803f40:	89 c2                	mov    %eax,%edx
  803f42:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f46:	d3 e0                	shl    %cl,%eax
  803f48:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f50:	89 f1                	mov    %esi,%ecx
  803f52:	d3 e8                	shr    %cl,%eax
  803f54:	09 d0                	or     %edx,%eax
  803f56:	d3 eb                	shr    %cl,%ebx
  803f58:	89 da                	mov    %ebx,%edx
  803f5a:	f7 f7                	div    %edi
  803f5c:	89 d3                	mov    %edx,%ebx
  803f5e:	f7 24 24             	mull   (%esp)
  803f61:	89 c6                	mov    %eax,%esi
  803f63:	89 d1                	mov    %edx,%ecx
  803f65:	39 d3                	cmp    %edx,%ebx
  803f67:	0f 82 87 00 00 00    	jb     803ff4 <__umoddi3+0x134>
  803f6d:	0f 84 91 00 00 00    	je     804004 <__umoddi3+0x144>
  803f73:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f77:	29 f2                	sub    %esi,%edx
  803f79:	19 cb                	sbb    %ecx,%ebx
  803f7b:	89 d8                	mov    %ebx,%eax
  803f7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f81:	d3 e0                	shl    %cl,%eax
  803f83:	89 e9                	mov    %ebp,%ecx
  803f85:	d3 ea                	shr    %cl,%edx
  803f87:	09 d0                	or     %edx,%eax
  803f89:	89 e9                	mov    %ebp,%ecx
  803f8b:	d3 eb                	shr    %cl,%ebx
  803f8d:	89 da                	mov    %ebx,%edx
  803f8f:	83 c4 1c             	add    $0x1c,%esp
  803f92:	5b                   	pop    %ebx
  803f93:	5e                   	pop    %esi
  803f94:	5f                   	pop    %edi
  803f95:	5d                   	pop    %ebp
  803f96:	c3                   	ret    
  803f97:	90                   	nop
  803f98:	89 fd                	mov    %edi,%ebp
  803f9a:	85 ff                	test   %edi,%edi
  803f9c:	75 0b                	jne    803fa9 <__umoddi3+0xe9>
  803f9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803fa3:	31 d2                	xor    %edx,%edx
  803fa5:	f7 f7                	div    %edi
  803fa7:	89 c5                	mov    %eax,%ebp
  803fa9:	89 f0                	mov    %esi,%eax
  803fab:	31 d2                	xor    %edx,%edx
  803fad:	f7 f5                	div    %ebp
  803faf:	89 c8                	mov    %ecx,%eax
  803fb1:	f7 f5                	div    %ebp
  803fb3:	89 d0                	mov    %edx,%eax
  803fb5:	e9 44 ff ff ff       	jmp    803efe <__umoddi3+0x3e>
  803fba:	66 90                	xchg   %ax,%ax
  803fbc:	89 c8                	mov    %ecx,%eax
  803fbe:	89 f2                	mov    %esi,%edx
  803fc0:	83 c4 1c             	add    $0x1c,%esp
  803fc3:	5b                   	pop    %ebx
  803fc4:	5e                   	pop    %esi
  803fc5:	5f                   	pop    %edi
  803fc6:	5d                   	pop    %ebp
  803fc7:	c3                   	ret    
  803fc8:	3b 04 24             	cmp    (%esp),%eax
  803fcb:	72 06                	jb     803fd3 <__umoddi3+0x113>
  803fcd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803fd1:	77 0f                	ja     803fe2 <__umoddi3+0x122>
  803fd3:	89 f2                	mov    %esi,%edx
  803fd5:	29 f9                	sub    %edi,%ecx
  803fd7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803fdb:	89 14 24             	mov    %edx,(%esp)
  803fde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fe2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803fe6:	8b 14 24             	mov    (%esp),%edx
  803fe9:	83 c4 1c             	add    $0x1c,%esp
  803fec:	5b                   	pop    %ebx
  803fed:	5e                   	pop    %esi
  803fee:	5f                   	pop    %edi
  803fef:	5d                   	pop    %ebp
  803ff0:	c3                   	ret    
  803ff1:	8d 76 00             	lea    0x0(%esi),%esi
  803ff4:	2b 04 24             	sub    (%esp),%eax
  803ff7:	19 fa                	sbb    %edi,%edx
  803ff9:	89 d1                	mov    %edx,%ecx
  803ffb:	89 c6                	mov    %eax,%esi
  803ffd:	e9 71 ff ff ff       	jmp    803f73 <__umoddi3+0xb3>
  804002:	66 90                	xchg   %ax,%ax
  804004:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804008:	72 ea                	jb     803ff4 <__umoddi3+0x134>
  80400a:	89 d9                	mov    %ebx,%ecx
  80400c:	e9 62 ff ff ff       	jmp    803f73 <__umoddi3+0xb3>
