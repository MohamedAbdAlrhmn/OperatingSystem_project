
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
  800045:	68 a0 35 80 00       	push   $0x8035a0
  80004a:	e8 b7 14 00 00       	call   801506 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 08 17 00 00       	call   80176b <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 a0 17 00 00       	call   80180b <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 b0 35 80 00       	push   $0x8035b0
  800079:	e8 b8 04 00 00       	call   800536 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 e3 35 80 00       	push   $0x8035e3
  800099:	e8 3f 19 00 00       	call   8019dd <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 4c 19 00 00       	call   8019fb <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 a9 16 00 00       	call   80176b <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 ec 35 80 00       	push   $0x8035ec
  8000cb:	e8 66 04 00 00       	call   800536 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 39 19 00 00       	call   801a17 <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 85 16 00 00       	call   80176b <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 1d 17 00 00       	call   80180b <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 20 36 80 00       	push   $0x803620
  800104:	e8 2d 04 00 00       	call   800536 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 70 36 80 00       	push   $0x803670
  800114:	6a 1e                	push   $0x1e
  800116:	68 a6 36 80 00       	push   $0x8036a6
  80011b:	e8 62 01 00 00       	call   800282 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 bc 36 80 00       	push   $0x8036bc
  80012b:	e8 06 04 00 00       	call   800536 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 1c 37 80 00       	push   $0x80371c
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
  80014c:	e8 fa 18 00 00       	call   801a4b <sys_getenvindex>
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
  8001b7:	e8 9c 16 00 00       	call   801858 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 80 37 80 00       	push   $0x803780
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
  8001e7:	68 a8 37 80 00       	push   $0x8037a8
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
  800218:	68 d0 37 80 00       	push   $0x8037d0
  80021d:	e8 14 03 00 00       	call   800536 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 28 38 80 00       	push   $0x803828
  800239:	e8 f8 02 00 00       	call   800536 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 80 37 80 00       	push   $0x803780
  800249:	e8 e8 02 00 00       	call   800536 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800251:	e8 1c 16 00 00       	call   801872 <sys_enable_interrupt>

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
  800269:	e8 a9 17 00 00       	call   801a17 <sys_destroy_env>
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
  80027a:	e8 fe 17 00 00       	call   801a7d <sys_exit_env>
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
  8002a3:	68 3c 38 80 00       	push   $0x80383c
  8002a8:	e8 89 02 00 00       	call   800536 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 41 38 80 00       	push   $0x803841
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
  8002e0:	68 5d 38 80 00       	push   $0x80385d
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
  80030c:	68 60 38 80 00       	push   $0x803860
  800311:	6a 26                	push   $0x26
  800313:	68 ac 38 80 00       	push   $0x8038ac
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
  8003de:	68 b8 38 80 00       	push   $0x8038b8
  8003e3:	6a 3a                	push   $0x3a
  8003e5:	68 ac 38 80 00       	push   $0x8038ac
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
  80044e:	68 0c 39 80 00       	push   $0x80390c
  800453:	6a 44                	push   $0x44
  800455:	68 ac 38 80 00       	push   $0x8038ac
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
  8004a8:	e8 fd 11 00 00       	call   8016aa <sys_cputs>
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
  80051f:	e8 86 11 00 00       	call   8016aa <sys_cputs>
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
  800569:	e8 ea 12 00 00       	call   801858 <sys_disable_interrupt>
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
  800589:	e8 e4 12 00 00       	call   801872 <sys_enable_interrupt>
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
  8005d3:	e8 58 2d 00 00       	call   803330 <__udivdi3>
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
  800623:	e8 18 2e 00 00       	call   803440 <__umoddi3>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	05 74 3b 80 00       	add    $0x803b74,%eax
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
  80077e:	8b 04 85 98 3b 80 00 	mov    0x803b98(,%eax,4),%eax
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
  80085f:	8b 34 9d e0 39 80 00 	mov    0x8039e0(,%ebx,4),%esi
  800866:	85 f6                	test   %esi,%esi
  800868:	75 19                	jne    800883 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086a:	53                   	push   %ebx
  80086b:	68 85 3b 80 00       	push   $0x803b85
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
  800884:	68 8e 3b 80 00       	push   $0x803b8e
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
  8008b1:	be 91 3b 80 00       	mov    $0x803b91,%esi
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
  8012d7:	68 f0 3c 80 00       	push   $0x803cf0
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  80138a:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801391:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801394:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801399:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139e:	83 ec 04             	sub    $0x4,%esp
  8013a1:	6a 06                	push   $0x6
  8013a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a6:	50                   	push   %eax
  8013a7:	e8 42 04 00 00       	call   8017ee <sys_allocate_chunk>
  8013ac:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013af:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b4:	83 ec 0c             	sub    $0xc,%esp
  8013b7:	50                   	push   %eax
  8013b8:	e8 b7 0a 00 00       	call   801e74 <initialize_MemBlocksList>
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
  8013e5:	68 15 3d 80 00       	push   $0x803d15
  8013ea:	6a 33                	push   $0x33
  8013ec:	68 33 3d 80 00       	push   $0x803d33
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
  801464:	68 40 3d 80 00       	push   $0x803d40
  801469:	6a 34                	push   $0x34
  80146b:	68 33 3d 80 00       	push   $0x803d33
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
  8014d9:	68 64 3d 80 00       	push   $0x803d64
  8014de:	6a 46                	push   $0x46
  8014e0:	68 33 3d 80 00       	push   $0x803d33
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
  8014f5:	68 8c 3d 80 00       	push   $0x803d8c
  8014fa:	6a 61                	push   $0x61
  8014fc:	68 33 3d 80 00       	push   $0x803d33
  801501:	e8 7c ed ff ff       	call   800282 <_panic>

00801506 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	83 ec 38             	sub    $0x38,%esp
  80150c:	8b 45 10             	mov    0x10(%ebp),%eax
  80150f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801512:	e8 a9 fd ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801517:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151b:	75 0a                	jne    801527 <smalloc+0x21>
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
  801522:	e9 9e 00 00 00       	jmp    8015c5 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801527:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80152e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801534:	01 d0                	add    %edx,%eax
  801536:	48                   	dec    %eax
  801537:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80153a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153d:	ba 00 00 00 00       	mov    $0x0,%edx
  801542:	f7 75 f0             	divl   -0x10(%ebp)
  801545:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801548:	29 d0                	sub    %edx,%eax
  80154a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80154d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801554:	e8 63 06 00 00       	call   801bbc <sys_isUHeapPlacementStrategyFIRSTFIT>
  801559:	85 c0                	test   %eax,%eax
  80155b:	74 11                	je     80156e <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80155d:	83 ec 0c             	sub    $0xc,%esp
  801560:	ff 75 e8             	pushl  -0x18(%ebp)
  801563:	e8 ce 0c 00 00       	call   802236 <alloc_block_FF>
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80156e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801572:	74 4c                	je     8015c0 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801577:	8b 40 08             	mov    0x8(%eax),%eax
  80157a:	89 c2                	mov    %eax,%edx
  80157c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801580:	52                   	push   %edx
  801581:	50                   	push   %eax
  801582:	ff 75 0c             	pushl  0xc(%ebp)
  801585:	ff 75 08             	pushl  0x8(%ebp)
  801588:	e8 b4 03 00 00       	call   801941 <sys_createSharedObject>
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801593:	83 ec 08             	sub    $0x8,%esp
  801596:	ff 75 e0             	pushl  -0x20(%ebp)
  801599:	68 af 3d 80 00       	push   $0x803daf
  80159e:	e8 93 ef ff ff       	call   800536 <cprintf>
  8015a3:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015a6:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015aa:	74 14                	je     8015c0 <smalloc+0xba>
  8015ac:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015b0:	74 0e                	je     8015c0 <smalloc+0xba>
  8015b2:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015b6:	74 08                	je     8015c0 <smalloc+0xba>
			return (void*) mem_block->sva;
  8015b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bb:	8b 40 08             	mov    0x8(%eax),%eax
  8015be:	eb 05                	jmp    8015c5 <smalloc+0xbf>
	}
	return NULL;
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015cd:	e8 ee fc ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	68 c4 3d 80 00       	push   $0x803dc4
  8015da:	68 ab 00 00 00       	push   $0xab
  8015df:	68 33 3d 80 00       	push   $0x803d33
  8015e4:	e8 99 ec ff ff       	call   800282 <_panic>

008015e9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ef:	e8 cc fc ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015f4:	83 ec 04             	sub    $0x4,%esp
  8015f7:	68 e8 3d 80 00       	push   $0x803de8
  8015fc:	68 ef 00 00 00       	push   $0xef
  801601:	68 33 3d 80 00       	push   $0x803d33
  801606:	e8 77 ec ff ff       	call   800282 <_panic>

0080160b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801611:	83 ec 04             	sub    $0x4,%esp
  801614:	68 10 3e 80 00       	push   $0x803e10
  801619:	68 03 01 00 00       	push   $0x103
  80161e:	68 33 3d 80 00       	push   $0x803d33
  801623:	e8 5a ec ff ff       	call   800282 <_panic>

00801628 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	68 34 3e 80 00       	push   $0x803e34
  801636:	68 0e 01 00 00       	push   $0x10e
  80163b:	68 33 3d 80 00       	push   $0x803d33
  801640:	e8 3d ec ff ff       	call   800282 <_panic>

00801645 <shrink>:

}
void shrink(uint32 newSize)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80164b:	83 ec 04             	sub    $0x4,%esp
  80164e:	68 34 3e 80 00       	push   $0x803e34
  801653:	68 13 01 00 00       	push   $0x113
  801658:	68 33 3d 80 00       	push   $0x803d33
  80165d:	e8 20 ec ff ff       	call   800282 <_panic>

00801662 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801668:	83 ec 04             	sub    $0x4,%esp
  80166b:	68 34 3e 80 00       	push   $0x803e34
  801670:	68 18 01 00 00       	push   $0x118
  801675:	68 33 3d 80 00       	push   $0x803d33
  80167a:	e8 03 ec ff ff       	call   800282 <_panic>

0080167f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	57                   	push   %edi
  801683:	56                   	push   %esi
  801684:	53                   	push   %ebx
  801685:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801691:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801694:	8b 7d 18             	mov    0x18(%ebp),%edi
  801697:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80169a:	cd 30                	int    $0x30
  80169c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80169f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5f                   	pop    %edi
  8016a8:	5d                   	pop    %ebp
  8016a9:	c3                   	ret    

008016aa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	83 ec 04             	sub    $0x4,%esp
  8016b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	52                   	push   %edx
  8016c2:	ff 75 0c             	pushl  0xc(%ebp)
  8016c5:	50                   	push   %eax
  8016c6:	6a 00                	push   $0x0
  8016c8:	e8 b2 ff ff ff       	call   80167f <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	90                   	nop
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 01                	push   $0x1
  8016e2:	e8 98 ff ff ff       	call   80167f <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	52                   	push   %edx
  8016fc:	50                   	push   %eax
  8016fd:	6a 05                	push   $0x5
  8016ff:	e8 7b ff ff ff       	call   80167f <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	56                   	push   %esi
  80170d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80170e:	8b 75 18             	mov    0x18(%ebp),%esi
  801711:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801714:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801717:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	56                   	push   %esi
  80171e:	53                   	push   %ebx
  80171f:	51                   	push   %ecx
  801720:	52                   	push   %edx
  801721:	50                   	push   %eax
  801722:	6a 06                	push   $0x6
  801724:	e8 56 ff ff ff       	call   80167f <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80172f:	5b                   	pop    %ebx
  801730:	5e                   	pop    %esi
  801731:	5d                   	pop    %ebp
  801732:	c3                   	ret    

00801733 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801736:	8b 55 0c             	mov    0xc(%ebp),%edx
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	52                   	push   %edx
  801743:	50                   	push   %eax
  801744:	6a 07                	push   $0x7
  801746:	e8 34 ff ff ff       	call   80167f <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	ff 75 0c             	pushl  0xc(%ebp)
  80175c:	ff 75 08             	pushl  0x8(%ebp)
  80175f:	6a 08                	push   $0x8
  801761:	e8 19 ff ff ff       	call   80167f <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 09                	push   $0x9
  80177a:	e8 00 ff ff ff       	call   80167f <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 0a                	push   $0xa
  801793:	e8 e7 fe ff ff       	call   80167f <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 0b                	push   $0xb
  8017ac:	e8 ce fe ff ff       	call   80167f <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	ff 75 0c             	pushl  0xc(%ebp)
  8017c2:	ff 75 08             	pushl  0x8(%ebp)
  8017c5:	6a 0f                	push   $0xf
  8017c7:	e8 b3 fe ff ff       	call   80167f <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
	return;
  8017cf:	90                   	nop
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	ff 75 08             	pushl  0x8(%ebp)
  8017e1:	6a 10                	push   $0x10
  8017e3:	e8 97 fe ff ff       	call   80167f <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8017eb:	90                   	nop
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	ff 75 10             	pushl  0x10(%ebp)
  8017f8:	ff 75 0c             	pushl  0xc(%ebp)
  8017fb:	ff 75 08             	pushl  0x8(%ebp)
  8017fe:	6a 11                	push   $0x11
  801800:	e8 7a fe ff ff       	call   80167f <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
	return ;
  801808:	90                   	nop
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 0c                	push   $0xc
  80181a:	e8 60 fe ff ff       	call   80167f <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	ff 75 08             	pushl  0x8(%ebp)
  801832:	6a 0d                	push   $0xd
  801834:	e8 46 fe ff ff       	call   80167f <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 0e                	push   $0xe
  80184d:	e8 2d fe ff ff       	call   80167f <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
}
  801855:	90                   	nop
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 13                	push   $0x13
  801867:	e8 13 fe ff ff       	call   80167f <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	90                   	nop
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 14                	push   $0x14
  801881:	e8 f9 fd ff ff       	call   80167f <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	90                   	nop
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_cputc>:


void
sys_cputc(const char c)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801898:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	50                   	push   %eax
  8018a5:	6a 15                	push   $0x15
  8018a7:	e8 d3 fd ff ff       	call   80167f <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	90                   	nop
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 16                	push   $0x16
  8018c1:	e8 b9 fd ff ff       	call   80167f <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	90                   	nop
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	ff 75 0c             	pushl  0xc(%ebp)
  8018db:	50                   	push   %eax
  8018dc:	6a 17                	push   $0x17
  8018de:	e8 9c fd ff ff       	call   80167f <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	52                   	push   %edx
  8018f8:	50                   	push   %eax
  8018f9:	6a 1a                	push   $0x1a
  8018fb:	e8 7f fd ff ff       	call   80167f <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801908:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	52                   	push   %edx
  801915:	50                   	push   %eax
  801916:	6a 18                	push   $0x18
  801918:	e8 62 fd ff ff       	call   80167f <syscall>
  80191d:	83 c4 18             	add    $0x18,%esp
}
  801920:	90                   	nop
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801926:	8b 55 0c             	mov    0xc(%ebp),%edx
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	52                   	push   %edx
  801933:	50                   	push   %eax
  801934:	6a 19                	push   $0x19
  801936:	e8 44 fd ff ff       	call   80167f <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	90                   	nop
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	8b 45 10             	mov    0x10(%ebp),%eax
  80194a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80194d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801950:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	6a 00                	push   $0x0
  801959:	51                   	push   %ecx
  80195a:	52                   	push   %edx
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	50                   	push   %eax
  80195f:	6a 1b                	push   $0x1b
  801961:	e8 19 fd ff ff       	call   80167f <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80196e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	52                   	push   %edx
  80197b:	50                   	push   %eax
  80197c:	6a 1c                	push   $0x1c
  80197e:	e8 fc fc ff ff       	call   80167f <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80198b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	51                   	push   %ecx
  801999:	52                   	push   %edx
  80199a:	50                   	push   %eax
  80199b:	6a 1d                	push   $0x1d
  80199d:	e8 dd fc ff ff       	call   80167f <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	52                   	push   %edx
  8019b7:	50                   	push   %eax
  8019b8:	6a 1e                	push   $0x1e
  8019ba:	e8 c0 fc ff ff       	call   80167f <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 1f                	push   $0x1f
  8019d3:	e8 a7 fc ff ff       	call   80167f <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	6a 00                	push   $0x0
  8019e5:	ff 75 14             	pushl  0x14(%ebp)
  8019e8:	ff 75 10             	pushl  0x10(%ebp)
  8019eb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ee:	50                   	push   %eax
  8019ef:	6a 20                	push   $0x20
  8019f1:	e8 89 fc ff ff       	call   80167f <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	50                   	push   %eax
  801a0a:	6a 21                	push   $0x21
  801a0c:	e8 6e fc ff ff       	call   80167f <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	90                   	nop
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	50                   	push   %eax
  801a26:	6a 22                	push   $0x22
  801a28:	e8 52 fc ff ff       	call   80167f <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 02                	push   $0x2
  801a41:	e8 39 fc ff ff       	call   80167f <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 03                	push   $0x3
  801a5a:	e8 20 fc ff ff       	call   80167f <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 04                	push   $0x4
  801a73:	e8 07 fc ff ff       	call   80167f <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_exit_env>:


void sys_exit_env(void)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 23                	push   $0x23
  801a8c:	e8 ee fb ff ff       	call   80167f <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	90                   	nop
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a9d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aa0:	8d 50 04             	lea    0x4(%eax),%edx
  801aa3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	52                   	push   %edx
  801aad:	50                   	push   %eax
  801aae:	6a 24                	push   $0x24
  801ab0:	e8 ca fb ff ff       	call   80167f <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
	return result;
  801ab8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801abb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac1:	89 01                	mov    %eax,(%ecx)
  801ac3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	c9                   	leave  
  801aca:	c2 04 00             	ret    $0x4

00801acd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	ff 75 10             	pushl  0x10(%ebp)
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	ff 75 08             	pushl  0x8(%ebp)
  801add:	6a 12                	push   $0x12
  801adf:	e8 9b fb ff ff       	call   80167f <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae7:	90                   	nop
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_rcr2>:
uint32 sys_rcr2()
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 25                	push   $0x25
  801af9:	e8 81 fb ff ff       	call   80167f <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 04             	sub    $0x4,%esp
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b0f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	50                   	push   %eax
  801b1c:	6a 26                	push   $0x26
  801b1e:	e8 5c fb ff ff       	call   80167f <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
	return ;
  801b26:	90                   	nop
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <rsttst>:
void rsttst()
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 28                	push   $0x28
  801b38:	e8 42 fb ff ff       	call   80167f <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b40:	90                   	nop
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 04             	sub    $0x4,%esp
  801b49:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b4f:	8b 55 18             	mov    0x18(%ebp),%edx
  801b52:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b56:	52                   	push   %edx
  801b57:	50                   	push   %eax
  801b58:	ff 75 10             	pushl  0x10(%ebp)
  801b5b:	ff 75 0c             	pushl  0xc(%ebp)
  801b5e:	ff 75 08             	pushl  0x8(%ebp)
  801b61:	6a 27                	push   $0x27
  801b63:	e8 17 fb ff ff       	call   80167f <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6b:	90                   	nop
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <chktst>:
void chktst(uint32 n)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	ff 75 08             	pushl  0x8(%ebp)
  801b7c:	6a 29                	push   $0x29
  801b7e:	e8 fc fa ff ff       	call   80167f <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
	return ;
  801b86:	90                   	nop
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <inctst>:

void inctst()
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 2a                	push   $0x2a
  801b98:	e8 e2 fa ff ff       	call   80167f <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba0:	90                   	nop
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <gettst>:
uint32 gettst()
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 2b                	push   $0x2b
  801bb2:	e8 c8 fa ff ff       	call   80167f <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 2c                	push   $0x2c
  801bce:	e8 ac fa ff ff       	call   80167f <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
  801bd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bd9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bdd:	75 07                	jne    801be6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bdf:	b8 01 00 00 00       	mov    $0x1,%eax
  801be4:	eb 05                	jmp    801beb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801be6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 2c                	push   $0x2c
  801bff:	e8 7b fa ff ff       	call   80167f <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
  801c07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c0a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c0e:	75 07                	jne    801c17 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c10:	b8 01 00 00 00       	mov    $0x1,%eax
  801c15:	eb 05                	jmp    801c1c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 2c                	push   $0x2c
  801c30:	e8 4a fa ff ff       	call   80167f <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
  801c38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c3b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c3f:	75 07                	jne    801c48 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c41:	b8 01 00 00 00       	mov    $0x1,%eax
  801c46:	eb 05                	jmp    801c4d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801c61:	e8 19 fa ff ff       	call   80167f <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
  801c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c6c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c70:	75 07                	jne    801c79 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c72:	b8 01 00 00 00       	mov    $0x1,%eax
  801c77:	eb 05                	jmp    801c7e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	ff 75 08             	pushl  0x8(%ebp)
  801c8e:	6a 2d                	push   $0x2d
  801c90:	e8 ea f9 ff ff       	call   80167f <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
	return ;
  801c98:	90                   	nop
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c9f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ca2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	53                   	push   %ebx
  801cae:	51                   	push   %ecx
  801caf:	52                   	push   %edx
  801cb0:	50                   	push   %eax
  801cb1:	6a 2e                	push   $0x2e
  801cb3:	e8 c7 f9 ff ff       	call   80167f <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	52                   	push   %edx
  801cd0:	50                   	push   %eax
  801cd1:	6a 2f                	push   $0x2f
  801cd3:	e8 a7 f9 ff ff       	call   80167f <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ce3:	83 ec 0c             	sub    $0xc,%esp
  801ce6:	68 44 3e 80 00       	push   $0x803e44
  801ceb:	e8 46 e8 ff ff       	call   800536 <cprintf>
  801cf0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cfa:	83 ec 0c             	sub    $0xc,%esp
  801cfd:	68 70 3e 80 00       	push   $0x803e70
  801d02:	e8 2f e8 ff ff       	call   800536 <cprintf>
  801d07:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d0a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d0e:	a1 38 41 80 00       	mov    0x804138,%eax
  801d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d16:	eb 56                	jmp    801d6e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d1c:	74 1c                	je     801d3a <print_mem_block_lists+0x5d>
  801d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d21:	8b 50 08             	mov    0x8(%eax),%edx
  801d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d27:	8b 48 08             	mov    0x8(%eax),%ecx
  801d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d30:	01 c8                	add    %ecx,%eax
  801d32:	39 c2                	cmp    %eax,%edx
  801d34:	73 04                	jae    801d3a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d36:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3d:	8b 50 08             	mov    0x8(%eax),%edx
  801d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d43:	8b 40 0c             	mov    0xc(%eax),%eax
  801d46:	01 c2                	add    %eax,%edx
  801d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4b:	8b 40 08             	mov    0x8(%eax),%eax
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	52                   	push   %edx
  801d52:	50                   	push   %eax
  801d53:	68 85 3e 80 00       	push   $0x803e85
  801d58:	e8 d9 e7 ff ff       	call   800536 <cprintf>
  801d5d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d66:	a1 40 41 80 00       	mov    0x804140,%eax
  801d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d72:	74 07                	je     801d7b <print_mem_block_lists+0x9e>
  801d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d77:	8b 00                	mov    (%eax),%eax
  801d79:	eb 05                	jmp    801d80 <print_mem_block_lists+0xa3>
  801d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d80:	a3 40 41 80 00       	mov    %eax,0x804140
  801d85:	a1 40 41 80 00       	mov    0x804140,%eax
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	75 8a                	jne    801d18 <print_mem_block_lists+0x3b>
  801d8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d92:	75 84                	jne    801d18 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d94:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d98:	75 10                	jne    801daa <print_mem_block_lists+0xcd>
  801d9a:	83 ec 0c             	sub    $0xc,%esp
  801d9d:	68 94 3e 80 00       	push   $0x803e94
  801da2:	e8 8f e7 ff ff       	call   800536 <cprintf>
  801da7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801daa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801db1:	83 ec 0c             	sub    $0xc,%esp
  801db4:	68 b8 3e 80 00       	push   $0x803eb8
  801db9:	e8 78 e7 ff ff       	call   800536 <cprintf>
  801dbe:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801dc1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dc5:	a1 40 40 80 00       	mov    0x804040,%eax
  801dca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dcd:	eb 56                	jmp    801e25 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dcf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dd3:	74 1c                	je     801df1 <print_mem_block_lists+0x114>
  801dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd8:	8b 50 08             	mov    0x8(%eax),%edx
  801ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dde:	8b 48 08             	mov    0x8(%eax),%ecx
  801de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de4:	8b 40 0c             	mov    0xc(%eax),%eax
  801de7:	01 c8                	add    %ecx,%eax
  801de9:	39 c2                	cmp    %eax,%edx
  801deb:	73 04                	jae    801df1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ded:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df4:	8b 50 08             	mov    0x8(%eax),%edx
  801df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfa:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfd:	01 c2                	add    %eax,%edx
  801dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e02:	8b 40 08             	mov    0x8(%eax),%eax
  801e05:	83 ec 04             	sub    $0x4,%esp
  801e08:	52                   	push   %edx
  801e09:	50                   	push   %eax
  801e0a:	68 85 3e 80 00       	push   $0x803e85
  801e0f:	e8 22 e7 ff ff       	call   800536 <cprintf>
  801e14:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e1d:	a1 48 40 80 00       	mov    0x804048,%eax
  801e22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e29:	74 07                	je     801e32 <print_mem_block_lists+0x155>
  801e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2e:	8b 00                	mov    (%eax),%eax
  801e30:	eb 05                	jmp    801e37 <print_mem_block_lists+0x15a>
  801e32:	b8 00 00 00 00       	mov    $0x0,%eax
  801e37:	a3 48 40 80 00       	mov    %eax,0x804048
  801e3c:	a1 48 40 80 00       	mov    0x804048,%eax
  801e41:	85 c0                	test   %eax,%eax
  801e43:	75 8a                	jne    801dcf <print_mem_block_lists+0xf2>
  801e45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e49:	75 84                	jne    801dcf <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e4b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e4f:	75 10                	jne    801e61 <print_mem_block_lists+0x184>
  801e51:	83 ec 0c             	sub    $0xc,%esp
  801e54:	68 d0 3e 80 00       	push   $0x803ed0
  801e59:	e8 d8 e6 ff ff       	call   800536 <cprintf>
  801e5e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e61:	83 ec 0c             	sub    $0xc,%esp
  801e64:	68 44 3e 80 00       	push   $0x803e44
  801e69:	e8 c8 e6 ff ff       	call   800536 <cprintf>
  801e6e:	83 c4 10             	add    $0x10,%esp

}
  801e71:	90                   	nop
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e7a:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e81:	00 00 00 
  801e84:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e8b:	00 00 00 
  801e8e:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e95:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e9f:	e9 9e 00 00 00       	jmp    801f42 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ea4:	a1 50 40 80 00       	mov    0x804050,%eax
  801ea9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eac:	c1 e2 04             	shl    $0x4,%edx
  801eaf:	01 d0                	add    %edx,%eax
  801eb1:	85 c0                	test   %eax,%eax
  801eb3:	75 14                	jne    801ec9 <initialize_MemBlocksList+0x55>
  801eb5:	83 ec 04             	sub    $0x4,%esp
  801eb8:	68 f8 3e 80 00       	push   $0x803ef8
  801ebd:	6a 46                	push   $0x46
  801ebf:	68 1b 3f 80 00       	push   $0x803f1b
  801ec4:	e8 b9 e3 ff ff       	call   800282 <_panic>
  801ec9:	a1 50 40 80 00       	mov    0x804050,%eax
  801ece:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed1:	c1 e2 04             	shl    $0x4,%edx
  801ed4:	01 d0                	add    %edx,%eax
  801ed6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801edc:	89 10                	mov    %edx,(%eax)
  801ede:	8b 00                	mov    (%eax),%eax
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	74 18                	je     801efc <initialize_MemBlocksList+0x88>
  801ee4:	a1 48 41 80 00       	mov    0x804148,%eax
  801ee9:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801eef:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ef2:	c1 e1 04             	shl    $0x4,%ecx
  801ef5:	01 ca                	add    %ecx,%edx
  801ef7:	89 50 04             	mov    %edx,0x4(%eax)
  801efa:	eb 12                	jmp    801f0e <initialize_MemBlocksList+0x9a>
  801efc:	a1 50 40 80 00       	mov    0x804050,%eax
  801f01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f04:	c1 e2 04             	shl    $0x4,%edx
  801f07:	01 d0                	add    %edx,%eax
  801f09:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f0e:	a1 50 40 80 00       	mov    0x804050,%eax
  801f13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f16:	c1 e2 04             	shl    $0x4,%edx
  801f19:	01 d0                	add    %edx,%eax
  801f1b:	a3 48 41 80 00       	mov    %eax,0x804148
  801f20:	a1 50 40 80 00       	mov    0x804050,%eax
  801f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f28:	c1 e2 04             	shl    $0x4,%edx
  801f2b:	01 d0                	add    %edx,%eax
  801f2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f34:	a1 54 41 80 00       	mov    0x804154,%eax
  801f39:	40                   	inc    %eax
  801f3a:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f3f:	ff 45 f4             	incl   -0xc(%ebp)
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f48:	0f 82 56 ff ff ff    	jb     801ea4 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f4e:	90                   	nop
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	8b 00                	mov    (%eax),%eax
  801f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f5f:	eb 19                	jmp    801f7a <find_block+0x29>
	{
		if(va==point->sva)
  801f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f64:	8b 40 08             	mov    0x8(%eax),%eax
  801f67:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f6a:	75 05                	jne    801f71 <find_block+0x20>
		   return point;
  801f6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f6f:	eb 36                	jmp    801fa7 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	8b 40 08             	mov    0x8(%eax),%eax
  801f77:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f7e:	74 07                	je     801f87 <find_block+0x36>
  801f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f83:	8b 00                	mov    (%eax),%eax
  801f85:	eb 05                	jmp    801f8c <find_block+0x3b>
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  801f8f:	89 42 08             	mov    %eax,0x8(%edx)
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	8b 40 08             	mov    0x8(%eax),%eax
  801f98:	85 c0                	test   %eax,%eax
  801f9a:	75 c5                	jne    801f61 <find_block+0x10>
  801f9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fa0:	75 bf                	jne    801f61 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801faf:	a1 40 40 80 00       	mov    0x804040,%eax
  801fb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fb7:	a1 44 40 80 00       	mov    0x804044,%eax
  801fbc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fc5:	74 24                	je     801feb <insert_sorted_allocList+0x42>
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	8b 50 08             	mov    0x8(%eax),%edx
  801fcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd0:	8b 40 08             	mov    0x8(%eax),%eax
  801fd3:	39 c2                	cmp    %eax,%edx
  801fd5:	76 14                	jbe    801feb <insert_sorted_allocList+0x42>
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	8b 50 08             	mov    0x8(%eax),%edx
  801fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe0:	8b 40 08             	mov    0x8(%eax),%eax
  801fe3:	39 c2                	cmp    %eax,%edx
  801fe5:	0f 82 60 01 00 00    	jb     80214b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801feb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fef:	75 65                	jne    802056 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801ff1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ff5:	75 14                	jne    80200b <insert_sorted_allocList+0x62>
  801ff7:	83 ec 04             	sub    $0x4,%esp
  801ffa:	68 f8 3e 80 00       	push   $0x803ef8
  801fff:	6a 6b                	push   $0x6b
  802001:	68 1b 3f 80 00       	push   $0x803f1b
  802006:	e8 77 e2 ff ff       	call   800282 <_panic>
  80200b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	89 10                	mov    %edx,(%eax)
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	8b 00                	mov    (%eax),%eax
  80201b:	85 c0                	test   %eax,%eax
  80201d:	74 0d                	je     80202c <insert_sorted_allocList+0x83>
  80201f:	a1 40 40 80 00       	mov    0x804040,%eax
  802024:	8b 55 08             	mov    0x8(%ebp),%edx
  802027:	89 50 04             	mov    %edx,0x4(%eax)
  80202a:	eb 08                	jmp    802034 <insert_sorted_allocList+0x8b>
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	a3 44 40 80 00       	mov    %eax,0x804044
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	a3 40 40 80 00       	mov    %eax,0x804040
  80203c:	8b 45 08             	mov    0x8(%ebp),%eax
  80203f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802046:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80204b:	40                   	inc    %eax
  80204c:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802051:	e9 dc 01 00 00       	jmp    802232 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	8b 50 08             	mov    0x8(%eax),%edx
  80205c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205f:	8b 40 08             	mov    0x8(%eax),%eax
  802062:	39 c2                	cmp    %eax,%edx
  802064:	77 6c                	ja     8020d2 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802066:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80206a:	74 06                	je     802072 <insert_sorted_allocList+0xc9>
  80206c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802070:	75 14                	jne    802086 <insert_sorted_allocList+0xdd>
  802072:	83 ec 04             	sub    $0x4,%esp
  802075:	68 34 3f 80 00       	push   $0x803f34
  80207a:	6a 6f                	push   $0x6f
  80207c:	68 1b 3f 80 00       	push   $0x803f1b
  802081:	e8 fc e1 ff ff       	call   800282 <_panic>
  802086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802089:	8b 50 04             	mov    0x4(%eax),%edx
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	89 50 04             	mov    %edx,0x4(%eax)
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802098:	89 10                	mov    %edx,(%eax)
  80209a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209d:	8b 40 04             	mov    0x4(%eax),%eax
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	74 0d                	je     8020b1 <insert_sorted_allocList+0x108>
  8020a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a7:	8b 40 04             	mov    0x4(%eax),%eax
  8020aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ad:	89 10                	mov    %edx,(%eax)
  8020af:	eb 08                	jmp    8020b9 <insert_sorted_allocList+0x110>
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	a3 40 40 80 00       	mov    %eax,0x804040
  8020b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bf:	89 50 04             	mov    %edx,0x4(%eax)
  8020c2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020c7:	40                   	inc    %eax
  8020c8:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020cd:	e9 60 01 00 00       	jmp    802232 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	8b 50 08             	mov    0x8(%eax),%edx
  8020d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020db:	8b 40 08             	mov    0x8(%eax),%eax
  8020de:	39 c2                	cmp    %eax,%edx
  8020e0:	0f 82 4c 01 00 00    	jb     802232 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ea:	75 14                	jne    802100 <insert_sorted_allocList+0x157>
  8020ec:	83 ec 04             	sub    $0x4,%esp
  8020ef:	68 6c 3f 80 00       	push   $0x803f6c
  8020f4:	6a 73                	push   $0x73
  8020f6:	68 1b 3f 80 00       	push   $0x803f1b
  8020fb:	e8 82 e1 ff ff       	call   800282 <_panic>
  802100:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	89 50 04             	mov    %edx,0x4(%eax)
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	8b 40 04             	mov    0x4(%eax),%eax
  802112:	85 c0                	test   %eax,%eax
  802114:	74 0c                	je     802122 <insert_sorted_allocList+0x179>
  802116:	a1 44 40 80 00       	mov    0x804044,%eax
  80211b:	8b 55 08             	mov    0x8(%ebp),%edx
  80211e:	89 10                	mov    %edx,(%eax)
  802120:	eb 08                	jmp    80212a <insert_sorted_allocList+0x181>
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	a3 40 40 80 00       	mov    %eax,0x804040
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	a3 44 40 80 00       	mov    %eax,0x804044
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80213b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802140:	40                   	inc    %eax
  802141:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802146:	e9 e7 00 00 00       	jmp    802232 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80214b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802151:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802158:	a1 40 40 80 00       	mov    0x804040,%eax
  80215d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802160:	e9 9d 00 00 00       	jmp    802202 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	8b 00                	mov    (%eax),%eax
  80216a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	8b 50 08             	mov    0x8(%eax),%edx
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	8b 40 08             	mov    0x8(%eax),%eax
  802179:	39 c2                	cmp    %eax,%edx
  80217b:	76 7d                	jbe    8021fa <insert_sorted_allocList+0x251>
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	8b 50 08             	mov    0x8(%eax),%edx
  802183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802186:	8b 40 08             	mov    0x8(%eax),%eax
  802189:	39 c2                	cmp    %eax,%edx
  80218b:	73 6d                	jae    8021fa <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80218d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802191:	74 06                	je     802199 <insert_sorted_allocList+0x1f0>
  802193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802197:	75 14                	jne    8021ad <insert_sorted_allocList+0x204>
  802199:	83 ec 04             	sub    $0x4,%esp
  80219c:	68 90 3f 80 00       	push   $0x803f90
  8021a1:	6a 7f                	push   $0x7f
  8021a3:	68 1b 3f 80 00       	push   $0x803f1b
  8021a8:	e8 d5 e0 ff ff       	call   800282 <_panic>
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	8b 10                	mov    (%eax),%edx
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	89 10                	mov    %edx,(%eax)
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	8b 00                	mov    (%eax),%eax
  8021bc:	85 c0                	test   %eax,%eax
  8021be:	74 0b                	je     8021cb <insert_sorted_allocList+0x222>
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c8:	89 50 04             	mov    %edx,0x4(%eax)
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d1:	89 10                	mov    %edx,(%eax)
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d9:	89 50 04             	mov    %edx,0x4(%eax)
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	8b 00                	mov    (%eax),%eax
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	75 08                	jne    8021ed <insert_sorted_allocList+0x244>
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	a3 44 40 80 00       	mov    %eax,0x804044
  8021ed:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021f2:	40                   	inc    %eax
  8021f3:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021f8:	eb 39                	jmp    802233 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021fa:	a1 48 40 80 00       	mov    0x804048,%eax
  8021ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802202:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802206:	74 07                	je     80220f <insert_sorted_allocList+0x266>
  802208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220b:	8b 00                	mov    (%eax),%eax
  80220d:	eb 05                	jmp    802214 <insert_sorted_allocList+0x26b>
  80220f:	b8 00 00 00 00       	mov    $0x0,%eax
  802214:	a3 48 40 80 00       	mov    %eax,0x804048
  802219:	a1 48 40 80 00       	mov    0x804048,%eax
  80221e:	85 c0                	test   %eax,%eax
  802220:	0f 85 3f ff ff ff    	jne    802165 <insert_sorted_allocList+0x1bc>
  802226:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222a:	0f 85 35 ff ff ff    	jne    802165 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802230:	eb 01                	jmp    802233 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802232:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802233:	90                   	nop
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80223c:	a1 38 41 80 00       	mov    0x804138,%eax
  802241:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802244:	e9 85 01 00 00       	jmp    8023ce <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	8b 40 0c             	mov    0xc(%eax),%eax
  80224f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802252:	0f 82 6e 01 00 00    	jb     8023c6 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 40 0c             	mov    0xc(%eax),%eax
  80225e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802261:	0f 85 8a 00 00 00    	jne    8022f1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802267:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226b:	75 17                	jne    802284 <alloc_block_FF+0x4e>
  80226d:	83 ec 04             	sub    $0x4,%esp
  802270:	68 c4 3f 80 00       	push   $0x803fc4
  802275:	68 93 00 00 00       	push   $0x93
  80227a:	68 1b 3f 80 00       	push   $0x803f1b
  80227f:	e8 fe df ff ff       	call   800282 <_panic>
  802284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802287:	8b 00                	mov    (%eax),%eax
  802289:	85 c0                	test   %eax,%eax
  80228b:	74 10                	je     80229d <alloc_block_FF+0x67>
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	8b 00                	mov    (%eax),%eax
  802292:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802295:	8b 52 04             	mov    0x4(%edx),%edx
  802298:	89 50 04             	mov    %edx,0x4(%eax)
  80229b:	eb 0b                	jmp    8022a8 <alloc_block_FF+0x72>
  80229d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a0:	8b 40 04             	mov    0x4(%eax),%eax
  8022a3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	8b 40 04             	mov    0x4(%eax),%eax
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	74 0f                	je     8022c1 <alloc_block_FF+0x8b>
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	8b 40 04             	mov    0x4(%eax),%eax
  8022b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bb:	8b 12                	mov    (%edx),%edx
  8022bd:	89 10                	mov    %edx,(%eax)
  8022bf:	eb 0a                	jmp    8022cb <alloc_block_FF+0x95>
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	8b 00                	mov    (%eax),%eax
  8022c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022de:	a1 44 41 80 00       	mov    0x804144,%eax
  8022e3:	48                   	dec    %eax
  8022e4:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	e9 10 01 00 00       	jmp    802401 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022fa:	0f 86 c6 00 00 00    	jbe    8023c6 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802300:	a1 48 41 80 00       	mov    0x804148,%eax
  802305:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 50 08             	mov    0x8(%eax),%edx
  80230e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802311:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802317:	8b 55 08             	mov    0x8(%ebp),%edx
  80231a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80231d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802321:	75 17                	jne    80233a <alloc_block_FF+0x104>
  802323:	83 ec 04             	sub    $0x4,%esp
  802326:	68 c4 3f 80 00       	push   $0x803fc4
  80232b:	68 9b 00 00 00       	push   $0x9b
  802330:	68 1b 3f 80 00       	push   $0x803f1b
  802335:	e8 48 df ff ff       	call   800282 <_panic>
  80233a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233d:	8b 00                	mov    (%eax),%eax
  80233f:	85 c0                	test   %eax,%eax
  802341:	74 10                	je     802353 <alloc_block_FF+0x11d>
  802343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802346:	8b 00                	mov    (%eax),%eax
  802348:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234b:	8b 52 04             	mov    0x4(%edx),%edx
  80234e:	89 50 04             	mov    %edx,0x4(%eax)
  802351:	eb 0b                	jmp    80235e <alloc_block_FF+0x128>
  802353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802356:	8b 40 04             	mov    0x4(%eax),%eax
  802359:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80235e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802361:	8b 40 04             	mov    0x4(%eax),%eax
  802364:	85 c0                	test   %eax,%eax
  802366:	74 0f                	je     802377 <alloc_block_FF+0x141>
  802368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236b:	8b 40 04             	mov    0x4(%eax),%eax
  80236e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802371:	8b 12                	mov    (%edx),%edx
  802373:	89 10                	mov    %edx,(%eax)
  802375:	eb 0a                	jmp    802381 <alloc_block_FF+0x14b>
  802377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	a3 48 41 80 00       	mov    %eax,0x804148
  802381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802384:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802394:	a1 54 41 80 00       	mov    0x804154,%eax
  802399:	48                   	dec    %eax
  80239a:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 50 08             	mov    0x8(%eax),%edx
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	01 c2                	add    %eax,%edx
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b6:	2b 45 08             	sub    0x8(%ebp),%eax
  8023b9:	89 c2                	mov    %eax,%edx
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c4:	eb 3b                	jmp    802401 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023c6:	a1 40 41 80 00       	mov    0x804140,%eax
  8023cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d2:	74 07                	je     8023db <alloc_block_FF+0x1a5>
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 00                	mov    (%eax),%eax
  8023d9:	eb 05                	jmp    8023e0 <alloc_block_FF+0x1aa>
  8023db:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e0:	a3 40 41 80 00       	mov    %eax,0x804140
  8023e5:	a1 40 41 80 00       	mov    0x804140,%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	0f 85 57 fe ff ff    	jne    802249 <alloc_block_FF+0x13>
  8023f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f6:	0f 85 4d fe ff ff    	jne    802249 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
  802406:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802409:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802410:	a1 38 41 80 00       	mov    0x804138,%eax
  802415:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802418:	e9 df 00 00 00       	jmp    8024fc <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	8b 40 0c             	mov    0xc(%eax),%eax
  802423:	3b 45 08             	cmp    0x8(%ebp),%eax
  802426:	0f 82 c8 00 00 00    	jb     8024f4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	8b 40 0c             	mov    0xc(%eax),%eax
  802432:	3b 45 08             	cmp    0x8(%ebp),%eax
  802435:	0f 85 8a 00 00 00    	jne    8024c5 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80243b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243f:	75 17                	jne    802458 <alloc_block_BF+0x55>
  802441:	83 ec 04             	sub    $0x4,%esp
  802444:	68 c4 3f 80 00       	push   $0x803fc4
  802449:	68 b7 00 00 00       	push   $0xb7
  80244e:	68 1b 3f 80 00       	push   $0x803f1b
  802453:	e8 2a de ff ff       	call   800282 <_panic>
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 00                	mov    (%eax),%eax
  80245d:	85 c0                	test   %eax,%eax
  80245f:	74 10                	je     802471 <alloc_block_BF+0x6e>
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 00                	mov    (%eax),%eax
  802466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802469:	8b 52 04             	mov    0x4(%edx),%edx
  80246c:	89 50 04             	mov    %edx,0x4(%eax)
  80246f:	eb 0b                	jmp    80247c <alloc_block_BF+0x79>
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	8b 40 04             	mov    0x4(%eax),%eax
  802477:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 40 04             	mov    0x4(%eax),%eax
  802482:	85 c0                	test   %eax,%eax
  802484:	74 0f                	je     802495 <alloc_block_BF+0x92>
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	8b 40 04             	mov    0x4(%eax),%eax
  80248c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248f:	8b 12                	mov    (%edx),%edx
  802491:	89 10                	mov    %edx,(%eax)
  802493:	eb 0a                	jmp    80249f <alloc_block_BF+0x9c>
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 00                	mov    (%eax),%eax
  80249a:	a3 38 41 80 00       	mov    %eax,0x804138
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b2:	a1 44 41 80 00       	mov    0x804144,%eax
  8024b7:	48                   	dec    %eax
  8024b8:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	e9 4d 01 00 00       	jmp    802612 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ce:	76 24                	jbe    8024f4 <alloc_block_BF+0xf1>
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024d9:	73 19                	jae    8024f4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024db:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 40 08             	mov    0x8(%eax),%eax
  8024f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024f4:	a1 40 41 80 00       	mov    0x804140,%eax
  8024f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802500:	74 07                	je     802509 <alloc_block_BF+0x106>
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 00                	mov    (%eax),%eax
  802507:	eb 05                	jmp    80250e <alloc_block_BF+0x10b>
  802509:	b8 00 00 00 00       	mov    $0x0,%eax
  80250e:	a3 40 41 80 00       	mov    %eax,0x804140
  802513:	a1 40 41 80 00       	mov    0x804140,%eax
  802518:	85 c0                	test   %eax,%eax
  80251a:	0f 85 fd fe ff ff    	jne    80241d <alloc_block_BF+0x1a>
  802520:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802524:	0f 85 f3 fe ff ff    	jne    80241d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80252a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80252e:	0f 84 d9 00 00 00    	je     80260d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802534:	a1 48 41 80 00       	mov    0x804148,%eax
  802539:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80253c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802542:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802548:	8b 55 08             	mov    0x8(%ebp),%edx
  80254b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80254e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802552:	75 17                	jne    80256b <alloc_block_BF+0x168>
  802554:	83 ec 04             	sub    $0x4,%esp
  802557:	68 c4 3f 80 00       	push   $0x803fc4
  80255c:	68 c7 00 00 00       	push   $0xc7
  802561:	68 1b 3f 80 00       	push   $0x803f1b
  802566:	e8 17 dd ff ff       	call   800282 <_panic>
  80256b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256e:	8b 00                	mov    (%eax),%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	74 10                	je     802584 <alloc_block_BF+0x181>
  802574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80257c:	8b 52 04             	mov    0x4(%edx),%edx
  80257f:	89 50 04             	mov    %edx,0x4(%eax)
  802582:	eb 0b                	jmp    80258f <alloc_block_BF+0x18c>
  802584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802587:	8b 40 04             	mov    0x4(%eax),%eax
  80258a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80258f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802592:	8b 40 04             	mov    0x4(%eax),%eax
  802595:	85 c0                	test   %eax,%eax
  802597:	74 0f                	je     8025a8 <alloc_block_BF+0x1a5>
  802599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259c:	8b 40 04             	mov    0x4(%eax),%eax
  80259f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a2:	8b 12                	mov    (%edx),%edx
  8025a4:	89 10                	mov    %edx,(%eax)
  8025a6:	eb 0a                	jmp    8025b2 <alloc_block_BF+0x1af>
  8025a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ab:	8b 00                	mov    (%eax),%eax
  8025ad:	a3 48 41 80 00       	mov    %eax,0x804148
  8025b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c5:	a1 54 41 80 00       	mov    0x804154,%eax
  8025ca:	48                   	dec    %eax
  8025cb:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025d0:	83 ec 08             	sub    $0x8,%esp
  8025d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8025d6:	68 38 41 80 00       	push   $0x804138
  8025db:	e8 71 f9 ff ff       	call   801f51 <find_block>
  8025e0:	83 c4 10             	add    $0x10,%esp
  8025e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e9:	8b 50 08             	mov    0x8(%eax),%edx
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	01 c2                	add    %eax,%edx
  8025f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fd:	2b 45 08             	sub    0x8(%ebp),%eax
  802600:	89 c2                	mov    %eax,%edx
  802602:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802605:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260b:	eb 05                	jmp    802612 <alloc_block_BF+0x20f>
	}
	return NULL;
  80260d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802612:	c9                   	leave  
  802613:	c3                   	ret    

00802614 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
  802617:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80261a:	a1 28 40 80 00       	mov    0x804028,%eax
  80261f:	85 c0                	test   %eax,%eax
  802621:	0f 85 de 01 00 00    	jne    802805 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802627:	a1 38 41 80 00       	mov    0x804138,%eax
  80262c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262f:	e9 9e 01 00 00       	jmp    8027d2 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 40 0c             	mov    0xc(%eax),%eax
  80263a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263d:	0f 82 87 01 00 00    	jb     8027ca <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	8b 40 0c             	mov    0xc(%eax),%eax
  802649:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264c:	0f 85 95 00 00 00    	jne    8026e7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802652:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802656:	75 17                	jne    80266f <alloc_block_NF+0x5b>
  802658:	83 ec 04             	sub    $0x4,%esp
  80265b:	68 c4 3f 80 00       	push   $0x803fc4
  802660:	68 e0 00 00 00       	push   $0xe0
  802665:	68 1b 3f 80 00       	push   $0x803f1b
  80266a:	e8 13 dc ff ff       	call   800282 <_panic>
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 00                	mov    (%eax),%eax
  802674:	85 c0                	test   %eax,%eax
  802676:	74 10                	je     802688 <alloc_block_NF+0x74>
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 00                	mov    (%eax),%eax
  80267d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802680:	8b 52 04             	mov    0x4(%edx),%edx
  802683:	89 50 04             	mov    %edx,0x4(%eax)
  802686:	eb 0b                	jmp    802693 <alloc_block_NF+0x7f>
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 40 04             	mov    0x4(%eax),%eax
  80268e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 40 04             	mov    0x4(%eax),%eax
  802699:	85 c0                	test   %eax,%eax
  80269b:	74 0f                	je     8026ac <alloc_block_NF+0x98>
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	8b 40 04             	mov    0x4(%eax),%eax
  8026a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a6:	8b 12                	mov    (%edx),%edx
  8026a8:	89 10                	mov    %edx,(%eax)
  8026aa:	eb 0a                	jmp    8026b6 <alloc_block_NF+0xa2>
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	8b 00                	mov    (%eax),%eax
  8026b1:	a3 38 41 80 00       	mov    %eax,0x804138
  8026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c9:	a1 44 41 80 00       	mov    0x804144,%eax
  8026ce:	48                   	dec    %eax
  8026cf:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 40 08             	mov    0x8(%eax),%eax
  8026da:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	e9 f8 04 00 00       	jmp    802bdf <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f0:	0f 86 d4 00 00 00    	jbe    8027ca <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026f6:	a1 48 41 80 00       	mov    0x804148,%eax
  8026fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 50 08             	mov    0x8(%eax),%edx
  802704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802707:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80270a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270d:	8b 55 08             	mov    0x8(%ebp),%edx
  802710:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802713:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802717:	75 17                	jne    802730 <alloc_block_NF+0x11c>
  802719:	83 ec 04             	sub    $0x4,%esp
  80271c:	68 c4 3f 80 00       	push   $0x803fc4
  802721:	68 e9 00 00 00       	push   $0xe9
  802726:	68 1b 3f 80 00       	push   $0x803f1b
  80272b:	e8 52 db ff ff       	call   800282 <_panic>
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	8b 00                	mov    (%eax),%eax
  802735:	85 c0                	test   %eax,%eax
  802737:	74 10                	je     802749 <alloc_block_NF+0x135>
  802739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802741:	8b 52 04             	mov    0x4(%edx),%edx
  802744:	89 50 04             	mov    %edx,0x4(%eax)
  802747:	eb 0b                	jmp    802754 <alloc_block_NF+0x140>
  802749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274c:	8b 40 04             	mov    0x4(%eax),%eax
  80274f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802757:	8b 40 04             	mov    0x4(%eax),%eax
  80275a:	85 c0                	test   %eax,%eax
  80275c:	74 0f                	je     80276d <alloc_block_NF+0x159>
  80275e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802761:	8b 40 04             	mov    0x4(%eax),%eax
  802764:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802767:	8b 12                	mov    (%edx),%edx
  802769:	89 10                	mov    %edx,(%eax)
  80276b:	eb 0a                	jmp    802777 <alloc_block_NF+0x163>
  80276d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802770:	8b 00                	mov    (%eax),%eax
  802772:	a3 48 41 80 00       	mov    %eax,0x804148
  802777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802783:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278a:	a1 54 41 80 00       	mov    0x804154,%eax
  80278f:	48                   	dec    %eax
  802790:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802798:	8b 40 08             	mov    0x8(%eax),%eax
  80279b:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	8b 50 08             	mov    0x8(%eax),%edx
  8027a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a9:	01 c2                	add    %eax,%edx
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ba:	89 c2                	mov    %eax,%edx
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c5:	e9 15 04 00 00       	jmp    802bdf <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027ca:	a1 40 41 80 00       	mov    0x804140,%eax
  8027cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d6:	74 07                	je     8027df <alloc_block_NF+0x1cb>
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 00                	mov    (%eax),%eax
  8027dd:	eb 05                	jmp    8027e4 <alloc_block_NF+0x1d0>
  8027df:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e4:	a3 40 41 80 00       	mov    %eax,0x804140
  8027e9:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	0f 85 3e fe ff ff    	jne    802634 <alloc_block_NF+0x20>
  8027f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fa:	0f 85 34 fe ff ff    	jne    802634 <alloc_block_NF+0x20>
  802800:	e9 d5 03 00 00       	jmp    802bda <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802805:	a1 38 41 80 00       	mov    0x804138,%eax
  80280a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280d:	e9 b1 01 00 00       	jmp    8029c3 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 50 08             	mov    0x8(%eax),%edx
  802818:	a1 28 40 80 00       	mov    0x804028,%eax
  80281d:	39 c2                	cmp    %eax,%edx
  80281f:	0f 82 96 01 00 00    	jb     8029bb <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 40 0c             	mov    0xc(%eax),%eax
  80282b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282e:	0f 82 87 01 00 00    	jb     8029bb <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 40 0c             	mov    0xc(%eax),%eax
  80283a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283d:	0f 85 95 00 00 00    	jne    8028d8 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802843:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802847:	75 17                	jne    802860 <alloc_block_NF+0x24c>
  802849:	83 ec 04             	sub    $0x4,%esp
  80284c:	68 c4 3f 80 00       	push   $0x803fc4
  802851:	68 fc 00 00 00       	push   $0xfc
  802856:	68 1b 3f 80 00       	push   $0x803f1b
  80285b:	e8 22 da ff ff       	call   800282 <_panic>
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 00                	mov    (%eax),%eax
  802865:	85 c0                	test   %eax,%eax
  802867:	74 10                	je     802879 <alloc_block_NF+0x265>
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 00                	mov    (%eax),%eax
  80286e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802871:	8b 52 04             	mov    0x4(%edx),%edx
  802874:	89 50 04             	mov    %edx,0x4(%eax)
  802877:	eb 0b                	jmp    802884 <alloc_block_NF+0x270>
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 40 04             	mov    0x4(%eax),%eax
  80287f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8b 40 04             	mov    0x4(%eax),%eax
  80288a:	85 c0                	test   %eax,%eax
  80288c:	74 0f                	je     80289d <alloc_block_NF+0x289>
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 40 04             	mov    0x4(%eax),%eax
  802894:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802897:	8b 12                	mov    (%edx),%edx
  802899:	89 10                	mov    %edx,(%eax)
  80289b:	eb 0a                	jmp    8028a7 <alloc_block_NF+0x293>
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	a3 38 41 80 00       	mov    %eax,0x804138
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ba:	a1 44 41 80 00       	mov    0x804144,%eax
  8028bf:	48                   	dec    %eax
  8028c0:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 40 08             	mov    0x8(%eax),%eax
  8028cb:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	e9 07 03 00 00       	jmp    802bdf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 40 0c             	mov    0xc(%eax),%eax
  8028de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e1:	0f 86 d4 00 00 00    	jbe    8029bb <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028e7:	a1 48 41 80 00       	mov    0x804148,%eax
  8028ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 50 08             	mov    0x8(%eax),%edx
  8028f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802901:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802904:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802908:	75 17                	jne    802921 <alloc_block_NF+0x30d>
  80290a:	83 ec 04             	sub    $0x4,%esp
  80290d:	68 c4 3f 80 00       	push   $0x803fc4
  802912:	68 04 01 00 00       	push   $0x104
  802917:	68 1b 3f 80 00       	push   $0x803f1b
  80291c:	e8 61 d9 ff ff       	call   800282 <_panic>
  802921:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802924:	8b 00                	mov    (%eax),%eax
  802926:	85 c0                	test   %eax,%eax
  802928:	74 10                	je     80293a <alloc_block_NF+0x326>
  80292a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802932:	8b 52 04             	mov    0x4(%edx),%edx
  802935:	89 50 04             	mov    %edx,0x4(%eax)
  802938:	eb 0b                	jmp    802945 <alloc_block_NF+0x331>
  80293a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293d:	8b 40 04             	mov    0x4(%eax),%eax
  802940:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802945:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802948:	8b 40 04             	mov    0x4(%eax),%eax
  80294b:	85 c0                	test   %eax,%eax
  80294d:	74 0f                	je     80295e <alloc_block_NF+0x34a>
  80294f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802952:	8b 40 04             	mov    0x4(%eax),%eax
  802955:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802958:	8b 12                	mov    (%edx),%edx
  80295a:	89 10                	mov    %edx,(%eax)
  80295c:	eb 0a                	jmp    802968 <alloc_block_NF+0x354>
  80295e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802961:	8b 00                	mov    (%eax),%eax
  802963:	a3 48 41 80 00       	mov    %eax,0x804148
  802968:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802971:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802974:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297b:	a1 54 41 80 00       	mov    0x804154,%eax
  802980:	48                   	dec    %eax
  802981:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802986:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802989:	8b 40 08             	mov    0x8(%eax),%eax
  80298c:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	8b 50 08             	mov    0x8(%eax),%edx
  802997:	8b 45 08             	mov    0x8(%ebp),%eax
  80299a:	01 c2                	add    %eax,%edx
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a8:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ab:	89 c2                	mov    %eax,%edx
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b6:	e9 24 02 00 00       	jmp    802bdf <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029bb:	a1 40 41 80 00       	mov    0x804140,%eax
  8029c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c7:	74 07                	je     8029d0 <alloc_block_NF+0x3bc>
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 00                	mov    (%eax),%eax
  8029ce:	eb 05                	jmp    8029d5 <alloc_block_NF+0x3c1>
  8029d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d5:	a3 40 41 80 00       	mov    %eax,0x804140
  8029da:	a1 40 41 80 00       	mov    0x804140,%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	0f 85 2b fe ff ff    	jne    802812 <alloc_block_NF+0x1fe>
  8029e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029eb:	0f 85 21 fe ff ff    	jne    802812 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029f1:	a1 38 41 80 00       	mov    0x804138,%eax
  8029f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f9:	e9 ae 01 00 00       	jmp    802bac <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 50 08             	mov    0x8(%eax),%edx
  802a04:	a1 28 40 80 00       	mov    0x804028,%eax
  802a09:	39 c2                	cmp    %eax,%edx
  802a0b:	0f 83 93 01 00 00    	jae    802ba4 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a14:	8b 40 0c             	mov    0xc(%eax),%eax
  802a17:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a1a:	0f 82 84 01 00 00    	jb     802ba4 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 40 0c             	mov    0xc(%eax),%eax
  802a26:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a29:	0f 85 95 00 00 00    	jne    802ac4 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a33:	75 17                	jne    802a4c <alloc_block_NF+0x438>
  802a35:	83 ec 04             	sub    $0x4,%esp
  802a38:	68 c4 3f 80 00       	push   $0x803fc4
  802a3d:	68 14 01 00 00       	push   $0x114
  802a42:	68 1b 3f 80 00       	push   $0x803f1b
  802a47:	e8 36 d8 ff ff       	call   800282 <_panic>
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 00                	mov    (%eax),%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	74 10                	je     802a65 <alloc_block_NF+0x451>
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5d:	8b 52 04             	mov    0x4(%edx),%edx
  802a60:	89 50 04             	mov    %edx,0x4(%eax)
  802a63:	eb 0b                	jmp    802a70 <alloc_block_NF+0x45c>
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 40 04             	mov    0x4(%eax),%eax
  802a6b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 40 04             	mov    0x4(%eax),%eax
  802a76:	85 c0                	test   %eax,%eax
  802a78:	74 0f                	je     802a89 <alloc_block_NF+0x475>
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 40 04             	mov    0x4(%eax),%eax
  802a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a83:	8b 12                	mov    (%edx),%edx
  802a85:	89 10                	mov    %edx,(%eax)
  802a87:	eb 0a                	jmp    802a93 <alloc_block_NF+0x47f>
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa6:	a1 44 41 80 00       	mov    0x804144,%eax
  802aab:	48                   	dec    %eax
  802aac:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 40 08             	mov    0x8(%eax),%eax
  802ab7:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abf:	e9 1b 01 00 00       	jmp    802bdf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aca:	3b 45 08             	cmp    0x8(%ebp),%eax
  802acd:	0f 86 d1 00 00 00    	jbe    802ba4 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ad3:	a1 48 41 80 00       	mov    0x804148,%eax
  802ad8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 50 08             	mov    0x8(%eax),%edx
  802ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aea:	8b 55 08             	mov    0x8(%ebp),%edx
  802aed:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802af0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802af4:	75 17                	jne    802b0d <alloc_block_NF+0x4f9>
  802af6:	83 ec 04             	sub    $0x4,%esp
  802af9:	68 c4 3f 80 00       	push   $0x803fc4
  802afe:	68 1c 01 00 00       	push   $0x11c
  802b03:	68 1b 3f 80 00       	push   $0x803f1b
  802b08:	e8 75 d7 ff ff       	call   800282 <_panic>
  802b0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b10:	8b 00                	mov    (%eax),%eax
  802b12:	85 c0                	test   %eax,%eax
  802b14:	74 10                	je     802b26 <alloc_block_NF+0x512>
  802b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b19:	8b 00                	mov    (%eax),%eax
  802b1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1e:	8b 52 04             	mov    0x4(%edx),%edx
  802b21:	89 50 04             	mov    %edx,0x4(%eax)
  802b24:	eb 0b                	jmp    802b31 <alloc_block_NF+0x51d>
  802b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b29:	8b 40 04             	mov    0x4(%eax),%eax
  802b2c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b34:	8b 40 04             	mov    0x4(%eax),%eax
  802b37:	85 c0                	test   %eax,%eax
  802b39:	74 0f                	je     802b4a <alloc_block_NF+0x536>
  802b3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3e:	8b 40 04             	mov    0x4(%eax),%eax
  802b41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b44:	8b 12                	mov    (%edx),%edx
  802b46:	89 10                	mov    %edx,(%eax)
  802b48:	eb 0a                	jmp    802b54 <alloc_block_NF+0x540>
  802b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	a3 48 41 80 00       	mov    %eax,0x804148
  802b54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b67:	a1 54 41 80 00       	mov    0x804154,%eax
  802b6c:	48                   	dec    %eax
  802b6d:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b75:	8b 40 08             	mov    0x8(%eax),%eax
  802b78:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	8b 50 08             	mov    0x8(%eax),%edx
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	01 c2                	add    %eax,%edx
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	8b 40 0c             	mov    0xc(%eax),%eax
  802b94:	2b 45 08             	sub    0x8(%ebp),%eax
  802b97:	89 c2                	mov    %eax,%edx
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba2:	eb 3b                	jmp    802bdf <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ba4:	a1 40 41 80 00       	mov    0x804140,%eax
  802ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb0:	74 07                	je     802bb9 <alloc_block_NF+0x5a5>
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 00                	mov    (%eax),%eax
  802bb7:	eb 05                	jmp    802bbe <alloc_block_NF+0x5aa>
  802bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbe:	a3 40 41 80 00       	mov    %eax,0x804140
  802bc3:	a1 40 41 80 00       	mov    0x804140,%eax
  802bc8:	85 c0                	test   %eax,%eax
  802bca:	0f 85 2e fe ff ff    	jne    8029fe <alloc_block_NF+0x3ea>
  802bd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd4:	0f 85 24 fe ff ff    	jne    8029fe <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bdf:	c9                   	leave  
  802be0:	c3                   	ret    

00802be1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802be1:	55                   	push   %ebp
  802be2:	89 e5                	mov    %esp,%ebp
  802be4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802be7:	a1 38 41 80 00       	mov    0x804138,%eax
  802bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bef:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bf4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bf7:	a1 38 41 80 00       	mov    0x804138,%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 14                	je     802c14 <insert_sorted_with_merge_freeList+0x33>
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	8b 50 08             	mov    0x8(%eax),%edx
  802c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c09:	8b 40 08             	mov    0x8(%eax),%eax
  802c0c:	39 c2                	cmp    %eax,%edx
  802c0e:	0f 87 9b 01 00 00    	ja     802daf <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c18:	75 17                	jne    802c31 <insert_sorted_with_merge_freeList+0x50>
  802c1a:	83 ec 04             	sub    $0x4,%esp
  802c1d:	68 f8 3e 80 00       	push   $0x803ef8
  802c22:	68 38 01 00 00       	push   $0x138
  802c27:	68 1b 3f 80 00       	push   $0x803f1b
  802c2c:	e8 51 d6 ff ff       	call   800282 <_panic>
  802c31:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	89 10                	mov    %edx,(%eax)
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	8b 00                	mov    (%eax),%eax
  802c41:	85 c0                	test   %eax,%eax
  802c43:	74 0d                	je     802c52 <insert_sorted_with_merge_freeList+0x71>
  802c45:	a1 38 41 80 00       	mov    0x804138,%eax
  802c4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4d:	89 50 04             	mov    %edx,0x4(%eax)
  802c50:	eb 08                	jmp    802c5a <insert_sorted_with_merge_freeList+0x79>
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	a3 38 41 80 00       	mov    %eax,0x804138
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6c:	a1 44 41 80 00       	mov    0x804144,%eax
  802c71:	40                   	inc    %eax
  802c72:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c7b:	0f 84 a8 06 00 00    	je     803329 <insert_sorted_with_merge_freeList+0x748>
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	8b 50 08             	mov    0x8(%eax),%edx
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8d:	01 c2                	add    %eax,%edx
  802c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c92:	8b 40 08             	mov    0x8(%eax),%eax
  802c95:	39 c2                	cmp    %eax,%edx
  802c97:	0f 85 8c 06 00 00    	jne    803329 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca9:	01 c2                	add    %eax,%edx
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cb5:	75 17                	jne    802cce <insert_sorted_with_merge_freeList+0xed>
  802cb7:	83 ec 04             	sub    $0x4,%esp
  802cba:	68 c4 3f 80 00       	push   $0x803fc4
  802cbf:	68 3c 01 00 00       	push   $0x13c
  802cc4:	68 1b 3f 80 00       	push   $0x803f1b
  802cc9:	e8 b4 d5 ff ff       	call   800282 <_panic>
  802cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	85 c0                	test   %eax,%eax
  802cd5:	74 10                	je     802ce7 <insert_sorted_with_merge_freeList+0x106>
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cdf:	8b 52 04             	mov    0x4(%edx),%edx
  802ce2:	89 50 04             	mov    %edx,0x4(%eax)
  802ce5:	eb 0b                	jmp    802cf2 <insert_sorted_with_merge_freeList+0x111>
  802ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cea:	8b 40 04             	mov    0x4(%eax),%eax
  802ced:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf5:	8b 40 04             	mov    0x4(%eax),%eax
  802cf8:	85 c0                	test   %eax,%eax
  802cfa:	74 0f                	je     802d0b <insert_sorted_with_merge_freeList+0x12a>
  802cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cff:	8b 40 04             	mov    0x4(%eax),%eax
  802d02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d05:	8b 12                	mov    (%edx),%edx
  802d07:	89 10                	mov    %edx,(%eax)
  802d09:	eb 0a                	jmp    802d15 <insert_sorted_with_merge_freeList+0x134>
  802d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0e:	8b 00                	mov    (%eax),%eax
  802d10:	a3 38 41 80 00       	mov    %eax,0x804138
  802d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d28:	a1 44 41 80 00       	mov    0x804144,%eax
  802d2d:	48                   	dec    %eax
  802d2e:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d36:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d40:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d4b:	75 17                	jne    802d64 <insert_sorted_with_merge_freeList+0x183>
  802d4d:	83 ec 04             	sub    $0x4,%esp
  802d50:	68 f8 3e 80 00       	push   $0x803ef8
  802d55:	68 3f 01 00 00       	push   $0x13f
  802d5a:	68 1b 3f 80 00       	push   $0x803f1b
  802d5f:	e8 1e d5 ff ff       	call   800282 <_panic>
  802d64:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	89 10                	mov    %edx,(%eax)
  802d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d72:	8b 00                	mov    (%eax),%eax
  802d74:	85 c0                	test   %eax,%eax
  802d76:	74 0d                	je     802d85 <insert_sorted_with_merge_freeList+0x1a4>
  802d78:	a1 48 41 80 00       	mov    0x804148,%eax
  802d7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d80:	89 50 04             	mov    %edx,0x4(%eax)
  802d83:	eb 08                	jmp    802d8d <insert_sorted_with_merge_freeList+0x1ac>
  802d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d88:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d90:	a3 48 41 80 00       	mov    %eax,0x804148
  802d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9f:	a1 54 41 80 00       	mov    0x804154,%eax
  802da4:	40                   	inc    %eax
  802da5:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802daa:	e9 7a 05 00 00       	jmp    803329 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	8b 50 08             	mov    0x8(%eax),%edx
  802db5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db8:	8b 40 08             	mov    0x8(%eax),%eax
  802dbb:	39 c2                	cmp    %eax,%edx
  802dbd:	0f 82 14 01 00 00    	jb     802ed7 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc6:	8b 50 08             	mov    0x8(%eax),%edx
  802dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcf:	01 c2                	add    %eax,%edx
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	8b 40 08             	mov    0x8(%eax),%eax
  802dd7:	39 c2                	cmp    %eax,%edx
  802dd9:	0f 85 90 00 00 00    	jne    802e6f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de2:	8b 50 0c             	mov    0xc(%eax),%edx
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	8b 40 0c             	mov    0xc(%eax),%eax
  802deb:	01 c2                	add    %eax,%edx
  802ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e0b:	75 17                	jne    802e24 <insert_sorted_with_merge_freeList+0x243>
  802e0d:	83 ec 04             	sub    $0x4,%esp
  802e10:	68 f8 3e 80 00       	push   $0x803ef8
  802e15:	68 49 01 00 00       	push   $0x149
  802e1a:	68 1b 3f 80 00       	push   $0x803f1b
  802e1f:	e8 5e d4 ff ff       	call   800282 <_panic>
  802e24:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	89 10                	mov    %edx,(%eax)
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	8b 00                	mov    (%eax),%eax
  802e34:	85 c0                	test   %eax,%eax
  802e36:	74 0d                	je     802e45 <insert_sorted_with_merge_freeList+0x264>
  802e38:	a1 48 41 80 00       	mov    0x804148,%eax
  802e3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e40:	89 50 04             	mov    %edx,0x4(%eax)
  802e43:	eb 08                	jmp    802e4d <insert_sorted_with_merge_freeList+0x26c>
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	a3 48 41 80 00       	mov    %eax,0x804148
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5f:	a1 54 41 80 00       	mov    0x804154,%eax
  802e64:	40                   	inc    %eax
  802e65:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e6a:	e9 bb 04 00 00       	jmp    80332a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e73:	75 17                	jne    802e8c <insert_sorted_with_merge_freeList+0x2ab>
  802e75:	83 ec 04             	sub    $0x4,%esp
  802e78:	68 6c 3f 80 00       	push   $0x803f6c
  802e7d:	68 4c 01 00 00       	push   $0x14c
  802e82:	68 1b 3f 80 00       	push   $0x803f1b
  802e87:	e8 f6 d3 ff ff       	call   800282 <_panic>
  802e8c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	89 50 04             	mov    %edx,0x4(%eax)
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 40 04             	mov    0x4(%eax),%eax
  802e9e:	85 c0                	test   %eax,%eax
  802ea0:	74 0c                	je     802eae <insert_sorted_with_merge_freeList+0x2cd>
  802ea2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  802eaa:	89 10                	mov    %edx,(%eax)
  802eac:	eb 08                	jmp    802eb6 <insert_sorted_with_merge_freeList+0x2d5>
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	a3 38 41 80 00       	mov    %eax,0x804138
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec7:	a1 44 41 80 00       	mov    0x804144,%eax
  802ecc:	40                   	inc    %eax
  802ecd:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ed2:	e9 53 04 00 00       	jmp    80332a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ed7:	a1 38 41 80 00       	mov    0x804138,%eax
  802edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802edf:	e9 15 04 00 00       	jmp    8032f9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 00                	mov    (%eax),%eax
  802ee9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	8b 50 08             	mov    0x8(%eax),%edx
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 08             	mov    0x8(%eax),%eax
  802ef8:	39 c2                	cmp    %eax,%edx
  802efa:	0f 86 f1 03 00 00    	jbe    8032f1 <insert_sorted_with_merge_freeList+0x710>
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	8b 50 08             	mov    0x8(%eax),%edx
  802f06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f09:	8b 40 08             	mov    0x8(%eax),%eax
  802f0c:	39 c2                	cmp    %eax,%edx
  802f0e:	0f 83 dd 03 00 00    	jae    8032f1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 50 08             	mov    0x8(%eax),%edx
  802f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f20:	01 c2                	add    %eax,%edx
  802f22:	8b 45 08             	mov    0x8(%ebp),%eax
  802f25:	8b 40 08             	mov    0x8(%eax),%eax
  802f28:	39 c2                	cmp    %eax,%edx
  802f2a:	0f 85 b9 01 00 00    	jne    8030e9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	8b 50 08             	mov    0x8(%eax),%edx
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3c:	01 c2                	add    %eax,%edx
  802f3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f41:	8b 40 08             	mov    0x8(%eax),%eax
  802f44:	39 c2                	cmp    %eax,%edx
  802f46:	0f 85 0d 01 00 00    	jne    803059 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f55:	8b 40 0c             	mov    0xc(%eax),%eax
  802f58:	01 c2                	add    %eax,%edx
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f60:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f64:	75 17                	jne    802f7d <insert_sorted_with_merge_freeList+0x39c>
  802f66:	83 ec 04             	sub    $0x4,%esp
  802f69:	68 c4 3f 80 00       	push   $0x803fc4
  802f6e:	68 5c 01 00 00       	push   $0x15c
  802f73:	68 1b 3f 80 00       	push   $0x803f1b
  802f78:	e8 05 d3 ff ff       	call   800282 <_panic>
  802f7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	85 c0                	test   %eax,%eax
  802f84:	74 10                	je     802f96 <insert_sorted_with_merge_freeList+0x3b5>
  802f86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f89:	8b 00                	mov    (%eax),%eax
  802f8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f8e:	8b 52 04             	mov    0x4(%edx),%edx
  802f91:	89 50 04             	mov    %edx,0x4(%eax)
  802f94:	eb 0b                	jmp    802fa1 <insert_sorted_with_merge_freeList+0x3c0>
  802f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f99:	8b 40 04             	mov    0x4(%eax),%eax
  802f9c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa4:	8b 40 04             	mov    0x4(%eax),%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	74 0f                	je     802fba <insert_sorted_with_merge_freeList+0x3d9>
  802fab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fae:	8b 40 04             	mov    0x4(%eax),%eax
  802fb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb4:	8b 12                	mov    (%edx),%edx
  802fb6:	89 10                	mov    %edx,(%eax)
  802fb8:	eb 0a                	jmp    802fc4 <insert_sorted_with_merge_freeList+0x3e3>
  802fba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	a3 38 41 80 00       	mov    %eax,0x804138
  802fc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd7:	a1 44 41 80 00       	mov    0x804144,%eax
  802fdc:	48                   	dec    %eax
  802fdd:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802ff6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ffa:	75 17                	jne    803013 <insert_sorted_with_merge_freeList+0x432>
  802ffc:	83 ec 04             	sub    $0x4,%esp
  802fff:	68 f8 3e 80 00       	push   $0x803ef8
  803004:	68 5f 01 00 00       	push   $0x15f
  803009:	68 1b 3f 80 00       	push   $0x803f1b
  80300e:	e8 6f d2 ff ff       	call   800282 <_panic>
  803013:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301c:	89 10                	mov    %edx,(%eax)
  80301e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	85 c0                	test   %eax,%eax
  803025:	74 0d                	je     803034 <insert_sorted_with_merge_freeList+0x453>
  803027:	a1 48 41 80 00       	mov    0x804148,%eax
  80302c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80302f:	89 50 04             	mov    %edx,0x4(%eax)
  803032:	eb 08                	jmp    80303c <insert_sorted_with_merge_freeList+0x45b>
  803034:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803037:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80303c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303f:	a3 48 41 80 00       	mov    %eax,0x804148
  803044:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803047:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304e:	a1 54 41 80 00       	mov    0x804154,%eax
  803053:	40                   	inc    %eax
  803054:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	8b 50 0c             	mov    0xc(%eax),%edx
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	8b 40 0c             	mov    0xc(%eax),%eax
  803065:	01 c2                	add    %eax,%edx
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803081:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803085:	75 17                	jne    80309e <insert_sorted_with_merge_freeList+0x4bd>
  803087:	83 ec 04             	sub    $0x4,%esp
  80308a:	68 f8 3e 80 00       	push   $0x803ef8
  80308f:	68 64 01 00 00       	push   $0x164
  803094:	68 1b 3f 80 00       	push   $0x803f1b
  803099:	e8 e4 d1 ff ff       	call   800282 <_panic>
  80309e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	89 10                	mov    %edx,(%eax)
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	8b 00                	mov    (%eax),%eax
  8030ae:	85 c0                	test   %eax,%eax
  8030b0:	74 0d                	je     8030bf <insert_sorted_with_merge_freeList+0x4de>
  8030b2:	a1 48 41 80 00       	mov    0x804148,%eax
  8030b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ba:	89 50 04             	mov    %edx,0x4(%eax)
  8030bd:	eb 08                	jmp    8030c7 <insert_sorted_with_merge_freeList+0x4e6>
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	a3 48 41 80 00       	mov    %eax,0x804148
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d9:	a1 54 41 80 00       	mov    0x804154,%eax
  8030de:	40                   	inc    %eax
  8030df:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030e4:	e9 41 02 00 00       	jmp    80332a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	8b 50 08             	mov    0x8(%eax),%edx
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f5:	01 c2                	add    %eax,%edx
  8030f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fa:	8b 40 08             	mov    0x8(%eax),%eax
  8030fd:	39 c2                	cmp    %eax,%edx
  8030ff:	0f 85 7c 01 00 00    	jne    803281 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803105:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803109:	74 06                	je     803111 <insert_sorted_with_merge_freeList+0x530>
  80310b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310f:	75 17                	jne    803128 <insert_sorted_with_merge_freeList+0x547>
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	68 34 3f 80 00       	push   $0x803f34
  803119:	68 69 01 00 00       	push   $0x169
  80311e:	68 1b 3f 80 00       	push   $0x803f1b
  803123:	e8 5a d1 ff ff       	call   800282 <_panic>
  803128:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312b:	8b 50 04             	mov    0x4(%eax),%edx
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	89 50 04             	mov    %edx,0x4(%eax)
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80313a:	89 10                	mov    %edx,(%eax)
  80313c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313f:	8b 40 04             	mov    0x4(%eax),%eax
  803142:	85 c0                	test   %eax,%eax
  803144:	74 0d                	je     803153 <insert_sorted_with_merge_freeList+0x572>
  803146:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803149:	8b 40 04             	mov    0x4(%eax),%eax
  80314c:	8b 55 08             	mov    0x8(%ebp),%edx
  80314f:	89 10                	mov    %edx,(%eax)
  803151:	eb 08                	jmp    80315b <insert_sorted_with_merge_freeList+0x57a>
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	a3 38 41 80 00       	mov    %eax,0x804138
  80315b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315e:	8b 55 08             	mov    0x8(%ebp),%edx
  803161:	89 50 04             	mov    %edx,0x4(%eax)
  803164:	a1 44 41 80 00       	mov    0x804144,%eax
  803169:	40                   	inc    %eax
  80316a:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	8b 50 0c             	mov    0xc(%eax),%edx
  803175:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803178:	8b 40 0c             	mov    0xc(%eax),%eax
  80317b:	01 c2                	add    %eax,%edx
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803183:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803187:	75 17                	jne    8031a0 <insert_sorted_with_merge_freeList+0x5bf>
  803189:	83 ec 04             	sub    $0x4,%esp
  80318c:	68 c4 3f 80 00       	push   $0x803fc4
  803191:	68 6b 01 00 00       	push   $0x16b
  803196:	68 1b 3f 80 00       	push   $0x803f1b
  80319b:	e8 e2 d0 ff ff       	call   800282 <_panic>
  8031a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a3:	8b 00                	mov    (%eax),%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	74 10                	je     8031b9 <insert_sorted_with_merge_freeList+0x5d8>
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b1:	8b 52 04             	mov    0x4(%edx),%edx
  8031b4:	89 50 04             	mov    %edx,0x4(%eax)
  8031b7:	eb 0b                	jmp    8031c4 <insert_sorted_with_merge_freeList+0x5e3>
  8031b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bc:	8b 40 04             	mov    0x4(%eax),%eax
  8031bf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ca:	85 c0                	test   %eax,%eax
  8031cc:	74 0f                	je     8031dd <insert_sorted_with_merge_freeList+0x5fc>
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	8b 40 04             	mov    0x4(%eax),%eax
  8031d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d7:	8b 12                	mov    (%edx),%edx
  8031d9:	89 10                	mov    %edx,(%eax)
  8031db:	eb 0a                	jmp    8031e7 <insert_sorted_with_merge_freeList+0x606>
  8031dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	a3 38 41 80 00       	mov    %eax,0x804138
  8031e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fa:	a1 44 41 80 00       	mov    0x804144,%eax
  8031ff:	48                   	dec    %eax
  803200:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803208:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80320f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803212:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803219:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80321d:	75 17                	jne    803236 <insert_sorted_with_merge_freeList+0x655>
  80321f:	83 ec 04             	sub    $0x4,%esp
  803222:	68 f8 3e 80 00       	push   $0x803ef8
  803227:	68 6e 01 00 00       	push   $0x16e
  80322c:	68 1b 3f 80 00       	push   $0x803f1b
  803231:	e8 4c d0 ff ff       	call   800282 <_panic>
  803236:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	89 10                	mov    %edx,(%eax)
  803241:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	85 c0                	test   %eax,%eax
  803248:	74 0d                	je     803257 <insert_sorted_with_merge_freeList+0x676>
  80324a:	a1 48 41 80 00       	mov    0x804148,%eax
  80324f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803252:	89 50 04             	mov    %edx,0x4(%eax)
  803255:	eb 08                	jmp    80325f <insert_sorted_with_merge_freeList+0x67e>
  803257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80325f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803262:	a3 48 41 80 00       	mov    %eax,0x804148
  803267:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803271:	a1 54 41 80 00       	mov    0x804154,%eax
  803276:	40                   	inc    %eax
  803277:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80327c:	e9 a9 00 00 00       	jmp    80332a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803285:	74 06                	je     80328d <insert_sorted_with_merge_freeList+0x6ac>
  803287:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328b:	75 17                	jne    8032a4 <insert_sorted_with_merge_freeList+0x6c3>
  80328d:	83 ec 04             	sub    $0x4,%esp
  803290:	68 90 3f 80 00       	push   $0x803f90
  803295:	68 73 01 00 00       	push   $0x173
  80329a:	68 1b 3f 80 00       	push   $0x803f1b
  80329f:	e8 de cf ff ff       	call   800282 <_panic>
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	8b 10                	mov    (%eax),%edx
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	89 10                	mov    %edx,(%eax)
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	8b 00                	mov    (%eax),%eax
  8032b3:	85 c0                	test   %eax,%eax
  8032b5:	74 0b                	je     8032c2 <insert_sorted_with_merge_freeList+0x6e1>
  8032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ba:	8b 00                	mov    (%eax),%eax
  8032bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bf:	89 50 04             	mov    %edx,0x4(%eax)
  8032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c8:	89 10                	mov    %edx,(%eax)
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d0:	89 50 04             	mov    %edx,0x4(%eax)
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	8b 00                	mov    (%eax),%eax
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	75 08                	jne    8032e4 <insert_sorted_with_merge_freeList+0x703>
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032e4:	a1 44 41 80 00       	mov    0x804144,%eax
  8032e9:	40                   	inc    %eax
  8032ea:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032ef:	eb 39                	jmp    80332a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032f1:	a1 40 41 80 00       	mov    0x804140,%eax
  8032f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fd:	74 07                	je     803306 <insert_sorted_with_merge_freeList+0x725>
  8032ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803302:	8b 00                	mov    (%eax),%eax
  803304:	eb 05                	jmp    80330b <insert_sorted_with_merge_freeList+0x72a>
  803306:	b8 00 00 00 00       	mov    $0x0,%eax
  80330b:	a3 40 41 80 00       	mov    %eax,0x804140
  803310:	a1 40 41 80 00       	mov    0x804140,%eax
  803315:	85 c0                	test   %eax,%eax
  803317:	0f 85 c7 fb ff ff    	jne    802ee4 <insert_sorted_with_merge_freeList+0x303>
  80331d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803321:	0f 85 bd fb ff ff    	jne    802ee4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803327:	eb 01                	jmp    80332a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803329:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80332a:	90                   	nop
  80332b:	c9                   	leave  
  80332c:	c3                   	ret    
  80332d:	66 90                	xchg   %ax,%ax
  80332f:	90                   	nop

00803330 <__udivdi3>:
  803330:	55                   	push   %ebp
  803331:	57                   	push   %edi
  803332:	56                   	push   %esi
  803333:	53                   	push   %ebx
  803334:	83 ec 1c             	sub    $0x1c,%esp
  803337:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80333b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80333f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803343:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803347:	89 ca                	mov    %ecx,%edx
  803349:	89 f8                	mov    %edi,%eax
  80334b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80334f:	85 f6                	test   %esi,%esi
  803351:	75 2d                	jne    803380 <__udivdi3+0x50>
  803353:	39 cf                	cmp    %ecx,%edi
  803355:	77 65                	ja     8033bc <__udivdi3+0x8c>
  803357:	89 fd                	mov    %edi,%ebp
  803359:	85 ff                	test   %edi,%edi
  80335b:	75 0b                	jne    803368 <__udivdi3+0x38>
  80335d:	b8 01 00 00 00       	mov    $0x1,%eax
  803362:	31 d2                	xor    %edx,%edx
  803364:	f7 f7                	div    %edi
  803366:	89 c5                	mov    %eax,%ebp
  803368:	31 d2                	xor    %edx,%edx
  80336a:	89 c8                	mov    %ecx,%eax
  80336c:	f7 f5                	div    %ebp
  80336e:	89 c1                	mov    %eax,%ecx
  803370:	89 d8                	mov    %ebx,%eax
  803372:	f7 f5                	div    %ebp
  803374:	89 cf                	mov    %ecx,%edi
  803376:	89 fa                	mov    %edi,%edx
  803378:	83 c4 1c             	add    $0x1c,%esp
  80337b:	5b                   	pop    %ebx
  80337c:	5e                   	pop    %esi
  80337d:	5f                   	pop    %edi
  80337e:	5d                   	pop    %ebp
  80337f:	c3                   	ret    
  803380:	39 ce                	cmp    %ecx,%esi
  803382:	77 28                	ja     8033ac <__udivdi3+0x7c>
  803384:	0f bd fe             	bsr    %esi,%edi
  803387:	83 f7 1f             	xor    $0x1f,%edi
  80338a:	75 40                	jne    8033cc <__udivdi3+0x9c>
  80338c:	39 ce                	cmp    %ecx,%esi
  80338e:	72 0a                	jb     80339a <__udivdi3+0x6a>
  803390:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803394:	0f 87 9e 00 00 00    	ja     803438 <__udivdi3+0x108>
  80339a:	b8 01 00 00 00       	mov    $0x1,%eax
  80339f:	89 fa                	mov    %edi,%edx
  8033a1:	83 c4 1c             	add    $0x1c,%esp
  8033a4:	5b                   	pop    %ebx
  8033a5:	5e                   	pop    %esi
  8033a6:	5f                   	pop    %edi
  8033a7:	5d                   	pop    %ebp
  8033a8:	c3                   	ret    
  8033a9:	8d 76 00             	lea    0x0(%esi),%esi
  8033ac:	31 ff                	xor    %edi,%edi
  8033ae:	31 c0                	xor    %eax,%eax
  8033b0:	89 fa                	mov    %edi,%edx
  8033b2:	83 c4 1c             	add    $0x1c,%esp
  8033b5:	5b                   	pop    %ebx
  8033b6:	5e                   	pop    %esi
  8033b7:	5f                   	pop    %edi
  8033b8:	5d                   	pop    %ebp
  8033b9:	c3                   	ret    
  8033ba:	66 90                	xchg   %ax,%ax
  8033bc:	89 d8                	mov    %ebx,%eax
  8033be:	f7 f7                	div    %edi
  8033c0:	31 ff                	xor    %edi,%edi
  8033c2:	89 fa                	mov    %edi,%edx
  8033c4:	83 c4 1c             	add    $0x1c,%esp
  8033c7:	5b                   	pop    %ebx
  8033c8:	5e                   	pop    %esi
  8033c9:	5f                   	pop    %edi
  8033ca:	5d                   	pop    %ebp
  8033cb:	c3                   	ret    
  8033cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033d1:	89 eb                	mov    %ebp,%ebx
  8033d3:	29 fb                	sub    %edi,%ebx
  8033d5:	89 f9                	mov    %edi,%ecx
  8033d7:	d3 e6                	shl    %cl,%esi
  8033d9:	89 c5                	mov    %eax,%ebp
  8033db:	88 d9                	mov    %bl,%cl
  8033dd:	d3 ed                	shr    %cl,%ebp
  8033df:	89 e9                	mov    %ebp,%ecx
  8033e1:	09 f1                	or     %esi,%ecx
  8033e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033e7:	89 f9                	mov    %edi,%ecx
  8033e9:	d3 e0                	shl    %cl,%eax
  8033eb:	89 c5                	mov    %eax,%ebp
  8033ed:	89 d6                	mov    %edx,%esi
  8033ef:	88 d9                	mov    %bl,%cl
  8033f1:	d3 ee                	shr    %cl,%esi
  8033f3:	89 f9                	mov    %edi,%ecx
  8033f5:	d3 e2                	shl    %cl,%edx
  8033f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033fb:	88 d9                	mov    %bl,%cl
  8033fd:	d3 e8                	shr    %cl,%eax
  8033ff:	09 c2                	or     %eax,%edx
  803401:	89 d0                	mov    %edx,%eax
  803403:	89 f2                	mov    %esi,%edx
  803405:	f7 74 24 0c          	divl   0xc(%esp)
  803409:	89 d6                	mov    %edx,%esi
  80340b:	89 c3                	mov    %eax,%ebx
  80340d:	f7 e5                	mul    %ebp
  80340f:	39 d6                	cmp    %edx,%esi
  803411:	72 19                	jb     80342c <__udivdi3+0xfc>
  803413:	74 0b                	je     803420 <__udivdi3+0xf0>
  803415:	89 d8                	mov    %ebx,%eax
  803417:	31 ff                	xor    %edi,%edi
  803419:	e9 58 ff ff ff       	jmp    803376 <__udivdi3+0x46>
  80341e:	66 90                	xchg   %ax,%ax
  803420:	8b 54 24 08          	mov    0x8(%esp),%edx
  803424:	89 f9                	mov    %edi,%ecx
  803426:	d3 e2                	shl    %cl,%edx
  803428:	39 c2                	cmp    %eax,%edx
  80342a:	73 e9                	jae    803415 <__udivdi3+0xe5>
  80342c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80342f:	31 ff                	xor    %edi,%edi
  803431:	e9 40 ff ff ff       	jmp    803376 <__udivdi3+0x46>
  803436:	66 90                	xchg   %ax,%ax
  803438:	31 c0                	xor    %eax,%eax
  80343a:	e9 37 ff ff ff       	jmp    803376 <__udivdi3+0x46>
  80343f:	90                   	nop

00803440 <__umoddi3>:
  803440:	55                   	push   %ebp
  803441:	57                   	push   %edi
  803442:	56                   	push   %esi
  803443:	53                   	push   %ebx
  803444:	83 ec 1c             	sub    $0x1c,%esp
  803447:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80344b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80344f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803453:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803457:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80345b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80345f:	89 f3                	mov    %esi,%ebx
  803461:	89 fa                	mov    %edi,%edx
  803463:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803467:	89 34 24             	mov    %esi,(%esp)
  80346a:	85 c0                	test   %eax,%eax
  80346c:	75 1a                	jne    803488 <__umoddi3+0x48>
  80346e:	39 f7                	cmp    %esi,%edi
  803470:	0f 86 a2 00 00 00    	jbe    803518 <__umoddi3+0xd8>
  803476:	89 c8                	mov    %ecx,%eax
  803478:	89 f2                	mov    %esi,%edx
  80347a:	f7 f7                	div    %edi
  80347c:	89 d0                	mov    %edx,%eax
  80347e:	31 d2                	xor    %edx,%edx
  803480:	83 c4 1c             	add    $0x1c,%esp
  803483:	5b                   	pop    %ebx
  803484:	5e                   	pop    %esi
  803485:	5f                   	pop    %edi
  803486:	5d                   	pop    %ebp
  803487:	c3                   	ret    
  803488:	39 f0                	cmp    %esi,%eax
  80348a:	0f 87 ac 00 00 00    	ja     80353c <__umoddi3+0xfc>
  803490:	0f bd e8             	bsr    %eax,%ebp
  803493:	83 f5 1f             	xor    $0x1f,%ebp
  803496:	0f 84 ac 00 00 00    	je     803548 <__umoddi3+0x108>
  80349c:	bf 20 00 00 00       	mov    $0x20,%edi
  8034a1:	29 ef                	sub    %ebp,%edi
  8034a3:	89 fe                	mov    %edi,%esi
  8034a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034a9:	89 e9                	mov    %ebp,%ecx
  8034ab:	d3 e0                	shl    %cl,%eax
  8034ad:	89 d7                	mov    %edx,%edi
  8034af:	89 f1                	mov    %esi,%ecx
  8034b1:	d3 ef                	shr    %cl,%edi
  8034b3:	09 c7                	or     %eax,%edi
  8034b5:	89 e9                	mov    %ebp,%ecx
  8034b7:	d3 e2                	shl    %cl,%edx
  8034b9:	89 14 24             	mov    %edx,(%esp)
  8034bc:	89 d8                	mov    %ebx,%eax
  8034be:	d3 e0                	shl    %cl,%eax
  8034c0:	89 c2                	mov    %eax,%edx
  8034c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034c6:	d3 e0                	shl    %cl,%eax
  8034c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034d0:	89 f1                	mov    %esi,%ecx
  8034d2:	d3 e8                	shr    %cl,%eax
  8034d4:	09 d0                	or     %edx,%eax
  8034d6:	d3 eb                	shr    %cl,%ebx
  8034d8:	89 da                	mov    %ebx,%edx
  8034da:	f7 f7                	div    %edi
  8034dc:	89 d3                	mov    %edx,%ebx
  8034de:	f7 24 24             	mull   (%esp)
  8034e1:	89 c6                	mov    %eax,%esi
  8034e3:	89 d1                	mov    %edx,%ecx
  8034e5:	39 d3                	cmp    %edx,%ebx
  8034e7:	0f 82 87 00 00 00    	jb     803574 <__umoddi3+0x134>
  8034ed:	0f 84 91 00 00 00    	je     803584 <__umoddi3+0x144>
  8034f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034f7:	29 f2                	sub    %esi,%edx
  8034f9:	19 cb                	sbb    %ecx,%ebx
  8034fb:	89 d8                	mov    %ebx,%eax
  8034fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803501:	d3 e0                	shl    %cl,%eax
  803503:	89 e9                	mov    %ebp,%ecx
  803505:	d3 ea                	shr    %cl,%edx
  803507:	09 d0                	or     %edx,%eax
  803509:	89 e9                	mov    %ebp,%ecx
  80350b:	d3 eb                	shr    %cl,%ebx
  80350d:	89 da                	mov    %ebx,%edx
  80350f:	83 c4 1c             	add    $0x1c,%esp
  803512:	5b                   	pop    %ebx
  803513:	5e                   	pop    %esi
  803514:	5f                   	pop    %edi
  803515:	5d                   	pop    %ebp
  803516:	c3                   	ret    
  803517:	90                   	nop
  803518:	89 fd                	mov    %edi,%ebp
  80351a:	85 ff                	test   %edi,%edi
  80351c:	75 0b                	jne    803529 <__umoddi3+0xe9>
  80351e:	b8 01 00 00 00       	mov    $0x1,%eax
  803523:	31 d2                	xor    %edx,%edx
  803525:	f7 f7                	div    %edi
  803527:	89 c5                	mov    %eax,%ebp
  803529:	89 f0                	mov    %esi,%eax
  80352b:	31 d2                	xor    %edx,%edx
  80352d:	f7 f5                	div    %ebp
  80352f:	89 c8                	mov    %ecx,%eax
  803531:	f7 f5                	div    %ebp
  803533:	89 d0                	mov    %edx,%eax
  803535:	e9 44 ff ff ff       	jmp    80347e <__umoddi3+0x3e>
  80353a:	66 90                	xchg   %ax,%ax
  80353c:	89 c8                	mov    %ecx,%eax
  80353e:	89 f2                	mov    %esi,%edx
  803540:	83 c4 1c             	add    $0x1c,%esp
  803543:	5b                   	pop    %ebx
  803544:	5e                   	pop    %esi
  803545:	5f                   	pop    %edi
  803546:	5d                   	pop    %ebp
  803547:	c3                   	ret    
  803548:	3b 04 24             	cmp    (%esp),%eax
  80354b:	72 06                	jb     803553 <__umoddi3+0x113>
  80354d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803551:	77 0f                	ja     803562 <__umoddi3+0x122>
  803553:	89 f2                	mov    %esi,%edx
  803555:	29 f9                	sub    %edi,%ecx
  803557:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80355b:	89 14 24             	mov    %edx,(%esp)
  80355e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803562:	8b 44 24 04          	mov    0x4(%esp),%eax
  803566:	8b 14 24             	mov    (%esp),%edx
  803569:	83 c4 1c             	add    $0x1c,%esp
  80356c:	5b                   	pop    %ebx
  80356d:	5e                   	pop    %esi
  80356e:	5f                   	pop    %edi
  80356f:	5d                   	pop    %ebp
  803570:	c3                   	ret    
  803571:	8d 76 00             	lea    0x0(%esi),%esi
  803574:	2b 04 24             	sub    (%esp),%eax
  803577:	19 fa                	sbb    %edi,%edx
  803579:	89 d1                	mov    %edx,%ecx
  80357b:	89 c6                	mov    %eax,%esi
  80357d:	e9 71 ff ff ff       	jmp    8034f3 <__umoddi3+0xb3>
  803582:	66 90                	xchg   %ax,%ax
  803584:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803588:	72 ea                	jb     803574 <__umoddi3+0x134>
  80358a:	89 d9                	mov    %ebx,%ecx
  80358c:	e9 62 ff ff ff       	jmp    8034f3 <__umoddi3+0xb3>
