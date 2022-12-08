
obj/user/tst_malloc_0:     file format elf32-i386


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
  800031:	e8 a3 01 00 00       	call   8001d9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 50 80 00       	mov    0x805020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 50 80 00       	mov    0x805020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 a0 35 80 00       	push   $0x8035a0
  800091:	6a 14                	push   $0x14
  800093:	68 bc 35 80 00       	push   $0x8035bc
  800098:	e8 78 02 00 00       	call   800315 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	if(STATIC_MEMBLOCK_ALLOC != 0)
		panic("STATIC_MEMBLOCK_ALLOC = 1 & it shall be 0. Go to 'inc/dynamic_allocator.h' and set STATIC_MEMBLOCK_ALLOC by 0. Then, repeat the test again.");

	int freeFrames_before = sys_calculate_free_frames() ;
  80009d:	e8 cf 16 00 00       	call   801771 <sys_calculate_free_frames>
  8000a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeDiskFrames_before = sys_pf_calculate_allocated_pages() ;
  8000a5:	e8 67 17 00 00       	call   801811 <sys_pf_calculate_allocated_pages>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	malloc(0);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	e8 9a 14 00 00       	call   801551 <malloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
	int freeFrames_after = sys_calculate_free_frames() ;
  8000ba:	e8 b2 16 00 00       	call   801771 <sys_calculate_free_frames>
  8000bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freeDiskFrames_after = sys_pf_calculate_allocated_pages() ;
  8000c2:	e8 4a 17 00 00       	call   801811 <sys_pf_calculate_allocated_pages>
  8000c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Check MAX_MEM_BLOCK_CNT
	if(MAX_MEM_BLOCK_CNT != ((0xA0000000-0x80000000)/4096))
  8000ca:	a1 20 51 80 00       	mov    0x805120,%eax
  8000cf:	3d 00 00 02 00       	cmp    $0x20000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
	{
		panic("Wrong initialize: MAX_MEM_BLOCK_CNT is not set with the correct size of the array");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 d0 35 80 00       	push   $0x8035d0
  8000de:	6a 23                	push   $0x23
  8000e0:	68 bc 35 80 00       	push   $0x8035bc
  8000e5:	e8 2b 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AvailableMemBlocksList
	if (LIST_SIZE(&(AvailableMemBlocksList)) != MAX_MEM_BLOCK_CNT-1)
  8000ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8000ef:	8b 15 20 51 80 00    	mov    0x805120,%edx
  8000f5:	4a                   	dec    %edx
  8000f6:	39 d0                	cmp    %edx,%eax
  8000f8:	74 14                	je     80010e <_main+0xd6>
	{
		panic("Wrong initialize: Wrong size for the AvailableMemBlocksList");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 24 36 80 00       	push   $0x803624
  800102:	6a 29                	push   $0x29
  800104:	68 bc 35 80 00       	push   $0x8035bc
  800109:	e8 07 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AllocMemBlocksList
	if (LIST_SIZE(&(AllocMemBlocksList)) != 0)
  80010e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  800113:	85 c0                	test   %eax,%eax
  800115:	74 14                	je     80012b <_main+0xf3>
	{
		panic("Wrong initialize: Wrong size for the AllocMemBlocksList");
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	68 60 36 80 00       	push   $0x803660
  80011f:	6a 2f                	push   $0x2f
  800121:	68 bc 35 80 00       	push   $0x8035bc
  800126:	e8 ea 01 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in FreeMemBlocksList
	if (LIST_SIZE(&(FreeMemBlocksList)) != 1)
  80012b:	a1 44 51 80 00       	mov    0x805144,%eax
  800130:	83 f8 01             	cmp    $0x1,%eax
  800133:	74 14                	je     800149 <_main+0x111>
	{
		panic("Wrong initialize: Wrong size for the FreeMemBlocksList");
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 98 36 80 00       	push   $0x803698
  80013d:	6a 35                	push   $0x35
  80013f:	68 bc 35 80 00       	push   $0x8035bc
  800144:	e8 cc 01 00 00       	call   800315 <_panic>
	}

	//Check content of FreeMemBlocksList
	struct MemBlock* block = LIST_FIRST(&FreeMemBlocksList);
  800149:	a1 38 51 80 00       	mov    0x805138,%eax
  80014e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(block == NULL || block->size != (0xA0000000-0x80000000) || block->sva != 0x80000000)
  800151:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800155:	74 1a                	je     800171 <_main+0x139>
  800157:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80015a:	8b 40 0c             	mov    0xc(%eax),%eax
  80015d:	3d 00 00 00 20       	cmp    $0x20000000,%eax
  800162:	75 0d                	jne    800171 <_main+0x139>
  800164:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800167:	8b 40 08             	mov    0x8(%eax),%eax
  80016a:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80016f:	74 14                	je     800185 <_main+0x14d>
	{
		panic("Wrong initialize: Wrong content for the FreeMemBlocksList.");
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 d0 36 80 00       	push   $0x8036d0
  800179:	6a 3c                	push   $0x3c
  80017b:	68 bc 35 80 00       	push   $0x8035bc
  800180:	e8 90 01 00 00       	call   800315 <_panic>
	}

	//Check number of disk and memory frames
	if ((freeDiskFrames_after - freeDiskFrames_before) != 0) panic("Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)");
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80018b:	74 14                	je     8001a1 <_main+0x169>
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 0c 37 80 00       	push   $0x80370c
  800195:	6a 40                	push   $0x40
  800197:	68 bc 35 80 00       	push   $0x8035bc
  80019c:	e8 74 01 00 00       	call   800315 <_panic>
	if ((freeFrames_before - freeFrames_after) != 512 + 1) panic("Wrong allocation: pages are not loaded successfully into memory %d", (freeFrames_before - freeFrames_after));
  8001a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a7:	3d 01 02 00 00       	cmp    $0x201,%eax
  8001ac:	74 18                	je     8001c6 <_main+0x18e>
  8001ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	68 74 37 80 00       	push   $0x803774
  8001ba:	6a 41                	push   $0x41
  8001bc:	68 bc 35 80 00       	push   $0x8035bc
  8001c1:	e8 4f 01 00 00       	call   800315 <_panic>

	/*=================================================*/

	cprintf("Congratulations!! test initialize_dyn_block_system of UHEAP completed successfully.\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 b8 37 80 00       	push   $0x8037b8
  8001ce:	e8 f6 03 00 00       	call   8005c9 <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp

	return;
  8001d6:	90                   	nop
}
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001df:	e8 6d 18 00 00       	call   801a51 <sys_getenvindex>
  8001e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001ea:	89 d0                	mov    %edx,%eax
  8001ec:	c1 e0 03             	shl    $0x3,%eax
  8001ef:	01 d0                	add    %edx,%eax
  8001f1:	01 c0                	add    %eax,%eax
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fc:	01 d0                	add    %edx,%eax
  8001fe:	c1 e0 04             	shl    $0x4,%eax
  800201:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800206:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80020b:	a1 20 50 80 00       	mov    0x805020,%eax
  800210:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800216:	84 c0                	test   %al,%al
  800218:	74 0f                	je     800229 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	05 5c 05 00 00       	add    $0x55c,%eax
  800224:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022d:	7e 0a                	jle    800239 <libmain+0x60>
		binaryname = argv[0];
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800232:	8b 00                	mov    (%eax),%eax
  800234:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 0c             	pushl  0xc(%ebp)
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	e8 f1 fd ff ff       	call   800038 <_main>
  800247:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80024a:	e8 0f 16 00 00       	call   80185e <sys_disable_interrupt>
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 28 38 80 00       	push   $0x803828
  800257:	e8 6d 03 00 00       	call   8005c9 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80025f:	a1 20 50 80 00       	mov    0x805020,%eax
  800264:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80026a:	a1 20 50 80 00       	mov    0x805020,%eax
  80026f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	52                   	push   %edx
  800279:	50                   	push   %eax
  80027a:	68 50 38 80 00       	push   $0x803850
  80027f:	e8 45 03 00 00       	call   8005c9 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800287:	a1 20 50 80 00       	mov    0x805020,%eax
  80028c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800292:	a1 20 50 80 00       	mov    0x805020,%eax
  800297:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80029d:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002a8:	51                   	push   %ecx
  8002a9:	52                   	push   %edx
  8002aa:	50                   	push   %eax
  8002ab:	68 78 38 80 00       	push   $0x803878
  8002b0:	e8 14 03 00 00       	call   8005c9 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 d0 38 80 00       	push   $0x8038d0
  8002cc:	e8 f8 02 00 00       	call   8005c9 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	68 28 38 80 00       	push   $0x803828
  8002dc:	e8 e8 02 00 00       	call   8005c9 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002e4:	e8 8f 15 00 00       	call   801878 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002e9:	e8 19 00 00 00       	call   800307 <exit>
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	6a 00                	push   $0x0
  8002fc:	e8 1c 17 00 00       	call   801a1d <sys_destroy_env>
  800301:	83 c4 10             	add    $0x10,%esp
}
  800304:	90                   	nop
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <exit>:

void
exit(void)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80030d:	e8 71 17 00 00       	call   801a83 <sys_exit_env>
}
  800312:	90                   	nop
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80031b:	8d 45 10             	lea    0x10(%ebp),%eax
  80031e:	83 c0 04             	add    $0x4,%eax
  800321:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800324:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800329:	85 c0                	test   %eax,%eax
  80032b:	74 16                	je     800343 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80032d:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	50                   	push   %eax
  800336:	68 e4 38 80 00       	push   $0x8038e4
  80033b:	e8 89 02 00 00       	call   8005c9 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800343:	a1 00 50 80 00       	mov    0x805000,%eax
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 e9 38 80 00       	push   $0x8038e9
  800354:	e8 70 02 00 00       	call   8005c9 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	50                   	push   %eax
  800366:	e8 f3 01 00 00       	call   80055e <vcprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	6a 00                	push   $0x0
  800373:	68 05 39 80 00       	push   $0x803905
  800378:	e8 e1 01 00 00       	call   80055e <vcprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800380:	e8 82 ff ff ff       	call   800307 <exit>

	// should not return here
	while (1) ;
  800385:	eb fe                	jmp    800385 <_panic+0x70>

00800387 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038d:	a1 20 50 80 00       	mov    0x805020,%eax
  800392:	8b 50 74             	mov    0x74(%eax),%edx
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
  800398:	39 c2                	cmp    %eax,%edx
  80039a:	74 14                	je     8003b0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80039c:	83 ec 04             	sub    $0x4,%esp
  80039f:	68 08 39 80 00       	push   $0x803908
  8003a4:	6a 26                	push   $0x26
  8003a6:	68 54 39 80 00       	push   $0x803954
  8003ab:	e8 65 ff ff ff       	call   800315 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003be:	e9 c2 00 00 00       	jmp    800485 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	85 c0                	test   %eax,%eax
  8003d6:	75 08                	jne    8003e0 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003d8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003db:	e9 a2 00 00 00       	jmp    800482 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ee:	eb 69                	jmp    800459 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	01 c0                	add    %eax,%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	c1 e0 03             	shl    $0x3,%eax
  800407:	01 c8                	add    %ecx,%eax
  800409:	8a 40 04             	mov    0x4(%eax),%al
  80040c:	84 c0                	test   %al,%al
  80040e:	75 46                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800410:	a1 20 50 80 00       	mov    0x805020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80042e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800431:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800436:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	01 c8                	add    %ecx,%eax
  800447:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800449:	39 c2                	cmp    %eax,%edx
  80044b:	75 09                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80044d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800454:	eb 12                	jmp    800468 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800456:	ff 45 e8             	incl   -0x18(%ebp)
  800459:	a1 20 50 80 00       	mov    0x805020,%eax
  80045e:	8b 50 74             	mov    0x74(%eax),%edx
  800461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800464:	39 c2                	cmp    %eax,%edx
  800466:	77 88                	ja     8003f0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800468:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80046c:	75 14                	jne    800482 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80046e:	83 ec 04             	sub    $0x4,%esp
  800471:	68 60 39 80 00       	push   $0x803960
  800476:	6a 3a                	push   $0x3a
  800478:	68 54 39 80 00       	push   $0x803954
  80047d:	e8 93 fe ff ff       	call   800315 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800482:	ff 45 f0             	incl   -0x10(%ebp)
  800485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800488:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80048b:	0f 8c 32 ff ff ff    	jl     8003c3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800491:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80049f:	eb 26                	jmp    8004c7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004af:	89 d0                	mov    %edx,%eax
  8004b1:	01 c0                	add    %eax,%eax
  8004b3:	01 d0                	add    %edx,%eax
  8004b5:	c1 e0 03             	shl    $0x3,%eax
  8004b8:	01 c8                	add    %ecx,%eax
  8004ba:	8a 40 04             	mov    0x4(%eax),%al
  8004bd:	3c 01                	cmp    $0x1,%al
  8004bf:	75 03                	jne    8004c4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004c1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c4:	ff 45 e0             	incl   -0x20(%ebp)
  8004c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004cc:	8b 50 74             	mov    0x74(%eax),%edx
  8004cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d2:	39 c2                	cmp    %eax,%edx
  8004d4:	77 cb                	ja     8004a1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 b4 39 80 00       	push   $0x8039b4
  8004e6:	6a 44                	push   $0x44
  8004e8:	68 54 39 80 00       	push   $0x803954
  8004ed:	e8 23 fe ff ff       	call   800315 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f2:	90                   	nop
  8004f3:	c9                   	leave  
  8004f4:	c3                   	ret    

008004f5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	8d 48 01             	lea    0x1(%eax),%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	89 0a                	mov    %ecx,(%edx)
  800508:	8b 55 08             	mov    0x8(%ebp),%edx
  80050b:	88 d1                	mov    %dl,%cl
  80050d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800510:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800514:	8b 45 0c             	mov    0xc(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	3d ff 00 00 00       	cmp    $0xff,%eax
  80051e:	75 2c                	jne    80054c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800520:	a0 24 50 80 00       	mov    0x805024,%al
  800525:	0f b6 c0             	movzbl %al,%eax
  800528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052b:	8b 12                	mov    (%edx),%edx
  80052d:	89 d1                	mov    %edx,%ecx
  80052f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800532:	83 c2 08             	add    $0x8,%edx
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	50                   	push   %eax
  800539:	51                   	push   %ecx
  80053a:	52                   	push   %edx
  80053b:	e8 70 11 00 00       	call   8016b0 <sys_cputs>
  800540:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800543:	8b 45 0c             	mov    0xc(%ebp),%eax
  800546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054f:	8b 40 04             	mov    0x4(%eax),%eax
  800552:	8d 50 01             	lea    0x1(%eax),%edx
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
  800558:	89 50 04             	mov    %edx,0x4(%eax)
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800567:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056e:	00 00 00 
	b.cnt = 0;
  800571:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800578:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057b:	ff 75 0c             	pushl  0xc(%ebp)
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800587:	50                   	push   %eax
  800588:	68 f5 04 80 00       	push   $0x8004f5
  80058d:	e8 11 02 00 00       	call   8007a3 <vprintfmt>
  800592:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800595:	a0 24 50 80 00       	mov    0x805024,%al
  80059a:	0f b6 c0             	movzbl %al,%eax
  80059d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005a3:	83 ec 04             	sub    $0x4,%esp
  8005a6:	50                   	push   %eax
  8005a7:	52                   	push   %edx
  8005a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ae:	83 c0 08             	add    $0x8,%eax
  8005b1:	50                   	push   %eax
  8005b2:	e8 f9 10 00 00       	call   8016b0 <sys_cputs>
  8005b7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005ba:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8005c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c7:	c9                   	leave  
  8005c8:	c3                   	ret    

008005c9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005cf:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8005d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e5:	50                   	push   %eax
  8005e6:	e8 73 ff ff ff       	call   80055e <vcprintf>
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005fc:	e8 5d 12 00 00       	call   80185e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800601:	8d 45 0c             	lea    0xc(%ebp),%eax
  800604:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	ff 75 f4             	pushl  -0xc(%ebp)
  800610:	50                   	push   %eax
  800611:	e8 48 ff ff ff       	call   80055e <vcprintf>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80061c:	e8 57 12 00 00       	call   801878 <sys_enable_interrupt>
	return cnt;
  800621:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800624:	c9                   	leave  
  800625:	c3                   	ret    

00800626 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	53                   	push   %ebx
  80062a:	83 ec 14             	sub    $0x14,%esp
  80062d:	8b 45 10             	mov    0x10(%ebp),%eax
  800630:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800639:	8b 45 18             	mov    0x18(%ebp),%eax
  80063c:	ba 00 00 00 00       	mov    $0x0,%edx
  800641:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800644:	77 55                	ja     80069b <printnum+0x75>
  800646:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800649:	72 05                	jb     800650 <printnum+0x2a>
  80064b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80064e:	77 4b                	ja     80069b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800650:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800653:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800656:	8b 45 18             	mov    0x18(%ebp),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
  80065e:	52                   	push   %edx
  80065f:	50                   	push   %eax
  800660:	ff 75 f4             	pushl  -0xc(%ebp)
  800663:	ff 75 f0             	pushl  -0x10(%ebp)
  800666:	e8 c9 2c 00 00       	call   803334 <__udivdi3>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	ff 75 20             	pushl  0x20(%ebp)
  800674:	53                   	push   %ebx
  800675:	ff 75 18             	pushl  0x18(%ebp)
  800678:	52                   	push   %edx
  800679:	50                   	push   %eax
  80067a:	ff 75 0c             	pushl  0xc(%ebp)
  80067d:	ff 75 08             	pushl  0x8(%ebp)
  800680:	e8 a1 ff ff ff       	call   800626 <printnum>
  800685:	83 c4 20             	add    $0x20,%esp
  800688:	eb 1a                	jmp    8006a4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	ff 75 0c             	pushl  0xc(%ebp)
  800690:	ff 75 20             	pushl  0x20(%ebp)
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	ff d0                	call   *%eax
  800698:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80069b:	ff 4d 1c             	decl   0x1c(%ebp)
  80069e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006a2:	7f e6                	jg     80068a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b2:	53                   	push   %ebx
  8006b3:	51                   	push   %ecx
  8006b4:	52                   	push   %edx
  8006b5:	50                   	push   %eax
  8006b6:	e8 89 2d 00 00       	call   803444 <__umoddi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	05 14 3c 80 00       	add    $0x803c14,%eax
  8006c3:	8a 00                	mov    (%eax),%al
  8006c5:	0f be c0             	movsbl %al,%eax
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	50                   	push   %eax
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
}
  8006d7:	90                   	nop
  8006d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e4:	7e 1c                	jle    800702 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	8d 50 08             	lea    0x8(%eax),%edx
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	89 10                	mov    %edx,(%eax)
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	83 e8 08             	sub    $0x8,%eax
  8006fb:	8b 50 04             	mov    0x4(%eax),%edx
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	eb 40                	jmp    800742 <getuint+0x65>
	else if (lflag)
  800702:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800706:	74 1e                	je     800726 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	8d 50 04             	lea    0x4(%eax),%edx
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	89 10                	mov    %edx,(%eax)
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	83 e8 04             	sub    $0x4,%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	ba 00 00 00 00       	mov    $0x0,%edx
  800724:	eb 1c                	jmp    800742 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800747:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074b:	7e 1c                	jle    800769 <getint+0x25>
		return va_arg(*ap, long long);
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	8d 50 08             	lea    0x8(%eax),%edx
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	89 10                	mov    %edx,(%eax)
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	83 e8 08             	sub    $0x8,%eax
  800762:	8b 50 04             	mov    0x4(%eax),%edx
  800765:	8b 00                	mov    (%eax),%eax
  800767:	eb 38                	jmp    8007a1 <getint+0x5d>
	else if (lflag)
  800769:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076d:	74 1a                	je     800789 <getint+0x45>
		return va_arg(*ap, long);
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	8d 50 04             	lea    0x4(%eax),%edx
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 10                	mov    %edx,(%eax)
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	83 e8 04             	sub    $0x4,%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	99                   	cltd   
  800787:	eb 18                	jmp    8007a1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	8d 50 04             	lea    0x4(%eax),%edx
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 10                	mov    %edx,(%eax)
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	83 e8 04             	sub    $0x4,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	99                   	cltd   
}
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	56                   	push   %esi
  8007a7:	53                   	push   %ebx
  8007a8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ab:	eb 17                	jmp    8007c4 <vprintfmt+0x21>
			if (ch == '\0')
  8007ad:	85 db                	test   %ebx,%ebx
  8007af:	0f 84 af 03 00 00    	je     800b64 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	53                   	push   %ebx
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	ff d0                	call   *%eax
  8007c1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8007cd:	8a 00                	mov    (%eax),%al
  8007cf:	0f b6 d8             	movzbl %al,%ebx
  8007d2:	83 fb 25             	cmp    $0x25,%ebx
  8007d5:	75 d6                	jne    8007ad <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007d7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007db:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fa:	8d 50 01             	lea    0x1(%eax),%edx
  8007fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f b6 d8             	movzbl %al,%ebx
  800805:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800808:	83 f8 55             	cmp    $0x55,%eax
  80080b:	0f 87 2b 03 00 00    	ja     800b3c <vprintfmt+0x399>
  800811:	8b 04 85 38 3c 80 00 	mov    0x803c38(,%eax,4),%eax
  800818:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80081a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80081e:	eb d7                	jmp    8007f7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800820:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800824:	eb d1                	jmp    8007f7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800826:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80082d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800830:	89 d0                	mov    %edx,%eax
  800832:	c1 e0 02             	shl    $0x2,%eax
  800835:	01 d0                	add    %edx,%eax
  800837:	01 c0                	add    %eax,%eax
  800839:	01 d8                	add    %ebx,%eax
  80083b:	83 e8 30             	sub    $0x30,%eax
  80083e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800841:	8b 45 10             	mov    0x10(%ebp),%eax
  800844:	8a 00                	mov    (%eax),%al
  800846:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800849:	83 fb 2f             	cmp    $0x2f,%ebx
  80084c:	7e 3e                	jle    80088c <vprintfmt+0xe9>
  80084e:	83 fb 39             	cmp    $0x39,%ebx
  800851:	7f 39                	jg     80088c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800853:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800856:	eb d5                	jmp    80082d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 e8 04             	sub    $0x4,%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80086c:	eb 1f                	jmp    80088d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80086e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800872:	79 83                	jns    8007f7 <vprintfmt+0x54>
				width = 0;
  800874:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80087b:	e9 77 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800880:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800887:	e9 6b ff ff ff       	jmp    8007f7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80088c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80088d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800891:	0f 89 60 ff ff ff    	jns    8007f7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008a4:	e9 4e ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ac:	e9 46 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	50                   	push   %eax
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
			break;
  8008d1:	e9 89 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	83 c0 04             	add    $0x4,%eax
  8008dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	83 e8 04             	sub    $0x4,%eax
  8008e5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008e7:	85 db                	test   %ebx,%ebx
  8008e9:	79 02                	jns    8008ed <vprintfmt+0x14a>
				err = -err;
  8008eb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008ed:	83 fb 64             	cmp    $0x64,%ebx
  8008f0:	7f 0b                	jg     8008fd <vprintfmt+0x15a>
  8008f2:	8b 34 9d 80 3a 80 00 	mov    0x803a80(,%ebx,4),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 19                	jne    800916 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	53                   	push   %ebx
  8008fe:	68 25 3c 80 00       	push   $0x803c25
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	ff 75 08             	pushl  0x8(%ebp)
  800909:	e8 5e 02 00 00       	call   800b6c <printfmt>
  80090e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800911:	e9 49 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800916:	56                   	push   %esi
  800917:	68 2e 3c 80 00       	push   $0x803c2e
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	ff 75 08             	pushl  0x8(%ebp)
  800922:	e8 45 02 00 00       	call   800b6c <printfmt>
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 30 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 30                	mov    (%eax),%esi
  800940:	85 f6                	test   %esi,%esi
  800942:	75 05                	jne    800949 <vprintfmt+0x1a6>
				p = "(null)";
  800944:	be 31 3c 80 00       	mov    $0x803c31,%esi
			if (width > 0 && padc != '-')
  800949:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094d:	7e 6d                	jle    8009bc <vprintfmt+0x219>
  80094f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800953:	74 67                	je     8009bc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	50                   	push   %eax
  80095c:	56                   	push   %esi
  80095d:	e8 0c 03 00 00       	call   800c6e <strnlen>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800968:	eb 16                	jmp    800980 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80096a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	50                   	push   %eax
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	ff d0                	call   *%eax
  80097a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80097d:	ff 4d e4             	decl   -0x1c(%ebp)
  800980:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800984:	7f e4                	jg     80096a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800986:	eb 34                	jmp    8009bc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800988:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80098c:	74 1c                	je     8009aa <vprintfmt+0x207>
  80098e:	83 fb 1f             	cmp    $0x1f,%ebx
  800991:	7e 05                	jle    800998 <vprintfmt+0x1f5>
  800993:	83 fb 7e             	cmp    $0x7e,%ebx
  800996:	7e 12                	jle    8009aa <vprintfmt+0x207>
					putch('?', putdat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	6a 3f                	push   $0x3f
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	ff d0                	call   *%eax
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	eb 0f                	jmp    8009b9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	53                   	push   %ebx
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bc:	89 f0                	mov    %esi,%eax
  8009be:	8d 70 01             	lea    0x1(%eax),%esi
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f be d8             	movsbl %al,%ebx
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	74 24                	je     8009ee <vprintfmt+0x24b>
  8009ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ce:	78 b8                	js     800988 <vprintfmt+0x1e5>
  8009d0:	ff 4d e0             	decl   -0x20(%ebp)
  8009d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d7:	79 af                	jns    800988 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d9:	eb 13                	jmp    8009ee <vprintfmt+0x24b>
				putch(' ', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 20                	push   $0x20
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f2:	7f e7                	jg     8009db <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009f4:	e9 66 01 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800a02:	50                   	push   %eax
  800a03:	e8 3c fd ff ff       	call   800744 <getint>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a17:	85 d2                	test   %edx,%edx
  800a19:	79 23                	jns    800a3e <vprintfmt+0x29b>
				putch('-', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 2d                	push   $0x2d
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a31:	f7 d8                	neg    %eax
  800a33:	83 d2 00             	adc    $0x0,%edx
  800a36:	f7 da                	neg    %edx
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a45:	e9 bc 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a50:	8d 45 14             	lea    0x14(%ebp),%eax
  800a53:	50                   	push   %eax
  800a54:	e8 84 fc ff ff       	call   8006dd <getuint>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a62:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a69:	e9 98 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	6a 58                	push   $0x58
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	6a 58                	push   $0x58
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	ff d0                	call   *%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 30                	push   $0x30
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	6a 78                	push   $0x78
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	ff d0                	call   *%eax
  800ac0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	83 c0 04             	add    $0x4,%eax
  800ac9:	89 45 14             	mov    %eax,0x14(%ebp)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	83 e8 04             	sub    $0x4,%eax
  800ad2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ade:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ae5:	eb 1f                	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 e8             	pushl  -0x18(%ebp)
  800aed:	8d 45 14             	lea    0x14(%ebp),%eax
  800af0:	50                   	push   %eax
  800af1:	e8 e7 fb ff ff       	call   8006dd <getuint>
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b06:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0d:	83 ec 04             	sub    $0x4,%esp
  800b10:	52                   	push   %edx
  800b11:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b14:	50                   	push   %eax
  800b15:	ff 75 f4             	pushl  -0xc(%ebp)
  800b18:	ff 75 f0             	pushl  -0x10(%ebp)
  800b1b:	ff 75 0c             	pushl  0xc(%ebp)
  800b1e:	ff 75 08             	pushl  0x8(%ebp)
  800b21:	e8 00 fb ff ff       	call   800626 <printnum>
  800b26:	83 c4 20             	add    $0x20,%esp
			break;
  800b29:	eb 34                	jmp    800b5f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
			break;
  800b3a:	eb 23                	jmp    800b5f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	6a 25                	push   $0x25
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4c:	ff 4d 10             	decl   0x10(%ebp)
  800b4f:	eb 03                	jmp    800b54 <vprintfmt+0x3b1>
  800b51:	ff 4d 10             	decl   0x10(%ebp)
  800b54:	8b 45 10             	mov    0x10(%ebp),%eax
  800b57:	48                   	dec    %eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	3c 25                	cmp    $0x25,%al
  800b5c:	75 f3                	jne    800b51 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b5e:	90                   	nop
		}
	}
  800b5f:	e9 47 fc ff ff       	jmp    8007ab <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b64:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b72:	8d 45 10             	lea    0x10(%ebp),%eax
  800b75:	83 c0 04             	add    $0x4,%eax
  800b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	50                   	push   %eax
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	ff 75 08             	pushl  0x8(%ebp)
  800b88:	e8 16 fc ff ff       	call   8007a3 <vprintfmt>
  800b8d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b90:	90                   	nop
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	8b 40 08             	mov    0x8(%eax),%eax
  800b9c:	8d 50 01             	lea    0x1(%eax),%edx
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	8b 10                	mov    (%eax),%edx
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8b 40 04             	mov    0x4(%eax),%eax
  800bb0:	39 c2                	cmp    %eax,%edx
  800bb2:	73 12                	jae    800bc6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	89 0a                	mov    %ecx,(%edx)
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	88 10                	mov    %dl,(%eax)
}
  800bc6:	90                   	nop
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	01 d0                	add    %edx,%eax
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bee:	74 06                	je     800bf6 <vsnprintf+0x2d>
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	7f 07                	jg     800bfd <vsnprintf+0x34>
		return -E_INVAL;
  800bf6:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfb:	eb 20                	jmp    800c1d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bfd:	ff 75 14             	pushl  0x14(%ebp)
  800c00:	ff 75 10             	pushl  0x10(%ebp)
  800c03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c06:	50                   	push   %eax
  800c07:	68 93 0b 80 00       	push   $0x800b93
  800c0c:	e8 92 fb ff ff       	call   8007a3 <vprintfmt>
  800c11:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c17:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c25:	8d 45 10             	lea    0x10(%ebp),%eax
  800c28:	83 c0 04             	add    $0x4,%eax
  800c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	ff 75 f4             	pushl  -0xc(%ebp)
  800c34:	50                   	push   %eax
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	ff 75 08             	pushl  0x8(%ebp)
  800c3b:	e8 89 ff ff ff       	call   800bc9 <vsnprintf>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c58:	eb 06                	jmp    800c60 <strlen+0x15>
		n++;
  800c5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5d:	ff 45 08             	incl   0x8(%ebp)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 f1                	jne    800c5a <strlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7b:	eb 09                	jmp    800c86 <strnlen+0x18>
		n++;
  800c7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c80:	ff 45 08             	incl   0x8(%ebp)
  800c83:	ff 4d 0c             	decl   0xc(%ebp)
  800c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8a:	74 09                	je     800c95 <strnlen+0x27>
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	84 c0                	test   %al,%al
  800c93:	75 e8                	jne    800c7d <strnlen+0xf>
		n++;
	return n;
  800c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca6:	90                   	nop
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8d 50 01             	lea    0x1(%eax),%edx
  800cad:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb9:	8a 12                	mov    (%edx),%dl
  800cbb:	88 10                	mov    %dl,(%eax)
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	84 c0                	test   %al,%al
  800cc1:	75 e4                	jne    800ca7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc6:	c9                   	leave  
  800cc7:	c3                   	ret    

00800cc8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdb:	eb 1f                	jmp    800cfc <strncpy+0x34>
		*dst++ = *src;
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8d 50 01             	lea    0x1(%eax),%edx
  800ce3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	84 c0                	test   %al,%al
  800cf4:	74 03                	je     800cf9 <strncpy+0x31>
			src++;
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf9:	ff 45 fc             	incl   -0x4(%ebp)
  800cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cff:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d02:	72 d9                	jb     800cdd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d19:	74 30                	je     800d4b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d1b:	eb 16                	jmp    800d33 <strlcpy+0x2a>
			*dst++ = *src++;
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	89 55 08             	mov    %edx,0x8(%ebp)
  800d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d2f:	8a 12                	mov    (%edx),%dl
  800d31:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d33:	ff 4d 10             	decl   0x10(%ebp)
  800d36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3a:	74 09                	je     800d45 <strlcpy+0x3c>
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	84 c0                	test   %al,%al
  800d43:	75 d8                	jne    800d1d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d51:	29 c2                	sub    %eax,%edx
  800d53:	89 d0                	mov    %edx,%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5a:	eb 06                	jmp    800d62 <strcmp+0xb>
		p++, q++;
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	84 c0                	test   %al,%al
  800d69:	74 0e                	je     800d79 <strcmp+0x22>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 10                	mov    (%eax),%dl
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	38 c2                	cmp    %al,%dl
  800d77:	74 e3                	je     800d5c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 d0             	movzbl %al,%edx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 c0             	movzbl %al,%eax
  800d89:	29 c2                	sub    %eax,%edx
  800d8b:	89 d0                	mov    %edx,%eax
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d92:	eb 09                	jmp    800d9d <strncmp+0xe>
		n--, p++, q++;
  800d94:	ff 4d 10             	decl   0x10(%ebp)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 17                	je     800dba <strncmp+0x2b>
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	74 0e                	je     800dba <strncmp+0x2b>
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 10                	mov    (%eax),%dl
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	38 c2                	cmp    %al,%dl
  800db8:	74 da                	je     800d94 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbe:	75 07                	jne    800dc7 <strncmp+0x38>
		return 0;
  800dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc5:	eb 14                	jmp    800ddb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f b6 d0             	movzbl %al,%edx
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 c0             	movzbl %al,%eax
  800dd7:	29 c2                	sub    %eax,%edx
  800dd9:	89 d0                	mov    %edx,%eax
}
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800de9:	eb 12                	jmp    800dfd <strchr+0x20>
		if (*s == c)
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df3:	75 05                	jne    800dfa <strchr+0x1d>
			return (char *) s;
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	eb 11                	jmp    800e0b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfa:	ff 45 08             	incl   0x8(%ebp)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	84 c0                	test   %al,%al
  800e04:	75 e5                	jne    800deb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e19:	eb 0d                	jmp    800e28 <strfind+0x1b>
		if (*s == c)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e23:	74 0e                	je     800e33 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e25:	ff 45 08             	incl   0x8(%ebp)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	84 c0                	test   %al,%al
  800e2f:	75 ea                	jne    800e1b <strfind+0xe>
  800e31:	eb 01                	jmp    800e34 <strfind+0x27>
		if (*s == c)
			break;
  800e33:	90                   	nop
	return (char *) s;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e4b:	eb 0e                	jmp    800e5b <memset+0x22>
		*p++ = c;
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e5b:	ff 4d f8             	decl   -0x8(%ebp)
  800e5e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e62:	79 e9                	jns    800e4d <memset+0x14>
		*p++ = c;

	return v;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e7b:	eb 16                	jmp    800e93 <memcpy+0x2a>
		*d++ = *s++;
  800e7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e80:	8d 50 01             	lea    0x1(%eax),%edx
  800e83:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e93:	8b 45 10             	mov    0x10(%ebp),%eax
  800e96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e99:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	75 dd                	jne    800e7d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ebd:	73 50                	jae    800f0f <memmove+0x6a>
  800ebf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eca:	76 43                	jbe    800f0f <memmove+0x6a>
		s += n;
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed8:	eb 10                	jmp    800eea <memmove+0x45>
			*--d = *--s;
  800eda:	ff 4d f8             	decl   -0x8(%ebp)
  800edd:	ff 4d fc             	decl   -0x4(%ebp)
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 10                	mov    (%eax),%dl
  800ee5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eea:	8b 45 10             	mov    0x10(%ebp),%eax
  800eed:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	75 e3                	jne    800eda <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ef7:	eb 23                	jmp    800f1c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ef9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efc:	8d 50 01             	lea    0x1(%eax),%edx
  800eff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f08:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0b:	8a 12                	mov    (%edx),%dl
  800f0d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f15:	89 55 10             	mov    %edx,0x10(%ebp)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	75 dd                	jne    800ef9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f33:	eb 2a                	jmp    800f5f <memcmp+0x3e>
		if (*s1 != *s2)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	38 c2                	cmp    %al,%dl
  800f41:	74 16                	je     800f59 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 d0             	movzbl %al,%edx
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	eb 18                	jmp    800f71 <memcmp+0x50>
		s1++, s2++;
  800f59:	ff 45 fc             	incl   -0x4(%ebp)
  800f5c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f65:	89 55 10             	mov    %edx,0x10(%ebp)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 c9                	jne    800f35 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f84:	eb 15                	jmp    800f9b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f b6 d0             	movzbl %al,%edx
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	39 c2                	cmp    %eax,%edx
  800f96:	74 0d                	je     800fa5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa1:	72 e3                	jb     800f86 <memfind+0x13>
  800fa3:	eb 01                	jmp    800fa6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fa5:	90                   	nop
	return (void *) s;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fb8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fbf:	eb 03                	jmp    800fc4 <strtol+0x19>
		s++;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 20                	cmp    $0x20,%al
  800fcb:	74 f4                	je     800fc1 <strtol+0x16>
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 09                	cmp    $0x9,%al
  800fd4:	74 eb                	je     800fc1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 2b                	cmp    $0x2b,%al
  800fdd:	75 05                	jne    800fe4 <strtol+0x39>
		s++;
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	eb 13                	jmp    800ff7 <strtol+0x4c>
	else if (*s == '-')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 2d                	cmp    $0x2d,%al
  800feb:	75 0a                	jne    800ff7 <strtol+0x4c>
		s++, neg = 1;
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	74 06                	je     801003 <strtol+0x58>
  800ffd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801001:	75 20                	jne    801023 <strtol+0x78>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 30                	cmp    $0x30,%al
  80100a:	75 17                	jne    801023 <strtol+0x78>
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	40                   	inc    %eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 78                	cmp    $0x78,%al
  801014:	75 0d                	jne    801023 <strtol+0x78>
		s += 2, base = 16;
  801016:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80101a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801021:	eb 28                	jmp    80104b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801023:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801027:	75 15                	jne    80103e <strtol+0x93>
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 30                	cmp    $0x30,%al
  801030:	75 0c                	jne    80103e <strtol+0x93>
		s++, base = 8;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80103c:	eb 0d                	jmp    80104b <strtol+0xa0>
	else if (base == 0)
  80103e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801042:	75 07                	jne    80104b <strtol+0xa0>
		base = 10;
  801044:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 2f                	cmp    $0x2f,%al
  801052:	7e 19                	jle    80106d <strtol+0xc2>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 39                	cmp    $0x39,%al
  80105b:	7f 10                	jg     80106d <strtol+0xc2>
			dig = *s - '0';
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 30             	sub    $0x30,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106b:	eb 42                	jmp    8010af <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 60                	cmp    $0x60,%al
  801074:	7e 19                	jle    80108f <strtol+0xe4>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 7a                	cmp    $0x7a,%al
  80107d:	7f 10                	jg     80108f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	0f be c0             	movsbl %al,%eax
  801087:	83 e8 57             	sub    $0x57,%eax
  80108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108d:	eb 20                	jmp    8010af <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 40                	cmp    $0x40,%al
  801096:	7e 39                	jle    8010d1 <strtol+0x126>
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 5a                	cmp    $0x5a,%al
  80109f:	7f 30                	jg     8010d1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	0f be c0             	movsbl %al,%eax
  8010a9:	83 e8 37             	sub    $0x37,%eax
  8010ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010b5:	7d 19                	jge    8010d0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010b7:	ff 45 08             	incl   0x8(%ebp)
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010cb:	e9 7b ff ff ff       	jmp    80104b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d5:	74 08                	je     8010df <strtol+0x134>
		*endptr = (char *) s;
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e3:	74 07                	je     8010ec <strtol+0x141>
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	f7 d8                	neg    %eax
  8010ea:	eb 03                	jmp    8010ef <strtol+0x144>
  8010ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801109:	79 13                	jns    80111e <ltostr+0x2d>
	{
		neg = 1;
  80110b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801118:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80111b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801126:	99                   	cltd   
  801127:	f7 f9                	idiv   %ecx
  801129:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80112c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112f:	8d 50 01             	lea    0x1(%eax),%edx
  801132:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801135:	89 c2                	mov    %eax,%edx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	01 d0                	add    %edx,%eax
  80113c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80113f:	83 c2 30             	add    $0x30,%edx
  801142:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801144:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801147:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80114c:	f7 e9                	imul   %ecx
  80114e:	c1 fa 02             	sar    $0x2,%edx
  801151:	89 c8                	mov    %ecx,%eax
  801153:	c1 f8 1f             	sar    $0x1f,%eax
  801156:	29 c2                	sub    %eax,%edx
  801158:	89 d0                	mov    %edx,%eax
  80115a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80115d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801160:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801165:	f7 e9                	imul   %ecx
  801167:	c1 fa 02             	sar    $0x2,%edx
  80116a:	89 c8                	mov    %ecx,%eax
  80116c:	c1 f8 1f             	sar    $0x1f,%eax
  80116f:	29 c2                	sub    %eax,%edx
  801171:	89 d0                	mov    %edx,%eax
  801173:	c1 e0 02             	shl    $0x2,%eax
  801176:	01 d0                	add    %edx,%eax
  801178:	01 c0                	add    %eax,%eax
  80117a:	29 c1                	sub    %eax,%ecx
  80117c:	89 ca                	mov    %ecx,%edx
  80117e:	85 d2                	test   %edx,%edx
  801180:	75 9c                	jne    80111e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	48                   	dec    %eax
  80118d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801190:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801194:	74 3d                	je     8011d3 <ltostr+0xe2>
		start = 1 ;
  801196:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80119d:	eb 34                	jmp    8011d3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	01 c2                	add    %eax,%edx
  8011b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c8                	add    %ecx,%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	01 c2                	add    %eax,%edx
  8011c8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011cb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011cd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c c4                	jl     80119f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011db:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	e8 54 fa ff ff       	call   800c4b <strlen>
  8011f7:	83 c4 04             	add    $0x4,%esp
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	e8 46 fa ff ff       	call   800c4b <strlen>
  801205:	83 c4 04             	add    $0x4,%esp
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801219:	eb 17                	jmp    801232 <strcconcat+0x49>
		final[s] = str1[s] ;
  80121b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121e:	8b 45 10             	mov    0x10(%ebp),%eax
  801221:	01 c2                	add    %eax,%edx
  801223:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	01 c8                	add    %ecx,%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80122f:	ff 45 fc             	incl   -0x4(%ebp)
  801232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801235:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801238:	7c e1                	jl     80121b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80123a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801241:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801248:	eb 1f                	jmp    801269 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c8                	add    %ecx,%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801266:	ff 45 f8             	incl   -0x8(%ebp)
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126f:	7c d9                	jl     80124a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801271:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	01 d0                	add    %edx,%eax
  801279:	c6 00 00             	movb   $0x0,(%eax)
}
  80127c:	90                   	nop
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80128b:	8b 45 14             	mov    0x14(%ebp),%eax
  80128e:	8b 00                	mov    (%eax),%eax
  801290:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a2:	eb 0c                	jmp    8012b0 <strsplit+0x31>
			*string++ = 0;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8d 50 01             	lea    0x1(%eax),%edx
  8012aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ad:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	84 c0                	test   %al,%al
  8012b7:	74 18                	je     8012d1 <strsplit+0x52>
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	0f be c0             	movsbl %al,%eax
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	e8 13 fb ff ff       	call   800ddd <strchr>
  8012ca:	83 c4 08             	add    $0x8,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	75 d3                	jne    8012a4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	74 5a                	je     801334 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012da:	8b 45 14             	mov    0x14(%ebp),%eax
  8012dd:	8b 00                	mov    (%eax),%eax
  8012df:	83 f8 0f             	cmp    $0xf,%eax
  8012e2:	75 07                	jne    8012eb <strsplit+0x6c>
		{
			return 0;
  8012e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e9:	eb 66                	jmp    801351 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f3:	8b 55 14             	mov    0x14(%ebp),%edx
  8012f6:	89 0a                	mov    %ecx,(%edx)
  8012f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 c2                	add    %eax,%edx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801309:	eb 03                	jmp    80130e <strsplit+0x8f>
			string++;
  80130b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	74 8b                	je     8012a2 <strsplit+0x23>
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f be c0             	movsbl %al,%eax
  80131f:	50                   	push   %eax
  801320:	ff 75 0c             	pushl  0xc(%ebp)
  801323:	e8 b5 fa ff ff       	call   800ddd <strchr>
  801328:	83 c4 08             	add    $0x8,%esp
  80132b:	85 c0                	test   %eax,%eax
  80132d:	74 dc                	je     80130b <strsplit+0x8c>
			string++;
	}
  80132f:	e9 6e ff ff ff       	jmp    8012a2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801334:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	8b 00                	mov    (%eax),%eax
  80133a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 d0                	add    %edx,%eax
  801346:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80134c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801359:	a1 04 50 80 00       	mov    0x805004,%eax
  80135e:	85 c0                	test   %eax,%eax
  801360:	74 1f                	je     801381 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801362:	e8 1d 00 00 00       	call   801384 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	68 90 3d 80 00       	push   $0x803d90
  80136f:	e8 55 f2 ff ff       	call   8005c9 <cprintf>
  801374:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801377:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80137e:	00 00 00 
	}
}
  801381:	90                   	nop
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80138a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801391:	00 00 00 
  801394:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80139b:	00 00 00 
  80139e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8013a5:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013a8:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8013af:	00 00 00 
  8013b2:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8013b9:	00 00 00 
  8013bc:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8013c3:	00 00 00 
	uint32 arr_size = 0;
  8013c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8013cd:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8013d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013dc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013e1:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8013e6:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8013ed:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8013f0:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8013f7:	a1 20 51 80 00       	mov    0x805120,%eax
  8013fc:	c1 e0 04             	shl    $0x4,%eax
  8013ff:	89 c2                	mov    %eax,%edx
  801401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801404:	01 d0                	add    %edx,%eax
  801406:	48                   	dec    %eax
  801407:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80140a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80140d:	ba 00 00 00 00       	mov    $0x0,%edx
  801412:	f7 75 ec             	divl   -0x14(%ebp)
  801415:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801418:	29 d0                	sub    %edx,%eax
  80141a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  80141d:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801427:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80142c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801431:	83 ec 04             	sub    $0x4,%esp
  801434:	6a 06                	push   $0x6
  801436:	ff 75 f4             	pushl  -0xc(%ebp)
  801439:	50                   	push   %eax
  80143a:	e8 b5 03 00 00       	call   8017f4 <sys_allocate_chunk>
  80143f:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801442:	a1 20 51 80 00       	mov    0x805120,%eax
  801447:	83 ec 0c             	sub    $0xc,%esp
  80144a:	50                   	push   %eax
  80144b:	e8 2a 0a 00 00       	call   801e7a <initialize_MemBlocksList>
  801450:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801453:	a1 48 51 80 00       	mov    0x805148,%eax
  801458:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  80145b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801468:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  80146f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801473:	75 14                	jne    801489 <initialize_dyn_block_system+0x105>
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	68 b5 3d 80 00       	push   $0x803db5
  80147d:	6a 33                	push   $0x33
  80147f:	68 d3 3d 80 00       	push   $0x803dd3
  801484:	e8 8c ee ff ff       	call   800315 <_panic>
  801489:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148c:	8b 00                	mov    (%eax),%eax
  80148e:	85 c0                	test   %eax,%eax
  801490:	74 10                	je     8014a2 <initialize_dyn_block_system+0x11e>
  801492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801495:	8b 00                	mov    (%eax),%eax
  801497:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80149a:	8b 52 04             	mov    0x4(%edx),%edx
  80149d:	89 50 04             	mov    %edx,0x4(%eax)
  8014a0:	eb 0b                	jmp    8014ad <initialize_dyn_block_system+0x129>
  8014a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a5:	8b 40 04             	mov    0x4(%eax),%eax
  8014a8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8014ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b0:	8b 40 04             	mov    0x4(%eax),%eax
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	74 0f                	je     8014c6 <initialize_dyn_block_system+0x142>
  8014b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ba:	8b 40 04             	mov    0x4(%eax),%eax
  8014bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014c0:	8b 12                	mov    (%edx),%edx
  8014c2:	89 10                	mov    %edx,(%eax)
  8014c4:	eb 0a                	jmp    8014d0 <initialize_dyn_block_system+0x14c>
  8014c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c9:	8b 00                	mov    (%eax),%eax
  8014cb:	a3 48 51 80 00       	mov    %eax,0x805148
  8014d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014e3:	a1 54 51 80 00       	mov    0x805154,%eax
  8014e8:	48                   	dec    %eax
  8014e9:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8014ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014f2:	75 14                	jne    801508 <initialize_dyn_block_system+0x184>
  8014f4:	83 ec 04             	sub    $0x4,%esp
  8014f7:	68 e0 3d 80 00       	push   $0x803de0
  8014fc:	6a 34                	push   $0x34
  8014fe:	68 d3 3d 80 00       	push   $0x803dd3
  801503:	e8 0d ee ff ff       	call   800315 <_panic>
  801508:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80150e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801511:	89 10                	mov    %edx,(%eax)
  801513:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801516:	8b 00                	mov    (%eax),%eax
  801518:	85 c0                	test   %eax,%eax
  80151a:	74 0d                	je     801529 <initialize_dyn_block_system+0x1a5>
  80151c:	a1 38 51 80 00       	mov    0x805138,%eax
  801521:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801524:	89 50 04             	mov    %edx,0x4(%eax)
  801527:	eb 08                	jmp    801531 <initialize_dyn_block_system+0x1ad>
  801529:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801531:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801534:	a3 38 51 80 00       	mov    %eax,0x805138
  801539:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801543:	a1 44 51 80 00       	mov    0x805144,%eax
  801548:	40                   	inc    %eax
  801549:	a3 44 51 80 00       	mov    %eax,0x805144
}
  80154e:	90                   	nop
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801557:	e8 f7 fd ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  80155c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801560:	75 07                	jne    801569 <malloc+0x18>
  801562:	b8 00 00 00 00       	mov    $0x0,%eax
  801567:	eb 14                	jmp    80157d <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801569:	83 ec 04             	sub    $0x4,%esp
  80156c:	68 04 3e 80 00       	push   $0x803e04
  801571:	6a 46                	push   $0x46
  801573:	68 d3 3d 80 00       	push   $0x803dd3
  801578:	e8 98 ed ff ff       	call   800315 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801585:	83 ec 04             	sub    $0x4,%esp
  801588:	68 2c 3e 80 00       	push   $0x803e2c
  80158d:	6a 61                	push   $0x61
  80158f:	68 d3 3d 80 00       	push   $0x803dd3
  801594:	e8 7c ed ff ff       	call   800315 <_panic>

00801599 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 18             	sub    $0x18,%esp
  80159f:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a2:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015a5:	e8 a9 fd ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015ae:	75 07                	jne    8015b7 <smalloc+0x1e>
  8015b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b5:	eb 14                	jmp    8015cb <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8015b7:	83 ec 04             	sub    $0x4,%esp
  8015ba:	68 50 3e 80 00       	push   $0x803e50
  8015bf:	6a 76                	push   $0x76
  8015c1:	68 d3 3d 80 00       	push   $0x803dd3
  8015c6:	e8 4a ed ff ff       	call   800315 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015d3:	e8 7b fd ff ff       	call   801353 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	68 78 3e 80 00       	push   $0x803e78
  8015e0:	68 93 00 00 00       	push   $0x93
  8015e5:	68 d3 3d 80 00       	push   $0x803dd3
  8015ea:	e8 26 ed ff ff       	call   800315 <_panic>

008015ef <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f5:	e8 59 fd ff ff       	call   801353 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015fa:	83 ec 04             	sub    $0x4,%esp
  8015fd:	68 9c 3e 80 00       	push   $0x803e9c
  801602:	68 c5 00 00 00       	push   $0xc5
  801607:	68 d3 3d 80 00       	push   $0x803dd3
  80160c:	e8 04 ed ff ff       	call   800315 <_panic>

00801611 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801617:	83 ec 04             	sub    $0x4,%esp
  80161a:	68 c4 3e 80 00       	push   $0x803ec4
  80161f:	68 d9 00 00 00       	push   $0xd9
  801624:	68 d3 3d 80 00       	push   $0x803dd3
  801629:	e8 e7 ec ff ff       	call   800315 <_panic>

0080162e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801634:	83 ec 04             	sub    $0x4,%esp
  801637:	68 e8 3e 80 00       	push   $0x803ee8
  80163c:	68 e4 00 00 00       	push   $0xe4
  801641:	68 d3 3d 80 00       	push   $0x803dd3
  801646:	e8 ca ec ff ff       	call   800315 <_panic>

0080164b <shrink>:

}
void shrink(uint32 newSize)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	68 e8 3e 80 00       	push   $0x803ee8
  801659:	68 e9 00 00 00       	push   $0xe9
  80165e:	68 d3 3d 80 00       	push   $0x803dd3
  801663:	e8 ad ec ff ff       	call   800315 <_panic>

00801668 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80166e:	83 ec 04             	sub    $0x4,%esp
  801671:	68 e8 3e 80 00       	push   $0x803ee8
  801676:	68 ee 00 00 00       	push   $0xee
  80167b:	68 d3 3d 80 00       	push   $0x803dd3
  801680:	e8 90 ec ff ff       	call   800315 <_panic>

00801685 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	57                   	push   %edi
  801689:	56                   	push   %esi
  80168a:	53                   	push   %ebx
  80168b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	8b 55 0c             	mov    0xc(%ebp),%edx
  801694:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801697:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80169a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80169d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016a0:	cd 30                	int    $0x30
  8016a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	5b                   	pop    %ebx
  8016ac:	5e                   	pop    %esi
  8016ad:	5f                   	pop    %edi
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    

008016b0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 04             	sub    $0x4,%esp
  8016b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016bc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	52                   	push   %edx
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	50                   	push   %eax
  8016cc:	6a 00                	push   $0x0
  8016ce:	e8 b2 ff ff ff       	call   801685 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
}
  8016d6:	90                   	nop
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 01                	push   $0x1
  8016e8:	e8 98 ff ff ff       	call   801685 <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	52                   	push   %edx
  801702:	50                   	push   %eax
  801703:	6a 05                	push   $0x5
  801705:	e8 7b ff ff ff       	call   801685 <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	56                   	push   %esi
  801713:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801714:	8b 75 18             	mov    0x18(%ebp),%esi
  801717:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80171a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80171d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	56                   	push   %esi
  801724:	53                   	push   %ebx
  801725:	51                   	push   %ecx
  801726:	52                   	push   %edx
  801727:	50                   	push   %eax
  801728:	6a 06                	push   $0x6
  80172a:	e8 56 ff ff ff       	call   801685 <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
}
  801732:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801735:	5b                   	pop    %ebx
  801736:	5e                   	pop    %esi
  801737:	5d                   	pop    %ebp
  801738:	c3                   	ret    

00801739 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	52                   	push   %edx
  801749:	50                   	push   %eax
  80174a:	6a 07                	push   $0x7
  80174c:	e8 34 ff ff ff       	call   801685 <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	ff 75 0c             	pushl  0xc(%ebp)
  801762:	ff 75 08             	pushl  0x8(%ebp)
  801765:	6a 08                	push   $0x8
  801767:	e8 19 ff ff ff       	call   801685 <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 09                	push   $0x9
  801780:	e8 00 ff ff ff       	call   801685 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 0a                	push   $0xa
  801799:	e8 e7 fe ff ff       	call   801685 <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 0b                	push   $0xb
  8017b2:	e8 ce fe ff ff       	call   801685 <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	ff 75 0c             	pushl  0xc(%ebp)
  8017c8:	ff 75 08             	pushl  0x8(%ebp)
  8017cb:	6a 0f                	push   $0xf
  8017cd:	e8 b3 fe ff ff       	call   801685 <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
	return;
  8017d5:	90                   	nop
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	ff 75 0c             	pushl  0xc(%ebp)
  8017e4:	ff 75 08             	pushl  0x8(%ebp)
  8017e7:	6a 10                	push   $0x10
  8017e9:	e8 97 fe ff ff       	call   801685 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f1:	90                   	nop
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	ff 75 10             	pushl  0x10(%ebp)
  8017fe:	ff 75 0c             	pushl  0xc(%ebp)
  801801:	ff 75 08             	pushl  0x8(%ebp)
  801804:	6a 11                	push   $0x11
  801806:	e8 7a fe ff ff       	call   801685 <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
	return ;
  80180e:	90                   	nop
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 0c                	push   $0xc
  801820:	e8 60 fe ff ff       	call   801685 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	ff 75 08             	pushl  0x8(%ebp)
  801838:	6a 0d                	push   $0xd
  80183a:	e8 46 fe ff ff       	call   801685 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 0e                	push   $0xe
  801853:	e8 2d fe ff ff       	call   801685 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	90                   	nop
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 13                	push   $0x13
  80186d:	e8 13 fe ff ff       	call   801685 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	90                   	nop
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 14                	push   $0x14
  801887:	e8 f9 fd ff ff       	call   801685 <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
}
  80188f:	90                   	nop
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_cputc>:


void
sys_cputc(const char c)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 04             	sub    $0x4,%esp
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80189e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	50                   	push   %eax
  8018ab:	6a 15                	push   $0x15
  8018ad:	e8 d3 fd ff ff       	call   801685 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	90                   	nop
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 16                	push   $0x16
  8018c7:	e8 b9 fd ff ff       	call   801685 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	90                   	nop
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	50                   	push   %eax
  8018e2:	6a 17                	push   $0x17
  8018e4:	e8 9c fd ff ff       	call   801685 <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	52                   	push   %edx
  8018fe:	50                   	push   %eax
  8018ff:	6a 1a                	push   $0x1a
  801901:	e8 7f fd ff ff       	call   801685 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80190e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	52                   	push   %edx
  80191b:	50                   	push   %eax
  80191c:	6a 18                	push   $0x18
  80191e:	e8 62 fd ff ff       	call   801685 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	90                   	nop
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80192c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	52                   	push   %edx
  801939:	50                   	push   %eax
  80193a:	6a 19                	push   $0x19
  80193c:	e8 44 fd ff ff       	call   801685 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	90                   	nop
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 04             	sub    $0x4,%esp
  80194d:	8b 45 10             	mov    0x10(%ebp),%eax
  801950:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801953:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801956:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	51                   	push   %ecx
  801960:	52                   	push   %edx
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	50                   	push   %eax
  801965:	6a 1b                	push   $0x1b
  801967:	e8 19 fd ff ff       	call   801685 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801974:	8b 55 0c             	mov    0xc(%ebp),%edx
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	52                   	push   %edx
  801981:	50                   	push   %eax
  801982:	6a 1c                	push   $0x1c
  801984:	e8 fc fc ff ff       	call   801685 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801991:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801994:	8b 55 0c             	mov    0xc(%ebp),%edx
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	51                   	push   %ecx
  80199f:	52                   	push   %edx
  8019a0:	50                   	push   %eax
  8019a1:	6a 1d                	push   $0x1d
  8019a3:	e8 dd fc ff ff       	call   801685 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	52                   	push   %edx
  8019bd:	50                   	push   %eax
  8019be:	6a 1e                	push   $0x1e
  8019c0:	e8 c0 fc ff ff       	call   801685 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 1f                	push   $0x1f
  8019d9:	e8 a7 fc ff ff       	call   801685 <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	6a 00                	push   $0x0
  8019eb:	ff 75 14             	pushl  0x14(%ebp)
  8019ee:	ff 75 10             	pushl  0x10(%ebp)
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	50                   	push   %eax
  8019f5:	6a 20                	push   $0x20
  8019f7:	e8 89 fc ff ff       	call   801685 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	50                   	push   %eax
  801a10:	6a 21                	push   $0x21
  801a12:	e8 6e fc ff ff       	call   801685 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	90                   	nop
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	50                   	push   %eax
  801a2c:	6a 22                	push   $0x22
  801a2e:	e8 52 fc ff ff       	call   801685 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 02                	push   $0x2
  801a47:	e8 39 fc ff ff       	call   801685 <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 03                	push   $0x3
  801a60:	e8 20 fc ff ff       	call   801685 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 04                	push   $0x4
  801a79:	e8 07 fc ff ff       	call   801685 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_exit_env>:


void sys_exit_env(void)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 23                	push   $0x23
  801a92:	e8 ee fb ff ff       	call   801685 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	90                   	nop
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801aa3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aa6:	8d 50 04             	lea    0x4(%eax),%edx
  801aa9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	52                   	push   %edx
  801ab3:	50                   	push   %eax
  801ab4:	6a 24                	push   $0x24
  801ab6:	e8 ca fb ff ff       	call   801685 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
	return result;
  801abe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ac1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ac4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac7:	89 01                	mov    %eax,(%ecx)
  801ac9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	c9                   	leave  
  801ad0:	c2 04 00             	ret    $0x4

00801ad3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	ff 75 10             	pushl  0x10(%ebp)
  801add:	ff 75 0c             	pushl  0xc(%ebp)
  801ae0:	ff 75 08             	pushl  0x8(%ebp)
  801ae3:	6a 12                	push   $0x12
  801ae5:	e8 9b fb ff ff       	call   801685 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
	return ;
  801aed:	90                   	nop
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 25                	push   $0x25
  801aff:	e8 81 fb ff ff       	call   801685 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 04             	sub    $0x4,%esp
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b15:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	50                   	push   %eax
  801b22:	6a 26                	push   $0x26
  801b24:	e8 5c fb ff ff       	call   801685 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2c:	90                   	nop
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <rsttst>:
void rsttst()
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 28                	push   $0x28
  801b3e:	e8 42 fb ff ff       	call   801685 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
	return ;
  801b46:	90                   	nop
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 04             	sub    $0x4,%esp
  801b4f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b52:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b55:	8b 55 18             	mov    0x18(%ebp),%edx
  801b58:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b5c:	52                   	push   %edx
  801b5d:	50                   	push   %eax
  801b5e:	ff 75 10             	pushl  0x10(%ebp)
  801b61:	ff 75 0c             	pushl  0xc(%ebp)
  801b64:	ff 75 08             	pushl  0x8(%ebp)
  801b67:	6a 27                	push   $0x27
  801b69:	e8 17 fb ff ff       	call   801685 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b71:	90                   	nop
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <chktst>:
void chktst(uint32 n)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	ff 75 08             	pushl  0x8(%ebp)
  801b82:	6a 29                	push   $0x29
  801b84:	e8 fc fa ff ff       	call   801685 <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8c:	90                   	nop
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <inctst>:

void inctst()
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 2a                	push   $0x2a
  801b9e:	e8 e2 fa ff ff       	call   801685 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba6:	90                   	nop
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <gettst>:
uint32 gettst()
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 2b                	push   $0x2b
  801bb8:	e8 c8 fa ff ff       	call   801685 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 2c                	push   $0x2c
  801bd4:	e8 ac fa ff ff       	call   801685 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
  801bdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bdf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801be3:	75 07                	jne    801bec <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801be5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bea:	eb 05                	jmp    801bf1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 2c                	push   $0x2c
  801c05:	e8 7b fa ff ff       	call   801685 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
  801c0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c10:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c14:	75 07                	jne    801c1d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c16:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1b:	eb 05                	jmp    801c22 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
  801c27:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 2c                	push   $0x2c
  801c36:	e8 4a fa ff ff       	call   801685 <syscall>
  801c3b:	83 c4 18             	add    $0x18,%esp
  801c3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c41:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c45:	75 07                	jne    801c4e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c47:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4c:	eb 05                	jmp    801c53 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 2c                	push   $0x2c
  801c67:	e8 19 fa ff ff       	call   801685 <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
  801c6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c72:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c76:	75 07                	jne    801c7f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c78:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7d:	eb 05                	jmp    801c84 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	ff 75 08             	pushl  0x8(%ebp)
  801c94:	6a 2d                	push   $0x2d
  801c96:	e8 ea f9 ff ff       	call   801685 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9e:	90                   	nop
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ca5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ca8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cae:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb1:	6a 00                	push   $0x0
  801cb3:	53                   	push   %ebx
  801cb4:	51                   	push   %ecx
  801cb5:	52                   	push   %edx
  801cb6:	50                   	push   %eax
  801cb7:	6a 2e                	push   $0x2e
  801cb9:	e8 c7 f9 ff ff       	call   801685 <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
}
  801cc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	52                   	push   %edx
  801cd6:	50                   	push   %eax
  801cd7:	6a 2f                	push   $0x2f
  801cd9:	e8 a7 f9 ff ff       	call   801685 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ce9:	83 ec 0c             	sub    $0xc,%esp
  801cec:	68 f8 3e 80 00       	push   $0x803ef8
  801cf1:	e8 d3 e8 ff ff       	call   8005c9 <cprintf>
  801cf6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cf9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d00:	83 ec 0c             	sub    $0xc,%esp
  801d03:	68 24 3f 80 00       	push   $0x803f24
  801d08:	e8 bc e8 ff ff       	call   8005c9 <cprintf>
  801d0d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d10:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d14:	a1 38 51 80 00       	mov    0x805138,%eax
  801d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d1c:	eb 56                	jmp    801d74 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d22:	74 1c                	je     801d40 <print_mem_block_lists+0x5d>
  801d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d27:	8b 50 08             	mov    0x8(%eax),%edx
  801d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2d:	8b 48 08             	mov    0x8(%eax),%ecx
  801d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d33:	8b 40 0c             	mov    0xc(%eax),%eax
  801d36:	01 c8                	add    %ecx,%eax
  801d38:	39 c2                	cmp    %eax,%edx
  801d3a:	73 04                	jae    801d40 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d3c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d43:	8b 50 08             	mov    0x8(%eax),%edx
  801d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d49:	8b 40 0c             	mov    0xc(%eax),%eax
  801d4c:	01 c2                	add    %eax,%edx
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	8b 40 08             	mov    0x8(%eax),%eax
  801d54:	83 ec 04             	sub    $0x4,%esp
  801d57:	52                   	push   %edx
  801d58:	50                   	push   %eax
  801d59:	68 39 3f 80 00       	push   $0x803f39
  801d5e:	e8 66 e8 ff ff       	call   8005c9 <cprintf>
  801d63:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d6c:	a1 40 51 80 00       	mov    0x805140,%eax
  801d71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d78:	74 07                	je     801d81 <print_mem_block_lists+0x9e>
  801d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7d:	8b 00                	mov    (%eax),%eax
  801d7f:	eb 05                	jmp    801d86 <print_mem_block_lists+0xa3>
  801d81:	b8 00 00 00 00       	mov    $0x0,%eax
  801d86:	a3 40 51 80 00       	mov    %eax,0x805140
  801d8b:	a1 40 51 80 00       	mov    0x805140,%eax
  801d90:	85 c0                	test   %eax,%eax
  801d92:	75 8a                	jne    801d1e <print_mem_block_lists+0x3b>
  801d94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d98:	75 84                	jne    801d1e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d9a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d9e:	75 10                	jne    801db0 <print_mem_block_lists+0xcd>
  801da0:	83 ec 0c             	sub    $0xc,%esp
  801da3:	68 48 3f 80 00       	push   $0x803f48
  801da8:	e8 1c e8 ff ff       	call   8005c9 <cprintf>
  801dad:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801db0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801db7:	83 ec 0c             	sub    $0xc,%esp
  801dba:	68 6c 3f 80 00       	push   $0x803f6c
  801dbf:	e8 05 e8 ff ff       	call   8005c9 <cprintf>
  801dc4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801dc7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dcb:	a1 40 50 80 00       	mov    0x805040,%eax
  801dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd3:	eb 56                	jmp    801e2b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dd9:	74 1c                	je     801df7 <print_mem_block_lists+0x114>
  801ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dde:	8b 50 08             	mov    0x8(%eax),%edx
  801de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de4:	8b 48 08             	mov    0x8(%eax),%ecx
  801de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dea:	8b 40 0c             	mov    0xc(%eax),%eax
  801ded:	01 c8                	add    %ecx,%eax
  801def:	39 c2                	cmp    %eax,%edx
  801df1:	73 04                	jae    801df7 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801df3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfa:	8b 50 08             	mov    0x8(%eax),%edx
  801dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e00:	8b 40 0c             	mov    0xc(%eax),%eax
  801e03:	01 c2                	add    %eax,%edx
  801e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e08:	8b 40 08             	mov    0x8(%eax),%eax
  801e0b:	83 ec 04             	sub    $0x4,%esp
  801e0e:	52                   	push   %edx
  801e0f:	50                   	push   %eax
  801e10:	68 39 3f 80 00       	push   $0x803f39
  801e15:	e8 af e7 ff ff       	call   8005c9 <cprintf>
  801e1a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e23:	a1 48 50 80 00       	mov    0x805048,%eax
  801e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e2f:	74 07                	je     801e38 <print_mem_block_lists+0x155>
  801e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e34:	8b 00                	mov    (%eax),%eax
  801e36:	eb 05                	jmp    801e3d <print_mem_block_lists+0x15a>
  801e38:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3d:	a3 48 50 80 00       	mov    %eax,0x805048
  801e42:	a1 48 50 80 00       	mov    0x805048,%eax
  801e47:	85 c0                	test   %eax,%eax
  801e49:	75 8a                	jne    801dd5 <print_mem_block_lists+0xf2>
  801e4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e4f:	75 84                	jne    801dd5 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e51:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e55:	75 10                	jne    801e67 <print_mem_block_lists+0x184>
  801e57:	83 ec 0c             	sub    $0xc,%esp
  801e5a:	68 84 3f 80 00       	push   $0x803f84
  801e5f:	e8 65 e7 ff ff       	call   8005c9 <cprintf>
  801e64:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	68 f8 3e 80 00       	push   $0x803ef8
  801e6f:	e8 55 e7 ff ff       	call   8005c9 <cprintf>
  801e74:	83 c4 10             	add    $0x10,%esp

}
  801e77:	90                   	nop
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e80:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e87:	00 00 00 
  801e8a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801e91:	00 00 00 
  801e94:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801e9b:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ea5:	e9 9e 00 00 00       	jmp    801f48 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801eaa:	a1 50 50 80 00       	mov    0x805050,%eax
  801eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb2:	c1 e2 04             	shl    $0x4,%edx
  801eb5:	01 d0                	add    %edx,%eax
  801eb7:	85 c0                	test   %eax,%eax
  801eb9:	75 14                	jne    801ecf <initialize_MemBlocksList+0x55>
  801ebb:	83 ec 04             	sub    $0x4,%esp
  801ebe:	68 ac 3f 80 00       	push   $0x803fac
  801ec3:	6a 46                	push   $0x46
  801ec5:	68 cf 3f 80 00       	push   $0x803fcf
  801eca:	e8 46 e4 ff ff       	call   800315 <_panic>
  801ecf:	a1 50 50 80 00       	mov    0x805050,%eax
  801ed4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed7:	c1 e2 04             	shl    $0x4,%edx
  801eda:	01 d0                	add    %edx,%eax
  801edc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801ee2:	89 10                	mov    %edx,(%eax)
  801ee4:	8b 00                	mov    (%eax),%eax
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	74 18                	je     801f02 <initialize_MemBlocksList+0x88>
  801eea:	a1 48 51 80 00       	mov    0x805148,%eax
  801eef:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801ef5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ef8:	c1 e1 04             	shl    $0x4,%ecx
  801efb:	01 ca                	add    %ecx,%edx
  801efd:	89 50 04             	mov    %edx,0x4(%eax)
  801f00:	eb 12                	jmp    801f14 <initialize_MemBlocksList+0x9a>
  801f02:	a1 50 50 80 00       	mov    0x805050,%eax
  801f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f0a:	c1 e2 04             	shl    $0x4,%edx
  801f0d:	01 d0                	add    %edx,%eax
  801f0f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f14:	a1 50 50 80 00       	mov    0x805050,%eax
  801f19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1c:	c1 e2 04             	shl    $0x4,%edx
  801f1f:	01 d0                	add    %edx,%eax
  801f21:	a3 48 51 80 00       	mov    %eax,0x805148
  801f26:	a1 50 50 80 00       	mov    0x805050,%eax
  801f2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2e:	c1 e2 04             	shl    $0x4,%edx
  801f31:	01 d0                	add    %edx,%eax
  801f33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f3a:	a1 54 51 80 00       	mov    0x805154,%eax
  801f3f:	40                   	inc    %eax
  801f40:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f45:	ff 45 f4             	incl   -0xc(%ebp)
  801f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f4e:	0f 82 56 ff ff ff    	jb     801eaa <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f54:	90                   	nop
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	8b 00                	mov    (%eax),%eax
  801f62:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f65:	eb 19                	jmp    801f80 <find_block+0x29>
	{
		if(va==point->sva)
  801f67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f6a:	8b 40 08             	mov    0x8(%eax),%eax
  801f6d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f70:	75 05                	jne    801f77 <find_block+0x20>
		   return point;
  801f72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f75:	eb 36                	jmp    801fad <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f77:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7a:	8b 40 08             	mov    0x8(%eax),%eax
  801f7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f80:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f84:	74 07                	je     801f8d <find_block+0x36>
  801f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f89:	8b 00                	mov    (%eax),%eax
  801f8b:	eb 05                	jmp    801f92 <find_block+0x3b>
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f92:	8b 55 08             	mov    0x8(%ebp),%edx
  801f95:	89 42 08             	mov    %eax,0x8(%edx)
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	8b 40 08             	mov    0x8(%eax),%eax
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	75 c5                	jne    801f67 <find_block+0x10>
  801fa2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fa6:	75 bf                	jne    801f67 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fa8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fb5:	a1 40 50 80 00       	mov    0x805040,%eax
  801fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fbd:	a1 44 50 80 00       	mov    0x805044,%eax
  801fc2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fcb:	74 24                	je     801ff1 <insert_sorted_allocList+0x42>
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	8b 50 08             	mov    0x8(%eax),%edx
  801fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd6:	8b 40 08             	mov    0x8(%eax),%eax
  801fd9:	39 c2                	cmp    %eax,%edx
  801fdb:	76 14                	jbe    801ff1 <insert_sorted_allocList+0x42>
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	8b 50 08             	mov    0x8(%eax),%edx
  801fe3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe6:	8b 40 08             	mov    0x8(%eax),%eax
  801fe9:	39 c2                	cmp    %eax,%edx
  801feb:	0f 82 60 01 00 00    	jb     802151 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801ff1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ff5:	75 65                	jne    80205c <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801ff7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ffb:	75 14                	jne    802011 <insert_sorted_allocList+0x62>
  801ffd:	83 ec 04             	sub    $0x4,%esp
  802000:	68 ac 3f 80 00       	push   $0x803fac
  802005:	6a 6b                	push   $0x6b
  802007:	68 cf 3f 80 00       	push   $0x803fcf
  80200c:	e8 04 e3 ff ff       	call   800315 <_panic>
  802011:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	89 10                	mov    %edx,(%eax)
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	8b 00                	mov    (%eax),%eax
  802021:	85 c0                	test   %eax,%eax
  802023:	74 0d                	je     802032 <insert_sorted_allocList+0x83>
  802025:	a1 40 50 80 00       	mov    0x805040,%eax
  80202a:	8b 55 08             	mov    0x8(%ebp),%edx
  80202d:	89 50 04             	mov    %edx,0x4(%eax)
  802030:	eb 08                	jmp    80203a <insert_sorted_allocList+0x8b>
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	a3 44 50 80 00       	mov    %eax,0x805044
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	a3 40 50 80 00       	mov    %eax,0x805040
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80204c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802051:	40                   	inc    %eax
  802052:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802057:	e9 dc 01 00 00       	jmp    802238 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	8b 50 08             	mov    0x8(%eax),%edx
  802062:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802065:	8b 40 08             	mov    0x8(%eax),%eax
  802068:	39 c2                	cmp    %eax,%edx
  80206a:	77 6c                	ja     8020d8 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80206c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802070:	74 06                	je     802078 <insert_sorted_allocList+0xc9>
  802072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802076:	75 14                	jne    80208c <insert_sorted_allocList+0xdd>
  802078:	83 ec 04             	sub    $0x4,%esp
  80207b:	68 e8 3f 80 00       	push   $0x803fe8
  802080:	6a 6f                	push   $0x6f
  802082:	68 cf 3f 80 00       	push   $0x803fcf
  802087:	e8 89 e2 ff ff       	call   800315 <_panic>
  80208c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208f:	8b 50 04             	mov    0x4(%eax),%edx
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	89 50 04             	mov    %edx,0x4(%eax)
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80209e:	89 10                	mov    %edx,(%eax)
  8020a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a3:	8b 40 04             	mov    0x4(%eax),%eax
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	74 0d                	je     8020b7 <insert_sorted_allocList+0x108>
  8020aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ad:	8b 40 04             	mov    0x4(%eax),%eax
  8020b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b3:	89 10                	mov    %edx,(%eax)
  8020b5:	eb 08                	jmp    8020bf <insert_sorted_allocList+0x110>
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	a3 40 50 80 00       	mov    %eax,0x805040
  8020bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c5:	89 50 04             	mov    %edx,0x4(%eax)
  8020c8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020cd:	40                   	inc    %eax
  8020ce:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020d3:	e9 60 01 00 00       	jmp    802238 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	8b 50 08             	mov    0x8(%eax),%edx
  8020de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e1:	8b 40 08             	mov    0x8(%eax),%eax
  8020e4:	39 c2                	cmp    %eax,%edx
  8020e6:	0f 82 4c 01 00 00    	jb     802238 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020f0:	75 14                	jne    802106 <insert_sorted_allocList+0x157>
  8020f2:	83 ec 04             	sub    $0x4,%esp
  8020f5:	68 20 40 80 00       	push   $0x804020
  8020fa:	6a 73                	push   $0x73
  8020fc:	68 cf 3f 80 00       	push   $0x803fcf
  802101:	e8 0f e2 ff ff       	call   800315 <_panic>
  802106:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	89 50 04             	mov    %edx,0x4(%eax)
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	8b 40 04             	mov    0x4(%eax),%eax
  802118:	85 c0                	test   %eax,%eax
  80211a:	74 0c                	je     802128 <insert_sorted_allocList+0x179>
  80211c:	a1 44 50 80 00       	mov    0x805044,%eax
  802121:	8b 55 08             	mov    0x8(%ebp),%edx
  802124:	89 10                	mov    %edx,(%eax)
  802126:	eb 08                	jmp    802130 <insert_sorted_allocList+0x181>
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	a3 40 50 80 00       	mov    %eax,0x805040
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	a3 44 50 80 00       	mov    %eax,0x805044
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802141:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802146:	40                   	inc    %eax
  802147:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80214c:	e9 e7 00 00 00       	jmp    802238 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802154:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802157:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80215e:	a1 40 50 80 00       	mov    0x805040,%eax
  802163:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802166:	e9 9d 00 00 00       	jmp    802208 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80216b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216e:	8b 00                	mov    (%eax),%eax
  802170:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	8b 50 08             	mov    0x8(%eax),%edx
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	8b 40 08             	mov    0x8(%eax),%eax
  80217f:	39 c2                	cmp    %eax,%edx
  802181:	76 7d                	jbe    802200 <insert_sorted_allocList+0x251>
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	8b 50 08             	mov    0x8(%eax),%edx
  802189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80218c:	8b 40 08             	mov    0x8(%eax),%eax
  80218f:	39 c2                	cmp    %eax,%edx
  802191:	73 6d                	jae    802200 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802193:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802197:	74 06                	je     80219f <insert_sorted_allocList+0x1f0>
  802199:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80219d:	75 14                	jne    8021b3 <insert_sorted_allocList+0x204>
  80219f:	83 ec 04             	sub    $0x4,%esp
  8021a2:	68 44 40 80 00       	push   $0x804044
  8021a7:	6a 7f                	push   $0x7f
  8021a9:	68 cf 3f 80 00       	push   $0x803fcf
  8021ae:	e8 62 e1 ff ff       	call   800315 <_panic>
  8021b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b6:	8b 10                	mov    (%eax),%edx
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	89 10                	mov    %edx,(%eax)
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	8b 00                	mov    (%eax),%eax
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	74 0b                	je     8021d1 <insert_sorted_allocList+0x222>
  8021c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c9:	8b 00                	mov    (%eax),%eax
  8021cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ce:	89 50 04             	mov    %edx,0x4(%eax)
  8021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d7:	89 10                	mov    %edx,(%eax)
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021df:	89 50 04             	mov    %edx,0x4(%eax)
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	8b 00                	mov    (%eax),%eax
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	75 08                	jne    8021f3 <insert_sorted_allocList+0x244>
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	a3 44 50 80 00       	mov    %eax,0x805044
  8021f3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021f8:	40                   	inc    %eax
  8021f9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8021fe:	eb 39                	jmp    802239 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802200:	a1 48 50 80 00       	mov    0x805048,%eax
  802205:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802208:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220c:	74 07                	je     802215 <insert_sorted_allocList+0x266>
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	8b 00                	mov    (%eax),%eax
  802213:	eb 05                	jmp    80221a <insert_sorted_allocList+0x26b>
  802215:	b8 00 00 00 00       	mov    $0x0,%eax
  80221a:	a3 48 50 80 00       	mov    %eax,0x805048
  80221f:	a1 48 50 80 00       	mov    0x805048,%eax
  802224:	85 c0                	test   %eax,%eax
  802226:	0f 85 3f ff ff ff    	jne    80216b <insert_sorted_allocList+0x1bc>
  80222c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802230:	0f 85 35 ff ff ff    	jne    80216b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802236:	eb 01                	jmp    802239 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802238:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802239:	90                   	nop
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802242:	a1 38 51 80 00       	mov    0x805138,%eax
  802247:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224a:	e9 85 01 00 00       	jmp    8023d4 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80224f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802252:	8b 40 0c             	mov    0xc(%eax),%eax
  802255:	3b 45 08             	cmp    0x8(%ebp),%eax
  802258:	0f 82 6e 01 00 00    	jb     8023cc <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	8b 40 0c             	mov    0xc(%eax),%eax
  802264:	3b 45 08             	cmp    0x8(%ebp),%eax
  802267:	0f 85 8a 00 00 00    	jne    8022f7 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80226d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802271:	75 17                	jne    80228a <alloc_block_FF+0x4e>
  802273:	83 ec 04             	sub    $0x4,%esp
  802276:	68 78 40 80 00       	push   $0x804078
  80227b:	68 93 00 00 00       	push   $0x93
  802280:	68 cf 3f 80 00       	push   $0x803fcf
  802285:	e8 8b e0 ff ff       	call   800315 <_panic>
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 00                	mov    (%eax),%eax
  80228f:	85 c0                	test   %eax,%eax
  802291:	74 10                	je     8022a3 <alloc_block_FF+0x67>
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	8b 00                	mov    (%eax),%eax
  802298:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229b:	8b 52 04             	mov    0x4(%edx),%edx
  80229e:	89 50 04             	mov    %edx,0x4(%eax)
  8022a1:	eb 0b                	jmp    8022ae <alloc_block_FF+0x72>
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 40 04             	mov    0x4(%eax),%eax
  8022a9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	8b 40 04             	mov    0x4(%eax),%eax
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	74 0f                	je     8022c7 <alloc_block_FF+0x8b>
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 40 04             	mov    0x4(%eax),%eax
  8022be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c1:	8b 12                	mov    (%edx),%edx
  8022c3:	89 10                	mov    %edx,(%eax)
  8022c5:	eb 0a                	jmp    8022d1 <alloc_block_FF+0x95>
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 00                	mov    (%eax),%eax
  8022cc:	a3 38 51 80 00       	mov    %eax,0x805138
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e4:	a1 44 51 80 00       	mov    0x805144,%eax
  8022e9:	48                   	dec    %eax
  8022ea:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	e9 10 01 00 00       	jmp    802407 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8022fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802300:	0f 86 c6 00 00 00    	jbe    8023cc <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802306:	a1 48 51 80 00       	mov    0x805148,%eax
  80230b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 50 08             	mov    0x8(%eax),%edx
  802314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802317:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80231a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231d:	8b 55 08             	mov    0x8(%ebp),%edx
  802320:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802323:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802327:	75 17                	jne    802340 <alloc_block_FF+0x104>
  802329:	83 ec 04             	sub    $0x4,%esp
  80232c:	68 78 40 80 00       	push   $0x804078
  802331:	68 9b 00 00 00       	push   $0x9b
  802336:	68 cf 3f 80 00       	push   $0x803fcf
  80233b:	e8 d5 df ff ff       	call   800315 <_panic>
  802340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802343:	8b 00                	mov    (%eax),%eax
  802345:	85 c0                	test   %eax,%eax
  802347:	74 10                	je     802359 <alloc_block_FF+0x11d>
  802349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234c:	8b 00                	mov    (%eax),%eax
  80234e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802351:	8b 52 04             	mov    0x4(%edx),%edx
  802354:	89 50 04             	mov    %edx,0x4(%eax)
  802357:	eb 0b                	jmp    802364 <alloc_block_FF+0x128>
  802359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235c:	8b 40 04             	mov    0x4(%eax),%eax
  80235f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802367:	8b 40 04             	mov    0x4(%eax),%eax
  80236a:	85 c0                	test   %eax,%eax
  80236c:	74 0f                	je     80237d <alloc_block_FF+0x141>
  80236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802371:	8b 40 04             	mov    0x4(%eax),%eax
  802374:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802377:	8b 12                	mov    (%edx),%edx
  802379:	89 10                	mov    %edx,(%eax)
  80237b:	eb 0a                	jmp    802387 <alloc_block_FF+0x14b>
  80237d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802380:	8b 00                	mov    (%eax),%eax
  802382:	a3 48 51 80 00       	mov    %eax,0x805148
  802387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802393:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80239a:	a1 54 51 80 00       	mov    0x805154,%eax
  80239f:	48                   	dec    %eax
  8023a0:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 50 08             	mov    0x8(%eax),%edx
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	01 c2                	add    %eax,%edx
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8023bf:	89 c2                	mov    %eax,%edx
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ca:	eb 3b                	jmp    802407 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023cc:	a1 40 51 80 00       	mov    0x805140,%eax
  8023d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d8:	74 07                	je     8023e1 <alloc_block_FF+0x1a5>
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	eb 05                	jmp    8023e6 <alloc_block_FF+0x1aa>
  8023e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e6:	a3 40 51 80 00       	mov    %eax,0x805140
  8023eb:	a1 40 51 80 00       	mov    0x805140,%eax
  8023f0:	85 c0                	test   %eax,%eax
  8023f2:	0f 85 57 fe ff ff    	jne    80224f <alloc_block_FF+0x13>
  8023f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fc:	0f 85 4d fe ff ff    	jne    80224f <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802407:	c9                   	leave  
  802408:	c3                   	ret    

00802409 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802409:	55                   	push   %ebp
  80240a:	89 e5                	mov    %esp,%ebp
  80240c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80240f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802416:	a1 38 51 80 00       	mov    0x805138,%eax
  80241b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80241e:	e9 df 00 00 00       	jmp    802502 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 40 0c             	mov    0xc(%eax),%eax
  802429:	3b 45 08             	cmp    0x8(%ebp),%eax
  80242c:	0f 82 c8 00 00 00    	jb     8024fa <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 40 0c             	mov    0xc(%eax),%eax
  802438:	3b 45 08             	cmp    0x8(%ebp),%eax
  80243b:	0f 85 8a 00 00 00    	jne    8024cb <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802445:	75 17                	jne    80245e <alloc_block_BF+0x55>
  802447:	83 ec 04             	sub    $0x4,%esp
  80244a:	68 78 40 80 00       	push   $0x804078
  80244f:	68 b7 00 00 00       	push   $0xb7
  802454:	68 cf 3f 80 00       	push   $0x803fcf
  802459:	e8 b7 de ff ff       	call   800315 <_panic>
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 00                	mov    (%eax),%eax
  802463:	85 c0                	test   %eax,%eax
  802465:	74 10                	je     802477 <alloc_block_BF+0x6e>
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246f:	8b 52 04             	mov    0x4(%edx),%edx
  802472:	89 50 04             	mov    %edx,0x4(%eax)
  802475:	eb 0b                	jmp    802482 <alloc_block_BF+0x79>
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 40 04             	mov    0x4(%eax),%eax
  80247d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 40 04             	mov    0x4(%eax),%eax
  802488:	85 c0                	test   %eax,%eax
  80248a:	74 0f                	je     80249b <alloc_block_BF+0x92>
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 40 04             	mov    0x4(%eax),%eax
  802492:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802495:	8b 12                	mov    (%edx),%edx
  802497:	89 10                	mov    %edx,(%eax)
  802499:	eb 0a                	jmp    8024a5 <alloc_block_BF+0x9c>
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	8b 00                	mov    (%eax),%eax
  8024a0:	a3 38 51 80 00       	mov    %eax,0x805138
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b8:	a1 44 51 80 00       	mov    0x805144,%eax
  8024bd:	48                   	dec    %eax
  8024be:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	e9 4d 01 00 00       	jmp    802618 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d4:	76 24                	jbe    8024fa <alloc_block_BF+0xf1>
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024df:	73 19                	jae    8024fa <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024e1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 40 08             	mov    0x8(%eax),%eax
  8024f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8024ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802506:	74 07                	je     80250f <alloc_block_BF+0x106>
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 00                	mov    (%eax),%eax
  80250d:	eb 05                	jmp    802514 <alloc_block_BF+0x10b>
  80250f:	b8 00 00 00 00       	mov    $0x0,%eax
  802514:	a3 40 51 80 00       	mov    %eax,0x805140
  802519:	a1 40 51 80 00       	mov    0x805140,%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	0f 85 fd fe ff ff    	jne    802423 <alloc_block_BF+0x1a>
  802526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252a:	0f 85 f3 fe ff ff    	jne    802423 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802530:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802534:	0f 84 d9 00 00 00    	je     802613 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80253a:	a1 48 51 80 00       	mov    0x805148,%eax
  80253f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802545:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802548:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80254b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254e:	8b 55 08             	mov    0x8(%ebp),%edx
  802551:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802554:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802558:	75 17                	jne    802571 <alloc_block_BF+0x168>
  80255a:	83 ec 04             	sub    $0x4,%esp
  80255d:	68 78 40 80 00       	push   $0x804078
  802562:	68 c7 00 00 00       	push   $0xc7
  802567:	68 cf 3f 80 00       	push   $0x803fcf
  80256c:	e8 a4 dd ff ff       	call   800315 <_panic>
  802571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802574:	8b 00                	mov    (%eax),%eax
  802576:	85 c0                	test   %eax,%eax
  802578:	74 10                	je     80258a <alloc_block_BF+0x181>
  80257a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802582:	8b 52 04             	mov    0x4(%edx),%edx
  802585:	89 50 04             	mov    %edx,0x4(%eax)
  802588:	eb 0b                	jmp    802595 <alloc_block_BF+0x18c>
  80258a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258d:	8b 40 04             	mov    0x4(%eax),%eax
  802590:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802598:	8b 40 04             	mov    0x4(%eax),%eax
  80259b:	85 c0                	test   %eax,%eax
  80259d:	74 0f                	je     8025ae <alloc_block_BF+0x1a5>
  80259f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a2:	8b 40 04             	mov    0x4(%eax),%eax
  8025a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a8:	8b 12                	mov    (%edx),%edx
  8025aa:	89 10                	mov    %edx,(%eax)
  8025ac:	eb 0a                	jmp    8025b8 <alloc_block_BF+0x1af>
  8025ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	a3 48 51 80 00       	mov    %eax,0x805148
  8025b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025cb:	a1 54 51 80 00       	mov    0x805154,%eax
  8025d0:	48                   	dec    %eax
  8025d1:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025d6:	83 ec 08             	sub    $0x8,%esp
  8025d9:	ff 75 ec             	pushl  -0x14(%ebp)
  8025dc:	68 38 51 80 00       	push   $0x805138
  8025e1:	e8 71 f9 ff ff       	call   801f57 <find_block>
  8025e6:	83 c4 10             	add    $0x10,%esp
  8025e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ef:	8b 50 08             	mov    0x8(%eax),%edx
  8025f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f5:	01 c2                	add    %eax,%edx
  8025f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025fa:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802600:	8b 40 0c             	mov    0xc(%eax),%eax
  802603:	2b 45 08             	sub    0x8(%ebp),%eax
  802606:	89 c2                	mov    %eax,%edx
  802608:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80260b:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80260e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802611:	eb 05                	jmp    802618 <alloc_block_BF+0x20f>
	}
	return NULL;
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802620:	a1 28 50 80 00       	mov    0x805028,%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	0f 85 de 01 00 00    	jne    80280b <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80262d:	a1 38 51 80 00       	mov    0x805138,%eax
  802632:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802635:	e9 9e 01 00 00       	jmp    8027d8 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 40 0c             	mov    0xc(%eax),%eax
  802640:	3b 45 08             	cmp    0x8(%ebp),%eax
  802643:	0f 82 87 01 00 00    	jb     8027d0 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 40 0c             	mov    0xc(%eax),%eax
  80264f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802652:	0f 85 95 00 00 00    	jne    8026ed <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265c:	75 17                	jne    802675 <alloc_block_NF+0x5b>
  80265e:	83 ec 04             	sub    $0x4,%esp
  802661:	68 78 40 80 00       	push   $0x804078
  802666:	68 e0 00 00 00       	push   $0xe0
  80266b:	68 cf 3f 80 00       	push   $0x803fcf
  802670:	e8 a0 dc ff ff       	call   800315 <_panic>
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 00                	mov    (%eax),%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	74 10                	je     80268e <alloc_block_NF+0x74>
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 00                	mov    (%eax),%eax
  802683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802686:	8b 52 04             	mov    0x4(%edx),%edx
  802689:	89 50 04             	mov    %edx,0x4(%eax)
  80268c:	eb 0b                	jmp    802699 <alloc_block_NF+0x7f>
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 40 04             	mov    0x4(%eax),%eax
  802694:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 40 04             	mov    0x4(%eax),%eax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	74 0f                	je     8026b2 <alloc_block_NF+0x98>
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 40 04             	mov    0x4(%eax),%eax
  8026a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ac:	8b 12                	mov    (%edx),%edx
  8026ae:	89 10                	mov    %edx,(%eax)
  8026b0:	eb 0a                	jmp    8026bc <alloc_block_NF+0xa2>
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 00                	mov    (%eax),%eax
  8026b7:	a3 38 51 80 00       	mov    %eax,0x805138
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026cf:	a1 44 51 80 00       	mov    0x805144,%eax
  8026d4:	48                   	dec    %eax
  8026d5:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 40 08             	mov    0x8(%eax),%eax
  8026e0:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	e9 f8 04 00 00       	jmp    802be5 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f6:	0f 86 d4 00 00 00    	jbe    8027d0 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026fc:	a1 48 51 80 00       	mov    0x805148,%eax
  802701:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 50 08             	mov    0x8(%eax),%edx
  80270a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270d:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802713:	8b 55 08             	mov    0x8(%ebp),%edx
  802716:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802719:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80271d:	75 17                	jne    802736 <alloc_block_NF+0x11c>
  80271f:	83 ec 04             	sub    $0x4,%esp
  802722:	68 78 40 80 00       	push   $0x804078
  802727:	68 e9 00 00 00       	push   $0xe9
  80272c:	68 cf 3f 80 00       	push   $0x803fcf
  802731:	e8 df db ff ff       	call   800315 <_panic>
  802736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	85 c0                	test   %eax,%eax
  80273d:	74 10                	je     80274f <alloc_block_NF+0x135>
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	8b 00                	mov    (%eax),%eax
  802744:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802747:	8b 52 04             	mov    0x4(%edx),%edx
  80274a:	89 50 04             	mov    %edx,0x4(%eax)
  80274d:	eb 0b                	jmp    80275a <alloc_block_NF+0x140>
  80274f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802752:	8b 40 04             	mov    0x4(%eax),%eax
  802755:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80275a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275d:	8b 40 04             	mov    0x4(%eax),%eax
  802760:	85 c0                	test   %eax,%eax
  802762:	74 0f                	je     802773 <alloc_block_NF+0x159>
  802764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802767:	8b 40 04             	mov    0x4(%eax),%eax
  80276a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80276d:	8b 12                	mov    (%edx),%edx
  80276f:	89 10                	mov    %edx,(%eax)
  802771:	eb 0a                	jmp    80277d <alloc_block_NF+0x163>
  802773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802776:	8b 00                	mov    (%eax),%eax
  802778:	a3 48 51 80 00       	mov    %eax,0x805148
  80277d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802780:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802786:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802789:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802790:	a1 54 51 80 00       	mov    0x805154,%eax
  802795:	48                   	dec    %eax
  802796:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80279b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279e:	8b 40 08             	mov    0x8(%eax),%eax
  8027a1:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 50 08             	mov    0x8(%eax),%edx
  8027ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8027af:	01 c2                	add    %eax,%edx
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bd:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c0:	89 c2                	mov    %eax,%edx
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cb:	e9 15 04 00 00       	jmp    802be5 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8027d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027dc:	74 07                	je     8027e5 <alloc_block_NF+0x1cb>
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	8b 00                	mov    (%eax),%eax
  8027e3:	eb 05                	jmp    8027ea <alloc_block_NF+0x1d0>
  8027e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ea:	a3 40 51 80 00       	mov    %eax,0x805140
  8027ef:	a1 40 51 80 00       	mov    0x805140,%eax
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	0f 85 3e fe ff ff    	jne    80263a <alloc_block_NF+0x20>
  8027fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802800:	0f 85 34 fe ff ff    	jne    80263a <alloc_block_NF+0x20>
  802806:	e9 d5 03 00 00       	jmp    802be0 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80280b:	a1 38 51 80 00       	mov    0x805138,%eax
  802810:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802813:	e9 b1 01 00 00       	jmp    8029c9 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 50 08             	mov    0x8(%eax),%edx
  80281e:	a1 28 50 80 00       	mov    0x805028,%eax
  802823:	39 c2                	cmp    %eax,%edx
  802825:	0f 82 96 01 00 00    	jb     8029c1 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 40 0c             	mov    0xc(%eax),%eax
  802831:	3b 45 08             	cmp    0x8(%ebp),%eax
  802834:	0f 82 87 01 00 00    	jb     8029c1 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	8b 40 0c             	mov    0xc(%eax),%eax
  802840:	3b 45 08             	cmp    0x8(%ebp),%eax
  802843:	0f 85 95 00 00 00    	jne    8028de <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802849:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284d:	75 17                	jne    802866 <alloc_block_NF+0x24c>
  80284f:	83 ec 04             	sub    $0x4,%esp
  802852:	68 78 40 80 00       	push   $0x804078
  802857:	68 fc 00 00 00       	push   $0xfc
  80285c:	68 cf 3f 80 00       	push   $0x803fcf
  802861:	e8 af da ff ff       	call   800315 <_panic>
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	85 c0                	test   %eax,%eax
  80286d:	74 10                	je     80287f <alloc_block_NF+0x265>
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	8b 00                	mov    (%eax),%eax
  802874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802877:	8b 52 04             	mov    0x4(%edx),%edx
  80287a:	89 50 04             	mov    %edx,0x4(%eax)
  80287d:	eb 0b                	jmp    80288a <alloc_block_NF+0x270>
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 04             	mov    0x4(%eax),%eax
  802885:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 40 04             	mov    0x4(%eax),%eax
  802890:	85 c0                	test   %eax,%eax
  802892:	74 0f                	je     8028a3 <alloc_block_NF+0x289>
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 40 04             	mov    0x4(%eax),%eax
  80289a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289d:	8b 12                	mov    (%edx),%edx
  80289f:	89 10                	mov    %edx,(%eax)
  8028a1:	eb 0a                	jmp    8028ad <alloc_block_NF+0x293>
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 00                	mov    (%eax),%eax
  8028a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8028c5:	48                   	dec    %eax
  8028c6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 40 08             	mov    0x8(%eax),%eax
  8028d1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	e9 07 03 00 00       	jmp    802be5 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e7:	0f 86 d4 00 00 00    	jbe    8029c1 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8028f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 50 08             	mov    0x8(%eax),%edx
  8028fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fe:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802901:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802904:	8b 55 08             	mov    0x8(%ebp),%edx
  802907:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80290a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80290e:	75 17                	jne    802927 <alloc_block_NF+0x30d>
  802910:	83 ec 04             	sub    $0x4,%esp
  802913:	68 78 40 80 00       	push   $0x804078
  802918:	68 04 01 00 00       	push   $0x104
  80291d:	68 cf 3f 80 00       	push   $0x803fcf
  802922:	e8 ee d9 ff ff       	call   800315 <_panic>
  802927:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292a:	8b 00                	mov    (%eax),%eax
  80292c:	85 c0                	test   %eax,%eax
  80292e:	74 10                	je     802940 <alloc_block_NF+0x326>
  802930:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802933:	8b 00                	mov    (%eax),%eax
  802935:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802938:	8b 52 04             	mov    0x4(%edx),%edx
  80293b:	89 50 04             	mov    %edx,0x4(%eax)
  80293e:	eb 0b                	jmp    80294b <alloc_block_NF+0x331>
  802940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802943:	8b 40 04             	mov    0x4(%eax),%eax
  802946:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80294b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294e:	8b 40 04             	mov    0x4(%eax),%eax
  802951:	85 c0                	test   %eax,%eax
  802953:	74 0f                	je     802964 <alloc_block_NF+0x34a>
  802955:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802958:	8b 40 04             	mov    0x4(%eax),%eax
  80295b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80295e:	8b 12                	mov    (%edx),%edx
  802960:	89 10                	mov    %edx,(%eax)
  802962:	eb 0a                	jmp    80296e <alloc_block_NF+0x354>
  802964:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802967:	8b 00                	mov    (%eax),%eax
  802969:	a3 48 51 80 00       	mov    %eax,0x805148
  80296e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802971:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802977:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802981:	a1 54 51 80 00       	mov    0x805154,%eax
  802986:	48                   	dec    %eax
  802987:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80298c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298f:	8b 40 08             	mov    0x8(%eax),%eax
  802992:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 50 08             	mov    0x8(%eax),%edx
  80299d:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a0:	01 c2                	add    %eax,%edx
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ae:	2b 45 08             	sub    0x8(%ebp),%eax
  8029b1:	89 c2                	mov    %eax,%edx
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bc:	e9 24 02 00 00       	jmp    802be5 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029c1:	a1 40 51 80 00       	mov    0x805140,%eax
  8029c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cd:	74 07                	je     8029d6 <alloc_block_NF+0x3bc>
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	8b 00                	mov    (%eax),%eax
  8029d4:	eb 05                	jmp    8029db <alloc_block_NF+0x3c1>
  8029d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029db:	a3 40 51 80 00       	mov    %eax,0x805140
  8029e0:	a1 40 51 80 00       	mov    0x805140,%eax
  8029e5:	85 c0                	test   %eax,%eax
  8029e7:	0f 85 2b fe ff ff    	jne    802818 <alloc_block_NF+0x1fe>
  8029ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f1:	0f 85 21 fe ff ff    	jne    802818 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029f7:	a1 38 51 80 00       	mov    0x805138,%eax
  8029fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ff:	e9 ae 01 00 00       	jmp    802bb2 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 50 08             	mov    0x8(%eax),%edx
  802a0a:	a1 28 50 80 00       	mov    0x805028,%eax
  802a0f:	39 c2                	cmp    %eax,%edx
  802a11:	0f 83 93 01 00 00    	jae    802baa <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a20:	0f 82 84 01 00 00    	jb     802baa <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2f:	0f 85 95 00 00 00    	jne    802aca <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a39:	75 17                	jne    802a52 <alloc_block_NF+0x438>
  802a3b:	83 ec 04             	sub    $0x4,%esp
  802a3e:	68 78 40 80 00       	push   $0x804078
  802a43:	68 14 01 00 00       	push   $0x114
  802a48:	68 cf 3f 80 00       	push   $0x803fcf
  802a4d:	e8 c3 d8 ff ff       	call   800315 <_panic>
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	74 10                	je     802a6b <alloc_block_NF+0x451>
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a63:	8b 52 04             	mov    0x4(%edx),%edx
  802a66:	89 50 04             	mov    %edx,0x4(%eax)
  802a69:	eb 0b                	jmp    802a76 <alloc_block_NF+0x45c>
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 40 04             	mov    0x4(%eax),%eax
  802a71:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	8b 40 04             	mov    0x4(%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 0f                	je     802a8f <alloc_block_NF+0x475>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 40 04             	mov    0x4(%eax),%eax
  802a86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a89:	8b 12                	mov    (%edx),%edx
  802a8b:	89 10                	mov    %edx,(%eax)
  802a8d:	eb 0a                	jmp    802a99 <alloc_block_NF+0x47f>
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	a3 38 51 80 00       	mov    %eax,0x805138
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aac:	a1 44 51 80 00       	mov    0x805144,%eax
  802ab1:	48                   	dec    %eax
  802ab2:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 40 08             	mov    0x8(%eax),%eax
  802abd:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	e9 1b 01 00 00       	jmp    802be5 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad3:	0f 86 d1 00 00 00    	jbe    802baa <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ad9:	a1 48 51 80 00       	mov    0x805148,%eax
  802ade:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 50 08             	mov    0x8(%eax),%edx
  802ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aea:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af0:	8b 55 08             	mov    0x8(%ebp),%edx
  802af3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802af6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802afa:	75 17                	jne    802b13 <alloc_block_NF+0x4f9>
  802afc:	83 ec 04             	sub    $0x4,%esp
  802aff:	68 78 40 80 00       	push   $0x804078
  802b04:	68 1c 01 00 00       	push   $0x11c
  802b09:	68 cf 3f 80 00       	push   $0x803fcf
  802b0e:	e8 02 d8 ff ff       	call   800315 <_panic>
  802b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b16:	8b 00                	mov    (%eax),%eax
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	74 10                	je     802b2c <alloc_block_NF+0x512>
  802b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b24:	8b 52 04             	mov    0x4(%edx),%edx
  802b27:	89 50 04             	mov    %edx,0x4(%eax)
  802b2a:	eb 0b                	jmp    802b37 <alloc_block_NF+0x51d>
  802b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2f:	8b 40 04             	mov    0x4(%eax),%eax
  802b32:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3a:	8b 40 04             	mov    0x4(%eax),%eax
  802b3d:	85 c0                	test   %eax,%eax
  802b3f:	74 0f                	je     802b50 <alloc_block_NF+0x536>
  802b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b44:	8b 40 04             	mov    0x4(%eax),%eax
  802b47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b4a:	8b 12                	mov    (%edx),%edx
  802b4c:	89 10                	mov    %edx,(%eax)
  802b4e:	eb 0a                	jmp    802b5a <alloc_block_NF+0x540>
  802b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	a3 48 51 80 00       	mov    %eax,0x805148
  802b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6d:	a1 54 51 80 00       	mov    0x805154,%eax
  802b72:	48                   	dec    %eax
  802b73:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7b:	8b 40 08             	mov    0x8(%eax),%eax
  802b7e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 50 08             	mov    0x8(%eax),%edx
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	01 c2                	add    %eax,%edx
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9a:	2b 45 08             	sub    0x8(%ebp),%eax
  802b9d:	89 c2                	mov    %eax,%edx
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba8:	eb 3b                	jmp    802be5 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802baa:	a1 40 51 80 00       	mov    0x805140,%eax
  802baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb6:	74 07                	je     802bbf <alloc_block_NF+0x5a5>
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 00                	mov    (%eax),%eax
  802bbd:	eb 05                	jmp    802bc4 <alloc_block_NF+0x5aa>
  802bbf:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc4:	a3 40 51 80 00       	mov    %eax,0x805140
  802bc9:	a1 40 51 80 00       	mov    0x805140,%eax
  802bce:	85 c0                	test   %eax,%eax
  802bd0:	0f 85 2e fe ff ff    	jne    802a04 <alloc_block_NF+0x3ea>
  802bd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bda:	0f 85 24 fe ff ff    	jne    802a04 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802be0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be5:	c9                   	leave  
  802be6:	c3                   	ret    

00802be7 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802be7:	55                   	push   %ebp
  802be8:	89 e5                	mov    %esp,%ebp
  802bea:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bed:	a1 38 51 80 00       	mov    0x805138,%eax
  802bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bf5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bfa:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bfd:	a1 38 51 80 00       	mov    0x805138,%eax
  802c02:	85 c0                	test   %eax,%eax
  802c04:	74 14                	je     802c1a <insert_sorted_with_merge_freeList+0x33>
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	8b 50 08             	mov    0x8(%eax),%edx
  802c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0f:	8b 40 08             	mov    0x8(%eax),%eax
  802c12:	39 c2                	cmp    %eax,%edx
  802c14:	0f 87 9b 01 00 00    	ja     802db5 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c1e:	75 17                	jne    802c37 <insert_sorted_with_merge_freeList+0x50>
  802c20:	83 ec 04             	sub    $0x4,%esp
  802c23:	68 ac 3f 80 00       	push   $0x803fac
  802c28:	68 38 01 00 00       	push   $0x138
  802c2d:	68 cf 3f 80 00       	push   $0x803fcf
  802c32:	e8 de d6 ff ff       	call   800315 <_panic>
  802c37:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	89 10                	mov    %edx,(%eax)
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	8b 00                	mov    (%eax),%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	74 0d                	je     802c58 <insert_sorted_with_merge_freeList+0x71>
  802c4b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c50:	8b 55 08             	mov    0x8(%ebp),%edx
  802c53:	89 50 04             	mov    %edx,0x4(%eax)
  802c56:	eb 08                	jmp    802c60 <insert_sorted_with_merge_freeList+0x79>
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	a3 38 51 80 00       	mov    %eax,0x805138
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c72:	a1 44 51 80 00       	mov    0x805144,%eax
  802c77:	40                   	inc    %eax
  802c78:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c81:	0f 84 a8 06 00 00    	je     80332f <insert_sorted_with_merge_freeList+0x748>
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	8b 50 08             	mov    0x8(%eax),%edx
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	8b 40 0c             	mov    0xc(%eax),%eax
  802c93:	01 c2                	add    %eax,%edx
  802c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c98:	8b 40 08             	mov    0x8(%eax),%eax
  802c9b:	39 c2                	cmp    %eax,%edx
  802c9d:	0f 85 8c 06 00 00    	jne    80332f <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cac:	8b 40 0c             	mov    0xc(%eax),%eax
  802caf:	01 c2                	add    %eax,%edx
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cbb:	75 17                	jne    802cd4 <insert_sorted_with_merge_freeList+0xed>
  802cbd:	83 ec 04             	sub    $0x4,%esp
  802cc0:	68 78 40 80 00       	push   $0x804078
  802cc5:	68 3c 01 00 00       	push   $0x13c
  802cca:	68 cf 3f 80 00       	push   $0x803fcf
  802ccf:	e8 41 d6 ff ff       	call   800315 <_panic>
  802cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd7:	8b 00                	mov    (%eax),%eax
  802cd9:	85 c0                	test   %eax,%eax
  802cdb:	74 10                	je     802ced <insert_sorted_with_merge_freeList+0x106>
  802cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce0:	8b 00                	mov    (%eax),%eax
  802ce2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce5:	8b 52 04             	mov    0x4(%edx),%edx
  802ce8:	89 50 04             	mov    %edx,0x4(%eax)
  802ceb:	eb 0b                	jmp    802cf8 <insert_sorted_with_merge_freeList+0x111>
  802ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfb:	8b 40 04             	mov    0x4(%eax),%eax
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	74 0f                	je     802d11 <insert_sorted_with_merge_freeList+0x12a>
  802d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d05:	8b 40 04             	mov    0x4(%eax),%eax
  802d08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0b:	8b 12                	mov    (%edx),%edx
  802d0d:	89 10                	mov    %edx,(%eax)
  802d0f:	eb 0a                	jmp    802d1b <insert_sorted_with_merge_freeList+0x134>
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	a3 38 51 80 00       	mov    %eax,0x805138
  802d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2e:	a1 44 51 80 00       	mov    0x805144,%eax
  802d33:	48                   	dec    %eax
  802d34:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d51:	75 17                	jne    802d6a <insert_sorted_with_merge_freeList+0x183>
  802d53:	83 ec 04             	sub    $0x4,%esp
  802d56:	68 ac 3f 80 00       	push   $0x803fac
  802d5b:	68 3f 01 00 00       	push   $0x13f
  802d60:	68 cf 3f 80 00       	push   $0x803fcf
  802d65:	e8 ab d5 ff ff       	call   800315 <_panic>
  802d6a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d73:	89 10                	mov    %edx,(%eax)
  802d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d78:	8b 00                	mov    (%eax),%eax
  802d7a:	85 c0                	test   %eax,%eax
  802d7c:	74 0d                	je     802d8b <insert_sorted_with_merge_freeList+0x1a4>
  802d7e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d86:	89 50 04             	mov    %edx,0x4(%eax)
  802d89:	eb 08                	jmp    802d93 <insert_sorted_with_merge_freeList+0x1ac>
  802d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d96:	a3 48 51 80 00       	mov    %eax,0x805148
  802d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da5:	a1 54 51 80 00       	mov    0x805154,%eax
  802daa:	40                   	inc    %eax
  802dab:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802db0:	e9 7a 05 00 00       	jmp    80332f <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	8b 50 08             	mov    0x8(%eax),%edx
  802dbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbe:	8b 40 08             	mov    0x8(%eax),%eax
  802dc1:	39 c2                	cmp    %eax,%edx
  802dc3:	0f 82 14 01 00 00    	jb     802edd <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcc:	8b 50 08             	mov    0x8(%eax),%edx
  802dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd5:	01 c2                	add    %eax,%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	8b 40 08             	mov    0x8(%eax),%eax
  802ddd:	39 c2                	cmp    %eax,%edx
  802ddf:	0f 85 90 00 00 00    	jne    802e75 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802de5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de8:	8b 50 0c             	mov    0xc(%eax),%edx
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	8b 40 0c             	mov    0xc(%eax),%eax
  802df1:	01 c2                	add    %eax,%edx
  802df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df6:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e11:	75 17                	jne    802e2a <insert_sorted_with_merge_freeList+0x243>
  802e13:	83 ec 04             	sub    $0x4,%esp
  802e16:	68 ac 3f 80 00       	push   $0x803fac
  802e1b:	68 49 01 00 00       	push   $0x149
  802e20:	68 cf 3f 80 00       	push   $0x803fcf
  802e25:	e8 eb d4 ff ff       	call   800315 <_panic>
  802e2a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	89 10                	mov    %edx,(%eax)
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	85 c0                	test   %eax,%eax
  802e3c:	74 0d                	je     802e4b <insert_sorted_with_merge_freeList+0x264>
  802e3e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e43:	8b 55 08             	mov    0x8(%ebp),%edx
  802e46:	89 50 04             	mov    %edx,0x4(%eax)
  802e49:	eb 08                	jmp    802e53 <insert_sorted_with_merge_freeList+0x26c>
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	a3 48 51 80 00       	mov    %eax,0x805148
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e65:	a1 54 51 80 00       	mov    0x805154,%eax
  802e6a:	40                   	inc    %eax
  802e6b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e70:	e9 bb 04 00 00       	jmp    803330 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e79:	75 17                	jne    802e92 <insert_sorted_with_merge_freeList+0x2ab>
  802e7b:	83 ec 04             	sub    $0x4,%esp
  802e7e:	68 20 40 80 00       	push   $0x804020
  802e83:	68 4c 01 00 00       	push   $0x14c
  802e88:	68 cf 3f 80 00       	push   $0x803fcf
  802e8d:	e8 83 d4 ff ff       	call   800315 <_panic>
  802e92:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	89 50 04             	mov    %edx,0x4(%eax)
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	8b 40 04             	mov    0x4(%eax),%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	74 0c                	je     802eb4 <insert_sorted_with_merge_freeList+0x2cd>
  802ea8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ead:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb0:	89 10                	mov    %edx,(%eax)
  802eb2:	eb 08                	jmp    802ebc <insert_sorted_with_merge_freeList+0x2d5>
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	a3 38 51 80 00       	mov    %eax,0x805138
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecd:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed2:	40                   	inc    %eax
  802ed3:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ed8:	e9 53 04 00 00       	jmp    803330 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802edd:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee5:	e9 15 04 00 00       	jmp    8032ff <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	8b 50 08             	mov    0x8(%eax),%edx
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 40 08             	mov    0x8(%eax),%eax
  802efe:	39 c2                	cmp    %eax,%edx
  802f00:	0f 86 f1 03 00 00    	jbe    8032f7 <insert_sorted_with_merge_freeList+0x710>
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	8b 50 08             	mov    0x8(%eax),%edx
  802f0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0f:	8b 40 08             	mov    0x8(%eax),%eax
  802f12:	39 c2                	cmp    %eax,%edx
  802f14:	0f 83 dd 03 00 00    	jae    8032f7 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	8b 50 08             	mov    0x8(%eax),%edx
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	8b 40 0c             	mov    0xc(%eax),%eax
  802f26:	01 c2                	add    %eax,%edx
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	8b 40 08             	mov    0x8(%eax),%eax
  802f2e:	39 c2                	cmp    %eax,%edx
  802f30:	0f 85 b9 01 00 00    	jne    8030ef <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	8b 50 08             	mov    0x8(%eax),%edx
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f42:	01 c2                	add    %eax,%edx
  802f44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f47:	8b 40 08             	mov    0x8(%eax),%eax
  802f4a:	39 c2                	cmp    %eax,%edx
  802f4c:	0f 85 0d 01 00 00    	jne    80305f <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	8b 50 0c             	mov    0xc(%eax),%edx
  802f58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5e:	01 c2                	add    %eax,%edx
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f66:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f6a:	75 17                	jne    802f83 <insert_sorted_with_merge_freeList+0x39c>
  802f6c:	83 ec 04             	sub    $0x4,%esp
  802f6f:	68 78 40 80 00       	push   $0x804078
  802f74:	68 5c 01 00 00       	push   $0x15c
  802f79:	68 cf 3f 80 00       	push   $0x803fcf
  802f7e:	e8 92 d3 ff ff       	call   800315 <_panic>
  802f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f86:	8b 00                	mov    (%eax),%eax
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	74 10                	je     802f9c <insert_sorted_with_merge_freeList+0x3b5>
  802f8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8f:	8b 00                	mov    (%eax),%eax
  802f91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f94:	8b 52 04             	mov    0x4(%edx),%edx
  802f97:	89 50 04             	mov    %edx,0x4(%eax)
  802f9a:	eb 0b                	jmp    802fa7 <insert_sorted_with_merge_freeList+0x3c0>
  802f9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9f:	8b 40 04             	mov    0x4(%eax),%eax
  802fa2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faa:	8b 40 04             	mov    0x4(%eax),%eax
  802fad:	85 c0                	test   %eax,%eax
  802faf:	74 0f                	je     802fc0 <insert_sorted_with_merge_freeList+0x3d9>
  802fb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb4:	8b 40 04             	mov    0x4(%eax),%eax
  802fb7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fba:	8b 12                	mov    (%edx),%edx
  802fbc:	89 10                	mov    %edx,(%eax)
  802fbe:	eb 0a                	jmp    802fca <insert_sorted_with_merge_freeList+0x3e3>
  802fc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc3:	8b 00                	mov    (%eax),%eax
  802fc5:	a3 38 51 80 00       	mov    %eax,0x805138
  802fca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fdd:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe2:	48                   	dec    %eax
  802fe3:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802fe8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802feb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802ffc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803000:	75 17                	jne    803019 <insert_sorted_with_merge_freeList+0x432>
  803002:	83 ec 04             	sub    $0x4,%esp
  803005:	68 ac 3f 80 00       	push   $0x803fac
  80300a:	68 5f 01 00 00       	push   $0x15f
  80300f:	68 cf 3f 80 00       	push   $0x803fcf
  803014:	e8 fc d2 ff ff       	call   800315 <_panic>
  803019:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80301f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803022:	89 10                	mov    %edx,(%eax)
  803024:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803027:	8b 00                	mov    (%eax),%eax
  803029:	85 c0                	test   %eax,%eax
  80302b:	74 0d                	je     80303a <insert_sorted_with_merge_freeList+0x453>
  80302d:	a1 48 51 80 00       	mov    0x805148,%eax
  803032:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803035:	89 50 04             	mov    %edx,0x4(%eax)
  803038:	eb 08                	jmp    803042 <insert_sorted_with_merge_freeList+0x45b>
  80303a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803042:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803045:	a3 48 51 80 00       	mov    %eax,0x805148
  80304a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803054:	a1 54 51 80 00       	mov    0x805154,%eax
  803059:	40                   	inc    %eax
  80305a:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	8b 50 0c             	mov    0xc(%eax),%edx
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	8b 40 0c             	mov    0xc(%eax),%eax
  80306b:	01 c2                	add    %eax,%edx
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803073:	8b 45 08             	mov    0x8(%ebp),%eax
  803076:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803087:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80308b:	75 17                	jne    8030a4 <insert_sorted_with_merge_freeList+0x4bd>
  80308d:	83 ec 04             	sub    $0x4,%esp
  803090:	68 ac 3f 80 00       	push   $0x803fac
  803095:	68 64 01 00 00       	push   $0x164
  80309a:	68 cf 3f 80 00       	push   $0x803fcf
  80309f:	e8 71 d2 ff ff       	call   800315 <_panic>
  8030a4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	89 10                	mov    %edx,(%eax)
  8030af:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b2:	8b 00                	mov    (%eax),%eax
  8030b4:	85 c0                	test   %eax,%eax
  8030b6:	74 0d                	je     8030c5 <insert_sorted_with_merge_freeList+0x4de>
  8030b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8030bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c0:	89 50 04             	mov    %edx,0x4(%eax)
  8030c3:	eb 08                	jmp    8030cd <insert_sorted_with_merge_freeList+0x4e6>
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030df:	a1 54 51 80 00       	mov    0x805154,%eax
  8030e4:	40                   	inc    %eax
  8030e5:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8030ea:	e9 41 02 00 00       	jmp    803330 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	8b 50 08             	mov    0x8(%eax),%edx
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fb:	01 c2                	add    %eax,%edx
  8030fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803100:	8b 40 08             	mov    0x8(%eax),%eax
  803103:	39 c2                	cmp    %eax,%edx
  803105:	0f 85 7c 01 00 00    	jne    803287 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80310b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80310f:	74 06                	je     803117 <insert_sorted_with_merge_freeList+0x530>
  803111:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803115:	75 17                	jne    80312e <insert_sorted_with_merge_freeList+0x547>
  803117:	83 ec 04             	sub    $0x4,%esp
  80311a:	68 e8 3f 80 00       	push   $0x803fe8
  80311f:	68 69 01 00 00       	push   $0x169
  803124:	68 cf 3f 80 00       	push   $0x803fcf
  803129:	e8 e7 d1 ff ff       	call   800315 <_panic>
  80312e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803131:	8b 50 04             	mov    0x4(%eax),%edx
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	89 50 04             	mov    %edx,0x4(%eax)
  80313a:	8b 45 08             	mov    0x8(%ebp),%eax
  80313d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803140:	89 10                	mov    %edx,(%eax)
  803142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803145:	8b 40 04             	mov    0x4(%eax),%eax
  803148:	85 c0                	test   %eax,%eax
  80314a:	74 0d                	je     803159 <insert_sorted_with_merge_freeList+0x572>
  80314c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314f:	8b 40 04             	mov    0x4(%eax),%eax
  803152:	8b 55 08             	mov    0x8(%ebp),%edx
  803155:	89 10                	mov    %edx,(%eax)
  803157:	eb 08                	jmp    803161 <insert_sorted_with_merge_freeList+0x57a>
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	a3 38 51 80 00       	mov    %eax,0x805138
  803161:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803164:	8b 55 08             	mov    0x8(%ebp),%edx
  803167:	89 50 04             	mov    %edx,0x4(%eax)
  80316a:	a1 44 51 80 00       	mov    0x805144,%eax
  80316f:	40                   	inc    %eax
  803170:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	8b 50 0c             	mov    0xc(%eax),%edx
  80317b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317e:	8b 40 0c             	mov    0xc(%eax),%eax
  803181:	01 c2                	add    %eax,%edx
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803189:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80318d:	75 17                	jne    8031a6 <insert_sorted_with_merge_freeList+0x5bf>
  80318f:	83 ec 04             	sub    $0x4,%esp
  803192:	68 78 40 80 00       	push   $0x804078
  803197:	68 6b 01 00 00       	push   $0x16b
  80319c:	68 cf 3f 80 00       	push   $0x803fcf
  8031a1:	e8 6f d1 ff ff       	call   800315 <_panic>
  8031a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	85 c0                	test   %eax,%eax
  8031ad:	74 10                	je     8031bf <insert_sorted_with_merge_freeList+0x5d8>
  8031af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b2:	8b 00                	mov    (%eax),%eax
  8031b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b7:	8b 52 04             	mov    0x4(%edx),%edx
  8031ba:	89 50 04             	mov    %edx,0x4(%eax)
  8031bd:	eb 0b                	jmp    8031ca <insert_sorted_with_merge_freeList+0x5e3>
  8031bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c2:	8b 40 04             	mov    0x4(%eax),%eax
  8031c5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cd:	8b 40 04             	mov    0x4(%eax),%eax
  8031d0:	85 c0                	test   %eax,%eax
  8031d2:	74 0f                	je     8031e3 <insert_sorted_with_merge_freeList+0x5fc>
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	8b 40 04             	mov    0x4(%eax),%eax
  8031da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031dd:	8b 12                	mov    (%edx),%edx
  8031df:	89 10                	mov    %edx,(%eax)
  8031e1:	eb 0a                	jmp    8031ed <insert_sorted_with_merge_freeList+0x606>
  8031e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803200:	a1 44 51 80 00       	mov    0x805144,%eax
  803205:	48                   	dec    %eax
  803206:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80320b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803218:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80321f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803223:	75 17                	jne    80323c <insert_sorted_with_merge_freeList+0x655>
  803225:	83 ec 04             	sub    $0x4,%esp
  803228:	68 ac 3f 80 00       	push   $0x803fac
  80322d:	68 6e 01 00 00       	push   $0x16e
  803232:	68 cf 3f 80 00       	push   $0x803fcf
  803237:	e8 d9 d0 ff ff       	call   800315 <_panic>
  80323c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803242:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803245:	89 10                	mov    %edx,(%eax)
  803247:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324a:	8b 00                	mov    (%eax),%eax
  80324c:	85 c0                	test   %eax,%eax
  80324e:	74 0d                	je     80325d <insert_sorted_with_merge_freeList+0x676>
  803250:	a1 48 51 80 00       	mov    0x805148,%eax
  803255:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803258:	89 50 04             	mov    %edx,0x4(%eax)
  80325b:	eb 08                	jmp    803265 <insert_sorted_with_merge_freeList+0x67e>
  80325d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803260:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803265:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803268:	a3 48 51 80 00       	mov    %eax,0x805148
  80326d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803270:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803277:	a1 54 51 80 00       	mov    0x805154,%eax
  80327c:	40                   	inc    %eax
  80327d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803282:	e9 a9 00 00 00       	jmp    803330 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803287:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328b:	74 06                	je     803293 <insert_sorted_with_merge_freeList+0x6ac>
  80328d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803291:	75 17                	jne    8032aa <insert_sorted_with_merge_freeList+0x6c3>
  803293:	83 ec 04             	sub    $0x4,%esp
  803296:	68 44 40 80 00       	push   $0x804044
  80329b:	68 73 01 00 00       	push   $0x173
  8032a0:	68 cf 3f 80 00       	push   $0x803fcf
  8032a5:	e8 6b d0 ff ff       	call   800315 <_panic>
  8032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ad:	8b 10                	mov    (%eax),%edx
  8032af:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b2:	89 10                	mov    %edx,(%eax)
  8032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	85 c0                	test   %eax,%eax
  8032bb:	74 0b                	je     8032c8 <insert_sorted_with_merge_freeList+0x6e1>
  8032bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c5:	89 50 04             	mov    %edx,0x4(%eax)
  8032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ce:	89 10                	mov    %edx,(%eax)
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d6:	89 50 04             	mov    %edx,0x4(%eax)
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	8b 00                	mov    (%eax),%eax
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	75 08                	jne    8032ea <insert_sorted_with_merge_freeList+0x703>
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ef:	40                   	inc    %eax
  8032f0:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8032f5:	eb 39                	jmp    803330 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8032fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803303:	74 07                	je     80330c <insert_sorted_with_merge_freeList+0x725>
  803305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803308:	8b 00                	mov    (%eax),%eax
  80330a:	eb 05                	jmp    803311 <insert_sorted_with_merge_freeList+0x72a>
  80330c:	b8 00 00 00 00       	mov    $0x0,%eax
  803311:	a3 40 51 80 00       	mov    %eax,0x805140
  803316:	a1 40 51 80 00       	mov    0x805140,%eax
  80331b:	85 c0                	test   %eax,%eax
  80331d:	0f 85 c7 fb ff ff    	jne    802eea <insert_sorted_with_merge_freeList+0x303>
  803323:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803327:	0f 85 bd fb ff ff    	jne    802eea <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80332d:	eb 01                	jmp    803330 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80332f:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803330:	90                   	nop
  803331:	c9                   	leave  
  803332:	c3                   	ret    
  803333:	90                   	nop

00803334 <__udivdi3>:
  803334:	55                   	push   %ebp
  803335:	57                   	push   %edi
  803336:	56                   	push   %esi
  803337:	53                   	push   %ebx
  803338:	83 ec 1c             	sub    $0x1c,%esp
  80333b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80333f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803343:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803347:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80334b:	89 ca                	mov    %ecx,%edx
  80334d:	89 f8                	mov    %edi,%eax
  80334f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803353:	85 f6                	test   %esi,%esi
  803355:	75 2d                	jne    803384 <__udivdi3+0x50>
  803357:	39 cf                	cmp    %ecx,%edi
  803359:	77 65                	ja     8033c0 <__udivdi3+0x8c>
  80335b:	89 fd                	mov    %edi,%ebp
  80335d:	85 ff                	test   %edi,%edi
  80335f:	75 0b                	jne    80336c <__udivdi3+0x38>
  803361:	b8 01 00 00 00       	mov    $0x1,%eax
  803366:	31 d2                	xor    %edx,%edx
  803368:	f7 f7                	div    %edi
  80336a:	89 c5                	mov    %eax,%ebp
  80336c:	31 d2                	xor    %edx,%edx
  80336e:	89 c8                	mov    %ecx,%eax
  803370:	f7 f5                	div    %ebp
  803372:	89 c1                	mov    %eax,%ecx
  803374:	89 d8                	mov    %ebx,%eax
  803376:	f7 f5                	div    %ebp
  803378:	89 cf                	mov    %ecx,%edi
  80337a:	89 fa                	mov    %edi,%edx
  80337c:	83 c4 1c             	add    $0x1c,%esp
  80337f:	5b                   	pop    %ebx
  803380:	5e                   	pop    %esi
  803381:	5f                   	pop    %edi
  803382:	5d                   	pop    %ebp
  803383:	c3                   	ret    
  803384:	39 ce                	cmp    %ecx,%esi
  803386:	77 28                	ja     8033b0 <__udivdi3+0x7c>
  803388:	0f bd fe             	bsr    %esi,%edi
  80338b:	83 f7 1f             	xor    $0x1f,%edi
  80338e:	75 40                	jne    8033d0 <__udivdi3+0x9c>
  803390:	39 ce                	cmp    %ecx,%esi
  803392:	72 0a                	jb     80339e <__udivdi3+0x6a>
  803394:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803398:	0f 87 9e 00 00 00    	ja     80343c <__udivdi3+0x108>
  80339e:	b8 01 00 00 00       	mov    $0x1,%eax
  8033a3:	89 fa                	mov    %edi,%edx
  8033a5:	83 c4 1c             	add    $0x1c,%esp
  8033a8:	5b                   	pop    %ebx
  8033a9:	5e                   	pop    %esi
  8033aa:	5f                   	pop    %edi
  8033ab:	5d                   	pop    %ebp
  8033ac:	c3                   	ret    
  8033ad:	8d 76 00             	lea    0x0(%esi),%esi
  8033b0:	31 ff                	xor    %edi,%edi
  8033b2:	31 c0                	xor    %eax,%eax
  8033b4:	89 fa                	mov    %edi,%edx
  8033b6:	83 c4 1c             	add    $0x1c,%esp
  8033b9:	5b                   	pop    %ebx
  8033ba:	5e                   	pop    %esi
  8033bb:	5f                   	pop    %edi
  8033bc:	5d                   	pop    %ebp
  8033bd:	c3                   	ret    
  8033be:	66 90                	xchg   %ax,%ax
  8033c0:	89 d8                	mov    %ebx,%eax
  8033c2:	f7 f7                	div    %edi
  8033c4:	31 ff                	xor    %edi,%edi
  8033c6:	89 fa                	mov    %edi,%edx
  8033c8:	83 c4 1c             	add    $0x1c,%esp
  8033cb:	5b                   	pop    %ebx
  8033cc:	5e                   	pop    %esi
  8033cd:	5f                   	pop    %edi
  8033ce:	5d                   	pop    %ebp
  8033cf:	c3                   	ret    
  8033d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033d5:	89 eb                	mov    %ebp,%ebx
  8033d7:	29 fb                	sub    %edi,%ebx
  8033d9:	89 f9                	mov    %edi,%ecx
  8033db:	d3 e6                	shl    %cl,%esi
  8033dd:	89 c5                	mov    %eax,%ebp
  8033df:	88 d9                	mov    %bl,%cl
  8033e1:	d3 ed                	shr    %cl,%ebp
  8033e3:	89 e9                	mov    %ebp,%ecx
  8033e5:	09 f1                	or     %esi,%ecx
  8033e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033eb:	89 f9                	mov    %edi,%ecx
  8033ed:	d3 e0                	shl    %cl,%eax
  8033ef:	89 c5                	mov    %eax,%ebp
  8033f1:	89 d6                	mov    %edx,%esi
  8033f3:	88 d9                	mov    %bl,%cl
  8033f5:	d3 ee                	shr    %cl,%esi
  8033f7:	89 f9                	mov    %edi,%ecx
  8033f9:	d3 e2                	shl    %cl,%edx
  8033fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033ff:	88 d9                	mov    %bl,%cl
  803401:	d3 e8                	shr    %cl,%eax
  803403:	09 c2                	or     %eax,%edx
  803405:	89 d0                	mov    %edx,%eax
  803407:	89 f2                	mov    %esi,%edx
  803409:	f7 74 24 0c          	divl   0xc(%esp)
  80340d:	89 d6                	mov    %edx,%esi
  80340f:	89 c3                	mov    %eax,%ebx
  803411:	f7 e5                	mul    %ebp
  803413:	39 d6                	cmp    %edx,%esi
  803415:	72 19                	jb     803430 <__udivdi3+0xfc>
  803417:	74 0b                	je     803424 <__udivdi3+0xf0>
  803419:	89 d8                	mov    %ebx,%eax
  80341b:	31 ff                	xor    %edi,%edi
  80341d:	e9 58 ff ff ff       	jmp    80337a <__udivdi3+0x46>
  803422:	66 90                	xchg   %ax,%ax
  803424:	8b 54 24 08          	mov    0x8(%esp),%edx
  803428:	89 f9                	mov    %edi,%ecx
  80342a:	d3 e2                	shl    %cl,%edx
  80342c:	39 c2                	cmp    %eax,%edx
  80342e:	73 e9                	jae    803419 <__udivdi3+0xe5>
  803430:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803433:	31 ff                	xor    %edi,%edi
  803435:	e9 40 ff ff ff       	jmp    80337a <__udivdi3+0x46>
  80343a:	66 90                	xchg   %ax,%ax
  80343c:	31 c0                	xor    %eax,%eax
  80343e:	e9 37 ff ff ff       	jmp    80337a <__udivdi3+0x46>
  803443:	90                   	nop

00803444 <__umoddi3>:
  803444:	55                   	push   %ebp
  803445:	57                   	push   %edi
  803446:	56                   	push   %esi
  803447:	53                   	push   %ebx
  803448:	83 ec 1c             	sub    $0x1c,%esp
  80344b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80344f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803453:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803457:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80345b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80345f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803463:	89 f3                	mov    %esi,%ebx
  803465:	89 fa                	mov    %edi,%edx
  803467:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80346b:	89 34 24             	mov    %esi,(%esp)
  80346e:	85 c0                	test   %eax,%eax
  803470:	75 1a                	jne    80348c <__umoddi3+0x48>
  803472:	39 f7                	cmp    %esi,%edi
  803474:	0f 86 a2 00 00 00    	jbe    80351c <__umoddi3+0xd8>
  80347a:	89 c8                	mov    %ecx,%eax
  80347c:	89 f2                	mov    %esi,%edx
  80347e:	f7 f7                	div    %edi
  803480:	89 d0                	mov    %edx,%eax
  803482:	31 d2                	xor    %edx,%edx
  803484:	83 c4 1c             	add    $0x1c,%esp
  803487:	5b                   	pop    %ebx
  803488:	5e                   	pop    %esi
  803489:	5f                   	pop    %edi
  80348a:	5d                   	pop    %ebp
  80348b:	c3                   	ret    
  80348c:	39 f0                	cmp    %esi,%eax
  80348e:	0f 87 ac 00 00 00    	ja     803540 <__umoddi3+0xfc>
  803494:	0f bd e8             	bsr    %eax,%ebp
  803497:	83 f5 1f             	xor    $0x1f,%ebp
  80349a:	0f 84 ac 00 00 00    	je     80354c <__umoddi3+0x108>
  8034a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8034a5:	29 ef                	sub    %ebp,%edi
  8034a7:	89 fe                	mov    %edi,%esi
  8034a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034ad:	89 e9                	mov    %ebp,%ecx
  8034af:	d3 e0                	shl    %cl,%eax
  8034b1:	89 d7                	mov    %edx,%edi
  8034b3:	89 f1                	mov    %esi,%ecx
  8034b5:	d3 ef                	shr    %cl,%edi
  8034b7:	09 c7                	or     %eax,%edi
  8034b9:	89 e9                	mov    %ebp,%ecx
  8034bb:	d3 e2                	shl    %cl,%edx
  8034bd:	89 14 24             	mov    %edx,(%esp)
  8034c0:	89 d8                	mov    %ebx,%eax
  8034c2:	d3 e0                	shl    %cl,%eax
  8034c4:	89 c2                	mov    %eax,%edx
  8034c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ca:	d3 e0                	shl    %cl,%eax
  8034cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034d4:	89 f1                	mov    %esi,%ecx
  8034d6:	d3 e8                	shr    %cl,%eax
  8034d8:	09 d0                	or     %edx,%eax
  8034da:	d3 eb                	shr    %cl,%ebx
  8034dc:	89 da                	mov    %ebx,%edx
  8034de:	f7 f7                	div    %edi
  8034e0:	89 d3                	mov    %edx,%ebx
  8034e2:	f7 24 24             	mull   (%esp)
  8034e5:	89 c6                	mov    %eax,%esi
  8034e7:	89 d1                	mov    %edx,%ecx
  8034e9:	39 d3                	cmp    %edx,%ebx
  8034eb:	0f 82 87 00 00 00    	jb     803578 <__umoddi3+0x134>
  8034f1:	0f 84 91 00 00 00    	je     803588 <__umoddi3+0x144>
  8034f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034fb:	29 f2                	sub    %esi,%edx
  8034fd:	19 cb                	sbb    %ecx,%ebx
  8034ff:	89 d8                	mov    %ebx,%eax
  803501:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803505:	d3 e0                	shl    %cl,%eax
  803507:	89 e9                	mov    %ebp,%ecx
  803509:	d3 ea                	shr    %cl,%edx
  80350b:	09 d0                	or     %edx,%eax
  80350d:	89 e9                	mov    %ebp,%ecx
  80350f:	d3 eb                	shr    %cl,%ebx
  803511:	89 da                	mov    %ebx,%edx
  803513:	83 c4 1c             	add    $0x1c,%esp
  803516:	5b                   	pop    %ebx
  803517:	5e                   	pop    %esi
  803518:	5f                   	pop    %edi
  803519:	5d                   	pop    %ebp
  80351a:	c3                   	ret    
  80351b:	90                   	nop
  80351c:	89 fd                	mov    %edi,%ebp
  80351e:	85 ff                	test   %edi,%edi
  803520:	75 0b                	jne    80352d <__umoddi3+0xe9>
  803522:	b8 01 00 00 00       	mov    $0x1,%eax
  803527:	31 d2                	xor    %edx,%edx
  803529:	f7 f7                	div    %edi
  80352b:	89 c5                	mov    %eax,%ebp
  80352d:	89 f0                	mov    %esi,%eax
  80352f:	31 d2                	xor    %edx,%edx
  803531:	f7 f5                	div    %ebp
  803533:	89 c8                	mov    %ecx,%eax
  803535:	f7 f5                	div    %ebp
  803537:	89 d0                	mov    %edx,%eax
  803539:	e9 44 ff ff ff       	jmp    803482 <__umoddi3+0x3e>
  80353e:	66 90                	xchg   %ax,%ax
  803540:	89 c8                	mov    %ecx,%eax
  803542:	89 f2                	mov    %esi,%edx
  803544:	83 c4 1c             	add    $0x1c,%esp
  803547:	5b                   	pop    %ebx
  803548:	5e                   	pop    %esi
  803549:	5f                   	pop    %edi
  80354a:	5d                   	pop    %ebp
  80354b:	c3                   	ret    
  80354c:	3b 04 24             	cmp    (%esp),%eax
  80354f:	72 06                	jb     803557 <__umoddi3+0x113>
  803551:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803555:	77 0f                	ja     803566 <__umoddi3+0x122>
  803557:	89 f2                	mov    %esi,%edx
  803559:	29 f9                	sub    %edi,%ecx
  80355b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80355f:	89 14 24             	mov    %edx,(%esp)
  803562:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803566:	8b 44 24 04          	mov    0x4(%esp),%eax
  80356a:	8b 14 24             	mov    (%esp),%edx
  80356d:	83 c4 1c             	add    $0x1c,%esp
  803570:	5b                   	pop    %ebx
  803571:	5e                   	pop    %esi
  803572:	5f                   	pop    %edi
  803573:	5d                   	pop    %ebp
  803574:	c3                   	ret    
  803575:	8d 76 00             	lea    0x0(%esi),%esi
  803578:	2b 04 24             	sub    (%esp),%eax
  80357b:	19 fa                	sbb    %edi,%edx
  80357d:	89 d1                	mov    %edx,%ecx
  80357f:	89 c6                	mov    %eax,%esi
  803581:	e9 71 ff ff ff       	jmp    8034f7 <__umoddi3+0xb3>
  803586:	66 90                	xchg   %ax,%ax
  803588:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80358c:	72 ea                	jb     803578 <__umoddi3+0x134>
  80358e:	89 d9                	mov    %ebx,%ecx
  803590:	e9 62 ff ff ff       	jmp    8034f7 <__umoddi3+0xb3>
