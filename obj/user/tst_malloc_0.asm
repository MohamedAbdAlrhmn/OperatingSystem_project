
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
  80008c:	68 a0 37 80 00       	push   $0x8037a0
  800091:	6a 14                	push   $0x14
  800093:	68 bc 37 80 00       	push   $0x8037bc
  800098:	e8 78 02 00 00       	call   800315 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	if(STATIC_MEMBLOCK_ALLOC != 0)
		panic("STATIC_MEMBLOCK_ALLOC = 1 & it shall be 0. Go to 'inc/dynamic_allocator.h' and set STATIC_MEMBLOCK_ALLOC by 0. Then, repeat the test again.");

	int freeFrames_before = sys_calculate_free_frames() ;
  80009d:	e8 cc 18 00 00       	call   80196e <sys_calculate_free_frames>
  8000a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeDiskFrames_before = sys_pf_calculate_allocated_pages() ;
  8000a5:	e8 64 19 00 00       	call   801a0e <sys_pf_calculate_allocated_pages>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	malloc(0);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	e8 9a 14 00 00       	call   801551 <malloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
	int freeFrames_after = sys_calculate_free_frames() ;
  8000ba:	e8 af 18 00 00       	call   80196e <sys_calculate_free_frames>
  8000bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freeDiskFrames_after = sys_pf_calculate_allocated_pages() ;
  8000c2:	e8 47 19 00 00       	call   801a0e <sys_pf_calculate_allocated_pages>
  8000c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Check MAX_MEM_BLOCK_CNT
	if(MAX_MEM_BLOCK_CNT != ((0xA0000000-0x80000000)/4096))
  8000ca:	a1 20 51 80 00       	mov    0x805120,%eax
  8000cf:	3d 00 00 02 00       	cmp    $0x20000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
	{
		panic("Wrong initialize: MAX_MEM_BLOCK_CNT is not set with the correct size of the array");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 d0 37 80 00       	push   $0x8037d0
  8000de:	6a 23                	push   $0x23
  8000e0:	68 bc 37 80 00       	push   $0x8037bc
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
  8000fd:	68 24 38 80 00       	push   $0x803824
  800102:	6a 29                	push   $0x29
  800104:	68 bc 37 80 00       	push   $0x8037bc
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
  80011a:	68 60 38 80 00       	push   $0x803860
  80011f:	6a 2f                	push   $0x2f
  800121:	68 bc 37 80 00       	push   $0x8037bc
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
  800138:	68 98 38 80 00       	push   $0x803898
  80013d:	6a 35                	push   $0x35
  80013f:	68 bc 37 80 00       	push   $0x8037bc
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
  800174:	68 d0 38 80 00       	push   $0x8038d0
  800179:	6a 3c                	push   $0x3c
  80017b:	68 bc 37 80 00       	push   $0x8037bc
  800180:	e8 90 01 00 00       	call   800315 <_panic>
	}

	//Check number of disk and memory frames
	if ((freeDiskFrames_after - freeDiskFrames_before) != 0) panic("Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)");
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80018b:	74 14                	je     8001a1 <_main+0x169>
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 0c 39 80 00       	push   $0x80390c
  800195:	6a 40                	push   $0x40
  800197:	68 bc 37 80 00       	push   $0x8037bc
  80019c:	e8 74 01 00 00       	call   800315 <_panic>
	if ((freeFrames_before - freeFrames_after) != 512 + 1) panic("Wrong allocation: pages are not loaded successfully into memory %d", (freeFrames_before - freeFrames_after));
  8001a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a7:	3d 01 02 00 00       	cmp    $0x201,%eax
  8001ac:	74 18                	je     8001c6 <_main+0x18e>
  8001ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	68 74 39 80 00       	push   $0x803974
  8001ba:	6a 41                	push   $0x41
  8001bc:	68 bc 37 80 00       	push   $0x8037bc
  8001c1:	e8 4f 01 00 00       	call   800315 <_panic>

	/*=================================================*/

	cprintf("Congratulations!! test initialize_dyn_block_system of UHEAP completed successfully.\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 b8 39 80 00       	push   $0x8039b8
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
  8001df:	e8 6a 1a 00 00       	call   801c4e <sys_getenvindex>
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
  80024a:	e8 0c 18 00 00       	call   801a5b <sys_disable_interrupt>
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 28 3a 80 00       	push   $0x803a28
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
  80027a:	68 50 3a 80 00       	push   $0x803a50
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
  8002ab:	68 78 3a 80 00       	push   $0x803a78
  8002b0:	e8 14 03 00 00       	call   8005c9 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 d0 3a 80 00       	push   $0x803ad0
  8002cc:	e8 f8 02 00 00       	call   8005c9 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	68 28 3a 80 00       	push   $0x803a28
  8002dc:	e8 e8 02 00 00       	call   8005c9 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002e4:	e8 8c 17 00 00       	call   801a75 <sys_enable_interrupt>

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
  8002fc:	e8 19 19 00 00       	call   801c1a <sys_destroy_env>
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
  80030d:	e8 6e 19 00 00       	call   801c80 <sys_exit_env>
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
  800336:	68 e4 3a 80 00       	push   $0x803ae4
  80033b:	e8 89 02 00 00       	call   8005c9 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800343:	a1 00 50 80 00       	mov    0x805000,%eax
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 e9 3a 80 00       	push   $0x803ae9
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
  800373:	68 05 3b 80 00       	push   $0x803b05
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
  80039f:	68 08 3b 80 00       	push   $0x803b08
  8003a4:	6a 26                	push   $0x26
  8003a6:	68 54 3b 80 00       	push   $0x803b54
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
  800471:	68 60 3b 80 00       	push   $0x803b60
  800476:	6a 3a                	push   $0x3a
  800478:	68 54 3b 80 00       	push   $0x803b54
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
  8004e1:	68 b4 3b 80 00       	push   $0x803bb4
  8004e6:	6a 44                	push   $0x44
  8004e8:	68 54 3b 80 00       	push   $0x803b54
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
  80053b:	e8 6d 13 00 00       	call   8018ad <sys_cputs>
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
  8005b2:	e8 f6 12 00 00       	call   8018ad <sys_cputs>
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
  8005fc:	e8 5a 14 00 00       	call   801a5b <sys_disable_interrupt>
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
  80061c:	e8 54 14 00 00       	call   801a75 <sys_enable_interrupt>
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
  800666:	e8 c5 2e 00 00       	call   803530 <__udivdi3>
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
  8006b6:	e8 85 2f 00 00       	call   803640 <__umoddi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	05 14 3e 80 00       	add    $0x803e14,%eax
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
  800811:	8b 04 85 38 3e 80 00 	mov    0x803e38(,%eax,4),%eax
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
  8008f2:	8b 34 9d 80 3c 80 00 	mov    0x803c80(,%ebx,4),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 19                	jne    800916 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	53                   	push   %ebx
  8008fe:	68 25 3e 80 00       	push   $0x803e25
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
  800917:	68 2e 3e 80 00       	push   $0x803e2e
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
  800944:	be 31 3e 80 00       	mov    $0x803e31,%esi
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
  80136a:	68 90 3f 80 00       	push   $0x803f90
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
  80143a:	e8 b2 05 00 00       	call   8019f1 <sys_allocate_chunk>
  80143f:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801442:	a1 20 51 80 00       	mov    0x805120,%eax
  801447:	83 ec 0c             	sub    $0xc,%esp
  80144a:	50                   	push   %eax
  80144b:	e8 27 0c 00 00       	call   802077 <initialize_MemBlocksList>
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
  801478:	68 b5 3f 80 00       	push   $0x803fb5
  80147d:	6a 33                	push   $0x33
  80147f:	68 d3 3f 80 00       	push   $0x803fd3
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
  8014f7:	68 e0 3f 80 00       	push   $0x803fe0
  8014fc:	6a 34                	push   $0x34
  8014fe:	68 d3 3f 80 00       	push   $0x803fd3
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
  801554:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801557:	e8 f7 fd ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  80155c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801560:	75 07                	jne    801569 <malloc+0x18>
  801562:	b8 00 00 00 00       	mov    $0x0,%eax
  801567:	eb 61                	jmp    8015ca <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801569:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801570:	8b 55 08             	mov    0x8(%ebp),%edx
  801573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	48                   	dec    %eax
  801579:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80157c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157f:	ba 00 00 00 00       	mov    $0x0,%edx
  801584:	f7 75 f0             	divl   -0x10(%ebp)
  801587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158a:	29 d0                	sub    %edx,%eax
  80158c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80158f:	e8 2b 08 00 00       	call   801dbf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801594:	85 c0                	test   %eax,%eax
  801596:	74 11                	je     8015a9 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801598:	83 ec 0c             	sub    $0xc,%esp
  80159b:	ff 75 e8             	pushl  -0x18(%ebp)
  80159e:	e8 96 0e 00 00       	call   802439 <alloc_block_FF>
  8015a3:	83 c4 10             	add    $0x10,%esp
  8015a6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  8015a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015ad:	74 16                	je     8015c5 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  8015af:	83 ec 0c             	sub    $0xc,%esp
  8015b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b5:	e8 f2 0b 00 00       	call   8021ac <insert_sorted_allocList>
  8015ba:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  8015bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c0:	8b 40 08             	mov    0x8(%eax),%eax
  8015c3:	eb 05                	jmp    8015ca <malloc+0x79>
	}

    return NULL;
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	83 ec 08             	sub    $0x8,%esp
  8015d8:	50                   	push   %eax
  8015d9:	68 40 50 80 00       	push   $0x805040
  8015de:	e8 71 0b 00 00       	call   802154 <find_block>
  8015e3:	83 c4 10             	add    $0x10,%esp
  8015e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8015e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015ed:	0f 84 a6 00 00 00    	je     801699 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8015f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f6:	8b 50 0c             	mov    0xc(%eax),%edx
  8015f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fc:	8b 40 08             	mov    0x8(%eax),%eax
  8015ff:	83 ec 08             	sub    $0x8,%esp
  801602:	52                   	push   %edx
  801603:	50                   	push   %eax
  801604:	e8 b0 03 00 00       	call   8019b9 <sys_free_user_mem>
  801609:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  80160c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801610:	75 14                	jne    801626 <free+0x5a>
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	68 b5 3f 80 00       	push   $0x803fb5
  80161a:	6a 74                	push   $0x74
  80161c:	68 d3 3f 80 00       	push   $0x803fd3
  801621:	e8 ef ec ff ff       	call   800315 <_panic>
  801626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801629:	8b 00                	mov    (%eax),%eax
  80162b:	85 c0                	test   %eax,%eax
  80162d:	74 10                	je     80163f <free+0x73>
  80162f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801632:	8b 00                	mov    (%eax),%eax
  801634:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801637:	8b 52 04             	mov    0x4(%edx),%edx
  80163a:	89 50 04             	mov    %edx,0x4(%eax)
  80163d:	eb 0b                	jmp    80164a <free+0x7e>
  80163f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801642:	8b 40 04             	mov    0x4(%eax),%eax
  801645:	a3 44 50 80 00       	mov    %eax,0x805044
  80164a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164d:	8b 40 04             	mov    0x4(%eax),%eax
  801650:	85 c0                	test   %eax,%eax
  801652:	74 0f                	je     801663 <free+0x97>
  801654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801657:	8b 40 04             	mov    0x4(%eax),%eax
  80165a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165d:	8b 12                	mov    (%edx),%edx
  80165f:	89 10                	mov    %edx,(%eax)
  801661:	eb 0a                	jmp    80166d <free+0xa1>
  801663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801666:	8b 00                	mov    (%eax),%eax
  801668:	a3 40 50 80 00       	mov    %eax,0x805040
  80166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801679:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801680:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801685:	48                   	dec    %eax
  801686:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  80168b:	83 ec 0c             	sub    $0xc,%esp
  80168e:	ff 75 f4             	pushl  -0xc(%ebp)
  801691:	e8 4e 17 00 00       	call   802de4 <insert_sorted_with_merge_freeList>
  801696:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	83 ec 08             	sub    $0x8,%esp
  8015d8:	50                   	push   %eax
  8015d9:	68 40 50 80 00       	push   $0x805040
  8015de:	e8 71 0b 00 00       	call   802154 <find_block>
  8015e3:	83 c4 10             	add    $0x10,%esp
  8015e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  8015e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015ed:	0f 84 a6 00 00 00    	je     801699 <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  8015f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f6:	8b 50 0c             	mov    0xc(%eax),%edx
  8015f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fc:	8b 40 08             	mov    0x8(%eax),%eax
  8015ff:	83 ec 08             	sub    $0x8,%esp
  801602:	52                   	push   %edx
  801603:	50                   	push   %eax
  801604:	e8 b0 03 00 00       	call   8019b9 <sys_free_user_mem>
  801609:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  80160c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801610:	75 14                	jne    801626 <free+0x5a>
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	68 b5 3f 80 00       	push   $0x803fb5
  80161a:	6a 7a                	push   $0x7a
  80161c:	68 d3 3f 80 00       	push   $0x803fd3
  801621:	e8 ef ec ff ff       	call   800315 <_panic>
  801626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801629:	8b 00                	mov    (%eax),%eax
  80162b:	85 c0                	test   %eax,%eax
  80162d:	74 10                	je     80163f <free+0x73>
  80162f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801632:	8b 00                	mov    (%eax),%eax
  801634:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801637:	8b 52 04             	mov    0x4(%edx),%edx
  80163a:	89 50 04             	mov    %edx,0x4(%eax)
  80163d:	eb 0b                	jmp    80164a <free+0x7e>
  80163f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801642:	8b 40 04             	mov    0x4(%eax),%eax
  801645:	a3 44 50 80 00       	mov    %eax,0x805044
  80164a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164d:	8b 40 04             	mov    0x4(%eax),%eax
  801650:	85 c0                	test   %eax,%eax
  801652:	74 0f                	je     801663 <free+0x97>
  801654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801657:	8b 40 04             	mov    0x4(%eax),%eax
  80165a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165d:	8b 12                	mov    (%edx),%edx
  80165f:	89 10                	mov    %edx,(%eax)
  801661:	eb 0a                	jmp    80166d <free+0xa1>
  801663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801666:	8b 00                	mov    (%eax),%eax
  801668:	a3 40 50 80 00       	mov    %eax,0x805040
  80166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801679:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801680:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801685:	48                   	dec    %eax
  801686:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  80168b:	83 ec 0c             	sub    $0xc,%esp
  80168e:	ff 75 f4             	pushl  -0xc(%ebp)
  801691:	e8 4e 17 00 00       	call   802de4 <insert_sorted_with_merge_freeList>
  801696:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  801699:	90                   	nop
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	83 ec 38             	sub    $0x38,%esp
  8016a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a5:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a8:	e8 a6 fc ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b1:	75 0a                	jne    8016bd <smalloc+0x21>
  8016b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b8:	e9 8b 00 00 00       	jmp    801748 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016bd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ca:	01 d0                	add    %edx,%eax
  8016cc:	48                   	dec    %eax
  8016cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d8:	f7 75 f0             	divl   -0x10(%ebp)
  8016db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016de:	29 d0                	sub    %edx,%eax
  8016e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8016e3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ea:	e8 d0 06 00 00       	call   801dbf <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	74 11                	je     801704 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8016f3:	83 ec 0c             	sub    $0xc,%esp
  8016f6:	ff 75 e8             	pushl  -0x18(%ebp)
  8016f9:	e8 3b 0d 00 00       	call   802439 <alloc_block_FF>
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801704:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801708:	74 39                	je     801743 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80170a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170d:	8b 40 08             	mov    0x8(%eax),%eax
  801710:	89 c2                	mov    %eax,%edx
  801712:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801716:	52                   	push   %edx
  801717:	50                   	push   %eax
  801718:	ff 75 0c             	pushl  0xc(%ebp)
  80171b:	ff 75 08             	pushl  0x8(%ebp)
  80171e:	e8 21 04 00 00       	call   801b44 <sys_createSharedObject>
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801729:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80172d:	74 14                	je     801743 <smalloc+0xa7>
  80172f:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801733:	74 0e                	je     801743 <smalloc+0xa7>
  801735:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801739:	74 08                	je     801743 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80173b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173e:	8b 40 08             	mov    0x8(%eax),%eax
  801741:	eb 05                	jmp    801748 <smalloc+0xac>
	}
	return NULL;
  801743:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801750:	e8 fe fb ff ff       	call   801353 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801755:	83 ec 08             	sub    $0x8,%esp
  801758:	ff 75 0c             	pushl  0xc(%ebp)
  80175b:	ff 75 08             	pushl  0x8(%ebp)
  80175e:	e8 0b 04 00 00       	call   801b6e <sys_getSizeOfSharedObject>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801769:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80176d:	74 76                	je     8017e5 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80176f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801776:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80177c:	01 d0                	add    %edx,%eax
  80177e:	48                   	dec    %eax
  80177f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801782:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801785:	ba 00 00 00 00       	mov    $0x0,%edx
  80178a:	f7 75 ec             	divl   -0x14(%ebp)
  80178d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801790:	29 d0                	sub    %edx,%eax
  801792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801795:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80179c:	e8 1e 06 00 00       	call   801dbf <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	74 11                	je     8017b6 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8017a5:	83 ec 0c             	sub    $0xc,%esp
  8017a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017ab:	e8 89 0c 00 00       	call   802439 <alloc_block_FF>
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8017b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017ba:	74 29                	je     8017e5 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8017bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bf:	8b 40 08             	mov    0x8(%eax),%eax
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	50                   	push   %eax
  8017c6:	ff 75 0c             	pushl  0xc(%ebp)
  8017c9:	ff 75 08             	pushl  0x8(%ebp)
  8017cc:	e8 ba 03 00 00       	call   801b8b <sys_getSharedObject>
  8017d1:	83 c4 10             	add    $0x10,%esp
  8017d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8017d7:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8017db:	74 08                	je     8017e5 <sget+0x9b>
				return (void *)mem_block->sva;
  8017dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e0:	8b 40 08             	mov    0x8(%eax),%eax
  8017e3:	eb 05                	jmp    8017ea <sget+0xa0>
		}
	}
	return NULL;
  8017e5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017f2:	e8 5c fb ff ff       	call   801353 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017f7:	83 ec 04             	sub    $0x4,%esp
  8017fa:	68 04 40 80 00       	push   $0x804004
<<<<<<< HEAD
  8017ff:	68 fc 00 00 00       	push   $0xfc
=======
  8017ff:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801804:	68 d3 3f 80 00       	push   $0x803fd3
  801809:	e8 07 eb ff ff       	call   800315 <_panic>

0080180e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	68 2c 40 80 00       	push   $0x80402c
<<<<<<< HEAD
  80181c:	68 10 01 00 00       	push   $0x110
=======
  80181c:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801821:	68 d3 3f 80 00       	push   $0x803fd3
  801826:	e8 ea ea ff ff       	call   800315 <_panic>

0080182b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801831:	83 ec 04             	sub    $0x4,%esp
  801834:	68 50 40 80 00       	push   $0x804050
<<<<<<< HEAD
  801839:	68 1b 01 00 00       	push   $0x11b
=======
  801839:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  80183e:	68 d3 3f 80 00       	push   $0x803fd3
  801843:	e8 cd ea ff ff       	call   800315 <_panic>

00801848 <shrink>:

}
void shrink(uint32 newSize)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80184e:	83 ec 04             	sub    $0x4,%esp
  801851:	68 50 40 80 00       	push   $0x804050
<<<<<<< HEAD
  801856:	68 20 01 00 00       	push   $0x120
=======
  801856:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  80185b:	68 d3 3f 80 00       	push   $0x803fd3
  801860:	e8 b0 ea ff ff       	call   800315 <_panic>

00801865 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80186b:	83 ec 04             	sub    $0x4,%esp
  80186e:	68 50 40 80 00       	push   $0x804050
<<<<<<< HEAD
  801873:	68 25 01 00 00       	push   $0x125
=======
  801873:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801878:	68 d3 3f 80 00       	push   $0x803fd3
  80187d:	e8 93 ea ff ff       	call   800315 <_panic>

00801882 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	57                   	push   %edi
  801886:	56                   	push   %esi
  801887:	53                   	push   %ebx
  801888:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801891:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801894:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801897:	8b 7d 18             	mov    0x18(%ebp),%edi
  80189a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80189d:	cd 30                	int    $0x30
  80189f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018a5:	83 c4 10             	add    $0x10,%esp
  8018a8:	5b                   	pop    %ebx
  8018a9:	5e                   	pop    %esi
  8018aa:	5f                   	pop    %edi
  8018ab:	5d                   	pop    %ebp
  8018ac:	c3                   	ret    

008018ad <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018b9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	52                   	push   %edx
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	50                   	push   %eax
  8018c9:	6a 00                	push   $0x0
  8018cb:	e8 b2 ff ff ff       	call   801882 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	90                   	nop
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 01                	push   $0x1
  8018e5:	e8 98 ff ff ff       	call   801882 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	52                   	push   %edx
  8018ff:	50                   	push   %eax
  801900:	6a 05                	push   $0x5
  801902:	e8 7b ff ff ff       	call   801882 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	56                   	push   %esi
  801910:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801911:	8b 75 18             	mov    0x18(%ebp),%esi
  801914:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801917:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	56                   	push   %esi
  801921:	53                   	push   %ebx
  801922:	51                   	push   %ecx
  801923:	52                   	push   %edx
  801924:	50                   	push   %eax
  801925:	6a 06                	push   $0x6
  801927:	e8 56 ff ff ff       	call   801882 <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801932:	5b                   	pop    %ebx
  801933:	5e                   	pop    %esi
  801934:	5d                   	pop    %ebp
  801935:	c3                   	ret    

00801936 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	52                   	push   %edx
  801946:	50                   	push   %eax
  801947:	6a 07                	push   $0x7
  801949:	e8 34 ff ff ff       	call   801882 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	ff 75 08             	pushl  0x8(%ebp)
  801962:	6a 08                	push   $0x8
  801964:	e8 19 ff ff ff       	call   801882 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 09                	push   $0x9
  80197d:	e8 00 ff ff ff       	call   801882 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 0a                	push   $0xa
  801996:	e8 e7 fe ff ff       	call   801882 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 0b                	push   $0xb
  8019af:	e8 ce fe ff ff       	call   801882 <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	ff 75 08             	pushl  0x8(%ebp)
  8019c8:	6a 0f                	push   $0xf
  8019ca:	e8 b3 fe ff ff       	call   801882 <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
	return;
  8019d2:	90                   	nop
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	6a 10                	push   $0x10
  8019e6:	e8 97 fe ff ff       	call   801882 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ee:	90                   	nop
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	ff 75 10             	pushl  0x10(%ebp)
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	ff 75 08             	pushl  0x8(%ebp)
  801a01:	6a 11                	push   $0x11
  801a03:	e8 7a fe ff ff       	call   801882 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0b:	90                   	nop
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 0c                	push   $0xc
  801a1d:	e8 60 fe ff ff       	call   801882 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	ff 75 08             	pushl  0x8(%ebp)
  801a35:	6a 0d                	push   $0xd
  801a37:	e8 46 fe ff ff       	call   801882 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 0e                	push   $0xe
  801a50:	e8 2d fe ff ff       	call   801882 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	90                   	nop
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 13                	push   $0x13
  801a6a:	e8 13 fe ff ff       	call   801882 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	90                   	nop
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 14                	push   $0x14
  801a84:	e8 f9 fd ff ff       	call   801882 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	90                   	nop
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_cputc>:


void
sys_cputc(const char c)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	83 ec 04             	sub    $0x4,%esp
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a9b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	50                   	push   %eax
  801aa8:	6a 15                	push   $0x15
  801aaa:	e8 d3 fd ff ff       	call   801882 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	90                   	nop
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 16                	push   $0x16
  801ac4:	e8 b9 fd ff ff       	call   801882 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	90                   	nop
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	50                   	push   %eax
  801adf:	6a 17                	push   $0x17
  801ae1:	e8 9c fd ff ff       	call   801882 <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	52                   	push   %edx
  801afb:	50                   	push   %eax
  801afc:	6a 1a                	push   $0x1a
  801afe:	e8 7f fd ff ff       	call   801882 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	52                   	push   %edx
  801b18:	50                   	push   %eax
  801b19:	6a 18                	push   $0x18
  801b1b:	e8 62 fd ff ff       	call   801882 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	90                   	nop
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	52                   	push   %edx
  801b36:	50                   	push   %eax
  801b37:	6a 19                	push   $0x19
  801b39:	e8 44 fd ff ff       	call   801882 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	90                   	nop
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b50:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b53:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	51                   	push   %ecx
  801b5d:	52                   	push   %edx
  801b5e:	ff 75 0c             	pushl  0xc(%ebp)
  801b61:	50                   	push   %eax
  801b62:	6a 1b                	push   $0x1b
  801b64:	e8 19 fd ff ff       	call   801882 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	52                   	push   %edx
  801b7e:	50                   	push   %eax
  801b7f:	6a 1c                	push   $0x1c
  801b81:	e8 fc fc ff ff       	call   801882 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	51                   	push   %ecx
  801b9c:	52                   	push   %edx
  801b9d:	50                   	push   %eax
  801b9e:	6a 1d                	push   $0x1d
  801ba0:	e8 dd fc ff ff       	call   801882 <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	52                   	push   %edx
  801bba:	50                   	push   %eax
  801bbb:	6a 1e                	push   $0x1e
  801bbd:	e8 c0 fc ff ff       	call   801882 <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 1f                	push   $0x1f
  801bd6:	e8 a7 fc ff ff       	call   801882 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	6a 00                	push   $0x0
  801be8:	ff 75 14             	pushl  0x14(%ebp)
  801beb:	ff 75 10             	pushl  0x10(%ebp)
  801bee:	ff 75 0c             	pushl  0xc(%ebp)
  801bf1:	50                   	push   %eax
  801bf2:	6a 20                	push   $0x20
  801bf4:	e8 89 fc ff ff       	call   801882 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	50                   	push   %eax
  801c0d:	6a 21                	push   $0x21
  801c0f:	e8 6e fc ff ff       	call   801882 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	90                   	nop
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	50                   	push   %eax
  801c29:	6a 22                	push   $0x22
  801c2b:	e8 52 fc ff ff       	call   801882 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 02                	push   $0x2
  801c44:	e8 39 fc ff ff       	call   801882 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 03                	push   $0x3
  801c5d:	e8 20 fc ff ff       	call   801882 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 04                	push   $0x4
  801c76:	e8 07 fc ff ff       	call   801882 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_exit_env>:


void sys_exit_env(void)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 23                	push   $0x23
  801c8f:	e8 ee fb ff ff       	call   801882 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
}
  801c97:	90                   	nop
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ca0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca3:	8d 50 04             	lea    0x4(%eax),%edx
  801ca6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	52                   	push   %edx
  801cb0:	50                   	push   %eax
  801cb1:	6a 24                	push   $0x24
  801cb3:	e8 ca fb ff ff       	call   801882 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
	return result;
  801cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cc4:	89 01                	mov    %eax,(%ecx)
  801cc6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	c9                   	leave  
  801ccd:	c2 04 00             	ret    $0x4

00801cd0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	ff 75 10             	pushl  0x10(%ebp)
  801cda:	ff 75 0c             	pushl  0xc(%ebp)
  801cdd:	ff 75 08             	pushl  0x8(%ebp)
  801ce0:	6a 12                	push   $0x12
  801ce2:	e8 9b fb ff ff       	call   801882 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cea:	90                   	nop
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_rcr2>:
uint32 sys_rcr2()
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 25                	push   $0x25
  801cfc:	e8 81 fb ff ff       	call   801882 <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 04             	sub    $0x4,%esp
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d12:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	50                   	push   %eax
  801d1f:	6a 26                	push   $0x26
  801d21:	e8 5c fb ff ff       	call   801882 <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
	return ;
  801d29:	90                   	nop
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <rsttst>:
void rsttst()
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 28                	push   $0x28
  801d3b:	e8 42 fb ff ff       	call   801882 <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
	return ;
  801d43:	90                   	nop
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 04             	sub    $0x4,%esp
  801d4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d52:	8b 55 18             	mov    0x18(%ebp),%edx
  801d55:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d59:	52                   	push   %edx
  801d5a:	50                   	push   %eax
  801d5b:	ff 75 10             	pushl  0x10(%ebp)
  801d5e:	ff 75 0c             	pushl  0xc(%ebp)
  801d61:	ff 75 08             	pushl  0x8(%ebp)
  801d64:	6a 27                	push   $0x27
  801d66:	e8 17 fb ff ff       	call   801882 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6e:	90                   	nop
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <chktst>:
void chktst(uint32 n)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	ff 75 08             	pushl  0x8(%ebp)
  801d7f:	6a 29                	push   $0x29
  801d81:	e8 fc fa ff ff       	call   801882 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
	return ;
  801d89:	90                   	nop
}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <inctst>:

void inctst()
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 2a                	push   $0x2a
  801d9b:	e8 e2 fa ff ff       	call   801882 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
	return ;
  801da3:	90                   	nop
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <gettst>:
uint32 gettst()
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 2b                	push   $0x2b
  801db5:	e8 c8 fa ff ff       	call   801882 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 2c                	push   $0x2c
  801dd1:	e8 ac fa ff ff       	call   801882 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
  801dd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ddc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801de0:	75 07                	jne    801de9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801de2:	b8 01 00 00 00       	mov    $0x1,%eax
  801de7:	eb 05                	jmp    801dee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 2c                	push   $0x2c
  801e02:	e8 7b fa ff ff       	call   801882 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
  801e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e0d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e11:	75 07                	jne    801e1a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e13:	b8 01 00 00 00       	mov    $0x1,%eax
  801e18:	eb 05                	jmp    801e1f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 2c                	push   $0x2c
  801e33:	e8 4a fa ff ff       	call   801882 <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
  801e3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e3e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e42:	75 07                	jne    801e4b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e44:	b8 01 00 00 00       	mov    $0x1,%eax
  801e49:	eb 05                	jmp    801e50 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 2c                	push   $0x2c
  801e64:	e8 19 fa ff ff       	call   801882 <syscall>
  801e69:	83 c4 18             	add    $0x18,%esp
  801e6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e6f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e73:	75 07                	jne    801e7c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e75:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7a:	eb 05                	jmp    801e81 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	ff 75 08             	pushl  0x8(%ebp)
  801e91:	6a 2d                	push   $0x2d
  801e93:	e8 ea f9 ff ff       	call   801882 <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9b:	90                   	nop
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ea2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ea8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	6a 00                	push   $0x0
  801eb0:	53                   	push   %ebx
  801eb1:	51                   	push   %ecx
  801eb2:	52                   	push   %edx
  801eb3:	50                   	push   %eax
  801eb4:	6a 2e                	push   $0x2e
  801eb6:	e8 c7 f9 ff ff       	call   801882 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ec6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	52                   	push   %edx
  801ed3:	50                   	push   %eax
  801ed4:	6a 2f                	push   $0x2f
  801ed6:	e8 a7 f9 ff ff       	call   801882 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ee6:	83 ec 0c             	sub    $0xc,%esp
  801ee9:	68 60 40 80 00       	push   $0x804060
  801eee:	e8 d6 e6 ff ff       	call   8005c9 <cprintf>
  801ef3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ef6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	68 8c 40 80 00       	push   $0x80408c
  801f05:	e8 bf e6 ff ff       	call   8005c9 <cprintf>
  801f0a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f0d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f11:	a1 38 51 80 00       	mov    0x805138,%eax
  801f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f19:	eb 56                	jmp    801f71 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f1f:	74 1c                	je     801f3d <print_mem_block_lists+0x5d>
  801f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f24:	8b 50 08             	mov    0x8(%eax),%edx
  801f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f30:	8b 40 0c             	mov    0xc(%eax),%eax
  801f33:	01 c8                	add    %ecx,%eax
  801f35:	39 c2                	cmp    %eax,%edx
  801f37:	73 04                	jae    801f3d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f39:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f40:	8b 50 08             	mov    0x8(%eax),%edx
  801f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f46:	8b 40 0c             	mov    0xc(%eax),%eax
  801f49:	01 c2                	add    %eax,%edx
  801f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4e:	8b 40 08             	mov    0x8(%eax),%eax
  801f51:	83 ec 04             	sub    $0x4,%esp
  801f54:	52                   	push   %edx
  801f55:	50                   	push   %eax
  801f56:	68 a1 40 80 00       	push   $0x8040a1
  801f5b:	e8 69 e6 ff ff       	call   8005c9 <cprintf>
  801f60:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f66:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f69:	a1 40 51 80 00       	mov    0x805140,%eax
  801f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f75:	74 07                	je     801f7e <print_mem_block_lists+0x9e>
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	8b 00                	mov    (%eax),%eax
  801f7c:	eb 05                	jmp    801f83 <print_mem_block_lists+0xa3>
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f83:	a3 40 51 80 00       	mov    %eax,0x805140
  801f88:	a1 40 51 80 00       	mov    0x805140,%eax
  801f8d:	85 c0                	test   %eax,%eax
  801f8f:	75 8a                	jne    801f1b <print_mem_block_lists+0x3b>
  801f91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f95:	75 84                	jne    801f1b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f97:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f9b:	75 10                	jne    801fad <print_mem_block_lists+0xcd>
  801f9d:	83 ec 0c             	sub    $0xc,%esp
  801fa0:	68 b0 40 80 00       	push   $0x8040b0
  801fa5:	e8 1f e6 ff ff       	call   8005c9 <cprintf>
  801faa:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fb4:	83 ec 0c             	sub    $0xc,%esp
  801fb7:	68 d4 40 80 00       	push   $0x8040d4
  801fbc:	e8 08 e6 ff ff       	call   8005c9 <cprintf>
  801fc1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fc4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fc8:	a1 40 50 80 00       	mov    0x805040,%eax
  801fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd0:	eb 56                	jmp    802028 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fd6:	74 1c                	je     801ff4 <print_mem_block_lists+0x114>
  801fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdb:	8b 50 08             	mov    0x8(%eax),%edx
  801fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe1:	8b 48 08             	mov    0x8(%eax),%ecx
  801fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe7:	8b 40 0c             	mov    0xc(%eax),%eax
  801fea:	01 c8                	add    %ecx,%eax
  801fec:	39 c2                	cmp    %eax,%edx
  801fee:	73 04                	jae    801ff4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ff0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff7:	8b 50 08             	mov    0x8(%eax),%edx
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffd:	8b 40 0c             	mov    0xc(%eax),%eax
  802000:	01 c2                	add    %eax,%edx
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	8b 40 08             	mov    0x8(%eax),%eax
  802008:	83 ec 04             	sub    $0x4,%esp
  80200b:	52                   	push   %edx
  80200c:	50                   	push   %eax
  80200d:	68 a1 40 80 00       	push   $0x8040a1
  802012:	e8 b2 e5 ff ff       	call   8005c9 <cprintf>
  802017:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802020:	a1 48 50 80 00       	mov    0x805048,%eax
  802025:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802028:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202c:	74 07                	je     802035 <print_mem_block_lists+0x155>
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802031:	8b 00                	mov    (%eax),%eax
  802033:	eb 05                	jmp    80203a <print_mem_block_lists+0x15a>
  802035:	b8 00 00 00 00       	mov    $0x0,%eax
  80203a:	a3 48 50 80 00       	mov    %eax,0x805048
  80203f:	a1 48 50 80 00       	mov    0x805048,%eax
  802044:	85 c0                	test   %eax,%eax
  802046:	75 8a                	jne    801fd2 <print_mem_block_lists+0xf2>
  802048:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204c:	75 84                	jne    801fd2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80204e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802052:	75 10                	jne    802064 <print_mem_block_lists+0x184>
  802054:	83 ec 0c             	sub    $0xc,%esp
  802057:	68 ec 40 80 00       	push   $0x8040ec
  80205c:	e8 68 e5 ff ff       	call   8005c9 <cprintf>
  802061:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802064:	83 ec 0c             	sub    $0xc,%esp
  802067:	68 60 40 80 00       	push   $0x804060
  80206c:	e8 58 e5 ff ff       	call   8005c9 <cprintf>
  802071:	83 c4 10             	add    $0x10,%esp

}
  802074:	90                   	nop
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80207d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802084:	00 00 00 
  802087:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80208e:	00 00 00 
  802091:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802098:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80209b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020a2:	e9 9e 00 00 00       	jmp    802145 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020a7:	a1 50 50 80 00       	mov    0x805050,%eax
  8020ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020af:	c1 e2 04             	shl    $0x4,%edx
  8020b2:	01 d0                	add    %edx,%eax
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	75 14                	jne    8020cc <initialize_MemBlocksList+0x55>
  8020b8:	83 ec 04             	sub    $0x4,%esp
  8020bb:	68 14 41 80 00       	push   $0x804114
  8020c0:	6a 46                	push   $0x46
  8020c2:	68 37 41 80 00       	push   $0x804137
  8020c7:	e8 49 e2 ff ff       	call   800315 <_panic>
  8020cc:	a1 50 50 80 00       	mov    0x805050,%eax
  8020d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d4:	c1 e2 04             	shl    $0x4,%edx
  8020d7:	01 d0                	add    %edx,%eax
  8020d9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020df:	89 10                	mov    %edx,(%eax)
  8020e1:	8b 00                	mov    (%eax),%eax
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	74 18                	je     8020ff <initialize_MemBlocksList+0x88>
  8020e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8020ec:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020f2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020f5:	c1 e1 04             	shl    $0x4,%ecx
  8020f8:	01 ca                	add    %ecx,%edx
  8020fa:	89 50 04             	mov    %edx,0x4(%eax)
  8020fd:	eb 12                	jmp    802111 <initialize_MemBlocksList+0x9a>
  8020ff:	a1 50 50 80 00       	mov    0x805050,%eax
  802104:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802107:	c1 e2 04             	shl    $0x4,%edx
  80210a:	01 d0                	add    %edx,%eax
  80210c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802111:	a1 50 50 80 00       	mov    0x805050,%eax
  802116:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802119:	c1 e2 04             	shl    $0x4,%edx
  80211c:	01 d0                	add    %edx,%eax
  80211e:	a3 48 51 80 00       	mov    %eax,0x805148
  802123:	a1 50 50 80 00       	mov    0x805050,%eax
  802128:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212b:	c1 e2 04             	shl    $0x4,%edx
  80212e:	01 d0                	add    %edx,%eax
  802130:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802137:	a1 54 51 80 00       	mov    0x805154,%eax
  80213c:	40                   	inc    %eax
  80213d:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802142:	ff 45 f4             	incl   -0xc(%ebp)
  802145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802148:	3b 45 08             	cmp    0x8(%ebp),%eax
  80214b:	0f 82 56 ff ff ff    	jb     8020a7 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802151:	90                   	nop
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	8b 00                	mov    (%eax),%eax
  80215f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802162:	eb 19                	jmp    80217d <find_block+0x29>
	{
		if(va==point->sva)
  802164:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802167:	8b 40 08             	mov    0x8(%eax),%eax
  80216a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80216d:	75 05                	jne    802174 <find_block+0x20>
		   return point;
  80216f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802172:	eb 36                	jmp    8021aa <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	8b 40 08             	mov    0x8(%eax),%eax
  80217a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80217d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802181:	74 07                	je     80218a <find_block+0x36>
  802183:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	eb 05                	jmp    80218f <find_block+0x3b>
  80218a:	b8 00 00 00 00       	mov    $0x0,%eax
  80218f:	8b 55 08             	mov    0x8(%ebp),%edx
  802192:	89 42 08             	mov    %eax,0x8(%edx)
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	8b 40 08             	mov    0x8(%eax),%eax
  80219b:	85 c0                	test   %eax,%eax
  80219d:	75 c5                	jne    802164 <find_block+0x10>
  80219f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021a3:	75 bf                	jne    802164 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021b2:	a1 40 50 80 00       	mov    0x805040,%eax
  8021b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021ba:	a1 44 50 80 00       	mov    0x805044,%eax
  8021bf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021c8:	74 24                	je     8021ee <insert_sorted_allocList+0x42>
  8021ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cd:	8b 50 08             	mov    0x8(%eax),%edx
  8021d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d3:	8b 40 08             	mov    0x8(%eax),%eax
  8021d6:	39 c2                	cmp    %eax,%edx
  8021d8:	76 14                	jbe    8021ee <insert_sorted_allocList+0x42>
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	8b 50 08             	mov    0x8(%eax),%edx
  8021e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e3:	8b 40 08             	mov    0x8(%eax),%eax
  8021e6:	39 c2                	cmp    %eax,%edx
  8021e8:	0f 82 60 01 00 00    	jb     80234e <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021f2:	75 65                	jne    802259 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f8:	75 14                	jne    80220e <insert_sorted_allocList+0x62>
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	68 14 41 80 00       	push   $0x804114
  802202:	6a 6b                	push   $0x6b
  802204:	68 37 41 80 00       	push   $0x804137
  802209:	e8 07 e1 ff ff       	call   800315 <_panic>
  80220e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	89 10                	mov    %edx,(%eax)
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	8b 00                	mov    (%eax),%eax
  80221e:	85 c0                	test   %eax,%eax
  802220:	74 0d                	je     80222f <insert_sorted_allocList+0x83>
  802222:	a1 40 50 80 00       	mov    0x805040,%eax
  802227:	8b 55 08             	mov    0x8(%ebp),%edx
  80222a:	89 50 04             	mov    %edx,0x4(%eax)
  80222d:	eb 08                	jmp    802237 <insert_sorted_allocList+0x8b>
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	a3 44 50 80 00       	mov    %eax,0x805044
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	a3 40 50 80 00       	mov    %eax,0x805040
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802249:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80224e:	40                   	inc    %eax
  80224f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802254:	e9 dc 01 00 00       	jmp    802435 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	8b 50 08             	mov    0x8(%eax),%edx
  80225f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802262:	8b 40 08             	mov    0x8(%eax),%eax
  802265:	39 c2                	cmp    %eax,%edx
  802267:	77 6c                	ja     8022d5 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802269:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80226d:	74 06                	je     802275 <insert_sorted_allocList+0xc9>
  80226f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802273:	75 14                	jne    802289 <insert_sorted_allocList+0xdd>
  802275:	83 ec 04             	sub    $0x4,%esp
  802278:	68 50 41 80 00       	push   $0x804150
  80227d:	6a 6f                	push   $0x6f
  80227f:	68 37 41 80 00       	push   $0x804137
  802284:	e8 8c e0 ff ff       	call   800315 <_panic>
  802289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228c:	8b 50 04             	mov    0x4(%eax),%edx
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	89 50 04             	mov    %edx,0x4(%eax)
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80229b:	89 10                	mov    %edx,(%eax)
  80229d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a0:	8b 40 04             	mov    0x4(%eax),%eax
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	74 0d                	je     8022b4 <insert_sorted_allocList+0x108>
  8022a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022aa:	8b 40 04             	mov    0x4(%eax),%eax
  8022ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b0:	89 10                	mov    %edx,(%eax)
  8022b2:	eb 08                	jmp    8022bc <insert_sorted_allocList+0x110>
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	a3 40 50 80 00       	mov    %eax,0x805040
  8022bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c2:	89 50 04             	mov    %edx,0x4(%eax)
  8022c5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ca:	40                   	inc    %eax
  8022cb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022d0:	e9 60 01 00 00       	jmp    802435 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	8b 50 08             	mov    0x8(%eax),%edx
  8022db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022de:	8b 40 08             	mov    0x8(%eax),%eax
  8022e1:	39 c2                	cmp    %eax,%edx
  8022e3:	0f 82 4c 01 00 00    	jb     802435 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ed:	75 14                	jne    802303 <insert_sorted_allocList+0x157>
  8022ef:	83 ec 04             	sub    $0x4,%esp
  8022f2:	68 88 41 80 00       	push   $0x804188
  8022f7:	6a 73                	push   $0x73
  8022f9:	68 37 41 80 00       	push   $0x804137
  8022fe:	e8 12 e0 ff ff       	call   800315 <_panic>
  802303:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	89 50 04             	mov    %edx,0x4(%eax)
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	8b 40 04             	mov    0x4(%eax),%eax
  802315:	85 c0                	test   %eax,%eax
  802317:	74 0c                	je     802325 <insert_sorted_allocList+0x179>
  802319:	a1 44 50 80 00       	mov    0x805044,%eax
  80231e:	8b 55 08             	mov    0x8(%ebp),%edx
  802321:	89 10                	mov    %edx,(%eax)
  802323:	eb 08                	jmp    80232d <insert_sorted_allocList+0x181>
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	a3 40 50 80 00       	mov    %eax,0x805040
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	a3 44 50 80 00       	mov    %eax,0x805044
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80233e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802343:	40                   	inc    %eax
  802344:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802349:	e9 e7 00 00 00       	jmp    802435 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80234e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802351:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802354:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80235b:	a1 40 50 80 00       	mov    0x805040,%eax
  802360:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802363:	e9 9d 00 00 00       	jmp    802405 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 00                	mov    (%eax),%eax
  80236d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	8b 50 08             	mov    0x8(%eax),%edx
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 40 08             	mov    0x8(%eax),%eax
  80237c:	39 c2                	cmp    %eax,%edx
  80237e:	76 7d                	jbe    8023fd <insert_sorted_allocList+0x251>
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	8b 50 08             	mov    0x8(%eax),%edx
  802386:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802389:	8b 40 08             	mov    0x8(%eax),%eax
  80238c:	39 c2                	cmp    %eax,%edx
  80238e:	73 6d                	jae    8023fd <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802394:	74 06                	je     80239c <insert_sorted_allocList+0x1f0>
  802396:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239a:	75 14                	jne    8023b0 <insert_sorted_allocList+0x204>
  80239c:	83 ec 04             	sub    $0x4,%esp
  80239f:	68 ac 41 80 00       	push   $0x8041ac
  8023a4:	6a 7f                	push   $0x7f
  8023a6:	68 37 41 80 00       	push   $0x804137
  8023ab:	e8 65 df ff ff       	call   800315 <_panic>
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	8b 10                	mov    (%eax),%edx
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	89 10                	mov    %edx,(%eax)
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	8b 00                	mov    (%eax),%eax
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	74 0b                	je     8023ce <insert_sorted_allocList+0x222>
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 00                	mov    (%eax),%eax
  8023c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cb:	89 50 04             	mov    %edx,0x4(%eax)
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d4:	89 10                	mov    %edx,(%eax)
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023dc:	89 50 04             	mov    %edx,0x4(%eax)
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	8b 00                	mov    (%eax),%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	75 08                	jne    8023f0 <insert_sorted_allocList+0x244>
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	a3 44 50 80 00       	mov    %eax,0x805044
  8023f0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023f5:	40                   	inc    %eax
  8023f6:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023fb:	eb 39                	jmp    802436 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023fd:	a1 48 50 80 00       	mov    0x805048,%eax
  802402:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802405:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802409:	74 07                	je     802412 <insert_sorted_allocList+0x266>
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	eb 05                	jmp    802417 <insert_sorted_allocList+0x26b>
  802412:	b8 00 00 00 00       	mov    $0x0,%eax
  802417:	a3 48 50 80 00       	mov    %eax,0x805048
  80241c:	a1 48 50 80 00       	mov    0x805048,%eax
  802421:	85 c0                	test   %eax,%eax
  802423:	0f 85 3f ff ff ff    	jne    802368 <insert_sorted_allocList+0x1bc>
  802429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242d:	0f 85 35 ff ff ff    	jne    802368 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802433:	eb 01                	jmp    802436 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802435:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802436:	90                   	nop
  802437:	c9                   	leave  
  802438:	c3                   	ret    

00802439 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
  80243c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80243f:	a1 38 51 80 00       	mov    0x805138,%eax
  802444:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802447:	e9 85 01 00 00       	jmp    8025d1 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	8b 40 0c             	mov    0xc(%eax),%eax
  802452:	3b 45 08             	cmp    0x8(%ebp),%eax
  802455:	0f 82 6e 01 00 00    	jb     8025c9 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 40 0c             	mov    0xc(%eax),%eax
  802461:	3b 45 08             	cmp    0x8(%ebp),%eax
  802464:	0f 85 8a 00 00 00    	jne    8024f4 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80246a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246e:	75 17                	jne    802487 <alloc_block_FF+0x4e>
  802470:	83 ec 04             	sub    $0x4,%esp
  802473:	68 e0 41 80 00       	push   $0x8041e0
  802478:	68 93 00 00 00       	push   $0x93
  80247d:	68 37 41 80 00       	push   $0x804137
  802482:	e8 8e de ff ff       	call   800315 <_panic>
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 00                	mov    (%eax),%eax
  80248c:	85 c0                	test   %eax,%eax
  80248e:	74 10                	je     8024a0 <alloc_block_FF+0x67>
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 00                	mov    (%eax),%eax
  802495:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802498:	8b 52 04             	mov    0x4(%edx),%edx
  80249b:	89 50 04             	mov    %edx,0x4(%eax)
  80249e:	eb 0b                	jmp    8024ab <alloc_block_FF+0x72>
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 04             	mov    0x4(%eax),%eax
  8024a6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 40 04             	mov    0x4(%eax),%eax
  8024b1:	85 c0                	test   %eax,%eax
  8024b3:	74 0f                	je     8024c4 <alloc_block_FF+0x8b>
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	8b 40 04             	mov    0x4(%eax),%eax
  8024bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024be:	8b 12                	mov    (%edx),%edx
  8024c0:	89 10                	mov    %edx,(%eax)
  8024c2:	eb 0a                	jmp    8024ce <alloc_block_FF+0x95>
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 00                	mov    (%eax),%eax
  8024c9:	a3 38 51 80 00       	mov    %eax,0x805138
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e1:	a1 44 51 80 00       	mov    0x805144,%eax
  8024e6:	48                   	dec    %eax
  8024e7:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	e9 10 01 00 00       	jmp    802604 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024fd:	0f 86 c6 00 00 00    	jbe    8025c9 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802503:	a1 48 51 80 00       	mov    0x805148,%eax
  802508:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 50 08             	mov    0x8(%eax),%edx
  802511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802514:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251a:	8b 55 08             	mov    0x8(%ebp),%edx
  80251d:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802520:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802524:	75 17                	jne    80253d <alloc_block_FF+0x104>
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	68 e0 41 80 00       	push   $0x8041e0
  80252e:	68 9b 00 00 00       	push   $0x9b
  802533:	68 37 41 80 00       	push   $0x804137
  802538:	e8 d8 dd ff ff       	call   800315 <_panic>
  80253d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	74 10                	je     802556 <alloc_block_FF+0x11d>
  802546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80254e:	8b 52 04             	mov    0x4(%edx),%edx
  802551:	89 50 04             	mov    %edx,0x4(%eax)
  802554:	eb 0b                	jmp    802561 <alloc_block_FF+0x128>
  802556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802559:	8b 40 04             	mov    0x4(%eax),%eax
  80255c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802564:	8b 40 04             	mov    0x4(%eax),%eax
  802567:	85 c0                	test   %eax,%eax
  802569:	74 0f                	je     80257a <alloc_block_FF+0x141>
  80256b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256e:	8b 40 04             	mov    0x4(%eax),%eax
  802571:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802574:	8b 12                	mov    (%edx),%edx
  802576:	89 10                	mov    %edx,(%eax)
  802578:	eb 0a                	jmp    802584 <alloc_block_FF+0x14b>
  80257a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	a3 48 51 80 00       	mov    %eax,0x805148
  802584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802590:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802597:	a1 54 51 80 00       	mov    0x805154,%eax
  80259c:	48                   	dec    %eax
  80259d:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 50 08             	mov    0x8(%eax),%edx
  8025a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ab:	01 c2                	add    %eax,%edx
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b9:	2b 45 08             	sub    0x8(%ebp),%eax
  8025bc:	89 c2                	mov    %eax,%edx
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c7:	eb 3b                	jmp    802604 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d5:	74 07                	je     8025de <alloc_block_FF+0x1a5>
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 00                	mov    (%eax),%eax
  8025dc:	eb 05                	jmp    8025e3 <alloc_block_FF+0x1aa>
  8025de:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e3:	a3 40 51 80 00       	mov    %eax,0x805140
  8025e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	0f 85 57 fe ff ff    	jne    80244c <alloc_block_FF+0x13>
  8025f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f9:	0f 85 4d fe ff ff    	jne    80244c <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
  802609:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80260c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802613:	a1 38 51 80 00       	mov    0x805138,%eax
  802618:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261b:	e9 df 00 00 00       	jmp    8026ff <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 40 0c             	mov    0xc(%eax),%eax
  802626:	3b 45 08             	cmp    0x8(%ebp),%eax
  802629:	0f 82 c8 00 00 00    	jb     8026f7 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	8b 40 0c             	mov    0xc(%eax),%eax
  802635:	3b 45 08             	cmp    0x8(%ebp),%eax
  802638:	0f 85 8a 00 00 00    	jne    8026c8 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80263e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802642:	75 17                	jne    80265b <alloc_block_BF+0x55>
  802644:	83 ec 04             	sub    $0x4,%esp
  802647:	68 e0 41 80 00       	push   $0x8041e0
  80264c:	68 b7 00 00 00       	push   $0xb7
  802651:	68 37 41 80 00       	push   $0x804137
  802656:	e8 ba dc ff ff       	call   800315 <_panic>
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 00                	mov    (%eax),%eax
  802660:	85 c0                	test   %eax,%eax
  802662:	74 10                	je     802674 <alloc_block_BF+0x6e>
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266c:	8b 52 04             	mov    0x4(%edx),%edx
  80266f:	89 50 04             	mov    %edx,0x4(%eax)
  802672:	eb 0b                	jmp    80267f <alloc_block_BF+0x79>
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 40 04             	mov    0x4(%eax),%eax
  80267a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 40 04             	mov    0x4(%eax),%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	74 0f                	je     802698 <alloc_block_BF+0x92>
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 40 04             	mov    0x4(%eax),%eax
  80268f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802692:	8b 12                	mov    (%edx),%edx
  802694:	89 10                	mov    %edx,(%eax)
  802696:	eb 0a                	jmp    8026a2 <alloc_block_BF+0x9c>
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 00                	mov    (%eax),%eax
  80269d:	a3 38 51 80 00       	mov    %eax,0x805138
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b5:	a1 44 51 80 00       	mov    0x805144,%eax
  8026ba:	48                   	dec    %eax
  8026bb:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	e9 4d 01 00 00       	jmp    802815 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d1:	76 24                	jbe    8026f7 <alloc_block_BF+0xf1>
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026dc:	73 19                	jae    8026f7 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026de:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 40 08             	mov    0x8(%eax),%eax
  8026f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8026fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802703:	74 07                	je     80270c <alloc_block_BF+0x106>
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 00                	mov    (%eax),%eax
  80270a:	eb 05                	jmp    802711 <alloc_block_BF+0x10b>
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
  802711:	a3 40 51 80 00       	mov    %eax,0x805140
  802716:	a1 40 51 80 00       	mov    0x805140,%eax
  80271b:	85 c0                	test   %eax,%eax
  80271d:	0f 85 fd fe ff ff    	jne    802620 <alloc_block_BF+0x1a>
  802723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802727:	0f 85 f3 fe ff ff    	jne    802620 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80272d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802731:	0f 84 d9 00 00 00    	je     802810 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802737:	a1 48 51 80 00       	mov    0x805148,%eax
  80273c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80273f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802742:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802745:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274b:	8b 55 08             	mov    0x8(%ebp),%edx
  80274e:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802751:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802755:	75 17                	jne    80276e <alloc_block_BF+0x168>
  802757:	83 ec 04             	sub    $0x4,%esp
  80275a:	68 e0 41 80 00       	push   $0x8041e0
  80275f:	68 c7 00 00 00       	push   $0xc7
  802764:	68 37 41 80 00       	push   $0x804137
  802769:	e8 a7 db ff ff       	call   800315 <_panic>
  80276e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802771:	8b 00                	mov    (%eax),%eax
  802773:	85 c0                	test   %eax,%eax
  802775:	74 10                	je     802787 <alloc_block_BF+0x181>
  802777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80277f:	8b 52 04             	mov    0x4(%edx),%edx
  802782:	89 50 04             	mov    %edx,0x4(%eax)
  802785:	eb 0b                	jmp    802792 <alloc_block_BF+0x18c>
  802787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278a:	8b 40 04             	mov    0x4(%eax),%eax
  80278d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802795:	8b 40 04             	mov    0x4(%eax),%eax
  802798:	85 c0                	test   %eax,%eax
  80279a:	74 0f                	je     8027ab <alloc_block_BF+0x1a5>
  80279c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279f:	8b 40 04             	mov    0x4(%eax),%eax
  8027a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027a5:	8b 12                	mov    (%edx),%edx
  8027a7:	89 10                	mov    %edx,(%eax)
  8027a9:	eb 0a                	jmp    8027b5 <alloc_block_BF+0x1af>
  8027ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ae:	8b 00                	mov    (%eax),%eax
  8027b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8027b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c8:	a1 54 51 80 00       	mov    0x805154,%eax
  8027cd:	48                   	dec    %eax
  8027ce:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027d3:	83 ec 08             	sub    $0x8,%esp
  8027d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8027d9:	68 38 51 80 00       	push   $0x805138
  8027de:	e8 71 f9 ff ff       	call   802154 <find_block>
  8027e3:	83 c4 10             	add    $0x10,%esp
  8027e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ec:	8b 50 08             	mov    0x8(%eax),%edx
  8027ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f2:	01 c2                	add    %eax,%edx
  8027f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f7:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802800:	2b 45 08             	sub    0x8(%ebp),%eax
  802803:	89 c2                	mov    %eax,%edx
  802805:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802808:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80280b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280e:	eb 05                	jmp    802815 <alloc_block_BF+0x20f>
	}
	return NULL;
  802810:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
  80281a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80281d:	a1 28 50 80 00       	mov    0x805028,%eax
  802822:	85 c0                	test   %eax,%eax
  802824:	0f 85 de 01 00 00    	jne    802a08 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80282a:	a1 38 51 80 00       	mov    0x805138,%eax
  80282f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802832:	e9 9e 01 00 00       	jmp    8029d5 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 40 0c             	mov    0xc(%eax),%eax
  80283d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802840:	0f 82 87 01 00 00    	jb     8029cd <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 0c             	mov    0xc(%eax),%eax
  80284c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284f:	0f 85 95 00 00 00    	jne    8028ea <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802859:	75 17                	jne    802872 <alloc_block_NF+0x5b>
  80285b:	83 ec 04             	sub    $0x4,%esp
  80285e:	68 e0 41 80 00       	push   $0x8041e0
  802863:	68 e0 00 00 00       	push   $0xe0
  802868:	68 37 41 80 00       	push   $0x804137
  80286d:	e8 a3 da ff ff       	call   800315 <_panic>
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	74 10                	je     80288b <alloc_block_NF+0x74>
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 00                	mov    (%eax),%eax
  802880:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802883:	8b 52 04             	mov    0x4(%edx),%edx
  802886:	89 50 04             	mov    %edx,0x4(%eax)
  802889:	eb 0b                	jmp    802896 <alloc_block_NF+0x7f>
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 40 04             	mov    0x4(%eax),%eax
  802891:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 40 04             	mov    0x4(%eax),%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	74 0f                	je     8028af <alloc_block_NF+0x98>
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 40 04             	mov    0x4(%eax),%eax
  8028a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a9:	8b 12                	mov    (%edx),%edx
  8028ab:	89 10                	mov    %edx,(%eax)
  8028ad:	eb 0a                	jmp    8028b9 <alloc_block_NF+0xa2>
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 00                	mov    (%eax),%eax
  8028b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8028d1:	48                   	dec    %eax
  8028d2:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 40 08             	mov    0x8(%eax),%eax
  8028dd:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	e9 f8 04 00 00       	jmp    802de2 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f3:	0f 86 d4 00 00 00    	jbe    8029cd <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8028fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	8b 50 08             	mov    0x8(%eax),%edx
  802907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290a:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80290d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802910:	8b 55 08             	mov    0x8(%ebp),%edx
  802913:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802916:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80291a:	75 17                	jne    802933 <alloc_block_NF+0x11c>
  80291c:	83 ec 04             	sub    $0x4,%esp
  80291f:	68 e0 41 80 00       	push   $0x8041e0
  802924:	68 e9 00 00 00       	push   $0xe9
  802929:	68 37 41 80 00       	push   $0x804137
  80292e:	e8 e2 d9 ff ff       	call   800315 <_panic>
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	8b 00                	mov    (%eax),%eax
  802938:	85 c0                	test   %eax,%eax
  80293a:	74 10                	je     80294c <alloc_block_NF+0x135>
  80293c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293f:	8b 00                	mov    (%eax),%eax
  802941:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802944:	8b 52 04             	mov    0x4(%edx),%edx
  802947:	89 50 04             	mov    %edx,0x4(%eax)
  80294a:	eb 0b                	jmp    802957 <alloc_block_NF+0x140>
  80294c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294f:	8b 40 04             	mov    0x4(%eax),%eax
  802952:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295a:	8b 40 04             	mov    0x4(%eax),%eax
  80295d:	85 c0                	test   %eax,%eax
  80295f:	74 0f                	je     802970 <alloc_block_NF+0x159>
  802961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802964:	8b 40 04             	mov    0x4(%eax),%eax
  802967:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80296a:	8b 12                	mov    (%edx),%edx
  80296c:	89 10                	mov    %edx,(%eax)
  80296e:	eb 0a                	jmp    80297a <alloc_block_NF+0x163>
  802970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	a3 48 51 80 00       	mov    %eax,0x805148
  80297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802986:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298d:	a1 54 51 80 00       	mov    0x805154,%eax
  802992:	48                   	dec    %eax
  802993:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299b:	8b 40 08             	mov    0x8(%eax),%eax
  80299e:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 50 08             	mov    0x8(%eax),%edx
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	01 c2                	add    %eax,%edx
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ba:	2b 45 08             	sub    0x8(%ebp),%eax
  8029bd:	89 c2                	mov    %eax,%edx
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c8:	e9 15 04 00 00       	jmp    802de2 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029cd:	a1 40 51 80 00       	mov    0x805140,%eax
  8029d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d9:	74 07                	je     8029e2 <alloc_block_NF+0x1cb>
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	eb 05                	jmp    8029e7 <alloc_block_NF+0x1d0>
  8029e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e7:	a3 40 51 80 00       	mov    %eax,0x805140
  8029ec:	a1 40 51 80 00       	mov    0x805140,%eax
  8029f1:	85 c0                	test   %eax,%eax
  8029f3:	0f 85 3e fe ff ff    	jne    802837 <alloc_block_NF+0x20>
  8029f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fd:	0f 85 34 fe ff ff    	jne    802837 <alloc_block_NF+0x20>
  802a03:	e9 d5 03 00 00       	jmp    802ddd <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a08:	a1 38 51 80 00       	mov    0x805138,%eax
  802a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a10:	e9 b1 01 00 00       	jmp    802bc6 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 50 08             	mov    0x8(%eax),%edx
  802a1b:	a1 28 50 80 00       	mov    0x805028,%eax
  802a20:	39 c2                	cmp    %eax,%edx
  802a22:	0f 82 96 01 00 00    	jb     802bbe <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a31:	0f 82 87 01 00 00    	jb     802bbe <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a40:	0f 85 95 00 00 00    	jne    802adb <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4a:	75 17                	jne    802a63 <alloc_block_NF+0x24c>
  802a4c:	83 ec 04             	sub    $0x4,%esp
  802a4f:	68 e0 41 80 00       	push   $0x8041e0
  802a54:	68 fc 00 00 00       	push   $0xfc
  802a59:	68 37 41 80 00       	push   $0x804137
  802a5e:	e8 b2 d8 ff ff       	call   800315 <_panic>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	74 10                	je     802a7c <alloc_block_NF+0x265>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 00                	mov    (%eax),%eax
  802a71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a74:	8b 52 04             	mov    0x4(%edx),%edx
  802a77:	89 50 04             	mov    %edx,0x4(%eax)
  802a7a:	eb 0b                	jmp    802a87 <alloc_block_NF+0x270>
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 40 04             	mov    0x4(%eax),%eax
  802a82:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 40 04             	mov    0x4(%eax),%eax
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	74 0f                	je     802aa0 <alloc_block_NF+0x289>
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 40 04             	mov    0x4(%eax),%eax
  802a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9a:	8b 12                	mov    (%edx),%edx
  802a9c:	89 10                	mov    %edx,(%eax)
  802a9e:	eb 0a                	jmp    802aaa <alloc_block_NF+0x293>
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	a3 38 51 80 00       	mov    %eax,0x805138
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abd:	a1 44 51 80 00       	mov    0x805144,%eax
  802ac2:	48                   	dec    %eax
  802ac3:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 08             	mov    0x8(%eax),%eax
  802ace:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	e9 07 03 00 00       	jmp    802de2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae4:	0f 86 d4 00 00 00    	jbe    802bbe <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aea:	a1 48 51 80 00       	mov    0x805148,%eax
  802aef:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	8b 50 08             	mov    0x8(%eax),%edx
  802af8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b01:	8b 55 08             	mov    0x8(%ebp),%edx
  802b04:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b07:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b0b:	75 17                	jne    802b24 <alloc_block_NF+0x30d>
  802b0d:	83 ec 04             	sub    $0x4,%esp
  802b10:	68 e0 41 80 00       	push   $0x8041e0
  802b15:	68 04 01 00 00       	push   $0x104
  802b1a:	68 37 41 80 00       	push   $0x804137
  802b1f:	e8 f1 d7 ff ff       	call   800315 <_panic>
  802b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b27:	8b 00                	mov    (%eax),%eax
  802b29:	85 c0                	test   %eax,%eax
  802b2b:	74 10                	je     802b3d <alloc_block_NF+0x326>
  802b2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b35:	8b 52 04             	mov    0x4(%edx),%edx
  802b38:	89 50 04             	mov    %edx,0x4(%eax)
  802b3b:	eb 0b                	jmp    802b48 <alloc_block_NF+0x331>
  802b3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b40:	8b 40 04             	mov    0x4(%eax),%eax
  802b43:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4b:	8b 40 04             	mov    0x4(%eax),%eax
  802b4e:	85 c0                	test   %eax,%eax
  802b50:	74 0f                	je     802b61 <alloc_block_NF+0x34a>
  802b52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b55:	8b 40 04             	mov    0x4(%eax),%eax
  802b58:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b5b:	8b 12                	mov    (%edx),%edx
  802b5d:	89 10                	mov    %edx,(%eax)
  802b5f:	eb 0a                	jmp    802b6b <alloc_block_NF+0x354>
  802b61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b64:	8b 00                	mov    (%eax),%eax
  802b66:	a3 48 51 80 00       	mov    %eax,0x805148
  802b6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7e:	a1 54 51 80 00       	mov    0x805154,%eax
  802b83:	48                   	dec    %eax
  802b84:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8c:	8b 40 08             	mov    0x8(%eax),%eax
  802b8f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 50 08             	mov    0x8(%eax),%edx
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	01 c2                	add    %eax,%edx
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bab:	2b 45 08             	sub    0x8(%ebp),%eax
  802bae:	89 c2                	mov    %eax,%edx
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb9:	e9 24 02 00 00       	jmp    802de2 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bbe:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bca:	74 07                	je     802bd3 <alloc_block_NF+0x3bc>
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	eb 05                	jmp    802bd8 <alloc_block_NF+0x3c1>
  802bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd8:	a3 40 51 80 00       	mov    %eax,0x805140
  802bdd:	a1 40 51 80 00       	mov    0x805140,%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	0f 85 2b fe ff ff    	jne    802a15 <alloc_block_NF+0x1fe>
  802bea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bee:	0f 85 21 fe ff ff    	jne    802a15 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bf4:	a1 38 51 80 00       	mov    0x805138,%eax
  802bf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bfc:	e9 ae 01 00 00       	jmp    802daf <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 50 08             	mov    0x8(%eax),%edx
  802c07:	a1 28 50 80 00       	mov    0x805028,%eax
  802c0c:	39 c2                	cmp    %eax,%edx
  802c0e:	0f 83 93 01 00 00    	jae    802da7 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1d:	0f 82 84 01 00 00    	jb     802da7 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	8b 40 0c             	mov    0xc(%eax),%eax
  802c29:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2c:	0f 85 95 00 00 00    	jne    802cc7 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c36:	75 17                	jne    802c4f <alloc_block_NF+0x438>
  802c38:	83 ec 04             	sub    $0x4,%esp
  802c3b:	68 e0 41 80 00       	push   $0x8041e0
  802c40:	68 14 01 00 00       	push   $0x114
  802c45:	68 37 41 80 00       	push   $0x804137
  802c4a:	e8 c6 d6 ff ff       	call   800315 <_panic>
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	74 10                	je     802c68 <alloc_block_NF+0x451>
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c60:	8b 52 04             	mov    0x4(%edx),%edx
  802c63:	89 50 04             	mov    %edx,0x4(%eax)
  802c66:	eb 0b                	jmp    802c73 <alloc_block_NF+0x45c>
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 40 04             	mov    0x4(%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	74 0f                	je     802c8c <alloc_block_NF+0x475>
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 40 04             	mov    0x4(%eax),%eax
  802c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c86:	8b 12                	mov    (%edx),%edx
  802c88:	89 10                	mov    %edx,(%eax)
  802c8a:	eb 0a                	jmp    802c96 <alloc_block_NF+0x47f>
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 00                	mov    (%eax),%eax
  802c91:	a3 38 51 80 00       	mov    %eax,0x805138
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca9:	a1 44 51 80 00       	mov    0x805144,%eax
  802cae:	48                   	dec    %eax
  802caf:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 40 08             	mov    0x8(%eax),%eax
  802cba:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	e9 1b 01 00 00       	jmp    802de2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd0:	0f 86 d1 00 00 00    	jbe    802da7 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cd6:	a1 48 51 80 00       	mov    0x805148,%eax
  802cdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 50 08             	mov    0x8(%eax),%edx
  802ce4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ced:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cf3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cf7:	75 17                	jne    802d10 <alloc_block_NF+0x4f9>
  802cf9:	83 ec 04             	sub    $0x4,%esp
  802cfc:	68 e0 41 80 00       	push   $0x8041e0
  802d01:	68 1c 01 00 00       	push   $0x11c
  802d06:	68 37 41 80 00       	push   $0x804137
  802d0b:	e8 05 d6 ff ff       	call   800315 <_panic>
  802d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	74 10                	je     802d29 <alloc_block_NF+0x512>
  802d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d21:	8b 52 04             	mov    0x4(%edx),%edx
  802d24:	89 50 04             	mov    %edx,0x4(%eax)
  802d27:	eb 0b                	jmp    802d34 <alloc_block_NF+0x51d>
  802d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2c:	8b 40 04             	mov    0x4(%eax),%eax
  802d2f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d37:	8b 40 04             	mov    0x4(%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 0f                	je     802d4d <alloc_block_NF+0x536>
  802d3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d47:	8b 12                	mov    (%edx),%edx
  802d49:	89 10                	mov    %edx,(%eax)
  802d4b:	eb 0a                	jmp    802d57 <alloc_block_NF+0x540>
  802d4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	a3 48 51 80 00       	mov    %eax,0x805148
  802d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6a:	a1 54 51 80 00       	mov    0x805154,%eax
  802d6f:	48                   	dec    %eax
  802d70:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d78:	8b 40 08             	mov    0x8(%eax),%eax
  802d7b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 50 08             	mov    0x8(%eax),%edx
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	01 c2                	add    %eax,%edx
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 40 0c             	mov    0xc(%eax),%eax
  802d97:	2b 45 08             	sub    0x8(%ebp),%eax
  802d9a:	89 c2                	mov    %eax,%edx
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da5:	eb 3b                	jmp    802de2 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802da7:	a1 40 51 80 00       	mov    0x805140,%eax
  802dac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802daf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db3:	74 07                	je     802dbc <alloc_block_NF+0x5a5>
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 00                	mov    (%eax),%eax
  802dba:	eb 05                	jmp    802dc1 <alloc_block_NF+0x5aa>
  802dbc:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc1:	a3 40 51 80 00       	mov    %eax,0x805140
  802dc6:	a1 40 51 80 00       	mov    0x805140,%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	0f 85 2e fe ff ff    	jne    802c01 <alloc_block_NF+0x3ea>
  802dd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd7:	0f 85 24 fe ff ff    	jne    802c01 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802de2:	c9                   	leave  
  802de3:	c3                   	ret    

00802de4 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802de4:	55                   	push   %ebp
  802de5:	89 e5                	mov    %esp,%ebp
  802de7:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802dea:	a1 38 51 80 00       	mov    0x805138,%eax
  802def:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802df2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802df7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802dfa:	a1 38 51 80 00       	mov    0x805138,%eax
  802dff:	85 c0                	test   %eax,%eax
  802e01:	74 14                	je     802e17 <insert_sorted_with_merge_freeList+0x33>
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	8b 50 08             	mov    0x8(%eax),%edx
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	8b 40 08             	mov    0x8(%eax),%eax
  802e0f:	39 c2                	cmp    %eax,%edx
  802e11:	0f 87 9b 01 00 00    	ja     802fb2 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1b:	75 17                	jne    802e34 <insert_sorted_with_merge_freeList+0x50>
  802e1d:	83 ec 04             	sub    $0x4,%esp
  802e20:	68 14 41 80 00       	push   $0x804114
  802e25:	68 38 01 00 00       	push   $0x138
  802e2a:	68 37 41 80 00       	push   $0x804137
  802e2f:	e8 e1 d4 ff ff       	call   800315 <_panic>
  802e34:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3d:	89 10                	mov    %edx,(%eax)
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	8b 00                	mov    (%eax),%eax
  802e44:	85 c0                	test   %eax,%eax
  802e46:	74 0d                	je     802e55 <insert_sorted_with_merge_freeList+0x71>
  802e48:	a1 38 51 80 00       	mov    0x805138,%eax
  802e4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e50:	89 50 04             	mov    %edx,0x4(%eax)
  802e53:	eb 08                	jmp    802e5d <insert_sorted_with_merge_freeList+0x79>
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	a3 38 51 80 00       	mov    %eax,0x805138
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6f:	a1 44 51 80 00       	mov    0x805144,%eax
  802e74:	40                   	inc    %eax
  802e75:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e7e:	0f 84 a8 06 00 00    	je     80352c <insert_sorted_with_merge_freeList+0x748>
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	8b 50 08             	mov    0x8(%eax),%edx
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e90:	01 c2                	add    %eax,%edx
  802e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e95:	8b 40 08             	mov    0x8(%eax),%eax
  802e98:	39 c2                	cmp    %eax,%edx
  802e9a:	0f 85 8c 06 00 00    	jne    80352c <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea9:	8b 40 0c             	mov    0xc(%eax),%eax
  802eac:	01 c2                	add    %eax,%edx
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802eb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eb8:	75 17                	jne    802ed1 <insert_sorted_with_merge_freeList+0xed>
  802eba:	83 ec 04             	sub    $0x4,%esp
  802ebd:	68 e0 41 80 00       	push   $0x8041e0
  802ec2:	68 3c 01 00 00       	push   $0x13c
  802ec7:	68 37 41 80 00       	push   $0x804137
  802ecc:	e8 44 d4 ff ff       	call   800315 <_panic>
  802ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed4:	8b 00                	mov    (%eax),%eax
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	74 10                	je     802eea <insert_sorted_with_merge_freeList+0x106>
  802eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edd:	8b 00                	mov    (%eax),%eax
  802edf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee2:	8b 52 04             	mov    0x4(%edx),%edx
  802ee5:	89 50 04             	mov    %edx,0x4(%eax)
  802ee8:	eb 0b                	jmp    802ef5 <insert_sorted_with_merge_freeList+0x111>
  802eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eed:	8b 40 04             	mov    0x4(%eax),%eax
  802ef0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef8:	8b 40 04             	mov    0x4(%eax),%eax
  802efb:	85 c0                	test   %eax,%eax
  802efd:	74 0f                	je     802f0e <insert_sorted_with_merge_freeList+0x12a>
  802eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f02:	8b 40 04             	mov    0x4(%eax),%eax
  802f05:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f08:	8b 12                	mov    (%edx),%edx
  802f0a:	89 10                	mov    %edx,(%eax)
  802f0c:	eb 0a                	jmp    802f18 <insert_sorted_with_merge_freeList+0x134>
  802f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	a3 38 51 80 00       	mov    %eax,0x805138
  802f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2b:	a1 44 51 80 00       	mov    0x805144,%eax
  802f30:	48                   	dec    %eax
  802f31:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f39:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f4e:	75 17                	jne    802f67 <insert_sorted_with_merge_freeList+0x183>
  802f50:	83 ec 04             	sub    $0x4,%esp
  802f53:	68 14 41 80 00       	push   $0x804114
  802f58:	68 3f 01 00 00       	push   $0x13f
  802f5d:	68 37 41 80 00       	push   $0x804137
  802f62:	e8 ae d3 ff ff       	call   800315 <_panic>
  802f67:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f70:	89 10                	mov    %edx,(%eax)
  802f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f75:	8b 00                	mov    (%eax),%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	74 0d                	je     802f88 <insert_sorted_with_merge_freeList+0x1a4>
  802f7b:	a1 48 51 80 00       	mov    0x805148,%eax
  802f80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f83:	89 50 04             	mov    %edx,0x4(%eax)
  802f86:	eb 08                	jmp    802f90 <insert_sorted_with_merge_freeList+0x1ac>
  802f88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f93:	a3 48 51 80 00       	mov    %eax,0x805148
  802f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa2:	a1 54 51 80 00       	mov    0x805154,%eax
  802fa7:	40                   	inc    %eax
  802fa8:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fad:	e9 7a 05 00 00       	jmp    80352c <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	8b 50 08             	mov    0x8(%eax),%edx
  802fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbb:	8b 40 08             	mov    0x8(%eax),%eax
  802fbe:	39 c2                	cmp    %eax,%edx
  802fc0:	0f 82 14 01 00 00    	jb     8030da <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc9:	8b 50 08             	mov    0x8(%eax),%edx
  802fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd2:	01 c2                	add    %eax,%edx
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	8b 40 08             	mov    0x8(%eax),%eax
  802fda:	39 c2                	cmp    %eax,%edx
  802fdc:	0f 85 90 00 00 00    	jne    803072 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802fe2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe5:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fee:	01 c2                	add    %eax,%edx
  802ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff3:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80300a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300e:	75 17                	jne    803027 <insert_sorted_with_merge_freeList+0x243>
  803010:	83 ec 04             	sub    $0x4,%esp
  803013:	68 14 41 80 00       	push   $0x804114
  803018:	68 49 01 00 00       	push   $0x149
  80301d:	68 37 41 80 00       	push   $0x804137
  803022:	e8 ee d2 ff ff       	call   800315 <_panic>
  803027:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	89 10                	mov    %edx,(%eax)
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8b 00                	mov    (%eax),%eax
  803037:	85 c0                	test   %eax,%eax
  803039:	74 0d                	je     803048 <insert_sorted_with_merge_freeList+0x264>
  80303b:	a1 48 51 80 00       	mov    0x805148,%eax
  803040:	8b 55 08             	mov    0x8(%ebp),%edx
  803043:	89 50 04             	mov    %edx,0x4(%eax)
  803046:	eb 08                	jmp    803050 <insert_sorted_with_merge_freeList+0x26c>
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	a3 48 51 80 00       	mov    %eax,0x805148
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803062:	a1 54 51 80 00       	mov    0x805154,%eax
  803067:	40                   	inc    %eax
  803068:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80306d:	e9 bb 04 00 00       	jmp    80352d <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803076:	75 17                	jne    80308f <insert_sorted_with_merge_freeList+0x2ab>
  803078:	83 ec 04             	sub    $0x4,%esp
  80307b:	68 88 41 80 00       	push   $0x804188
  803080:	68 4c 01 00 00       	push   $0x14c
  803085:	68 37 41 80 00       	push   $0x804137
  80308a:	e8 86 d2 ff ff       	call   800315 <_panic>
  80308f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	89 50 04             	mov    %edx,0x4(%eax)
  80309b:	8b 45 08             	mov    0x8(%ebp),%eax
  80309e:	8b 40 04             	mov    0x4(%eax),%eax
  8030a1:	85 c0                	test   %eax,%eax
  8030a3:	74 0c                	je     8030b1 <insert_sorted_with_merge_freeList+0x2cd>
  8030a5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ad:	89 10                	mov    %edx,(%eax)
  8030af:	eb 08                	jmp    8030b9 <insert_sorted_with_merge_freeList+0x2d5>
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ca:	a1 44 51 80 00       	mov    0x805144,%eax
  8030cf:	40                   	inc    %eax
  8030d0:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030d5:	e9 53 04 00 00       	jmp    80352d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030da:	a1 38 51 80 00       	mov    0x805138,%eax
  8030df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e2:	e9 15 04 00 00       	jmp    8034fc <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	8b 00                	mov    (%eax),%eax
  8030ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	8b 50 08             	mov    0x8(%eax),%edx
  8030f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f8:	8b 40 08             	mov    0x8(%eax),%eax
  8030fb:	39 c2                	cmp    %eax,%edx
  8030fd:	0f 86 f1 03 00 00    	jbe    8034f4 <insert_sorted_with_merge_freeList+0x710>
  803103:	8b 45 08             	mov    0x8(%ebp),%eax
  803106:	8b 50 08             	mov    0x8(%eax),%edx
  803109:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310c:	8b 40 08             	mov    0x8(%eax),%eax
  80310f:	39 c2                	cmp    %eax,%edx
  803111:	0f 83 dd 03 00 00    	jae    8034f4 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	8b 50 08             	mov    0x8(%eax),%edx
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	8b 40 0c             	mov    0xc(%eax),%eax
  803123:	01 c2                	add    %eax,%edx
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	8b 40 08             	mov    0x8(%eax),%eax
  80312b:	39 c2                	cmp    %eax,%edx
  80312d:	0f 85 b9 01 00 00    	jne    8032ec <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	8b 50 08             	mov    0x8(%eax),%edx
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	8b 40 0c             	mov    0xc(%eax),%eax
  80313f:	01 c2                	add    %eax,%edx
  803141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803144:	8b 40 08             	mov    0x8(%eax),%eax
  803147:	39 c2                	cmp    %eax,%edx
  803149:	0f 85 0d 01 00 00    	jne    80325c <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 50 0c             	mov    0xc(%eax),%edx
  803155:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803158:	8b 40 0c             	mov    0xc(%eax),%eax
  80315b:	01 c2                	add    %eax,%edx
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803163:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803167:	75 17                	jne    803180 <insert_sorted_with_merge_freeList+0x39c>
  803169:	83 ec 04             	sub    $0x4,%esp
  80316c:	68 e0 41 80 00       	push   $0x8041e0
  803171:	68 5c 01 00 00       	push   $0x15c
  803176:	68 37 41 80 00       	push   $0x804137
  80317b:	e8 95 d1 ff ff       	call   800315 <_panic>
  803180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	85 c0                	test   %eax,%eax
  803187:	74 10                	je     803199 <insert_sorted_with_merge_freeList+0x3b5>
  803189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318c:	8b 00                	mov    (%eax),%eax
  80318e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803191:	8b 52 04             	mov    0x4(%edx),%edx
  803194:	89 50 04             	mov    %edx,0x4(%eax)
  803197:	eb 0b                	jmp    8031a4 <insert_sorted_with_merge_freeList+0x3c0>
  803199:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319c:	8b 40 04             	mov    0x4(%eax),%eax
  80319f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a7:	8b 40 04             	mov    0x4(%eax),%eax
  8031aa:	85 c0                	test   %eax,%eax
  8031ac:	74 0f                	je     8031bd <insert_sorted_with_merge_freeList+0x3d9>
  8031ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b1:	8b 40 04             	mov    0x4(%eax),%eax
  8031b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b7:	8b 12                	mov    (%edx),%edx
  8031b9:	89 10                	mov    %edx,(%eax)
  8031bb:	eb 0a                	jmp    8031c7 <insert_sorted_with_merge_freeList+0x3e3>
  8031bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c0:	8b 00                	mov    (%eax),%eax
  8031c2:	a3 38 51 80 00       	mov    %eax,0x805138
  8031c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031da:	a1 44 51 80 00       	mov    0x805144,%eax
  8031df:	48                   	dec    %eax
  8031e0:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031fd:	75 17                	jne    803216 <insert_sorted_with_merge_freeList+0x432>
  8031ff:	83 ec 04             	sub    $0x4,%esp
  803202:	68 14 41 80 00       	push   $0x804114
  803207:	68 5f 01 00 00       	push   $0x15f
  80320c:	68 37 41 80 00       	push   $0x804137
  803211:	e8 ff d0 ff ff       	call   800315 <_panic>
  803216:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80321c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321f:	89 10                	mov    %edx,(%eax)
  803221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	85 c0                	test   %eax,%eax
  803228:	74 0d                	je     803237 <insert_sorted_with_merge_freeList+0x453>
  80322a:	a1 48 51 80 00       	mov    0x805148,%eax
  80322f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803232:	89 50 04             	mov    %edx,0x4(%eax)
  803235:	eb 08                	jmp    80323f <insert_sorted_with_merge_freeList+0x45b>
  803237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80323f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803242:	a3 48 51 80 00       	mov    %eax,0x805148
  803247:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803251:	a1 54 51 80 00       	mov    0x805154,%eax
  803256:	40                   	inc    %eax
  803257:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80325c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325f:	8b 50 0c             	mov    0xc(%eax),%edx
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	8b 40 0c             	mov    0xc(%eax),%eax
  803268:	01 c2                	add    %eax,%edx
  80326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803284:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803288:	75 17                	jne    8032a1 <insert_sorted_with_merge_freeList+0x4bd>
  80328a:	83 ec 04             	sub    $0x4,%esp
  80328d:	68 14 41 80 00       	push   $0x804114
  803292:	68 64 01 00 00       	push   $0x164
  803297:	68 37 41 80 00       	push   $0x804137
  80329c:	e8 74 d0 ff ff       	call   800315 <_panic>
  8032a1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032aa:	89 10                	mov    %edx,(%eax)
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	85 c0                	test   %eax,%eax
  8032b3:	74 0d                	je     8032c2 <insert_sorted_with_merge_freeList+0x4de>
  8032b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bd:	89 50 04             	mov    %edx,0x4(%eax)
  8032c0:	eb 08                	jmp    8032ca <insert_sorted_with_merge_freeList+0x4e6>
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	a3 48 51 80 00       	mov    %eax,0x805148
  8032d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032dc:	a1 54 51 80 00       	mov    0x805154,%eax
  8032e1:	40                   	inc    %eax
  8032e2:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032e7:	e9 41 02 00 00       	jmp    80352d <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ef:	8b 50 08             	mov    0x8(%eax),%edx
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f8:	01 c2                	add    %eax,%edx
  8032fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fd:	8b 40 08             	mov    0x8(%eax),%eax
  803300:	39 c2                	cmp    %eax,%edx
  803302:	0f 85 7c 01 00 00    	jne    803484 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803308:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80330c:	74 06                	je     803314 <insert_sorted_with_merge_freeList+0x530>
  80330e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803312:	75 17                	jne    80332b <insert_sorted_with_merge_freeList+0x547>
  803314:	83 ec 04             	sub    $0x4,%esp
  803317:	68 50 41 80 00       	push   $0x804150
  80331c:	68 69 01 00 00       	push   $0x169
  803321:	68 37 41 80 00       	push   $0x804137
  803326:	e8 ea cf ff ff       	call   800315 <_panic>
  80332b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332e:	8b 50 04             	mov    0x4(%eax),%edx
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	89 50 04             	mov    %edx,0x4(%eax)
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333d:	89 10                	mov    %edx,(%eax)
  80333f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803342:	8b 40 04             	mov    0x4(%eax),%eax
  803345:	85 c0                	test   %eax,%eax
  803347:	74 0d                	je     803356 <insert_sorted_with_merge_freeList+0x572>
  803349:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334c:	8b 40 04             	mov    0x4(%eax),%eax
  80334f:	8b 55 08             	mov    0x8(%ebp),%edx
  803352:	89 10                	mov    %edx,(%eax)
  803354:	eb 08                	jmp    80335e <insert_sorted_with_merge_freeList+0x57a>
  803356:	8b 45 08             	mov    0x8(%ebp),%eax
  803359:	a3 38 51 80 00       	mov    %eax,0x805138
  80335e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803361:	8b 55 08             	mov    0x8(%ebp),%edx
  803364:	89 50 04             	mov    %edx,0x4(%eax)
  803367:	a1 44 51 80 00       	mov    0x805144,%eax
  80336c:	40                   	inc    %eax
  80336d:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	8b 50 0c             	mov    0xc(%eax),%edx
  803378:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337b:	8b 40 0c             	mov    0xc(%eax),%eax
  80337e:	01 c2                	add    %eax,%edx
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803386:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80338a:	75 17                	jne    8033a3 <insert_sorted_with_merge_freeList+0x5bf>
  80338c:	83 ec 04             	sub    $0x4,%esp
  80338f:	68 e0 41 80 00       	push   $0x8041e0
  803394:	68 6b 01 00 00       	push   $0x16b
  803399:	68 37 41 80 00       	push   $0x804137
  80339e:	e8 72 cf ff ff       	call   800315 <_panic>
  8033a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a6:	8b 00                	mov    (%eax),%eax
  8033a8:	85 c0                	test   %eax,%eax
  8033aa:	74 10                	je     8033bc <insert_sorted_with_merge_freeList+0x5d8>
  8033ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b4:	8b 52 04             	mov    0x4(%edx),%edx
  8033b7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ba:	eb 0b                	jmp    8033c7 <insert_sorted_with_merge_freeList+0x5e3>
  8033bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bf:	8b 40 04             	mov    0x4(%eax),%eax
  8033c2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ca:	8b 40 04             	mov    0x4(%eax),%eax
  8033cd:	85 c0                	test   %eax,%eax
  8033cf:	74 0f                	je     8033e0 <insert_sorted_with_merge_freeList+0x5fc>
  8033d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d4:	8b 40 04             	mov    0x4(%eax),%eax
  8033d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033da:	8b 12                	mov    (%edx),%edx
  8033dc:	89 10                	mov    %edx,(%eax)
  8033de:	eb 0a                	jmp    8033ea <insert_sorted_with_merge_freeList+0x606>
  8033e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e3:	8b 00                	mov    (%eax),%eax
  8033e5:	a3 38 51 80 00       	mov    %eax,0x805138
  8033ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033fd:	a1 44 51 80 00       	mov    0x805144,%eax
  803402:	48                   	dec    %eax
  803403:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803408:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803412:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803415:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80341c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803420:	75 17                	jne    803439 <insert_sorted_with_merge_freeList+0x655>
  803422:	83 ec 04             	sub    $0x4,%esp
  803425:	68 14 41 80 00       	push   $0x804114
  80342a:	68 6e 01 00 00       	push   $0x16e
  80342f:	68 37 41 80 00       	push   $0x804137
  803434:	e8 dc ce ff ff       	call   800315 <_panic>
  803439:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80343f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803442:	89 10                	mov    %edx,(%eax)
  803444:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803447:	8b 00                	mov    (%eax),%eax
  803449:	85 c0                	test   %eax,%eax
  80344b:	74 0d                	je     80345a <insert_sorted_with_merge_freeList+0x676>
  80344d:	a1 48 51 80 00       	mov    0x805148,%eax
  803452:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803455:	89 50 04             	mov    %edx,0x4(%eax)
  803458:	eb 08                	jmp    803462 <insert_sorted_with_merge_freeList+0x67e>
  80345a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803462:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803465:	a3 48 51 80 00       	mov    %eax,0x805148
  80346a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803474:	a1 54 51 80 00       	mov    0x805154,%eax
  803479:	40                   	inc    %eax
  80347a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80347f:	e9 a9 00 00 00       	jmp    80352d <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803488:	74 06                	je     803490 <insert_sorted_with_merge_freeList+0x6ac>
  80348a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80348e:	75 17                	jne    8034a7 <insert_sorted_with_merge_freeList+0x6c3>
  803490:	83 ec 04             	sub    $0x4,%esp
  803493:	68 ac 41 80 00       	push   $0x8041ac
  803498:	68 73 01 00 00       	push   $0x173
  80349d:	68 37 41 80 00       	push   $0x804137
  8034a2:	e8 6e ce ff ff       	call   800315 <_panic>
  8034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034aa:	8b 10                	mov    (%eax),%edx
  8034ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8034af:	89 10                	mov    %edx,(%eax)
  8034b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b4:	8b 00                	mov    (%eax),%eax
  8034b6:	85 c0                	test   %eax,%eax
  8034b8:	74 0b                	je     8034c5 <insert_sorted_with_merge_freeList+0x6e1>
  8034ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bd:	8b 00                	mov    (%eax),%eax
  8034bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c2:	89 50 04             	mov    %edx,0x4(%eax)
  8034c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cb:	89 10                	mov    %edx,(%eax)
  8034cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d3:	89 50 04             	mov    %edx,0x4(%eax)
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	8b 00                	mov    (%eax),%eax
  8034db:	85 c0                	test   %eax,%eax
  8034dd:	75 08                	jne    8034e7 <insert_sorted_with_merge_freeList+0x703>
  8034df:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034e7:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ec:	40                   	inc    %eax
  8034ed:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034f2:	eb 39                	jmp    80352d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034f4:	a1 40 51 80 00       	mov    0x805140,%eax
  8034f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803500:	74 07                	je     803509 <insert_sorted_with_merge_freeList+0x725>
  803502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803505:	8b 00                	mov    (%eax),%eax
  803507:	eb 05                	jmp    80350e <insert_sorted_with_merge_freeList+0x72a>
  803509:	b8 00 00 00 00       	mov    $0x0,%eax
  80350e:	a3 40 51 80 00       	mov    %eax,0x805140
  803513:	a1 40 51 80 00       	mov    0x805140,%eax
  803518:	85 c0                	test   %eax,%eax
  80351a:	0f 85 c7 fb ff ff    	jne    8030e7 <insert_sorted_with_merge_freeList+0x303>
  803520:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803524:	0f 85 bd fb ff ff    	jne    8030e7 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80352a:	eb 01                	jmp    80352d <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80352c:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80352d:	90                   	nop
  80352e:	c9                   	leave  
  80352f:	c3                   	ret    

00803530 <__udivdi3>:
  803530:	55                   	push   %ebp
  803531:	57                   	push   %edi
  803532:	56                   	push   %esi
  803533:	53                   	push   %ebx
  803534:	83 ec 1c             	sub    $0x1c,%esp
  803537:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80353b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80353f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803543:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803547:	89 ca                	mov    %ecx,%edx
  803549:	89 f8                	mov    %edi,%eax
  80354b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80354f:	85 f6                	test   %esi,%esi
  803551:	75 2d                	jne    803580 <__udivdi3+0x50>
  803553:	39 cf                	cmp    %ecx,%edi
  803555:	77 65                	ja     8035bc <__udivdi3+0x8c>
  803557:	89 fd                	mov    %edi,%ebp
  803559:	85 ff                	test   %edi,%edi
  80355b:	75 0b                	jne    803568 <__udivdi3+0x38>
  80355d:	b8 01 00 00 00       	mov    $0x1,%eax
  803562:	31 d2                	xor    %edx,%edx
  803564:	f7 f7                	div    %edi
  803566:	89 c5                	mov    %eax,%ebp
  803568:	31 d2                	xor    %edx,%edx
  80356a:	89 c8                	mov    %ecx,%eax
  80356c:	f7 f5                	div    %ebp
  80356e:	89 c1                	mov    %eax,%ecx
  803570:	89 d8                	mov    %ebx,%eax
  803572:	f7 f5                	div    %ebp
  803574:	89 cf                	mov    %ecx,%edi
  803576:	89 fa                	mov    %edi,%edx
  803578:	83 c4 1c             	add    $0x1c,%esp
  80357b:	5b                   	pop    %ebx
  80357c:	5e                   	pop    %esi
  80357d:	5f                   	pop    %edi
  80357e:	5d                   	pop    %ebp
  80357f:	c3                   	ret    
  803580:	39 ce                	cmp    %ecx,%esi
  803582:	77 28                	ja     8035ac <__udivdi3+0x7c>
  803584:	0f bd fe             	bsr    %esi,%edi
  803587:	83 f7 1f             	xor    $0x1f,%edi
  80358a:	75 40                	jne    8035cc <__udivdi3+0x9c>
  80358c:	39 ce                	cmp    %ecx,%esi
  80358e:	72 0a                	jb     80359a <__udivdi3+0x6a>
  803590:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803594:	0f 87 9e 00 00 00    	ja     803638 <__udivdi3+0x108>
  80359a:	b8 01 00 00 00       	mov    $0x1,%eax
  80359f:	89 fa                	mov    %edi,%edx
  8035a1:	83 c4 1c             	add    $0x1c,%esp
  8035a4:	5b                   	pop    %ebx
  8035a5:	5e                   	pop    %esi
  8035a6:	5f                   	pop    %edi
  8035a7:	5d                   	pop    %ebp
  8035a8:	c3                   	ret    
  8035a9:	8d 76 00             	lea    0x0(%esi),%esi
  8035ac:	31 ff                	xor    %edi,%edi
  8035ae:	31 c0                	xor    %eax,%eax
  8035b0:	89 fa                	mov    %edi,%edx
  8035b2:	83 c4 1c             	add    $0x1c,%esp
  8035b5:	5b                   	pop    %ebx
  8035b6:	5e                   	pop    %esi
  8035b7:	5f                   	pop    %edi
  8035b8:	5d                   	pop    %ebp
  8035b9:	c3                   	ret    
  8035ba:	66 90                	xchg   %ax,%ax
  8035bc:	89 d8                	mov    %ebx,%eax
  8035be:	f7 f7                	div    %edi
  8035c0:	31 ff                	xor    %edi,%edi
  8035c2:	89 fa                	mov    %edi,%edx
  8035c4:	83 c4 1c             	add    $0x1c,%esp
  8035c7:	5b                   	pop    %ebx
  8035c8:	5e                   	pop    %esi
  8035c9:	5f                   	pop    %edi
  8035ca:	5d                   	pop    %ebp
  8035cb:	c3                   	ret    
  8035cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035d1:	89 eb                	mov    %ebp,%ebx
  8035d3:	29 fb                	sub    %edi,%ebx
  8035d5:	89 f9                	mov    %edi,%ecx
  8035d7:	d3 e6                	shl    %cl,%esi
  8035d9:	89 c5                	mov    %eax,%ebp
  8035db:	88 d9                	mov    %bl,%cl
  8035dd:	d3 ed                	shr    %cl,%ebp
  8035df:	89 e9                	mov    %ebp,%ecx
  8035e1:	09 f1                	or     %esi,%ecx
  8035e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035e7:	89 f9                	mov    %edi,%ecx
  8035e9:	d3 e0                	shl    %cl,%eax
  8035eb:	89 c5                	mov    %eax,%ebp
  8035ed:	89 d6                	mov    %edx,%esi
  8035ef:	88 d9                	mov    %bl,%cl
  8035f1:	d3 ee                	shr    %cl,%esi
  8035f3:	89 f9                	mov    %edi,%ecx
  8035f5:	d3 e2                	shl    %cl,%edx
  8035f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035fb:	88 d9                	mov    %bl,%cl
  8035fd:	d3 e8                	shr    %cl,%eax
  8035ff:	09 c2                	or     %eax,%edx
  803601:	89 d0                	mov    %edx,%eax
  803603:	89 f2                	mov    %esi,%edx
  803605:	f7 74 24 0c          	divl   0xc(%esp)
  803609:	89 d6                	mov    %edx,%esi
  80360b:	89 c3                	mov    %eax,%ebx
  80360d:	f7 e5                	mul    %ebp
  80360f:	39 d6                	cmp    %edx,%esi
  803611:	72 19                	jb     80362c <__udivdi3+0xfc>
  803613:	74 0b                	je     803620 <__udivdi3+0xf0>
  803615:	89 d8                	mov    %ebx,%eax
  803617:	31 ff                	xor    %edi,%edi
  803619:	e9 58 ff ff ff       	jmp    803576 <__udivdi3+0x46>
  80361e:	66 90                	xchg   %ax,%ax
  803620:	8b 54 24 08          	mov    0x8(%esp),%edx
  803624:	89 f9                	mov    %edi,%ecx
  803626:	d3 e2                	shl    %cl,%edx
  803628:	39 c2                	cmp    %eax,%edx
  80362a:	73 e9                	jae    803615 <__udivdi3+0xe5>
  80362c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80362f:	31 ff                	xor    %edi,%edi
  803631:	e9 40 ff ff ff       	jmp    803576 <__udivdi3+0x46>
  803636:	66 90                	xchg   %ax,%ax
  803638:	31 c0                	xor    %eax,%eax
  80363a:	e9 37 ff ff ff       	jmp    803576 <__udivdi3+0x46>
  80363f:	90                   	nop

00803640 <__umoddi3>:
  803640:	55                   	push   %ebp
  803641:	57                   	push   %edi
  803642:	56                   	push   %esi
  803643:	53                   	push   %ebx
  803644:	83 ec 1c             	sub    $0x1c,%esp
  803647:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80364b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80364f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803653:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803657:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80365b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80365f:	89 f3                	mov    %esi,%ebx
  803661:	89 fa                	mov    %edi,%edx
  803663:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803667:	89 34 24             	mov    %esi,(%esp)
  80366a:	85 c0                	test   %eax,%eax
  80366c:	75 1a                	jne    803688 <__umoddi3+0x48>
  80366e:	39 f7                	cmp    %esi,%edi
  803670:	0f 86 a2 00 00 00    	jbe    803718 <__umoddi3+0xd8>
  803676:	89 c8                	mov    %ecx,%eax
  803678:	89 f2                	mov    %esi,%edx
  80367a:	f7 f7                	div    %edi
  80367c:	89 d0                	mov    %edx,%eax
  80367e:	31 d2                	xor    %edx,%edx
  803680:	83 c4 1c             	add    $0x1c,%esp
  803683:	5b                   	pop    %ebx
  803684:	5e                   	pop    %esi
  803685:	5f                   	pop    %edi
  803686:	5d                   	pop    %ebp
  803687:	c3                   	ret    
  803688:	39 f0                	cmp    %esi,%eax
  80368a:	0f 87 ac 00 00 00    	ja     80373c <__umoddi3+0xfc>
  803690:	0f bd e8             	bsr    %eax,%ebp
  803693:	83 f5 1f             	xor    $0x1f,%ebp
  803696:	0f 84 ac 00 00 00    	je     803748 <__umoddi3+0x108>
  80369c:	bf 20 00 00 00       	mov    $0x20,%edi
  8036a1:	29 ef                	sub    %ebp,%edi
  8036a3:	89 fe                	mov    %edi,%esi
  8036a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036a9:	89 e9                	mov    %ebp,%ecx
  8036ab:	d3 e0                	shl    %cl,%eax
  8036ad:	89 d7                	mov    %edx,%edi
  8036af:	89 f1                	mov    %esi,%ecx
  8036b1:	d3 ef                	shr    %cl,%edi
  8036b3:	09 c7                	or     %eax,%edi
  8036b5:	89 e9                	mov    %ebp,%ecx
  8036b7:	d3 e2                	shl    %cl,%edx
  8036b9:	89 14 24             	mov    %edx,(%esp)
  8036bc:	89 d8                	mov    %ebx,%eax
  8036be:	d3 e0                	shl    %cl,%eax
  8036c0:	89 c2                	mov    %eax,%edx
  8036c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036c6:	d3 e0                	shl    %cl,%eax
  8036c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036d0:	89 f1                	mov    %esi,%ecx
  8036d2:	d3 e8                	shr    %cl,%eax
  8036d4:	09 d0                	or     %edx,%eax
  8036d6:	d3 eb                	shr    %cl,%ebx
  8036d8:	89 da                	mov    %ebx,%edx
  8036da:	f7 f7                	div    %edi
  8036dc:	89 d3                	mov    %edx,%ebx
  8036de:	f7 24 24             	mull   (%esp)
  8036e1:	89 c6                	mov    %eax,%esi
  8036e3:	89 d1                	mov    %edx,%ecx
  8036e5:	39 d3                	cmp    %edx,%ebx
  8036e7:	0f 82 87 00 00 00    	jb     803774 <__umoddi3+0x134>
  8036ed:	0f 84 91 00 00 00    	je     803784 <__umoddi3+0x144>
  8036f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036f7:	29 f2                	sub    %esi,%edx
  8036f9:	19 cb                	sbb    %ecx,%ebx
  8036fb:	89 d8                	mov    %ebx,%eax
  8036fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803701:	d3 e0                	shl    %cl,%eax
  803703:	89 e9                	mov    %ebp,%ecx
  803705:	d3 ea                	shr    %cl,%edx
  803707:	09 d0                	or     %edx,%eax
  803709:	89 e9                	mov    %ebp,%ecx
  80370b:	d3 eb                	shr    %cl,%ebx
  80370d:	89 da                	mov    %ebx,%edx
  80370f:	83 c4 1c             	add    $0x1c,%esp
  803712:	5b                   	pop    %ebx
  803713:	5e                   	pop    %esi
  803714:	5f                   	pop    %edi
  803715:	5d                   	pop    %ebp
  803716:	c3                   	ret    
  803717:	90                   	nop
  803718:	89 fd                	mov    %edi,%ebp
  80371a:	85 ff                	test   %edi,%edi
  80371c:	75 0b                	jne    803729 <__umoddi3+0xe9>
  80371e:	b8 01 00 00 00       	mov    $0x1,%eax
  803723:	31 d2                	xor    %edx,%edx
  803725:	f7 f7                	div    %edi
  803727:	89 c5                	mov    %eax,%ebp
  803729:	89 f0                	mov    %esi,%eax
  80372b:	31 d2                	xor    %edx,%edx
  80372d:	f7 f5                	div    %ebp
  80372f:	89 c8                	mov    %ecx,%eax
  803731:	f7 f5                	div    %ebp
  803733:	89 d0                	mov    %edx,%eax
  803735:	e9 44 ff ff ff       	jmp    80367e <__umoddi3+0x3e>
  80373a:	66 90                	xchg   %ax,%ax
  80373c:	89 c8                	mov    %ecx,%eax
  80373e:	89 f2                	mov    %esi,%edx
  803740:	83 c4 1c             	add    $0x1c,%esp
  803743:	5b                   	pop    %ebx
  803744:	5e                   	pop    %esi
  803745:	5f                   	pop    %edi
  803746:	5d                   	pop    %ebp
  803747:	c3                   	ret    
  803748:	3b 04 24             	cmp    (%esp),%eax
  80374b:	72 06                	jb     803753 <__umoddi3+0x113>
  80374d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803751:	77 0f                	ja     803762 <__umoddi3+0x122>
  803753:	89 f2                	mov    %esi,%edx
  803755:	29 f9                	sub    %edi,%ecx
  803757:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80375b:	89 14 24             	mov    %edx,(%esp)
  80375e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803762:	8b 44 24 04          	mov    0x4(%esp),%eax
  803766:	8b 14 24             	mov    (%esp),%edx
  803769:	83 c4 1c             	add    $0x1c,%esp
  80376c:	5b                   	pop    %ebx
  80376d:	5e                   	pop    %esi
  80376e:	5f                   	pop    %edi
  80376f:	5d                   	pop    %ebp
  803770:	c3                   	ret    
  803771:	8d 76 00             	lea    0x0(%esi),%esi
  803774:	2b 04 24             	sub    (%esp),%eax
  803777:	19 fa                	sbb    %edi,%edx
  803779:	89 d1                	mov    %edx,%ecx
  80377b:	89 c6                	mov    %eax,%esi
  80377d:	e9 71 ff ff ff       	jmp    8036f3 <__umoddi3+0xb3>
  803782:	66 90                	xchg   %ax,%ax
  803784:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803788:	72 ea                	jb     803774 <__umoddi3+0x134>
  80378a:	89 d9                	mov    %ebx,%ecx
  80378c:	e9 62 ff ff ff       	jmp    8036f3 <__umoddi3+0xb3>
