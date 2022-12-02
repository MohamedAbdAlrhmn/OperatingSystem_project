
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
  800045:	68 20 35 80 00       	push   $0x803520
  80004a:	e8 b7 14 00 00       	call   801506 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 7b 16 00 00       	call   8016de <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 13 17 00 00       	call   80177e <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 35 80 00       	push   $0x803530
  800079:	e8 b8 04 00 00       	call   800536 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 63 35 80 00       	push   $0x803563
  800099:	e8 b2 18 00 00       	call   801950 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 bf 18 00 00       	call   80196e <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 1c 16 00 00       	call   8016de <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 6c 35 80 00       	push   $0x80356c
  8000cb:	e8 66 04 00 00       	call   800536 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 ac 18 00 00       	call   80198a <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 f8 15 00 00       	call   8016de <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 90 16 00 00       	call   80177e <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 a0 35 80 00       	push   $0x8035a0
  800104:	e8 2d 04 00 00       	call   800536 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 f0 35 80 00       	push   $0x8035f0
  800114:	6a 1e                	push   $0x1e
  800116:	68 26 36 80 00       	push   $0x803626
  80011b:	e8 62 01 00 00       	call   800282 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 3c 36 80 00       	push   $0x80363c
  80012b:	e8 06 04 00 00       	call   800536 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 9c 36 80 00       	push   $0x80369c
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
  80014c:	e8 6d 18 00 00       	call   8019be <sys_getenvindex>
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
  800173:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 40 80 00       	mov    0x804020,%eax
  80017d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800183:	84 c0                	test   %al,%al
  800185:	74 0f                	je     800196 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800187:	a1 20 40 80 00       	mov    0x804020,%eax
  80018c:	05 5c 05 00 00       	add    $0x55c,%eax
  800191:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019a:	7e 0a                	jle    8001a6 <libmain+0x60>
		binaryname = argv[0];
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	e8 84 fe ff ff       	call   800038 <_main>
  8001b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b7:	e8 0f 16 00 00       	call   8017cb <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 00 37 80 00       	push   $0x803700
  8001c4:	e8 6d 03 00 00       	call   800536 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	52                   	push   %edx
  8001e6:	50                   	push   %eax
  8001e7:	68 28 37 80 00       	push   $0x803728
  8001ec:	e8 45 03 00 00       	call   800536 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80020a:	a1 20 40 80 00       	mov    0x804020,%eax
  80020f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800215:	51                   	push   %ecx
  800216:	52                   	push   %edx
  800217:	50                   	push   %eax
  800218:	68 50 37 80 00       	push   $0x803750
  80021d:	e8 14 03 00 00       	call   800536 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 a8 37 80 00       	push   $0x8037a8
  800239:	e8 f8 02 00 00       	call   800536 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 00 37 80 00       	push   $0x803700
  800249:	e8 e8 02 00 00       	call   800536 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800251:	e8 8f 15 00 00       	call   8017e5 <sys_enable_interrupt>

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
  800269:	e8 1c 17 00 00       	call   80198a <sys_destroy_env>
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
  80027a:	e8 71 17 00 00       	call   8019f0 <sys_exit_env>
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
  800291:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	74 16                	je     8002b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	50                   	push   %eax
  8002a3:	68 bc 37 80 00       	push   $0x8037bc
  8002a8:	e8 89 02 00 00       	call   800536 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 c1 37 80 00       	push   $0x8037c1
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
  8002e0:	68 dd 37 80 00       	push   $0x8037dd
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
  8002fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ff:	8b 50 74             	mov    0x74(%eax),%edx
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	39 c2                	cmp    %eax,%edx
  800307:	74 14                	je     80031d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 e0 37 80 00       	push   $0x8037e0
  800311:	6a 26                	push   $0x26
  800313:	68 2c 38 80 00       	push   $0x80382c
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
  80035d:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80037d:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8003c6:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8003de:	68 38 38 80 00       	push   $0x803838
  8003e3:	6a 3a                	push   $0x3a
  8003e5:	68 2c 38 80 00       	push   $0x80382c
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
  80040e:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800434:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80044e:	68 8c 38 80 00       	push   $0x80388c
  800453:	6a 44                	push   $0x44
  800455:	68 2c 38 80 00       	push   $0x80382c
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
  80048d:	a0 24 40 80 00       	mov    0x804024,%al
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
  8004a8:	e8 70 11 00 00       	call   80161d <sys_cputs>
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
  800502:	a0 24 40 80 00       	mov    0x804024,%al
  800507:	0f b6 c0             	movzbl %al,%eax
  80050a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800510:	83 ec 04             	sub    $0x4,%esp
  800513:	50                   	push   %eax
  800514:	52                   	push   %edx
  800515:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051b:	83 c0 08             	add    $0x8,%eax
  80051e:	50                   	push   %eax
  80051f:	e8 f9 10 00 00       	call   80161d <sys_cputs>
  800524:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800527:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
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
  80053c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
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
  800569:	e8 5d 12 00 00       	call   8017cb <sys_disable_interrupt>
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
  800589:	e8 57 12 00 00       	call   8017e5 <sys_enable_interrupt>
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
  8005d3:	e8 c8 2c 00 00       	call   8032a0 <__udivdi3>
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
  800623:	e8 88 2d 00 00       	call   8033b0 <__umoddi3>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	05 f4 3a 80 00       	add    $0x803af4,%eax
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
  80077e:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
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
  80085f:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  800866:	85 f6                	test   %esi,%esi
  800868:	75 19                	jne    800883 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086a:	53                   	push   %ebx
  80086b:	68 05 3b 80 00       	push   $0x803b05
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
  800884:	68 0e 3b 80 00       	push   $0x803b0e
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
  8008b1:	be 11 3b 80 00       	mov    $0x803b11,%esi
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
  8012c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 1f                	je     8012ee <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cf:	e8 1d 00 00 00       	call   8012f1 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	68 70 3c 80 00       	push   $0x803c70
  8012dc:	e8 55 f2 ff ff       	call   800536 <cprintf>
  8012e1:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e4:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
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
  8012f7:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012fe:	00 00 00 
  801301:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801308:	00 00 00 
  80130b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801312:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801315:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80131c:	00 00 00 
  80131f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801326:	00 00 00 
  801329:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
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
  80134e:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801353:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80135a:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80135d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801364:	a1 20 41 80 00       	mov    0x804120,%eax
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  80138a:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801391:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801394:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801399:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139e:	83 ec 04             	sub    $0x4,%esp
  8013a1:	6a 03                	push   $0x3
  8013a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a6:	50                   	push   %eax
  8013a7:	e8 b5 03 00 00       	call   801761 <sys_allocate_chunk>
  8013ac:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013af:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b4:	83 ec 0c             	sub    $0xc,%esp
  8013b7:	50                   	push   %eax
  8013b8:	e8 2a 0a 00 00       	call   801de7 <initialize_MemBlocksList>
  8013bd:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013c0:	a1 48 41 80 00       	mov    0x804148,%eax
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
  8013e5:	68 95 3c 80 00       	push   $0x803c95
  8013ea:	6a 33                	push   $0x33
  8013ec:	68 b3 3c 80 00       	push   $0x803cb3
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
  801415:	a3 4c 41 80 00       	mov    %eax,0x80414c
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
  801438:	a3 48 41 80 00       	mov    %eax,0x804148
  80143d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801446:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801449:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801450:	a1 54 41 80 00       	mov    0x804154,%eax
  801455:	48                   	dec    %eax
  801456:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  80145b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80145f:	75 14                	jne    801475 <initialize_dyn_block_system+0x184>
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	68 c0 3c 80 00       	push   $0x803cc0
  801469:	6a 34                	push   $0x34
  80146b:	68 b3 3c 80 00       	push   $0x803cb3
  801470:	e8 0d ee ff ff       	call   800282 <_panic>
  801475:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80147b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147e:	89 10                	mov    %edx,(%eax)
  801480:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	85 c0                	test   %eax,%eax
  801487:	74 0d                	je     801496 <initialize_dyn_block_system+0x1a5>
  801489:	a1 38 41 80 00       	mov    0x804138,%eax
  80148e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801491:	89 50 04             	mov    %edx,0x4(%eax)
  801494:	eb 08                	jmp    80149e <initialize_dyn_block_system+0x1ad>
  801496:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801499:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80149e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a1:	a3 38 41 80 00       	mov    %eax,0x804138
  8014a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014b0:	a1 44 41 80 00       	mov    0x804144,%eax
  8014b5:	40                   	inc    %eax
  8014b6:	a3 44 41 80 00       	mov    %eax,0x804144
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
  8014c1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014c4:	e8 f7 fd ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014cd:	75 07                	jne    8014d6 <malloc+0x18>
  8014cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d4:	eb 14                	jmp    8014ea <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	68 e4 3c 80 00       	push   $0x803ce4
  8014de:	6a 46                	push   $0x46
  8014e0:	68 b3 3c 80 00       	push   $0x803cb3
  8014e5:	e8 98 ed ff ff       	call   800282 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	68 0c 3d 80 00       	push   $0x803d0c
  8014fa:	6a 61                	push   $0x61
  8014fc:	68 b3 3c 80 00       	push   $0x803cb3
  801501:	e8 7c ed ff ff       	call   800282 <_panic>

00801506 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	83 ec 18             	sub    $0x18,%esp
  80150c:	8b 45 10             	mov    0x10(%ebp),%eax
  80150f:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801512:	e8 a9 fd ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801517:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151b:	75 07                	jne    801524 <smalloc+0x1e>
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
  801522:	eb 14                	jmp    801538 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	68 30 3d 80 00       	push   $0x803d30
  80152c:	6a 76                	push   $0x76
  80152e:	68 b3 3c 80 00       	push   $0x803cb3
  801533:	e8 4a ed ff ff       	call   800282 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801540:	e8 7b fd ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801545:	83 ec 04             	sub    $0x4,%esp
  801548:	68 58 3d 80 00       	push   $0x803d58
  80154d:	68 93 00 00 00       	push   $0x93
  801552:	68 b3 3c 80 00       	push   $0x803cb3
  801557:	e8 26 ed ff ff       	call   800282 <_panic>

0080155c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801562:	e8 59 fd ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	68 7c 3d 80 00       	push   $0x803d7c
  80156f:	68 c5 00 00 00       	push   $0xc5
  801574:	68 b3 3c 80 00       	push   $0x803cb3
  801579:	e8 04 ed ff ff       	call   800282 <_panic>

0080157e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801584:	83 ec 04             	sub    $0x4,%esp
  801587:	68 a4 3d 80 00       	push   $0x803da4
  80158c:	68 d9 00 00 00       	push   $0xd9
  801591:	68 b3 3c 80 00       	push   $0x803cb3
  801596:	e8 e7 ec ff ff       	call   800282 <_panic>

0080159b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015a1:	83 ec 04             	sub    $0x4,%esp
  8015a4:	68 c8 3d 80 00       	push   $0x803dc8
  8015a9:	68 e4 00 00 00       	push   $0xe4
  8015ae:	68 b3 3c 80 00       	push   $0x803cb3
  8015b3:	e8 ca ec ff ff       	call   800282 <_panic>

008015b8 <shrink>:

}
void shrink(uint32 newSize)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015be:	83 ec 04             	sub    $0x4,%esp
  8015c1:	68 c8 3d 80 00       	push   $0x803dc8
  8015c6:	68 e9 00 00 00       	push   $0xe9
  8015cb:	68 b3 3c 80 00       	push   $0x803cb3
  8015d0:	e8 ad ec ff ff       	call   800282 <_panic>

008015d5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	68 c8 3d 80 00       	push   $0x803dc8
  8015e3:	68 ee 00 00 00       	push   $0xee
  8015e8:	68 b3 3c 80 00       	push   $0x803cb3
  8015ed:	e8 90 ec ff ff       	call   800282 <_panic>

008015f2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	57                   	push   %edi
  8015f6:	56                   	push   %esi
  8015f7:	53                   	push   %ebx
  8015f8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801601:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801604:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801607:	8b 7d 18             	mov    0x18(%ebp),%edi
  80160a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80160d:	cd 30                	int    $0x30
  80160f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	5b                   	pop    %ebx
  801619:	5e                   	pop    %esi
  80161a:	5f                   	pop    %edi
  80161b:	5d                   	pop    %ebp
  80161c:	c3                   	ret    

0080161d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	83 ec 04             	sub    $0x4,%esp
  801623:	8b 45 10             	mov    0x10(%ebp),%eax
  801626:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801629:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80162d:	8b 45 08             	mov    0x8(%ebp),%eax
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	52                   	push   %edx
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	50                   	push   %eax
  801639:	6a 00                	push   $0x0
  80163b:	e8 b2 ff ff ff       	call   8015f2 <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
}
  801643:	90                   	nop
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <sys_cgetc>:

int
sys_cgetc(void)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 01                	push   $0x1
  801655:	e8 98 ff ff ff       	call   8015f2 <syscall>
  80165a:	83 c4 18             	add    $0x18,%esp
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801662:	8b 55 0c             	mov    0xc(%ebp),%edx
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	52                   	push   %edx
  80166f:	50                   	push   %eax
  801670:	6a 05                	push   $0x5
  801672:	e8 7b ff ff ff       	call   8015f2 <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	56                   	push   %esi
  801680:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801681:	8b 75 18             	mov    0x18(%ebp),%esi
  801684:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801687:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80168a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	56                   	push   %esi
  801691:	53                   	push   %ebx
  801692:	51                   	push   %ecx
  801693:	52                   	push   %edx
  801694:	50                   	push   %eax
  801695:	6a 06                	push   $0x6
  801697:	e8 56 ff ff ff       	call   8015f2 <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
}
  80169f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016a2:	5b                   	pop    %ebx
  8016a3:	5e                   	pop    %esi
  8016a4:	5d                   	pop    %ebp
  8016a5:	c3                   	ret    

008016a6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	52                   	push   %edx
  8016b6:	50                   	push   %eax
  8016b7:	6a 07                	push   $0x7
  8016b9:	e8 34 ff ff ff       	call   8015f2 <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	ff 75 08             	pushl  0x8(%ebp)
  8016d2:	6a 08                	push   $0x8
  8016d4:	e8 19 ff ff ff       	call   8015f2 <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 09                	push   $0x9
  8016ed:	e8 00 ff ff ff       	call   8015f2 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 0a                	push   $0xa
  801706:	e8 e7 fe ff ff       	call   8015f2 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 0b                	push   $0xb
  80171f:	e8 ce fe ff ff       	call   8015f2 <syscall>
  801724:	83 c4 18             	add    $0x18,%esp
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	ff 75 08             	pushl  0x8(%ebp)
  801738:	6a 0f                	push   $0xf
  80173a:	e8 b3 fe ff ff       	call   8015f2 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
	return;
  801742:	90                   	nop
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	ff 75 0c             	pushl  0xc(%ebp)
  801751:	ff 75 08             	pushl  0x8(%ebp)
  801754:	6a 10                	push   $0x10
  801756:	e8 97 fe ff ff       	call   8015f2 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
	return ;
  80175e:	90                   	nop
}
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	ff 75 10             	pushl  0x10(%ebp)
  80176b:	ff 75 0c             	pushl  0xc(%ebp)
  80176e:	ff 75 08             	pushl  0x8(%ebp)
  801771:	6a 11                	push   $0x11
  801773:	e8 7a fe ff ff       	call   8015f2 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
	return ;
  80177b:	90                   	nop
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 0c                	push   $0xc
  80178d:	e8 60 fe ff ff       	call   8015f2 <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	ff 75 08             	pushl  0x8(%ebp)
  8017a5:	6a 0d                	push   $0xd
  8017a7:	e8 46 fe ff ff       	call   8015f2 <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 0e                	push   $0xe
  8017c0:	e8 2d fe ff ff       	call   8015f2 <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	90                   	nop
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 13                	push   $0x13
  8017da:	e8 13 fe ff ff       	call   8015f2 <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
}
  8017e2:	90                   	nop
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 14                	push   $0x14
  8017f4:	e8 f9 fd ff ff       	call   8015f2 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	90                   	nop
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_cputc>:


void
sys_cputc(const char c)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 04             	sub    $0x4,%esp
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80180b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	50                   	push   %eax
  801818:	6a 15                	push   $0x15
  80181a:	e8 d3 fd ff ff       	call   8015f2 <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
}
  801822:	90                   	nop
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 16                	push   $0x16
  801834:	e8 b9 fd ff ff       	call   8015f2 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	90                   	nop
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	ff 75 0c             	pushl  0xc(%ebp)
  80184e:	50                   	push   %eax
  80184f:	6a 17                	push   $0x17
  801851:	e8 9c fd ff ff       	call   8015f2 <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80185e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	52                   	push   %edx
  80186b:	50                   	push   %eax
  80186c:	6a 1a                	push   $0x1a
  80186e:	e8 7f fd ff ff       	call   8015f2 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80187b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	52                   	push   %edx
  801888:	50                   	push   %eax
  801889:	6a 18                	push   $0x18
  80188b:	e8 62 fd ff ff       	call   8015f2 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	52                   	push   %edx
  8018a6:	50                   	push   %eax
  8018a7:	6a 19                	push   $0x19
  8018a9:	e8 44 fd ff ff       	call   8015f2 <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	90                   	nop
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 04             	sub    $0x4,%esp
  8018ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018c0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	6a 00                	push   $0x0
  8018cc:	51                   	push   %ecx
  8018cd:	52                   	push   %edx
  8018ce:	ff 75 0c             	pushl  0xc(%ebp)
  8018d1:	50                   	push   %eax
  8018d2:	6a 1b                	push   $0x1b
  8018d4:	e8 19 fd ff ff       	call   8015f2 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	52                   	push   %edx
  8018ee:	50                   	push   %eax
  8018ef:	6a 1c                	push   $0x1c
  8018f1:	e8 fc fc ff ff       	call   8015f2 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801901:	8b 55 0c             	mov    0xc(%ebp),%edx
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	51                   	push   %ecx
  80190c:	52                   	push   %edx
  80190d:	50                   	push   %eax
  80190e:	6a 1d                	push   $0x1d
  801910:	e8 dd fc ff ff       	call   8015f2 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80191d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	52                   	push   %edx
  80192a:	50                   	push   %eax
  80192b:	6a 1e                	push   $0x1e
  80192d:	e8 c0 fc ff ff       	call   8015f2 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 1f                	push   $0x1f
  801946:	e8 a7 fc ff ff       	call   8015f2 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	ff 75 14             	pushl  0x14(%ebp)
  80195b:	ff 75 10             	pushl  0x10(%ebp)
  80195e:	ff 75 0c             	pushl  0xc(%ebp)
  801961:	50                   	push   %eax
  801962:	6a 20                	push   $0x20
  801964:	e8 89 fc ff ff       	call   8015f2 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	50                   	push   %eax
  80197d:	6a 21                	push   $0x21
  80197f:	e8 6e fc ff ff       	call   8015f2 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	90                   	nop
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	50                   	push   %eax
  801999:	6a 22                	push   $0x22
  80199b:	e8 52 fc ff ff       	call   8015f2 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 02                	push   $0x2
  8019b4:	e8 39 fc ff ff       	call   8015f2 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 03                	push   $0x3
  8019cd:	e8 20 fc ff ff       	call   8015f2 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 04                	push   $0x4
  8019e6:	e8 07 fc ff ff       	call   8015f2 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_exit_env>:


void sys_exit_env(void)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 23                	push   $0x23
  8019ff:	e8 ee fb ff ff       	call   8015f2 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	90                   	nop
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a10:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a13:	8d 50 04             	lea    0x4(%eax),%edx
  801a16:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	52                   	push   %edx
  801a20:	50                   	push   %eax
  801a21:	6a 24                	push   $0x24
  801a23:	e8 ca fb ff ff       	call   8015f2 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
	return result;
  801a2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a31:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a34:	89 01                	mov    %eax,(%ecx)
  801a36:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	c9                   	leave  
  801a3d:	c2 04 00             	ret    $0x4

00801a40 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	ff 75 10             	pushl  0x10(%ebp)
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	ff 75 08             	pushl  0x8(%ebp)
  801a50:	6a 12                	push   $0x12
  801a52:	e8 9b fb ff ff       	call   8015f2 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5a:	90                   	nop
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_rcr2>:
uint32 sys_rcr2()
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 25                	push   $0x25
  801a6c:	e8 81 fb ff ff       	call   8015f2 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 04             	sub    $0x4,%esp
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a82:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	50                   	push   %eax
  801a8f:	6a 26                	push   $0x26
  801a91:	e8 5c fb ff ff       	call   8015f2 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
	return ;
  801a99:	90                   	nop
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <rsttst>:
void rsttst()
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 28                	push   $0x28
  801aab:	e8 42 fb ff ff       	call   8015f2 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab3:	90                   	nop
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 04             	sub    $0x4,%esp
  801abc:	8b 45 14             	mov    0x14(%ebp),%eax
  801abf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ac2:	8b 55 18             	mov    0x18(%ebp),%edx
  801ac5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ac9:	52                   	push   %edx
  801aca:	50                   	push   %eax
  801acb:	ff 75 10             	pushl  0x10(%ebp)
  801ace:	ff 75 0c             	pushl  0xc(%ebp)
  801ad1:	ff 75 08             	pushl  0x8(%ebp)
  801ad4:	6a 27                	push   $0x27
  801ad6:	e8 17 fb ff ff       	call   8015f2 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ade:	90                   	nop
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <chktst>:
void chktst(uint32 n)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	ff 75 08             	pushl  0x8(%ebp)
  801aef:	6a 29                	push   $0x29
  801af1:	e8 fc fa ff ff       	call   8015f2 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
	return ;
  801af9:	90                   	nop
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <inctst>:

void inctst()
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 2a                	push   $0x2a
  801b0b:	e8 e2 fa ff ff       	call   8015f2 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
	return ;
  801b13:	90                   	nop
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <gettst>:
uint32 gettst()
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 2b                	push   $0x2b
  801b25:	e8 c8 fa ff ff       	call   8015f2 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 2c                	push   $0x2c
  801b41:	e8 ac fa ff ff       	call   8015f2 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
  801b49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b4c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b50:	75 07                	jne    801b59 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b52:	b8 01 00 00 00       	mov    $0x1,%eax
  801b57:	eb 05                	jmp    801b5e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 2c                	push   $0x2c
  801b72:	e8 7b fa ff ff       	call   8015f2 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
  801b7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b7d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b81:	75 07                	jne    801b8a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b83:	b8 01 00 00 00       	mov    $0x1,%eax
  801b88:	eb 05                	jmp    801b8f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 2c                	push   $0x2c
  801ba3:	e8 4a fa ff ff       	call   8015f2 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
  801bab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bae:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bb2:	75 07                	jne    801bbb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bb4:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb9:	eb 05                	jmp    801bc0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801bd4:	e8 19 fa ff ff       	call   8015f2 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
  801bdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bdf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801be3:	75 07                	jne    801bec <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801be5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bea:	eb 05                	jmp    801bf1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	ff 75 08             	pushl  0x8(%ebp)
  801c01:	6a 2d                	push   $0x2d
  801c03:	e8 ea f9 ff ff       	call   8015f2 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0b:	90                   	nop
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c12:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c15:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	6a 00                	push   $0x0
  801c20:	53                   	push   %ebx
  801c21:	51                   	push   %ecx
  801c22:	52                   	push   %edx
  801c23:	50                   	push   %eax
  801c24:	6a 2e                	push   $0x2e
  801c26:	e8 c7 f9 ff ff       	call   8015f2 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c39:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	52                   	push   %edx
  801c43:	50                   	push   %eax
  801c44:	6a 2f                	push   $0x2f
  801c46:	e8 a7 f9 ff ff       	call   8015f2 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c56:	83 ec 0c             	sub    $0xc,%esp
  801c59:	68 d8 3d 80 00       	push   $0x803dd8
  801c5e:	e8 d3 e8 ff ff       	call   800536 <cprintf>
  801c63:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c66:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c6d:	83 ec 0c             	sub    $0xc,%esp
  801c70:	68 04 3e 80 00       	push   $0x803e04
  801c75:	e8 bc e8 ff ff       	call   800536 <cprintf>
  801c7a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c7d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c81:	a1 38 41 80 00       	mov    0x804138,%eax
  801c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c89:	eb 56                	jmp    801ce1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c8f:	74 1c                	je     801cad <print_mem_block_lists+0x5d>
  801c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c94:	8b 50 08             	mov    0x8(%eax),%edx
  801c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9a:	8b 48 08             	mov    0x8(%eax),%ecx
  801c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca3:	01 c8                	add    %ecx,%eax
  801ca5:	39 c2                	cmp    %eax,%edx
  801ca7:	73 04                	jae    801cad <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ca9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb0:	8b 50 08             	mov    0x8(%eax),%edx
  801cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb6:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb9:	01 c2                	add    %eax,%edx
  801cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbe:	8b 40 08             	mov    0x8(%eax),%eax
  801cc1:	83 ec 04             	sub    $0x4,%esp
  801cc4:	52                   	push   %edx
  801cc5:	50                   	push   %eax
  801cc6:	68 19 3e 80 00       	push   $0x803e19
  801ccb:	e8 66 e8 ff ff       	call   800536 <cprintf>
  801cd0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cd9:	a1 40 41 80 00       	mov    0x804140,%eax
  801cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ce5:	74 07                	je     801cee <print_mem_block_lists+0x9e>
  801ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cea:	8b 00                	mov    (%eax),%eax
  801cec:	eb 05                	jmp    801cf3 <print_mem_block_lists+0xa3>
  801cee:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf3:	a3 40 41 80 00       	mov    %eax,0x804140
  801cf8:	a1 40 41 80 00       	mov    0x804140,%eax
  801cfd:	85 c0                	test   %eax,%eax
  801cff:	75 8a                	jne    801c8b <print_mem_block_lists+0x3b>
  801d01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d05:	75 84                	jne    801c8b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d07:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d0b:	75 10                	jne    801d1d <print_mem_block_lists+0xcd>
  801d0d:	83 ec 0c             	sub    $0xc,%esp
  801d10:	68 28 3e 80 00       	push   $0x803e28
  801d15:	e8 1c e8 ff ff       	call   800536 <cprintf>
  801d1a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d1d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d24:	83 ec 0c             	sub    $0xc,%esp
  801d27:	68 4c 3e 80 00       	push   $0x803e4c
  801d2c:	e8 05 e8 ff ff       	call   800536 <cprintf>
  801d31:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d34:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d38:	a1 40 40 80 00       	mov    0x804040,%eax
  801d3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d40:	eb 56                	jmp    801d98 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d46:	74 1c                	je     801d64 <print_mem_block_lists+0x114>
  801d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4b:	8b 50 08             	mov    0x8(%eax),%edx
  801d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d51:	8b 48 08             	mov    0x8(%eax),%ecx
  801d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d57:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5a:	01 c8                	add    %ecx,%eax
  801d5c:	39 c2                	cmp    %eax,%edx
  801d5e:	73 04                	jae    801d64 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d60:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d67:	8b 50 08             	mov    0x8(%eax),%edx
  801d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d70:	01 c2                	add    %eax,%edx
  801d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d75:	8b 40 08             	mov    0x8(%eax),%eax
  801d78:	83 ec 04             	sub    $0x4,%esp
  801d7b:	52                   	push   %edx
  801d7c:	50                   	push   %eax
  801d7d:	68 19 3e 80 00       	push   $0x803e19
  801d82:	e8 af e7 ff ff       	call   800536 <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d90:	a1 48 40 80 00       	mov    0x804048,%eax
  801d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d9c:	74 07                	je     801da5 <print_mem_block_lists+0x155>
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da1:	8b 00                	mov    (%eax),%eax
  801da3:	eb 05                	jmp    801daa <print_mem_block_lists+0x15a>
  801da5:	b8 00 00 00 00       	mov    $0x0,%eax
  801daa:	a3 48 40 80 00       	mov    %eax,0x804048
  801daf:	a1 48 40 80 00       	mov    0x804048,%eax
  801db4:	85 c0                	test   %eax,%eax
  801db6:	75 8a                	jne    801d42 <print_mem_block_lists+0xf2>
  801db8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dbc:	75 84                	jne    801d42 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801dbe:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dc2:	75 10                	jne    801dd4 <print_mem_block_lists+0x184>
  801dc4:	83 ec 0c             	sub    $0xc,%esp
  801dc7:	68 64 3e 80 00       	push   $0x803e64
  801dcc:	e8 65 e7 ff ff       	call   800536 <cprintf>
  801dd1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801dd4:	83 ec 0c             	sub    $0xc,%esp
  801dd7:	68 d8 3d 80 00       	push   $0x803dd8
  801ddc:	e8 55 e7 ff ff       	call   800536 <cprintf>
  801de1:	83 c4 10             	add    $0x10,%esp

}
  801de4:	90                   	nop
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ded:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801df4:	00 00 00 
  801df7:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801dfe:	00 00 00 
  801e01:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e08:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e12:	e9 9e 00 00 00       	jmp    801eb5 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e17:	a1 50 40 80 00       	mov    0x804050,%eax
  801e1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1f:	c1 e2 04             	shl    $0x4,%edx
  801e22:	01 d0                	add    %edx,%eax
  801e24:	85 c0                	test   %eax,%eax
  801e26:	75 14                	jne    801e3c <initialize_MemBlocksList+0x55>
  801e28:	83 ec 04             	sub    $0x4,%esp
  801e2b:	68 8c 3e 80 00       	push   $0x803e8c
  801e30:	6a 46                	push   $0x46
  801e32:	68 af 3e 80 00       	push   $0x803eaf
  801e37:	e8 46 e4 ff ff       	call   800282 <_panic>
  801e3c:	a1 50 40 80 00       	mov    0x804050,%eax
  801e41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e44:	c1 e2 04             	shl    $0x4,%edx
  801e47:	01 d0                	add    %edx,%eax
  801e49:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e4f:	89 10                	mov    %edx,(%eax)
  801e51:	8b 00                	mov    (%eax),%eax
  801e53:	85 c0                	test   %eax,%eax
  801e55:	74 18                	je     801e6f <initialize_MemBlocksList+0x88>
  801e57:	a1 48 41 80 00       	mov    0x804148,%eax
  801e5c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e62:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e65:	c1 e1 04             	shl    $0x4,%ecx
  801e68:	01 ca                	add    %ecx,%edx
  801e6a:	89 50 04             	mov    %edx,0x4(%eax)
  801e6d:	eb 12                	jmp    801e81 <initialize_MemBlocksList+0x9a>
  801e6f:	a1 50 40 80 00       	mov    0x804050,%eax
  801e74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e77:	c1 e2 04             	shl    $0x4,%edx
  801e7a:	01 d0                	add    %edx,%eax
  801e7c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e81:	a1 50 40 80 00       	mov    0x804050,%eax
  801e86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e89:	c1 e2 04             	shl    $0x4,%edx
  801e8c:	01 d0                	add    %edx,%eax
  801e8e:	a3 48 41 80 00       	mov    %eax,0x804148
  801e93:	a1 50 40 80 00       	mov    0x804050,%eax
  801e98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9b:	c1 e2 04             	shl    $0x4,%edx
  801e9e:	01 d0                	add    %edx,%eax
  801ea0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ea7:	a1 54 41 80 00       	mov    0x804154,%eax
  801eac:	40                   	inc    %eax
  801ead:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801eb2:	ff 45 f4             	incl   -0xc(%ebp)
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ebb:	0f 82 56 ff ff ff    	jb     801e17 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801ec1:	90                   	nop
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	8b 00                	mov    (%eax),%eax
  801ecf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ed2:	eb 19                	jmp    801eed <find_block+0x29>
	{
		if(va==point->sva)
  801ed4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed7:	8b 40 08             	mov    0x8(%eax),%eax
  801eda:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801edd:	75 05                	jne    801ee4 <find_block+0x20>
		   return point;
  801edf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee2:	eb 36                	jmp    801f1a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	8b 40 08             	mov    0x8(%eax),%eax
  801eea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801eed:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ef1:	74 07                	je     801efa <find_block+0x36>
  801ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef6:	8b 00                	mov    (%eax),%eax
  801ef8:	eb 05                	jmp    801eff <find_block+0x3b>
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eff:	8b 55 08             	mov    0x8(%ebp),%edx
  801f02:	89 42 08             	mov    %eax,0x8(%edx)
  801f05:	8b 45 08             	mov    0x8(%ebp),%eax
  801f08:	8b 40 08             	mov    0x8(%eax),%eax
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	75 c5                	jne    801ed4 <find_block+0x10>
  801f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f13:	75 bf                	jne    801ed4 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1a:	c9                   	leave  
  801f1b:	c3                   	ret    

00801f1c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f22:	a1 40 40 80 00       	mov    0x804040,%eax
  801f27:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f2a:	a1 44 40 80 00       	mov    0x804044,%eax
  801f2f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f35:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f38:	74 24                	je     801f5e <insert_sorted_allocList+0x42>
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	8b 50 08             	mov    0x8(%eax),%edx
  801f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f43:	8b 40 08             	mov    0x8(%eax),%eax
  801f46:	39 c2                	cmp    %eax,%edx
  801f48:	76 14                	jbe    801f5e <insert_sorted_allocList+0x42>
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	8b 50 08             	mov    0x8(%eax),%edx
  801f50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f53:	8b 40 08             	mov    0x8(%eax),%eax
  801f56:	39 c2                	cmp    %eax,%edx
  801f58:	0f 82 60 01 00 00    	jb     8020be <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801f5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f62:	75 65                	jne    801fc9 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801f64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f68:	75 14                	jne    801f7e <insert_sorted_allocList+0x62>
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	68 8c 3e 80 00       	push   $0x803e8c
  801f72:	6a 6b                	push   $0x6b
  801f74:	68 af 3e 80 00       	push   $0x803eaf
  801f79:	e8 04 e3 ff ff       	call   800282 <_panic>
  801f7e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	89 10                	mov    %edx,(%eax)
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	8b 00                	mov    (%eax),%eax
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	74 0d                	je     801f9f <insert_sorted_allocList+0x83>
  801f92:	a1 40 40 80 00       	mov    0x804040,%eax
  801f97:	8b 55 08             	mov    0x8(%ebp),%edx
  801f9a:	89 50 04             	mov    %edx,0x4(%eax)
  801f9d:	eb 08                	jmp    801fa7 <insert_sorted_allocList+0x8b>
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	a3 44 40 80 00       	mov    %eax,0x804044
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	a3 40 40 80 00       	mov    %eax,0x804040
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fbe:	40                   	inc    %eax
  801fbf:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fc4:	e9 dc 01 00 00       	jmp    8021a5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	8b 50 08             	mov    0x8(%eax),%edx
  801fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd2:	8b 40 08             	mov    0x8(%eax),%eax
  801fd5:	39 c2                	cmp    %eax,%edx
  801fd7:	77 6c                	ja     802045 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801fd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fdd:	74 06                	je     801fe5 <insert_sorted_allocList+0xc9>
  801fdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe3:	75 14                	jne    801ff9 <insert_sorted_allocList+0xdd>
  801fe5:	83 ec 04             	sub    $0x4,%esp
  801fe8:	68 c8 3e 80 00       	push   $0x803ec8
  801fed:	6a 6f                	push   $0x6f
  801fef:	68 af 3e 80 00       	push   $0x803eaf
  801ff4:	e8 89 e2 ff ff       	call   800282 <_panic>
  801ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffc:	8b 50 04             	mov    0x4(%eax),%edx
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	89 50 04             	mov    %edx,0x4(%eax)
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80200b:	89 10                	mov    %edx,(%eax)
  80200d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802010:	8b 40 04             	mov    0x4(%eax),%eax
  802013:	85 c0                	test   %eax,%eax
  802015:	74 0d                	je     802024 <insert_sorted_allocList+0x108>
  802017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201a:	8b 40 04             	mov    0x4(%eax),%eax
  80201d:	8b 55 08             	mov    0x8(%ebp),%edx
  802020:	89 10                	mov    %edx,(%eax)
  802022:	eb 08                	jmp    80202c <insert_sorted_allocList+0x110>
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	a3 40 40 80 00       	mov    %eax,0x804040
  80202c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202f:	8b 55 08             	mov    0x8(%ebp),%edx
  802032:	89 50 04             	mov    %edx,0x4(%eax)
  802035:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80203a:	40                   	inc    %eax
  80203b:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802040:	e9 60 01 00 00       	jmp    8021a5 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	8b 50 08             	mov    0x8(%eax),%edx
  80204b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204e:	8b 40 08             	mov    0x8(%eax),%eax
  802051:	39 c2                	cmp    %eax,%edx
  802053:	0f 82 4c 01 00 00    	jb     8021a5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802059:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80205d:	75 14                	jne    802073 <insert_sorted_allocList+0x157>
  80205f:	83 ec 04             	sub    $0x4,%esp
  802062:	68 00 3f 80 00       	push   $0x803f00
  802067:	6a 73                	push   $0x73
  802069:	68 af 3e 80 00       	push   $0x803eaf
  80206e:	e8 0f e2 ff ff       	call   800282 <_panic>
  802073:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802079:	8b 45 08             	mov    0x8(%ebp),%eax
  80207c:	89 50 04             	mov    %edx,0x4(%eax)
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	8b 40 04             	mov    0x4(%eax),%eax
  802085:	85 c0                	test   %eax,%eax
  802087:	74 0c                	je     802095 <insert_sorted_allocList+0x179>
  802089:	a1 44 40 80 00       	mov    0x804044,%eax
  80208e:	8b 55 08             	mov    0x8(%ebp),%edx
  802091:	89 10                	mov    %edx,(%eax)
  802093:	eb 08                	jmp    80209d <insert_sorted_allocList+0x181>
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	a3 40 40 80 00       	mov    %eax,0x804040
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	a3 44 40 80 00       	mov    %eax,0x804044
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020ae:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020b3:	40                   	inc    %eax
  8020b4:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020b9:	e9 e7 00 00 00       	jmp    8021a5 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8020be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8020c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020cb:	a1 40 40 80 00       	mov    0x804040,%eax
  8020d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d3:	e9 9d 00 00 00       	jmp    802175 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8020d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020db:	8b 00                	mov    (%eax),%eax
  8020dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	8b 50 08             	mov    0x8(%eax),%edx
  8020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e9:	8b 40 08             	mov    0x8(%eax),%eax
  8020ec:	39 c2                	cmp    %eax,%edx
  8020ee:	76 7d                	jbe    80216d <insert_sorted_allocList+0x251>
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	8b 50 08             	mov    0x8(%eax),%edx
  8020f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f9:	8b 40 08             	mov    0x8(%eax),%eax
  8020fc:	39 c2                	cmp    %eax,%edx
  8020fe:	73 6d                	jae    80216d <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802104:	74 06                	je     80210c <insert_sorted_allocList+0x1f0>
  802106:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80210a:	75 14                	jne    802120 <insert_sorted_allocList+0x204>
  80210c:	83 ec 04             	sub    $0x4,%esp
  80210f:	68 24 3f 80 00       	push   $0x803f24
  802114:	6a 7f                	push   $0x7f
  802116:	68 af 3e 80 00       	push   $0x803eaf
  80211b:	e8 62 e1 ff ff       	call   800282 <_panic>
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802123:	8b 10                	mov    (%eax),%edx
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	89 10                	mov    %edx,(%eax)
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	8b 00                	mov    (%eax),%eax
  80212f:	85 c0                	test   %eax,%eax
  802131:	74 0b                	je     80213e <insert_sorted_allocList+0x222>
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	8b 55 08             	mov    0x8(%ebp),%edx
  80213b:	89 50 04             	mov    %edx,0x4(%eax)
  80213e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802141:	8b 55 08             	mov    0x8(%ebp),%edx
  802144:	89 10                	mov    %edx,(%eax)
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214c:	89 50 04             	mov    %edx,0x4(%eax)
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	8b 00                	mov    (%eax),%eax
  802154:	85 c0                	test   %eax,%eax
  802156:	75 08                	jne    802160 <insert_sorted_allocList+0x244>
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	a3 44 40 80 00       	mov    %eax,0x804044
  802160:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802165:	40                   	inc    %eax
  802166:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80216b:	eb 39                	jmp    8021a6 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80216d:	a1 48 40 80 00       	mov    0x804048,%eax
  802172:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802175:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802179:	74 07                	je     802182 <insert_sorted_allocList+0x266>
  80217b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217e:	8b 00                	mov    (%eax),%eax
  802180:	eb 05                	jmp    802187 <insert_sorted_allocList+0x26b>
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
  802187:	a3 48 40 80 00       	mov    %eax,0x804048
  80218c:	a1 48 40 80 00       	mov    0x804048,%eax
  802191:	85 c0                	test   %eax,%eax
  802193:	0f 85 3f ff ff ff    	jne    8020d8 <insert_sorted_allocList+0x1bc>
  802199:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219d:	0f 85 35 ff ff ff    	jne    8020d8 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021a3:	eb 01                	jmp    8021a6 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021a5:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021a6:	90                   	nop
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021af:	a1 38 41 80 00       	mov    0x804138,%eax
  8021b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b7:	e9 85 01 00 00       	jmp    802341 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8021bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8021c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c5:	0f 82 6e 01 00 00    	jb     802339 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021d4:	0f 85 8a 00 00 00    	jne    802264 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8021da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021de:	75 17                	jne    8021f7 <alloc_block_FF+0x4e>
  8021e0:	83 ec 04             	sub    $0x4,%esp
  8021e3:	68 58 3f 80 00       	push   $0x803f58
  8021e8:	68 93 00 00 00       	push   $0x93
  8021ed:	68 af 3e 80 00       	push   $0x803eaf
  8021f2:	e8 8b e0 ff ff       	call   800282 <_panic>
  8021f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fa:	8b 00                	mov    (%eax),%eax
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	74 10                	je     802210 <alloc_block_FF+0x67>
  802200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802203:	8b 00                	mov    (%eax),%eax
  802205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802208:	8b 52 04             	mov    0x4(%edx),%edx
  80220b:	89 50 04             	mov    %edx,0x4(%eax)
  80220e:	eb 0b                	jmp    80221b <alloc_block_FF+0x72>
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	8b 40 04             	mov    0x4(%eax),%eax
  802216:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80221b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221e:	8b 40 04             	mov    0x4(%eax),%eax
  802221:	85 c0                	test   %eax,%eax
  802223:	74 0f                	je     802234 <alloc_block_FF+0x8b>
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	8b 40 04             	mov    0x4(%eax),%eax
  80222b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222e:	8b 12                	mov    (%edx),%edx
  802230:	89 10                	mov    %edx,(%eax)
  802232:	eb 0a                	jmp    80223e <alloc_block_FF+0x95>
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	8b 00                	mov    (%eax),%eax
  802239:	a3 38 41 80 00       	mov    %eax,0x804138
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802251:	a1 44 41 80 00       	mov    0x804144,%eax
  802256:	48                   	dec    %eax
  802257:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	e9 10 01 00 00       	jmp    802374 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	8b 40 0c             	mov    0xc(%eax),%eax
  80226a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80226d:	0f 86 c6 00 00 00    	jbe    802339 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802273:	a1 48 41 80 00       	mov    0x804148,%eax
  802278:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227e:	8b 50 08             	mov    0x8(%eax),%edx
  802281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802284:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228a:	8b 55 08             	mov    0x8(%ebp),%edx
  80228d:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802290:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802294:	75 17                	jne    8022ad <alloc_block_FF+0x104>
  802296:	83 ec 04             	sub    $0x4,%esp
  802299:	68 58 3f 80 00       	push   $0x803f58
  80229e:	68 9b 00 00 00       	push   $0x9b
  8022a3:	68 af 3e 80 00       	push   $0x803eaf
  8022a8:	e8 d5 df ff ff       	call   800282 <_panic>
  8022ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b0:	8b 00                	mov    (%eax),%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	74 10                	je     8022c6 <alloc_block_FF+0x11d>
  8022b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b9:	8b 00                	mov    (%eax),%eax
  8022bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022be:	8b 52 04             	mov    0x4(%edx),%edx
  8022c1:	89 50 04             	mov    %edx,0x4(%eax)
  8022c4:	eb 0b                	jmp    8022d1 <alloc_block_FF+0x128>
  8022c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c9:	8b 40 04             	mov    0x4(%eax),%eax
  8022cc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d4:	8b 40 04             	mov    0x4(%eax),%eax
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	74 0f                	je     8022ea <alloc_block_FF+0x141>
  8022db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022de:	8b 40 04             	mov    0x4(%eax),%eax
  8022e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022e4:	8b 12                	mov    (%edx),%edx
  8022e6:	89 10                	mov    %edx,(%eax)
  8022e8:	eb 0a                	jmp    8022f4 <alloc_block_FF+0x14b>
  8022ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	a3 48 41 80 00       	mov    %eax,0x804148
  8022f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802300:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802307:	a1 54 41 80 00       	mov    0x804154,%eax
  80230c:	48                   	dec    %eax
  80230d:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 50 08             	mov    0x8(%eax),%edx
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	01 c2                	add    %eax,%edx
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	8b 40 0c             	mov    0xc(%eax),%eax
  802329:	2b 45 08             	sub    0x8(%ebp),%eax
  80232c:	89 c2                	mov    %eax,%edx
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802334:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802337:	eb 3b                	jmp    802374 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802339:	a1 40 41 80 00       	mov    0x804140,%eax
  80233e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802341:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802345:	74 07                	je     80234e <alloc_block_FF+0x1a5>
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 00                	mov    (%eax),%eax
  80234c:	eb 05                	jmp    802353 <alloc_block_FF+0x1aa>
  80234e:	b8 00 00 00 00       	mov    $0x0,%eax
  802353:	a3 40 41 80 00       	mov    %eax,0x804140
  802358:	a1 40 41 80 00       	mov    0x804140,%eax
  80235d:	85 c0                	test   %eax,%eax
  80235f:	0f 85 57 fe ff ff    	jne    8021bc <alloc_block_FF+0x13>
  802365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802369:	0f 85 4d fe ff ff    	jne    8021bc <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80236f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80237c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802383:	a1 38 41 80 00       	mov    0x804138,%eax
  802388:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238b:	e9 df 00 00 00       	jmp    80246f <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	8b 40 0c             	mov    0xc(%eax),%eax
  802396:	3b 45 08             	cmp    0x8(%ebp),%eax
  802399:	0f 82 c8 00 00 00    	jb     802467 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a8:	0f 85 8a 00 00 00    	jne    802438 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b2:	75 17                	jne    8023cb <alloc_block_BF+0x55>
  8023b4:	83 ec 04             	sub    $0x4,%esp
  8023b7:	68 58 3f 80 00       	push   $0x803f58
  8023bc:	68 b7 00 00 00       	push   $0xb7
  8023c1:	68 af 3e 80 00       	push   $0x803eaf
  8023c6:	e8 b7 de ff ff       	call   800282 <_panic>
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 00                	mov    (%eax),%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	74 10                	je     8023e4 <alloc_block_BF+0x6e>
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 00                	mov    (%eax),%eax
  8023d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023dc:	8b 52 04             	mov    0x4(%edx),%edx
  8023df:	89 50 04             	mov    %edx,0x4(%eax)
  8023e2:	eb 0b                	jmp    8023ef <alloc_block_BF+0x79>
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ea:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 40 04             	mov    0x4(%eax),%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	74 0f                	je     802408 <alloc_block_BF+0x92>
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 40 04             	mov    0x4(%eax),%eax
  8023ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802402:	8b 12                	mov    (%edx),%edx
  802404:	89 10                	mov    %edx,(%eax)
  802406:	eb 0a                	jmp    802412 <alloc_block_BF+0x9c>
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	a3 38 41 80 00       	mov    %eax,0x804138
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802425:	a1 44 41 80 00       	mov    0x804144,%eax
  80242a:	48                   	dec    %eax
  80242b:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	e9 4d 01 00 00       	jmp    802585 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 40 0c             	mov    0xc(%eax),%eax
  80243e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802441:	76 24                	jbe    802467 <alloc_block_BF+0xf1>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 0c             	mov    0xc(%eax),%eax
  802449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80244c:	73 19                	jae    802467 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80244e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 40 0c             	mov    0xc(%eax),%eax
  80245b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 40 08             	mov    0x8(%eax),%eax
  802464:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802467:	a1 40 41 80 00       	mov    0x804140,%eax
  80246c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80246f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802473:	74 07                	je     80247c <alloc_block_BF+0x106>
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 00                	mov    (%eax),%eax
  80247a:	eb 05                	jmp    802481 <alloc_block_BF+0x10b>
  80247c:	b8 00 00 00 00       	mov    $0x0,%eax
  802481:	a3 40 41 80 00       	mov    %eax,0x804140
  802486:	a1 40 41 80 00       	mov    0x804140,%eax
  80248b:	85 c0                	test   %eax,%eax
  80248d:	0f 85 fd fe ff ff    	jne    802390 <alloc_block_BF+0x1a>
  802493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802497:	0f 85 f3 fe ff ff    	jne    802390 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80249d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024a1:	0f 84 d9 00 00 00    	je     802580 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024a7:	a1 48 41 80 00       	mov    0x804148,%eax
  8024ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024b5:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8024b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024be:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8024c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024c5:	75 17                	jne    8024de <alloc_block_BF+0x168>
  8024c7:	83 ec 04             	sub    $0x4,%esp
  8024ca:	68 58 3f 80 00       	push   $0x803f58
  8024cf:	68 c7 00 00 00       	push   $0xc7
  8024d4:	68 af 3e 80 00       	push   $0x803eaf
  8024d9:	e8 a4 dd ff ff       	call   800282 <_panic>
  8024de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e1:	8b 00                	mov    (%eax),%eax
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	74 10                	je     8024f7 <alloc_block_BF+0x181>
  8024e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ea:	8b 00                	mov    (%eax),%eax
  8024ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024ef:	8b 52 04             	mov    0x4(%edx),%edx
  8024f2:	89 50 04             	mov    %edx,0x4(%eax)
  8024f5:	eb 0b                	jmp    802502 <alloc_block_BF+0x18c>
  8024f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024fa:	8b 40 04             	mov    0x4(%eax),%eax
  8024fd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802505:	8b 40 04             	mov    0x4(%eax),%eax
  802508:	85 c0                	test   %eax,%eax
  80250a:	74 0f                	je     80251b <alloc_block_BF+0x1a5>
  80250c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250f:	8b 40 04             	mov    0x4(%eax),%eax
  802512:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802515:	8b 12                	mov    (%edx),%edx
  802517:	89 10                	mov    %edx,(%eax)
  802519:	eb 0a                	jmp    802525 <alloc_block_BF+0x1af>
  80251b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251e:	8b 00                	mov    (%eax),%eax
  802520:	a3 48 41 80 00       	mov    %eax,0x804148
  802525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802528:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802531:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802538:	a1 54 41 80 00       	mov    0x804154,%eax
  80253d:	48                   	dec    %eax
  80253e:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802543:	83 ec 08             	sub    $0x8,%esp
  802546:	ff 75 ec             	pushl  -0x14(%ebp)
  802549:	68 38 41 80 00       	push   $0x804138
  80254e:	e8 71 f9 ff ff       	call   801ec4 <find_block>
  802553:	83 c4 10             	add    $0x10,%esp
  802556:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802559:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80255c:	8b 50 08             	mov    0x8(%eax),%edx
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	01 c2                	add    %eax,%edx
  802564:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802567:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80256a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80256d:	8b 40 0c             	mov    0xc(%eax),%eax
  802570:	2b 45 08             	sub    0x8(%ebp),%eax
  802573:	89 c2                	mov    %eax,%edx
  802575:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802578:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80257b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257e:	eb 05                	jmp    802585 <alloc_block_BF+0x20f>
	}
	return NULL;
  802580:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802585:	c9                   	leave  
  802586:	c3                   	ret    

00802587 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802587:	55                   	push   %ebp
  802588:	89 e5                	mov    %esp,%ebp
  80258a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80258d:	a1 28 40 80 00       	mov    0x804028,%eax
  802592:	85 c0                	test   %eax,%eax
  802594:	0f 85 de 01 00 00    	jne    802778 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80259a:	a1 38 41 80 00       	mov    0x804138,%eax
  80259f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a2:	e9 9e 01 00 00       	jmp    802745 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b0:	0f 82 87 01 00 00    	jb     80273d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025bf:	0f 85 95 00 00 00    	jne    80265a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8025c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c9:	75 17                	jne    8025e2 <alloc_block_NF+0x5b>
  8025cb:	83 ec 04             	sub    $0x4,%esp
  8025ce:	68 58 3f 80 00       	push   $0x803f58
  8025d3:	68 e0 00 00 00       	push   $0xe0
  8025d8:	68 af 3e 80 00       	push   $0x803eaf
  8025dd:	e8 a0 dc ff ff       	call   800282 <_panic>
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 00                	mov    (%eax),%eax
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	74 10                	je     8025fb <alloc_block_NF+0x74>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f3:	8b 52 04             	mov    0x4(%edx),%edx
  8025f6:	89 50 04             	mov    %edx,0x4(%eax)
  8025f9:	eb 0b                	jmp    802606 <alloc_block_NF+0x7f>
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 40 04             	mov    0x4(%eax),%eax
  802601:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 40 04             	mov    0x4(%eax),%eax
  80260c:	85 c0                	test   %eax,%eax
  80260e:	74 0f                	je     80261f <alloc_block_NF+0x98>
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 40 04             	mov    0x4(%eax),%eax
  802616:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802619:	8b 12                	mov    (%edx),%edx
  80261b:	89 10                	mov    %edx,(%eax)
  80261d:	eb 0a                	jmp    802629 <alloc_block_NF+0xa2>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	a3 38 41 80 00       	mov    %eax,0x804138
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263c:	a1 44 41 80 00       	mov    0x804144,%eax
  802641:	48                   	dec    %eax
  802642:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 40 08             	mov    0x8(%eax),%eax
  80264d:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	e9 f8 04 00 00       	jmp    802b52 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 40 0c             	mov    0xc(%eax),%eax
  802660:	3b 45 08             	cmp    0x8(%ebp),%eax
  802663:	0f 86 d4 00 00 00    	jbe    80273d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802669:	a1 48 41 80 00       	mov    0x804148,%eax
  80266e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 50 08             	mov    0x8(%eax),%edx
  802677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267a:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80267d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802680:	8b 55 08             	mov    0x8(%ebp),%edx
  802683:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802686:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80268a:	75 17                	jne    8026a3 <alloc_block_NF+0x11c>
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	68 58 3f 80 00       	push   $0x803f58
  802694:	68 e9 00 00 00       	push   $0xe9
  802699:	68 af 3e 80 00       	push   $0x803eaf
  80269e:	e8 df db ff ff       	call   800282 <_panic>
  8026a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a6:	8b 00                	mov    (%eax),%eax
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	74 10                	je     8026bc <alloc_block_NF+0x135>
  8026ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026af:	8b 00                	mov    (%eax),%eax
  8026b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026b4:	8b 52 04             	mov    0x4(%edx),%edx
  8026b7:	89 50 04             	mov    %edx,0x4(%eax)
  8026ba:	eb 0b                	jmp    8026c7 <alloc_block_NF+0x140>
  8026bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bf:	8b 40 04             	mov    0x4(%eax),%eax
  8026c2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	74 0f                	je     8026e0 <alloc_block_NF+0x159>
  8026d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d4:	8b 40 04             	mov    0x4(%eax),%eax
  8026d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026da:	8b 12                	mov    (%edx),%edx
  8026dc:	89 10                	mov    %edx,(%eax)
  8026de:	eb 0a                	jmp    8026ea <alloc_block_NF+0x163>
  8026e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e3:	8b 00                	mov    (%eax),%eax
  8026e5:	a3 48 41 80 00       	mov    %eax,0x804148
  8026ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fd:	a1 54 41 80 00       	mov    0x804154,%eax
  802702:	48                   	dec    %eax
  802703:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270b:	8b 40 08             	mov    0x8(%eax),%eax
  80270e:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 50 08             	mov    0x8(%eax),%edx
  802719:	8b 45 08             	mov    0x8(%ebp),%eax
  80271c:	01 c2                	add    %eax,%edx
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 0c             	mov    0xc(%eax),%eax
  80272a:	2b 45 08             	sub    0x8(%ebp),%eax
  80272d:	89 c2                	mov    %eax,%edx
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802738:	e9 15 04 00 00       	jmp    802b52 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80273d:	a1 40 41 80 00       	mov    0x804140,%eax
  802742:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802745:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802749:	74 07                	je     802752 <alloc_block_NF+0x1cb>
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 00                	mov    (%eax),%eax
  802750:	eb 05                	jmp    802757 <alloc_block_NF+0x1d0>
  802752:	b8 00 00 00 00       	mov    $0x0,%eax
  802757:	a3 40 41 80 00       	mov    %eax,0x804140
  80275c:	a1 40 41 80 00       	mov    0x804140,%eax
  802761:	85 c0                	test   %eax,%eax
  802763:	0f 85 3e fe ff ff    	jne    8025a7 <alloc_block_NF+0x20>
  802769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276d:	0f 85 34 fe ff ff    	jne    8025a7 <alloc_block_NF+0x20>
  802773:	e9 d5 03 00 00       	jmp    802b4d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802778:	a1 38 41 80 00       	mov    0x804138,%eax
  80277d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802780:	e9 b1 01 00 00       	jmp    802936 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	8b 50 08             	mov    0x8(%eax),%edx
  80278b:	a1 28 40 80 00       	mov    0x804028,%eax
  802790:	39 c2                	cmp    %eax,%edx
  802792:	0f 82 96 01 00 00    	jb     80292e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 40 0c             	mov    0xc(%eax),%eax
  80279e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a1:	0f 82 87 01 00 00    	jb     80292e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b0:	0f 85 95 00 00 00    	jne    80284b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ba:	75 17                	jne    8027d3 <alloc_block_NF+0x24c>
  8027bc:	83 ec 04             	sub    $0x4,%esp
  8027bf:	68 58 3f 80 00       	push   $0x803f58
  8027c4:	68 fc 00 00 00       	push   $0xfc
  8027c9:	68 af 3e 80 00       	push   $0x803eaf
  8027ce:	e8 af da ff ff       	call   800282 <_panic>
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 00                	mov    (%eax),%eax
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	74 10                	je     8027ec <alloc_block_NF+0x265>
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e4:	8b 52 04             	mov    0x4(%edx),%edx
  8027e7:	89 50 04             	mov    %edx,0x4(%eax)
  8027ea:	eb 0b                	jmp    8027f7 <alloc_block_NF+0x270>
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 40 04             	mov    0x4(%eax),%eax
  8027f2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	8b 40 04             	mov    0x4(%eax),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	74 0f                	je     802810 <alloc_block_NF+0x289>
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	8b 40 04             	mov    0x4(%eax),%eax
  802807:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280a:	8b 12                	mov    (%edx),%edx
  80280c:	89 10                	mov    %edx,(%eax)
  80280e:	eb 0a                	jmp    80281a <alloc_block_NF+0x293>
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 00                	mov    (%eax),%eax
  802815:	a3 38 41 80 00       	mov    %eax,0x804138
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282d:	a1 44 41 80 00       	mov    0x804144,%eax
  802832:	48                   	dec    %eax
  802833:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 40 08             	mov    0x8(%eax),%eax
  80283e:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	e9 07 03 00 00       	jmp    802b52 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	8b 40 0c             	mov    0xc(%eax),%eax
  802851:	3b 45 08             	cmp    0x8(%ebp),%eax
  802854:	0f 86 d4 00 00 00    	jbe    80292e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80285a:	a1 48 41 80 00       	mov    0x804148,%eax
  80285f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 50 08             	mov    0x8(%eax),%edx
  802868:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80286b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80286e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802871:	8b 55 08             	mov    0x8(%ebp),%edx
  802874:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802877:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80287b:	75 17                	jne    802894 <alloc_block_NF+0x30d>
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	68 58 3f 80 00       	push   $0x803f58
  802885:	68 04 01 00 00       	push   $0x104
  80288a:	68 af 3e 80 00       	push   $0x803eaf
  80288f:	e8 ee d9 ff ff       	call   800282 <_panic>
  802894:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802897:	8b 00                	mov    (%eax),%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	74 10                	je     8028ad <alloc_block_NF+0x326>
  80289d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028a5:	8b 52 04             	mov    0x4(%edx),%edx
  8028a8:	89 50 04             	mov    %edx,0x4(%eax)
  8028ab:	eb 0b                	jmp    8028b8 <alloc_block_NF+0x331>
  8028ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b0:	8b 40 04             	mov    0x4(%eax),%eax
  8028b3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028bb:	8b 40 04             	mov    0x4(%eax),%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	74 0f                	je     8028d1 <alloc_block_NF+0x34a>
  8028c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c5:	8b 40 04             	mov    0x4(%eax),%eax
  8028c8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028cb:	8b 12                	mov    (%edx),%edx
  8028cd:	89 10                	mov    %edx,(%eax)
  8028cf:	eb 0a                	jmp    8028db <alloc_block_NF+0x354>
  8028d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	a3 48 41 80 00       	mov    %eax,0x804148
  8028db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ee:	a1 54 41 80 00       	mov    0x804154,%eax
  8028f3:	48                   	dec    %eax
  8028f4:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8028f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fc:	8b 40 08             	mov    0x8(%eax),%eax
  8028ff:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 50 08             	mov    0x8(%eax),%edx
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	01 c2                	add    %eax,%edx
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	8b 40 0c             	mov    0xc(%eax),%eax
  80291b:	2b 45 08             	sub    0x8(%ebp),%eax
  80291e:	89 c2                	mov    %eax,%edx
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802926:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802929:	e9 24 02 00 00       	jmp    802b52 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80292e:	a1 40 41 80 00       	mov    0x804140,%eax
  802933:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802936:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293a:	74 07                	je     802943 <alloc_block_NF+0x3bc>
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 00                	mov    (%eax),%eax
  802941:	eb 05                	jmp    802948 <alloc_block_NF+0x3c1>
  802943:	b8 00 00 00 00       	mov    $0x0,%eax
  802948:	a3 40 41 80 00       	mov    %eax,0x804140
  80294d:	a1 40 41 80 00       	mov    0x804140,%eax
  802952:	85 c0                	test   %eax,%eax
  802954:	0f 85 2b fe ff ff    	jne    802785 <alloc_block_NF+0x1fe>
  80295a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295e:	0f 85 21 fe ff ff    	jne    802785 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802964:	a1 38 41 80 00       	mov    0x804138,%eax
  802969:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296c:	e9 ae 01 00 00       	jmp    802b1f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 50 08             	mov    0x8(%eax),%edx
  802977:	a1 28 40 80 00       	mov    0x804028,%eax
  80297c:	39 c2                	cmp    %eax,%edx
  80297e:	0f 83 93 01 00 00    	jae    802b17 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 40 0c             	mov    0xc(%eax),%eax
  80298a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298d:	0f 82 84 01 00 00    	jb     802b17 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 40 0c             	mov    0xc(%eax),%eax
  802999:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299c:	0f 85 95 00 00 00    	jne    802a37 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a6:	75 17                	jne    8029bf <alloc_block_NF+0x438>
  8029a8:	83 ec 04             	sub    $0x4,%esp
  8029ab:	68 58 3f 80 00       	push   $0x803f58
  8029b0:	68 14 01 00 00       	push   $0x114
  8029b5:	68 af 3e 80 00       	push   $0x803eaf
  8029ba:	e8 c3 d8 ff ff       	call   800282 <_panic>
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	8b 00                	mov    (%eax),%eax
  8029c4:	85 c0                	test   %eax,%eax
  8029c6:	74 10                	je     8029d8 <alloc_block_NF+0x451>
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 00                	mov    (%eax),%eax
  8029cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d0:	8b 52 04             	mov    0x4(%edx),%edx
  8029d3:	89 50 04             	mov    %edx,0x4(%eax)
  8029d6:	eb 0b                	jmp    8029e3 <alloc_block_NF+0x45c>
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 40 04             	mov    0x4(%eax),%eax
  8029de:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	8b 40 04             	mov    0x4(%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	74 0f                	je     8029fc <alloc_block_NF+0x475>
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 40 04             	mov    0x4(%eax),%eax
  8029f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f6:	8b 12                	mov    (%edx),%edx
  8029f8:	89 10                	mov    %edx,(%eax)
  8029fa:	eb 0a                	jmp    802a06 <alloc_block_NF+0x47f>
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	a3 38 41 80 00       	mov    %eax,0x804138
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a19:	a1 44 41 80 00       	mov    0x804144,%eax
  802a1e:	48                   	dec    %eax
  802a1f:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 40 08             	mov    0x8(%eax),%eax
  802a2a:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	e9 1b 01 00 00       	jmp    802b52 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a40:	0f 86 d1 00 00 00    	jbe    802b17 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a46:	a1 48 41 80 00       	mov    0x804148,%eax
  802a4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	8b 50 08             	mov    0x8(%eax),%edx
  802a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a57:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a60:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a67:	75 17                	jne    802a80 <alloc_block_NF+0x4f9>
  802a69:	83 ec 04             	sub    $0x4,%esp
  802a6c:	68 58 3f 80 00       	push   $0x803f58
  802a71:	68 1c 01 00 00       	push   $0x11c
  802a76:	68 af 3e 80 00       	push   $0x803eaf
  802a7b:	e8 02 d8 ff ff       	call   800282 <_panic>
  802a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	74 10                	je     802a99 <alloc_block_NF+0x512>
  802a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a91:	8b 52 04             	mov    0x4(%edx),%edx
  802a94:	89 50 04             	mov    %edx,0x4(%eax)
  802a97:	eb 0b                	jmp    802aa4 <alloc_block_NF+0x51d>
  802a99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa7:	8b 40 04             	mov    0x4(%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 0f                	je     802abd <alloc_block_NF+0x536>
  802aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab1:	8b 40 04             	mov    0x4(%eax),%eax
  802ab4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ab7:	8b 12                	mov    (%edx),%edx
  802ab9:	89 10                	mov    %edx,(%eax)
  802abb:	eb 0a                	jmp    802ac7 <alloc_block_NF+0x540>
  802abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	a3 48 41 80 00       	mov    %eax,0x804148
  802ac7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ada:	a1 54 41 80 00       	mov    0x804154,%eax
  802adf:	48                   	dec    %eax
  802ae0:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae8:	8b 40 08             	mov    0x8(%eax),%eax
  802aeb:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 50 08             	mov    0x8(%eax),%edx
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	01 c2                	add    %eax,%edx
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 40 0c             	mov    0xc(%eax),%eax
  802b07:	2b 45 08             	sub    0x8(%ebp),%eax
  802b0a:	89 c2                	mov    %eax,%edx
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b15:	eb 3b                	jmp    802b52 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b17:	a1 40 41 80 00       	mov    0x804140,%eax
  802b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b23:	74 07                	je     802b2c <alloc_block_NF+0x5a5>
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	eb 05                	jmp    802b31 <alloc_block_NF+0x5aa>
  802b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b31:	a3 40 41 80 00       	mov    %eax,0x804140
  802b36:	a1 40 41 80 00       	mov    0x804140,%eax
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	0f 85 2e fe ff ff    	jne    802971 <alloc_block_NF+0x3ea>
  802b43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b47:	0f 85 24 fe ff ff    	jne    802971 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b52:	c9                   	leave  
  802b53:	c3                   	ret    

00802b54 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b54:	55                   	push   %ebp
  802b55:	89 e5                	mov    %esp,%ebp
  802b57:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b5a:	a1 38 41 80 00       	mov    0x804138,%eax
  802b5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802b62:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b67:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802b6a:	a1 38 41 80 00       	mov    0x804138,%eax
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	74 14                	je     802b87 <insert_sorted_with_merge_freeList+0x33>
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	8b 50 08             	mov    0x8(%eax),%edx
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	8b 40 08             	mov    0x8(%eax),%eax
  802b7f:	39 c2                	cmp    %eax,%edx
  802b81:	0f 87 9b 01 00 00    	ja     802d22 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8b:	75 17                	jne    802ba4 <insert_sorted_with_merge_freeList+0x50>
  802b8d:	83 ec 04             	sub    $0x4,%esp
  802b90:	68 8c 3e 80 00       	push   $0x803e8c
  802b95:	68 38 01 00 00       	push   $0x138
  802b9a:	68 af 3e 80 00       	push   $0x803eaf
  802b9f:	e8 de d6 ff ff       	call   800282 <_panic>
  802ba4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	89 10                	mov    %edx,(%eax)
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	85 c0                	test   %eax,%eax
  802bb6:	74 0d                	je     802bc5 <insert_sorted_with_merge_freeList+0x71>
  802bb8:	a1 38 41 80 00       	mov    0x804138,%eax
  802bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc0:	89 50 04             	mov    %edx,0x4(%eax)
  802bc3:	eb 08                	jmp    802bcd <insert_sorted_with_merge_freeList+0x79>
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	a3 38 41 80 00       	mov    %eax,0x804138
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdf:	a1 44 41 80 00       	mov    0x804144,%eax
  802be4:	40                   	inc    %eax
  802be5:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802bea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bee:	0f 84 a8 06 00 00    	je     80329c <insert_sorted_with_merge_freeList+0x748>
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	8b 50 08             	mov    0x8(%eax),%edx
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802c00:	01 c2                	add    %eax,%edx
  802c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c05:	8b 40 08             	mov    0x8(%eax),%eax
  802c08:	39 c2                	cmp    %eax,%edx
  802c0a:	0f 85 8c 06 00 00    	jne    80329c <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	8b 50 0c             	mov    0xc(%eax),%edx
  802c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c19:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1c:	01 c2                	add    %eax,%edx
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c28:	75 17                	jne    802c41 <insert_sorted_with_merge_freeList+0xed>
  802c2a:	83 ec 04             	sub    $0x4,%esp
  802c2d:	68 58 3f 80 00       	push   $0x803f58
  802c32:	68 3c 01 00 00       	push   $0x13c
  802c37:	68 af 3e 80 00       	push   $0x803eaf
  802c3c:	e8 41 d6 ff ff       	call   800282 <_panic>
  802c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	85 c0                	test   %eax,%eax
  802c48:	74 10                	je     802c5a <insert_sorted_with_merge_freeList+0x106>
  802c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4d:	8b 00                	mov    (%eax),%eax
  802c4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c52:	8b 52 04             	mov    0x4(%edx),%edx
  802c55:	89 50 04             	mov    %edx,0x4(%eax)
  802c58:	eb 0b                	jmp    802c65 <insert_sorted_with_merge_freeList+0x111>
  802c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5d:	8b 40 04             	mov    0x4(%eax),%eax
  802c60:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c68:	8b 40 04             	mov    0x4(%eax),%eax
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	74 0f                	je     802c7e <insert_sorted_with_merge_freeList+0x12a>
  802c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c72:	8b 40 04             	mov    0x4(%eax),%eax
  802c75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c78:	8b 12                	mov    (%edx),%edx
  802c7a:	89 10                	mov    %edx,(%eax)
  802c7c:	eb 0a                	jmp    802c88 <insert_sorted_with_merge_freeList+0x134>
  802c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	a3 38 41 80 00       	mov    %eax,0x804138
  802c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9b:	a1 44 41 80 00       	mov    0x804144,%eax
  802ca0:	48                   	dec    %eax
  802ca1:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802cba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cbe:	75 17                	jne    802cd7 <insert_sorted_with_merge_freeList+0x183>
  802cc0:	83 ec 04             	sub    $0x4,%esp
  802cc3:	68 8c 3e 80 00       	push   $0x803e8c
  802cc8:	68 3f 01 00 00       	push   $0x13f
  802ccd:	68 af 3e 80 00       	push   $0x803eaf
  802cd2:	e8 ab d5 ff ff       	call   800282 <_panic>
  802cd7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce0:	89 10                	mov    %edx,(%eax)
  802ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce5:	8b 00                	mov    (%eax),%eax
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	74 0d                	je     802cf8 <insert_sorted_with_merge_freeList+0x1a4>
  802ceb:	a1 48 41 80 00       	mov    0x804148,%eax
  802cf0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf3:	89 50 04             	mov    %edx,0x4(%eax)
  802cf6:	eb 08                	jmp    802d00 <insert_sorted_with_merge_freeList+0x1ac>
  802cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d03:	a3 48 41 80 00       	mov    %eax,0x804148
  802d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d12:	a1 54 41 80 00       	mov    0x804154,%eax
  802d17:	40                   	inc    %eax
  802d18:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d1d:	e9 7a 05 00 00       	jmp    80329c <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	8b 50 08             	mov    0x8(%eax),%edx
  802d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2b:	8b 40 08             	mov    0x8(%eax),%eax
  802d2e:	39 c2                	cmp    %eax,%edx
  802d30:	0f 82 14 01 00 00    	jb     802e4a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d39:	8b 50 08             	mov    0x8(%eax),%edx
  802d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d42:	01 c2                	add    %eax,%edx
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	8b 40 08             	mov    0x8(%eax),%eax
  802d4a:	39 c2                	cmp    %eax,%edx
  802d4c:	0f 85 90 00 00 00    	jne    802de2 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d55:	8b 50 0c             	mov    0xc(%eax),%edx
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5e:	01 c2                	add    %eax,%edx
  802d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d63:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d7e:	75 17                	jne    802d97 <insert_sorted_with_merge_freeList+0x243>
  802d80:	83 ec 04             	sub    $0x4,%esp
  802d83:	68 8c 3e 80 00       	push   $0x803e8c
  802d88:	68 49 01 00 00       	push   $0x149
  802d8d:	68 af 3e 80 00       	push   $0x803eaf
  802d92:	e8 eb d4 ff ff       	call   800282 <_panic>
  802d97:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	89 10                	mov    %edx,(%eax)
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	74 0d                	je     802db8 <insert_sorted_with_merge_freeList+0x264>
  802dab:	a1 48 41 80 00       	mov    0x804148,%eax
  802db0:	8b 55 08             	mov    0x8(%ebp),%edx
  802db3:	89 50 04             	mov    %edx,0x4(%eax)
  802db6:	eb 08                	jmp    802dc0 <insert_sorted_with_merge_freeList+0x26c>
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	a3 48 41 80 00       	mov    %eax,0x804148
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd2:	a1 54 41 80 00       	mov    0x804154,%eax
  802dd7:	40                   	inc    %eax
  802dd8:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ddd:	e9 bb 04 00 00       	jmp    80329d <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802de2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de6:	75 17                	jne    802dff <insert_sorted_with_merge_freeList+0x2ab>
  802de8:	83 ec 04             	sub    $0x4,%esp
  802deb:	68 00 3f 80 00       	push   $0x803f00
  802df0:	68 4c 01 00 00       	push   $0x14c
  802df5:	68 af 3e 80 00       	push   $0x803eaf
  802dfa:	e8 83 d4 ff ff       	call   800282 <_panic>
  802dff:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	89 50 04             	mov    %edx,0x4(%eax)
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	8b 40 04             	mov    0x4(%eax),%eax
  802e11:	85 c0                	test   %eax,%eax
  802e13:	74 0c                	je     802e21 <insert_sorted_with_merge_freeList+0x2cd>
  802e15:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1d:	89 10                	mov    %edx,(%eax)
  802e1f:	eb 08                	jmp    802e29 <insert_sorted_with_merge_freeList+0x2d5>
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	a3 38 41 80 00       	mov    %eax,0x804138
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3a:	a1 44 41 80 00       	mov    0x804144,%eax
  802e3f:	40                   	inc    %eax
  802e40:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e45:	e9 53 04 00 00       	jmp    80329d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e4a:	a1 38 41 80 00       	mov    0x804138,%eax
  802e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e52:	e9 15 04 00 00       	jmp    80326c <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 00                	mov    (%eax),%eax
  802e5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	8b 50 08             	mov    0x8(%eax),%edx
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	8b 40 08             	mov    0x8(%eax),%eax
  802e6b:	39 c2                	cmp    %eax,%edx
  802e6d:	0f 86 f1 03 00 00    	jbe    803264 <insert_sorted_with_merge_freeList+0x710>
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	8b 50 08             	mov    0x8(%eax),%edx
  802e79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7c:	8b 40 08             	mov    0x8(%eax),%eax
  802e7f:	39 c2                	cmp    %eax,%edx
  802e81:	0f 83 dd 03 00 00    	jae    803264 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 50 08             	mov    0x8(%eax),%edx
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 40 0c             	mov    0xc(%eax),%eax
  802e93:	01 c2                	add    %eax,%edx
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	8b 40 08             	mov    0x8(%eax),%eax
  802e9b:	39 c2                	cmp    %eax,%edx
  802e9d:	0f 85 b9 01 00 00    	jne    80305c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 50 08             	mov    0x8(%eax),%edx
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	8b 40 0c             	mov    0xc(%eax),%eax
  802eaf:	01 c2                	add    %eax,%edx
  802eb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb4:	8b 40 08             	mov    0x8(%eax),%eax
  802eb7:	39 c2                	cmp    %eax,%edx
  802eb9:	0f 85 0d 01 00 00    	jne    802fcc <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecb:	01 c2                	add    %eax,%edx
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802ed3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ed7:	75 17                	jne    802ef0 <insert_sorted_with_merge_freeList+0x39c>
  802ed9:	83 ec 04             	sub    $0x4,%esp
  802edc:	68 58 3f 80 00       	push   $0x803f58
  802ee1:	68 5c 01 00 00       	push   $0x15c
  802ee6:	68 af 3e 80 00       	push   $0x803eaf
  802eeb:	e8 92 d3 ff ff       	call   800282 <_panic>
  802ef0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef3:	8b 00                	mov    (%eax),%eax
  802ef5:	85 c0                	test   %eax,%eax
  802ef7:	74 10                	je     802f09 <insert_sorted_with_merge_freeList+0x3b5>
  802ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f01:	8b 52 04             	mov    0x4(%edx),%edx
  802f04:	89 50 04             	mov    %edx,0x4(%eax)
  802f07:	eb 0b                	jmp    802f14 <insert_sorted_with_merge_freeList+0x3c0>
  802f09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0c:	8b 40 04             	mov    0x4(%eax),%eax
  802f0f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f17:	8b 40 04             	mov    0x4(%eax),%eax
  802f1a:	85 c0                	test   %eax,%eax
  802f1c:	74 0f                	je     802f2d <insert_sorted_with_merge_freeList+0x3d9>
  802f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f21:	8b 40 04             	mov    0x4(%eax),%eax
  802f24:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f27:	8b 12                	mov    (%edx),%edx
  802f29:	89 10                	mov    %edx,(%eax)
  802f2b:	eb 0a                	jmp    802f37 <insert_sorted_with_merge_freeList+0x3e3>
  802f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f30:	8b 00                	mov    (%eax),%eax
  802f32:	a3 38 41 80 00       	mov    %eax,0x804138
  802f37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4a:	a1 44 41 80 00       	mov    0x804144,%eax
  802f4f:	48                   	dec    %eax
  802f50:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f58:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802f5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f62:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802f69:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f6d:	75 17                	jne    802f86 <insert_sorted_with_merge_freeList+0x432>
  802f6f:	83 ec 04             	sub    $0x4,%esp
  802f72:	68 8c 3e 80 00       	push   $0x803e8c
  802f77:	68 5f 01 00 00       	push   $0x15f
  802f7c:	68 af 3e 80 00       	push   $0x803eaf
  802f81:	e8 fc d2 ff ff       	call   800282 <_panic>
  802f86:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8f:	89 10                	mov    %edx,(%eax)
  802f91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f94:	8b 00                	mov    (%eax),%eax
  802f96:	85 c0                	test   %eax,%eax
  802f98:	74 0d                	je     802fa7 <insert_sorted_with_merge_freeList+0x453>
  802f9a:	a1 48 41 80 00       	mov    0x804148,%eax
  802f9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa2:	89 50 04             	mov    %edx,0x4(%eax)
  802fa5:	eb 08                	jmp    802faf <insert_sorted_with_merge_freeList+0x45b>
  802fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802faf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb2:	a3 48 41 80 00       	mov    %eax,0x804148
  802fb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc1:	a1 54 41 80 00       	mov    0x804154,%eax
  802fc6:	40                   	inc    %eax
  802fc7:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	8b 50 0c             	mov    0xc(%eax),%edx
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd8:	01 c2                	add    %eax,%edx
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ff4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff8:	75 17                	jne    803011 <insert_sorted_with_merge_freeList+0x4bd>
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	68 8c 3e 80 00       	push   $0x803e8c
  803002:	68 64 01 00 00       	push   $0x164
  803007:	68 af 3e 80 00       	push   $0x803eaf
  80300c:	e8 71 d2 ff ff       	call   800282 <_panic>
  803011:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803017:	8b 45 08             	mov    0x8(%ebp),%eax
  80301a:	89 10                	mov    %edx,(%eax)
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	85 c0                	test   %eax,%eax
  803023:	74 0d                	je     803032 <insert_sorted_with_merge_freeList+0x4de>
  803025:	a1 48 41 80 00       	mov    0x804148,%eax
  80302a:	8b 55 08             	mov    0x8(%ebp),%edx
  80302d:	89 50 04             	mov    %edx,0x4(%eax)
  803030:	eb 08                	jmp    80303a <insert_sorted_with_merge_freeList+0x4e6>
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	a3 48 41 80 00       	mov    %eax,0x804148
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304c:	a1 54 41 80 00       	mov    0x804154,%eax
  803051:	40                   	inc    %eax
  803052:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803057:	e9 41 02 00 00       	jmp    80329d <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	8b 50 08             	mov    0x8(%eax),%edx
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	8b 40 0c             	mov    0xc(%eax),%eax
  803068:	01 c2                	add    %eax,%edx
  80306a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306d:	8b 40 08             	mov    0x8(%eax),%eax
  803070:	39 c2                	cmp    %eax,%edx
  803072:	0f 85 7c 01 00 00    	jne    8031f4 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803078:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80307c:	74 06                	je     803084 <insert_sorted_with_merge_freeList+0x530>
  80307e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803082:	75 17                	jne    80309b <insert_sorted_with_merge_freeList+0x547>
  803084:	83 ec 04             	sub    $0x4,%esp
  803087:	68 c8 3e 80 00       	push   $0x803ec8
  80308c:	68 69 01 00 00       	push   $0x169
  803091:	68 af 3e 80 00       	push   $0x803eaf
  803096:	e8 e7 d1 ff ff       	call   800282 <_panic>
  80309b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309e:	8b 50 04             	mov    0x4(%eax),%edx
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	89 50 04             	mov    %edx,0x4(%eax)
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ad:	89 10                	mov    %edx,(%eax)
  8030af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b2:	8b 40 04             	mov    0x4(%eax),%eax
  8030b5:	85 c0                	test   %eax,%eax
  8030b7:	74 0d                	je     8030c6 <insert_sorted_with_merge_freeList+0x572>
  8030b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bc:	8b 40 04             	mov    0x4(%eax),%eax
  8030bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c2:	89 10                	mov    %edx,(%eax)
  8030c4:	eb 08                	jmp    8030ce <insert_sorted_with_merge_freeList+0x57a>
  8030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c9:	a3 38 41 80 00       	mov    %eax,0x804138
  8030ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d4:	89 50 04             	mov    %edx,0x4(%eax)
  8030d7:	a1 44 41 80 00       	mov    0x804144,%eax
  8030dc:	40                   	inc    %eax
  8030dd:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	8b 50 0c             	mov    0xc(%eax),%edx
  8030e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ee:	01 c2                	add    %eax,%edx
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030fa:	75 17                	jne    803113 <insert_sorted_with_merge_freeList+0x5bf>
  8030fc:	83 ec 04             	sub    $0x4,%esp
  8030ff:	68 58 3f 80 00       	push   $0x803f58
  803104:	68 6b 01 00 00       	push   $0x16b
  803109:	68 af 3e 80 00       	push   $0x803eaf
  80310e:	e8 6f d1 ff ff       	call   800282 <_panic>
  803113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	85 c0                	test   %eax,%eax
  80311a:	74 10                	je     80312c <insert_sorted_with_merge_freeList+0x5d8>
  80311c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311f:	8b 00                	mov    (%eax),%eax
  803121:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803124:	8b 52 04             	mov    0x4(%edx),%edx
  803127:	89 50 04             	mov    %edx,0x4(%eax)
  80312a:	eb 0b                	jmp    803137 <insert_sorted_with_merge_freeList+0x5e3>
  80312c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312f:	8b 40 04             	mov    0x4(%eax),%eax
  803132:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313a:	8b 40 04             	mov    0x4(%eax),%eax
  80313d:	85 c0                	test   %eax,%eax
  80313f:	74 0f                	je     803150 <insert_sorted_with_merge_freeList+0x5fc>
  803141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803144:	8b 40 04             	mov    0x4(%eax),%eax
  803147:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80314a:	8b 12                	mov    (%edx),%edx
  80314c:	89 10                	mov    %edx,(%eax)
  80314e:	eb 0a                	jmp    80315a <insert_sorted_with_merge_freeList+0x606>
  803150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803153:	8b 00                	mov    (%eax),%eax
  803155:	a3 38 41 80 00       	mov    %eax,0x804138
  80315a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803166:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316d:	a1 44 41 80 00       	mov    0x804144,%eax
  803172:	48                   	dec    %eax
  803173:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80318c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803190:	75 17                	jne    8031a9 <insert_sorted_with_merge_freeList+0x655>
  803192:	83 ec 04             	sub    $0x4,%esp
  803195:	68 8c 3e 80 00       	push   $0x803e8c
  80319a:	68 6e 01 00 00       	push   $0x16e
  80319f:	68 af 3e 80 00       	push   $0x803eaf
  8031a4:	e8 d9 d0 ff ff       	call   800282 <_panic>
  8031a9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b2:	89 10                	mov    %edx,(%eax)
  8031b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b7:	8b 00                	mov    (%eax),%eax
  8031b9:	85 c0                	test   %eax,%eax
  8031bb:	74 0d                	je     8031ca <insert_sorted_with_merge_freeList+0x676>
  8031bd:	a1 48 41 80 00       	mov    0x804148,%eax
  8031c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c5:	89 50 04             	mov    %edx,0x4(%eax)
  8031c8:	eb 08                	jmp    8031d2 <insert_sorted_with_merge_freeList+0x67e>
  8031ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d5:	a3 48 41 80 00       	mov    %eax,0x804148
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e4:	a1 54 41 80 00       	mov    0x804154,%eax
  8031e9:	40                   	inc    %eax
  8031ea:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8031ef:	e9 a9 00 00 00       	jmp    80329d <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8031f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f8:	74 06                	je     803200 <insert_sorted_with_merge_freeList+0x6ac>
  8031fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031fe:	75 17                	jne    803217 <insert_sorted_with_merge_freeList+0x6c3>
  803200:	83 ec 04             	sub    $0x4,%esp
  803203:	68 24 3f 80 00       	push   $0x803f24
  803208:	68 73 01 00 00       	push   $0x173
  80320d:	68 af 3e 80 00       	push   $0x803eaf
  803212:	e8 6b d0 ff ff       	call   800282 <_panic>
  803217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321a:	8b 10                	mov    (%eax),%edx
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	89 10                	mov    %edx,(%eax)
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	85 c0                	test   %eax,%eax
  803228:	74 0b                	je     803235 <insert_sorted_with_merge_freeList+0x6e1>
  80322a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322d:	8b 00                	mov    (%eax),%eax
  80322f:	8b 55 08             	mov    0x8(%ebp),%edx
  803232:	89 50 04             	mov    %edx,0x4(%eax)
  803235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803238:	8b 55 08             	mov    0x8(%ebp),%edx
  80323b:	89 10                	mov    %edx,(%eax)
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803243:	89 50 04             	mov    %edx,0x4(%eax)
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	8b 00                	mov    (%eax),%eax
  80324b:	85 c0                	test   %eax,%eax
  80324d:	75 08                	jne    803257 <insert_sorted_with_merge_freeList+0x703>
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803257:	a1 44 41 80 00       	mov    0x804144,%eax
  80325c:	40                   	inc    %eax
  80325d:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803262:	eb 39                	jmp    80329d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803264:	a1 40 41 80 00       	mov    0x804140,%eax
  803269:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80326c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803270:	74 07                	je     803279 <insert_sorted_with_merge_freeList+0x725>
  803272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803275:	8b 00                	mov    (%eax),%eax
  803277:	eb 05                	jmp    80327e <insert_sorted_with_merge_freeList+0x72a>
  803279:	b8 00 00 00 00       	mov    $0x0,%eax
  80327e:	a3 40 41 80 00       	mov    %eax,0x804140
  803283:	a1 40 41 80 00       	mov    0x804140,%eax
  803288:	85 c0                	test   %eax,%eax
  80328a:	0f 85 c7 fb ff ff    	jne    802e57 <insert_sorted_with_merge_freeList+0x303>
  803290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803294:	0f 85 bd fb ff ff    	jne    802e57 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80329a:	eb 01                	jmp    80329d <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80329c:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80329d:	90                   	nop
  80329e:	c9                   	leave  
  80329f:	c3                   	ret    

008032a0 <__udivdi3>:
  8032a0:	55                   	push   %ebp
  8032a1:	57                   	push   %edi
  8032a2:	56                   	push   %esi
  8032a3:	53                   	push   %ebx
  8032a4:	83 ec 1c             	sub    $0x1c,%esp
  8032a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032b7:	89 ca                	mov    %ecx,%edx
  8032b9:	89 f8                	mov    %edi,%eax
  8032bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032bf:	85 f6                	test   %esi,%esi
  8032c1:	75 2d                	jne    8032f0 <__udivdi3+0x50>
  8032c3:	39 cf                	cmp    %ecx,%edi
  8032c5:	77 65                	ja     80332c <__udivdi3+0x8c>
  8032c7:	89 fd                	mov    %edi,%ebp
  8032c9:	85 ff                	test   %edi,%edi
  8032cb:	75 0b                	jne    8032d8 <__udivdi3+0x38>
  8032cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8032d2:	31 d2                	xor    %edx,%edx
  8032d4:	f7 f7                	div    %edi
  8032d6:	89 c5                	mov    %eax,%ebp
  8032d8:	31 d2                	xor    %edx,%edx
  8032da:	89 c8                	mov    %ecx,%eax
  8032dc:	f7 f5                	div    %ebp
  8032de:	89 c1                	mov    %eax,%ecx
  8032e0:	89 d8                	mov    %ebx,%eax
  8032e2:	f7 f5                	div    %ebp
  8032e4:	89 cf                	mov    %ecx,%edi
  8032e6:	89 fa                	mov    %edi,%edx
  8032e8:	83 c4 1c             	add    $0x1c,%esp
  8032eb:	5b                   	pop    %ebx
  8032ec:	5e                   	pop    %esi
  8032ed:	5f                   	pop    %edi
  8032ee:	5d                   	pop    %ebp
  8032ef:	c3                   	ret    
  8032f0:	39 ce                	cmp    %ecx,%esi
  8032f2:	77 28                	ja     80331c <__udivdi3+0x7c>
  8032f4:	0f bd fe             	bsr    %esi,%edi
  8032f7:	83 f7 1f             	xor    $0x1f,%edi
  8032fa:	75 40                	jne    80333c <__udivdi3+0x9c>
  8032fc:	39 ce                	cmp    %ecx,%esi
  8032fe:	72 0a                	jb     80330a <__udivdi3+0x6a>
  803300:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803304:	0f 87 9e 00 00 00    	ja     8033a8 <__udivdi3+0x108>
  80330a:	b8 01 00 00 00       	mov    $0x1,%eax
  80330f:	89 fa                	mov    %edi,%edx
  803311:	83 c4 1c             	add    $0x1c,%esp
  803314:	5b                   	pop    %ebx
  803315:	5e                   	pop    %esi
  803316:	5f                   	pop    %edi
  803317:	5d                   	pop    %ebp
  803318:	c3                   	ret    
  803319:	8d 76 00             	lea    0x0(%esi),%esi
  80331c:	31 ff                	xor    %edi,%edi
  80331e:	31 c0                	xor    %eax,%eax
  803320:	89 fa                	mov    %edi,%edx
  803322:	83 c4 1c             	add    $0x1c,%esp
  803325:	5b                   	pop    %ebx
  803326:	5e                   	pop    %esi
  803327:	5f                   	pop    %edi
  803328:	5d                   	pop    %ebp
  803329:	c3                   	ret    
  80332a:	66 90                	xchg   %ax,%ax
  80332c:	89 d8                	mov    %ebx,%eax
  80332e:	f7 f7                	div    %edi
  803330:	31 ff                	xor    %edi,%edi
  803332:	89 fa                	mov    %edi,%edx
  803334:	83 c4 1c             	add    $0x1c,%esp
  803337:	5b                   	pop    %ebx
  803338:	5e                   	pop    %esi
  803339:	5f                   	pop    %edi
  80333a:	5d                   	pop    %ebp
  80333b:	c3                   	ret    
  80333c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803341:	89 eb                	mov    %ebp,%ebx
  803343:	29 fb                	sub    %edi,%ebx
  803345:	89 f9                	mov    %edi,%ecx
  803347:	d3 e6                	shl    %cl,%esi
  803349:	89 c5                	mov    %eax,%ebp
  80334b:	88 d9                	mov    %bl,%cl
  80334d:	d3 ed                	shr    %cl,%ebp
  80334f:	89 e9                	mov    %ebp,%ecx
  803351:	09 f1                	or     %esi,%ecx
  803353:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803357:	89 f9                	mov    %edi,%ecx
  803359:	d3 e0                	shl    %cl,%eax
  80335b:	89 c5                	mov    %eax,%ebp
  80335d:	89 d6                	mov    %edx,%esi
  80335f:	88 d9                	mov    %bl,%cl
  803361:	d3 ee                	shr    %cl,%esi
  803363:	89 f9                	mov    %edi,%ecx
  803365:	d3 e2                	shl    %cl,%edx
  803367:	8b 44 24 08          	mov    0x8(%esp),%eax
  80336b:	88 d9                	mov    %bl,%cl
  80336d:	d3 e8                	shr    %cl,%eax
  80336f:	09 c2                	or     %eax,%edx
  803371:	89 d0                	mov    %edx,%eax
  803373:	89 f2                	mov    %esi,%edx
  803375:	f7 74 24 0c          	divl   0xc(%esp)
  803379:	89 d6                	mov    %edx,%esi
  80337b:	89 c3                	mov    %eax,%ebx
  80337d:	f7 e5                	mul    %ebp
  80337f:	39 d6                	cmp    %edx,%esi
  803381:	72 19                	jb     80339c <__udivdi3+0xfc>
  803383:	74 0b                	je     803390 <__udivdi3+0xf0>
  803385:	89 d8                	mov    %ebx,%eax
  803387:	31 ff                	xor    %edi,%edi
  803389:	e9 58 ff ff ff       	jmp    8032e6 <__udivdi3+0x46>
  80338e:	66 90                	xchg   %ax,%ax
  803390:	8b 54 24 08          	mov    0x8(%esp),%edx
  803394:	89 f9                	mov    %edi,%ecx
  803396:	d3 e2                	shl    %cl,%edx
  803398:	39 c2                	cmp    %eax,%edx
  80339a:	73 e9                	jae    803385 <__udivdi3+0xe5>
  80339c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80339f:	31 ff                	xor    %edi,%edi
  8033a1:	e9 40 ff ff ff       	jmp    8032e6 <__udivdi3+0x46>
  8033a6:	66 90                	xchg   %ax,%ax
  8033a8:	31 c0                	xor    %eax,%eax
  8033aa:	e9 37 ff ff ff       	jmp    8032e6 <__udivdi3+0x46>
  8033af:	90                   	nop

008033b0 <__umoddi3>:
  8033b0:	55                   	push   %ebp
  8033b1:	57                   	push   %edi
  8033b2:	56                   	push   %esi
  8033b3:	53                   	push   %ebx
  8033b4:	83 ec 1c             	sub    $0x1c,%esp
  8033b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033cf:	89 f3                	mov    %esi,%ebx
  8033d1:	89 fa                	mov    %edi,%edx
  8033d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033d7:	89 34 24             	mov    %esi,(%esp)
  8033da:	85 c0                	test   %eax,%eax
  8033dc:	75 1a                	jne    8033f8 <__umoddi3+0x48>
  8033de:	39 f7                	cmp    %esi,%edi
  8033e0:	0f 86 a2 00 00 00    	jbe    803488 <__umoddi3+0xd8>
  8033e6:	89 c8                	mov    %ecx,%eax
  8033e8:	89 f2                	mov    %esi,%edx
  8033ea:	f7 f7                	div    %edi
  8033ec:	89 d0                	mov    %edx,%eax
  8033ee:	31 d2                	xor    %edx,%edx
  8033f0:	83 c4 1c             	add    $0x1c,%esp
  8033f3:	5b                   	pop    %ebx
  8033f4:	5e                   	pop    %esi
  8033f5:	5f                   	pop    %edi
  8033f6:	5d                   	pop    %ebp
  8033f7:	c3                   	ret    
  8033f8:	39 f0                	cmp    %esi,%eax
  8033fa:	0f 87 ac 00 00 00    	ja     8034ac <__umoddi3+0xfc>
  803400:	0f bd e8             	bsr    %eax,%ebp
  803403:	83 f5 1f             	xor    $0x1f,%ebp
  803406:	0f 84 ac 00 00 00    	je     8034b8 <__umoddi3+0x108>
  80340c:	bf 20 00 00 00       	mov    $0x20,%edi
  803411:	29 ef                	sub    %ebp,%edi
  803413:	89 fe                	mov    %edi,%esi
  803415:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803419:	89 e9                	mov    %ebp,%ecx
  80341b:	d3 e0                	shl    %cl,%eax
  80341d:	89 d7                	mov    %edx,%edi
  80341f:	89 f1                	mov    %esi,%ecx
  803421:	d3 ef                	shr    %cl,%edi
  803423:	09 c7                	or     %eax,%edi
  803425:	89 e9                	mov    %ebp,%ecx
  803427:	d3 e2                	shl    %cl,%edx
  803429:	89 14 24             	mov    %edx,(%esp)
  80342c:	89 d8                	mov    %ebx,%eax
  80342e:	d3 e0                	shl    %cl,%eax
  803430:	89 c2                	mov    %eax,%edx
  803432:	8b 44 24 08          	mov    0x8(%esp),%eax
  803436:	d3 e0                	shl    %cl,%eax
  803438:	89 44 24 04          	mov    %eax,0x4(%esp)
  80343c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803440:	89 f1                	mov    %esi,%ecx
  803442:	d3 e8                	shr    %cl,%eax
  803444:	09 d0                	or     %edx,%eax
  803446:	d3 eb                	shr    %cl,%ebx
  803448:	89 da                	mov    %ebx,%edx
  80344a:	f7 f7                	div    %edi
  80344c:	89 d3                	mov    %edx,%ebx
  80344e:	f7 24 24             	mull   (%esp)
  803451:	89 c6                	mov    %eax,%esi
  803453:	89 d1                	mov    %edx,%ecx
  803455:	39 d3                	cmp    %edx,%ebx
  803457:	0f 82 87 00 00 00    	jb     8034e4 <__umoddi3+0x134>
  80345d:	0f 84 91 00 00 00    	je     8034f4 <__umoddi3+0x144>
  803463:	8b 54 24 04          	mov    0x4(%esp),%edx
  803467:	29 f2                	sub    %esi,%edx
  803469:	19 cb                	sbb    %ecx,%ebx
  80346b:	89 d8                	mov    %ebx,%eax
  80346d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803471:	d3 e0                	shl    %cl,%eax
  803473:	89 e9                	mov    %ebp,%ecx
  803475:	d3 ea                	shr    %cl,%edx
  803477:	09 d0                	or     %edx,%eax
  803479:	89 e9                	mov    %ebp,%ecx
  80347b:	d3 eb                	shr    %cl,%ebx
  80347d:	89 da                	mov    %ebx,%edx
  80347f:	83 c4 1c             	add    $0x1c,%esp
  803482:	5b                   	pop    %ebx
  803483:	5e                   	pop    %esi
  803484:	5f                   	pop    %edi
  803485:	5d                   	pop    %ebp
  803486:	c3                   	ret    
  803487:	90                   	nop
  803488:	89 fd                	mov    %edi,%ebp
  80348a:	85 ff                	test   %edi,%edi
  80348c:	75 0b                	jne    803499 <__umoddi3+0xe9>
  80348e:	b8 01 00 00 00       	mov    $0x1,%eax
  803493:	31 d2                	xor    %edx,%edx
  803495:	f7 f7                	div    %edi
  803497:	89 c5                	mov    %eax,%ebp
  803499:	89 f0                	mov    %esi,%eax
  80349b:	31 d2                	xor    %edx,%edx
  80349d:	f7 f5                	div    %ebp
  80349f:	89 c8                	mov    %ecx,%eax
  8034a1:	f7 f5                	div    %ebp
  8034a3:	89 d0                	mov    %edx,%eax
  8034a5:	e9 44 ff ff ff       	jmp    8033ee <__umoddi3+0x3e>
  8034aa:	66 90                	xchg   %ax,%ax
  8034ac:	89 c8                	mov    %ecx,%eax
  8034ae:	89 f2                	mov    %esi,%edx
  8034b0:	83 c4 1c             	add    $0x1c,%esp
  8034b3:	5b                   	pop    %ebx
  8034b4:	5e                   	pop    %esi
  8034b5:	5f                   	pop    %edi
  8034b6:	5d                   	pop    %ebp
  8034b7:	c3                   	ret    
  8034b8:	3b 04 24             	cmp    (%esp),%eax
  8034bb:	72 06                	jb     8034c3 <__umoddi3+0x113>
  8034bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034c1:	77 0f                	ja     8034d2 <__umoddi3+0x122>
  8034c3:	89 f2                	mov    %esi,%edx
  8034c5:	29 f9                	sub    %edi,%ecx
  8034c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034cb:	89 14 24             	mov    %edx,(%esp)
  8034ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034d6:	8b 14 24             	mov    (%esp),%edx
  8034d9:	83 c4 1c             	add    $0x1c,%esp
  8034dc:	5b                   	pop    %ebx
  8034dd:	5e                   	pop    %esi
  8034de:	5f                   	pop    %edi
  8034df:	5d                   	pop    %ebp
  8034e0:	c3                   	ret    
  8034e1:	8d 76 00             	lea    0x0(%esi),%esi
  8034e4:	2b 04 24             	sub    (%esp),%eax
  8034e7:	19 fa                	sbb    %edi,%edx
  8034e9:	89 d1                	mov    %edx,%ecx
  8034eb:	89 c6                	mov    %eax,%esi
  8034ed:	e9 71 ff ff ff       	jmp    803463 <__umoddi3+0xb3>
  8034f2:	66 90                	xchg   %ax,%ax
  8034f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034f8:	72 ea                	jb     8034e4 <__umoddi3+0x134>
  8034fa:	89 d9                	mov    %ebx,%ecx
  8034fc:	e9 62 ff ff ff       	jmp    803463 <__umoddi3+0xb3>
