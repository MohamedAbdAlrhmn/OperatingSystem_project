
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
  80008c:	68 60 36 80 00       	push   $0x803660
  800091:	6a 14                	push   $0x14
  800093:	68 7c 36 80 00       	push   $0x80367c
  800098:	e8 78 02 00 00       	call   800315 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	if(STATIC_MEMBLOCK_ALLOC != 0)
		panic("STATIC_MEMBLOCK_ALLOC = 1 & it shall be 0. Go to 'inc/dynamic_allocator.h' and set STATIC_MEMBLOCK_ALLOC by 0. Then, repeat the test again.");

	int freeFrames_before = sys_calculate_free_frames() ;
  80009d:	e8 84 17 00 00       	call   801826 <sys_calculate_free_frames>
  8000a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeDiskFrames_before = sys_pf_calculate_allocated_pages() ;
  8000a5:	e8 1c 18 00 00       	call   8018c6 <sys_pf_calculate_allocated_pages>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	malloc(0);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	e8 9a 14 00 00       	call   801551 <malloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
	int freeFrames_after = sys_calculate_free_frames() ;
  8000ba:	e8 67 17 00 00       	call   801826 <sys_calculate_free_frames>
  8000bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freeDiskFrames_after = sys_pf_calculate_allocated_pages() ;
  8000c2:	e8 ff 17 00 00       	call   8018c6 <sys_pf_calculate_allocated_pages>
  8000c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Check MAX_MEM_BLOCK_CNT
	if(MAX_MEM_BLOCK_CNT != ((0xA0000000-0x80000000)/4096))
  8000ca:	a1 20 51 80 00       	mov    0x805120,%eax
  8000cf:	3d 00 00 02 00       	cmp    $0x20000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
	{
		panic("Wrong initialize: MAX_MEM_BLOCK_CNT is not set with the correct size of the array");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 90 36 80 00       	push   $0x803690
  8000de:	6a 23                	push   $0x23
  8000e0:	68 7c 36 80 00       	push   $0x80367c
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
  8000fd:	68 e4 36 80 00       	push   $0x8036e4
  800102:	6a 29                	push   $0x29
  800104:	68 7c 36 80 00       	push   $0x80367c
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
  80011a:	68 20 37 80 00       	push   $0x803720
  80011f:	6a 2f                	push   $0x2f
  800121:	68 7c 36 80 00       	push   $0x80367c
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
  800138:	68 58 37 80 00       	push   $0x803758
  80013d:	6a 35                	push   $0x35
  80013f:	68 7c 36 80 00       	push   $0x80367c
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
  800174:	68 90 37 80 00       	push   $0x803790
  800179:	6a 3c                	push   $0x3c
  80017b:	68 7c 36 80 00       	push   $0x80367c
  800180:	e8 90 01 00 00       	call   800315 <_panic>
	}

	//Check number of disk and memory frames
	if ((freeDiskFrames_after - freeDiskFrames_before) != 0) panic("Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)");
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80018b:	74 14                	je     8001a1 <_main+0x169>
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 cc 37 80 00       	push   $0x8037cc
  800195:	6a 40                	push   $0x40
  800197:	68 7c 36 80 00       	push   $0x80367c
  80019c:	e8 74 01 00 00       	call   800315 <_panic>
	if ((freeFrames_before - freeFrames_after) != 512 + 1) panic("Wrong allocation: pages are not loaded successfully into memory %d", (freeFrames_before - freeFrames_after));
  8001a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a7:	3d 01 02 00 00       	cmp    $0x201,%eax
  8001ac:	74 18                	je     8001c6 <_main+0x18e>
  8001ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	68 34 38 80 00       	push   $0x803834
  8001ba:	6a 41                	push   $0x41
  8001bc:	68 7c 36 80 00       	push   $0x80367c
  8001c1:	e8 4f 01 00 00       	call   800315 <_panic>

	/*=================================================*/

	cprintf("Congratulations!! test initialize_dyn_block_system of UHEAP completed successfully.\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 78 38 80 00       	push   $0x803878
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
  8001df:	e8 22 19 00 00       	call   801b06 <sys_getenvindex>
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
  80024a:	e8 c4 16 00 00       	call   801913 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 e8 38 80 00       	push   $0x8038e8
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
  80027a:	68 10 39 80 00       	push   $0x803910
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
  8002ab:	68 38 39 80 00       	push   $0x803938
  8002b0:	e8 14 03 00 00       	call   8005c9 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 90 39 80 00       	push   $0x803990
  8002cc:	e8 f8 02 00 00       	call   8005c9 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	68 e8 38 80 00       	push   $0x8038e8
  8002dc:	e8 e8 02 00 00       	call   8005c9 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002e4:	e8 44 16 00 00       	call   80192d <sys_enable_interrupt>

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
  8002fc:	e8 d1 17 00 00       	call   801ad2 <sys_destroy_env>
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
  80030d:	e8 26 18 00 00       	call   801b38 <sys_exit_env>
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
  800336:	68 a4 39 80 00       	push   $0x8039a4
  80033b:	e8 89 02 00 00       	call   8005c9 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800343:	a1 00 50 80 00       	mov    0x805000,%eax
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 a9 39 80 00       	push   $0x8039a9
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
  800373:	68 c5 39 80 00       	push   $0x8039c5
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
  80039f:	68 c8 39 80 00       	push   $0x8039c8
  8003a4:	6a 26                	push   $0x26
  8003a6:	68 14 3a 80 00       	push   $0x803a14
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
  800471:	68 20 3a 80 00       	push   $0x803a20
  800476:	6a 3a                	push   $0x3a
  800478:	68 14 3a 80 00       	push   $0x803a14
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
  8004e1:	68 74 3a 80 00       	push   $0x803a74
  8004e6:	6a 44                	push   $0x44
  8004e8:	68 14 3a 80 00       	push   $0x803a14
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
  80053b:	e8 25 12 00 00       	call   801765 <sys_cputs>
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
  8005b2:	e8 ae 11 00 00       	call   801765 <sys_cputs>
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
  8005fc:	e8 12 13 00 00       	call   801913 <sys_disable_interrupt>
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
  80061c:	e8 0c 13 00 00       	call   80192d <sys_enable_interrupt>
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
  800666:	e8 7d 2d 00 00       	call   8033e8 <__udivdi3>
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
  8006b6:	e8 3d 2e 00 00       	call   8034f8 <__umoddi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	05 d4 3c 80 00       	add    $0x803cd4,%eax
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
  800811:	8b 04 85 f8 3c 80 00 	mov    0x803cf8(,%eax,4),%eax
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
  8008f2:	8b 34 9d 40 3b 80 00 	mov    0x803b40(,%ebx,4),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 19                	jne    800916 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	53                   	push   %ebx
  8008fe:	68 e5 3c 80 00       	push   $0x803ce5
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
  800917:	68 ee 3c 80 00       	push   $0x803cee
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
  800944:	be f1 3c 80 00       	mov    $0x803cf1,%esi
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
  80136a:	68 50 3e 80 00       	push   $0x803e50
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
  80143a:	e8 6a 04 00 00       	call   8018a9 <sys_allocate_chunk>
  80143f:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801442:	a1 20 51 80 00       	mov    0x805120,%eax
  801447:	83 ec 0c             	sub    $0xc,%esp
  80144a:	50                   	push   %eax
  80144b:	e8 df 0a 00 00       	call   801f2f <initialize_MemBlocksList>
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
  801478:	68 75 3e 80 00       	push   $0x803e75
  80147d:	6a 33                	push   $0x33
  80147f:	68 93 3e 80 00       	push   $0x803e93
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
  8014f7:	68 a0 3e 80 00       	push   $0x803ea0
  8014fc:	6a 34                	push   $0x34
  8014fe:	68 93 3e 80 00       	push   $0x803e93
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
  80158f:	e8 e3 06 00 00       	call   801c77 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801594:	85 c0                	test   %eax,%eax
  801596:	74 11                	je     8015a9 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801598:	83 ec 0c             	sub    $0xc,%esp
  80159b:	ff 75 e8             	pushl  -0x18(%ebp)
  80159e:	e8 4e 0d 00 00       	call   8022f1 <alloc_block_FF>
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
  8015b5:	e8 aa 0a 00 00       	call   802064 <insert_sorted_allocList>
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
  8015cf:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	68 c4 3e 80 00       	push   $0x803ec4
  8015da:	6a 6f                	push   $0x6f
  8015dc:	68 93 3e 80 00       	push   $0x803e93
  8015e1:	e8 2f ed ff ff       	call   800315 <_panic>

008015e6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 38             	sub    $0x38,%esp
  8015ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ef:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f2:	e8 5c fd ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fb:	75 07                	jne    801604 <smalloc+0x1e>
  8015fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801602:	eb 7c                	jmp    801680 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801604:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80160b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801611:	01 d0                	add    %edx,%eax
  801613:	48                   	dec    %eax
  801614:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161a:	ba 00 00 00 00       	mov    $0x0,%edx
  80161f:	f7 75 f0             	divl   -0x10(%ebp)
  801622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801625:	29 d0                	sub    %edx,%eax
  801627:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80162a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801631:	e8 41 06 00 00       	call   801c77 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801636:	85 c0                	test   %eax,%eax
  801638:	74 11                	je     80164b <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80163a:	83 ec 0c             	sub    $0xc,%esp
  80163d:	ff 75 e8             	pushl  -0x18(%ebp)
  801640:	e8 ac 0c 00 00       	call   8022f1 <alloc_block_FF>
  801645:	83 c4 10             	add    $0x10,%esp
  801648:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80164b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80164f:	74 2a                	je     80167b <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801654:	8b 40 08             	mov    0x8(%eax),%eax
  801657:	89 c2                	mov    %eax,%edx
  801659:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80165d:	52                   	push   %edx
  80165e:	50                   	push   %eax
  80165f:	ff 75 0c             	pushl  0xc(%ebp)
  801662:	ff 75 08             	pushl  0x8(%ebp)
  801665:	e8 92 03 00 00       	call   8019fc <sys_createSharedObject>
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801670:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801674:	74 05                	je     80167b <smalloc+0x95>
			return (void*)virtual_address;
  801676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801679:	eb 05                	jmp    801680 <smalloc+0x9a>
	}
	return NULL;
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801688:	e8 c6 fc ff ff       	call   801353 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80168d:	83 ec 04             	sub    $0x4,%esp
  801690:	68 e8 3e 80 00       	push   $0x803ee8
  801695:	68 b0 00 00 00       	push   $0xb0
  80169a:	68 93 3e 80 00       	push   $0x803e93
  80169f:	e8 71 ec ff ff       	call   800315 <_panic>

008016a4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016aa:	e8 a4 fc ff ff       	call   801353 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016af:	83 ec 04             	sub    $0x4,%esp
  8016b2:	68 0c 3f 80 00       	push   $0x803f0c
  8016b7:	68 f4 00 00 00       	push   $0xf4
  8016bc:	68 93 3e 80 00       	push   $0x803e93
  8016c1:	e8 4f ec ff ff       	call   800315 <_panic>

008016c6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	68 34 3f 80 00       	push   $0x803f34
  8016d4:	68 08 01 00 00       	push   $0x108
  8016d9:	68 93 3e 80 00       	push   $0x803e93
  8016de:	e8 32 ec ff ff       	call   800315 <_panic>

008016e3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016e9:	83 ec 04             	sub    $0x4,%esp
  8016ec:	68 58 3f 80 00       	push   $0x803f58
  8016f1:	68 13 01 00 00       	push   $0x113
  8016f6:	68 93 3e 80 00       	push   $0x803e93
  8016fb:	e8 15 ec ff ff       	call   800315 <_panic>

00801700 <shrink>:

}
void shrink(uint32 newSize)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801706:	83 ec 04             	sub    $0x4,%esp
  801709:	68 58 3f 80 00       	push   $0x803f58
  80170e:	68 18 01 00 00       	push   $0x118
  801713:	68 93 3e 80 00       	push   $0x803e93
  801718:	e8 f8 eb ff ff       	call   800315 <_panic>

0080171d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801723:	83 ec 04             	sub    $0x4,%esp
  801726:	68 58 3f 80 00       	push   $0x803f58
  80172b:	68 1d 01 00 00       	push   $0x11d
  801730:	68 93 3e 80 00       	push   $0x803e93
  801735:	e8 db eb ff ff       	call   800315 <_panic>

0080173a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	57                   	push   %edi
  80173e:	56                   	push   %esi
  80173f:	53                   	push   %ebx
  801740:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	8b 55 0c             	mov    0xc(%ebp),%edx
  801749:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80174f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801752:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801755:	cd 30                	int    $0x30
  801757:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80175a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	5b                   	pop    %ebx
  801761:	5e                   	pop    %esi
  801762:	5f                   	pop    %edi
  801763:	5d                   	pop    %ebp
  801764:	c3                   	ret    

00801765 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	8b 45 10             	mov    0x10(%ebp),%eax
  80176e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801771:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	52                   	push   %edx
  80177d:	ff 75 0c             	pushl  0xc(%ebp)
  801780:	50                   	push   %eax
  801781:	6a 00                	push   $0x0
  801783:	e8 b2 ff ff ff       	call   80173a <syscall>
  801788:	83 c4 18             	add    $0x18,%esp
}
  80178b:	90                   	nop
  80178c:	c9                   	leave  
  80178d:	c3                   	ret    

0080178e <sys_cgetc>:

int
sys_cgetc(void)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 01                	push   $0x1
  80179d:	e8 98 ff ff ff       	call   80173a <syscall>
  8017a2:	83 c4 18             	add    $0x18,%esp
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	52                   	push   %edx
  8017b7:	50                   	push   %eax
  8017b8:	6a 05                	push   $0x5
  8017ba:	e8 7b ff ff ff       	call   80173a <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	56                   	push   %esi
  8017c8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017c9:	8b 75 18             	mov    0x18(%ebp),%esi
  8017cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	56                   	push   %esi
  8017d9:	53                   	push   %ebx
  8017da:	51                   	push   %ecx
  8017db:	52                   	push   %edx
  8017dc:	50                   	push   %eax
  8017dd:	6a 06                	push   $0x6
  8017df:	e8 56 ff ff ff       	call   80173a <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
}
  8017e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ea:	5b                   	pop    %ebx
  8017eb:	5e                   	pop    %esi
  8017ec:	5d                   	pop    %ebp
  8017ed:	c3                   	ret    

008017ee <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	52                   	push   %edx
  8017fe:	50                   	push   %eax
  8017ff:	6a 07                	push   $0x7
  801801:	e8 34 ff ff ff       	call   80173a <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	ff 75 08             	pushl  0x8(%ebp)
  80181a:	6a 08                	push   $0x8
  80181c:	e8 19 ff ff ff       	call   80173a <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 09                	push   $0x9
  801835:	e8 00 ff ff ff       	call   80173a <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 0a                	push   $0xa
  80184e:	e8 e7 fe ff ff       	call   80173a <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 0b                	push   $0xb
  801867:	e8 ce fe ff ff       	call   80173a <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	ff 75 0c             	pushl  0xc(%ebp)
  80187d:	ff 75 08             	pushl  0x8(%ebp)
  801880:	6a 0f                	push   $0xf
  801882:	e8 b3 fe ff ff       	call   80173a <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
	return;
  80188a:	90                   	nop
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	ff 75 0c             	pushl  0xc(%ebp)
  801899:	ff 75 08             	pushl  0x8(%ebp)
  80189c:	6a 10                	push   $0x10
  80189e:	e8 97 fe ff ff       	call   80173a <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a6:	90                   	nop
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	ff 75 10             	pushl  0x10(%ebp)
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	ff 75 08             	pushl  0x8(%ebp)
  8018b9:	6a 11                	push   $0x11
  8018bb:	e8 7a fe ff ff       	call   80173a <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c3:	90                   	nop
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 0c                	push   $0xc
  8018d5:	e8 60 fe ff ff       	call   80173a <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	ff 75 08             	pushl  0x8(%ebp)
  8018ed:	6a 0d                	push   $0xd
  8018ef:	e8 46 fe ff ff       	call   80173a <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 0e                	push   $0xe
  801908:	e8 2d fe ff ff       	call   80173a <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	90                   	nop
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 13                	push   $0x13
  801922:	e8 13 fe ff ff       	call   80173a <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	90                   	nop
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 14                	push   $0x14
  80193c:	e8 f9 fd ff ff       	call   80173a <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	90                   	nop
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_cputc>:


void
sys_cputc(const char c)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 04             	sub    $0x4,%esp
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801953:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	50                   	push   %eax
  801960:	6a 15                	push   $0x15
  801962:	e8 d3 fd ff ff       	call   80173a <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	90                   	nop
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 16                	push   $0x16
  80197c:	e8 b9 fd ff ff       	call   80173a <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	90                   	nop
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	50                   	push   %eax
  801997:	6a 17                	push   $0x17
  801999:	e8 9c fd ff ff       	call   80173a <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	52                   	push   %edx
  8019b3:	50                   	push   %eax
  8019b4:	6a 1a                	push   $0x1a
  8019b6:	e8 7f fd ff ff       	call   80173a <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	52                   	push   %edx
  8019d0:	50                   	push   %eax
  8019d1:	6a 18                	push   $0x18
  8019d3:	e8 62 fd ff ff       	call   80173a <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	90                   	nop
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	52                   	push   %edx
  8019ee:	50                   	push   %eax
  8019ef:	6a 19                	push   $0x19
  8019f1:	e8 44 fd ff ff       	call   80173a <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	90                   	nop
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	8b 45 10             	mov    0x10(%ebp),%eax
  801a05:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a08:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a0b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	6a 00                	push   $0x0
  801a14:	51                   	push   %ecx
  801a15:	52                   	push   %edx
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	50                   	push   %eax
  801a1a:	6a 1b                	push   $0x1b
  801a1c:	e8 19 fd ff ff       	call   80173a <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	52                   	push   %edx
  801a36:	50                   	push   %eax
  801a37:	6a 1c                	push   $0x1c
  801a39:	e8 fc fc ff ff       	call   80173a <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	51                   	push   %ecx
  801a54:	52                   	push   %edx
  801a55:	50                   	push   %eax
  801a56:	6a 1d                	push   $0x1d
  801a58:	e8 dd fc ff ff       	call   80173a <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	52                   	push   %edx
  801a72:	50                   	push   %eax
  801a73:	6a 1e                	push   $0x1e
  801a75:	e8 c0 fc ff ff       	call   80173a <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 1f                	push   $0x1f
  801a8e:	e8 a7 fc ff ff       	call   80173a <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	6a 00                	push   $0x0
  801aa0:	ff 75 14             	pushl  0x14(%ebp)
  801aa3:	ff 75 10             	pushl  0x10(%ebp)
  801aa6:	ff 75 0c             	pushl  0xc(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	6a 20                	push   $0x20
  801aac:	e8 89 fc ff ff       	call   80173a <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	50                   	push   %eax
  801ac5:	6a 21                	push   $0x21
  801ac7:	e8 6e fc ff ff       	call   80173a <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	90                   	nop
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	50                   	push   %eax
  801ae1:	6a 22                	push   $0x22
  801ae3:	e8 52 fc ff ff       	call   80173a <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 02                	push   $0x2
  801afc:	e8 39 fc ff ff       	call   80173a <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 03                	push   $0x3
  801b15:	e8 20 fc ff ff       	call   80173a <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 04                	push   $0x4
  801b2e:	e8 07 fc ff ff       	call   80173a <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_exit_env>:


void sys_exit_env(void)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 23                	push   $0x23
  801b47:	e8 ee fb ff ff       	call   80173a <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	90                   	nop
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b58:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b5b:	8d 50 04             	lea    0x4(%eax),%edx
  801b5e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	52                   	push   %edx
  801b68:	50                   	push   %eax
  801b69:	6a 24                	push   $0x24
  801b6b:	e8 ca fb ff ff       	call   80173a <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
	return result;
  801b73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b7c:	89 01                	mov    %eax,(%ecx)
  801b7e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	c9                   	leave  
  801b85:	c2 04 00             	ret    $0x4

00801b88 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	ff 75 10             	pushl  0x10(%ebp)
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	ff 75 08             	pushl  0x8(%ebp)
  801b98:	6a 12                	push   $0x12
  801b9a:	e8 9b fb ff ff       	call   80173a <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba2:	90                   	nop
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 25                	push   $0x25
  801bb4:	e8 81 fb ff ff       	call   80173a <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	83 ec 04             	sub    $0x4,%esp
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bca:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	50                   	push   %eax
  801bd7:	6a 26                	push   $0x26
  801bd9:	e8 5c fb ff ff       	call   80173a <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
	return ;
  801be1:	90                   	nop
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <rsttst>:
void rsttst()
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 28                	push   $0x28
  801bf3:	e8 42 fb ff ff       	call   80173a <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfb:	90                   	nop
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 04             	sub    $0x4,%esp
  801c04:	8b 45 14             	mov    0x14(%ebp),%eax
  801c07:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c0a:	8b 55 18             	mov    0x18(%ebp),%edx
  801c0d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c11:	52                   	push   %edx
  801c12:	50                   	push   %eax
  801c13:	ff 75 10             	pushl  0x10(%ebp)
  801c16:	ff 75 0c             	pushl  0xc(%ebp)
  801c19:	ff 75 08             	pushl  0x8(%ebp)
  801c1c:	6a 27                	push   $0x27
  801c1e:	e8 17 fb ff ff       	call   80173a <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
	return ;
  801c26:	90                   	nop
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <chktst>:
void chktst(uint32 n)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	ff 75 08             	pushl  0x8(%ebp)
  801c37:	6a 29                	push   $0x29
  801c39:	e8 fc fa ff ff       	call   80173a <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c41:	90                   	nop
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <inctst>:

void inctst()
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 2a                	push   $0x2a
  801c53:	e8 e2 fa ff ff       	call   80173a <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5b:	90                   	nop
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <gettst>:
uint32 gettst()
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 2b                	push   $0x2b
  801c6d:	e8 c8 fa ff ff       	call   80173a <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 2c                	push   $0x2c
  801c89:	e8 ac fa ff ff       	call   80173a <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
  801c91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c94:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c98:	75 07                	jne    801ca1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9f:	eb 05                	jmp    801ca6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 2c                	push   $0x2c
  801cba:	e8 7b fa ff ff       	call   80173a <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
  801cc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cc5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cc9:	75 07                	jne    801cd2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ccb:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd0:	eb 05                	jmp    801cd7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 2c                	push   $0x2c
  801ceb:	e8 4a fa ff ff       	call   80173a <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
  801cf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cf6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cfa:	75 07                	jne    801d03 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cfc:	b8 01 00 00 00       	mov    $0x1,%eax
  801d01:	eb 05                	jmp    801d08 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 2c                	push   $0x2c
  801d1c:	e8 19 fa ff ff       	call   80173a <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
  801d24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d27:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d2b:	75 07                	jne    801d34 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d32:	eb 05                	jmp    801d39 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	ff 75 08             	pushl  0x8(%ebp)
  801d49:	6a 2d                	push   $0x2d
  801d4b:	e8 ea f9 ff ff       	call   80173a <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
	return ;
  801d53:	90                   	nop
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d5a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	6a 00                	push   $0x0
  801d68:	53                   	push   %ebx
  801d69:	51                   	push   %ecx
  801d6a:	52                   	push   %edx
  801d6b:	50                   	push   %eax
  801d6c:	6a 2e                	push   $0x2e
  801d6e:	e8 c7 f9 ff ff       	call   80173a <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	52                   	push   %edx
  801d8b:	50                   	push   %eax
  801d8c:	6a 2f                	push   $0x2f
  801d8e:	e8 a7 f9 ff ff       	call   80173a <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d9e:	83 ec 0c             	sub    $0xc,%esp
  801da1:	68 68 3f 80 00       	push   $0x803f68
  801da6:	e8 1e e8 ff ff       	call   8005c9 <cprintf>
  801dab:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801dae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801db5:	83 ec 0c             	sub    $0xc,%esp
  801db8:	68 94 3f 80 00       	push   $0x803f94
  801dbd:	e8 07 e8 ff ff       	call   8005c9 <cprintf>
  801dc2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801dc5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dc9:	a1 38 51 80 00       	mov    0x805138,%eax
  801dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd1:	eb 56                	jmp    801e29 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dd7:	74 1c                	je     801df5 <print_mem_block_lists+0x5d>
  801dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddc:	8b 50 08             	mov    0x8(%eax),%edx
  801ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de2:	8b 48 08             	mov    0x8(%eax),%ecx
  801de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de8:	8b 40 0c             	mov    0xc(%eax),%eax
  801deb:	01 c8                	add    %ecx,%eax
  801ded:	39 c2                	cmp    %eax,%edx
  801def:	73 04                	jae    801df5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801df1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df8:	8b 50 08             	mov    0x8(%eax),%edx
  801dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  801e01:	01 c2                	add    %eax,%edx
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	8b 40 08             	mov    0x8(%eax),%eax
  801e09:	83 ec 04             	sub    $0x4,%esp
  801e0c:	52                   	push   %edx
  801e0d:	50                   	push   %eax
  801e0e:	68 a9 3f 80 00       	push   $0x803fa9
  801e13:	e8 b1 e7 ff ff       	call   8005c9 <cprintf>
  801e18:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e21:	a1 40 51 80 00       	mov    0x805140,%eax
  801e26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e2d:	74 07                	je     801e36 <print_mem_block_lists+0x9e>
  801e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e32:	8b 00                	mov    (%eax),%eax
  801e34:	eb 05                	jmp    801e3b <print_mem_block_lists+0xa3>
  801e36:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3b:	a3 40 51 80 00       	mov    %eax,0x805140
  801e40:	a1 40 51 80 00       	mov    0x805140,%eax
  801e45:	85 c0                	test   %eax,%eax
  801e47:	75 8a                	jne    801dd3 <print_mem_block_lists+0x3b>
  801e49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e4d:	75 84                	jne    801dd3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e4f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e53:	75 10                	jne    801e65 <print_mem_block_lists+0xcd>
  801e55:	83 ec 0c             	sub    $0xc,%esp
  801e58:	68 b8 3f 80 00       	push   $0x803fb8
  801e5d:	e8 67 e7 ff ff       	call   8005c9 <cprintf>
  801e62:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e65:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e6c:	83 ec 0c             	sub    $0xc,%esp
  801e6f:	68 dc 3f 80 00       	push   $0x803fdc
  801e74:	e8 50 e7 ff ff       	call   8005c9 <cprintf>
  801e79:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e7c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e80:	a1 40 50 80 00       	mov    0x805040,%eax
  801e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e88:	eb 56                	jmp    801ee0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e8e:	74 1c                	je     801eac <print_mem_block_lists+0x114>
  801e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e93:	8b 50 08             	mov    0x8(%eax),%edx
  801e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e99:	8b 48 08             	mov    0x8(%eax),%ecx
  801e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea2:	01 c8                	add    %ecx,%eax
  801ea4:	39 c2                	cmp    %eax,%edx
  801ea6:	73 04                	jae    801eac <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ea8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	8b 50 08             	mov    0x8(%eax),%edx
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb8:	01 c2                	add    %eax,%edx
  801eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebd:	8b 40 08             	mov    0x8(%eax),%eax
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	52                   	push   %edx
  801ec4:	50                   	push   %eax
  801ec5:	68 a9 3f 80 00       	push   $0x803fa9
  801eca:	e8 fa e6 ff ff       	call   8005c9 <cprintf>
  801ecf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ed8:	a1 48 50 80 00       	mov    0x805048,%eax
  801edd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee4:	74 07                	je     801eed <print_mem_block_lists+0x155>
  801ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee9:	8b 00                	mov    (%eax),%eax
  801eeb:	eb 05                	jmp    801ef2 <print_mem_block_lists+0x15a>
  801eed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef2:	a3 48 50 80 00       	mov    %eax,0x805048
  801ef7:	a1 48 50 80 00       	mov    0x805048,%eax
  801efc:	85 c0                	test   %eax,%eax
  801efe:	75 8a                	jne    801e8a <print_mem_block_lists+0xf2>
  801f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f04:	75 84                	jne    801e8a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f06:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f0a:	75 10                	jne    801f1c <print_mem_block_lists+0x184>
  801f0c:	83 ec 0c             	sub    $0xc,%esp
  801f0f:	68 f4 3f 80 00       	push   $0x803ff4
  801f14:	e8 b0 e6 ff ff       	call   8005c9 <cprintf>
  801f19:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f1c:	83 ec 0c             	sub    $0xc,%esp
  801f1f:	68 68 3f 80 00       	push   $0x803f68
  801f24:	e8 a0 e6 ff ff       	call   8005c9 <cprintf>
  801f29:	83 c4 10             	add    $0x10,%esp

}
  801f2c:	90                   	nop
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f35:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f3c:	00 00 00 
  801f3f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f46:	00 00 00 
  801f49:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f50:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f5a:	e9 9e 00 00 00       	jmp    801ffd <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f5f:	a1 50 50 80 00       	mov    0x805050,%eax
  801f64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f67:	c1 e2 04             	shl    $0x4,%edx
  801f6a:	01 d0                	add    %edx,%eax
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	75 14                	jne    801f84 <initialize_MemBlocksList+0x55>
  801f70:	83 ec 04             	sub    $0x4,%esp
  801f73:	68 1c 40 80 00       	push   $0x80401c
  801f78:	6a 46                	push   $0x46
  801f7a:	68 3f 40 80 00       	push   $0x80403f
  801f7f:	e8 91 e3 ff ff       	call   800315 <_panic>
  801f84:	a1 50 50 80 00       	mov    0x805050,%eax
  801f89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8c:	c1 e2 04             	shl    $0x4,%edx
  801f8f:	01 d0                	add    %edx,%eax
  801f91:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f97:	89 10                	mov    %edx,(%eax)
  801f99:	8b 00                	mov    (%eax),%eax
  801f9b:	85 c0                	test   %eax,%eax
  801f9d:	74 18                	je     801fb7 <initialize_MemBlocksList+0x88>
  801f9f:	a1 48 51 80 00       	mov    0x805148,%eax
  801fa4:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801faa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fad:	c1 e1 04             	shl    $0x4,%ecx
  801fb0:	01 ca                	add    %ecx,%edx
  801fb2:	89 50 04             	mov    %edx,0x4(%eax)
  801fb5:	eb 12                	jmp    801fc9 <initialize_MemBlocksList+0x9a>
  801fb7:	a1 50 50 80 00       	mov    0x805050,%eax
  801fbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbf:	c1 e2 04             	shl    $0x4,%edx
  801fc2:	01 d0                	add    %edx,%eax
  801fc4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fc9:	a1 50 50 80 00       	mov    0x805050,%eax
  801fce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd1:	c1 e2 04             	shl    $0x4,%edx
  801fd4:	01 d0                	add    %edx,%eax
  801fd6:	a3 48 51 80 00       	mov    %eax,0x805148
  801fdb:	a1 50 50 80 00       	mov    0x805050,%eax
  801fe0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe3:	c1 e2 04             	shl    $0x4,%edx
  801fe6:	01 d0                	add    %edx,%eax
  801fe8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fef:	a1 54 51 80 00       	mov    0x805154,%eax
  801ff4:	40                   	inc    %eax
  801ff5:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ffa:	ff 45 f4             	incl   -0xc(%ebp)
  801ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802000:	3b 45 08             	cmp    0x8(%ebp),%eax
  802003:	0f 82 56 ff ff ff    	jb     801f5f <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802009:	90                   	nop
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	8b 00                	mov    (%eax),%eax
  802017:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80201a:	eb 19                	jmp    802035 <find_block+0x29>
	{
		if(va==point->sva)
  80201c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80201f:	8b 40 08             	mov    0x8(%eax),%eax
  802022:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802025:	75 05                	jne    80202c <find_block+0x20>
		   return point;
  802027:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80202a:	eb 36                	jmp    802062 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	8b 40 08             	mov    0x8(%eax),%eax
  802032:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802035:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802039:	74 07                	je     802042 <find_block+0x36>
  80203b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80203e:	8b 00                	mov    (%eax),%eax
  802040:	eb 05                	jmp    802047 <find_block+0x3b>
  802042:	b8 00 00 00 00       	mov    $0x0,%eax
  802047:	8b 55 08             	mov    0x8(%ebp),%edx
  80204a:	89 42 08             	mov    %eax,0x8(%edx)
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	8b 40 08             	mov    0x8(%eax),%eax
  802053:	85 c0                	test   %eax,%eax
  802055:	75 c5                	jne    80201c <find_block+0x10>
  802057:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80205b:	75 bf                	jne    80201c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80205d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80206a:	a1 40 50 80 00       	mov    0x805040,%eax
  80206f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802072:	a1 44 50 80 00       	mov    0x805044,%eax
  802077:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80207a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802080:	74 24                	je     8020a6 <insert_sorted_allocList+0x42>
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	8b 50 08             	mov    0x8(%eax),%edx
  802088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208b:	8b 40 08             	mov    0x8(%eax),%eax
  80208e:	39 c2                	cmp    %eax,%edx
  802090:	76 14                	jbe    8020a6 <insert_sorted_allocList+0x42>
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	8b 50 08             	mov    0x8(%eax),%edx
  802098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209b:	8b 40 08             	mov    0x8(%eax),%eax
  80209e:	39 c2                	cmp    %eax,%edx
  8020a0:	0f 82 60 01 00 00    	jb     802206 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020aa:	75 65                	jne    802111 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b0:	75 14                	jne    8020c6 <insert_sorted_allocList+0x62>
  8020b2:	83 ec 04             	sub    $0x4,%esp
  8020b5:	68 1c 40 80 00       	push   $0x80401c
  8020ba:	6a 6b                	push   $0x6b
  8020bc:	68 3f 40 80 00       	push   $0x80403f
  8020c1:	e8 4f e2 ff ff       	call   800315 <_panic>
  8020c6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	89 10                	mov    %edx,(%eax)
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	8b 00                	mov    (%eax),%eax
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	74 0d                	je     8020e7 <insert_sorted_allocList+0x83>
  8020da:	a1 40 50 80 00       	mov    0x805040,%eax
  8020df:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e2:	89 50 04             	mov    %edx,0x4(%eax)
  8020e5:	eb 08                	jmp    8020ef <insert_sorted_allocList+0x8b>
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	a3 44 50 80 00       	mov    %eax,0x805044
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	a3 40 50 80 00       	mov    %eax,0x805040
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802101:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802106:	40                   	inc    %eax
  802107:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80210c:	e9 dc 01 00 00       	jmp    8022ed <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	8b 50 08             	mov    0x8(%eax),%edx
  802117:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211a:	8b 40 08             	mov    0x8(%eax),%eax
  80211d:	39 c2                	cmp    %eax,%edx
  80211f:	77 6c                	ja     80218d <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802121:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802125:	74 06                	je     80212d <insert_sorted_allocList+0xc9>
  802127:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80212b:	75 14                	jne    802141 <insert_sorted_allocList+0xdd>
  80212d:	83 ec 04             	sub    $0x4,%esp
  802130:	68 58 40 80 00       	push   $0x804058
  802135:	6a 6f                	push   $0x6f
  802137:	68 3f 40 80 00       	push   $0x80403f
  80213c:	e8 d4 e1 ff ff       	call   800315 <_panic>
  802141:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802144:	8b 50 04             	mov    0x4(%eax),%edx
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	89 50 04             	mov    %edx,0x4(%eax)
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802153:	89 10                	mov    %edx,(%eax)
  802155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802158:	8b 40 04             	mov    0x4(%eax),%eax
  80215b:	85 c0                	test   %eax,%eax
  80215d:	74 0d                	je     80216c <insert_sorted_allocList+0x108>
  80215f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802162:	8b 40 04             	mov    0x4(%eax),%eax
  802165:	8b 55 08             	mov    0x8(%ebp),%edx
  802168:	89 10                	mov    %edx,(%eax)
  80216a:	eb 08                	jmp    802174 <insert_sorted_allocList+0x110>
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	a3 40 50 80 00       	mov    %eax,0x805040
  802174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802177:	8b 55 08             	mov    0x8(%ebp),%edx
  80217a:	89 50 04             	mov    %edx,0x4(%eax)
  80217d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802182:	40                   	inc    %eax
  802183:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802188:	e9 60 01 00 00       	jmp    8022ed <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	8b 50 08             	mov    0x8(%eax),%edx
  802193:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802196:	8b 40 08             	mov    0x8(%eax),%eax
  802199:	39 c2                	cmp    %eax,%edx
  80219b:	0f 82 4c 01 00 00    	jb     8022ed <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a5:	75 14                	jne    8021bb <insert_sorted_allocList+0x157>
  8021a7:	83 ec 04             	sub    $0x4,%esp
  8021aa:	68 90 40 80 00       	push   $0x804090
  8021af:	6a 73                	push   $0x73
  8021b1:	68 3f 40 80 00       	push   $0x80403f
  8021b6:	e8 5a e1 ff ff       	call   800315 <_panic>
  8021bb:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	89 50 04             	mov    %edx,0x4(%eax)
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	8b 40 04             	mov    0x4(%eax),%eax
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	74 0c                	je     8021dd <insert_sorted_allocList+0x179>
  8021d1:	a1 44 50 80 00       	mov    0x805044,%eax
  8021d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d9:	89 10                	mov    %edx,(%eax)
  8021db:	eb 08                	jmp    8021e5 <insert_sorted_allocList+0x181>
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	a3 40 50 80 00       	mov    %eax,0x805040
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	a3 44 50 80 00       	mov    %eax,0x805044
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021f6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021fb:	40                   	inc    %eax
  8021fc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802201:	e9 e7 00 00 00       	jmp    8022ed <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802206:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802209:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80220c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802213:	a1 40 50 80 00       	mov    0x805040,%eax
  802218:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221b:	e9 9d 00 00 00       	jmp    8022bd <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802223:	8b 00                	mov    (%eax),%eax
  802225:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	8b 50 08             	mov    0x8(%eax),%edx
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	8b 40 08             	mov    0x8(%eax),%eax
  802234:	39 c2                	cmp    %eax,%edx
  802236:	76 7d                	jbe    8022b5 <insert_sorted_allocList+0x251>
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	8b 50 08             	mov    0x8(%eax),%edx
  80223e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802241:	8b 40 08             	mov    0x8(%eax),%eax
  802244:	39 c2                	cmp    %eax,%edx
  802246:	73 6d                	jae    8022b5 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802248:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224c:	74 06                	je     802254 <insert_sorted_allocList+0x1f0>
  80224e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802252:	75 14                	jne    802268 <insert_sorted_allocList+0x204>
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	68 b4 40 80 00       	push   $0x8040b4
  80225c:	6a 7f                	push   $0x7f
  80225e:	68 3f 40 80 00       	push   $0x80403f
  802263:	e8 ad e0 ff ff       	call   800315 <_panic>
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	8b 10                	mov    (%eax),%edx
  80226d:	8b 45 08             	mov    0x8(%ebp),%eax
  802270:	89 10                	mov    %edx,(%eax)
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	8b 00                	mov    (%eax),%eax
  802277:	85 c0                	test   %eax,%eax
  802279:	74 0b                	je     802286 <insert_sorted_allocList+0x222>
  80227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227e:	8b 00                	mov    (%eax),%eax
  802280:	8b 55 08             	mov    0x8(%ebp),%edx
  802283:	89 50 04             	mov    %edx,0x4(%eax)
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 55 08             	mov    0x8(%ebp),%edx
  80228c:	89 10                	mov    %edx,(%eax)
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802294:	89 50 04             	mov    %edx,0x4(%eax)
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	8b 00                	mov    (%eax),%eax
  80229c:	85 c0                	test   %eax,%eax
  80229e:	75 08                	jne    8022a8 <insert_sorted_allocList+0x244>
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	a3 44 50 80 00       	mov    %eax,0x805044
  8022a8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ad:	40                   	inc    %eax
  8022ae:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022b3:	eb 39                	jmp    8022ee <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022b5:	a1 48 50 80 00       	mov    0x805048,%eax
  8022ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c1:	74 07                	je     8022ca <insert_sorted_allocList+0x266>
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	eb 05                	jmp    8022cf <insert_sorted_allocList+0x26b>
  8022ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8022cf:	a3 48 50 80 00       	mov    %eax,0x805048
  8022d4:	a1 48 50 80 00       	mov    0x805048,%eax
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	0f 85 3f ff ff ff    	jne    802220 <insert_sorted_allocList+0x1bc>
  8022e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e5:	0f 85 35 ff ff ff    	jne    802220 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022eb:	eb 01                	jmp    8022ee <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022ed:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022ee:	90                   	nop
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022f7:	a1 38 51 80 00       	mov    0x805138,%eax
  8022fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ff:	e9 85 01 00 00       	jmp    802489 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802307:	8b 40 0c             	mov    0xc(%eax),%eax
  80230a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80230d:	0f 82 6e 01 00 00    	jb     802481 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 40 0c             	mov    0xc(%eax),%eax
  802319:	3b 45 08             	cmp    0x8(%ebp),%eax
  80231c:	0f 85 8a 00 00 00    	jne    8023ac <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802322:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802326:	75 17                	jne    80233f <alloc_block_FF+0x4e>
  802328:	83 ec 04             	sub    $0x4,%esp
  80232b:	68 e8 40 80 00       	push   $0x8040e8
  802330:	68 93 00 00 00       	push   $0x93
  802335:	68 3f 40 80 00       	push   $0x80403f
  80233a:	e8 d6 df ff ff       	call   800315 <_panic>
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	8b 00                	mov    (%eax),%eax
  802344:	85 c0                	test   %eax,%eax
  802346:	74 10                	je     802358 <alloc_block_FF+0x67>
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802350:	8b 52 04             	mov    0x4(%edx),%edx
  802353:	89 50 04             	mov    %edx,0x4(%eax)
  802356:	eb 0b                	jmp    802363 <alloc_block_FF+0x72>
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 40 04             	mov    0x4(%eax),%eax
  80235e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	8b 40 04             	mov    0x4(%eax),%eax
  802369:	85 c0                	test   %eax,%eax
  80236b:	74 0f                	je     80237c <alloc_block_FF+0x8b>
  80236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802370:	8b 40 04             	mov    0x4(%eax),%eax
  802373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802376:	8b 12                	mov    (%edx),%edx
  802378:	89 10                	mov    %edx,(%eax)
  80237a:	eb 0a                	jmp    802386 <alloc_block_FF+0x95>
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	8b 00                	mov    (%eax),%eax
  802381:	a3 38 51 80 00       	mov    %eax,0x805138
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802399:	a1 44 51 80 00       	mov    0x805144,%eax
  80239e:	48                   	dec    %eax
  80239f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	e9 10 01 00 00       	jmp    8024bc <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b5:	0f 86 c6 00 00 00    	jbe    802481 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023bb:	a1 48 51 80 00       	mov    0x805148,%eax
  8023c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 50 08             	mov    0x8(%eax),%edx
  8023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cc:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d5:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023dc:	75 17                	jne    8023f5 <alloc_block_FF+0x104>
  8023de:	83 ec 04             	sub    $0x4,%esp
  8023e1:	68 e8 40 80 00       	push   $0x8040e8
  8023e6:	68 9b 00 00 00       	push   $0x9b
  8023eb:	68 3f 40 80 00       	push   $0x80403f
  8023f0:	e8 20 df ff ff       	call   800315 <_panic>
  8023f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f8:	8b 00                	mov    (%eax),%eax
  8023fa:	85 c0                	test   %eax,%eax
  8023fc:	74 10                	je     80240e <alloc_block_FF+0x11d>
  8023fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802406:	8b 52 04             	mov    0x4(%edx),%edx
  802409:	89 50 04             	mov    %edx,0x4(%eax)
  80240c:	eb 0b                	jmp    802419 <alloc_block_FF+0x128>
  80240e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802411:	8b 40 04             	mov    0x4(%eax),%eax
  802414:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241c:	8b 40 04             	mov    0x4(%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	74 0f                	je     802432 <alloc_block_FF+0x141>
  802423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802426:	8b 40 04             	mov    0x4(%eax),%eax
  802429:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80242c:	8b 12                	mov    (%edx),%edx
  80242e:	89 10                	mov    %edx,(%eax)
  802430:	eb 0a                	jmp    80243c <alloc_block_FF+0x14b>
  802432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802435:	8b 00                	mov    (%eax),%eax
  802437:	a3 48 51 80 00       	mov    %eax,0x805148
  80243c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802448:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244f:	a1 54 51 80 00       	mov    0x805154,%eax
  802454:	48                   	dec    %eax
  802455:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	8b 50 08             	mov    0x8(%eax),%edx
  802460:	8b 45 08             	mov    0x8(%ebp),%eax
  802463:	01 c2                	add    %eax,%edx
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 40 0c             	mov    0xc(%eax),%eax
  802471:	2b 45 08             	sub    0x8(%ebp),%eax
  802474:	89 c2                	mov    %eax,%edx
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80247c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247f:	eb 3b                	jmp    8024bc <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802481:	a1 40 51 80 00       	mov    0x805140,%eax
  802486:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248d:	74 07                	je     802496 <alloc_block_FF+0x1a5>
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	eb 05                	jmp    80249b <alloc_block_FF+0x1aa>
  802496:	b8 00 00 00 00       	mov    $0x0,%eax
  80249b:	a3 40 51 80 00       	mov    %eax,0x805140
  8024a0:	a1 40 51 80 00       	mov    0x805140,%eax
  8024a5:	85 c0                	test   %eax,%eax
  8024a7:	0f 85 57 fe ff ff    	jne    802304 <alloc_block_FF+0x13>
  8024ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b1:	0f 85 4d fe ff ff    	jne    802304 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bc:	c9                   	leave  
  8024bd:	c3                   	ret    

008024be <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024be:	55                   	push   %ebp
  8024bf:	89 e5                	mov    %esp,%ebp
  8024c1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8024d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d3:	e9 df 00 00 00       	jmp    8025b7 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 40 0c             	mov    0xc(%eax),%eax
  8024de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e1:	0f 82 c8 00 00 00    	jb     8025af <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f0:	0f 85 8a 00 00 00    	jne    802580 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fa:	75 17                	jne    802513 <alloc_block_BF+0x55>
  8024fc:	83 ec 04             	sub    $0x4,%esp
  8024ff:	68 e8 40 80 00       	push   $0x8040e8
  802504:	68 b7 00 00 00       	push   $0xb7
  802509:	68 3f 40 80 00       	push   $0x80403f
  80250e:	e8 02 de ff ff       	call   800315 <_panic>
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 00                	mov    (%eax),%eax
  802518:	85 c0                	test   %eax,%eax
  80251a:	74 10                	je     80252c <alloc_block_BF+0x6e>
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 00                	mov    (%eax),%eax
  802521:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802524:	8b 52 04             	mov    0x4(%edx),%edx
  802527:	89 50 04             	mov    %edx,0x4(%eax)
  80252a:	eb 0b                	jmp    802537 <alloc_block_BF+0x79>
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 40 04             	mov    0x4(%eax),%eax
  802532:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 04             	mov    0x4(%eax),%eax
  80253d:	85 c0                	test   %eax,%eax
  80253f:	74 0f                	je     802550 <alloc_block_BF+0x92>
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 40 04             	mov    0x4(%eax),%eax
  802547:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254a:	8b 12                	mov    (%edx),%edx
  80254c:	89 10                	mov    %edx,(%eax)
  80254e:	eb 0a                	jmp    80255a <alloc_block_BF+0x9c>
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 00                	mov    (%eax),%eax
  802555:	a3 38 51 80 00       	mov    %eax,0x805138
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80256d:	a1 44 51 80 00       	mov    0x805144,%eax
  802572:	48                   	dec    %eax
  802573:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	e9 4d 01 00 00       	jmp    8026cd <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 40 0c             	mov    0xc(%eax),%eax
  802586:	3b 45 08             	cmp    0x8(%ebp),%eax
  802589:	76 24                	jbe    8025af <alloc_block_BF+0xf1>
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 40 0c             	mov    0xc(%eax),%eax
  802591:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802594:	73 19                	jae    8025af <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802596:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 40 08             	mov    0x8(%eax),%eax
  8025ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025af:	a1 40 51 80 00       	mov    0x805140,%eax
  8025b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bb:	74 07                	je     8025c4 <alloc_block_BF+0x106>
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 00                	mov    (%eax),%eax
  8025c2:	eb 05                	jmp    8025c9 <alloc_block_BF+0x10b>
  8025c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c9:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ce:	a1 40 51 80 00       	mov    0x805140,%eax
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	0f 85 fd fe ff ff    	jne    8024d8 <alloc_block_BF+0x1a>
  8025db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025df:	0f 85 f3 fe ff ff    	jne    8024d8 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025e9:	0f 84 d9 00 00 00    	je     8026c8 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025ef:	a1 48 51 80 00       	mov    0x805148,%eax
  8025f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025fd:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802603:	8b 55 08             	mov    0x8(%ebp),%edx
  802606:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802609:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80260d:	75 17                	jne    802626 <alloc_block_BF+0x168>
  80260f:	83 ec 04             	sub    $0x4,%esp
  802612:	68 e8 40 80 00       	push   $0x8040e8
  802617:	68 c7 00 00 00       	push   $0xc7
  80261c:	68 3f 40 80 00       	push   $0x80403f
  802621:	e8 ef dc ff ff       	call   800315 <_panic>
  802626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	85 c0                	test   %eax,%eax
  80262d:	74 10                	je     80263f <alloc_block_BF+0x181>
  80262f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802632:	8b 00                	mov    (%eax),%eax
  802634:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802637:	8b 52 04             	mov    0x4(%edx),%edx
  80263a:	89 50 04             	mov    %edx,0x4(%eax)
  80263d:	eb 0b                	jmp    80264a <alloc_block_BF+0x18c>
  80263f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802642:	8b 40 04             	mov    0x4(%eax),%eax
  802645:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80264a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264d:	8b 40 04             	mov    0x4(%eax),%eax
  802650:	85 c0                	test   %eax,%eax
  802652:	74 0f                	je     802663 <alloc_block_BF+0x1a5>
  802654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802657:	8b 40 04             	mov    0x4(%eax),%eax
  80265a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80265d:	8b 12                	mov    (%edx),%edx
  80265f:	89 10                	mov    %edx,(%eax)
  802661:	eb 0a                	jmp    80266d <alloc_block_BF+0x1af>
  802663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802666:	8b 00                	mov    (%eax),%eax
  802668:	a3 48 51 80 00       	mov    %eax,0x805148
  80266d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802679:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802680:	a1 54 51 80 00       	mov    0x805154,%eax
  802685:	48                   	dec    %eax
  802686:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80268b:	83 ec 08             	sub    $0x8,%esp
  80268e:	ff 75 ec             	pushl  -0x14(%ebp)
  802691:	68 38 51 80 00       	push   $0x805138
  802696:	e8 71 f9 ff ff       	call   80200c <find_block>
  80269b:	83 c4 10             	add    $0x10,%esp
  80269e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a4:	8b 50 08             	mov    0x8(%eax),%edx
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	01 c2                	add    %eax,%edx
  8026ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026af:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b8:	2b 45 08             	sub    0x8(%ebp),%eax
  8026bb:	89 c2                	mov    %eax,%edx
  8026bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c0:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c6:	eb 05                	jmp    8026cd <alloc_block_BF+0x20f>
	}
	return NULL;
  8026c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
  8026d2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026d5:	a1 28 50 80 00       	mov    0x805028,%eax
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	0f 85 de 01 00 00    	jne    8028c0 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8026e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ea:	e9 9e 01 00 00       	jmp    80288d <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f8:	0f 82 87 01 00 00    	jb     802885 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 40 0c             	mov    0xc(%eax),%eax
  802704:	3b 45 08             	cmp    0x8(%ebp),%eax
  802707:	0f 85 95 00 00 00    	jne    8027a2 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80270d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802711:	75 17                	jne    80272a <alloc_block_NF+0x5b>
  802713:	83 ec 04             	sub    $0x4,%esp
  802716:	68 e8 40 80 00       	push   $0x8040e8
  80271b:	68 e0 00 00 00       	push   $0xe0
  802720:	68 3f 40 80 00       	push   $0x80403f
  802725:	e8 eb db ff ff       	call   800315 <_panic>
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	85 c0                	test   %eax,%eax
  802731:	74 10                	je     802743 <alloc_block_NF+0x74>
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273b:	8b 52 04             	mov    0x4(%edx),%edx
  80273e:	89 50 04             	mov    %edx,0x4(%eax)
  802741:	eb 0b                	jmp    80274e <alloc_block_NF+0x7f>
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 04             	mov    0x4(%eax),%eax
  802749:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 40 04             	mov    0x4(%eax),%eax
  802754:	85 c0                	test   %eax,%eax
  802756:	74 0f                	je     802767 <alloc_block_NF+0x98>
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 40 04             	mov    0x4(%eax),%eax
  80275e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802761:	8b 12                	mov    (%edx),%edx
  802763:	89 10                	mov    %edx,(%eax)
  802765:	eb 0a                	jmp    802771 <alloc_block_NF+0xa2>
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 00                	mov    (%eax),%eax
  80276c:	a3 38 51 80 00       	mov    %eax,0x805138
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802784:	a1 44 51 80 00       	mov    0x805144,%eax
  802789:	48                   	dec    %eax
  80278a:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 40 08             	mov    0x8(%eax),%eax
  802795:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	e9 f8 04 00 00       	jmp    802c9a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ab:	0f 86 d4 00 00 00    	jbe    802885 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027b1:	a1 48 51 80 00       	mov    0x805148,%eax
  8027b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 50 08             	mov    0x8(%eax),%edx
  8027bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c2:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8027cb:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027d2:	75 17                	jne    8027eb <alloc_block_NF+0x11c>
  8027d4:	83 ec 04             	sub    $0x4,%esp
  8027d7:	68 e8 40 80 00       	push   $0x8040e8
  8027dc:	68 e9 00 00 00       	push   $0xe9
  8027e1:	68 3f 40 80 00       	push   $0x80403f
  8027e6:	e8 2a db ff ff       	call   800315 <_panic>
  8027eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	74 10                	je     802804 <alloc_block_NF+0x135>
  8027f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f7:	8b 00                	mov    (%eax),%eax
  8027f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027fc:	8b 52 04             	mov    0x4(%edx),%edx
  8027ff:	89 50 04             	mov    %edx,0x4(%eax)
  802802:	eb 0b                	jmp    80280f <alloc_block_NF+0x140>
  802804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802807:	8b 40 04             	mov    0x4(%eax),%eax
  80280a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80280f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802812:	8b 40 04             	mov    0x4(%eax),%eax
  802815:	85 c0                	test   %eax,%eax
  802817:	74 0f                	je     802828 <alloc_block_NF+0x159>
  802819:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281c:	8b 40 04             	mov    0x4(%eax),%eax
  80281f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802822:	8b 12                	mov    (%edx),%edx
  802824:	89 10                	mov    %edx,(%eax)
  802826:	eb 0a                	jmp    802832 <alloc_block_NF+0x163>
  802828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282b:	8b 00                	mov    (%eax),%eax
  80282d:	a3 48 51 80 00       	mov    %eax,0x805148
  802832:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802835:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802845:	a1 54 51 80 00       	mov    0x805154,%eax
  80284a:	48                   	dec    %eax
  80284b:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802853:	8b 40 08             	mov    0x8(%eax),%eax
  802856:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 50 08             	mov    0x8(%eax),%edx
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	01 c2                	add    %eax,%edx
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 40 0c             	mov    0xc(%eax),%eax
  802872:	2b 45 08             	sub    0x8(%ebp),%eax
  802875:	89 c2                	mov    %eax,%edx
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80287d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802880:	e9 15 04 00 00       	jmp    802c9a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802885:	a1 40 51 80 00       	mov    0x805140,%eax
  80288a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802891:	74 07                	je     80289a <alloc_block_NF+0x1cb>
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 00                	mov    (%eax),%eax
  802898:	eb 05                	jmp    80289f <alloc_block_NF+0x1d0>
  80289a:	b8 00 00 00 00       	mov    $0x0,%eax
  80289f:	a3 40 51 80 00       	mov    %eax,0x805140
  8028a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8028a9:	85 c0                	test   %eax,%eax
  8028ab:	0f 85 3e fe ff ff    	jne    8026ef <alloc_block_NF+0x20>
  8028b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b5:	0f 85 34 fe ff ff    	jne    8026ef <alloc_block_NF+0x20>
  8028bb:	e9 d5 03 00 00       	jmp    802c95 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028c0:	a1 38 51 80 00       	mov    0x805138,%eax
  8028c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c8:	e9 b1 01 00 00       	jmp    802a7e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 50 08             	mov    0x8(%eax),%edx
  8028d3:	a1 28 50 80 00       	mov    0x805028,%eax
  8028d8:	39 c2                	cmp    %eax,%edx
  8028da:	0f 82 96 01 00 00    	jb     802a76 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e9:	0f 82 87 01 00 00    	jb     802a76 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f8:	0f 85 95 00 00 00    	jne    802993 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802902:	75 17                	jne    80291b <alloc_block_NF+0x24c>
  802904:	83 ec 04             	sub    $0x4,%esp
  802907:	68 e8 40 80 00       	push   $0x8040e8
  80290c:	68 fc 00 00 00       	push   $0xfc
  802911:	68 3f 40 80 00       	push   $0x80403f
  802916:	e8 fa d9 ff ff       	call   800315 <_panic>
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	85 c0                	test   %eax,%eax
  802922:	74 10                	je     802934 <alloc_block_NF+0x265>
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 00                	mov    (%eax),%eax
  802929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292c:	8b 52 04             	mov    0x4(%edx),%edx
  80292f:	89 50 04             	mov    %edx,0x4(%eax)
  802932:	eb 0b                	jmp    80293f <alloc_block_NF+0x270>
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 40 04             	mov    0x4(%eax),%eax
  80293a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 40 04             	mov    0x4(%eax),%eax
  802945:	85 c0                	test   %eax,%eax
  802947:	74 0f                	je     802958 <alloc_block_NF+0x289>
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 40 04             	mov    0x4(%eax),%eax
  80294f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802952:	8b 12                	mov    (%edx),%edx
  802954:	89 10                	mov    %edx,(%eax)
  802956:	eb 0a                	jmp    802962 <alloc_block_NF+0x293>
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	8b 00                	mov    (%eax),%eax
  80295d:	a3 38 51 80 00       	mov    %eax,0x805138
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802975:	a1 44 51 80 00       	mov    0x805144,%eax
  80297a:	48                   	dec    %eax
  80297b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 40 08             	mov    0x8(%eax),%eax
  802986:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	e9 07 03 00 00       	jmp    802c9a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 40 0c             	mov    0xc(%eax),%eax
  802999:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299c:	0f 86 d4 00 00 00    	jbe    802a76 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8029a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ad:	8b 50 08             	mov    0x8(%eax),%edx
  8029b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bc:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029c3:	75 17                	jne    8029dc <alloc_block_NF+0x30d>
  8029c5:	83 ec 04             	sub    $0x4,%esp
  8029c8:	68 e8 40 80 00       	push   $0x8040e8
  8029cd:	68 04 01 00 00       	push   $0x104
  8029d2:	68 3f 40 80 00       	push   $0x80403f
  8029d7:	e8 39 d9 ff ff       	call   800315 <_panic>
  8029dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029df:	8b 00                	mov    (%eax),%eax
  8029e1:	85 c0                	test   %eax,%eax
  8029e3:	74 10                	je     8029f5 <alloc_block_NF+0x326>
  8029e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e8:	8b 00                	mov    (%eax),%eax
  8029ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029ed:	8b 52 04             	mov    0x4(%edx),%edx
  8029f0:	89 50 04             	mov    %edx,0x4(%eax)
  8029f3:	eb 0b                	jmp    802a00 <alloc_block_NF+0x331>
  8029f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f8:	8b 40 04             	mov    0x4(%eax),%eax
  8029fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a03:	8b 40 04             	mov    0x4(%eax),%eax
  802a06:	85 c0                	test   %eax,%eax
  802a08:	74 0f                	je     802a19 <alloc_block_NF+0x34a>
  802a0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0d:	8b 40 04             	mov    0x4(%eax),%eax
  802a10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a13:	8b 12                	mov    (%edx),%edx
  802a15:	89 10                	mov    %edx,(%eax)
  802a17:	eb 0a                	jmp    802a23 <alloc_block_NF+0x354>
  802a19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1c:	8b 00                	mov    (%eax),%eax
  802a1e:	a3 48 51 80 00       	mov    %eax,0x805148
  802a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a36:	a1 54 51 80 00       	mov    0x805154,%eax
  802a3b:	48                   	dec    %eax
  802a3c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a44:	8b 40 08             	mov    0x8(%eax),%eax
  802a47:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 50 08             	mov    0x8(%eax),%edx
  802a52:	8b 45 08             	mov    0x8(%ebp),%eax
  802a55:	01 c2                	add    %eax,%edx
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8b 40 0c             	mov    0xc(%eax),%eax
  802a63:	2b 45 08             	sub    0x8(%ebp),%eax
  802a66:	89 c2                	mov    %eax,%edx
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a71:	e9 24 02 00 00       	jmp    802c9a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a76:	a1 40 51 80 00       	mov    0x805140,%eax
  802a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a82:	74 07                	je     802a8b <alloc_block_NF+0x3bc>
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	8b 00                	mov    (%eax),%eax
  802a89:	eb 05                	jmp    802a90 <alloc_block_NF+0x3c1>
  802a8b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a90:	a3 40 51 80 00       	mov    %eax,0x805140
  802a95:	a1 40 51 80 00       	mov    0x805140,%eax
  802a9a:	85 c0                	test   %eax,%eax
  802a9c:	0f 85 2b fe ff ff    	jne    8028cd <alloc_block_NF+0x1fe>
  802aa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa6:	0f 85 21 fe ff ff    	jne    8028cd <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aac:	a1 38 51 80 00       	mov    0x805138,%eax
  802ab1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab4:	e9 ae 01 00 00       	jmp    802c67 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 50 08             	mov    0x8(%eax),%edx
  802abf:	a1 28 50 80 00       	mov    0x805028,%eax
  802ac4:	39 c2                	cmp    %eax,%edx
  802ac6:	0f 83 93 01 00 00    	jae    802c5f <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad5:	0f 82 84 01 00 00    	jb     802c5f <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae4:	0f 85 95 00 00 00    	jne    802b7f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802aea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aee:	75 17                	jne    802b07 <alloc_block_NF+0x438>
  802af0:	83 ec 04             	sub    $0x4,%esp
  802af3:	68 e8 40 80 00       	push   $0x8040e8
  802af8:	68 14 01 00 00       	push   $0x114
  802afd:	68 3f 40 80 00       	push   $0x80403f
  802b02:	e8 0e d8 ff ff       	call   800315 <_panic>
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 00                	mov    (%eax),%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	74 10                	je     802b20 <alloc_block_NF+0x451>
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b18:	8b 52 04             	mov    0x4(%edx),%edx
  802b1b:	89 50 04             	mov    %edx,0x4(%eax)
  802b1e:	eb 0b                	jmp    802b2b <alloc_block_NF+0x45c>
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 40 04             	mov    0x4(%eax),%eax
  802b26:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	8b 40 04             	mov    0x4(%eax),%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	74 0f                	je     802b44 <alloc_block_NF+0x475>
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 40 04             	mov    0x4(%eax),%eax
  802b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3e:	8b 12                	mov    (%edx),%edx
  802b40:	89 10                	mov    %edx,(%eax)
  802b42:	eb 0a                	jmp    802b4e <alloc_block_NF+0x47f>
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 00                	mov    (%eax),%eax
  802b49:	a3 38 51 80 00       	mov    %eax,0x805138
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b61:	a1 44 51 80 00       	mov    0x805144,%eax
  802b66:	48                   	dec    %eax
  802b67:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	8b 40 08             	mov    0x8(%eax),%eax
  802b72:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	e9 1b 01 00 00       	jmp    802c9a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 40 0c             	mov    0xc(%eax),%eax
  802b85:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b88:	0f 86 d1 00 00 00    	jbe    802c5f <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b8e:	a1 48 51 80 00       	mov    0x805148,%eax
  802b93:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	8b 50 08             	mov    0x8(%eax),%edx
  802b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802baf:	75 17                	jne    802bc8 <alloc_block_NF+0x4f9>
  802bb1:	83 ec 04             	sub    $0x4,%esp
  802bb4:	68 e8 40 80 00       	push   $0x8040e8
  802bb9:	68 1c 01 00 00       	push   $0x11c
  802bbe:	68 3f 40 80 00       	push   $0x80403f
  802bc3:	e8 4d d7 ff ff       	call   800315 <_panic>
  802bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcb:	8b 00                	mov    (%eax),%eax
  802bcd:	85 c0                	test   %eax,%eax
  802bcf:	74 10                	je     802be1 <alloc_block_NF+0x512>
  802bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd4:	8b 00                	mov    (%eax),%eax
  802bd6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd9:	8b 52 04             	mov    0x4(%edx),%edx
  802bdc:	89 50 04             	mov    %edx,0x4(%eax)
  802bdf:	eb 0b                	jmp    802bec <alloc_block_NF+0x51d>
  802be1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be4:	8b 40 04             	mov    0x4(%eax),%eax
  802be7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bef:	8b 40 04             	mov    0x4(%eax),%eax
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	74 0f                	je     802c05 <alloc_block_NF+0x536>
  802bf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf9:	8b 40 04             	mov    0x4(%eax),%eax
  802bfc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bff:	8b 12                	mov    (%edx),%edx
  802c01:	89 10                	mov    %edx,(%eax)
  802c03:	eb 0a                	jmp    802c0f <alloc_block_NF+0x540>
  802c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c08:	8b 00                	mov    (%eax),%eax
  802c0a:	a3 48 51 80 00       	mov    %eax,0x805148
  802c0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c22:	a1 54 51 80 00       	mov    0x805154,%eax
  802c27:	48                   	dec    %eax
  802c28:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c30:	8b 40 08             	mov    0x8(%eax),%eax
  802c33:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 50 08             	mov    0x8(%eax),%edx
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	01 c2                	add    %eax,%edx
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4f:	2b 45 08             	sub    0x8(%ebp),%eax
  802c52:	89 c2                	mov    %eax,%edx
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	eb 3b                	jmp    802c9a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c5f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6b:	74 07                	je     802c74 <alloc_block_NF+0x5a5>
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 00                	mov    (%eax),%eax
  802c72:	eb 05                	jmp    802c79 <alloc_block_NF+0x5aa>
  802c74:	b8 00 00 00 00       	mov    $0x0,%eax
  802c79:	a3 40 51 80 00       	mov    %eax,0x805140
  802c7e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	0f 85 2e fe ff ff    	jne    802ab9 <alloc_block_NF+0x3ea>
  802c8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8f:	0f 85 24 fe ff ff    	jne    802ab9 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c9a:	c9                   	leave  
  802c9b:	c3                   	ret    

00802c9c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c9c:	55                   	push   %ebp
  802c9d:	89 e5                	mov    %esp,%ebp
  802c9f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ca2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802caa:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802caf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cb2:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	74 14                	je     802ccf <insert_sorted_with_merge_freeList+0x33>
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	8b 50 08             	mov    0x8(%eax),%edx
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	8b 40 08             	mov    0x8(%eax),%eax
  802cc7:	39 c2                	cmp    %eax,%edx
  802cc9:	0f 87 9b 01 00 00    	ja     802e6a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ccf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd3:	75 17                	jne    802cec <insert_sorted_with_merge_freeList+0x50>
  802cd5:	83 ec 04             	sub    $0x4,%esp
  802cd8:	68 1c 40 80 00       	push   $0x80401c
  802cdd:	68 38 01 00 00       	push   $0x138
  802ce2:	68 3f 40 80 00       	push   $0x80403f
  802ce7:	e8 29 d6 ff ff       	call   800315 <_panic>
  802cec:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	89 10                	mov    %edx,(%eax)
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	74 0d                	je     802d0d <insert_sorted_with_merge_freeList+0x71>
  802d00:	a1 38 51 80 00       	mov    0x805138,%eax
  802d05:	8b 55 08             	mov    0x8(%ebp),%edx
  802d08:	89 50 04             	mov    %edx,0x4(%eax)
  802d0b:	eb 08                	jmp    802d15 <insert_sorted_with_merge_freeList+0x79>
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	a3 38 51 80 00       	mov    %eax,0x805138
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d27:	a1 44 51 80 00       	mov    0x805144,%eax
  802d2c:	40                   	inc    %eax
  802d2d:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d36:	0f 84 a8 06 00 00    	je     8033e4 <insert_sorted_with_merge_freeList+0x748>
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	8b 50 08             	mov    0x8(%eax),%edx
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	8b 40 0c             	mov    0xc(%eax),%eax
  802d48:	01 c2                	add    %eax,%edx
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	8b 40 08             	mov    0x8(%eax),%eax
  802d50:	39 c2                	cmp    %eax,%edx
  802d52:	0f 85 8c 06 00 00    	jne    8033e4 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d61:	8b 40 0c             	mov    0xc(%eax),%eax
  802d64:	01 c2                	add    %eax,%edx
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d70:	75 17                	jne    802d89 <insert_sorted_with_merge_freeList+0xed>
  802d72:	83 ec 04             	sub    $0x4,%esp
  802d75:	68 e8 40 80 00       	push   $0x8040e8
  802d7a:	68 3c 01 00 00       	push   $0x13c
  802d7f:	68 3f 40 80 00       	push   $0x80403f
  802d84:	e8 8c d5 ff ff       	call   800315 <_panic>
  802d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	85 c0                	test   %eax,%eax
  802d90:	74 10                	je     802da2 <insert_sorted_with_merge_freeList+0x106>
  802d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d95:	8b 00                	mov    (%eax),%eax
  802d97:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d9a:	8b 52 04             	mov    0x4(%edx),%edx
  802d9d:	89 50 04             	mov    %edx,0x4(%eax)
  802da0:	eb 0b                	jmp    802dad <insert_sorted_with_merge_freeList+0x111>
  802da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da5:	8b 40 04             	mov    0x4(%eax),%eax
  802da8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db0:	8b 40 04             	mov    0x4(%eax),%eax
  802db3:	85 c0                	test   %eax,%eax
  802db5:	74 0f                	je     802dc6 <insert_sorted_with_merge_freeList+0x12a>
  802db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dba:	8b 40 04             	mov    0x4(%eax),%eax
  802dbd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc0:	8b 12                	mov    (%edx),%edx
  802dc2:	89 10                	mov    %edx,(%eax)
  802dc4:	eb 0a                	jmp    802dd0 <insert_sorted_with_merge_freeList+0x134>
  802dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	a3 38 51 80 00       	mov    %eax,0x805138
  802dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de3:	a1 44 51 80 00       	mov    0x805144,%eax
  802de8:	48                   	dec    %eax
  802de9:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e06:	75 17                	jne    802e1f <insert_sorted_with_merge_freeList+0x183>
  802e08:	83 ec 04             	sub    $0x4,%esp
  802e0b:	68 1c 40 80 00       	push   $0x80401c
  802e10:	68 3f 01 00 00       	push   $0x13f
  802e15:	68 3f 40 80 00       	push   $0x80403f
  802e1a:	e8 f6 d4 ff ff       	call   800315 <_panic>
  802e1f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e28:	89 10                	mov    %edx,(%eax)
  802e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2d:	8b 00                	mov    (%eax),%eax
  802e2f:	85 c0                	test   %eax,%eax
  802e31:	74 0d                	je     802e40 <insert_sorted_with_merge_freeList+0x1a4>
  802e33:	a1 48 51 80 00       	mov    0x805148,%eax
  802e38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e3b:	89 50 04             	mov    %edx,0x4(%eax)
  802e3e:	eb 08                	jmp    802e48 <insert_sorted_with_merge_freeList+0x1ac>
  802e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e43:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4b:	a3 48 51 80 00       	mov    %eax,0x805148
  802e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e5f:	40                   	inc    %eax
  802e60:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e65:	e9 7a 05 00 00       	jmp    8033e4 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	8b 50 08             	mov    0x8(%eax),%edx
  802e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e73:	8b 40 08             	mov    0x8(%eax),%eax
  802e76:	39 c2                	cmp    %eax,%edx
  802e78:	0f 82 14 01 00 00    	jb     802f92 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e81:	8b 50 08             	mov    0x8(%eax),%edx
  802e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e87:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8a:	01 c2                	add    %eax,%edx
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	8b 40 08             	mov    0x8(%eax),%eax
  802e92:	39 c2                	cmp    %eax,%edx
  802e94:	0f 85 90 00 00 00    	jne    802f2a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9d:	8b 50 0c             	mov    0xc(%eax),%edx
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea6:	01 c2                	add    %eax,%edx
  802ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eab:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ec2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec6:	75 17                	jne    802edf <insert_sorted_with_merge_freeList+0x243>
  802ec8:	83 ec 04             	sub    $0x4,%esp
  802ecb:	68 1c 40 80 00       	push   $0x80401c
  802ed0:	68 49 01 00 00       	push   $0x149
  802ed5:	68 3f 40 80 00       	push   $0x80403f
  802eda:	e8 36 d4 ff ff       	call   800315 <_panic>
  802edf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	89 10                	mov    %edx,(%eax)
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	85 c0                	test   %eax,%eax
  802ef1:	74 0d                	je     802f00 <insert_sorted_with_merge_freeList+0x264>
  802ef3:	a1 48 51 80 00       	mov    0x805148,%eax
  802ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  802efb:	89 50 04             	mov    %edx,0x4(%eax)
  802efe:	eb 08                	jmp    802f08 <insert_sorted_with_merge_freeList+0x26c>
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	a3 48 51 80 00       	mov    %eax,0x805148
  802f10:	8b 45 08             	mov    0x8(%ebp),%eax
  802f13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1a:	a1 54 51 80 00       	mov    0x805154,%eax
  802f1f:	40                   	inc    %eax
  802f20:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f25:	e9 bb 04 00 00       	jmp    8033e5 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2e:	75 17                	jne    802f47 <insert_sorted_with_merge_freeList+0x2ab>
  802f30:	83 ec 04             	sub    $0x4,%esp
  802f33:	68 90 40 80 00       	push   $0x804090
  802f38:	68 4c 01 00 00       	push   $0x14c
  802f3d:	68 3f 40 80 00       	push   $0x80403f
  802f42:	e8 ce d3 ff ff       	call   800315 <_panic>
  802f47:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	89 50 04             	mov    %edx,0x4(%eax)
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	8b 40 04             	mov    0x4(%eax),%eax
  802f59:	85 c0                	test   %eax,%eax
  802f5b:	74 0c                	je     802f69 <insert_sorted_with_merge_freeList+0x2cd>
  802f5d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f62:	8b 55 08             	mov    0x8(%ebp),%edx
  802f65:	89 10                	mov    %edx,(%eax)
  802f67:	eb 08                	jmp    802f71 <insert_sorted_with_merge_freeList+0x2d5>
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f82:	a1 44 51 80 00       	mov    0x805144,%eax
  802f87:	40                   	inc    %eax
  802f88:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f8d:	e9 53 04 00 00       	jmp    8033e5 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f92:	a1 38 51 80 00       	mov    0x805138,%eax
  802f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f9a:	e9 15 04 00 00       	jmp    8033b4 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 00                	mov    (%eax),%eax
  802fa4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	8b 50 08             	mov    0x8(%eax),%edx
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	8b 40 08             	mov    0x8(%eax),%eax
  802fb3:	39 c2                	cmp    %eax,%edx
  802fb5:	0f 86 f1 03 00 00    	jbe    8033ac <insert_sorted_with_merge_freeList+0x710>
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	8b 50 08             	mov    0x8(%eax),%edx
  802fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc4:	8b 40 08             	mov    0x8(%eax),%eax
  802fc7:	39 c2                	cmp    %eax,%edx
  802fc9:	0f 83 dd 03 00 00    	jae    8033ac <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd2:	8b 50 08             	mov    0x8(%eax),%edx
  802fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fdb:	01 c2                	add    %eax,%edx
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	8b 40 08             	mov    0x8(%eax),%eax
  802fe3:	39 c2                	cmp    %eax,%edx
  802fe5:	0f 85 b9 01 00 00    	jne    8031a4 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	8b 50 08             	mov    0x8(%eax),%edx
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff7:	01 c2                	add    %eax,%edx
  802ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffc:	8b 40 08             	mov    0x8(%eax),%eax
  802fff:	39 c2                	cmp    %eax,%edx
  803001:	0f 85 0d 01 00 00    	jne    803114 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300a:	8b 50 0c             	mov    0xc(%eax),%edx
  80300d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803010:	8b 40 0c             	mov    0xc(%eax),%eax
  803013:	01 c2                	add    %eax,%edx
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80301b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80301f:	75 17                	jne    803038 <insert_sorted_with_merge_freeList+0x39c>
  803021:	83 ec 04             	sub    $0x4,%esp
  803024:	68 e8 40 80 00       	push   $0x8040e8
  803029:	68 5c 01 00 00       	push   $0x15c
  80302e:	68 3f 40 80 00       	push   $0x80403f
  803033:	e8 dd d2 ff ff       	call   800315 <_panic>
  803038:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303b:	8b 00                	mov    (%eax),%eax
  80303d:	85 c0                	test   %eax,%eax
  80303f:	74 10                	je     803051 <insert_sorted_with_merge_freeList+0x3b5>
  803041:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803044:	8b 00                	mov    (%eax),%eax
  803046:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803049:	8b 52 04             	mov    0x4(%edx),%edx
  80304c:	89 50 04             	mov    %edx,0x4(%eax)
  80304f:	eb 0b                	jmp    80305c <insert_sorted_with_merge_freeList+0x3c0>
  803051:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803054:	8b 40 04             	mov    0x4(%eax),%eax
  803057:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80305c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305f:	8b 40 04             	mov    0x4(%eax),%eax
  803062:	85 c0                	test   %eax,%eax
  803064:	74 0f                	je     803075 <insert_sorted_with_merge_freeList+0x3d9>
  803066:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803069:	8b 40 04             	mov    0x4(%eax),%eax
  80306c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80306f:	8b 12                	mov    (%edx),%edx
  803071:	89 10                	mov    %edx,(%eax)
  803073:	eb 0a                	jmp    80307f <insert_sorted_with_merge_freeList+0x3e3>
  803075:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803078:	8b 00                	mov    (%eax),%eax
  80307a:	a3 38 51 80 00       	mov    %eax,0x805138
  80307f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803082:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803088:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803092:	a1 44 51 80 00       	mov    0x805144,%eax
  803097:	48                   	dec    %eax
  803098:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80309d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030aa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b5:	75 17                	jne    8030ce <insert_sorted_with_merge_freeList+0x432>
  8030b7:	83 ec 04             	sub    $0x4,%esp
  8030ba:	68 1c 40 80 00       	push   $0x80401c
  8030bf:	68 5f 01 00 00       	push   $0x15f
  8030c4:	68 3f 40 80 00       	push   $0x80403f
  8030c9:	e8 47 d2 ff ff       	call   800315 <_panic>
  8030ce:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d7:	89 10                	mov    %edx,(%eax)
  8030d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030dc:	8b 00                	mov    (%eax),%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	74 0d                	je     8030ef <insert_sorted_with_merge_freeList+0x453>
  8030e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ea:	89 50 04             	mov    %edx,0x4(%eax)
  8030ed:	eb 08                	jmp    8030f7 <insert_sorted_with_merge_freeList+0x45b>
  8030ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8030ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803102:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803109:	a1 54 51 80 00       	mov    0x805154,%eax
  80310e:	40                   	inc    %eax
  80310f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803117:	8b 50 0c             	mov    0xc(%eax),%edx
  80311a:	8b 45 08             	mov    0x8(%ebp),%eax
  80311d:	8b 40 0c             	mov    0xc(%eax),%eax
  803120:	01 c2                	add    %eax,%edx
  803122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803125:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80313c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803140:	75 17                	jne    803159 <insert_sorted_with_merge_freeList+0x4bd>
  803142:	83 ec 04             	sub    $0x4,%esp
  803145:	68 1c 40 80 00       	push   $0x80401c
  80314a:	68 64 01 00 00       	push   $0x164
  80314f:	68 3f 40 80 00       	push   $0x80403f
  803154:	e8 bc d1 ff ff       	call   800315 <_panic>
  803159:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80315f:	8b 45 08             	mov    0x8(%ebp),%eax
  803162:	89 10                	mov    %edx,(%eax)
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	74 0d                	je     80317a <insert_sorted_with_merge_freeList+0x4de>
  80316d:	a1 48 51 80 00       	mov    0x805148,%eax
  803172:	8b 55 08             	mov    0x8(%ebp),%edx
  803175:	89 50 04             	mov    %edx,0x4(%eax)
  803178:	eb 08                	jmp    803182 <insert_sorted_with_merge_freeList+0x4e6>
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	a3 48 51 80 00       	mov    %eax,0x805148
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803194:	a1 54 51 80 00       	mov    0x805154,%eax
  803199:	40                   	inc    %eax
  80319a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80319f:	e9 41 02 00 00       	jmp    8033e5 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	8b 50 08             	mov    0x8(%eax),%edx
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b0:	01 c2                	add    %eax,%edx
  8031b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b5:	8b 40 08             	mov    0x8(%eax),%eax
  8031b8:	39 c2                	cmp    %eax,%edx
  8031ba:	0f 85 7c 01 00 00    	jne    80333c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c4:	74 06                	je     8031cc <insert_sorted_with_merge_freeList+0x530>
  8031c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ca:	75 17                	jne    8031e3 <insert_sorted_with_merge_freeList+0x547>
  8031cc:	83 ec 04             	sub    $0x4,%esp
  8031cf:	68 58 40 80 00       	push   $0x804058
  8031d4:	68 69 01 00 00       	push   $0x169
  8031d9:	68 3f 40 80 00       	push   $0x80403f
  8031de:	e8 32 d1 ff ff       	call   800315 <_panic>
  8031e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e6:	8b 50 04             	mov    0x4(%eax),%edx
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	89 50 04             	mov    %edx,0x4(%eax)
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f5:	89 10                	mov    %edx,(%eax)
  8031f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fa:	8b 40 04             	mov    0x4(%eax),%eax
  8031fd:	85 c0                	test   %eax,%eax
  8031ff:	74 0d                	je     80320e <insert_sorted_with_merge_freeList+0x572>
  803201:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803204:	8b 40 04             	mov    0x4(%eax),%eax
  803207:	8b 55 08             	mov    0x8(%ebp),%edx
  80320a:	89 10                	mov    %edx,(%eax)
  80320c:	eb 08                	jmp    803216 <insert_sorted_with_merge_freeList+0x57a>
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	a3 38 51 80 00       	mov    %eax,0x805138
  803216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803219:	8b 55 08             	mov    0x8(%ebp),%edx
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	a1 44 51 80 00       	mov    0x805144,%eax
  803224:	40                   	inc    %eax
  803225:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	8b 50 0c             	mov    0xc(%eax),%edx
  803230:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803233:	8b 40 0c             	mov    0xc(%eax),%eax
  803236:	01 c2                	add    %eax,%edx
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80323e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803242:	75 17                	jne    80325b <insert_sorted_with_merge_freeList+0x5bf>
  803244:	83 ec 04             	sub    $0x4,%esp
  803247:	68 e8 40 80 00       	push   $0x8040e8
  80324c:	68 6b 01 00 00       	push   $0x16b
  803251:	68 3f 40 80 00       	push   $0x80403f
  803256:	e8 ba d0 ff ff       	call   800315 <_panic>
  80325b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325e:	8b 00                	mov    (%eax),%eax
  803260:	85 c0                	test   %eax,%eax
  803262:	74 10                	je     803274 <insert_sorted_with_merge_freeList+0x5d8>
  803264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803267:	8b 00                	mov    (%eax),%eax
  803269:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326c:	8b 52 04             	mov    0x4(%edx),%edx
  80326f:	89 50 04             	mov    %edx,0x4(%eax)
  803272:	eb 0b                	jmp    80327f <insert_sorted_with_merge_freeList+0x5e3>
  803274:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803277:	8b 40 04             	mov    0x4(%eax),%eax
  80327a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80327f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803282:	8b 40 04             	mov    0x4(%eax),%eax
  803285:	85 c0                	test   %eax,%eax
  803287:	74 0f                	je     803298 <insert_sorted_with_merge_freeList+0x5fc>
  803289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328c:	8b 40 04             	mov    0x4(%eax),%eax
  80328f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803292:	8b 12                	mov    (%edx),%edx
  803294:	89 10                	mov    %edx,(%eax)
  803296:	eb 0a                	jmp    8032a2 <insert_sorted_with_merge_freeList+0x606>
  803298:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329b:	8b 00                	mov    (%eax),%eax
  80329d:	a3 38 51 80 00       	mov    %eax,0x805138
  8032a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b5:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ba:	48                   	dec    %eax
  8032bb:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032d8:	75 17                	jne    8032f1 <insert_sorted_with_merge_freeList+0x655>
  8032da:	83 ec 04             	sub    $0x4,%esp
  8032dd:	68 1c 40 80 00       	push   $0x80401c
  8032e2:	68 6e 01 00 00       	push   $0x16e
  8032e7:	68 3f 40 80 00       	push   $0x80403f
  8032ec:	e8 24 d0 ff ff       	call   800315 <_panic>
  8032f1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fa:	89 10                	mov    %edx,(%eax)
  8032fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ff:	8b 00                	mov    (%eax),%eax
  803301:	85 c0                	test   %eax,%eax
  803303:	74 0d                	je     803312 <insert_sorted_with_merge_freeList+0x676>
  803305:	a1 48 51 80 00       	mov    0x805148,%eax
  80330a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80330d:	89 50 04             	mov    %edx,0x4(%eax)
  803310:	eb 08                	jmp    80331a <insert_sorted_with_merge_freeList+0x67e>
  803312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803315:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331d:	a3 48 51 80 00       	mov    %eax,0x805148
  803322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803325:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332c:	a1 54 51 80 00       	mov    0x805154,%eax
  803331:	40                   	inc    %eax
  803332:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803337:	e9 a9 00 00 00       	jmp    8033e5 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80333c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803340:	74 06                	je     803348 <insert_sorted_with_merge_freeList+0x6ac>
  803342:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803346:	75 17                	jne    80335f <insert_sorted_with_merge_freeList+0x6c3>
  803348:	83 ec 04             	sub    $0x4,%esp
  80334b:	68 b4 40 80 00       	push   $0x8040b4
  803350:	68 73 01 00 00       	push   $0x173
  803355:	68 3f 40 80 00       	push   $0x80403f
  80335a:	e8 b6 cf ff ff       	call   800315 <_panic>
  80335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803362:	8b 10                	mov    (%eax),%edx
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	89 10                	mov    %edx,(%eax)
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	74 0b                	je     80337d <insert_sorted_with_merge_freeList+0x6e1>
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	8b 00                	mov    (%eax),%eax
  803377:	8b 55 08             	mov    0x8(%ebp),%edx
  80337a:	89 50 04             	mov    %edx,0x4(%eax)
  80337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803380:	8b 55 08             	mov    0x8(%ebp),%edx
  803383:	89 10                	mov    %edx,(%eax)
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80338b:	89 50 04             	mov    %edx,0x4(%eax)
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	8b 00                	mov    (%eax),%eax
  803393:	85 c0                	test   %eax,%eax
  803395:	75 08                	jne    80339f <insert_sorted_with_merge_freeList+0x703>
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80339f:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a4:	40                   	inc    %eax
  8033a5:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033aa:	eb 39                	jmp    8033e5 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033ac:	a1 40 51 80 00       	mov    0x805140,%eax
  8033b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b8:	74 07                	je     8033c1 <insert_sorted_with_merge_freeList+0x725>
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	8b 00                	mov    (%eax),%eax
  8033bf:	eb 05                	jmp    8033c6 <insert_sorted_with_merge_freeList+0x72a>
  8033c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c6:	a3 40 51 80 00       	mov    %eax,0x805140
  8033cb:	a1 40 51 80 00       	mov    0x805140,%eax
  8033d0:	85 c0                	test   %eax,%eax
  8033d2:	0f 85 c7 fb ff ff    	jne    802f9f <insert_sorted_with_merge_freeList+0x303>
  8033d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033dc:	0f 85 bd fb ff ff    	jne    802f9f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033e2:	eb 01                	jmp    8033e5 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033e4:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033e5:	90                   	nop
  8033e6:	c9                   	leave  
  8033e7:	c3                   	ret    

008033e8 <__udivdi3>:
  8033e8:	55                   	push   %ebp
  8033e9:	57                   	push   %edi
  8033ea:	56                   	push   %esi
  8033eb:	53                   	push   %ebx
  8033ec:	83 ec 1c             	sub    $0x1c,%esp
  8033ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033ff:	89 ca                	mov    %ecx,%edx
  803401:	89 f8                	mov    %edi,%eax
  803403:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803407:	85 f6                	test   %esi,%esi
  803409:	75 2d                	jne    803438 <__udivdi3+0x50>
  80340b:	39 cf                	cmp    %ecx,%edi
  80340d:	77 65                	ja     803474 <__udivdi3+0x8c>
  80340f:	89 fd                	mov    %edi,%ebp
  803411:	85 ff                	test   %edi,%edi
  803413:	75 0b                	jne    803420 <__udivdi3+0x38>
  803415:	b8 01 00 00 00       	mov    $0x1,%eax
  80341a:	31 d2                	xor    %edx,%edx
  80341c:	f7 f7                	div    %edi
  80341e:	89 c5                	mov    %eax,%ebp
  803420:	31 d2                	xor    %edx,%edx
  803422:	89 c8                	mov    %ecx,%eax
  803424:	f7 f5                	div    %ebp
  803426:	89 c1                	mov    %eax,%ecx
  803428:	89 d8                	mov    %ebx,%eax
  80342a:	f7 f5                	div    %ebp
  80342c:	89 cf                	mov    %ecx,%edi
  80342e:	89 fa                	mov    %edi,%edx
  803430:	83 c4 1c             	add    $0x1c,%esp
  803433:	5b                   	pop    %ebx
  803434:	5e                   	pop    %esi
  803435:	5f                   	pop    %edi
  803436:	5d                   	pop    %ebp
  803437:	c3                   	ret    
  803438:	39 ce                	cmp    %ecx,%esi
  80343a:	77 28                	ja     803464 <__udivdi3+0x7c>
  80343c:	0f bd fe             	bsr    %esi,%edi
  80343f:	83 f7 1f             	xor    $0x1f,%edi
  803442:	75 40                	jne    803484 <__udivdi3+0x9c>
  803444:	39 ce                	cmp    %ecx,%esi
  803446:	72 0a                	jb     803452 <__udivdi3+0x6a>
  803448:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80344c:	0f 87 9e 00 00 00    	ja     8034f0 <__udivdi3+0x108>
  803452:	b8 01 00 00 00       	mov    $0x1,%eax
  803457:	89 fa                	mov    %edi,%edx
  803459:	83 c4 1c             	add    $0x1c,%esp
  80345c:	5b                   	pop    %ebx
  80345d:	5e                   	pop    %esi
  80345e:	5f                   	pop    %edi
  80345f:	5d                   	pop    %ebp
  803460:	c3                   	ret    
  803461:	8d 76 00             	lea    0x0(%esi),%esi
  803464:	31 ff                	xor    %edi,%edi
  803466:	31 c0                	xor    %eax,%eax
  803468:	89 fa                	mov    %edi,%edx
  80346a:	83 c4 1c             	add    $0x1c,%esp
  80346d:	5b                   	pop    %ebx
  80346e:	5e                   	pop    %esi
  80346f:	5f                   	pop    %edi
  803470:	5d                   	pop    %ebp
  803471:	c3                   	ret    
  803472:	66 90                	xchg   %ax,%ax
  803474:	89 d8                	mov    %ebx,%eax
  803476:	f7 f7                	div    %edi
  803478:	31 ff                	xor    %edi,%edi
  80347a:	89 fa                	mov    %edi,%edx
  80347c:	83 c4 1c             	add    $0x1c,%esp
  80347f:	5b                   	pop    %ebx
  803480:	5e                   	pop    %esi
  803481:	5f                   	pop    %edi
  803482:	5d                   	pop    %ebp
  803483:	c3                   	ret    
  803484:	bd 20 00 00 00       	mov    $0x20,%ebp
  803489:	89 eb                	mov    %ebp,%ebx
  80348b:	29 fb                	sub    %edi,%ebx
  80348d:	89 f9                	mov    %edi,%ecx
  80348f:	d3 e6                	shl    %cl,%esi
  803491:	89 c5                	mov    %eax,%ebp
  803493:	88 d9                	mov    %bl,%cl
  803495:	d3 ed                	shr    %cl,%ebp
  803497:	89 e9                	mov    %ebp,%ecx
  803499:	09 f1                	or     %esi,%ecx
  80349b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80349f:	89 f9                	mov    %edi,%ecx
  8034a1:	d3 e0                	shl    %cl,%eax
  8034a3:	89 c5                	mov    %eax,%ebp
  8034a5:	89 d6                	mov    %edx,%esi
  8034a7:	88 d9                	mov    %bl,%cl
  8034a9:	d3 ee                	shr    %cl,%esi
  8034ab:	89 f9                	mov    %edi,%ecx
  8034ad:	d3 e2                	shl    %cl,%edx
  8034af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034b3:	88 d9                	mov    %bl,%cl
  8034b5:	d3 e8                	shr    %cl,%eax
  8034b7:	09 c2                	or     %eax,%edx
  8034b9:	89 d0                	mov    %edx,%eax
  8034bb:	89 f2                	mov    %esi,%edx
  8034bd:	f7 74 24 0c          	divl   0xc(%esp)
  8034c1:	89 d6                	mov    %edx,%esi
  8034c3:	89 c3                	mov    %eax,%ebx
  8034c5:	f7 e5                	mul    %ebp
  8034c7:	39 d6                	cmp    %edx,%esi
  8034c9:	72 19                	jb     8034e4 <__udivdi3+0xfc>
  8034cb:	74 0b                	je     8034d8 <__udivdi3+0xf0>
  8034cd:	89 d8                	mov    %ebx,%eax
  8034cf:	31 ff                	xor    %edi,%edi
  8034d1:	e9 58 ff ff ff       	jmp    80342e <__udivdi3+0x46>
  8034d6:	66 90                	xchg   %ax,%ax
  8034d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034dc:	89 f9                	mov    %edi,%ecx
  8034de:	d3 e2                	shl    %cl,%edx
  8034e0:	39 c2                	cmp    %eax,%edx
  8034e2:	73 e9                	jae    8034cd <__udivdi3+0xe5>
  8034e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034e7:	31 ff                	xor    %edi,%edi
  8034e9:	e9 40 ff ff ff       	jmp    80342e <__udivdi3+0x46>
  8034ee:	66 90                	xchg   %ax,%ax
  8034f0:	31 c0                	xor    %eax,%eax
  8034f2:	e9 37 ff ff ff       	jmp    80342e <__udivdi3+0x46>
  8034f7:	90                   	nop

008034f8 <__umoddi3>:
  8034f8:	55                   	push   %ebp
  8034f9:	57                   	push   %edi
  8034fa:	56                   	push   %esi
  8034fb:	53                   	push   %ebx
  8034fc:	83 ec 1c             	sub    $0x1c,%esp
  8034ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803503:	8b 74 24 34          	mov    0x34(%esp),%esi
  803507:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80350b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80350f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803513:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803517:	89 f3                	mov    %esi,%ebx
  803519:	89 fa                	mov    %edi,%edx
  80351b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80351f:	89 34 24             	mov    %esi,(%esp)
  803522:	85 c0                	test   %eax,%eax
  803524:	75 1a                	jne    803540 <__umoddi3+0x48>
  803526:	39 f7                	cmp    %esi,%edi
  803528:	0f 86 a2 00 00 00    	jbe    8035d0 <__umoddi3+0xd8>
  80352e:	89 c8                	mov    %ecx,%eax
  803530:	89 f2                	mov    %esi,%edx
  803532:	f7 f7                	div    %edi
  803534:	89 d0                	mov    %edx,%eax
  803536:	31 d2                	xor    %edx,%edx
  803538:	83 c4 1c             	add    $0x1c,%esp
  80353b:	5b                   	pop    %ebx
  80353c:	5e                   	pop    %esi
  80353d:	5f                   	pop    %edi
  80353e:	5d                   	pop    %ebp
  80353f:	c3                   	ret    
  803540:	39 f0                	cmp    %esi,%eax
  803542:	0f 87 ac 00 00 00    	ja     8035f4 <__umoddi3+0xfc>
  803548:	0f bd e8             	bsr    %eax,%ebp
  80354b:	83 f5 1f             	xor    $0x1f,%ebp
  80354e:	0f 84 ac 00 00 00    	je     803600 <__umoddi3+0x108>
  803554:	bf 20 00 00 00       	mov    $0x20,%edi
  803559:	29 ef                	sub    %ebp,%edi
  80355b:	89 fe                	mov    %edi,%esi
  80355d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803561:	89 e9                	mov    %ebp,%ecx
  803563:	d3 e0                	shl    %cl,%eax
  803565:	89 d7                	mov    %edx,%edi
  803567:	89 f1                	mov    %esi,%ecx
  803569:	d3 ef                	shr    %cl,%edi
  80356b:	09 c7                	or     %eax,%edi
  80356d:	89 e9                	mov    %ebp,%ecx
  80356f:	d3 e2                	shl    %cl,%edx
  803571:	89 14 24             	mov    %edx,(%esp)
  803574:	89 d8                	mov    %ebx,%eax
  803576:	d3 e0                	shl    %cl,%eax
  803578:	89 c2                	mov    %eax,%edx
  80357a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80357e:	d3 e0                	shl    %cl,%eax
  803580:	89 44 24 04          	mov    %eax,0x4(%esp)
  803584:	8b 44 24 08          	mov    0x8(%esp),%eax
  803588:	89 f1                	mov    %esi,%ecx
  80358a:	d3 e8                	shr    %cl,%eax
  80358c:	09 d0                	or     %edx,%eax
  80358e:	d3 eb                	shr    %cl,%ebx
  803590:	89 da                	mov    %ebx,%edx
  803592:	f7 f7                	div    %edi
  803594:	89 d3                	mov    %edx,%ebx
  803596:	f7 24 24             	mull   (%esp)
  803599:	89 c6                	mov    %eax,%esi
  80359b:	89 d1                	mov    %edx,%ecx
  80359d:	39 d3                	cmp    %edx,%ebx
  80359f:	0f 82 87 00 00 00    	jb     80362c <__umoddi3+0x134>
  8035a5:	0f 84 91 00 00 00    	je     80363c <__umoddi3+0x144>
  8035ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035af:	29 f2                	sub    %esi,%edx
  8035b1:	19 cb                	sbb    %ecx,%ebx
  8035b3:	89 d8                	mov    %ebx,%eax
  8035b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035b9:	d3 e0                	shl    %cl,%eax
  8035bb:	89 e9                	mov    %ebp,%ecx
  8035bd:	d3 ea                	shr    %cl,%edx
  8035bf:	09 d0                	or     %edx,%eax
  8035c1:	89 e9                	mov    %ebp,%ecx
  8035c3:	d3 eb                	shr    %cl,%ebx
  8035c5:	89 da                	mov    %ebx,%edx
  8035c7:	83 c4 1c             	add    $0x1c,%esp
  8035ca:	5b                   	pop    %ebx
  8035cb:	5e                   	pop    %esi
  8035cc:	5f                   	pop    %edi
  8035cd:	5d                   	pop    %ebp
  8035ce:	c3                   	ret    
  8035cf:	90                   	nop
  8035d0:	89 fd                	mov    %edi,%ebp
  8035d2:	85 ff                	test   %edi,%edi
  8035d4:	75 0b                	jne    8035e1 <__umoddi3+0xe9>
  8035d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035db:	31 d2                	xor    %edx,%edx
  8035dd:	f7 f7                	div    %edi
  8035df:	89 c5                	mov    %eax,%ebp
  8035e1:	89 f0                	mov    %esi,%eax
  8035e3:	31 d2                	xor    %edx,%edx
  8035e5:	f7 f5                	div    %ebp
  8035e7:	89 c8                	mov    %ecx,%eax
  8035e9:	f7 f5                	div    %ebp
  8035eb:	89 d0                	mov    %edx,%eax
  8035ed:	e9 44 ff ff ff       	jmp    803536 <__umoddi3+0x3e>
  8035f2:	66 90                	xchg   %ax,%ax
  8035f4:	89 c8                	mov    %ecx,%eax
  8035f6:	89 f2                	mov    %esi,%edx
  8035f8:	83 c4 1c             	add    $0x1c,%esp
  8035fb:	5b                   	pop    %ebx
  8035fc:	5e                   	pop    %esi
  8035fd:	5f                   	pop    %edi
  8035fe:	5d                   	pop    %ebp
  8035ff:	c3                   	ret    
  803600:	3b 04 24             	cmp    (%esp),%eax
  803603:	72 06                	jb     80360b <__umoddi3+0x113>
  803605:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803609:	77 0f                	ja     80361a <__umoddi3+0x122>
  80360b:	89 f2                	mov    %esi,%edx
  80360d:	29 f9                	sub    %edi,%ecx
  80360f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803613:	89 14 24             	mov    %edx,(%esp)
  803616:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80361a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80361e:	8b 14 24             	mov    (%esp),%edx
  803621:	83 c4 1c             	add    $0x1c,%esp
  803624:	5b                   	pop    %ebx
  803625:	5e                   	pop    %esi
  803626:	5f                   	pop    %edi
  803627:	5d                   	pop    %ebp
  803628:	c3                   	ret    
  803629:	8d 76 00             	lea    0x0(%esi),%esi
  80362c:	2b 04 24             	sub    (%esp),%eax
  80362f:	19 fa                	sbb    %edi,%edx
  803631:	89 d1                	mov    %edx,%ecx
  803633:	89 c6                	mov    %eax,%esi
  803635:	e9 71 ff ff ff       	jmp    8035ab <__umoddi3+0xb3>
  80363a:	66 90                	xchg   %ax,%ax
  80363c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803640:	72 ea                	jb     80362c <__umoddi3+0x134>
  803642:	89 d9                	mov    %ebx,%ecx
  803644:	e9 62 ff ff ff       	jmp    8035ab <__umoddi3+0xb3>
