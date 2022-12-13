
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
  800056:	e8 85 27 00 00       	call   8027e0 <sys_set_uheap_strategy>
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
  8000ac:	68 00 41 80 00       	push   $0x804100
  8000b1:	6a 18                	push   $0x18
  8000b3:	68 1c 41 80 00       	push   $0x80411c
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
  8000e9:	68 2f 41 80 00       	push   $0x80412f
  8000ee:	68 46 41 80 00       	push   $0x804146
  8000f3:	6a 20                	push   $0x20
  8000f5:	68 1c 41 80 00       	push   $0x80411c
  8000fa:	e8 29 0c 00 00       	call   800d28 <_panic>




	sys_set_uheap_strategy(UHP_PLACE_NEXTFIT);
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	6a 03                	push   $0x3
  800104:	e8 d7 26 00 00       	call   8027e0 <sys_set_uheap_strategy>
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
  80015a:	68 00 41 80 00       	push   $0x804100
  80015f:	6a 32                	push   $0x32
  800161:	68 1c 41 80 00       	push   $0x80411c
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
  8001c9:	68 5c 41 80 00       	push   $0x80415c
  8001ce:	6a 43                	push   $0x43
  8001d0:	68 1c 41 80 00       	push   $0x80411c
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
  8001f1:	68 ac 41 80 00       	push   $0x8041ac
  8001f6:	e8 e1 0d 00 00       	call   800fdc <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp

	// allocate pages
	freeFrames = sys_calculate_free_frames() ;
  8001fe:	e8 c8 20 00 00       	call   8022cb <sys_calculate_free_frames>
  800203:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800206:	e8 60 21 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  8002ab:	68 fc 41 80 00       	push   $0x8041fc
  8002b0:	6a 5c                	push   $0x5c
  8002b2:	68 1c 41 80 00       	push   $0x80411c
  8002b7:	e8 6c 0a 00 00       	call   800d28 <_panic>

	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8002bc:	e8 aa 20 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  8002df:	68 3a 42 80 00       	push   $0x80423a
  8002e4:	6a 5e                	push   $0x5e
  8002e6:	68 1c 41 80 00       	push   $0x80411c
  8002eb:	e8 38 0a 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != (512*Mega)/(1024*PAGE_SIZE) ) panic("Wrong allocation");
  8002f0:	8b 5d c8             	mov    -0x38(%ebp),%ebx
  8002f3:	e8 d3 1f 00 00       	call   8022cb <sys_calculate_free_frames>
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
  800315:	68 57 42 80 00       	push   $0x804257
  80031a:	6a 5f                	push   $0x5f
  80031c:	68 1c 41 80 00       	push   $0x80411c
  800321:	e8 02 0a 00 00       	call   800d28 <_panic>

	// Make memory holes.
	freeFrames = sys_calculate_free_frames() ;
  800326:	e8 a0 1f 00 00       	call   8022cb <sys_calculate_free_frames>
  80032b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  80032e:	e8 38 20 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
  800333:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	free(ptr_allocations[0]);		// Hole 1 = 2 M
  800336:	8b 85 c0 f7 ff ff    	mov    -0x840(%ebp),%eax
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	50                   	push   %eax
  800340:	e8 9a 1c 00 00       	call   801fdf <free>
  800345:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[2]);		// Hole 2 = 4 M
  800348:	8b 85 c8 f7 ff ff    	mov    -0x838(%ebp),%eax
  80034e:	83 ec 0c             	sub    $0xc,%esp
  800351:	50                   	push   %eax
  800352:	e8 88 1c 00 00       	call   801fdf <free>
  800357:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[3]);
  80035a:	8b 85 cc f7 ff ff    	mov    -0x834(%ebp),%eax
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	50                   	push   %eax
  800364:	e8 76 1c 00 00       	call   801fdf <free>
  800369:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[5]);		// Hole 3 = 2 M
  80036c:	8b 85 d4 f7 ff ff    	mov    -0x82c(%ebp),%eax
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	50                   	push   %eax
  800376:	e8 64 1c 00 00       	call   801fdf <free>
  80037b:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[10]);		// Hole 4 = 6 M
  80037e:	8b 85 e8 f7 ff ff    	mov    -0x818(%ebp),%eax
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	50                   	push   %eax
  800388:	e8 52 1c 00 00       	call   801fdf <free>
  80038d:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[12]);
  800390:	8b 85 f0 f7 ff ff    	mov    -0x810(%ebp),%eax
  800396:	83 ec 0c             	sub    $0xc,%esp
  800399:	50                   	push   %eax
  80039a:	e8 40 1c 00 00       	call   801fdf <free>
  80039f:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[11]);
  8003a2:	8b 85 ec f7 ff ff    	mov    -0x814(%ebp),%eax
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	50                   	push   %eax
  8003ac:	e8 2e 1c 00 00       	call   801fdf <free>
  8003b1:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[20]);		// Hole 5 = 2 M
  8003b4:	8b 85 10 f8 ff ff    	mov    -0x7f0(%ebp),%eax
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	50                   	push   %eax
  8003be:	e8 1c 1c 00 00       	call   801fdf <free>
  8003c3:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[25]);		// Hole 6 = 2 M
  8003c6:	8b 85 24 f8 ff ff    	mov    -0x7dc(%ebp),%eax
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	50                   	push   %eax
  8003d0:	e8 0a 1c 00 00       	call   801fdf <free>
  8003d5:	83 c4 10             	add    $0x10,%esp
	free(ptr_allocations[255]);		// Hole 7 = 2 M
  8003d8:	8b 85 bc fb ff ff    	mov    -0x444(%ebp),%eax
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	50                   	push   %eax
  8003e2:	e8 f8 1b 00 00       	call   801fdf <free>
  8003e7:	83 c4 10             	add    $0x10,%esp

	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 10*(2*Mega)/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8003ea:	e8 7c 1f 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  800416:	68 68 42 80 00       	push   $0x804268
  80041b:	6a 70                	push   $0x70
  80041d:	68 1c 41 80 00       	push   $0x80411c
  800422:	e8 01 09 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800427:	e8 9f 1e 00 00       	call   8022cb <sys_calculate_free_frames>
  80042c:	89 c2                	mov    %eax,%edx
  80042e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800431:	39 c2                	cmp    %eax,%edx
  800433:	74 14                	je     800449 <_main+0x411>
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 a4 42 80 00       	push   $0x8042a4
  80043d:	6a 71                	push   $0x71
  80043f:	68 1c 41 80 00       	push   $0x80411c
  800444:	e8 df 08 00 00       	call   800d28 <_panic>

	// Test next fit

	freeFrames = sys_calculate_free_frames() ;
  800449:	e8 7d 1e 00 00       	call   8022cb <sys_calculate_free_frames>
  80044e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800451:	e8 15 1f 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  80047b:	68 e4 42 80 00       	push   $0x8042e4
  800480:	6a 79                	push   $0x79
  800482:	68 1c 41 80 00       	push   $0x80411c
  800487:	e8 9c 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80048c:	e8 da 1e 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  8004ac:	68 3a 42 80 00       	push   $0x80423a
  8004b1:	6a 7a                	push   $0x7a
  8004b3:	68 1c 41 80 00       	push   $0x80411c
  8004b8:	e8 6b 08 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8004bd:	e8 09 1e 00 00       	call   8022cb <sys_calculate_free_frames>
  8004c2:	89 c2                	mov    %eax,%edx
  8004c4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004c7:	39 c2                	cmp    %eax,%edx
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 57 42 80 00       	push   $0x804257
  8004d3:	6a 7b                	push   $0x7b
  8004d5:	68 1c 41 80 00       	push   $0x80411c
  8004da:	e8 49 08 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8004df:	e8 e7 1d 00 00       	call   8022cb <sys_calculate_free_frames>
  8004e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e7:	e8 7f 1e 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  80050e:	68 e4 42 80 00       	push   $0x8042e4
  800513:	68 81 00 00 00       	push   $0x81
  800518:	68 1c 41 80 00       	push   $0x80411c
  80051d:	e8 06 08 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800522:	e8 44 1e 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  800545:	68 3a 42 80 00       	push   $0x80423a
  80054a:	68 82 00 00 00       	push   $0x82
  80054f:	68 1c 41 80 00       	push   $0x80411c
  800554:	e8 cf 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800559:	e8 6d 1d 00 00       	call   8022cb <sys_calculate_free_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 17                	je     80057e <_main+0x546>
  800567:	83 ec 04             	sub    $0x4,%esp
  80056a:	68 57 42 80 00       	push   $0x804257
  80056f:	68 83 00 00 00       	push   $0x83
  800574:	68 1c 41 80 00       	push   $0x80411c
  800579:	e8 aa 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80057e:	e8 48 1d 00 00       	call   8022cb <sys_calculate_free_frames>
  800583:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800586:	e8 e0 1d 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  8005b4:	68 e4 42 80 00       	push   $0x8042e4
  8005b9:	68 89 00 00 00       	push   $0x89
  8005be:	68 1c 41 80 00       	push   $0x80411c
  8005c3:	e8 60 07 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  8005c8:	e8 9e 1d 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  8005ef:	68 3a 42 80 00       	push   $0x80423a
  8005f4:	68 8a 00 00 00       	push   $0x8a
  8005f9:	68 1c 41 80 00       	push   $0x80411c
  8005fe:	e8 25 07 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800603:	e8 c3 1c 00 00       	call   8022cb <sys_calculate_free_frames>
  800608:	89 c2                	mov    %eax,%edx
  80060a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80060d:	39 c2                	cmp    %eax,%edx
  80060f:	74 17                	je     800628 <_main+0x5f0>
  800611:	83 ec 04             	sub    $0x4,%esp
  800614:	68 57 42 80 00       	push   $0x804257
  800619:	68 8b 00 00 00       	push   $0x8b
  80061e:	68 1c 41 80 00       	push   $0x80411c
  800623:	e8 00 07 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  800628:	e8 9e 1c 00 00       	call   8022cb <sys_calculate_free_frames>
  80062d:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800630:	e8 36 1d 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  800657:	68 e4 42 80 00       	push   $0x8042e4
  80065c:	68 91 00 00 00       	push   $0x91
  800661:	68 1c 41 80 00       	push   $0x80411c
  800666:	e8 bd 06 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  80066b:	e8 fb 1c 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  80068b:	68 3a 42 80 00       	push   $0x80423a
  800690:	68 92 00 00 00       	push   $0x92
  800695:	68 1c 41 80 00       	push   $0x80411c
  80069a:	e8 89 06 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  80069f:	e8 27 1c 00 00       	call   8022cb <sys_calculate_free_frames>
  8006a4:	89 c2                	mov    %eax,%edx
  8006a6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8006a9:	39 c2                	cmp    %eax,%edx
  8006ab:	74 17                	je     8006c4 <_main+0x68c>
  8006ad:	83 ec 04             	sub    $0x4,%esp
  8006b0:	68 57 42 80 00       	push   $0x804257
  8006b5:	68 93 00 00 00       	push   $0x93
  8006ba:	68 1c 41 80 00       	push   $0x80411c
  8006bf:	e8 64 06 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  8006c4:	e8 02 1c 00 00       	call   8022cb <sys_calculate_free_frames>
  8006c9:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8006cc:	e8 9a 1c 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
  8006d1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[15]);					// Make a new hole => 2 M
  8006d4:	8b 85 fc f7 ff ff    	mov    -0x804(%ebp),%eax
  8006da:	83 ec 0c             	sub    $0xc,%esp
  8006dd:	50                   	push   %eax
  8006de:	e8 fc 18 00 00       	call   801fdf <free>
  8006e3:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006e6:	e8 80 1c 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  800708:	68 68 42 80 00       	push   $0x804268
  80070d:	68 99 00 00 00       	push   $0x99
  800712:	68 1c 41 80 00       	push   $0x80411c
  800717:	e8 0c 06 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  80071c:	e8 aa 1b 00 00       	call   8022cb <sys_calculate_free_frames>
  800721:	89 c2                	mov    %eax,%edx
  800723:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800726:	39 c2                	cmp    %eax,%edx
  800728:	74 17                	je     800741 <_main+0x709>
  80072a:	83 ec 04             	sub    $0x4,%esp
  80072d:	68 a4 42 80 00       	push   $0x8042a4
  800732:	68 9a 00 00 00       	push   $0x9a
  800737:	68 1c 41 80 00       	push   $0x80411c
  80073c:	e8 e7 05 00 00       	call   800d28 <_panic>

	//[NEXT FIT Case]
	freeFrames = sys_calculate_free_frames() ;
  800741:	e8 85 1b 00 00       	call   8022cb <sys_calculate_free_frames>
  800746:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800749:	e8 1d 1c 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  800770:	68 e4 42 80 00       	push   $0x8042e4
  800775:	68 a1 00 00 00       	push   $0xa1
  80077a:	68 1c 41 80 00       	push   $0x80411c
  80077f:	e8 a4 05 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  800784:	e8 e2 1b 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  8007a7:	68 3a 42 80 00       	push   $0x80423a
  8007ac:	68 a2 00 00 00       	push   $0xa2
  8007b1:	68 1c 41 80 00       	push   $0x80411c
  8007b6:	e8 6d 05 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8007bb:	e8 0b 1b 00 00       	call   8022cb <sys_calculate_free_frames>
  8007c0:	89 c2                	mov    %eax,%edx
  8007c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8007c5:	39 c2                	cmp    %eax,%edx
  8007c7:	74 17                	je     8007e0 <_main+0x7a8>
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	68 57 42 80 00       	push   $0x804257
  8007d1:	68 a3 00 00 00       	push   $0xa3
  8007d6:	68 1c 41 80 00       	push   $0x80411c
  8007db:	e8 48 05 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  8007e0:	e8 e6 1a 00 00       	call   8022cb <sys_calculate_free_frames>
  8007e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8007e8:	e8 7e 1b 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  80081e:	68 e4 42 80 00       	push   $0x8042e4
  800823:	68 a9 00 00 00       	push   $0xa9
  800828:	68 1c 41 80 00       	push   $0x80411c
  80082d:	e8 f6 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (1*Mega+1016*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  800832:	e8 34 1b 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  800861:	68 3a 42 80 00       	push   $0x80423a
  800866:	68 aa 00 00 00       	push   $0xaa
  80086b:	68 1c 41 80 00       	push   $0x80411c
  800870:	e8 b3 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800875:	e8 51 1a 00 00       	call   8022cb <sys_calculate_free_frames>
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80087f:	39 c2                	cmp    %eax,%edx
  800881:	74 17                	je     80089a <_main+0x862>
  800883:	83 ec 04             	sub    $0x4,%esp
  800886:	68 57 42 80 00       	push   $0x804257
  80088b:	68 ab 00 00 00       	push   $0xab
  800890:	68 1c 41 80 00       	push   $0x80411c
  800895:	e8 8e 04 00 00       	call   800d28 <_panic>

	freeFrames = sys_calculate_free_frames() ;
  80089a:	e8 2c 1a 00 00       	call   8022cb <sys_calculate_free_frames>
  80089f:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  8008a2:	e8 c4 1a 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  8008cc:	68 e4 42 80 00       	push   $0x8042e4
  8008d1:	68 b1 00 00 00       	push   $0xb1
  8008d6:	68 1c 41 80 00       	push   $0x80411c
  8008db:	e8 48 04 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512*kilo/PAGE_SIZE) panic("Wrong page file allocation: ");
  8008e0:	e8 86 1a 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  800903:	68 3a 42 80 00       	push   $0x80423a
  800908:	68 b2 00 00 00       	push   $0xb2
  80090d:	68 1c 41 80 00       	push   $0x80411c
  800912:	e8 11 04 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800917:	e8 af 19 00 00       	call   8022cb <sys_calculate_free_frames>
  80091c:	89 c2                	mov    %eax,%edx
  80091e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800921:	39 c2                	cmp    %eax,%edx
  800923:	74 17                	je     80093c <_main+0x904>
  800925:	83 ec 04             	sub    $0x4,%esp
  800928:	68 57 42 80 00       	push   $0x804257
  80092d:	68 b3 00 00 00       	push   $0xb3
  800932:	68 1c 41 80 00       	push   $0x80411c
  800937:	e8 ec 03 00 00       	call   800d28 <_panic>

	cprintf("\nCASE1: (next fit without looping back) is succeeded...\n") ;
  80093c:	83 ec 0c             	sub    $0xc,%esp
  80093f:	68 04 43 80 00       	push   $0x804304
  800944:	e8 93 06 00 00       	call   800fdc <cprintf>
  800949:	83 c4 10             	add    $0x10,%esp

	// Check that next fit is looping back to check for free space
	freeFrames = sys_calculate_free_frames() ;
  80094c:	e8 7a 19 00 00       	call   8022cb <sys_calculate_free_frames>
  800951:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800954:	e8 12 1a 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  800989:	68 e4 42 80 00       	push   $0x8042e4
  80098e:	68 bc 00 00 00       	push   $0xbc
  800993:	68 1c 41 80 00       	push   $0x80411c
  800998:	e8 8b 03 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  (3*Mega+512*kilo)/PAGE_SIZE) panic("Wrong page file allocation: ");
  80099d:	e8 c9 19 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  8009cb:	68 3a 42 80 00       	push   $0x80423a
  8009d0:	68 bd 00 00 00       	push   $0xbd
  8009d5:	68 1c 41 80 00       	push   $0x80411c
  8009da:	e8 49 03 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  8009df:	e8 e7 18 00 00       	call   8022cb <sys_calculate_free_frames>
  8009e4:	89 c2                	mov    %eax,%edx
  8009e6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8009e9:	39 c2                	cmp    %eax,%edx
  8009eb:	74 17                	je     800a04 <_main+0x9cc>
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 57 42 80 00       	push   $0x804257
  8009f5:	68 be 00 00 00       	push   $0xbe
  8009fa:	68 1c 41 80 00       	push   $0x80411c
  8009ff:	e8 24 03 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a04:	e8 c2 18 00 00       	call   8022cb <sys_calculate_free_frames>
  800a09:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a0c:	e8 5a 19 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
  800a11:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	free(ptr_allocations[24]);		// Increase size of Hole 6 to 4 M
  800a14:	8b 85 20 f8 ff ff    	mov    -0x7e0(%ebp),%eax
  800a1a:	83 ec 0c             	sub    $0xc,%esp
  800a1d:	50                   	push   %eax
  800a1e:	e8 bc 15 00 00       	call   801fdf <free>
  800a23:	83 c4 10             	add    $0x10,%esp
	if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 2*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  800a26:	e8 40 19 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  800a48:	68 68 42 80 00       	push   $0x804268
  800a4d:	68 c4 00 00 00       	push   $0xc4
  800a52:	68 1c 41 80 00       	push   $0x80411c
  800a57:	e8 cc 02 00 00       	call   800d28 <_panic>
	if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: Extra or less pages are removed from main memory");
  800a5c:	e8 6a 18 00 00       	call   8022cb <sys_calculate_free_frames>
  800a61:	89 c2                	mov    %eax,%edx
  800a63:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800a66:	39 c2                	cmp    %eax,%edx
  800a68:	74 17                	je     800a81 <_main+0xa49>
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	68 a4 42 80 00       	push   $0x8042a4
  800a72:	68 c5 00 00 00       	push   $0xc5
  800a77:	68 1c 41 80 00       	push   $0x80411c
  800a7c:	e8 a7 02 00 00       	call   800d28 <_panic>


	freeFrames = sys_calculate_free_frames() ;
  800a81:	e8 45 18 00 00       	call   8022cb <sys_calculate_free_frames>
  800a86:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800a89:	e8 dd 18 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  800ab6:	68 e4 42 80 00       	push   $0x8042e4
  800abb:	68 cc 00 00 00       	push   $0xcc
  800ac0:	68 1c 41 80 00       	push   $0x80411c
  800ac5:	e8 5e 02 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/PAGE_SIZE) panic("Wrong page file allocation: ");
  800aca:	e8 9c 18 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  800aed:	68 3a 42 80 00       	push   $0x80423a
  800af2:	68 cd 00 00 00       	push   $0xcd
  800af7:	68 1c 41 80 00       	push   $0x80411c
  800afc:	e8 27 02 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b01:	e8 c5 17 00 00       	call   8022cb <sys_calculate_free_frames>
  800b06:	89 c2                	mov    %eax,%edx
  800b08:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	74 17                	je     800b26 <_main+0xaee>
  800b0f:	83 ec 04             	sub    $0x4,%esp
  800b12:	68 57 42 80 00       	push   $0x804257
  800b17:	68 ce 00 00 00       	push   $0xce
  800b1c:	68 1c 41 80 00       	push   $0x80411c
  800b21:	e8 02 02 00 00       	call   800d28 <_panic>

	cprintf("\nCASE2: (next fit WITH looping back) is succeeded...\n") ;
  800b26:	83 ec 0c             	sub    $0xc,%esp
  800b29:	68 40 43 80 00       	push   $0x804340
  800b2e:	e8 a9 04 00 00       	call   800fdc <cprintf>
  800b33:	83 c4 10             	add    $0x10,%esp

	// Check that next fit returns null in case all holes are not free
	freeFrames = sys_calculate_free_frames() ;
  800b36:	e8 90 17 00 00       	call   8022cb <sys_calculate_free_frames>
  800b3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
	usedDiskPages = sys_pf_calculate_allocated_pages();
  800b3e:	e8 28 18 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
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
  800b6a:	68 e4 42 80 00       	push   $0x8042e4
  800b6f:	68 d7 00 00 00       	push   $0xd7
  800b74:	68 1c 41 80 00       	push   $0x80411c
  800b79:	e8 aa 01 00 00       	call   800d28 <_panic>
	if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b7e:	e8 e8 17 00 00       	call   80236b <sys_pf_calculate_allocated_pages>
  800b83:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  800b86:	74 17                	je     800b9f <_main+0xb67>
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	68 3a 42 80 00       	push   $0x80423a
  800b90:	68 d8 00 00 00       	push   $0xd8
  800b95:	68 1c 41 80 00       	push   $0x80411c
  800b9a:	e8 89 01 00 00       	call   800d28 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation");
  800b9f:	e8 27 17 00 00       	call   8022cb <sys_calculate_free_frames>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800ba9:	39 c2                	cmp    %eax,%edx
  800bab:	74 17                	je     800bc4 <_main+0xb8c>
  800bad:	83 ec 04             	sub    $0x4,%esp
  800bb0:	68 57 42 80 00       	push   $0x804257
  800bb5:	68 d9 00 00 00       	push   $0xd9
  800bba:	68 1c 41 80 00       	push   $0x80411c
  800bbf:	e8 64 01 00 00       	call   800d28 <_panic>

	cprintf("\nCASE3: (next fit with insufficient space) is succeeded...\n") ;
  800bc4:	83 ec 0c             	sub    $0xc,%esp
  800bc7:	68 78 43 80 00       	push   $0x804378
  800bcc:	e8 0b 04 00 00       	call   800fdc <cprintf>
  800bd1:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! test Next Fit completed successfully.\n");
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	68 b4 43 80 00       	push   $0x8043b4
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
  800bf2:	e8 b4 19 00 00       	call   8025ab <sys_getenvindex>
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
  800c5d:	e8 56 17 00 00       	call   8023b8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800c62:	83 ec 0c             	sub    $0xc,%esp
  800c65:	68 08 44 80 00       	push   $0x804408
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
  800c8d:	68 30 44 80 00       	push   $0x804430
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
  800cbe:	68 58 44 80 00       	push   $0x804458
  800cc3:	e8 14 03 00 00       	call   800fdc <cprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800ccb:	a1 20 50 80 00       	mov    0x805020,%eax
  800cd0:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800cd6:	83 ec 08             	sub    $0x8,%esp
  800cd9:	50                   	push   %eax
  800cda:	68 b0 44 80 00       	push   $0x8044b0
  800cdf:	e8 f8 02 00 00       	call   800fdc <cprintf>
  800ce4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	68 08 44 80 00       	push   $0x804408
  800cef:	e8 e8 02 00 00       	call   800fdc <cprintf>
  800cf4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800cf7:	e8 d6 16 00 00       	call   8023d2 <sys_enable_interrupt>

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
  800d0f:	e8 63 18 00 00       	call   802577 <sys_destroy_env>
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
  800d20:	e8 b8 18 00 00       	call   8025dd <sys_exit_env>
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
  800d49:	68 c4 44 80 00       	push   $0x8044c4
  800d4e:	e8 89 02 00 00       	call   800fdc <cprintf>
  800d53:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800d56:	a1 00 50 80 00       	mov    0x805000,%eax
  800d5b:	ff 75 0c             	pushl  0xc(%ebp)
  800d5e:	ff 75 08             	pushl  0x8(%ebp)
  800d61:	50                   	push   %eax
  800d62:	68 c9 44 80 00       	push   $0x8044c9
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
  800d86:	68 e5 44 80 00       	push   $0x8044e5
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
  800db2:	68 e8 44 80 00       	push   $0x8044e8
  800db7:	6a 26                	push   $0x26
  800db9:	68 34 45 80 00       	push   $0x804534
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
  800e84:	68 40 45 80 00       	push   $0x804540
  800e89:	6a 3a                	push   $0x3a
  800e8b:	68 34 45 80 00       	push   $0x804534
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
  800ef4:	68 94 45 80 00       	push   $0x804594
  800ef9:	6a 44                	push   $0x44
  800efb:	68 34 45 80 00       	push   $0x804534
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
  800f4e:	e8 b7 12 00 00       	call   80220a <sys_cputs>
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
  800fc5:	e8 40 12 00 00       	call   80220a <sys_cputs>
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
  80100f:	e8 a4 13 00 00       	call   8023b8 <sys_disable_interrupt>
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
  80102f:	e8 9e 13 00 00       	call   8023d2 <sys_enable_interrupt>
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
  801079:	e8 12 2e 00 00       	call   803e90 <__udivdi3>
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
  8010c9:	e8 d2 2e 00 00       	call   803fa0 <__umoddi3>
  8010ce:	83 c4 10             	add    $0x10,%esp
  8010d1:	05 f4 47 80 00       	add    $0x8047f4,%eax
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
  801224:	8b 04 85 18 48 80 00 	mov    0x804818(,%eax,4),%eax
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
  801305:	8b 34 9d 60 46 80 00 	mov    0x804660(,%ebx,4),%esi
  80130c:	85 f6                	test   %esi,%esi
  80130e:	75 19                	jne    801329 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801310:	53                   	push   %ebx
  801311:	68 05 48 80 00       	push   $0x804805
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
  80132a:	68 0e 48 80 00       	push   $0x80480e
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
  801357:	be 11 48 80 00       	mov    $0x804811,%esi
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
  801d7d:	68 70 49 80 00       	push   $0x804970
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
  801e4d:	e8 fc 04 00 00       	call   80234e <sys_allocate_chunk>
  801e52:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801e55:	a1 20 51 80 00       	mov    0x805120,%eax
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	50                   	push   %eax
  801e5e:	e8 71 0b 00 00       	call   8029d4 <initialize_MemBlocksList>
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
  801e8b:	68 95 49 80 00       	push   $0x804995
  801e90:	6a 33                	push   $0x33
  801e92:	68 b3 49 80 00       	push   $0x8049b3
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
  801f0a:	68 c0 49 80 00       	push   $0x8049c0
  801f0f:	6a 34                	push   $0x34
  801f11:	68 b3 49 80 00       	push   $0x8049b3
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
  801f67:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f6a:	e8 f7 fd ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f73:	75 07                	jne    801f7c <malloc+0x18>
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7a:	eb 61                	jmp    801fdd <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801f7c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f83:	8b 55 08             	mov    0x8(%ebp),%edx
  801f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f89:	01 d0                	add    %edx,%eax
  801f8b:	48                   	dec    %eax
  801f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f92:	ba 00 00 00 00       	mov    $0x0,%edx
  801f97:	f7 75 f0             	divl   -0x10(%ebp)
  801f9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9d:	29 d0                	sub    %edx,%eax
  801f9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801fa2:	e8 75 07 00 00       	call   80271c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	74 11                	je     801fbc <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801fab:	83 ec 0c             	sub    $0xc,%esp
  801fae:	ff 75 e8             	pushl  -0x18(%ebp)
  801fb1:	e8 e0 0d 00 00       	call   802d96 <alloc_block_FF>
  801fb6:	83 c4 10             	add    $0x10,%esp
  801fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801fbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc0:	74 16                	je     801fd8 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801fc2:	83 ec 0c             	sub    $0xc,%esp
  801fc5:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc8:	e8 3c 0b 00 00       	call   802b09 <insert_sorted_allocList>
  801fcd:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd3:	8b 40 08             	mov    0x8(%eax),%eax
  801fd6:	eb 05                	jmp    801fdd <malloc+0x79>
	}

    return NULL;
  801fd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	68 e4 49 80 00       	push   $0x8049e4
  801fed:	6a 6f                	push   $0x6f
  801fef:	68 b3 49 80 00       	push   $0x8049b3
  801ff4:	e8 2f ed ff ff       	call   800d28 <_panic>

00801ff9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 38             	sub    $0x38,%esp
  801fff:	8b 45 10             	mov    0x10(%ebp),%eax
  802002:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802005:	e8 5c fd ff ff       	call   801d66 <InitializeUHeap>
	if (size == 0) return NULL ;
  80200a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80200e:	75 0a                	jne    80201a <smalloc+0x21>
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
  802015:	e9 8b 00 00 00       	jmp    8020a5 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80201a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802021:	8b 55 0c             	mov    0xc(%ebp),%edx
  802024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802027:	01 d0                	add    %edx,%eax
  802029:	48                   	dec    %eax
  80202a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80202d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802030:	ba 00 00 00 00       	mov    $0x0,%edx
  802035:	f7 75 f0             	divl   -0x10(%ebp)
  802038:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203b:	29 d0                	sub    %edx,%eax
  80203d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  802040:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  802047:	e8 d0 06 00 00       	call   80271c <sys_isUHeapPlacementStrategyFIRSTFIT>
  80204c:	85 c0                	test   %eax,%eax
  80204e:	74 11                	je     802061 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  802050:	83 ec 0c             	sub    $0xc,%esp
  802053:	ff 75 e8             	pushl  -0x18(%ebp)
  802056:	e8 3b 0d 00 00       	call   802d96 <alloc_block_FF>
  80205b:	83 c4 10             	add    $0x10,%esp
  80205e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  802061:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802065:	74 39                	je     8020a0 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  802067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206a:	8b 40 08             	mov    0x8(%eax),%eax
  80206d:	89 c2                	mov    %eax,%edx
  80206f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802073:	52                   	push   %edx
  802074:	50                   	push   %eax
  802075:	ff 75 0c             	pushl  0xc(%ebp)
  802078:	ff 75 08             	pushl  0x8(%ebp)
  80207b:	e8 21 04 00 00       	call   8024a1 <sys_createSharedObject>
  802080:	83 c4 10             	add    $0x10,%esp
  802083:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  802086:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80208a:	74 14                	je     8020a0 <smalloc+0xa7>
  80208c:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  802090:	74 0e                	je     8020a0 <smalloc+0xa7>
  802092:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  802096:	74 08                	je     8020a0 <smalloc+0xa7>
			return (void*) mem_block->sva;
  802098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209b:	8b 40 08             	mov    0x8(%eax),%eax
  80209e:	eb 05                	jmp    8020a5 <smalloc+0xac>
	}
	return NULL;
  8020a0:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020ad:	e8 b4 fc ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020b2:	83 ec 08             	sub    $0x8,%esp
  8020b5:	ff 75 0c             	pushl  0xc(%ebp)
  8020b8:	ff 75 08             	pushl  0x8(%ebp)
  8020bb:	e8 0b 04 00 00       	call   8024cb <sys_getSizeOfSharedObject>
  8020c0:	83 c4 10             	add    $0x10,%esp
  8020c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8020c6:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8020ca:	74 76                	je     802142 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8020cc:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d9:	01 d0                	add    %edx,%eax
  8020db:	48                   	dec    %eax
  8020dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e7:	f7 75 ec             	divl   -0x14(%ebp)
  8020ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020ed:	29 d0                	sub    %edx,%eax
  8020ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8020f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8020f9:	e8 1e 06 00 00       	call   80271c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020fe:	85 c0                	test   %eax,%eax
  802100:	74 11                	je     802113 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  802102:	83 ec 0c             	sub    $0xc,%esp
  802105:	ff 75 e4             	pushl  -0x1c(%ebp)
  802108:	e8 89 0c 00 00       	call   802d96 <alloc_block_FF>
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  802113:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802117:	74 29                	je     802142 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	8b 40 08             	mov    0x8(%eax),%eax
  80211f:	83 ec 04             	sub    $0x4,%esp
  802122:	50                   	push   %eax
  802123:	ff 75 0c             	pushl  0xc(%ebp)
  802126:	ff 75 08             	pushl  0x8(%ebp)
  802129:	e8 ba 03 00 00       	call   8024e8 <sys_getSharedObject>
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  802134:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  802138:	74 08                	je     802142 <sget+0x9b>
				return (void *)mem_block->sva;
  80213a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213d:	8b 40 08             	mov    0x8(%eax),%eax
  802140:	eb 05                	jmp    802147 <sget+0xa0>
		}
	}
	return (void *)NULL;
  802142:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802147:	c9                   	leave  
  802148:	c3                   	ret    

00802149 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80214f:	e8 12 fc ff ff       	call   801d66 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802154:	83 ec 04             	sub    $0x4,%esp
  802157:	68 08 4a 80 00       	push   $0x804a08
  80215c:	68 f1 00 00 00       	push   $0xf1
  802161:	68 b3 49 80 00       	push   $0x8049b3
  802166:	e8 bd eb ff ff       	call   800d28 <_panic>

0080216b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802171:	83 ec 04             	sub    $0x4,%esp
  802174:	68 30 4a 80 00       	push   $0x804a30
  802179:	68 05 01 00 00       	push   $0x105
  80217e:	68 b3 49 80 00       	push   $0x8049b3
  802183:	e8 a0 eb ff ff       	call   800d28 <_panic>

00802188 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80218e:	83 ec 04             	sub    $0x4,%esp
  802191:	68 54 4a 80 00       	push   $0x804a54
  802196:	68 10 01 00 00       	push   $0x110
  80219b:	68 b3 49 80 00       	push   $0x8049b3
  8021a0:	e8 83 eb ff ff       	call   800d28 <_panic>

008021a5 <shrink>:

}
void shrink(uint32 newSize)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021ab:	83 ec 04             	sub    $0x4,%esp
  8021ae:	68 54 4a 80 00       	push   $0x804a54
  8021b3:	68 15 01 00 00       	push   $0x115
  8021b8:	68 b3 49 80 00       	push   $0x8049b3
  8021bd:	e8 66 eb ff ff       	call   800d28 <_panic>

008021c2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
  8021c5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021c8:	83 ec 04             	sub    $0x4,%esp
  8021cb:	68 54 4a 80 00       	push   $0x804a54
  8021d0:	68 1a 01 00 00       	push   $0x11a
  8021d5:	68 b3 49 80 00       	push   $0x8049b3
  8021da:	e8 49 eb ff ff       	call   800d28 <_panic>

008021df <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	57                   	push   %edi
  8021e3:	56                   	push   %esi
  8021e4:	53                   	push   %ebx
  8021e5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021f4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021f7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021fa:	cd 30                	int    $0x30
  8021fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802202:	83 c4 10             	add    $0x10,%esp
  802205:	5b                   	pop    %ebx
  802206:	5e                   	pop    %esi
  802207:	5f                   	pop    %edi
  802208:	5d                   	pop    %ebp
  802209:	c3                   	ret    

0080220a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	83 ec 04             	sub    $0x4,%esp
  802210:	8b 45 10             	mov    0x10(%ebp),%eax
  802213:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802216:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	52                   	push   %edx
  802222:	ff 75 0c             	pushl  0xc(%ebp)
  802225:	50                   	push   %eax
  802226:	6a 00                	push   $0x0
  802228:	e8 b2 ff ff ff       	call   8021df <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
}
  802230:	90                   	nop
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_cgetc>:

int
sys_cgetc(void)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 01                	push   $0x1
  802242:	e8 98 ff ff ff       	call   8021df <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80224f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	52                   	push   %edx
  80225c:	50                   	push   %eax
  80225d:	6a 05                	push   $0x5
  80225f:	e8 7b ff ff ff       	call   8021df <syscall>
  802264:	83 c4 18             	add    $0x18,%esp
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
  80226c:	56                   	push   %esi
  80226d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80226e:	8b 75 18             	mov    0x18(%ebp),%esi
  802271:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802274:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802277:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	56                   	push   %esi
  80227e:	53                   	push   %ebx
  80227f:	51                   	push   %ecx
  802280:	52                   	push   %edx
  802281:	50                   	push   %eax
  802282:	6a 06                	push   $0x6
  802284:	e8 56 ff ff ff       	call   8021df <syscall>
  802289:	83 c4 18             	add    $0x18,%esp
}
  80228c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80228f:	5b                   	pop    %ebx
  802290:	5e                   	pop    %esi
  802291:	5d                   	pop    %ebp
  802292:	c3                   	ret    

00802293 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802296:	8b 55 0c             	mov    0xc(%ebp),%edx
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	52                   	push   %edx
  8022a3:	50                   	push   %eax
  8022a4:	6a 07                	push   $0x7
  8022a6:	e8 34 ff ff ff       	call   8021df <syscall>
  8022ab:	83 c4 18             	add    $0x18,%esp
}
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	ff 75 0c             	pushl  0xc(%ebp)
  8022bc:	ff 75 08             	pushl  0x8(%ebp)
  8022bf:	6a 08                	push   $0x8
  8022c1:	e8 19 ff ff ff       	call   8021df <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 09                	push   $0x9
  8022da:	e8 00 ff ff ff       	call   8021df <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 0a                	push   $0xa
  8022f3:	e8 e7 fe ff ff       	call   8021df <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 0b                	push   $0xb
  80230c:	e8 ce fe ff ff       	call   8021df <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	ff 75 0c             	pushl  0xc(%ebp)
  802322:	ff 75 08             	pushl  0x8(%ebp)
  802325:	6a 0f                	push   $0xf
  802327:	e8 b3 fe ff ff       	call   8021df <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
	return;
  80232f:	90                   	nop
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	ff 75 0c             	pushl  0xc(%ebp)
  80233e:	ff 75 08             	pushl  0x8(%ebp)
  802341:	6a 10                	push   $0x10
  802343:	e8 97 fe ff ff       	call   8021df <syscall>
  802348:	83 c4 18             	add    $0x18,%esp
	return ;
  80234b:	90                   	nop
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	ff 75 10             	pushl  0x10(%ebp)
  802358:	ff 75 0c             	pushl  0xc(%ebp)
  80235b:	ff 75 08             	pushl  0x8(%ebp)
  80235e:	6a 11                	push   $0x11
  802360:	e8 7a fe ff ff       	call   8021df <syscall>
  802365:	83 c4 18             	add    $0x18,%esp
	return ;
  802368:	90                   	nop
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 0c                	push   $0xc
  80237a:	e8 60 fe ff ff       	call   8021df <syscall>
  80237f:	83 c4 18             	add    $0x18,%esp
}
  802382:	c9                   	leave  
  802383:	c3                   	ret    

00802384 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802387:	6a 00                	push   $0x0
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	ff 75 08             	pushl  0x8(%ebp)
  802392:	6a 0d                	push   $0xd
  802394:	e8 46 fe ff ff       	call   8021df <syscall>
  802399:	83 c4 18             	add    $0x18,%esp
}
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 0e                	push   $0xe
  8023ad:	e8 2d fe ff ff       	call   8021df <syscall>
  8023b2:	83 c4 18             	add    $0x18,%esp
}
  8023b5:	90                   	nop
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 13                	push   $0x13
  8023c7:	e8 13 fe ff ff       	call   8021df <syscall>
  8023cc:	83 c4 18             	add    $0x18,%esp
}
  8023cf:	90                   	nop
  8023d0:	c9                   	leave  
  8023d1:	c3                   	ret    

008023d2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 14                	push   $0x14
  8023e1:	e8 f9 fd ff ff       	call   8021df <syscall>
  8023e6:	83 c4 18             	add    $0x18,%esp
}
  8023e9:	90                   	nop
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_cputc>:


void
sys_cputc(const char c)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	83 ec 04             	sub    $0x4,%esp
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023f8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	50                   	push   %eax
  802405:	6a 15                	push   $0x15
  802407:	e8 d3 fd ff ff       	call   8021df <syscall>
  80240c:	83 c4 18             	add    $0x18,%esp
}
  80240f:	90                   	nop
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 16                	push   $0x16
  802421:	e8 b9 fd ff ff       	call   8021df <syscall>
  802426:	83 c4 18             	add    $0x18,%esp
}
  802429:	90                   	nop
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	ff 75 0c             	pushl  0xc(%ebp)
  80243b:	50                   	push   %eax
  80243c:	6a 17                	push   $0x17
  80243e:	e8 9c fd ff ff       	call   8021df <syscall>
  802443:	83 c4 18             	add    $0x18,%esp
}
  802446:	c9                   	leave  
  802447:	c3                   	ret    

00802448 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802448:	55                   	push   %ebp
  802449:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80244b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	52                   	push   %edx
  802458:	50                   	push   %eax
  802459:	6a 1a                	push   $0x1a
  80245b:	e8 7f fd ff ff       	call   8021df <syscall>
  802460:	83 c4 18             	add    $0x18,%esp
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802468:	8b 55 0c             	mov    0xc(%ebp),%edx
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	52                   	push   %edx
  802475:	50                   	push   %eax
  802476:	6a 18                	push   $0x18
  802478:	e8 62 fd ff ff       	call   8021df <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
}
  802480:	90                   	nop
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802486:	8b 55 0c             	mov    0xc(%ebp),%edx
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	6a 00                	push   $0x0
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	52                   	push   %edx
  802493:	50                   	push   %eax
  802494:	6a 19                	push   $0x19
  802496:	e8 44 fd ff ff       	call   8021df <syscall>
  80249b:	83 c4 18             	add    $0x18,%esp
}
  80249e:	90                   	nop
  80249f:	c9                   	leave  
  8024a0:	c3                   	ret    

008024a1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
  8024a4:	83 ec 04             	sub    $0x4,%esp
  8024a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8024aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024ad:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024b0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	6a 00                	push   $0x0
  8024b9:	51                   	push   %ecx
  8024ba:	52                   	push   %edx
  8024bb:	ff 75 0c             	pushl  0xc(%ebp)
  8024be:	50                   	push   %eax
  8024bf:	6a 1b                	push   $0x1b
  8024c1:	e8 19 fd ff ff       	call   8021df <syscall>
  8024c6:	83 c4 18             	add    $0x18,%esp
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	52                   	push   %edx
  8024db:	50                   	push   %eax
  8024dc:	6a 1c                	push   $0x1c
  8024de:	e8 fc fc ff ff       	call   8021df <syscall>
  8024e3:	83 c4 18             	add    $0x18,%esp
}
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8024eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	51                   	push   %ecx
  8024f9:	52                   	push   %edx
  8024fa:	50                   	push   %eax
  8024fb:	6a 1d                	push   $0x1d
  8024fd:	e8 dd fc ff ff       	call   8021df <syscall>
  802502:	83 c4 18             	add    $0x18,%esp
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80250a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	52                   	push   %edx
  802517:	50                   	push   %eax
  802518:	6a 1e                	push   $0x1e
  80251a:	e8 c0 fc ff ff       	call   8021df <syscall>
  80251f:	83 c4 18             	add    $0x18,%esp
}
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802527:	6a 00                	push   $0x0
  802529:	6a 00                	push   $0x0
  80252b:	6a 00                	push   $0x0
  80252d:	6a 00                	push   $0x0
  80252f:	6a 00                	push   $0x0
  802531:	6a 1f                	push   $0x1f
  802533:	e8 a7 fc ff ff       	call   8021df <syscall>
  802538:	83 c4 18             	add    $0x18,%esp
}
  80253b:	c9                   	leave  
  80253c:	c3                   	ret    

0080253d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	6a 00                	push   $0x0
  802545:	ff 75 14             	pushl  0x14(%ebp)
  802548:	ff 75 10             	pushl  0x10(%ebp)
  80254b:	ff 75 0c             	pushl  0xc(%ebp)
  80254e:	50                   	push   %eax
  80254f:	6a 20                	push   $0x20
  802551:	e8 89 fc ff ff       	call   8021df <syscall>
  802556:	83 c4 18             	add    $0x18,%esp
}
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	50                   	push   %eax
  80256a:	6a 21                	push   $0x21
  80256c:	e8 6e fc ff ff       	call   8021df <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
}
  802574:	90                   	nop
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	50                   	push   %eax
  802586:	6a 22                	push   $0x22
  802588:	e8 52 fc ff ff       	call   8021df <syscall>
  80258d:	83 c4 18             	add    $0x18,%esp
}
  802590:	c9                   	leave  
  802591:	c3                   	ret    

00802592 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 02                	push   $0x2
  8025a1:	e8 39 fc ff ff       	call   8021df <syscall>
  8025a6:	83 c4 18             	add    $0x18,%esp
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 03                	push   $0x3
  8025ba:	e8 20 fc ff ff       	call   8021df <syscall>
  8025bf:	83 c4 18             	add    $0x18,%esp
}
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025c7:	6a 00                	push   $0x0
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 04                	push   $0x4
  8025d3:	e8 07 fc ff ff       	call   8021df <syscall>
  8025d8:	83 c4 18             	add    $0x18,%esp
}
  8025db:	c9                   	leave  
  8025dc:	c3                   	ret    

008025dd <sys_exit_env>:


void sys_exit_env(void)
{
  8025dd:	55                   	push   %ebp
  8025de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025e0:	6a 00                	push   $0x0
  8025e2:	6a 00                	push   $0x0
  8025e4:	6a 00                	push   $0x0
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 23                	push   $0x23
  8025ec:	e8 ee fb ff ff       	call   8021df <syscall>
  8025f1:	83 c4 18             	add    $0x18,%esp
}
  8025f4:	90                   	nop
  8025f5:	c9                   	leave  
  8025f6:	c3                   	ret    

008025f7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8025f7:	55                   	push   %ebp
  8025f8:	89 e5                	mov    %esp,%ebp
  8025fa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025fd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802600:	8d 50 04             	lea    0x4(%eax),%edx
  802603:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802606:	6a 00                	push   $0x0
  802608:	6a 00                	push   $0x0
  80260a:	6a 00                	push   $0x0
  80260c:	52                   	push   %edx
  80260d:	50                   	push   %eax
  80260e:	6a 24                	push   $0x24
  802610:	e8 ca fb ff ff       	call   8021df <syscall>
  802615:	83 c4 18             	add    $0x18,%esp
	return result;
  802618:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80261b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80261e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802621:	89 01                	mov    %eax,(%ecx)
  802623:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802626:	8b 45 08             	mov    0x8(%ebp),%eax
  802629:	c9                   	leave  
  80262a:	c2 04 00             	ret    $0x4

0080262d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80262d:	55                   	push   %ebp
  80262e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802630:	6a 00                	push   $0x0
  802632:	6a 00                	push   $0x0
  802634:	ff 75 10             	pushl  0x10(%ebp)
  802637:	ff 75 0c             	pushl  0xc(%ebp)
  80263a:	ff 75 08             	pushl  0x8(%ebp)
  80263d:	6a 12                	push   $0x12
  80263f:	e8 9b fb ff ff       	call   8021df <syscall>
  802644:	83 c4 18             	add    $0x18,%esp
	return ;
  802647:	90                   	nop
}
  802648:	c9                   	leave  
  802649:	c3                   	ret    

0080264a <sys_rcr2>:
uint32 sys_rcr2()
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 25                	push   $0x25
  802659:	e8 81 fb ff ff       	call   8021df <syscall>
  80265e:	83 c4 18             	add    $0x18,%esp
}
  802661:	c9                   	leave  
  802662:	c3                   	ret    

00802663 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	83 ec 04             	sub    $0x4,%esp
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80266f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 00                	push   $0x0
  80267b:	50                   	push   %eax
  80267c:	6a 26                	push   $0x26
  80267e:	e8 5c fb ff ff       	call   8021df <syscall>
  802683:	83 c4 18             	add    $0x18,%esp
	return ;
  802686:	90                   	nop
}
  802687:	c9                   	leave  
  802688:	c3                   	ret    

00802689 <rsttst>:
void rsttst()
{
  802689:	55                   	push   %ebp
  80268a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 00                	push   $0x0
  802692:	6a 00                	push   $0x0
  802694:	6a 00                	push   $0x0
  802696:	6a 28                	push   $0x28
  802698:	e8 42 fb ff ff       	call   8021df <syscall>
  80269d:	83 c4 18             	add    $0x18,%esp
	return ;
  8026a0:	90                   	nop
}
  8026a1:	c9                   	leave  
  8026a2:	c3                   	ret    

008026a3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026a3:	55                   	push   %ebp
  8026a4:	89 e5                	mov    %esp,%ebp
  8026a6:	83 ec 04             	sub    $0x4,%esp
  8026a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8026ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026af:	8b 55 18             	mov    0x18(%ebp),%edx
  8026b2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026b6:	52                   	push   %edx
  8026b7:	50                   	push   %eax
  8026b8:	ff 75 10             	pushl  0x10(%ebp)
  8026bb:	ff 75 0c             	pushl  0xc(%ebp)
  8026be:	ff 75 08             	pushl  0x8(%ebp)
  8026c1:	6a 27                	push   $0x27
  8026c3:	e8 17 fb ff ff       	call   8021df <syscall>
  8026c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8026cb:	90                   	nop
}
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    

008026ce <chktst>:
void chktst(uint32 n)
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026d1:	6a 00                	push   $0x0
  8026d3:	6a 00                	push   $0x0
  8026d5:	6a 00                	push   $0x0
  8026d7:	6a 00                	push   $0x0
  8026d9:	ff 75 08             	pushl  0x8(%ebp)
  8026dc:	6a 29                	push   $0x29
  8026de:	e8 fc fa ff ff       	call   8021df <syscall>
  8026e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e6:	90                   	nop
}
  8026e7:	c9                   	leave  
  8026e8:	c3                   	ret    

008026e9 <inctst>:

void inctst()
{
  8026e9:	55                   	push   %ebp
  8026ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026ec:	6a 00                	push   $0x0
  8026ee:	6a 00                	push   $0x0
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 2a                	push   $0x2a
  8026f8:	e8 e2 fa ff ff       	call   8021df <syscall>
  8026fd:	83 c4 18             	add    $0x18,%esp
	return ;
  802700:	90                   	nop
}
  802701:	c9                   	leave  
  802702:	c3                   	ret    

00802703 <gettst>:
uint32 gettst()
{
  802703:	55                   	push   %ebp
  802704:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802706:	6a 00                	push   $0x0
  802708:	6a 00                	push   $0x0
  80270a:	6a 00                	push   $0x0
  80270c:	6a 00                	push   $0x0
  80270e:	6a 00                	push   $0x0
  802710:	6a 2b                	push   $0x2b
  802712:	e8 c8 fa ff ff       	call   8021df <syscall>
  802717:	83 c4 18             	add    $0x18,%esp
}
  80271a:	c9                   	leave  
  80271b:	c3                   	ret    

0080271c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
  80271f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	6a 00                	push   $0x0
  80272a:	6a 00                	push   $0x0
  80272c:	6a 2c                	push   $0x2c
  80272e:	e8 ac fa ff ff       	call   8021df <syscall>
  802733:	83 c4 18             	add    $0x18,%esp
  802736:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802739:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80273d:	75 07                	jne    802746 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80273f:	b8 01 00 00 00       	mov    $0x1,%eax
  802744:	eb 05                	jmp    80274b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802746:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
  802750:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802753:	6a 00                	push   $0x0
  802755:	6a 00                	push   $0x0
  802757:	6a 00                	push   $0x0
  802759:	6a 00                	push   $0x0
  80275b:	6a 00                	push   $0x0
  80275d:	6a 2c                	push   $0x2c
  80275f:	e8 7b fa ff ff       	call   8021df <syscall>
  802764:	83 c4 18             	add    $0x18,%esp
  802767:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80276a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80276e:	75 07                	jne    802777 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802770:	b8 01 00 00 00       	mov    $0x1,%eax
  802775:	eb 05                	jmp    80277c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802777:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80277c:	c9                   	leave  
  80277d:	c3                   	ret    

0080277e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80277e:	55                   	push   %ebp
  80277f:	89 e5                	mov    %esp,%ebp
  802781:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802784:	6a 00                	push   $0x0
  802786:	6a 00                	push   $0x0
  802788:	6a 00                	push   $0x0
  80278a:	6a 00                	push   $0x0
  80278c:	6a 00                	push   $0x0
  80278e:	6a 2c                	push   $0x2c
  802790:	e8 4a fa ff ff       	call   8021df <syscall>
  802795:	83 c4 18             	add    $0x18,%esp
  802798:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80279b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80279f:	75 07                	jne    8027a8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a6:	eb 05                	jmp    8027ad <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ad:	c9                   	leave  
  8027ae:	c3                   	ret    

008027af <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
  8027b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 2c                	push   $0x2c
  8027c1:	e8 19 fa ff ff       	call   8021df <syscall>
  8027c6:	83 c4 18             	add    $0x18,%esp
  8027c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027cc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027d0:	75 07                	jne    8027d9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d7:	eb 05                	jmp    8027de <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    

008027e0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027e3:	6a 00                	push   $0x0
  8027e5:	6a 00                	push   $0x0
  8027e7:	6a 00                	push   $0x0
  8027e9:	6a 00                	push   $0x0
  8027eb:	ff 75 08             	pushl  0x8(%ebp)
  8027ee:	6a 2d                	push   $0x2d
  8027f0:	e8 ea f9 ff ff       	call   8021df <syscall>
  8027f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8027f8:	90                   	nop
}
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    

008027fb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
  8027fe:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802802:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802805:	8b 55 0c             	mov    0xc(%ebp),%edx
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	6a 00                	push   $0x0
  80280d:	53                   	push   %ebx
  80280e:	51                   	push   %ecx
  80280f:	52                   	push   %edx
  802810:	50                   	push   %eax
  802811:	6a 2e                	push   $0x2e
  802813:	e8 c7 f9 ff ff       	call   8021df <syscall>
  802818:	83 c4 18             	add    $0x18,%esp
}
  80281b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80281e:	c9                   	leave  
  80281f:	c3                   	ret    

00802820 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802823:	8b 55 0c             	mov    0xc(%ebp),%edx
  802826:	8b 45 08             	mov    0x8(%ebp),%eax
  802829:	6a 00                	push   $0x0
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	52                   	push   %edx
  802830:	50                   	push   %eax
  802831:	6a 2f                	push   $0x2f
  802833:	e8 a7 f9 ff ff       	call   8021df <syscall>
  802838:	83 c4 18             	add    $0x18,%esp
}
  80283b:	c9                   	leave  
  80283c:	c3                   	ret    

0080283d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
  802840:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802843:	83 ec 0c             	sub    $0xc,%esp
  802846:	68 64 4a 80 00       	push   $0x804a64
  80284b:	e8 8c e7 ff ff       	call   800fdc <cprintf>
  802850:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802853:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80285a:	83 ec 0c             	sub    $0xc,%esp
  80285d:	68 90 4a 80 00       	push   $0x804a90
  802862:	e8 75 e7 ff ff       	call   800fdc <cprintf>
  802867:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80286a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80286e:	a1 38 51 80 00       	mov    0x805138,%eax
  802873:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802876:	eb 56                	jmp    8028ce <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802878:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80287c:	74 1c                	je     80289a <print_mem_block_lists+0x5d>
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 50 08             	mov    0x8(%eax),%edx
  802884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802887:	8b 48 08             	mov    0x8(%eax),%ecx
  80288a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288d:	8b 40 0c             	mov    0xc(%eax),%eax
  802890:	01 c8                	add    %ecx,%eax
  802892:	39 c2                	cmp    %eax,%edx
  802894:	73 04                	jae    80289a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802896:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	8b 50 08             	mov    0x8(%eax),%edx
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a6:	01 c2                	add    %eax,%edx
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 40 08             	mov    0x8(%eax),%eax
  8028ae:	83 ec 04             	sub    $0x4,%esp
  8028b1:	52                   	push   %edx
  8028b2:	50                   	push   %eax
  8028b3:	68 a5 4a 80 00       	push   $0x804aa5
  8028b8:	e8 1f e7 ff ff       	call   800fdc <cprintf>
  8028bd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8028cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d2:	74 07                	je     8028db <print_mem_block_lists+0x9e>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	eb 05                	jmp    8028e0 <print_mem_block_lists+0xa3>
  8028db:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e0:	a3 40 51 80 00       	mov    %eax,0x805140
  8028e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	75 8a                	jne    802878 <print_mem_block_lists+0x3b>
  8028ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f2:	75 84                	jne    802878 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8028f4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028f8:	75 10                	jne    80290a <print_mem_block_lists+0xcd>
  8028fa:	83 ec 0c             	sub    $0xc,%esp
  8028fd:	68 b4 4a 80 00       	push   $0x804ab4
  802902:	e8 d5 e6 ff ff       	call   800fdc <cprintf>
  802907:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80290a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802911:	83 ec 0c             	sub    $0xc,%esp
  802914:	68 d8 4a 80 00       	push   $0x804ad8
  802919:	e8 be e6 ff ff       	call   800fdc <cprintf>
  80291e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802921:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802925:	a1 40 50 80 00       	mov    0x805040,%eax
  80292a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80292d:	eb 56                	jmp    802985 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80292f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802933:	74 1c                	je     802951 <print_mem_block_lists+0x114>
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 50 08             	mov    0x8(%eax),%edx
  80293b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293e:	8b 48 08             	mov    0x8(%eax),%ecx
  802941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802944:	8b 40 0c             	mov    0xc(%eax),%eax
  802947:	01 c8                	add    %ecx,%eax
  802949:	39 c2                	cmp    %eax,%edx
  80294b:	73 04                	jae    802951 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80294d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 50 08             	mov    0x8(%eax),%edx
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 40 0c             	mov    0xc(%eax),%eax
  80295d:	01 c2                	add    %eax,%edx
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 40 08             	mov    0x8(%eax),%eax
  802965:	83 ec 04             	sub    $0x4,%esp
  802968:	52                   	push   %edx
  802969:	50                   	push   %eax
  80296a:	68 a5 4a 80 00       	push   $0x804aa5
  80296f:	e8 68 e6 ff ff       	call   800fdc <cprintf>
  802974:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80297d:	a1 48 50 80 00       	mov    0x805048,%eax
  802982:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802985:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802989:	74 07                	je     802992 <print_mem_block_lists+0x155>
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	eb 05                	jmp    802997 <print_mem_block_lists+0x15a>
  802992:	b8 00 00 00 00       	mov    $0x0,%eax
  802997:	a3 48 50 80 00       	mov    %eax,0x805048
  80299c:	a1 48 50 80 00       	mov    0x805048,%eax
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	75 8a                	jne    80292f <print_mem_block_lists+0xf2>
  8029a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a9:	75 84                	jne    80292f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8029ab:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029af:	75 10                	jne    8029c1 <print_mem_block_lists+0x184>
  8029b1:	83 ec 0c             	sub    $0xc,%esp
  8029b4:	68 f0 4a 80 00       	push   $0x804af0
  8029b9:	e8 1e e6 ff ff       	call   800fdc <cprintf>
  8029be:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029c1:	83 ec 0c             	sub    $0xc,%esp
  8029c4:	68 64 4a 80 00       	push   $0x804a64
  8029c9:	e8 0e e6 ff ff       	call   800fdc <cprintf>
  8029ce:	83 c4 10             	add    $0x10,%esp

}
  8029d1:	90                   	nop
  8029d2:	c9                   	leave  
  8029d3:	c3                   	ret    

008029d4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8029d4:	55                   	push   %ebp
  8029d5:	89 e5                	mov    %esp,%ebp
  8029d7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8029da:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8029e1:	00 00 00 
  8029e4:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8029eb:	00 00 00 
  8029ee:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8029f5:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8029f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029ff:	e9 9e 00 00 00       	jmp    802aa2 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802a04:	a1 50 50 80 00       	mov    0x805050,%eax
  802a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0c:	c1 e2 04             	shl    $0x4,%edx
  802a0f:	01 d0                	add    %edx,%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	75 14                	jne    802a29 <initialize_MemBlocksList+0x55>
  802a15:	83 ec 04             	sub    $0x4,%esp
  802a18:	68 18 4b 80 00       	push   $0x804b18
  802a1d:	6a 46                	push   $0x46
  802a1f:	68 3b 4b 80 00       	push   $0x804b3b
  802a24:	e8 ff e2 ff ff       	call   800d28 <_panic>
  802a29:	a1 50 50 80 00       	mov    0x805050,%eax
  802a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a31:	c1 e2 04             	shl    $0x4,%edx
  802a34:	01 d0                	add    %edx,%eax
  802a36:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a3c:	89 10                	mov    %edx,(%eax)
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	74 18                	je     802a5c <initialize_MemBlocksList+0x88>
  802a44:	a1 48 51 80 00       	mov    0x805148,%eax
  802a49:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a4f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a52:	c1 e1 04             	shl    $0x4,%ecx
  802a55:	01 ca                	add    %ecx,%edx
  802a57:	89 50 04             	mov    %edx,0x4(%eax)
  802a5a:	eb 12                	jmp    802a6e <initialize_MemBlocksList+0x9a>
  802a5c:	a1 50 50 80 00       	mov    0x805050,%eax
  802a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a64:	c1 e2 04             	shl    $0x4,%edx
  802a67:	01 d0                	add    %edx,%eax
  802a69:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a6e:	a1 50 50 80 00       	mov    0x805050,%eax
  802a73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a76:	c1 e2 04             	shl    $0x4,%edx
  802a79:	01 d0                	add    %edx,%eax
  802a7b:	a3 48 51 80 00       	mov    %eax,0x805148
  802a80:	a1 50 50 80 00       	mov    0x805050,%eax
  802a85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a88:	c1 e2 04             	shl    $0x4,%edx
  802a8b:	01 d0                	add    %edx,%eax
  802a8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a94:	a1 54 51 80 00       	mov    0x805154,%eax
  802a99:	40                   	inc    %eax
  802a9a:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802a9f:	ff 45 f4             	incl   -0xc(%ebp)
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa8:	0f 82 56 ff ff ff    	jb     802a04 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802aae:	90                   	nop
  802aaf:	c9                   	leave  
  802ab0:	c3                   	ret    

00802ab1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802ab1:	55                   	push   %ebp
  802ab2:	89 e5                	mov    %esp,%ebp
  802ab4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	8b 00                	mov    (%eax),%eax
  802abc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802abf:	eb 19                	jmp    802ada <find_block+0x29>
	{
		if(va==point->sva)
  802ac1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ac4:	8b 40 08             	mov    0x8(%eax),%eax
  802ac7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802aca:	75 05                	jne    802ad1 <find_block+0x20>
		   return point;
  802acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802acf:	eb 36                	jmp    802b07 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	8b 40 08             	mov    0x8(%eax),%eax
  802ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ada:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802ade:	74 07                	je     802ae7 <find_block+0x36>
  802ae0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ae3:	8b 00                	mov    (%eax),%eax
  802ae5:	eb 05                	jmp    802aec <find_block+0x3b>
  802ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aec:	8b 55 08             	mov    0x8(%ebp),%edx
  802aef:	89 42 08             	mov    %eax,0x8(%edx)
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	8b 40 08             	mov    0x8(%eax),%eax
  802af8:	85 c0                	test   %eax,%eax
  802afa:	75 c5                	jne    802ac1 <find_block+0x10>
  802afc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b00:	75 bf                	jne    802ac1 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802b02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b07:	c9                   	leave  
  802b08:	c3                   	ret    

00802b09 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b09:	55                   	push   %ebp
  802b0a:	89 e5                	mov    %esp,%ebp
  802b0c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802b0f:	a1 40 50 80 00       	mov    0x805040,%eax
  802b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802b17:	a1 44 50 80 00       	mov    0x805044,%eax
  802b1c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b22:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b25:	74 24                	je     802b4b <insert_sorted_allocList+0x42>
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	8b 50 08             	mov    0x8(%eax),%edx
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	8b 40 08             	mov    0x8(%eax),%eax
  802b33:	39 c2                	cmp    %eax,%edx
  802b35:	76 14                	jbe    802b4b <insert_sorted_allocList+0x42>
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	8b 50 08             	mov    0x8(%eax),%edx
  802b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b40:	8b 40 08             	mov    0x8(%eax),%eax
  802b43:	39 c2                	cmp    %eax,%edx
  802b45:	0f 82 60 01 00 00    	jb     802cab <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802b4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4f:	75 65                	jne    802bb6 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802b51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b55:	75 14                	jne    802b6b <insert_sorted_allocList+0x62>
  802b57:	83 ec 04             	sub    $0x4,%esp
  802b5a:	68 18 4b 80 00       	push   $0x804b18
  802b5f:	6a 6b                	push   $0x6b
  802b61:	68 3b 4b 80 00       	push   $0x804b3b
  802b66:	e8 bd e1 ff ff       	call   800d28 <_panic>
  802b6b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b71:	8b 45 08             	mov    0x8(%ebp),%eax
  802b74:	89 10                	mov    %edx,(%eax)
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	74 0d                	je     802b8c <insert_sorted_allocList+0x83>
  802b7f:	a1 40 50 80 00       	mov    0x805040,%eax
  802b84:	8b 55 08             	mov    0x8(%ebp),%edx
  802b87:	89 50 04             	mov    %edx,0x4(%eax)
  802b8a:	eb 08                	jmp    802b94 <insert_sorted_allocList+0x8b>
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	a3 44 50 80 00       	mov    %eax,0x805044
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	a3 40 50 80 00       	mov    %eax,0x805040
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bab:	40                   	inc    %eax
  802bac:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802bb1:	e9 dc 01 00 00       	jmp    802d92 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 40 08             	mov    0x8(%eax),%eax
  802bc2:	39 c2                	cmp    %eax,%edx
  802bc4:	77 6c                	ja     802c32 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802bc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bca:	74 06                	je     802bd2 <insert_sorted_allocList+0xc9>
  802bcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd0:	75 14                	jne    802be6 <insert_sorted_allocList+0xdd>
  802bd2:	83 ec 04             	sub    $0x4,%esp
  802bd5:	68 54 4b 80 00       	push   $0x804b54
  802bda:	6a 6f                	push   $0x6f
  802bdc:	68 3b 4b 80 00       	push   $0x804b3b
  802be1:	e8 42 e1 ff ff       	call   800d28 <_panic>
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	8b 50 04             	mov    0x4(%eax),%edx
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	89 50 04             	mov    %edx,0x4(%eax)
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bf8:	89 10                	mov    %edx,(%eax)
  802bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfd:	8b 40 04             	mov    0x4(%eax),%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	74 0d                	je     802c11 <insert_sorted_allocList+0x108>
  802c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c07:	8b 40 04             	mov    0x4(%eax),%eax
  802c0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0d:	89 10                	mov    %edx,(%eax)
  802c0f:	eb 08                	jmp    802c19 <insert_sorted_allocList+0x110>
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	a3 40 50 80 00       	mov    %eax,0x805040
  802c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1f:	89 50 04             	mov    %edx,0x4(%eax)
  802c22:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c27:	40                   	inc    %eax
  802c28:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802c2d:	e9 60 01 00 00       	jmp    802d92 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	8b 50 08             	mov    0x8(%eax),%edx
  802c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3b:	8b 40 08             	mov    0x8(%eax),%eax
  802c3e:	39 c2                	cmp    %eax,%edx
  802c40:	0f 82 4c 01 00 00    	jb     802d92 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802c46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4a:	75 14                	jne    802c60 <insert_sorted_allocList+0x157>
  802c4c:	83 ec 04             	sub    $0x4,%esp
  802c4f:	68 8c 4b 80 00       	push   $0x804b8c
  802c54:	6a 73                	push   $0x73
  802c56:	68 3b 4b 80 00       	push   $0x804b3b
  802c5b:	e8 c8 e0 ff ff       	call   800d28 <_panic>
  802c60:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	89 50 04             	mov    %edx,0x4(%eax)
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	8b 40 04             	mov    0x4(%eax),%eax
  802c72:	85 c0                	test   %eax,%eax
  802c74:	74 0c                	je     802c82 <insert_sorted_allocList+0x179>
  802c76:	a1 44 50 80 00       	mov    0x805044,%eax
  802c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7e:	89 10                	mov    %edx,(%eax)
  802c80:	eb 08                	jmp    802c8a <insert_sorted_allocList+0x181>
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	a3 40 50 80 00       	mov    %eax,0x805040
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	a3 44 50 80 00       	mov    %eax,0x805044
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ca0:	40                   	inc    %eax
  802ca1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802ca6:	e9 e7 00 00 00       	jmp    802d92 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802cb1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802cb8:	a1 40 50 80 00       	mov    0x805040,%eax
  802cbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc0:	e9 9d 00 00 00       	jmp    802d62 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 40 08             	mov    0x8(%eax),%eax
  802cd9:	39 c2                	cmp    %eax,%edx
  802cdb:	76 7d                	jbe    802d5a <insert_sorted_allocList+0x251>
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	8b 50 08             	mov    0x8(%eax),%edx
  802ce3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce6:	8b 40 08             	mov    0x8(%eax),%eax
  802ce9:	39 c2                	cmp    %eax,%edx
  802ceb:	73 6d                	jae    802d5a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802ced:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf1:	74 06                	je     802cf9 <insert_sorted_allocList+0x1f0>
  802cf3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf7:	75 14                	jne    802d0d <insert_sorted_allocList+0x204>
  802cf9:	83 ec 04             	sub    $0x4,%esp
  802cfc:	68 b0 4b 80 00       	push   $0x804bb0
  802d01:	6a 7f                	push   $0x7f
  802d03:	68 3b 4b 80 00       	push   $0x804b3b
  802d08:	e8 1b e0 ff ff       	call   800d28 <_panic>
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	8b 10                	mov    (%eax),%edx
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	89 10                	mov    %edx,(%eax)
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	8b 00                	mov    (%eax),%eax
  802d1c:	85 c0                	test   %eax,%eax
  802d1e:	74 0b                	je     802d2b <insert_sorted_allocList+0x222>
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	8b 00                	mov    (%eax),%eax
  802d25:	8b 55 08             	mov    0x8(%ebp),%edx
  802d28:	89 50 04             	mov    %edx,0x4(%eax)
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d31:	89 10                	mov    %edx,(%eax)
  802d33:	8b 45 08             	mov    0x8(%ebp),%eax
  802d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d39:	89 50 04             	mov    %edx,0x4(%eax)
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	85 c0                	test   %eax,%eax
  802d43:	75 08                	jne    802d4d <insert_sorted_allocList+0x244>
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	a3 44 50 80 00       	mov    %eax,0x805044
  802d4d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d52:	40                   	inc    %eax
  802d53:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802d58:	eb 39                	jmp    802d93 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802d5a:	a1 48 50 80 00       	mov    0x805048,%eax
  802d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d66:	74 07                	je     802d6f <insert_sorted_allocList+0x266>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	eb 05                	jmp    802d74 <insert_sorted_allocList+0x26b>
  802d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d74:	a3 48 50 80 00       	mov    %eax,0x805048
  802d79:	a1 48 50 80 00       	mov    0x805048,%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	0f 85 3f ff ff ff    	jne    802cc5 <insert_sorted_allocList+0x1bc>
  802d86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8a:	0f 85 35 ff ff ff    	jne    802cc5 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802d90:	eb 01                	jmp    802d93 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802d92:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802d93:	90                   	nop
  802d94:	c9                   	leave  
  802d95:	c3                   	ret    

00802d96 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d96:	55                   	push   %ebp
  802d97:	89 e5                	mov    %esp,%ebp
  802d99:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802d9c:	a1 38 51 80 00       	mov    0x805138,%eax
  802da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da4:	e9 85 01 00 00       	jmp    802f2e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dac:	8b 40 0c             	mov    0xc(%eax),%eax
  802daf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802db2:	0f 82 6e 01 00 00    	jb     802f26 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dc1:	0f 85 8a 00 00 00    	jne    802e51 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802dc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dcb:	75 17                	jne    802de4 <alloc_block_FF+0x4e>
  802dcd:	83 ec 04             	sub    $0x4,%esp
  802dd0:	68 e4 4b 80 00       	push   $0x804be4
  802dd5:	68 93 00 00 00       	push   $0x93
  802dda:	68 3b 4b 80 00       	push   $0x804b3b
  802ddf:	e8 44 df ff ff       	call   800d28 <_panic>
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 00                	mov    (%eax),%eax
  802de9:	85 c0                	test   %eax,%eax
  802deb:	74 10                	je     802dfd <alloc_block_FF+0x67>
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df5:	8b 52 04             	mov    0x4(%edx),%edx
  802df8:	89 50 04             	mov    %edx,0x4(%eax)
  802dfb:	eb 0b                	jmp    802e08 <alloc_block_FF+0x72>
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 40 04             	mov    0x4(%eax),%eax
  802e03:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 40 04             	mov    0x4(%eax),%eax
  802e0e:	85 c0                	test   %eax,%eax
  802e10:	74 0f                	je     802e21 <alloc_block_FF+0x8b>
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 40 04             	mov    0x4(%eax),%eax
  802e18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e1b:	8b 12                	mov    (%edx),%edx
  802e1d:	89 10                	mov    %edx,(%eax)
  802e1f:	eb 0a                	jmp    802e2b <alloc_block_FF+0x95>
  802e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e24:	8b 00                	mov    (%eax),%eax
  802e26:	a3 38 51 80 00       	mov    %eax,0x805138
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e43:	48                   	dec    %eax
  802e44:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	e9 10 01 00 00       	jmp    802f61 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 0c             	mov    0xc(%eax),%eax
  802e57:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e5a:	0f 86 c6 00 00 00    	jbe    802f26 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802e60:	a1 48 51 80 00       	mov    0x805148,%eax
  802e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 50 08             	mov    0x8(%eax),%edx
  802e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e71:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e77:	8b 55 08             	mov    0x8(%ebp),%edx
  802e7a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802e7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e81:	75 17                	jne    802e9a <alloc_block_FF+0x104>
  802e83:	83 ec 04             	sub    $0x4,%esp
  802e86:	68 e4 4b 80 00       	push   $0x804be4
  802e8b:	68 9b 00 00 00       	push   $0x9b
  802e90:	68 3b 4b 80 00       	push   $0x804b3b
  802e95:	e8 8e de ff ff       	call   800d28 <_panic>
  802e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9d:	8b 00                	mov    (%eax),%eax
  802e9f:	85 c0                	test   %eax,%eax
  802ea1:	74 10                	je     802eb3 <alloc_block_FF+0x11d>
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eab:	8b 52 04             	mov    0x4(%edx),%edx
  802eae:	89 50 04             	mov    %edx,0x4(%eax)
  802eb1:	eb 0b                	jmp    802ebe <alloc_block_FF+0x128>
  802eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb6:	8b 40 04             	mov    0x4(%eax),%eax
  802eb9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec1:	8b 40 04             	mov    0x4(%eax),%eax
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	74 0f                	je     802ed7 <alloc_block_FF+0x141>
  802ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecb:	8b 40 04             	mov    0x4(%eax),%eax
  802ece:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ed1:	8b 12                	mov    (%edx),%edx
  802ed3:	89 10                	mov    %edx,(%eax)
  802ed5:	eb 0a                	jmp    802ee1 <alloc_block_FF+0x14b>
  802ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eda:	8b 00                	mov    (%eax),%eax
  802edc:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef4:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef9:	48                   	dec    %eax
  802efa:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f02:	8b 50 08             	mov    0x8(%eax),%edx
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	01 c2                	add    %eax,%edx
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	8b 40 0c             	mov    0xc(%eax),%eax
  802f16:	2b 45 08             	sub    0x8(%ebp),%eax
  802f19:	89 c2                	mov    %eax,%edx
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f24:	eb 3b                	jmp    802f61 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802f26:	a1 40 51 80 00       	mov    0x805140,%eax
  802f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f32:	74 07                	je     802f3b <alloc_block_FF+0x1a5>
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 00                	mov    (%eax),%eax
  802f39:	eb 05                	jmp    802f40 <alloc_block_FF+0x1aa>
  802f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f40:	a3 40 51 80 00       	mov    %eax,0x805140
  802f45:	a1 40 51 80 00       	mov    0x805140,%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	0f 85 57 fe ff ff    	jne    802da9 <alloc_block_FF+0x13>
  802f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f56:	0f 85 4d fe ff ff    	jne    802da9 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802f5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f61:	c9                   	leave  
  802f62:	c3                   	ret    

00802f63 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802f63:	55                   	push   %ebp
  802f64:	89 e5                	mov    %esp,%ebp
  802f66:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802f69:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802f70:	a1 38 51 80 00       	mov    0x805138,%eax
  802f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f78:	e9 df 00 00 00       	jmp    80305c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 40 0c             	mov    0xc(%eax),%eax
  802f83:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f86:	0f 82 c8 00 00 00    	jb     803054 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f92:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f95:	0f 85 8a 00 00 00    	jne    803025 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802f9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9f:	75 17                	jne    802fb8 <alloc_block_BF+0x55>
  802fa1:	83 ec 04             	sub    $0x4,%esp
  802fa4:	68 e4 4b 80 00       	push   $0x804be4
  802fa9:	68 b7 00 00 00       	push   $0xb7
  802fae:	68 3b 4b 80 00       	push   $0x804b3b
  802fb3:	e8 70 dd ff ff       	call   800d28 <_panic>
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 00                	mov    (%eax),%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	74 10                	je     802fd1 <alloc_block_BF+0x6e>
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc9:	8b 52 04             	mov    0x4(%edx),%edx
  802fcc:	89 50 04             	mov    %edx,0x4(%eax)
  802fcf:	eb 0b                	jmp    802fdc <alloc_block_BF+0x79>
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	8b 40 04             	mov    0x4(%eax),%eax
  802fd7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdf:	8b 40 04             	mov    0x4(%eax),%eax
  802fe2:	85 c0                	test   %eax,%eax
  802fe4:	74 0f                	je     802ff5 <alloc_block_BF+0x92>
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 40 04             	mov    0x4(%eax),%eax
  802fec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fef:	8b 12                	mov    (%edx),%edx
  802ff1:	89 10                	mov    %edx,(%eax)
  802ff3:	eb 0a                	jmp    802fff <alloc_block_BF+0x9c>
  802ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	a3 38 51 80 00       	mov    %eax,0x805138
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803012:	a1 44 51 80 00       	mov    0x805144,%eax
  803017:	48                   	dec    %eax
  803018:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	e9 4d 01 00 00       	jmp    803172 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  803025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803028:	8b 40 0c             	mov    0xc(%eax),%eax
  80302b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80302e:	76 24                	jbe    803054 <alloc_block_BF+0xf1>
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	8b 40 0c             	mov    0xc(%eax),%eax
  803036:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803039:	73 19                	jae    803054 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80303b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 40 0c             	mov    0xc(%eax),%eax
  803048:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	8b 40 08             	mov    0x8(%eax),%eax
  803051:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  803054:	a1 40 51 80 00       	mov    0x805140,%eax
  803059:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80305c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803060:	74 07                	je     803069 <alloc_block_BF+0x106>
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	8b 00                	mov    (%eax),%eax
  803067:	eb 05                	jmp    80306e <alloc_block_BF+0x10b>
  803069:	b8 00 00 00 00       	mov    $0x0,%eax
  80306e:	a3 40 51 80 00       	mov    %eax,0x805140
  803073:	a1 40 51 80 00       	mov    0x805140,%eax
  803078:	85 c0                	test   %eax,%eax
  80307a:	0f 85 fd fe ff ff    	jne    802f7d <alloc_block_BF+0x1a>
  803080:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803084:	0f 85 f3 fe ff ff    	jne    802f7d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80308a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80308e:	0f 84 d9 00 00 00    	je     80316d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  803094:	a1 48 51 80 00       	mov    0x805148,%eax
  803099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80309c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80309f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030a2:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8030a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ab:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8030ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030b2:	75 17                	jne    8030cb <alloc_block_BF+0x168>
  8030b4:	83 ec 04             	sub    $0x4,%esp
  8030b7:	68 e4 4b 80 00       	push   $0x804be4
  8030bc:	68 c7 00 00 00       	push   $0xc7
  8030c1:	68 3b 4b 80 00       	push   $0x804b3b
  8030c6:	e8 5d dc ff ff       	call   800d28 <_panic>
  8030cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ce:	8b 00                	mov    (%eax),%eax
  8030d0:	85 c0                	test   %eax,%eax
  8030d2:	74 10                	je     8030e4 <alloc_block_BF+0x181>
  8030d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030dc:	8b 52 04             	mov    0x4(%edx),%edx
  8030df:	89 50 04             	mov    %edx,0x4(%eax)
  8030e2:	eb 0b                	jmp    8030ef <alloc_block_BF+0x18c>
  8030e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f2:	8b 40 04             	mov    0x4(%eax),%eax
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	74 0f                	je     803108 <alloc_block_BF+0x1a5>
  8030f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fc:	8b 40 04             	mov    0x4(%eax),%eax
  8030ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803102:	8b 12                	mov    (%edx),%edx
  803104:	89 10                	mov    %edx,(%eax)
  803106:	eb 0a                	jmp    803112 <alloc_block_BF+0x1af>
  803108:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	a3 48 51 80 00       	mov    %eax,0x805148
  803112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803115:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803125:	a1 54 51 80 00       	mov    0x805154,%eax
  80312a:	48                   	dec    %eax
  80312b:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  803130:	83 ec 08             	sub    $0x8,%esp
  803133:	ff 75 ec             	pushl  -0x14(%ebp)
  803136:	68 38 51 80 00       	push   $0x805138
  80313b:	e8 71 f9 ff ff       	call   802ab1 <find_block>
  803140:	83 c4 10             	add    $0x10,%esp
  803143:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  803146:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803149:	8b 50 08             	mov    0x8(%eax),%edx
  80314c:	8b 45 08             	mov    0x8(%ebp),%eax
  80314f:	01 c2                	add    %eax,%edx
  803151:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803154:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  803157:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80315a:	8b 40 0c             	mov    0xc(%eax),%eax
  80315d:	2b 45 08             	sub    0x8(%ebp),%eax
  803160:	89 c2                	mov    %eax,%edx
  803162:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803165:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  803168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316b:	eb 05                	jmp    803172 <alloc_block_BF+0x20f>
	}
	return NULL;
  80316d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803172:	c9                   	leave  
  803173:	c3                   	ret    

00803174 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803174:	55                   	push   %ebp
  803175:	89 e5                	mov    %esp,%ebp
  803177:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80317a:	a1 28 50 80 00       	mov    0x805028,%eax
  80317f:	85 c0                	test   %eax,%eax
  803181:	0f 85 de 01 00 00    	jne    803365 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  803187:	a1 38 51 80 00       	mov    0x805138,%eax
  80318c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80318f:	e9 9e 01 00 00       	jmp    803332 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  803194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803197:	8b 40 0c             	mov    0xc(%eax),%eax
  80319a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80319d:	0f 82 87 01 00 00    	jb     80332a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031ac:	0f 85 95 00 00 00    	jne    803247 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8031b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b6:	75 17                	jne    8031cf <alloc_block_NF+0x5b>
  8031b8:	83 ec 04             	sub    $0x4,%esp
  8031bb:	68 e4 4b 80 00       	push   $0x804be4
  8031c0:	68 e0 00 00 00       	push   $0xe0
  8031c5:	68 3b 4b 80 00       	push   $0x804b3b
  8031ca:	e8 59 db ff ff       	call   800d28 <_panic>
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	8b 00                	mov    (%eax),%eax
  8031d4:	85 c0                	test   %eax,%eax
  8031d6:	74 10                	je     8031e8 <alloc_block_NF+0x74>
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	8b 00                	mov    (%eax),%eax
  8031dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031e0:	8b 52 04             	mov    0x4(%edx),%edx
  8031e3:	89 50 04             	mov    %edx,0x4(%eax)
  8031e6:	eb 0b                	jmp    8031f3 <alloc_block_NF+0x7f>
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	8b 40 04             	mov    0x4(%eax),%eax
  8031ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 40 04             	mov    0x4(%eax),%eax
  8031f9:	85 c0                	test   %eax,%eax
  8031fb:	74 0f                	je     80320c <alloc_block_NF+0x98>
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 40 04             	mov    0x4(%eax),%eax
  803203:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803206:	8b 12                	mov    (%edx),%edx
  803208:	89 10                	mov    %edx,(%eax)
  80320a:	eb 0a                	jmp    803216 <alloc_block_NF+0xa2>
  80320c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320f:	8b 00                	mov    (%eax),%eax
  803211:	a3 38 51 80 00       	mov    %eax,0x805138
  803216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803219:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803229:	a1 44 51 80 00       	mov    0x805144,%eax
  80322e:	48                   	dec    %eax
  80322f:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	8b 40 08             	mov    0x8(%eax),%eax
  80323a:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80323f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803242:	e9 f8 04 00 00       	jmp    80373f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  803247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324a:	8b 40 0c             	mov    0xc(%eax),%eax
  80324d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803250:	0f 86 d4 00 00 00    	jbe    80332a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803256:	a1 48 51 80 00       	mov    0x805148,%eax
  80325b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80325e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803261:	8b 50 08             	mov    0x8(%eax),%edx
  803264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803267:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80326a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326d:	8b 55 08             	mov    0x8(%ebp),%edx
  803270:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803273:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803277:	75 17                	jne    803290 <alloc_block_NF+0x11c>
  803279:	83 ec 04             	sub    $0x4,%esp
  80327c:	68 e4 4b 80 00       	push   $0x804be4
  803281:	68 e9 00 00 00       	push   $0xe9
  803286:	68 3b 4b 80 00       	push   $0x804b3b
  80328b:	e8 98 da ff ff       	call   800d28 <_panic>
  803290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803293:	8b 00                	mov    (%eax),%eax
  803295:	85 c0                	test   %eax,%eax
  803297:	74 10                	je     8032a9 <alloc_block_NF+0x135>
  803299:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329c:	8b 00                	mov    (%eax),%eax
  80329e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032a1:	8b 52 04             	mov    0x4(%edx),%edx
  8032a4:	89 50 04             	mov    %edx,0x4(%eax)
  8032a7:	eb 0b                	jmp    8032b4 <alloc_block_NF+0x140>
  8032a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ac:	8b 40 04             	mov    0x4(%eax),%eax
  8032af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ba:	85 c0                	test   %eax,%eax
  8032bc:	74 0f                	je     8032cd <alloc_block_NF+0x159>
  8032be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c1:	8b 40 04             	mov    0x4(%eax),%eax
  8032c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c7:	8b 12                	mov    (%edx),%edx
  8032c9:	89 10                	mov    %edx,(%eax)
  8032cb:	eb 0a                	jmp    8032d7 <alloc_block_NF+0x163>
  8032cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d0:	8b 00                	mov    (%eax),%eax
  8032d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8032d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ef:	48                   	dec    %eax
  8032f0:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8032f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f8:	8b 40 08             	mov    0x8(%eax),%eax
  8032fb:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  803300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803303:	8b 50 08             	mov    0x8(%eax),%edx
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	01 c2                	add    %eax,%edx
  80330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  803311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803314:	8b 40 0c             	mov    0xc(%eax),%eax
  803317:	2b 45 08             	sub    0x8(%ebp),%eax
  80331a:	89 c2                	mov    %eax,%edx
  80331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  803322:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803325:	e9 15 04 00 00       	jmp    80373f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80332a:	a1 40 51 80 00       	mov    0x805140,%eax
  80332f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803332:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803336:	74 07                	je     80333f <alloc_block_NF+0x1cb>
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	8b 00                	mov    (%eax),%eax
  80333d:	eb 05                	jmp    803344 <alloc_block_NF+0x1d0>
  80333f:	b8 00 00 00 00       	mov    $0x0,%eax
  803344:	a3 40 51 80 00       	mov    %eax,0x805140
  803349:	a1 40 51 80 00       	mov    0x805140,%eax
  80334e:	85 c0                	test   %eax,%eax
  803350:	0f 85 3e fe ff ff    	jne    803194 <alloc_block_NF+0x20>
  803356:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80335a:	0f 85 34 fe ff ff    	jne    803194 <alloc_block_NF+0x20>
  803360:	e9 d5 03 00 00       	jmp    80373a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  803365:	a1 38 51 80 00       	mov    0x805138,%eax
  80336a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336d:	e9 b1 01 00 00       	jmp    803523 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	8b 50 08             	mov    0x8(%eax),%edx
  803378:	a1 28 50 80 00       	mov    0x805028,%eax
  80337d:	39 c2                	cmp    %eax,%edx
  80337f:	0f 82 96 01 00 00    	jb     80351b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	8b 40 0c             	mov    0xc(%eax),%eax
  80338b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80338e:	0f 82 87 01 00 00    	jb     80351b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	8b 40 0c             	mov    0xc(%eax),%eax
  80339a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80339d:	0f 85 95 00 00 00    	jne    803438 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8033a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a7:	75 17                	jne    8033c0 <alloc_block_NF+0x24c>
  8033a9:	83 ec 04             	sub    $0x4,%esp
  8033ac:	68 e4 4b 80 00       	push   $0x804be4
  8033b1:	68 fc 00 00 00       	push   $0xfc
  8033b6:	68 3b 4b 80 00       	push   $0x804b3b
  8033bb:	e8 68 d9 ff ff       	call   800d28 <_panic>
  8033c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	85 c0                	test   %eax,%eax
  8033c7:	74 10                	je     8033d9 <alloc_block_NF+0x265>
  8033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cc:	8b 00                	mov    (%eax),%eax
  8033ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033d1:	8b 52 04             	mov    0x4(%edx),%edx
  8033d4:	89 50 04             	mov    %edx,0x4(%eax)
  8033d7:	eb 0b                	jmp    8033e4 <alloc_block_NF+0x270>
  8033d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dc:	8b 40 04             	mov    0x4(%eax),%eax
  8033df:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e7:	8b 40 04             	mov    0x4(%eax),%eax
  8033ea:	85 c0                	test   %eax,%eax
  8033ec:	74 0f                	je     8033fd <alloc_block_NF+0x289>
  8033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f1:	8b 40 04             	mov    0x4(%eax),%eax
  8033f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033f7:	8b 12                	mov    (%edx),%edx
  8033f9:	89 10                	mov    %edx,(%eax)
  8033fb:	eb 0a                	jmp    803407 <alloc_block_NF+0x293>
  8033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803400:	8b 00                	mov    (%eax),%eax
  803402:	a3 38 51 80 00       	mov    %eax,0x805138
  803407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803413:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341a:	a1 44 51 80 00       	mov    0x805144,%eax
  80341f:	48                   	dec    %eax
  803420:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803428:	8b 40 08             	mov    0x8(%eax),%eax
  80342b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  803430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803433:	e9 07 03 00 00       	jmp    80373f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343b:	8b 40 0c             	mov    0xc(%eax),%eax
  80343e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803441:	0f 86 d4 00 00 00    	jbe    80351b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803447:	a1 48 51 80 00       	mov    0x805148,%eax
  80344c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	8b 50 08             	mov    0x8(%eax),%edx
  803455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803458:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80345b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345e:	8b 55 08             	mov    0x8(%ebp),%edx
  803461:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803464:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803468:	75 17                	jne    803481 <alloc_block_NF+0x30d>
  80346a:	83 ec 04             	sub    $0x4,%esp
  80346d:	68 e4 4b 80 00       	push   $0x804be4
  803472:	68 04 01 00 00       	push   $0x104
  803477:	68 3b 4b 80 00       	push   $0x804b3b
  80347c:	e8 a7 d8 ff ff       	call   800d28 <_panic>
  803481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803484:	8b 00                	mov    (%eax),%eax
  803486:	85 c0                	test   %eax,%eax
  803488:	74 10                	je     80349a <alloc_block_NF+0x326>
  80348a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348d:	8b 00                	mov    (%eax),%eax
  80348f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803492:	8b 52 04             	mov    0x4(%edx),%edx
  803495:	89 50 04             	mov    %edx,0x4(%eax)
  803498:	eb 0b                	jmp    8034a5 <alloc_block_NF+0x331>
  80349a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349d:	8b 40 04             	mov    0x4(%eax),%eax
  8034a0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a8:	8b 40 04             	mov    0x4(%eax),%eax
  8034ab:	85 c0                	test   %eax,%eax
  8034ad:	74 0f                	je     8034be <alloc_block_NF+0x34a>
  8034af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b2:	8b 40 04             	mov    0x4(%eax),%eax
  8034b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034b8:	8b 12                	mov    (%edx),%edx
  8034ba:	89 10                	mov    %edx,(%eax)
  8034bc:	eb 0a                	jmp    8034c8 <alloc_block_NF+0x354>
  8034be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c1:	8b 00                	mov    (%eax),%eax
  8034c3:	a3 48 51 80 00       	mov    %eax,0x805148
  8034c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034db:	a1 54 51 80 00       	mov    0x805154,%eax
  8034e0:	48                   	dec    %eax
  8034e1:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8034e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e9:	8b 40 08             	mov    0x8(%eax),%eax
  8034ec:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f4:	8b 50 08             	mov    0x8(%eax),%edx
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	01 c2                	add    %eax,%edx
  8034fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ff:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  803502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803505:	8b 40 0c             	mov    0xc(%eax),%eax
  803508:	2b 45 08             	sub    0x8(%ebp),%eax
  80350b:	89 c2                	mov    %eax,%edx
  80350d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803510:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  803513:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803516:	e9 24 02 00 00       	jmp    80373f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80351b:	a1 40 51 80 00       	mov    0x805140,%eax
  803520:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803523:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803527:	74 07                	je     803530 <alloc_block_NF+0x3bc>
  803529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352c:	8b 00                	mov    (%eax),%eax
  80352e:	eb 05                	jmp    803535 <alloc_block_NF+0x3c1>
  803530:	b8 00 00 00 00       	mov    $0x0,%eax
  803535:	a3 40 51 80 00       	mov    %eax,0x805140
  80353a:	a1 40 51 80 00       	mov    0x805140,%eax
  80353f:	85 c0                	test   %eax,%eax
  803541:	0f 85 2b fe ff ff    	jne    803372 <alloc_block_NF+0x1fe>
  803547:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80354b:	0f 85 21 fe ff ff    	jne    803372 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803551:	a1 38 51 80 00       	mov    0x805138,%eax
  803556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803559:	e9 ae 01 00 00       	jmp    80370c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80355e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803561:	8b 50 08             	mov    0x8(%eax),%edx
  803564:	a1 28 50 80 00       	mov    0x805028,%eax
  803569:	39 c2                	cmp    %eax,%edx
  80356b:	0f 83 93 01 00 00    	jae    803704 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  803571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803574:	8b 40 0c             	mov    0xc(%eax),%eax
  803577:	3b 45 08             	cmp    0x8(%ebp),%eax
  80357a:	0f 82 84 01 00 00    	jb     803704 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  803580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803583:	8b 40 0c             	mov    0xc(%eax),%eax
  803586:	3b 45 08             	cmp    0x8(%ebp),%eax
  803589:	0f 85 95 00 00 00    	jne    803624 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80358f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803593:	75 17                	jne    8035ac <alloc_block_NF+0x438>
  803595:	83 ec 04             	sub    $0x4,%esp
  803598:	68 e4 4b 80 00       	push   $0x804be4
  80359d:	68 14 01 00 00       	push   $0x114
  8035a2:	68 3b 4b 80 00       	push   $0x804b3b
  8035a7:	e8 7c d7 ff ff       	call   800d28 <_panic>
  8035ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035af:	8b 00                	mov    (%eax),%eax
  8035b1:	85 c0                	test   %eax,%eax
  8035b3:	74 10                	je     8035c5 <alloc_block_NF+0x451>
  8035b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b8:	8b 00                	mov    (%eax),%eax
  8035ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035bd:	8b 52 04             	mov    0x4(%edx),%edx
  8035c0:	89 50 04             	mov    %edx,0x4(%eax)
  8035c3:	eb 0b                	jmp    8035d0 <alloc_block_NF+0x45c>
  8035c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c8:	8b 40 04             	mov    0x4(%eax),%eax
  8035cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d3:	8b 40 04             	mov    0x4(%eax),%eax
  8035d6:	85 c0                	test   %eax,%eax
  8035d8:	74 0f                	je     8035e9 <alloc_block_NF+0x475>
  8035da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dd:	8b 40 04             	mov    0x4(%eax),%eax
  8035e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035e3:	8b 12                	mov    (%edx),%edx
  8035e5:	89 10                	mov    %edx,(%eax)
  8035e7:	eb 0a                	jmp    8035f3 <alloc_block_NF+0x47f>
  8035e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ec:	8b 00                	mov    (%eax),%eax
  8035ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8035f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803606:	a1 44 51 80 00       	mov    0x805144,%eax
  80360b:	48                   	dec    %eax
  80360c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  803611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803614:	8b 40 08             	mov    0x8(%eax),%eax
  803617:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80361c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361f:	e9 1b 01 00 00       	jmp    80373f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  803624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803627:	8b 40 0c             	mov    0xc(%eax),%eax
  80362a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80362d:	0f 86 d1 00 00 00    	jbe    803704 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  803633:	a1 48 51 80 00       	mov    0x805148,%eax
  803638:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  80363b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363e:	8b 50 08             	mov    0x8(%eax),%edx
  803641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803644:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  803647:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80364a:	8b 55 08             	mov    0x8(%ebp),%edx
  80364d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  803650:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803654:	75 17                	jne    80366d <alloc_block_NF+0x4f9>
  803656:	83 ec 04             	sub    $0x4,%esp
  803659:	68 e4 4b 80 00       	push   $0x804be4
  80365e:	68 1c 01 00 00       	push   $0x11c
  803663:	68 3b 4b 80 00       	push   $0x804b3b
  803668:	e8 bb d6 ff ff       	call   800d28 <_panic>
  80366d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803670:	8b 00                	mov    (%eax),%eax
  803672:	85 c0                	test   %eax,%eax
  803674:	74 10                	je     803686 <alloc_block_NF+0x512>
  803676:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803679:	8b 00                	mov    (%eax),%eax
  80367b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80367e:	8b 52 04             	mov    0x4(%edx),%edx
  803681:	89 50 04             	mov    %edx,0x4(%eax)
  803684:	eb 0b                	jmp    803691 <alloc_block_NF+0x51d>
  803686:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803689:	8b 40 04             	mov    0x4(%eax),%eax
  80368c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803694:	8b 40 04             	mov    0x4(%eax),%eax
  803697:	85 c0                	test   %eax,%eax
  803699:	74 0f                	je     8036aa <alloc_block_NF+0x536>
  80369b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80369e:	8b 40 04             	mov    0x4(%eax),%eax
  8036a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036a4:	8b 12                	mov    (%edx),%edx
  8036a6:	89 10                	mov    %edx,(%eax)
  8036a8:	eb 0a                	jmp    8036b4 <alloc_block_NF+0x540>
  8036aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ad:	8b 00                	mov    (%eax),%eax
  8036af:	a3 48 51 80 00       	mov    %eax,0x805148
  8036b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8036cc:	48                   	dec    %eax
  8036cd:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8036d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d5:	8b 40 08             	mov    0x8(%eax),%eax
  8036d8:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8036dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e0:	8b 50 08             	mov    0x8(%eax),%edx
  8036e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e6:	01 c2                	add    %eax,%edx
  8036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036eb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8036ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f4:	2b 45 08             	sub    0x8(%ebp),%eax
  8036f7:	89 c2                	mov    %eax,%edx
  8036f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8036ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803702:	eb 3b                	jmp    80373f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  803704:	a1 40 51 80 00       	mov    0x805140,%eax
  803709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80370c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803710:	74 07                	je     803719 <alloc_block_NF+0x5a5>
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	8b 00                	mov    (%eax),%eax
  803717:	eb 05                	jmp    80371e <alloc_block_NF+0x5aa>
  803719:	b8 00 00 00 00       	mov    $0x0,%eax
  80371e:	a3 40 51 80 00       	mov    %eax,0x805140
  803723:	a1 40 51 80 00       	mov    0x805140,%eax
  803728:	85 c0                	test   %eax,%eax
  80372a:	0f 85 2e fe ff ff    	jne    80355e <alloc_block_NF+0x3ea>
  803730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803734:	0f 85 24 fe ff ff    	jne    80355e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80373a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80373f:	c9                   	leave  
  803740:	c3                   	ret    

00803741 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803741:	55                   	push   %ebp
  803742:	89 e5                	mov    %esp,%ebp
  803744:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  803747:	a1 38 51 80 00       	mov    0x805138,%eax
  80374c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  80374f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803754:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  803757:	a1 38 51 80 00       	mov    0x805138,%eax
  80375c:	85 c0                	test   %eax,%eax
  80375e:	74 14                	je     803774 <insert_sorted_with_merge_freeList+0x33>
  803760:	8b 45 08             	mov    0x8(%ebp),%eax
  803763:	8b 50 08             	mov    0x8(%eax),%edx
  803766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803769:	8b 40 08             	mov    0x8(%eax),%eax
  80376c:	39 c2                	cmp    %eax,%edx
  80376e:	0f 87 9b 01 00 00    	ja     80390f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  803774:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803778:	75 17                	jne    803791 <insert_sorted_with_merge_freeList+0x50>
  80377a:	83 ec 04             	sub    $0x4,%esp
  80377d:	68 18 4b 80 00       	push   $0x804b18
  803782:	68 38 01 00 00       	push   $0x138
  803787:	68 3b 4b 80 00       	push   $0x804b3b
  80378c:	e8 97 d5 ff ff       	call   800d28 <_panic>
  803791:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803797:	8b 45 08             	mov    0x8(%ebp),%eax
  80379a:	89 10                	mov    %edx,(%eax)
  80379c:	8b 45 08             	mov    0x8(%ebp),%eax
  80379f:	8b 00                	mov    (%eax),%eax
  8037a1:	85 c0                	test   %eax,%eax
  8037a3:	74 0d                	je     8037b2 <insert_sorted_with_merge_freeList+0x71>
  8037a5:	a1 38 51 80 00       	mov    0x805138,%eax
  8037aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8037ad:	89 50 04             	mov    %edx,0x4(%eax)
  8037b0:	eb 08                	jmp    8037ba <insert_sorted_with_merge_freeList+0x79>
  8037b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8037c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8037d1:	40                   	inc    %eax
  8037d2:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8037d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037db:	0f 84 a8 06 00 00    	je     803e89 <insert_sorted_with_merge_freeList+0x748>
  8037e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e4:	8b 50 08             	mov    0x8(%eax),%edx
  8037e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ed:	01 c2                	add    %eax,%edx
  8037ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f2:	8b 40 08             	mov    0x8(%eax),%eax
  8037f5:	39 c2                	cmp    %eax,%edx
  8037f7:	0f 85 8c 06 00 00    	jne    803e89 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	8b 50 0c             	mov    0xc(%eax),%edx
  803803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803806:	8b 40 0c             	mov    0xc(%eax),%eax
  803809:	01 c2                	add    %eax,%edx
  80380b:	8b 45 08             	mov    0x8(%ebp),%eax
  80380e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  803811:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803815:	75 17                	jne    80382e <insert_sorted_with_merge_freeList+0xed>
  803817:	83 ec 04             	sub    $0x4,%esp
  80381a:	68 e4 4b 80 00       	push   $0x804be4
  80381f:	68 3c 01 00 00       	push   $0x13c
  803824:	68 3b 4b 80 00       	push   $0x804b3b
  803829:	e8 fa d4 ff ff       	call   800d28 <_panic>
  80382e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803831:	8b 00                	mov    (%eax),%eax
  803833:	85 c0                	test   %eax,%eax
  803835:	74 10                	je     803847 <insert_sorted_with_merge_freeList+0x106>
  803837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80383a:	8b 00                	mov    (%eax),%eax
  80383c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80383f:	8b 52 04             	mov    0x4(%edx),%edx
  803842:	89 50 04             	mov    %edx,0x4(%eax)
  803845:	eb 0b                	jmp    803852 <insert_sorted_with_merge_freeList+0x111>
  803847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80384a:	8b 40 04             	mov    0x4(%eax),%eax
  80384d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803855:	8b 40 04             	mov    0x4(%eax),%eax
  803858:	85 c0                	test   %eax,%eax
  80385a:	74 0f                	je     80386b <insert_sorted_with_merge_freeList+0x12a>
  80385c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80385f:	8b 40 04             	mov    0x4(%eax),%eax
  803862:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803865:	8b 12                	mov    (%edx),%edx
  803867:	89 10                	mov    %edx,(%eax)
  803869:	eb 0a                	jmp    803875 <insert_sorted_with_merge_freeList+0x134>
  80386b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80386e:	8b 00                	mov    (%eax),%eax
  803870:	a3 38 51 80 00       	mov    %eax,0x805138
  803875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803878:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80387e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803881:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803888:	a1 44 51 80 00       	mov    0x805144,%eax
  80388d:	48                   	dec    %eax
  80388e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  803893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803896:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  80389d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  8038a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038ab:	75 17                	jne    8038c4 <insert_sorted_with_merge_freeList+0x183>
  8038ad:	83 ec 04             	sub    $0x4,%esp
  8038b0:	68 18 4b 80 00       	push   $0x804b18
  8038b5:	68 3f 01 00 00       	push   $0x13f
  8038ba:	68 3b 4b 80 00       	push   $0x804b3b
  8038bf:	e8 64 d4 ff ff       	call   800d28 <_panic>
  8038c4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038cd:	89 10                	mov    %edx,(%eax)
  8038cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038d2:	8b 00                	mov    (%eax),%eax
  8038d4:	85 c0                	test   %eax,%eax
  8038d6:	74 0d                	je     8038e5 <insert_sorted_with_merge_freeList+0x1a4>
  8038d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8038dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038e0:	89 50 04             	mov    %edx,0x4(%eax)
  8038e3:	eb 08                	jmp    8038ed <insert_sorted_with_merge_freeList+0x1ac>
  8038e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038e8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8038f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ff:	a1 54 51 80 00       	mov    0x805154,%eax
  803904:	40                   	inc    %eax
  803905:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80390a:	e9 7a 05 00 00       	jmp    803e89 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80390f:	8b 45 08             	mov    0x8(%ebp),%eax
  803912:	8b 50 08             	mov    0x8(%eax),%edx
  803915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803918:	8b 40 08             	mov    0x8(%eax),%eax
  80391b:	39 c2                	cmp    %eax,%edx
  80391d:	0f 82 14 01 00 00    	jb     803a37 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  803923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803926:	8b 50 08             	mov    0x8(%eax),%edx
  803929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80392c:	8b 40 0c             	mov    0xc(%eax),%eax
  80392f:	01 c2                	add    %eax,%edx
  803931:	8b 45 08             	mov    0x8(%ebp),%eax
  803934:	8b 40 08             	mov    0x8(%eax),%eax
  803937:	39 c2                	cmp    %eax,%edx
  803939:	0f 85 90 00 00 00    	jne    8039cf <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80393f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803942:	8b 50 0c             	mov    0xc(%eax),%edx
  803945:	8b 45 08             	mov    0x8(%ebp),%eax
  803948:	8b 40 0c             	mov    0xc(%eax),%eax
  80394b:	01 c2                	add    %eax,%edx
  80394d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803950:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803953:	8b 45 08             	mov    0x8(%ebp),%eax
  803956:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  80395d:	8b 45 08             	mov    0x8(%ebp),%eax
  803960:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803967:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80396b:	75 17                	jne    803984 <insert_sorted_with_merge_freeList+0x243>
  80396d:	83 ec 04             	sub    $0x4,%esp
  803970:	68 18 4b 80 00       	push   $0x804b18
  803975:	68 49 01 00 00       	push   $0x149
  80397a:	68 3b 4b 80 00       	push   $0x804b3b
  80397f:	e8 a4 d3 ff ff       	call   800d28 <_panic>
  803984:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80398a:	8b 45 08             	mov    0x8(%ebp),%eax
  80398d:	89 10                	mov    %edx,(%eax)
  80398f:	8b 45 08             	mov    0x8(%ebp),%eax
  803992:	8b 00                	mov    (%eax),%eax
  803994:	85 c0                	test   %eax,%eax
  803996:	74 0d                	je     8039a5 <insert_sorted_with_merge_freeList+0x264>
  803998:	a1 48 51 80 00       	mov    0x805148,%eax
  80399d:	8b 55 08             	mov    0x8(%ebp),%edx
  8039a0:	89 50 04             	mov    %edx,0x4(%eax)
  8039a3:	eb 08                	jmp    8039ad <insert_sorted_with_merge_freeList+0x26c>
  8039a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8039b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039bf:	a1 54 51 80 00       	mov    0x805154,%eax
  8039c4:	40                   	inc    %eax
  8039c5:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8039ca:	e9 bb 04 00 00       	jmp    803e8a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8039cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039d3:	75 17                	jne    8039ec <insert_sorted_with_merge_freeList+0x2ab>
  8039d5:	83 ec 04             	sub    $0x4,%esp
  8039d8:	68 8c 4b 80 00       	push   $0x804b8c
  8039dd:	68 4c 01 00 00       	push   $0x14c
  8039e2:	68 3b 4b 80 00       	push   $0x804b3b
  8039e7:	e8 3c d3 ff ff       	call   800d28 <_panic>
  8039ec:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8039f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f5:	89 50 04             	mov    %edx,0x4(%eax)
  8039f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fb:	8b 40 04             	mov    0x4(%eax),%eax
  8039fe:	85 c0                	test   %eax,%eax
  803a00:	74 0c                	je     803a0e <insert_sorted_with_merge_freeList+0x2cd>
  803a02:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803a07:	8b 55 08             	mov    0x8(%ebp),%edx
  803a0a:	89 10                	mov    %edx,(%eax)
  803a0c:	eb 08                	jmp    803a16 <insert_sorted_with_merge_freeList+0x2d5>
  803a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a11:	a3 38 51 80 00       	mov    %eax,0x805138
  803a16:	8b 45 08             	mov    0x8(%ebp),%eax
  803a19:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  803a21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a27:	a1 44 51 80 00       	mov    0x805144,%eax
  803a2c:	40                   	inc    %eax
  803a2d:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803a32:	e9 53 04 00 00       	jmp    803e8a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803a37:	a1 38 51 80 00       	mov    0x805138,%eax
  803a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a3f:	e9 15 04 00 00       	jmp    803e59 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a47:	8b 00                	mov    (%eax),%eax
  803a49:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4f:	8b 50 08             	mov    0x8(%eax),%edx
  803a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a55:	8b 40 08             	mov    0x8(%eax),%eax
  803a58:	39 c2                	cmp    %eax,%edx
  803a5a:	0f 86 f1 03 00 00    	jbe    803e51 <insert_sorted_with_merge_freeList+0x710>
  803a60:	8b 45 08             	mov    0x8(%ebp),%eax
  803a63:	8b 50 08             	mov    0x8(%eax),%edx
  803a66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a69:	8b 40 08             	mov    0x8(%eax),%eax
  803a6c:	39 c2                	cmp    %eax,%edx
  803a6e:	0f 83 dd 03 00 00    	jae    803e51 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a77:	8b 50 08             	mov    0x8(%eax),%edx
  803a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7d:	8b 40 0c             	mov    0xc(%eax),%eax
  803a80:	01 c2                	add    %eax,%edx
  803a82:	8b 45 08             	mov    0x8(%ebp),%eax
  803a85:	8b 40 08             	mov    0x8(%eax),%eax
  803a88:	39 c2                	cmp    %eax,%edx
  803a8a:	0f 85 b9 01 00 00    	jne    803c49 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803a90:	8b 45 08             	mov    0x8(%ebp),%eax
  803a93:	8b 50 08             	mov    0x8(%eax),%edx
  803a96:	8b 45 08             	mov    0x8(%ebp),%eax
  803a99:	8b 40 0c             	mov    0xc(%eax),%eax
  803a9c:	01 c2                	add    %eax,%edx
  803a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803aa1:	8b 40 08             	mov    0x8(%eax),%eax
  803aa4:	39 c2                	cmp    %eax,%edx
  803aa6:	0f 85 0d 01 00 00    	jne    803bb9 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aaf:	8b 50 0c             	mov    0xc(%eax),%edx
  803ab2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ab5:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab8:	01 c2                	add    %eax,%edx
  803aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abd:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803ac0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ac4:	75 17                	jne    803add <insert_sorted_with_merge_freeList+0x39c>
  803ac6:	83 ec 04             	sub    $0x4,%esp
  803ac9:	68 e4 4b 80 00       	push   $0x804be4
  803ace:	68 5c 01 00 00       	push   $0x15c
  803ad3:	68 3b 4b 80 00       	push   $0x804b3b
  803ad8:	e8 4b d2 ff ff       	call   800d28 <_panic>
  803add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae0:	8b 00                	mov    (%eax),%eax
  803ae2:	85 c0                	test   %eax,%eax
  803ae4:	74 10                	je     803af6 <insert_sorted_with_merge_freeList+0x3b5>
  803ae6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ae9:	8b 00                	mov    (%eax),%eax
  803aeb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803aee:	8b 52 04             	mov    0x4(%edx),%edx
  803af1:	89 50 04             	mov    %edx,0x4(%eax)
  803af4:	eb 0b                	jmp    803b01 <insert_sorted_with_merge_freeList+0x3c0>
  803af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803af9:	8b 40 04             	mov    0x4(%eax),%eax
  803afc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b04:	8b 40 04             	mov    0x4(%eax),%eax
  803b07:	85 c0                	test   %eax,%eax
  803b09:	74 0f                	je     803b1a <insert_sorted_with_merge_freeList+0x3d9>
  803b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b0e:	8b 40 04             	mov    0x4(%eax),%eax
  803b11:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b14:	8b 12                	mov    (%edx),%edx
  803b16:	89 10                	mov    %edx,(%eax)
  803b18:	eb 0a                	jmp    803b24 <insert_sorted_with_merge_freeList+0x3e3>
  803b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b1d:	8b 00                	mov    (%eax),%eax
  803b1f:	a3 38 51 80 00       	mov    %eax,0x805138
  803b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b37:	a1 44 51 80 00       	mov    0x805144,%eax
  803b3c:	48                   	dec    %eax
  803b3d:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b45:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803b4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b4f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803b56:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803b5a:	75 17                	jne    803b73 <insert_sorted_with_merge_freeList+0x432>
  803b5c:	83 ec 04             	sub    $0x4,%esp
  803b5f:	68 18 4b 80 00       	push   $0x804b18
  803b64:	68 5f 01 00 00       	push   $0x15f
  803b69:	68 3b 4b 80 00       	push   $0x804b3b
  803b6e:	e8 b5 d1 ff ff       	call   800d28 <_panic>
  803b73:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803b79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b7c:	89 10                	mov    %edx,(%eax)
  803b7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b81:	8b 00                	mov    (%eax),%eax
  803b83:	85 c0                	test   %eax,%eax
  803b85:	74 0d                	je     803b94 <insert_sorted_with_merge_freeList+0x453>
  803b87:	a1 48 51 80 00       	mov    0x805148,%eax
  803b8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803b8f:	89 50 04             	mov    %edx,0x4(%eax)
  803b92:	eb 08                	jmp    803b9c <insert_sorted_with_merge_freeList+0x45b>
  803b94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b97:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803b9f:	a3 48 51 80 00       	mov    %eax,0x805148
  803ba4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ba7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bae:	a1 54 51 80 00       	mov    0x805154,%eax
  803bb3:	40                   	inc    %eax
  803bb4:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bbc:	8b 50 0c             	mov    0xc(%eax),%edx
  803bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc2:	8b 40 0c             	mov    0xc(%eax),%eax
  803bc5:	01 c2                	add    %eax,%edx
  803bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bca:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  803bda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803be1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803be5:	75 17                	jne    803bfe <insert_sorted_with_merge_freeList+0x4bd>
  803be7:	83 ec 04             	sub    $0x4,%esp
  803bea:	68 18 4b 80 00       	push   $0x804b18
  803bef:	68 64 01 00 00       	push   $0x164
  803bf4:	68 3b 4b 80 00       	push   $0x804b3b
  803bf9:	e8 2a d1 ff ff       	call   800d28 <_panic>
  803bfe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803c04:	8b 45 08             	mov    0x8(%ebp),%eax
  803c07:	89 10                	mov    %edx,(%eax)
  803c09:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0c:	8b 00                	mov    (%eax),%eax
  803c0e:	85 c0                	test   %eax,%eax
  803c10:	74 0d                	je     803c1f <insert_sorted_with_merge_freeList+0x4de>
  803c12:	a1 48 51 80 00       	mov    0x805148,%eax
  803c17:	8b 55 08             	mov    0x8(%ebp),%edx
  803c1a:	89 50 04             	mov    %edx,0x4(%eax)
  803c1d:	eb 08                	jmp    803c27 <insert_sorted_with_merge_freeList+0x4e6>
  803c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c22:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c27:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2a:	a3 48 51 80 00       	mov    %eax,0x805148
  803c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c39:	a1 54 51 80 00       	mov    0x805154,%eax
  803c3e:	40                   	inc    %eax
  803c3f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803c44:	e9 41 02 00 00       	jmp    803e8a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803c49:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4c:	8b 50 08             	mov    0x8(%eax),%edx
  803c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c52:	8b 40 0c             	mov    0xc(%eax),%eax
  803c55:	01 c2                	add    %eax,%edx
  803c57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c5a:	8b 40 08             	mov    0x8(%eax),%eax
  803c5d:	39 c2                	cmp    %eax,%edx
  803c5f:	0f 85 7c 01 00 00    	jne    803de1 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803c65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803c69:	74 06                	je     803c71 <insert_sorted_with_merge_freeList+0x530>
  803c6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c6f:	75 17                	jne    803c88 <insert_sorted_with_merge_freeList+0x547>
  803c71:	83 ec 04             	sub    $0x4,%esp
  803c74:	68 54 4b 80 00       	push   $0x804b54
  803c79:	68 69 01 00 00       	push   $0x169
  803c7e:	68 3b 4b 80 00       	push   $0x804b3b
  803c83:	e8 a0 d0 ff ff       	call   800d28 <_panic>
  803c88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c8b:	8b 50 04             	mov    0x4(%eax),%edx
  803c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c91:	89 50 04             	mov    %edx,0x4(%eax)
  803c94:	8b 45 08             	mov    0x8(%ebp),%eax
  803c97:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803c9a:	89 10                	mov    %edx,(%eax)
  803c9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c9f:	8b 40 04             	mov    0x4(%eax),%eax
  803ca2:	85 c0                	test   %eax,%eax
  803ca4:	74 0d                	je     803cb3 <insert_sorted_with_merge_freeList+0x572>
  803ca6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ca9:	8b 40 04             	mov    0x4(%eax),%eax
  803cac:	8b 55 08             	mov    0x8(%ebp),%edx
  803caf:	89 10                	mov    %edx,(%eax)
  803cb1:	eb 08                	jmp    803cbb <insert_sorted_with_merge_freeList+0x57a>
  803cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  803cb6:	a3 38 51 80 00       	mov    %eax,0x805138
  803cbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  803cc1:	89 50 04             	mov    %edx,0x4(%eax)
  803cc4:	a1 44 51 80 00       	mov    0x805144,%eax
  803cc9:	40                   	inc    %eax
  803cca:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd2:	8b 50 0c             	mov    0xc(%eax),%edx
  803cd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd8:	8b 40 0c             	mov    0xc(%eax),%eax
  803cdb:	01 c2                	add    %eax,%edx
  803cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ce0:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803ce3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803ce7:	75 17                	jne    803d00 <insert_sorted_with_merge_freeList+0x5bf>
  803ce9:	83 ec 04             	sub    $0x4,%esp
  803cec:	68 e4 4b 80 00       	push   $0x804be4
  803cf1:	68 6b 01 00 00       	push   $0x16b
  803cf6:	68 3b 4b 80 00       	push   $0x804b3b
  803cfb:	e8 28 d0 ff ff       	call   800d28 <_panic>
  803d00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d03:	8b 00                	mov    (%eax),%eax
  803d05:	85 c0                	test   %eax,%eax
  803d07:	74 10                	je     803d19 <insert_sorted_with_merge_freeList+0x5d8>
  803d09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d0c:	8b 00                	mov    (%eax),%eax
  803d0e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d11:	8b 52 04             	mov    0x4(%edx),%edx
  803d14:	89 50 04             	mov    %edx,0x4(%eax)
  803d17:	eb 0b                	jmp    803d24 <insert_sorted_with_merge_freeList+0x5e3>
  803d19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d1c:	8b 40 04             	mov    0x4(%eax),%eax
  803d1f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803d24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d27:	8b 40 04             	mov    0x4(%eax),%eax
  803d2a:	85 c0                	test   %eax,%eax
  803d2c:	74 0f                	je     803d3d <insert_sorted_with_merge_freeList+0x5fc>
  803d2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d31:	8b 40 04             	mov    0x4(%eax),%eax
  803d34:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d37:	8b 12                	mov    (%edx),%edx
  803d39:	89 10                	mov    %edx,(%eax)
  803d3b:	eb 0a                	jmp    803d47 <insert_sorted_with_merge_freeList+0x606>
  803d3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d40:	8b 00                	mov    (%eax),%eax
  803d42:	a3 38 51 80 00       	mov    %eax,0x805138
  803d47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d5a:	a1 44 51 80 00       	mov    0x805144,%eax
  803d5f:	48                   	dec    %eax
  803d60:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803d65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803d6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d72:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803d79:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d7d:	75 17                	jne    803d96 <insert_sorted_with_merge_freeList+0x655>
  803d7f:	83 ec 04             	sub    $0x4,%esp
  803d82:	68 18 4b 80 00       	push   $0x804b18
  803d87:	68 6e 01 00 00       	push   $0x16e
  803d8c:	68 3b 4b 80 00       	push   $0x804b3b
  803d91:	e8 92 cf ff ff       	call   800d28 <_panic>
  803d96:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803d9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d9f:	89 10                	mov    %edx,(%eax)
  803da1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803da4:	8b 00                	mov    (%eax),%eax
  803da6:	85 c0                	test   %eax,%eax
  803da8:	74 0d                	je     803db7 <insert_sorted_with_merge_freeList+0x676>
  803daa:	a1 48 51 80 00       	mov    0x805148,%eax
  803daf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803db2:	89 50 04             	mov    %edx,0x4(%eax)
  803db5:	eb 08                	jmp    803dbf <insert_sorted_with_merge_freeList+0x67e>
  803db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803dbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dc2:	a3 48 51 80 00       	mov    %eax,0x805148
  803dc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803dd1:	a1 54 51 80 00       	mov    0x805154,%eax
  803dd6:	40                   	inc    %eax
  803dd7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803ddc:	e9 a9 00 00 00       	jmp    803e8a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803de1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803de5:	74 06                	je     803ded <insert_sorted_with_merge_freeList+0x6ac>
  803de7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803deb:	75 17                	jne    803e04 <insert_sorted_with_merge_freeList+0x6c3>
  803ded:	83 ec 04             	sub    $0x4,%esp
  803df0:	68 b0 4b 80 00       	push   $0x804bb0
  803df5:	68 73 01 00 00       	push   $0x173
  803dfa:	68 3b 4b 80 00       	push   $0x804b3b
  803dff:	e8 24 cf ff ff       	call   800d28 <_panic>
  803e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e07:	8b 10                	mov    (%eax),%edx
  803e09:	8b 45 08             	mov    0x8(%ebp),%eax
  803e0c:	89 10                	mov    %edx,(%eax)
  803e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  803e11:	8b 00                	mov    (%eax),%eax
  803e13:	85 c0                	test   %eax,%eax
  803e15:	74 0b                	je     803e22 <insert_sorted_with_merge_freeList+0x6e1>
  803e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e1a:	8b 00                	mov    (%eax),%eax
  803e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  803e1f:	89 50 04             	mov    %edx,0x4(%eax)
  803e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e25:	8b 55 08             	mov    0x8(%ebp),%edx
  803e28:	89 10                	mov    %edx,(%eax)
  803e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803e30:	89 50 04             	mov    %edx,0x4(%eax)
  803e33:	8b 45 08             	mov    0x8(%ebp),%eax
  803e36:	8b 00                	mov    (%eax),%eax
  803e38:	85 c0                	test   %eax,%eax
  803e3a:	75 08                	jne    803e44 <insert_sorted_with_merge_freeList+0x703>
  803e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e3f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803e44:	a1 44 51 80 00       	mov    0x805144,%eax
  803e49:	40                   	inc    %eax
  803e4a:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803e4f:	eb 39                	jmp    803e8a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803e51:	a1 40 51 80 00       	mov    0x805140,%eax
  803e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803e59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e5d:	74 07                	je     803e66 <insert_sorted_with_merge_freeList+0x725>
  803e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e62:	8b 00                	mov    (%eax),%eax
  803e64:	eb 05                	jmp    803e6b <insert_sorted_with_merge_freeList+0x72a>
  803e66:	b8 00 00 00 00       	mov    $0x0,%eax
  803e6b:	a3 40 51 80 00       	mov    %eax,0x805140
  803e70:	a1 40 51 80 00       	mov    0x805140,%eax
  803e75:	85 c0                	test   %eax,%eax
  803e77:	0f 85 c7 fb ff ff    	jne    803a44 <insert_sorted_with_merge_freeList+0x303>
  803e7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e81:	0f 85 bd fb ff ff    	jne    803a44 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e87:	eb 01                	jmp    803e8a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803e89:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803e8a:	90                   	nop
  803e8b:	c9                   	leave  
  803e8c:	c3                   	ret    
  803e8d:	66 90                	xchg   %ax,%ax
  803e8f:	90                   	nop

00803e90 <__udivdi3>:
  803e90:	55                   	push   %ebp
  803e91:	57                   	push   %edi
  803e92:	56                   	push   %esi
  803e93:	53                   	push   %ebx
  803e94:	83 ec 1c             	sub    $0x1c,%esp
  803e97:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803e9b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803e9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ea3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ea7:	89 ca                	mov    %ecx,%edx
  803ea9:	89 f8                	mov    %edi,%eax
  803eab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803eaf:	85 f6                	test   %esi,%esi
  803eb1:	75 2d                	jne    803ee0 <__udivdi3+0x50>
  803eb3:	39 cf                	cmp    %ecx,%edi
  803eb5:	77 65                	ja     803f1c <__udivdi3+0x8c>
  803eb7:	89 fd                	mov    %edi,%ebp
  803eb9:	85 ff                	test   %edi,%edi
  803ebb:	75 0b                	jne    803ec8 <__udivdi3+0x38>
  803ebd:	b8 01 00 00 00       	mov    $0x1,%eax
  803ec2:	31 d2                	xor    %edx,%edx
  803ec4:	f7 f7                	div    %edi
  803ec6:	89 c5                	mov    %eax,%ebp
  803ec8:	31 d2                	xor    %edx,%edx
  803eca:	89 c8                	mov    %ecx,%eax
  803ecc:	f7 f5                	div    %ebp
  803ece:	89 c1                	mov    %eax,%ecx
  803ed0:	89 d8                	mov    %ebx,%eax
  803ed2:	f7 f5                	div    %ebp
  803ed4:	89 cf                	mov    %ecx,%edi
  803ed6:	89 fa                	mov    %edi,%edx
  803ed8:	83 c4 1c             	add    $0x1c,%esp
  803edb:	5b                   	pop    %ebx
  803edc:	5e                   	pop    %esi
  803edd:	5f                   	pop    %edi
  803ede:	5d                   	pop    %ebp
  803edf:	c3                   	ret    
  803ee0:	39 ce                	cmp    %ecx,%esi
  803ee2:	77 28                	ja     803f0c <__udivdi3+0x7c>
  803ee4:	0f bd fe             	bsr    %esi,%edi
  803ee7:	83 f7 1f             	xor    $0x1f,%edi
  803eea:	75 40                	jne    803f2c <__udivdi3+0x9c>
  803eec:	39 ce                	cmp    %ecx,%esi
  803eee:	72 0a                	jb     803efa <__udivdi3+0x6a>
  803ef0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ef4:	0f 87 9e 00 00 00    	ja     803f98 <__udivdi3+0x108>
  803efa:	b8 01 00 00 00       	mov    $0x1,%eax
  803eff:	89 fa                	mov    %edi,%edx
  803f01:	83 c4 1c             	add    $0x1c,%esp
  803f04:	5b                   	pop    %ebx
  803f05:	5e                   	pop    %esi
  803f06:	5f                   	pop    %edi
  803f07:	5d                   	pop    %ebp
  803f08:	c3                   	ret    
  803f09:	8d 76 00             	lea    0x0(%esi),%esi
  803f0c:	31 ff                	xor    %edi,%edi
  803f0e:	31 c0                	xor    %eax,%eax
  803f10:	89 fa                	mov    %edi,%edx
  803f12:	83 c4 1c             	add    $0x1c,%esp
  803f15:	5b                   	pop    %ebx
  803f16:	5e                   	pop    %esi
  803f17:	5f                   	pop    %edi
  803f18:	5d                   	pop    %ebp
  803f19:	c3                   	ret    
  803f1a:	66 90                	xchg   %ax,%ax
  803f1c:	89 d8                	mov    %ebx,%eax
  803f1e:	f7 f7                	div    %edi
  803f20:	31 ff                	xor    %edi,%edi
  803f22:	89 fa                	mov    %edi,%edx
  803f24:	83 c4 1c             	add    $0x1c,%esp
  803f27:	5b                   	pop    %ebx
  803f28:	5e                   	pop    %esi
  803f29:	5f                   	pop    %edi
  803f2a:	5d                   	pop    %ebp
  803f2b:	c3                   	ret    
  803f2c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803f31:	89 eb                	mov    %ebp,%ebx
  803f33:	29 fb                	sub    %edi,%ebx
  803f35:	89 f9                	mov    %edi,%ecx
  803f37:	d3 e6                	shl    %cl,%esi
  803f39:	89 c5                	mov    %eax,%ebp
  803f3b:	88 d9                	mov    %bl,%cl
  803f3d:	d3 ed                	shr    %cl,%ebp
  803f3f:	89 e9                	mov    %ebp,%ecx
  803f41:	09 f1                	or     %esi,%ecx
  803f43:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803f47:	89 f9                	mov    %edi,%ecx
  803f49:	d3 e0                	shl    %cl,%eax
  803f4b:	89 c5                	mov    %eax,%ebp
  803f4d:	89 d6                	mov    %edx,%esi
  803f4f:	88 d9                	mov    %bl,%cl
  803f51:	d3 ee                	shr    %cl,%esi
  803f53:	89 f9                	mov    %edi,%ecx
  803f55:	d3 e2                	shl    %cl,%edx
  803f57:	8b 44 24 08          	mov    0x8(%esp),%eax
  803f5b:	88 d9                	mov    %bl,%cl
  803f5d:	d3 e8                	shr    %cl,%eax
  803f5f:	09 c2                	or     %eax,%edx
  803f61:	89 d0                	mov    %edx,%eax
  803f63:	89 f2                	mov    %esi,%edx
  803f65:	f7 74 24 0c          	divl   0xc(%esp)
  803f69:	89 d6                	mov    %edx,%esi
  803f6b:	89 c3                	mov    %eax,%ebx
  803f6d:	f7 e5                	mul    %ebp
  803f6f:	39 d6                	cmp    %edx,%esi
  803f71:	72 19                	jb     803f8c <__udivdi3+0xfc>
  803f73:	74 0b                	je     803f80 <__udivdi3+0xf0>
  803f75:	89 d8                	mov    %ebx,%eax
  803f77:	31 ff                	xor    %edi,%edi
  803f79:	e9 58 ff ff ff       	jmp    803ed6 <__udivdi3+0x46>
  803f7e:	66 90                	xchg   %ax,%ax
  803f80:	8b 54 24 08          	mov    0x8(%esp),%edx
  803f84:	89 f9                	mov    %edi,%ecx
  803f86:	d3 e2                	shl    %cl,%edx
  803f88:	39 c2                	cmp    %eax,%edx
  803f8a:	73 e9                	jae    803f75 <__udivdi3+0xe5>
  803f8c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803f8f:	31 ff                	xor    %edi,%edi
  803f91:	e9 40 ff ff ff       	jmp    803ed6 <__udivdi3+0x46>
  803f96:	66 90                	xchg   %ax,%ax
  803f98:	31 c0                	xor    %eax,%eax
  803f9a:	e9 37 ff ff ff       	jmp    803ed6 <__udivdi3+0x46>
  803f9f:	90                   	nop

00803fa0 <__umoddi3>:
  803fa0:	55                   	push   %ebp
  803fa1:	57                   	push   %edi
  803fa2:	56                   	push   %esi
  803fa3:	53                   	push   %ebx
  803fa4:	83 ec 1c             	sub    $0x1c,%esp
  803fa7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803fab:	8b 74 24 34          	mov    0x34(%esp),%esi
  803faf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803fb3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803fb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803fbb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fbf:	89 f3                	mov    %esi,%ebx
  803fc1:	89 fa                	mov    %edi,%edx
  803fc3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803fc7:	89 34 24             	mov    %esi,(%esp)
  803fca:	85 c0                	test   %eax,%eax
  803fcc:	75 1a                	jne    803fe8 <__umoddi3+0x48>
  803fce:	39 f7                	cmp    %esi,%edi
  803fd0:	0f 86 a2 00 00 00    	jbe    804078 <__umoddi3+0xd8>
  803fd6:	89 c8                	mov    %ecx,%eax
  803fd8:	89 f2                	mov    %esi,%edx
  803fda:	f7 f7                	div    %edi
  803fdc:	89 d0                	mov    %edx,%eax
  803fde:	31 d2                	xor    %edx,%edx
  803fe0:	83 c4 1c             	add    $0x1c,%esp
  803fe3:	5b                   	pop    %ebx
  803fe4:	5e                   	pop    %esi
  803fe5:	5f                   	pop    %edi
  803fe6:	5d                   	pop    %ebp
  803fe7:	c3                   	ret    
  803fe8:	39 f0                	cmp    %esi,%eax
  803fea:	0f 87 ac 00 00 00    	ja     80409c <__umoddi3+0xfc>
  803ff0:	0f bd e8             	bsr    %eax,%ebp
  803ff3:	83 f5 1f             	xor    $0x1f,%ebp
  803ff6:	0f 84 ac 00 00 00    	je     8040a8 <__umoddi3+0x108>
  803ffc:	bf 20 00 00 00       	mov    $0x20,%edi
  804001:	29 ef                	sub    %ebp,%edi
  804003:	89 fe                	mov    %edi,%esi
  804005:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804009:	89 e9                	mov    %ebp,%ecx
  80400b:	d3 e0                	shl    %cl,%eax
  80400d:	89 d7                	mov    %edx,%edi
  80400f:	89 f1                	mov    %esi,%ecx
  804011:	d3 ef                	shr    %cl,%edi
  804013:	09 c7                	or     %eax,%edi
  804015:	89 e9                	mov    %ebp,%ecx
  804017:	d3 e2                	shl    %cl,%edx
  804019:	89 14 24             	mov    %edx,(%esp)
  80401c:	89 d8                	mov    %ebx,%eax
  80401e:	d3 e0                	shl    %cl,%eax
  804020:	89 c2                	mov    %eax,%edx
  804022:	8b 44 24 08          	mov    0x8(%esp),%eax
  804026:	d3 e0                	shl    %cl,%eax
  804028:	89 44 24 04          	mov    %eax,0x4(%esp)
  80402c:	8b 44 24 08          	mov    0x8(%esp),%eax
  804030:	89 f1                	mov    %esi,%ecx
  804032:	d3 e8                	shr    %cl,%eax
  804034:	09 d0                	or     %edx,%eax
  804036:	d3 eb                	shr    %cl,%ebx
  804038:	89 da                	mov    %ebx,%edx
  80403a:	f7 f7                	div    %edi
  80403c:	89 d3                	mov    %edx,%ebx
  80403e:	f7 24 24             	mull   (%esp)
  804041:	89 c6                	mov    %eax,%esi
  804043:	89 d1                	mov    %edx,%ecx
  804045:	39 d3                	cmp    %edx,%ebx
  804047:	0f 82 87 00 00 00    	jb     8040d4 <__umoddi3+0x134>
  80404d:	0f 84 91 00 00 00    	je     8040e4 <__umoddi3+0x144>
  804053:	8b 54 24 04          	mov    0x4(%esp),%edx
  804057:	29 f2                	sub    %esi,%edx
  804059:	19 cb                	sbb    %ecx,%ebx
  80405b:	89 d8                	mov    %ebx,%eax
  80405d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804061:	d3 e0                	shl    %cl,%eax
  804063:	89 e9                	mov    %ebp,%ecx
  804065:	d3 ea                	shr    %cl,%edx
  804067:	09 d0                	or     %edx,%eax
  804069:	89 e9                	mov    %ebp,%ecx
  80406b:	d3 eb                	shr    %cl,%ebx
  80406d:	89 da                	mov    %ebx,%edx
  80406f:	83 c4 1c             	add    $0x1c,%esp
  804072:	5b                   	pop    %ebx
  804073:	5e                   	pop    %esi
  804074:	5f                   	pop    %edi
  804075:	5d                   	pop    %ebp
  804076:	c3                   	ret    
  804077:	90                   	nop
  804078:	89 fd                	mov    %edi,%ebp
  80407a:	85 ff                	test   %edi,%edi
  80407c:	75 0b                	jne    804089 <__umoddi3+0xe9>
  80407e:	b8 01 00 00 00       	mov    $0x1,%eax
  804083:	31 d2                	xor    %edx,%edx
  804085:	f7 f7                	div    %edi
  804087:	89 c5                	mov    %eax,%ebp
  804089:	89 f0                	mov    %esi,%eax
  80408b:	31 d2                	xor    %edx,%edx
  80408d:	f7 f5                	div    %ebp
  80408f:	89 c8                	mov    %ecx,%eax
  804091:	f7 f5                	div    %ebp
  804093:	89 d0                	mov    %edx,%eax
  804095:	e9 44 ff ff ff       	jmp    803fde <__umoddi3+0x3e>
  80409a:	66 90                	xchg   %ax,%ax
  80409c:	89 c8                	mov    %ecx,%eax
  80409e:	89 f2                	mov    %esi,%edx
  8040a0:	83 c4 1c             	add    $0x1c,%esp
  8040a3:	5b                   	pop    %ebx
  8040a4:	5e                   	pop    %esi
  8040a5:	5f                   	pop    %edi
  8040a6:	5d                   	pop    %ebp
  8040a7:	c3                   	ret    
  8040a8:	3b 04 24             	cmp    (%esp),%eax
  8040ab:	72 06                	jb     8040b3 <__umoddi3+0x113>
  8040ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8040b1:	77 0f                	ja     8040c2 <__umoddi3+0x122>
  8040b3:	89 f2                	mov    %esi,%edx
  8040b5:	29 f9                	sub    %edi,%ecx
  8040b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8040bb:	89 14 24             	mov    %edx,(%esp)
  8040be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8040c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8040c6:	8b 14 24             	mov    (%esp),%edx
  8040c9:	83 c4 1c             	add    $0x1c,%esp
  8040cc:	5b                   	pop    %ebx
  8040cd:	5e                   	pop    %esi
  8040ce:	5f                   	pop    %edi
  8040cf:	5d                   	pop    %ebp
  8040d0:	c3                   	ret    
  8040d1:	8d 76 00             	lea    0x0(%esi),%esi
  8040d4:	2b 04 24             	sub    (%esp),%eax
  8040d7:	19 fa                	sbb    %edi,%edx
  8040d9:	89 d1                	mov    %edx,%ecx
  8040db:	89 c6                	mov    %eax,%esi
  8040dd:	e9 71 ff ff ff       	jmp    804053 <__umoddi3+0xb3>
  8040e2:	66 90                	xchg   %ax,%ax
  8040e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8040e8:	72 ea                	jb     8040d4 <__umoddi3+0x134>
  8040ea:	89 d9                	mov    %ebx,%ecx
  8040ec:	e9 62 ff ff ff       	jmp    804053 <__umoddi3+0xb3>
