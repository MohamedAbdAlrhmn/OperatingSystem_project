
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
  80008c:	68 40 36 80 00       	push   $0x803640
  800091:	6a 14                	push   $0x14
  800093:	68 5c 36 80 00       	push   $0x80365c
  800098:	e8 78 02 00 00       	call   800315 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	if(STATIC_MEMBLOCK_ALLOC != 0)
		panic("STATIC_MEMBLOCK_ALLOC = 1 & it shall be 0. Go to 'inc/dynamic_allocator.h' and set STATIC_MEMBLOCK_ALLOC by 0. Then, repeat the test again.");

	int freeFrames_before = sys_calculate_free_frames() ;
  80009d:	e8 5c 17 00 00       	call   8017fe <sys_calculate_free_frames>
  8000a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeDiskFrames_before = sys_pf_calculate_allocated_pages() ;
  8000a5:	e8 f4 17 00 00       	call   80189e <sys_pf_calculate_allocated_pages>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	malloc(0);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	e8 9a 14 00 00       	call   801551 <malloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
	int freeFrames_after = sys_calculate_free_frames() ;
  8000ba:	e8 3f 17 00 00       	call   8017fe <sys_calculate_free_frames>
  8000bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freeDiskFrames_after = sys_pf_calculate_allocated_pages() ;
  8000c2:	e8 d7 17 00 00       	call   80189e <sys_pf_calculate_allocated_pages>
  8000c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Check MAX_MEM_BLOCK_CNT
	if(MAX_MEM_BLOCK_CNT != ((0xA0000000-0x80000000)/4096))
  8000ca:	a1 20 51 80 00       	mov    0x805120,%eax
  8000cf:	3d 00 00 02 00       	cmp    $0x20000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
	{
		panic("Wrong initialize: MAX_MEM_BLOCK_CNT is not set with the correct size of the array");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 70 36 80 00       	push   $0x803670
  8000de:	6a 23                	push   $0x23
  8000e0:	68 5c 36 80 00       	push   $0x80365c
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
  8000fd:	68 c4 36 80 00       	push   $0x8036c4
  800102:	6a 29                	push   $0x29
  800104:	68 5c 36 80 00       	push   $0x80365c
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
  80011a:	68 00 37 80 00       	push   $0x803700
  80011f:	6a 2f                	push   $0x2f
  800121:	68 5c 36 80 00       	push   $0x80365c
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
  800138:	68 38 37 80 00       	push   $0x803738
  80013d:	6a 35                	push   $0x35
  80013f:	68 5c 36 80 00       	push   $0x80365c
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
  800174:	68 70 37 80 00       	push   $0x803770
  800179:	6a 3c                	push   $0x3c
  80017b:	68 5c 36 80 00       	push   $0x80365c
  800180:	e8 90 01 00 00       	call   800315 <_panic>
	}

	//Check number of disk and memory frames
	if ((freeDiskFrames_after - freeDiskFrames_before) != 0) panic("Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)");
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80018b:	74 14                	je     8001a1 <_main+0x169>
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 ac 37 80 00       	push   $0x8037ac
  800195:	6a 40                	push   $0x40
  800197:	68 5c 36 80 00       	push   $0x80365c
  80019c:	e8 74 01 00 00       	call   800315 <_panic>
	if ((freeFrames_before - freeFrames_after) != 512 + 1) panic("Wrong allocation: pages are not loaded successfully into memory %d", (freeFrames_before - freeFrames_after));
  8001a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a7:	3d 01 02 00 00       	cmp    $0x201,%eax
  8001ac:	74 18                	je     8001c6 <_main+0x18e>
  8001ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	68 14 38 80 00       	push   $0x803814
  8001ba:	6a 41                	push   $0x41
  8001bc:	68 5c 36 80 00       	push   $0x80365c
  8001c1:	e8 4f 01 00 00       	call   800315 <_panic>

	/*=================================================*/

	cprintf("Congratulations!! test initialize_dyn_block_system of UHEAP completed successfully.\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 58 38 80 00       	push   $0x803858
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
  8001df:	e8 fa 18 00 00       	call   801ade <sys_getenvindex>
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
  80024a:	e8 9c 16 00 00       	call   8018eb <sys_disable_interrupt>
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 c8 38 80 00       	push   $0x8038c8
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
  80027a:	68 f0 38 80 00       	push   $0x8038f0
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
  8002ab:	68 18 39 80 00       	push   $0x803918
  8002b0:	e8 14 03 00 00       	call   8005c9 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 70 39 80 00       	push   $0x803970
  8002cc:	e8 f8 02 00 00       	call   8005c9 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	68 c8 38 80 00       	push   $0x8038c8
  8002dc:	e8 e8 02 00 00       	call   8005c9 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002e4:	e8 1c 16 00 00       	call   801905 <sys_enable_interrupt>

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
  8002fc:	e8 a9 17 00 00       	call   801aaa <sys_destroy_env>
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
  80030d:	e8 fe 17 00 00       	call   801b10 <sys_exit_env>
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
  800336:	68 84 39 80 00       	push   $0x803984
  80033b:	e8 89 02 00 00       	call   8005c9 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800343:	a1 00 50 80 00       	mov    0x805000,%eax
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 89 39 80 00       	push   $0x803989
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
  800373:	68 a5 39 80 00       	push   $0x8039a5
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
  80039f:	68 a8 39 80 00       	push   $0x8039a8
  8003a4:	6a 26                	push   $0x26
  8003a6:	68 f4 39 80 00       	push   $0x8039f4
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
  800471:	68 00 3a 80 00       	push   $0x803a00
  800476:	6a 3a                	push   $0x3a
  800478:	68 f4 39 80 00       	push   $0x8039f4
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
  8004e1:	68 54 3a 80 00       	push   $0x803a54
  8004e6:	6a 44                	push   $0x44
  8004e8:	68 f4 39 80 00       	push   $0x8039f4
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
  80053b:	e8 fd 11 00 00       	call   80173d <sys_cputs>
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
  8005b2:	e8 86 11 00 00       	call   80173d <sys_cputs>
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
  8005fc:	e8 ea 12 00 00       	call   8018eb <sys_disable_interrupt>
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
  80061c:	e8 e4 12 00 00       	call   801905 <sys_enable_interrupt>
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
  800666:	e8 55 2d 00 00       	call   8033c0 <__udivdi3>
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
  8006b6:	e8 15 2e 00 00       	call   8034d0 <__umoddi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	05 b4 3c 80 00       	add    $0x803cb4,%eax
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
  800811:	8b 04 85 d8 3c 80 00 	mov    0x803cd8(,%eax,4),%eax
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
  8008f2:	8b 34 9d 20 3b 80 00 	mov    0x803b20(,%ebx,4),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 19                	jne    800916 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	53                   	push   %ebx
  8008fe:	68 c5 3c 80 00       	push   $0x803cc5
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
  800917:	68 ce 3c 80 00       	push   $0x803cce
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
  800944:	be d1 3c 80 00       	mov    $0x803cd1,%esi
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
  80136a:	68 30 3e 80 00       	push   $0x803e30
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
  80143a:	e8 42 04 00 00       	call   801881 <sys_allocate_chunk>
  80143f:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801442:	a1 20 51 80 00       	mov    0x805120,%eax
  801447:	83 ec 0c             	sub    $0xc,%esp
  80144a:	50                   	push   %eax
  80144b:	e8 b7 0a 00 00       	call   801f07 <initialize_MemBlocksList>
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
  801478:	68 55 3e 80 00       	push   $0x803e55
  80147d:	6a 33                	push   $0x33
  80147f:	68 73 3e 80 00       	push   $0x803e73
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
  8014f7:	68 80 3e 80 00       	push   $0x803e80
  8014fc:	6a 34                	push   $0x34
  8014fe:	68 73 3e 80 00       	push   $0x803e73
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
  80156c:	68 a4 3e 80 00       	push   $0x803ea4
  801571:	6a 46                	push   $0x46
  801573:	68 73 3e 80 00       	push   $0x803e73
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
  801588:	68 cc 3e 80 00       	push   $0x803ecc
  80158d:	6a 61                	push   $0x61
  80158f:	68 73 3e 80 00       	push   $0x803e73
  801594:	e8 7c ed ff ff       	call   800315 <_panic>

00801599 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 38             	sub    $0x38,%esp
  80159f:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a2:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015a5:	e8 a9 fd ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015ae:	75 0a                	jne    8015ba <smalloc+0x21>
  8015b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b5:	e9 9e 00 00 00       	jmp    801658 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015ba:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c7:	01 d0                	add    %edx,%eax
  8015c9:	48                   	dec    %eax
  8015ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d5:	f7 75 f0             	divl   -0x10(%ebp)
  8015d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015db:	29 d0                	sub    %edx,%eax
  8015dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015e0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015e7:	e8 63 06 00 00       	call   801c4f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	74 11                	je     801601 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8015f0:	83 ec 0c             	sub    $0xc,%esp
  8015f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f6:	e8 ce 0c 00 00       	call   8022c9 <alloc_block_FF>
  8015fb:	83 c4 10             	add    $0x10,%esp
  8015fe:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801605:	74 4c                	je     801653 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160a:	8b 40 08             	mov    0x8(%eax),%eax
  80160d:	89 c2                	mov    %eax,%edx
  80160f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801613:	52                   	push   %edx
  801614:	50                   	push   %eax
  801615:	ff 75 0c             	pushl  0xc(%ebp)
  801618:	ff 75 08             	pushl  0x8(%ebp)
  80161b:	e8 b4 03 00 00       	call   8019d4 <sys_createSharedObject>
  801620:	83 c4 10             	add    $0x10,%esp
  801623:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801626:	83 ec 08             	sub    $0x8,%esp
  801629:	ff 75 e0             	pushl  -0x20(%ebp)
  80162c:	68 ef 3e 80 00       	push   $0x803eef
  801631:	e8 93 ef ff ff       	call   8005c9 <cprintf>
  801636:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801639:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80163d:	74 14                	je     801653 <smalloc+0xba>
  80163f:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801643:	74 0e                	je     801653 <smalloc+0xba>
  801645:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801649:	74 08                	je     801653 <smalloc+0xba>
			return (void*) mem_block->sva;
  80164b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164e:	8b 40 08             	mov    0x8(%eax),%eax
  801651:	eb 05                	jmp    801658 <smalloc+0xbf>
	}
	return NULL;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801660:	e8 ee fc ff ff       	call   801353 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	68 04 3f 80 00       	push   $0x803f04
  80166d:	68 ab 00 00 00       	push   $0xab
  801672:	68 73 3e 80 00       	push   $0x803e73
  801677:	e8 99 ec ff ff       	call   800315 <_panic>

0080167c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801682:	e8 cc fc ff ff       	call   801353 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	68 28 3f 80 00       	push   $0x803f28
  80168f:	68 ef 00 00 00       	push   $0xef
  801694:	68 73 3e 80 00       	push   $0x803e73
  801699:	e8 77 ec ff ff       	call   800315 <_panic>

0080169e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016a4:	83 ec 04             	sub    $0x4,%esp
  8016a7:	68 50 3f 80 00       	push   $0x803f50
  8016ac:	68 03 01 00 00       	push   $0x103
  8016b1:	68 73 3e 80 00       	push   $0x803e73
  8016b6:	e8 5a ec ff ff       	call   800315 <_panic>

008016bb <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016c1:	83 ec 04             	sub    $0x4,%esp
  8016c4:	68 74 3f 80 00       	push   $0x803f74
  8016c9:	68 0e 01 00 00       	push   $0x10e
  8016ce:	68 73 3e 80 00       	push   $0x803e73
  8016d3:	e8 3d ec ff ff       	call   800315 <_panic>

008016d8 <shrink>:

}
void shrink(uint32 newSize)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016de:	83 ec 04             	sub    $0x4,%esp
  8016e1:	68 74 3f 80 00       	push   $0x803f74
  8016e6:	68 13 01 00 00       	push   $0x113
  8016eb:	68 73 3e 80 00       	push   $0x803e73
  8016f0:	e8 20 ec ff ff       	call   800315 <_panic>

008016f5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	68 74 3f 80 00       	push   $0x803f74
  801703:	68 18 01 00 00       	push   $0x118
  801708:	68 73 3e 80 00       	push   $0x803e73
  80170d:	e8 03 ec ff ff       	call   800315 <_panic>

00801712 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	57                   	push   %edi
  801716:	56                   	push   %esi
  801717:	53                   	push   %ebx
  801718:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801721:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801724:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801727:	8b 7d 18             	mov    0x18(%ebp),%edi
  80172a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80172d:	cd 30                	int    $0x30
  80172f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801732:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5f                   	pop    %edi
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    

0080173d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801749:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	52                   	push   %edx
  801755:	ff 75 0c             	pushl  0xc(%ebp)
  801758:	50                   	push   %eax
  801759:	6a 00                	push   $0x0
  80175b:	e8 b2 ff ff ff       	call   801712 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	90                   	nop
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_cgetc>:

int
sys_cgetc(void)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 01                	push   $0x1
  801775:	e8 98 ff ff ff       	call   801712 <syscall>
  80177a:	83 c4 18             	add    $0x18,%esp
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801782:	8b 55 0c             	mov    0xc(%ebp),%edx
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	52                   	push   %edx
  80178f:	50                   	push   %eax
  801790:	6a 05                	push   $0x5
  801792:	e8 7b ff ff ff       	call   801712 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	56                   	push   %esi
  8017a0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017a1:	8b 75 18             	mov    0x18(%ebp),%esi
  8017a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	56                   	push   %esi
  8017b1:	53                   	push   %ebx
  8017b2:	51                   	push   %ecx
  8017b3:	52                   	push   %edx
  8017b4:	50                   	push   %eax
  8017b5:	6a 06                	push   $0x6
  8017b7:	e8 56 ff ff ff       	call   801712 <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
}
  8017bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c2:	5b                   	pop    %ebx
  8017c3:	5e                   	pop    %esi
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    

008017c6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	52                   	push   %edx
  8017d6:	50                   	push   %eax
  8017d7:	6a 07                	push   $0x7
  8017d9:	e8 34 ff ff ff       	call   801712 <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	ff 75 0c             	pushl  0xc(%ebp)
  8017ef:	ff 75 08             	pushl  0x8(%ebp)
  8017f2:	6a 08                	push   $0x8
  8017f4:	e8 19 ff ff ff       	call   801712 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 09                	push   $0x9
  80180d:	e8 00 ff ff ff       	call   801712 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 0a                	push   $0xa
  801826:	e8 e7 fe ff ff       	call   801712 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 0b                	push   $0xb
  80183f:	e8 ce fe ff ff       	call   801712 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	ff 75 0c             	pushl  0xc(%ebp)
  801855:	ff 75 08             	pushl  0x8(%ebp)
  801858:	6a 0f                	push   $0xf
  80185a:	e8 b3 fe ff ff       	call   801712 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
	return;
  801862:	90                   	nop
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	6a 10                	push   $0x10
  801876:	e8 97 fe ff ff       	call   801712 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
	return ;
  80187e:	90                   	nop
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	ff 75 10             	pushl  0x10(%ebp)
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	ff 75 08             	pushl  0x8(%ebp)
  801891:	6a 11                	push   $0x11
  801893:	e8 7a fe ff ff       	call   801712 <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
	return ;
  80189b:	90                   	nop
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 0c                	push   $0xc
  8018ad:	e8 60 fe ff ff       	call   801712 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	ff 75 08             	pushl  0x8(%ebp)
  8018c5:	6a 0d                	push   $0xd
  8018c7:	e8 46 fe ff ff       	call   801712 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 0e                	push   $0xe
  8018e0:	e8 2d fe ff ff       	call   801712 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	90                   	nop
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 13                	push   $0x13
  8018fa:	e8 13 fe ff ff       	call   801712 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	90                   	nop
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 14                	push   $0x14
  801914:	e8 f9 fd ff ff       	call   801712 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	90                   	nop
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_cputc>:


void
sys_cputc(const char c)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80192b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	50                   	push   %eax
  801938:	6a 15                	push   $0x15
  80193a:	e8 d3 fd ff ff       	call   801712 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	90                   	nop
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 16                	push   $0x16
  801954:	e8 b9 fd ff ff       	call   801712 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	90                   	nop
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	ff 75 0c             	pushl  0xc(%ebp)
  80196e:	50                   	push   %eax
  80196f:	6a 17                	push   $0x17
  801971:	e8 9c fd ff ff       	call   801712 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80197e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	52                   	push   %edx
  80198b:	50                   	push   %eax
  80198c:	6a 1a                	push   $0x1a
  80198e:	e8 7f fd ff ff       	call   801712 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80199b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	52                   	push   %edx
  8019a8:	50                   	push   %eax
  8019a9:	6a 18                	push   $0x18
  8019ab:	e8 62 fd ff ff       	call   801712 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	52                   	push   %edx
  8019c6:	50                   	push   %eax
  8019c7:	6a 19                	push   $0x19
  8019c9:	e8 44 fd ff ff       	call   801712 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	90                   	nop
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	8b 45 10             	mov    0x10(%ebp),%eax
  8019dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019e0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019e3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	6a 00                	push   $0x0
  8019ec:	51                   	push   %ecx
  8019ed:	52                   	push   %edx
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	50                   	push   %eax
  8019f2:	6a 1b                	push   $0x1b
  8019f4:	e8 19 fd ff ff       	call   801712 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	52                   	push   %edx
  801a0e:	50                   	push   %eax
  801a0f:	6a 1c                	push   $0x1c
  801a11:	e8 fc fc ff ff       	call   801712 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	51                   	push   %ecx
  801a2c:	52                   	push   %edx
  801a2d:	50                   	push   %eax
  801a2e:	6a 1d                	push   $0x1d
  801a30:	e8 dd fc ff ff       	call   801712 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	52                   	push   %edx
  801a4a:	50                   	push   %eax
  801a4b:	6a 1e                	push   $0x1e
  801a4d:	e8 c0 fc ff ff       	call   801712 <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 1f                	push   $0x1f
  801a66:	e8 a7 fc ff ff       	call   801712 <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	6a 00                	push   $0x0
  801a78:	ff 75 14             	pushl  0x14(%ebp)
  801a7b:	ff 75 10             	pushl  0x10(%ebp)
  801a7e:	ff 75 0c             	pushl  0xc(%ebp)
  801a81:	50                   	push   %eax
  801a82:	6a 20                	push   $0x20
  801a84:	e8 89 fc ff ff       	call   801712 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	50                   	push   %eax
  801a9d:	6a 21                	push   $0x21
  801a9f:	e8 6e fc ff ff       	call   801712 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	90                   	nop
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	50                   	push   %eax
  801ab9:	6a 22                	push   $0x22
  801abb:	e8 52 fc ff ff       	call   801712 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 02                	push   $0x2
  801ad4:	e8 39 fc ff ff       	call   801712 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 03                	push   $0x3
  801aed:	e8 20 fc ff ff       	call   801712 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 04                	push   $0x4
  801b06:	e8 07 fc ff ff       	call   801712 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_exit_env>:


void sys_exit_env(void)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 23                	push   $0x23
  801b1f:	e8 ee fb ff ff       	call   801712 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	90                   	nop
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b30:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b33:	8d 50 04             	lea    0x4(%eax),%edx
  801b36:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	52                   	push   %edx
  801b40:	50                   	push   %eax
  801b41:	6a 24                	push   $0x24
  801b43:	e8 ca fb ff ff       	call   801712 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
	return result;
  801b4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b51:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b54:	89 01                	mov    %eax,(%ecx)
  801b56:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	c9                   	leave  
  801b5d:	c2 04 00             	ret    $0x4

00801b60 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	ff 75 10             	pushl  0x10(%ebp)
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	ff 75 08             	pushl  0x8(%ebp)
  801b70:	6a 12                	push   $0x12
  801b72:	e8 9b fb ff ff       	call   801712 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7a:	90                   	nop
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_rcr2>:
uint32 sys_rcr2()
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 25                	push   $0x25
  801b8c:	e8 81 fb ff ff       	call   801712 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 04             	sub    $0x4,%esp
  801b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ba2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	50                   	push   %eax
  801baf:	6a 26                	push   $0x26
  801bb1:	e8 5c fb ff ff       	call   801712 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb9:	90                   	nop
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <rsttst>:
void rsttst()
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 28                	push   $0x28
  801bcb:	e8 42 fb ff ff       	call   801712 <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd3:	90                   	nop
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	8b 45 14             	mov    0x14(%ebp),%eax
  801bdf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801be2:	8b 55 18             	mov    0x18(%ebp),%edx
  801be5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be9:	52                   	push   %edx
  801bea:	50                   	push   %eax
  801beb:	ff 75 10             	pushl  0x10(%ebp)
  801bee:	ff 75 0c             	pushl  0xc(%ebp)
  801bf1:	ff 75 08             	pushl  0x8(%ebp)
  801bf4:	6a 27                	push   $0x27
  801bf6:	e8 17 fb ff ff       	call   801712 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfe:	90                   	nop
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <chktst>:
void chktst(uint32 n)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	6a 29                	push   $0x29
  801c11:	e8 fc fa ff ff       	call   801712 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
	return ;
  801c19:	90                   	nop
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <inctst>:

void inctst()
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 2a                	push   $0x2a
  801c2b:	e8 e2 fa ff ff       	call   801712 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
	return ;
  801c33:	90                   	nop
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <gettst>:
uint32 gettst()
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 2b                	push   $0x2b
  801c45:	e8 c8 fa ff ff       	call   801712 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 2c                	push   $0x2c
  801c61:	e8 ac fa ff ff       	call   801712 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
  801c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c6c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c70:	75 07                	jne    801c79 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c72:	b8 01 00 00 00       	mov    $0x1,%eax
  801c77:	eb 05                	jmp    801c7e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 2c                	push   $0x2c
  801c92:	e8 7b fa ff ff       	call   801712 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
  801c9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c9d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ca1:	75 07                	jne    801caa <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ca3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca8:	eb 05                	jmp    801caf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 2c                	push   $0x2c
  801cc3:	e8 4a fa ff ff       	call   801712 <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
  801ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cce:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cd2:	75 07                	jne    801cdb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cd4:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd9:	eb 05                	jmp    801ce0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 2c                	push   $0x2c
  801cf4:	e8 19 fa ff ff       	call   801712 <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
  801cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cff:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d03:	75 07                	jne    801d0c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d05:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0a:	eb 05                	jmp    801d11 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	ff 75 08             	pushl  0x8(%ebp)
  801d21:	6a 2d                	push   $0x2d
  801d23:	e8 ea f9 ff ff       	call   801712 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2b:	90                   	nop
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	6a 00                	push   $0x0
  801d40:	53                   	push   %ebx
  801d41:	51                   	push   %ecx
  801d42:	52                   	push   %edx
  801d43:	50                   	push   %eax
  801d44:	6a 2e                	push   $0x2e
  801d46:	e8 c7 f9 ff ff       	call   801712 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	52                   	push   %edx
  801d63:	50                   	push   %eax
  801d64:	6a 2f                	push   $0x2f
  801d66:	e8 a7 f9 ff ff       	call   801712 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d76:	83 ec 0c             	sub    $0xc,%esp
  801d79:	68 84 3f 80 00       	push   $0x803f84
  801d7e:	e8 46 e8 ff ff       	call   8005c9 <cprintf>
  801d83:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d86:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d8d:	83 ec 0c             	sub    $0xc,%esp
  801d90:	68 b0 3f 80 00       	push   $0x803fb0
  801d95:	e8 2f e8 ff ff       	call   8005c9 <cprintf>
  801d9a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d9d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801da1:	a1 38 51 80 00       	mov    0x805138,%eax
  801da6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da9:	eb 56                	jmp    801e01 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801daf:	74 1c                	je     801dcd <print_mem_block_lists+0x5d>
  801db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db4:	8b 50 08             	mov    0x8(%eax),%edx
  801db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dba:	8b 48 08             	mov    0x8(%eax),%ecx
  801dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc3:	01 c8                	add    %ecx,%eax
  801dc5:	39 c2                	cmp    %eax,%edx
  801dc7:	73 04                	jae    801dcd <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801dc9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd0:	8b 50 08             	mov    0x8(%eax),%edx
  801dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd6:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd9:	01 c2                	add    %eax,%edx
  801ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dde:	8b 40 08             	mov    0x8(%eax),%eax
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	52                   	push   %edx
  801de5:	50                   	push   %eax
  801de6:	68 c5 3f 80 00       	push   $0x803fc5
  801deb:	e8 d9 e7 ff ff       	call   8005c9 <cprintf>
  801df0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801df9:	a1 40 51 80 00       	mov    0x805140,%eax
  801dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e05:	74 07                	je     801e0e <print_mem_block_lists+0x9e>
  801e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0a:	8b 00                	mov    (%eax),%eax
  801e0c:	eb 05                	jmp    801e13 <print_mem_block_lists+0xa3>
  801e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e13:	a3 40 51 80 00       	mov    %eax,0x805140
  801e18:	a1 40 51 80 00       	mov    0x805140,%eax
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	75 8a                	jne    801dab <print_mem_block_lists+0x3b>
  801e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e25:	75 84                	jne    801dab <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e27:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e2b:	75 10                	jne    801e3d <print_mem_block_lists+0xcd>
  801e2d:	83 ec 0c             	sub    $0xc,%esp
  801e30:	68 d4 3f 80 00       	push   $0x803fd4
  801e35:	e8 8f e7 ff ff       	call   8005c9 <cprintf>
  801e3a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e3d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e44:	83 ec 0c             	sub    $0xc,%esp
  801e47:	68 f8 3f 80 00       	push   $0x803ff8
  801e4c:	e8 78 e7 ff ff       	call   8005c9 <cprintf>
  801e51:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e54:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e58:	a1 40 50 80 00       	mov    0x805040,%eax
  801e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e60:	eb 56                	jmp    801eb8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e66:	74 1c                	je     801e84 <print_mem_block_lists+0x114>
  801e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6b:	8b 50 08             	mov    0x8(%eax),%edx
  801e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e71:	8b 48 08             	mov    0x8(%eax),%ecx
  801e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e77:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7a:	01 c8                	add    %ecx,%eax
  801e7c:	39 c2                	cmp    %eax,%edx
  801e7e:	73 04                	jae    801e84 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e80:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e87:	8b 50 08             	mov    0x8(%eax),%edx
  801e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e90:	01 c2                	add    %eax,%edx
  801e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e95:	8b 40 08             	mov    0x8(%eax),%eax
  801e98:	83 ec 04             	sub    $0x4,%esp
  801e9b:	52                   	push   %edx
  801e9c:	50                   	push   %eax
  801e9d:	68 c5 3f 80 00       	push   $0x803fc5
  801ea2:	e8 22 e7 ff ff       	call   8005c9 <cprintf>
  801ea7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eb0:	a1 48 50 80 00       	mov    0x805048,%eax
  801eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ebc:	74 07                	je     801ec5 <print_mem_block_lists+0x155>
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	8b 00                	mov    (%eax),%eax
  801ec3:	eb 05                	jmp    801eca <print_mem_block_lists+0x15a>
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eca:	a3 48 50 80 00       	mov    %eax,0x805048
  801ecf:	a1 48 50 80 00       	mov    0x805048,%eax
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	75 8a                	jne    801e62 <print_mem_block_lists+0xf2>
  801ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801edc:	75 84                	jne    801e62 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ede:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ee2:	75 10                	jne    801ef4 <print_mem_block_lists+0x184>
  801ee4:	83 ec 0c             	sub    $0xc,%esp
  801ee7:	68 10 40 80 00       	push   $0x804010
  801eec:	e8 d8 e6 ff ff       	call   8005c9 <cprintf>
  801ef1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ef4:	83 ec 0c             	sub    $0xc,%esp
  801ef7:	68 84 3f 80 00       	push   $0x803f84
  801efc:	e8 c8 e6 ff ff       	call   8005c9 <cprintf>
  801f01:	83 c4 10             	add    $0x10,%esp

}
  801f04:	90                   	nop
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f0d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f14:	00 00 00 
  801f17:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f1e:	00 00 00 
  801f21:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f28:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f32:	e9 9e 00 00 00       	jmp    801fd5 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f37:	a1 50 50 80 00       	mov    0x805050,%eax
  801f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3f:	c1 e2 04             	shl    $0x4,%edx
  801f42:	01 d0                	add    %edx,%eax
  801f44:	85 c0                	test   %eax,%eax
  801f46:	75 14                	jne    801f5c <initialize_MemBlocksList+0x55>
  801f48:	83 ec 04             	sub    $0x4,%esp
  801f4b:	68 38 40 80 00       	push   $0x804038
  801f50:	6a 46                	push   $0x46
  801f52:	68 5b 40 80 00       	push   $0x80405b
  801f57:	e8 b9 e3 ff ff       	call   800315 <_panic>
  801f5c:	a1 50 50 80 00       	mov    0x805050,%eax
  801f61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f64:	c1 e2 04             	shl    $0x4,%edx
  801f67:	01 d0                	add    %edx,%eax
  801f69:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f6f:	89 10                	mov    %edx,(%eax)
  801f71:	8b 00                	mov    (%eax),%eax
  801f73:	85 c0                	test   %eax,%eax
  801f75:	74 18                	je     801f8f <initialize_MemBlocksList+0x88>
  801f77:	a1 48 51 80 00       	mov    0x805148,%eax
  801f7c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f82:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f85:	c1 e1 04             	shl    $0x4,%ecx
  801f88:	01 ca                	add    %ecx,%edx
  801f8a:	89 50 04             	mov    %edx,0x4(%eax)
  801f8d:	eb 12                	jmp    801fa1 <initialize_MemBlocksList+0x9a>
  801f8f:	a1 50 50 80 00       	mov    0x805050,%eax
  801f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f97:	c1 e2 04             	shl    $0x4,%edx
  801f9a:	01 d0                	add    %edx,%eax
  801f9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fa1:	a1 50 50 80 00       	mov    0x805050,%eax
  801fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa9:	c1 e2 04             	shl    $0x4,%edx
  801fac:	01 d0                	add    %edx,%eax
  801fae:	a3 48 51 80 00       	mov    %eax,0x805148
  801fb3:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbb:	c1 e2 04             	shl    $0x4,%edx
  801fbe:	01 d0                	add    %edx,%eax
  801fc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc7:	a1 54 51 80 00       	mov    0x805154,%eax
  801fcc:	40                   	inc    %eax
  801fcd:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fd2:	ff 45 f4             	incl   -0xc(%ebp)
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fdb:	0f 82 56 ff ff ff    	jb     801f37 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fe1:	90                   	nop
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	8b 00                	mov    (%eax),%eax
  801fef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ff2:	eb 19                	jmp    80200d <find_block+0x29>
	{
		if(va==point->sva)
  801ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff7:	8b 40 08             	mov    0x8(%eax),%eax
  801ffa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ffd:	75 05                	jne    802004 <find_block+0x20>
		   return point;
  801fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802002:	eb 36                	jmp    80203a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	8b 40 08             	mov    0x8(%eax),%eax
  80200a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80200d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802011:	74 07                	je     80201a <find_block+0x36>
  802013:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802016:	8b 00                	mov    (%eax),%eax
  802018:	eb 05                	jmp    80201f <find_block+0x3b>
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
  80201f:	8b 55 08             	mov    0x8(%ebp),%edx
  802022:	89 42 08             	mov    %eax,0x8(%edx)
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	8b 40 08             	mov    0x8(%eax),%eax
  80202b:	85 c0                	test   %eax,%eax
  80202d:	75 c5                	jne    801ff4 <find_block+0x10>
  80202f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802033:	75 bf                	jne    801ff4 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802035:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802042:	a1 40 50 80 00       	mov    0x805040,%eax
  802047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80204a:	a1 44 50 80 00       	mov    0x805044,%eax
  80204f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802055:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802058:	74 24                	je     80207e <insert_sorted_allocList+0x42>
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	8b 50 08             	mov    0x8(%eax),%edx
  802060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802063:	8b 40 08             	mov    0x8(%eax),%eax
  802066:	39 c2                	cmp    %eax,%edx
  802068:	76 14                	jbe    80207e <insert_sorted_allocList+0x42>
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	8b 50 08             	mov    0x8(%eax),%edx
  802070:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802073:	8b 40 08             	mov    0x8(%eax),%eax
  802076:	39 c2                	cmp    %eax,%edx
  802078:	0f 82 60 01 00 00    	jb     8021de <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80207e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802082:	75 65                	jne    8020e9 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802084:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802088:	75 14                	jne    80209e <insert_sorted_allocList+0x62>
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	68 38 40 80 00       	push   $0x804038
  802092:	6a 6b                	push   $0x6b
  802094:	68 5b 40 80 00       	push   $0x80405b
  802099:	e8 77 e2 ff ff       	call   800315 <_panic>
  80209e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	89 10                	mov    %edx,(%eax)
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	8b 00                	mov    (%eax),%eax
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	74 0d                	je     8020bf <insert_sorted_allocList+0x83>
  8020b2:	a1 40 50 80 00       	mov    0x805040,%eax
  8020b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ba:	89 50 04             	mov    %edx,0x4(%eax)
  8020bd:	eb 08                	jmp    8020c7 <insert_sorted_allocList+0x8b>
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	a3 44 50 80 00       	mov    %eax,0x805044
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	a3 40 50 80 00       	mov    %eax,0x805040
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020de:	40                   	inc    %eax
  8020df:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020e4:	e9 dc 01 00 00       	jmp    8022c5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	8b 50 08             	mov    0x8(%eax),%edx
  8020ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f2:	8b 40 08             	mov    0x8(%eax),%eax
  8020f5:	39 c2                	cmp    %eax,%edx
  8020f7:	77 6c                	ja     802165 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020fd:	74 06                	je     802105 <insert_sorted_allocList+0xc9>
  8020ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802103:	75 14                	jne    802119 <insert_sorted_allocList+0xdd>
  802105:	83 ec 04             	sub    $0x4,%esp
  802108:	68 74 40 80 00       	push   $0x804074
  80210d:	6a 6f                	push   $0x6f
  80210f:	68 5b 40 80 00       	push   $0x80405b
  802114:	e8 fc e1 ff ff       	call   800315 <_panic>
  802119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211c:	8b 50 04             	mov    0x4(%eax),%edx
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	89 50 04             	mov    %edx,0x4(%eax)
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80212b:	89 10                	mov    %edx,(%eax)
  80212d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802130:	8b 40 04             	mov    0x4(%eax),%eax
  802133:	85 c0                	test   %eax,%eax
  802135:	74 0d                	je     802144 <insert_sorted_allocList+0x108>
  802137:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213a:	8b 40 04             	mov    0x4(%eax),%eax
  80213d:	8b 55 08             	mov    0x8(%ebp),%edx
  802140:	89 10                	mov    %edx,(%eax)
  802142:	eb 08                	jmp    80214c <insert_sorted_allocList+0x110>
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	a3 40 50 80 00       	mov    %eax,0x805040
  80214c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214f:	8b 55 08             	mov    0x8(%ebp),%edx
  802152:	89 50 04             	mov    %edx,0x4(%eax)
  802155:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80215a:	40                   	inc    %eax
  80215b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802160:	e9 60 01 00 00       	jmp    8022c5 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	8b 50 08             	mov    0x8(%eax),%edx
  80216b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216e:	8b 40 08             	mov    0x8(%eax),%eax
  802171:	39 c2                	cmp    %eax,%edx
  802173:	0f 82 4c 01 00 00    	jb     8022c5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802179:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80217d:	75 14                	jne    802193 <insert_sorted_allocList+0x157>
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	68 ac 40 80 00       	push   $0x8040ac
  802187:	6a 73                	push   $0x73
  802189:	68 5b 40 80 00       	push   $0x80405b
  80218e:	e8 82 e1 ff ff       	call   800315 <_panic>
  802193:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	89 50 04             	mov    %edx,0x4(%eax)
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	8b 40 04             	mov    0x4(%eax),%eax
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	74 0c                	je     8021b5 <insert_sorted_allocList+0x179>
  8021a9:	a1 44 50 80 00       	mov    0x805044,%eax
  8021ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b1:	89 10                	mov    %edx,(%eax)
  8021b3:	eb 08                	jmp    8021bd <insert_sorted_allocList+0x181>
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	a3 40 50 80 00       	mov    %eax,0x805040
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	a3 44 50 80 00       	mov    %eax,0x805044
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ce:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021d3:	40                   	inc    %eax
  8021d4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021d9:	e9 e7 00 00 00       	jmp    8022c5 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021e4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021eb:	a1 40 50 80 00       	mov    0x805040,%eax
  8021f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f3:	e9 9d 00 00 00       	jmp    802295 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fb:	8b 00                	mov    (%eax),%eax
  8021fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	8b 50 08             	mov    0x8(%eax),%edx
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 40 08             	mov    0x8(%eax),%eax
  80220c:	39 c2                	cmp    %eax,%edx
  80220e:	76 7d                	jbe    80228d <insert_sorted_allocList+0x251>
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	8b 50 08             	mov    0x8(%eax),%edx
  802216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802219:	8b 40 08             	mov    0x8(%eax),%eax
  80221c:	39 c2                	cmp    %eax,%edx
  80221e:	73 6d                	jae    80228d <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802220:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802224:	74 06                	je     80222c <insert_sorted_allocList+0x1f0>
  802226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80222a:	75 14                	jne    802240 <insert_sorted_allocList+0x204>
  80222c:	83 ec 04             	sub    $0x4,%esp
  80222f:	68 d0 40 80 00       	push   $0x8040d0
  802234:	6a 7f                	push   $0x7f
  802236:	68 5b 40 80 00       	push   $0x80405b
  80223b:	e8 d5 e0 ff ff       	call   800315 <_panic>
  802240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802243:	8b 10                	mov    (%eax),%edx
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	89 10                	mov    %edx,(%eax)
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	85 c0                	test   %eax,%eax
  802251:	74 0b                	je     80225e <insert_sorted_allocList+0x222>
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 00                	mov    (%eax),%eax
  802258:	8b 55 08             	mov    0x8(%ebp),%edx
  80225b:	89 50 04             	mov    %edx,0x4(%eax)
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	8b 55 08             	mov    0x8(%ebp),%edx
  802264:	89 10                	mov    %edx,(%eax)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226c:	89 50 04             	mov    %edx,0x4(%eax)
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	85 c0                	test   %eax,%eax
  802276:	75 08                	jne    802280 <insert_sorted_allocList+0x244>
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	a3 44 50 80 00       	mov    %eax,0x805044
  802280:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802285:	40                   	inc    %eax
  802286:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80228b:	eb 39                	jmp    8022c6 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80228d:	a1 48 50 80 00       	mov    0x805048,%eax
  802292:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802295:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802299:	74 07                	je     8022a2 <insert_sorted_allocList+0x266>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	eb 05                	jmp    8022a7 <insert_sorted_allocList+0x26b>
  8022a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a7:	a3 48 50 80 00       	mov    %eax,0x805048
  8022ac:	a1 48 50 80 00       	mov    0x805048,%eax
  8022b1:	85 c0                	test   %eax,%eax
  8022b3:	0f 85 3f ff ff ff    	jne    8021f8 <insert_sorted_allocList+0x1bc>
  8022b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022bd:	0f 85 35 ff ff ff    	jne    8021f8 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022c3:	eb 01                	jmp    8022c6 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022c5:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022c6:	90                   	nop
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8022d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d7:	e9 85 01 00 00       	jmp    802461 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e5:	0f 82 6e 01 00 00    	jb     802459 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f4:	0f 85 8a 00 00 00    	jne    802384 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fe:	75 17                	jne    802317 <alloc_block_FF+0x4e>
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	68 04 41 80 00       	push   $0x804104
  802308:	68 93 00 00 00       	push   $0x93
  80230d:	68 5b 40 80 00       	push   $0x80405b
  802312:	e8 fe df ff ff       	call   800315 <_panic>
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 00                	mov    (%eax),%eax
  80231c:	85 c0                	test   %eax,%eax
  80231e:	74 10                	je     802330 <alloc_block_FF+0x67>
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 00                	mov    (%eax),%eax
  802325:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802328:	8b 52 04             	mov    0x4(%edx),%edx
  80232b:	89 50 04             	mov    %edx,0x4(%eax)
  80232e:	eb 0b                	jmp    80233b <alloc_block_FF+0x72>
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	8b 40 04             	mov    0x4(%eax),%eax
  802336:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80233b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233e:	8b 40 04             	mov    0x4(%eax),%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	74 0f                	je     802354 <alloc_block_FF+0x8b>
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 40 04             	mov    0x4(%eax),%eax
  80234b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234e:	8b 12                	mov    (%edx),%edx
  802350:	89 10                	mov    %edx,(%eax)
  802352:	eb 0a                	jmp    80235e <alloc_block_FF+0x95>
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 00                	mov    (%eax),%eax
  802359:	a3 38 51 80 00       	mov    %eax,0x805138
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802371:	a1 44 51 80 00       	mov    0x805144,%eax
  802376:	48                   	dec    %eax
  802377:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	e9 10 01 00 00       	jmp    802494 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	8b 40 0c             	mov    0xc(%eax),%eax
  80238a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80238d:	0f 86 c6 00 00 00    	jbe    802459 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802393:	a1 48 51 80 00       	mov    0x805148,%eax
  802398:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	8b 50 08             	mov    0x8(%eax),%edx
  8023a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a4:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ad:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b4:	75 17                	jne    8023cd <alloc_block_FF+0x104>
  8023b6:	83 ec 04             	sub    $0x4,%esp
  8023b9:	68 04 41 80 00       	push   $0x804104
  8023be:	68 9b 00 00 00       	push   $0x9b
  8023c3:	68 5b 40 80 00       	push   $0x80405b
  8023c8:	e8 48 df ff ff       	call   800315 <_panic>
  8023cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d0:	8b 00                	mov    (%eax),%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	74 10                	je     8023e6 <alloc_block_FF+0x11d>
  8023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d9:	8b 00                	mov    (%eax),%eax
  8023db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023de:	8b 52 04             	mov    0x4(%edx),%edx
  8023e1:	89 50 04             	mov    %edx,0x4(%eax)
  8023e4:	eb 0b                	jmp    8023f1 <alloc_block_FF+0x128>
  8023e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e9:	8b 40 04             	mov    0x4(%eax),%eax
  8023ec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f4:	8b 40 04             	mov    0x4(%eax),%eax
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	74 0f                	je     80240a <alloc_block_FF+0x141>
  8023fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fe:	8b 40 04             	mov    0x4(%eax),%eax
  802401:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802404:	8b 12                	mov    (%edx),%edx
  802406:	89 10                	mov    %edx,(%eax)
  802408:	eb 0a                	jmp    802414 <alloc_block_FF+0x14b>
  80240a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240d:	8b 00                	mov    (%eax),%eax
  80240f:	a3 48 51 80 00       	mov    %eax,0x805148
  802414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80241d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802420:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802427:	a1 54 51 80 00       	mov    0x805154,%eax
  80242c:	48                   	dec    %eax
  80242d:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 50 08             	mov    0x8(%eax),%edx
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	01 c2                	add    %eax,%edx
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 0c             	mov    0xc(%eax),%eax
  802449:	2b 45 08             	sub    0x8(%ebp),%eax
  80244c:	89 c2                	mov    %eax,%edx
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802457:	eb 3b                	jmp    802494 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802459:	a1 40 51 80 00       	mov    0x805140,%eax
  80245e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802465:	74 07                	je     80246e <alloc_block_FF+0x1a5>
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	eb 05                	jmp    802473 <alloc_block_FF+0x1aa>
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
  802473:	a3 40 51 80 00       	mov    %eax,0x805140
  802478:	a1 40 51 80 00       	mov    0x805140,%eax
  80247d:	85 c0                	test   %eax,%eax
  80247f:	0f 85 57 fe ff ff    	jne    8022dc <alloc_block_FF+0x13>
  802485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802489:	0f 85 4d fe ff ff    	jne    8022dc <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80249c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024a3:	a1 38 51 80 00       	mov    0x805138,%eax
  8024a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ab:	e9 df 00 00 00       	jmp    80258f <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b9:	0f 82 c8 00 00 00    	jb     802587 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c8:	0f 85 8a 00 00 00    	jne    802558 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d2:	75 17                	jne    8024eb <alloc_block_BF+0x55>
  8024d4:	83 ec 04             	sub    $0x4,%esp
  8024d7:	68 04 41 80 00       	push   $0x804104
  8024dc:	68 b7 00 00 00       	push   $0xb7
  8024e1:	68 5b 40 80 00       	push   $0x80405b
  8024e6:	e8 2a de ff ff       	call   800315 <_panic>
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 00                	mov    (%eax),%eax
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	74 10                	je     802504 <alloc_block_BF+0x6e>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fc:	8b 52 04             	mov    0x4(%edx),%edx
  8024ff:	89 50 04             	mov    %edx,0x4(%eax)
  802502:	eb 0b                	jmp    80250f <alloc_block_BF+0x79>
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 40 04             	mov    0x4(%eax),%eax
  80250a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 40 04             	mov    0x4(%eax),%eax
  802515:	85 c0                	test   %eax,%eax
  802517:	74 0f                	je     802528 <alloc_block_BF+0x92>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 40 04             	mov    0x4(%eax),%eax
  80251f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802522:	8b 12                	mov    (%edx),%edx
  802524:	89 10                	mov    %edx,(%eax)
  802526:	eb 0a                	jmp    802532 <alloc_block_BF+0x9c>
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 00                	mov    (%eax),%eax
  80252d:	a3 38 51 80 00       	mov    %eax,0x805138
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802545:	a1 44 51 80 00       	mov    0x805144,%eax
  80254a:	48                   	dec    %eax
  80254b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	e9 4d 01 00 00       	jmp    8026a5 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 40 0c             	mov    0xc(%eax),%eax
  80255e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802561:	76 24                	jbe    802587 <alloc_block_BF+0xf1>
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 40 0c             	mov    0xc(%eax),%eax
  802569:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80256c:	73 19                	jae    802587 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80256e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 40 0c             	mov    0xc(%eax),%eax
  80257b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	8b 40 08             	mov    0x8(%eax),%eax
  802584:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802587:	a1 40 51 80 00       	mov    0x805140,%eax
  80258c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802593:	74 07                	je     80259c <alloc_block_BF+0x106>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	eb 05                	jmp    8025a1 <alloc_block_BF+0x10b>
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a1:	a3 40 51 80 00       	mov    %eax,0x805140
  8025a6:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	0f 85 fd fe ff ff    	jne    8024b0 <alloc_block_BF+0x1a>
  8025b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b7:	0f 85 f3 fe ff ff    	jne    8024b0 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025c1:	0f 84 d9 00 00 00    	je     8026a0 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025c7:	a1 48 51 80 00       	mov    0x805148,%eax
  8025cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d5:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025db:	8b 55 08             	mov    0x8(%ebp),%edx
  8025de:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025e5:	75 17                	jne    8025fe <alloc_block_BF+0x168>
  8025e7:	83 ec 04             	sub    $0x4,%esp
  8025ea:	68 04 41 80 00       	push   $0x804104
  8025ef:	68 c7 00 00 00       	push   $0xc7
  8025f4:	68 5b 40 80 00       	push   $0x80405b
  8025f9:	e8 17 dd ff ff       	call   800315 <_panic>
  8025fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802601:	8b 00                	mov    (%eax),%eax
  802603:	85 c0                	test   %eax,%eax
  802605:	74 10                	je     802617 <alloc_block_BF+0x181>
  802607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260a:	8b 00                	mov    (%eax),%eax
  80260c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80260f:	8b 52 04             	mov    0x4(%edx),%edx
  802612:	89 50 04             	mov    %edx,0x4(%eax)
  802615:	eb 0b                	jmp    802622 <alloc_block_BF+0x18c>
  802617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261a:	8b 40 04             	mov    0x4(%eax),%eax
  80261d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802625:	8b 40 04             	mov    0x4(%eax),%eax
  802628:	85 c0                	test   %eax,%eax
  80262a:	74 0f                	je     80263b <alloc_block_BF+0x1a5>
  80262c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262f:	8b 40 04             	mov    0x4(%eax),%eax
  802632:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802635:	8b 12                	mov    (%edx),%edx
  802637:	89 10                	mov    %edx,(%eax)
  802639:	eb 0a                	jmp    802645 <alloc_block_BF+0x1af>
  80263b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263e:	8b 00                	mov    (%eax),%eax
  802640:	a3 48 51 80 00       	mov    %eax,0x805148
  802645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802648:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802651:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802658:	a1 54 51 80 00       	mov    0x805154,%eax
  80265d:	48                   	dec    %eax
  80265e:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802663:	83 ec 08             	sub    $0x8,%esp
  802666:	ff 75 ec             	pushl  -0x14(%ebp)
  802669:	68 38 51 80 00       	push   $0x805138
  80266e:	e8 71 f9 ff ff       	call   801fe4 <find_block>
  802673:	83 c4 10             	add    $0x10,%esp
  802676:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802679:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267c:	8b 50 08             	mov    0x8(%eax),%edx
  80267f:	8b 45 08             	mov    0x8(%ebp),%eax
  802682:	01 c2                	add    %eax,%edx
  802684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802687:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80268a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80268d:	8b 40 0c             	mov    0xc(%eax),%eax
  802690:	2b 45 08             	sub    0x8(%ebp),%eax
  802693:	89 c2                	mov    %eax,%edx
  802695:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802698:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80269b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269e:	eb 05                	jmp    8026a5 <alloc_block_BF+0x20f>
	}
	return NULL;
  8026a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a5:	c9                   	leave  
  8026a6:	c3                   	ret    

008026a7 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
  8026aa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026ad:	a1 28 50 80 00       	mov    0x805028,%eax
  8026b2:	85 c0                	test   %eax,%eax
  8026b4:	0f 85 de 01 00 00    	jne    802898 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026ba:	a1 38 51 80 00       	mov    0x805138,%eax
  8026bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c2:	e9 9e 01 00 00       	jmp    802865 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d0:	0f 82 87 01 00 00    	jb     80285d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026df:	0f 85 95 00 00 00    	jne    80277a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e9:	75 17                	jne    802702 <alloc_block_NF+0x5b>
  8026eb:	83 ec 04             	sub    $0x4,%esp
  8026ee:	68 04 41 80 00       	push   $0x804104
  8026f3:	68 e0 00 00 00       	push   $0xe0
  8026f8:	68 5b 40 80 00       	push   $0x80405b
  8026fd:	e8 13 dc ff ff       	call   800315 <_panic>
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 00                	mov    (%eax),%eax
  802707:	85 c0                	test   %eax,%eax
  802709:	74 10                	je     80271b <alloc_block_NF+0x74>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802713:	8b 52 04             	mov    0x4(%edx),%edx
  802716:	89 50 04             	mov    %edx,0x4(%eax)
  802719:	eb 0b                	jmp    802726 <alloc_block_NF+0x7f>
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 04             	mov    0x4(%eax),%eax
  802721:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 40 04             	mov    0x4(%eax),%eax
  80272c:	85 c0                	test   %eax,%eax
  80272e:	74 0f                	je     80273f <alloc_block_NF+0x98>
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 40 04             	mov    0x4(%eax),%eax
  802736:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802739:	8b 12                	mov    (%edx),%edx
  80273b:	89 10                	mov    %edx,(%eax)
  80273d:	eb 0a                	jmp    802749 <alloc_block_NF+0xa2>
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 00                	mov    (%eax),%eax
  802744:	a3 38 51 80 00       	mov    %eax,0x805138
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275c:	a1 44 51 80 00       	mov    0x805144,%eax
  802761:	48                   	dec    %eax
  802762:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 08             	mov    0x8(%eax),%eax
  80276d:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	e9 f8 04 00 00       	jmp    802c72 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	8b 40 0c             	mov    0xc(%eax),%eax
  802780:	3b 45 08             	cmp    0x8(%ebp),%eax
  802783:	0f 86 d4 00 00 00    	jbe    80285d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802789:	a1 48 51 80 00       	mov    0x805148,%eax
  80278e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 50 08             	mov    0x8(%eax),%edx
  802797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279a:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a3:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027aa:	75 17                	jne    8027c3 <alloc_block_NF+0x11c>
  8027ac:	83 ec 04             	sub    $0x4,%esp
  8027af:	68 04 41 80 00       	push   $0x804104
  8027b4:	68 e9 00 00 00       	push   $0xe9
  8027b9:	68 5b 40 80 00       	push   $0x80405b
  8027be:	e8 52 db ff ff       	call   800315 <_panic>
  8027c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	74 10                	je     8027dc <alloc_block_NF+0x135>
  8027cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d4:	8b 52 04             	mov    0x4(%edx),%edx
  8027d7:	89 50 04             	mov    %edx,0x4(%eax)
  8027da:	eb 0b                	jmp    8027e7 <alloc_block_NF+0x140>
  8027dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ea:	8b 40 04             	mov    0x4(%eax),%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	74 0f                	je     802800 <alloc_block_NF+0x159>
  8027f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f4:	8b 40 04             	mov    0x4(%eax),%eax
  8027f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027fa:	8b 12                	mov    (%edx),%edx
  8027fc:	89 10                	mov    %edx,(%eax)
  8027fe:	eb 0a                	jmp    80280a <alloc_block_NF+0x163>
  802800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	a3 48 51 80 00       	mov    %eax,0x805148
  80280a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802816:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281d:	a1 54 51 80 00       	mov    0x805154,%eax
  802822:	48                   	dec    %eax
  802823:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282b:	8b 40 08             	mov    0x8(%eax),%eax
  80282e:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 50 08             	mov    0x8(%eax),%edx
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	01 c2                	add    %eax,%edx
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 40 0c             	mov    0xc(%eax),%eax
  80284a:	2b 45 08             	sub    0x8(%ebp),%eax
  80284d:	89 c2                	mov    %eax,%edx
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802858:	e9 15 04 00 00       	jmp    802c72 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80285d:	a1 40 51 80 00       	mov    0x805140,%eax
  802862:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802869:	74 07                	je     802872 <alloc_block_NF+0x1cb>
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	eb 05                	jmp    802877 <alloc_block_NF+0x1d0>
  802872:	b8 00 00 00 00       	mov    $0x0,%eax
  802877:	a3 40 51 80 00       	mov    %eax,0x805140
  80287c:	a1 40 51 80 00       	mov    0x805140,%eax
  802881:	85 c0                	test   %eax,%eax
  802883:	0f 85 3e fe ff ff    	jne    8026c7 <alloc_block_NF+0x20>
  802889:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288d:	0f 85 34 fe ff ff    	jne    8026c7 <alloc_block_NF+0x20>
  802893:	e9 d5 03 00 00       	jmp    802c6d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802898:	a1 38 51 80 00       	mov    0x805138,%eax
  80289d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a0:	e9 b1 01 00 00       	jmp    802a56 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 50 08             	mov    0x8(%eax),%edx
  8028ab:	a1 28 50 80 00       	mov    0x805028,%eax
  8028b0:	39 c2                	cmp    %eax,%edx
  8028b2:	0f 82 96 01 00 00    	jb     802a4e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c1:	0f 82 87 01 00 00    	jb     802a4e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d0:	0f 85 95 00 00 00    	jne    80296b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028da:	75 17                	jne    8028f3 <alloc_block_NF+0x24c>
  8028dc:	83 ec 04             	sub    $0x4,%esp
  8028df:	68 04 41 80 00       	push   $0x804104
  8028e4:	68 fc 00 00 00       	push   $0xfc
  8028e9:	68 5b 40 80 00       	push   $0x80405b
  8028ee:	e8 22 da ff ff       	call   800315 <_panic>
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 00                	mov    (%eax),%eax
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	74 10                	je     80290c <alloc_block_NF+0x265>
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802904:	8b 52 04             	mov    0x4(%edx),%edx
  802907:	89 50 04             	mov    %edx,0x4(%eax)
  80290a:	eb 0b                	jmp    802917 <alloc_block_NF+0x270>
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 40 04             	mov    0x4(%eax),%eax
  802912:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	8b 40 04             	mov    0x4(%eax),%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	74 0f                	je     802930 <alloc_block_NF+0x289>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 40 04             	mov    0x4(%eax),%eax
  802927:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292a:	8b 12                	mov    (%edx),%edx
  80292c:	89 10                	mov    %edx,(%eax)
  80292e:	eb 0a                	jmp    80293a <alloc_block_NF+0x293>
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 00                	mov    (%eax),%eax
  802935:	a3 38 51 80 00       	mov    %eax,0x805138
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294d:	a1 44 51 80 00       	mov    0x805144,%eax
  802952:	48                   	dec    %eax
  802953:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	8b 40 08             	mov    0x8(%eax),%eax
  80295e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	e9 07 03 00 00       	jmp    802c72 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 40 0c             	mov    0xc(%eax),%eax
  802971:	3b 45 08             	cmp    0x8(%ebp),%eax
  802974:	0f 86 d4 00 00 00    	jbe    802a4e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80297a:	a1 48 51 80 00       	mov    0x805148,%eax
  80297f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 50 08             	mov    0x8(%eax),%edx
  802988:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80298e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802991:	8b 55 08             	mov    0x8(%ebp),%edx
  802994:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802997:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80299b:	75 17                	jne    8029b4 <alloc_block_NF+0x30d>
  80299d:	83 ec 04             	sub    $0x4,%esp
  8029a0:	68 04 41 80 00       	push   $0x804104
  8029a5:	68 04 01 00 00       	push   $0x104
  8029aa:	68 5b 40 80 00       	push   $0x80405b
  8029af:	e8 61 d9 ff ff       	call   800315 <_panic>
  8029b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b7:	8b 00                	mov    (%eax),%eax
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	74 10                	je     8029cd <alloc_block_NF+0x326>
  8029bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c0:	8b 00                	mov    (%eax),%eax
  8029c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c5:	8b 52 04             	mov    0x4(%edx),%edx
  8029c8:	89 50 04             	mov    %edx,0x4(%eax)
  8029cb:	eb 0b                	jmp    8029d8 <alloc_block_NF+0x331>
  8029cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d0:	8b 40 04             	mov    0x4(%eax),%eax
  8029d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029db:	8b 40 04             	mov    0x4(%eax),%eax
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	74 0f                	je     8029f1 <alloc_block_NF+0x34a>
  8029e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e5:	8b 40 04             	mov    0x4(%eax),%eax
  8029e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029eb:	8b 12                	mov    (%edx),%edx
  8029ed:	89 10                	mov    %edx,(%eax)
  8029ef:	eb 0a                	jmp    8029fb <alloc_block_NF+0x354>
  8029f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f4:	8b 00                	mov    (%eax),%eax
  8029f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8029fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0e:	a1 54 51 80 00       	mov    0x805154,%eax
  802a13:	48                   	dec    %eax
  802a14:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1c:	8b 40 08             	mov    0x8(%eax),%eax
  802a1f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 50 08             	mov    0x8(%eax),%edx
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	01 c2                	add    %eax,%edx
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a3e:	89 c2                	mov    %eax,%edx
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a49:	e9 24 02 00 00       	jmp    802c72 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a4e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5a:	74 07                	je     802a63 <alloc_block_NF+0x3bc>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	eb 05                	jmp    802a68 <alloc_block_NF+0x3c1>
  802a63:	b8 00 00 00 00       	mov    $0x0,%eax
  802a68:	a3 40 51 80 00       	mov    %eax,0x805140
  802a6d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	0f 85 2b fe ff ff    	jne    8028a5 <alloc_block_NF+0x1fe>
  802a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7e:	0f 85 21 fe ff ff    	jne    8028a5 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a84:	a1 38 51 80 00       	mov    0x805138,%eax
  802a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8c:	e9 ae 01 00 00       	jmp    802c3f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 50 08             	mov    0x8(%eax),%edx
  802a97:	a1 28 50 80 00       	mov    0x805028,%eax
  802a9c:	39 c2                	cmp    %eax,%edx
  802a9e:	0f 83 93 01 00 00    	jae    802c37 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aad:	0f 82 84 01 00 00    	jb     802c37 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802abc:	0f 85 95 00 00 00    	jne    802b57 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac6:	75 17                	jne    802adf <alloc_block_NF+0x438>
  802ac8:	83 ec 04             	sub    $0x4,%esp
  802acb:	68 04 41 80 00       	push   $0x804104
  802ad0:	68 14 01 00 00       	push   $0x114
  802ad5:	68 5b 40 80 00       	push   $0x80405b
  802ada:	e8 36 d8 ff ff       	call   800315 <_panic>
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 00                	mov    (%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 10                	je     802af8 <alloc_block_NF+0x451>
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af0:	8b 52 04             	mov    0x4(%edx),%edx
  802af3:	89 50 04             	mov    %edx,0x4(%eax)
  802af6:	eb 0b                	jmp    802b03 <alloc_block_NF+0x45c>
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 40 04             	mov    0x4(%eax),%eax
  802afe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 40 04             	mov    0x4(%eax),%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	74 0f                	je     802b1c <alloc_block_NF+0x475>
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	8b 40 04             	mov    0x4(%eax),%eax
  802b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b16:	8b 12                	mov    (%edx),%edx
  802b18:	89 10                	mov    %edx,(%eax)
  802b1a:	eb 0a                	jmp    802b26 <alloc_block_NF+0x47f>
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	a3 38 51 80 00       	mov    %eax,0x805138
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b39:	a1 44 51 80 00       	mov    0x805144,%eax
  802b3e:	48                   	dec    %eax
  802b3f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 40 08             	mov    0x8(%eax),%eax
  802b4a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	e9 1b 01 00 00       	jmp    802c72 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b60:	0f 86 d1 00 00 00    	jbe    802c37 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b66:	a1 48 51 80 00       	mov    0x805148,%eax
  802b6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 50 08             	mov    0x8(%eax),%edx
  802b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b77:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b80:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b87:	75 17                	jne    802ba0 <alloc_block_NF+0x4f9>
  802b89:	83 ec 04             	sub    $0x4,%esp
  802b8c:	68 04 41 80 00       	push   $0x804104
  802b91:	68 1c 01 00 00       	push   $0x11c
  802b96:	68 5b 40 80 00       	push   $0x80405b
  802b9b:	e8 75 d7 ff ff       	call   800315 <_panic>
  802ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	74 10                	je     802bb9 <alloc_block_NF+0x512>
  802ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bac:	8b 00                	mov    (%eax),%eax
  802bae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb1:	8b 52 04             	mov    0x4(%edx),%edx
  802bb4:	89 50 04             	mov    %edx,0x4(%eax)
  802bb7:	eb 0b                	jmp    802bc4 <alloc_block_NF+0x51d>
  802bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbc:	8b 40 04             	mov    0x4(%eax),%eax
  802bbf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc7:	8b 40 04             	mov    0x4(%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	74 0f                	je     802bdd <alloc_block_NF+0x536>
  802bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd1:	8b 40 04             	mov    0x4(%eax),%eax
  802bd4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd7:	8b 12                	mov    (%edx),%edx
  802bd9:	89 10                	mov    %edx,(%eax)
  802bdb:	eb 0a                	jmp    802be7 <alloc_block_NF+0x540>
  802bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	a3 48 51 80 00       	mov    %eax,0x805148
  802be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bfa:	a1 54 51 80 00       	mov    0x805154,%eax
  802bff:	48                   	dec    %eax
  802c00:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c08:	8b 40 08             	mov    0x8(%eax),%eax
  802c0b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 50 08             	mov    0x8(%eax),%edx
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	01 c2                	add    %eax,%edx
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 40 0c             	mov    0xc(%eax),%eax
  802c27:	2b 45 08             	sub    0x8(%ebp),%eax
  802c2a:	89 c2                	mov    %eax,%edx
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c35:	eb 3b                	jmp    802c72 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c37:	a1 40 51 80 00       	mov    0x805140,%eax
  802c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c43:	74 07                	je     802c4c <alloc_block_NF+0x5a5>
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 00                	mov    (%eax),%eax
  802c4a:	eb 05                	jmp    802c51 <alloc_block_NF+0x5aa>
  802c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c51:	a3 40 51 80 00       	mov    %eax,0x805140
  802c56:	a1 40 51 80 00       	mov    0x805140,%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	0f 85 2e fe ff ff    	jne    802a91 <alloc_block_NF+0x3ea>
  802c63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c67:	0f 85 24 fe ff ff    	jne    802a91 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c72:	c9                   	leave  
  802c73:	c3                   	ret    

00802c74 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c74:	55                   	push   %ebp
  802c75:	89 e5                	mov    %esp,%ebp
  802c77:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c7a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c82:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c87:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c8a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c8f:	85 c0                	test   %eax,%eax
  802c91:	74 14                	je     802ca7 <insert_sorted_with_merge_freeList+0x33>
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	8b 50 08             	mov    0x8(%eax),%edx
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	8b 40 08             	mov    0x8(%eax),%eax
  802c9f:	39 c2                	cmp    %eax,%edx
  802ca1:	0f 87 9b 01 00 00    	ja     802e42 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ca7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cab:	75 17                	jne    802cc4 <insert_sorted_with_merge_freeList+0x50>
  802cad:	83 ec 04             	sub    $0x4,%esp
  802cb0:	68 38 40 80 00       	push   $0x804038
  802cb5:	68 38 01 00 00       	push   $0x138
  802cba:	68 5b 40 80 00       	push   $0x80405b
  802cbf:	e8 51 d6 ff ff       	call   800315 <_panic>
  802cc4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccd:	89 10                	mov    %edx,(%eax)
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	74 0d                	je     802ce5 <insert_sorted_with_merge_freeList+0x71>
  802cd8:	a1 38 51 80 00       	mov    0x805138,%eax
  802cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce0:	89 50 04             	mov    %edx,0x4(%eax)
  802ce3:	eb 08                	jmp    802ced <insert_sorted_with_merge_freeList+0x79>
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	a3 38 51 80 00       	mov    %eax,0x805138
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cff:	a1 44 51 80 00       	mov    0x805144,%eax
  802d04:	40                   	inc    %eax
  802d05:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0e:	0f 84 a8 06 00 00    	je     8033bc <insert_sorted_with_merge_freeList+0x748>
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	8b 50 08             	mov    0x8(%eax),%edx
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d20:	01 c2                	add    %eax,%edx
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	8b 40 08             	mov    0x8(%eax),%eax
  802d28:	39 c2                	cmp    %eax,%edx
  802d2a:	0f 85 8c 06 00 00    	jne    8033bc <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	8b 50 0c             	mov    0xc(%eax),%edx
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3c:	01 c2                	add    %eax,%edx
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d48:	75 17                	jne    802d61 <insert_sorted_with_merge_freeList+0xed>
  802d4a:	83 ec 04             	sub    $0x4,%esp
  802d4d:	68 04 41 80 00       	push   $0x804104
  802d52:	68 3c 01 00 00       	push   $0x13c
  802d57:	68 5b 40 80 00       	push   $0x80405b
  802d5c:	e8 b4 d5 ff ff       	call   800315 <_panic>
  802d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	85 c0                	test   %eax,%eax
  802d68:	74 10                	je     802d7a <insert_sorted_with_merge_freeList+0x106>
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d72:	8b 52 04             	mov    0x4(%edx),%edx
  802d75:	89 50 04             	mov    %edx,0x4(%eax)
  802d78:	eb 0b                	jmp    802d85 <insert_sorted_with_merge_freeList+0x111>
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	8b 40 04             	mov    0x4(%eax),%eax
  802d80:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d88:	8b 40 04             	mov    0x4(%eax),%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	74 0f                	je     802d9e <insert_sorted_with_merge_freeList+0x12a>
  802d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d92:	8b 40 04             	mov    0x4(%eax),%eax
  802d95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d98:	8b 12                	mov    (%edx),%edx
  802d9a:	89 10                	mov    %edx,(%eax)
  802d9c:	eb 0a                	jmp    802da8 <insert_sorted_with_merge_freeList+0x134>
  802d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da1:	8b 00                	mov    (%eax),%eax
  802da3:	a3 38 51 80 00       	mov    %eax,0x805138
  802da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbb:	a1 44 51 80 00       	mov    0x805144,%eax
  802dc0:	48                   	dec    %eax
  802dc1:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802dda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dde:	75 17                	jne    802df7 <insert_sorted_with_merge_freeList+0x183>
  802de0:	83 ec 04             	sub    $0x4,%esp
  802de3:	68 38 40 80 00       	push   $0x804038
  802de8:	68 3f 01 00 00       	push   $0x13f
  802ded:	68 5b 40 80 00       	push   $0x80405b
  802df2:	e8 1e d5 ff ff       	call   800315 <_panic>
  802df7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e00:	89 10                	mov    %edx,(%eax)
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	8b 00                	mov    (%eax),%eax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	74 0d                	je     802e18 <insert_sorted_with_merge_freeList+0x1a4>
  802e0b:	a1 48 51 80 00       	mov    0x805148,%eax
  802e10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e13:	89 50 04             	mov    %edx,0x4(%eax)
  802e16:	eb 08                	jmp    802e20 <insert_sorted_with_merge_freeList+0x1ac>
  802e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e23:	a3 48 51 80 00       	mov    %eax,0x805148
  802e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e32:	a1 54 51 80 00       	mov    0x805154,%eax
  802e37:	40                   	inc    %eax
  802e38:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e3d:	e9 7a 05 00 00       	jmp    8033bc <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	8b 50 08             	mov    0x8(%eax),%edx
  802e48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4b:	8b 40 08             	mov    0x8(%eax),%eax
  802e4e:	39 c2                	cmp    %eax,%edx
  802e50:	0f 82 14 01 00 00    	jb     802f6a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e59:	8b 50 08             	mov    0x8(%eax),%edx
  802e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e62:	01 c2                	add    %eax,%edx
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	8b 40 08             	mov    0x8(%eax),%eax
  802e6a:	39 c2                	cmp    %eax,%edx
  802e6c:	0f 85 90 00 00 00    	jne    802f02 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e75:	8b 50 0c             	mov    0xc(%eax),%edx
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7e:	01 c2                	add    %eax,%edx
  802e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e83:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9e:	75 17                	jne    802eb7 <insert_sorted_with_merge_freeList+0x243>
  802ea0:	83 ec 04             	sub    $0x4,%esp
  802ea3:	68 38 40 80 00       	push   $0x804038
  802ea8:	68 49 01 00 00       	push   $0x149
  802ead:	68 5b 40 80 00       	push   $0x80405b
  802eb2:	e8 5e d4 ff ff       	call   800315 <_panic>
  802eb7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	89 10                	mov    %edx,(%eax)
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	74 0d                	je     802ed8 <insert_sorted_with_merge_freeList+0x264>
  802ecb:	a1 48 51 80 00       	mov    0x805148,%eax
  802ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed3:	89 50 04             	mov    %edx,0x4(%eax)
  802ed6:	eb 08                	jmp    802ee0 <insert_sorted_with_merge_freeList+0x26c>
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef2:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef7:	40                   	inc    %eax
  802ef8:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802efd:	e9 bb 04 00 00       	jmp    8033bd <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f06:	75 17                	jne    802f1f <insert_sorted_with_merge_freeList+0x2ab>
  802f08:	83 ec 04             	sub    $0x4,%esp
  802f0b:	68 ac 40 80 00       	push   $0x8040ac
  802f10:	68 4c 01 00 00       	push   $0x14c
  802f15:	68 5b 40 80 00       	push   $0x80405b
  802f1a:	e8 f6 d3 ff ff       	call   800315 <_panic>
  802f1f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	89 50 04             	mov    %edx,0x4(%eax)
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	8b 40 04             	mov    0x4(%eax),%eax
  802f31:	85 c0                	test   %eax,%eax
  802f33:	74 0c                	je     802f41 <insert_sorted_with_merge_freeList+0x2cd>
  802f35:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3d:	89 10                	mov    %edx,(%eax)
  802f3f:	eb 08                	jmp    802f49 <insert_sorted_with_merge_freeList+0x2d5>
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	a3 38 51 80 00       	mov    %eax,0x805138
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f5f:	40                   	inc    %eax
  802f60:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f65:	e9 53 04 00 00       	jmp    8033bd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f6a:	a1 38 51 80 00       	mov    0x805138,%eax
  802f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f72:	e9 15 04 00 00       	jmp    80338c <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	8b 50 08             	mov    0x8(%eax),%edx
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	8b 40 08             	mov    0x8(%eax),%eax
  802f8b:	39 c2                	cmp    %eax,%edx
  802f8d:	0f 86 f1 03 00 00    	jbe    803384 <insert_sorted_with_merge_freeList+0x710>
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	8b 50 08             	mov    0x8(%eax),%edx
  802f99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9c:	8b 40 08             	mov    0x8(%eax),%eax
  802f9f:	39 c2                	cmp    %eax,%edx
  802fa1:	0f 83 dd 03 00 00    	jae    803384 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	8b 50 08             	mov    0x8(%eax),%edx
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb3:	01 c2                	add    %eax,%edx
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	8b 40 08             	mov    0x8(%eax),%eax
  802fbb:	39 c2                	cmp    %eax,%edx
  802fbd:	0f 85 b9 01 00 00    	jne    80317c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8b 50 08             	mov    0x8(%eax),%edx
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcf:	01 c2                	add    %eax,%edx
  802fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd4:	8b 40 08             	mov    0x8(%eax),%eax
  802fd7:	39 c2                	cmp    %eax,%edx
  802fd9:	0f 85 0d 01 00 00    	jne    8030ec <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe8:	8b 40 0c             	mov    0xc(%eax),%eax
  802feb:	01 c2                	add    %eax,%edx
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802ff3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ff7:	75 17                	jne    803010 <insert_sorted_with_merge_freeList+0x39c>
  802ff9:	83 ec 04             	sub    $0x4,%esp
  802ffc:	68 04 41 80 00       	push   $0x804104
  803001:	68 5c 01 00 00       	push   $0x15c
  803006:	68 5b 40 80 00       	push   $0x80405b
  80300b:	e8 05 d3 ff ff       	call   800315 <_panic>
  803010:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	85 c0                	test   %eax,%eax
  803017:	74 10                	je     803029 <insert_sorted_with_merge_freeList+0x3b5>
  803019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301c:	8b 00                	mov    (%eax),%eax
  80301e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803021:	8b 52 04             	mov    0x4(%edx),%edx
  803024:	89 50 04             	mov    %edx,0x4(%eax)
  803027:	eb 0b                	jmp    803034 <insert_sorted_with_merge_freeList+0x3c0>
  803029:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302c:	8b 40 04             	mov    0x4(%eax),%eax
  80302f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803034:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803037:	8b 40 04             	mov    0x4(%eax),%eax
  80303a:	85 c0                	test   %eax,%eax
  80303c:	74 0f                	je     80304d <insert_sorted_with_merge_freeList+0x3d9>
  80303e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803041:	8b 40 04             	mov    0x4(%eax),%eax
  803044:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803047:	8b 12                	mov    (%edx),%edx
  803049:	89 10                	mov    %edx,(%eax)
  80304b:	eb 0a                	jmp    803057 <insert_sorted_with_merge_freeList+0x3e3>
  80304d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803050:	8b 00                	mov    (%eax),%eax
  803052:	a3 38 51 80 00       	mov    %eax,0x805138
  803057:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803060:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803063:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306a:	a1 44 51 80 00       	mov    0x805144,%eax
  80306f:	48                   	dec    %eax
  803070:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803075:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803078:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80307f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803082:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803089:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80308d:	75 17                	jne    8030a6 <insert_sorted_with_merge_freeList+0x432>
  80308f:	83 ec 04             	sub    $0x4,%esp
  803092:	68 38 40 80 00       	push   $0x804038
  803097:	68 5f 01 00 00       	push   $0x15f
  80309c:	68 5b 40 80 00       	push   $0x80405b
  8030a1:	e8 6f d2 ff ff       	call   800315 <_panic>
  8030a6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030af:	89 10                	mov    %edx,(%eax)
  8030b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	85 c0                	test   %eax,%eax
  8030b8:	74 0d                	je     8030c7 <insert_sorted_with_merge_freeList+0x453>
  8030ba:	a1 48 51 80 00       	mov    0x805148,%eax
  8030bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c2:	89 50 04             	mov    %edx,0x4(%eax)
  8030c5:	eb 08                	jmp    8030cf <insert_sorted_with_merge_freeList+0x45b>
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8030d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8030e6:	40                   	inc    %eax
  8030e7:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f8:	01 c2                	add    %eax,%edx
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803114:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803118:	75 17                	jne    803131 <insert_sorted_with_merge_freeList+0x4bd>
  80311a:	83 ec 04             	sub    $0x4,%esp
  80311d:	68 38 40 80 00       	push   $0x804038
  803122:	68 64 01 00 00       	push   $0x164
  803127:	68 5b 40 80 00       	push   $0x80405b
  80312c:	e8 e4 d1 ff ff       	call   800315 <_panic>
  803131:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	89 10                	mov    %edx,(%eax)
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	74 0d                	je     803152 <insert_sorted_with_merge_freeList+0x4de>
  803145:	a1 48 51 80 00       	mov    0x805148,%eax
  80314a:	8b 55 08             	mov    0x8(%ebp),%edx
  80314d:	89 50 04             	mov    %edx,0x4(%eax)
  803150:	eb 08                	jmp    80315a <insert_sorted_with_merge_freeList+0x4e6>
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	a3 48 51 80 00       	mov    %eax,0x805148
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316c:	a1 54 51 80 00       	mov    0x805154,%eax
  803171:	40                   	inc    %eax
  803172:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803177:	e9 41 02 00 00       	jmp    8033bd <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	8b 50 08             	mov    0x8(%eax),%edx
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	8b 40 0c             	mov    0xc(%eax),%eax
  803188:	01 c2                	add    %eax,%edx
  80318a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318d:	8b 40 08             	mov    0x8(%eax),%eax
  803190:	39 c2                	cmp    %eax,%edx
  803192:	0f 85 7c 01 00 00    	jne    803314 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803198:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319c:	74 06                	je     8031a4 <insert_sorted_with_merge_freeList+0x530>
  80319e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a2:	75 17                	jne    8031bb <insert_sorted_with_merge_freeList+0x547>
  8031a4:	83 ec 04             	sub    $0x4,%esp
  8031a7:	68 74 40 80 00       	push   $0x804074
  8031ac:	68 69 01 00 00       	push   $0x169
  8031b1:	68 5b 40 80 00       	push   $0x80405b
  8031b6:	e8 5a d1 ff ff       	call   800315 <_panic>
  8031bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031be:	8b 50 04             	mov    0x4(%eax),%edx
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	89 50 04             	mov    %edx,0x4(%eax)
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031cd:	89 10                	mov    %edx,(%eax)
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	8b 40 04             	mov    0x4(%eax),%eax
  8031d5:	85 c0                	test   %eax,%eax
  8031d7:	74 0d                	je     8031e6 <insert_sorted_with_merge_freeList+0x572>
  8031d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dc:	8b 40 04             	mov    0x4(%eax),%eax
  8031df:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e2:	89 10                	mov    %edx,(%eax)
  8031e4:	eb 08                	jmp    8031ee <insert_sorted_with_merge_freeList+0x57a>
  8031e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e9:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f4:	89 50 04             	mov    %edx,0x4(%eax)
  8031f7:	a1 44 51 80 00       	mov    0x805144,%eax
  8031fc:	40                   	inc    %eax
  8031fd:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	8b 50 0c             	mov    0xc(%eax),%edx
  803208:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320b:	8b 40 0c             	mov    0xc(%eax),%eax
  80320e:	01 c2                	add    %eax,%edx
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803216:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80321a:	75 17                	jne    803233 <insert_sorted_with_merge_freeList+0x5bf>
  80321c:	83 ec 04             	sub    $0x4,%esp
  80321f:	68 04 41 80 00       	push   $0x804104
  803224:	68 6b 01 00 00       	push   $0x16b
  803229:	68 5b 40 80 00       	push   $0x80405b
  80322e:	e8 e2 d0 ff ff       	call   800315 <_panic>
  803233:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803236:	8b 00                	mov    (%eax),%eax
  803238:	85 c0                	test   %eax,%eax
  80323a:	74 10                	je     80324c <insert_sorted_with_merge_freeList+0x5d8>
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	8b 00                	mov    (%eax),%eax
  803241:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803244:	8b 52 04             	mov    0x4(%edx),%edx
  803247:	89 50 04             	mov    %edx,0x4(%eax)
  80324a:	eb 0b                	jmp    803257 <insert_sorted_with_merge_freeList+0x5e3>
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	8b 40 04             	mov    0x4(%eax),%eax
  803252:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325a:	8b 40 04             	mov    0x4(%eax),%eax
  80325d:	85 c0                	test   %eax,%eax
  80325f:	74 0f                	je     803270 <insert_sorted_with_merge_freeList+0x5fc>
  803261:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803264:	8b 40 04             	mov    0x4(%eax),%eax
  803267:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326a:	8b 12                	mov    (%edx),%edx
  80326c:	89 10                	mov    %edx,(%eax)
  80326e:	eb 0a                	jmp    80327a <insert_sorted_with_merge_freeList+0x606>
  803270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	a3 38 51 80 00       	mov    %eax,0x805138
  80327a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803286:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328d:	a1 44 51 80 00       	mov    0x805144,%eax
  803292:	48                   	dec    %eax
  803293:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803298:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032b0:	75 17                	jne    8032c9 <insert_sorted_with_merge_freeList+0x655>
  8032b2:	83 ec 04             	sub    $0x4,%esp
  8032b5:	68 38 40 80 00       	push   $0x804038
  8032ba:	68 6e 01 00 00       	push   $0x16e
  8032bf:	68 5b 40 80 00       	push   $0x80405b
  8032c4:	e8 4c d0 ff ff       	call   800315 <_panic>
  8032c9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d2:	89 10                	mov    %edx,(%eax)
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	74 0d                	je     8032ea <insert_sorted_with_merge_freeList+0x676>
  8032dd:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e5:	89 50 04             	mov    %edx,0x4(%eax)
  8032e8:	eb 08                	jmp    8032f2 <insert_sorted_with_merge_freeList+0x67e>
  8032ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8032fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803304:	a1 54 51 80 00       	mov    0x805154,%eax
  803309:	40                   	inc    %eax
  80330a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80330f:	e9 a9 00 00 00       	jmp    8033bd <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803318:	74 06                	je     803320 <insert_sorted_with_merge_freeList+0x6ac>
  80331a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331e:	75 17                	jne    803337 <insert_sorted_with_merge_freeList+0x6c3>
  803320:	83 ec 04             	sub    $0x4,%esp
  803323:	68 d0 40 80 00       	push   $0x8040d0
  803328:	68 73 01 00 00       	push   $0x173
  80332d:	68 5b 40 80 00       	push   $0x80405b
  803332:	e8 de cf ff ff       	call   800315 <_panic>
  803337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333a:	8b 10                	mov    (%eax),%edx
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	89 10                	mov    %edx,(%eax)
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	85 c0                	test   %eax,%eax
  803348:	74 0b                	je     803355 <insert_sorted_with_merge_freeList+0x6e1>
  80334a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334d:	8b 00                	mov    (%eax),%eax
  80334f:	8b 55 08             	mov    0x8(%ebp),%edx
  803352:	89 50 04             	mov    %edx,0x4(%eax)
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	8b 55 08             	mov    0x8(%ebp),%edx
  80335b:	89 10                	mov    %edx,(%eax)
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803363:	89 50 04             	mov    %edx,0x4(%eax)
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	8b 00                	mov    (%eax),%eax
  80336b:	85 c0                	test   %eax,%eax
  80336d:	75 08                	jne    803377 <insert_sorted_with_merge_freeList+0x703>
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803377:	a1 44 51 80 00       	mov    0x805144,%eax
  80337c:	40                   	inc    %eax
  80337d:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803382:	eb 39                	jmp    8033bd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803384:	a1 40 51 80 00       	mov    0x805140,%eax
  803389:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80338c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803390:	74 07                	je     803399 <insert_sorted_with_merge_freeList+0x725>
  803392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803395:	8b 00                	mov    (%eax),%eax
  803397:	eb 05                	jmp    80339e <insert_sorted_with_merge_freeList+0x72a>
  803399:	b8 00 00 00 00       	mov    $0x0,%eax
  80339e:	a3 40 51 80 00       	mov    %eax,0x805140
  8033a3:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a8:	85 c0                	test   %eax,%eax
  8033aa:	0f 85 c7 fb ff ff    	jne    802f77 <insert_sorted_with_merge_freeList+0x303>
  8033b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b4:	0f 85 bd fb ff ff    	jne    802f77 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033ba:	eb 01                	jmp    8033bd <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033bc:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033bd:	90                   	nop
  8033be:	c9                   	leave  
  8033bf:	c3                   	ret    

008033c0 <__udivdi3>:
  8033c0:	55                   	push   %ebp
  8033c1:	57                   	push   %edi
  8033c2:	56                   	push   %esi
  8033c3:	53                   	push   %ebx
  8033c4:	83 ec 1c             	sub    $0x1c,%esp
  8033c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033d7:	89 ca                	mov    %ecx,%edx
  8033d9:	89 f8                	mov    %edi,%eax
  8033db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033df:	85 f6                	test   %esi,%esi
  8033e1:	75 2d                	jne    803410 <__udivdi3+0x50>
  8033e3:	39 cf                	cmp    %ecx,%edi
  8033e5:	77 65                	ja     80344c <__udivdi3+0x8c>
  8033e7:	89 fd                	mov    %edi,%ebp
  8033e9:	85 ff                	test   %edi,%edi
  8033eb:	75 0b                	jne    8033f8 <__udivdi3+0x38>
  8033ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8033f2:	31 d2                	xor    %edx,%edx
  8033f4:	f7 f7                	div    %edi
  8033f6:	89 c5                	mov    %eax,%ebp
  8033f8:	31 d2                	xor    %edx,%edx
  8033fa:	89 c8                	mov    %ecx,%eax
  8033fc:	f7 f5                	div    %ebp
  8033fe:	89 c1                	mov    %eax,%ecx
  803400:	89 d8                	mov    %ebx,%eax
  803402:	f7 f5                	div    %ebp
  803404:	89 cf                	mov    %ecx,%edi
  803406:	89 fa                	mov    %edi,%edx
  803408:	83 c4 1c             	add    $0x1c,%esp
  80340b:	5b                   	pop    %ebx
  80340c:	5e                   	pop    %esi
  80340d:	5f                   	pop    %edi
  80340e:	5d                   	pop    %ebp
  80340f:	c3                   	ret    
  803410:	39 ce                	cmp    %ecx,%esi
  803412:	77 28                	ja     80343c <__udivdi3+0x7c>
  803414:	0f bd fe             	bsr    %esi,%edi
  803417:	83 f7 1f             	xor    $0x1f,%edi
  80341a:	75 40                	jne    80345c <__udivdi3+0x9c>
  80341c:	39 ce                	cmp    %ecx,%esi
  80341e:	72 0a                	jb     80342a <__udivdi3+0x6a>
  803420:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803424:	0f 87 9e 00 00 00    	ja     8034c8 <__udivdi3+0x108>
  80342a:	b8 01 00 00 00       	mov    $0x1,%eax
  80342f:	89 fa                	mov    %edi,%edx
  803431:	83 c4 1c             	add    $0x1c,%esp
  803434:	5b                   	pop    %ebx
  803435:	5e                   	pop    %esi
  803436:	5f                   	pop    %edi
  803437:	5d                   	pop    %ebp
  803438:	c3                   	ret    
  803439:	8d 76 00             	lea    0x0(%esi),%esi
  80343c:	31 ff                	xor    %edi,%edi
  80343e:	31 c0                	xor    %eax,%eax
  803440:	89 fa                	mov    %edi,%edx
  803442:	83 c4 1c             	add    $0x1c,%esp
  803445:	5b                   	pop    %ebx
  803446:	5e                   	pop    %esi
  803447:	5f                   	pop    %edi
  803448:	5d                   	pop    %ebp
  803449:	c3                   	ret    
  80344a:	66 90                	xchg   %ax,%ax
  80344c:	89 d8                	mov    %ebx,%eax
  80344e:	f7 f7                	div    %edi
  803450:	31 ff                	xor    %edi,%edi
  803452:	89 fa                	mov    %edi,%edx
  803454:	83 c4 1c             	add    $0x1c,%esp
  803457:	5b                   	pop    %ebx
  803458:	5e                   	pop    %esi
  803459:	5f                   	pop    %edi
  80345a:	5d                   	pop    %ebp
  80345b:	c3                   	ret    
  80345c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803461:	89 eb                	mov    %ebp,%ebx
  803463:	29 fb                	sub    %edi,%ebx
  803465:	89 f9                	mov    %edi,%ecx
  803467:	d3 e6                	shl    %cl,%esi
  803469:	89 c5                	mov    %eax,%ebp
  80346b:	88 d9                	mov    %bl,%cl
  80346d:	d3 ed                	shr    %cl,%ebp
  80346f:	89 e9                	mov    %ebp,%ecx
  803471:	09 f1                	or     %esi,%ecx
  803473:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803477:	89 f9                	mov    %edi,%ecx
  803479:	d3 e0                	shl    %cl,%eax
  80347b:	89 c5                	mov    %eax,%ebp
  80347d:	89 d6                	mov    %edx,%esi
  80347f:	88 d9                	mov    %bl,%cl
  803481:	d3 ee                	shr    %cl,%esi
  803483:	89 f9                	mov    %edi,%ecx
  803485:	d3 e2                	shl    %cl,%edx
  803487:	8b 44 24 08          	mov    0x8(%esp),%eax
  80348b:	88 d9                	mov    %bl,%cl
  80348d:	d3 e8                	shr    %cl,%eax
  80348f:	09 c2                	or     %eax,%edx
  803491:	89 d0                	mov    %edx,%eax
  803493:	89 f2                	mov    %esi,%edx
  803495:	f7 74 24 0c          	divl   0xc(%esp)
  803499:	89 d6                	mov    %edx,%esi
  80349b:	89 c3                	mov    %eax,%ebx
  80349d:	f7 e5                	mul    %ebp
  80349f:	39 d6                	cmp    %edx,%esi
  8034a1:	72 19                	jb     8034bc <__udivdi3+0xfc>
  8034a3:	74 0b                	je     8034b0 <__udivdi3+0xf0>
  8034a5:	89 d8                	mov    %ebx,%eax
  8034a7:	31 ff                	xor    %edi,%edi
  8034a9:	e9 58 ff ff ff       	jmp    803406 <__udivdi3+0x46>
  8034ae:	66 90                	xchg   %ax,%ax
  8034b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034b4:	89 f9                	mov    %edi,%ecx
  8034b6:	d3 e2                	shl    %cl,%edx
  8034b8:	39 c2                	cmp    %eax,%edx
  8034ba:	73 e9                	jae    8034a5 <__udivdi3+0xe5>
  8034bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034bf:	31 ff                	xor    %edi,%edi
  8034c1:	e9 40 ff ff ff       	jmp    803406 <__udivdi3+0x46>
  8034c6:	66 90                	xchg   %ax,%ax
  8034c8:	31 c0                	xor    %eax,%eax
  8034ca:	e9 37 ff ff ff       	jmp    803406 <__udivdi3+0x46>
  8034cf:	90                   	nop

008034d0 <__umoddi3>:
  8034d0:	55                   	push   %ebp
  8034d1:	57                   	push   %edi
  8034d2:	56                   	push   %esi
  8034d3:	53                   	push   %ebx
  8034d4:	83 ec 1c             	sub    $0x1c,%esp
  8034d7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034db:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034e3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034ef:	89 f3                	mov    %esi,%ebx
  8034f1:	89 fa                	mov    %edi,%edx
  8034f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034f7:	89 34 24             	mov    %esi,(%esp)
  8034fa:	85 c0                	test   %eax,%eax
  8034fc:	75 1a                	jne    803518 <__umoddi3+0x48>
  8034fe:	39 f7                	cmp    %esi,%edi
  803500:	0f 86 a2 00 00 00    	jbe    8035a8 <__umoddi3+0xd8>
  803506:	89 c8                	mov    %ecx,%eax
  803508:	89 f2                	mov    %esi,%edx
  80350a:	f7 f7                	div    %edi
  80350c:	89 d0                	mov    %edx,%eax
  80350e:	31 d2                	xor    %edx,%edx
  803510:	83 c4 1c             	add    $0x1c,%esp
  803513:	5b                   	pop    %ebx
  803514:	5e                   	pop    %esi
  803515:	5f                   	pop    %edi
  803516:	5d                   	pop    %ebp
  803517:	c3                   	ret    
  803518:	39 f0                	cmp    %esi,%eax
  80351a:	0f 87 ac 00 00 00    	ja     8035cc <__umoddi3+0xfc>
  803520:	0f bd e8             	bsr    %eax,%ebp
  803523:	83 f5 1f             	xor    $0x1f,%ebp
  803526:	0f 84 ac 00 00 00    	je     8035d8 <__umoddi3+0x108>
  80352c:	bf 20 00 00 00       	mov    $0x20,%edi
  803531:	29 ef                	sub    %ebp,%edi
  803533:	89 fe                	mov    %edi,%esi
  803535:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803539:	89 e9                	mov    %ebp,%ecx
  80353b:	d3 e0                	shl    %cl,%eax
  80353d:	89 d7                	mov    %edx,%edi
  80353f:	89 f1                	mov    %esi,%ecx
  803541:	d3 ef                	shr    %cl,%edi
  803543:	09 c7                	or     %eax,%edi
  803545:	89 e9                	mov    %ebp,%ecx
  803547:	d3 e2                	shl    %cl,%edx
  803549:	89 14 24             	mov    %edx,(%esp)
  80354c:	89 d8                	mov    %ebx,%eax
  80354e:	d3 e0                	shl    %cl,%eax
  803550:	89 c2                	mov    %eax,%edx
  803552:	8b 44 24 08          	mov    0x8(%esp),%eax
  803556:	d3 e0                	shl    %cl,%eax
  803558:	89 44 24 04          	mov    %eax,0x4(%esp)
  80355c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803560:	89 f1                	mov    %esi,%ecx
  803562:	d3 e8                	shr    %cl,%eax
  803564:	09 d0                	or     %edx,%eax
  803566:	d3 eb                	shr    %cl,%ebx
  803568:	89 da                	mov    %ebx,%edx
  80356a:	f7 f7                	div    %edi
  80356c:	89 d3                	mov    %edx,%ebx
  80356e:	f7 24 24             	mull   (%esp)
  803571:	89 c6                	mov    %eax,%esi
  803573:	89 d1                	mov    %edx,%ecx
  803575:	39 d3                	cmp    %edx,%ebx
  803577:	0f 82 87 00 00 00    	jb     803604 <__umoddi3+0x134>
  80357d:	0f 84 91 00 00 00    	je     803614 <__umoddi3+0x144>
  803583:	8b 54 24 04          	mov    0x4(%esp),%edx
  803587:	29 f2                	sub    %esi,%edx
  803589:	19 cb                	sbb    %ecx,%ebx
  80358b:	89 d8                	mov    %ebx,%eax
  80358d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803591:	d3 e0                	shl    %cl,%eax
  803593:	89 e9                	mov    %ebp,%ecx
  803595:	d3 ea                	shr    %cl,%edx
  803597:	09 d0                	or     %edx,%eax
  803599:	89 e9                	mov    %ebp,%ecx
  80359b:	d3 eb                	shr    %cl,%ebx
  80359d:	89 da                	mov    %ebx,%edx
  80359f:	83 c4 1c             	add    $0x1c,%esp
  8035a2:	5b                   	pop    %ebx
  8035a3:	5e                   	pop    %esi
  8035a4:	5f                   	pop    %edi
  8035a5:	5d                   	pop    %ebp
  8035a6:	c3                   	ret    
  8035a7:	90                   	nop
  8035a8:	89 fd                	mov    %edi,%ebp
  8035aa:	85 ff                	test   %edi,%edi
  8035ac:	75 0b                	jne    8035b9 <__umoddi3+0xe9>
  8035ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8035b3:	31 d2                	xor    %edx,%edx
  8035b5:	f7 f7                	div    %edi
  8035b7:	89 c5                	mov    %eax,%ebp
  8035b9:	89 f0                	mov    %esi,%eax
  8035bb:	31 d2                	xor    %edx,%edx
  8035bd:	f7 f5                	div    %ebp
  8035bf:	89 c8                	mov    %ecx,%eax
  8035c1:	f7 f5                	div    %ebp
  8035c3:	89 d0                	mov    %edx,%eax
  8035c5:	e9 44 ff ff ff       	jmp    80350e <__umoddi3+0x3e>
  8035ca:	66 90                	xchg   %ax,%ax
  8035cc:	89 c8                	mov    %ecx,%eax
  8035ce:	89 f2                	mov    %esi,%edx
  8035d0:	83 c4 1c             	add    $0x1c,%esp
  8035d3:	5b                   	pop    %ebx
  8035d4:	5e                   	pop    %esi
  8035d5:	5f                   	pop    %edi
  8035d6:	5d                   	pop    %ebp
  8035d7:	c3                   	ret    
  8035d8:	3b 04 24             	cmp    (%esp),%eax
  8035db:	72 06                	jb     8035e3 <__umoddi3+0x113>
  8035dd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035e1:	77 0f                	ja     8035f2 <__umoddi3+0x122>
  8035e3:	89 f2                	mov    %esi,%edx
  8035e5:	29 f9                	sub    %edi,%ecx
  8035e7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035eb:	89 14 24             	mov    %edx,(%esp)
  8035ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035f2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035f6:	8b 14 24             	mov    (%esp),%edx
  8035f9:	83 c4 1c             	add    $0x1c,%esp
  8035fc:	5b                   	pop    %ebx
  8035fd:	5e                   	pop    %esi
  8035fe:	5f                   	pop    %edi
  8035ff:	5d                   	pop    %ebp
  803600:	c3                   	ret    
  803601:	8d 76 00             	lea    0x0(%esi),%esi
  803604:	2b 04 24             	sub    (%esp),%eax
  803607:	19 fa                	sbb    %edi,%edx
  803609:	89 d1                	mov    %edx,%ecx
  80360b:	89 c6                	mov    %eax,%esi
  80360d:	e9 71 ff ff ff       	jmp    803583 <__umoddi3+0xb3>
  803612:	66 90                	xchg   %ax,%ax
  803614:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803618:	72 ea                	jb     803604 <__umoddi3+0x134>
  80361a:	89 d9                	mov    %ebx,%ecx
  80361c:	e9 62 ff ff ff       	jmp    803583 <__umoddi3+0xb3>
