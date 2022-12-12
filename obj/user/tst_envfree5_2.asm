
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 4b 01 00 00       	call   800181 <libmain>
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
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 60 36 80 00       	push   $0x803660
  80004a:	e8 f2 14 00 00       	call   801541 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 1e 17 00 00       	call   801781 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 b6 17 00 00       	call   801821 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 70 36 80 00       	push   $0x803670
  800079:	e8 f3 04 00 00       	call   800571 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 a3 36 80 00       	push   $0x8036a3
  80008f:	e8 5f 19 00 00       	call   8019f3 <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 ac 36 80 00       	push   $0x8036ac
  8000a8:	e8 46 19 00 00       	call   8019f3 <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 53 19 00 00       	call   801a11 <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 75 32 00 00       	call   803343 <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 35 19 00 00       	call   801a11 <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 92 16 00 00       	call   801781 <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 b8 36 80 00       	push   $0x8036b8
  8000f8:	e8 74 04 00 00       	call   800571 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 22 19 00 00       	call   801a2d <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 14 19 00 00       	call   801a2d <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 60 16 00 00       	call   801781 <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 f8 16 00 00       	call   801821 <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 ec 36 80 00       	push   $0x8036ec
  80013f:	e8 2d 04 00 00       	call   800571 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 3c 37 80 00       	push   $0x80373c
  80014f:	6a 23                	push   $0x23
  800151:	68 72 37 80 00       	push   $0x803772
  800156:	e8 62 01 00 00       	call   8002bd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 88 37 80 00       	push   $0x803788
  800166:	e8 06 04 00 00       	call   800571 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 e8 37 80 00       	push   $0x8037e8
  800176:	e8 f6 03 00 00       	call   800571 <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
	return;
  80017e:	90                   	nop
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800187:	e8 d5 18 00 00       	call   801a61 <sys_getenvindex>
  80018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80018f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	c1 e0 03             	shl    $0x3,%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001a4:	01 d0                	add    %edx,%eax
  8001a6:	c1 e0 04             	shl    $0x4,%eax
  8001a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ae:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b3:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b8:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001be:	84 c0                	test   %al,%al
  8001c0:	74 0f                	je     8001d1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c7:	05 5c 05 00 00       	add    $0x55c,%eax
  8001cc:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d5:	7e 0a                	jle    8001e1 <libmain+0x60>
		binaryname = argv[0];
  8001d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001da:	8b 00                	mov    (%eax),%eax
  8001dc:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	e8 49 fe ff ff       	call   800038 <_main>
  8001ef:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001f2:	e8 77 16 00 00       	call   80186e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 4c 38 80 00       	push   $0x80384c
  8001ff:	e8 6d 03 00 00       	call   800571 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800207:	a1 20 50 80 00       	mov    0x805020,%eax
  80020c:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800212:	a1 20 50 80 00       	mov    0x805020,%eax
  800217:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	68 74 38 80 00       	push   $0x803874
  800227:	e8 45 03 00 00       	call   800571 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022f:	a1 20 50 80 00       	mov    0x805020,%eax
  800234:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80023a:	a1 20 50 80 00       	mov    0x805020,%eax
  80023f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800245:	a1 20 50 80 00       	mov    0x805020,%eax
  80024a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800250:	51                   	push   %ecx
  800251:	52                   	push   %edx
  800252:	50                   	push   %eax
  800253:	68 9c 38 80 00       	push   $0x80389c
  800258:	e8 14 03 00 00       	call   800571 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 f4 38 80 00       	push   $0x8038f4
  800274:	e8 f8 02 00 00       	call   800571 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 4c 38 80 00       	push   $0x80384c
  800284:	e8 e8 02 00 00       	call   800571 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80028c:	e8 f7 15 00 00       	call   801888 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800291:	e8 19 00 00 00       	call   8002af <exit>
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	6a 00                	push   $0x0
  8002a4:	e8 84 17 00 00       	call   801a2d <sys_destroy_env>
  8002a9:	83 c4 10             	add    $0x10,%esp
}
  8002ac:	90                   	nop
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <exit>:

void
exit(void)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b5:	e8 d9 17 00 00       	call   801a93 <sys_exit_env>
}
  8002ba:	90                   	nop
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8002c6:	83 c0 04             	add    $0x4,%eax
  8002c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002cc:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002d1:	85 c0                	test   %eax,%eax
  8002d3:	74 16                	je     8002eb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002d5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	50                   	push   %eax
  8002de:	68 08 39 80 00       	push   $0x803908
  8002e3:	e8 89 02 00 00       	call   800571 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002eb:	a1 00 50 80 00       	mov    0x805000,%eax
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	68 0d 39 80 00       	push   $0x80390d
  8002fc:	e8 70 02 00 00       	call   800571 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800304:	8b 45 10             	mov    0x10(%ebp),%eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 f4             	pushl  -0xc(%ebp)
  80030d:	50                   	push   %eax
  80030e:	e8 f3 01 00 00       	call   800506 <vcprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 29 39 80 00       	push   $0x803929
  800320:	e8 e1 01 00 00       	call   800506 <vcprintf>
  800325:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800328:	e8 82 ff ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  80032d:	eb fe                	jmp    80032d <_panic+0x70>

0080032f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800335:	a1 20 50 80 00       	mov    0x805020,%eax
  80033a:	8b 50 74             	mov    0x74(%eax),%edx
  80033d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800340:	39 c2                	cmp    %eax,%edx
  800342:	74 14                	je     800358 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	68 2c 39 80 00       	push   $0x80392c
  80034c:	6a 26                	push   $0x26
  80034e:	68 78 39 80 00       	push   $0x803978
  800353:	e8 65 ff ff ff       	call   8002bd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80035f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800366:	e9 c2 00 00 00       	jmp    80042d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80036b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	01 d0                	add    %edx,%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	75 08                	jne    800388 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800380:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800383:	e9 a2 00 00 00       	jmp    80042a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800388:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800396:	eb 69                	jmp    800401 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800398:	a1 20 50 80 00       	mov    0x805020,%eax
  80039d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a6:	89 d0                	mov    %edx,%eax
  8003a8:	01 c0                	add    %eax,%eax
  8003aa:	01 d0                	add    %edx,%eax
  8003ac:	c1 e0 03             	shl    $0x3,%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8a 40 04             	mov    0x4(%eax),%al
  8003b4:	84 c0                	test   %al,%al
  8003b6:	75 46                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8003bd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c6:	89 d0                	mov    %edx,%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	c1 e0 03             	shl    $0x3,%eax
  8003cf:	01 c8                	add    %ecx,%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003de:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	01 c8                	add    %ecx,%eax
  8003ef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f1:	39 c2                	cmp    %eax,%edx
  8003f3:	75 09                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003f5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003fc:	eb 12                	jmp    800410 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fe:	ff 45 e8             	incl   -0x18(%ebp)
  800401:	a1 20 50 80 00       	mov    0x805020,%eax
  800406:	8b 50 74             	mov    0x74(%eax),%edx
  800409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	77 88                	ja     800398 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800414:	75 14                	jne    80042a <CheckWSWithoutLastIndex+0xfb>
			panic(
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 84 39 80 00       	push   $0x803984
  80041e:	6a 3a                	push   $0x3a
  800420:	68 78 39 80 00       	push   $0x803978
  800425:	e8 93 fe ff ff       	call   8002bd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80042a:	ff 45 f0             	incl   -0x10(%ebp)
  80042d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800430:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800433:	0f 8c 32 ff ff ff    	jl     80036b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800439:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800440:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800447:	eb 26                	jmp    80046f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800449:	a1 20 50 80 00       	mov    0x805020,%eax
  80044e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800454:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	c1 e0 03             	shl    $0x3,%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8a 40 04             	mov    0x4(%eax),%al
  800465:	3c 01                	cmp    $0x1,%al
  800467:	75 03                	jne    80046c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800469:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	ff 45 e0             	incl   -0x20(%ebp)
  80046f:	a1 20 50 80 00       	mov    0x805020,%eax
  800474:	8b 50 74             	mov    0x74(%eax),%edx
  800477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047a:	39 c2                	cmp    %eax,%edx
  80047c:	77 cb                	ja     800449 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80047e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800481:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800484:	74 14                	je     80049a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 d8 39 80 00       	push   $0x8039d8
  80048e:	6a 44                	push   $0x44
  800490:	68 78 39 80 00       	push   $0x803978
  800495:	e8 23 fe ff ff       	call   8002bd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ae:	89 0a                	mov    %ecx,(%edx)
  8004b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b3:	88 d1                	mov    %dl,%cl
  8004b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c6:	75 2c                	jne    8004f4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c8:	a0 24 50 80 00       	mov    0x805024,%al
  8004cd:	0f b6 c0             	movzbl %al,%eax
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	8b 12                	mov    (%edx),%edx
  8004d5:	89 d1                	mov    %edx,%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	83 c2 08             	add    $0x8,%edx
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	50                   	push   %eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	e8 d8 11 00 00       	call   8016c0 <sys_cputs>
  8004e8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8b 40 04             	mov    0x4(%eax),%eax
  8004fa:	8d 50 01             	lea    0x1(%eax),%edx
  8004fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800500:	89 50 04             	mov    %edx,0x4(%eax)
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80050f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800516:	00 00 00 
	b.cnt = 0;
  800519:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800520:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 08             	pushl  0x8(%ebp)
  800529:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	68 9d 04 80 00       	push   $0x80049d
  800535:	e8 11 02 00 00       	call   80074b <vprintfmt>
  80053a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80053d:	a0 24 50 80 00       	mov    0x805024,%al
  800542:	0f b6 c0             	movzbl %al,%eax
  800545:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80054b:	83 ec 04             	sub    $0x4,%esp
  80054e:	50                   	push   %eax
  80054f:	52                   	push   %edx
  800550:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800556:	83 c0 08             	add    $0x8,%eax
  800559:	50                   	push   %eax
  80055a:	e8 61 11 00 00       	call   8016c0 <sys_cputs>
  80055f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800562:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800569:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <cprintf>:

int cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800577:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80057e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	ff 75 f4             	pushl  -0xc(%ebp)
  80058d:	50                   	push   %eax
  80058e:	e8 73 ff ff ff       	call   800506 <vcprintf>
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800599:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a4:	e8 c5 12 00 00       	call   80186e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	e8 48 ff ff ff       	call   800506 <vcprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005c4:	e8 bf 12 00 00       	call   801888 <sys_enable_interrupt>
	return cnt;
  8005c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cc:	c9                   	leave  
  8005cd:	c3                   	ret    

008005ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	53                   	push   %ebx
  8005d2:	83 ec 14             	sub    $0x14,%esp
  8005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ec:	77 55                	ja     800643 <printnum+0x75>
  8005ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f1:	72 05                	jb     8005f8 <printnum+0x2a>
  8005f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005f6:	77 4b                	ja     800643 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	52                   	push   %edx
  800607:	50                   	push   %eax
  800608:	ff 75 f4             	pushl  -0xc(%ebp)
  80060b:	ff 75 f0             	pushl  -0x10(%ebp)
  80060e:	e8 e5 2d 00 00       	call   8033f8 <__udivdi3>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	ff 75 20             	pushl  0x20(%ebp)
  80061c:	53                   	push   %ebx
  80061d:	ff 75 18             	pushl  0x18(%ebp)
  800620:	52                   	push   %edx
  800621:	50                   	push   %eax
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	ff 75 08             	pushl  0x8(%ebp)
  800628:	e8 a1 ff ff ff       	call   8005ce <printnum>
  80062d:	83 c4 20             	add    $0x20,%esp
  800630:	eb 1a                	jmp    80064c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 20             	pushl  0x20(%ebp)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800643:	ff 4d 1c             	decl   0x1c(%ebp)
  800646:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80064a:	7f e6                	jg     800632 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80064c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80064f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80065a:	53                   	push   %ebx
  80065b:	51                   	push   %ecx
  80065c:	52                   	push   %edx
  80065d:	50                   	push   %eax
  80065e:	e8 a5 2e 00 00       	call   803508 <__umoddi3>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	05 54 3c 80 00       	add    $0x803c54,%eax
  80066b:	8a 00                	mov    (%eax),%al
  80066d:	0f be c0             	movsbl %al,%eax
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	ff 75 0c             	pushl  0xc(%ebp)
  800676:	50                   	push   %eax
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	ff d0                	call   *%eax
  80067c:	83 c4 10             	add    $0x10,%esp
}
  80067f:	90                   	nop
  800680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800683:	c9                   	leave  
  800684:	c3                   	ret    

00800685 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800688:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80068c:	7e 1c                	jle    8006aa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	8d 50 08             	lea    0x8(%eax),%edx
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	89 10                	mov    %edx,(%eax)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	83 e8 08             	sub    $0x8,%eax
  8006a3:	8b 50 04             	mov    0x4(%eax),%edx
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	eb 40                	jmp    8006ea <getuint+0x65>
	else if (lflag)
  8006aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ae:	74 1e                	je     8006ce <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	8d 50 04             	lea    0x4(%eax),%edx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 10                	mov    %edx,(%eax)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	83 e8 04             	sub    $0x4,%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cc:	eb 1c                	jmp    8006ea <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	8d 50 04             	lea    0x4(%eax),%edx
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	89 10                	mov    %edx,(%eax)
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	83 e8 04             	sub    $0x4,%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ea:	5d                   	pop    %ebp
  8006eb:	c3                   	ret    

008006ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f3:	7e 1c                	jle    800711 <getint+0x25>
		return va_arg(*ap, long long);
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	8d 50 08             	lea    0x8(%eax),%edx
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	89 10                	mov    %edx,(%eax)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	83 e8 08             	sub    $0x8,%eax
  80070a:	8b 50 04             	mov    0x4(%eax),%edx
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	eb 38                	jmp    800749 <getint+0x5d>
	else if (lflag)
  800711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800715:	74 1a                	je     800731 <getint+0x45>
		return va_arg(*ap, long);
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	8d 50 04             	lea    0x4(%eax),%edx
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	89 10                	mov    %edx,(%eax)
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	83 e8 04             	sub    $0x4,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	99                   	cltd   
  80072f:	eb 18                	jmp    800749 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	8d 50 04             	lea    0x4(%eax),%edx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	89 10                	mov    %edx,(%eax)
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	83 e8 04             	sub    $0x4,%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	99                   	cltd   
}
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	56                   	push   %esi
  80074f:	53                   	push   %ebx
  800750:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800753:	eb 17                	jmp    80076c <vprintfmt+0x21>
			if (ch == '\0')
  800755:	85 db                	test   %ebx,%ebx
  800757:	0f 84 af 03 00 00    	je     800b0c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076c:	8b 45 10             	mov    0x10(%ebp),%eax
  80076f:	8d 50 01             	lea    0x1(%eax),%edx
  800772:	89 55 10             	mov    %edx,0x10(%ebp)
  800775:	8a 00                	mov    (%eax),%al
  800777:	0f b6 d8             	movzbl %al,%ebx
  80077a:	83 fb 25             	cmp    $0x25,%ebx
  80077d:	75 d6                	jne    800755 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80077f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800783:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80078a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800791:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800798:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80079f:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a2:	8d 50 01             	lea    0x1(%eax),%edx
  8007a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f b6 d8             	movzbl %al,%ebx
  8007ad:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007b0:	83 f8 55             	cmp    $0x55,%eax
  8007b3:	0f 87 2b 03 00 00    	ja     800ae4 <vprintfmt+0x399>
  8007b9:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
  8007c0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007c2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007c6:	eb d7                	jmp    80079f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007cc:	eb d1                	jmp    80079f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	c1 e0 02             	shl    $0x2,%eax
  8007dd:	01 d0                	add    %edx,%eax
  8007df:	01 c0                	add    %eax,%eax
  8007e1:	01 d8                	add    %ebx,%eax
  8007e3:	83 e8 30             	sub    $0x30,%eax
  8007e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ec:	8a 00                	mov    (%eax),%al
  8007ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007f4:	7e 3e                	jle    800834 <vprintfmt+0xe9>
  8007f6:	83 fb 39             	cmp    $0x39,%ebx
  8007f9:	7f 39                	jg     800834 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007fe:	eb d5                	jmp    8007d5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 c0 04             	add    $0x4,%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800814:	eb 1f                	jmp    800835 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800816:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081a:	79 83                	jns    80079f <vprintfmt+0x54>
				width = 0;
  80081c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800823:	e9 77 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800828:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80082f:	e9 6b ff ff ff       	jmp    80079f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800834:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800835:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800839:	0f 89 60 ff ff ff    	jns    80079f <vprintfmt+0x54>
				width = precision, precision = -1;
  80083f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800845:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80084c:	e9 4e ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800851:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800854:	e9 46 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 c0 04             	add    $0x4,%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 e8 04             	sub    $0x4,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	50                   	push   %eax
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
			break;
  800879:	e9 89 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 e8 04             	sub    $0x4,%eax
  80088d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80088f:	85 db                	test   %ebx,%ebx
  800891:	79 02                	jns    800895 <vprintfmt+0x14a>
				err = -err;
  800893:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800895:	83 fb 64             	cmp    $0x64,%ebx
  800898:	7f 0b                	jg     8008a5 <vprintfmt+0x15a>
  80089a:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 19                	jne    8008be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a5:	53                   	push   %ebx
  8008a6:	68 65 3c 80 00       	push   $0x803c65
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	ff 75 08             	pushl  0x8(%ebp)
  8008b1:	e8 5e 02 00 00       	call   800b14 <printfmt>
  8008b6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b9:	e9 49 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008be:	56                   	push   %esi
  8008bf:	68 6e 3c 80 00       	push   $0x803c6e
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 45 02 00 00       	call   800b14 <printfmt>
  8008cf:	83 c4 10             	add    $0x10,%esp
			break;
  8008d2:	e9 30 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 c0 04             	add    $0x4,%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 30                	mov    (%eax),%esi
  8008e8:	85 f6                	test   %esi,%esi
  8008ea:	75 05                	jne    8008f1 <vprintfmt+0x1a6>
				p = "(null)";
  8008ec:	be 71 3c 80 00       	mov    $0x803c71,%esi
			if (width > 0 && padc != '-')
  8008f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f5:	7e 6d                	jle    800964 <vprintfmt+0x219>
  8008f7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008fb:	74 67                	je     800964 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	50                   	push   %eax
  800904:	56                   	push   %esi
  800905:	e8 0c 03 00 00       	call   800c16 <strnlen>
  80090a:	83 c4 10             	add    $0x10,%esp
  80090d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800910:	eb 16                	jmp    800928 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800912:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800925:	ff 4d e4             	decl   -0x1c(%ebp)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	7f e4                	jg     800912 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	eb 34                	jmp    800964 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800930:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800934:	74 1c                	je     800952 <vprintfmt+0x207>
  800936:	83 fb 1f             	cmp    $0x1f,%ebx
  800939:	7e 05                	jle    800940 <vprintfmt+0x1f5>
  80093b:	83 fb 7e             	cmp    $0x7e,%ebx
  80093e:	7e 12                	jle    800952 <vprintfmt+0x207>
					putch('?', putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	6a 3f                	push   $0x3f
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	ff d0                	call   *%eax
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	eb 0f                	jmp    800961 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800961:	ff 4d e4             	decl   -0x1c(%ebp)
  800964:	89 f0                	mov    %esi,%eax
  800966:	8d 70 01             	lea    0x1(%eax),%esi
  800969:	8a 00                	mov    (%eax),%al
  80096b:	0f be d8             	movsbl %al,%ebx
  80096e:	85 db                	test   %ebx,%ebx
  800970:	74 24                	je     800996 <vprintfmt+0x24b>
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	78 b8                	js     800930 <vprintfmt+0x1e5>
  800978:	ff 4d e0             	decl   -0x20(%ebp)
  80097b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097f:	79 af                	jns    800930 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800981:	eb 13                	jmp    800996 <vprintfmt+0x24b>
				putch(' ', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	6a 20                	push   $0x20
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800993:	ff 4d e4             	decl   -0x1c(%ebp)
  800996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099a:	7f e7                	jg     800983 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80099c:	e9 66 01 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a7:	8d 45 14             	lea    0x14(%ebp),%eax
  8009aa:	50                   	push   %eax
  8009ab:	e8 3c fd ff ff       	call   8006ec <getint>
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	79 23                	jns    8009e6 <vprintfmt+0x29b>
				putch('-', putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	6a 2d                	push   $0x2d
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	ff d0                	call   *%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d9:	f7 d8                	neg    %eax
  8009db:	83 d2 00             	adc    $0x0,%edx
  8009de:	f7 da                	neg    %edx
  8009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009e6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ed:	e9 bc 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fb:	50                   	push   %eax
  8009fc:	e8 84 fc ff ff       	call   800685 <getuint>
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a11:	e9 98 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	6a 58                	push   $0x58
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	6a 58                	push   $0x58
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	ff d0                	call   *%eax
  800a33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	6a 58                	push   $0x58
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
			break;
  800a46:	e9 bc 00 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	6a 30                	push   $0x30
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	ff d0                	call   *%eax
  800a58:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	6a 78                	push   $0x78
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 c0 04             	add    $0x4,%eax
  800a71:	89 45 14             	mov    %eax,0x14(%ebp)
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	83 e8 04             	sub    $0x4,%eax
  800a7a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a8d:	eb 1f                	jmp    800aae <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 e8             	pushl  -0x18(%ebp)
  800a95:	8d 45 14             	lea    0x14(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	e8 e7 fb ff ff       	call   800685 <getuint>
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aae:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	52                   	push   %edx
  800ab9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800abc:	50                   	push   %eax
  800abd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	e8 00 fb ff ff       	call   8005ce <printnum>
  800ace:	83 c4 20             	add    $0x20,%esp
			break;
  800ad1:	eb 34                	jmp    800b07 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	53                   	push   %ebx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	ff d0                	call   *%eax
  800adf:	83 c4 10             	add    $0x10,%esp
			break;
  800ae2:	eb 23                	jmp    800b07 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	6a 25                	push   $0x25
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af4:	ff 4d 10             	decl   0x10(%ebp)
  800af7:	eb 03                	jmp    800afc <vprintfmt+0x3b1>
  800af9:	ff 4d 10             	decl   0x10(%ebp)
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	48                   	dec    %eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	3c 25                	cmp    $0x25,%al
  800b04:	75 f3                	jne    800af9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b06:	90                   	nop
		}
	}
  800b07:	e9 47 fc ff ff       	jmp    800753 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1d:	83 c0 04             	add    $0x4,%eax
  800b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b23:	8b 45 10             	mov    0x10(%ebp),%eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	50                   	push   %eax
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 16 fc ff ff       	call   80074b <vprintfmt>
  800b35:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b38:	90                   	nop
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	8b 40 08             	mov    0x8(%eax),%eax
  800b44:	8d 50 01             	lea    0x1(%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	8b 10                	mov    (%eax),%edx
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 04             	mov    0x4(%eax),%eax
  800b58:	39 c2                	cmp    %eax,%edx
  800b5a:	73 12                	jae    800b6e <sprintputch+0x33>
		*b->buf++ = ch;
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	8d 48 01             	lea    0x1(%eax),%ecx
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	89 0a                	mov    %ecx,(%edx)
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	88 10                	mov    %dl,(%eax)
}
  800b6e:	90                   	nop
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	01 d0                	add    %edx,%eax
  800b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b96:	74 06                	je     800b9e <vsnprintf+0x2d>
  800b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9c:	7f 07                	jg     800ba5 <vsnprintf+0x34>
		return -E_INVAL;
  800b9e:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba3:	eb 20                	jmp    800bc5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba5:	ff 75 14             	pushl  0x14(%ebp)
  800ba8:	ff 75 10             	pushl  0x10(%ebp)
  800bab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	68 3b 0b 80 00       	push   $0x800b3b
  800bb4:	e8 92 fb ff ff       	call   80074b <vprintfmt>
  800bb9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bcd:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd0:	83 c0 04             	add    $0x4,%eax
  800bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 89 ff ff ff       	call   800b71 <vsnprintf>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c00:	eb 06                	jmp    800c08 <strlen+0x15>
		n++;
  800c02:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c05:	ff 45 08             	incl   0x8(%ebp)
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	84 c0                	test   %al,%al
  800c0f:	75 f1                	jne    800c02 <strlen+0xf>
		n++;
	return n;
  800c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c23:	eb 09                	jmp    800c2e <strnlen+0x18>
		n++;
  800c25:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 4d 0c             	decl   0xc(%ebp)
  800c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c32:	74 09                	je     800c3d <strnlen+0x27>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e8                	jne    800c25 <strnlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c4e:	90                   	nop
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8d 50 01             	lea    0x1(%eax),%edx
  800c55:	89 55 08             	mov    %edx,0x8(%ebp)
  800c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c61:	8a 12                	mov    (%edx),%dl
  800c63:	88 10                	mov    %dl,(%eax)
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	84 c0                	test   %al,%al
  800c69:	75 e4                	jne    800c4f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c83:	eb 1f                	jmp    800ca4 <strncpy+0x34>
		*dst++ = *src;
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8d 50 01             	lea    0x1(%eax),%edx
  800c8b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	84 c0                	test   %al,%al
  800c9c:	74 03                	je     800ca1 <strncpy+0x31>
			src++;
  800c9e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca1:	ff 45 fc             	incl   -0x4(%ebp)
  800ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800caa:	72 d9                	jb     800c85 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc1:	74 30                	je     800cf3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc3:	eb 16                	jmp    800cdb <strlcpy+0x2a>
			*dst++ = *src++;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8d 50 01             	lea    0x1(%eax),%edx
  800ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd7:	8a 12                	mov    (%edx),%dl
  800cd9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cdb:	ff 4d 10             	decl   0x10(%ebp)
  800cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce2:	74 09                	je     800ced <strlcpy+0x3c>
  800ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	75 d8                	jne    800cc5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	29 c2                	sub    %eax,%edx
  800cfb:	89 d0                	mov    %edx,%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d02:	eb 06                	jmp    800d0a <strcmp+0xb>
		p++, q++;
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	84 c0                	test   %al,%al
  800d11:	74 0e                	je     800d21 <strcmp+0x22>
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 10                	mov    (%eax),%dl
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	38 c2                	cmp    %al,%dl
  800d1f:	74 e3                	je     800d04 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	0f b6 d0             	movzbl %al,%edx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 c0             	movzbl %al,%eax
  800d31:	29 c2                	sub    %eax,%edx
  800d33:	89 d0                	mov    %edx,%eax
}
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d3a:	eb 09                	jmp    800d45 <strncmp+0xe>
		n--, p++, q++;
  800d3c:	ff 4d 10             	decl   0x10(%ebp)
  800d3f:	ff 45 08             	incl   0x8(%ebp)
  800d42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 17                	je     800d62 <strncmp+0x2b>
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	84 c0                	test   %al,%al
  800d52:	74 0e                	je     800d62 <strncmp+0x2b>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 10                	mov    (%eax),%dl
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	38 c2                	cmp    %al,%dl
  800d60:	74 da                	je     800d3c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	75 07                	jne    800d6f <strncmp+0x38>
		return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	eb 14                	jmp    800d83 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	0f b6 d0             	movzbl %al,%edx
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	0f b6 c0             	movzbl %al,%eax
  800d7f:	29 c2                	sub    %eax,%edx
  800d81:	89 d0                	mov    %edx,%eax
}
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 04             	sub    $0x4,%esp
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d91:	eb 12                	jmp    800da5 <strchr+0x20>
		if (*s == c)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9b:	75 05                	jne    800da2 <strchr+0x1d>
			return (char *) s;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	eb 11                	jmp    800db3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da2:	ff 45 08             	incl   0x8(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 e5                	jne    800d93 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 04             	sub    $0x4,%esp
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc1:	eb 0d                	jmp    800dd0 <strfind+0x1b>
		if (*s == c)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dcb:	74 0e                	je     800ddb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	75 ea                	jne    800dc3 <strfind+0xe>
  800dd9:	eb 01                	jmp    800ddc <strfind+0x27>
		if (*s == c)
			break;
  800ddb:	90                   	nop
	return (char *) s;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df3:	eb 0e                	jmp    800e03 <memset+0x22>
		*p++ = c;
  800df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df8:	8d 50 01             	lea    0x1(%eax),%edx
  800dfb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e01:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e03:	ff 4d f8             	decl   -0x8(%ebp)
  800e06:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e0a:	79 e9                	jns    800df5 <memset+0x14>
		*p++ = c;

	return v;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e23:	eb 16                	jmp    800e3b <memcpy+0x2a>
		*d++ = *s++;
  800e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e28:	8d 50 01             	lea    0x1(%eax),%edx
  800e2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e37:	8a 12                	mov    (%edx),%dl
  800e39:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e41:	89 55 10             	mov    %edx,0x10(%ebp)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	75 dd                	jne    800e25 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e65:	73 50                	jae    800eb7 <memmove+0x6a>
  800e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	01 d0                	add    %edx,%eax
  800e6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e72:	76 43                	jbe    800eb7 <memmove+0x6a>
		s += n;
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e80:	eb 10                	jmp    800e92 <memmove+0x45>
			*--d = *--s;
  800e82:	ff 4d f8             	decl   -0x8(%ebp)
  800e85:	ff 4d fc             	decl   -0x4(%ebp)
  800e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8b:	8a 10                	mov    (%eax),%dl
  800e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e90:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e98:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 e3                	jne    800e82 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9f:	eb 23                	jmp    800ec4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eaa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	75 dd                	jne    800ea1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800edb:	eb 2a                	jmp    800f07 <memcmp+0x3e>
		if (*s1 != *s2)
  800edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee0:	8a 10                	mov    (%eax),%dl
  800ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	38 c2                	cmp    %al,%dl
  800ee9:	74 16                	je     800f01 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	0f b6 d0             	movzbl %al,%edx
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 c0             	movzbl %al,%eax
  800efb:	29 c2                	sub    %eax,%edx
  800efd:	89 d0                	mov    %edx,%eax
  800eff:	eb 18                	jmp    800f19 <memcmp+0x50>
		s1++, s2++;
  800f01:	ff 45 fc             	incl   -0x4(%ebp)
  800f04:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f07:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	75 c9                	jne    800edd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	01 d0                	add    %edx,%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f2c:	eb 15                	jmp    800f43 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f b6 d0             	movzbl %al,%edx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	0f b6 c0             	movzbl %al,%eax
  800f3c:	39 c2                	cmp    %eax,%edx
  800f3e:	74 0d                	je     800f4d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f49:	72 e3                	jb     800f2e <memfind+0x13>
  800f4b:	eb 01                	jmp    800f4e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f4d:	90                   	nop
	return (void *) s;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f67:	eb 03                	jmp    800f6c <strtol+0x19>
		s++;
  800f69:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 20                	cmp    $0x20,%al
  800f73:	74 f4                	je     800f69 <strtol+0x16>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	3c 09                	cmp    $0x9,%al
  800f7c:	74 eb                	je     800f69 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 2b                	cmp    $0x2b,%al
  800f85:	75 05                	jne    800f8c <strtol+0x39>
		s++;
  800f87:	ff 45 08             	incl   0x8(%ebp)
  800f8a:	eb 13                	jmp    800f9f <strtol+0x4c>
	else if (*s == '-')
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	3c 2d                	cmp    $0x2d,%al
  800f93:	75 0a                	jne    800f9f <strtol+0x4c>
		s++, neg = 1;
  800f95:	ff 45 08             	incl   0x8(%ebp)
  800f98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	74 06                	je     800fab <strtol+0x58>
  800fa5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa9:	75 20                	jne    800fcb <strtol+0x78>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 30                	cmp    $0x30,%al
  800fb2:	75 17                	jne    800fcb <strtol+0x78>
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	40                   	inc    %eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 78                	cmp    $0x78,%al
  800fbc:	75 0d                	jne    800fcb <strtol+0x78>
		s += 2, base = 16;
  800fbe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc9:	eb 28                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	75 15                	jne    800fe6 <strtol+0x93>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 30                	cmp    $0x30,%al
  800fd8:	75 0c                	jne    800fe6 <strtol+0x93>
		s++, base = 8;
  800fda:	ff 45 08             	incl   0x8(%ebp)
  800fdd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fe4:	eb 0d                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0)
  800fe6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fea:	75 07                	jne    800ff3 <strtol+0xa0>
		base = 10;
  800fec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 2f                	cmp    $0x2f,%al
  800ffa:	7e 19                	jle    801015 <strtol+0xc2>
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 39                	cmp    $0x39,%al
  801003:	7f 10                	jg     801015 <strtol+0xc2>
			dig = *s - '0';
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f be c0             	movsbl %al,%eax
  80100d:	83 e8 30             	sub    $0x30,%eax
  801010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801013:	eb 42                	jmp    801057 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 60                	cmp    $0x60,%al
  80101c:	7e 19                	jle    801037 <strtol+0xe4>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 7a                	cmp    $0x7a,%al
  801025:	7f 10                	jg     801037 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	0f be c0             	movsbl %al,%eax
  80102f:	83 e8 57             	sub    $0x57,%eax
  801032:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801035:	eb 20                	jmp    801057 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3c 40                	cmp    $0x40,%al
  80103e:	7e 39                	jle    801079 <strtol+0x126>
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	3c 5a                	cmp    $0x5a,%al
  801047:	7f 30                	jg     801079 <strtol+0x126>
			dig = *s - 'A' + 10;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	0f be c0             	movsbl %al,%eax
  801051:	83 e8 37             	sub    $0x37,%eax
  801054:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105d:	7d 19                	jge    801078 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80105f:	ff 45 08             	incl   0x8(%ebp)
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	0f af 45 10          	imul   0x10(%ebp),%eax
  801069:	89 c2                	mov    %eax,%edx
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801073:	e9 7b ff ff ff       	jmp    800ff3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801078:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801079:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107d:	74 08                	je     801087 <strtol+0x134>
		*endptr = (char *) s;
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801087:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108b:	74 07                	je     801094 <strtol+0x141>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	f7 d8                	neg    %eax
  801092:	eb 03                	jmp    801097 <strtol+0x144>
  801094:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <ltostr>:

void
ltostr(long value, char *str)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b1:	79 13                	jns    8010c6 <ltostr+0x2d>
	{
		neg = 1;
  8010b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010c0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010ce:	99                   	cltd   
  8010cf:	f7 f9                	idiv   %ecx
  8010d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d7:	8d 50 01             	lea    0x1(%eax),%edx
  8010da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010dd:	89 c2                	mov    %eax,%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	01 d0                	add    %edx,%eax
  8010e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e7:	83 c2 30             	add    $0x30,%edx
  8010ea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f4:	f7 e9                	imul   %ecx
  8010f6:	c1 fa 02             	sar    $0x2,%edx
  8010f9:	89 c8                	mov    %ecx,%eax
  8010fb:	c1 f8 1f             	sar    $0x1f,%eax
  8010fe:	29 c2                	sub    %eax,%edx
  801100:	89 d0                	mov    %edx,%eax
  801102:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801108:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80110d:	f7 e9                	imul   %ecx
  80110f:	c1 fa 02             	sar    $0x2,%edx
  801112:	89 c8                	mov    %ecx,%eax
  801114:	c1 f8 1f             	sar    $0x1f,%eax
  801117:	29 c2                	sub    %eax,%edx
  801119:	89 d0                	mov    %edx,%eax
  80111b:	c1 e0 02             	shl    $0x2,%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	01 c0                	add    %eax,%eax
  801122:	29 c1                	sub    %eax,%ecx
  801124:	89 ca                	mov    %ecx,%edx
  801126:	85 d2                	test   %edx,%edx
  801128:	75 9c                	jne    8010c6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80112a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801134:	48                   	dec    %eax
  801135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 3d                	je     80117b <ltostr+0xe2>
		start = 1 ;
  80113e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801145:	eb 34                	jmp    80117b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 c2                	add    %eax,%edx
  80115c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801168:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8a 45 eb             	mov    -0x15(%ebp),%al
  801173:	88 02                	mov    %al,(%edx)
		start++ ;
  801175:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801178:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801181:	7c c4                	jl     801147 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801183:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	01 d0                	add    %edx,%eax
  80118b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80118e:	90                   	nop
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801197:	ff 75 08             	pushl  0x8(%ebp)
  80119a:	e8 54 fa ff ff       	call   800bf3 <strlen>
  80119f:	83 c4 04             	add    $0x4,%esp
  8011a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	e8 46 fa ff ff       	call   800bf3 <strlen>
  8011ad:	83 c4 04             	add    $0x4,%esp
  8011b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c1:	eb 17                	jmp    8011da <strcconcat+0x49>
		final[s] = str1[s] ;
  8011c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 c2                	add    %eax,%edx
  8011cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	01 c8                	add    %ecx,%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d7:	ff 45 fc             	incl   -0x4(%ebp)
  8011da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011e0:	7c e1                	jl     8011c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011f0:	eb 1f                	jmp    801211 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f5:	8d 50 01             	lea    0x1(%eax),%edx
  8011f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801200:	01 c2                	add    %eax,%edx
  801202:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c8                	add    %ecx,%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801217:	7c d9                	jl     8011f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801219:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121c:	8b 45 10             	mov    0x10(%ebp),%eax
  80121f:	01 d0                	add    %edx,%eax
  801221:	c6 00 00             	movb   $0x0,(%eax)
}
  801224:	90                   	nop
  801225:	c9                   	leave  
  801226:	c3                   	ret    

00801227 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80122a:	8b 45 14             	mov    0x14(%ebp),%eax
  80122d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801233:	8b 45 14             	mov    0x14(%ebp),%eax
  801236:	8b 00                	mov    (%eax),%eax
  801238:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124a:	eb 0c                	jmp    801258 <strsplit+0x31>
			*string++ = 0;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 08             	mov    %edx,0x8(%ebp)
  801255:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	84 c0                	test   %al,%al
  80125f:	74 18                	je     801279 <strsplit+0x52>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	0f be c0             	movsbl %al,%eax
  801269:	50                   	push   %eax
  80126a:	ff 75 0c             	pushl  0xc(%ebp)
  80126d:	e8 13 fb ff ff       	call   800d85 <strchr>
  801272:	83 c4 08             	add    $0x8,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	75 d3                	jne    80124c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	84 c0                	test   %al,%al
  801280:	74 5a                	je     8012dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	8b 00                	mov    (%eax),%eax
  801287:	83 f8 0f             	cmp    $0xf,%eax
  80128a:	75 07                	jne    801293 <strsplit+0x6c>
		{
			return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
  801291:	eb 66                	jmp    8012f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 48 01             	lea    0x1(%eax),%ecx
  80129b:	8b 55 14             	mov    0x14(%ebp),%edx
  80129e:	89 0a                	mov    %ecx,(%edx)
  8012a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012aa:	01 c2                	add    %eax,%edx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b1:	eb 03                	jmp    8012b6 <strsplit+0x8f>
			string++;
  8012b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	84 c0                	test   %al,%al
  8012bd:	74 8b                	je     80124a <strsplit+0x23>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	0f be c0             	movsbl %al,%eax
  8012c7:	50                   	push   %eax
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	e8 b5 fa ff ff       	call   800d85 <strchr>
  8012d0:	83 c4 08             	add    $0x8,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	74 dc                	je     8012b3 <strsplit+0x8c>
			string++;
	}
  8012d7:	e9 6e ff ff ff       	jmp    80124a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e0:	8b 00                	mov    (%eax),%eax
  8012e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801301:	a1 04 50 80 00       	mov    0x805004,%eax
  801306:	85 c0                	test   %eax,%eax
  801308:	74 1f                	je     801329 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80130a:	e8 1d 00 00 00       	call   80132c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	68 d0 3d 80 00       	push   $0x803dd0
  801317:	e8 55 f2 ff ff       	call   800571 <cprintf>
  80131c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80131f:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801326:	00 00 00 
	}
}
  801329:	90                   	nop
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801332:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801339:	00 00 00 
  80133c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801343:	00 00 00 
  801346:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80134d:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801350:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801357:	00 00 00 
  80135a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801361:	00 00 00 
  801364:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80136b:	00 00 00 
	uint32 arr_size = 0;
  80136e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801375:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80137c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801384:	2d 00 10 00 00       	sub    $0x1000,%eax
  801389:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80138e:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801395:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801398:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80139f:	a1 20 51 80 00       	mov    0x805120,%eax
  8013a4:	c1 e0 04             	shl    $0x4,%eax
  8013a7:	89 c2                	mov    %eax,%edx
  8013a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ac:	01 d0                	add    %edx,%eax
  8013ae:	48                   	dec    %eax
  8013af:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8013b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ba:	f7 75 ec             	divl   -0x14(%ebp)
  8013bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c0:	29 d0                	sub    %edx,%eax
  8013c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8013c5:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013d9:	83 ec 04             	sub    $0x4,%esp
  8013dc:	6a 06                	push   $0x6
  8013de:	ff 75 f4             	pushl  -0xc(%ebp)
  8013e1:	50                   	push   %eax
  8013e2:	e8 1d 04 00 00       	call   801804 <sys_allocate_chunk>
  8013e7:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ea:	a1 20 51 80 00       	mov    0x805120,%eax
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	50                   	push   %eax
  8013f3:	e8 92 0a 00 00       	call   801e8a <initialize_MemBlocksList>
  8013f8:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013fb:	a1 48 51 80 00       	mov    0x805148,%eax
  801400:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801403:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801406:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  80140d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801410:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801417:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80141b:	75 14                	jne    801431 <initialize_dyn_block_system+0x105>
  80141d:	83 ec 04             	sub    $0x4,%esp
  801420:	68 f5 3d 80 00       	push   $0x803df5
  801425:	6a 33                	push   $0x33
  801427:	68 13 3e 80 00       	push   $0x803e13
  80142c:	e8 8c ee ff ff       	call   8002bd <_panic>
  801431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801434:	8b 00                	mov    (%eax),%eax
  801436:	85 c0                	test   %eax,%eax
  801438:	74 10                	je     80144a <initialize_dyn_block_system+0x11e>
  80143a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143d:	8b 00                	mov    (%eax),%eax
  80143f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801442:	8b 52 04             	mov    0x4(%edx),%edx
  801445:	89 50 04             	mov    %edx,0x4(%eax)
  801448:	eb 0b                	jmp    801455 <initialize_dyn_block_system+0x129>
  80144a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144d:	8b 40 04             	mov    0x4(%eax),%eax
  801450:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801455:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801458:	8b 40 04             	mov    0x4(%eax),%eax
  80145b:	85 c0                	test   %eax,%eax
  80145d:	74 0f                	je     80146e <initialize_dyn_block_system+0x142>
  80145f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801462:	8b 40 04             	mov    0x4(%eax),%eax
  801465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801468:	8b 12                	mov    (%edx),%edx
  80146a:	89 10                	mov    %edx,(%eax)
  80146c:	eb 0a                	jmp    801478 <initialize_dyn_block_system+0x14c>
  80146e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801471:	8b 00                	mov    (%eax),%eax
  801473:	a3 48 51 80 00       	mov    %eax,0x805148
  801478:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801484:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80148b:	a1 54 51 80 00       	mov    0x805154,%eax
  801490:	48                   	dec    %eax
  801491:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801496:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80149a:	75 14                	jne    8014b0 <initialize_dyn_block_system+0x184>
  80149c:	83 ec 04             	sub    $0x4,%esp
  80149f:	68 20 3e 80 00       	push   $0x803e20
  8014a4:	6a 34                	push   $0x34
  8014a6:	68 13 3e 80 00       	push   $0x803e13
  8014ab:	e8 0d ee ff ff       	call   8002bd <_panic>
  8014b0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8014b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b9:	89 10                	mov    %edx,(%eax)
  8014bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014be:	8b 00                	mov    (%eax),%eax
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	74 0d                	je     8014d1 <initialize_dyn_block_system+0x1a5>
  8014c4:	a1 38 51 80 00       	mov    0x805138,%eax
  8014c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014cc:	89 50 04             	mov    %edx,0x4(%eax)
  8014cf:	eb 08                	jmp    8014d9 <initialize_dyn_block_system+0x1ad>
  8014d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8014d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014dc:	a3 38 51 80 00       	mov    %eax,0x805138
  8014e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8014f0:	40                   	inc    %eax
  8014f1:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8014f6:	90                   	nop
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014ff:	e8 f7 fd ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  801504:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801508:	75 07                	jne    801511 <malloc+0x18>
  80150a:	b8 00 00 00 00       	mov    $0x0,%eax
  80150f:	eb 14                	jmp    801525 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	68 44 3e 80 00       	push   $0x803e44
  801519:	6a 46                	push   $0x46
  80151b:	68 13 3e 80 00       	push   $0x803e13
  801520:	e8 98 ed ff ff       	call   8002bd <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80152d:	83 ec 04             	sub    $0x4,%esp
  801530:	68 6c 3e 80 00       	push   $0x803e6c
  801535:	6a 61                	push   $0x61
  801537:	68 13 3e 80 00       	push   $0x803e13
  80153c:	e8 7c ed ff ff       	call   8002bd <_panic>

00801541 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 38             	sub    $0x38,%esp
  801547:	8b 45 10             	mov    0x10(%ebp),%eax
  80154a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80154d:	e8 a9 fd ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  801552:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801556:	75 07                	jne    80155f <smalloc+0x1e>
  801558:	b8 00 00 00 00       	mov    $0x0,%eax
  80155d:	eb 7c                	jmp    8015db <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80155f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801566:	8b 55 0c             	mov    0xc(%ebp),%edx
  801569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156c:	01 d0                	add    %edx,%eax
  80156e:	48                   	dec    %eax
  80156f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801575:	ba 00 00 00 00       	mov    $0x0,%edx
  80157a:	f7 75 f0             	divl   -0x10(%ebp)
  80157d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801580:	29 d0                	sub    %edx,%eax
  801582:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801585:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80158c:	e8 41 06 00 00       	call   801bd2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801591:	85 c0                	test   %eax,%eax
  801593:	74 11                	je     8015a6 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801595:	83 ec 0c             	sub    $0xc,%esp
  801598:	ff 75 e8             	pushl  -0x18(%ebp)
  80159b:	e8 ac 0c 00 00       	call   80224c <alloc_block_FF>
  8015a0:	83 c4 10             	add    $0x10,%esp
  8015a3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015aa:	74 2a                	je     8015d6 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015af:	8b 40 08             	mov    0x8(%eax),%eax
  8015b2:	89 c2                	mov    %eax,%edx
  8015b4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015b8:	52                   	push   %edx
  8015b9:	50                   	push   %eax
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	ff 75 08             	pushl  0x8(%ebp)
  8015c0:	e8 92 03 00 00       	call   801957 <sys_createSharedObject>
  8015c5:	83 c4 10             	add    $0x10,%esp
  8015c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8015cb:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8015cf:	74 05                	je     8015d6 <smalloc+0x95>
			return (void*)virtual_address;
  8015d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d4:	eb 05                	jmp    8015db <smalloc+0x9a>
	}
	return NULL;
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015e3:	e8 13 fd ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015e8:	83 ec 04             	sub    $0x4,%esp
  8015eb:	68 90 3e 80 00       	push   $0x803e90
  8015f0:	68 a2 00 00 00       	push   $0xa2
  8015f5:	68 13 3e 80 00       	push   $0x803e13
  8015fa:	e8 be ec ff ff       	call   8002bd <_panic>

008015ff <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801605:	e8 f1 fc ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80160a:	83 ec 04             	sub    $0x4,%esp
  80160d:	68 b4 3e 80 00       	push   $0x803eb4
  801612:	68 e6 00 00 00       	push   $0xe6
  801617:	68 13 3e 80 00       	push   $0x803e13
  80161c:	e8 9c ec ff ff       	call   8002bd <_panic>

00801621 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801627:	83 ec 04             	sub    $0x4,%esp
  80162a:	68 dc 3e 80 00       	push   $0x803edc
  80162f:	68 fa 00 00 00       	push   $0xfa
  801634:	68 13 3e 80 00       	push   $0x803e13
  801639:	e8 7f ec ff ff       	call   8002bd <_panic>

0080163e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801644:	83 ec 04             	sub    $0x4,%esp
  801647:	68 00 3f 80 00       	push   $0x803f00
  80164c:	68 05 01 00 00       	push   $0x105
  801651:	68 13 3e 80 00       	push   $0x803e13
  801656:	e8 62 ec ff ff       	call   8002bd <_panic>

0080165b <shrink>:

}
void shrink(uint32 newSize)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	68 00 3f 80 00       	push   $0x803f00
  801669:	68 0a 01 00 00       	push   $0x10a
  80166e:	68 13 3e 80 00       	push   $0x803e13
  801673:	e8 45 ec ff ff       	call   8002bd <_panic>

00801678 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
  80167b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80167e:	83 ec 04             	sub    $0x4,%esp
  801681:	68 00 3f 80 00       	push   $0x803f00
  801686:	68 0f 01 00 00       	push   $0x10f
  80168b:	68 13 3e 80 00       	push   $0x803e13
  801690:	e8 28 ec ff ff       	call   8002bd <_panic>

00801695 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	57                   	push   %edi
  801699:	56                   	push   %esi
  80169a:	53                   	push   %ebx
  80169b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016aa:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016ad:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016b0:	cd 30                	int    $0x30
  8016b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	5b                   	pop    %ebx
  8016bc:	5e                   	pop    %esi
  8016bd:	5f                   	pop    %edi
  8016be:	5d                   	pop    %ebp
  8016bf:	c3                   	ret    

008016c0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 04             	sub    $0x4,%esp
  8016c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016cc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	52                   	push   %edx
  8016d8:	ff 75 0c             	pushl  0xc(%ebp)
  8016db:	50                   	push   %eax
  8016dc:	6a 00                	push   $0x0
  8016de:	e8 b2 ff ff ff       	call   801695 <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
}
  8016e6:	90                   	nop
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 01                	push   $0x1
  8016f8:	e8 98 ff ff ff       	call   801695 <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801705:	8b 55 0c             	mov    0xc(%ebp),%edx
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	52                   	push   %edx
  801712:	50                   	push   %eax
  801713:	6a 05                	push   $0x5
  801715:	e8 7b ff ff ff       	call   801695 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	56                   	push   %esi
  801723:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801724:	8b 75 18             	mov    0x18(%ebp),%esi
  801727:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80172a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80172d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	56                   	push   %esi
  801734:	53                   	push   %ebx
  801735:	51                   	push   %ecx
  801736:	52                   	push   %edx
  801737:	50                   	push   %eax
  801738:	6a 06                	push   $0x6
  80173a:	e8 56 ff ff ff       	call   801695 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801745:	5b                   	pop    %ebx
  801746:	5e                   	pop    %esi
  801747:	5d                   	pop    %ebp
  801748:	c3                   	ret    

00801749 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80174c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	52                   	push   %edx
  801759:	50                   	push   %eax
  80175a:	6a 07                	push   $0x7
  80175c:	e8 34 ff ff ff       	call   801695 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	ff 75 0c             	pushl  0xc(%ebp)
  801772:	ff 75 08             	pushl  0x8(%ebp)
  801775:	6a 08                	push   $0x8
  801777:	e8 19 ff ff ff       	call   801695 <syscall>
  80177c:	83 c4 18             	add    $0x18,%esp
}
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 09                	push   $0x9
  801790:	e8 00 ff ff ff       	call   801695 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 0a                	push   $0xa
  8017a9:	e8 e7 fe ff ff       	call   801695 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 0b                	push   $0xb
  8017c2:	e8 ce fe ff ff       	call   801695 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	ff 75 0c             	pushl  0xc(%ebp)
  8017d8:	ff 75 08             	pushl  0x8(%ebp)
  8017db:	6a 0f                	push   $0xf
  8017dd:	e8 b3 fe ff ff       	call   801695 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
	return;
  8017e5:	90                   	nop
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	ff 75 0c             	pushl  0xc(%ebp)
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	6a 10                	push   $0x10
  8017f9:	e8 97 fe ff ff       	call   801695 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801801:	90                   	nop
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	ff 75 10             	pushl  0x10(%ebp)
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	ff 75 08             	pushl  0x8(%ebp)
  801814:	6a 11                	push   $0x11
  801816:	e8 7a fe ff ff       	call   801695 <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
	return ;
  80181e:	90                   	nop
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 0c                	push   $0xc
  801830:	e8 60 fe ff ff       	call   801695 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	ff 75 08             	pushl  0x8(%ebp)
  801848:	6a 0d                	push   $0xd
  80184a:	e8 46 fe ff ff       	call   801695 <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 0e                	push   $0xe
  801863:	e8 2d fe ff ff       	call   801695 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	90                   	nop
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 13                	push   $0x13
  80187d:	e8 13 fe ff ff       	call   801695 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	90                   	nop
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 14                	push   $0x14
  801897:	e8 f9 fd ff ff       	call   801695 <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	90                   	nop
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 04             	sub    $0x4,%esp
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018ae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	50                   	push   %eax
  8018bb:	6a 15                	push   $0x15
  8018bd:	e8 d3 fd ff ff       	call   801695 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	90                   	nop
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 16                	push   $0x16
  8018d7:	e8 b9 fd ff ff       	call   801695 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	90                   	nop
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	50                   	push   %eax
  8018f2:	6a 17                	push   $0x17
  8018f4:	e8 9c fd ff ff       	call   801695 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801901:	8b 55 0c             	mov    0xc(%ebp),%edx
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	52                   	push   %edx
  80190e:	50                   	push   %eax
  80190f:	6a 1a                	push   $0x1a
  801911:	e8 7f fd ff ff       	call   801695 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80191e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	52                   	push   %edx
  80192b:	50                   	push   %eax
  80192c:	6a 18                	push   $0x18
  80192e:	e8 62 fd ff ff       	call   801695 <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
}
  801936:	90                   	nop
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	52                   	push   %edx
  801949:	50                   	push   %eax
  80194a:	6a 19                	push   $0x19
  80194c:	e8 44 fd ff ff       	call   801695 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	90                   	nop
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	83 ec 04             	sub    $0x4,%esp
  80195d:	8b 45 10             	mov    0x10(%ebp),%eax
  801960:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801963:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801966:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	6a 00                	push   $0x0
  80196f:	51                   	push   %ecx
  801970:	52                   	push   %edx
  801971:	ff 75 0c             	pushl  0xc(%ebp)
  801974:	50                   	push   %eax
  801975:	6a 1b                	push   $0x1b
  801977:	e8 19 fd ff ff       	call   801695 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801984:	8b 55 0c             	mov    0xc(%ebp),%edx
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	52                   	push   %edx
  801991:	50                   	push   %eax
  801992:	6a 1c                	push   $0x1c
  801994:	e8 fc fc ff ff       	call   801695 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	51                   	push   %ecx
  8019af:	52                   	push   %edx
  8019b0:	50                   	push   %eax
  8019b1:	6a 1d                	push   $0x1d
  8019b3:	e8 dd fc ff ff       	call   801695 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	52                   	push   %edx
  8019cd:	50                   	push   %eax
  8019ce:	6a 1e                	push   $0x1e
  8019d0:	e8 c0 fc ff ff       	call   801695 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 1f                	push   $0x1f
  8019e9:	e8 a7 fc ff ff       	call   801695 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	6a 00                	push   $0x0
  8019fb:	ff 75 14             	pushl  0x14(%ebp)
  8019fe:	ff 75 10             	pushl  0x10(%ebp)
  801a01:	ff 75 0c             	pushl  0xc(%ebp)
  801a04:	50                   	push   %eax
  801a05:	6a 20                	push   $0x20
  801a07:	e8 89 fc ff ff       	call   801695 <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	50                   	push   %eax
  801a20:	6a 21                	push   $0x21
  801a22:	e8 6e fc ff ff       	call   801695 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	90                   	nop
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	50                   	push   %eax
  801a3c:	6a 22                	push   $0x22
  801a3e:	e8 52 fc ff ff       	call   801695 <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 02                	push   $0x2
  801a57:	e8 39 fc ff ff       	call   801695 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 03                	push   $0x3
  801a70:	e8 20 fc ff ff       	call   801695 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 04                	push   $0x4
  801a89:	e8 07 fc ff ff       	call   801695 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_exit_env>:


void sys_exit_env(void)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 23                	push   $0x23
  801aa2:	e8 ee fb ff ff       	call   801695 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	90                   	nop
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ab3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ab6:	8d 50 04             	lea    0x4(%eax),%edx
  801ab9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	52                   	push   %edx
  801ac3:	50                   	push   %eax
  801ac4:	6a 24                	push   $0x24
  801ac6:	e8 ca fb ff ff       	call   801695 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
	return result;
  801ace:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad7:	89 01                	mov    %eax,(%ecx)
  801ad9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	c9                   	leave  
  801ae0:	c2 04 00             	ret    $0x4

00801ae3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	ff 75 10             	pushl  0x10(%ebp)
  801aed:	ff 75 0c             	pushl  0xc(%ebp)
  801af0:	ff 75 08             	pushl  0x8(%ebp)
  801af3:	6a 12                	push   $0x12
  801af5:	e8 9b fb ff ff       	call   801695 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
	return ;
  801afd:	90                   	nop
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 25                	push   $0x25
  801b0f:	e8 81 fb ff ff       	call   801695 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 04             	sub    $0x4,%esp
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b25:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	50                   	push   %eax
  801b32:	6a 26                	push   $0x26
  801b34:	e8 5c fb ff ff       	call   801695 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3c:	90                   	nop
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <rsttst>:
void rsttst()
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 28                	push   $0x28
  801b4e:	e8 42 fb ff ff       	call   801695 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
	return ;
  801b56:	90                   	nop
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 04             	sub    $0x4,%esp
  801b5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b65:	8b 55 18             	mov    0x18(%ebp),%edx
  801b68:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b6c:	52                   	push   %edx
  801b6d:	50                   	push   %eax
  801b6e:	ff 75 10             	pushl  0x10(%ebp)
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	ff 75 08             	pushl  0x8(%ebp)
  801b77:	6a 27                	push   $0x27
  801b79:	e8 17 fb ff ff       	call   801695 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b81:	90                   	nop
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <chktst>:
void chktst(uint32 n)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	ff 75 08             	pushl  0x8(%ebp)
  801b92:	6a 29                	push   $0x29
  801b94:	e8 fc fa ff ff       	call   801695 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9c:	90                   	nop
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <inctst>:

void inctst()
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 2a                	push   $0x2a
  801bae:	e8 e2 fa ff ff       	call   801695 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb6:	90                   	nop
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <gettst>:
uint32 gettst()
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 2b                	push   $0x2b
  801bc8:	e8 c8 fa ff ff       	call   801695 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 2c                	push   $0x2c
  801be4:	e8 ac fa ff ff       	call   801695 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
  801bec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bef:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bf3:	75 07                	jne    801bfc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bf5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfa:	eb 05                	jmp    801c01 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 2c                	push   $0x2c
  801c15:	e8 7b fa ff ff       	call   801695 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
  801c1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c20:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c24:	75 07                	jne    801c2d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c26:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2b:	eb 05                	jmp    801c32 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 2c                	push   $0x2c
  801c46:	e8 4a fa ff ff       	call   801695 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
  801c4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c51:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c55:	75 07                	jne    801c5e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c57:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5c:	eb 05                	jmp    801c63 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 2c                	push   $0x2c
  801c77:	e8 19 fa ff ff       	call   801695 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
  801c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c82:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c86:	75 07                	jne    801c8f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c88:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8d:	eb 05                	jmp    801c94 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	ff 75 08             	pushl  0x8(%ebp)
  801ca4:	6a 2d                	push   $0x2d
  801ca6:	e8 ea f9 ff ff       	call   801695 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
	return ;
  801cae:	90                   	nop
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cb5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	6a 00                	push   $0x0
  801cc3:	53                   	push   %ebx
  801cc4:	51                   	push   %ecx
  801cc5:	52                   	push   %edx
  801cc6:	50                   	push   %eax
  801cc7:	6a 2e                	push   $0x2e
  801cc9:	e8 c7 f9 ff ff       	call   801695 <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	52                   	push   %edx
  801ce6:	50                   	push   %eax
  801ce7:	6a 2f                	push   $0x2f
  801ce9:	e8 a7 f9 ff ff       	call   801695 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cf9:	83 ec 0c             	sub    $0xc,%esp
  801cfc:	68 10 3f 80 00       	push   $0x803f10
  801d01:	e8 6b e8 ff ff       	call   800571 <cprintf>
  801d06:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d10:	83 ec 0c             	sub    $0xc,%esp
  801d13:	68 3c 3f 80 00       	push   $0x803f3c
  801d18:	e8 54 e8 ff ff       	call   800571 <cprintf>
  801d1d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d20:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d24:	a1 38 51 80 00       	mov    0x805138,%eax
  801d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d2c:	eb 56                	jmp    801d84 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d32:	74 1c                	je     801d50 <print_mem_block_lists+0x5d>
  801d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d37:	8b 50 08             	mov    0x8(%eax),%edx
  801d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3d:	8b 48 08             	mov    0x8(%eax),%ecx
  801d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d43:	8b 40 0c             	mov    0xc(%eax),%eax
  801d46:	01 c8                	add    %ecx,%eax
  801d48:	39 c2                	cmp    %eax,%edx
  801d4a:	73 04                	jae    801d50 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d4c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d53:	8b 50 08             	mov    0x8(%eax),%edx
  801d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d59:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5c:	01 c2                	add    %eax,%edx
  801d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d61:	8b 40 08             	mov    0x8(%eax),%eax
  801d64:	83 ec 04             	sub    $0x4,%esp
  801d67:	52                   	push   %edx
  801d68:	50                   	push   %eax
  801d69:	68 51 3f 80 00       	push   $0x803f51
  801d6e:	e8 fe e7 ff ff       	call   800571 <cprintf>
  801d73:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d7c:	a1 40 51 80 00       	mov    0x805140,%eax
  801d81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d88:	74 07                	je     801d91 <print_mem_block_lists+0x9e>
  801d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8d:	8b 00                	mov    (%eax),%eax
  801d8f:	eb 05                	jmp    801d96 <print_mem_block_lists+0xa3>
  801d91:	b8 00 00 00 00       	mov    $0x0,%eax
  801d96:	a3 40 51 80 00       	mov    %eax,0x805140
  801d9b:	a1 40 51 80 00       	mov    0x805140,%eax
  801da0:	85 c0                	test   %eax,%eax
  801da2:	75 8a                	jne    801d2e <print_mem_block_lists+0x3b>
  801da4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da8:	75 84                	jne    801d2e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801daa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dae:	75 10                	jne    801dc0 <print_mem_block_lists+0xcd>
  801db0:	83 ec 0c             	sub    $0xc,%esp
  801db3:	68 60 3f 80 00       	push   $0x803f60
  801db8:	e8 b4 e7 ff ff       	call   800571 <cprintf>
  801dbd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dc0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dc7:	83 ec 0c             	sub    $0xc,%esp
  801dca:	68 84 3f 80 00       	push   $0x803f84
  801dcf:	e8 9d e7 ff ff       	call   800571 <cprintf>
  801dd4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801dd7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ddb:	a1 40 50 80 00       	mov    0x805040,%eax
  801de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de3:	eb 56                	jmp    801e3b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801de5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801de9:	74 1c                	je     801e07 <print_mem_block_lists+0x114>
  801deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dee:	8b 50 08             	mov    0x8(%eax),%edx
  801df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df4:	8b 48 08             	mov    0x8(%eax),%ecx
  801df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfa:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfd:	01 c8                	add    %ecx,%eax
  801dff:	39 c2                	cmp    %eax,%edx
  801e01:	73 04                	jae    801e07 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e03:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0a:	8b 50 08             	mov    0x8(%eax),%edx
  801e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e10:	8b 40 0c             	mov    0xc(%eax),%eax
  801e13:	01 c2                	add    %eax,%edx
  801e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e18:	8b 40 08             	mov    0x8(%eax),%eax
  801e1b:	83 ec 04             	sub    $0x4,%esp
  801e1e:	52                   	push   %edx
  801e1f:	50                   	push   %eax
  801e20:	68 51 3f 80 00       	push   $0x803f51
  801e25:	e8 47 e7 ff ff       	call   800571 <cprintf>
  801e2a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e33:	a1 48 50 80 00       	mov    0x805048,%eax
  801e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e3f:	74 07                	je     801e48 <print_mem_block_lists+0x155>
  801e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e44:	8b 00                	mov    (%eax),%eax
  801e46:	eb 05                	jmp    801e4d <print_mem_block_lists+0x15a>
  801e48:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4d:	a3 48 50 80 00       	mov    %eax,0x805048
  801e52:	a1 48 50 80 00       	mov    0x805048,%eax
  801e57:	85 c0                	test   %eax,%eax
  801e59:	75 8a                	jne    801de5 <print_mem_block_lists+0xf2>
  801e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5f:	75 84                	jne    801de5 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e61:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e65:	75 10                	jne    801e77 <print_mem_block_lists+0x184>
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	68 9c 3f 80 00       	push   $0x803f9c
  801e6f:	e8 fd e6 ff ff       	call   800571 <cprintf>
  801e74:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e77:	83 ec 0c             	sub    $0xc,%esp
  801e7a:	68 10 3f 80 00       	push   $0x803f10
  801e7f:	e8 ed e6 ff ff       	call   800571 <cprintf>
  801e84:	83 c4 10             	add    $0x10,%esp

}
  801e87:	90                   	nop
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e90:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e97:	00 00 00 
  801e9a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ea1:	00 00 00 
  801ea4:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801eab:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801eae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eb5:	e9 9e 00 00 00       	jmp    801f58 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801eba:	a1 50 50 80 00       	mov    0x805050,%eax
  801ebf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec2:	c1 e2 04             	shl    $0x4,%edx
  801ec5:	01 d0                	add    %edx,%eax
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	75 14                	jne    801edf <initialize_MemBlocksList+0x55>
  801ecb:	83 ec 04             	sub    $0x4,%esp
  801ece:	68 c4 3f 80 00       	push   $0x803fc4
  801ed3:	6a 46                	push   $0x46
  801ed5:	68 e7 3f 80 00       	push   $0x803fe7
  801eda:	e8 de e3 ff ff       	call   8002bd <_panic>
  801edf:	a1 50 50 80 00       	mov    0x805050,%eax
  801ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee7:	c1 e2 04             	shl    $0x4,%edx
  801eea:	01 d0                	add    %edx,%eax
  801eec:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801ef2:	89 10                	mov    %edx,(%eax)
  801ef4:	8b 00                	mov    (%eax),%eax
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	74 18                	je     801f12 <initialize_MemBlocksList+0x88>
  801efa:	a1 48 51 80 00       	mov    0x805148,%eax
  801eff:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f05:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f08:	c1 e1 04             	shl    $0x4,%ecx
  801f0b:	01 ca                	add    %ecx,%edx
  801f0d:	89 50 04             	mov    %edx,0x4(%eax)
  801f10:	eb 12                	jmp    801f24 <initialize_MemBlocksList+0x9a>
  801f12:	a1 50 50 80 00       	mov    0x805050,%eax
  801f17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1a:	c1 e2 04             	shl    $0x4,%edx
  801f1d:	01 d0                	add    %edx,%eax
  801f1f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f24:	a1 50 50 80 00       	mov    0x805050,%eax
  801f29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2c:	c1 e2 04             	shl    $0x4,%edx
  801f2f:	01 d0                	add    %edx,%eax
  801f31:	a3 48 51 80 00       	mov    %eax,0x805148
  801f36:	a1 50 50 80 00       	mov    0x805050,%eax
  801f3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3e:	c1 e2 04             	shl    $0x4,%edx
  801f41:	01 d0                	add    %edx,%eax
  801f43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f4a:	a1 54 51 80 00       	mov    0x805154,%eax
  801f4f:	40                   	inc    %eax
  801f50:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f55:	ff 45 f4             	incl   -0xc(%ebp)
  801f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f5e:	0f 82 56 ff ff ff    	jb     801eba <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f64:	90                   	nop
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	8b 00                	mov    (%eax),%eax
  801f72:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f75:	eb 19                	jmp    801f90 <find_block+0x29>
	{
		if(va==point->sva)
  801f77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7a:	8b 40 08             	mov    0x8(%eax),%eax
  801f7d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f80:	75 05                	jne    801f87 <find_block+0x20>
		   return point;
  801f82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f85:	eb 36                	jmp    801fbd <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	8b 40 08             	mov    0x8(%eax),%eax
  801f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f90:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f94:	74 07                	je     801f9d <find_block+0x36>
  801f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f99:	8b 00                	mov    (%eax),%eax
  801f9b:	eb 05                	jmp    801fa2 <find_block+0x3b>
  801f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa5:	89 42 08             	mov    %eax,0x8(%edx)
  801fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fab:	8b 40 08             	mov    0x8(%eax),%eax
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	75 c5                	jne    801f77 <find_block+0x10>
  801fb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fb6:	75 bf                	jne    801f77 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fc5:	a1 40 50 80 00       	mov    0x805040,%eax
  801fca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fcd:	a1 44 50 80 00       	mov    0x805044,%eax
  801fd2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fdb:	74 24                	je     802001 <insert_sorted_allocList+0x42>
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	8b 50 08             	mov    0x8(%eax),%edx
  801fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe6:	8b 40 08             	mov    0x8(%eax),%eax
  801fe9:	39 c2                	cmp    %eax,%edx
  801feb:	76 14                	jbe    802001 <insert_sorted_allocList+0x42>
  801fed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff0:	8b 50 08             	mov    0x8(%eax),%edx
  801ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff6:	8b 40 08             	mov    0x8(%eax),%eax
  801ff9:	39 c2                	cmp    %eax,%edx
  801ffb:	0f 82 60 01 00 00    	jb     802161 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802001:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802005:	75 65                	jne    80206c <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802007:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80200b:	75 14                	jne    802021 <insert_sorted_allocList+0x62>
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	68 c4 3f 80 00       	push   $0x803fc4
  802015:	6a 6b                	push   $0x6b
  802017:	68 e7 3f 80 00       	push   $0x803fe7
  80201c:	e8 9c e2 ff ff       	call   8002bd <_panic>
  802021:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	89 10                	mov    %edx,(%eax)
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	8b 00                	mov    (%eax),%eax
  802031:	85 c0                	test   %eax,%eax
  802033:	74 0d                	je     802042 <insert_sorted_allocList+0x83>
  802035:	a1 40 50 80 00       	mov    0x805040,%eax
  80203a:	8b 55 08             	mov    0x8(%ebp),%edx
  80203d:	89 50 04             	mov    %edx,0x4(%eax)
  802040:	eb 08                	jmp    80204a <insert_sorted_allocList+0x8b>
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	a3 44 50 80 00       	mov    %eax,0x805044
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	a3 40 50 80 00       	mov    %eax,0x805040
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80205c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802061:	40                   	inc    %eax
  802062:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802067:	e9 dc 01 00 00       	jmp    802248 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	8b 50 08             	mov    0x8(%eax),%edx
  802072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802075:	8b 40 08             	mov    0x8(%eax),%eax
  802078:	39 c2                	cmp    %eax,%edx
  80207a:	77 6c                	ja     8020e8 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80207c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802080:	74 06                	je     802088 <insert_sorted_allocList+0xc9>
  802082:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802086:	75 14                	jne    80209c <insert_sorted_allocList+0xdd>
  802088:	83 ec 04             	sub    $0x4,%esp
  80208b:	68 00 40 80 00       	push   $0x804000
  802090:	6a 6f                	push   $0x6f
  802092:	68 e7 3f 80 00       	push   $0x803fe7
  802097:	e8 21 e2 ff ff       	call   8002bd <_panic>
  80209c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209f:	8b 50 04             	mov    0x4(%eax),%edx
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	89 50 04             	mov    %edx,0x4(%eax)
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ae:	89 10                	mov    %edx,(%eax)
  8020b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b3:	8b 40 04             	mov    0x4(%eax),%eax
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	74 0d                	je     8020c7 <insert_sorted_allocList+0x108>
  8020ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bd:	8b 40 04             	mov    0x4(%eax),%eax
  8020c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c3:	89 10                	mov    %edx,(%eax)
  8020c5:	eb 08                	jmp    8020cf <insert_sorted_allocList+0x110>
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	a3 40 50 80 00       	mov    %eax,0x805040
  8020cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d5:	89 50 04             	mov    %edx,0x4(%eax)
  8020d8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020dd:	40                   	inc    %eax
  8020de:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020e3:	e9 60 01 00 00       	jmp    802248 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	8b 50 08             	mov    0x8(%eax),%edx
  8020ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f1:	8b 40 08             	mov    0x8(%eax),%eax
  8020f4:	39 c2                	cmp    %eax,%edx
  8020f6:	0f 82 4c 01 00 00    	jb     802248 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802100:	75 14                	jne    802116 <insert_sorted_allocList+0x157>
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	68 38 40 80 00       	push   $0x804038
  80210a:	6a 73                	push   $0x73
  80210c:	68 e7 3f 80 00       	push   $0x803fe7
  802111:	e8 a7 e1 ff ff       	call   8002bd <_panic>
  802116:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	89 50 04             	mov    %edx,0x4(%eax)
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	8b 40 04             	mov    0x4(%eax),%eax
  802128:	85 c0                	test   %eax,%eax
  80212a:	74 0c                	je     802138 <insert_sorted_allocList+0x179>
  80212c:	a1 44 50 80 00       	mov    0x805044,%eax
  802131:	8b 55 08             	mov    0x8(%ebp),%edx
  802134:	89 10                	mov    %edx,(%eax)
  802136:	eb 08                	jmp    802140 <insert_sorted_allocList+0x181>
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	a3 40 50 80 00       	mov    %eax,0x805040
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	a3 44 50 80 00       	mov    %eax,0x805044
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802151:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802156:	40                   	inc    %eax
  802157:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80215c:	e9 e7 00 00 00       	jmp    802248 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802164:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802167:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80216e:	a1 40 50 80 00       	mov    0x805040,%eax
  802173:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802176:	e9 9d 00 00 00       	jmp    802218 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80217b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217e:	8b 00                	mov    (%eax),%eax
  802180:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	8b 50 08             	mov    0x8(%eax),%edx
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	8b 40 08             	mov    0x8(%eax),%eax
  80218f:	39 c2                	cmp    %eax,%edx
  802191:	76 7d                	jbe    802210 <insert_sorted_allocList+0x251>
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8b 50 08             	mov    0x8(%eax),%edx
  802199:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80219c:	8b 40 08             	mov    0x8(%eax),%eax
  80219f:	39 c2                	cmp    %eax,%edx
  8021a1:	73 6d                	jae    802210 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a7:	74 06                	je     8021af <insert_sorted_allocList+0x1f0>
  8021a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ad:	75 14                	jne    8021c3 <insert_sorted_allocList+0x204>
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	68 5c 40 80 00       	push   $0x80405c
  8021b7:	6a 7f                	push   $0x7f
  8021b9:	68 e7 3f 80 00       	push   $0x803fe7
  8021be:	e8 fa e0 ff ff       	call   8002bd <_panic>
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	8b 10                	mov    (%eax),%edx
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	89 10                	mov    %edx,(%eax)
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	8b 00                	mov    (%eax),%eax
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	74 0b                	je     8021e1 <insert_sorted_allocList+0x222>
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	8b 00                	mov    (%eax),%eax
  8021db:	8b 55 08             	mov    0x8(%ebp),%edx
  8021de:	89 50 04             	mov    %edx,0x4(%eax)
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e7:	89 10                	mov    %edx,(%eax)
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ef:	89 50 04             	mov    %edx,0x4(%eax)
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	8b 00                	mov    (%eax),%eax
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	75 08                	jne    802203 <insert_sorted_allocList+0x244>
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	a3 44 50 80 00       	mov    %eax,0x805044
  802203:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802208:	40                   	inc    %eax
  802209:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80220e:	eb 39                	jmp    802249 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802210:	a1 48 50 80 00       	mov    0x805048,%eax
  802215:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802218:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221c:	74 07                	je     802225 <insert_sorted_allocList+0x266>
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	8b 00                	mov    (%eax),%eax
  802223:	eb 05                	jmp    80222a <insert_sorted_allocList+0x26b>
  802225:	b8 00 00 00 00       	mov    $0x0,%eax
  80222a:	a3 48 50 80 00       	mov    %eax,0x805048
  80222f:	a1 48 50 80 00       	mov    0x805048,%eax
  802234:	85 c0                	test   %eax,%eax
  802236:	0f 85 3f ff ff ff    	jne    80217b <insert_sorted_allocList+0x1bc>
  80223c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802240:	0f 85 35 ff ff ff    	jne    80217b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802246:	eb 01                	jmp    802249 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802248:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802249:	90                   	nop
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802252:	a1 38 51 80 00       	mov    0x805138,%eax
  802257:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225a:	e9 85 01 00 00       	jmp    8023e4 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	8b 40 0c             	mov    0xc(%eax),%eax
  802265:	3b 45 08             	cmp    0x8(%ebp),%eax
  802268:	0f 82 6e 01 00 00    	jb     8023dc <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	8b 40 0c             	mov    0xc(%eax),%eax
  802274:	3b 45 08             	cmp    0x8(%ebp),%eax
  802277:	0f 85 8a 00 00 00    	jne    802307 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80227d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802281:	75 17                	jne    80229a <alloc_block_FF+0x4e>
  802283:	83 ec 04             	sub    $0x4,%esp
  802286:	68 90 40 80 00       	push   $0x804090
  80228b:	68 93 00 00 00       	push   $0x93
  802290:	68 e7 3f 80 00       	push   $0x803fe7
  802295:	e8 23 e0 ff ff       	call   8002bd <_panic>
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 00                	mov    (%eax),%eax
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	74 10                	je     8022b3 <alloc_block_FF+0x67>
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 00                	mov    (%eax),%eax
  8022a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ab:	8b 52 04             	mov    0x4(%edx),%edx
  8022ae:	89 50 04             	mov    %edx,0x4(%eax)
  8022b1:	eb 0b                	jmp    8022be <alloc_block_FF+0x72>
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 40 04             	mov    0x4(%eax),%eax
  8022b9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	8b 40 04             	mov    0x4(%eax),%eax
  8022c4:	85 c0                	test   %eax,%eax
  8022c6:	74 0f                	je     8022d7 <alloc_block_FF+0x8b>
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	8b 40 04             	mov    0x4(%eax),%eax
  8022ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d1:	8b 12                	mov    (%edx),%edx
  8022d3:	89 10                	mov    %edx,(%eax)
  8022d5:	eb 0a                	jmp    8022e1 <alloc_block_FF+0x95>
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 00                	mov    (%eax),%eax
  8022dc:	a3 38 51 80 00       	mov    %eax,0x805138
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f4:	a1 44 51 80 00       	mov    0x805144,%eax
  8022f9:	48                   	dec    %eax
  8022fa:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	e9 10 01 00 00       	jmp    802417 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 40 0c             	mov    0xc(%eax),%eax
  80230d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802310:	0f 86 c6 00 00 00    	jbe    8023dc <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802316:	a1 48 51 80 00       	mov    0x805148,%eax
  80231b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	8b 50 08             	mov    0x8(%eax),%edx
  802324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802327:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80232a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232d:	8b 55 08             	mov    0x8(%ebp),%edx
  802330:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802333:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802337:	75 17                	jne    802350 <alloc_block_FF+0x104>
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	68 90 40 80 00       	push   $0x804090
  802341:	68 9b 00 00 00       	push   $0x9b
  802346:	68 e7 3f 80 00       	push   $0x803fe7
  80234b:	e8 6d df ff ff       	call   8002bd <_panic>
  802350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802353:	8b 00                	mov    (%eax),%eax
  802355:	85 c0                	test   %eax,%eax
  802357:	74 10                	je     802369 <alloc_block_FF+0x11d>
  802359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802361:	8b 52 04             	mov    0x4(%edx),%edx
  802364:	89 50 04             	mov    %edx,0x4(%eax)
  802367:	eb 0b                	jmp    802374 <alloc_block_FF+0x128>
  802369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236c:	8b 40 04             	mov    0x4(%eax),%eax
  80236f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802377:	8b 40 04             	mov    0x4(%eax),%eax
  80237a:	85 c0                	test   %eax,%eax
  80237c:	74 0f                	je     80238d <alloc_block_FF+0x141>
  80237e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802381:	8b 40 04             	mov    0x4(%eax),%eax
  802384:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802387:	8b 12                	mov    (%edx),%edx
  802389:	89 10                	mov    %edx,(%eax)
  80238b:	eb 0a                	jmp    802397 <alloc_block_FF+0x14b>
  80238d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	a3 48 51 80 00       	mov    %eax,0x805148
  802397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023aa:	a1 54 51 80 00       	mov    0x805154,%eax
  8023af:	48                   	dec    %eax
  8023b0:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	8b 50 08             	mov    0x8(%eax),%edx
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	01 c2                	add    %eax,%edx
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cc:	2b 45 08             	sub    0x8(%ebp),%eax
  8023cf:	89 c2                	mov    %eax,%edx
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023da:	eb 3b                	jmp    802417 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023dc:	a1 40 51 80 00       	mov    0x805140,%eax
  8023e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e8:	74 07                	je     8023f1 <alloc_block_FF+0x1a5>
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 00                	mov    (%eax),%eax
  8023ef:	eb 05                	jmp    8023f6 <alloc_block_FF+0x1aa>
  8023f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f6:	a3 40 51 80 00       	mov    %eax,0x805140
  8023fb:	a1 40 51 80 00       	mov    0x805140,%eax
  802400:	85 c0                	test   %eax,%eax
  802402:	0f 85 57 fe ff ff    	jne    80225f <alloc_block_FF+0x13>
  802408:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240c:	0f 85 4d fe ff ff    	jne    80225f <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802412:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802417:	c9                   	leave  
  802418:	c3                   	ret    

00802419 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
  80241c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80241f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802426:	a1 38 51 80 00       	mov    0x805138,%eax
  80242b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242e:	e9 df 00 00 00       	jmp    802512 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 40 0c             	mov    0xc(%eax),%eax
  802439:	3b 45 08             	cmp    0x8(%ebp),%eax
  80243c:	0f 82 c8 00 00 00    	jb     80250a <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802445:	8b 40 0c             	mov    0xc(%eax),%eax
  802448:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244b:	0f 85 8a 00 00 00    	jne    8024db <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802451:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802455:	75 17                	jne    80246e <alloc_block_BF+0x55>
  802457:	83 ec 04             	sub    $0x4,%esp
  80245a:	68 90 40 80 00       	push   $0x804090
  80245f:	68 b7 00 00 00       	push   $0xb7
  802464:	68 e7 3f 80 00       	push   $0x803fe7
  802469:	e8 4f de ff ff       	call   8002bd <_panic>
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 00                	mov    (%eax),%eax
  802473:	85 c0                	test   %eax,%eax
  802475:	74 10                	je     802487 <alloc_block_BF+0x6e>
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 00                	mov    (%eax),%eax
  80247c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247f:	8b 52 04             	mov    0x4(%edx),%edx
  802482:	89 50 04             	mov    %edx,0x4(%eax)
  802485:	eb 0b                	jmp    802492 <alloc_block_BF+0x79>
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 40 04             	mov    0x4(%eax),%eax
  80248d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 40 04             	mov    0x4(%eax),%eax
  802498:	85 c0                	test   %eax,%eax
  80249a:	74 0f                	je     8024ab <alloc_block_BF+0x92>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 40 04             	mov    0x4(%eax),%eax
  8024a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a5:	8b 12                	mov    (%edx),%edx
  8024a7:	89 10                	mov    %edx,(%eax)
  8024a9:	eb 0a                	jmp    8024b5 <alloc_block_BF+0x9c>
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8024cd:	48                   	dec    %eax
  8024ce:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	e9 4d 01 00 00       	jmp    802628 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e4:	76 24                	jbe    80250a <alloc_block_BF+0xf1>
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024ef:	73 19                	jae    80250a <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024f1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 40 08             	mov    0x8(%eax),%eax
  802507:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80250a:	a1 40 51 80 00       	mov    0x805140,%eax
  80250f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802516:	74 07                	je     80251f <alloc_block_BF+0x106>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	eb 05                	jmp    802524 <alloc_block_BF+0x10b>
  80251f:	b8 00 00 00 00       	mov    $0x0,%eax
  802524:	a3 40 51 80 00       	mov    %eax,0x805140
  802529:	a1 40 51 80 00       	mov    0x805140,%eax
  80252e:	85 c0                	test   %eax,%eax
  802530:	0f 85 fd fe ff ff    	jne    802433 <alloc_block_BF+0x1a>
  802536:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253a:	0f 85 f3 fe ff ff    	jne    802433 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802540:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802544:	0f 84 d9 00 00 00    	je     802623 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80254a:	a1 48 51 80 00       	mov    0x805148,%eax
  80254f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802555:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802558:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80255b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255e:	8b 55 08             	mov    0x8(%ebp),%edx
  802561:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802564:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802568:	75 17                	jne    802581 <alloc_block_BF+0x168>
  80256a:	83 ec 04             	sub    $0x4,%esp
  80256d:	68 90 40 80 00       	push   $0x804090
  802572:	68 c7 00 00 00       	push   $0xc7
  802577:	68 e7 3f 80 00       	push   $0x803fe7
  80257c:	e8 3c dd ff ff       	call   8002bd <_panic>
  802581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802584:	8b 00                	mov    (%eax),%eax
  802586:	85 c0                	test   %eax,%eax
  802588:	74 10                	je     80259a <alloc_block_BF+0x181>
  80258a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258d:	8b 00                	mov    (%eax),%eax
  80258f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802592:	8b 52 04             	mov    0x4(%edx),%edx
  802595:	89 50 04             	mov    %edx,0x4(%eax)
  802598:	eb 0b                	jmp    8025a5 <alloc_block_BF+0x18c>
  80259a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259d:	8b 40 04             	mov    0x4(%eax),%eax
  8025a0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a8:	8b 40 04             	mov    0x4(%eax),%eax
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	74 0f                	je     8025be <alloc_block_BF+0x1a5>
  8025af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b2:	8b 40 04             	mov    0x4(%eax),%eax
  8025b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b8:	8b 12                	mov    (%edx),%edx
  8025ba:	89 10                	mov    %edx,(%eax)
  8025bc:	eb 0a                	jmp    8025c8 <alloc_block_BF+0x1af>
  8025be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c1:	8b 00                	mov    (%eax),%eax
  8025c3:	a3 48 51 80 00       	mov    %eax,0x805148
  8025c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025db:	a1 54 51 80 00       	mov    0x805154,%eax
  8025e0:	48                   	dec    %eax
  8025e1:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025e6:	83 ec 08             	sub    $0x8,%esp
  8025e9:	ff 75 ec             	pushl  -0x14(%ebp)
  8025ec:	68 38 51 80 00       	push   $0x805138
  8025f1:	e8 71 f9 ff ff       	call   801f67 <find_block>
  8025f6:	83 c4 10             	add    $0x10,%esp
  8025f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ff:	8b 50 08             	mov    0x8(%eax),%edx
  802602:	8b 45 08             	mov    0x8(%ebp),%eax
  802605:	01 c2                	add    %eax,%edx
  802607:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80260a:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80260d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802610:	8b 40 0c             	mov    0xc(%eax),%eax
  802613:	2b 45 08             	sub    0x8(%ebp),%eax
  802616:	89 c2                	mov    %eax,%edx
  802618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261b:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80261e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802621:	eb 05                	jmp    802628 <alloc_block_BF+0x20f>
	}
	return NULL;
  802623:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802628:	c9                   	leave  
  802629:	c3                   	ret    

0080262a <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
  80262d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802630:	a1 28 50 80 00       	mov    0x805028,%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	0f 85 de 01 00 00    	jne    80281b <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80263d:	a1 38 51 80 00       	mov    0x805138,%eax
  802642:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802645:	e9 9e 01 00 00       	jmp    8027e8 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 40 0c             	mov    0xc(%eax),%eax
  802650:	3b 45 08             	cmp    0x8(%ebp),%eax
  802653:	0f 82 87 01 00 00    	jb     8027e0 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 40 0c             	mov    0xc(%eax),%eax
  80265f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802662:	0f 85 95 00 00 00    	jne    8026fd <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802668:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266c:	75 17                	jne    802685 <alloc_block_NF+0x5b>
  80266e:	83 ec 04             	sub    $0x4,%esp
  802671:	68 90 40 80 00       	push   $0x804090
  802676:	68 e0 00 00 00       	push   $0xe0
  80267b:	68 e7 3f 80 00       	push   $0x803fe7
  802680:	e8 38 dc ff ff       	call   8002bd <_panic>
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	74 10                	je     80269e <alloc_block_NF+0x74>
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 00                	mov    (%eax),%eax
  802693:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802696:	8b 52 04             	mov    0x4(%edx),%edx
  802699:	89 50 04             	mov    %edx,0x4(%eax)
  80269c:	eb 0b                	jmp    8026a9 <alloc_block_NF+0x7f>
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 40 04             	mov    0x4(%eax),%eax
  8026a4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 40 04             	mov    0x4(%eax),%eax
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	74 0f                	je     8026c2 <alloc_block_NF+0x98>
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 40 04             	mov    0x4(%eax),%eax
  8026b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bc:	8b 12                	mov    (%edx),%edx
  8026be:	89 10                	mov    %edx,(%eax)
  8026c0:	eb 0a                	jmp    8026cc <alloc_block_NF+0xa2>
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 00                	mov    (%eax),%eax
  8026c7:	a3 38 51 80 00       	mov    %eax,0x805138
  8026cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026df:	a1 44 51 80 00       	mov    0x805144,%eax
  8026e4:	48                   	dec    %eax
  8026e5:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 08             	mov    0x8(%eax),%eax
  8026f0:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	e9 f8 04 00 00       	jmp    802bf5 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 40 0c             	mov    0xc(%eax),%eax
  802703:	3b 45 08             	cmp    0x8(%ebp),%eax
  802706:	0f 86 d4 00 00 00    	jbe    8027e0 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80270c:	a1 48 51 80 00       	mov    0x805148,%eax
  802711:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 50 08             	mov    0x8(%eax),%edx
  80271a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271d:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802723:	8b 55 08             	mov    0x8(%ebp),%edx
  802726:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802729:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80272d:	75 17                	jne    802746 <alloc_block_NF+0x11c>
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	68 90 40 80 00       	push   $0x804090
  802737:	68 e9 00 00 00       	push   $0xe9
  80273c:	68 e7 3f 80 00       	push   $0x803fe7
  802741:	e8 77 db ff ff       	call   8002bd <_panic>
  802746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 10                	je     80275f <alloc_block_NF+0x135>
  80274f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802757:	8b 52 04             	mov    0x4(%edx),%edx
  80275a:	89 50 04             	mov    %edx,0x4(%eax)
  80275d:	eb 0b                	jmp    80276a <alloc_block_NF+0x140>
  80275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802762:	8b 40 04             	mov    0x4(%eax),%eax
  802765:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80276a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276d:	8b 40 04             	mov    0x4(%eax),%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	74 0f                	je     802783 <alloc_block_NF+0x159>
  802774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802777:	8b 40 04             	mov    0x4(%eax),%eax
  80277a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80277d:	8b 12                	mov    (%edx),%edx
  80277f:	89 10                	mov    %edx,(%eax)
  802781:	eb 0a                	jmp    80278d <alloc_block_NF+0x163>
  802783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802786:	8b 00                	mov    (%eax),%eax
  802788:	a3 48 51 80 00       	mov    %eax,0x805148
  80278d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802799:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a0:	a1 54 51 80 00       	mov    0x805154,%eax
  8027a5:	48                   	dec    %eax
  8027a6:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ae:	8b 40 08             	mov    0x8(%eax),%eax
  8027b1:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 50 08             	mov    0x8(%eax),%edx
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	01 c2                	add    %eax,%edx
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cd:	2b 45 08             	sub    0x8(%ebp),%eax
  8027d0:	89 c2                	mov    %eax,%edx
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027db:	e9 15 04 00 00       	jmp    802bf5 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027e0:	a1 40 51 80 00       	mov    0x805140,%eax
  8027e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ec:	74 07                	je     8027f5 <alloc_block_NF+0x1cb>
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 00                	mov    (%eax),%eax
  8027f3:	eb 05                	jmp    8027fa <alloc_block_NF+0x1d0>
  8027f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fa:	a3 40 51 80 00       	mov    %eax,0x805140
  8027ff:	a1 40 51 80 00       	mov    0x805140,%eax
  802804:	85 c0                	test   %eax,%eax
  802806:	0f 85 3e fe ff ff    	jne    80264a <alloc_block_NF+0x20>
  80280c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802810:	0f 85 34 fe ff ff    	jne    80264a <alloc_block_NF+0x20>
  802816:	e9 d5 03 00 00       	jmp    802bf0 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80281b:	a1 38 51 80 00       	mov    0x805138,%eax
  802820:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802823:	e9 b1 01 00 00       	jmp    8029d9 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 50 08             	mov    0x8(%eax),%edx
  80282e:	a1 28 50 80 00       	mov    0x805028,%eax
  802833:	39 c2                	cmp    %eax,%edx
  802835:	0f 82 96 01 00 00    	jb     8029d1 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 40 0c             	mov    0xc(%eax),%eax
  802841:	3b 45 08             	cmp    0x8(%ebp),%eax
  802844:	0f 82 87 01 00 00    	jb     8029d1 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 40 0c             	mov    0xc(%eax),%eax
  802850:	3b 45 08             	cmp    0x8(%ebp),%eax
  802853:	0f 85 95 00 00 00    	jne    8028ee <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802859:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285d:	75 17                	jne    802876 <alloc_block_NF+0x24c>
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	68 90 40 80 00       	push   $0x804090
  802867:	68 fc 00 00 00       	push   $0xfc
  80286c:	68 e7 3f 80 00       	push   $0x803fe7
  802871:	e8 47 da ff ff       	call   8002bd <_panic>
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	85 c0                	test   %eax,%eax
  80287d:	74 10                	je     80288f <alloc_block_NF+0x265>
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 00                	mov    (%eax),%eax
  802884:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802887:	8b 52 04             	mov    0x4(%edx),%edx
  80288a:	89 50 04             	mov    %edx,0x4(%eax)
  80288d:	eb 0b                	jmp    80289a <alloc_block_NF+0x270>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 40 04             	mov    0x4(%eax),%eax
  802895:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	8b 40 04             	mov    0x4(%eax),%eax
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	74 0f                	je     8028b3 <alloc_block_NF+0x289>
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 40 04             	mov    0x4(%eax),%eax
  8028aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ad:	8b 12                	mov    (%edx),%edx
  8028af:	89 10                	mov    %edx,(%eax)
  8028b1:	eb 0a                	jmp    8028bd <alloc_block_NF+0x293>
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 00                	mov    (%eax),%eax
  8028b8:	a3 38 51 80 00       	mov    %eax,0x805138
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d0:	a1 44 51 80 00       	mov    0x805144,%eax
  8028d5:	48                   	dec    %eax
  8028d6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 40 08             	mov    0x8(%eax),%eax
  8028e1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	e9 07 03 00 00       	jmp    802bf5 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f7:	0f 86 d4 00 00 00    	jbe    8029d1 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028fd:	a1 48 51 80 00       	mov    0x805148,%eax
  802902:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 50 08             	mov    0x8(%eax),%edx
  80290b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802914:	8b 55 08             	mov    0x8(%ebp),%edx
  802917:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80291a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80291e:	75 17                	jne    802937 <alloc_block_NF+0x30d>
  802920:	83 ec 04             	sub    $0x4,%esp
  802923:	68 90 40 80 00       	push   $0x804090
  802928:	68 04 01 00 00       	push   $0x104
  80292d:	68 e7 3f 80 00       	push   $0x803fe7
  802932:	e8 86 d9 ff ff       	call   8002bd <_panic>
  802937:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	74 10                	je     802950 <alloc_block_NF+0x326>
  802940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802948:	8b 52 04             	mov    0x4(%edx),%edx
  80294b:	89 50 04             	mov    %edx,0x4(%eax)
  80294e:	eb 0b                	jmp    80295b <alloc_block_NF+0x331>
  802950:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80295b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295e:	8b 40 04             	mov    0x4(%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 0f                	je     802974 <alloc_block_NF+0x34a>
  802965:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80296e:	8b 12                	mov    (%edx),%edx
  802970:	89 10                	mov    %edx,(%eax)
  802972:	eb 0a                	jmp    80297e <alloc_block_NF+0x354>
  802974:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	a3 48 51 80 00       	mov    %eax,0x805148
  80297e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802981:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802987:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802991:	a1 54 51 80 00       	mov    0x805154,%eax
  802996:	48                   	dec    %eax
  802997:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  80299c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299f:	8b 40 08             	mov    0x8(%eax),%eax
  8029a2:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 50 08             	mov    0x8(%eax),%edx
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	01 c2                	add    %eax,%edx
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029be:	2b 45 08             	sub    0x8(%ebp),%eax
  8029c1:	89 c2                	mov    %eax,%edx
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cc:	e9 24 02 00 00       	jmp    802bf5 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8029d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029dd:	74 07                	je     8029e6 <alloc_block_NF+0x3bc>
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	eb 05                	jmp    8029eb <alloc_block_NF+0x3c1>
  8029e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029eb:	a3 40 51 80 00       	mov    %eax,0x805140
  8029f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8029f5:	85 c0                	test   %eax,%eax
  8029f7:	0f 85 2b fe ff ff    	jne    802828 <alloc_block_NF+0x1fe>
  8029fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a01:	0f 85 21 fe ff ff    	jne    802828 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a07:	a1 38 51 80 00       	mov    0x805138,%eax
  802a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0f:	e9 ae 01 00 00       	jmp    802bc2 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 50 08             	mov    0x8(%eax),%edx
  802a1a:	a1 28 50 80 00       	mov    0x805028,%eax
  802a1f:	39 c2                	cmp    %eax,%edx
  802a21:	0f 83 93 01 00 00    	jae    802bba <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a30:	0f 82 84 01 00 00    	jb     802bba <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a3f:	0f 85 95 00 00 00    	jne    802ada <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a49:	75 17                	jne    802a62 <alloc_block_NF+0x438>
  802a4b:	83 ec 04             	sub    $0x4,%esp
  802a4e:	68 90 40 80 00       	push   $0x804090
  802a53:	68 14 01 00 00       	push   $0x114
  802a58:	68 e7 3f 80 00       	push   $0x803fe7
  802a5d:	e8 5b d8 ff ff       	call   8002bd <_panic>
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 00                	mov    (%eax),%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	74 10                	je     802a7b <alloc_block_NF+0x451>
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 00                	mov    (%eax),%eax
  802a70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a73:	8b 52 04             	mov    0x4(%edx),%edx
  802a76:	89 50 04             	mov    %edx,0x4(%eax)
  802a79:	eb 0b                	jmp    802a86 <alloc_block_NF+0x45c>
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 40 04             	mov    0x4(%eax),%eax
  802a81:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 40 04             	mov    0x4(%eax),%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	74 0f                	je     802a9f <alloc_block_NF+0x475>
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 40 04             	mov    0x4(%eax),%eax
  802a96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a99:	8b 12                	mov    (%edx),%edx
  802a9b:	89 10                	mov    %edx,(%eax)
  802a9d:	eb 0a                	jmp    802aa9 <alloc_block_NF+0x47f>
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	a3 38 51 80 00       	mov    %eax,0x805138
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abc:	a1 44 51 80 00       	mov    0x805144,%eax
  802ac1:	48                   	dec    %eax
  802ac2:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	8b 40 08             	mov    0x8(%eax),%eax
  802acd:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	e9 1b 01 00 00       	jmp    802bf5 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae3:	0f 86 d1 00 00 00    	jbe    802bba <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ae9:	a1 48 51 80 00       	mov    0x805148,%eax
  802aee:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 50 08             	mov    0x8(%eax),%edx
  802af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afa:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b00:	8b 55 08             	mov    0x8(%ebp),%edx
  802b03:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b06:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b0a:	75 17                	jne    802b23 <alloc_block_NF+0x4f9>
  802b0c:	83 ec 04             	sub    $0x4,%esp
  802b0f:	68 90 40 80 00       	push   $0x804090
  802b14:	68 1c 01 00 00       	push   $0x11c
  802b19:	68 e7 3f 80 00       	push   $0x803fe7
  802b1e:	e8 9a d7 ff ff       	call   8002bd <_panic>
  802b23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b26:	8b 00                	mov    (%eax),%eax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	74 10                	je     802b3c <alloc_block_NF+0x512>
  802b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2f:	8b 00                	mov    (%eax),%eax
  802b31:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b34:	8b 52 04             	mov    0x4(%edx),%edx
  802b37:	89 50 04             	mov    %edx,0x4(%eax)
  802b3a:	eb 0b                	jmp    802b47 <alloc_block_NF+0x51d>
  802b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3f:	8b 40 04             	mov    0x4(%eax),%eax
  802b42:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4a:	8b 40 04             	mov    0x4(%eax),%eax
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	74 0f                	je     802b60 <alloc_block_NF+0x536>
  802b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b54:	8b 40 04             	mov    0x4(%eax),%eax
  802b57:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b5a:	8b 12                	mov    (%edx),%edx
  802b5c:	89 10                	mov    %edx,(%eax)
  802b5e:	eb 0a                	jmp    802b6a <alloc_block_NF+0x540>
  802b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b63:	8b 00                	mov    (%eax),%eax
  802b65:	a3 48 51 80 00       	mov    %eax,0x805148
  802b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7d:	a1 54 51 80 00       	mov    0x805154,%eax
  802b82:	48                   	dec    %eax
  802b83:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8b:	8b 40 08             	mov    0x8(%eax),%eax
  802b8e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	8b 50 08             	mov    0x8(%eax),%edx
  802b99:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9c:	01 c2                	add    %eax,%edx
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 40 0c             	mov    0xc(%eax),%eax
  802baa:	2b 45 08             	sub    0x8(%ebp),%eax
  802bad:	89 c2                	mov    %eax,%edx
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb8:	eb 3b                	jmp    802bf5 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bba:	a1 40 51 80 00       	mov    0x805140,%eax
  802bbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc6:	74 07                	je     802bcf <alloc_block_NF+0x5a5>
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	8b 00                	mov    (%eax),%eax
  802bcd:	eb 05                	jmp    802bd4 <alloc_block_NF+0x5aa>
  802bcf:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd4:	a3 40 51 80 00       	mov    %eax,0x805140
  802bd9:	a1 40 51 80 00       	mov    0x805140,%eax
  802bde:	85 c0                	test   %eax,%eax
  802be0:	0f 85 2e fe ff ff    	jne    802a14 <alloc_block_NF+0x3ea>
  802be6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bea:	0f 85 24 fe ff ff    	jne    802a14 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bf5:	c9                   	leave  
  802bf6:	c3                   	ret    

00802bf7 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bf7:	55                   	push   %ebp
  802bf8:	89 e5                	mov    %esp,%ebp
  802bfa:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bfd:	a1 38 51 80 00       	mov    0x805138,%eax
  802c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c05:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c0a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c0d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c12:	85 c0                	test   %eax,%eax
  802c14:	74 14                	je     802c2a <insert_sorted_with_merge_freeList+0x33>
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	8b 50 08             	mov    0x8(%eax),%edx
  802c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1f:	8b 40 08             	mov    0x8(%eax),%eax
  802c22:	39 c2                	cmp    %eax,%edx
  802c24:	0f 87 9b 01 00 00    	ja     802dc5 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2e:	75 17                	jne    802c47 <insert_sorted_with_merge_freeList+0x50>
  802c30:	83 ec 04             	sub    $0x4,%esp
  802c33:	68 c4 3f 80 00       	push   $0x803fc4
  802c38:	68 38 01 00 00       	push   $0x138
  802c3d:	68 e7 3f 80 00       	push   $0x803fe7
  802c42:	e8 76 d6 ff ff       	call   8002bd <_panic>
  802c47:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	89 10                	mov    %edx,(%eax)
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	8b 00                	mov    (%eax),%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	74 0d                	je     802c68 <insert_sorted_with_merge_freeList+0x71>
  802c5b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c60:	8b 55 08             	mov    0x8(%ebp),%edx
  802c63:	89 50 04             	mov    %edx,0x4(%eax)
  802c66:	eb 08                	jmp    802c70 <insert_sorted_with_merge_freeList+0x79>
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	a3 38 51 80 00       	mov    %eax,0x805138
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c82:	a1 44 51 80 00       	mov    0x805144,%eax
  802c87:	40                   	inc    %eax
  802c88:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c91:	0f 84 a8 06 00 00    	je     80333f <insert_sorted_with_merge_freeList+0x748>
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	8b 50 08             	mov    0x8(%eax),%edx
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca3:	01 c2                	add    %eax,%edx
  802ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca8:	8b 40 08             	mov    0x8(%eax),%eax
  802cab:	39 c2                	cmp    %eax,%edx
  802cad:	0f 85 8c 06 00 00    	jne    80333f <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	8b 50 0c             	mov    0xc(%eax),%edx
  802cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbf:	01 c2                	add    %eax,%edx
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ccb:	75 17                	jne    802ce4 <insert_sorted_with_merge_freeList+0xed>
  802ccd:	83 ec 04             	sub    $0x4,%esp
  802cd0:	68 90 40 80 00       	push   $0x804090
  802cd5:	68 3c 01 00 00       	push   $0x13c
  802cda:	68 e7 3f 80 00       	push   $0x803fe7
  802cdf:	e8 d9 d5 ff ff       	call   8002bd <_panic>
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	74 10                	je     802cfd <insert_sorted_with_merge_freeList+0x106>
  802ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf0:	8b 00                	mov    (%eax),%eax
  802cf2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf5:	8b 52 04             	mov    0x4(%edx),%edx
  802cf8:	89 50 04             	mov    %edx,0x4(%eax)
  802cfb:	eb 0b                	jmp    802d08 <insert_sorted_with_merge_freeList+0x111>
  802cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d00:	8b 40 04             	mov    0x4(%eax),%eax
  802d03:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0b:	8b 40 04             	mov    0x4(%eax),%eax
  802d0e:	85 c0                	test   %eax,%eax
  802d10:	74 0f                	je     802d21 <insert_sorted_with_merge_freeList+0x12a>
  802d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d15:	8b 40 04             	mov    0x4(%eax),%eax
  802d18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1b:	8b 12                	mov    (%edx),%edx
  802d1d:	89 10                	mov    %edx,(%eax)
  802d1f:	eb 0a                	jmp    802d2b <insert_sorted_with_merge_freeList+0x134>
  802d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	a3 38 51 80 00       	mov    %eax,0x805138
  802d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3e:	a1 44 51 80 00       	mov    0x805144,%eax
  802d43:	48                   	dec    %eax
  802d44:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d61:	75 17                	jne    802d7a <insert_sorted_with_merge_freeList+0x183>
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	68 c4 3f 80 00       	push   $0x803fc4
  802d6b:	68 3f 01 00 00       	push   $0x13f
  802d70:	68 e7 3f 80 00       	push   $0x803fe7
  802d75:	e8 43 d5 ff ff       	call   8002bd <_panic>
  802d7a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d83:	89 10                	mov    %edx,(%eax)
  802d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	74 0d                	je     802d9b <insert_sorted_with_merge_freeList+0x1a4>
  802d8e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d93:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d96:	89 50 04             	mov    %edx,0x4(%eax)
  802d99:	eb 08                	jmp    802da3 <insert_sorted_with_merge_freeList+0x1ac>
  802d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da6:	a3 48 51 80 00       	mov    %eax,0x805148
  802dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db5:	a1 54 51 80 00       	mov    0x805154,%eax
  802dba:	40                   	inc    %eax
  802dbb:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dc0:	e9 7a 05 00 00       	jmp    80333f <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc8:	8b 50 08             	mov    0x8(%eax),%edx
  802dcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dce:	8b 40 08             	mov    0x8(%eax),%eax
  802dd1:	39 c2                	cmp    %eax,%edx
  802dd3:	0f 82 14 01 00 00    	jb     802eed <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddc:	8b 50 08             	mov    0x8(%eax),%edx
  802ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de2:	8b 40 0c             	mov    0xc(%eax),%eax
  802de5:	01 c2                	add    %eax,%edx
  802de7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dea:	8b 40 08             	mov    0x8(%eax),%eax
  802ded:	39 c2                	cmp    %eax,%edx
  802def:	0f 85 90 00 00 00    	jne    802e85 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df8:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802e01:	01 c2                	add    %eax,%edx
  802e03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e06:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e21:	75 17                	jne    802e3a <insert_sorted_with_merge_freeList+0x243>
  802e23:	83 ec 04             	sub    $0x4,%esp
  802e26:	68 c4 3f 80 00       	push   $0x803fc4
  802e2b:	68 49 01 00 00       	push   $0x149
  802e30:	68 e7 3f 80 00       	push   $0x803fe7
  802e35:	e8 83 d4 ff ff       	call   8002bd <_panic>
  802e3a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	89 10                	mov    %edx,(%eax)
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	8b 00                	mov    (%eax),%eax
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	74 0d                	je     802e5b <insert_sorted_with_merge_freeList+0x264>
  802e4e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e53:	8b 55 08             	mov    0x8(%ebp),%edx
  802e56:	89 50 04             	mov    %edx,0x4(%eax)
  802e59:	eb 08                	jmp    802e63 <insert_sorted_with_merge_freeList+0x26c>
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	a3 48 51 80 00       	mov    %eax,0x805148
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e75:	a1 54 51 80 00       	mov    0x805154,%eax
  802e7a:	40                   	inc    %eax
  802e7b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e80:	e9 bb 04 00 00       	jmp    803340 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e89:	75 17                	jne    802ea2 <insert_sorted_with_merge_freeList+0x2ab>
  802e8b:	83 ec 04             	sub    $0x4,%esp
  802e8e:	68 38 40 80 00       	push   $0x804038
  802e93:	68 4c 01 00 00       	push   $0x14c
  802e98:	68 e7 3f 80 00       	push   $0x803fe7
  802e9d:	e8 1b d4 ff ff       	call   8002bd <_panic>
  802ea2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	89 50 04             	mov    %edx,0x4(%eax)
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	8b 40 04             	mov    0x4(%eax),%eax
  802eb4:	85 c0                	test   %eax,%eax
  802eb6:	74 0c                	je     802ec4 <insert_sorted_with_merge_freeList+0x2cd>
  802eb8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ebd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec0:	89 10                	mov    %edx,(%eax)
  802ec2:	eb 08                	jmp    802ecc <insert_sorted_with_merge_freeList+0x2d5>
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	a3 38 51 80 00       	mov    %eax,0x805138
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802edd:	a1 44 51 80 00       	mov    0x805144,%eax
  802ee2:	40                   	inc    %eax
  802ee3:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ee8:	e9 53 04 00 00       	jmp    803340 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802eed:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef5:	e9 15 04 00 00       	jmp    80330f <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 00                	mov    (%eax),%eax
  802eff:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	8b 50 08             	mov    0x8(%eax),%edx
  802f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0b:	8b 40 08             	mov    0x8(%eax),%eax
  802f0e:	39 c2                	cmp    %eax,%edx
  802f10:	0f 86 f1 03 00 00    	jbe    803307 <insert_sorted_with_merge_freeList+0x710>
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	8b 50 08             	mov    0x8(%eax),%edx
  802f1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1f:	8b 40 08             	mov    0x8(%eax),%eax
  802f22:	39 c2                	cmp    %eax,%edx
  802f24:	0f 83 dd 03 00 00    	jae    803307 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 50 08             	mov    0x8(%eax),%edx
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 40 0c             	mov    0xc(%eax),%eax
  802f36:	01 c2                	add    %eax,%edx
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	8b 40 08             	mov    0x8(%eax),%eax
  802f3e:	39 c2                	cmp    %eax,%edx
  802f40:	0f 85 b9 01 00 00    	jne    8030ff <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	8b 50 08             	mov    0x8(%eax),%edx
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f52:	01 c2                	add    %eax,%edx
  802f54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f57:	8b 40 08             	mov    0x8(%eax),%eax
  802f5a:	39 c2                	cmp    %eax,%edx
  802f5c:	0f 85 0d 01 00 00    	jne    80306f <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	8b 50 0c             	mov    0xc(%eax),%edx
  802f68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6e:	01 c2                	add    %eax,%edx
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f7a:	75 17                	jne    802f93 <insert_sorted_with_merge_freeList+0x39c>
  802f7c:	83 ec 04             	sub    $0x4,%esp
  802f7f:	68 90 40 80 00       	push   $0x804090
  802f84:	68 5c 01 00 00       	push   $0x15c
  802f89:	68 e7 3f 80 00       	push   $0x803fe7
  802f8e:	e8 2a d3 ff ff       	call   8002bd <_panic>
  802f93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f96:	8b 00                	mov    (%eax),%eax
  802f98:	85 c0                	test   %eax,%eax
  802f9a:	74 10                	je     802fac <insert_sorted_with_merge_freeList+0x3b5>
  802f9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa4:	8b 52 04             	mov    0x4(%edx),%edx
  802fa7:	89 50 04             	mov    %edx,0x4(%eax)
  802faa:	eb 0b                	jmp    802fb7 <insert_sorted_with_merge_freeList+0x3c0>
  802fac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faf:	8b 40 04             	mov    0x4(%eax),%eax
  802fb2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fba:	8b 40 04             	mov    0x4(%eax),%eax
  802fbd:	85 c0                	test   %eax,%eax
  802fbf:	74 0f                	je     802fd0 <insert_sorted_with_merge_freeList+0x3d9>
  802fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc4:	8b 40 04             	mov    0x4(%eax),%eax
  802fc7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fca:	8b 12                	mov    (%edx),%edx
  802fcc:	89 10                	mov    %edx,(%eax)
  802fce:	eb 0a                	jmp    802fda <insert_sorted_with_merge_freeList+0x3e3>
  802fd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd3:	8b 00                	mov    (%eax),%eax
  802fd5:	a3 38 51 80 00       	mov    %eax,0x805138
  802fda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fed:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff2:	48                   	dec    %eax
  802ff3:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802ff8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803002:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803005:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80300c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803010:	75 17                	jne    803029 <insert_sorted_with_merge_freeList+0x432>
  803012:	83 ec 04             	sub    $0x4,%esp
  803015:	68 c4 3f 80 00       	push   $0x803fc4
  80301a:	68 5f 01 00 00       	push   $0x15f
  80301f:	68 e7 3f 80 00       	push   $0x803fe7
  803024:	e8 94 d2 ff ff       	call   8002bd <_panic>
  803029:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80302f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803032:	89 10                	mov    %edx,(%eax)
  803034:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803037:	8b 00                	mov    (%eax),%eax
  803039:	85 c0                	test   %eax,%eax
  80303b:	74 0d                	je     80304a <insert_sorted_with_merge_freeList+0x453>
  80303d:	a1 48 51 80 00       	mov    0x805148,%eax
  803042:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803045:	89 50 04             	mov    %edx,0x4(%eax)
  803048:	eb 08                	jmp    803052 <insert_sorted_with_merge_freeList+0x45b>
  80304a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803052:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803055:	a3 48 51 80 00       	mov    %eax,0x805148
  80305a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803064:	a1 54 51 80 00       	mov    0x805154,%eax
  803069:	40                   	inc    %eax
  80306a:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 50 0c             	mov    0xc(%eax),%edx
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	8b 40 0c             	mov    0xc(%eax),%eax
  80307b:	01 c2                	add    %eax,%edx
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803097:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309b:	75 17                	jne    8030b4 <insert_sorted_with_merge_freeList+0x4bd>
  80309d:	83 ec 04             	sub    $0x4,%esp
  8030a0:	68 c4 3f 80 00       	push   $0x803fc4
  8030a5:	68 64 01 00 00       	push   $0x164
  8030aa:	68 e7 3f 80 00       	push   $0x803fe7
  8030af:	e8 09 d2 ff ff       	call   8002bd <_panic>
  8030b4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	89 10                	mov    %edx,(%eax)
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	8b 00                	mov    (%eax),%eax
  8030c4:	85 c0                	test   %eax,%eax
  8030c6:	74 0d                	je     8030d5 <insert_sorted_with_merge_freeList+0x4de>
  8030c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8030cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d0:	89 50 04             	mov    %edx,0x4(%eax)
  8030d3:	eb 08                	jmp    8030dd <insert_sorted_with_merge_freeList+0x4e6>
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	a3 48 51 80 00       	mov    %eax,0x805148
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ef:	a1 54 51 80 00       	mov    0x805154,%eax
  8030f4:	40                   	inc    %eax
  8030f5:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8030fa:	e9 41 02 00 00       	jmp    803340 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	8b 50 08             	mov    0x8(%eax),%edx
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	8b 40 0c             	mov    0xc(%eax),%eax
  80310b:	01 c2                	add    %eax,%edx
  80310d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803110:	8b 40 08             	mov    0x8(%eax),%eax
  803113:	39 c2                	cmp    %eax,%edx
  803115:	0f 85 7c 01 00 00    	jne    803297 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80311b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80311f:	74 06                	je     803127 <insert_sorted_with_merge_freeList+0x530>
  803121:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803125:	75 17                	jne    80313e <insert_sorted_with_merge_freeList+0x547>
  803127:	83 ec 04             	sub    $0x4,%esp
  80312a:	68 00 40 80 00       	push   $0x804000
  80312f:	68 69 01 00 00       	push   $0x169
  803134:	68 e7 3f 80 00       	push   $0x803fe7
  803139:	e8 7f d1 ff ff       	call   8002bd <_panic>
  80313e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803141:	8b 50 04             	mov    0x4(%eax),%edx
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	89 50 04             	mov    %edx,0x4(%eax)
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803150:	89 10                	mov    %edx,(%eax)
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	8b 40 04             	mov    0x4(%eax),%eax
  803158:	85 c0                	test   %eax,%eax
  80315a:	74 0d                	je     803169 <insert_sorted_with_merge_freeList+0x572>
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	8b 40 04             	mov    0x4(%eax),%eax
  803162:	8b 55 08             	mov    0x8(%ebp),%edx
  803165:	89 10                	mov    %edx,(%eax)
  803167:	eb 08                	jmp    803171 <insert_sorted_with_merge_freeList+0x57a>
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	a3 38 51 80 00       	mov    %eax,0x805138
  803171:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803174:	8b 55 08             	mov    0x8(%ebp),%edx
  803177:	89 50 04             	mov    %edx,0x4(%eax)
  80317a:	a1 44 51 80 00       	mov    0x805144,%eax
  80317f:	40                   	inc    %eax
  803180:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	8b 50 0c             	mov    0xc(%eax),%edx
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	8b 40 0c             	mov    0xc(%eax),%eax
  803191:	01 c2                	add    %eax,%edx
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803199:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319d:	75 17                	jne    8031b6 <insert_sorted_with_merge_freeList+0x5bf>
  80319f:	83 ec 04             	sub    $0x4,%esp
  8031a2:	68 90 40 80 00       	push   $0x804090
  8031a7:	68 6b 01 00 00       	push   $0x16b
  8031ac:	68 e7 3f 80 00       	push   $0x803fe7
  8031b1:	e8 07 d1 ff ff       	call   8002bd <_panic>
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	85 c0                	test   %eax,%eax
  8031bd:	74 10                	je     8031cf <insert_sorted_with_merge_freeList+0x5d8>
  8031bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c2:	8b 00                	mov    (%eax),%eax
  8031c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c7:	8b 52 04             	mov    0x4(%edx),%edx
  8031ca:	89 50 04             	mov    %edx,0x4(%eax)
  8031cd:	eb 0b                	jmp    8031da <insert_sorted_with_merge_freeList+0x5e3>
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	8b 40 04             	mov    0x4(%eax),%eax
  8031d5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	8b 40 04             	mov    0x4(%eax),%eax
  8031e0:	85 c0                	test   %eax,%eax
  8031e2:	74 0f                	je     8031f3 <insert_sorted_with_merge_freeList+0x5fc>
  8031e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ed:	8b 12                	mov    (%edx),%edx
  8031ef:	89 10                	mov    %edx,(%eax)
  8031f1:	eb 0a                	jmp    8031fd <insert_sorted_with_merge_freeList+0x606>
  8031f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	a3 38 51 80 00       	mov    %eax,0x805138
  8031fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803209:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803210:	a1 44 51 80 00       	mov    0x805144,%eax
  803215:	48                   	dec    %eax
  803216:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80321b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803225:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803228:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80322f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803233:	75 17                	jne    80324c <insert_sorted_with_merge_freeList+0x655>
  803235:	83 ec 04             	sub    $0x4,%esp
  803238:	68 c4 3f 80 00       	push   $0x803fc4
  80323d:	68 6e 01 00 00       	push   $0x16e
  803242:	68 e7 3f 80 00       	push   $0x803fe7
  803247:	e8 71 d0 ff ff       	call   8002bd <_panic>
  80324c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803252:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803255:	89 10                	mov    %edx,(%eax)
  803257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	85 c0                	test   %eax,%eax
  80325e:	74 0d                	je     80326d <insert_sorted_with_merge_freeList+0x676>
  803260:	a1 48 51 80 00       	mov    0x805148,%eax
  803265:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803268:	89 50 04             	mov    %edx,0x4(%eax)
  80326b:	eb 08                	jmp    803275 <insert_sorted_with_merge_freeList+0x67e>
  80326d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803270:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803275:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803278:	a3 48 51 80 00       	mov    %eax,0x805148
  80327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803280:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803287:	a1 54 51 80 00       	mov    0x805154,%eax
  80328c:	40                   	inc    %eax
  80328d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803292:	e9 a9 00 00 00       	jmp    803340 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803297:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80329b:	74 06                	je     8032a3 <insert_sorted_with_merge_freeList+0x6ac>
  80329d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a1:	75 17                	jne    8032ba <insert_sorted_with_merge_freeList+0x6c3>
  8032a3:	83 ec 04             	sub    $0x4,%esp
  8032a6:	68 5c 40 80 00       	push   $0x80405c
  8032ab:	68 73 01 00 00       	push   $0x173
  8032b0:	68 e7 3f 80 00       	push   $0x803fe7
  8032b5:	e8 03 d0 ff ff       	call   8002bd <_panic>
  8032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bd:	8b 10                	mov    (%eax),%edx
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	89 10                	mov    %edx,(%eax)
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	8b 00                	mov    (%eax),%eax
  8032c9:	85 c0                	test   %eax,%eax
  8032cb:	74 0b                	je     8032d8 <insert_sorted_with_merge_freeList+0x6e1>
  8032cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d0:	8b 00                	mov    (%eax),%eax
  8032d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d5:	89 50 04             	mov    %edx,0x4(%eax)
  8032d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032db:	8b 55 08             	mov    0x8(%ebp),%edx
  8032de:	89 10                	mov    %edx,(%eax)
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e6:	89 50 04             	mov    %edx,0x4(%eax)
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	8b 00                	mov    (%eax),%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	75 08                	jne    8032fa <insert_sorted_with_merge_freeList+0x703>
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ff:	40                   	inc    %eax
  803300:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803305:	eb 39                	jmp    803340 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803307:	a1 40 51 80 00       	mov    0x805140,%eax
  80330c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80330f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803313:	74 07                	je     80331c <insert_sorted_with_merge_freeList+0x725>
  803315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	eb 05                	jmp    803321 <insert_sorted_with_merge_freeList+0x72a>
  80331c:	b8 00 00 00 00       	mov    $0x0,%eax
  803321:	a3 40 51 80 00       	mov    %eax,0x805140
  803326:	a1 40 51 80 00       	mov    0x805140,%eax
  80332b:	85 c0                	test   %eax,%eax
  80332d:	0f 85 c7 fb ff ff    	jne    802efa <insert_sorted_with_merge_freeList+0x303>
  803333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803337:	0f 85 bd fb ff ff    	jne    802efa <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80333d:	eb 01                	jmp    803340 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80333f:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803340:	90                   	nop
  803341:	c9                   	leave  
  803342:	c3                   	ret    

00803343 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803343:	55                   	push   %ebp
  803344:	89 e5                	mov    %esp,%ebp
  803346:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803349:	8b 55 08             	mov    0x8(%ebp),%edx
  80334c:	89 d0                	mov    %edx,%eax
  80334e:	c1 e0 02             	shl    $0x2,%eax
  803351:	01 d0                	add    %edx,%eax
  803353:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80335a:	01 d0                	add    %edx,%eax
  80335c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803363:	01 d0                	add    %edx,%eax
  803365:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80336c:	01 d0                	add    %edx,%eax
  80336e:	c1 e0 04             	shl    $0x4,%eax
  803371:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803374:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80337b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80337e:	83 ec 0c             	sub    $0xc,%esp
  803381:	50                   	push   %eax
  803382:	e8 26 e7 ff ff       	call   801aad <sys_get_virtual_time>
  803387:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80338a:	eb 41                	jmp    8033cd <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80338c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80338f:	83 ec 0c             	sub    $0xc,%esp
  803392:	50                   	push   %eax
  803393:	e8 15 e7 ff ff       	call   801aad <sys_get_virtual_time>
  803398:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80339b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80339e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a1:	29 c2                	sub    %eax,%edx
  8033a3:	89 d0                	mov    %edx,%eax
  8033a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ae:	89 d1                	mov    %edx,%ecx
  8033b0:	29 c1                	sub    %eax,%ecx
  8033b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b8:	39 c2                	cmp    %eax,%edx
  8033ba:	0f 97 c0             	seta   %al
  8033bd:	0f b6 c0             	movzbl %al,%eax
  8033c0:	29 c1                	sub    %eax,%ecx
  8033c2:	89 c8                	mov    %ecx,%eax
  8033c4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033d3:	72 b7                	jb     80338c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033d5:	90                   	nop
  8033d6:	c9                   	leave  
  8033d7:	c3                   	ret    

008033d8 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033d8:	55                   	push   %ebp
  8033d9:	89 e5                	mov    %esp,%ebp
  8033db:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033e5:	eb 03                	jmp    8033ea <busy_wait+0x12>
  8033e7:	ff 45 fc             	incl   -0x4(%ebp)
  8033ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033f0:	72 f5                	jb     8033e7 <busy_wait+0xf>
	return i;
  8033f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033f5:	c9                   	leave  
  8033f6:	c3                   	ret    
  8033f7:	90                   	nop

008033f8 <__udivdi3>:
  8033f8:	55                   	push   %ebp
  8033f9:	57                   	push   %edi
  8033fa:	56                   	push   %esi
  8033fb:	53                   	push   %ebx
  8033fc:	83 ec 1c             	sub    $0x1c,%esp
  8033ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803403:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803407:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80340b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80340f:	89 ca                	mov    %ecx,%edx
  803411:	89 f8                	mov    %edi,%eax
  803413:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803417:	85 f6                	test   %esi,%esi
  803419:	75 2d                	jne    803448 <__udivdi3+0x50>
  80341b:	39 cf                	cmp    %ecx,%edi
  80341d:	77 65                	ja     803484 <__udivdi3+0x8c>
  80341f:	89 fd                	mov    %edi,%ebp
  803421:	85 ff                	test   %edi,%edi
  803423:	75 0b                	jne    803430 <__udivdi3+0x38>
  803425:	b8 01 00 00 00       	mov    $0x1,%eax
  80342a:	31 d2                	xor    %edx,%edx
  80342c:	f7 f7                	div    %edi
  80342e:	89 c5                	mov    %eax,%ebp
  803430:	31 d2                	xor    %edx,%edx
  803432:	89 c8                	mov    %ecx,%eax
  803434:	f7 f5                	div    %ebp
  803436:	89 c1                	mov    %eax,%ecx
  803438:	89 d8                	mov    %ebx,%eax
  80343a:	f7 f5                	div    %ebp
  80343c:	89 cf                	mov    %ecx,%edi
  80343e:	89 fa                	mov    %edi,%edx
  803440:	83 c4 1c             	add    $0x1c,%esp
  803443:	5b                   	pop    %ebx
  803444:	5e                   	pop    %esi
  803445:	5f                   	pop    %edi
  803446:	5d                   	pop    %ebp
  803447:	c3                   	ret    
  803448:	39 ce                	cmp    %ecx,%esi
  80344a:	77 28                	ja     803474 <__udivdi3+0x7c>
  80344c:	0f bd fe             	bsr    %esi,%edi
  80344f:	83 f7 1f             	xor    $0x1f,%edi
  803452:	75 40                	jne    803494 <__udivdi3+0x9c>
  803454:	39 ce                	cmp    %ecx,%esi
  803456:	72 0a                	jb     803462 <__udivdi3+0x6a>
  803458:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80345c:	0f 87 9e 00 00 00    	ja     803500 <__udivdi3+0x108>
  803462:	b8 01 00 00 00       	mov    $0x1,%eax
  803467:	89 fa                	mov    %edi,%edx
  803469:	83 c4 1c             	add    $0x1c,%esp
  80346c:	5b                   	pop    %ebx
  80346d:	5e                   	pop    %esi
  80346e:	5f                   	pop    %edi
  80346f:	5d                   	pop    %ebp
  803470:	c3                   	ret    
  803471:	8d 76 00             	lea    0x0(%esi),%esi
  803474:	31 ff                	xor    %edi,%edi
  803476:	31 c0                	xor    %eax,%eax
  803478:	89 fa                	mov    %edi,%edx
  80347a:	83 c4 1c             	add    $0x1c,%esp
  80347d:	5b                   	pop    %ebx
  80347e:	5e                   	pop    %esi
  80347f:	5f                   	pop    %edi
  803480:	5d                   	pop    %ebp
  803481:	c3                   	ret    
  803482:	66 90                	xchg   %ax,%ax
  803484:	89 d8                	mov    %ebx,%eax
  803486:	f7 f7                	div    %edi
  803488:	31 ff                	xor    %edi,%edi
  80348a:	89 fa                	mov    %edi,%edx
  80348c:	83 c4 1c             	add    $0x1c,%esp
  80348f:	5b                   	pop    %ebx
  803490:	5e                   	pop    %esi
  803491:	5f                   	pop    %edi
  803492:	5d                   	pop    %ebp
  803493:	c3                   	ret    
  803494:	bd 20 00 00 00       	mov    $0x20,%ebp
  803499:	89 eb                	mov    %ebp,%ebx
  80349b:	29 fb                	sub    %edi,%ebx
  80349d:	89 f9                	mov    %edi,%ecx
  80349f:	d3 e6                	shl    %cl,%esi
  8034a1:	89 c5                	mov    %eax,%ebp
  8034a3:	88 d9                	mov    %bl,%cl
  8034a5:	d3 ed                	shr    %cl,%ebp
  8034a7:	89 e9                	mov    %ebp,%ecx
  8034a9:	09 f1                	or     %esi,%ecx
  8034ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034af:	89 f9                	mov    %edi,%ecx
  8034b1:	d3 e0                	shl    %cl,%eax
  8034b3:	89 c5                	mov    %eax,%ebp
  8034b5:	89 d6                	mov    %edx,%esi
  8034b7:	88 d9                	mov    %bl,%cl
  8034b9:	d3 ee                	shr    %cl,%esi
  8034bb:	89 f9                	mov    %edi,%ecx
  8034bd:	d3 e2                	shl    %cl,%edx
  8034bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034c3:	88 d9                	mov    %bl,%cl
  8034c5:	d3 e8                	shr    %cl,%eax
  8034c7:	09 c2                	or     %eax,%edx
  8034c9:	89 d0                	mov    %edx,%eax
  8034cb:	89 f2                	mov    %esi,%edx
  8034cd:	f7 74 24 0c          	divl   0xc(%esp)
  8034d1:	89 d6                	mov    %edx,%esi
  8034d3:	89 c3                	mov    %eax,%ebx
  8034d5:	f7 e5                	mul    %ebp
  8034d7:	39 d6                	cmp    %edx,%esi
  8034d9:	72 19                	jb     8034f4 <__udivdi3+0xfc>
  8034db:	74 0b                	je     8034e8 <__udivdi3+0xf0>
  8034dd:	89 d8                	mov    %ebx,%eax
  8034df:	31 ff                	xor    %edi,%edi
  8034e1:	e9 58 ff ff ff       	jmp    80343e <__udivdi3+0x46>
  8034e6:	66 90                	xchg   %ax,%ax
  8034e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034ec:	89 f9                	mov    %edi,%ecx
  8034ee:	d3 e2                	shl    %cl,%edx
  8034f0:	39 c2                	cmp    %eax,%edx
  8034f2:	73 e9                	jae    8034dd <__udivdi3+0xe5>
  8034f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034f7:	31 ff                	xor    %edi,%edi
  8034f9:	e9 40 ff ff ff       	jmp    80343e <__udivdi3+0x46>
  8034fe:	66 90                	xchg   %ax,%ax
  803500:	31 c0                	xor    %eax,%eax
  803502:	e9 37 ff ff ff       	jmp    80343e <__udivdi3+0x46>
  803507:	90                   	nop

00803508 <__umoddi3>:
  803508:	55                   	push   %ebp
  803509:	57                   	push   %edi
  80350a:	56                   	push   %esi
  80350b:	53                   	push   %ebx
  80350c:	83 ec 1c             	sub    $0x1c,%esp
  80350f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803513:	8b 74 24 34          	mov    0x34(%esp),%esi
  803517:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80351b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80351f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803523:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803527:	89 f3                	mov    %esi,%ebx
  803529:	89 fa                	mov    %edi,%edx
  80352b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80352f:	89 34 24             	mov    %esi,(%esp)
  803532:	85 c0                	test   %eax,%eax
  803534:	75 1a                	jne    803550 <__umoddi3+0x48>
  803536:	39 f7                	cmp    %esi,%edi
  803538:	0f 86 a2 00 00 00    	jbe    8035e0 <__umoddi3+0xd8>
  80353e:	89 c8                	mov    %ecx,%eax
  803540:	89 f2                	mov    %esi,%edx
  803542:	f7 f7                	div    %edi
  803544:	89 d0                	mov    %edx,%eax
  803546:	31 d2                	xor    %edx,%edx
  803548:	83 c4 1c             	add    $0x1c,%esp
  80354b:	5b                   	pop    %ebx
  80354c:	5e                   	pop    %esi
  80354d:	5f                   	pop    %edi
  80354e:	5d                   	pop    %ebp
  80354f:	c3                   	ret    
  803550:	39 f0                	cmp    %esi,%eax
  803552:	0f 87 ac 00 00 00    	ja     803604 <__umoddi3+0xfc>
  803558:	0f bd e8             	bsr    %eax,%ebp
  80355b:	83 f5 1f             	xor    $0x1f,%ebp
  80355e:	0f 84 ac 00 00 00    	je     803610 <__umoddi3+0x108>
  803564:	bf 20 00 00 00       	mov    $0x20,%edi
  803569:	29 ef                	sub    %ebp,%edi
  80356b:	89 fe                	mov    %edi,%esi
  80356d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803571:	89 e9                	mov    %ebp,%ecx
  803573:	d3 e0                	shl    %cl,%eax
  803575:	89 d7                	mov    %edx,%edi
  803577:	89 f1                	mov    %esi,%ecx
  803579:	d3 ef                	shr    %cl,%edi
  80357b:	09 c7                	or     %eax,%edi
  80357d:	89 e9                	mov    %ebp,%ecx
  80357f:	d3 e2                	shl    %cl,%edx
  803581:	89 14 24             	mov    %edx,(%esp)
  803584:	89 d8                	mov    %ebx,%eax
  803586:	d3 e0                	shl    %cl,%eax
  803588:	89 c2                	mov    %eax,%edx
  80358a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80358e:	d3 e0                	shl    %cl,%eax
  803590:	89 44 24 04          	mov    %eax,0x4(%esp)
  803594:	8b 44 24 08          	mov    0x8(%esp),%eax
  803598:	89 f1                	mov    %esi,%ecx
  80359a:	d3 e8                	shr    %cl,%eax
  80359c:	09 d0                	or     %edx,%eax
  80359e:	d3 eb                	shr    %cl,%ebx
  8035a0:	89 da                	mov    %ebx,%edx
  8035a2:	f7 f7                	div    %edi
  8035a4:	89 d3                	mov    %edx,%ebx
  8035a6:	f7 24 24             	mull   (%esp)
  8035a9:	89 c6                	mov    %eax,%esi
  8035ab:	89 d1                	mov    %edx,%ecx
  8035ad:	39 d3                	cmp    %edx,%ebx
  8035af:	0f 82 87 00 00 00    	jb     80363c <__umoddi3+0x134>
  8035b5:	0f 84 91 00 00 00    	je     80364c <__umoddi3+0x144>
  8035bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035bf:	29 f2                	sub    %esi,%edx
  8035c1:	19 cb                	sbb    %ecx,%ebx
  8035c3:	89 d8                	mov    %ebx,%eax
  8035c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035c9:	d3 e0                	shl    %cl,%eax
  8035cb:	89 e9                	mov    %ebp,%ecx
  8035cd:	d3 ea                	shr    %cl,%edx
  8035cf:	09 d0                	or     %edx,%eax
  8035d1:	89 e9                	mov    %ebp,%ecx
  8035d3:	d3 eb                	shr    %cl,%ebx
  8035d5:	89 da                	mov    %ebx,%edx
  8035d7:	83 c4 1c             	add    $0x1c,%esp
  8035da:	5b                   	pop    %ebx
  8035db:	5e                   	pop    %esi
  8035dc:	5f                   	pop    %edi
  8035dd:	5d                   	pop    %ebp
  8035de:	c3                   	ret    
  8035df:	90                   	nop
  8035e0:	89 fd                	mov    %edi,%ebp
  8035e2:	85 ff                	test   %edi,%edi
  8035e4:	75 0b                	jne    8035f1 <__umoddi3+0xe9>
  8035e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035eb:	31 d2                	xor    %edx,%edx
  8035ed:	f7 f7                	div    %edi
  8035ef:	89 c5                	mov    %eax,%ebp
  8035f1:	89 f0                	mov    %esi,%eax
  8035f3:	31 d2                	xor    %edx,%edx
  8035f5:	f7 f5                	div    %ebp
  8035f7:	89 c8                	mov    %ecx,%eax
  8035f9:	f7 f5                	div    %ebp
  8035fb:	89 d0                	mov    %edx,%eax
  8035fd:	e9 44 ff ff ff       	jmp    803546 <__umoddi3+0x3e>
  803602:	66 90                	xchg   %ax,%ax
  803604:	89 c8                	mov    %ecx,%eax
  803606:	89 f2                	mov    %esi,%edx
  803608:	83 c4 1c             	add    $0x1c,%esp
  80360b:	5b                   	pop    %ebx
  80360c:	5e                   	pop    %esi
  80360d:	5f                   	pop    %edi
  80360e:	5d                   	pop    %ebp
  80360f:	c3                   	ret    
  803610:	3b 04 24             	cmp    (%esp),%eax
  803613:	72 06                	jb     80361b <__umoddi3+0x113>
  803615:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803619:	77 0f                	ja     80362a <__umoddi3+0x122>
  80361b:	89 f2                	mov    %esi,%edx
  80361d:	29 f9                	sub    %edi,%ecx
  80361f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803623:	89 14 24             	mov    %edx,(%esp)
  803626:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80362a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80362e:	8b 14 24             	mov    (%esp),%edx
  803631:	83 c4 1c             	add    $0x1c,%esp
  803634:	5b                   	pop    %ebx
  803635:	5e                   	pop    %esi
  803636:	5f                   	pop    %edi
  803637:	5d                   	pop    %ebp
  803638:	c3                   	ret    
  803639:	8d 76 00             	lea    0x0(%esi),%esi
  80363c:	2b 04 24             	sub    (%esp),%eax
  80363f:	19 fa                	sbb    %edi,%edx
  803641:	89 d1                	mov    %edx,%ecx
  803643:	89 c6                	mov    %eax,%esi
  803645:	e9 71 ff ff ff       	jmp    8035bb <__umoddi3+0xb3>
  80364a:	66 90                	xchg   %ax,%ax
  80364c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803650:	72 ea                	jb     80363c <__umoddi3+0x134>
  803652:	89 d9                	mov    %ebx,%ecx
  803654:	e9 62 ff ff ff       	jmp    8035bb <__umoddi3+0xb3>
