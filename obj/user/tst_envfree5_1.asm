
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
  800045:	68 60 36 80 00       	push   $0x803660
  80004a:	e8 04 15 00 00       	call   801553 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 c2 17 00 00       	call   801825 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 5a 18 00 00       	call   8018c5 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 70 36 80 00       	push   $0x803670
  800079:	e8 b8 04 00 00       	call   800536 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 a3 36 80 00       	push   $0x8036a3
  800099:	e8 f9 19 00 00       	call   801a97 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 06 1a 00 00       	call   801ab5 <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 63 17 00 00       	call   801825 <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 ac 36 80 00       	push   $0x8036ac
  8000cb:	e8 66 04 00 00       	call   800536 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 f3 19 00 00       	call   801ad1 <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 3f 17 00 00       	call   801825 <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 d7 17 00 00       	call   8018c5 <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 e0 36 80 00       	push   $0x8036e0
  800104:	e8 2d 04 00 00       	call   800536 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 30 37 80 00       	push   $0x803730
  800114:	6a 1e                	push   $0x1e
  800116:	68 66 37 80 00       	push   $0x803766
  80011b:	e8 62 01 00 00       	call   800282 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 7c 37 80 00       	push   $0x80377c
  80012b:	e8 06 04 00 00       	call   800536 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 dc 37 80 00       	push   $0x8037dc
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
  80014c:	e8 b4 19 00 00       	call   801b05 <sys_getenvindex>
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
  8001b7:	e8 56 17 00 00       	call   801912 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 40 38 80 00       	push   $0x803840
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
  8001e7:	68 68 38 80 00       	push   $0x803868
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
  800218:	68 90 38 80 00       	push   $0x803890
  80021d:	e8 14 03 00 00       	call   800536 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 50 80 00       	mov    0x805020,%eax
  80022a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 e8 38 80 00       	push   $0x8038e8
  800239:	e8 f8 02 00 00       	call   800536 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 40 38 80 00       	push   $0x803840
  800249:	e8 e8 02 00 00       	call   800536 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800251:	e8 d6 16 00 00       	call   80192c <sys_enable_interrupt>

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
  800269:	e8 63 18 00 00       	call   801ad1 <sys_destroy_env>
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
  80027a:	e8 b8 18 00 00       	call   801b37 <sys_exit_env>
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
  8002a3:	68 fc 38 80 00       	push   $0x8038fc
  8002a8:	e8 89 02 00 00       	call   800536 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 50 80 00       	mov    0x805000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 01 39 80 00       	push   $0x803901
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
  8002e0:	68 1d 39 80 00       	push   $0x80391d
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
  80030c:	68 20 39 80 00       	push   $0x803920
  800311:	6a 26                	push   $0x26
  800313:	68 6c 39 80 00       	push   $0x80396c
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
  8003de:	68 78 39 80 00       	push   $0x803978
  8003e3:	6a 3a                	push   $0x3a
  8003e5:	68 6c 39 80 00       	push   $0x80396c
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
  80044e:	68 cc 39 80 00       	push   $0x8039cc
  800453:	6a 44                	push   $0x44
  800455:	68 6c 39 80 00       	push   $0x80396c
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
  8004a8:	e8 b7 12 00 00       	call   801764 <sys_cputs>
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
  80051f:	e8 40 12 00 00       	call   801764 <sys_cputs>
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
  800569:	e8 a4 13 00 00       	call   801912 <sys_disable_interrupt>
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
  800589:	e8 9e 13 00 00       	call   80192c <sys_enable_interrupt>
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
  8005d3:	e8 10 2e 00 00       	call   8033e8 <__udivdi3>
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
  800623:	e8 d0 2e 00 00       	call   8034f8 <__umoddi3>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	05 34 3c 80 00       	add    $0x803c34,%eax
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
  80077e:	8b 04 85 58 3c 80 00 	mov    0x803c58(,%eax,4),%eax
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
  80085f:	8b 34 9d a0 3a 80 00 	mov    0x803aa0(,%ebx,4),%esi
  800866:	85 f6                	test   %esi,%esi
  800868:	75 19                	jne    800883 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086a:	53                   	push   %ebx
  80086b:	68 45 3c 80 00       	push   $0x803c45
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
  800884:	68 4e 3c 80 00       	push   $0x803c4e
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
  8008b1:	be 51 3c 80 00       	mov    $0x803c51,%esi
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
  8012d7:	68 b0 3d 80 00       	push   $0x803db0
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
  8013a7:	e8 fc 04 00 00       	call   8018a8 <sys_allocate_chunk>
  8013ac:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013af:	a1 20 51 80 00       	mov    0x805120,%eax
  8013b4:	83 ec 0c             	sub    $0xc,%esp
  8013b7:	50                   	push   %eax
  8013b8:	e8 71 0b 00 00       	call   801f2e <initialize_MemBlocksList>
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
  8013e5:	68 d5 3d 80 00       	push   $0x803dd5
  8013ea:	6a 33                	push   $0x33
  8013ec:	68 f3 3d 80 00       	push   $0x803df3
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
  801464:	68 00 3e 80 00       	push   $0x803e00
  801469:	6a 34                	push   $0x34
  80146b:	68 f3 3d 80 00       	push   $0x803df3
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
  8014fc:	e8 75 07 00 00       	call   801c76 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801501:	85 c0                	test   %eax,%eax
  801503:	74 11                	je     801516 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801505:	83 ec 0c             	sub    $0xc,%esp
  801508:	ff 75 e8             	pushl  -0x18(%ebp)
  80150b:	e8 e0 0d 00 00       	call   8022f0 <alloc_block_FF>
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
  801522:	e8 3c 0b 00 00       	call   802063 <insert_sorted_allocList>
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
  80153c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80153f:	83 ec 04             	sub    $0x4,%esp
  801542:	68 24 3e 80 00       	push   $0x803e24
  801547:	6a 6f                	push   $0x6f
  801549:	68 f3 3d 80 00       	push   $0x803df3
  80154e:	e8 2f ed ff ff       	call   800282 <_panic>

00801553 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 38             	sub    $0x38,%esp
  801559:	8b 45 10             	mov    0x10(%ebp),%eax
  80155c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80155f:	e8 5c fd ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801564:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801568:	75 0a                	jne    801574 <smalloc+0x21>
  80156a:	b8 00 00 00 00       	mov    $0x0,%eax
  80156f:	e9 8b 00 00 00       	jmp    8015ff <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801574:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801581:	01 d0                	add    %edx,%eax
  801583:	48                   	dec    %eax
  801584:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158a:	ba 00 00 00 00       	mov    $0x0,%edx
  80158f:	f7 75 f0             	divl   -0x10(%ebp)
  801592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801595:	29 d0                	sub    %edx,%eax
  801597:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80159a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015a1:	e8 d0 06 00 00       	call   801c76 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	74 11                	je     8015bb <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8015aa:	83 ec 0c             	sub    $0xc,%esp
  8015ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8015b0:	e8 3b 0d 00 00       	call   8022f0 <alloc_block_FF>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8015bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015bf:	74 39                	je     8015fa <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c4:	8b 40 08             	mov    0x8(%eax),%eax
  8015c7:	89 c2                	mov    %eax,%edx
  8015c9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015cd:	52                   	push   %edx
  8015ce:	50                   	push   %eax
  8015cf:	ff 75 0c             	pushl  0xc(%ebp)
  8015d2:	ff 75 08             	pushl  0x8(%ebp)
  8015d5:	e8 21 04 00 00       	call   8019fb <sys_createSharedObject>
  8015da:	83 c4 10             	add    $0x10,%esp
  8015dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015e0:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015e4:	74 14                	je     8015fa <smalloc+0xa7>
  8015e6:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015ea:	74 0e                	je     8015fa <smalloc+0xa7>
  8015ec:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015f0:	74 08                	je     8015fa <smalloc+0xa7>
			return (void*) mem_block->sva;
  8015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f5:	8b 40 08             	mov    0x8(%eax),%eax
  8015f8:	eb 05                	jmp    8015ff <smalloc+0xac>
	}
	return NULL;
  8015fa:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801607:	e8 b4 fc ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80160c:	83 ec 08             	sub    $0x8,%esp
  80160f:	ff 75 0c             	pushl  0xc(%ebp)
  801612:	ff 75 08             	pushl  0x8(%ebp)
  801615:	e8 0b 04 00 00       	call   801a25 <sys_getSizeOfSharedObject>
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801620:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801624:	74 76                	je     80169c <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801626:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80162d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801630:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801633:	01 d0                	add    %edx,%eax
  801635:	48                   	dec    %eax
  801636:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801639:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80163c:	ba 00 00 00 00       	mov    $0x0,%edx
  801641:	f7 75 ec             	divl   -0x14(%ebp)
  801644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801647:	29 d0                	sub    %edx,%eax
  801649:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80164c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801653:	e8 1e 06 00 00       	call   801c76 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801658:	85 c0                	test   %eax,%eax
  80165a:	74 11                	je     80166d <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80165c:	83 ec 0c             	sub    $0xc,%esp
  80165f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801662:	e8 89 0c 00 00       	call   8022f0 <alloc_block_FF>
  801667:	83 c4 10             	add    $0x10,%esp
  80166a:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80166d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801671:	74 29                	je     80169c <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801676:	8b 40 08             	mov    0x8(%eax),%eax
  801679:	83 ec 04             	sub    $0x4,%esp
  80167c:	50                   	push   %eax
  80167d:	ff 75 0c             	pushl  0xc(%ebp)
  801680:	ff 75 08             	pushl  0x8(%ebp)
  801683:	e8 ba 03 00 00       	call   801a42 <sys_getSharedObject>
  801688:	83 c4 10             	add    $0x10,%esp
  80168b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80168e:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801692:	74 08                	je     80169c <sget+0x9b>
				return (void *)mem_block->sva;
  801694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801697:	8b 40 08             	mov    0x8(%eax),%eax
  80169a:	eb 05                	jmp    8016a1 <sget+0xa0>
		}
	}
	return NULL;
  80169c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a9:	e8 12 fc ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	68 48 3e 80 00       	push   $0x803e48
  8016b6:	68 f1 00 00 00       	push   $0xf1
  8016bb:	68 f3 3d 80 00       	push   $0x803df3
  8016c0:	e8 bd eb ff ff       	call   800282 <_panic>

008016c5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	68 70 3e 80 00       	push   $0x803e70
  8016d3:	68 05 01 00 00       	push   $0x105
  8016d8:	68 f3 3d 80 00       	push   $0x803df3
  8016dd:	e8 a0 eb ff ff       	call   800282 <_panic>

008016e2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	68 94 3e 80 00       	push   $0x803e94
  8016f0:	68 10 01 00 00       	push   $0x110
  8016f5:	68 f3 3d 80 00       	push   $0x803df3
  8016fa:	e8 83 eb ff ff       	call   800282 <_panic>

008016ff <shrink>:

}
void shrink(uint32 newSize)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	68 94 3e 80 00       	push   $0x803e94
  80170d:	68 15 01 00 00       	push   $0x115
  801712:	68 f3 3d 80 00       	push   $0x803df3
  801717:	e8 66 eb ff ff       	call   800282 <_panic>

0080171c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801722:	83 ec 04             	sub    $0x4,%esp
  801725:	68 94 3e 80 00       	push   $0x803e94
  80172a:	68 1a 01 00 00       	push   $0x11a
  80172f:	68 f3 3d 80 00       	push   $0x803df3
  801734:	e8 49 eb ff ff       	call   800282 <_panic>

00801739 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	57                   	push   %edi
  80173d:	56                   	push   %esi
  80173e:	53                   	push   %ebx
  80173f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	8b 55 0c             	mov    0xc(%ebp),%edx
  801748:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80174b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80174e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801751:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801754:	cd 30                	int    $0x30
  801756:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801759:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	5b                   	pop    %ebx
  801760:	5e                   	pop    %esi
  801761:	5f                   	pop    %edi
  801762:	5d                   	pop    %ebp
  801763:	c3                   	ret    

00801764 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	83 ec 04             	sub    $0x4,%esp
  80176a:	8b 45 10             	mov    0x10(%ebp),%eax
  80176d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801770:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	52                   	push   %edx
  80177c:	ff 75 0c             	pushl  0xc(%ebp)
  80177f:	50                   	push   %eax
  801780:	6a 00                	push   $0x0
  801782:	e8 b2 ff ff ff       	call   801739 <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	90                   	nop
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <sys_cgetc>:

int
sys_cgetc(void)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 01                	push   $0x1
  80179c:	e8 98 ff ff ff       	call   801739 <syscall>
  8017a1:	83 c4 18             	add    $0x18,%esp
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	52                   	push   %edx
  8017b6:	50                   	push   %eax
  8017b7:	6a 05                	push   $0x5
  8017b9:	e8 7b ff ff ff       	call   801739 <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	56                   	push   %esi
  8017c7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017c8:	8b 75 18             	mov    0x18(%ebp),%esi
  8017cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	56                   	push   %esi
  8017d8:	53                   	push   %ebx
  8017d9:	51                   	push   %ecx
  8017da:	52                   	push   %edx
  8017db:	50                   	push   %eax
  8017dc:	6a 06                	push   $0x6
  8017de:	e8 56 ff ff ff       	call   801739 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e9:	5b                   	pop    %ebx
  8017ea:	5e                   	pop    %esi
  8017eb:	5d                   	pop    %ebp
  8017ec:	c3                   	ret    

008017ed <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	52                   	push   %edx
  8017fd:	50                   	push   %eax
  8017fe:	6a 07                	push   $0x7
  801800:	e8 34 ff ff ff       	call   801739 <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	6a 08                	push   $0x8
  80181b:	e8 19 ff ff ff       	call   801739 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 09                	push   $0x9
  801834:	e8 00 ff ff ff       	call   801739 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 0a                	push   $0xa
  80184d:	e8 e7 fe ff ff       	call   801739 <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 0b                	push   $0xb
  801866:	e8 ce fe ff ff       	call   801739 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	ff 75 08             	pushl  0x8(%ebp)
  80187f:	6a 0f                	push   $0xf
  801881:	e8 b3 fe ff ff       	call   801739 <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
	return;
  801889:	90                   	nop
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	ff 75 0c             	pushl  0xc(%ebp)
  801898:	ff 75 08             	pushl  0x8(%ebp)
  80189b:	6a 10                	push   $0x10
  80189d:	e8 97 fe ff ff       	call   801739 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a5:	90                   	nop
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	ff 75 10             	pushl  0x10(%ebp)
  8018b2:	ff 75 0c             	pushl  0xc(%ebp)
  8018b5:	ff 75 08             	pushl  0x8(%ebp)
  8018b8:	6a 11                	push   $0x11
  8018ba:	e8 7a fe ff ff       	call   801739 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c2:	90                   	nop
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 0c                	push   $0xc
  8018d4:	e8 60 fe ff ff       	call   801739 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	ff 75 08             	pushl  0x8(%ebp)
  8018ec:	6a 0d                	push   $0xd
  8018ee:	e8 46 fe ff ff       	call   801739 <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 0e                	push   $0xe
  801907:	e8 2d fe ff ff       	call   801739 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	90                   	nop
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 13                	push   $0x13
  801921:	e8 13 fe ff ff       	call   801739 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	90                   	nop
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 14                	push   $0x14
  80193b:	e8 f9 fd ff ff       	call   801739 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	90                   	nop
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_cputc>:


void
sys_cputc(const char c)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801952:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	50                   	push   %eax
  80195f:	6a 15                	push   $0x15
  801961:	e8 d3 fd ff ff       	call   801739 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	90                   	nop
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 16                	push   $0x16
  80197b:	e8 b9 fd ff ff       	call   801739 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	90                   	nop
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	ff 75 0c             	pushl  0xc(%ebp)
  801995:	50                   	push   %eax
  801996:	6a 17                	push   $0x17
  801998:	e8 9c fd ff ff       	call   801739 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	52                   	push   %edx
  8019b2:	50                   	push   %eax
  8019b3:	6a 1a                	push   $0x1a
  8019b5:	e8 7f fd ff ff       	call   801739 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	52                   	push   %edx
  8019cf:	50                   	push   %eax
  8019d0:	6a 18                	push   $0x18
  8019d2:	e8 62 fd ff ff       	call   801739 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	90                   	nop
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	52                   	push   %edx
  8019ed:	50                   	push   %eax
  8019ee:	6a 19                	push   $0x19
  8019f0:	e8 44 fd ff ff       	call   801739 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	90                   	nop
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 04             	sub    $0x4,%esp
  801a01:	8b 45 10             	mov    0x10(%ebp),%eax
  801a04:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a07:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a0a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	6a 00                	push   $0x0
  801a13:	51                   	push   %ecx
  801a14:	52                   	push   %edx
  801a15:	ff 75 0c             	pushl  0xc(%ebp)
  801a18:	50                   	push   %eax
  801a19:	6a 1b                	push   $0x1b
  801a1b:	e8 19 fd ff ff       	call   801739 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	52                   	push   %edx
  801a35:	50                   	push   %eax
  801a36:	6a 1c                	push   $0x1c
  801a38:	e8 fc fc ff ff       	call   801739 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a45:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	51                   	push   %ecx
  801a53:	52                   	push   %edx
  801a54:	50                   	push   %eax
  801a55:	6a 1d                	push   $0x1d
  801a57:	e8 dd fc ff ff       	call   801739 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	52                   	push   %edx
  801a71:	50                   	push   %eax
  801a72:	6a 1e                	push   $0x1e
  801a74:	e8 c0 fc ff ff       	call   801739 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 1f                	push   $0x1f
  801a8d:	e8 a7 fc ff ff       	call   801739 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	ff 75 14             	pushl  0x14(%ebp)
  801aa2:	ff 75 10             	pushl  0x10(%ebp)
  801aa5:	ff 75 0c             	pushl  0xc(%ebp)
  801aa8:	50                   	push   %eax
  801aa9:	6a 20                	push   $0x20
  801aab:	e8 89 fc ff ff       	call   801739 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	50                   	push   %eax
  801ac4:	6a 21                	push   $0x21
  801ac6:	e8 6e fc ff ff       	call   801739 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	90                   	nop
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	50                   	push   %eax
  801ae0:	6a 22                	push   $0x22
  801ae2:	e8 52 fc ff ff       	call   801739 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 02                	push   $0x2
  801afb:	e8 39 fc ff ff       	call   801739 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 03                	push   $0x3
  801b14:	e8 20 fc ff ff       	call   801739 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 04                	push   $0x4
  801b2d:	e8 07 fc ff ff       	call   801739 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_exit_env>:


void sys_exit_env(void)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 23                	push   $0x23
  801b46:	e8 ee fb ff ff       	call   801739 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	90                   	nop
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b57:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b5a:	8d 50 04             	lea    0x4(%eax),%edx
  801b5d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	52                   	push   %edx
  801b67:	50                   	push   %eax
  801b68:	6a 24                	push   $0x24
  801b6a:	e8 ca fb ff ff       	call   801739 <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
	return result;
  801b72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b75:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b7b:	89 01                	mov    %eax,(%ecx)
  801b7d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	c9                   	leave  
  801b84:	c2 04 00             	ret    $0x4

00801b87 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	ff 75 10             	pushl  0x10(%ebp)
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	ff 75 08             	pushl  0x8(%ebp)
  801b97:	6a 12                	push   $0x12
  801b99:	e8 9b fb ff ff       	call   801739 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba1:	90                   	nop
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 25                	push   $0x25
  801bb3:	e8 81 fb ff ff       	call   801739 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 04             	sub    $0x4,%esp
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bc9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	50                   	push   %eax
  801bd6:	6a 26                	push   $0x26
  801bd8:	e8 5c fb ff ff       	call   801739 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801be0:	90                   	nop
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <rsttst>:
void rsttst()
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 28                	push   $0x28
  801bf2:	e8 42 fb ff ff       	call   801739 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfa:	90                   	nop
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	83 ec 04             	sub    $0x4,%esp
  801c03:	8b 45 14             	mov    0x14(%ebp),%eax
  801c06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c09:	8b 55 18             	mov    0x18(%ebp),%edx
  801c0c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c10:	52                   	push   %edx
  801c11:	50                   	push   %eax
  801c12:	ff 75 10             	pushl  0x10(%ebp)
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	ff 75 08             	pushl  0x8(%ebp)
  801c1b:	6a 27                	push   $0x27
  801c1d:	e8 17 fb ff ff       	call   801739 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
	return ;
  801c25:	90                   	nop
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <chktst>:
void chktst(uint32 n)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	ff 75 08             	pushl  0x8(%ebp)
  801c36:	6a 29                	push   $0x29
  801c38:	e8 fc fa ff ff       	call   801739 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c40:	90                   	nop
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <inctst>:

void inctst()
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 2a                	push   $0x2a
  801c52:	e8 e2 fa ff ff       	call   801739 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5a:	90                   	nop
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <gettst>:
uint32 gettst()
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 2b                	push   $0x2b
  801c6c:	e8 c8 fa ff ff       	call   801739 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 2c                	push   $0x2c
  801c88:	e8 ac fa ff ff       	call   801739 <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
  801c90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c93:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c97:	75 07                	jne    801ca0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c99:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9e:	eb 05                	jmp    801ca5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 2c                	push   $0x2c
  801cb9:	e8 7b fa ff ff       	call   801739 <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
  801cc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cc4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cc8:	75 07                	jne    801cd1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cca:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccf:	eb 05                	jmp    801cd6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 2c                	push   $0x2c
  801cea:	e8 4a fa ff ff       	call   801739 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
  801cf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cf5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cf9:	75 07                	jne    801d02 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cfb:	b8 01 00 00 00       	mov    $0x1,%eax
  801d00:	eb 05                	jmp    801d07 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d02:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 2c                	push   $0x2c
  801d1b:	e8 19 fa ff ff       	call   801739 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
  801d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d26:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d2a:	75 07                	jne    801d33 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d31:	eb 05                	jmp    801d38 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	ff 75 08             	pushl  0x8(%ebp)
  801d48:	6a 2d                	push   $0x2d
  801d4a:	e8 ea f9 ff ff       	call   801739 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d52:	90                   	nop
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d59:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d5c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	6a 00                	push   $0x0
  801d67:	53                   	push   %ebx
  801d68:	51                   	push   %ecx
  801d69:	52                   	push   %edx
  801d6a:	50                   	push   %eax
  801d6b:	6a 2e                	push   $0x2e
  801d6d:	e8 c7 f9 ff ff       	call   801739 <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
}
  801d75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	6a 2f                	push   $0x2f
  801d8d:	e8 a7 f9 ff ff       	call   801739 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d9d:	83 ec 0c             	sub    $0xc,%esp
  801da0:	68 a4 3e 80 00       	push   $0x803ea4
  801da5:	e8 8c e7 ff ff       	call   800536 <cprintf>
  801daa:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801dad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801db4:	83 ec 0c             	sub    $0xc,%esp
  801db7:	68 d0 3e 80 00       	push   $0x803ed0
  801dbc:	e8 75 e7 ff ff       	call   800536 <cprintf>
  801dc1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801dc4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dc8:	a1 38 51 80 00       	mov    0x805138,%eax
  801dcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd0:	eb 56                	jmp    801e28 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dd6:	74 1c                	je     801df4 <print_mem_block_lists+0x5d>
  801dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddb:	8b 50 08             	mov    0x8(%eax),%edx
  801dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de1:	8b 48 08             	mov    0x8(%eax),%ecx
  801de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de7:	8b 40 0c             	mov    0xc(%eax),%eax
  801dea:	01 c8                	add    %ecx,%eax
  801dec:	39 c2                	cmp    %eax,%edx
  801dee:	73 04                	jae    801df4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801df0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df7:	8b 50 08             	mov    0x8(%eax),%edx
  801dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfd:	8b 40 0c             	mov    0xc(%eax),%eax
  801e00:	01 c2                	add    %eax,%edx
  801e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e05:	8b 40 08             	mov    0x8(%eax),%eax
  801e08:	83 ec 04             	sub    $0x4,%esp
  801e0b:	52                   	push   %edx
  801e0c:	50                   	push   %eax
  801e0d:	68 e5 3e 80 00       	push   $0x803ee5
  801e12:	e8 1f e7 ff ff       	call   800536 <cprintf>
  801e17:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e20:	a1 40 51 80 00       	mov    0x805140,%eax
  801e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e2c:	74 07                	je     801e35 <print_mem_block_lists+0x9e>
  801e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e31:	8b 00                	mov    (%eax),%eax
  801e33:	eb 05                	jmp    801e3a <print_mem_block_lists+0xa3>
  801e35:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3a:	a3 40 51 80 00       	mov    %eax,0x805140
  801e3f:	a1 40 51 80 00       	mov    0x805140,%eax
  801e44:	85 c0                	test   %eax,%eax
  801e46:	75 8a                	jne    801dd2 <print_mem_block_lists+0x3b>
  801e48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e4c:	75 84                	jne    801dd2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e4e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e52:	75 10                	jne    801e64 <print_mem_block_lists+0xcd>
  801e54:	83 ec 0c             	sub    $0xc,%esp
  801e57:	68 f4 3e 80 00       	push   $0x803ef4
  801e5c:	e8 d5 e6 ff ff       	call   800536 <cprintf>
  801e61:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e6b:	83 ec 0c             	sub    $0xc,%esp
  801e6e:	68 18 3f 80 00       	push   $0x803f18
  801e73:	e8 be e6 ff ff       	call   800536 <cprintf>
  801e78:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e7b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e7f:	a1 40 50 80 00       	mov    0x805040,%eax
  801e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e87:	eb 56                	jmp    801edf <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e8d:	74 1c                	je     801eab <print_mem_block_lists+0x114>
  801e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e92:	8b 50 08             	mov    0x8(%eax),%edx
  801e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e98:	8b 48 08             	mov    0x8(%eax),%ecx
  801e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea1:	01 c8                	add    %ecx,%eax
  801ea3:	39 c2                	cmp    %eax,%edx
  801ea5:	73 04                	jae    801eab <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ea7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eae:	8b 50 08             	mov    0x8(%eax),%edx
  801eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb4:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb7:	01 c2                	add    %eax,%edx
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	8b 40 08             	mov    0x8(%eax),%eax
  801ebf:	83 ec 04             	sub    $0x4,%esp
  801ec2:	52                   	push   %edx
  801ec3:	50                   	push   %eax
  801ec4:	68 e5 3e 80 00       	push   $0x803ee5
  801ec9:	e8 68 e6 ff ff       	call   800536 <cprintf>
  801ece:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ed7:	a1 48 50 80 00       	mov    0x805048,%eax
  801edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801edf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee3:	74 07                	je     801eec <print_mem_block_lists+0x155>
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee8:	8b 00                	mov    (%eax),%eax
  801eea:	eb 05                	jmp    801ef1 <print_mem_block_lists+0x15a>
  801eec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef1:	a3 48 50 80 00       	mov    %eax,0x805048
  801ef6:	a1 48 50 80 00       	mov    0x805048,%eax
  801efb:	85 c0                	test   %eax,%eax
  801efd:	75 8a                	jne    801e89 <print_mem_block_lists+0xf2>
  801eff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f03:	75 84                	jne    801e89 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f05:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f09:	75 10                	jne    801f1b <print_mem_block_lists+0x184>
  801f0b:	83 ec 0c             	sub    $0xc,%esp
  801f0e:	68 30 3f 80 00       	push   $0x803f30
  801f13:	e8 1e e6 ff ff       	call   800536 <cprintf>
  801f18:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	68 a4 3e 80 00       	push   $0x803ea4
  801f23:	e8 0e e6 ff ff       	call   800536 <cprintf>
  801f28:	83 c4 10             	add    $0x10,%esp

}
  801f2b:	90                   	nop
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f34:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f3b:	00 00 00 
  801f3e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f45:	00 00 00 
  801f48:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f4f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f59:	e9 9e 00 00 00       	jmp    801ffc <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f5e:	a1 50 50 80 00       	mov    0x805050,%eax
  801f63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f66:	c1 e2 04             	shl    $0x4,%edx
  801f69:	01 d0                	add    %edx,%eax
  801f6b:	85 c0                	test   %eax,%eax
  801f6d:	75 14                	jne    801f83 <initialize_MemBlocksList+0x55>
  801f6f:	83 ec 04             	sub    $0x4,%esp
  801f72:	68 58 3f 80 00       	push   $0x803f58
  801f77:	6a 46                	push   $0x46
  801f79:	68 7b 3f 80 00       	push   $0x803f7b
  801f7e:	e8 ff e2 ff ff       	call   800282 <_panic>
  801f83:	a1 50 50 80 00       	mov    0x805050,%eax
  801f88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8b:	c1 e2 04             	shl    $0x4,%edx
  801f8e:	01 d0                	add    %edx,%eax
  801f90:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f96:	89 10                	mov    %edx,(%eax)
  801f98:	8b 00                	mov    (%eax),%eax
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	74 18                	je     801fb6 <initialize_MemBlocksList+0x88>
  801f9e:	a1 48 51 80 00       	mov    0x805148,%eax
  801fa3:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fa9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fac:	c1 e1 04             	shl    $0x4,%ecx
  801faf:	01 ca                	add    %ecx,%edx
  801fb1:	89 50 04             	mov    %edx,0x4(%eax)
  801fb4:	eb 12                	jmp    801fc8 <initialize_MemBlocksList+0x9a>
  801fb6:	a1 50 50 80 00       	mov    0x805050,%eax
  801fbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbe:	c1 e2 04             	shl    $0x4,%edx
  801fc1:	01 d0                	add    %edx,%eax
  801fc3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fc8:	a1 50 50 80 00       	mov    0x805050,%eax
  801fcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd0:	c1 e2 04             	shl    $0x4,%edx
  801fd3:	01 d0                	add    %edx,%eax
  801fd5:	a3 48 51 80 00       	mov    %eax,0x805148
  801fda:	a1 50 50 80 00       	mov    0x805050,%eax
  801fdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe2:	c1 e2 04             	shl    $0x4,%edx
  801fe5:	01 d0                	add    %edx,%eax
  801fe7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fee:	a1 54 51 80 00       	mov    0x805154,%eax
  801ff3:	40                   	inc    %eax
  801ff4:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ff9:	ff 45 f4             	incl   -0xc(%ebp)
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802002:	0f 82 56 ff ff ff    	jb     801f5e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802008:	90                   	nop
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	8b 00                	mov    (%eax),%eax
  802016:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802019:	eb 19                	jmp    802034 <find_block+0x29>
	{
		if(va==point->sva)
  80201b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80201e:	8b 40 08             	mov    0x8(%eax),%eax
  802021:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802024:	75 05                	jne    80202b <find_block+0x20>
		   return point;
  802026:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802029:	eb 36                	jmp    802061 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	8b 40 08             	mov    0x8(%eax),%eax
  802031:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802034:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802038:	74 07                	je     802041 <find_block+0x36>
  80203a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80203d:	8b 00                	mov    (%eax),%eax
  80203f:	eb 05                	jmp    802046 <find_block+0x3b>
  802041:	b8 00 00 00 00       	mov    $0x0,%eax
  802046:	8b 55 08             	mov    0x8(%ebp),%edx
  802049:	89 42 08             	mov    %eax,0x8(%edx)
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	8b 40 08             	mov    0x8(%eax),%eax
  802052:	85 c0                	test   %eax,%eax
  802054:	75 c5                	jne    80201b <find_block+0x10>
  802056:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80205a:	75 bf                	jne    80201b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802069:	a1 40 50 80 00       	mov    0x805040,%eax
  80206e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802071:	a1 44 50 80 00       	mov    0x805044,%eax
  802076:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80207f:	74 24                	je     8020a5 <insert_sorted_allocList+0x42>
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	8b 50 08             	mov    0x8(%eax),%edx
  802087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208a:	8b 40 08             	mov    0x8(%eax),%eax
  80208d:	39 c2                	cmp    %eax,%edx
  80208f:	76 14                	jbe    8020a5 <insert_sorted_allocList+0x42>
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	8b 50 08             	mov    0x8(%eax),%edx
  802097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209a:	8b 40 08             	mov    0x8(%eax),%eax
  80209d:	39 c2                	cmp    %eax,%edx
  80209f:	0f 82 60 01 00 00    	jb     802205 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020a9:	75 65                	jne    802110 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020af:	75 14                	jne    8020c5 <insert_sorted_allocList+0x62>
  8020b1:	83 ec 04             	sub    $0x4,%esp
  8020b4:	68 58 3f 80 00       	push   $0x803f58
  8020b9:	6a 6b                	push   $0x6b
  8020bb:	68 7b 3f 80 00       	push   $0x803f7b
  8020c0:	e8 bd e1 ff ff       	call   800282 <_panic>
  8020c5:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	89 10                	mov    %edx,(%eax)
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	8b 00                	mov    (%eax),%eax
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	74 0d                	je     8020e6 <insert_sorted_allocList+0x83>
  8020d9:	a1 40 50 80 00       	mov    0x805040,%eax
  8020de:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e1:	89 50 04             	mov    %edx,0x4(%eax)
  8020e4:	eb 08                	jmp    8020ee <insert_sorted_allocList+0x8b>
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	a3 44 50 80 00       	mov    %eax,0x805044
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	a3 40 50 80 00       	mov    %eax,0x805040
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802100:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802105:	40                   	inc    %eax
  802106:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80210b:	e9 dc 01 00 00       	jmp    8022ec <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	8b 50 08             	mov    0x8(%eax),%edx
  802116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802119:	8b 40 08             	mov    0x8(%eax),%eax
  80211c:	39 c2                	cmp    %eax,%edx
  80211e:	77 6c                	ja     80218c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802120:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802124:	74 06                	je     80212c <insert_sorted_allocList+0xc9>
  802126:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80212a:	75 14                	jne    802140 <insert_sorted_allocList+0xdd>
  80212c:	83 ec 04             	sub    $0x4,%esp
  80212f:	68 94 3f 80 00       	push   $0x803f94
  802134:	6a 6f                	push   $0x6f
  802136:	68 7b 3f 80 00       	push   $0x803f7b
  80213b:	e8 42 e1 ff ff       	call   800282 <_panic>
  802140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802143:	8b 50 04             	mov    0x4(%eax),%edx
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	89 50 04             	mov    %edx,0x4(%eax)
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802152:	89 10                	mov    %edx,(%eax)
  802154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802157:	8b 40 04             	mov    0x4(%eax),%eax
  80215a:	85 c0                	test   %eax,%eax
  80215c:	74 0d                	je     80216b <insert_sorted_allocList+0x108>
  80215e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802161:	8b 40 04             	mov    0x4(%eax),%eax
  802164:	8b 55 08             	mov    0x8(%ebp),%edx
  802167:	89 10                	mov    %edx,(%eax)
  802169:	eb 08                	jmp    802173 <insert_sorted_allocList+0x110>
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	a3 40 50 80 00       	mov    %eax,0x805040
  802173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802176:	8b 55 08             	mov    0x8(%ebp),%edx
  802179:	89 50 04             	mov    %edx,0x4(%eax)
  80217c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802181:	40                   	inc    %eax
  802182:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802187:	e9 60 01 00 00       	jmp    8022ec <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	8b 50 08             	mov    0x8(%eax),%edx
  802192:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802195:	8b 40 08             	mov    0x8(%eax),%eax
  802198:	39 c2                	cmp    %eax,%edx
  80219a:	0f 82 4c 01 00 00    	jb     8022ec <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a4:	75 14                	jne    8021ba <insert_sorted_allocList+0x157>
  8021a6:	83 ec 04             	sub    $0x4,%esp
  8021a9:	68 cc 3f 80 00       	push   $0x803fcc
  8021ae:	6a 73                	push   $0x73
  8021b0:	68 7b 3f 80 00       	push   $0x803f7b
  8021b5:	e8 c8 e0 ff ff       	call   800282 <_panic>
  8021ba:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	89 50 04             	mov    %edx,0x4(%eax)
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	8b 40 04             	mov    0x4(%eax),%eax
  8021cc:	85 c0                	test   %eax,%eax
  8021ce:	74 0c                	je     8021dc <insert_sorted_allocList+0x179>
  8021d0:	a1 44 50 80 00       	mov    0x805044,%eax
  8021d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d8:	89 10                	mov    %edx,(%eax)
  8021da:	eb 08                	jmp    8021e4 <insert_sorted_allocList+0x181>
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	a3 40 50 80 00       	mov    %eax,0x805040
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	a3 44 50 80 00       	mov    %eax,0x805044
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021f5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021fa:	40                   	inc    %eax
  8021fb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802200:	e9 e7 00 00 00       	jmp    8022ec <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802208:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80220b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802212:	a1 40 50 80 00       	mov    0x805040,%eax
  802217:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221a:	e9 9d 00 00 00       	jmp    8022bc <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	8b 00                	mov    (%eax),%eax
  802224:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	8b 50 08             	mov    0x8(%eax),%edx
  80222d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802230:	8b 40 08             	mov    0x8(%eax),%eax
  802233:	39 c2                	cmp    %eax,%edx
  802235:	76 7d                	jbe    8022b4 <insert_sorted_allocList+0x251>
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	8b 50 08             	mov    0x8(%eax),%edx
  80223d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802240:	8b 40 08             	mov    0x8(%eax),%eax
  802243:	39 c2                	cmp    %eax,%edx
  802245:	73 6d                	jae    8022b4 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802247:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224b:	74 06                	je     802253 <insert_sorted_allocList+0x1f0>
  80224d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802251:	75 14                	jne    802267 <insert_sorted_allocList+0x204>
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	68 f0 3f 80 00       	push   $0x803ff0
  80225b:	6a 7f                	push   $0x7f
  80225d:	68 7b 3f 80 00       	push   $0x803f7b
  802262:	e8 1b e0 ff ff       	call   800282 <_panic>
  802267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226a:	8b 10                	mov    (%eax),%edx
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	89 10                	mov    %edx,(%eax)
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	8b 00                	mov    (%eax),%eax
  802276:	85 c0                	test   %eax,%eax
  802278:	74 0b                	je     802285 <insert_sorted_allocList+0x222>
  80227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227d:	8b 00                	mov    (%eax),%eax
  80227f:	8b 55 08             	mov    0x8(%ebp),%edx
  802282:	89 50 04             	mov    %edx,0x4(%eax)
  802285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802288:	8b 55 08             	mov    0x8(%ebp),%edx
  80228b:	89 10                	mov    %edx,(%eax)
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802293:	89 50 04             	mov    %edx,0x4(%eax)
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	8b 00                	mov    (%eax),%eax
  80229b:	85 c0                	test   %eax,%eax
  80229d:	75 08                	jne    8022a7 <insert_sorted_allocList+0x244>
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	a3 44 50 80 00       	mov    %eax,0x805044
  8022a7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ac:	40                   	inc    %eax
  8022ad:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022b2:	eb 39                	jmp    8022ed <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022b4:	a1 48 50 80 00       	mov    0x805048,%eax
  8022b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c0:	74 07                	je     8022c9 <insert_sorted_allocList+0x266>
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	8b 00                	mov    (%eax),%eax
  8022c7:	eb 05                	jmp    8022ce <insert_sorted_allocList+0x26b>
  8022c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ce:	a3 48 50 80 00       	mov    %eax,0x805048
  8022d3:	a1 48 50 80 00       	mov    0x805048,%eax
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	0f 85 3f ff ff ff    	jne    80221f <insert_sorted_allocList+0x1bc>
  8022e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e4:	0f 85 35 ff ff ff    	jne    80221f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022ea:	eb 01                	jmp    8022ed <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022ec:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022ed:	90                   	nop
  8022ee:	c9                   	leave  
  8022ef:	c3                   	ret    

008022f0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022f6:	a1 38 51 80 00       	mov    0x805138,%eax
  8022fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022fe:	e9 85 01 00 00       	jmp    802488 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 40 0c             	mov    0xc(%eax),%eax
  802309:	3b 45 08             	cmp    0x8(%ebp),%eax
  80230c:	0f 82 6e 01 00 00    	jb     802480 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 40 0c             	mov    0xc(%eax),%eax
  802318:	3b 45 08             	cmp    0x8(%ebp),%eax
  80231b:	0f 85 8a 00 00 00    	jne    8023ab <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802321:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802325:	75 17                	jne    80233e <alloc_block_FF+0x4e>
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	68 24 40 80 00       	push   $0x804024
  80232f:	68 93 00 00 00       	push   $0x93
  802334:	68 7b 3f 80 00       	push   $0x803f7b
  802339:	e8 44 df ff ff       	call   800282 <_panic>
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 00                	mov    (%eax),%eax
  802343:	85 c0                	test   %eax,%eax
  802345:	74 10                	je     802357 <alloc_block_FF+0x67>
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 00                	mov    (%eax),%eax
  80234c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234f:	8b 52 04             	mov    0x4(%edx),%edx
  802352:	89 50 04             	mov    %edx,0x4(%eax)
  802355:	eb 0b                	jmp    802362 <alloc_block_FF+0x72>
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 04             	mov    0x4(%eax),%eax
  80235d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	8b 40 04             	mov    0x4(%eax),%eax
  802368:	85 c0                	test   %eax,%eax
  80236a:	74 0f                	je     80237b <alloc_block_FF+0x8b>
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 40 04             	mov    0x4(%eax),%eax
  802372:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802375:	8b 12                	mov    (%edx),%edx
  802377:	89 10                	mov    %edx,(%eax)
  802379:	eb 0a                	jmp    802385 <alloc_block_FF+0x95>
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 00                	mov    (%eax),%eax
  802380:	a3 38 51 80 00       	mov    %eax,0x805138
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802398:	a1 44 51 80 00       	mov    0x805144,%eax
  80239d:	48                   	dec    %eax
  80239e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	e9 10 01 00 00       	jmp    8024bb <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b4:	0f 86 c6 00 00 00    	jbe    802480 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023ba:	a1 48 51 80 00       	mov    0x805148,%eax
  8023bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 50 08             	mov    0x8(%eax),%edx
  8023c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cb:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d4:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023db:	75 17                	jne    8023f4 <alloc_block_FF+0x104>
  8023dd:	83 ec 04             	sub    $0x4,%esp
  8023e0:	68 24 40 80 00       	push   $0x804024
  8023e5:	68 9b 00 00 00       	push   $0x9b
  8023ea:	68 7b 3f 80 00       	push   $0x803f7b
  8023ef:	e8 8e de ff ff       	call   800282 <_panic>
  8023f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	74 10                	je     80240d <alloc_block_FF+0x11d>
  8023fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802405:	8b 52 04             	mov    0x4(%edx),%edx
  802408:	89 50 04             	mov    %edx,0x4(%eax)
  80240b:	eb 0b                	jmp    802418 <alloc_block_FF+0x128>
  80240d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802410:	8b 40 04             	mov    0x4(%eax),%eax
  802413:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241b:	8b 40 04             	mov    0x4(%eax),%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	74 0f                	je     802431 <alloc_block_FF+0x141>
  802422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802425:	8b 40 04             	mov    0x4(%eax),%eax
  802428:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80242b:	8b 12                	mov    (%edx),%edx
  80242d:	89 10                	mov    %edx,(%eax)
  80242f:	eb 0a                	jmp    80243b <alloc_block_FF+0x14b>
  802431:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	a3 48 51 80 00       	mov    %eax,0x805148
  80243b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802447:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244e:	a1 54 51 80 00       	mov    0x805154,%eax
  802453:	48                   	dec    %eax
  802454:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 50 08             	mov    0x8(%eax),%edx
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	01 c2                	add    %eax,%edx
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	8b 40 0c             	mov    0xc(%eax),%eax
  802470:	2b 45 08             	sub    0x8(%ebp),%eax
  802473:	89 c2                	mov    %eax,%edx
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80247b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247e:	eb 3b                	jmp    8024bb <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802480:	a1 40 51 80 00       	mov    0x805140,%eax
  802485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802488:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248c:	74 07                	je     802495 <alloc_block_FF+0x1a5>
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 00                	mov    (%eax),%eax
  802493:	eb 05                	jmp    80249a <alloc_block_FF+0x1aa>
  802495:	b8 00 00 00 00       	mov    $0x0,%eax
  80249a:	a3 40 51 80 00       	mov    %eax,0x805140
  80249f:	a1 40 51 80 00       	mov    0x805140,%eax
  8024a4:	85 c0                	test   %eax,%eax
  8024a6:	0f 85 57 fe ff ff    	jne    802303 <alloc_block_FF+0x13>
  8024ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b0:	0f 85 4d fe ff ff    	jne    802303 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bb:	c9                   	leave  
  8024bc:	c3                   	ret    

008024bd <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
  8024c0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024c3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8024cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d2:	e9 df 00 00 00       	jmp    8025b6 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 40 0c             	mov    0xc(%eax),%eax
  8024dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e0:	0f 82 c8 00 00 00    	jb     8025ae <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ef:	0f 85 8a 00 00 00    	jne    80257f <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f9:	75 17                	jne    802512 <alloc_block_BF+0x55>
  8024fb:	83 ec 04             	sub    $0x4,%esp
  8024fe:	68 24 40 80 00       	push   $0x804024
  802503:	68 b7 00 00 00       	push   $0xb7
  802508:	68 7b 3f 80 00       	push   $0x803f7b
  80250d:	e8 70 dd ff ff       	call   800282 <_panic>
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 00                	mov    (%eax),%eax
  802517:	85 c0                	test   %eax,%eax
  802519:	74 10                	je     80252b <alloc_block_BF+0x6e>
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 00                	mov    (%eax),%eax
  802520:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802523:	8b 52 04             	mov    0x4(%edx),%edx
  802526:	89 50 04             	mov    %edx,0x4(%eax)
  802529:	eb 0b                	jmp    802536 <alloc_block_BF+0x79>
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 40 04             	mov    0x4(%eax),%eax
  802531:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 40 04             	mov    0x4(%eax),%eax
  80253c:	85 c0                	test   %eax,%eax
  80253e:	74 0f                	je     80254f <alloc_block_BF+0x92>
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 40 04             	mov    0x4(%eax),%eax
  802546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802549:	8b 12                	mov    (%edx),%edx
  80254b:	89 10                	mov    %edx,(%eax)
  80254d:	eb 0a                	jmp    802559 <alloc_block_BF+0x9c>
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	a3 38 51 80 00       	mov    %eax,0x805138
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80256c:	a1 44 51 80 00       	mov    0x805144,%eax
  802571:	48                   	dec    %eax
  802572:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	e9 4d 01 00 00       	jmp    8026cc <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 40 0c             	mov    0xc(%eax),%eax
  802585:	3b 45 08             	cmp    0x8(%ebp),%eax
  802588:	76 24                	jbe    8025ae <alloc_block_BF+0xf1>
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 40 0c             	mov    0xc(%eax),%eax
  802590:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802593:	73 19                	jae    8025ae <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802595:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 40 08             	mov    0x8(%eax),%eax
  8025ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025ae:	a1 40 51 80 00       	mov    0x805140,%eax
  8025b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ba:	74 07                	je     8025c3 <alloc_block_BF+0x106>
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 00                	mov    (%eax),%eax
  8025c1:	eb 05                	jmp    8025c8 <alloc_block_BF+0x10b>
  8025c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c8:	a3 40 51 80 00       	mov    %eax,0x805140
  8025cd:	a1 40 51 80 00       	mov    0x805140,%eax
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	0f 85 fd fe ff ff    	jne    8024d7 <alloc_block_BF+0x1a>
  8025da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025de:	0f 85 f3 fe ff ff    	jne    8024d7 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025e8:	0f 84 d9 00 00 00    	je     8026c7 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025ee:	a1 48 51 80 00       	mov    0x805148,%eax
  8025f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025fc:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802602:	8b 55 08             	mov    0x8(%ebp),%edx
  802605:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802608:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80260c:	75 17                	jne    802625 <alloc_block_BF+0x168>
  80260e:	83 ec 04             	sub    $0x4,%esp
  802611:	68 24 40 80 00       	push   $0x804024
  802616:	68 c7 00 00 00       	push   $0xc7
  80261b:	68 7b 3f 80 00       	push   $0x803f7b
  802620:	e8 5d dc ff ff       	call   800282 <_panic>
  802625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	85 c0                	test   %eax,%eax
  80262c:	74 10                	je     80263e <alloc_block_BF+0x181>
  80262e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802636:	8b 52 04             	mov    0x4(%edx),%edx
  802639:	89 50 04             	mov    %edx,0x4(%eax)
  80263c:	eb 0b                	jmp    802649 <alloc_block_BF+0x18c>
  80263e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802641:	8b 40 04             	mov    0x4(%eax),%eax
  802644:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802649:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264c:	8b 40 04             	mov    0x4(%eax),%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	74 0f                	je     802662 <alloc_block_BF+0x1a5>
  802653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802656:	8b 40 04             	mov    0x4(%eax),%eax
  802659:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80265c:	8b 12                	mov    (%edx),%edx
  80265e:	89 10                	mov    %edx,(%eax)
  802660:	eb 0a                	jmp    80266c <alloc_block_BF+0x1af>
  802662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802665:	8b 00                	mov    (%eax),%eax
  802667:	a3 48 51 80 00       	mov    %eax,0x805148
  80266c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802678:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267f:	a1 54 51 80 00       	mov    0x805154,%eax
  802684:	48                   	dec    %eax
  802685:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80268a:	83 ec 08             	sub    $0x8,%esp
  80268d:	ff 75 ec             	pushl  -0x14(%ebp)
  802690:	68 38 51 80 00       	push   $0x805138
  802695:	e8 71 f9 ff ff       	call   80200b <find_block>
  80269a:	83 c4 10             	add    $0x10,%esp
  80269d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a3:	8b 50 08             	mov    0x8(%eax),%edx
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	01 c2                	add    %eax,%edx
  8026ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ae:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ba:	89 c2                	mov    %eax,%edx
  8026bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bf:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c5:	eb 05                	jmp    8026cc <alloc_block_BF+0x20f>
	}
	return NULL;
  8026c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    

008026ce <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
  8026d1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026d4:	a1 28 50 80 00       	mov    0x805028,%eax
  8026d9:	85 c0                	test   %eax,%eax
  8026db:	0f 85 de 01 00 00    	jne    8028bf <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8026e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e9:	e9 9e 01 00 00       	jmp    80288c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f7:	0f 82 87 01 00 00    	jb     802884 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 40 0c             	mov    0xc(%eax),%eax
  802703:	3b 45 08             	cmp    0x8(%ebp),%eax
  802706:	0f 85 95 00 00 00    	jne    8027a1 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80270c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802710:	75 17                	jne    802729 <alloc_block_NF+0x5b>
  802712:	83 ec 04             	sub    $0x4,%esp
  802715:	68 24 40 80 00       	push   $0x804024
  80271a:	68 e0 00 00 00       	push   $0xe0
  80271f:	68 7b 3f 80 00       	push   $0x803f7b
  802724:	e8 59 db ff ff       	call   800282 <_panic>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 00                	mov    (%eax),%eax
  80272e:	85 c0                	test   %eax,%eax
  802730:	74 10                	je     802742 <alloc_block_NF+0x74>
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 00                	mov    (%eax),%eax
  802737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273a:	8b 52 04             	mov    0x4(%edx),%edx
  80273d:	89 50 04             	mov    %edx,0x4(%eax)
  802740:	eb 0b                	jmp    80274d <alloc_block_NF+0x7f>
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 04             	mov    0x4(%eax),%eax
  802748:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 40 04             	mov    0x4(%eax),%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	74 0f                	je     802766 <alloc_block_NF+0x98>
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 40 04             	mov    0x4(%eax),%eax
  80275d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802760:	8b 12                	mov    (%edx),%edx
  802762:	89 10                	mov    %edx,(%eax)
  802764:	eb 0a                	jmp    802770 <alloc_block_NF+0xa2>
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 00                	mov    (%eax),%eax
  80276b:	a3 38 51 80 00       	mov    %eax,0x805138
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802783:	a1 44 51 80 00       	mov    0x805144,%eax
  802788:	48                   	dec    %eax
  802789:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 40 08             	mov    0x8(%eax),%eax
  802794:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	e9 f8 04 00 00       	jmp    802c99 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027aa:	0f 86 d4 00 00 00    	jbe    802884 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027b0:	a1 48 51 80 00       	mov    0x805148,%eax
  8027b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 50 08             	mov    0x8(%eax),%edx
  8027be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c1:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ca:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027d1:	75 17                	jne    8027ea <alloc_block_NF+0x11c>
  8027d3:	83 ec 04             	sub    $0x4,%esp
  8027d6:	68 24 40 80 00       	push   $0x804024
  8027db:	68 e9 00 00 00       	push   $0xe9
  8027e0:	68 7b 3f 80 00       	push   $0x803f7b
  8027e5:	e8 98 da ff ff       	call   800282 <_panic>
  8027ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	74 10                	je     802803 <alloc_block_NF+0x135>
  8027f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f6:	8b 00                	mov    (%eax),%eax
  8027f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027fb:	8b 52 04             	mov    0x4(%edx),%edx
  8027fe:	89 50 04             	mov    %edx,0x4(%eax)
  802801:	eb 0b                	jmp    80280e <alloc_block_NF+0x140>
  802803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802806:	8b 40 04             	mov    0x4(%eax),%eax
  802809:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802811:	8b 40 04             	mov    0x4(%eax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	74 0f                	je     802827 <alloc_block_NF+0x159>
  802818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281b:	8b 40 04             	mov    0x4(%eax),%eax
  80281e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802821:	8b 12                	mov    (%edx),%edx
  802823:	89 10                	mov    %edx,(%eax)
  802825:	eb 0a                	jmp    802831 <alloc_block_NF+0x163>
  802827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	a3 48 51 80 00       	mov    %eax,0x805148
  802831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802834:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802844:	a1 54 51 80 00       	mov    0x805154,%eax
  802849:	48                   	dec    %eax
  80284a:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80284f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802852:	8b 40 08             	mov    0x8(%eax),%eax
  802855:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 50 08             	mov    0x8(%eax),%edx
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	01 c2                	add    %eax,%edx
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 40 0c             	mov    0xc(%eax),%eax
  802871:	2b 45 08             	sub    0x8(%ebp),%eax
  802874:	89 c2                	mov    %eax,%edx
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80287c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287f:	e9 15 04 00 00       	jmp    802c99 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802884:	a1 40 51 80 00       	mov    0x805140,%eax
  802889:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802890:	74 07                	je     802899 <alloc_block_NF+0x1cb>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	eb 05                	jmp    80289e <alloc_block_NF+0x1d0>
  802899:	b8 00 00 00 00       	mov    $0x0,%eax
  80289e:	a3 40 51 80 00       	mov    %eax,0x805140
  8028a3:	a1 40 51 80 00       	mov    0x805140,%eax
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	0f 85 3e fe ff ff    	jne    8026ee <alloc_block_NF+0x20>
  8028b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b4:	0f 85 34 fe ff ff    	jne    8026ee <alloc_block_NF+0x20>
  8028ba:	e9 d5 03 00 00       	jmp    802c94 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028bf:	a1 38 51 80 00       	mov    0x805138,%eax
  8028c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c7:	e9 b1 01 00 00       	jmp    802a7d <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 50 08             	mov    0x8(%eax),%edx
  8028d2:	a1 28 50 80 00       	mov    0x805028,%eax
  8028d7:	39 c2                	cmp    %eax,%edx
  8028d9:	0f 82 96 01 00 00    	jb     802a75 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e8:	0f 82 87 01 00 00    	jb     802a75 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f7:	0f 85 95 00 00 00    	jne    802992 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802901:	75 17                	jne    80291a <alloc_block_NF+0x24c>
  802903:	83 ec 04             	sub    $0x4,%esp
  802906:	68 24 40 80 00       	push   $0x804024
  80290b:	68 fc 00 00 00       	push   $0xfc
  802910:	68 7b 3f 80 00       	push   $0x803f7b
  802915:	e8 68 d9 ff ff       	call   800282 <_panic>
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 00                	mov    (%eax),%eax
  80291f:	85 c0                	test   %eax,%eax
  802921:	74 10                	je     802933 <alloc_block_NF+0x265>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292b:	8b 52 04             	mov    0x4(%edx),%edx
  80292e:	89 50 04             	mov    %edx,0x4(%eax)
  802931:	eb 0b                	jmp    80293e <alloc_block_NF+0x270>
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 04             	mov    0x4(%eax),%eax
  802939:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 40 04             	mov    0x4(%eax),%eax
  802944:	85 c0                	test   %eax,%eax
  802946:	74 0f                	je     802957 <alloc_block_NF+0x289>
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 40 04             	mov    0x4(%eax),%eax
  80294e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802951:	8b 12                	mov    (%edx),%edx
  802953:	89 10                	mov    %edx,(%eax)
  802955:	eb 0a                	jmp    802961 <alloc_block_NF+0x293>
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	a3 38 51 80 00       	mov    %eax,0x805138
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802974:	a1 44 51 80 00       	mov    0x805144,%eax
  802979:	48                   	dec    %eax
  80297a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 40 08             	mov    0x8(%eax),%eax
  802985:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	e9 07 03 00 00       	jmp    802c99 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 40 0c             	mov    0xc(%eax),%eax
  802998:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299b:	0f 86 d4 00 00 00    	jbe    802a75 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029a1:	a1 48 51 80 00       	mov    0x805148,%eax
  8029a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	8b 50 08             	mov    0x8(%eax),%edx
  8029af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029c2:	75 17                	jne    8029db <alloc_block_NF+0x30d>
  8029c4:	83 ec 04             	sub    $0x4,%esp
  8029c7:	68 24 40 80 00       	push   $0x804024
  8029cc:	68 04 01 00 00       	push   $0x104
  8029d1:	68 7b 3f 80 00       	push   $0x803f7b
  8029d6:	e8 a7 d8 ff ff       	call   800282 <_panic>
  8029db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	74 10                	je     8029f4 <alloc_block_NF+0x326>
  8029e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029ec:	8b 52 04             	mov    0x4(%edx),%edx
  8029ef:	89 50 04             	mov    %edx,0x4(%eax)
  8029f2:	eb 0b                	jmp    8029ff <alloc_block_NF+0x331>
  8029f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f7:	8b 40 04             	mov    0x4(%eax),%eax
  8029fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a02:	8b 40 04             	mov    0x4(%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 0f                	je     802a18 <alloc_block_NF+0x34a>
  802a09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0c:	8b 40 04             	mov    0x4(%eax),%eax
  802a0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a12:	8b 12                	mov    (%edx),%edx
  802a14:	89 10                	mov    %edx,(%eax)
  802a16:	eb 0a                	jmp    802a22 <alloc_block_NF+0x354>
  802a18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	a3 48 51 80 00       	mov    %eax,0x805148
  802a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a35:	a1 54 51 80 00       	mov    0x805154,%eax
  802a3a:	48                   	dec    %eax
  802a3b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a43:	8b 40 08             	mov    0x8(%eax),%eax
  802a46:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 50 08             	mov    0x8(%eax),%edx
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	01 c2                	add    %eax,%edx
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a62:	2b 45 08             	sub    0x8(%ebp),%eax
  802a65:	89 c2                	mov    %eax,%edx
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a70:	e9 24 02 00 00       	jmp    802c99 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a75:	a1 40 51 80 00       	mov    0x805140,%eax
  802a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a81:	74 07                	je     802a8a <alloc_block_NF+0x3bc>
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 00                	mov    (%eax),%eax
  802a88:	eb 05                	jmp    802a8f <alloc_block_NF+0x3c1>
  802a8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8f:	a3 40 51 80 00       	mov    %eax,0x805140
  802a94:	a1 40 51 80 00       	mov    0x805140,%eax
  802a99:	85 c0                	test   %eax,%eax
  802a9b:	0f 85 2b fe ff ff    	jne    8028cc <alloc_block_NF+0x1fe>
  802aa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa5:	0f 85 21 fe ff ff    	jne    8028cc <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aab:	a1 38 51 80 00       	mov    0x805138,%eax
  802ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab3:	e9 ae 01 00 00       	jmp    802c66 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 50 08             	mov    0x8(%eax),%edx
  802abe:	a1 28 50 80 00       	mov    0x805028,%eax
  802ac3:	39 c2                	cmp    %eax,%edx
  802ac5:	0f 83 93 01 00 00    	jae    802c5e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad4:	0f 82 84 01 00 00    	jb     802c5e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae3:	0f 85 95 00 00 00    	jne    802b7e <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aed:	75 17                	jne    802b06 <alloc_block_NF+0x438>
  802aef:	83 ec 04             	sub    $0x4,%esp
  802af2:	68 24 40 80 00       	push   $0x804024
  802af7:	68 14 01 00 00       	push   $0x114
  802afc:	68 7b 3f 80 00       	push   $0x803f7b
  802b01:	e8 7c d7 ff ff       	call   800282 <_panic>
  802b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b09:	8b 00                	mov    (%eax),%eax
  802b0b:	85 c0                	test   %eax,%eax
  802b0d:	74 10                	je     802b1f <alloc_block_NF+0x451>
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 00                	mov    (%eax),%eax
  802b14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b17:	8b 52 04             	mov    0x4(%edx),%edx
  802b1a:	89 50 04             	mov    %edx,0x4(%eax)
  802b1d:	eb 0b                	jmp    802b2a <alloc_block_NF+0x45c>
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 40 04             	mov    0x4(%eax),%eax
  802b25:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 40 04             	mov    0x4(%eax),%eax
  802b30:	85 c0                	test   %eax,%eax
  802b32:	74 0f                	je     802b43 <alloc_block_NF+0x475>
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 40 04             	mov    0x4(%eax),%eax
  802b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3d:	8b 12                	mov    (%edx),%edx
  802b3f:	89 10                	mov    %edx,(%eax)
  802b41:	eb 0a                	jmp    802b4d <alloc_block_NF+0x47f>
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	8b 00                	mov    (%eax),%eax
  802b48:	a3 38 51 80 00       	mov    %eax,0x805138
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b60:	a1 44 51 80 00       	mov    0x805144,%eax
  802b65:	48                   	dec    %eax
  802b66:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 40 08             	mov    0x8(%eax),%eax
  802b71:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	e9 1b 01 00 00       	jmp    802c99 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 40 0c             	mov    0xc(%eax),%eax
  802b84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b87:	0f 86 d1 00 00 00    	jbe    802c5e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b8d:	a1 48 51 80 00       	mov    0x805148,%eax
  802b92:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 50 08             	mov    0x8(%eax),%edx
  802b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802baa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bae:	75 17                	jne    802bc7 <alloc_block_NF+0x4f9>
  802bb0:	83 ec 04             	sub    $0x4,%esp
  802bb3:	68 24 40 80 00       	push   $0x804024
  802bb8:	68 1c 01 00 00       	push   $0x11c
  802bbd:	68 7b 3f 80 00       	push   $0x803f7b
  802bc2:	e8 bb d6 ff ff       	call   800282 <_panic>
  802bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bca:	8b 00                	mov    (%eax),%eax
  802bcc:	85 c0                	test   %eax,%eax
  802bce:	74 10                	je     802be0 <alloc_block_NF+0x512>
  802bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd8:	8b 52 04             	mov    0x4(%edx),%edx
  802bdb:	89 50 04             	mov    %edx,0x4(%eax)
  802bde:	eb 0b                	jmp    802beb <alloc_block_NF+0x51d>
  802be0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be3:	8b 40 04             	mov    0x4(%eax),%eax
  802be6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bee:	8b 40 04             	mov    0x4(%eax),%eax
  802bf1:	85 c0                	test   %eax,%eax
  802bf3:	74 0f                	je     802c04 <alloc_block_NF+0x536>
  802bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf8:	8b 40 04             	mov    0x4(%eax),%eax
  802bfb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bfe:	8b 12                	mov    (%edx),%edx
  802c00:	89 10                	mov    %edx,(%eax)
  802c02:	eb 0a                	jmp    802c0e <alloc_block_NF+0x540>
  802c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c07:	8b 00                	mov    (%eax),%eax
  802c09:	a3 48 51 80 00       	mov    %eax,0x805148
  802c0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c21:	a1 54 51 80 00       	mov    0x805154,%eax
  802c26:	48                   	dec    %eax
  802c27:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2f:	8b 40 08             	mov    0x8(%eax),%eax
  802c32:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 50 08             	mov    0x8(%eax),%edx
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	01 c2                	add    %eax,%edx
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4e:	2b 45 08             	sub    0x8(%ebp),%eax
  802c51:	89 c2                	mov    %eax,%edx
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5c:	eb 3b                	jmp    802c99 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c5e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6a:	74 07                	je     802c73 <alloc_block_NF+0x5a5>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	eb 05                	jmp    802c78 <alloc_block_NF+0x5aa>
  802c73:	b8 00 00 00 00       	mov    $0x0,%eax
  802c78:	a3 40 51 80 00       	mov    %eax,0x805140
  802c7d:	a1 40 51 80 00       	mov    0x805140,%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	0f 85 2e fe ff ff    	jne    802ab8 <alloc_block_NF+0x3ea>
  802c8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8e:	0f 85 24 fe ff ff    	jne    802ab8 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c99:	c9                   	leave  
  802c9a:	c3                   	ret    

00802c9b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c9b:	55                   	push   %ebp
  802c9c:	89 e5                	mov    %esp,%ebp
  802c9e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ca1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ca9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cae:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cb1:	a1 38 51 80 00       	mov    0x805138,%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	74 14                	je     802cce <insert_sorted_with_merge_freeList+0x33>
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	8b 50 08             	mov    0x8(%eax),%edx
  802cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc3:	8b 40 08             	mov    0x8(%eax),%eax
  802cc6:	39 c2                	cmp    %eax,%edx
  802cc8:	0f 87 9b 01 00 00    	ja     802e69 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd2:	75 17                	jne    802ceb <insert_sorted_with_merge_freeList+0x50>
  802cd4:	83 ec 04             	sub    $0x4,%esp
  802cd7:	68 58 3f 80 00       	push   $0x803f58
  802cdc:	68 38 01 00 00       	push   $0x138
  802ce1:	68 7b 3f 80 00       	push   $0x803f7b
  802ce6:	e8 97 d5 ff ff       	call   800282 <_panic>
  802ceb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf4:	89 10                	mov    %edx,(%eax)
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	85 c0                	test   %eax,%eax
  802cfd:	74 0d                	je     802d0c <insert_sorted_with_merge_freeList+0x71>
  802cff:	a1 38 51 80 00       	mov    0x805138,%eax
  802d04:	8b 55 08             	mov    0x8(%ebp),%edx
  802d07:	89 50 04             	mov    %edx,0x4(%eax)
  802d0a:	eb 08                	jmp    802d14 <insert_sorted_with_merge_freeList+0x79>
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	a3 38 51 80 00       	mov    %eax,0x805138
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d26:	a1 44 51 80 00       	mov    0x805144,%eax
  802d2b:	40                   	inc    %eax
  802d2c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d35:	0f 84 a8 06 00 00    	je     8033e3 <insert_sorted_with_merge_freeList+0x748>
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	8b 50 08             	mov    0x8(%eax),%edx
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	8b 40 0c             	mov    0xc(%eax),%eax
  802d47:	01 c2                	add    %eax,%edx
  802d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4c:	8b 40 08             	mov    0x8(%eax),%eax
  802d4f:	39 c2                	cmp    %eax,%edx
  802d51:	0f 85 8c 06 00 00    	jne    8033e3 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	8b 40 0c             	mov    0xc(%eax),%eax
  802d63:	01 c2                	add    %eax,%edx
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d6f:	75 17                	jne    802d88 <insert_sorted_with_merge_freeList+0xed>
  802d71:	83 ec 04             	sub    $0x4,%esp
  802d74:	68 24 40 80 00       	push   $0x804024
  802d79:	68 3c 01 00 00       	push   $0x13c
  802d7e:	68 7b 3f 80 00       	push   $0x803f7b
  802d83:	e8 fa d4 ff ff       	call   800282 <_panic>
  802d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8b:	8b 00                	mov    (%eax),%eax
  802d8d:	85 c0                	test   %eax,%eax
  802d8f:	74 10                	je     802da1 <insert_sorted_with_merge_freeList+0x106>
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d99:	8b 52 04             	mov    0x4(%edx),%edx
  802d9c:	89 50 04             	mov    %edx,0x4(%eax)
  802d9f:	eb 0b                	jmp    802dac <insert_sorted_with_merge_freeList+0x111>
  802da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da4:	8b 40 04             	mov    0x4(%eax),%eax
  802da7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daf:	8b 40 04             	mov    0x4(%eax),%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	74 0f                	je     802dc5 <insert_sorted_with_merge_freeList+0x12a>
  802db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db9:	8b 40 04             	mov    0x4(%eax),%eax
  802dbc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dbf:	8b 12                	mov    (%edx),%edx
  802dc1:	89 10                	mov    %edx,(%eax)
  802dc3:	eb 0a                	jmp    802dcf <insert_sorted_with_merge_freeList+0x134>
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	8b 00                	mov    (%eax),%eax
  802dca:	a3 38 51 80 00       	mov    %eax,0x805138
  802dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de2:	a1 44 51 80 00       	mov    0x805144,%eax
  802de7:	48                   	dec    %eax
  802de8:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e05:	75 17                	jne    802e1e <insert_sorted_with_merge_freeList+0x183>
  802e07:	83 ec 04             	sub    $0x4,%esp
  802e0a:	68 58 3f 80 00       	push   $0x803f58
  802e0f:	68 3f 01 00 00       	push   $0x13f
  802e14:	68 7b 3f 80 00       	push   $0x803f7b
  802e19:	e8 64 d4 ff ff       	call   800282 <_panic>
  802e1e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e27:	89 10                	mov    %edx,(%eax)
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	8b 00                	mov    (%eax),%eax
  802e2e:	85 c0                	test   %eax,%eax
  802e30:	74 0d                	je     802e3f <insert_sorted_with_merge_freeList+0x1a4>
  802e32:	a1 48 51 80 00       	mov    0x805148,%eax
  802e37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e3a:	89 50 04             	mov    %edx,0x4(%eax)
  802e3d:	eb 08                	jmp    802e47 <insert_sorted_with_merge_freeList+0x1ac>
  802e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e42:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4a:	a3 48 51 80 00       	mov    %eax,0x805148
  802e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e59:	a1 54 51 80 00       	mov    0x805154,%eax
  802e5e:	40                   	inc    %eax
  802e5f:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e64:	e9 7a 05 00 00       	jmp    8033e3 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	8b 50 08             	mov    0x8(%eax),%edx
  802e6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e72:	8b 40 08             	mov    0x8(%eax),%eax
  802e75:	39 c2                	cmp    %eax,%edx
  802e77:	0f 82 14 01 00 00    	jb     802f91 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e80:	8b 50 08             	mov    0x8(%eax),%edx
  802e83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e86:	8b 40 0c             	mov    0xc(%eax),%eax
  802e89:	01 c2                	add    %eax,%edx
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	8b 40 08             	mov    0x8(%eax),%eax
  802e91:	39 c2                	cmp    %eax,%edx
  802e93:	0f 85 90 00 00 00    	jne    802f29 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea5:	01 c2                	add    %eax,%edx
  802ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eaa:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ec1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec5:	75 17                	jne    802ede <insert_sorted_with_merge_freeList+0x243>
  802ec7:	83 ec 04             	sub    $0x4,%esp
  802eca:	68 58 3f 80 00       	push   $0x803f58
  802ecf:	68 49 01 00 00       	push   $0x149
  802ed4:	68 7b 3f 80 00       	push   $0x803f7b
  802ed9:	e8 a4 d3 ff ff       	call   800282 <_panic>
  802ede:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	89 10                	mov    %edx,(%eax)
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	74 0d                	je     802eff <insert_sorted_with_merge_freeList+0x264>
  802ef2:	a1 48 51 80 00       	mov    0x805148,%eax
  802ef7:	8b 55 08             	mov    0x8(%ebp),%edx
  802efa:	89 50 04             	mov    %edx,0x4(%eax)
  802efd:	eb 08                	jmp    802f07 <insert_sorted_with_merge_freeList+0x26c>
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f19:	a1 54 51 80 00       	mov    0x805154,%eax
  802f1e:	40                   	inc    %eax
  802f1f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f24:	e9 bb 04 00 00       	jmp    8033e4 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2d:	75 17                	jne    802f46 <insert_sorted_with_merge_freeList+0x2ab>
  802f2f:	83 ec 04             	sub    $0x4,%esp
  802f32:	68 cc 3f 80 00       	push   $0x803fcc
  802f37:	68 4c 01 00 00       	push   $0x14c
  802f3c:	68 7b 3f 80 00       	push   $0x803f7b
  802f41:	e8 3c d3 ff ff       	call   800282 <_panic>
  802f46:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	89 50 04             	mov    %edx,0x4(%eax)
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	8b 40 04             	mov    0x4(%eax),%eax
  802f58:	85 c0                	test   %eax,%eax
  802f5a:	74 0c                	je     802f68 <insert_sorted_with_merge_freeList+0x2cd>
  802f5c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f61:	8b 55 08             	mov    0x8(%ebp),%edx
  802f64:	89 10                	mov    %edx,(%eax)
  802f66:	eb 08                	jmp    802f70 <insert_sorted_with_merge_freeList+0x2d5>
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	a3 38 51 80 00       	mov    %eax,0x805138
  802f70:	8b 45 08             	mov    0x8(%ebp),%eax
  802f73:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f78:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f81:	a1 44 51 80 00       	mov    0x805144,%eax
  802f86:	40                   	inc    %eax
  802f87:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f8c:	e9 53 04 00 00       	jmp    8033e4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f91:	a1 38 51 80 00       	mov    0x805138,%eax
  802f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f99:	e9 15 04 00 00       	jmp    8033b3 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa1:	8b 00                	mov    (%eax),%eax
  802fa3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	8b 50 08             	mov    0x8(%eax),%edx
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	8b 40 08             	mov    0x8(%eax),%eax
  802fb2:	39 c2                	cmp    %eax,%edx
  802fb4:	0f 86 f1 03 00 00    	jbe    8033ab <insert_sorted_with_merge_freeList+0x710>
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	8b 50 08             	mov    0x8(%eax),%edx
  802fc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc3:	8b 40 08             	mov    0x8(%eax),%eax
  802fc6:	39 c2                	cmp    %eax,%edx
  802fc8:	0f 83 dd 03 00 00    	jae    8033ab <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd1:	8b 50 08             	mov    0x8(%eax),%edx
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fda:	01 c2                	add    %eax,%edx
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	8b 40 08             	mov    0x8(%eax),%eax
  802fe2:	39 c2                	cmp    %eax,%edx
  802fe4:	0f 85 b9 01 00 00    	jne    8031a3 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	8b 50 08             	mov    0x8(%eax),%edx
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff6:	01 c2                	add    %eax,%edx
  802ff8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffb:	8b 40 08             	mov    0x8(%eax),%eax
  802ffe:	39 c2                	cmp    %eax,%edx
  803000:	0f 85 0d 01 00 00    	jne    803113 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 50 0c             	mov    0xc(%eax),%edx
  80300c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300f:	8b 40 0c             	mov    0xc(%eax),%eax
  803012:	01 c2                	add    %eax,%edx
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80301a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80301e:	75 17                	jne    803037 <insert_sorted_with_merge_freeList+0x39c>
  803020:	83 ec 04             	sub    $0x4,%esp
  803023:	68 24 40 80 00       	push   $0x804024
  803028:	68 5c 01 00 00       	push   $0x15c
  80302d:	68 7b 3f 80 00       	push   $0x803f7b
  803032:	e8 4b d2 ff ff       	call   800282 <_panic>
  803037:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303a:	8b 00                	mov    (%eax),%eax
  80303c:	85 c0                	test   %eax,%eax
  80303e:	74 10                	je     803050 <insert_sorted_with_merge_freeList+0x3b5>
  803040:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803048:	8b 52 04             	mov    0x4(%edx),%edx
  80304b:	89 50 04             	mov    %edx,0x4(%eax)
  80304e:	eb 0b                	jmp    80305b <insert_sorted_with_merge_freeList+0x3c0>
  803050:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803053:	8b 40 04             	mov    0x4(%eax),%eax
  803056:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	8b 40 04             	mov    0x4(%eax),%eax
  803061:	85 c0                	test   %eax,%eax
  803063:	74 0f                	je     803074 <insert_sorted_with_merge_freeList+0x3d9>
  803065:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803068:	8b 40 04             	mov    0x4(%eax),%eax
  80306b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80306e:	8b 12                	mov    (%edx),%edx
  803070:	89 10                	mov    %edx,(%eax)
  803072:	eb 0a                	jmp    80307e <insert_sorted_with_merge_freeList+0x3e3>
  803074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	a3 38 51 80 00       	mov    %eax,0x805138
  80307e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803081:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803087:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803091:	a1 44 51 80 00       	mov    0x805144,%eax
  803096:	48                   	dec    %eax
  803097:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80309c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b4:	75 17                	jne    8030cd <insert_sorted_with_merge_freeList+0x432>
  8030b6:	83 ec 04             	sub    $0x4,%esp
  8030b9:	68 58 3f 80 00       	push   $0x803f58
  8030be:	68 5f 01 00 00       	push   $0x15f
  8030c3:	68 7b 3f 80 00       	push   $0x803f7b
  8030c8:	e8 b5 d1 ff ff       	call   800282 <_panic>
  8030cd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d6:	89 10                	mov    %edx,(%eax)
  8030d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	85 c0                	test   %eax,%eax
  8030df:	74 0d                	je     8030ee <insert_sorted_with_merge_freeList+0x453>
  8030e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030e9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ec:	eb 08                	jmp    8030f6 <insert_sorted_with_merge_freeList+0x45b>
  8030ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8030fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803101:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803108:	a1 54 51 80 00       	mov    0x805154,%eax
  80310d:	40                   	inc    %eax
  80310e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	8b 50 0c             	mov    0xc(%eax),%edx
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	8b 40 0c             	mov    0xc(%eax),%eax
  80311f:	01 c2                	add    %eax,%edx
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80313b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313f:	75 17                	jne    803158 <insert_sorted_with_merge_freeList+0x4bd>
  803141:	83 ec 04             	sub    $0x4,%esp
  803144:	68 58 3f 80 00       	push   $0x803f58
  803149:	68 64 01 00 00       	push   $0x164
  80314e:	68 7b 3f 80 00       	push   $0x803f7b
  803153:	e8 2a d1 ff ff       	call   800282 <_panic>
  803158:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	89 10                	mov    %edx,(%eax)
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	8b 00                	mov    (%eax),%eax
  803168:	85 c0                	test   %eax,%eax
  80316a:	74 0d                	je     803179 <insert_sorted_with_merge_freeList+0x4de>
  80316c:	a1 48 51 80 00       	mov    0x805148,%eax
  803171:	8b 55 08             	mov    0x8(%ebp),%edx
  803174:	89 50 04             	mov    %edx,0x4(%eax)
  803177:	eb 08                	jmp    803181 <insert_sorted_with_merge_freeList+0x4e6>
  803179:	8b 45 08             	mov    0x8(%ebp),%eax
  80317c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803181:	8b 45 08             	mov    0x8(%ebp),%eax
  803184:	a3 48 51 80 00       	mov    %eax,0x805148
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803193:	a1 54 51 80 00       	mov    0x805154,%eax
  803198:	40                   	inc    %eax
  803199:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80319e:	e9 41 02 00 00       	jmp    8033e4 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	8b 50 08             	mov    0x8(%eax),%edx
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8031af:	01 c2                	add    %eax,%edx
  8031b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b4:	8b 40 08             	mov    0x8(%eax),%eax
  8031b7:	39 c2                	cmp    %eax,%edx
  8031b9:	0f 85 7c 01 00 00    	jne    80333b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031c3:	74 06                	je     8031cb <insert_sorted_with_merge_freeList+0x530>
  8031c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031c9:	75 17                	jne    8031e2 <insert_sorted_with_merge_freeList+0x547>
  8031cb:	83 ec 04             	sub    $0x4,%esp
  8031ce:	68 94 3f 80 00       	push   $0x803f94
  8031d3:	68 69 01 00 00       	push   $0x169
  8031d8:	68 7b 3f 80 00       	push   $0x803f7b
  8031dd:	e8 a0 d0 ff ff       	call   800282 <_panic>
  8031e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e5:	8b 50 04             	mov    0x4(%eax),%edx
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f4:	89 10                	mov    %edx,(%eax)
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	8b 40 04             	mov    0x4(%eax),%eax
  8031fc:	85 c0                	test   %eax,%eax
  8031fe:	74 0d                	je     80320d <insert_sorted_with_merge_freeList+0x572>
  803200:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803203:	8b 40 04             	mov    0x4(%eax),%eax
  803206:	8b 55 08             	mov    0x8(%ebp),%edx
  803209:	89 10                	mov    %edx,(%eax)
  80320b:	eb 08                	jmp    803215 <insert_sorted_with_merge_freeList+0x57a>
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	a3 38 51 80 00       	mov    %eax,0x805138
  803215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803218:	8b 55 08             	mov    0x8(%ebp),%edx
  80321b:	89 50 04             	mov    %edx,0x4(%eax)
  80321e:	a1 44 51 80 00       	mov    0x805144,%eax
  803223:	40                   	inc    %eax
  803224:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	8b 50 0c             	mov    0xc(%eax),%edx
  80322f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803232:	8b 40 0c             	mov    0xc(%eax),%eax
  803235:	01 c2                	add    %eax,%edx
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80323d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803241:	75 17                	jne    80325a <insert_sorted_with_merge_freeList+0x5bf>
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	68 24 40 80 00       	push   $0x804024
  80324b:	68 6b 01 00 00       	push   $0x16b
  803250:	68 7b 3f 80 00       	push   $0x803f7b
  803255:	e8 28 d0 ff ff       	call   800282 <_panic>
  80325a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325d:	8b 00                	mov    (%eax),%eax
  80325f:	85 c0                	test   %eax,%eax
  803261:	74 10                	je     803273 <insert_sorted_with_merge_freeList+0x5d8>
  803263:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803266:	8b 00                	mov    (%eax),%eax
  803268:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326b:	8b 52 04             	mov    0x4(%edx),%edx
  80326e:	89 50 04             	mov    %edx,0x4(%eax)
  803271:	eb 0b                	jmp    80327e <insert_sorted_with_merge_freeList+0x5e3>
  803273:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803276:	8b 40 04             	mov    0x4(%eax),%eax
  803279:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80327e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803281:	8b 40 04             	mov    0x4(%eax),%eax
  803284:	85 c0                	test   %eax,%eax
  803286:	74 0f                	je     803297 <insert_sorted_with_merge_freeList+0x5fc>
  803288:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328b:	8b 40 04             	mov    0x4(%eax),%eax
  80328e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803291:	8b 12                	mov    (%edx),%edx
  803293:	89 10                	mov    %edx,(%eax)
  803295:	eb 0a                	jmp    8032a1 <insert_sorted_with_merge_freeList+0x606>
  803297:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329a:	8b 00                	mov    (%eax),%eax
  80329c:	a3 38 51 80 00       	mov    %eax,0x805138
  8032a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b4:	a1 44 51 80 00       	mov    0x805144,%eax
  8032b9:	48                   	dec    %eax
  8032ba:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032d7:	75 17                	jne    8032f0 <insert_sorted_with_merge_freeList+0x655>
  8032d9:	83 ec 04             	sub    $0x4,%esp
  8032dc:	68 58 3f 80 00       	push   $0x803f58
  8032e1:	68 6e 01 00 00       	push   $0x16e
  8032e6:	68 7b 3f 80 00       	push   $0x803f7b
  8032eb:	e8 92 cf ff ff       	call   800282 <_panic>
  8032f0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f9:	89 10                	mov    %edx,(%eax)
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	8b 00                	mov    (%eax),%eax
  803300:	85 c0                	test   %eax,%eax
  803302:	74 0d                	je     803311 <insert_sorted_with_merge_freeList+0x676>
  803304:	a1 48 51 80 00       	mov    0x805148,%eax
  803309:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80330c:	89 50 04             	mov    %edx,0x4(%eax)
  80330f:	eb 08                	jmp    803319 <insert_sorted_with_merge_freeList+0x67e>
  803311:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803314:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803319:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331c:	a3 48 51 80 00       	mov    %eax,0x805148
  803321:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803324:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332b:	a1 54 51 80 00       	mov    0x805154,%eax
  803330:	40                   	inc    %eax
  803331:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803336:	e9 a9 00 00 00       	jmp    8033e4 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80333b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80333f:	74 06                	je     803347 <insert_sorted_with_merge_freeList+0x6ac>
  803341:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803345:	75 17                	jne    80335e <insert_sorted_with_merge_freeList+0x6c3>
  803347:	83 ec 04             	sub    $0x4,%esp
  80334a:	68 f0 3f 80 00       	push   $0x803ff0
  80334f:	68 73 01 00 00       	push   $0x173
  803354:	68 7b 3f 80 00       	push   $0x803f7b
  803359:	e8 24 cf ff ff       	call   800282 <_panic>
  80335e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803361:	8b 10                	mov    (%eax),%edx
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	89 10                	mov    %edx,(%eax)
  803368:	8b 45 08             	mov    0x8(%ebp),%eax
  80336b:	8b 00                	mov    (%eax),%eax
  80336d:	85 c0                	test   %eax,%eax
  80336f:	74 0b                	je     80337c <insert_sorted_with_merge_freeList+0x6e1>
  803371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	8b 55 08             	mov    0x8(%ebp),%edx
  803379:	89 50 04             	mov    %edx,0x4(%eax)
  80337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337f:	8b 55 08             	mov    0x8(%ebp),%edx
  803382:	89 10                	mov    %edx,(%eax)
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80338a:	89 50 04             	mov    %edx,0x4(%eax)
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	8b 00                	mov    (%eax),%eax
  803392:	85 c0                	test   %eax,%eax
  803394:	75 08                	jne    80339e <insert_sorted_with_merge_freeList+0x703>
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80339e:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a3:	40                   	inc    %eax
  8033a4:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033a9:	eb 39                	jmp    8033e4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8033b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b7:	74 07                	je     8033c0 <insert_sorted_with_merge_freeList+0x725>
  8033b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bc:	8b 00                	mov    (%eax),%eax
  8033be:	eb 05                	jmp    8033c5 <insert_sorted_with_merge_freeList+0x72a>
  8033c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033c5:	a3 40 51 80 00       	mov    %eax,0x805140
  8033ca:	a1 40 51 80 00       	mov    0x805140,%eax
  8033cf:	85 c0                	test   %eax,%eax
  8033d1:	0f 85 c7 fb ff ff    	jne    802f9e <insert_sorted_with_merge_freeList+0x303>
  8033d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033db:	0f 85 bd fb ff ff    	jne    802f9e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033e1:	eb 01                	jmp    8033e4 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033e3:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033e4:	90                   	nop
  8033e5:	c9                   	leave  
  8033e6:	c3                   	ret    
  8033e7:	90                   	nop

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
