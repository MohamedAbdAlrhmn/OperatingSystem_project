
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 10 01 00 00       	call   800146 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing removing the shared variables
	// Testing scenario 5_1: Kill ONE program has shared variables and it free it
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 20 37 80 00       	push   $0x803720
  80004a:	e8 ba 15 00 00       	call   801609 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 78 18 00 00       	call   8018db <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 10 19 00 00       	call   80197b <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 37 80 00       	push   $0x803730
  800079:	e8 b8 04 00 00       	call   800536 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 63 37 80 00       	push   $0x803763
  800099:	e8 af 1a 00 00       	call   801b4d <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 bc 1a 00 00       	call   801b6b <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 19 18 00 00       	call   8018db <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 6c 37 80 00       	push   $0x80376c
  8000cb:	e8 66 04 00 00       	call   800536 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 a9 1a 00 00       	call   801b87 <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 f5 17 00 00       	call   8018db <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 8d 18 00 00       	call   80197b <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 a0 37 80 00       	push   $0x8037a0
  800104:	e8 2d 04 00 00       	call   800536 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 f0 37 80 00       	push   $0x8037f0
  800114:	6a 1e                	push   $0x1e
  800116:	68 26 38 80 00       	push   $0x803826
  80011b:	e8 62 01 00 00       	call   800282 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 3c 38 80 00       	push   $0x80383c
  80012b:	e8 06 04 00 00       	call   800536 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 9c 38 80 00       	push   $0x80389c
  80013b:	e8 f6 03 00 00       	call   800536 <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	return;
  800143:	90                   	nop
}
  800144:	c9                   	leave  
  800145:	c3                   	ret    

00800146 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80014c:	e8 6a 1a 00 00       	call   801bbb <sys_getenvindex>
  800151:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800157:	89 d0                	mov    %edx,%eax
  800159:	c1 e0 03             	shl    $0x3,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 04             	shl    $0x4,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 50 80 00       	mov    0x805020,%eax
  80017d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800183:	84 c0                	test   %al,%al
  800185:	74 0f                	je     800196 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800187:	a1 20 50 80 00       	mov    0x805020,%eax
  80018c:	05 5c 05 00 00       	add    $0x55c,%eax
  800191:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019a:	7e 0a                	jle    8001a6 <libmain+0x60>
		binaryname = argv[0];
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	e8 84 fe ff ff       	call   800038 <_main>
  8001b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b7:	e8 0c 18 00 00       	call   8019c8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 00 39 80 00       	push   $0x803900
  8001c4:	e8 6d 03 00 00       	call   800536 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8001dc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	52                   	push   %edx
  8001e6:	50                   	push   %eax
  8001e7:	68 28 39 80 00       	push   $0x803928
  8001ec:	e8 45 03 00 00       	call   800536 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f4:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f9:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ff:	a1 20 50 80 00       	mov    0x805020,%eax
  800204:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80020a:	a1 20 50 80 00       	mov    0x805020,%eax
  80020f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800215:	51                   	push   %ecx
  800216:	52                   	push   %edx
  800217:	50                   	push   %eax
  800218:	68 50 39 80 00       	push   $0x803950
  80021d:	e8 14 03 00 00       	call   800536 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 50 80 00       	mov    0x805020,%eax
  80022a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 a8 39 80 00       	push   $0x8039a8
  800239:	e8 f8 02 00 00       	call   800536 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 00 39 80 00       	push   $0x803900
  800249:	e8 e8 02 00 00       	call   800536 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800251:	e8 8c 17 00 00       	call   8019e2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800256:	e8 19 00 00 00       	call   800274 <exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	6a 00                	push   $0x0
  800269:	e8 19 19 00 00       	call   801b87 <sys_destroy_env>
  80026e:	83 c4 10             	add    $0x10,%esp
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <exit>:

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027a:	e8 6e 19 00 00       	call   801bed <sys_exit_env>
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800288:	8d 45 10             	lea    0x10(%ebp),%eax
  80028b:	83 c0 04             	add    $0x4,%eax
  80028e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800291:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	74 16                	je     8002b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029a:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	50                   	push   %eax
  8002a3:	68 bc 39 80 00       	push   $0x8039bc
  8002a8:	e8 89 02 00 00       	call   800536 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 50 80 00       	mov    0x805000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 c1 39 80 00       	push   $0x8039c1
  8002c1:	e8 70 02 00 00       	call   800536 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d2:	50                   	push   %eax
  8002d3:	e8 f3 01 00 00       	call   8004cb <vcprintf>
  8002d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	6a 00                	push   $0x0
  8002e0:	68 dd 39 80 00       	push   $0x8039dd
  8002e5:	e8 e1 01 00 00       	call   8004cb <vcprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ed:	e8 82 ff ff ff       	call   800274 <exit>

	// should not return here
	while (1) ;
  8002f2:	eb fe                	jmp    8002f2 <_panic+0x70>

008002f4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ff:	8b 50 74             	mov    0x74(%eax),%edx
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	39 c2                	cmp    %eax,%edx
  800307:	74 14                	je     80031d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 e0 39 80 00       	push   $0x8039e0
  800311:	6a 26                	push   $0x26
  800313:	68 2c 3a 80 00       	push   $0x803a2c
  800318:	e8 65 ff ff ff       	call   800282 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800324:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80032b:	e9 c2 00 00 00       	jmp    8003f2 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800333:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	01 d0                	add    %edx,%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	85 c0                	test   %eax,%eax
  800343:	75 08                	jne    80034d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800345:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800348:	e9 a2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800354:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80035b:	eb 69                	jmp    8003c6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035d:	a1 20 50 80 00       	mov    0x805020,%eax
  800362:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800368:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036b:	89 d0                	mov    %edx,%eax
  80036d:	01 c0                	add    %eax,%eax
  80036f:	01 d0                	add    %edx,%eax
  800371:	c1 e0 03             	shl    $0x3,%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8a 40 04             	mov    0x4(%eax),%al
  800379:	84 c0                	test   %al,%al
  80037b:	75 46                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037d:	a1 20 50 80 00       	mov    0x805020,%eax
  800382:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800388:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038b:	89 d0                	mov    %edx,%eax
  80038d:	01 c0                	add    %eax,%eax
  80038f:	01 d0                	add    %edx,%eax
  800391:	c1 e0 03             	shl    $0x3,%eax
  800394:	01 c8                	add    %ecx,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80039b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	01 c8                	add    %ecx,%eax
  8003b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b6:	39 c2                	cmp    %eax,%edx
  8003b8:	75 09                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c1:	eb 12                	jmp    8003d5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c3:	ff 45 e8             	incl   -0x18(%ebp)
  8003c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003cb:	8b 50 74             	mov    0x74(%eax),%edx
  8003ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	77 88                	ja     80035d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d9:	75 14                	jne    8003ef <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	68 38 3a 80 00       	push   $0x803a38
  8003e3:	6a 3a                	push   $0x3a
  8003e5:	68 2c 3a 80 00       	push   $0x803a2c
  8003ea:	e8 93 fe ff ff       	call   800282 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ef:	ff 45 f0             	incl   -0x10(%ebp)
  8003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f8:	0f 8c 32 ff ff ff    	jl     800330 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800405:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040c:	eb 26                	jmp    800434 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040e:	a1 20 50 80 00       	mov    0x805020,%eax
  800413:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800419:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	01 c0                	add    %eax,%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	c1 e0 03             	shl    $0x3,%eax
  800425:	01 c8                	add    %ecx,%eax
  800427:	8a 40 04             	mov    0x4(%eax),%al
  80042a:	3c 01                	cmp    $0x1,%al
  80042c:	75 03                	jne    800431 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800431:	ff 45 e0             	incl   -0x20(%ebp)
  800434:	a1 20 50 80 00       	mov    0x805020,%eax
  800439:	8b 50 74             	mov    0x74(%eax),%edx
  80043c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043f:	39 c2                	cmp    %eax,%edx
  800441:	77 cb                	ja     80040e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800449:	74 14                	je     80045f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80044b:	83 ec 04             	sub    $0x4,%esp
  80044e:	68 8c 3a 80 00       	push   $0x803a8c
  800453:	6a 44                	push   $0x44
  800455:	68 2c 3a 80 00       	push   $0x803a2c
  80045a:	e8 23 fe ff ff       	call   800282 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045f:	90                   	nop
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 48 01             	lea    0x1(%eax),%ecx
  800470:	8b 55 0c             	mov    0xc(%ebp),%edx
  800473:	89 0a                	mov    %ecx,(%edx)
  800475:	8b 55 08             	mov    0x8(%ebp),%edx
  800478:	88 d1                	mov    %dl,%cl
  80047a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800481:	8b 45 0c             	mov    0xc(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048b:	75 2c                	jne    8004b9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048d:	a0 24 50 80 00       	mov    0x805024,%al
  800492:	0f b6 c0             	movzbl %al,%eax
  800495:	8b 55 0c             	mov    0xc(%ebp),%edx
  800498:	8b 12                	mov    (%edx),%edx
  80049a:	89 d1                	mov    %edx,%ecx
  80049c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049f:	83 c2 08             	add    $0x8,%edx
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	50                   	push   %eax
  8004a6:	51                   	push   %ecx
  8004a7:	52                   	push   %edx
  8004a8:	e8 6d 13 00 00       	call   80181a <sys_cputs>
  8004ad:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bc:	8b 40 04             	mov    0x4(%eax),%eax
  8004bf:	8d 50 01             	lea    0x1(%eax),%edx
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c8:	90                   	nop
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004db:	00 00 00 
	b.cnt = 0;
  8004de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	50                   	push   %eax
  8004f5:	68 62 04 80 00       	push   $0x800462
  8004fa:	e8 11 02 00 00       	call   800710 <vprintfmt>
  8004ff:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800502:	a0 24 50 80 00       	mov    0x805024,%al
  800507:	0f b6 c0             	movzbl %al,%eax
  80050a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800510:	83 ec 04             	sub    $0x4,%esp
  800513:	50                   	push   %eax
  800514:	52                   	push   %edx
  800515:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051b:	83 c0 08             	add    $0x8,%eax
  80051e:	50                   	push   %eax
  80051f:	e8 f6 12 00 00       	call   80181a <sys_cputs>
  800524:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800527:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80052e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <cprintf>:

int cprintf(const char *fmt, ...) {
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80053c:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800543:	8d 45 0c             	lea    0xc(%ebp),%eax
  800546:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	ff 75 f4             	pushl  -0xc(%ebp)
  800552:	50                   	push   %eax
  800553:	e8 73 ff ff ff       	call   8004cb <vcprintf>
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800569:	e8 5a 14 00 00       	call   8019c8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800571:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 f4             	pushl  -0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	e8 48 ff ff ff       	call   8004cb <vcprintf>
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800589:	e8 54 14 00 00       	call   8019e2 <sys_enable_interrupt>
	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	53                   	push   %ebx
  800597:	83 ec 14             	sub    $0x14,%esp
  80059a:	8b 45 10             	mov    0x10(%ebp),%eax
  80059d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b1:	77 55                	ja     800608 <printnum+0x75>
  8005b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b6:	72 05                	jb     8005bd <printnum+0x2a>
  8005b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005bb:	77 4b                	ja     800608 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	52                   	push   %edx
  8005cc:	50                   	push   %eax
  8005cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d3:	e8 c8 2e 00 00       	call   8034a0 <__udivdi3>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	ff 75 20             	pushl  0x20(%ebp)
  8005e1:	53                   	push   %ebx
  8005e2:	ff 75 18             	pushl  0x18(%ebp)
  8005e5:	52                   	push   %edx
  8005e6:	50                   	push   %eax
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 08             	pushl  0x8(%ebp)
  8005ed:	e8 a1 ff ff ff       	call   800593 <printnum>
  8005f2:	83 c4 20             	add    $0x20,%esp
  8005f5:	eb 1a                	jmp    800611 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	ff 75 0c             	pushl  0xc(%ebp)
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800608:	ff 4d 1c             	decl   0x1c(%ebp)
  80060b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060f:	7f e6                	jg     8005f7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800611:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800614:	bb 00 00 00 00       	mov    $0x0,%ebx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061f:	53                   	push   %ebx
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	50                   	push   %eax
  800623:	e8 88 2f 00 00       	call   8035b0 <__umoddi3>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	05 f4 3c 80 00       	add    $0x803cf4,%eax
  800630:	8a 00                	mov    (%eax),%al
  800632:	0f be c0             	movsbl %al,%eax
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 0c             	pushl  0xc(%ebp)
  80063b:	50                   	push   %eax
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	ff d0                	call   *%eax
  800641:	83 c4 10             	add    $0x10,%esp
}
  800644:	90                   	nop
  800645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800648:	c9                   	leave  
  800649:	c3                   	ret    

0080064a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064a:	55                   	push   %ebp
  80064b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800651:	7e 1c                	jle    80066f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	8d 50 08             	lea    0x8(%eax),%edx
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	89 10                	mov    %edx,(%eax)
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	83 e8 08             	sub    $0x8,%eax
  800668:	8b 50 04             	mov    0x4(%eax),%edx
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	eb 40                	jmp    8006af <getuint+0x65>
	else if (lflag)
  80066f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800673:	74 1e                	je     800693 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800675:	8b 45 08             	mov    0x8(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	8d 50 04             	lea    0x4(%eax),%edx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	89 10                	mov    %edx,(%eax)
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	83 e8 04             	sub    $0x4,%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	eb 1c                	jmp    8006af <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 04             	lea    0x4(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 04             	sub    $0x4,%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006af:	5d                   	pop    %ebp
  8006b0:	c3                   	ret    

008006b1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getint+0x25>
		return va_arg(*ap, long long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 08             	lea    0x8(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 08             	sub    $0x8,%eax
  8006cf:	8b 50 04             	mov    0x4(%eax),%edx
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	eb 38                	jmp    80070e <getint+0x5d>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1a                	je     8006f6 <getint+0x45>
		return va_arg(*ap, long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	99                   	cltd   
  8006f4:	eb 18                	jmp    80070e <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	8d 50 04             	lea    0x4(%eax),%edx
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	89 10                	mov    %edx,(%eax)
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	83 e8 04             	sub    $0x4,%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	99                   	cltd   
}
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	56                   	push   %esi
  800714:	53                   	push   %ebx
  800715:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800718:	eb 17                	jmp    800731 <vprintfmt+0x21>
			if (ch == '\0')
  80071a:	85 db                	test   %ebx,%ebx
  80071c:	0f 84 af 03 00 00    	je     800ad1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	53                   	push   %ebx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	ff d0                	call   *%eax
  80072e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800731:	8b 45 10             	mov    0x10(%ebp),%eax
  800734:	8d 50 01             	lea    0x1(%eax),%edx
  800737:	89 55 10             	mov    %edx,0x10(%ebp)
  80073a:	8a 00                	mov    (%eax),%al
  80073c:	0f b6 d8             	movzbl %al,%ebx
  80073f:	83 fb 25             	cmp    $0x25,%ebx
  800742:	75 d6                	jne    80071a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800744:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800748:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800756:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800775:	83 f8 55             	cmp    $0x55,%eax
  800778:	0f 87 2b 03 00 00    	ja     800aa9 <vprintfmt+0x399>
  80077e:	8b 04 85 18 3d 80 00 	mov    0x803d18(,%eax,4),%eax
  800785:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800787:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078b:	eb d7                	jmp    800764 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800791:	eb d1                	jmp    800764 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800793:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079d:	89 d0                	mov    %edx,%eax
  80079f:	c1 e0 02             	shl    $0x2,%eax
  8007a2:	01 d0                	add    %edx,%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	01 d8                	add    %ebx,%eax
  8007a8:	83 e8 30             	sub    $0x30,%eax
  8007ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b1:	8a 00                	mov    (%eax),%al
  8007b3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b9:	7e 3e                	jle    8007f9 <vprintfmt+0xe9>
  8007bb:	83 fb 39             	cmp    $0x39,%ebx
  8007be:	7f 39                	jg     8007f9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c3:	eb d5                	jmp    80079a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 c0 04             	add    $0x4,%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d9:	eb 1f                	jmp    8007fa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007df:	79 83                	jns    800764 <vprintfmt+0x54>
				width = 0;
  8007e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e8:	e9 77 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ed:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f4:	e9 6b ff ff ff       	jmp    800764 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	0f 89 60 ff ff ff    	jns    800764 <vprintfmt+0x54>
				width = precision, precision = -1;
  800804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800811:	e9 4e ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800816:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800819:	e9 46 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	83 c0 04             	add    $0x4,%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 e8 04             	sub    $0x4,%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	50                   	push   %eax
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			break;
  80083e:	e9 89 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 e8 04             	sub    $0x4,%eax
  800852:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800854:	85 db                	test   %ebx,%ebx
  800856:	79 02                	jns    80085a <vprintfmt+0x14a>
				err = -err;
  800858:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085a:	83 fb 64             	cmp    $0x64,%ebx
  80085d:	7f 0b                	jg     80086a <vprintfmt+0x15a>
  80085f:	8b 34 9d 60 3b 80 00 	mov    0x803b60(,%ebx,4),%esi
  800866:	85 f6                	test   %esi,%esi
  800868:	75 19                	jne    800883 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086a:	53                   	push   %ebx
  80086b:	68 05 3d 80 00       	push   $0x803d05
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	ff 75 08             	pushl  0x8(%ebp)
  800876:	e8 5e 02 00 00       	call   800ad9 <printfmt>
  80087b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087e:	e9 49 02 00 00       	jmp    800acc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800883:	56                   	push   %esi
  800884:	68 0e 3d 80 00       	push   $0x803d0e
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	ff 75 08             	pushl  0x8(%ebp)
  80088f:	e8 45 02 00 00       	call   800ad9 <printfmt>
  800894:	83 c4 10             	add    $0x10,%esp
			break;
  800897:	e9 30 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 e8 04             	sub    $0x4,%eax
  8008ab:	8b 30                	mov    (%eax),%esi
  8008ad:	85 f6                	test   %esi,%esi
  8008af:	75 05                	jne    8008b6 <vprintfmt+0x1a6>
				p = "(null)";
  8008b1:	be 11 3d 80 00       	mov    $0x803d11,%esi
			if (width > 0 && padc != '-')
  8008b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ba:	7e 6d                	jle    800929 <vprintfmt+0x219>
  8008bc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c0:	74 67                	je     800929 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	50                   	push   %eax
  8008c9:	56                   	push   %esi
  8008ca:	e8 0c 03 00 00       	call   800bdb <strnlen>
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d5:	eb 16                	jmp    8008ed <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	50                   	push   %eax
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f1:	7f e4                	jg     8008d7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f3:	eb 34                	jmp    800929 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f9:	74 1c                	je     800917 <vprintfmt+0x207>
  8008fb:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fe:	7e 05                	jle    800905 <vprintfmt+0x1f5>
  800900:	83 fb 7e             	cmp    $0x7e,%ebx
  800903:	7e 12                	jle    800917 <vprintfmt+0x207>
					putch('?', putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	6a 3f                	push   $0x3f
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	eb 0f                	jmp    800926 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	53                   	push   %ebx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	ff 4d e4             	decl   -0x1c(%ebp)
  800929:	89 f0                	mov    %esi,%eax
  80092b:	8d 70 01             	lea    0x1(%eax),%esi
  80092e:	8a 00                	mov    (%eax),%al
  800930:	0f be d8             	movsbl %al,%ebx
  800933:	85 db                	test   %ebx,%ebx
  800935:	74 24                	je     80095b <vprintfmt+0x24b>
  800937:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093b:	78 b8                	js     8008f5 <vprintfmt+0x1e5>
  80093d:	ff 4d e0             	decl   -0x20(%ebp)
  800940:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800944:	79 af                	jns    8008f5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800946:	eb 13                	jmp    80095b <vprintfmt+0x24b>
				putch(' ', putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	6a 20                	push   $0x20
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095f:	7f e7                	jg     800948 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800961:	e9 66 01 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 e8             	pushl  -0x18(%ebp)
  80096c:	8d 45 14             	lea    0x14(%ebp),%eax
  80096f:	50                   	push   %eax
  800970:	e8 3c fd ff ff       	call   8006b1 <getint>
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800984:	85 d2                	test   %edx,%edx
  800986:	79 23                	jns    8009ab <vprintfmt+0x29b>
				putch('-', putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	6a 2d                	push   $0x2d
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	ff d0                	call   *%eax
  800995:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099e:	f7 d8                	neg    %eax
  8009a0:	83 d2 00             	adc    $0x0,%edx
  8009a3:	f7 da                	neg    %edx
  8009a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b2:	e9 bc 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bd:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c0:	50                   	push   %eax
  8009c1:	e8 84 fc ff ff       	call   80064a <getuint>
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d6:	e9 98 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 58                	push   $0x58
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	6a 58                	push   $0x58
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 58                	push   $0x58
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			break;
  800a0b:	e9 bc 00 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	6a 30                	push   $0x30
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 78                	push   $0x78
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 c0 04             	add    $0x4,%eax
  800a36:	89 45 14             	mov    %eax,0x14(%ebp)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 e8 04             	sub    $0x4,%eax
  800a3f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a52:	eb 1f                	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5d:	50                   	push   %eax
  800a5e:	e8 e7 fb ff ff       	call   80064a <getuint>
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a6c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a73:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7a:	83 ec 04             	sub    $0x4,%esp
  800a7d:	52                   	push   %edx
  800a7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a81:	50                   	push   %eax
  800a82:	ff 75 f4             	pushl  -0xc(%ebp)
  800a85:	ff 75 f0             	pushl  -0x10(%ebp)
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	e8 00 fb ff ff       	call   800593 <printnum>
  800a93:	83 c4 20             	add    $0x20,%esp
			break;
  800a96:	eb 34                	jmp    800acc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	53                   	push   %ebx
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			break;
  800aa7:	eb 23                	jmp    800acc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	6a 25                	push   $0x25
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab9:	ff 4d 10             	decl   0x10(%ebp)
  800abc:	eb 03                	jmp    800ac1 <vprintfmt+0x3b1>
  800abe:	ff 4d 10             	decl   0x10(%ebp)
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	48                   	dec    %eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	3c 25                	cmp    $0x25,%al
  800ac9:	75 f3                	jne    800abe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800acb:	90                   	nop
		}
	}
  800acc:	e9 47 fc ff ff       	jmp    800718 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  800aeb:	ff 75 f4             	pushl  -0xc(%ebp)
  800aee:	50                   	push   %eax
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 16 fc ff ff       	call   800710 <vprintfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afd:	90                   	nop
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	8b 40 08             	mov    0x8(%eax),%eax
  800b09:	8d 50 01             	lea    0x1(%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8b 10                	mov    (%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	8b 40 04             	mov    0x4(%eax),%eax
  800b1d:	39 c2                	cmp    %eax,%edx
  800b1f:	73 12                	jae    800b33 <sprintputch+0x33>
		*b->buf++ = ch;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	8d 48 01             	lea    0x1(%eax),%ecx
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 0a                	mov    %ecx,(%edx)
  800b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b31:	88 10                	mov    %dl,(%eax)
}
  800b33:	90                   	nop
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	01 d0                	add    %edx,%eax
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5b:	74 06                	je     800b63 <vsnprintf+0x2d>
  800b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b61:	7f 07                	jg     800b6a <vsnprintf+0x34>
		return -E_INVAL;
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	eb 20                	jmp    800b8a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b6a:	ff 75 14             	pushl  0x14(%ebp)
  800b6d:	ff 75 10             	pushl  0x10(%ebp)
  800b70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 00 0b 80 00       	push   $0x800b00
  800b79:	e8 92 fb ff ff       	call   800710 <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 89 ff ff ff       	call   800b36 <vsnprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc5:	eb 06                	jmp    800bcd <strlen+0x15>
		n++;
  800bc7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bca:	ff 45 08             	incl   0x8(%ebp)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 f1                	jne    800bc7 <strlen+0xf>
		n++;
	return n;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be8:	eb 09                	jmp    800bf3 <strnlen+0x18>
		n++;
  800bea:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 4d 0c             	decl   0xc(%ebp)
  800bf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf7:	74 09                	je     800c02 <strnlen+0x27>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	75 e8                	jne    800bea <strnlen+0xf>
		n++;
	return n;
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c13:	90                   	nop
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c23:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c26:	8a 12                	mov    (%edx),%dl
  800c28:	88 10                	mov    %dl,(%eax)
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	75 e4                	jne    800c14 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c48:	eb 1f                	jmp    800c69 <strncpy+0x34>
		*dst++ = *src;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 08             	mov    %edx,0x8(%ebp)
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	84 c0                	test   %al,%al
  800c61:	74 03                	je     800c66 <strncpy+0x31>
			src++;
  800c63:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c66:	ff 45 fc             	incl   -0x4(%ebp)
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6f:	72 d9                	jb     800c4a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c86:	74 30                	je     800cb8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c88:	eb 16                	jmp    800ca0 <strlcpy+0x2a>
			*dst++ = *src++;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8d 50 01             	lea    0x1(%eax),%edx
  800c90:	89 55 08             	mov    %edx,0x8(%ebp)
  800c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9c:	8a 12                	mov    (%edx),%dl
  800c9e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca0:	ff 4d 10             	decl   0x10(%ebp)
  800ca3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca7:	74 09                	je     800cb2 <strlcpy+0x3c>
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 d8                	jne    800c8a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbe:	29 c2                	sub    %eax,%edx
  800cc0:	89 d0                	mov    %edx,%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc7:	eb 06                	jmp    800ccf <strcmp+0xb>
		p++, q++;
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	84 c0                	test   %al,%al
  800cd6:	74 0e                	je     800ce6 <strcmp+0x22>
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 10                	mov    (%eax),%dl
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	38 c2                	cmp    %al,%dl
  800ce4:	74 e3                	je     800cc9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	0f b6 d0             	movzbl %al,%edx
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	0f b6 c0             	movzbl %al,%eax
  800cf6:	29 c2                	sub    %eax,%edx
  800cf8:	89 d0                	mov    %edx,%eax
}
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cff:	eb 09                	jmp    800d0a <strncmp+0xe>
		n--, p++, q++;
  800d01:	ff 4d 10             	decl   0x10(%ebp)
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 17                	je     800d27 <strncmp+0x2b>
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	74 0e                	je     800d27 <strncmp+0x2b>
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 10                	mov    (%eax),%dl
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	38 c2                	cmp    %al,%dl
  800d25:	74 da                	je     800d01 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2b:	75 07                	jne    800d34 <strncmp+0x38>
		return 0;
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	eb 14                	jmp    800d48 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 d0             	movzbl %al,%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f b6 c0             	movzbl %al,%eax
  800d44:	29 c2                	sub    %eax,%edx
  800d46:	89 d0                	mov    %edx,%eax
}
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d56:	eb 12                	jmp    800d6a <strchr+0x20>
		if (*s == c)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d60:	75 05                	jne    800d67 <strchr+0x1d>
			return (char *) s;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	eb 11                	jmp    800d78 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	84 c0                	test   %al,%al
  800d71:	75 e5                	jne    800d58 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 0d                	jmp    800d95 <strfind+0x1b>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	74 0e                	je     800da0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 ea                	jne    800d88 <strfind+0xe>
  800d9e:	eb 01                	jmp    800da1 <strfind+0x27>
		if (*s == c)
			break;
  800da0:	90                   	nop
	return (char *) s;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db8:	eb 0e                	jmp    800dc8 <memset+0x22>
		*p++ = c;
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc8:	ff 4d f8             	decl   -0x8(%ebp)
  800dcb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcf:	79 e9                	jns    800dba <memset+0x14>
		*p++ = c;

	return v;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de8:	eb 16                	jmp    800e00 <memcpy+0x2a>
		*d++ = *s++;
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dfc:	8a 12                	mov    (%edx),%dl
  800dfe:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e06:	89 55 10             	mov    %edx,0x10(%ebp)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	75 dd                	jne    800dea <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2a:	73 50                	jae    800e7c <memmove+0x6a>
  800e2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	01 d0                	add    %edx,%eax
  800e34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e37:	76 43                	jbe    800e7c <memmove+0x6a>
		s += n;
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e42:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e45:	eb 10                	jmp    800e57 <memmove+0x45>
			*--d = *--s;
  800e47:	ff 4d f8             	decl   -0x8(%ebp)
  800e4a:	ff 4d fc             	decl   -0x4(%ebp)
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8a 10                	mov    (%eax),%dl
  800e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e55:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e57:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	75 e3                	jne    800e47 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e64:	eb 23                	jmp    800e89 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e75:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e78:	8a 12                	mov    (%edx),%dl
  800e7a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 dd                	jne    800e66 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea0:	eb 2a                	jmp    800ecc <memcmp+0x3e>
		if (*s1 != *s2)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8a 10                	mov    (%eax),%dl
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	38 c2                	cmp    %al,%dl
  800eae:	74 16                	je     800ec6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	0f b6 d0             	movzbl %al,%edx
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	0f b6 c0             	movzbl %al,%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	eb 18                	jmp    800ede <memcmp+0x50>
		s1++, s2++;
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
  800ec9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	75 c9                	jne    800ea2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef1:	eb 15                	jmp    800f08 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 d0             	movzbl %al,%edx
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	0f b6 c0             	movzbl %al,%eax
  800f01:	39 c2                	cmp    %eax,%edx
  800f03:	74 0d                	je     800f12 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0e:	72 e3                	jb     800ef3 <memfind+0x13>
  800f10:	eb 01                	jmp    800f13 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f12:	90                   	nop
	return (void *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2c:	eb 03                	jmp    800f31 <strtol+0x19>
		s++;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 20                	cmp    $0x20,%al
  800f38:	74 f4                	je     800f2e <strtol+0x16>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 09                	cmp    $0x9,%al
  800f41:	74 eb                	je     800f2e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 2b                	cmp    $0x2b,%al
  800f4a:	75 05                	jne    800f51 <strtol+0x39>
		s++;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	eb 13                	jmp    800f64 <strtol+0x4c>
	else if (*s == '-')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2d                	cmp    $0x2d,%al
  800f58:	75 0a                	jne    800f64 <strtol+0x4c>
		s++, neg = 1;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f68:	74 06                	je     800f70 <strtol+0x58>
  800f6a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6e:	75 20                	jne    800f90 <strtol+0x78>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 30                	cmp    $0x30,%al
  800f77:	75 17                	jne    800f90 <strtol+0x78>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	40                   	inc    %eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 78                	cmp    $0x78,%al
  800f81:	75 0d                	jne    800f90 <strtol+0x78>
		s += 2, base = 16;
  800f83:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f87:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8e:	eb 28                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	75 15                	jne    800fab <strtol+0x93>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 30                	cmp    $0x30,%al
  800f9d:	75 0c                	jne    800fab <strtol+0x93>
		s++, base = 8;
  800f9f:	ff 45 08             	incl   0x8(%ebp)
  800fa2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa9:	eb 0d                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0)
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	75 07                	jne    800fb8 <strtol+0xa0>
		base = 10;
  800fb1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2f                	cmp    $0x2f,%al
  800fbf:	7e 19                	jle    800fda <strtol+0xc2>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3c 39                	cmp    $0x39,%al
  800fc8:	7f 10                	jg     800fda <strtol+0xc2>
			dig = *s - '0';
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f be c0             	movsbl %al,%eax
  800fd2:	83 e8 30             	sub    $0x30,%eax
  800fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd8:	eb 42                	jmp    80101c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 60                	cmp    $0x60,%al
  800fe1:	7e 19                	jle    800ffc <strtol+0xe4>
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 7a                	cmp    $0x7a,%al
  800fea:	7f 10                	jg     800ffc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	0f be c0             	movsbl %al,%eax
  800ff4:	83 e8 57             	sub    $0x57,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ffa:	eb 20                	jmp    80101c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 40                	cmp    $0x40,%al
  801003:	7e 39                	jle    80103e <strtol+0x126>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	3c 5a                	cmp    $0x5a,%al
  80100c:	7f 30                	jg     80103e <strtol+0x126>
			dig = *s - 'A' + 10;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f be c0             	movsbl %al,%eax
  801016:	83 e8 37             	sub    $0x37,%eax
  801019:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801022:	7d 19                	jge    80103d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102e:	89 c2                	mov    %eax,%edx
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801038:	e9 7b ff ff ff       	jmp    800fb8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801042:	74 08                	je     80104c <strtol+0x134>
		*endptr = (char *) s;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80104c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801050:	74 07                	je     801059 <strtol+0x141>
  801052:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801055:	f7 d8                	neg    %eax
  801057:	eb 03                	jmp    80105c <strtol+0x144>
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <ltostr>:

void
ltostr(long value, char *str)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80106b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801076:	79 13                	jns    80108b <ltostr+0x2d>
	{
		neg = 1;
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801085:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801088:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801093:	99                   	cltd   
  801094:	f7 f9                	idiv   %ecx
  801096:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	8d 50 01             	lea    0x1(%eax),%edx
  80109f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ac:	83 c2 30             	add    $0x30,%edx
  8010af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b9:	f7 e9                	imul   %ecx
  8010bb:	c1 fa 02             	sar    $0x2,%edx
  8010be:	89 c8                	mov    %ecx,%eax
  8010c0:	c1 f8 1f             	sar    $0x1f,%eax
  8010c3:	29 c2                	sub    %eax,%edx
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d2:	f7 e9                	imul   %ecx
  8010d4:	c1 fa 02             	sar    $0x2,%edx
  8010d7:	89 c8                	mov    %ecx,%eax
  8010d9:	c1 f8 1f             	sar    $0x1f,%eax
  8010dc:	29 c2                	sub    %eax,%edx
  8010de:	89 d0                	mov    %edx,%eax
  8010e0:	c1 e0 02             	shl    $0x2,%eax
  8010e3:	01 d0                	add    %edx,%eax
  8010e5:	01 c0                	add    %eax,%eax
  8010e7:	29 c1                	sub    %eax,%ecx
  8010e9:	89 ca                	mov    %ecx,%edx
  8010eb:	85 d2                	test   %edx,%edx
  8010ed:	75 9c                	jne    80108b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	48                   	dec    %eax
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801101:	74 3d                	je     801140 <ltostr+0xe2>
		start = 1 ;
  801103:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80110a:	eb 34                	jmp    801140 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80110c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 c2                	add    %eax,%edx
  801121:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c8                	add    %ecx,%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	01 c2                	add    %eax,%edx
  801135:	8a 45 eb             	mov    -0x15(%ebp),%al
  801138:	88 02                	mov    %al,(%edx)
		start++ ;
  80113a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801146:	7c c4                	jl     80110c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801148:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801153:	90                   	nop
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80115c:	ff 75 08             	pushl  0x8(%ebp)
  80115f:	e8 54 fa ff ff       	call   800bb8 <strlen>
  801164:	83 c4 04             	add    $0x4,%esp
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80116a:	ff 75 0c             	pushl  0xc(%ebp)
  80116d:	e8 46 fa ff ff       	call   800bb8 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801186:	eb 17                	jmp    80119f <strcconcat+0x49>
		final[s] = str1[s] ;
  801188:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	01 c2                	add    %eax,%edx
  801190:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	01 c8                	add    %ecx,%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80119c:	ff 45 fc             	incl   -0x4(%ebp)
  80119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a5:	7c e1                	jl     801188 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b5:	eb 1f                	jmp    8011d6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ba:	8d 50 01             	lea    0x1(%eax),%edx
  8011bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	01 c2                	add    %eax,%edx
  8011c7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	01 c8                	add    %ecx,%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d3:	ff 45 f8             	incl   -0x8(%ebp)
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dc:	7c d9                	jl     8011b7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e9:	90                   	nop
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801204:	8b 45 10             	mov    0x10(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120f:	eb 0c                	jmp    80121d <strsplit+0x31>
			*string++ = 0;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	89 55 08             	mov    %edx,0x8(%ebp)
  80121a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	84 c0                	test   %al,%al
  801224:	74 18                	je     80123e <strsplit+0x52>
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	0f be c0             	movsbl %al,%eax
  80122e:	50                   	push   %eax
  80122f:	ff 75 0c             	pushl  0xc(%ebp)
  801232:	e8 13 fb ff ff       	call   800d4a <strchr>
  801237:	83 c4 08             	add    $0x8,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 d3                	jne    801211 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	74 5a                	je     8012a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	83 f8 0f             	cmp    $0xf,%eax
  80124f:	75 07                	jne    801258 <strsplit+0x6c>
		{
			return 0;
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	eb 66                	jmp    8012be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801258:	8b 45 14             	mov    0x14(%ebp),%eax
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8d 48 01             	lea    0x1(%eax),%ecx
  801260:	8b 55 14             	mov    0x14(%ebp),%edx
  801263:	89 0a                	mov    %ecx,(%edx)
  801265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	01 c2                	add    %eax,%edx
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801276:	eb 03                	jmp    80127b <strsplit+0x8f>
			string++;
  801278:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	84 c0                	test   %al,%al
  801282:	74 8b                	je     80120f <strsplit+0x23>
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	0f be c0             	movsbl %al,%eax
  80128c:	50                   	push   %eax
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	e8 b5 fa ff ff       	call   800d4a <strchr>
  801295:	83 c4 08             	add    $0x8,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	74 dc                	je     801278 <strsplit+0x8c>
			string++;
	}
  80129c:	e9 6e ff ff ff       	jmp    80120f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	8b 00                	mov    (%eax),%eax
  8012a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c6:	a1 04 50 80 00       	mov    0x805004,%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 1f                	je     8012ee <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cf:	e8 1d 00 00 00       	call   8012f1 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	68 70 3e 80 00       	push   $0x803e70
  8012dc:	e8 55 f2 ff ff       	call   800536 <cprintf>
  8012e1:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e4:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8012eb:	00 00 00 
	}
}
  8012ee:	90                   	nop
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8012f7:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8012fe:	00 00 00 
  801301:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801308:	00 00 00 
  80130b:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801312:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801315:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80131c:	00 00 00 
  80131f:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801326:	00 00 00 
  801329:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801330:	00 00 00 
	uint32 arr_size = 0;
  801333:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  80133a:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801349:	2d 00 10 00 00       	sub    $0x1000,%eax
  80134e:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801353:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80135a:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80135d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801364:	a1 20 51 80 00       	mov    0x805120,%eax
  801369:	c1 e0 04             	shl    $0x4,%eax
  80136c:	89 c2                	mov    %eax,%edx
  80136e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801371:	01 d0                	add    %edx,%eax
  801373:	48                   	dec    %eax
  801374:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80137a:	ba 00 00 00 00       	mov    $0x0,%edx
  80137f:	f7 75 ec             	divl   -0x14(%ebp)
  801382:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801385:	29 d0                	sub    %edx,%eax
  801387:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  80138a:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801391:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801394:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801399:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139e:	83 ec 04             	sub    $0x4,%esp
  8013a1:	6a 06                	push   $0x6
  8013a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a6:	50                   	push   %eax
  8013a7:	e8 b2 05 00 00       	call   80195e <sys_allocate_chunk>
  8013ac:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013af:	a1 20 51 80 00       	mov    0x805120,%eax
  8013b4:	83 ec 0c             	sub    $0xc,%esp
  8013b7:	50                   	push   %eax
  8013b8:	e8 27 0c 00 00       	call   801fe4 <initialize_MemBlocksList>
  8013bd:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8013c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8013c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013cb:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8013d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d5:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8013dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013e0:	75 14                	jne    8013f6 <initialize_dyn_block_system+0x105>
  8013e2:	83 ec 04             	sub    $0x4,%esp
  8013e5:	68 95 3e 80 00       	push   $0x803e95
  8013ea:	6a 33                	push   $0x33
  8013ec:	68 b3 3e 80 00       	push   $0x803eb3
  8013f1:	e8 8c ee ff ff       	call   800282 <_panic>
  8013f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f9:	8b 00                	mov    (%eax),%eax
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	74 10                	je     80140f <initialize_dyn_block_system+0x11e>
  8013ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801402:	8b 00                	mov    (%eax),%eax
  801404:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801407:	8b 52 04             	mov    0x4(%edx),%edx
  80140a:	89 50 04             	mov    %edx,0x4(%eax)
  80140d:	eb 0b                	jmp    80141a <initialize_dyn_block_system+0x129>
  80140f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801412:	8b 40 04             	mov    0x4(%eax),%eax
  801415:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80141a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141d:	8b 40 04             	mov    0x4(%eax),%eax
  801420:	85 c0                	test   %eax,%eax
  801422:	74 0f                	je     801433 <initialize_dyn_block_system+0x142>
  801424:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801427:	8b 40 04             	mov    0x4(%eax),%eax
  80142a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80142d:	8b 12                	mov    (%edx),%edx
  80142f:	89 10                	mov    %edx,(%eax)
  801431:	eb 0a                	jmp    80143d <initialize_dyn_block_system+0x14c>
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	8b 00                	mov    (%eax),%eax
  801438:	a3 48 51 80 00       	mov    %eax,0x805148
  80143d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801446:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801449:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801450:	a1 54 51 80 00       	mov    0x805154,%eax
  801455:	48                   	dec    %eax
  801456:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  80145b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80145f:	75 14                	jne    801475 <initialize_dyn_block_system+0x184>
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	68 c0 3e 80 00       	push   $0x803ec0
  801469:	6a 34                	push   $0x34
  80146b:	68 b3 3e 80 00       	push   $0x803eb3
  801470:	e8 0d ee ff ff       	call   800282 <_panic>
  801475:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80147b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147e:	89 10                	mov    %edx,(%eax)
  801480:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	85 c0                	test   %eax,%eax
  801487:	74 0d                	je     801496 <initialize_dyn_block_system+0x1a5>
  801489:	a1 38 51 80 00       	mov    0x805138,%eax
  80148e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801491:	89 50 04             	mov    %edx,0x4(%eax)
  801494:	eb 08                	jmp    80149e <initialize_dyn_block_system+0x1ad>
  801496:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801499:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80149e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8014a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014b0:	a1 44 51 80 00       	mov    0x805144,%eax
  8014b5:	40                   	inc    %eax
  8014b6:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8014bb:	90                   	nop
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014c4:	e8 f7 fd ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014cd:	75 07                	jne    8014d6 <malloc+0x18>
  8014cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d4:	eb 61                	jmp    801537 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8014d6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e3:	01 d0                	add    %edx,%eax
  8014e5:	48                   	dec    %eax
  8014e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f1:	f7 75 f0             	divl   -0x10(%ebp)
  8014f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f7:	29 d0                	sub    %edx,%eax
  8014f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014fc:	e8 2b 08 00 00       	call   801d2c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801501:	85 c0                	test   %eax,%eax
  801503:	74 11                	je     801516 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801505:	83 ec 0c             	sub    $0xc,%esp
  801508:	ff 75 e8             	pushl  -0x18(%ebp)
  80150b:	e8 96 0e 00 00       	call   8023a6 <alloc_block_FF>
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80151a:	74 16                	je     801532 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80151c:	83 ec 0c             	sub    $0xc,%esp
  80151f:	ff 75 f4             	pushl  -0xc(%ebp)
  801522:	e8 f2 0b 00 00       	call   802119 <insert_sorted_allocList>
  801527:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80152a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152d:	8b 40 08             	mov    0x8(%eax),%eax
  801530:	eb 05                	jmp    801537 <malloc+0x79>
	}

    return NULL;
  801532:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801537:	c9                   	leave  
  801538:	c3                   	ret    

00801539 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	83 ec 08             	sub    $0x8,%esp
  801545:	50                   	push   %eax
  801546:	68 40 50 80 00       	push   $0x805040
  80154b:	e8 71 0b 00 00       	call   8020c1 <find_block>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801556:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80155a:	0f 84 a6 00 00 00    	je     801606 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801563:	8b 50 0c             	mov    0xc(%eax),%edx
  801566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801569:	8b 40 08             	mov    0x8(%eax),%eax
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	52                   	push   %edx
  801570:	50                   	push   %eax
  801571:	e8 b0 03 00 00       	call   801926 <sys_free_user_mem>
  801576:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80157d:	75 14                	jne    801593 <free+0x5a>
  80157f:	83 ec 04             	sub    $0x4,%esp
  801582:	68 95 3e 80 00       	push   $0x803e95
  801587:	6a 74                	push   $0x74
  801589:	68 b3 3e 80 00       	push   $0x803eb3
  80158e:	e8 ef ec ff ff       	call   800282 <_panic>
  801593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801596:	8b 00                	mov    (%eax),%eax
  801598:	85 c0                	test   %eax,%eax
  80159a:	74 10                	je     8015ac <free+0x73>
  80159c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159f:	8b 00                	mov    (%eax),%eax
  8015a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a4:	8b 52 04             	mov    0x4(%edx),%edx
  8015a7:	89 50 04             	mov    %edx,0x4(%eax)
  8015aa:	eb 0b                	jmp    8015b7 <free+0x7e>
  8015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015af:	8b 40 04             	mov    0x4(%eax),%eax
  8015b2:	a3 44 50 80 00       	mov    %eax,0x805044
  8015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ba:	8b 40 04             	mov    0x4(%eax),%eax
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	74 0f                	je     8015d0 <free+0x97>
  8015c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c4:	8b 40 04             	mov    0x4(%eax),%eax
  8015c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ca:	8b 12                	mov    (%edx),%edx
  8015cc:	89 10                	mov    %edx,(%eax)
  8015ce:	eb 0a                	jmp    8015da <free+0xa1>
  8015d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d3:	8b 00                	mov    (%eax),%eax
  8015d5:	a3 40 50 80 00       	mov    %eax,0x805040
  8015da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015ed:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8015f2:	48                   	dec    %eax
  8015f3:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  8015f8:	83 ec 0c             	sub    $0xc,%esp
  8015fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fe:	e8 4e 17 00 00       	call   802d51 <insert_sorted_with_merge_freeList>
  801603:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	83 ec 08             	sub    $0x8,%esp
  801545:	50                   	push   %eax
  801546:	68 40 50 80 00       	push   $0x805040
  80154b:	e8 71 0b 00 00       	call   8020c1 <find_block>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  801556:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80155a:	0f 84 a6 00 00 00    	je     801606 <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  801560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801563:	8b 50 0c             	mov    0xc(%eax),%edx
  801566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801569:	8b 40 08             	mov    0x8(%eax),%eax
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	52                   	push   %edx
  801570:	50                   	push   %eax
  801571:	e8 b0 03 00 00       	call   801926 <sys_free_user_mem>
  801576:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  801579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80157d:	75 14                	jne    801593 <free+0x5a>
  80157f:	83 ec 04             	sub    $0x4,%esp
  801582:	68 95 3e 80 00       	push   $0x803e95
  801587:	6a 7a                	push   $0x7a
  801589:	68 b3 3e 80 00       	push   $0x803eb3
  80158e:	e8 ef ec ff ff       	call   800282 <_panic>
  801593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801596:	8b 00                	mov    (%eax),%eax
  801598:	85 c0                	test   %eax,%eax
  80159a:	74 10                	je     8015ac <free+0x73>
  80159c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159f:	8b 00                	mov    (%eax),%eax
  8015a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a4:	8b 52 04             	mov    0x4(%edx),%edx
  8015a7:	89 50 04             	mov    %edx,0x4(%eax)
  8015aa:	eb 0b                	jmp    8015b7 <free+0x7e>
  8015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015af:	8b 40 04             	mov    0x4(%eax),%eax
  8015b2:	a3 44 50 80 00       	mov    %eax,0x805044
  8015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ba:	8b 40 04             	mov    0x4(%eax),%eax
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	74 0f                	je     8015d0 <free+0x97>
  8015c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c4:	8b 40 04             	mov    0x4(%eax),%eax
  8015c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ca:	8b 12                	mov    (%edx),%edx
  8015cc:	89 10                	mov    %edx,(%eax)
  8015ce:	eb 0a                	jmp    8015da <free+0xa1>
  8015d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d3:	8b 00                	mov    (%eax),%eax
  8015d5:	a3 40 50 80 00       	mov    %eax,0x805040
  8015da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015ed:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8015f2:	48                   	dec    %eax
  8015f3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  8015f8:	83 ec 0c             	sub    $0xc,%esp
  8015fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fe:	e8 4e 17 00 00       	call   802d51 <insert_sorted_with_merge_freeList>
  801603:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  801606:	90                   	nop
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 38             	sub    $0x38,%esp
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
  801612:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801615:	e8 a6 fc ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  80161a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161e:	75 0a                	jne    80162a <smalloc+0x21>
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
  801625:	e9 8b 00 00 00       	jmp    8016b5 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80162a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801631:	8b 55 0c             	mov    0xc(%ebp),%edx
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	01 d0                	add    %edx,%eax
  801639:	48                   	dec    %eax
  80163a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80163d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801640:	ba 00 00 00 00       	mov    $0x0,%edx
  801645:	f7 75 f0             	divl   -0x10(%ebp)
  801648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164b:	29 d0                	sub    %edx,%eax
  80164d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801650:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801657:	e8 d0 06 00 00       	call   801d2c <sys_isUHeapPlacementStrategyFIRSTFIT>
  80165c:	85 c0                	test   %eax,%eax
  80165e:	74 11                	je     801671 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801660:	83 ec 0c             	sub    $0xc,%esp
  801663:	ff 75 e8             	pushl  -0x18(%ebp)
  801666:	e8 3b 0d 00 00       	call   8023a6 <alloc_block_FF>
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801675:	74 39                	je     8016b0 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167a:	8b 40 08             	mov    0x8(%eax),%eax
  80167d:	89 c2                	mov    %eax,%edx
  80167f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801683:	52                   	push   %edx
  801684:	50                   	push   %eax
  801685:	ff 75 0c             	pushl  0xc(%ebp)
  801688:	ff 75 08             	pushl  0x8(%ebp)
  80168b:	e8 21 04 00 00       	call   801ab1 <sys_createSharedObject>
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801696:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80169a:	74 14                	je     8016b0 <smalloc+0xa7>
  80169c:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016a0:	74 0e                	je     8016b0 <smalloc+0xa7>
  8016a2:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016a6:	74 08                	je     8016b0 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8016a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ab:	8b 40 08             	mov    0x8(%eax),%eax
  8016ae:	eb 05                	jmp    8016b5 <smalloc+0xac>
	}
	return NULL;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016bd:	e8 fe fb ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016c2:	83 ec 08             	sub    $0x8,%esp
  8016c5:	ff 75 0c             	pushl  0xc(%ebp)
  8016c8:	ff 75 08             	pushl  0x8(%ebp)
  8016cb:	e8 0b 04 00 00       	call   801adb <sys_getSizeOfSharedObject>
  8016d0:	83 c4 10             	add    $0x10,%esp
  8016d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8016d6:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8016da:	74 76                	je     801752 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016dc:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e9:	01 d0                	add    %edx,%eax
  8016eb:	48                   	dec    %eax
  8016ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f7:	f7 75 ec             	divl   -0x14(%ebp)
  8016fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016fd:	29 d0                	sub    %edx,%eax
  8016ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801702:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801709:	e8 1e 06 00 00       	call   801d2c <sys_isUHeapPlacementStrategyFIRSTFIT>
  80170e:	85 c0                	test   %eax,%eax
  801710:	74 11                	je     801723 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801712:	83 ec 0c             	sub    $0xc,%esp
  801715:	ff 75 e4             	pushl  -0x1c(%ebp)
  801718:	e8 89 0c 00 00       	call   8023a6 <alloc_block_FF>
  80171d:	83 c4 10             	add    $0x10,%esp
  801720:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801727:	74 29                	je     801752 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172c:	8b 40 08             	mov    0x8(%eax),%eax
  80172f:	83 ec 04             	sub    $0x4,%esp
  801732:	50                   	push   %eax
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	ff 75 08             	pushl  0x8(%ebp)
  801739:	e8 ba 03 00 00       	call   801af8 <sys_getSharedObject>
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801744:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801748:	74 08                	je     801752 <sget+0x9b>
				return (void *)mem_block->sva;
  80174a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174d:	8b 40 08             	mov    0x8(%eax),%eax
  801750:	eb 05                	jmp    801757 <sget+0xa0>
		}
	}
	return NULL;
  801752:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80175f:	e8 5c fb ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	68 e4 3e 80 00       	push   $0x803ee4
<<<<<<< HEAD
  80176c:	68 fc 00 00 00       	push   $0xfc
=======
  80176c:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801771:	68 b3 3e 80 00       	push   $0x803eb3
  801776:	e8 07 eb ff ff       	call   800282 <_panic>

0080177b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801781:	83 ec 04             	sub    $0x4,%esp
  801784:	68 0c 3f 80 00       	push   $0x803f0c
<<<<<<< HEAD
  801789:	68 10 01 00 00       	push   $0x110
=======
  801789:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  80178e:	68 b3 3e 80 00       	push   $0x803eb3
  801793:	e8 ea ea ff ff       	call   800282 <_panic>

00801798 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80179e:	83 ec 04             	sub    $0x4,%esp
  8017a1:	68 30 3f 80 00       	push   $0x803f30
<<<<<<< HEAD
  8017a6:	68 1b 01 00 00       	push   $0x11b
=======
  8017a6:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8017ab:	68 b3 3e 80 00       	push   $0x803eb3
  8017b0:	e8 cd ea ff ff       	call   800282 <_panic>

008017b5 <shrink>:

}
void shrink(uint32 newSize)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017bb:	83 ec 04             	sub    $0x4,%esp
  8017be:	68 30 3f 80 00       	push   $0x803f30
<<<<<<< HEAD
  8017c3:	68 20 01 00 00       	push   $0x120
=======
  8017c3:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8017c8:	68 b3 3e 80 00       	push   $0x803eb3
  8017cd:	e8 b0 ea ff ff       	call   800282 <_panic>

008017d2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d8:	83 ec 04             	sub    $0x4,%esp
  8017db:	68 30 3f 80 00       	push   $0x803f30
<<<<<<< HEAD
  8017e0:	68 25 01 00 00       	push   $0x125
=======
  8017e0:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8017e5:	68 b3 3e 80 00       	push   $0x803eb3
  8017ea:	e8 93 ea ff ff       	call   800282 <_panic>

008017ef <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	57                   	push   %edi
  8017f3:	56                   	push   %esi
  8017f4:	53                   	push   %ebx
  8017f5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801801:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801804:	8b 7d 18             	mov    0x18(%ebp),%edi
  801807:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180a:	cd 30                	int    $0x30
  80180c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80180f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	5b                   	pop    %ebx
  801816:	5e                   	pop    %esi
  801817:	5f                   	pop    %edi
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    

0080181a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	8b 45 10             	mov    0x10(%ebp),%eax
  801823:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801826:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	52                   	push   %edx
  801832:	ff 75 0c             	pushl  0xc(%ebp)
  801835:	50                   	push   %eax
  801836:	6a 00                	push   $0x0
  801838:	e8 b2 ff ff ff       	call   8017ef <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	90                   	nop
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_cgetc>:

int
sys_cgetc(void)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 01                	push   $0x1
  801852:	e8 98 ff ff ff       	call   8017ef <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80185f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	52                   	push   %edx
  80186c:	50                   	push   %eax
  80186d:	6a 05                	push   $0x5
  80186f:	e8 7b ff ff ff       	call   8017ef <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	56                   	push   %esi
  80187d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80187e:	8b 75 18             	mov    0x18(%ebp),%esi
  801881:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801884:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	56                   	push   %esi
  80188e:	53                   	push   %ebx
  80188f:	51                   	push   %ecx
  801890:	52                   	push   %edx
  801891:	50                   	push   %eax
  801892:	6a 06                	push   $0x6
  801894:	e8 56 ff ff ff       	call   8017ef <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
}
  80189c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189f:	5b                   	pop    %ebx
  8018a0:	5e                   	pop    %esi
  8018a1:	5d                   	pop    %ebp
  8018a2:	c3                   	ret    

008018a3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	52                   	push   %edx
  8018b3:	50                   	push   %eax
  8018b4:	6a 07                	push   $0x7
  8018b6:	e8 34 ff ff ff       	call   8017ef <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	ff 75 0c             	pushl  0xc(%ebp)
  8018cc:	ff 75 08             	pushl  0x8(%ebp)
  8018cf:	6a 08                	push   $0x8
  8018d1:	e8 19 ff ff ff       	call   8017ef <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 09                	push   $0x9
  8018ea:	e8 00 ff ff ff       	call   8017ef <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 0a                	push   $0xa
  801903:	e8 e7 fe ff ff       	call   8017ef <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 0b                	push   $0xb
  80191c:	e8 ce fe ff ff       	call   8017ef <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	ff 75 0c             	pushl  0xc(%ebp)
  801932:	ff 75 08             	pushl  0x8(%ebp)
  801935:	6a 0f                	push   $0xf
  801937:	e8 b3 fe ff ff       	call   8017ef <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
	return;
  80193f:	90                   	nop
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	ff 75 0c             	pushl  0xc(%ebp)
  80194e:	ff 75 08             	pushl  0x8(%ebp)
  801951:	6a 10                	push   $0x10
  801953:	e8 97 fe ff ff       	call   8017ef <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
	return ;
  80195b:	90                   	nop
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	ff 75 10             	pushl  0x10(%ebp)
  801968:	ff 75 0c             	pushl  0xc(%ebp)
  80196b:	ff 75 08             	pushl  0x8(%ebp)
  80196e:	6a 11                	push   $0x11
  801970:	e8 7a fe ff ff       	call   8017ef <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
	return ;
  801978:	90                   	nop
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 0c                	push   $0xc
  80198a:	e8 60 fe ff ff       	call   8017ef <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	6a 0d                	push   $0xd
  8019a4:	e8 46 fe ff ff       	call   8017ef <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 0e                	push   $0xe
  8019bd:	e8 2d fe ff ff       	call   8017ef <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	90                   	nop
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 13                	push   $0x13
  8019d7:	e8 13 fe ff ff       	call   8017ef <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	90                   	nop
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 14                	push   $0x14
  8019f1:	e8 f9 fd ff ff       	call   8017ef <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	90                   	nop
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_cputc>:


void
sys_cputc(const char c)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a08:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	50                   	push   %eax
  801a15:	6a 15                	push   $0x15
  801a17:	e8 d3 fd ff ff       	call   8017ef <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	90                   	nop
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 16                	push   $0x16
  801a31:	e8 b9 fd ff ff       	call   8017ef <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	90                   	nop
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	ff 75 0c             	pushl  0xc(%ebp)
  801a4b:	50                   	push   %eax
  801a4c:	6a 17                	push   $0x17
  801a4e:	e8 9c fd ff ff       	call   8017ef <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	52                   	push   %edx
  801a68:	50                   	push   %eax
  801a69:	6a 1a                	push   $0x1a
  801a6b:	e8 7f fd ff ff       	call   8017ef <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	52                   	push   %edx
  801a85:	50                   	push   %eax
  801a86:	6a 18                	push   $0x18
  801a88:	e8 62 fd ff ff       	call   8017ef <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	90                   	nop
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	52                   	push   %edx
  801aa3:	50                   	push   %eax
  801aa4:	6a 19                	push   $0x19
  801aa6:	e8 44 fd ff ff       	call   8017ef <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	90                   	nop
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 04             	sub    $0x4,%esp
  801ab7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aba:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801abd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac7:	6a 00                	push   $0x0
  801ac9:	51                   	push   %ecx
  801aca:	52                   	push   %edx
  801acb:	ff 75 0c             	pushl  0xc(%ebp)
  801ace:	50                   	push   %eax
  801acf:	6a 1b                	push   $0x1b
  801ad1:	e8 19 fd ff ff       	call   8017ef <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	52                   	push   %edx
  801aeb:	50                   	push   %eax
  801aec:	6a 1c                	push   $0x1c
  801aee:	e8 fc fc ff ff       	call   8017ef <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801afb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	51                   	push   %ecx
  801b09:	52                   	push   %edx
  801b0a:	50                   	push   %eax
  801b0b:	6a 1d                	push   $0x1d
  801b0d:	e8 dd fc ff ff       	call   8017ef <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	52                   	push   %edx
  801b27:	50                   	push   %eax
  801b28:	6a 1e                	push   $0x1e
  801b2a:	e8 c0 fc ff ff       	call   8017ef <syscall>
  801b2f:	83 c4 18             	add    $0x18,%esp
}
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 1f                	push   $0x1f
  801b43:	e8 a7 fc ff ff       	call   8017ef <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	6a 00                	push   $0x0
  801b55:	ff 75 14             	pushl  0x14(%ebp)
  801b58:	ff 75 10             	pushl  0x10(%ebp)
  801b5b:	ff 75 0c             	pushl  0xc(%ebp)
  801b5e:	50                   	push   %eax
  801b5f:	6a 20                	push   $0x20
  801b61:	e8 89 fc ff ff       	call   8017ef <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	50                   	push   %eax
  801b7a:	6a 21                	push   $0x21
  801b7c:	e8 6e fc ff ff       	call   8017ef <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	90                   	nop
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	50                   	push   %eax
  801b96:	6a 22                	push   $0x22
  801b98:	e8 52 fc ff ff       	call   8017ef <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 02                	push   $0x2
  801bb1:	e8 39 fc ff ff       	call   8017ef <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 03                	push   $0x3
  801bca:	e8 20 fc ff ff       	call   8017ef <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 04                	push   $0x4
  801be3:	e8 07 fc ff ff       	call   8017ef <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_exit_env>:


void sys_exit_env(void)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 23                	push   $0x23
  801bfc:	e8 ee fb ff ff       	call   8017ef <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	90                   	nop
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
  801c0a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c0d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c10:	8d 50 04             	lea    0x4(%eax),%edx
  801c13:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	52                   	push   %edx
  801c1d:	50                   	push   %eax
  801c1e:	6a 24                	push   $0x24
  801c20:	e8 ca fb ff ff       	call   8017ef <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
	return result;
  801c28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c31:	89 01                	mov    %eax,(%ecx)
  801c33:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	c9                   	leave  
  801c3a:	c2 04 00             	ret    $0x4

00801c3d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	ff 75 10             	pushl  0x10(%ebp)
  801c47:	ff 75 0c             	pushl  0xc(%ebp)
  801c4a:	ff 75 08             	pushl  0x8(%ebp)
  801c4d:	6a 12                	push   $0x12
  801c4f:	e8 9b fb ff ff       	call   8017ef <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
	return ;
  801c57:	90                   	nop
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_rcr2>:
uint32 sys_rcr2()
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 25                	push   $0x25
  801c69:	e8 81 fb ff ff       	call   8017ef <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 04             	sub    $0x4,%esp
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c7f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	50                   	push   %eax
  801c8c:	6a 26                	push   $0x26
  801c8e:	e8 5c fb ff ff       	call   8017ef <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
	return ;
  801c96:	90                   	nop
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <rsttst>:
void rsttst()
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 28                	push   $0x28
  801ca8:	e8 42 fb ff ff       	call   8017ef <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb0:	90                   	nop
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 04             	sub    $0x4,%esp
  801cb9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cbf:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc6:	52                   	push   %edx
  801cc7:	50                   	push   %eax
  801cc8:	ff 75 10             	pushl  0x10(%ebp)
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	ff 75 08             	pushl  0x8(%ebp)
  801cd1:	6a 27                	push   $0x27
  801cd3:	e8 17 fb ff ff       	call   8017ef <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdb:	90                   	nop
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <chktst>:
void chktst(uint32 n)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	ff 75 08             	pushl  0x8(%ebp)
  801cec:	6a 29                	push   $0x29
  801cee:	e8 fc fa ff ff       	call   8017ef <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf6:	90                   	nop
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <inctst>:

void inctst()
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 2a                	push   $0x2a
  801d08:	e8 e2 fa ff ff       	call   8017ef <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d10:	90                   	nop
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <gettst>:
uint32 gettst()
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 2b                	push   $0x2b
  801d22:	e8 c8 fa ff ff       	call   8017ef <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 2c                	push   $0x2c
  801d3e:	e8 ac fa ff ff       	call   8017ef <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
  801d46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d49:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d4d:	75 07                	jne    801d56 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d54:	eb 05                	jmp    801d5b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 2c                	push   $0x2c
  801d6f:	e8 7b fa ff ff       	call   8017ef <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
  801d77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d7a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d7e:	75 07                	jne    801d87 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d80:	b8 01 00 00 00       	mov    $0x1,%eax
  801d85:	eb 05                	jmp    801d8c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 2c                	push   $0x2c
  801da0:	e8 4a fa ff ff       	call   8017ef <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
  801da8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dab:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801daf:	75 07                	jne    801db8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801db1:	b8 01 00 00 00       	mov    $0x1,%eax
  801db6:	eb 05                	jmp    801dbd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801db8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801dd1:	e8 19 fa ff ff       	call   8017ef <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
  801dd9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ddc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801de0:	75 07                	jne    801de9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de2:	b8 01 00 00 00       	mov    $0x1,%eax
  801de7:	eb 05                	jmp    801dee <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	ff 75 08             	pushl  0x8(%ebp)
  801dfe:	6a 2d                	push   $0x2d
  801e00:	e8 ea f9 ff ff       	call   8017ef <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
	return ;
  801e08:	90                   	nop
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e0f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e12:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	6a 00                	push   $0x0
  801e1d:	53                   	push   %ebx
  801e1e:	51                   	push   %ecx
  801e1f:	52                   	push   %edx
  801e20:	50                   	push   %eax
  801e21:	6a 2e                	push   $0x2e
  801e23:	e8 c7 f9 ff ff       	call   8017ef <syscall>
  801e28:	83 c4 18             	add    $0x18,%esp
}
  801e2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	52                   	push   %edx
  801e40:	50                   	push   %eax
  801e41:	6a 2f                	push   $0x2f
  801e43:	e8 a7 f9 ff ff       	call   8017ef <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	68 40 3f 80 00       	push   $0x803f40
  801e5b:	e8 d6 e6 ff ff       	call   800536 <cprintf>
  801e60:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e6a:	83 ec 0c             	sub    $0xc,%esp
  801e6d:	68 6c 3f 80 00       	push   $0x803f6c
  801e72:	e8 bf e6 ff ff       	call   800536 <cprintf>
  801e77:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e7a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e7e:	a1 38 51 80 00       	mov    0x805138,%eax
  801e83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e86:	eb 56                	jmp    801ede <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e8c:	74 1c                	je     801eaa <print_mem_block_lists+0x5d>
  801e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e91:	8b 50 08             	mov    0x8(%eax),%edx
  801e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e97:	8b 48 08             	mov    0x8(%eax),%ecx
  801e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea0:	01 c8                	add    %ecx,%eax
  801ea2:	39 c2                	cmp    %eax,%edx
  801ea4:	73 04                	jae    801eaa <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ea6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	8b 50 08             	mov    0x8(%eax),%edx
  801eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb3:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb6:	01 c2                	add    %eax,%edx
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	8b 40 08             	mov    0x8(%eax),%eax
  801ebe:	83 ec 04             	sub    $0x4,%esp
  801ec1:	52                   	push   %edx
  801ec2:	50                   	push   %eax
  801ec3:	68 81 3f 80 00       	push   $0x803f81
  801ec8:	e8 69 e6 ff ff       	call   800536 <cprintf>
  801ecd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ed6:	a1 40 51 80 00       	mov    0x805140,%eax
  801edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ede:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee2:	74 07                	je     801eeb <print_mem_block_lists+0x9e>
  801ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee7:	8b 00                	mov    (%eax),%eax
  801ee9:	eb 05                	jmp    801ef0 <print_mem_block_lists+0xa3>
  801eeb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef0:	a3 40 51 80 00       	mov    %eax,0x805140
  801ef5:	a1 40 51 80 00       	mov    0x805140,%eax
  801efa:	85 c0                	test   %eax,%eax
  801efc:	75 8a                	jne    801e88 <print_mem_block_lists+0x3b>
  801efe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f02:	75 84                	jne    801e88 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f04:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f08:	75 10                	jne    801f1a <print_mem_block_lists+0xcd>
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	68 90 3f 80 00       	push   $0x803f90
  801f12:	e8 1f e6 ff ff       	call   800536 <cprintf>
  801f17:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	68 b4 3f 80 00       	push   $0x803fb4
  801f29:	e8 08 e6 ff ff       	call   800536 <cprintf>
  801f2e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f31:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f35:	a1 40 50 80 00       	mov    0x805040,%eax
  801f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3d:	eb 56                	jmp    801f95 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f43:	74 1c                	je     801f61 <print_mem_block_lists+0x114>
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	8b 50 08             	mov    0x8(%eax),%edx
  801f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4e:	8b 48 08             	mov    0x8(%eax),%ecx
  801f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f54:	8b 40 0c             	mov    0xc(%eax),%eax
  801f57:	01 c8                	add    %ecx,%eax
  801f59:	39 c2                	cmp    %eax,%edx
  801f5b:	73 04                	jae    801f61 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f5d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	8b 50 08             	mov    0x8(%eax),%edx
  801f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6d:	01 c2                	add    %eax,%edx
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	8b 40 08             	mov    0x8(%eax),%eax
  801f75:	83 ec 04             	sub    $0x4,%esp
  801f78:	52                   	push   %edx
  801f79:	50                   	push   %eax
  801f7a:	68 81 3f 80 00       	push   $0x803f81
  801f7f:	e8 b2 e5 ff ff       	call   800536 <cprintf>
  801f84:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f8d:	a1 48 50 80 00       	mov    0x805048,%eax
  801f92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f99:	74 07                	je     801fa2 <print_mem_block_lists+0x155>
  801f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9e:	8b 00                	mov    (%eax),%eax
  801fa0:	eb 05                	jmp    801fa7 <print_mem_block_lists+0x15a>
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa7:	a3 48 50 80 00       	mov    %eax,0x805048
  801fac:	a1 48 50 80 00       	mov    0x805048,%eax
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	75 8a                	jne    801f3f <print_mem_block_lists+0xf2>
  801fb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb9:	75 84                	jne    801f3f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fbb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fbf:	75 10                	jne    801fd1 <print_mem_block_lists+0x184>
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	68 cc 3f 80 00       	push   $0x803fcc
  801fc9:	e8 68 e5 ff ff       	call   800536 <cprintf>
  801fce:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fd1:	83 ec 0c             	sub    $0xc,%esp
  801fd4:	68 40 3f 80 00       	push   $0x803f40
  801fd9:	e8 58 e5 ff ff       	call   800536 <cprintf>
  801fde:	83 c4 10             	add    $0x10,%esp

}
  801fe1:	90                   	nop
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fea:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ff1:	00 00 00 
  801ff4:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ffb:	00 00 00 
  801ffe:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802005:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802008:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80200f:	e9 9e 00 00 00       	jmp    8020b2 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802014:	a1 50 50 80 00       	mov    0x805050,%eax
  802019:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201c:	c1 e2 04             	shl    $0x4,%edx
  80201f:	01 d0                	add    %edx,%eax
  802021:	85 c0                	test   %eax,%eax
  802023:	75 14                	jne    802039 <initialize_MemBlocksList+0x55>
  802025:	83 ec 04             	sub    $0x4,%esp
  802028:	68 f4 3f 80 00       	push   $0x803ff4
  80202d:	6a 46                	push   $0x46
  80202f:	68 17 40 80 00       	push   $0x804017
  802034:	e8 49 e2 ff ff       	call   800282 <_panic>
  802039:	a1 50 50 80 00       	mov    0x805050,%eax
  80203e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802041:	c1 e2 04             	shl    $0x4,%edx
  802044:	01 d0                	add    %edx,%eax
  802046:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80204c:	89 10                	mov    %edx,(%eax)
  80204e:	8b 00                	mov    (%eax),%eax
  802050:	85 c0                	test   %eax,%eax
  802052:	74 18                	je     80206c <initialize_MemBlocksList+0x88>
  802054:	a1 48 51 80 00       	mov    0x805148,%eax
  802059:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80205f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802062:	c1 e1 04             	shl    $0x4,%ecx
  802065:	01 ca                	add    %ecx,%edx
  802067:	89 50 04             	mov    %edx,0x4(%eax)
  80206a:	eb 12                	jmp    80207e <initialize_MemBlocksList+0x9a>
  80206c:	a1 50 50 80 00       	mov    0x805050,%eax
  802071:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802074:	c1 e2 04             	shl    $0x4,%edx
  802077:	01 d0                	add    %edx,%eax
  802079:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80207e:	a1 50 50 80 00       	mov    0x805050,%eax
  802083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802086:	c1 e2 04             	shl    $0x4,%edx
  802089:	01 d0                	add    %edx,%eax
  80208b:	a3 48 51 80 00       	mov    %eax,0x805148
  802090:	a1 50 50 80 00       	mov    0x805050,%eax
  802095:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802098:	c1 e2 04             	shl    $0x4,%edx
  80209b:	01 d0                	add    %edx,%eax
  80209d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8020a9:	40                   	inc    %eax
  8020aa:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020af:	ff 45 f4             	incl   -0xc(%ebp)
  8020b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020b8:	0f 82 56 ff ff ff    	jb     802014 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020be:	90                   	nop
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	8b 00                	mov    (%eax),%eax
  8020cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020cf:	eb 19                	jmp    8020ea <find_block+0x29>
	{
		if(va==point->sva)
  8020d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d4:	8b 40 08             	mov    0x8(%eax),%eax
  8020d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020da:	75 05                	jne    8020e1 <find_block+0x20>
		   return point;
  8020dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020df:	eb 36                	jmp    802117 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8b 40 08             	mov    0x8(%eax),%eax
  8020e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020ee:	74 07                	je     8020f7 <find_block+0x36>
  8020f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f3:	8b 00                	mov    (%eax),%eax
  8020f5:	eb 05                	jmp    8020fc <find_block+0x3b>
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ff:	89 42 08             	mov    %eax,0x8(%edx)
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	8b 40 08             	mov    0x8(%eax),%eax
  802108:	85 c0                	test   %eax,%eax
  80210a:	75 c5                	jne    8020d1 <find_block+0x10>
  80210c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802110:	75 bf                	jne    8020d1 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802112:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80211f:	a1 40 50 80 00       	mov    0x805040,%eax
  802124:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802127:	a1 44 50 80 00       	mov    0x805044,%eax
  80212c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80212f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802132:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802135:	74 24                	je     80215b <insert_sorted_allocList+0x42>
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	8b 50 08             	mov    0x8(%eax),%edx
  80213d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802140:	8b 40 08             	mov    0x8(%eax),%eax
  802143:	39 c2                	cmp    %eax,%edx
  802145:	76 14                	jbe    80215b <insert_sorted_allocList+0x42>
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	8b 50 08             	mov    0x8(%eax),%edx
  80214d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802150:	8b 40 08             	mov    0x8(%eax),%eax
  802153:	39 c2                	cmp    %eax,%edx
  802155:	0f 82 60 01 00 00    	jb     8022bb <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80215b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80215f:	75 65                	jne    8021c6 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802161:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802165:	75 14                	jne    80217b <insert_sorted_allocList+0x62>
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	68 f4 3f 80 00       	push   $0x803ff4
  80216f:	6a 6b                	push   $0x6b
  802171:	68 17 40 80 00       	push   $0x804017
  802176:	e8 07 e1 ff ff       	call   800282 <_panic>
  80217b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	89 10                	mov    %edx,(%eax)
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	8b 00                	mov    (%eax),%eax
  80218b:	85 c0                	test   %eax,%eax
  80218d:	74 0d                	je     80219c <insert_sorted_allocList+0x83>
  80218f:	a1 40 50 80 00       	mov    0x805040,%eax
  802194:	8b 55 08             	mov    0x8(%ebp),%edx
  802197:	89 50 04             	mov    %edx,0x4(%eax)
  80219a:	eb 08                	jmp    8021a4 <insert_sorted_allocList+0x8b>
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	a3 44 50 80 00       	mov    %eax,0x805044
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	a3 40 50 80 00       	mov    %eax,0x805040
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021bb:	40                   	inc    %eax
  8021bc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021c1:	e9 dc 01 00 00       	jmp    8023a2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	8b 50 08             	mov    0x8(%eax),%edx
  8021cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cf:	8b 40 08             	mov    0x8(%eax),%eax
  8021d2:	39 c2                	cmp    %eax,%edx
  8021d4:	77 6c                	ja     802242 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021da:	74 06                	je     8021e2 <insert_sorted_allocList+0xc9>
  8021dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e0:	75 14                	jne    8021f6 <insert_sorted_allocList+0xdd>
  8021e2:	83 ec 04             	sub    $0x4,%esp
  8021e5:	68 30 40 80 00       	push   $0x804030
  8021ea:	6a 6f                	push   $0x6f
  8021ec:	68 17 40 80 00       	push   $0x804017
  8021f1:	e8 8c e0 ff ff       	call   800282 <_panic>
  8021f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f9:	8b 50 04             	mov    0x4(%eax),%edx
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	89 50 04             	mov    %edx,0x4(%eax)
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802208:	89 10                	mov    %edx,(%eax)
  80220a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220d:	8b 40 04             	mov    0x4(%eax),%eax
  802210:	85 c0                	test   %eax,%eax
  802212:	74 0d                	je     802221 <insert_sorted_allocList+0x108>
  802214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802217:	8b 40 04             	mov    0x4(%eax),%eax
  80221a:	8b 55 08             	mov    0x8(%ebp),%edx
  80221d:	89 10                	mov    %edx,(%eax)
  80221f:	eb 08                	jmp    802229 <insert_sorted_allocList+0x110>
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	a3 40 50 80 00       	mov    %eax,0x805040
  802229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222c:	8b 55 08             	mov    0x8(%ebp),%edx
  80222f:	89 50 04             	mov    %edx,0x4(%eax)
  802232:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802237:	40                   	inc    %eax
  802238:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80223d:	e9 60 01 00 00       	jmp    8023a2 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	8b 50 08             	mov    0x8(%eax),%edx
  802248:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224b:	8b 40 08             	mov    0x8(%eax),%eax
  80224e:	39 c2                	cmp    %eax,%edx
  802250:	0f 82 4c 01 00 00    	jb     8023a2 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802256:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225a:	75 14                	jne    802270 <insert_sorted_allocList+0x157>
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	68 68 40 80 00       	push   $0x804068
  802264:	6a 73                	push   $0x73
  802266:	68 17 40 80 00       	push   $0x804017
  80226b:	e8 12 e0 ff ff       	call   800282 <_panic>
  802270:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	89 50 04             	mov    %edx,0x4(%eax)
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	8b 40 04             	mov    0x4(%eax),%eax
  802282:	85 c0                	test   %eax,%eax
  802284:	74 0c                	je     802292 <insert_sorted_allocList+0x179>
  802286:	a1 44 50 80 00       	mov    0x805044,%eax
  80228b:	8b 55 08             	mov    0x8(%ebp),%edx
  80228e:	89 10                	mov    %edx,(%eax)
  802290:	eb 08                	jmp    80229a <insert_sorted_allocList+0x181>
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	a3 40 50 80 00       	mov    %eax,0x805040
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	a3 44 50 80 00       	mov    %eax,0x805044
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ab:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022b0:	40                   	inc    %eax
  8022b1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022b6:	e9 e7 00 00 00       	jmp    8023a2 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022c8:	a1 40 50 80 00       	mov    0x805040,%eax
  8022cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d0:	e9 9d 00 00 00       	jmp    802372 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	8b 50 08             	mov    0x8(%eax),%edx
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	8b 40 08             	mov    0x8(%eax),%eax
  8022e9:	39 c2                	cmp    %eax,%edx
  8022eb:	76 7d                	jbe    80236a <insert_sorted_allocList+0x251>
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	8b 50 08             	mov    0x8(%eax),%edx
  8022f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022f6:	8b 40 08             	mov    0x8(%eax),%eax
  8022f9:	39 c2                	cmp    %eax,%edx
  8022fb:	73 6d                	jae    80236a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802301:	74 06                	je     802309 <insert_sorted_allocList+0x1f0>
  802303:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802307:	75 14                	jne    80231d <insert_sorted_allocList+0x204>
  802309:	83 ec 04             	sub    $0x4,%esp
  80230c:	68 8c 40 80 00       	push   $0x80408c
  802311:	6a 7f                	push   $0x7f
  802313:	68 17 40 80 00       	push   $0x804017
  802318:	e8 65 df ff ff       	call   800282 <_panic>
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	8b 10                	mov    (%eax),%edx
  802322:	8b 45 08             	mov    0x8(%ebp),%eax
  802325:	89 10                	mov    %edx,(%eax)
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	8b 00                	mov    (%eax),%eax
  80232c:	85 c0                	test   %eax,%eax
  80232e:	74 0b                	je     80233b <insert_sorted_allocList+0x222>
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	8b 00                	mov    (%eax),%eax
  802335:	8b 55 08             	mov    0x8(%ebp),%edx
  802338:	89 50 04             	mov    %edx,0x4(%eax)
  80233b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233e:	8b 55 08             	mov    0x8(%ebp),%edx
  802341:	89 10                	mov    %edx,(%eax)
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802349:	89 50 04             	mov    %edx,0x4(%eax)
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	85 c0                	test   %eax,%eax
  802353:	75 08                	jne    80235d <insert_sorted_allocList+0x244>
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	a3 44 50 80 00       	mov    %eax,0x805044
  80235d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802362:	40                   	inc    %eax
  802363:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802368:	eb 39                	jmp    8023a3 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80236a:	a1 48 50 80 00       	mov    0x805048,%eax
  80236f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802376:	74 07                	je     80237f <insert_sorted_allocList+0x266>
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	8b 00                	mov    (%eax),%eax
  80237d:	eb 05                	jmp    802384 <insert_sorted_allocList+0x26b>
  80237f:	b8 00 00 00 00       	mov    $0x0,%eax
  802384:	a3 48 50 80 00       	mov    %eax,0x805048
  802389:	a1 48 50 80 00       	mov    0x805048,%eax
  80238e:	85 c0                	test   %eax,%eax
  802390:	0f 85 3f ff ff ff    	jne    8022d5 <insert_sorted_allocList+0x1bc>
  802396:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239a:	0f 85 35 ff ff ff    	jne    8022d5 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023a0:	eb 01                	jmp    8023a3 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023a2:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023a3:	90                   	nop
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023ac:	a1 38 51 80 00       	mov    0x805138,%eax
  8023b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b4:	e9 85 01 00 00       	jmp    80253e <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c2:	0f 82 6e 01 00 00    	jb     802536 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d1:	0f 85 8a 00 00 00    	jne    802461 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023db:	75 17                	jne    8023f4 <alloc_block_FF+0x4e>
  8023dd:	83 ec 04             	sub    $0x4,%esp
  8023e0:	68 c0 40 80 00       	push   $0x8040c0
  8023e5:	68 93 00 00 00       	push   $0x93
  8023ea:	68 17 40 80 00       	push   $0x804017
  8023ef:	e8 8e de ff ff       	call   800282 <_panic>
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	74 10                	je     80240d <alloc_block_FF+0x67>
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802405:	8b 52 04             	mov    0x4(%edx),%edx
  802408:	89 50 04             	mov    %edx,0x4(%eax)
  80240b:	eb 0b                	jmp    802418 <alloc_block_FF+0x72>
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 40 04             	mov    0x4(%eax),%eax
  802413:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	8b 40 04             	mov    0x4(%eax),%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	74 0f                	je     802431 <alloc_block_FF+0x8b>
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 40 04             	mov    0x4(%eax),%eax
  802428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242b:	8b 12                	mov    (%edx),%edx
  80242d:	89 10                	mov    %edx,(%eax)
  80242f:	eb 0a                	jmp    80243b <alloc_block_FF+0x95>
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	a3 38 51 80 00       	mov    %eax,0x805138
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244e:	a1 44 51 80 00       	mov    0x805144,%eax
  802453:	48                   	dec    %eax
  802454:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	e9 10 01 00 00       	jmp    802571 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 40 0c             	mov    0xc(%eax),%eax
  802467:	3b 45 08             	cmp    0x8(%ebp),%eax
  80246a:	0f 86 c6 00 00 00    	jbe    802536 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802470:	a1 48 51 80 00       	mov    0x805148,%eax
  802475:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 50 08             	mov    0x8(%eax),%edx
  80247e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802481:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802487:	8b 55 08             	mov    0x8(%ebp),%edx
  80248a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80248d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802491:	75 17                	jne    8024aa <alloc_block_FF+0x104>
  802493:	83 ec 04             	sub    $0x4,%esp
  802496:	68 c0 40 80 00       	push   $0x8040c0
  80249b:	68 9b 00 00 00       	push   $0x9b
  8024a0:	68 17 40 80 00       	push   $0x804017
  8024a5:	e8 d8 dd ff ff       	call   800282 <_panic>
  8024aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	74 10                	je     8024c3 <alloc_block_FF+0x11d>
  8024b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024bb:	8b 52 04             	mov    0x4(%edx),%edx
  8024be:	89 50 04             	mov    %edx,0x4(%eax)
  8024c1:	eb 0b                	jmp    8024ce <alloc_block_FF+0x128>
  8024c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c6:	8b 40 04             	mov    0x4(%eax),%eax
  8024c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d1:	8b 40 04             	mov    0x4(%eax),%eax
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	74 0f                	je     8024e7 <alloc_block_FF+0x141>
  8024d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024db:	8b 40 04             	mov    0x4(%eax),%eax
  8024de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e1:	8b 12                	mov    (%edx),%edx
  8024e3:	89 10                	mov    %edx,(%eax)
  8024e5:	eb 0a                	jmp    8024f1 <alloc_block_FF+0x14b>
  8024e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ea:	8b 00                	mov    (%eax),%eax
  8024ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802504:	a1 54 51 80 00       	mov    0x805154,%eax
  802509:	48                   	dec    %eax
  80250a:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 50 08             	mov    0x8(%eax),%edx
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	01 c2                	add    %eax,%edx
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 40 0c             	mov    0xc(%eax),%eax
  802526:	2b 45 08             	sub    0x8(%ebp),%eax
  802529:	89 c2                	mov    %eax,%edx
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802534:	eb 3b                	jmp    802571 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802536:	a1 40 51 80 00       	mov    0x805140,%eax
  80253b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802542:	74 07                	je     80254b <alloc_block_FF+0x1a5>
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 00                	mov    (%eax),%eax
  802549:	eb 05                	jmp    802550 <alloc_block_FF+0x1aa>
  80254b:	b8 00 00 00 00       	mov    $0x0,%eax
  802550:	a3 40 51 80 00       	mov    %eax,0x805140
  802555:	a1 40 51 80 00       	mov    0x805140,%eax
  80255a:	85 c0                	test   %eax,%eax
  80255c:	0f 85 57 fe ff ff    	jne    8023b9 <alloc_block_FF+0x13>
  802562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802566:	0f 85 4d fe ff ff    	jne    8023b9 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802579:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802580:	a1 38 51 80 00       	mov    0x805138,%eax
  802585:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802588:	e9 df 00 00 00       	jmp    80266c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 40 0c             	mov    0xc(%eax),%eax
  802593:	3b 45 08             	cmp    0x8(%ebp),%eax
  802596:	0f 82 c8 00 00 00    	jb     802664 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a5:	0f 85 8a 00 00 00    	jne    802635 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025af:	75 17                	jne    8025c8 <alloc_block_BF+0x55>
  8025b1:	83 ec 04             	sub    $0x4,%esp
  8025b4:	68 c0 40 80 00       	push   $0x8040c0
  8025b9:	68 b7 00 00 00       	push   $0xb7
  8025be:	68 17 40 80 00       	push   $0x804017
  8025c3:	e8 ba dc ff ff       	call   800282 <_panic>
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	85 c0                	test   %eax,%eax
  8025cf:	74 10                	je     8025e1 <alloc_block_BF+0x6e>
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 00                	mov    (%eax),%eax
  8025d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d9:	8b 52 04             	mov    0x4(%edx),%edx
  8025dc:	89 50 04             	mov    %edx,0x4(%eax)
  8025df:	eb 0b                	jmp    8025ec <alloc_block_BF+0x79>
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 40 04             	mov    0x4(%eax),%eax
  8025e7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 40 04             	mov    0x4(%eax),%eax
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	74 0f                	je     802605 <alloc_block_BF+0x92>
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 40 04             	mov    0x4(%eax),%eax
  8025fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ff:	8b 12                	mov    (%edx),%edx
  802601:	89 10                	mov    %edx,(%eax)
  802603:	eb 0a                	jmp    80260f <alloc_block_BF+0x9c>
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 00                	mov    (%eax),%eax
  80260a:	a3 38 51 80 00       	mov    %eax,0x805138
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802622:	a1 44 51 80 00       	mov    0x805144,%eax
  802627:	48                   	dec    %eax
  802628:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	e9 4d 01 00 00       	jmp    802782 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 40 0c             	mov    0xc(%eax),%eax
  80263b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263e:	76 24                	jbe    802664 <alloc_block_BF+0xf1>
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 0c             	mov    0xc(%eax),%eax
  802646:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802649:	73 19                	jae    802664 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80264b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 40 0c             	mov    0xc(%eax),%eax
  802658:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 40 08             	mov    0x8(%eax),%eax
  802661:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802664:	a1 40 51 80 00       	mov    0x805140,%eax
  802669:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80266c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802670:	74 07                	je     802679 <alloc_block_BF+0x106>
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 00                	mov    (%eax),%eax
  802677:	eb 05                	jmp    80267e <alloc_block_BF+0x10b>
  802679:	b8 00 00 00 00       	mov    $0x0,%eax
  80267e:	a3 40 51 80 00       	mov    %eax,0x805140
  802683:	a1 40 51 80 00       	mov    0x805140,%eax
  802688:	85 c0                	test   %eax,%eax
  80268a:	0f 85 fd fe ff ff    	jne    80258d <alloc_block_BF+0x1a>
  802690:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802694:	0f 85 f3 fe ff ff    	jne    80258d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80269a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80269e:	0f 84 d9 00 00 00    	je     80277d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026a4:	a1 48 51 80 00       	mov    0x805148,%eax
  8026a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b2:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bb:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026c2:	75 17                	jne    8026db <alloc_block_BF+0x168>
  8026c4:	83 ec 04             	sub    $0x4,%esp
  8026c7:	68 c0 40 80 00       	push   $0x8040c0
  8026cc:	68 c7 00 00 00       	push   $0xc7
  8026d1:	68 17 40 80 00       	push   $0x804017
  8026d6:	e8 a7 db ff ff       	call   800282 <_panic>
  8026db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026de:	8b 00                	mov    (%eax),%eax
  8026e0:	85 c0                	test   %eax,%eax
  8026e2:	74 10                	je     8026f4 <alloc_block_BF+0x181>
  8026e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e7:	8b 00                	mov    (%eax),%eax
  8026e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ec:	8b 52 04             	mov    0x4(%edx),%edx
  8026ef:	89 50 04             	mov    %edx,0x4(%eax)
  8026f2:	eb 0b                	jmp    8026ff <alloc_block_BF+0x18c>
  8026f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f7:	8b 40 04             	mov    0x4(%eax),%eax
  8026fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802702:	8b 40 04             	mov    0x4(%eax),%eax
  802705:	85 c0                	test   %eax,%eax
  802707:	74 0f                	je     802718 <alloc_block_BF+0x1a5>
  802709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270c:	8b 40 04             	mov    0x4(%eax),%eax
  80270f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802712:	8b 12                	mov    (%edx),%edx
  802714:	89 10                	mov    %edx,(%eax)
  802716:	eb 0a                	jmp    802722 <alloc_block_BF+0x1af>
  802718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	a3 48 51 80 00       	mov    %eax,0x805148
  802722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802725:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802735:	a1 54 51 80 00       	mov    0x805154,%eax
  80273a:	48                   	dec    %eax
  80273b:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802740:	83 ec 08             	sub    $0x8,%esp
  802743:	ff 75 ec             	pushl  -0x14(%ebp)
  802746:	68 38 51 80 00       	push   $0x805138
  80274b:	e8 71 f9 ff ff       	call   8020c1 <find_block>
  802750:	83 c4 10             	add    $0x10,%esp
  802753:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802756:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802759:	8b 50 08             	mov    0x8(%eax),%edx
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	01 c2                	add    %eax,%edx
  802761:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802764:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802767:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276a:	8b 40 0c             	mov    0xc(%eax),%eax
  80276d:	2b 45 08             	sub    0x8(%ebp),%eax
  802770:	89 c2                	mov    %eax,%edx
  802772:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802775:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277b:	eb 05                	jmp    802782 <alloc_block_BF+0x20f>
	}
	return NULL;
  80277d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802782:	c9                   	leave  
  802783:	c3                   	ret    

00802784 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
  802787:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80278a:	a1 28 50 80 00       	mov    0x805028,%eax
  80278f:	85 c0                	test   %eax,%eax
  802791:	0f 85 de 01 00 00    	jne    802975 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802797:	a1 38 51 80 00       	mov    0x805138,%eax
  80279c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279f:	e9 9e 01 00 00       	jmp    802942 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ad:	0f 82 87 01 00 00    	jb     80293a <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027bc:	0f 85 95 00 00 00    	jne    802857 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c6:	75 17                	jne    8027df <alloc_block_NF+0x5b>
  8027c8:	83 ec 04             	sub    $0x4,%esp
  8027cb:	68 c0 40 80 00       	push   $0x8040c0
  8027d0:	68 e0 00 00 00       	push   $0xe0
  8027d5:	68 17 40 80 00       	push   $0x804017
  8027da:	e8 a3 da ff ff       	call   800282 <_panic>
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 10                	je     8027f8 <alloc_block_NF+0x74>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f0:	8b 52 04             	mov    0x4(%edx),%edx
  8027f3:	89 50 04             	mov    %edx,0x4(%eax)
  8027f6:	eb 0b                	jmp    802803 <alloc_block_NF+0x7f>
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 40 04             	mov    0x4(%eax),%eax
  8027fe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 40 04             	mov    0x4(%eax),%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	74 0f                	je     80281c <alloc_block_NF+0x98>
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 40 04             	mov    0x4(%eax),%eax
  802813:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802816:	8b 12                	mov    (%edx),%edx
  802818:	89 10                	mov    %edx,(%eax)
  80281a:	eb 0a                	jmp    802826 <alloc_block_NF+0xa2>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 00                	mov    (%eax),%eax
  802821:	a3 38 51 80 00       	mov    %eax,0x805138
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802839:	a1 44 51 80 00       	mov    0x805144,%eax
  80283e:	48                   	dec    %eax
  80283f:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 40 08             	mov    0x8(%eax),%eax
  80284a:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	e9 f8 04 00 00       	jmp    802d4f <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 40 0c             	mov    0xc(%eax),%eax
  80285d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802860:	0f 86 d4 00 00 00    	jbe    80293a <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802866:	a1 48 51 80 00       	mov    0x805148,%eax
  80286b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 50 08             	mov    0x8(%eax),%edx
  802874:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802877:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80287a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287d:	8b 55 08             	mov    0x8(%ebp),%edx
  802880:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802883:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802887:	75 17                	jne    8028a0 <alloc_block_NF+0x11c>
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	68 c0 40 80 00       	push   $0x8040c0
  802891:	68 e9 00 00 00       	push   $0xe9
  802896:	68 17 40 80 00       	push   $0x804017
  80289b:	e8 e2 d9 ff ff       	call   800282 <_panic>
  8028a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	74 10                	je     8028b9 <alloc_block_NF+0x135>
  8028a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b1:	8b 52 04             	mov    0x4(%edx),%edx
  8028b4:	89 50 04             	mov    %edx,0x4(%eax)
  8028b7:	eb 0b                	jmp    8028c4 <alloc_block_NF+0x140>
  8028b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bc:	8b 40 04             	mov    0x4(%eax),%eax
  8028bf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	74 0f                	je     8028dd <alloc_block_NF+0x159>
  8028ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d1:	8b 40 04             	mov    0x4(%eax),%eax
  8028d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d7:	8b 12                	mov    (%edx),%edx
  8028d9:	89 10                	mov    %edx,(%eax)
  8028db:	eb 0a                	jmp    8028e7 <alloc_block_NF+0x163>
  8028dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e0:	8b 00                	mov    (%eax),%eax
  8028e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8028e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8028ff:	48                   	dec    %eax
  802900:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802908:	8b 40 08             	mov    0x8(%eax),%eax
  80290b:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	8b 50 08             	mov    0x8(%eax),%edx
  802916:	8b 45 08             	mov    0x8(%ebp),%eax
  802919:	01 c2                	add    %eax,%edx
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 40 0c             	mov    0xc(%eax),%eax
  802927:	2b 45 08             	sub    0x8(%ebp),%eax
  80292a:	89 c2                	mov    %eax,%edx
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802935:	e9 15 04 00 00       	jmp    802d4f <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80293a:	a1 40 51 80 00       	mov    0x805140,%eax
  80293f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802946:	74 07                	je     80294f <alloc_block_NF+0x1cb>
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 00                	mov    (%eax),%eax
  80294d:	eb 05                	jmp    802954 <alloc_block_NF+0x1d0>
  80294f:	b8 00 00 00 00       	mov    $0x0,%eax
  802954:	a3 40 51 80 00       	mov    %eax,0x805140
  802959:	a1 40 51 80 00       	mov    0x805140,%eax
  80295e:	85 c0                	test   %eax,%eax
  802960:	0f 85 3e fe ff ff    	jne    8027a4 <alloc_block_NF+0x20>
  802966:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296a:	0f 85 34 fe ff ff    	jne    8027a4 <alloc_block_NF+0x20>
  802970:	e9 d5 03 00 00       	jmp    802d4a <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802975:	a1 38 51 80 00       	mov    0x805138,%eax
  80297a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297d:	e9 b1 01 00 00       	jmp    802b33 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 50 08             	mov    0x8(%eax),%edx
  802988:	a1 28 50 80 00       	mov    0x805028,%eax
  80298d:	39 c2                	cmp    %eax,%edx
  80298f:	0f 82 96 01 00 00    	jb     802b2b <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	8b 40 0c             	mov    0xc(%eax),%eax
  80299b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299e:	0f 82 87 01 00 00    	jb     802b2b <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ad:	0f 85 95 00 00 00    	jne    802a48 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b7:	75 17                	jne    8029d0 <alloc_block_NF+0x24c>
  8029b9:	83 ec 04             	sub    $0x4,%esp
  8029bc:	68 c0 40 80 00       	push   $0x8040c0
  8029c1:	68 fc 00 00 00       	push   $0xfc
  8029c6:	68 17 40 80 00       	push   $0x804017
  8029cb:	e8 b2 d8 ff ff       	call   800282 <_panic>
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 00                	mov    (%eax),%eax
  8029d5:	85 c0                	test   %eax,%eax
  8029d7:	74 10                	je     8029e9 <alloc_block_NF+0x265>
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e1:	8b 52 04             	mov    0x4(%edx),%edx
  8029e4:	89 50 04             	mov    %edx,0x4(%eax)
  8029e7:	eb 0b                	jmp    8029f4 <alloc_block_NF+0x270>
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 40 04             	mov    0x4(%eax),%eax
  8029ef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 40 04             	mov    0x4(%eax),%eax
  8029fa:	85 c0                	test   %eax,%eax
  8029fc:	74 0f                	je     802a0d <alloc_block_NF+0x289>
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 40 04             	mov    0x4(%eax),%eax
  802a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a07:	8b 12                	mov    (%edx),%edx
  802a09:	89 10                	mov    %edx,(%eax)
  802a0b:	eb 0a                	jmp    802a17 <alloc_block_NF+0x293>
  802a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	a3 38 51 80 00       	mov    %eax,0x805138
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2a:	a1 44 51 80 00       	mov    0x805144,%eax
  802a2f:	48                   	dec    %eax
  802a30:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 40 08             	mov    0x8(%eax),%eax
  802a3b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	e9 07 03 00 00       	jmp    802d4f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a51:	0f 86 d4 00 00 00    	jbe    802b2b <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a57:	a1 48 51 80 00       	mov    0x805148,%eax
  802a5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 50 08             	mov    0x8(%eax),%edx
  802a65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a68:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a71:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a74:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a78:	75 17                	jne    802a91 <alloc_block_NF+0x30d>
  802a7a:	83 ec 04             	sub    $0x4,%esp
  802a7d:	68 c0 40 80 00       	push   $0x8040c0
  802a82:	68 04 01 00 00       	push   $0x104
  802a87:	68 17 40 80 00       	push   $0x804017
  802a8c:	e8 f1 d7 ff ff       	call   800282 <_panic>
  802a91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a94:	8b 00                	mov    (%eax),%eax
  802a96:	85 c0                	test   %eax,%eax
  802a98:	74 10                	je     802aaa <alloc_block_NF+0x326>
  802a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9d:	8b 00                	mov    (%eax),%eax
  802a9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aa2:	8b 52 04             	mov    0x4(%edx),%edx
  802aa5:	89 50 04             	mov    %edx,0x4(%eax)
  802aa8:	eb 0b                	jmp    802ab5 <alloc_block_NF+0x331>
  802aaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aad:	8b 40 04             	mov    0x4(%eax),%eax
  802ab0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ab5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab8:	8b 40 04             	mov    0x4(%eax),%eax
  802abb:	85 c0                	test   %eax,%eax
  802abd:	74 0f                	je     802ace <alloc_block_NF+0x34a>
  802abf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac2:	8b 40 04             	mov    0x4(%eax),%eax
  802ac5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ac8:	8b 12                	mov    (%edx),%edx
  802aca:	89 10                	mov    %edx,(%eax)
  802acc:	eb 0a                	jmp    802ad8 <alloc_block_NF+0x354>
  802ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad1:	8b 00                	mov    (%eax),%eax
  802ad3:	a3 48 51 80 00       	mov    %eax,0x805148
  802ad8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802adb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aeb:	a1 54 51 80 00       	mov    0x805154,%eax
  802af0:	48                   	dec    %eax
  802af1:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af9:	8b 40 08             	mov    0x8(%eax),%eax
  802afc:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 50 08             	mov    0x8(%eax),%edx
  802b07:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0a:	01 c2                	add    %eax,%edx
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 40 0c             	mov    0xc(%eax),%eax
  802b18:	2b 45 08             	sub    0x8(%ebp),%eax
  802b1b:	89 c2                	mov    %eax,%edx
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b26:	e9 24 02 00 00       	jmp    802d4f <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b2b:	a1 40 51 80 00       	mov    0x805140,%eax
  802b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b37:	74 07                	je     802b40 <alloc_block_NF+0x3bc>
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	8b 00                	mov    (%eax),%eax
  802b3e:	eb 05                	jmp    802b45 <alloc_block_NF+0x3c1>
  802b40:	b8 00 00 00 00       	mov    $0x0,%eax
  802b45:	a3 40 51 80 00       	mov    %eax,0x805140
  802b4a:	a1 40 51 80 00       	mov    0x805140,%eax
  802b4f:	85 c0                	test   %eax,%eax
  802b51:	0f 85 2b fe ff ff    	jne    802982 <alloc_block_NF+0x1fe>
  802b57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5b:	0f 85 21 fe ff ff    	jne    802982 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b61:	a1 38 51 80 00       	mov    0x805138,%eax
  802b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b69:	e9 ae 01 00 00       	jmp    802d1c <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 50 08             	mov    0x8(%eax),%edx
  802b74:	a1 28 50 80 00       	mov    0x805028,%eax
  802b79:	39 c2                	cmp    %eax,%edx
  802b7b:	0f 83 93 01 00 00    	jae    802d14 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b84:	8b 40 0c             	mov    0xc(%eax),%eax
  802b87:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8a:	0f 82 84 01 00 00    	jb     802d14 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	8b 40 0c             	mov    0xc(%eax),%eax
  802b96:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b99:	0f 85 95 00 00 00    	jne    802c34 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba3:	75 17                	jne    802bbc <alloc_block_NF+0x438>
  802ba5:	83 ec 04             	sub    $0x4,%esp
  802ba8:	68 c0 40 80 00       	push   $0x8040c0
  802bad:	68 14 01 00 00       	push   $0x114
  802bb2:	68 17 40 80 00       	push   $0x804017
  802bb7:	e8 c6 d6 ff ff       	call   800282 <_panic>
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	85 c0                	test   %eax,%eax
  802bc3:	74 10                	je     802bd5 <alloc_block_NF+0x451>
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 00                	mov    (%eax),%eax
  802bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bcd:	8b 52 04             	mov    0x4(%edx),%edx
  802bd0:	89 50 04             	mov    %edx,0x4(%eax)
  802bd3:	eb 0b                	jmp    802be0 <alloc_block_NF+0x45c>
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 40 04             	mov    0x4(%eax),%eax
  802bdb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 40 04             	mov    0x4(%eax),%eax
  802be6:	85 c0                	test   %eax,%eax
  802be8:	74 0f                	je     802bf9 <alloc_block_NF+0x475>
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 40 04             	mov    0x4(%eax),%eax
  802bf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf3:	8b 12                	mov    (%edx),%edx
  802bf5:	89 10                	mov    %edx,(%eax)
  802bf7:	eb 0a                	jmp    802c03 <alloc_block_NF+0x47f>
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	8b 00                	mov    (%eax),%eax
  802bfe:	a3 38 51 80 00       	mov    %eax,0x805138
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c16:	a1 44 51 80 00       	mov    0x805144,%eax
  802c1b:	48                   	dec    %eax
  802c1c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 40 08             	mov    0x8(%eax),%eax
  802c27:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	e9 1b 01 00 00       	jmp    802d4f <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3d:	0f 86 d1 00 00 00    	jbe    802d14 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c43:	a1 48 51 80 00       	mov    0x805148,%eax
  802c48:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 50 08             	mov    0x8(%eax),%edx
  802c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c54:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c64:	75 17                	jne    802c7d <alloc_block_NF+0x4f9>
  802c66:	83 ec 04             	sub    $0x4,%esp
  802c69:	68 c0 40 80 00       	push   $0x8040c0
  802c6e:	68 1c 01 00 00       	push   $0x11c
  802c73:	68 17 40 80 00       	push   $0x804017
  802c78:	e8 05 d6 ff ff       	call   800282 <_panic>
  802c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c80:	8b 00                	mov    (%eax),%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	74 10                	je     802c96 <alloc_block_NF+0x512>
  802c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c89:	8b 00                	mov    (%eax),%eax
  802c8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c8e:	8b 52 04             	mov    0x4(%edx),%edx
  802c91:	89 50 04             	mov    %edx,0x4(%eax)
  802c94:	eb 0b                	jmp    802ca1 <alloc_block_NF+0x51d>
  802c96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c99:	8b 40 04             	mov    0x4(%eax),%eax
  802c9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca4:	8b 40 04             	mov    0x4(%eax),%eax
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	74 0f                	je     802cba <alloc_block_NF+0x536>
  802cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cae:	8b 40 04             	mov    0x4(%eax),%eax
  802cb1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cb4:	8b 12                	mov    (%edx),%edx
  802cb6:	89 10                	mov    %edx,(%eax)
  802cb8:	eb 0a                	jmp    802cc4 <alloc_block_NF+0x540>
  802cba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbd:	8b 00                	mov    (%eax),%eax
  802cbf:	a3 48 51 80 00       	mov    %eax,0x805148
  802cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd7:	a1 54 51 80 00       	mov    0x805154,%eax
  802cdc:	48                   	dec    %eax
  802cdd:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce5:	8b 40 08             	mov    0x8(%eax),%eax
  802ce8:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 50 08             	mov    0x8(%eax),%edx
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	01 c2                	add    %eax,%edx
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 40 0c             	mov    0xc(%eax),%eax
  802d04:	2b 45 08             	sub    0x8(%ebp),%eax
  802d07:	89 c2                	mov    %eax,%edx
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d12:	eb 3b                	jmp    802d4f <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d14:	a1 40 51 80 00       	mov    0x805140,%eax
  802d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d20:	74 07                	je     802d29 <alloc_block_NF+0x5a5>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	eb 05                	jmp    802d2e <alloc_block_NF+0x5aa>
  802d29:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2e:	a3 40 51 80 00       	mov    %eax,0x805140
  802d33:	a1 40 51 80 00       	mov    0x805140,%eax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	0f 85 2e fe ff ff    	jne    802b6e <alloc_block_NF+0x3ea>
  802d40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d44:	0f 85 24 fe ff ff    	jne    802b6e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d4f:	c9                   	leave  
  802d50:	c3                   	ret    

00802d51 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d51:	55                   	push   %ebp
  802d52:	89 e5                	mov    %esp,%ebp
  802d54:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d57:	a1 38 51 80 00       	mov    0x805138,%eax
  802d5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d5f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d64:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d67:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6c:	85 c0                	test   %eax,%eax
  802d6e:	74 14                	je     802d84 <insert_sorted_with_merge_freeList+0x33>
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	8b 50 08             	mov    0x8(%eax),%edx
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	8b 40 08             	mov    0x8(%eax),%eax
  802d7c:	39 c2                	cmp    %eax,%edx
  802d7e:	0f 87 9b 01 00 00    	ja     802f1f <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d88:	75 17                	jne    802da1 <insert_sorted_with_merge_freeList+0x50>
  802d8a:	83 ec 04             	sub    $0x4,%esp
  802d8d:	68 f4 3f 80 00       	push   $0x803ff4
  802d92:	68 38 01 00 00       	push   $0x138
  802d97:	68 17 40 80 00       	push   $0x804017
  802d9c:	e8 e1 d4 ff ff       	call   800282 <_panic>
  802da1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	89 10                	mov    %edx,(%eax)
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	8b 00                	mov    (%eax),%eax
  802db1:	85 c0                	test   %eax,%eax
  802db3:	74 0d                	je     802dc2 <insert_sorted_with_merge_freeList+0x71>
  802db5:	a1 38 51 80 00       	mov    0x805138,%eax
  802dba:	8b 55 08             	mov    0x8(%ebp),%edx
  802dbd:	89 50 04             	mov    %edx,0x4(%eax)
  802dc0:	eb 08                	jmp    802dca <insert_sorted_with_merge_freeList+0x79>
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	a3 38 51 80 00       	mov    %eax,0x805138
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddc:	a1 44 51 80 00       	mov    0x805144,%eax
  802de1:	40                   	inc    %eax
  802de2:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802de7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802deb:	0f 84 a8 06 00 00    	je     803499 <insert_sorted_with_merge_freeList+0x748>
  802df1:	8b 45 08             	mov    0x8(%ebp),%eax
  802df4:	8b 50 08             	mov    0x8(%eax),%edx
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfd:	01 c2                	add    %eax,%edx
  802dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e02:	8b 40 08             	mov    0x8(%eax),%eax
  802e05:	39 c2                	cmp    %eax,%edx
  802e07:	0f 85 8c 06 00 00    	jne    803499 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	8b 50 0c             	mov    0xc(%eax),%edx
  802e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e16:	8b 40 0c             	mov    0xc(%eax),%eax
  802e19:	01 c2                	add    %eax,%edx
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e25:	75 17                	jne    802e3e <insert_sorted_with_merge_freeList+0xed>
  802e27:	83 ec 04             	sub    $0x4,%esp
  802e2a:	68 c0 40 80 00       	push   $0x8040c0
  802e2f:	68 3c 01 00 00       	push   $0x13c
  802e34:	68 17 40 80 00       	push   $0x804017
  802e39:	e8 44 d4 ff ff       	call   800282 <_panic>
  802e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	85 c0                	test   %eax,%eax
  802e45:	74 10                	je     802e57 <insert_sorted_with_merge_freeList+0x106>
  802e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4a:	8b 00                	mov    (%eax),%eax
  802e4c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e4f:	8b 52 04             	mov    0x4(%edx),%edx
  802e52:	89 50 04             	mov    %edx,0x4(%eax)
  802e55:	eb 0b                	jmp    802e62 <insert_sorted_with_merge_freeList+0x111>
  802e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e65:	8b 40 04             	mov    0x4(%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	74 0f                	je     802e7b <insert_sorted_with_merge_freeList+0x12a>
  802e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6f:	8b 40 04             	mov    0x4(%eax),%eax
  802e72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e75:	8b 12                	mov    (%edx),%edx
  802e77:	89 10                	mov    %edx,(%eax)
  802e79:	eb 0a                	jmp    802e85 <insert_sorted_with_merge_freeList+0x134>
  802e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	a3 38 51 80 00       	mov    %eax,0x805138
  802e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e98:	a1 44 51 80 00       	mov    0x805144,%eax
  802e9d:	48                   	dec    %eax
  802e9e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802eb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ebb:	75 17                	jne    802ed4 <insert_sorted_with_merge_freeList+0x183>
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	68 f4 3f 80 00       	push   $0x803ff4
  802ec5:	68 3f 01 00 00       	push   $0x13f
  802eca:	68 17 40 80 00       	push   $0x804017
  802ecf:	e8 ae d3 ff ff       	call   800282 <_panic>
  802ed4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edd:	89 10                	mov    %edx,(%eax)
  802edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	85 c0                	test   %eax,%eax
  802ee6:	74 0d                	je     802ef5 <insert_sorted_with_merge_freeList+0x1a4>
  802ee8:	a1 48 51 80 00       	mov    0x805148,%eax
  802eed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef0:	89 50 04             	mov    %edx,0x4(%eax)
  802ef3:	eb 08                	jmp    802efd <insert_sorted_with_merge_freeList+0x1ac>
  802ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f00:	a3 48 51 80 00       	mov    %eax,0x805148
  802f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0f:	a1 54 51 80 00       	mov    0x805154,%eax
  802f14:	40                   	inc    %eax
  802f15:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f1a:	e9 7a 05 00 00       	jmp    803499 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	8b 50 08             	mov    0x8(%eax),%edx
  802f25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f28:	8b 40 08             	mov    0x8(%eax),%eax
  802f2b:	39 c2                	cmp    %eax,%edx
  802f2d:	0f 82 14 01 00 00    	jb     803047 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f36:	8b 50 08             	mov    0x8(%eax),%edx
  802f39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3f:	01 c2                	add    %eax,%edx
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	8b 40 08             	mov    0x8(%eax),%eax
  802f47:	39 c2                	cmp    %eax,%edx
  802f49:	0f 85 90 00 00 00    	jne    802fdf <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f52:	8b 50 0c             	mov    0xc(%eax),%edx
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5b:	01 c2                	add    %eax,%edx
  802f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f60:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7b:	75 17                	jne    802f94 <insert_sorted_with_merge_freeList+0x243>
  802f7d:	83 ec 04             	sub    $0x4,%esp
  802f80:	68 f4 3f 80 00       	push   $0x803ff4
  802f85:	68 49 01 00 00       	push   $0x149
  802f8a:	68 17 40 80 00       	push   $0x804017
  802f8f:	e8 ee d2 ff ff       	call   800282 <_panic>
  802f94:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	89 10                	mov    %edx,(%eax)
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	8b 00                	mov    (%eax),%eax
  802fa4:	85 c0                	test   %eax,%eax
  802fa6:	74 0d                	je     802fb5 <insert_sorted_with_merge_freeList+0x264>
  802fa8:	a1 48 51 80 00       	mov    0x805148,%eax
  802fad:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb0:	89 50 04             	mov    %edx,0x4(%eax)
  802fb3:	eb 08                	jmp    802fbd <insert_sorted_with_merge_freeList+0x26c>
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcf:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd4:	40                   	inc    %eax
  802fd5:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fda:	e9 bb 04 00 00       	jmp    80349a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe3:	75 17                	jne    802ffc <insert_sorted_with_merge_freeList+0x2ab>
  802fe5:	83 ec 04             	sub    $0x4,%esp
  802fe8:	68 68 40 80 00       	push   $0x804068
  802fed:	68 4c 01 00 00       	push   $0x14c
  802ff2:	68 17 40 80 00       	push   $0x804017
  802ff7:	e8 86 d2 ff ff       	call   800282 <_panic>
  802ffc:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803002:	8b 45 08             	mov    0x8(%ebp),%eax
  803005:	89 50 04             	mov    %edx,0x4(%eax)
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	8b 40 04             	mov    0x4(%eax),%eax
  80300e:	85 c0                	test   %eax,%eax
  803010:	74 0c                	je     80301e <insert_sorted_with_merge_freeList+0x2cd>
  803012:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803017:	8b 55 08             	mov    0x8(%ebp),%edx
  80301a:	89 10                	mov    %edx,(%eax)
  80301c:	eb 08                	jmp    803026 <insert_sorted_with_merge_freeList+0x2d5>
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	a3 38 51 80 00       	mov    %eax,0x805138
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80302e:	8b 45 08             	mov    0x8(%ebp),%eax
  803031:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803037:	a1 44 51 80 00       	mov    0x805144,%eax
  80303c:	40                   	inc    %eax
  80303d:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803042:	e9 53 04 00 00       	jmp    80349a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803047:	a1 38 51 80 00       	mov    0x805138,%eax
  80304c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304f:	e9 15 04 00 00       	jmp    803469 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	8b 50 08             	mov    0x8(%eax),%edx
  803062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803065:	8b 40 08             	mov    0x8(%eax),%eax
  803068:	39 c2                	cmp    %eax,%edx
  80306a:	0f 86 f1 03 00 00    	jbe    803461 <insert_sorted_with_merge_freeList+0x710>
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	8b 50 08             	mov    0x8(%eax),%edx
  803076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803079:	8b 40 08             	mov    0x8(%eax),%eax
  80307c:	39 c2                	cmp    %eax,%edx
  80307e:	0f 83 dd 03 00 00    	jae    803461 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 50 08             	mov    0x8(%eax),%edx
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 40 0c             	mov    0xc(%eax),%eax
  803090:	01 c2                	add    %eax,%edx
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	8b 40 08             	mov    0x8(%eax),%eax
  803098:	39 c2                	cmp    %eax,%edx
  80309a:	0f 85 b9 01 00 00    	jne    803259 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	8b 50 08             	mov    0x8(%eax),%edx
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ac:	01 c2                	add    %eax,%edx
  8030ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b1:	8b 40 08             	mov    0x8(%eax),%eax
  8030b4:	39 c2                	cmp    %eax,%edx
  8030b6:	0f 85 0d 01 00 00    	jne    8031c9 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c8:	01 c2                	add    %eax,%edx
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d4:	75 17                	jne    8030ed <insert_sorted_with_merge_freeList+0x39c>
  8030d6:	83 ec 04             	sub    $0x4,%esp
  8030d9:	68 c0 40 80 00       	push   $0x8040c0
  8030de:	68 5c 01 00 00       	push   $0x15c
  8030e3:	68 17 40 80 00       	push   $0x804017
  8030e8:	e8 95 d1 ff ff       	call   800282 <_panic>
  8030ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f0:	8b 00                	mov    (%eax),%eax
  8030f2:	85 c0                	test   %eax,%eax
  8030f4:	74 10                	je     803106 <insert_sorted_with_merge_freeList+0x3b5>
  8030f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030fe:	8b 52 04             	mov    0x4(%edx),%edx
  803101:	89 50 04             	mov    %edx,0x4(%eax)
  803104:	eb 0b                	jmp    803111 <insert_sorted_with_merge_freeList+0x3c0>
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	8b 40 04             	mov    0x4(%eax),%eax
  80310c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803111:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803114:	8b 40 04             	mov    0x4(%eax),%eax
  803117:	85 c0                	test   %eax,%eax
  803119:	74 0f                	je     80312a <insert_sorted_with_merge_freeList+0x3d9>
  80311b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311e:	8b 40 04             	mov    0x4(%eax),%eax
  803121:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803124:	8b 12                	mov    (%edx),%edx
  803126:	89 10                	mov    %edx,(%eax)
  803128:	eb 0a                	jmp    803134 <insert_sorted_with_merge_freeList+0x3e3>
  80312a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312d:	8b 00                	mov    (%eax),%eax
  80312f:	a3 38 51 80 00       	mov    %eax,0x805138
  803134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803137:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803140:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803147:	a1 44 51 80 00       	mov    0x805144,%eax
  80314c:	48                   	dec    %eax
  80314d:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803166:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80316a:	75 17                	jne    803183 <insert_sorted_with_merge_freeList+0x432>
  80316c:	83 ec 04             	sub    $0x4,%esp
  80316f:	68 f4 3f 80 00       	push   $0x803ff4
  803174:	68 5f 01 00 00       	push   $0x15f
  803179:	68 17 40 80 00       	push   $0x804017
  80317e:	e8 ff d0 ff ff       	call   800282 <_panic>
  803183:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318c:	89 10                	mov    %edx,(%eax)
  80318e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803191:	8b 00                	mov    (%eax),%eax
  803193:	85 c0                	test   %eax,%eax
  803195:	74 0d                	je     8031a4 <insert_sorted_with_merge_freeList+0x453>
  803197:	a1 48 51 80 00       	mov    0x805148,%eax
  80319c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80319f:	89 50 04             	mov    %edx,0x4(%eax)
  8031a2:	eb 08                	jmp    8031ac <insert_sorted_with_merge_freeList+0x45b>
  8031a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031af:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031be:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c3:	40                   	inc    %eax
  8031c4:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d5:	01 c2                	add    %eax,%edx
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f5:	75 17                	jne    80320e <insert_sorted_with_merge_freeList+0x4bd>
  8031f7:	83 ec 04             	sub    $0x4,%esp
  8031fa:	68 f4 3f 80 00       	push   $0x803ff4
  8031ff:	68 64 01 00 00       	push   $0x164
  803204:	68 17 40 80 00       	push   $0x804017
  803209:	e8 74 d0 ff ff       	call   800282 <_panic>
  80320e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803214:	8b 45 08             	mov    0x8(%ebp),%eax
  803217:	89 10                	mov    %edx,(%eax)
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	85 c0                	test   %eax,%eax
  803220:	74 0d                	je     80322f <insert_sorted_with_merge_freeList+0x4de>
  803222:	a1 48 51 80 00       	mov    0x805148,%eax
  803227:	8b 55 08             	mov    0x8(%ebp),%edx
  80322a:	89 50 04             	mov    %edx,0x4(%eax)
  80322d:	eb 08                	jmp    803237 <insert_sorted_with_merge_freeList+0x4e6>
  80322f:	8b 45 08             	mov    0x8(%ebp),%eax
  803232:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	a3 48 51 80 00       	mov    %eax,0x805148
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803249:	a1 54 51 80 00       	mov    0x805154,%eax
  80324e:	40                   	inc    %eax
  80324f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803254:	e9 41 02 00 00       	jmp    80349a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	8b 50 08             	mov    0x8(%eax),%edx
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	8b 40 0c             	mov    0xc(%eax),%eax
  803265:	01 c2                	add    %eax,%edx
  803267:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326a:	8b 40 08             	mov    0x8(%eax),%eax
  80326d:	39 c2                	cmp    %eax,%edx
  80326f:	0f 85 7c 01 00 00    	jne    8033f1 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803275:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803279:	74 06                	je     803281 <insert_sorted_with_merge_freeList+0x530>
  80327b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80327f:	75 17                	jne    803298 <insert_sorted_with_merge_freeList+0x547>
  803281:	83 ec 04             	sub    $0x4,%esp
  803284:	68 30 40 80 00       	push   $0x804030
  803289:	68 69 01 00 00       	push   $0x169
  80328e:	68 17 40 80 00       	push   $0x804017
  803293:	e8 ea cf ff ff       	call   800282 <_panic>
  803298:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329b:	8b 50 04             	mov    0x4(%eax),%edx
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	89 50 04             	mov    %edx,0x4(%eax)
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032aa:	89 10                	mov    %edx,(%eax)
  8032ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032af:	8b 40 04             	mov    0x4(%eax),%eax
  8032b2:	85 c0                	test   %eax,%eax
  8032b4:	74 0d                	je     8032c3 <insert_sorted_with_merge_freeList+0x572>
  8032b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b9:	8b 40 04             	mov    0x4(%eax),%eax
  8032bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bf:	89 10                	mov    %edx,(%eax)
  8032c1:	eb 08                	jmp    8032cb <insert_sorted_with_merge_freeList+0x57a>
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8032cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d1:	89 50 04             	mov    %edx,0x4(%eax)
  8032d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8032d9:	40                   	inc    %eax
  8032da:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	8b 50 0c             	mov    0xc(%eax),%edx
  8032e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032eb:	01 c2                	add    %eax,%edx
  8032ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f0:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032f7:	75 17                	jne    803310 <insert_sorted_with_merge_freeList+0x5bf>
  8032f9:	83 ec 04             	sub    $0x4,%esp
  8032fc:	68 c0 40 80 00       	push   $0x8040c0
  803301:	68 6b 01 00 00       	push   $0x16b
  803306:	68 17 40 80 00       	push   $0x804017
  80330b:	e8 72 cf ff ff       	call   800282 <_panic>
  803310:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803313:	8b 00                	mov    (%eax),%eax
  803315:	85 c0                	test   %eax,%eax
  803317:	74 10                	je     803329 <insert_sorted_with_merge_freeList+0x5d8>
  803319:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331c:	8b 00                	mov    (%eax),%eax
  80331e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803321:	8b 52 04             	mov    0x4(%edx),%edx
  803324:	89 50 04             	mov    %edx,0x4(%eax)
  803327:	eb 0b                	jmp    803334 <insert_sorted_with_merge_freeList+0x5e3>
  803329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332c:	8b 40 04             	mov    0x4(%eax),%eax
  80332f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803334:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803337:	8b 40 04             	mov    0x4(%eax),%eax
  80333a:	85 c0                	test   %eax,%eax
  80333c:	74 0f                	je     80334d <insert_sorted_with_merge_freeList+0x5fc>
  80333e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803347:	8b 12                	mov    (%edx),%edx
  803349:	89 10                	mov    %edx,(%eax)
  80334b:	eb 0a                	jmp    803357 <insert_sorted_with_merge_freeList+0x606>
  80334d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803350:	8b 00                	mov    (%eax),%eax
  803352:	a3 38 51 80 00       	mov    %eax,0x805138
  803357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803360:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803363:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336a:	a1 44 51 80 00       	mov    0x805144,%eax
  80336f:	48                   	dec    %eax
  803370:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80337f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803382:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803389:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80338d:	75 17                	jne    8033a6 <insert_sorted_with_merge_freeList+0x655>
  80338f:	83 ec 04             	sub    $0x4,%esp
  803392:	68 f4 3f 80 00       	push   $0x803ff4
  803397:	68 6e 01 00 00       	push   $0x16e
  80339c:	68 17 40 80 00       	push   $0x804017
  8033a1:	e8 dc ce ff ff       	call   800282 <_panic>
  8033a6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033af:	89 10                	mov    %edx,(%eax)
  8033b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b4:	8b 00                	mov    (%eax),%eax
  8033b6:	85 c0                	test   %eax,%eax
  8033b8:	74 0d                	je     8033c7 <insert_sorted_with_merge_freeList+0x676>
  8033ba:	a1 48 51 80 00       	mov    0x805148,%eax
  8033bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c2:	89 50 04             	mov    %edx,0x4(%eax)
  8033c5:	eb 08                	jmp    8033cf <insert_sorted_with_merge_freeList+0x67e>
  8033c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8033d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8033e6:	40                   	inc    %eax
  8033e7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033ec:	e9 a9 00 00 00       	jmp    80349a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f5:	74 06                	je     8033fd <insert_sorted_with_merge_freeList+0x6ac>
  8033f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033fb:	75 17                	jne    803414 <insert_sorted_with_merge_freeList+0x6c3>
  8033fd:	83 ec 04             	sub    $0x4,%esp
  803400:	68 8c 40 80 00       	push   $0x80408c
  803405:	68 73 01 00 00       	push   $0x173
  80340a:	68 17 40 80 00       	push   $0x804017
  80340f:	e8 6e ce ff ff       	call   800282 <_panic>
  803414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803417:	8b 10                	mov    (%eax),%edx
  803419:	8b 45 08             	mov    0x8(%ebp),%eax
  80341c:	89 10                	mov    %edx,(%eax)
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	8b 00                	mov    (%eax),%eax
  803423:	85 c0                	test   %eax,%eax
  803425:	74 0b                	je     803432 <insert_sorted_with_merge_freeList+0x6e1>
  803427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342a:	8b 00                	mov    (%eax),%eax
  80342c:	8b 55 08             	mov    0x8(%ebp),%edx
  80342f:	89 50 04             	mov    %edx,0x4(%eax)
  803432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803435:	8b 55 08             	mov    0x8(%ebp),%edx
  803438:	89 10                	mov    %edx,(%eax)
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803440:	89 50 04             	mov    %edx,0x4(%eax)
  803443:	8b 45 08             	mov    0x8(%ebp),%eax
  803446:	8b 00                	mov    (%eax),%eax
  803448:	85 c0                	test   %eax,%eax
  80344a:	75 08                	jne    803454 <insert_sorted_with_merge_freeList+0x703>
  80344c:	8b 45 08             	mov    0x8(%ebp),%eax
  80344f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803454:	a1 44 51 80 00       	mov    0x805144,%eax
  803459:	40                   	inc    %eax
  80345a:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80345f:	eb 39                	jmp    80349a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803461:	a1 40 51 80 00       	mov    0x805140,%eax
  803466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803469:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346d:	74 07                	je     803476 <insert_sorted_with_merge_freeList+0x725>
  80346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803472:	8b 00                	mov    (%eax),%eax
  803474:	eb 05                	jmp    80347b <insert_sorted_with_merge_freeList+0x72a>
  803476:	b8 00 00 00 00       	mov    $0x0,%eax
  80347b:	a3 40 51 80 00       	mov    %eax,0x805140
  803480:	a1 40 51 80 00       	mov    0x805140,%eax
  803485:	85 c0                	test   %eax,%eax
  803487:	0f 85 c7 fb ff ff    	jne    803054 <insert_sorted_with_merge_freeList+0x303>
  80348d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803491:	0f 85 bd fb ff ff    	jne    803054 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803497:	eb 01                	jmp    80349a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803499:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80349a:	90                   	nop
  80349b:	c9                   	leave  
  80349c:	c3                   	ret    
  80349d:	66 90                	xchg   %ax,%ax
  80349f:	90                   	nop

008034a0 <__udivdi3>:
  8034a0:	55                   	push   %ebp
  8034a1:	57                   	push   %edi
  8034a2:	56                   	push   %esi
  8034a3:	53                   	push   %ebx
  8034a4:	83 ec 1c             	sub    $0x1c,%esp
  8034a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034b7:	89 ca                	mov    %ecx,%edx
  8034b9:	89 f8                	mov    %edi,%eax
  8034bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034bf:	85 f6                	test   %esi,%esi
  8034c1:	75 2d                	jne    8034f0 <__udivdi3+0x50>
  8034c3:	39 cf                	cmp    %ecx,%edi
  8034c5:	77 65                	ja     80352c <__udivdi3+0x8c>
  8034c7:	89 fd                	mov    %edi,%ebp
  8034c9:	85 ff                	test   %edi,%edi
  8034cb:	75 0b                	jne    8034d8 <__udivdi3+0x38>
  8034cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8034d2:	31 d2                	xor    %edx,%edx
  8034d4:	f7 f7                	div    %edi
  8034d6:	89 c5                	mov    %eax,%ebp
  8034d8:	31 d2                	xor    %edx,%edx
  8034da:	89 c8                	mov    %ecx,%eax
  8034dc:	f7 f5                	div    %ebp
  8034de:	89 c1                	mov    %eax,%ecx
  8034e0:	89 d8                	mov    %ebx,%eax
  8034e2:	f7 f5                	div    %ebp
  8034e4:	89 cf                	mov    %ecx,%edi
  8034e6:	89 fa                	mov    %edi,%edx
  8034e8:	83 c4 1c             	add    $0x1c,%esp
  8034eb:	5b                   	pop    %ebx
  8034ec:	5e                   	pop    %esi
  8034ed:	5f                   	pop    %edi
  8034ee:	5d                   	pop    %ebp
  8034ef:	c3                   	ret    
  8034f0:	39 ce                	cmp    %ecx,%esi
  8034f2:	77 28                	ja     80351c <__udivdi3+0x7c>
  8034f4:	0f bd fe             	bsr    %esi,%edi
  8034f7:	83 f7 1f             	xor    $0x1f,%edi
  8034fa:	75 40                	jne    80353c <__udivdi3+0x9c>
  8034fc:	39 ce                	cmp    %ecx,%esi
  8034fe:	72 0a                	jb     80350a <__udivdi3+0x6a>
  803500:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803504:	0f 87 9e 00 00 00    	ja     8035a8 <__udivdi3+0x108>
  80350a:	b8 01 00 00 00       	mov    $0x1,%eax
  80350f:	89 fa                	mov    %edi,%edx
  803511:	83 c4 1c             	add    $0x1c,%esp
  803514:	5b                   	pop    %ebx
  803515:	5e                   	pop    %esi
  803516:	5f                   	pop    %edi
  803517:	5d                   	pop    %ebp
  803518:	c3                   	ret    
  803519:	8d 76 00             	lea    0x0(%esi),%esi
  80351c:	31 ff                	xor    %edi,%edi
  80351e:	31 c0                	xor    %eax,%eax
  803520:	89 fa                	mov    %edi,%edx
  803522:	83 c4 1c             	add    $0x1c,%esp
  803525:	5b                   	pop    %ebx
  803526:	5e                   	pop    %esi
  803527:	5f                   	pop    %edi
  803528:	5d                   	pop    %ebp
  803529:	c3                   	ret    
  80352a:	66 90                	xchg   %ax,%ax
  80352c:	89 d8                	mov    %ebx,%eax
  80352e:	f7 f7                	div    %edi
  803530:	31 ff                	xor    %edi,%edi
  803532:	89 fa                	mov    %edi,%edx
  803534:	83 c4 1c             	add    $0x1c,%esp
  803537:	5b                   	pop    %ebx
  803538:	5e                   	pop    %esi
  803539:	5f                   	pop    %edi
  80353a:	5d                   	pop    %ebp
  80353b:	c3                   	ret    
  80353c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803541:	89 eb                	mov    %ebp,%ebx
  803543:	29 fb                	sub    %edi,%ebx
  803545:	89 f9                	mov    %edi,%ecx
  803547:	d3 e6                	shl    %cl,%esi
  803549:	89 c5                	mov    %eax,%ebp
  80354b:	88 d9                	mov    %bl,%cl
  80354d:	d3 ed                	shr    %cl,%ebp
  80354f:	89 e9                	mov    %ebp,%ecx
  803551:	09 f1                	or     %esi,%ecx
  803553:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803557:	89 f9                	mov    %edi,%ecx
  803559:	d3 e0                	shl    %cl,%eax
  80355b:	89 c5                	mov    %eax,%ebp
  80355d:	89 d6                	mov    %edx,%esi
  80355f:	88 d9                	mov    %bl,%cl
  803561:	d3 ee                	shr    %cl,%esi
  803563:	89 f9                	mov    %edi,%ecx
  803565:	d3 e2                	shl    %cl,%edx
  803567:	8b 44 24 08          	mov    0x8(%esp),%eax
  80356b:	88 d9                	mov    %bl,%cl
  80356d:	d3 e8                	shr    %cl,%eax
  80356f:	09 c2                	or     %eax,%edx
  803571:	89 d0                	mov    %edx,%eax
  803573:	89 f2                	mov    %esi,%edx
  803575:	f7 74 24 0c          	divl   0xc(%esp)
  803579:	89 d6                	mov    %edx,%esi
  80357b:	89 c3                	mov    %eax,%ebx
  80357d:	f7 e5                	mul    %ebp
  80357f:	39 d6                	cmp    %edx,%esi
  803581:	72 19                	jb     80359c <__udivdi3+0xfc>
  803583:	74 0b                	je     803590 <__udivdi3+0xf0>
  803585:	89 d8                	mov    %ebx,%eax
  803587:	31 ff                	xor    %edi,%edi
  803589:	e9 58 ff ff ff       	jmp    8034e6 <__udivdi3+0x46>
  80358e:	66 90                	xchg   %ax,%ax
  803590:	8b 54 24 08          	mov    0x8(%esp),%edx
  803594:	89 f9                	mov    %edi,%ecx
  803596:	d3 e2                	shl    %cl,%edx
  803598:	39 c2                	cmp    %eax,%edx
  80359a:	73 e9                	jae    803585 <__udivdi3+0xe5>
  80359c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80359f:	31 ff                	xor    %edi,%edi
  8035a1:	e9 40 ff ff ff       	jmp    8034e6 <__udivdi3+0x46>
  8035a6:	66 90                	xchg   %ax,%ax
  8035a8:	31 c0                	xor    %eax,%eax
  8035aa:	e9 37 ff ff ff       	jmp    8034e6 <__udivdi3+0x46>
  8035af:	90                   	nop

008035b0 <__umoddi3>:
  8035b0:	55                   	push   %ebp
  8035b1:	57                   	push   %edi
  8035b2:	56                   	push   %esi
  8035b3:	53                   	push   %ebx
  8035b4:	83 ec 1c             	sub    $0x1c,%esp
  8035b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035cf:	89 f3                	mov    %esi,%ebx
  8035d1:	89 fa                	mov    %edi,%edx
  8035d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035d7:	89 34 24             	mov    %esi,(%esp)
  8035da:	85 c0                	test   %eax,%eax
  8035dc:	75 1a                	jne    8035f8 <__umoddi3+0x48>
  8035de:	39 f7                	cmp    %esi,%edi
  8035e0:	0f 86 a2 00 00 00    	jbe    803688 <__umoddi3+0xd8>
  8035e6:	89 c8                	mov    %ecx,%eax
  8035e8:	89 f2                	mov    %esi,%edx
  8035ea:	f7 f7                	div    %edi
  8035ec:	89 d0                	mov    %edx,%eax
  8035ee:	31 d2                	xor    %edx,%edx
  8035f0:	83 c4 1c             	add    $0x1c,%esp
  8035f3:	5b                   	pop    %ebx
  8035f4:	5e                   	pop    %esi
  8035f5:	5f                   	pop    %edi
  8035f6:	5d                   	pop    %ebp
  8035f7:	c3                   	ret    
  8035f8:	39 f0                	cmp    %esi,%eax
  8035fa:	0f 87 ac 00 00 00    	ja     8036ac <__umoddi3+0xfc>
  803600:	0f bd e8             	bsr    %eax,%ebp
  803603:	83 f5 1f             	xor    $0x1f,%ebp
  803606:	0f 84 ac 00 00 00    	je     8036b8 <__umoddi3+0x108>
  80360c:	bf 20 00 00 00       	mov    $0x20,%edi
  803611:	29 ef                	sub    %ebp,%edi
  803613:	89 fe                	mov    %edi,%esi
  803615:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803619:	89 e9                	mov    %ebp,%ecx
  80361b:	d3 e0                	shl    %cl,%eax
  80361d:	89 d7                	mov    %edx,%edi
  80361f:	89 f1                	mov    %esi,%ecx
  803621:	d3 ef                	shr    %cl,%edi
  803623:	09 c7                	or     %eax,%edi
  803625:	89 e9                	mov    %ebp,%ecx
  803627:	d3 e2                	shl    %cl,%edx
  803629:	89 14 24             	mov    %edx,(%esp)
  80362c:	89 d8                	mov    %ebx,%eax
  80362e:	d3 e0                	shl    %cl,%eax
  803630:	89 c2                	mov    %eax,%edx
  803632:	8b 44 24 08          	mov    0x8(%esp),%eax
  803636:	d3 e0                	shl    %cl,%eax
  803638:	89 44 24 04          	mov    %eax,0x4(%esp)
  80363c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803640:	89 f1                	mov    %esi,%ecx
  803642:	d3 e8                	shr    %cl,%eax
  803644:	09 d0                	or     %edx,%eax
  803646:	d3 eb                	shr    %cl,%ebx
  803648:	89 da                	mov    %ebx,%edx
  80364a:	f7 f7                	div    %edi
  80364c:	89 d3                	mov    %edx,%ebx
  80364e:	f7 24 24             	mull   (%esp)
  803651:	89 c6                	mov    %eax,%esi
  803653:	89 d1                	mov    %edx,%ecx
  803655:	39 d3                	cmp    %edx,%ebx
  803657:	0f 82 87 00 00 00    	jb     8036e4 <__umoddi3+0x134>
  80365d:	0f 84 91 00 00 00    	je     8036f4 <__umoddi3+0x144>
  803663:	8b 54 24 04          	mov    0x4(%esp),%edx
  803667:	29 f2                	sub    %esi,%edx
  803669:	19 cb                	sbb    %ecx,%ebx
  80366b:	89 d8                	mov    %ebx,%eax
  80366d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803671:	d3 e0                	shl    %cl,%eax
  803673:	89 e9                	mov    %ebp,%ecx
  803675:	d3 ea                	shr    %cl,%edx
  803677:	09 d0                	or     %edx,%eax
  803679:	89 e9                	mov    %ebp,%ecx
  80367b:	d3 eb                	shr    %cl,%ebx
  80367d:	89 da                	mov    %ebx,%edx
  80367f:	83 c4 1c             	add    $0x1c,%esp
  803682:	5b                   	pop    %ebx
  803683:	5e                   	pop    %esi
  803684:	5f                   	pop    %edi
  803685:	5d                   	pop    %ebp
  803686:	c3                   	ret    
  803687:	90                   	nop
  803688:	89 fd                	mov    %edi,%ebp
  80368a:	85 ff                	test   %edi,%edi
  80368c:	75 0b                	jne    803699 <__umoddi3+0xe9>
  80368e:	b8 01 00 00 00       	mov    $0x1,%eax
  803693:	31 d2                	xor    %edx,%edx
  803695:	f7 f7                	div    %edi
  803697:	89 c5                	mov    %eax,%ebp
  803699:	89 f0                	mov    %esi,%eax
  80369b:	31 d2                	xor    %edx,%edx
  80369d:	f7 f5                	div    %ebp
  80369f:	89 c8                	mov    %ecx,%eax
  8036a1:	f7 f5                	div    %ebp
  8036a3:	89 d0                	mov    %edx,%eax
  8036a5:	e9 44 ff ff ff       	jmp    8035ee <__umoddi3+0x3e>
  8036aa:	66 90                	xchg   %ax,%ax
  8036ac:	89 c8                	mov    %ecx,%eax
  8036ae:	89 f2                	mov    %esi,%edx
  8036b0:	83 c4 1c             	add    $0x1c,%esp
  8036b3:	5b                   	pop    %ebx
  8036b4:	5e                   	pop    %esi
  8036b5:	5f                   	pop    %edi
  8036b6:	5d                   	pop    %ebp
  8036b7:	c3                   	ret    
  8036b8:	3b 04 24             	cmp    (%esp),%eax
  8036bb:	72 06                	jb     8036c3 <__umoddi3+0x113>
  8036bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036c1:	77 0f                	ja     8036d2 <__umoddi3+0x122>
  8036c3:	89 f2                	mov    %esi,%edx
  8036c5:	29 f9                	sub    %edi,%ecx
  8036c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036cb:	89 14 24             	mov    %edx,(%esp)
  8036ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036d6:	8b 14 24             	mov    (%esp),%edx
  8036d9:	83 c4 1c             	add    $0x1c,%esp
  8036dc:	5b                   	pop    %ebx
  8036dd:	5e                   	pop    %esi
  8036de:	5f                   	pop    %edi
  8036df:	5d                   	pop    %ebp
  8036e0:	c3                   	ret    
  8036e1:	8d 76 00             	lea    0x0(%esi),%esi
  8036e4:	2b 04 24             	sub    (%esp),%eax
  8036e7:	19 fa                	sbb    %edi,%edx
  8036e9:	89 d1                	mov    %edx,%ecx
  8036eb:	89 c6                	mov    %eax,%esi
  8036ed:	e9 71 ff ff ff       	jmp    803663 <__umoddi3+0xb3>
  8036f2:	66 90                	xchg   %ax,%ax
  8036f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036f8:	72 ea                	jb     8036e4 <__umoddi3+0x134>
  8036fa:	89 d9                	mov    %ebx,%ecx
  8036fc:	e9 62 ff ff ff       	jmp    803663 <__umoddi3+0xb3>
