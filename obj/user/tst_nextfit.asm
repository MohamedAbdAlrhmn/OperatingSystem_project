
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
  800056:	e8 3e 26 00 00       	call   802699 <sys_set_uheap_strategy>
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
  8000ac:	68 c0 3f 80 00       	push   $0x803fc0
  8000b1:	6a 18                	push   $0x18
  8000b3:	68 dc 3f 80 00       	push   $0x803fdc
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
  8000e9:	68 ef 3f 80 00       	push   $0x803fef
  8000ee:	68 06 40 80 00       	push   $0x804006
  8000f3:	6a 20                	push   $0x20
  8000f5:	68 dc 3f 80 00       	push   $0x803fdc
  8000fa:	e8 29 0c 00 00       	call   800d28 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 03                	push   $0x3
  800104:	e8 90 25 00 00       	call   802699 <sys_set_uheap_strategy>
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
  80015a:	68 c0 3f 80 00       	push   $0x803fc0
  80015f:	6a 32                	push   $0x32
  800161:	68 dc 3f 80 00       	push   $0x803fdc
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
  8001c9:	68 1c 40 80 00       	push   $0x80401c
  8001ce:	6a 43                	push   $0x43
  8001d0:	68 dc 3f 80 00       	push   $0x803fdc
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
  8001f1:	68 6c 40 80 00       	push   $0x80406c
  8001f6:	e8 e1 0d 00 00       	call   800fdc <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 81 1f 00 00       	call   802184 <sys_calculate_free_frames>
  800203:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 19 20 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  8002ab:	68 bc 40 80 00       	push   $0x8040bc
  8002b0:	6a 5c                	push   $0x5c
  8002b2:	68 dc 3f 80 00       	push   $0x803fdc
  8002b7:	e8 6c 0a 00 00       	call   800d28 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002bc:	e8 63 1f 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  8002df:	68 fa 40 80 00       	push   $0x8040fa
  8002e4:	6a 5e                	push   $0x5e
  8002e6:	68 dc 3f 80 00       	push   $0x803fdc
  8002eb:	e8 38 0a 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  8002f3:	e8 8c 1e 00 00       	call   802184 <sys_calculate_free_frames>
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
  800315:	68 17 41 80 00       	push   $0x804117
  80031a:	6a 5f                	push   $0x5f
  80031c:	68 dc 3f 80 00       	push   $0x803fdc
  800321:	e8 02 0a 00 00       	call   800d28 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  800326:	e8 59 1e 00 00       	call   802184 <sys_calculate_free_frames>
  80032b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80032e:	e8 f1 1e 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  8003ea:	e8 35 1e 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  800416:	68 28 41 80 00       	push   $0x804128
  80041b:	6a 70                	push   $0x70
  80041d:	68 dc 3f 80 00       	push   $0x803fdc
  800422:	e8 01 09 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800427:	e8 58 1d 00 00       	call   802184 <sys_calculate_free_frames>
  80042c:	89 c2                	mov    %eax,%edx
  80042e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800431:	39 c2                	cmp    %eax,%edx
  800433:	74 14                	je     800449 <_main+0x411>
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 64 41 80 00       	push   $0x804164
  80043d:	6a 71                	push   $0x71
  80043f:	68 dc 3f 80 00       	push   $0x803fdc
  800444:	e8 df 08 00 00       	call   800d28 <_panic>

	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  800449:	e8 36 1d 00 00       	call   802184 <sys_calculate_free_frames>
  80044e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800451:	e8 ce 1d 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  80047b:	68 a4 41 80 00       	push   $0x8041a4
  800480:	6a 79                	push   $0x79
  800482:	68 dc 3f 80 00       	push   $0x803fdc
  800487:	e8 9c 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80048c:	e8 93 1d 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  8004ac:	68 fa 40 80 00       	push   $0x8040fa
  8004b1:	6a 7a                	push   $0x7a
  8004b3:	68 dc 3f 80 00       	push   $0x803fdc
  8004b8:	e8 6b 08 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004bd:	e8 c2 1c 00 00       	call   802184 <sys_calculate_free_frames>
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 17 41 80 00       	push   $0x804117
  8004d3:	6a 7b                	push   $0x7b
  8004d5:	68 dc 3f 80 00       	push   $0x803fdc
  8004da:	e8 49 08 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8004df:	e8 a0 1c 00 00       	call   802184 <sys_calculate_free_frames>
  8004e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e7:	e8 38 1d 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  80050e:	68 a4 41 80 00       	push   $0x8041a4
  800513:	68 81 00 00 00       	push   $0x81
  800518:	68 dc 3f 80 00       	push   $0x803fdc
  80051d:	e8 06 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800522:	e8 fd 1c 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  800545:	68 fa 40 80 00       	push   $0x8040fa
  80054a:	68 82 00 00 00       	push   $0x82
  80054f:	68 dc 3f 80 00       	push   $0x803fdc
  800554:	e8 cf 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800559:	e8 26 1c 00 00       	call   802184 <sys_calculate_free_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 17                	je     80057e <_main+0x546>
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 17 41 80 00       	push   $0x804117
  80056f:	68 83 00 00 00       	push   $0x83
  800574:	68 dc 3f 80 00       	push   $0x803fdc
  800579:	e8 aa 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80057e:	e8 01 1c 00 00       	call   802184 <sys_calculate_free_frames>
  800583:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800586:	e8 99 1c 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  8005b4:	68 a4 41 80 00       	push   $0x8041a4
  8005b9:	68 89 00 00 00       	push   $0x89
  8005be:	68 dc 3f 80 00       	push   $0x803fdc
  8005c3:	e8 60 07 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005c8:	e8 57 1c 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  8005ef:	68 fa 40 80 00       	push   $0x8040fa
  8005f4:	68 8a 00 00 00       	push   $0x8a
  8005f9:	68 dc 3f 80 00       	push   $0x803fdc
  8005fe:	e8 25 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800603:	e8 7c 1b 00 00       	call   802184 <sys_calculate_free_frames>
  800608:	89 c2                	mov    %eax,%edx
  80060a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	74 17                	je     800628 <_main+0x5f0>
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	68 17 41 80 00       	push   $0x804117
  800619:	68 8b 00 00 00       	push   $0x8b
  80061e:	68 dc 3f 80 00       	push   $0x803fdc
  800623:	e8 00 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800628:	e8 57 1b 00 00       	call   802184 <sys_calculate_free_frames>
  80062d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800630:	e8 ef 1b 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  800657:	68 a4 41 80 00       	push   $0x8041a4
  80065c:	68 91 00 00 00       	push   $0x91
  800661:	68 dc 3f 80 00       	push   $0x803fdc
  800666:	e8 bd 06 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80066b:	e8 b4 1b 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  80068b:	68 fa 40 80 00       	push   $0x8040fa
  800690:	68 92 00 00 00       	push   $0x92
  800695:	68 dc 3f 80 00       	push   $0x803fdc
  80069a:	e8 89 06 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069f:	e8 e0 1a 00 00       	call   802184 <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 17 41 80 00       	push   $0x804117
  8006b5:	68 93 00 00 00       	push   $0x93
  8006ba:	68 dc 3f 80 00       	push   $0x803fdc
  8006bf:	e8 64 06 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 bb 1a 00 00       	call   802184 <sys_calculate_free_frames>
  8006c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 53 1b 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  8006d4:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	50                   	push   %eax
  8006de:	e8 af 18 00 00       	call   801f92 <free>
  8006e3:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e6:	e8 39 1b 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  800708:	68 28 41 80 00       	push   $0x804128
  80070d:	68 99 00 00 00       	push   $0x99
  800712:	68 dc 3f 80 00       	push   $0x803fdc
  800717:	e8 0c 06 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80071c:	e8 63 1a 00 00       	call   802184 <sys_calculate_free_frames>
  800721:	89 c2                	mov    %eax,%edx
  800723:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800726:	39 c2                	cmp    %eax,%edx
  800728:	74 17                	je     800741 <_main+0x709>
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	68 64 41 80 00       	push   $0x804164
  800732:	68 9a 00 00 00       	push   $0x9a
  800737:	68 dc 3f 80 00       	push   $0x803fdc
  80073c:	e8 e7 05 00 00       	call   800d28 <_panic>

	//[NEXT FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  800741:	e8 3e 1a 00 00       	call   802184 <sys_calculate_free_frames>
  800746:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800749:	e8 d6 1a 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  800770:	68 a4 41 80 00       	push   $0x8041a4
  800775:	68 a1 00 00 00       	push   $0xa1
  80077a:	68 dc 3f 80 00       	push   $0x803fdc
  80077f:	e8 a4 05 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800784:	e8 9b 1a 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  8007a7:	68 fa 40 80 00       	push   $0x8040fa
  8007ac:	68 a2 00 00 00       	push   $0xa2
  8007b1:	68 dc 3f 80 00       	push   $0x803fdc
  8007b6:	e8 6d 05 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007bb:	e8 c4 19 00 00       	call   802184 <sys_calculate_free_frames>
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c5:	39 c2                	cmp    %eax,%edx
  8007c7:	74 17                	je     8007e0 <_main+0x7a8>
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	68 17 41 80 00       	push   $0x804117
  8007d1:	68 a3 00 00 00       	push   $0xa3
  8007d6:	68 dc 3f 80 00       	push   $0x803fdc
  8007db:	e8 48 05 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8007e0:	e8 9f 19 00 00       	call   802184 <sys_calculate_free_frames>
  8007e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e8:	e8 37 1a 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  80081e:	68 a4 41 80 00       	push   $0x8041a4
  800823:	68 a9 00 00 00       	push   $0xa9
  800828:	68 dc 3f 80 00       	push   $0x803fdc
  80082d:	e8 f6 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800832:	e8 ed 19 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  800861:	68 fa 40 80 00       	push   $0x8040fa
  800866:	68 aa 00 00 00       	push   $0xaa
  80086b:	68 dc 3f 80 00       	push   $0x803fdc
  800870:	e8 b3 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800875:	e8 0a 19 00 00       	call   802184 <sys_calculate_free_frames>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	74 17                	je     80089a <_main+0x862>
  800883:	83 ec 04             	sub    $0x4,%esp
  800886:	68 17 41 80 00       	push   $0x804117
  80088b:	68 ab 00 00 00       	push   $0xab
  800890:	68 dc 3f 80 00       	push   $0x803fdc
  800895:	e8 8e 04 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80089a:	e8 e5 18 00 00       	call   802184 <sys_calculate_free_frames>
  80089f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a2:	e8 7d 19 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  8008cc:	68 a4 41 80 00       	push   $0x8041a4
  8008d1:	68 b1 00 00 00       	push   $0xb1
  8008d6:	68 dc 3f 80 00       	push   $0x803fdc
  8008db:	e8 48 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8008e0:	e8 3f 19 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  800903:	68 fa 40 80 00       	push   $0x8040fa
  800908:	68 b2 00 00 00       	push   $0xb2
  80090d:	68 dc 3f 80 00       	push   $0x803fdc
  800912:	e8 11 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800917:	e8 68 18 00 00       	call   802184 <sys_calculate_free_frames>
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	74 17                	je     80093c <_main+0x904>
  800925:	83 ec 04             	sub    $0x4,%esp
  800928:	68 17 41 80 00       	push   $0x804117
  80092d:	68 b3 00 00 00       	push   $0xb3
  800932:	68 dc 3f 80 00       	push   $0x803fdc
  800937:	e8 ec 03 00 00       	call   800d28 <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	68 c4 41 80 00       	push   $0x8041c4
  800944:	e8 93 06 00 00       	call   800fdc <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  80094c:	e8 33 18 00 00       	call   802184 <sys_calculate_free_frames>
  800951:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800954:	e8 cb 18 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  800989:	68 a4 41 80 00       	push   $0x8041a4
  80098e:	68 bc 00 00 00       	push   $0xbc
  800993:	68 dc 3f 80 00       	push   $0x803fdc
  800998:	e8 8b 03 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80099d:	e8 82 18 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  8009cb:	68 fa 40 80 00       	push   $0x8040fa
  8009d0:	68 bd 00 00 00       	push   $0xbd
  8009d5:	68 dc 3f 80 00       	push   $0x803fdc
  8009da:	e8 49 03 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009df:	e8 a0 17 00 00       	call   802184 <sys_calculate_free_frames>
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 17                	je     800a04 <_main+0x9cc>
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 17 41 80 00       	push   $0x804117
  8009f5:	68 be 00 00 00       	push   $0xbe
  8009fa:	68 dc 3f 80 00       	push   $0x803fdc
  8009ff:	e8 24 03 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a04:	e8 7b 17 00 00       	call   802184 <sys_calculate_free_frames>
  800a09:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a0c:	e8 13 18 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
  800a11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  800a14:	8b 85 20 f8 ff ff    	mov    -0x7e0(%ebp),%eax
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	50                   	push   %eax
  800a1e:	e8 6f 15 00 00       	call   801f92 <free>
  800a23:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800a26:	e8 f9 17 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  800a48:	68 28 41 80 00       	push   $0x804128
  800a4d:	68 c4 00 00 00       	push   $0xc4
  800a52:	68 dc 3f 80 00       	push   $0x803fdc
  800a57:	e8 cc 02 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800a5c:	e8 23 17 00 00       	call   802184 <sys_calculate_free_frames>
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a66:	39 c2                	cmp    %eax,%edx
  800a68:	74 17                	je     800a81 <_main+0xa49>
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	68 64 41 80 00       	push   $0x804164
  800a72:	68 c5 00 00 00       	push   $0xc5
  800a77:	68 dc 3f 80 00       	push   $0x803fdc
  800a7c:	e8 a7 02 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a81:	e8 fe 16 00 00       	call   802184 <sys_calculate_free_frames>
  800a86:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a89:	e8 96 17 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  800ab6:	68 a4 41 80 00       	push   $0x8041a4
  800abb:	68 cc 00 00 00       	push   $0xcc
  800ac0:	68 dc 3f 80 00       	push   $0x803fdc
  800ac5:	e8 5e 02 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800aca:	e8 55 17 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  800aed:	68 fa 40 80 00       	push   $0x8040fa
  800af2:	68 cd 00 00 00       	push   $0xcd
  800af7:	68 dc 3f 80 00       	push   $0x803fdc
  800afc:	e8 27 02 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b01:	e8 7e 16 00 00       	call   802184 <sys_calculate_free_frames>
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	74 17                	je     800b26 <_main+0xaee>
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	68 17 41 80 00       	push   $0x804117
  800b17:	68 ce 00 00 00       	push   $0xce
  800b1c:	68 dc 3f 80 00       	push   $0x803fdc
  800b21:	e8 02 02 00 00       	call   800d28 <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	68 00 42 80 00       	push   $0x804200
  800b2e:	e8 a9 04 00 00       	call   800fdc <cprintf>
  800b33:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800b36:	e8 49 16 00 00       	call   802184 <sys_calculate_free_frames>
  800b3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b3e:	e8 e1 16 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
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
  800b6a:	68 a4 41 80 00       	push   $0x8041a4
  800b6f:	68 d7 00 00 00       	push   $0xd7
  800b74:	68 dc 3f 80 00       	push   $0x803fdc
  800b79:	e8 aa 01 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b7e:	e8 a1 16 00 00       	call   802224 <sys_pf_calculate_allocated_pages>
  800b83:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b86:	74 17                	je     800b9f <_main+0xb67>
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	68 fa 40 80 00       	push   $0x8040fa
  800b90:	68 d8 00 00 00       	push   $0xd8
  800b95:	68 dc 3f 80 00       	push   $0x803fdc
  800b9a:	e8 89 01 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b9f:	e8 e0 15 00 00       	call   802184 <sys_calculate_free_frames>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	74 17                	je     800bc4 <_main+0xb8c>
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	68 17 41 80 00       	push   $0x804117
  800bb5:	68 d9 00 00 00       	push   $0xd9
  800bba:	68 dc 3f 80 00       	push   $0x803fdc
  800bbf:	e8 64 01 00 00       	call   800d28 <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	68 38 42 80 00       	push   $0x804238
  800bcc:	e8 0b 04 00 00       	call   800fdc <cprintf>
  800bd1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	68 74 42 80 00       	push   $0x804274
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
  800bf2:	e8 6d 18 00 00       	call   802464 <sys_getenvindex>
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
  800c5d:	e8 0f 16 00 00       	call   802271 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	68 c8 42 80 00       	push   $0x8042c8
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
  800c8d:	68 f0 42 80 00       	push   $0x8042f0
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
  800cbe:	68 18 43 80 00       	push   $0x804318
  800cc3:	e8 14 03 00 00       	call   800fdc <cprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ccb:	a1 20 50 80 00       	mov    0x805020,%eax
  800cd0:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	50                   	push   %eax
  800cda:	68 70 43 80 00       	push   $0x804370
  800cdf:	e8 f8 02 00 00       	call   800fdc <cprintf>
  800ce4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	68 c8 42 80 00       	push   $0x8042c8
  800cef:	e8 e8 02 00 00       	call   800fdc <cprintf>
  800cf4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800cf7:	e8 8f 15 00 00       	call   80228b <sys_enable_interrupt>

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
  800d0f:	e8 1c 17 00 00       	call   802430 <sys_destroy_env>
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
  800d20:	e8 71 17 00 00       	call   802496 <sys_exit_env>
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
  800d49:	68 84 43 80 00       	push   $0x804384
  800d4e:	e8 89 02 00 00       	call   800fdc <cprintf>
  800d53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d56:	a1 00 50 80 00       	mov    0x805000,%eax
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	50                   	push   %eax
  800d62:	68 89 43 80 00       	push   $0x804389
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
  800d86:	68 a5 43 80 00       	push   $0x8043a5
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
  800db2:	68 a8 43 80 00       	push   $0x8043a8
  800db7:	6a 26                	push   $0x26
  800db9:	68 f4 43 80 00       	push   $0x8043f4
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
  800e84:	68 00 44 80 00       	push   $0x804400
  800e89:	6a 3a                	push   $0x3a
  800e8b:	68 f4 43 80 00       	push   $0x8043f4
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
  800ef4:	68 54 44 80 00       	push   $0x804454
  800ef9:	6a 44                	push   $0x44
  800efb:	68 f4 43 80 00       	push   $0x8043f4
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
  800f4e:	e8 70 11 00 00       	call   8020c3 <sys_cputs>
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
  800fc5:	e8 f9 10 00 00       	call   8020c3 <sys_cputs>
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
  80100f:	e8 5d 12 00 00       	call   802271 <sys_disable_interrupt>
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
  80102f:	e8 57 12 00 00       	call   80228b <sys_enable_interrupt>
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
  801079:	e8 ca 2c 00 00       	call   803d48 <__udivdi3>
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
  8010c9:	e8 8a 2d 00 00       	call   803e58 <__umoddi3>
  8010ce:	83 c4 10             	add    $0x10,%esp
  8010d1:	05 b4 46 80 00       	add    $0x8046b4,%eax
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
  801224:	8b 04 85 d8 46 80 00 	mov    0x8046d8(,%eax,4),%eax
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
  801305:	8b 34 9d 20 45 80 00 	mov    0x804520(,%ebx,4),%esi
  80130c:	85 f6                	test   %esi,%esi
  80130e:	75 19                	jne    801329 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801310:	53                   	push   %ebx
  801311:	68 c5 46 80 00       	push   $0x8046c5
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
  80132a:	68 ce 46 80 00       	push   $0x8046ce
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
  801357:	be d1 46 80 00       	mov    $0x8046d1,%esi
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
  801d7d:	68 30 48 80 00       	push   $0x804830
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801e30:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e3f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801e44:	83 ec 04             	sub    $0x4,%esp
  801e47:	6a 03                	push   $0x3
  801e49:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4c:	50                   	push   %eax
  801e4d:	e8 b5 03 00 00       	call   802207 <sys_allocate_chunk>
  801e52:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801e55:	a1 20 51 80 00       	mov    0x805120,%eax
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	50                   	push   %eax
  801e5e:	e8 2a 0a 00 00       	call   80288d <initialize_MemBlocksList>
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
  801e8b:	68 55 48 80 00       	push   $0x804855
  801e90:	6a 33                	push   $0x33
  801e92:	68 73 48 80 00       	push   $0x804873
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
  801f0a:	68 80 48 80 00       	push   $0x804880
  801f0f:	6a 34                	push   $0x34
  801f11:	68 73 48 80 00       	push   $0x804873
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
  801f7f:	68 a4 48 80 00       	push   $0x8048a4
  801f84:	6a 46                	push   $0x46
  801f86:	68 73 48 80 00       	push   $0x804873
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
  801f9b:	68 cc 48 80 00       	push   $0x8048cc
  801fa0:	6a 61                	push   $0x61
  801fa2:	68 73 48 80 00       	push   $0x804873
  801fa7:	e8 7c ed ff ff       	call   800d28 <_panic>

00801fac <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 18             	sub    $0x18,%esp
  801fb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb5:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fb8:	e8 a9 fd ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  801fbd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fc1:	75 07                	jne    801fca <smalloc+0x1e>
  801fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc8:	eb 14                	jmp    801fde <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801fca:	83 ec 04             	sub    $0x4,%esp
  801fcd:	68 f0 48 80 00       	push   $0x8048f0
  801fd2:	6a 76                	push   $0x76
  801fd4:	68 73 48 80 00       	push   $0x804873
  801fd9:	e8 4a ed ff ff       	call   800d28 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fe6:	e8 7b fd ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	68 18 49 80 00       	push   $0x804918
  801ff3:	68 93 00 00 00       	push   $0x93
  801ff8:	68 73 48 80 00       	push   $0x804873
  801ffd:	e8 26 ed ff ff       	call   800d28 <_panic>

00802002 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802008:	e8 59 fd ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	68 3c 49 80 00       	push   $0x80493c
  802015:	68 c5 00 00 00       	push   $0xc5
  80201a:	68 73 48 80 00       	push   $0x804873
  80201f:	e8 04 ed ff ff       	call   800d28 <_panic>

00802024 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	68 64 49 80 00       	push   $0x804964
  802032:	68 d9 00 00 00       	push   $0xd9
  802037:	68 73 48 80 00       	push   $0x804873
  80203c:	e8 e7 ec ff ff       	call   800d28 <_panic>

00802041 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802047:	83 ec 04             	sub    $0x4,%esp
  80204a:	68 88 49 80 00       	push   $0x804988
  80204f:	68 e4 00 00 00       	push   $0xe4
  802054:	68 73 48 80 00       	push   $0x804873
  802059:	e8 ca ec ff ff       	call   800d28 <_panic>

0080205e <shrink>:

}
void shrink(uint32 newSize)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802064:	83 ec 04             	sub    $0x4,%esp
  802067:	68 88 49 80 00       	push   $0x804988
  80206c:	68 e9 00 00 00       	push   $0xe9
  802071:	68 73 48 80 00       	push   $0x804873
  802076:	e8 ad ec ff ff       	call   800d28 <_panic>

0080207b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	68 88 49 80 00       	push   $0x804988
  802089:	68 ee 00 00 00       	push   $0xee
  80208e:	68 73 48 80 00       	push   $0x804873
  802093:	e8 90 ec ff ff       	call   800d28 <_panic>

00802098 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	57                   	push   %edi
  80209c:	56                   	push   %esi
  80209d:	53                   	push   %ebx
  80209e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020aa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ad:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020b0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020b3:	cd 30                	int    $0x30
  8020b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020bb:	83 c4 10             	add    $0x10,%esp
  8020be:	5b                   	pop    %ebx
  8020bf:	5e                   	pop    %esi
  8020c0:	5f                   	pop    %edi
  8020c1:	5d                   	pop    %ebp
  8020c2:	c3                   	ret    

008020c3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 04             	sub    $0x4,%esp
  8020c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020cf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	52                   	push   %edx
  8020db:	ff 75 0c             	pushl  0xc(%ebp)
  8020de:	50                   	push   %eax
  8020df:	6a 00                	push   $0x0
  8020e1:	e8 b2 ff ff ff       	call   802098 <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	90                   	nop
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <sys_cgetc>:

int
sys_cgetc(void)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 01                	push   $0x1
  8020fb:	e8 98 ff ff ff       	call   802098 <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802108:	8b 55 0c             	mov    0xc(%ebp),%edx
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	52                   	push   %edx
  802115:	50                   	push   %eax
  802116:	6a 05                	push   $0x5
  802118:	e8 7b ff ff ff       	call   802098 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	56                   	push   %esi
  802126:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802127:	8b 75 18             	mov    0x18(%ebp),%esi
  80212a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80212d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802130:	8b 55 0c             	mov    0xc(%ebp),%edx
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	56                   	push   %esi
  802137:	53                   	push   %ebx
  802138:	51                   	push   %ecx
  802139:	52                   	push   %edx
  80213a:	50                   	push   %eax
  80213b:	6a 06                	push   $0x6
  80213d:	e8 56 ff ff ff       	call   802098 <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
}
  802145:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802148:	5b                   	pop    %ebx
  802149:	5e                   	pop    %esi
  80214a:	5d                   	pop    %ebp
  80214b:	c3                   	ret    

0080214c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80214f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	52                   	push   %edx
  80215c:	50                   	push   %eax
  80215d:	6a 07                	push   $0x7
  80215f:	e8 34 ff ff ff       	call   802098 <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
}
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	ff 75 0c             	pushl  0xc(%ebp)
  802175:	ff 75 08             	pushl  0x8(%ebp)
  802178:	6a 08                	push   $0x8
  80217a:	e8 19 ff ff ff       	call   802098 <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 09                	push   $0x9
  802193:	e8 00 ff ff ff       	call   802098 <syscall>
  802198:	83 c4 18             	add    $0x18,%esp
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 0a                	push   $0xa
  8021ac:	e8 e7 fe ff ff       	call   802098 <syscall>
  8021b1:	83 c4 18             	add    $0x18,%esp
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 0b                	push   $0xb
  8021c5:	e8 ce fe ff ff       	call   802098 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	ff 75 0c             	pushl  0xc(%ebp)
  8021db:	ff 75 08             	pushl  0x8(%ebp)
  8021de:	6a 0f                	push   $0xf
  8021e0:	e8 b3 fe ff ff       	call   802098 <syscall>
  8021e5:	83 c4 18             	add    $0x18,%esp
	return;
  8021e8:	90                   	nop
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	ff 75 0c             	pushl  0xc(%ebp)
  8021f7:	ff 75 08             	pushl  0x8(%ebp)
  8021fa:	6a 10                	push   $0x10
  8021fc:	e8 97 fe ff ff       	call   802098 <syscall>
  802201:	83 c4 18             	add    $0x18,%esp
	return ;
  802204:	90                   	nop
}
  802205:	c9                   	leave  
  802206:	c3                   	ret    

00802207 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	ff 75 10             	pushl  0x10(%ebp)
  802211:	ff 75 0c             	pushl  0xc(%ebp)
  802214:	ff 75 08             	pushl  0x8(%ebp)
  802217:	6a 11                	push   $0x11
  802219:	e8 7a fe ff ff       	call   802098 <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
	return ;
  802221:	90                   	nop
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 0c                	push   $0xc
  802233:	e8 60 fe ff ff       	call   802098 <syscall>
  802238:	83 c4 18             	add    $0x18,%esp
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	ff 75 08             	pushl  0x8(%ebp)
  80224b:	6a 0d                	push   $0xd
  80224d:	e8 46 fe ff ff       	call   802098 <syscall>
  802252:	83 c4 18             	add    $0x18,%esp
}
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 0e                	push   $0xe
  802266:	e8 2d fe ff ff       	call   802098 <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
}
  80226e:	90                   	nop
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 13                	push   $0x13
  802280:	e8 13 fe ff ff       	call   802098 <syscall>
  802285:	83 c4 18             	add    $0x18,%esp
}
  802288:	90                   	nop
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 14                	push   $0x14
  80229a:	e8 f9 fd ff ff       	call   802098 <syscall>
  80229f:	83 c4 18             	add    $0x18,%esp
}
  8022a2:	90                   	nop
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 04             	sub    $0x4,%esp
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022b1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	50                   	push   %eax
  8022be:	6a 15                	push   $0x15
  8022c0:	e8 d3 fd ff ff       	call   802098 <syscall>
  8022c5:	83 c4 18             	add    $0x18,%esp
}
  8022c8:	90                   	nop
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 16                	push   $0x16
  8022da:	e8 b9 fd ff ff       	call   802098 <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	90                   	nop
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	ff 75 0c             	pushl  0xc(%ebp)
  8022f4:	50                   	push   %eax
  8022f5:	6a 17                	push   $0x17
  8022f7:	e8 9c fd ff ff       	call   802098 <syscall>
  8022fc:	83 c4 18             	add    $0x18,%esp
}
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802304:	8b 55 0c             	mov    0xc(%ebp),%edx
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	52                   	push   %edx
  802311:	50                   	push   %eax
  802312:	6a 1a                	push   $0x1a
  802314:	e8 7f fd ff ff       	call   802098 <syscall>
  802319:	83 c4 18             	add    $0x18,%esp
}
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802321:	8b 55 0c             	mov    0xc(%ebp),%edx
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	52                   	push   %edx
  80232e:	50                   	push   %eax
  80232f:	6a 18                	push   $0x18
  802331:	e8 62 fd ff ff       	call   802098 <syscall>
  802336:	83 c4 18             	add    $0x18,%esp
}
  802339:	90                   	nop
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80233f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	52                   	push   %edx
  80234c:	50                   	push   %eax
  80234d:	6a 19                	push   $0x19
  80234f:	e8 44 fd ff ff       	call   802098 <syscall>
  802354:	83 c4 18             	add    $0x18,%esp
}
  802357:	90                   	nop
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	83 ec 04             	sub    $0x4,%esp
  802360:	8b 45 10             	mov    0x10(%ebp),%eax
  802363:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802366:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802369:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	6a 00                	push   $0x0
  802372:	51                   	push   %ecx
  802373:	52                   	push   %edx
  802374:	ff 75 0c             	pushl  0xc(%ebp)
  802377:	50                   	push   %eax
  802378:	6a 1b                	push   $0x1b
  80237a:	e8 19 fd ff ff       	call   802098 <syscall>
  80237f:	83 c4 18             	add    $0x18,%esp
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802387:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	52                   	push   %edx
  802394:	50                   	push   %eax
  802395:	6a 1c                	push   $0x1c
  802397:	e8 fc fc ff ff       	call   802098 <syscall>
  80239c:	83 c4 18             	add    $0x18,%esp
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	51                   	push   %ecx
  8023b2:	52                   	push   %edx
  8023b3:	50                   	push   %eax
  8023b4:	6a 1d                	push   $0x1d
  8023b6:	e8 dd fc ff ff       	call   802098 <syscall>
  8023bb:	83 c4 18             	add    $0x18,%esp
}
  8023be:	c9                   	leave  
  8023bf:	c3                   	ret    

008023c0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	52                   	push   %edx
  8023d0:	50                   	push   %eax
  8023d1:	6a 1e                	push   $0x1e
  8023d3:	e8 c0 fc ff ff       	call   802098 <syscall>
  8023d8:	83 c4 18             	add    $0x18,%esp
}
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 1f                	push   $0x1f
  8023ec:	e8 a7 fc ff ff       	call   802098 <syscall>
  8023f1:	83 c4 18             	add    $0x18,%esp
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	6a 00                	push   $0x0
  8023fe:	ff 75 14             	pushl  0x14(%ebp)
  802401:	ff 75 10             	pushl  0x10(%ebp)
  802404:	ff 75 0c             	pushl  0xc(%ebp)
  802407:	50                   	push   %eax
  802408:	6a 20                	push   $0x20
  80240a:	e8 89 fc ff ff       	call   802098 <syscall>
  80240f:	83 c4 18             	add    $0x18,%esp
}
  802412:	c9                   	leave  
  802413:	c3                   	ret    

00802414 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802414:	55                   	push   %ebp
  802415:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	6a 00                	push   $0x0
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	50                   	push   %eax
  802423:	6a 21                	push   $0x21
  802425:	e8 6e fc ff ff       	call   802098 <syscall>
  80242a:	83 c4 18             	add    $0x18,%esp
}
  80242d:	90                   	nop
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	50                   	push   %eax
  80243f:	6a 22                	push   $0x22
  802441:	e8 52 fc ff ff       	call   802098 <syscall>
  802446:	83 c4 18             	add    $0x18,%esp
}
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 02                	push   $0x2
  80245a:	e8 39 fc ff ff       	call   802098 <syscall>
  80245f:	83 c4 18             	add    $0x18,%esp
}
  802462:	c9                   	leave  
  802463:	c3                   	ret    

00802464 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802467:	6a 00                	push   $0x0
  802469:	6a 00                	push   $0x0
  80246b:	6a 00                	push   $0x0
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 03                	push   $0x3
  802473:	e8 20 fc ff ff       	call   802098 <syscall>
  802478:	83 c4 18             	add    $0x18,%esp
}
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 04                	push   $0x4
  80248c:	e8 07 fc ff ff       	call   802098 <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <sys_exit_env>:


void sys_exit_env(void)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 23                	push   $0x23
  8024a5:	e8 ee fb ff ff       	call   802098 <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
}
  8024ad:	90                   	nop
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024b6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024b9:	8d 50 04             	lea    0x4(%eax),%edx
  8024bc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	52                   	push   %edx
  8024c6:	50                   	push   %eax
  8024c7:	6a 24                	push   $0x24
  8024c9:	e8 ca fb ff ff       	call   802098 <syscall>
  8024ce:	83 c4 18             	add    $0x18,%esp
	return result;
  8024d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024da:	89 01                	mov    %eax,(%ecx)
  8024dc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024df:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e2:	c9                   	leave  
  8024e3:	c2 04 00             	ret    $0x4

008024e6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	ff 75 10             	pushl  0x10(%ebp)
  8024f0:	ff 75 0c             	pushl  0xc(%ebp)
  8024f3:	ff 75 08             	pushl  0x8(%ebp)
  8024f6:	6a 12                	push   $0x12
  8024f8:	e8 9b fb ff ff       	call   802098 <syscall>
  8024fd:	83 c4 18             	add    $0x18,%esp
	return ;
  802500:	90                   	nop
}
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <sys_rcr2>:
uint32 sys_rcr2()
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802506:	6a 00                	push   $0x0
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 25                	push   $0x25
  802512:	e8 81 fb ff ff       	call   802098 <syscall>
  802517:	83 c4 18             	add    $0x18,%esp
}
  80251a:	c9                   	leave  
  80251b:	c3                   	ret    

0080251c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
  80251f:	83 ec 04             	sub    $0x4,%esp
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802528:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	50                   	push   %eax
  802535:	6a 26                	push   $0x26
  802537:	e8 5c fb ff ff       	call   802098 <syscall>
  80253c:	83 c4 18             	add    $0x18,%esp
	return ;
  80253f:	90                   	nop
}
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <rsttst>:
void rsttst()
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 28                	push   $0x28
  802551:	e8 42 fb ff ff       	call   802098 <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
	return ;
  802559:	90                   	nop
}
  80255a:	c9                   	leave  
  80255b:	c3                   	ret    

0080255c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
  80255f:	83 ec 04             	sub    $0x4,%esp
  802562:	8b 45 14             	mov    0x14(%ebp),%eax
  802565:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802568:	8b 55 18             	mov    0x18(%ebp),%edx
  80256b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80256f:	52                   	push   %edx
  802570:	50                   	push   %eax
  802571:	ff 75 10             	pushl  0x10(%ebp)
  802574:	ff 75 0c             	pushl  0xc(%ebp)
  802577:	ff 75 08             	pushl  0x8(%ebp)
  80257a:	6a 27                	push   $0x27
  80257c:	e8 17 fb ff ff       	call   802098 <syscall>
  802581:	83 c4 18             	add    $0x18,%esp
	return ;
  802584:	90                   	nop
}
  802585:	c9                   	leave  
  802586:	c3                   	ret    

00802587 <chktst>:
void chktst(uint32 n)
{
  802587:	55                   	push   %ebp
  802588:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 00                	push   $0x0
  802590:	6a 00                	push   $0x0
  802592:	ff 75 08             	pushl  0x8(%ebp)
  802595:	6a 29                	push   $0x29
  802597:	e8 fc fa ff ff       	call   802098 <syscall>
  80259c:	83 c4 18             	add    $0x18,%esp
	return ;
  80259f:	90                   	nop
}
  8025a0:	c9                   	leave  
  8025a1:	c3                   	ret    

008025a2 <inctst>:

void inctst()
{
  8025a2:	55                   	push   %ebp
  8025a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 00                	push   $0x0
  8025ad:	6a 00                	push   $0x0
  8025af:	6a 2a                	push   $0x2a
  8025b1:	e8 e2 fa ff ff       	call   802098 <syscall>
  8025b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b9:	90                   	nop
}
  8025ba:	c9                   	leave  
  8025bb:	c3                   	ret    

008025bc <gettst>:
uint32 gettst()
{
  8025bc:	55                   	push   %ebp
  8025bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 2b                	push   $0x2b
  8025cb:	e8 c8 fa ff ff       	call   802098 <syscall>
  8025d0:	83 c4 18             	add    $0x18,%esp
}
  8025d3:	c9                   	leave  
  8025d4:	c3                   	ret    

008025d5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025d5:	55                   	push   %ebp
  8025d6:	89 e5                	mov    %esp,%ebp
  8025d8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 2c                	push   $0x2c
  8025e7:	e8 ac fa ff ff       	call   802098 <syscall>
  8025ec:	83 c4 18             	add    $0x18,%esp
  8025ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025f2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025f6:	75 07                	jne    8025ff <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8025fd:	eb 05                	jmp    802604 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80260c:	6a 00                	push   $0x0
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 2c                	push   $0x2c
  802618:	e8 7b fa ff ff       	call   802098 <syscall>
  80261d:	83 c4 18             	add    $0x18,%esp
  802620:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802623:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802627:	75 07                	jne    802630 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802629:	b8 01 00 00 00       	mov    $0x1,%eax
  80262e:	eb 05                	jmp    802635 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802630:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802635:	c9                   	leave  
  802636:	c3                   	ret    

00802637 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802637:	55                   	push   %ebp
  802638:	89 e5                	mov    %esp,%ebp
  80263a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80263d:	6a 00                	push   $0x0
  80263f:	6a 00                	push   $0x0
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 2c                	push   $0x2c
  802649:	e8 4a fa ff ff       	call   802098 <syscall>
  80264e:	83 c4 18             	add    $0x18,%esp
  802651:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802654:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802658:	75 07                	jne    802661 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80265a:	b8 01 00 00 00       	mov    $0x1,%eax
  80265f:	eb 05                	jmp    802666 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802661:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802666:	c9                   	leave  
  802667:	c3                   	ret    

00802668 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802668:	55                   	push   %ebp
  802669:	89 e5                	mov    %esp,%ebp
  80266b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80266e:	6a 00                	push   $0x0
  802670:	6a 00                	push   $0x0
  802672:	6a 00                	push   $0x0
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 2c                	push   $0x2c
  80267a:	e8 19 fa ff ff       	call   802098 <syscall>
  80267f:	83 c4 18             	add    $0x18,%esp
  802682:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802685:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802689:	75 07                	jne    802692 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80268b:	b8 01 00 00 00       	mov    $0x1,%eax
  802690:	eb 05                	jmp    802697 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802692:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802697:	c9                   	leave  
  802698:	c3                   	ret    

00802699 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802699:	55                   	push   %ebp
  80269a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	ff 75 08             	pushl  0x8(%ebp)
  8026a7:	6a 2d                	push   $0x2d
  8026a9:	e8 ea f9 ff ff       	call   802098 <syscall>
  8026ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b1:	90                   	nop
}
  8026b2:	c9                   	leave  
  8026b3:	c3                   	ret    

008026b4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
  8026b7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	6a 00                	push   $0x0
  8026c6:	53                   	push   %ebx
  8026c7:	51                   	push   %ecx
  8026c8:	52                   	push   %edx
  8026c9:	50                   	push   %eax
  8026ca:	6a 2e                	push   $0x2e
  8026cc:	e8 c7 f9 ff ff       	call   802098 <syscall>
  8026d1:	83 c4 18             	add    $0x18,%esp
}
  8026d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026d7:	c9                   	leave  
  8026d8:	c3                   	ret    

008026d9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026d9:	55                   	push   %ebp
  8026da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026df:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	52                   	push   %edx
  8026e9:	50                   	push   %eax
  8026ea:	6a 2f                	push   $0x2f
  8026ec:	e8 a7 f9 ff ff       	call   802098 <syscall>
  8026f1:	83 c4 18             	add    $0x18,%esp
}
  8026f4:	c9                   	leave  
  8026f5:	c3                   	ret    

008026f6 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
  8026f9:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026fc:	83 ec 0c             	sub    $0xc,%esp
  8026ff:	68 98 49 80 00       	push   $0x804998
  802704:	e8 d3 e8 ff ff       	call   800fdc <cprintf>
  802709:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80270c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802713:	83 ec 0c             	sub    $0xc,%esp
  802716:	68 c4 49 80 00       	push   $0x8049c4
  80271b:	e8 bc e8 ff ff       	call   800fdc <cprintf>
  802720:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802723:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802727:	a1 38 51 80 00       	mov    0x805138,%eax
  80272c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272f:	eb 56                	jmp    802787 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802731:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802735:	74 1c                	je     802753 <print_mem_block_lists+0x5d>
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 50 08             	mov    0x8(%eax),%edx
  80273d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802740:	8b 48 08             	mov    0x8(%eax),%ecx
  802743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802746:	8b 40 0c             	mov    0xc(%eax),%eax
  802749:	01 c8                	add    %ecx,%eax
  80274b:	39 c2                	cmp    %eax,%edx
  80274d:	73 04                	jae    802753 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80274f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 50 08             	mov    0x8(%eax),%edx
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 40 0c             	mov    0xc(%eax),%eax
  80275f:	01 c2                	add    %eax,%edx
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 40 08             	mov    0x8(%eax),%eax
  802767:	83 ec 04             	sub    $0x4,%esp
  80276a:	52                   	push   %edx
  80276b:	50                   	push   %eax
  80276c:	68 d9 49 80 00       	push   $0x8049d9
  802771:	e8 66 e8 ff ff       	call   800fdc <cprintf>
  802776:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80277f:	a1 40 51 80 00       	mov    0x805140,%eax
  802784:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278b:	74 07                	je     802794 <print_mem_block_lists+0x9e>
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 00                	mov    (%eax),%eax
  802792:	eb 05                	jmp    802799 <print_mem_block_lists+0xa3>
  802794:	b8 00 00 00 00       	mov    $0x0,%eax
  802799:	a3 40 51 80 00       	mov    %eax,0x805140
  80279e:	a1 40 51 80 00       	mov    0x805140,%eax
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	75 8a                	jne    802731 <print_mem_block_lists+0x3b>
  8027a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ab:	75 84                	jne    802731 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8027ad:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027b1:	75 10                	jne    8027c3 <print_mem_block_lists+0xcd>
  8027b3:	83 ec 0c             	sub    $0xc,%esp
  8027b6:	68 e8 49 80 00       	push   $0x8049e8
  8027bb:	e8 1c e8 ff ff       	call   800fdc <cprintf>
  8027c0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8027c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8027ca:	83 ec 0c             	sub    $0xc,%esp
  8027cd:	68 0c 4a 80 00       	push   $0x804a0c
  8027d2:	e8 05 e8 ff ff       	call   800fdc <cprintf>
  8027d7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027da:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027de:	a1 40 50 80 00       	mov    0x805040,%eax
  8027e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e6:	eb 56                	jmp    80283e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ec:	74 1c                	je     80280a <print_mem_block_lists+0x114>
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 50 08             	mov    0x8(%eax),%edx
  8027f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f7:	8b 48 08             	mov    0x8(%eax),%ecx
  8027fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802800:	01 c8                	add    %ecx,%eax
  802802:	39 c2                	cmp    %eax,%edx
  802804:	73 04                	jae    80280a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802806:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 50 08             	mov    0x8(%eax),%edx
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 40 0c             	mov    0xc(%eax),%eax
  802816:	01 c2                	add    %eax,%edx
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 40 08             	mov    0x8(%eax),%eax
  80281e:	83 ec 04             	sub    $0x4,%esp
  802821:	52                   	push   %edx
  802822:	50                   	push   %eax
  802823:	68 d9 49 80 00       	push   $0x8049d9
  802828:	e8 af e7 ff ff       	call   800fdc <cprintf>
  80282d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802836:	a1 48 50 80 00       	mov    0x805048,%eax
  80283b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80283e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802842:	74 07                	je     80284b <print_mem_block_lists+0x155>
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	eb 05                	jmp    802850 <print_mem_block_lists+0x15a>
  80284b:	b8 00 00 00 00       	mov    $0x0,%eax
  802850:	a3 48 50 80 00       	mov    %eax,0x805048
  802855:	a1 48 50 80 00       	mov    0x805048,%eax
  80285a:	85 c0                	test   %eax,%eax
  80285c:	75 8a                	jne    8027e8 <print_mem_block_lists+0xf2>
  80285e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802862:	75 84                	jne    8027e8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802864:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802868:	75 10                	jne    80287a <print_mem_block_lists+0x184>
  80286a:	83 ec 0c             	sub    $0xc,%esp
  80286d:	68 24 4a 80 00       	push   $0x804a24
  802872:	e8 65 e7 ff ff       	call   800fdc <cprintf>
  802877:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80287a:	83 ec 0c             	sub    $0xc,%esp
  80287d:	68 98 49 80 00       	push   $0x804998
  802882:	e8 55 e7 ff ff       	call   800fdc <cprintf>
  802887:	83 c4 10             	add    $0x10,%esp

}
  80288a:	90                   	nop
  80288b:	c9                   	leave  
  80288c:	c3                   	ret    

0080288d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80288d:	55                   	push   %ebp
  80288e:	89 e5                	mov    %esp,%ebp
  802890:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802893:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80289a:	00 00 00 
  80289d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8028a4:	00 00 00 
  8028a7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8028ae:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8028b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028b8:	e9 9e 00 00 00       	jmp    80295b <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8028bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8028c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c5:	c1 e2 04             	shl    $0x4,%edx
  8028c8:	01 d0                	add    %edx,%eax
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	75 14                	jne    8028e2 <initialize_MemBlocksList+0x55>
  8028ce:	83 ec 04             	sub    $0x4,%esp
  8028d1:	68 4c 4a 80 00       	push   $0x804a4c
  8028d6:	6a 46                	push   $0x46
  8028d8:	68 6f 4a 80 00       	push   $0x804a6f
  8028dd:	e8 46 e4 ff ff       	call   800d28 <_panic>
  8028e2:	a1 50 50 80 00       	mov    0x805050,%eax
  8028e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ea:	c1 e2 04             	shl    $0x4,%edx
  8028ed:	01 d0                	add    %edx,%eax
  8028ef:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028f5:	89 10                	mov    %edx,(%eax)
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	74 18                	je     802915 <initialize_MemBlocksList+0x88>
  8028fd:	a1 48 51 80 00       	mov    0x805148,%eax
  802902:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802908:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80290b:	c1 e1 04             	shl    $0x4,%ecx
  80290e:	01 ca                	add    %ecx,%edx
  802910:	89 50 04             	mov    %edx,0x4(%eax)
  802913:	eb 12                	jmp    802927 <initialize_MemBlocksList+0x9a>
  802915:	a1 50 50 80 00       	mov    0x805050,%eax
  80291a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291d:	c1 e2 04             	shl    $0x4,%edx
  802920:	01 d0                	add    %edx,%eax
  802922:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802927:	a1 50 50 80 00       	mov    0x805050,%eax
  80292c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292f:	c1 e2 04             	shl    $0x4,%edx
  802932:	01 d0                	add    %edx,%eax
  802934:	a3 48 51 80 00       	mov    %eax,0x805148
  802939:	a1 50 50 80 00       	mov    0x805050,%eax
  80293e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802941:	c1 e2 04             	shl    $0x4,%edx
  802944:	01 d0                	add    %edx,%eax
  802946:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294d:	a1 54 51 80 00       	mov    0x805154,%eax
  802952:	40                   	inc    %eax
  802953:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802958:	ff 45 f4             	incl   -0xc(%ebp)
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802961:	0f 82 56 ff ff ff    	jb     8028bd <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802967:	90                   	nop
  802968:	c9                   	leave  
  802969:	c3                   	ret    

0080296a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
  80296d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802978:	eb 19                	jmp    802993 <find_block+0x29>
	{
		if(va==point->sva)
  80297a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80297d:	8b 40 08             	mov    0x8(%eax),%eax
  802980:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802983:	75 05                	jne    80298a <find_block+0x20>
		   return point;
  802985:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802988:	eb 36                	jmp    8029c0 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	8b 40 08             	mov    0x8(%eax),%eax
  802990:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802993:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802997:	74 07                	je     8029a0 <find_block+0x36>
  802999:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	eb 05                	jmp    8029a5 <find_block+0x3b>
  8029a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a8:	89 42 08             	mov    %eax,0x8(%edx)
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	8b 40 08             	mov    0x8(%eax),%eax
  8029b1:	85 c0                	test   %eax,%eax
  8029b3:	75 c5                	jne    80297a <find_block+0x10>
  8029b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029b9:	75 bf                	jne    80297a <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8029bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c0:	c9                   	leave  
  8029c1:	c3                   	ret    

008029c2 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8029c2:	55                   	push   %ebp
  8029c3:	89 e5                	mov    %esp,%ebp
  8029c5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8029c8:	a1 40 50 80 00       	mov    0x805040,%eax
  8029cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8029d0:	a1 44 50 80 00       	mov    0x805044,%eax
  8029d5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8029d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029de:	74 24                	je     802a04 <insert_sorted_allocList+0x42>
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	8b 50 08             	mov    0x8(%eax),%edx
  8029e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e9:	8b 40 08             	mov    0x8(%eax),%eax
  8029ec:	39 c2                	cmp    %eax,%edx
  8029ee:	76 14                	jbe    802a04 <insert_sorted_allocList+0x42>
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	8b 50 08             	mov    0x8(%eax),%edx
  8029f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f9:	8b 40 08             	mov    0x8(%eax),%eax
  8029fc:	39 c2                	cmp    %eax,%edx
  8029fe:	0f 82 60 01 00 00    	jb     802b64 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802a04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a08:	75 65                	jne    802a6f <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802a0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a0e:	75 14                	jne    802a24 <insert_sorted_allocList+0x62>
  802a10:	83 ec 04             	sub    $0x4,%esp
  802a13:	68 4c 4a 80 00       	push   $0x804a4c
  802a18:	6a 6b                	push   $0x6b
  802a1a:	68 6f 4a 80 00       	push   $0x804a6f
  802a1f:	e8 04 e3 ff ff       	call   800d28 <_panic>
  802a24:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	89 10                	mov    %edx,(%eax)
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	8b 00                	mov    (%eax),%eax
  802a34:	85 c0                	test   %eax,%eax
  802a36:	74 0d                	je     802a45 <insert_sorted_allocList+0x83>
  802a38:	a1 40 50 80 00       	mov    0x805040,%eax
  802a3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a40:	89 50 04             	mov    %edx,0x4(%eax)
  802a43:	eb 08                	jmp    802a4d <insert_sorted_allocList+0x8b>
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	a3 44 50 80 00       	mov    %eax,0x805044
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	a3 40 50 80 00       	mov    %eax,0x805040
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a64:	40                   	inc    %eax
  802a65:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802a6a:	e9 dc 01 00 00       	jmp    802c4b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	8b 50 08             	mov    0x8(%eax),%edx
  802a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a78:	8b 40 08             	mov    0x8(%eax),%eax
  802a7b:	39 c2                	cmp    %eax,%edx
  802a7d:	77 6c                	ja     802aeb <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802a7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a83:	74 06                	je     802a8b <insert_sorted_allocList+0xc9>
  802a85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a89:	75 14                	jne    802a9f <insert_sorted_allocList+0xdd>
  802a8b:	83 ec 04             	sub    $0x4,%esp
  802a8e:	68 88 4a 80 00       	push   $0x804a88
  802a93:	6a 6f                	push   $0x6f
  802a95:	68 6f 4a 80 00       	push   $0x804a6f
  802a9a:	e8 89 e2 ff ff       	call   800d28 <_panic>
  802a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa2:	8b 50 04             	mov    0x4(%eax),%edx
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	89 50 04             	mov    %edx,0x4(%eax)
  802aab:	8b 45 08             	mov    0x8(%ebp),%eax
  802aae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab1:	89 10                	mov    %edx,(%eax)
  802ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	74 0d                	je     802aca <insert_sorted_allocList+0x108>
  802abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac0:	8b 40 04             	mov    0x4(%eax),%eax
  802ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac6:	89 10                	mov    %edx,(%eax)
  802ac8:	eb 08                	jmp    802ad2 <insert_sorted_allocList+0x110>
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	a3 40 50 80 00       	mov    %eax,0x805040
  802ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad8:	89 50 04             	mov    %edx,0x4(%eax)
  802adb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ae0:	40                   	inc    %eax
  802ae1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ae6:	e9 60 01 00 00       	jmp    802c4b <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	8b 50 08             	mov    0x8(%eax),%edx
  802af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af4:	8b 40 08             	mov    0x8(%eax),%eax
  802af7:	39 c2                	cmp    %eax,%edx
  802af9:	0f 82 4c 01 00 00    	jb     802c4b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802aff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b03:	75 14                	jne    802b19 <insert_sorted_allocList+0x157>
  802b05:	83 ec 04             	sub    $0x4,%esp
  802b08:	68 c0 4a 80 00       	push   $0x804ac0
  802b0d:	6a 73                	push   $0x73
  802b0f:	68 6f 4a 80 00       	push   $0x804a6f
  802b14:	e8 0f e2 ff ff       	call   800d28 <_panic>
  802b19:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	89 50 04             	mov    %edx,0x4(%eax)
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	8b 40 04             	mov    0x4(%eax),%eax
  802b2b:	85 c0                	test   %eax,%eax
  802b2d:	74 0c                	je     802b3b <insert_sorted_allocList+0x179>
  802b2f:	a1 44 50 80 00       	mov    0x805044,%eax
  802b34:	8b 55 08             	mov    0x8(%ebp),%edx
  802b37:	89 10                	mov    %edx,(%eax)
  802b39:	eb 08                	jmp    802b43 <insert_sorted_allocList+0x181>
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	a3 40 50 80 00       	mov    %eax,0x805040
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	a3 44 50 80 00       	mov    %eax,0x805044
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b54:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b59:	40                   	inc    %eax
  802b5a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802b5f:	e9 e7 00 00 00       	jmp    802c4b <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802b6a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802b71:	a1 40 50 80 00       	mov    0x805040,%eax
  802b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b79:	e9 9d 00 00 00       	jmp    802c1b <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	8b 50 08             	mov    0x8(%eax),%edx
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 40 08             	mov    0x8(%eax),%eax
  802b92:	39 c2                	cmp    %eax,%edx
  802b94:	76 7d                	jbe    802c13 <insert_sorted_allocList+0x251>
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	8b 50 08             	mov    0x8(%eax),%edx
  802b9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ba2:	39 c2                	cmp    %eax,%edx
  802ba4:	73 6d                	jae    802c13 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802baa:	74 06                	je     802bb2 <insert_sorted_allocList+0x1f0>
  802bac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb0:	75 14                	jne    802bc6 <insert_sorted_allocList+0x204>
  802bb2:	83 ec 04             	sub    $0x4,%esp
  802bb5:	68 e4 4a 80 00       	push   $0x804ae4
  802bba:	6a 7f                	push   $0x7f
  802bbc:	68 6f 4a 80 00       	push   $0x804a6f
  802bc1:	e8 62 e1 ff ff       	call   800d28 <_panic>
  802bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc9:	8b 10                	mov    (%eax),%edx
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	89 10                	mov    %edx,(%eax)
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	74 0b                	je     802be4 <insert_sorted_allocList+0x222>
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	8b 55 08             	mov    0x8(%ebp),%edx
  802be1:	89 50 04             	mov    %edx,0x4(%eax)
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 55 08             	mov    0x8(%ebp),%edx
  802bea:	89 10                	mov    %edx,(%eax)
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf2:	89 50 04             	mov    %edx,0x4(%eax)
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	75 08                	jne    802c06 <insert_sorted_allocList+0x244>
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	a3 44 50 80 00       	mov    %eax,0x805044
  802c06:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c0b:	40                   	inc    %eax
  802c0c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802c11:	eb 39                	jmp    802c4c <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802c13:	a1 48 50 80 00       	mov    0x805048,%eax
  802c18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1f:	74 07                	je     802c28 <insert_sorted_allocList+0x266>
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	eb 05                	jmp    802c2d <insert_sorted_allocList+0x26b>
  802c28:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2d:	a3 48 50 80 00       	mov    %eax,0x805048
  802c32:	a1 48 50 80 00       	mov    0x805048,%eax
  802c37:	85 c0                	test   %eax,%eax
  802c39:	0f 85 3f ff ff ff    	jne    802b7e <insert_sorted_allocList+0x1bc>
  802c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c43:	0f 85 35 ff ff ff    	jne    802b7e <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c49:	eb 01                	jmp    802c4c <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c4b:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802c4c:	90                   	nop
  802c4d:	c9                   	leave  
  802c4e:	c3                   	ret    

00802c4f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c4f:	55                   	push   %ebp
  802c50:	89 e5                	mov    %esp,%ebp
  802c52:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802c55:	a1 38 51 80 00       	mov    0x805138,%eax
  802c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c5d:	e9 85 01 00 00       	jmp    802de7 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 40 0c             	mov    0xc(%eax),%eax
  802c68:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c6b:	0f 82 6e 01 00 00    	jb     802ddf <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	8b 40 0c             	mov    0xc(%eax),%eax
  802c77:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c7a:	0f 85 8a 00 00 00    	jne    802d0a <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802c80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c84:	75 17                	jne    802c9d <alloc_block_FF+0x4e>
  802c86:	83 ec 04             	sub    $0x4,%esp
  802c89:	68 18 4b 80 00       	push   $0x804b18
  802c8e:	68 93 00 00 00       	push   $0x93
  802c93:	68 6f 4a 80 00       	push   $0x804a6f
  802c98:	e8 8b e0 ff ff       	call   800d28 <_panic>
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 00                	mov    (%eax),%eax
  802ca2:	85 c0                	test   %eax,%eax
  802ca4:	74 10                	je     802cb6 <alloc_block_FF+0x67>
  802ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca9:	8b 00                	mov    (%eax),%eax
  802cab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cae:	8b 52 04             	mov    0x4(%edx),%edx
  802cb1:	89 50 04             	mov    %edx,0x4(%eax)
  802cb4:	eb 0b                	jmp    802cc1 <alloc_block_FF+0x72>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 40 04             	mov    0x4(%eax),%eax
  802cbc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 40 04             	mov    0x4(%eax),%eax
  802cc7:	85 c0                	test   %eax,%eax
  802cc9:	74 0f                	je     802cda <alloc_block_FF+0x8b>
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 40 04             	mov    0x4(%eax),%eax
  802cd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd4:	8b 12                	mov    (%edx),%edx
  802cd6:	89 10                	mov    %edx,(%eax)
  802cd8:	eb 0a                	jmp    802ce4 <alloc_block_FF+0x95>
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 00                	mov    (%eax),%eax
  802cdf:	a3 38 51 80 00       	mov    %eax,0x805138
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf7:	a1 44 51 80 00       	mov    0x805144,%eax
  802cfc:	48                   	dec    %eax
  802cfd:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	e9 10 01 00 00       	jmp    802e1a <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d10:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d13:	0f 86 c6 00 00 00    	jbe    802ddf <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d19:	a1 48 51 80 00       	mov    0x805148,%eax
  802d1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	8b 50 08             	mov    0x8(%eax),%edx
  802d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2a:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d30:	8b 55 08             	mov    0x8(%ebp),%edx
  802d33:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d3a:	75 17                	jne    802d53 <alloc_block_FF+0x104>
  802d3c:	83 ec 04             	sub    $0x4,%esp
  802d3f:	68 18 4b 80 00       	push   $0x804b18
  802d44:	68 9b 00 00 00       	push   $0x9b
  802d49:	68 6f 4a 80 00       	push   $0x804a6f
  802d4e:	e8 d5 df ff ff       	call   800d28 <_panic>
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 10                	je     802d6c <alloc_block_FF+0x11d>
  802d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5f:	8b 00                	mov    (%eax),%eax
  802d61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d64:	8b 52 04             	mov    0x4(%edx),%edx
  802d67:	89 50 04             	mov    %edx,0x4(%eax)
  802d6a:	eb 0b                	jmp    802d77 <alloc_block_FF+0x128>
  802d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6f:	8b 40 04             	mov    0x4(%eax),%eax
  802d72:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7a:	8b 40 04             	mov    0x4(%eax),%eax
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	74 0f                	je     802d90 <alloc_block_FF+0x141>
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	8b 40 04             	mov    0x4(%eax),%eax
  802d87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8a:	8b 12                	mov    (%edx),%edx
  802d8c:	89 10                	mov    %edx,(%eax)
  802d8e:	eb 0a                	jmp    802d9a <alloc_block_FF+0x14b>
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	a3 48 51 80 00       	mov    %eax,0x805148
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dad:	a1 54 51 80 00       	mov    0x805154,%eax
  802db2:	48                   	dec    %eax
  802db3:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	8b 50 08             	mov    0x8(%eax),%edx
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	01 c2                	add    %eax,%edx
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcf:	2b 45 08             	sub    0x8(%ebp),%eax
  802dd2:	89 c2                	mov    %eax,%edx
  802dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd7:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddd:	eb 3b                	jmp    802e1a <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802ddf:	a1 40 51 80 00       	mov    0x805140,%eax
  802de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802deb:	74 07                	je     802df4 <alloc_block_FF+0x1a5>
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	eb 05                	jmp    802df9 <alloc_block_FF+0x1aa>
  802df4:	b8 00 00 00 00       	mov    $0x0,%eax
  802df9:	a3 40 51 80 00       	mov    %eax,0x805140
  802dfe:	a1 40 51 80 00       	mov    0x805140,%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	0f 85 57 fe ff ff    	jne    802c62 <alloc_block_FF+0x13>
  802e0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0f:	0f 85 4d fe ff ff    	jne    802c62 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802e15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e1a:	c9                   	leave  
  802e1b:	c3                   	ret    

00802e1c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e1c:	55                   	push   %ebp
  802e1d:	89 e5                	mov    %esp,%ebp
  802e1f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802e22:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802e29:	a1 38 51 80 00       	mov    0x805138,%eax
  802e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e31:	e9 df 00 00 00       	jmp    802f15 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e3f:	0f 82 c8 00 00 00    	jb     802f0d <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e48:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e4e:	0f 85 8a 00 00 00    	jne    802ede <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802e54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e58:	75 17                	jne    802e71 <alloc_block_BF+0x55>
  802e5a:	83 ec 04             	sub    $0x4,%esp
  802e5d:	68 18 4b 80 00       	push   $0x804b18
  802e62:	68 b7 00 00 00       	push   $0xb7
  802e67:	68 6f 4a 80 00       	push   $0x804a6f
  802e6c:	e8 b7 de ff ff       	call   800d28 <_panic>
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	74 10                	je     802e8a <alloc_block_BF+0x6e>
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 00                	mov    (%eax),%eax
  802e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e82:	8b 52 04             	mov    0x4(%edx),%edx
  802e85:	89 50 04             	mov    %edx,0x4(%eax)
  802e88:	eb 0b                	jmp    802e95 <alloc_block_BF+0x79>
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 40 04             	mov    0x4(%eax),%eax
  802e90:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 40 04             	mov    0x4(%eax),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	74 0f                	je     802eae <alloc_block_BF+0x92>
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 40 04             	mov    0x4(%eax),%eax
  802ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea8:	8b 12                	mov    (%edx),%edx
  802eaa:	89 10                	mov    %edx,(%eax)
  802eac:	eb 0a                	jmp    802eb8 <alloc_block_BF+0x9c>
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	8b 00                	mov    (%eax),%eax
  802eb3:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecb:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed0:	48                   	dec    %eax
  802ed1:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	e9 4d 01 00 00       	jmp    80302b <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ee7:	76 24                	jbe    802f0d <alloc_block_BF+0xf1>
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 40 0c             	mov    0xc(%eax),%eax
  802eef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ef2:	73 19                	jae    802f0d <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802ef4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	8b 40 0c             	mov    0xc(%eax),%eax
  802f01:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 40 08             	mov    0x8(%eax),%eax
  802f0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802f0d:	a1 40 51 80 00       	mov    0x805140,%eax
  802f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f19:	74 07                	je     802f22 <alloc_block_BF+0x106>
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 00                	mov    (%eax),%eax
  802f20:	eb 05                	jmp    802f27 <alloc_block_BF+0x10b>
  802f22:	b8 00 00 00 00       	mov    $0x0,%eax
  802f27:	a3 40 51 80 00       	mov    %eax,0x805140
  802f2c:	a1 40 51 80 00       	mov    0x805140,%eax
  802f31:	85 c0                	test   %eax,%eax
  802f33:	0f 85 fd fe ff ff    	jne    802e36 <alloc_block_BF+0x1a>
  802f39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3d:	0f 85 f3 fe ff ff    	jne    802e36 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802f43:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f47:	0f 84 d9 00 00 00    	je     803026 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802f4d:	a1 48 51 80 00       	mov    0x805148,%eax
  802f52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f5b:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f61:	8b 55 08             	mov    0x8(%ebp),%edx
  802f64:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802f67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f6b:	75 17                	jne    802f84 <alloc_block_BF+0x168>
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	68 18 4b 80 00       	push   $0x804b18
  802f75:	68 c7 00 00 00       	push   $0xc7
  802f7a:	68 6f 4a 80 00       	push   $0x804a6f
  802f7f:	e8 a4 dd ff ff       	call   800d28 <_panic>
  802f84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	85 c0                	test   %eax,%eax
  802f8b:	74 10                	je     802f9d <alloc_block_BF+0x181>
  802f8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f95:	8b 52 04             	mov    0x4(%edx),%edx
  802f98:	89 50 04             	mov    %edx,0x4(%eax)
  802f9b:	eb 0b                	jmp    802fa8 <alloc_block_BF+0x18c>
  802f9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa0:	8b 40 04             	mov    0x4(%eax),%eax
  802fa3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 0f                	je     802fc1 <alloc_block_BF+0x1a5>
  802fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb5:	8b 40 04             	mov    0x4(%eax),%eax
  802fb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fbb:	8b 12                	mov    (%edx),%edx
  802fbd:	89 10                	mov    %edx,(%eax)
  802fbf:	eb 0a                	jmp    802fcb <alloc_block_BF+0x1af>
  802fc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	a3 48 51 80 00       	mov    %eax,0x805148
  802fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fde:	a1 54 51 80 00       	mov    0x805154,%eax
  802fe3:	48                   	dec    %eax
  802fe4:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802fe9:	83 ec 08             	sub    $0x8,%esp
  802fec:	ff 75 ec             	pushl  -0x14(%ebp)
  802fef:	68 38 51 80 00       	push   $0x805138
  802ff4:	e8 71 f9 ff ff       	call   80296a <find_block>
  802ff9:	83 c4 10             	add    $0x10,%esp
  802ffc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802fff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803002:	8b 50 08             	mov    0x8(%eax),%edx
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	01 c2                	add    %eax,%edx
  80300a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300d:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803010:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803013:	8b 40 0c             	mov    0xc(%eax),%eax
  803016:	2b 45 08             	sub    0x8(%ebp),%eax
  803019:	89 c2                	mov    %eax,%edx
  80301b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301e:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803021:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803024:	eb 05                	jmp    80302b <alloc_block_BF+0x20f>
	}
	return NULL;
  803026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80302b:	c9                   	leave  
  80302c:	c3                   	ret    

0080302d <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80302d:	55                   	push   %ebp
  80302e:	89 e5                	mov    %esp,%ebp
  803030:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  803033:	a1 28 50 80 00       	mov    0x805028,%eax
  803038:	85 c0                	test   %eax,%eax
  80303a:	0f 85 de 01 00 00    	jne    80321e <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803040:	a1 38 51 80 00       	mov    0x805138,%eax
  803045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803048:	e9 9e 01 00 00       	jmp    8031eb <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	8b 40 0c             	mov    0xc(%eax),%eax
  803053:	3b 45 08             	cmp    0x8(%ebp),%eax
  803056:	0f 82 87 01 00 00    	jb     8031e3 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 40 0c             	mov    0xc(%eax),%eax
  803062:	3b 45 08             	cmp    0x8(%ebp),%eax
  803065:	0f 85 95 00 00 00    	jne    803100 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80306b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80306f:	75 17                	jne    803088 <alloc_block_NF+0x5b>
  803071:	83 ec 04             	sub    $0x4,%esp
  803074:	68 18 4b 80 00       	push   $0x804b18
  803079:	68 e0 00 00 00       	push   $0xe0
  80307e:	68 6f 4a 80 00       	push   $0x804a6f
  803083:	e8 a0 dc ff ff       	call   800d28 <_panic>
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 00                	mov    (%eax),%eax
  80308d:	85 c0                	test   %eax,%eax
  80308f:	74 10                	je     8030a1 <alloc_block_NF+0x74>
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	8b 00                	mov    (%eax),%eax
  803096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803099:	8b 52 04             	mov    0x4(%edx),%edx
  80309c:	89 50 04             	mov    %edx,0x4(%eax)
  80309f:	eb 0b                	jmp    8030ac <alloc_block_NF+0x7f>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 40 04             	mov    0x4(%eax),%eax
  8030a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	74 0f                	je     8030c5 <alloc_block_NF+0x98>
  8030b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b9:	8b 40 04             	mov    0x4(%eax),%eax
  8030bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030bf:	8b 12                	mov    (%edx),%edx
  8030c1:	89 10                	mov    %edx,(%eax)
  8030c3:	eb 0a                	jmp    8030cf <alloc_block_NF+0xa2>
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 00                	mov    (%eax),%eax
  8030ca:	a3 38 51 80 00       	mov    %eax,0x805138
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e7:	48                   	dec    %eax
  8030e8:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	8b 40 08             	mov    0x8(%eax),%eax
  8030f3:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	e9 f8 04 00 00       	jmp    8035f8 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803103:	8b 40 0c             	mov    0xc(%eax),%eax
  803106:	3b 45 08             	cmp    0x8(%ebp),%eax
  803109:	0f 86 d4 00 00 00    	jbe    8031e3 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80310f:	a1 48 51 80 00       	mov    0x805148,%eax
  803114:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	8b 50 08             	mov    0x8(%eax),%edx
  80311d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803120:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  803123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803126:	8b 55 08             	mov    0x8(%ebp),%edx
  803129:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80312c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803130:	75 17                	jne    803149 <alloc_block_NF+0x11c>
  803132:	83 ec 04             	sub    $0x4,%esp
  803135:	68 18 4b 80 00       	push   $0x804b18
  80313a:	68 e9 00 00 00       	push   $0xe9
  80313f:	68 6f 4a 80 00       	push   $0x804a6f
  803144:	e8 df db ff ff       	call   800d28 <_panic>
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	8b 00                	mov    (%eax),%eax
  80314e:	85 c0                	test   %eax,%eax
  803150:	74 10                	je     803162 <alloc_block_NF+0x135>
  803152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80315a:	8b 52 04             	mov    0x4(%edx),%edx
  80315d:	89 50 04             	mov    %edx,0x4(%eax)
  803160:	eb 0b                	jmp    80316d <alloc_block_NF+0x140>
  803162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803165:	8b 40 04             	mov    0x4(%eax),%eax
  803168:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80316d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803170:	8b 40 04             	mov    0x4(%eax),%eax
  803173:	85 c0                	test   %eax,%eax
  803175:	74 0f                	je     803186 <alloc_block_NF+0x159>
  803177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317a:	8b 40 04             	mov    0x4(%eax),%eax
  80317d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803180:	8b 12                	mov    (%edx),%edx
  803182:	89 10                	mov    %edx,(%eax)
  803184:	eb 0a                	jmp    803190 <alloc_block_NF+0x163>
  803186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803189:	8b 00                	mov    (%eax),%eax
  80318b:	a3 48 51 80 00       	mov    %eax,0x805148
  803190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803193:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a3:	a1 54 51 80 00       	mov    0x805154,%eax
  8031a8:	48                   	dec    %eax
  8031a9:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8031ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b1:	8b 40 08             	mov    0x8(%eax),%eax
  8031b4:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8031b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bc:	8b 50 08             	mov    0x8(%eax),%edx
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	01 c2                	add    %eax,%edx
  8031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c7:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8031ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d0:	2b 45 08             	sub    0x8(%ebp),%eax
  8031d3:	89 c2                	mov    %eax,%edx
  8031d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d8:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8031db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031de:	e9 15 04 00 00       	jmp    8035f8 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8031e3:	a1 40 51 80 00       	mov    0x805140,%eax
  8031e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ef:	74 07                	je     8031f8 <alloc_block_NF+0x1cb>
  8031f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f4:	8b 00                	mov    (%eax),%eax
  8031f6:	eb 05                	jmp    8031fd <alloc_block_NF+0x1d0>
  8031f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031fd:	a3 40 51 80 00       	mov    %eax,0x805140
  803202:	a1 40 51 80 00       	mov    0x805140,%eax
  803207:	85 c0                	test   %eax,%eax
  803209:	0f 85 3e fe ff ff    	jne    80304d <alloc_block_NF+0x20>
  80320f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803213:	0f 85 34 fe ff ff    	jne    80304d <alloc_block_NF+0x20>
  803219:	e9 d5 03 00 00       	jmp    8035f3 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80321e:	a1 38 51 80 00       	mov    0x805138,%eax
  803223:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803226:	e9 b1 01 00 00       	jmp    8033dc <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	8b 50 08             	mov    0x8(%eax),%edx
  803231:	a1 28 50 80 00       	mov    0x805028,%eax
  803236:	39 c2                	cmp    %eax,%edx
  803238:	0f 82 96 01 00 00    	jb     8033d4 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80323e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803241:	8b 40 0c             	mov    0xc(%eax),%eax
  803244:	3b 45 08             	cmp    0x8(%ebp),%eax
  803247:	0f 82 87 01 00 00    	jb     8033d4 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 40 0c             	mov    0xc(%eax),%eax
  803253:	3b 45 08             	cmp    0x8(%ebp),%eax
  803256:	0f 85 95 00 00 00    	jne    8032f1 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80325c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803260:	75 17                	jne    803279 <alloc_block_NF+0x24c>
  803262:	83 ec 04             	sub    $0x4,%esp
  803265:	68 18 4b 80 00       	push   $0x804b18
  80326a:	68 fc 00 00 00       	push   $0xfc
  80326f:	68 6f 4a 80 00       	push   $0x804a6f
  803274:	e8 af da ff ff       	call   800d28 <_panic>
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	74 10                	je     803292 <alloc_block_NF+0x265>
  803282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803285:	8b 00                	mov    (%eax),%eax
  803287:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80328a:	8b 52 04             	mov    0x4(%edx),%edx
  80328d:	89 50 04             	mov    %edx,0x4(%eax)
  803290:	eb 0b                	jmp    80329d <alloc_block_NF+0x270>
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	8b 40 04             	mov    0x4(%eax),%eax
  803298:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80329d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a0:	8b 40 04             	mov    0x4(%eax),%eax
  8032a3:	85 c0                	test   %eax,%eax
  8032a5:	74 0f                	je     8032b6 <alloc_block_NF+0x289>
  8032a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032aa:	8b 40 04             	mov    0x4(%eax),%eax
  8032ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b0:	8b 12                	mov    (%edx),%edx
  8032b2:	89 10                	mov    %edx,(%eax)
  8032b4:	eb 0a                	jmp    8032c0 <alloc_block_NF+0x293>
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	8b 00                	mov    (%eax),%eax
  8032bb:	a3 38 51 80 00       	mov    %eax,0x805138
  8032c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d3:	a1 44 51 80 00       	mov    0x805144,%eax
  8032d8:	48                   	dec    %eax
  8032d9:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e1:	8b 40 08             	mov    0x8(%eax),%eax
  8032e4:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ec:	e9 07 03 00 00       	jmp    8035f8 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032fa:	0f 86 d4 00 00 00    	jbe    8033d4 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803300:	a1 48 51 80 00       	mov    0x805148,%eax
  803305:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  803308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330b:	8b 50 08             	mov    0x8(%eax),%edx
  80330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803311:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803314:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803317:	8b 55 08             	mov    0x8(%ebp),%edx
  80331a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80331d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803321:	75 17                	jne    80333a <alloc_block_NF+0x30d>
  803323:	83 ec 04             	sub    $0x4,%esp
  803326:	68 18 4b 80 00       	push   $0x804b18
  80332b:	68 04 01 00 00       	push   $0x104
  803330:	68 6f 4a 80 00       	push   $0x804a6f
  803335:	e8 ee d9 ff ff       	call   800d28 <_panic>
  80333a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333d:	8b 00                	mov    (%eax),%eax
  80333f:	85 c0                	test   %eax,%eax
  803341:	74 10                	je     803353 <alloc_block_NF+0x326>
  803343:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803346:	8b 00                	mov    (%eax),%eax
  803348:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80334b:	8b 52 04             	mov    0x4(%edx),%edx
  80334e:	89 50 04             	mov    %edx,0x4(%eax)
  803351:	eb 0b                	jmp    80335e <alloc_block_NF+0x331>
  803353:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803356:	8b 40 04             	mov    0x4(%eax),%eax
  803359:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80335e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803361:	8b 40 04             	mov    0x4(%eax),%eax
  803364:	85 c0                	test   %eax,%eax
  803366:	74 0f                	je     803377 <alloc_block_NF+0x34a>
  803368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336b:	8b 40 04             	mov    0x4(%eax),%eax
  80336e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803371:	8b 12                	mov    (%edx),%edx
  803373:	89 10                	mov    %edx,(%eax)
  803375:	eb 0a                	jmp    803381 <alloc_block_NF+0x354>
  803377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	a3 48 51 80 00       	mov    %eax,0x805148
  803381:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803384:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803394:	a1 54 51 80 00       	mov    0x805154,%eax
  803399:	48                   	dec    %eax
  80339a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80339f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a2:	8b 40 08             	mov    0x8(%eax),%eax
  8033a5:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8033aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ad:	8b 50 08             	mov    0x8(%eax),%edx
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	01 c2                	add    %eax,%edx
  8033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8033bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033be:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c1:	2b 45 08             	sub    0x8(%ebp),%eax
  8033c4:	89 c2                	mov    %eax,%edx
  8033c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c9:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8033cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cf:	e9 24 02 00 00       	jmp    8035f8 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8033d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8033d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e0:	74 07                	je     8033e9 <alloc_block_NF+0x3bc>
  8033e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e5:	8b 00                	mov    (%eax),%eax
  8033e7:	eb 05                	jmp    8033ee <alloc_block_NF+0x3c1>
  8033e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ee:	a3 40 51 80 00       	mov    %eax,0x805140
  8033f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8033f8:	85 c0                	test   %eax,%eax
  8033fa:	0f 85 2b fe ff ff    	jne    80322b <alloc_block_NF+0x1fe>
  803400:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803404:	0f 85 21 fe ff ff    	jne    80322b <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80340a:	a1 38 51 80 00       	mov    0x805138,%eax
  80340f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803412:	e9 ae 01 00 00       	jmp    8035c5 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  803417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341a:	8b 50 08             	mov    0x8(%eax),%edx
  80341d:	a1 28 50 80 00       	mov    0x805028,%eax
  803422:	39 c2                	cmp    %eax,%edx
  803424:	0f 83 93 01 00 00    	jae    8035bd <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80342a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342d:	8b 40 0c             	mov    0xc(%eax),%eax
  803430:	3b 45 08             	cmp    0x8(%ebp),%eax
  803433:	0f 82 84 01 00 00    	jb     8035bd <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	8b 40 0c             	mov    0xc(%eax),%eax
  80343f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803442:	0f 85 95 00 00 00    	jne    8034dd <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  803448:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80344c:	75 17                	jne    803465 <alloc_block_NF+0x438>
  80344e:	83 ec 04             	sub    $0x4,%esp
  803451:	68 18 4b 80 00       	push   $0x804b18
  803456:	68 14 01 00 00       	push   $0x114
  80345b:	68 6f 4a 80 00       	push   $0x804a6f
  803460:	e8 c3 d8 ff ff       	call   800d28 <_panic>
  803465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803468:	8b 00                	mov    (%eax),%eax
  80346a:	85 c0                	test   %eax,%eax
  80346c:	74 10                	je     80347e <alloc_block_NF+0x451>
  80346e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803471:	8b 00                	mov    (%eax),%eax
  803473:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803476:	8b 52 04             	mov    0x4(%edx),%edx
  803479:	89 50 04             	mov    %edx,0x4(%eax)
  80347c:	eb 0b                	jmp    803489 <alloc_block_NF+0x45c>
  80347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803481:	8b 40 04             	mov    0x4(%eax),%eax
  803484:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348c:	8b 40 04             	mov    0x4(%eax),%eax
  80348f:	85 c0                	test   %eax,%eax
  803491:	74 0f                	je     8034a2 <alloc_block_NF+0x475>
  803493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803496:	8b 40 04             	mov    0x4(%eax),%eax
  803499:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80349c:	8b 12                	mov    (%edx),%edx
  80349e:	89 10                	mov    %edx,(%eax)
  8034a0:	eb 0a                	jmp    8034ac <alloc_block_NF+0x47f>
  8034a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a5:	8b 00                	mov    (%eax),%eax
  8034a7:	a3 38 51 80 00       	mov    %eax,0x805138
  8034ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034bf:	a1 44 51 80 00       	mov    0x805144,%eax
  8034c4:	48                   	dec    %eax
  8034c5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8034ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cd:	8b 40 08             	mov    0x8(%eax),%eax
  8034d0:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d8:	e9 1b 01 00 00       	jmp    8035f8 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8034dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034e6:	0f 86 d1 00 00 00    	jbe    8035bd <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8034ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8034f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8034f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f7:	8b 50 08             	mov    0x8(%eax),%edx
  8034fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fd:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803503:	8b 55 08             	mov    0x8(%ebp),%edx
  803506:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803509:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80350d:	75 17                	jne    803526 <alloc_block_NF+0x4f9>
  80350f:	83 ec 04             	sub    $0x4,%esp
  803512:	68 18 4b 80 00       	push   $0x804b18
  803517:	68 1c 01 00 00       	push   $0x11c
  80351c:	68 6f 4a 80 00       	push   $0x804a6f
  803521:	e8 02 d8 ff ff       	call   800d28 <_panic>
  803526:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803529:	8b 00                	mov    (%eax),%eax
  80352b:	85 c0                	test   %eax,%eax
  80352d:	74 10                	je     80353f <alloc_block_NF+0x512>
  80352f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803532:	8b 00                	mov    (%eax),%eax
  803534:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803537:	8b 52 04             	mov    0x4(%edx),%edx
  80353a:	89 50 04             	mov    %edx,0x4(%eax)
  80353d:	eb 0b                	jmp    80354a <alloc_block_NF+0x51d>
  80353f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803542:	8b 40 04             	mov    0x4(%eax),%eax
  803545:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80354a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80354d:	8b 40 04             	mov    0x4(%eax),%eax
  803550:	85 c0                	test   %eax,%eax
  803552:	74 0f                	je     803563 <alloc_block_NF+0x536>
  803554:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803557:	8b 40 04             	mov    0x4(%eax),%eax
  80355a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80355d:	8b 12                	mov    (%edx),%edx
  80355f:	89 10                	mov    %edx,(%eax)
  803561:	eb 0a                	jmp    80356d <alloc_block_NF+0x540>
  803563:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803566:	8b 00                	mov    (%eax),%eax
  803568:	a3 48 51 80 00       	mov    %eax,0x805148
  80356d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803579:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803580:	a1 54 51 80 00       	mov    0x805154,%eax
  803585:	48                   	dec    %eax
  803586:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80358b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358e:	8b 40 08             	mov    0x8(%eax),%eax
  803591:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  803596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803599:	8b 50 08             	mov    0x8(%eax),%edx
  80359c:	8b 45 08             	mov    0x8(%ebp),%eax
  80359f:	01 c2                	add    %eax,%edx
  8035a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8035a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ad:	2b 45 08             	sub    0x8(%ebp),%eax
  8035b0:	89 c2                	mov    %eax,%edx
  8035b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8035b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035bb:	eb 3b                	jmp    8035f8 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8035bd:	a1 40 51 80 00       	mov    0x805140,%eax
  8035c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035c9:	74 07                	je     8035d2 <alloc_block_NF+0x5a5>
  8035cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ce:	8b 00                	mov    (%eax),%eax
  8035d0:	eb 05                	jmp    8035d7 <alloc_block_NF+0x5aa>
  8035d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8035d7:	a3 40 51 80 00       	mov    %eax,0x805140
  8035dc:	a1 40 51 80 00       	mov    0x805140,%eax
  8035e1:	85 c0                	test   %eax,%eax
  8035e3:	0f 85 2e fe ff ff    	jne    803417 <alloc_block_NF+0x3ea>
  8035e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ed:	0f 85 24 fe ff ff    	jne    803417 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8035f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8035f8:	c9                   	leave  
  8035f9:	c3                   	ret    

008035fa <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8035fa:	55                   	push   %ebp
  8035fb:	89 e5                	mov    %esp,%ebp
  8035fd:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803600:	a1 38 51 80 00       	mov    0x805138,%eax
  803605:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  803608:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80360d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803610:	a1 38 51 80 00       	mov    0x805138,%eax
  803615:	85 c0                	test   %eax,%eax
  803617:	74 14                	je     80362d <insert_sorted_with_merge_freeList+0x33>
  803619:	8b 45 08             	mov    0x8(%ebp),%eax
  80361c:	8b 50 08             	mov    0x8(%eax),%edx
  80361f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803622:	8b 40 08             	mov    0x8(%eax),%eax
  803625:	39 c2                	cmp    %eax,%edx
  803627:	0f 87 9b 01 00 00    	ja     8037c8 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  80362d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803631:	75 17                	jne    80364a <insert_sorted_with_merge_freeList+0x50>
  803633:	83 ec 04             	sub    $0x4,%esp
  803636:	68 4c 4a 80 00       	push   $0x804a4c
  80363b:	68 38 01 00 00       	push   $0x138
  803640:	68 6f 4a 80 00       	push   $0x804a6f
  803645:	e8 de d6 ff ff       	call   800d28 <_panic>
  80364a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803650:	8b 45 08             	mov    0x8(%ebp),%eax
  803653:	89 10                	mov    %edx,(%eax)
  803655:	8b 45 08             	mov    0x8(%ebp),%eax
  803658:	8b 00                	mov    (%eax),%eax
  80365a:	85 c0                	test   %eax,%eax
  80365c:	74 0d                	je     80366b <insert_sorted_with_merge_freeList+0x71>
  80365e:	a1 38 51 80 00       	mov    0x805138,%eax
  803663:	8b 55 08             	mov    0x8(%ebp),%edx
  803666:	89 50 04             	mov    %edx,0x4(%eax)
  803669:	eb 08                	jmp    803673 <insert_sorted_with_merge_freeList+0x79>
  80366b:	8b 45 08             	mov    0x8(%ebp),%eax
  80366e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803673:	8b 45 08             	mov    0x8(%ebp),%eax
  803676:	a3 38 51 80 00       	mov    %eax,0x805138
  80367b:	8b 45 08             	mov    0x8(%ebp),%eax
  80367e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803685:	a1 44 51 80 00       	mov    0x805144,%eax
  80368a:	40                   	inc    %eax
  80368b:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803690:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803694:	0f 84 a8 06 00 00    	je     803d42 <insert_sorted_with_merge_freeList+0x748>
  80369a:	8b 45 08             	mov    0x8(%ebp),%eax
  80369d:	8b 50 08             	mov    0x8(%eax),%edx
  8036a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8036a6:	01 c2                	add    %eax,%edx
  8036a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ab:	8b 40 08             	mov    0x8(%eax),%eax
  8036ae:	39 c2                	cmp    %eax,%edx
  8036b0:	0f 85 8c 06 00 00    	jne    803d42 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8036b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b9:	8b 50 0c             	mov    0xc(%eax),%edx
  8036bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c2:	01 c2                	add    %eax,%edx
  8036c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c7:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  8036ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036ce:	75 17                	jne    8036e7 <insert_sorted_with_merge_freeList+0xed>
  8036d0:	83 ec 04             	sub    $0x4,%esp
  8036d3:	68 18 4b 80 00       	push   $0x804b18
  8036d8:	68 3c 01 00 00       	push   $0x13c
  8036dd:	68 6f 4a 80 00       	push   $0x804a6f
  8036e2:	e8 41 d6 ff ff       	call   800d28 <_panic>
  8036e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ea:	8b 00                	mov    (%eax),%eax
  8036ec:	85 c0                	test   %eax,%eax
  8036ee:	74 10                	je     803700 <insert_sorted_with_merge_freeList+0x106>
  8036f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036f3:	8b 00                	mov    (%eax),%eax
  8036f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036f8:	8b 52 04             	mov    0x4(%edx),%edx
  8036fb:	89 50 04             	mov    %edx,0x4(%eax)
  8036fe:	eb 0b                	jmp    80370b <insert_sorted_with_merge_freeList+0x111>
  803700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803703:	8b 40 04             	mov    0x4(%eax),%eax
  803706:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80370b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370e:	8b 40 04             	mov    0x4(%eax),%eax
  803711:	85 c0                	test   %eax,%eax
  803713:	74 0f                	je     803724 <insert_sorted_with_merge_freeList+0x12a>
  803715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803718:	8b 40 04             	mov    0x4(%eax),%eax
  80371b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80371e:	8b 12                	mov    (%edx),%edx
  803720:	89 10                	mov    %edx,(%eax)
  803722:	eb 0a                	jmp    80372e <insert_sorted_with_merge_freeList+0x134>
  803724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803727:	8b 00                	mov    (%eax),%eax
  803729:	a3 38 51 80 00       	mov    %eax,0x805138
  80372e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803731:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80373a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803741:	a1 44 51 80 00       	mov    0x805144,%eax
  803746:	48                   	dec    %eax
  803747:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  80374c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80374f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  803756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803759:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  803760:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803764:	75 17                	jne    80377d <insert_sorted_with_merge_freeList+0x183>
  803766:	83 ec 04             	sub    $0x4,%esp
  803769:	68 4c 4a 80 00       	push   $0x804a4c
  80376e:	68 3f 01 00 00       	push   $0x13f
  803773:	68 6f 4a 80 00       	push   $0x804a6f
  803778:	e8 ab d5 ff ff       	call   800d28 <_panic>
  80377d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803786:	89 10                	mov    %edx,(%eax)
  803788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80378b:	8b 00                	mov    (%eax),%eax
  80378d:	85 c0                	test   %eax,%eax
  80378f:	74 0d                	je     80379e <insert_sorted_with_merge_freeList+0x1a4>
  803791:	a1 48 51 80 00       	mov    0x805148,%eax
  803796:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803799:	89 50 04             	mov    %edx,0x4(%eax)
  80379c:	eb 08                	jmp    8037a6 <insert_sorted_with_merge_freeList+0x1ac>
  80379e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8037ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8037bd:	40                   	inc    %eax
  8037be:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037c3:	e9 7a 05 00 00       	jmp    803d42 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  8037c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cb:	8b 50 08             	mov    0x8(%eax),%edx
  8037ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037d1:	8b 40 08             	mov    0x8(%eax),%eax
  8037d4:	39 c2                	cmp    %eax,%edx
  8037d6:	0f 82 14 01 00 00    	jb     8038f0 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  8037dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037df:	8b 50 08             	mov    0x8(%eax),%edx
  8037e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e8:	01 c2                	add    %eax,%edx
  8037ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ed:	8b 40 08             	mov    0x8(%eax),%eax
  8037f0:	39 c2                	cmp    %eax,%edx
  8037f2:	0f 85 90 00 00 00    	jne    803888 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  8037f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8037fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803801:	8b 40 0c             	mov    0xc(%eax),%eax
  803804:	01 c2                	add    %eax,%edx
  803806:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803809:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80380c:	8b 45 08             	mov    0x8(%ebp),%eax
  80380f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803816:	8b 45 08             	mov    0x8(%ebp),%eax
  803819:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803824:	75 17                	jne    80383d <insert_sorted_with_merge_freeList+0x243>
  803826:	83 ec 04             	sub    $0x4,%esp
  803829:	68 4c 4a 80 00       	push   $0x804a4c
  80382e:	68 49 01 00 00       	push   $0x149
  803833:	68 6f 4a 80 00       	push   $0x804a6f
  803838:	e8 eb d4 ff ff       	call   800d28 <_panic>
  80383d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803843:	8b 45 08             	mov    0x8(%ebp),%eax
  803846:	89 10                	mov    %edx,(%eax)
  803848:	8b 45 08             	mov    0x8(%ebp),%eax
  80384b:	8b 00                	mov    (%eax),%eax
  80384d:	85 c0                	test   %eax,%eax
  80384f:	74 0d                	je     80385e <insert_sorted_with_merge_freeList+0x264>
  803851:	a1 48 51 80 00       	mov    0x805148,%eax
  803856:	8b 55 08             	mov    0x8(%ebp),%edx
  803859:	89 50 04             	mov    %edx,0x4(%eax)
  80385c:	eb 08                	jmp    803866 <insert_sorted_with_merge_freeList+0x26c>
  80385e:	8b 45 08             	mov    0x8(%ebp),%eax
  803861:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803866:	8b 45 08             	mov    0x8(%ebp),%eax
  803869:	a3 48 51 80 00       	mov    %eax,0x805148
  80386e:	8b 45 08             	mov    0x8(%ebp),%eax
  803871:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803878:	a1 54 51 80 00       	mov    0x805154,%eax
  80387d:	40                   	inc    %eax
  80387e:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803883:	e9 bb 04 00 00       	jmp    803d43 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803888:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80388c:	75 17                	jne    8038a5 <insert_sorted_with_merge_freeList+0x2ab>
  80388e:	83 ec 04             	sub    $0x4,%esp
  803891:	68 c0 4a 80 00       	push   $0x804ac0
  803896:	68 4c 01 00 00       	push   $0x14c
  80389b:	68 6f 4a 80 00       	push   $0x804a6f
  8038a0:	e8 83 d4 ff ff       	call   800d28 <_panic>
  8038a5:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8038ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ae:	89 50 04             	mov    %edx,0x4(%eax)
  8038b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b4:	8b 40 04             	mov    0x4(%eax),%eax
  8038b7:	85 c0                	test   %eax,%eax
  8038b9:	74 0c                	je     8038c7 <insert_sorted_with_merge_freeList+0x2cd>
  8038bb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8038c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8038c3:	89 10                	mov    %edx,(%eax)
  8038c5:	eb 08                	jmp    8038cf <insert_sorted_with_merge_freeList+0x2d5>
  8038c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ca:	a3 38 51 80 00       	mov    %eax,0x805138
  8038cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8038d2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8038d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038e0:	a1 44 51 80 00       	mov    0x805144,%eax
  8038e5:	40                   	inc    %eax
  8038e6:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8038eb:	e9 53 04 00 00       	jmp    803d43 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8038f0:	a1 38 51 80 00       	mov    0x805138,%eax
  8038f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038f8:	e9 15 04 00 00       	jmp    803d12 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803900:	8b 00                	mov    (%eax),%eax
  803902:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803905:	8b 45 08             	mov    0x8(%ebp),%eax
  803908:	8b 50 08             	mov    0x8(%eax),%edx
  80390b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390e:	8b 40 08             	mov    0x8(%eax),%eax
  803911:	39 c2                	cmp    %eax,%edx
  803913:	0f 86 f1 03 00 00    	jbe    803d0a <insert_sorted_with_merge_freeList+0x710>
  803919:	8b 45 08             	mov    0x8(%ebp),%eax
  80391c:	8b 50 08             	mov    0x8(%eax),%edx
  80391f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803922:	8b 40 08             	mov    0x8(%eax),%eax
  803925:	39 c2                	cmp    %eax,%edx
  803927:	0f 83 dd 03 00 00    	jae    803d0a <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80392d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803930:	8b 50 08             	mov    0x8(%eax),%edx
  803933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803936:	8b 40 0c             	mov    0xc(%eax),%eax
  803939:	01 c2                	add    %eax,%edx
  80393b:	8b 45 08             	mov    0x8(%ebp),%eax
  80393e:	8b 40 08             	mov    0x8(%eax),%eax
  803941:	39 c2                	cmp    %eax,%edx
  803943:	0f 85 b9 01 00 00    	jne    803b02 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803949:	8b 45 08             	mov    0x8(%ebp),%eax
  80394c:	8b 50 08             	mov    0x8(%eax),%edx
  80394f:	8b 45 08             	mov    0x8(%ebp),%eax
  803952:	8b 40 0c             	mov    0xc(%eax),%eax
  803955:	01 c2                	add    %eax,%edx
  803957:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80395a:	8b 40 08             	mov    0x8(%eax),%eax
  80395d:	39 c2                	cmp    %eax,%edx
  80395f:	0f 85 0d 01 00 00    	jne    803a72 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803968:	8b 50 0c             	mov    0xc(%eax),%edx
  80396b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396e:	8b 40 0c             	mov    0xc(%eax),%eax
  803971:	01 c2                	add    %eax,%edx
  803973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803976:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803979:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80397d:	75 17                	jne    803996 <insert_sorted_with_merge_freeList+0x39c>
  80397f:	83 ec 04             	sub    $0x4,%esp
  803982:	68 18 4b 80 00       	push   $0x804b18
  803987:	68 5c 01 00 00       	push   $0x15c
  80398c:	68 6f 4a 80 00       	push   $0x804a6f
  803991:	e8 92 d3 ff ff       	call   800d28 <_panic>
  803996:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803999:	8b 00                	mov    (%eax),%eax
  80399b:	85 c0                	test   %eax,%eax
  80399d:	74 10                	je     8039af <insert_sorted_with_merge_freeList+0x3b5>
  80399f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a2:	8b 00                	mov    (%eax),%eax
  8039a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039a7:	8b 52 04             	mov    0x4(%edx),%edx
  8039aa:	89 50 04             	mov    %edx,0x4(%eax)
  8039ad:	eb 0b                	jmp    8039ba <insert_sorted_with_merge_freeList+0x3c0>
  8039af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b2:	8b 40 04             	mov    0x4(%eax),%eax
  8039b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8039ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039bd:	8b 40 04             	mov    0x4(%eax),%eax
  8039c0:	85 c0                	test   %eax,%eax
  8039c2:	74 0f                	je     8039d3 <insert_sorted_with_merge_freeList+0x3d9>
  8039c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c7:	8b 40 04             	mov    0x4(%eax),%eax
  8039ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8039cd:	8b 12                	mov    (%edx),%edx
  8039cf:	89 10                	mov    %edx,(%eax)
  8039d1:	eb 0a                	jmp    8039dd <insert_sorted_with_merge_freeList+0x3e3>
  8039d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d6:	8b 00                	mov    (%eax),%eax
  8039d8:	a3 38 51 80 00       	mov    %eax,0x805138
  8039dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8039f5:	48                   	dec    %eax
  8039f6:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8039fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a08:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803a0f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803a13:	75 17                	jne    803a2c <insert_sorted_with_merge_freeList+0x432>
  803a15:	83 ec 04             	sub    $0x4,%esp
  803a18:	68 4c 4a 80 00       	push   $0x804a4c
  803a1d:	68 5f 01 00 00       	push   $0x15f
  803a22:	68 6f 4a 80 00       	push   $0x804a6f
  803a27:	e8 fc d2 ff ff       	call   800d28 <_panic>
  803a2c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a35:	89 10                	mov    %edx,(%eax)
  803a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a3a:	8b 00                	mov    (%eax),%eax
  803a3c:	85 c0                	test   %eax,%eax
  803a3e:	74 0d                	je     803a4d <insert_sorted_with_merge_freeList+0x453>
  803a40:	a1 48 51 80 00       	mov    0x805148,%eax
  803a45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803a48:	89 50 04             	mov    %edx,0x4(%eax)
  803a4b:	eb 08                	jmp    803a55 <insert_sorted_with_merge_freeList+0x45b>
  803a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a50:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a58:	a3 48 51 80 00       	mov    %eax,0x805148
  803a5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a67:	a1 54 51 80 00       	mov    0x805154,%eax
  803a6c:	40                   	inc    %eax
  803a6d:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a75:	8b 50 0c             	mov    0xc(%eax),%edx
  803a78:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7b:	8b 40 0c             	mov    0xc(%eax),%eax
  803a7e:	01 c2                	add    %eax,%edx
  803a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a83:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803a86:	8b 45 08             	mov    0x8(%ebp),%eax
  803a89:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803a90:	8b 45 08             	mov    0x8(%ebp),%eax
  803a93:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a9e:	75 17                	jne    803ab7 <insert_sorted_with_merge_freeList+0x4bd>
  803aa0:	83 ec 04             	sub    $0x4,%esp
  803aa3:	68 4c 4a 80 00       	push   $0x804a4c
  803aa8:	68 64 01 00 00       	push   $0x164
  803aad:	68 6f 4a 80 00       	push   $0x804a6f
  803ab2:	e8 71 d2 ff ff       	call   800d28 <_panic>
  803ab7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803abd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac0:	89 10                	mov    %edx,(%eax)
  803ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac5:	8b 00                	mov    (%eax),%eax
  803ac7:	85 c0                	test   %eax,%eax
  803ac9:	74 0d                	je     803ad8 <insert_sorted_with_merge_freeList+0x4de>
  803acb:	a1 48 51 80 00       	mov    0x805148,%eax
  803ad0:	8b 55 08             	mov    0x8(%ebp),%edx
  803ad3:	89 50 04             	mov    %edx,0x4(%eax)
  803ad6:	eb 08                	jmp    803ae0 <insert_sorted_with_merge_freeList+0x4e6>
  803ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  803adb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae3:	a3 48 51 80 00       	mov    %eax,0x805148
  803ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  803aeb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803af2:	a1 54 51 80 00       	mov    0x805154,%eax
  803af7:	40                   	inc    %eax
  803af8:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803afd:	e9 41 02 00 00       	jmp    803d43 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803b02:	8b 45 08             	mov    0x8(%ebp),%eax
  803b05:	8b 50 08             	mov    0x8(%eax),%edx
  803b08:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0b:	8b 40 0c             	mov    0xc(%eax),%eax
  803b0e:	01 c2                	add    %eax,%edx
  803b10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b13:	8b 40 08             	mov    0x8(%eax),%eax
  803b16:	39 c2                	cmp    %eax,%edx
  803b18:	0f 85 7c 01 00 00    	jne    803c9a <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803b1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b22:	74 06                	je     803b2a <insert_sorted_with_merge_freeList+0x530>
  803b24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b28:	75 17                	jne    803b41 <insert_sorted_with_merge_freeList+0x547>
  803b2a:	83 ec 04             	sub    $0x4,%esp
  803b2d:	68 88 4a 80 00       	push   $0x804a88
  803b32:	68 69 01 00 00       	push   $0x169
  803b37:	68 6f 4a 80 00       	push   $0x804a6f
  803b3c:	e8 e7 d1 ff ff       	call   800d28 <_panic>
  803b41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b44:	8b 50 04             	mov    0x4(%eax),%edx
  803b47:	8b 45 08             	mov    0x8(%ebp),%eax
  803b4a:	89 50 04             	mov    %edx,0x4(%eax)
  803b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  803b50:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b53:	89 10                	mov    %edx,(%eax)
  803b55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b58:	8b 40 04             	mov    0x4(%eax),%eax
  803b5b:	85 c0                	test   %eax,%eax
  803b5d:	74 0d                	je     803b6c <insert_sorted_with_merge_freeList+0x572>
  803b5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b62:	8b 40 04             	mov    0x4(%eax),%eax
  803b65:	8b 55 08             	mov    0x8(%ebp),%edx
  803b68:	89 10                	mov    %edx,(%eax)
  803b6a:	eb 08                	jmp    803b74 <insert_sorted_with_merge_freeList+0x57a>
  803b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6f:	a3 38 51 80 00       	mov    %eax,0x805138
  803b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b77:	8b 55 08             	mov    0x8(%ebp),%edx
  803b7a:	89 50 04             	mov    %edx,0x4(%eax)
  803b7d:	a1 44 51 80 00       	mov    0x805144,%eax
  803b82:	40                   	inc    %eax
  803b83:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803b88:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8b:	8b 50 0c             	mov    0xc(%eax),%edx
  803b8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b91:	8b 40 0c             	mov    0xc(%eax),%eax
  803b94:	01 c2                	add    %eax,%edx
  803b96:	8b 45 08             	mov    0x8(%ebp),%eax
  803b99:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803b9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ba0:	75 17                	jne    803bb9 <insert_sorted_with_merge_freeList+0x5bf>
  803ba2:	83 ec 04             	sub    $0x4,%esp
  803ba5:	68 18 4b 80 00       	push   $0x804b18
  803baa:	68 6b 01 00 00       	push   $0x16b
  803baf:	68 6f 4a 80 00       	push   $0x804a6f
  803bb4:	e8 6f d1 ff ff       	call   800d28 <_panic>
  803bb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bbc:	8b 00                	mov    (%eax),%eax
  803bbe:	85 c0                	test   %eax,%eax
  803bc0:	74 10                	je     803bd2 <insert_sorted_with_merge_freeList+0x5d8>
  803bc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bc5:	8b 00                	mov    (%eax),%eax
  803bc7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bca:	8b 52 04             	mov    0x4(%edx),%edx
  803bcd:	89 50 04             	mov    %edx,0x4(%eax)
  803bd0:	eb 0b                	jmp    803bdd <insert_sorted_with_merge_freeList+0x5e3>
  803bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bd5:	8b 40 04             	mov    0x4(%eax),%eax
  803bd8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803bdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803be0:	8b 40 04             	mov    0x4(%eax),%eax
  803be3:	85 c0                	test   %eax,%eax
  803be5:	74 0f                	je     803bf6 <insert_sorted_with_merge_freeList+0x5fc>
  803be7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bea:	8b 40 04             	mov    0x4(%eax),%eax
  803bed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803bf0:	8b 12                	mov    (%edx),%edx
  803bf2:	89 10                	mov    %edx,(%eax)
  803bf4:	eb 0a                	jmp    803c00 <insert_sorted_with_merge_freeList+0x606>
  803bf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803bf9:	8b 00                	mov    (%eax),%eax
  803bfb:	a3 38 51 80 00       	mov    %eax,0x805138
  803c00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c13:	a1 44 51 80 00       	mov    0x805144,%eax
  803c18:	48                   	dec    %eax
  803c19:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803c1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c2b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803c32:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c36:	75 17                	jne    803c4f <insert_sorted_with_merge_freeList+0x655>
  803c38:	83 ec 04             	sub    $0x4,%esp
  803c3b:	68 4c 4a 80 00       	push   $0x804a4c
  803c40:	68 6e 01 00 00       	push   $0x16e
  803c45:	68 6f 4a 80 00       	push   $0x804a6f
  803c4a:	e8 d9 d0 ff ff       	call   800d28 <_panic>
  803c4f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c58:	89 10                	mov    %edx,(%eax)
  803c5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5d:	8b 00                	mov    (%eax),%eax
  803c5f:	85 c0                	test   %eax,%eax
  803c61:	74 0d                	je     803c70 <insert_sorted_with_merge_freeList+0x676>
  803c63:	a1 48 51 80 00       	mov    0x805148,%eax
  803c68:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c6b:	89 50 04             	mov    %edx,0x4(%eax)
  803c6e:	eb 08                	jmp    803c78 <insert_sorted_with_merge_freeList+0x67e>
  803c70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c73:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c7b:	a3 48 51 80 00       	mov    %eax,0x805148
  803c80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c8a:	a1 54 51 80 00       	mov    0x805154,%eax
  803c8f:	40                   	inc    %eax
  803c90:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c95:	e9 a9 00 00 00       	jmp    803d43 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803c9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c9e:	74 06                	je     803ca6 <insert_sorted_with_merge_freeList+0x6ac>
  803ca0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ca4:	75 17                	jne    803cbd <insert_sorted_with_merge_freeList+0x6c3>
  803ca6:	83 ec 04             	sub    $0x4,%esp
  803ca9:	68 e4 4a 80 00       	push   $0x804ae4
  803cae:	68 73 01 00 00       	push   $0x173
  803cb3:	68 6f 4a 80 00       	push   $0x804a6f
  803cb8:	e8 6b d0 ff ff       	call   800d28 <_panic>
  803cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc0:	8b 10                	mov    (%eax),%edx
  803cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc5:	89 10                	mov    %edx,(%eax)
  803cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  803cca:	8b 00                	mov    (%eax),%eax
  803ccc:	85 c0                	test   %eax,%eax
  803cce:	74 0b                	je     803cdb <insert_sorted_with_merge_freeList+0x6e1>
  803cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd3:	8b 00                	mov    (%eax),%eax
  803cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  803cd8:	89 50 04             	mov    %edx,0x4(%eax)
  803cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cde:	8b 55 08             	mov    0x8(%ebp),%edx
  803ce1:	89 10                	mov    %edx,(%eax)
  803ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ce9:	89 50 04             	mov    %edx,0x4(%eax)
  803cec:	8b 45 08             	mov    0x8(%ebp),%eax
  803cef:	8b 00                	mov    (%eax),%eax
  803cf1:	85 c0                	test   %eax,%eax
  803cf3:	75 08                	jne    803cfd <insert_sorted_with_merge_freeList+0x703>
  803cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803cfd:	a1 44 51 80 00       	mov    0x805144,%eax
  803d02:	40                   	inc    %eax
  803d03:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803d08:	eb 39                	jmp    803d43 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803d0a:	a1 40 51 80 00       	mov    0x805140,%eax
  803d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d16:	74 07                	je     803d1f <insert_sorted_with_merge_freeList+0x725>
  803d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d1b:	8b 00                	mov    (%eax),%eax
  803d1d:	eb 05                	jmp    803d24 <insert_sorted_with_merge_freeList+0x72a>
  803d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  803d24:	a3 40 51 80 00       	mov    %eax,0x805140
  803d29:	a1 40 51 80 00       	mov    0x805140,%eax
  803d2e:	85 c0                	test   %eax,%eax
  803d30:	0f 85 c7 fb ff ff    	jne    8038fd <insert_sorted_with_merge_freeList+0x303>
  803d36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d3a:	0f 85 bd fb ff ff    	jne    8038fd <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d40:	eb 01                	jmp    803d43 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803d42:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803d43:	90                   	nop
  803d44:	c9                   	leave  
  803d45:	c3                   	ret    
  803d46:	66 90                	xchg   %ax,%ax

00803d48 <__udivdi3>:
  803d48:	55                   	push   %ebp
  803d49:	57                   	push   %edi
  803d4a:	56                   	push   %esi
  803d4b:	53                   	push   %ebx
  803d4c:	83 ec 1c             	sub    $0x1c,%esp
  803d4f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803d53:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803d57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d5b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d5f:	89 ca                	mov    %ecx,%edx
  803d61:	89 f8                	mov    %edi,%eax
  803d63:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803d67:	85 f6                	test   %esi,%esi
  803d69:	75 2d                	jne    803d98 <__udivdi3+0x50>
  803d6b:	39 cf                	cmp    %ecx,%edi
  803d6d:	77 65                	ja     803dd4 <__udivdi3+0x8c>
  803d6f:	89 fd                	mov    %edi,%ebp
  803d71:	85 ff                	test   %edi,%edi
  803d73:	75 0b                	jne    803d80 <__udivdi3+0x38>
  803d75:	b8 01 00 00 00       	mov    $0x1,%eax
  803d7a:	31 d2                	xor    %edx,%edx
  803d7c:	f7 f7                	div    %edi
  803d7e:	89 c5                	mov    %eax,%ebp
  803d80:	31 d2                	xor    %edx,%edx
  803d82:	89 c8                	mov    %ecx,%eax
  803d84:	f7 f5                	div    %ebp
  803d86:	89 c1                	mov    %eax,%ecx
  803d88:	89 d8                	mov    %ebx,%eax
  803d8a:	f7 f5                	div    %ebp
  803d8c:	89 cf                	mov    %ecx,%edi
  803d8e:	89 fa                	mov    %edi,%edx
  803d90:	83 c4 1c             	add    $0x1c,%esp
  803d93:	5b                   	pop    %ebx
  803d94:	5e                   	pop    %esi
  803d95:	5f                   	pop    %edi
  803d96:	5d                   	pop    %ebp
  803d97:	c3                   	ret    
  803d98:	39 ce                	cmp    %ecx,%esi
  803d9a:	77 28                	ja     803dc4 <__udivdi3+0x7c>
  803d9c:	0f bd fe             	bsr    %esi,%edi
  803d9f:	83 f7 1f             	xor    $0x1f,%edi
  803da2:	75 40                	jne    803de4 <__udivdi3+0x9c>
  803da4:	39 ce                	cmp    %ecx,%esi
  803da6:	72 0a                	jb     803db2 <__udivdi3+0x6a>
  803da8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803dac:	0f 87 9e 00 00 00    	ja     803e50 <__udivdi3+0x108>
  803db2:	b8 01 00 00 00       	mov    $0x1,%eax
  803db7:	89 fa                	mov    %edi,%edx
  803db9:	83 c4 1c             	add    $0x1c,%esp
  803dbc:	5b                   	pop    %ebx
  803dbd:	5e                   	pop    %esi
  803dbe:	5f                   	pop    %edi
  803dbf:	5d                   	pop    %ebp
  803dc0:	c3                   	ret    
  803dc1:	8d 76 00             	lea    0x0(%esi),%esi
  803dc4:	31 ff                	xor    %edi,%edi
  803dc6:	31 c0                	xor    %eax,%eax
  803dc8:	89 fa                	mov    %edi,%edx
  803dca:	83 c4 1c             	add    $0x1c,%esp
  803dcd:	5b                   	pop    %ebx
  803dce:	5e                   	pop    %esi
  803dcf:	5f                   	pop    %edi
  803dd0:	5d                   	pop    %ebp
  803dd1:	c3                   	ret    
  803dd2:	66 90                	xchg   %ax,%ax
  803dd4:	89 d8                	mov    %ebx,%eax
  803dd6:	f7 f7                	div    %edi
  803dd8:	31 ff                	xor    %edi,%edi
  803dda:	89 fa                	mov    %edi,%edx
  803ddc:	83 c4 1c             	add    $0x1c,%esp
  803ddf:	5b                   	pop    %ebx
  803de0:	5e                   	pop    %esi
  803de1:	5f                   	pop    %edi
  803de2:	5d                   	pop    %ebp
  803de3:	c3                   	ret    
  803de4:	bd 20 00 00 00       	mov    $0x20,%ebp
  803de9:	89 eb                	mov    %ebp,%ebx
  803deb:	29 fb                	sub    %edi,%ebx
  803ded:	89 f9                	mov    %edi,%ecx
  803def:	d3 e6                	shl    %cl,%esi
  803df1:	89 c5                	mov    %eax,%ebp
  803df3:	88 d9                	mov    %bl,%cl
  803df5:	d3 ed                	shr    %cl,%ebp
  803df7:	89 e9                	mov    %ebp,%ecx
  803df9:	09 f1                	or     %esi,%ecx
  803dfb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803dff:	89 f9                	mov    %edi,%ecx
  803e01:	d3 e0                	shl    %cl,%eax
  803e03:	89 c5                	mov    %eax,%ebp
  803e05:	89 d6                	mov    %edx,%esi
  803e07:	88 d9                	mov    %bl,%cl
  803e09:	d3 ee                	shr    %cl,%esi
  803e0b:	89 f9                	mov    %edi,%ecx
  803e0d:	d3 e2                	shl    %cl,%edx
  803e0f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e13:	88 d9                	mov    %bl,%cl
  803e15:	d3 e8                	shr    %cl,%eax
  803e17:	09 c2                	or     %eax,%edx
  803e19:	89 d0                	mov    %edx,%eax
  803e1b:	89 f2                	mov    %esi,%edx
  803e1d:	f7 74 24 0c          	divl   0xc(%esp)
  803e21:	89 d6                	mov    %edx,%esi
  803e23:	89 c3                	mov    %eax,%ebx
  803e25:	f7 e5                	mul    %ebp
  803e27:	39 d6                	cmp    %edx,%esi
  803e29:	72 19                	jb     803e44 <__udivdi3+0xfc>
  803e2b:	74 0b                	je     803e38 <__udivdi3+0xf0>
  803e2d:	89 d8                	mov    %ebx,%eax
  803e2f:	31 ff                	xor    %edi,%edi
  803e31:	e9 58 ff ff ff       	jmp    803d8e <__udivdi3+0x46>
  803e36:	66 90                	xchg   %ax,%ax
  803e38:	8b 54 24 08          	mov    0x8(%esp),%edx
  803e3c:	89 f9                	mov    %edi,%ecx
  803e3e:	d3 e2                	shl    %cl,%edx
  803e40:	39 c2                	cmp    %eax,%edx
  803e42:	73 e9                	jae    803e2d <__udivdi3+0xe5>
  803e44:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803e47:	31 ff                	xor    %edi,%edi
  803e49:	e9 40 ff ff ff       	jmp    803d8e <__udivdi3+0x46>
  803e4e:	66 90                	xchg   %ax,%ax
  803e50:	31 c0                	xor    %eax,%eax
  803e52:	e9 37 ff ff ff       	jmp    803d8e <__udivdi3+0x46>
  803e57:	90                   	nop

00803e58 <__umoddi3>:
  803e58:	55                   	push   %ebp
  803e59:	57                   	push   %edi
  803e5a:	56                   	push   %esi
  803e5b:	53                   	push   %ebx
  803e5c:	83 ec 1c             	sub    $0x1c,%esp
  803e5f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803e63:	8b 74 24 34          	mov    0x34(%esp),%esi
  803e67:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803e6b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803e6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803e73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803e77:	89 f3                	mov    %esi,%ebx
  803e79:	89 fa                	mov    %edi,%edx
  803e7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803e7f:	89 34 24             	mov    %esi,(%esp)
  803e82:	85 c0                	test   %eax,%eax
  803e84:	75 1a                	jne    803ea0 <__umoddi3+0x48>
  803e86:	39 f7                	cmp    %esi,%edi
  803e88:	0f 86 a2 00 00 00    	jbe    803f30 <__umoddi3+0xd8>
  803e8e:	89 c8                	mov    %ecx,%eax
  803e90:	89 f2                	mov    %esi,%edx
  803e92:	f7 f7                	div    %edi
  803e94:	89 d0                	mov    %edx,%eax
  803e96:	31 d2                	xor    %edx,%edx
  803e98:	83 c4 1c             	add    $0x1c,%esp
  803e9b:	5b                   	pop    %ebx
  803e9c:	5e                   	pop    %esi
  803e9d:	5f                   	pop    %edi
  803e9e:	5d                   	pop    %ebp
  803e9f:	c3                   	ret    
  803ea0:	39 f0                	cmp    %esi,%eax
  803ea2:	0f 87 ac 00 00 00    	ja     803f54 <__umoddi3+0xfc>
  803ea8:	0f bd e8             	bsr    %eax,%ebp
  803eab:	83 f5 1f             	xor    $0x1f,%ebp
  803eae:	0f 84 ac 00 00 00    	je     803f60 <__umoddi3+0x108>
  803eb4:	bf 20 00 00 00       	mov    $0x20,%edi
  803eb9:	29 ef                	sub    %ebp,%edi
  803ebb:	89 fe                	mov    %edi,%esi
  803ebd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ec1:	89 e9                	mov    %ebp,%ecx
  803ec3:	d3 e0                	shl    %cl,%eax
  803ec5:	89 d7                	mov    %edx,%edi
  803ec7:	89 f1                	mov    %esi,%ecx
  803ec9:	d3 ef                	shr    %cl,%edi
  803ecb:	09 c7                	or     %eax,%edi
  803ecd:	89 e9                	mov    %ebp,%ecx
  803ecf:	d3 e2                	shl    %cl,%edx
  803ed1:	89 14 24             	mov    %edx,(%esp)
  803ed4:	89 d8                	mov    %ebx,%eax
  803ed6:	d3 e0                	shl    %cl,%eax
  803ed8:	89 c2                	mov    %eax,%edx
  803eda:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ede:	d3 e0                	shl    %cl,%eax
  803ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ee4:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ee8:	89 f1                	mov    %esi,%ecx
  803eea:	d3 e8                	shr    %cl,%eax
  803eec:	09 d0                	or     %edx,%eax
  803eee:	d3 eb                	shr    %cl,%ebx
  803ef0:	89 da                	mov    %ebx,%edx
  803ef2:	f7 f7                	div    %edi
  803ef4:	89 d3                	mov    %edx,%ebx
  803ef6:	f7 24 24             	mull   (%esp)
  803ef9:	89 c6                	mov    %eax,%esi
  803efb:	89 d1                	mov    %edx,%ecx
  803efd:	39 d3                	cmp    %edx,%ebx
  803eff:	0f 82 87 00 00 00    	jb     803f8c <__umoddi3+0x134>
  803f05:	0f 84 91 00 00 00    	je     803f9c <__umoddi3+0x144>
  803f0b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f0f:	29 f2                	sub    %esi,%edx
  803f11:	19 cb                	sbb    %ecx,%ebx
  803f13:	89 d8                	mov    %ebx,%eax
  803f15:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803f19:	d3 e0                	shl    %cl,%eax
  803f1b:	89 e9                	mov    %ebp,%ecx
  803f1d:	d3 ea                	shr    %cl,%edx
  803f1f:	09 d0                	or     %edx,%eax
  803f21:	89 e9                	mov    %ebp,%ecx
  803f23:	d3 eb                	shr    %cl,%ebx
  803f25:	89 da                	mov    %ebx,%edx
  803f27:	83 c4 1c             	add    $0x1c,%esp
  803f2a:	5b                   	pop    %ebx
  803f2b:	5e                   	pop    %esi
  803f2c:	5f                   	pop    %edi
  803f2d:	5d                   	pop    %ebp
  803f2e:	c3                   	ret    
  803f2f:	90                   	nop
  803f30:	89 fd                	mov    %edi,%ebp
  803f32:	85 ff                	test   %edi,%edi
  803f34:	75 0b                	jne    803f41 <__umoddi3+0xe9>
  803f36:	b8 01 00 00 00       	mov    $0x1,%eax
  803f3b:	31 d2                	xor    %edx,%edx
  803f3d:	f7 f7                	div    %edi
  803f3f:	89 c5                	mov    %eax,%ebp
  803f41:	89 f0                	mov    %esi,%eax
  803f43:	31 d2                	xor    %edx,%edx
  803f45:	f7 f5                	div    %ebp
  803f47:	89 c8                	mov    %ecx,%eax
  803f49:	f7 f5                	div    %ebp
  803f4b:	89 d0                	mov    %edx,%eax
  803f4d:	e9 44 ff ff ff       	jmp    803e96 <__umoddi3+0x3e>
  803f52:	66 90                	xchg   %ax,%ax
  803f54:	89 c8                	mov    %ecx,%eax
  803f56:	89 f2                	mov    %esi,%edx
  803f58:	83 c4 1c             	add    $0x1c,%esp
  803f5b:	5b                   	pop    %ebx
  803f5c:	5e                   	pop    %esi
  803f5d:	5f                   	pop    %edi
  803f5e:	5d                   	pop    %ebp
  803f5f:	c3                   	ret    
  803f60:	3b 04 24             	cmp    (%esp),%eax
  803f63:	72 06                	jb     803f6b <__umoddi3+0x113>
  803f65:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803f69:	77 0f                	ja     803f7a <__umoddi3+0x122>
  803f6b:	89 f2                	mov    %esi,%edx
  803f6d:	29 f9                	sub    %edi,%ecx
  803f6f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803f73:	89 14 24             	mov    %edx,(%esp)
  803f76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803f7a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803f7e:	8b 14 24             	mov    (%esp),%edx
  803f81:	83 c4 1c             	add    $0x1c,%esp
  803f84:	5b                   	pop    %ebx
  803f85:	5e                   	pop    %esi
  803f86:	5f                   	pop    %edi
  803f87:	5d                   	pop    %ebp
  803f88:	c3                   	ret    
  803f89:	8d 76 00             	lea    0x0(%esi),%esi
  803f8c:	2b 04 24             	sub    (%esp),%eax
  803f8f:	19 fa                	sbb    %edi,%edx
  803f91:	89 d1                	mov    %edx,%ecx
  803f93:	89 c6                	mov    %eax,%esi
  803f95:	e9 71 ff ff ff       	jmp    803f0b <__umoddi3+0xb3>
  803f9a:	66 90                	xchg   %ax,%ax
  803f9c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803fa0:	72 ea                	jb     803f8c <__umoddi3+0x134>
  803fa2:	89 d9                	mov    %ebx,%ecx
  803fa4:	e9 62 ff ff ff       	jmp    803f0b <__umoddi3+0xb3>
