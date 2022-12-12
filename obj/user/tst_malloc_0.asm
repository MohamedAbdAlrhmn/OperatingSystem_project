
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
  80008c:	68 00 36 80 00       	push   $0x803600
  800091:	6a 14                	push   $0x14
  800093:	68 1c 36 80 00       	push   $0x80361c
  800098:	e8 78 02 00 00       	call   800315 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	if(STATIC_MEMBLOCK_ALLOC != 0)
		panic("STATIC_MEMBLOCK_ALLOC = 1 & it shall be 0. Go to 'inc/dynamic_allocator.h' and set STATIC_MEMBLOCK_ALLOC by 0. Then, repeat the test again.");

	int freeFrames_before = sys_calculate_free_frames() ;
  80009d:	e8 37 17 00 00       	call   8017d9 <sys_calculate_free_frames>
  8000a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeDiskFrames_before = sys_pf_calculate_allocated_pages() ;
  8000a5:	e8 cf 17 00 00       	call   801879 <sys_pf_calculate_allocated_pages>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	malloc(0);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	e8 9a 14 00 00       	call   801551 <malloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
	int freeFrames_after = sys_calculate_free_frames() ;
  8000ba:	e8 1a 17 00 00       	call   8017d9 <sys_calculate_free_frames>
  8000bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freeDiskFrames_after = sys_pf_calculate_allocated_pages() ;
  8000c2:	e8 b2 17 00 00       	call   801879 <sys_pf_calculate_allocated_pages>
  8000c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Check MAX_MEM_BLOCK_CNT
	if(MAX_MEM_BLOCK_CNT != ((0xA0000000-0x80000000)/4096))
  8000ca:	a1 20 51 80 00       	mov    0x805120,%eax
  8000cf:	3d 00 00 02 00       	cmp    $0x20000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
	{
		panic("Wrong initialize: MAX_MEM_BLOCK_CNT is not set with the correct size of the array");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 30 36 80 00       	push   $0x803630
  8000de:	6a 23                	push   $0x23
  8000e0:	68 1c 36 80 00       	push   $0x80361c
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
  8000fd:	68 84 36 80 00       	push   $0x803684
  800102:	6a 29                	push   $0x29
  800104:	68 1c 36 80 00       	push   $0x80361c
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
  80011a:	68 c0 36 80 00       	push   $0x8036c0
  80011f:	6a 2f                	push   $0x2f
  800121:	68 1c 36 80 00       	push   $0x80361c
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
  800138:	68 f8 36 80 00       	push   $0x8036f8
  80013d:	6a 35                	push   $0x35
  80013f:	68 1c 36 80 00       	push   $0x80361c
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
  800174:	68 30 37 80 00       	push   $0x803730
  800179:	6a 3c                	push   $0x3c
  80017b:	68 1c 36 80 00       	push   $0x80361c
  800180:	e8 90 01 00 00       	call   800315 <_panic>
	}

	//Check number of disk and memory frames
	if ((freeDiskFrames_after - freeDiskFrames_before) != 0) panic("Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)");
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80018b:	74 14                	je     8001a1 <_main+0x169>
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 6c 37 80 00       	push   $0x80376c
  800195:	6a 40                	push   $0x40
  800197:	68 1c 36 80 00       	push   $0x80361c
  80019c:	e8 74 01 00 00       	call   800315 <_panic>
	if ((freeFrames_before - freeFrames_after) != 512 + 1) panic("Wrong allocation: pages are not loaded successfully into memory %d", (freeFrames_before - freeFrames_after));
  8001a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a7:	3d 01 02 00 00       	cmp    $0x201,%eax
  8001ac:	74 18                	je     8001c6 <_main+0x18e>
  8001ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	68 d4 37 80 00       	push   $0x8037d4
  8001ba:	6a 41                	push   $0x41
  8001bc:	68 1c 36 80 00       	push   $0x80361c
  8001c1:	e8 4f 01 00 00       	call   800315 <_panic>

	/*=================================================*/

	cprintf("Congratulations!! test initialize_dyn_block_system of UHEAP completed successfully.\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 18 38 80 00       	push   $0x803818
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
  8001df:	e8 d5 18 00 00       	call   801ab9 <sys_getenvindex>
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
  80024a:	e8 77 16 00 00       	call   8018c6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 88 38 80 00       	push   $0x803888
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
  80027a:	68 b0 38 80 00       	push   $0x8038b0
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
  8002ab:	68 d8 38 80 00       	push   $0x8038d8
  8002b0:	e8 14 03 00 00       	call   8005c9 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 30 39 80 00       	push   $0x803930
  8002cc:	e8 f8 02 00 00       	call   8005c9 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	68 88 38 80 00       	push   $0x803888
  8002dc:	e8 e8 02 00 00       	call   8005c9 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002e4:	e8 f7 15 00 00       	call   8018e0 <sys_enable_interrupt>

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
  8002fc:	e8 84 17 00 00       	call   801a85 <sys_destroy_env>
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
  80030d:	e8 d9 17 00 00       	call   801aeb <sys_exit_env>
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
  800336:	68 44 39 80 00       	push   $0x803944
  80033b:	e8 89 02 00 00       	call   8005c9 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800343:	a1 00 50 80 00       	mov    0x805000,%eax
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 49 39 80 00       	push   $0x803949
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
  800373:	68 65 39 80 00       	push   $0x803965
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
  80039f:	68 68 39 80 00       	push   $0x803968
  8003a4:	6a 26                	push   $0x26
  8003a6:	68 b4 39 80 00       	push   $0x8039b4
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
  800471:	68 c0 39 80 00       	push   $0x8039c0
  800476:	6a 3a                	push   $0x3a
  800478:	68 b4 39 80 00       	push   $0x8039b4
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
  8004e1:	68 14 3a 80 00       	push   $0x803a14
  8004e6:	6a 44                	push   $0x44
  8004e8:	68 b4 39 80 00       	push   $0x8039b4
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
  80053b:	e8 d8 11 00 00       	call   801718 <sys_cputs>
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
  8005b2:	e8 61 11 00 00       	call   801718 <sys_cputs>
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
  8005fc:	e8 c5 12 00 00       	call   8018c6 <sys_disable_interrupt>
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
  80061c:	e8 bf 12 00 00       	call   8018e0 <sys_enable_interrupt>
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
  800666:	e8 31 2d 00 00       	call   80339c <__udivdi3>
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
  8006b6:	e8 f1 2d 00 00       	call   8034ac <__umoddi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	05 74 3c 80 00       	add    $0x803c74,%eax
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
  800811:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
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
  8008f2:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 19                	jne    800916 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	53                   	push   %ebx
  8008fe:	68 85 3c 80 00       	push   $0x803c85
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
  800917:	68 8e 3c 80 00       	push   $0x803c8e
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
  800944:	be 91 3c 80 00       	mov    $0x803c91,%esi
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
  80136a:	68 f0 3d 80 00       	push   $0x803df0
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
  80143a:	e8 1d 04 00 00       	call   80185c <sys_allocate_chunk>
  80143f:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801442:	a1 20 51 80 00       	mov    0x805120,%eax
  801447:	83 ec 0c             	sub    $0xc,%esp
  80144a:	50                   	push   %eax
  80144b:	e8 92 0a 00 00       	call   801ee2 <initialize_MemBlocksList>
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
  801478:	68 15 3e 80 00       	push   $0x803e15
  80147d:	6a 33                	push   $0x33
  80147f:	68 33 3e 80 00       	push   $0x803e33
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
  8014f7:	68 40 3e 80 00       	push   $0x803e40
  8014fc:	6a 34                	push   $0x34
  8014fe:	68 33 3e 80 00       	push   $0x803e33
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
  80156c:	68 64 3e 80 00       	push   $0x803e64
  801571:	6a 46                	push   $0x46
  801573:	68 33 3e 80 00       	push   $0x803e33
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
  801588:	68 8c 3e 80 00       	push   $0x803e8c
  80158d:	6a 61                	push   $0x61
  80158f:	68 33 3e 80 00       	push   $0x803e33
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
  8015ae:	75 07                	jne    8015b7 <smalloc+0x1e>
  8015b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b5:	eb 7c                	jmp    801633 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015b7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c4:	01 d0                	add    %edx,%eax
  8015c6:	48                   	dec    %eax
  8015c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d2:	f7 75 f0             	divl   -0x10(%ebp)
  8015d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d8:	29 d0                	sub    %edx,%eax
  8015da:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015dd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015e4:	e8 41 06 00 00       	call   801c2a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	74 11                	je     8015fe <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f3:	e8 ac 0c 00 00       	call   8022a4 <alloc_block_FF>
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801602:	74 2a                	je     80162e <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801607:	8b 40 08             	mov    0x8(%eax),%eax
  80160a:	89 c2                	mov    %eax,%edx
  80160c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801610:	52                   	push   %edx
  801611:	50                   	push   %eax
  801612:	ff 75 0c             	pushl  0xc(%ebp)
  801615:	ff 75 08             	pushl  0x8(%ebp)
  801618:	e8 92 03 00 00       	call   8019af <sys_createSharedObject>
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801623:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801627:	74 05                	je     80162e <smalloc+0x95>
			return (void*)virtual_address;
  801629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80162c:	eb 05                	jmp    801633 <smalloc+0x9a>
	}
	return NULL;
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80163b:	e8 13 fd ff ff       	call   801353 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	68 b0 3e 80 00       	push   $0x803eb0
  801648:	68 a2 00 00 00       	push   $0xa2
  80164d:	68 33 3e 80 00       	push   $0x803e33
  801652:	e8 be ec ff ff       	call   800315 <_panic>

00801657 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80165d:	e8 f1 fc ff ff       	call   801353 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801662:	83 ec 04             	sub    $0x4,%esp
  801665:	68 d4 3e 80 00       	push   $0x803ed4
  80166a:	68 e6 00 00 00       	push   $0xe6
  80166f:	68 33 3e 80 00       	push   $0x803e33
  801674:	e8 9c ec ff ff       	call   800315 <_panic>

00801679 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80167f:	83 ec 04             	sub    $0x4,%esp
  801682:	68 fc 3e 80 00       	push   $0x803efc
  801687:	68 fa 00 00 00       	push   $0xfa
  80168c:	68 33 3e 80 00       	push   $0x803e33
  801691:	e8 7f ec ff ff       	call   800315 <_panic>

00801696 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80169c:	83 ec 04             	sub    $0x4,%esp
  80169f:	68 20 3f 80 00       	push   $0x803f20
  8016a4:	68 05 01 00 00       	push   $0x105
  8016a9:	68 33 3e 80 00       	push   $0x803e33
  8016ae:	e8 62 ec ff ff       	call   800315 <_panic>

008016b3 <shrink>:

}
void shrink(uint32 newSize)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016b9:	83 ec 04             	sub    $0x4,%esp
  8016bc:	68 20 3f 80 00       	push   $0x803f20
  8016c1:	68 0a 01 00 00       	push   $0x10a
  8016c6:	68 33 3e 80 00       	push   $0x803e33
  8016cb:	e8 45 ec ff ff       	call   800315 <_panic>

008016d0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016d6:	83 ec 04             	sub    $0x4,%esp
  8016d9:	68 20 3f 80 00       	push   $0x803f20
  8016de:	68 0f 01 00 00       	push   $0x10f
  8016e3:	68 33 3e 80 00       	push   $0x803e33
  8016e8:	e8 28 ec ff ff       	call   800315 <_panic>

008016ed <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	57                   	push   %edi
  8016f1:	56                   	push   %esi
  8016f2:	53                   	push   %ebx
  8016f3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801702:	8b 7d 18             	mov    0x18(%ebp),%edi
  801705:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801708:	cd 30                	int    $0x30
  80170a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80170d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	5b                   	pop    %ebx
  801714:	5e                   	pop    %esi
  801715:	5f                   	pop    %edi
  801716:	5d                   	pop    %ebp
  801717:	c3                   	ret    

00801718 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	8b 45 10             	mov    0x10(%ebp),%eax
  801721:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801724:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	52                   	push   %edx
  801730:	ff 75 0c             	pushl  0xc(%ebp)
  801733:	50                   	push   %eax
  801734:	6a 00                	push   $0x0
  801736:	e8 b2 ff ff ff       	call   8016ed <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	90                   	nop
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_cgetc>:

int
sys_cgetc(void)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 01                	push   $0x1
  801750:	e8 98 ff ff ff       	call   8016ed <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80175d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	52                   	push   %edx
  80176a:	50                   	push   %eax
  80176b:	6a 05                	push   $0x5
  80176d:	e8 7b ff ff ff       	call   8016ed <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	56                   	push   %esi
  80177b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80177c:	8b 75 18             	mov    0x18(%ebp),%esi
  80177f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801782:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801785:	8b 55 0c             	mov    0xc(%ebp),%edx
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	56                   	push   %esi
  80178c:	53                   	push   %ebx
  80178d:	51                   	push   %ecx
  80178e:	52                   	push   %edx
  80178f:	50                   	push   %eax
  801790:	6a 06                	push   $0x6
  801792:	e8 56 ff ff ff       	call   8016ed <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80179d:	5b                   	pop    %ebx
  80179e:	5e                   	pop    %esi
  80179f:	5d                   	pop    %ebp
  8017a0:	c3                   	ret    

008017a1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	52                   	push   %edx
  8017b1:	50                   	push   %eax
  8017b2:	6a 07                	push   $0x7
  8017b4:	e8 34 ff ff ff       	call   8016ed <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ca:	ff 75 08             	pushl  0x8(%ebp)
  8017cd:	6a 08                	push   $0x8
  8017cf:	e8 19 ff ff ff       	call   8016ed <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 09                	push   $0x9
  8017e8:	e8 00 ff ff ff       	call   8016ed <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 0a                	push   $0xa
  801801:	e8 e7 fe ff ff       	call   8016ed <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 0b                	push   $0xb
  80181a:	e8 ce fe ff ff       	call   8016ed <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	ff 75 0c             	pushl  0xc(%ebp)
  801830:	ff 75 08             	pushl  0x8(%ebp)
  801833:	6a 0f                	push   $0xf
  801835:	e8 b3 fe ff ff       	call   8016ed <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
	return;
  80183d:	90                   	nop
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	ff 75 0c             	pushl  0xc(%ebp)
  80184c:	ff 75 08             	pushl  0x8(%ebp)
  80184f:	6a 10                	push   $0x10
  801851:	e8 97 fe ff ff       	call   8016ed <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
	return ;
  801859:	90                   	nop
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	ff 75 10             	pushl  0x10(%ebp)
  801866:	ff 75 0c             	pushl  0xc(%ebp)
  801869:	ff 75 08             	pushl  0x8(%ebp)
  80186c:	6a 11                	push   $0x11
  80186e:	e8 7a fe ff ff       	call   8016ed <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
	return ;
  801876:	90                   	nop
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 0c                	push   $0xc
  801888:	e8 60 fe ff ff       	call   8016ed <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	ff 75 08             	pushl  0x8(%ebp)
  8018a0:	6a 0d                	push   $0xd
  8018a2:	e8 46 fe ff ff       	call   8016ed <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 0e                	push   $0xe
  8018bb:	e8 2d fe ff ff       	call   8016ed <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	90                   	nop
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 13                	push   $0x13
  8018d5:	e8 13 fe ff ff       	call   8016ed <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	90                   	nop
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 14                	push   $0x14
  8018ef:	e8 f9 fd ff ff       	call   8016ed <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	90                   	nop
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_cputc>:


void
sys_cputc(const char c)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 04             	sub    $0x4,%esp
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801906:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	50                   	push   %eax
  801913:	6a 15                	push   $0x15
  801915:	e8 d3 fd ff ff       	call   8016ed <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	90                   	nop
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 16                	push   $0x16
  80192f:	e8 b9 fd ff ff       	call   8016ed <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	90                   	nop
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	ff 75 0c             	pushl  0xc(%ebp)
  801949:	50                   	push   %eax
  80194a:	6a 17                	push   $0x17
  80194c:	e8 9c fd ff ff       	call   8016ed <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	52                   	push   %edx
  801966:	50                   	push   %eax
  801967:	6a 1a                	push   $0x1a
  801969:	e8 7f fd ff ff       	call   8016ed <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801976:	8b 55 0c             	mov    0xc(%ebp),%edx
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	52                   	push   %edx
  801983:	50                   	push   %eax
  801984:	6a 18                	push   $0x18
  801986:	e8 62 fd ff ff       	call   8016ed <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	90                   	nop
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801994:	8b 55 0c             	mov    0xc(%ebp),%edx
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	52                   	push   %edx
  8019a1:	50                   	push   %eax
  8019a2:	6a 19                	push   $0x19
  8019a4:	e8 44 fd ff ff       	call   8016ed <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	90                   	nop
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 04             	sub    $0x4,%esp
  8019b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019bb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c5:	6a 00                	push   $0x0
  8019c7:	51                   	push   %ecx
  8019c8:	52                   	push   %edx
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	50                   	push   %eax
  8019cd:	6a 1b                	push   $0x1b
  8019cf:	e8 19 fd ff ff       	call   8016ed <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	52                   	push   %edx
  8019e9:	50                   	push   %eax
  8019ea:	6a 1c                	push   $0x1c
  8019ec:	e8 fc fc ff ff       	call   8016ed <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	51                   	push   %ecx
  801a07:	52                   	push   %edx
  801a08:	50                   	push   %eax
  801a09:	6a 1d                	push   $0x1d
  801a0b:	e8 dd fc ff ff       	call   8016ed <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	52                   	push   %edx
  801a25:	50                   	push   %eax
  801a26:	6a 1e                	push   $0x1e
  801a28:	e8 c0 fc ff ff       	call   8016ed <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 1f                	push   $0x1f
  801a41:	e8 a7 fc ff ff       	call   8016ed <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	6a 00                	push   $0x0
  801a53:	ff 75 14             	pushl  0x14(%ebp)
  801a56:	ff 75 10             	pushl  0x10(%ebp)
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	50                   	push   %eax
  801a5d:	6a 20                	push   $0x20
  801a5f:	e8 89 fc ff ff       	call   8016ed <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	50                   	push   %eax
  801a78:	6a 21                	push   $0x21
  801a7a:	e8 6e fc ff ff       	call   8016ed <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	90                   	nop
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	50                   	push   %eax
  801a94:	6a 22                	push   $0x22
  801a96:	e8 52 fc ff ff       	call   8016ed <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 02                	push   $0x2
  801aaf:	e8 39 fc ff ff       	call   8016ed <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 03                	push   $0x3
  801ac8:	e8 20 fc ff ff       	call   8016ed <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 04                	push   $0x4
  801ae1:	e8 07 fc ff ff       	call   8016ed <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_exit_env>:


void sys_exit_env(void)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 23                	push   $0x23
  801afa:	e8 ee fb ff ff       	call   8016ed <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	90                   	nop
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b0b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b0e:	8d 50 04             	lea    0x4(%eax),%edx
  801b11:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	52                   	push   %edx
  801b1b:	50                   	push   %eax
  801b1c:	6a 24                	push   $0x24
  801b1e:	e8 ca fb ff ff       	call   8016ed <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
	return result;
  801b26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b2f:	89 01                	mov    %eax,(%ecx)
  801b31:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	c9                   	leave  
  801b38:	c2 04 00             	ret    $0x4

00801b3b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	ff 75 10             	pushl  0x10(%ebp)
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	ff 75 08             	pushl  0x8(%ebp)
  801b4b:	6a 12                	push   $0x12
  801b4d:	e8 9b fb ff ff       	call   8016ed <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
	return ;
  801b55:	90                   	nop
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 25                	push   $0x25
  801b67:	e8 81 fb ff ff       	call   8016ed <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 04             	sub    $0x4,%esp
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b7d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	50                   	push   %eax
  801b8a:	6a 26                	push   $0x26
  801b8c:	e8 5c fb ff ff       	call   8016ed <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
	return ;
  801b94:	90                   	nop
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <rsttst>:
void rsttst()
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 28                	push   $0x28
  801ba6:	e8 42 fb ff ff       	call   8016ed <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
	return ;
  801bae:	90                   	nop
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 04             	sub    $0x4,%esp
  801bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bbd:	8b 55 18             	mov    0x18(%ebp),%edx
  801bc0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bc4:	52                   	push   %edx
  801bc5:	50                   	push   %eax
  801bc6:	ff 75 10             	pushl  0x10(%ebp)
  801bc9:	ff 75 0c             	pushl  0xc(%ebp)
  801bcc:	ff 75 08             	pushl  0x8(%ebp)
  801bcf:	6a 27                	push   $0x27
  801bd1:	e8 17 fb ff ff       	call   8016ed <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd9:	90                   	nop
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <chktst>:
void chktst(uint32 n)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	ff 75 08             	pushl  0x8(%ebp)
  801bea:	6a 29                	push   $0x29
  801bec:	e8 fc fa ff ff       	call   8016ed <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf4:	90                   	nop
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <inctst>:

void inctst()
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 2a                	push   $0x2a
  801c06:	e8 e2 fa ff ff       	call   8016ed <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0e:	90                   	nop
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <gettst>:
uint32 gettst()
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 2b                	push   $0x2b
  801c20:	e8 c8 fa ff ff       	call   8016ed <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 2c                	push   $0x2c
  801c3c:	e8 ac fa ff ff       	call   8016ed <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
  801c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c47:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c4b:	75 07                	jne    801c54 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c52:	eb 05                	jmp    801c59 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 2c                	push   $0x2c
  801c6d:	e8 7b fa ff ff       	call   8016ed <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
  801c75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c78:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c7c:	75 07                	jne    801c85 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c83:	eb 05                	jmp    801c8a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 2c                	push   $0x2c
  801c9e:	e8 4a fa ff ff       	call   8016ed <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
  801ca6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ca9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cad:	75 07                	jne    801cb6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801caf:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb4:	eb 05                	jmp    801cbb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 2c                	push   $0x2c
  801ccf:	e8 19 fa ff ff       	call   8016ed <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
  801cd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cda:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cde:	75 07                	jne    801ce7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ce0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce5:	eb 05                	jmp    801cec <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ce7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	ff 75 08             	pushl  0x8(%ebp)
  801cfc:	6a 2d                	push   $0x2d
  801cfe:	e8 ea f9 ff ff       	call   8016ed <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
	return ;
  801d06:	90                   	nop
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d16:	8b 45 08             	mov    0x8(%ebp),%eax
  801d19:	6a 00                	push   $0x0
  801d1b:	53                   	push   %ebx
  801d1c:	51                   	push   %ecx
  801d1d:	52                   	push   %edx
  801d1e:	50                   	push   %eax
  801d1f:	6a 2e                	push   $0x2e
  801d21:	e8 c7 f9 ff ff       	call   8016ed <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
}
  801d29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	52                   	push   %edx
  801d3e:	50                   	push   %eax
  801d3f:	6a 2f                	push   $0x2f
  801d41:	e8 a7 f9 ff ff       	call   8016ed <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d51:	83 ec 0c             	sub    $0xc,%esp
  801d54:	68 30 3f 80 00       	push   $0x803f30
  801d59:	e8 6b e8 ff ff       	call   8005c9 <cprintf>
  801d5e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d68:	83 ec 0c             	sub    $0xc,%esp
  801d6b:	68 5c 3f 80 00       	push   $0x803f5c
  801d70:	e8 54 e8 ff ff       	call   8005c9 <cprintf>
  801d75:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d78:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d7c:	a1 38 51 80 00       	mov    0x805138,%eax
  801d81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d84:	eb 56                	jmp    801ddc <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d8a:	74 1c                	je     801da8 <print_mem_block_lists+0x5d>
  801d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8f:	8b 50 08             	mov    0x8(%eax),%edx
  801d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d95:	8b 48 08             	mov    0x8(%eax),%ecx
  801d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9e:	01 c8                	add    %ecx,%eax
  801da0:	39 c2                	cmp    %eax,%edx
  801da2:	73 04                	jae    801da8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801da4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dab:	8b 50 08             	mov    0x8(%eax),%edx
  801dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db1:	8b 40 0c             	mov    0xc(%eax),%eax
  801db4:	01 c2                	add    %eax,%edx
  801db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db9:	8b 40 08             	mov    0x8(%eax),%eax
  801dbc:	83 ec 04             	sub    $0x4,%esp
  801dbf:	52                   	push   %edx
  801dc0:	50                   	push   %eax
  801dc1:	68 71 3f 80 00       	push   $0x803f71
  801dc6:	e8 fe e7 ff ff       	call   8005c9 <cprintf>
  801dcb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dd4:	a1 40 51 80 00       	mov    0x805140,%eax
  801dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de0:	74 07                	je     801de9 <print_mem_block_lists+0x9e>
  801de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de5:	8b 00                	mov    (%eax),%eax
  801de7:	eb 05                	jmp    801dee <print_mem_block_lists+0xa3>
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	a3 40 51 80 00       	mov    %eax,0x805140
  801df3:	a1 40 51 80 00       	mov    0x805140,%eax
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	75 8a                	jne    801d86 <print_mem_block_lists+0x3b>
  801dfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e00:	75 84                	jne    801d86 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e02:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e06:	75 10                	jne    801e18 <print_mem_block_lists+0xcd>
  801e08:	83 ec 0c             	sub    $0xc,%esp
  801e0b:	68 80 3f 80 00       	push   $0x803f80
  801e10:	e8 b4 e7 ff ff       	call   8005c9 <cprintf>
  801e15:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e1f:	83 ec 0c             	sub    $0xc,%esp
  801e22:	68 a4 3f 80 00       	push   $0x803fa4
  801e27:	e8 9d e7 ff ff       	call   8005c9 <cprintf>
  801e2c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e2f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e33:	a1 40 50 80 00       	mov    0x805040,%eax
  801e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3b:	eb 56                	jmp    801e93 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e41:	74 1c                	je     801e5f <print_mem_block_lists+0x114>
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	8b 50 08             	mov    0x8(%eax),%edx
  801e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4c:	8b 48 08             	mov    0x8(%eax),%ecx
  801e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e52:	8b 40 0c             	mov    0xc(%eax),%eax
  801e55:	01 c8                	add    %ecx,%eax
  801e57:	39 c2                	cmp    %eax,%edx
  801e59:	73 04                	jae    801e5f <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e5b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e62:	8b 50 08             	mov    0x8(%eax),%edx
  801e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e68:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6b:	01 c2                	add    %eax,%edx
  801e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e70:	8b 40 08             	mov    0x8(%eax),%eax
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	52                   	push   %edx
  801e77:	50                   	push   %eax
  801e78:	68 71 3f 80 00       	push   $0x803f71
  801e7d:	e8 47 e7 ff ff       	call   8005c9 <cprintf>
  801e82:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e8b:	a1 48 50 80 00       	mov    0x805048,%eax
  801e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e97:	74 07                	je     801ea0 <print_mem_block_lists+0x155>
  801e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9c:	8b 00                	mov    (%eax),%eax
  801e9e:	eb 05                	jmp    801ea5 <print_mem_block_lists+0x15a>
  801ea0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea5:	a3 48 50 80 00       	mov    %eax,0x805048
  801eaa:	a1 48 50 80 00       	mov    0x805048,%eax
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	75 8a                	jne    801e3d <print_mem_block_lists+0xf2>
  801eb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb7:	75 84                	jne    801e3d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801eb9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ebd:	75 10                	jne    801ecf <print_mem_block_lists+0x184>
  801ebf:	83 ec 0c             	sub    $0xc,%esp
  801ec2:	68 bc 3f 80 00       	push   $0x803fbc
  801ec7:	e8 fd e6 ff ff       	call   8005c9 <cprintf>
  801ecc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ecf:	83 ec 0c             	sub    $0xc,%esp
  801ed2:	68 30 3f 80 00       	push   $0x803f30
  801ed7:	e8 ed e6 ff ff       	call   8005c9 <cprintf>
  801edc:	83 c4 10             	add    $0x10,%esp

}
  801edf:	90                   	nop
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ee8:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801eef:	00 00 00 
  801ef2:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ef9:	00 00 00 
  801efc:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f03:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f0d:	e9 9e 00 00 00       	jmp    801fb0 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f12:	a1 50 50 80 00       	mov    0x805050,%eax
  801f17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1a:	c1 e2 04             	shl    $0x4,%edx
  801f1d:	01 d0                	add    %edx,%eax
  801f1f:	85 c0                	test   %eax,%eax
  801f21:	75 14                	jne    801f37 <initialize_MemBlocksList+0x55>
  801f23:	83 ec 04             	sub    $0x4,%esp
  801f26:	68 e4 3f 80 00       	push   $0x803fe4
  801f2b:	6a 46                	push   $0x46
  801f2d:	68 07 40 80 00       	push   $0x804007
  801f32:	e8 de e3 ff ff       	call   800315 <_panic>
  801f37:	a1 50 50 80 00       	mov    0x805050,%eax
  801f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3f:	c1 e2 04             	shl    $0x4,%edx
  801f42:	01 d0                	add    %edx,%eax
  801f44:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f4a:	89 10                	mov    %edx,(%eax)
  801f4c:	8b 00                	mov    (%eax),%eax
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	74 18                	je     801f6a <initialize_MemBlocksList+0x88>
  801f52:	a1 48 51 80 00       	mov    0x805148,%eax
  801f57:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f5d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f60:	c1 e1 04             	shl    $0x4,%ecx
  801f63:	01 ca                	add    %ecx,%edx
  801f65:	89 50 04             	mov    %edx,0x4(%eax)
  801f68:	eb 12                	jmp    801f7c <initialize_MemBlocksList+0x9a>
  801f6a:	a1 50 50 80 00       	mov    0x805050,%eax
  801f6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f72:	c1 e2 04             	shl    $0x4,%edx
  801f75:	01 d0                	add    %edx,%eax
  801f77:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f7c:	a1 50 50 80 00       	mov    0x805050,%eax
  801f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f84:	c1 e2 04             	shl    $0x4,%edx
  801f87:	01 d0                	add    %edx,%eax
  801f89:	a3 48 51 80 00       	mov    %eax,0x805148
  801f8e:	a1 50 50 80 00       	mov    0x805050,%eax
  801f93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f96:	c1 e2 04             	shl    $0x4,%edx
  801f99:	01 d0                	add    %edx,%eax
  801f9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fa2:	a1 54 51 80 00       	mov    0x805154,%eax
  801fa7:	40                   	inc    %eax
  801fa8:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fad:	ff 45 f4             	incl   -0xc(%ebp)
  801fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fb6:	0f 82 56 ff ff ff    	jb     801f12 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fbc:	90                   	nop
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	8b 00                	mov    (%eax),%eax
  801fca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fcd:	eb 19                	jmp    801fe8 <find_block+0x29>
	{
		if(va==point->sva)
  801fcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd2:	8b 40 08             	mov    0x8(%eax),%eax
  801fd5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fd8:	75 05                	jne    801fdf <find_block+0x20>
		   return point;
  801fda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fdd:	eb 36                	jmp    802015 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe2:	8b 40 08             	mov    0x8(%eax),%eax
  801fe5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fe8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fec:	74 07                	je     801ff5 <find_block+0x36>
  801fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff1:	8b 00                	mov    (%eax),%eax
  801ff3:	eb 05                	jmp    801ffa <find_block+0x3b>
  801ff5:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  801ffd:	89 42 08             	mov    %eax,0x8(%edx)
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	8b 40 08             	mov    0x8(%eax),%eax
  802006:	85 c0                	test   %eax,%eax
  802008:	75 c5                	jne    801fcf <find_block+0x10>
  80200a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80200e:	75 bf                	jne    801fcf <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80201d:	a1 40 50 80 00       	mov    0x805040,%eax
  802022:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802025:	a1 44 50 80 00       	mov    0x805044,%eax
  80202a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80202d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802030:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802033:	74 24                	je     802059 <insert_sorted_allocList+0x42>
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	8b 50 08             	mov    0x8(%eax),%edx
  80203b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203e:	8b 40 08             	mov    0x8(%eax),%eax
  802041:	39 c2                	cmp    %eax,%edx
  802043:	76 14                	jbe    802059 <insert_sorted_allocList+0x42>
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	8b 50 08             	mov    0x8(%eax),%edx
  80204b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204e:	8b 40 08             	mov    0x8(%eax),%eax
  802051:	39 c2                	cmp    %eax,%edx
  802053:	0f 82 60 01 00 00    	jb     8021b9 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802059:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80205d:	75 65                	jne    8020c4 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80205f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802063:	75 14                	jne    802079 <insert_sorted_allocList+0x62>
  802065:	83 ec 04             	sub    $0x4,%esp
  802068:	68 e4 3f 80 00       	push   $0x803fe4
  80206d:	6a 6b                	push   $0x6b
  80206f:	68 07 40 80 00       	push   $0x804007
  802074:	e8 9c e2 ff ff       	call   800315 <_panic>
  802079:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	89 10                	mov    %edx,(%eax)
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	8b 00                	mov    (%eax),%eax
  802089:	85 c0                	test   %eax,%eax
  80208b:	74 0d                	je     80209a <insert_sorted_allocList+0x83>
  80208d:	a1 40 50 80 00       	mov    0x805040,%eax
  802092:	8b 55 08             	mov    0x8(%ebp),%edx
  802095:	89 50 04             	mov    %edx,0x4(%eax)
  802098:	eb 08                	jmp    8020a2 <insert_sorted_allocList+0x8b>
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	a3 44 50 80 00       	mov    %eax,0x805044
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	a3 40 50 80 00       	mov    %eax,0x805040
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020b4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020b9:	40                   	inc    %eax
  8020ba:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020bf:	e9 dc 01 00 00       	jmp    8022a0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	8b 50 08             	mov    0x8(%eax),%edx
  8020ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cd:	8b 40 08             	mov    0x8(%eax),%eax
  8020d0:	39 c2                	cmp    %eax,%edx
  8020d2:	77 6c                	ja     802140 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d8:	74 06                	je     8020e0 <insert_sorted_allocList+0xc9>
  8020da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020de:	75 14                	jne    8020f4 <insert_sorted_allocList+0xdd>
  8020e0:	83 ec 04             	sub    $0x4,%esp
  8020e3:	68 20 40 80 00       	push   $0x804020
  8020e8:	6a 6f                	push   $0x6f
  8020ea:	68 07 40 80 00       	push   $0x804007
  8020ef:	e8 21 e2 ff ff       	call   800315 <_panic>
  8020f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f7:	8b 50 04             	mov    0x4(%eax),%edx
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	89 50 04             	mov    %edx,0x4(%eax)
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802106:	89 10                	mov    %edx,(%eax)
  802108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210b:	8b 40 04             	mov    0x4(%eax),%eax
  80210e:	85 c0                	test   %eax,%eax
  802110:	74 0d                	je     80211f <insert_sorted_allocList+0x108>
  802112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802115:	8b 40 04             	mov    0x4(%eax),%eax
  802118:	8b 55 08             	mov    0x8(%ebp),%edx
  80211b:	89 10                	mov    %edx,(%eax)
  80211d:	eb 08                	jmp    802127 <insert_sorted_allocList+0x110>
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	a3 40 50 80 00       	mov    %eax,0x805040
  802127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212a:	8b 55 08             	mov    0x8(%ebp),%edx
  80212d:	89 50 04             	mov    %edx,0x4(%eax)
  802130:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802135:	40                   	inc    %eax
  802136:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80213b:	e9 60 01 00 00       	jmp    8022a0 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	8b 50 08             	mov    0x8(%eax),%edx
  802146:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802149:	8b 40 08             	mov    0x8(%eax),%eax
  80214c:	39 c2                	cmp    %eax,%edx
  80214e:	0f 82 4c 01 00 00    	jb     8022a0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802154:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802158:	75 14                	jne    80216e <insert_sorted_allocList+0x157>
  80215a:	83 ec 04             	sub    $0x4,%esp
  80215d:	68 58 40 80 00       	push   $0x804058
  802162:	6a 73                	push   $0x73
  802164:	68 07 40 80 00       	push   $0x804007
  802169:	e8 a7 e1 ff ff       	call   800315 <_panic>
  80216e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	89 50 04             	mov    %edx,0x4(%eax)
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	8b 40 04             	mov    0x4(%eax),%eax
  802180:	85 c0                	test   %eax,%eax
  802182:	74 0c                	je     802190 <insert_sorted_allocList+0x179>
  802184:	a1 44 50 80 00       	mov    0x805044,%eax
  802189:	8b 55 08             	mov    0x8(%ebp),%edx
  80218c:	89 10                	mov    %edx,(%eax)
  80218e:	eb 08                	jmp    802198 <insert_sorted_allocList+0x181>
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	a3 40 50 80 00       	mov    %eax,0x805040
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	a3 44 50 80 00       	mov    %eax,0x805044
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021a9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021ae:	40                   	inc    %eax
  8021af:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021b4:	e9 e7 00 00 00       	jmp    8022a0 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021bf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021c6:	a1 40 50 80 00       	mov    0x805040,%eax
  8021cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ce:	e9 9d 00 00 00       	jmp    802270 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	8b 00                	mov    (%eax),%eax
  8021d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	8b 50 08             	mov    0x8(%eax),%edx
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	8b 40 08             	mov    0x8(%eax),%eax
  8021e7:	39 c2                	cmp    %eax,%edx
  8021e9:	76 7d                	jbe    802268 <insert_sorted_allocList+0x251>
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	8b 50 08             	mov    0x8(%eax),%edx
  8021f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021f4:	8b 40 08             	mov    0x8(%eax),%eax
  8021f7:	39 c2                	cmp    %eax,%edx
  8021f9:	73 6d                	jae    802268 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ff:	74 06                	je     802207 <insert_sorted_allocList+0x1f0>
  802201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802205:	75 14                	jne    80221b <insert_sorted_allocList+0x204>
  802207:	83 ec 04             	sub    $0x4,%esp
  80220a:	68 7c 40 80 00       	push   $0x80407c
  80220f:	6a 7f                	push   $0x7f
  802211:	68 07 40 80 00       	push   $0x804007
  802216:	e8 fa e0 ff ff       	call   800315 <_panic>
  80221b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221e:	8b 10                	mov    (%eax),%edx
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	89 10                	mov    %edx,(%eax)
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	8b 00                	mov    (%eax),%eax
  80222a:	85 c0                	test   %eax,%eax
  80222c:	74 0b                	je     802239 <insert_sorted_allocList+0x222>
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	8b 00                	mov    (%eax),%eax
  802233:	8b 55 08             	mov    0x8(%ebp),%edx
  802236:	89 50 04             	mov    %edx,0x4(%eax)
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	8b 55 08             	mov    0x8(%ebp),%edx
  80223f:	89 10                	mov    %edx,(%eax)
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802247:	89 50 04             	mov    %edx,0x4(%eax)
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	85 c0                	test   %eax,%eax
  802251:	75 08                	jne    80225b <insert_sorted_allocList+0x244>
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	a3 44 50 80 00       	mov    %eax,0x805044
  80225b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802260:	40                   	inc    %eax
  802261:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802266:	eb 39                	jmp    8022a1 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802268:	a1 48 50 80 00       	mov    0x805048,%eax
  80226d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802270:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802274:	74 07                	je     80227d <insert_sorted_allocList+0x266>
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 00                	mov    (%eax),%eax
  80227b:	eb 05                	jmp    802282 <insert_sorted_allocList+0x26b>
  80227d:	b8 00 00 00 00       	mov    $0x0,%eax
  802282:	a3 48 50 80 00       	mov    %eax,0x805048
  802287:	a1 48 50 80 00       	mov    0x805048,%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	0f 85 3f ff ff ff    	jne    8021d3 <insert_sorted_allocList+0x1bc>
  802294:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802298:	0f 85 35 ff ff ff    	jne    8021d3 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80229e:	eb 01                	jmp    8022a1 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022a0:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022a1:	90                   	nop
  8022a2:	c9                   	leave  
  8022a3:	c3                   	ret    

008022a4 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022aa:	a1 38 51 80 00       	mov    0x805138,%eax
  8022af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b2:	e9 85 01 00 00       	jmp    80243c <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8022bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c0:	0f 82 6e 01 00 00    	jb     802434 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022cf:	0f 85 8a 00 00 00    	jne    80235f <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d9:	75 17                	jne    8022f2 <alloc_block_FF+0x4e>
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	68 b0 40 80 00       	push   $0x8040b0
  8022e3:	68 93 00 00 00       	push   $0x93
  8022e8:	68 07 40 80 00       	push   $0x804007
  8022ed:	e8 23 e0 ff ff       	call   800315 <_panic>
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	8b 00                	mov    (%eax),%eax
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	74 10                	je     80230b <alloc_block_FF+0x67>
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 00                	mov    (%eax),%eax
  802300:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802303:	8b 52 04             	mov    0x4(%edx),%edx
  802306:	89 50 04             	mov    %edx,0x4(%eax)
  802309:	eb 0b                	jmp    802316 <alloc_block_FF+0x72>
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	8b 40 04             	mov    0x4(%eax),%eax
  802311:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 40 04             	mov    0x4(%eax),%eax
  80231c:	85 c0                	test   %eax,%eax
  80231e:	74 0f                	je     80232f <alloc_block_FF+0x8b>
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 40 04             	mov    0x4(%eax),%eax
  802326:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802329:	8b 12                	mov    (%edx),%edx
  80232b:	89 10                	mov    %edx,(%eax)
  80232d:	eb 0a                	jmp    802339 <alloc_block_FF+0x95>
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	8b 00                	mov    (%eax),%eax
  802334:	a3 38 51 80 00       	mov    %eax,0x805138
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80234c:	a1 44 51 80 00       	mov    0x805144,%eax
  802351:	48                   	dec    %eax
  802352:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	e9 10 01 00 00       	jmp    80246f <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	8b 40 0c             	mov    0xc(%eax),%eax
  802365:	3b 45 08             	cmp    0x8(%ebp),%eax
  802368:	0f 86 c6 00 00 00    	jbe    802434 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80236e:	a1 48 51 80 00       	mov    0x805148,%eax
  802373:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 50 08             	mov    0x8(%eax),%edx
  80237c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237f:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802385:	8b 55 08             	mov    0x8(%ebp),%edx
  802388:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80238b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80238f:	75 17                	jne    8023a8 <alloc_block_FF+0x104>
  802391:	83 ec 04             	sub    $0x4,%esp
  802394:	68 b0 40 80 00       	push   $0x8040b0
  802399:	68 9b 00 00 00       	push   $0x9b
  80239e:	68 07 40 80 00       	push   $0x804007
  8023a3:	e8 6d df ff ff       	call   800315 <_panic>
  8023a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ab:	8b 00                	mov    (%eax),%eax
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	74 10                	je     8023c1 <alloc_block_FF+0x11d>
  8023b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b4:	8b 00                	mov    (%eax),%eax
  8023b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023b9:	8b 52 04             	mov    0x4(%edx),%edx
  8023bc:	89 50 04             	mov    %edx,0x4(%eax)
  8023bf:	eb 0b                	jmp    8023cc <alloc_block_FF+0x128>
  8023c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c4:	8b 40 04             	mov    0x4(%eax),%eax
  8023c7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cf:	8b 40 04             	mov    0x4(%eax),%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	74 0f                	je     8023e5 <alloc_block_FF+0x141>
  8023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d9:	8b 40 04             	mov    0x4(%eax),%eax
  8023dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023df:	8b 12                	mov    (%edx),%edx
  8023e1:	89 10                	mov    %edx,(%eax)
  8023e3:	eb 0a                	jmp    8023ef <alloc_block_FF+0x14b>
  8023e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	a3 48 51 80 00       	mov    %eax,0x805148
  8023ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802402:	a1 54 51 80 00       	mov    0x805154,%eax
  802407:	48                   	dec    %eax
  802408:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 50 08             	mov    0x8(%eax),%edx
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	01 c2                	add    %eax,%edx
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 40 0c             	mov    0xc(%eax),%eax
  802424:	2b 45 08             	sub    0x8(%ebp),%eax
  802427:	89 c2                	mov    %eax,%edx
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	eb 3b                	jmp    80246f <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802434:	a1 40 51 80 00       	mov    0x805140,%eax
  802439:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802440:	74 07                	je     802449 <alloc_block_FF+0x1a5>
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802445:	8b 00                	mov    (%eax),%eax
  802447:	eb 05                	jmp    80244e <alloc_block_FF+0x1aa>
  802449:	b8 00 00 00 00       	mov    $0x0,%eax
  80244e:	a3 40 51 80 00       	mov    %eax,0x805140
  802453:	a1 40 51 80 00       	mov    0x805140,%eax
  802458:	85 c0                	test   %eax,%eax
  80245a:	0f 85 57 fe ff ff    	jne    8022b7 <alloc_block_FF+0x13>
  802460:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802464:	0f 85 4d fe ff ff    	jne    8022b7 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80246a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246f:	c9                   	leave  
  802470:	c3                   	ret    

00802471 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
  802474:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802477:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80247e:	a1 38 51 80 00       	mov    0x805138,%eax
  802483:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802486:	e9 df 00 00 00       	jmp    80256a <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 40 0c             	mov    0xc(%eax),%eax
  802491:	3b 45 08             	cmp    0x8(%ebp),%eax
  802494:	0f 82 c8 00 00 00    	jb     802562 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a3:	0f 85 8a 00 00 00    	jne    802533 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ad:	75 17                	jne    8024c6 <alloc_block_BF+0x55>
  8024af:	83 ec 04             	sub    $0x4,%esp
  8024b2:	68 b0 40 80 00       	push   $0x8040b0
  8024b7:	68 b7 00 00 00       	push   $0xb7
  8024bc:	68 07 40 80 00       	push   $0x804007
  8024c1:	e8 4f de ff ff       	call   800315 <_panic>
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 00                	mov    (%eax),%eax
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	74 10                	je     8024df <alloc_block_BF+0x6e>
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 00                	mov    (%eax),%eax
  8024d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d7:	8b 52 04             	mov    0x4(%edx),%edx
  8024da:	89 50 04             	mov    %edx,0x4(%eax)
  8024dd:	eb 0b                	jmp    8024ea <alloc_block_BF+0x79>
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 40 04             	mov    0x4(%eax),%eax
  8024e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 40 04             	mov    0x4(%eax),%eax
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	74 0f                	je     802503 <alloc_block_BF+0x92>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 40 04             	mov    0x4(%eax),%eax
  8024fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fd:	8b 12                	mov    (%edx),%edx
  8024ff:	89 10                	mov    %edx,(%eax)
  802501:	eb 0a                	jmp    80250d <alloc_block_BF+0x9c>
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	8b 00                	mov    (%eax),%eax
  802508:	a3 38 51 80 00       	mov    %eax,0x805138
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802520:	a1 44 51 80 00       	mov    0x805144,%eax
  802525:	48                   	dec    %eax
  802526:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	e9 4d 01 00 00       	jmp    802680 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 40 0c             	mov    0xc(%eax),%eax
  802539:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253c:	76 24                	jbe    802562 <alloc_block_BF+0xf1>
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 40 0c             	mov    0xc(%eax),%eax
  802544:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802547:	73 19                	jae    802562 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802549:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 40 0c             	mov    0xc(%eax),%eax
  802556:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 40 08             	mov    0x8(%eax),%eax
  80255f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802562:	a1 40 51 80 00       	mov    0x805140,%eax
  802567:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256e:	74 07                	je     802577 <alloc_block_BF+0x106>
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 00                	mov    (%eax),%eax
  802575:	eb 05                	jmp    80257c <alloc_block_BF+0x10b>
  802577:	b8 00 00 00 00       	mov    $0x0,%eax
  80257c:	a3 40 51 80 00       	mov    %eax,0x805140
  802581:	a1 40 51 80 00       	mov    0x805140,%eax
  802586:	85 c0                	test   %eax,%eax
  802588:	0f 85 fd fe ff ff    	jne    80248b <alloc_block_BF+0x1a>
  80258e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802592:	0f 85 f3 fe ff ff    	jne    80248b <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802598:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80259c:	0f 84 d9 00 00 00    	je     80267b <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8025a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025b0:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b9:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025c0:	75 17                	jne    8025d9 <alloc_block_BF+0x168>
  8025c2:	83 ec 04             	sub    $0x4,%esp
  8025c5:	68 b0 40 80 00       	push   $0x8040b0
  8025ca:	68 c7 00 00 00       	push   $0xc7
  8025cf:	68 07 40 80 00       	push   $0x804007
  8025d4:	e8 3c dd ff ff       	call   800315 <_panic>
  8025d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025dc:	8b 00                	mov    (%eax),%eax
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	74 10                	je     8025f2 <alloc_block_BF+0x181>
  8025e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e5:	8b 00                	mov    (%eax),%eax
  8025e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025ea:	8b 52 04             	mov    0x4(%edx),%edx
  8025ed:	89 50 04             	mov    %edx,0x4(%eax)
  8025f0:	eb 0b                	jmp    8025fd <alloc_block_BF+0x18c>
  8025f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f5:	8b 40 04             	mov    0x4(%eax),%eax
  8025f8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802600:	8b 40 04             	mov    0x4(%eax),%eax
  802603:	85 c0                	test   %eax,%eax
  802605:	74 0f                	je     802616 <alloc_block_BF+0x1a5>
  802607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260a:	8b 40 04             	mov    0x4(%eax),%eax
  80260d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802610:	8b 12                	mov    (%edx),%edx
  802612:	89 10                	mov    %edx,(%eax)
  802614:	eb 0a                	jmp    802620 <alloc_block_BF+0x1af>
  802616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802619:	8b 00                	mov    (%eax),%eax
  80261b:	a3 48 51 80 00       	mov    %eax,0x805148
  802620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802633:	a1 54 51 80 00       	mov    0x805154,%eax
  802638:	48                   	dec    %eax
  802639:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80263e:	83 ec 08             	sub    $0x8,%esp
  802641:	ff 75 ec             	pushl  -0x14(%ebp)
  802644:	68 38 51 80 00       	push   $0x805138
  802649:	e8 71 f9 ff ff       	call   801fbf <find_block>
  80264e:	83 c4 10             	add    $0x10,%esp
  802651:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802654:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802657:	8b 50 08             	mov    0x8(%eax),%edx
  80265a:	8b 45 08             	mov    0x8(%ebp),%eax
  80265d:	01 c2                	add    %eax,%edx
  80265f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802662:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802665:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802668:	8b 40 0c             	mov    0xc(%eax),%eax
  80266b:	2b 45 08             	sub    0x8(%ebp),%eax
  80266e:	89 c2                	mov    %eax,%edx
  802670:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802673:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802679:	eb 05                	jmp    802680 <alloc_block_BF+0x20f>
	}
	return NULL;
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802680:	c9                   	leave  
  802681:	c3                   	ret    

00802682 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
  802685:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802688:	a1 28 50 80 00       	mov    0x805028,%eax
  80268d:	85 c0                	test   %eax,%eax
  80268f:	0f 85 de 01 00 00    	jne    802873 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802695:	a1 38 51 80 00       	mov    0x805138,%eax
  80269a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269d:	e9 9e 01 00 00       	jmp    802840 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ab:	0f 82 87 01 00 00    	jb     802838 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ba:	0f 85 95 00 00 00    	jne    802755 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c4:	75 17                	jne    8026dd <alloc_block_NF+0x5b>
  8026c6:	83 ec 04             	sub    $0x4,%esp
  8026c9:	68 b0 40 80 00       	push   $0x8040b0
  8026ce:	68 e0 00 00 00       	push   $0xe0
  8026d3:	68 07 40 80 00       	push   $0x804007
  8026d8:	e8 38 dc ff ff       	call   800315 <_panic>
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	74 10                	je     8026f6 <alloc_block_NF+0x74>
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 00                	mov    (%eax),%eax
  8026eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ee:	8b 52 04             	mov    0x4(%edx),%edx
  8026f1:	89 50 04             	mov    %edx,0x4(%eax)
  8026f4:	eb 0b                	jmp    802701 <alloc_block_NF+0x7f>
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 04             	mov    0x4(%eax),%eax
  8026fc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 40 04             	mov    0x4(%eax),%eax
  802707:	85 c0                	test   %eax,%eax
  802709:	74 0f                	je     80271a <alloc_block_NF+0x98>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 04             	mov    0x4(%eax),%eax
  802711:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802714:	8b 12                	mov    (%edx),%edx
  802716:	89 10                	mov    %edx,(%eax)
  802718:	eb 0a                	jmp    802724 <alloc_block_NF+0xa2>
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 00                	mov    (%eax),%eax
  80271f:	a3 38 51 80 00       	mov    %eax,0x805138
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802737:	a1 44 51 80 00       	mov    0x805144,%eax
  80273c:	48                   	dec    %eax
  80273d:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 08             	mov    0x8(%eax),%eax
  802748:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	e9 f8 04 00 00       	jmp    802c4d <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 40 0c             	mov    0xc(%eax),%eax
  80275b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80275e:	0f 86 d4 00 00 00    	jbe    802838 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802764:	a1 48 51 80 00       	mov    0x805148,%eax
  802769:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	8b 50 08             	mov    0x8(%eax),%edx
  802772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802775:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277b:	8b 55 08             	mov    0x8(%ebp),%edx
  80277e:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802781:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802785:	75 17                	jne    80279e <alloc_block_NF+0x11c>
  802787:	83 ec 04             	sub    $0x4,%esp
  80278a:	68 b0 40 80 00       	push   $0x8040b0
  80278f:	68 e9 00 00 00       	push   $0xe9
  802794:	68 07 40 80 00       	push   $0x804007
  802799:	e8 77 db ff ff       	call   800315 <_panic>
  80279e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a1:	8b 00                	mov    (%eax),%eax
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	74 10                	je     8027b7 <alloc_block_NF+0x135>
  8027a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027aa:	8b 00                	mov    (%eax),%eax
  8027ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027af:	8b 52 04             	mov    0x4(%edx),%edx
  8027b2:	89 50 04             	mov    %edx,0x4(%eax)
  8027b5:	eb 0b                	jmp    8027c2 <alloc_block_NF+0x140>
  8027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ba:	8b 40 04             	mov    0x4(%eax),%eax
  8027bd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c5:	8b 40 04             	mov    0x4(%eax),%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	74 0f                	je     8027db <alloc_block_NF+0x159>
  8027cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cf:	8b 40 04             	mov    0x4(%eax),%eax
  8027d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d5:	8b 12                	mov    (%edx),%edx
  8027d7:	89 10                	mov    %edx,(%eax)
  8027d9:	eb 0a                	jmp    8027e5 <alloc_block_NF+0x163>
  8027db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	a3 48 51 80 00       	mov    %eax,0x805148
  8027e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8027fd:	48                   	dec    %eax
  8027fe:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802806:	8b 40 08             	mov    0x8(%eax),%eax
  802809:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 50 08             	mov    0x8(%eax),%edx
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
  802817:	01 c2                	add    %eax,%edx
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 40 0c             	mov    0xc(%eax),%eax
  802825:	2b 45 08             	sub    0x8(%ebp),%eax
  802828:	89 c2                	mov    %eax,%edx
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802833:	e9 15 04 00 00       	jmp    802c4d <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802838:	a1 40 51 80 00       	mov    0x805140,%eax
  80283d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802840:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802844:	74 07                	je     80284d <alloc_block_NF+0x1cb>
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 00                	mov    (%eax),%eax
  80284b:	eb 05                	jmp    802852 <alloc_block_NF+0x1d0>
  80284d:	b8 00 00 00 00       	mov    $0x0,%eax
  802852:	a3 40 51 80 00       	mov    %eax,0x805140
  802857:	a1 40 51 80 00       	mov    0x805140,%eax
  80285c:	85 c0                	test   %eax,%eax
  80285e:	0f 85 3e fe ff ff    	jne    8026a2 <alloc_block_NF+0x20>
  802864:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802868:	0f 85 34 fe ff ff    	jne    8026a2 <alloc_block_NF+0x20>
  80286e:	e9 d5 03 00 00       	jmp    802c48 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802873:	a1 38 51 80 00       	mov    0x805138,%eax
  802878:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287b:	e9 b1 01 00 00       	jmp    802a31 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 50 08             	mov    0x8(%eax),%edx
  802886:	a1 28 50 80 00       	mov    0x805028,%eax
  80288b:	39 c2                	cmp    %eax,%edx
  80288d:	0f 82 96 01 00 00    	jb     802a29 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 40 0c             	mov    0xc(%eax),%eax
  802899:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289c:	0f 82 87 01 00 00    	jb     802a29 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ab:	0f 85 95 00 00 00    	jne    802946 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b5:	75 17                	jne    8028ce <alloc_block_NF+0x24c>
  8028b7:	83 ec 04             	sub    $0x4,%esp
  8028ba:	68 b0 40 80 00       	push   $0x8040b0
  8028bf:	68 fc 00 00 00       	push   $0xfc
  8028c4:	68 07 40 80 00       	push   $0x804007
  8028c9:	e8 47 da ff ff       	call   800315 <_panic>
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 00                	mov    (%eax),%eax
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	74 10                	je     8028e7 <alloc_block_NF+0x265>
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028df:	8b 52 04             	mov    0x4(%edx),%edx
  8028e2:	89 50 04             	mov    %edx,0x4(%eax)
  8028e5:	eb 0b                	jmp    8028f2 <alloc_block_NF+0x270>
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 40 04             	mov    0x4(%eax),%eax
  8028ed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	8b 40 04             	mov    0x4(%eax),%eax
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	74 0f                	je     80290b <alloc_block_NF+0x289>
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 40 04             	mov    0x4(%eax),%eax
  802902:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802905:	8b 12                	mov    (%edx),%edx
  802907:	89 10                	mov    %edx,(%eax)
  802909:	eb 0a                	jmp    802915 <alloc_block_NF+0x293>
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 00                	mov    (%eax),%eax
  802910:	a3 38 51 80 00       	mov    %eax,0x805138
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802928:	a1 44 51 80 00       	mov    0x805144,%eax
  80292d:	48                   	dec    %eax
  80292e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 08             	mov    0x8(%eax),%eax
  802939:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	e9 07 03 00 00       	jmp    802c4d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 40 0c             	mov    0xc(%eax),%eax
  80294c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294f:	0f 86 d4 00 00 00    	jbe    802a29 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802955:	a1 48 51 80 00       	mov    0x805148,%eax
  80295a:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 50 08             	mov    0x8(%eax),%edx
  802963:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802966:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802969:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296c:	8b 55 08             	mov    0x8(%ebp),%edx
  80296f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802972:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802976:	75 17                	jne    80298f <alloc_block_NF+0x30d>
  802978:	83 ec 04             	sub    $0x4,%esp
  80297b:	68 b0 40 80 00       	push   $0x8040b0
  802980:	68 04 01 00 00       	push   $0x104
  802985:	68 07 40 80 00       	push   $0x804007
  80298a:	e8 86 d9 ff ff       	call   800315 <_panic>
  80298f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	74 10                	je     8029a8 <alloc_block_NF+0x326>
  802998:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029a0:	8b 52 04             	mov    0x4(%edx),%edx
  8029a3:	89 50 04             	mov    %edx,0x4(%eax)
  8029a6:	eb 0b                	jmp    8029b3 <alloc_block_NF+0x331>
  8029a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ab:	8b 40 04             	mov    0x4(%eax),%eax
  8029ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b6:	8b 40 04             	mov    0x4(%eax),%eax
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	74 0f                	je     8029cc <alloc_block_NF+0x34a>
  8029bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c0:	8b 40 04             	mov    0x4(%eax),%eax
  8029c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c6:	8b 12                	mov    (%edx),%edx
  8029c8:	89 10                	mov    %edx,(%eax)
  8029ca:	eb 0a                	jmp    8029d6 <alloc_block_NF+0x354>
  8029cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cf:	8b 00                	mov    (%eax),%eax
  8029d1:	a3 48 51 80 00       	mov    %eax,0x805148
  8029d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e9:	a1 54 51 80 00       	mov    0x805154,%eax
  8029ee:	48                   	dec    %eax
  8029ef:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f7:	8b 40 08             	mov    0x8(%eax),%eax
  8029fa:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 50 08             	mov    0x8(%eax),%edx
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	01 c2                	add    %eax,%edx
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 40 0c             	mov    0xc(%eax),%eax
  802a16:	2b 45 08             	sub    0x8(%ebp),%eax
  802a19:	89 c2                	mov    %eax,%edx
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a24:	e9 24 02 00 00       	jmp    802c4d <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a29:	a1 40 51 80 00       	mov    0x805140,%eax
  802a2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a35:	74 07                	je     802a3e <alloc_block_NF+0x3bc>
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 00                	mov    (%eax),%eax
  802a3c:	eb 05                	jmp    802a43 <alloc_block_NF+0x3c1>
  802a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a43:	a3 40 51 80 00       	mov    %eax,0x805140
  802a48:	a1 40 51 80 00       	mov    0x805140,%eax
  802a4d:	85 c0                	test   %eax,%eax
  802a4f:	0f 85 2b fe ff ff    	jne    802880 <alloc_block_NF+0x1fe>
  802a55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a59:	0f 85 21 fe ff ff    	jne    802880 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a5f:	a1 38 51 80 00       	mov    0x805138,%eax
  802a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a67:	e9 ae 01 00 00       	jmp    802c1a <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 50 08             	mov    0x8(%eax),%edx
  802a72:	a1 28 50 80 00       	mov    0x805028,%eax
  802a77:	39 c2                	cmp    %eax,%edx
  802a79:	0f 83 93 01 00 00    	jae    802c12 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 40 0c             	mov    0xc(%eax),%eax
  802a85:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a88:	0f 82 84 01 00 00    	jb     802c12 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 0c             	mov    0xc(%eax),%eax
  802a94:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a97:	0f 85 95 00 00 00    	jne    802b32 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa1:	75 17                	jne    802aba <alloc_block_NF+0x438>
  802aa3:	83 ec 04             	sub    $0x4,%esp
  802aa6:	68 b0 40 80 00       	push   $0x8040b0
  802aab:	68 14 01 00 00       	push   $0x114
  802ab0:	68 07 40 80 00       	push   $0x804007
  802ab5:	e8 5b d8 ff ff       	call   800315 <_panic>
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	8b 00                	mov    (%eax),%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	74 10                	je     802ad3 <alloc_block_NF+0x451>
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802acb:	8b 52 04             	mov    0x4(%edx),%edx
  802ace:	89 50 04             	mov    %edx,0x4(%eax)
  802ad1:	eb 0b                	jmp    802ade <alloc_block_NF+0x45c>
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	8b 40 04             	mov    0x4(%eax),%eax
  802ad9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae1:	8b 40 04             	mov    0x4(%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 0f                	je     802af7 <alloc_block_NF+0x475>
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 40 04             	mov    0x4(%eax),%eax
  802aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af1:	8b 12                	mov    (%edx),%edx
  802af3:	89 10                	mov    %edx,(%eax)
  802af5:	eb 0a                	jmp    802b01 <alloc_block_NF+0x47f>
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	8b 00                	mov    (%eax),%eax
  802afc:	a3 38 51 80 00       	mov    %eax,0x805138
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b14:	a1 44 51 80 00       	mov    0x805144,%eax
  802b19:	48                   	dec    %eax
  802b1a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 40 08             	mov    0x8(%eax),%eax
  802b25:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	e9 1b 01 00 00       	jmp    802c4d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	8b 40 0c             	mov    0xc(%eax),%eax
  802b38:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3b:	0f 86 d1 00 00 00    	jbe    802c12 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b41:	a1 48 51 80 00       	mov    0x805148,%eax
  802b46:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 50 08             	mov    0x8(%eax),%edx
  802b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b52:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b58:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b62:	75 17                	jne    802b7b <alloc_block_NF+0x4f9>
  802b64:	83 ec 04             	sub    $0x4,%esp
  802b67:	68 b0 40 80 00       	push   $0x8040b0
  802b6c:	68 1c 01 00 00       	push   $0x11c
  802b71:	68 07 40 80 00       	push   $0x804007
  802b76:	e8 9a d7 ff ff       	call   800315 <_panic>
  802b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	85 c0                	test   %eax,%eax
  802b82:	74 10                	je     802b94 <alloc_block_NF+0x512>
  802b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b87:	8b 00                	mov    (%eax),%eax
  802b89:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b8c:	8b 52 04             	mov    0x4(%edx),%edx
  802b8f:	89 50 04             	mov    %edx,0x4(%eax)
  802b92:	eb 0b                	jmp    802b9f <alloc_block_NF+0x51d>
  802b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b97:	8b 40 04             	mov    0x4(%eax),%eax
  802b9a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba2:	8b 40 04             	mov    0x4(%eax),%eax
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	74 0f                	je     802bb8 <alloc_block_NF+0x536>
  802ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bac:	8b 40 04             	mov    0x4(%eax),%eax
  802baf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb2:	8b 12                	mov    (%edx),%edx
  802bb4:	89 10                	mov    %edx,(%eax)
  802bb6:	eb 0a                	jmp    802bc2 <alloc_block_NF+0x540>
  802bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbb:	8b 00                	mov    (%eax),%eax
  802bbd:	a3 48 51 80 00       	mov    %eax,0x805148
  802bc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd5:	a1 54 51 80 00       	mov    0x805154,%eax
  802bda:	48                   	dec    %eax
  802bdb:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be3:	8b 40 08             	mov    0x8(%eax),%eax
  802be6:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	8b 50 08             	mov    0x8(%eax),%edx
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	01 c2                	add    %eax,%edx
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 40 0c             	mov    0xc(%eax),%eax
  802c02:	2b 45 08             	sub    0x8(%ebp),%eax
  802c05:	89 c2                	mov    %eax,%edx
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c10:	eb 3b                	jmp    802c4d <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c12:	a1 40 51 80 00       	mov    0x805140,%eax
  802c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1e:	74 07                	je     802c27 <alloc_block_NF+0x5a5>
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 00                	mov    (%eax),%eax
  802c25:	eb 05                	jmp    802c2c <alloc_block_NF+0x5aa>
  802c27:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2c:	a3 40 51 80 00       	mov    %eax,0x805140
  802c31:	a1 40 51 80 00       	mov    0x805140,%eax
  802c36:	85 c0                	test   %eax,%eax
  802c38:	0f 85 2e fe ff ff    	jne    802a6c <alloc_block_NF+0x3ea>
  802c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c42:	0f 85 24 fe ff ff    	jne    802a6c <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c4d:	c9                   	leave  
  802c4e:	c3                   	ret    

00802c4f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c4f:	55                   	push   %ebp
  802c50:	89 e5                	mov    %esp,%ebp
  802c52:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c55:	a1 38 51 80 00       	mov    0x805138,%eax
  802c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c5d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c62:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c65:	a1 38 51 80 00       	mov    0x805138,%eax
  802c6a:	85 c0                	test   %eax,%eax
  802c6c:	74 14                	je     802c82 <insert_sorted_with_merge_freeList+0x33>
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	8b 50 08             	mov    0x8(%eax),%edx
  802c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c77:	8b 40 08             	mov    0x8(%eax),%eax
  802c7a:	39 c2                	cmp    %eax,%edx
  802c7c:	0f 87 9b 01 00 00    	ja     802e1d <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c86:	75 17                	jne    802c9f <insert_sorted_with_merge_freeList+0x50>
  802c88:	83 ec 04             	sub    $0x4,%esp
  802c8b:	68 e4 3f 80 00       	push   $0x803fe4
  802c90:	68 38 01 00 00       	push   $0x138
  802c95:	68 07 40 80 00       	push   $0x804007
  802c9a:	e8 76 d6 ff ff       	call   800315 <_panic>
  802c9f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	89 10                	mov    %edx,(%eax)
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	85 c0                	test   %eax,%eax
  802cb1:	74 0d                	je     802cc0 <insert_sorted_with_merge_freeList+0x71>
  802cb3:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbb:	89 50 04             	mov    %edx,0x4(%eax)
  802cbe:	eb 08                	jmp    802cc8 <insert_sorted_with_merge_freeList+0x79>
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	a3 38 51 80 00       	mov    %eax,0x805138
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cda:	a1 44 51 80 00       	mov    0x805144,%eax
  802cdf:	40                   	inc    %eax
  802ce0:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ce5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce9:	0f 84 a8 06 00 00    	je     803397 <insert_sorted_with_merge_freeList+0x748>
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	8b 50 08             	mov    0x8(%eax),%edx
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfb:	01 c2                	add    %eax,%edx
  802cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d00:	8b 40 08             	mov    0x8(%eax),%eax
  802d03:	39 c2                	cmp    %eax,%edx
  802d05:	0f 85 8c 06 00 00    	jne    803397 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	8b 40 0c             	mov    0xc(%eax),%eax
  802d17:	01 c2                	add    %eax,%edx
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d23:	75 17                	jne    802d3c <insert_sorted_with_merge_freeList+0xed>
  802d25:	83 ec 04             	sub    $0x4,%esp
  802d28:	68 b0 40 80 00       	push   $0x8040b0
  802d2d:	68 3c 01 00 00       	push   $0x13c
  802d32:	68 07 40 80 00       	push   $0x804007
  802d37:	e8 d9 d5 ff ff       	call   800315 <_panic>
  802d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	85 c0                	test   %eax,%eax
  802d43:	74 10                	je     802d55 <insert_sorted_with_merge_freeList+0x106>
  802d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4d:	8b 52 04             	mov    0x4(%edx),%edx
  802d50:	89 50 04             	mov    %edx,0x4(%eax)
  802d53:	eb 0b                	jmp    802d60 <insert_sorted_with_merge_freeList+0x111>
  802d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d58:	8b 40 04             	mov    0x4(%eax),%eax
  802d5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	85 c0                	test   %eax,%eax
  802d68:	74 0f                	je     802d79 <insert_sorted_with_merge_freeList+0x12a>
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d73:	8b 12                	mov    (%edx),%edx
  802d75:	89 10                	mov    %edx,(%eax)
  802d77:	eb 0a                	jmp    802d83 <insert_sorted_with_merge_freeList+0x134>
  802d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	a3 38 51 80 00       	mov    %eax,0x805138
  802d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d96:	a1 44 51 80 00       	mov    0x805144,%eax
  802d9b:	48                   	dec    %eax
  802d9c:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802db5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db9:	75 17                	jne    802dd2 <insert_sorted_with_merge_freeList+0x183>
  802dbb:	83 ec 04             	sub    $0x4,%esp
  802dbe:	68 e4 3f 80 00       	push   $0x803fe4
  802dc3:	68 3f 01 00 00       	push   $0x13f
  802dc8:	68 07 40 80 00       	push   $0x804007
  802dcd:	e8 43 d5 ff ff       	call   800315 <_panic>
  802dd2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddb:	89 10                	mov    %edx,(%eax)
  802ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de0:	8b 00                	mov    (%eax),%eax
  802de2:	85 c0                	test   %eax,%eax
  802de4:	74 0d                	je     802df3 <insert_sorted_with_merge_freeList+0x1a4>
  802de6:	a1 48 51 80 00       	mov    0x805148,%eax
  802deb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dee:	89 50 04             	mov    %edx,0x4(%eax)
  802df1:	eb 08                	jmp    802dfb <insert_sorted_with_merge_freeList+0x1ac>
  802df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfe:	a3 48 51 80 00       	mov    %eax,0x805148
  802e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0d:	a1 54 51 80 00       	mov    0x805154,%eax
  802e12:	40                   	inc    %eax
  802e13:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e18:	e9 7a 05 00 00       	jmp    803397 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	8b 50 08             	mov    0x8(%eax),%edx
  802e23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e26:	8b 40 08             	mov    0x8(%eax),%eax
  802e29:	39 c2                	cmp    %eax,%edx
  802e2b:	0f 82 14 01 00 00    	jb     802f45 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e34:	8b 50 08             	mov    0x8(%eax),%edx
  802e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3d:	01 c2                	add    %eax,%edx
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	8b 40 08             	mov    0x8(%eax),%eax
  802e45:	39 c2                	cmp    %eax,%edx
  802e47:	0f 85 90 00 00 00    	jne    802edd <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e50:	8b 50 0c             	mov    0xc(%eax),%edx
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	8b 40 0c             	mov    0xc(%eax),%eax
  802e59:	01 c2                	add    %eax,%edx
  802e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5e:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e79:	75 17                	jne    802e92 <insert_sorted_with_merge_freeList+0x243>
  802e7b:	83 ec 04             	sub    $0x4,%esp
  802e7e:	68 e4 3f 80 00       	push   $0x803fe4
  802e83:	68 49 01 00 00       	push   $0x149
  802e88:	68 07 40 80 00       	push   $0x804007
  802e8d:	e8 83 d4 ff ff       	call   800315 <_panic>
  802e92:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	89 10                	mov    %edx,(%eax)
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	8b 00                	mov    (%eax),%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	74 0d                	je     802eb3 <insert_sorted_with_merge_freeList+0x264>
  802ea6:	a1 48 51 80 00       	mov    0x805148,%eax
  802eab:	8b 55 08             	mov    0x8(%ebp),%edx
  802eae:	89 50 04             	mov    %edx,0x4(%eax)
  802eb1:	eb 08                	jmp    802ebb <insert_sorted_with_merge_freeList+0x26c>
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	a3 48 51 80 00       	mov    %eax,0x805148
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecd:	a1 54 51 80 00       	mov    0x805154,%eax
  802ed2:	40                   	inc    %eax
  802ed3:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ed8:	e9 bb 04 00 00       	jmp    803398 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802edd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee1:	75 17                	jne    802efa <insert_sorted_with_merge_freeList+0x2ab>
  802ee3:	83 ec 04             	sub    $0x4,%esp
  802ee6:	68 58 40 80 00       	push   $0x804058
  802eeb:	68 4c 01 00 00       	push   $0x14c
  802ef0:	68 07 40 80 00       	push   $0x804007
  802ef5:	e8 1b d4 ff ff       	call   800315 <_panic>
  802efa:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	89 50 04             	mov    %edx,0x4(%eax)
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	8b 40 04             	mov    0x4(%eax),%eax
  802f0c:	85 c0                	test   %eax,%eax
  802f0e:	74 0c                	je     802f1c <insert_sorted_with_merge_freeList+0x2cd>
  802f10:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f15:	8b 55 08             	mov    0x8(%ebp),%edx
  802f18:	89 10                	mov    %edx,(%eax)
  802f1a:	eb 08                	jmp    802f24 <insert_sorted_with_merge_freeList+0x2d5>
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	a3 38 51 80 00       	mov    %eax,0x805138
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f35:	a1 44 51 80 00       	mov    0x805144,%eax
  802f3a:	40                   	inc    %eax
  802f3b:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f40:	e9 53 04 00 00       	jmp    803398 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f45:	a1 38 51 80 00       	mov    0x805138,%eax
  802f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f4d:	e9 15 04 00 00       	jmp    803367 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	8b 00                	mov    (%eax),%eax
  802f57:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	8b 50 08             	mov    0x8(%eax),%edx
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 40 08             	mov    0x8(%eax),%eax
  802f66:	39 c2                	cmp    %eax,%edx
  802f68:	0f 86 f1 03 00 00    	jbe    80335f <insert_sorted_with_merge_freeList+0x710>
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	8b 50 08             	mov    0x8(%eax),%edx
  802f74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f77:	8b 40 08             	mov    0x8(%eax),%eax
  802f7a:	39 c2                	cmp    %eax,%edx
  802f7c:	0f 83 dd 03 00 00    	jae    80335f <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f85:	8b 50 08             	mov    0x8(%eax),%edx
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8e:	01 c2                	add    %eax,%edx
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	8b 40 08             	mov    0x8(%eax),%eax
  802f96:	39 c2                	cmp    %eax,%edx
  802f98:	0f 85 b9 01 00 00    	jne    803157 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	8b 50 08             	mov    0x8(%eax),%edx
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802faa:	01 c2                	add    %eax,%edx
  802fac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faf:	8b 40 08             	mov    0x8(%eax),%eax
  802fb2:	39 c2                	cmp    %eax,%edx
  802fb4:	0f 85 0d 01 00 00    	jne    8030c7 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 50 0c             	mov    0xc(%eax),%edx
  802fc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc6:	01 c2                	add    %eax,%edx
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd2:	75 17                	jne    802feb <insert_sorted_with_merge_freeList+0x39c>
  802fd4:	83 ec 04             	sub    $0x4,%esp
  802fd7:	68 b0 40 80 00       	push   $0x8040b0
  802fdc:	68 5c 01 00 00       	push   $0x15c
  802fe1:	68 07 40 80 00       	push   $0x804007
  802fe6:	e8 2a d3 ff ff       	call   800315 <_panic>
  802feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	74 10                	je     803004 <insert_sorted_with_merge_freeList+0x3b5>
  802ff4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ffc:	8b 52 04             	mov    0x4(%edx),%edx
  802fff:	89 50 04             	mov    %edx,0x4(%eax)
  803002:	eb 0b                	jmp    80300f <insert_sorted_with_merge_freeList+0x3c0>
  803004:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803007:	8b 40 04             	mov    0x4(%eax),%eax
  80300a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80300f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803012:	8b 40 04             	mov    0x4(%eax),%eax
  803015:	85 c0                	test   %eax,%eax
  803017:	74 0f                	je     803028 <insert_sorted_with_merge_freeList+0x3d9>
  803019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301c:	8b 40 04             	mov    0x4(%eax),%eax
  80301f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803022:	8b 12                	mov    (%edx),%edx
  803024:	89 10                	mov    %edx,(%eax)
  803026:	eb 0a                	jmp    803032 <insert_sorted_with_merge_freeList+0x3e3>
  803028:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302b:	8b 00                	mov    (%eax),%eax
  80302d:	a3 38 51 80 00       	mov    %eax,0x805138
  803032:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803035:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803045:	a1 44 51 80 00       	mov    0x805144,%eax
  80304a:	48                   	dec    %eax
  80304b:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803050:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803053:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80305a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803064:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803068:	75 17                	jne    803081 <insert_sorted_with_merge_freeList+0x432>
  80306a:	83 ec 04             	sub    $0x4,%esp
  80306d:	68 e4 3f 80 00       	push   $0x803fe4
  803072:	68 5f 01 00 00       	push   $0x15f
  803077:	68 07 40 80 00       	push   $0x804007
  80307c:	e8 94 d2 ff ff       	call   800315 <_panic>
  803081:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803087:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308a:	89 10                	mov    %edx,(%eax)
  80308c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	85 c0                	test   %eax,%eax
  803093:	74 0d                	je     8030a2 <insert_sorted_with_merge_freeList+0x453>
  803095:	a1 48 51 80 00       	mov    0x805148,%eax
  80309a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309d:	89 50 04             	mov    %edx,0x4(%eax)
  8030a0:	eb 08                	jmp    8030aa <insert_sorted_with_merge_freeList+0x45b>
  8030a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ad:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bc:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c1:	40                   	inc    %eax
  8030c2:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	8b 50 0c             	mov    0xc(%eax),%edx
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d3:	01 c2                	add    %eax,%edx
  8030d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d8:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030db:	8b 45 08             	mov    0x8(%ebp),%eax
  8030de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f3:	75 17                	jne    80310c <insert_sorted_with_merge_freeList+0x4bd>
  8030f5:	83 ec 04             	sub    $0x4,%esp
  8030f8:	68 e4 3f 80 00       	push   $0x803fe4
  8030fd:	68 64 01 00 00       	push   $0x164
  803102:	68 07 40 80 00       	push   $0x804007
  803107:	e8 09 d2 ff ff       	call   800315 <_panic>
  80310c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	89 10                	mov    %edx,(%eax)
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	8b 00                	mov    (%eax),%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	74 0d                	je     80312d <insert_sorted_with_merge_freeList+0x4de>
  803120:	a1 48 51 80 00       	mov    0x805148,%eax
  803125:	8b 55 08             	mov    0x8(%ebp),%edx
  803128:	89 50 04             	mov    %edx,0x4(%eax)
  80312b:	eb 08                	jmp    803135 <insert_sorted_with_merge_freeList+0x4e6>
  80312d:	8b 45 08             	mov    0x8(%ebp),%eax
  803130:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803135:	8b 45 08             	mov    0x8(%ebp),%eax
  803138:	a3 48 51 80 00       	mov    %eax,0x805148
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803147:	a1 54 51 80 00       	mov    0x805154,%eax
  80314c:	40                   	inc    %eax
  80314d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803152:	e9 41 02 00 00       	jmp    803398 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803157:	8b 45 08             	mov    0x8(%ebp),%eax
  80315a:	8b 50 08             	mov    0x8(%eax),%edx
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	8b 40 0c             	mov    0xc(%eax),%eax
  803163:	01 c2                	add    %eax,%edx
  803165:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803168:	8b 40 08             	mov    0x8(%eax),%eax
  80316b:	39 c2                	cmp    %eax,%edx
  80316d:	0f 85 7c 01 00 00    	jne    8032ef <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803173:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803177:	74 06                	je     80317f <insert_sorted_with_merge_freeList+0x530>
  803179:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317d:	75 17                	jne    803196 <insert_sorted_with_merge_freeList+0x547>
  80317f:	83 ec 04             	sub    $0x4,%esp
  803182:	68 20 40 80 00       	push   $0x804020
  803187:	68 69 01 00 00       	push   $0x169
  80318c:	68 07 40 80 00       	push   $0x804007
  803191:	e8 7f d1 ff ff       	call   800315 <_panic>
  803196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803199:	8b 50 04             	mov    0x4(%eax),%edx
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	89 50 04             	mov    %edx,0x4(%eax)
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a8:	89 10                	mov    %edx,(%eax)
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	8b 40 04             	mov    0x4(%eax),%eax
  8031b0:	85 c0                	test   %eax,%eax
  8031b2:	74 0d                	je     8031c1 <insert_sorted_with_merge_freeList+0x572>
  8031b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bd:	89 10                	mov    %edx,(%eax)
  8031bf:	eb 08                	jmp    8031c9 <insert_sorted_with_merge_freeList+0x57a>
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	a3 38 51 80 00       	mov    %eax,0x805138
  8031c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8031cf:	89 50 04             	mov    %edx,0x4(%eax)
  8031d2:	a1 44 51 80 00       	mov    0x805144,%eax
  8031d7:	40                   	inc    %eax
  8031d8:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	8b 50 0c             	mov    0xc(%eax),%edx
  8031e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e9:	01 c2                	add    %eax,%edx
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f5:	75 17                	jne    80320e <insert_sorted_with_merge_freeList+0x5bf>
  8031f7:	83 ec 04             	sub    $0x4,%esp
  8031fa:	68 b0 40 80 00       	push   $0x8040b0
  8031ff:	68 6b 01 00 00       	push   $0x16b
  803204:	68 07 40 80 00       	push   $0x804007
  803209:	e8 07 d1 ff ff       	call   800315 <_panic>
  80320e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803211:	8b 00                	mov    (%eax),%eax
  803213:	85 c0                	test   %eax,%eax
  803215:	74 10                	je     803227 <insert_sorted_with_merge_freeList+0x5d8>
  803217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321a:	8b 00                	mov    (%eax),%eax
  80321c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80321f:	8b 52 04             	mov    0x4(%edx),%edx
  803222:	89 50 04             	mov    %edx,0x4(%eax)
  803225:	eb 0b                	jmp    803232 <insert_sorted_with_merge_freeList+0x5e3>
  803227:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322a:	8b 40 04             	mov    0x4(%eax),%eax
  80322d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803235:	8b 40 04             	mov    0x4(%eax),%eax
  803238:	85 c0                	test   %eax,%eax
  80323a:	74 0f                	je     80324b <insert_sorted_with_merge_freeList+0x5fc>
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	8b 40 04             	mov    0x4(%eax),%eax
  803242:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803245:	8b 12                	mov    (%edx),%edx
  803247:	89 10                	mov    %edx,(%eax)
  803249:	eb 0a                	jmp    803255 <insert_sorted_with_merge_freeList+0x606>
  80324b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324e:	8b 00                	mov    (%eax),%eax
  803250:	a3 38 51 80 00       	mov    %eax,0x805138
  803255:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803268:	a1 44 51 80 00       	mov    0x805144,%eax
  80326d:	48                   	dec    %eax
  80326e:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803276:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803280:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803287:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80328b:	75 17                	jne    8032a4 <insert_sorted_with_merge_freeList+0x655>
  80328d:	83 ec 04             	sub    $0x4,%esp
  803290:	68 e4 3f 80 00       	push   $0x803fe4
  803295:	68 6e 01 00 00       	push   $0x16e
  80329a:	68 07 40 80 00       	push   $0x804007
  80329f:	e8 71 d0 ff ff       	call   800315 <_panic>
  8032a4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ad:	89 10                	mov    %edx,(%eax)
  8032af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b2:	8b 00                	mov    (%eax),%eax
  8032b4:	85 c0                	test   %eax,%eax
  8032b6:	74 0d                	je     8032c5 <insert_sorted_with_merge_freeList+0x676>
  8032b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8032bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c0:	89 50 04             	mov    %edx,0x4(%eax)
  8032c3:	eb 08                	jmp    8032cd <insert_sorted_with_merge_freeList+0x67e>
  8032c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8032d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032df:	a1 54 51 80 00       	mov    0x805154,%eax
  8032e4:	40                   	inc    %eax
  8032e5:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032ea:	e9 a9 00 00 00       	jmp    803398 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f3:	74 06                	je     8032fb <insert_sorted_with_merge_freeList+0x6ac>
  8032f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f9:	75 17                	jne    803312 <insert_sorted_with_merge_freeList+0x6c3>
  8032fb:	83 ec 04             	sub    $0x4,%esp
  8032fe:	68 7c 40 80 00       	push   $0x80407c
  803303:	68 73 01 00 00       	push   $0x173
  803308:	68 07 40 80 00       	push   $0x804007
  80330d:	e8 03 d0 ff ff       	call   800315 <_panic>
  803312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803315:	8b 10                	mov    (%eax),%edx
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	89 10                	mov    %edx,(%eax)
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	8b 00                	mov    (%eax),%eax
  803321:	85 c0                	test   %eax,%eax
  803323:	74 0b                	je     803330 <insert_sorted_with_merge_freeList+0x6e1>
  803325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803328:	8b 00                	mov    (%eax),%eax
  80332a:	8b 55 08             	mov    0x8(%ebp),%edx
  80332d:	89 50 04             	mov    %edx,0x4(%eax)
  803330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803333:	8b 55 08             	mov    0x8(%ebp),%edx
  803336:	89 10                	mov    %edx,(%eax)
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80333e:	89 50 04             	mov    %edx,0x4(%eax)
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	85 c0                	test   %eax,%eax
  803348:	75 08                	jne    803352 <insert_sorted_with_merge_freeList+0x703>
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803352:	a1 44 51 80 00       	mov    0x805144,%eax
  803357:	40                   	inc    %eax
  803358:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80335d:	eb 39                	jmp    803398 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80335f:	a1 40 51 80 00       	mov    0x805140,%eax
  803364:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803367:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336b:	74 07                	je     803374 <insert_sorted_with_merge_freeList+0x725>
  80336d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803370:	8b 00                	mov    (%eax),%eax
  803372:	eb 05                	jmp    803379 <insert_sorted_with_merge_freeList+0x72a>
  803374:	b8 00 00 00 00       	mov    $0x0,%eax
  803379:	a3 40 51 80 00       	mov    %eax,0x805140
  80337e:	a1 40 51 80 00       	mov    0x805140,%eax
  803383:	85 c0                	test   %eax,%eax
  803385:	0f 85 c7 fb ff ff    	jne    802f52 <insert_sorted_with_merge_freeList+0x303>
  80338b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338f:	0f 85 bd fb ff ff    	jne    802f52 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803395:	eb 01                	jmp    803398 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803397:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803398:	90                   	nop
  803399:	c9                   	leave  
  80339a:	c3                   	ret    
  80339b:	90                   	nop

0080339c <__udivdi3>:
  80339c:	55                   	push   %ebp
  80339d:	57                   	push   %edi
  80339e:	56                   	push   %esi
  80339f:	53                   	push   %ebx
  8033a0:	83 ec 1c             	sub    $0x1c,%esp
  8033a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033b3:	89 ca                	mov    %ecx,%edx
  8033b5:	89 f8                	mov    %edi,%eax
  8033b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033bb:	85 f6                	test   %esi,%esi
  8033bd:	75 2d                	jne    8033ec <__udivdi3+0x50>
  8033bf:	39 cf                	cmp    %ecx,%edi
  8033c1:	77 65                	ja     803428 <__udivdi3+0x8c>
  8033c3:	89 fd                	mov    %edi,%ebp
  8033c5:	85 ff                	test   %edi,%edi
  8033c7:	75 0b                	jne    8033d4 <__udivdi3+0x38>
  8033c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ce:	31 d2                	xor    %edx,%edx
  8033d0:	f7 f7                	div    %edi
  8033d2:	89 c5                	mov    %eax,%ebp
  8033d4:	31 d2                	xor    %edx,%edx
  8033d6:	89 c8                	mov    %ecx,%eax
  8033d8:	f7 f5                	div    %ebp
  8033da:	89 c1                	mov    %eax,%ecx
  8033dc:	89 d8                	mov    %ebx,%eax
  8033de:	f7 f5                	div    %ebp
  8033e0:	89 cf                	mov    %ecx,%edi
  8033e2:	89 fa                	mov    %edi,%edx
  8033e4:	83 c4 1c             	add    $0x1c,%esp
  8033e7:	5b                   	pop    %ebx
  8033e8:	5e                   	pop    %esi
  8033e9:	5f                   	pop    %edi
  8033ea:	5d                   	pop    %ebp
  8033eb:	c3                   	ret    
  8033ec:	39 ce                	cmp    %ecx,%esi
  8033ee:	77 28                	ja     803418 <__udivdi3+0x7c>
  8033f0:	0f bd fe             	bsr    %esi,%edi
  8033f3:	83 f7 1f             	xor    $0x1f,%edi
  8033f6:	75 40                	jne    803438 <__udivdi3+0x9c>
  8033f8:	39 ce                	cmp    %ecx,%esi
  8033fa:	72 0a                	jb     803406 <__udivdi3+0x6a>
  8033fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803400:	0f 87 9e 00 00 00    	ja     8034a4 <__udivdi3+0x108>
  803406:	b8 01 00 00 00       	mov    $0x1,%eax
  80340b:	89 fa                	mov    %edi,%edx
  80340d:	83 c4 1c             	add    $0x1c,%esp
  803410:	5b                   	pop    %ebx
  803411:	5e                   	pop    %esi
  803412:	5f                   	pop    %edi
  803413:	5d                   	pop    %ebp
  803414:	c3                   	ret    
  803415:	8d 76 00             	lea    0x0(%esi),%esi
  803418:	31 ff                	xor    %edi,%edi
  80341a:	31 c0                	xor    %eax,%eax
  80341c:	89 fa                	mov    %edi,%edx
  80341e:	83 c4 1c             	add    $0x1c,%esp
  803421:	5b                   	pop    %ebx
  803422:	5e                   	pop    %esi
  803423:	5f                   	pop    %edi
  803424:	5d                   	pop    %ebp
  803425:	c3                   	ret    
  803426:	66 90                	xchg   %ax,%ax
  803428:	89 d8                	mov    %ebx,%eax
  80342a:	f7 f7                	div    %edi
  80342c:	31 ff                	xor    %edi,%edi
  80342e:	89 fa                	mov    %edi,%edx
  803430:	83 c4 1c             	add    $0x1c,%esp
  803433:	5b                   	pop    %ebx
  803434:	5e                   	pop    %esi
  803435:	5f                   	pop    %edi
  803436:	5d                   	pop    %ebp
  803437:	c3                   	ret    
  803438:	bd 20 00 00 00       	mov    $0x20,%ebp
  80343d:	89 eb                	mov    %ebp,%ebx
  80343f:	29 fb                	sub    %edi,%ebx
  803441:	89 f9                	mov    %edi,%ecx
  803443:	d3 e6                	shl    %cl,%esi
  803445:	89 c5                	mov    %eax,%ebp
  803447:	88 d9                	mov    %bl,%cl
  803449:	d3 ed                	shr    %cl,%ebp
  80344b:	89 e9                	mov    %ebp,%ecx
  80344d:	09 f1                	or     %esi,%ecx
  80344f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803453:	89 f9                	mov    %edi,%ecx
  803455:	d3 e0                	shl    %cl,%eax
  803457:	89 c5                	mov    %eax,%ebp
  803459:	89 d6                	mov    %edx,%esi
  80345b:	88 d9                	mov    %bl,%cl
  80345d:	d3 ee                	shr    %cl,%esi
  80345f:	89 f9                	mov    %edi,%ecx
  803461:	d3 e2                	shl    %cl,%edx
  803463:	8b 44 24 08          	mov    0x8(%esp),%eax
  803467:	88 d9                	mov    %bl,%cl
  803469:	d3 e8                	shr    %cl,%eax
  80346b:	09 c2                	or     %eax,%edx
  80346d:	89 d0                	mov    %edx,%eax
  80346f:	89 f2                	mov    %esi,%edx
  803471:	f7 74 24 0c          	divl   0xc(%esp)
  803475:	89 d6                	mov    %edx,%esi
  803477:	89 c3                	mov    %eax,%ebx
  803479:	f7 e5                	mul    %ebp
  80347b:	39 d6                	cmp    %edx,%esi
  80347d:	72 19                	jb     803498 <__udivdi3+0xfc>
  80347f:	74 0b                	je     80348c <__udivdi3+0xf0>
  803481:	89 d8                	mov    %ebx,%eax
  803483:	31 ff                	xor    %edi,%edi
  803485:	e9 58 ff ff ff       	jmp    8033e2 <__udivdi3+0x46>
  80348a:	66 90                	xchg   %ax,%ax
  80348c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803490:	89 f9                	mov    %edi,%ecx
  803492:	d3 e2                	shl    %cl,%edx
  803494:	39 c2                	cmp    %eax,%edx
  803496:	73 e9                	jae    803481 <__udivdi3+0xe5>
  803498:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80349b:	31 ff                	xor    %edi,%edi
  80349d:	e9 40 ff ff ff       	jmp    8033e2 <__udivdi3+0x46>
  8034a2:	66 90                	xchg   %ax,%ax
  8034a4:	31 c0                	xor    %eax,%eax
  8034a6:	e9 37 ff ff ff       	jmp    8033e2 <__udivdi3+0x46>
  8034ab:	90                   	nop

008034ac <__umoddi3>:
  8034ac:	55                   	push   %ebp
  8034ad:	57                   	push   %edi
  8034ae:	56                   	push   %esi
  8034af:	53                   	push   %ebx
  8034b0:	83 ec 1c             	sub    $0x1c,%esp
  8034b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034cb:	89 f3                	mov    %esi,%ebx
  8034cd:	89 fa                	mov    %edi,%edx
  8034cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034d3:	89 34 24             	mov    %esi,(%esp)
  8034d6:	85 c0                	test   %eax,%eax
  8034d8:	75 1a                	jne    8034f4 <__umoddi3+0x48>
  8034da:	39 f7                	cmp    %esi,%edi
  8034dc:	0f 86 a2 00 00 00    	jbe    803584 <__umoddi3+0xd8>
  8034e2:	89 c8                	mov    %ecx,%eax
  8034e4:	89 f2                	mov    %esi,%edx
  8034e6:	f7 f7                	div    %edi
  8034e8:	89 d0                	mov    %edx,%eax
  8034ea:	31 d2                	xor    %edx,%edx
  8034ec:	83 c4 1c             	add    $0x1c,%esp
  8034ef:	5b                   	pop    %ebx
  8034f0:	5e                   	pop    %esi
  8034f1:	5f                   	pop    %edi
  8034f2:	5d                   	pop    %ebp
  8034f3:	c3                   	ret    
  8034f4:	39 f0                	cmp    %esi,%eax
  8034f6:	0f 87 ac 00 00 00    	ja     8035a8 <__umoddi3+0xfc>
  8034fc:	0f bd e8             	bsr    %eax,%ebp
  8034ff:	83 f5 1f             	xor    $0x1f,%ebp
  803502:	0f 84 ac 00 00 00    	je     8035b4 <__umoddi3+0x108>
  803508:	bf 20 00 00 00       	mov    $0x20,%edi
  80350d:	29 ef                	sub    %ebp,%edi
  80350f:	89 fe                	mov    %edi,%esi
  803511:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803515:	89 e9                	mov    %ebp,%ecx
  803517:	d3 e0                	shl    %cl,%eax
  803519:	89 d7                	mov    %edx,%edi
  80351b:	89 f1                	mov    %esi,%ecx
  80351d:	d3 ef                	shr    %cl,%edi
  80351f:	09 c7                	or     %eax,%edi
  803521:	89 e9                	mov    %ebp,%ecx
  803523:	d3 e2                	shl    %cl,%edx
  803525:	89 14 24             	mov    %edx,(%esp)
  803528:	89 d8                	mov    %ebx,%eax
  80352a:	d3 e0                	shl    %cl,%eax
  80352c:	89 c2                	mov    %eax,%edx
  80352e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803532:	d3 e0                	shl    %cl,%eax
  803534:	89 44 24 04          	mov    %eax,0x4(%esp)
  803538:	8b 44 24 08          	mov    0x8(%esp),%eax
  80353c:	89 f1                	mov    %esi,%ecx
  80353e:	d3 e8                	shr    %cl,%eax
  803540:	09 d0                	or     %edx,%eax
  803542:	d3 eb                	shr    %cl,%ebx
  803544:	89 da                	mov    %ebx,%edx
  803546:	f7 f7                	div    %edi
  803548:	89 d3                	mov    %edx,%ebx
  80354a:	f7 24 24             	mull   (%esp)
  80354d:	89 c6                	mov    %eax,%esi
  80354f:	89 d1                	mov    %edx,%ecx
  803551:	39 d3                	cmp    %edx,%ebx
  803553:	0f 82 87 00 00 00    	jb     8035e0 <__umoddi3+0x134>
  803559:	0f 84 91 00 00 00    	je     8035f0 <__umoddi3+0x144>
  80355f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803563:	29 f2                	sub    %esi,%edx
  803565:	19 cb                	sbb    %ecx,%ebx
  803567:	89 d8                	mov    %ebx,%eax
  803569:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80356d:	d3 e0                	shl    %cl,%eax
  80356f:	89 e9                	mov    %ebp,%ecx
  803571:	d3 ea                	shr    %cl,%edx
  803573:	09 d0                	or     %edx,%eax
  803575:	89 e9                	mov    %ebp,%ecx
  803577:	d3 eb                	shr    %cl,%ebx
  803579:	89 da                	mov    %ebx,%edx
  80357b:	83 c4 1c             	add    $0x1c,%esp
  80357e:	5b                   	pop    %ebx
  80357f:	5e                   	pop    %esi
  803580:	5f                   	pop    %edi
  803581:	5d                   	pop    %ebp
  803582:	c3                   	ret    
  803583:	90                   	nop
  803584:	89 fd                	mov    %edi,%ebp
  803586:	85 ff                	test   %edi,%edi
  803588:	75 0b                	jne    803595 <__umoddi3+0xe9>
  80358a:	b8 01 00 00 00       	mov    $0x1,%eax
  80358f:	31 d2                	xor    %edx,%edx
  803591:	f7 f7                	div    %edi
  803593:	89 c5                	mov    %eax,%ebp
  803595:	89 f0                	mov    %esi,%eax
  803597:	31 d2                	xor    %edx,%edx
  803599:	f7 f5                	div    %ebp
  80359b:	89 c8                	mov    %ecx,%eax
  80359d:	f7 f5                	div    %ebp
  80359f:	89 d0                	mov    %edx,%eax
  8035a1:	e9 44 ff ff ff       	jmp    8034ea <__umoddi3+0x3e>
  8035a6:	66 90                	xchg   %ax,%ax
  8035a8:	89 c8                	mov    %ecx,%eax
  8035aa:	89 f2                	mov    %esi,%edx
  8035ac:	83 c4 1c             	add    $0x1c,%esp
  8035af:	5b                   	pop    %ebx
  8035b0:	5e                   	pop    %esi
  8035b1:	5f                   	pop    %edi
  8035b2:	5d                   	pop    %ebp
  8035b3:	c3                   	ret    
  8035b4:	3b 04 24             	cmp    (%esp),%eax
  8035b7:	72 06                	jb     8035bf <__umoddi3+0x113>
  8035b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035bd:	77 0f                	ja     8035ce <__umoddi3+0x122>
  8035bf:	89 f2                	mov    %esi,%edx
  8035c1:	29 f9                	sub    %edi,%ecx
  8035c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035c7:	89 14 24             	mov    %edx,(%esp)
  8035ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035d2:	8b 14 24             	mov    (%esp),%edx
  8035d5:	83 c4 1c             	add    $0x1c,%esp
  8035d8:	5b                   	pop    %ebx
  8035d9:	5e                   	pop    %esi
  8035da:	5f                   	pop    %edi
  8035db:	5d                   	pop    %ebp
  8035dc:	c3                   	ret    
  8035dd:	8d 76 00             	lea    0x0(%esi),%esi
  8035e0:	2b 04 24             	sub    (%esp),%eax
  8035e3:	19 fa                	sbb    %edi,%edx
  8035e5:	89 d1                	mov    %edx,%ecx
  8035e7:	89 c6                	mov    %eax,%esi
  8035e9:	e9 71 ff ff ff       	jmp    80355f <__umoddi3+0xb3>
  8035ee:	66 90                	xchg   %ax,%ax
  8035f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035f4:	72 ea                	jb     8035e0 <__umoddi3+0x134>
  8035f6:	89 d9                	mov    %ebx,%ecx
  8035f8:	e9 62 ff ff ff       	jmp    80355f <__umoddi3+0xb3>
