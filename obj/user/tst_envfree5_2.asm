
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
  800045:	68 00 38 80 00       	push   $0x803800
  80004a:	e8 f5 15 00 00       	call   801644 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 b3 18 00 00       	call   801916 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 4b 19 00 00       	call   8019b6 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 10 38 80 00       	push   $0x803810
  800079:	e8 f3 04 00 00       	call   800571 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 43 38 80 00       	push   $0x803843
  80008f:	e8 f4 1a 00 00       	call   801b88 <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 4c 38 80 00       	push   $0x80384c
  8000a8:	e8 db 1a 00 00       	call   801b88 <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 e8 1a 00 00       	call   801ba6 <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 0a 34 00 00       	call   8034d8 <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 ca 1a 00 00       	call   801ba6 <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 27 18 00 00       	call   801916 <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 58 38 80 00       	push   $0x803858
  8000f8:	e8 74 04 00 00       	call   800571 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 b7 1a 00 00       	call   801bc2 <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 a9 1a 00 00       	call   801bc2 <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 f5 17 00 00       	call   801916 <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 8d 18 00 00       	call   8019b6 <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 8c 38 80 00       	push   $0x80388c
  80013f:	e8 2d 04 00 00       	call   800571 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 dc 38 80 00       	push   $0x8038dc
  80014f:	6a 23                	push   $0x23
  800151:	68 12 39 80 00       	push   $0x803912
  800156:	e8 62 01 00 00       	call   8002bd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 28 39 80 00       	push   $0x803928
  800166:	e8 06 04 00 00       	call   800571 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 88 39 80 00       	push   $0x803988
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
  800187:	e8 6a 1a 00 00       	call   801bf6 <sys_getenvindex>
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
  8001f2:	e8 0c 18 00 00       	call   801a03 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 ec 39 80 00       	push   $0x8039ec
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
  800222:	68 14 3a 80 00       	push   $0x803a14
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
  800253:	68 3c 3a 80 00       	push   $0x803a3c
  800258:	e8 14 03 00 00       	call   800571 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 94 3a 80 00       	push   $0x803a94
  800274:	e8 f8 02 00 00       	call   800571 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 ec 39 80 00       	push   $0x8039ec
  800284:	e8 e8 02 00 00       	call   800571 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80028c:	e8 8c 17 00 00       	call   801a1d <sys_enable_interrupt>

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
  8002a4:	e8 19 19 00 00       	call   801bc2 <sys_destroy_env>
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
  8002b5:	e8 6e 19 00 00       	call   801c28 <sys_exit_env>
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
  8002de:	68 a8 3a 80 00       	push   $0x803aa8
  8002e3:	e8 89 02 00 00       	call   800571 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002eb:	a1 00 50 80 00       	mov    0x805000,%eax
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	68 ad 3a 80 00       	push   $0x803aad
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
  80031b:	68 c9 3a 80 00       	push   $0x803ac9
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
  800347:	68 cc 3a 80 00       	push   $0x803acc
  80034c:	6a 26                	push   $0x26
  80034e:	68 18 3b 80 00       	push   $0x803b18
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
  800419:	68 24 3b 80 00       	push   $0x803b24
  80041e:	6a 3a                	push   $0x3a
  800420:	68 18 3b 80 00       	push   $0x803b18
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
  800489:	68 78 3b 80 00       	push   $0x803b78
  80048e:	6a 44                	push   $0x44
  800490:	68 18 3b 80 00       	push   $0x803b18
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
  8004e3:	e8 6d 13 00 00       	call   801855 <sys_cputs>
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
  80055a:	e8 f6 12 00 00       	call   801855 <sys_cputs>
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
  8005a4:	e8 5a 14 00 00       	call   801a03 <sys_disable_interrupt>
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
  8005c4:	e8 54 14 00 00       	call   801a1d <sys_enable_interrupt>
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
  80060e:	e8 79 2f 00 00       	call   80358c <__udivdi3>
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
  80065e:	e8 39 30 00 00       	call   80369c <__umoddi3>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	05 f4 3d 80 00       	add    $0x803df4,%eax
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
  8007b9:	8b 04 85 18 3e 80 00 	mov    0x803e18(,%eax,4),%eax
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
  80089a:	8b 34 9d 60 3c 80 00 	mov    0x803c60(,%ebx,4),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 19                	jne    8008be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a5:	53                   	push   %ebx
  8008a6:	68 05 3e 80 00       	push   $0x803e05
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
  8008bf:	68 0e 3e 80 00       	push   $0x803e0e
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
  8008ec:	be 11 3e 80 00       	mov    $0x803e11,%esi
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
  801312:	68 70 3f 80 00       	push   $0x803f70
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
  8013e2:	e8 b2 05 00 00       	call   801999 <sys_allocate_chunk>
  8013e7:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ea:	a1 20 51 80 00       	mov    0x805120,%eax
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	50                   	push   %eax
  8013f3:	e8 27 0c 00 00       	call   80201f <initialize_MemBlocksList>
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
  801420:	68 95 3f 80 00       	push   $0x803f95
  801425:	6a 33                	push   $0x33
  801427:	68 b3 3f 80 00       	push   $0x803fb3
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
  80149f:	68 c0 3f 80 00       	push   $0x803fc0
  8014a4:	6a 34                	push   $0x34
  8014a6:	68 b3 3f 80 00       	push   $0x803fb3
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
  8014fc:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014ff:	e8 f7 fd ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  801504:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801508:	75 07                	jne    801511 <malloc+0x18>
  80150a:	b8 00 00 00 00       	mov    $0x0,%eax
  80150f:	eb 61                	jmp    801572 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801511:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801518:	8b 55 08             	mov    0x8(%ebp),%edx
  80151b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151e:	01 d0                	add    %edx,%eax
  801520:	48                   	dec    %eax
  801521:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801527:	ba 00 00 00 00       	mov    $0x0,%edx
  80152c:	f7 75 f0             	divl   -0x10(%ebp)
  80152f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801532:	29 d0                	sub    %edx,%eax
  801534:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801537:	e8 2b 08 00 00       	call   801d67 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80153c:	85 c0                	test   %eax,%eax
  80153e:	74 11                	je     801551 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801540:	83 ec 0c             	sub    $0xc,%esp
  801543:	ff 75 e8             	pushl  -0x18(%ebp)
  801546:	e8 96 0e 00 00       	call   8023e1 <alloc_block_FF>
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801555:	74 16                	je     80156d <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801557:	83 ec 0c             	sub    $0xc,%esp
  80155a:	ff 75 f4             	pushl  -0xc(%ebp)
  80155d:	e8 f2 0b 00 00       	call   802154 <insert_sorted_allocList>
  801562:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801568:	8b 40 08             	mov    0x8(%eax),%eax
  80156b:	eb 05                	jmp    801572 <malloc+0x79>
	}

    return NULL;
  80156d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	83 ec 08             	sub    $0x8,%esp
  801580:	50                   	push   %eax
  801581:	68 40 50 80 00       	push   $0x805040
  801586:	e8 71 0b 00 00       	call   8020fc <find_block>
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801595:	0f 84 a6 00 00 00    	je     801641 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  80159b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159e:	8b 50 0c             	mov    0xc(%eax),%edx
  8015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a4:	8b 40 08             	mov    0x8(%eax),%eax
  8015a7:	83 ec 08             	sub    $0x8,%esp
  8015aa:	52                   	push   %edx
  8015ab:	50                   	push   %eax
  8015ac:	e8 b0 03 00 00       	call   801961 <sys_free_user_mem>
  8015b1:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8015b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015b8:	75 14                	jne    8015ce <free+0x5a>
  8015ba:	83 ec 04             	sub    $0x4,%esp
  8015bd:	68 95 3f 80 00       	push   $0x803f95
  8015c2:	6a 74                	push   $0x74
  8015c4:	68 b3 3f 80 00       	push   $0x803fb3
  8015c9:	e8 ef ec ff ff       	call   8002bd <_panic>
  8015ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d1:	8b 00                	mov    (%eax),%eax
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	74 10                	je     8015e7 <free+0x73>
  8015d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015da:	8b 00                	mov    (%eax),%eax
  8015dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015df:	8b 52 04             	mov    0x4(%edx),%edx
  8015e2:	89 50 04             	mov    %edx,0x4(%eax)
  8015e5:	eb 0b                	jmp    8015f2 <free+0x7e>
  8015e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ea:	8b 40 04             	mov    0x4(%eax),%eax
  8015ed:	a3 44 50 80 00       	mov    %eax,0x805044
  8015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f5:	8b 40 04             	mov    0x4(%eax),%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 0f                	je     80160b <free+0x97>
  8015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ff:	8b 40 04             	mov    0x4(%eax),%eax
  801602:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801605:	8b 12                	mov    (%edx),%edx
  801607:	89 10                	mov    %edx,(%eax)
  801609:	eb 0a                	jmp    801615 <free+0xa1>
  80160b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160e:	8b 00                	mov    (%eax),%eax
  801610:	a3 40 50 80 00       	mov    %eax,0x805040
  801615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801618:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80161e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801621:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801628:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80162d:	48                   	dec    %eax
  80162e:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	ff 75 f4             	pushl  -0xc(%ebp)
  801639:	e8 4e 17 00 00       	call   802d8c <insert_sorted_with_merge_freeList>
  80163e:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	83 ec 08             	sub    $0x8,%esp
  801580:	50                   	push   %eax
  801581:	68 40 50 80 00       	push   $0x805040
  801586:	e8 71 0b 00 00       	call   8020fc <find_block>
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  801591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801595:	0f 84 a6 00 00 00    	je     801641 <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  80159b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159e:	8b 50 0c             	mov    0xc(%eax),%edx
  8015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a4:	8b 40 08             	mov    0x8(%eax),%eax
  8015a7:	83 ec 08             	sub    $0x8,%esp
  8015aa:	52                   	push   %edx
  8015ab:	50                   	push   %eax
  8015ac:	e8 b0 03 00 00       	call   801961 <sys_free_user_mem>
  8015b1:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  8015b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015b8:	75 14                	jne    8015ce <free+0x5a>
  8015ba:	83 ec 04             	sub    $0x4,%esp
  8015bd:	68 95 3f 80 00       	push   $0x803f95
  8015c2:	6a 7a                	push   $0x7a
  8015c4:	68 b3 3f 80 00       	push   $0x803fb3
  8015c9:	e8 ef ec ff ff       	call   8002bd <_panic>
  8015ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d1:	8b 00                	mov    (%eax),%eax
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	74 10                	je     8015e7 <free+0x73>
  8015d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015da:	8b 00                	mov    (%eax),%eax
  8015dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015df:	8b 52 04             	mov    0x4(%edx),%edx
  8015e2:	89 50 04             	mov    %edx,0x4(%eax)
  8015e5:	eb 0b                	jmp    8015f2 <free+0x7e>
  8015e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ea:	8b 40 04             	mov    0x4(%eax),%eax
  8015ed:	a3 44 50 80 00       	mov    %eax,0x805044
  8015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f5:	8b 40 04             	mov    0x4(%eax),%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 0f                	je     80160b <free+0x97>
  8015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ff:	8b 40 04             	mov    0x4(%eax),%eax
  801602:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801605:	8b 12                	mov    (%edx),%edx
  801607:	89 10                	mov    %edx,(%eax)
  801609:	eb 0a                	jmp    801615 <free+0xa1>
  80160b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160e:	8b 00                	mov    (%eax),%eax
  801610:	a3 40 50 80 00       	mov    %eax,0x805040
  801615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801618:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80161e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801621:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801628:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80162d:	48                   	dec    %eax
  80162e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	ff 75 f4             	pushl  -0xc(%ebp)
  801639:	e8 4e 17 00 00       	call   802d8c <insert_sorted_with_merge_freeList>
  80163e:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  801641:	90                   	nop
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	83 ec 38             	sub    $0x38,%esp
  80164a:	8b 45 10             	mov    0x10(%ebp),%eax
  80164d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801650:	e8 a6 fc ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  801655:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801659:	75 0a                	jne    801665 <smalloc+0x21>
  80165b:	b8 00 00 00 00       	mov    $0x0,%eax
  801660:	e9 8b 00 00 00       	jmp    8016f0 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801665:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80166c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801672:	01 d0                	add    %edx,%eax
  801674:	48                   	dec    %eax
  801675:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167b:	ba 00 00 00 00       	mov    $0x0,%edx
  801680:	f7 75 f0             	divl   -0x10(%ebp)
  801683:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801686:	29 d0                	sub    %edx,%eax
  801688:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80168b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801692:	e8 d0 06 00 00       	call   801d67 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801697:	85 c0                	test   %eax,%eax
  801699:	74 11                	je     8016ac <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80169b:	83 ec 0c             	sub    $0xc,%esp
  80169e:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a1:	e8 3b 0d 00 00       	call   8023e1 <alloc_block_FF>
  8016a6:	83 c4 10             	add    $0x10,%esp
  8016a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8016ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016b0:	74 39                	je     8016eb <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b5:	8b 40 08             	mov    0x8(%eax),%eax
  8016b8:	89 c2                	mov    %eax,%edx
  8016ba:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016be:	52                   	push   %edx
  8016bf:	50                   	push   %eax
  8016c0:	ff 75 0c             	pushl  0xc(%ebp)
  8016c3:	ff 75 08             	pushl  0x8(%ebp)
  8016c6:	e8 21 04 00 00       	call   801aec <sys_createSharedObject>
  8016cb:	83 c4 10             	add    $0x10,%esp
  8016ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016d1:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016d5:	74 14                	je     8016eb <smalloc+0xa7>
  8016d7:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016db:	74 0e                	je     8016eb <smalloc+0xa7>
  8016dd:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016e1:	74 08                	je     8016eb <smalloc+0xa7>
			return (void*) mem_block->sva;
  8016e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e6:	8b 40 08             	mov    0x8(%eax),%eax
  8016e9:	eb 05                	jmp    8016f0 <smalloc+0xac>
	}
	return NULL;
  8016eb:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016f8:	e8 fe fb ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016fd:	83 ec 08             	sub    $0x8,%esp
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	ff 75 08             	pushl  0x8(%ebp)
  801706:	e8 0b 04 00 00       	call   801b16 <sys_getSizeOfSharedObject>
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801711:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801715:	74 76                	je     80178d <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801717:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80171e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801724:	01 d0                	add    %edx,%eax
  801726:	48                   	dec    %eax
  801727:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80172a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80172d:	ba 00 00 00 00       	mov    $0x0,%edx
  801732:	f7 75 ec             	divl   -0x14(%ebp)
  801735:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801738:	29 d0                	sub    %edx,%eax
  80173a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80173d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801744:	e8 1e 06 00 00       	call   801d67 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801749:	85 c0                	test   %eax,%eax
  80174b:	74 11                	je     80175e <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80174d:	83 ec 0c             	sub    $0xc,%esp
  801750:	ff 75 e4             	pushl  -0x1c(%ebp)
  801753:	e8 89 0c 00 00       	call   8023e1 <alloc_block_FF>
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80175e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801762:	74 29                	je     80178d <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801767:	8b 40 08             	mov    0x8(%eax),%eax
  80176a:	83 ec 04             	sub    $0x4,%esp
  80176d:	50                   	push   %eax
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	ff 75 08             	pushl  0x8(%ebp)
  801774:	e8 ba 03 00 00       	call   801b33 <sys_getSharedObject>
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80177f:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801783:	74 08                	je     80178d <sget+0x9b>
				return (void *)mem_block->sva;
  801785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801788:	8b 40 08             	mov    0x8(%eax),%eax
  80178b:	eb 05                	jmp    801792 <sget+0xa0>
		}
	}
	return NULL;
  80178d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80179a:	e8 5c fb ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80179f:	83 ec 04             	sub    $0x4,%esp
  8017a2:	68 e4 3f 80 00       	push   $0x803fe4
<<<<<<< HEAD
  8017a7:	68 fc 00 00 00       	push   $0xfc
=======
  8017a7:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8017ac:	68 b3 3f 80 00       	push   $0x803fb3
  8017b1:	e8 07 eb ff ff       	call   8002bd <_panic>

008017b6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017bc:	83 ec 04             	sub    $0x4,%esp
  8017bf:	68 0c 40 80 00       	push   $0x80400c
<<<<<<< HEAD
  8017c4:	68 10 01 00 00       	push   $0x110
=======
  8017c4:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8017c9:	68 b3 3f 80 00       	push   $0x803fb3
  8017ce:	e8 ea ea ff ff       	call   8002bd <_panic>

008017d3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	68 30 40 80 00       	push   $0x804030
<<<<<<< HEAD
  8017e1:	68 1b 01 00 00       	push   $0x11b
=======
  8017e1:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8017e6:	68 b3 3f 80 00       	push   $0x803fb3
  8017eb:	e8 cd ea ff ff       	call   8002bd <_panic>

008017f0 <shrink>:

}
void shrink(uint32 newSize)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	68 30 40 80 00       	push   $0x804030
<<<<<<< HEAD
  8017fe:	68 20 01 00 00       	push   $0x120
=======
  8017fe:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801803:	68 b3 3f 80 00       	push   $0x803fb3
  801808:	e8 b0 ea ff ff       	call   8002bd <_panic>

0080180d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801813:	83 ec 04             	sub    $0x4,%esp
  801816:	68 30 40 80 00       	push   $0x804030
<<<<<<< HEAD
  80181b:	68 25 01 00 00       	push   $0x125
=======
  80181b:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801820:	68 b3 3f 80 00       	push   $0x803fb3
  801825:	e8 93 ea ff ff       	call   8002bd <_panic>

0080182a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	57                   	push   %edi
  80182e:	56                   	push   %esi
  80182f:	53                   	push   %ebx
  801830:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	8b 55 0c             	mov    0xc(%ebp),%edx
  801839:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80183c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80183f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801842:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801845:	cd 30                	int    $0x30
  801847:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80184a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80184d:	83 c4 10             	add    $0x10,%esp
  801850:	5b                   	pop    %ebx
  801851:	5e                   	pop    %esi
  801852:	5f                   	pop    %edi
  801853:	5d                   	pop    %ebp
  801854:	c3                   	ret    

00801855 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 04             	sub    $0x4,%esp
  80185b:	8b 45 10             	mov    0x10(%ebp),%eax
  80185e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801861:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	52                   	push   %edx
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	50                   	push   %eax
  801871:	6a 00                	push   $0x0
  801873:	e8 b2 ff ff ff       	call   80182a <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	90                   	nop
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_cgetc>:

int
sys_cgetc(void)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 01                	push   $0x1
  80188d:	e8 98 ff ff ff       	call   80182a <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80189a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	52                   	push   %edx
  8018a7:	50                   	push   %eax
  8018a8:	6a 05                	push   $0x5
  8018aa:	e8 7b ff ff ff       	call   80182a <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	56                   	push   %esi
  8018b8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b9:	8b 75 18             	mov    0x18(%ebp),%esi
  8018bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	56                   	push   %esi
  8018c9:	53                   	push   %ebx
  8018ca:	51                   	push   %ecx
  8018cb:	52                   	push   %edx
  8018cc:	50                   	push   %eax
  8018cd:	6a 06                	push   $0x6
  8018cf:	e8 56 ff ff ff       	call   80182a <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018da:	5b                   	pop    %ebx
  8018db:	5e                   	pop    %esi
  8018dc:	5d                   	pop    %ebp
  8018dd:	c3                   	ret    

008018de <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	52                   	push   %edx
  8018ee:	50                   	push   %eax
  8018ef:	6a 07                	push   $0x7
  8018f1:	e8 34 ff ff ff       	call   80182a <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	ff 75 08             	pushl  0x8(%ebp)
  80190a:	6a 08                	push   $0x8
  80190c:	e8 19 ff ff ff       	call   80182a <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 09                	push   $0x9
  801925:	e8 00 ff ff ff       	call   80182a <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 0a                	push   $0xa
  80193e:	e8 e7 fe ff ff       	call   80182a <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 0b                	push   $0xb
  801957:	e8 ce fe ff ff       	call   80182a <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	ff 75 08             	pushl  0x8(%ebp)
  801970:	6a 0f                	push   $0xf
  801972:	e8 b3 fe ff ff       	call   80182a <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
	return;
  80197a:	90                   	nop
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	ff 75 0c             	pushl  0xc(%ebp)
  801989:	ff 75 08             	pushl  0x8(%ebp)
  80198c:	6a 10                	push   $0x10
  80198e:	e8 97 fe ff ff       	call   80182a <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
	return ;
  801996:	90                   	nop
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	ff 75 10             	pushl  0x10(%ebp)
  8019a3:	ff 75 0c             	pushl  0xc(%ebp)
  8019a6:	ff 75 08             	pushl  0x8(%ebp)
  8019a9:	6a 11                	push   $0x11
  8019ab:	e8 7a fe ff ff       	call   80182a <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b3:	90                   	nop
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 0c                	push   $0xc
  8019c5:	e8 60 fe ff ff       	call   80182a <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	ff 75 08             	pushl  0x8(%ebp)
  8019dd:	6a 0d                	push   $0xd
  8019df:	e8 46 fe ff ff       	call   80182a <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 0e                	push   $0xe
  8019f8:	e8 2d fe ff ff       	call   80182a <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	90                   	nop
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 13                	push   $0x13
  801a12:	e8 13 fe ff ff       	call   80182a <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	90                   	nop
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 14                	push   $0x14
  801a2c:	e8 f9 fd ff ff       	call   80182a <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	90                   	nop
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a43:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	50                   	push   %eax
  801a50:	6a 15                	push   $0x15
  801a52:	e8 d3 fd ff ff       	call   80182a <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	90                   	nop
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 16                	push   $0x16
  801a6c:	e8 b9 fd ff ff       	call   80182a <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	90                   	nop
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	50                   	push   %eax
  801a87:	6a 17                	push   $0x17
  801a89:	e8 9c fd ff ff       	call   80182a <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	52                   	push   %edx
  801aa3:	50                   	push   %eax
  801aa4:	6a 1a                	push   $0x1a
  801aa6:	e8 7f fd ff ff       	call   80182a <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	52                   	push   %edx
  801ac0:	50                   	push   %eax
  801ac1:	6a 18                	push   $0x18
  801ac3:	e8 62 fd ff ff       	call   80182a <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	90                   	nop
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	52                   	push   %edx
  801ade:	50                   	push   %eax
  801adf:	6a 19                	push   $0x19
  801ae1:	e8 44 fd ff ff       	call   80182a <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	90                   	nop
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 04             	sub    $0x4,%esp
  801af2:	8b 45 10             	mov    0x10(%ebp),%eax
  801af5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801af8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801afb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	51                   	push   %ecx
  801b05:	52                   	push   %edx
  801b06:	ff 75 0c             	pushl  0xc(%ebp)
  801b09:	50                   	push   %eax
  801b0a:	6a 1b                	push   $0x1b
  801b0c:	e8 19 fd ff ff       	call   80182a <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	52                   	push   %edx
  801b26:	50                   	push   %eax
  801b27:	6a 1c                	push   $0x1c
  801b29:	e8 fc fc ff ff       	call   80182a <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b36:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	51                   	push   %ecx
  801b44:	52                   	push   %edx
  801b45:	50                   	push   %eax
  801b46:	6a 1d                	push   $0x1d
  801b48:	e8 dd fc ff ff       	call   80182a <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	6a 1e                	push   $0x1e
  801b65:	e8 c0 fc ff ff       	call   80182a <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 1f                	push   $0x1f
  801b7e:	e8 a7 fc ff ff       	call   80182a <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	6a 00                	push   $0x0
  801b90:	ff 75 14             	pushl  0x14(%ebp)
  801b93:	ff 75 10             	pushl  0x10(%ebp)
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	50                   	push   %eax
  801b9a:	6a 20                	push   $0x20
  801b9c:	e8 89 fc ff ff       	call   80182a <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	50                   	push   %eax
  801bb5:	6a 21                	push   $0x21
  801bb7:	e8 6e fc ff ff       	call   80182a <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	90                   	nop
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	50                   	push   %eax
  801bd1:	6a 22                	push   $0x22
  801bd3:	e8 52 fc ff ff       	call   80182a <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 02                	push   $0x2
  801bec:	e8 39 fc ff ff       	call   80182a <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 03                	push   $0x3
  801c05:	e8 20 fc ff ff       	call   80182a <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 04                	push   $0x4
  801c1e:	e8 07 fc ff ff       	call   80182a <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_exit_env>:


void sys_exit_env(void)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 23                	push   $0x23
  801c37:	e8 ee fb ff ff       	call   80182a <syscall>
  801c3c:	83 c4 18             	add    $0x18,%esp
}
  801c3f:	90                   	nop
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c48:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c4b:	8d 50 04             	lea    0x4(%eax),%edx
  801c4e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	52                   	push   %edx
  801c58:	50                   	push   %eax
  801c59:	6a 24                	push   $0x24
  801c5b:	e8 ca fb ff ff       	call   80182a <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
	return result;
  801c63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c69:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c6c:	89 01                	mov    %eax,(%ecx)
  801c6e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	c9                   	leave  
  801c75:	c2 04 00             	ret    $0x4

00801c78 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	ff 75 10             	pushl  0x10(%ebp)
  801c82:	ff 75 0c             	pushl  0xc(%ebp)
  801c85:	ff 75 08             	pushl  0x8(%ebp)
  801c88:	6a 12                	push   $0x12
  801c8a:	e8 9b fb ff ff       	call   80182a <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c92:	90                   	nop
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 25                	push   $0x25
  801ca4:	e8 81 fb ff ff       	call   80182a <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 04             	sub    $0x4,%esp
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cba:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	50                   	push   %eax
  801cc7:	6a 26                	push   $0x26
  801cc9:	e8 5c fb ff ff       	call   80182a <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd1:	90                   	nop
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <rsttst>:
void rsttst()
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 28                	push   $0x28
  801ce3:	e8 42 fb ff ff       	call   80182a <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ceb:	90                   	nop
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	83 ec 04             	sub    $0x4,%esp
  801cf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cfa:	8b 55 18             	mov    0x18(%ebp),%edx
  801cfd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d01:	52                   	push   %edx
  801d02:	50                   	push   %eax
  801d03:	ff 75 10             	pushl  0x10(%ebp)
  801d06:	ff 75 0c             	pushl  0xc(%ebp)
  801d09:	ff 75 08             	pushl  0x8(%ebp)
  801d0c:	6a 27                	push   $0x27
  801d0e:	e8 17 fb ff ff       	call   80182a <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
	return ;
  801d16:	90                   	nop
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <chktst>:
void chktst(uint32 n)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	ff 75 08             	pushl  0x8(%ebp)
  801d27:	6a 29                	push   $0x29
  801d29:	e8 fc fa ff ff       	call   80182a <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d31:	90                   	nop
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <inctst>:

void inctst()
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 2a                	push   $0x2a
  801d43:	e8 e2 fa ff ff       	call   80182a <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4b:	90                   	nop
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <gettst>:
uint32 gettst()
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 2b                	push   $0x2b
  801d5d:	e8 c8 fa ff ff       	call   80182a <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 2c                	push   $0x2c
  801d79:	e8 ac fa ff ff       	call   80182a <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
  801d81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d84:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d88:	75 07                	jne    801d91 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8f:	eb 05                	jmp    801d96 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 2c                	push   $0x2c
  801daa:	e8 7b fa ff ff       	call   80182a <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
  801db2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801db5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801db9:	75 07                	jne    801dc2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dbb:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc0:	eb 05                	jmp    801dc7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 2c                	push   $0x2c
  801ddb:	e8 4a fa ff ff       	call   80182a <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
  801de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801de6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dea:	75 07                	jne    801df3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dec:	b8 01 00 00 00       	mov    $0x1,%eax
  801df1:	eb 05                	jmp    801df8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 2c                	push   $0x2c
  801e0c:	e8 19 fa ff ff       	call   80182a <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
  801e14:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e17:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e1b:	75 07                	jne    801e24 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e1d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e22:	eb 05                	jmp    801e29 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	ff 75 08             	pushl  0x8(%ebp)
  801e39:	6a 2d                	push   $0x2d
  801e3b:	e8 ea f9 ff ff       	call   80182a <syscall>
  801e40:	83 c4 18             	add    $0x18,%esp
	return ;
  801e43:	90                   	nop
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e4a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e53:	8b 45 08             	mov    0x8(%ebp),%eax
  801e56:	6a 00                	push   $0x0
  801e58:	53                   	push   %ebx
  801e59:	51                   	push   %ecx
  801e5a:	52                   	push   %edx
  801e5b:	50                   	push   %eax
  801e5c:	6a 2e                	push   $0x2e
  801e5e:	e8 c7 f9 ff ff       	call   80182a <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
}
  801e66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	52                   	push   %edx
  801e7b:	50                   	push   %eax
  801e7c:	6a 2f                	push   $0x2f
  801e7e:	e8 a7 f9 ff ff       	call   80182a <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e8e:	83 ec 0c             	sub    $0xc,%esp
  801e91:	68 40 40 80 00       	push   $0x804040
  801e96:	e8 d6 e6 ff ff       	call   800571 <cprintf>
  801e9b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e9e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ea5:	83 ec 0c             	sub    $0xc,%esp
  801ea8:	68 6c 40 80 00       	push   $0x80406c
  801ead:	e8 bf e6 ff ff       	call   800571 <cprintf>
  801eb2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eb5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eb9:	a1 38 51 80 00       	mov    0x805138,%eax
  801ebe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec1:	eb 56                	jmp    801f19 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ec3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ec7:	74 1c                	je     801ee5 <print_mem_block_lists+0x5d>
  801ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecc:	8b 50 08             	mov    0x8(%eax),%edx
  801ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed2:	8b 48 08             	mov    0x8(%eax),%ecx
  801ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed8:	8b 40 0c             	mov    0xc(%eax),%eax
  801edb:	01 c8                	add    %ecx,%eax
  801edd:	39 c2                	cmp    %eax,%edx
  801edf:	73 04                	jae    801ee5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ee1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee8:	8b 50 08             	mov    0x8(%eax),%edx
  801eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eee:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef1:	01 c2                	add    %eax,%edx
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 40 08             	mov    0x8(%eax),%eax
  801ef9:	83 ec 04             	sub    $0x4,%esp
  801efc:	52                   	push   %edx
  801efd:	50                   	push   %eax
  801efe:	68 81 40 80 00       	push   $0x804081
  801f03:	e8 69 e6 ff ff       	call   800571 <cprintf>
  801f08:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f11:	a1 40 51 80 00       	mov    0x805140,%eax
  801f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f1d:	74 07                	je     801f26 <print_mem_block_lists+0x9e>
  801f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f22:	8b 00                	mov    (%eax),%eax
  801f24:	eb 05                	jmp    801f2b <print_mem_block_lists+0xa3>
  801f26:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2b:	a3 40 51 80 00       	mov    %eax,0x805140
  801f30:	a1 40 51 80 00       	mov    0x805140,%eax
  801f35:	85 c0                	test   %eax,%eax
  801f37:	75 8a                	jne    801ec3 <print_mem_block_lists+0x3b>
  801f39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f3d:	75 84                	jne    801ec3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f3f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f43:	75 10                	jne    801f55 <print_mem_block_lists+0xcd>
  801f45:	83 ec 0c             	sub    $0xc,%esp
  801f48:	68 90 40 80 00       	push   $0x804090
  801f4d:	e8 1f e6 ff ff       	call   800571 <cprintf>
  801f52:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f5c:	83 ec 0c             	sub    $0xc,%esp
  801f5f:	68 b4 40 80 00       	push   $0x8040b4
  801f64:	e8 08 e6 ff ff       	call   800571 <cprintf>
  801f69:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f6c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f70:	a1 40 50 80 00       	mov    0x805040,%eax
  801f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f78:	eb 56                	jmp    801fd0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f7e:	74 1c                	je     801f9c <print_mem_block_lists+0x114>
  801f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f83:	8b 50 08             	mov    0x8(%eax),%edx
  801f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f89:	8b 48 08             	mov    0x8(%eax),%ecx
  801f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f92:	01 c8                	add    %ecx,%eax
  801f94:	39 c2                	cmp    %eax,%edx
  801f96:	73 04                	jae    801f9c <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f98:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	8b 50 08             	mov    0x8(%eax),%edx
  801fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa5:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa8:	01 c2                	add    %eax,%edx
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	8b 40 08             	mov    0x8(%eax),%eax
  801fb0:	83 ec 04             	sub    $0x4,%esp
  801fb3:	52                   	push   %edx
  801fb4:	50                   	push   %eax
  801fb5:	68 81 40 80 00       	push   $0x804081
  801fba:	e8 b2 e5 ff ff       	call   800571 <cprintf>
  801fbf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fc8:	a1 48 50 80 00       	mov    0x805048,%eax
  801fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd4:	74 07                	je     801fdd <print_mem_block_lists+0x155>
  801fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd9:	8b 00                	mov    (%eax),%eax
  801fdb:	eb 05                	jmp    801fe2 <print_mem_block_lists+0x15a>
  801fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe2:	a3 48 50 80 00       	mov    %eax,0x805048
  801fe7:	a1 48 50 80 00       	mov    0x805048,%eax
  801fec:	85 c0                	test   %eax,%eax
  801fee:	75 8a                	jne    801f7a <print_mem_block_lists+0xf2>
  801ff0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff4:	75 84                	jne    801f7a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ff6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ffa:	75 10                	jne    80200c <print_mem_block_lists+0x184>
  801ffc:	83 ec 0c             	sub    $0xc,%esp
  801fff:	68 cc 40 80 00       	push   $0x8040cc
  802004:	e8 68 e5 ff ff       	call   800571 <cprintf>
  802009:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80200c:	83 ec 0c             	sub    $0xc,%esp
  80200f:	68 40 40 80 00       	push   $0x804040
  802014:	e8 58 e5 ff ff       	call   800571 <cprintf>
  802019:	83 c4 10             	add    $0x10,%esp

}
  80201c:	90                   	nop
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
  802022:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802025:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80202c:	00 00 00 
  80202f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802036:	00 00 00 
  802039:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802040:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802043:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80204a:	e9 9e 00 00 00       	jmp    8020ed <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80204f:	a1 50 50 80 00       	mov    0x805050,%eax
  802054:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802057:	c1 e2 04             	shl    $0x4,%edx
  80205a:	01 d0                	add    %edx,%eax
  80205c:	85 c0                	test   %eax,%eax
  80205e:	75 14                	jne    802074 <initialize_MemBlocksList+0x55>
  802060:	83 ec 04             	sub    $0x4,%esp
  802063:	68 f4 40 80 00       	push   $0x8040f4
  802068:	6a 46                	push   $0x46
  80206a:	68 17 41 80 00       	push   $0x804117
  80206f:	e8 49 e2 ff ff       	call   8002bd <_panic>
  802074:	a1 50 50 80 00       	mov    0x805050,%eax
  802079:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207c:	c1 e2 04             	shl    $0x4,%edx
  80207f:	01 d0                	add    %edx,%eax
  802081:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802087:	89 10                	mov    %edx,(%eax)
  802089:	8b 00                	mov    (%eax),%eax
  80208b:	85 c0                	test   %eax,%eax
  80208d:	74 18                	je     8020a7 <initialize_MemBlocksList+0x88>
  80208f:	a1 48 51 80 00       	mov    0x805148,%eax
  802094:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80209a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80209d:	c1 e1 04             	shl    $0x4,%ecx
  8020a0:	01 ca                	add    %ecx,%edx
  8020a2:	89 50 04             	mov    %edx,0x4(%eax)
  8020a5:	eb 12                	jmp    8020b9 <initialize_MemBlocksList+0x9a>
  8020a7:	a1 50 50 80 00       	mov    0x805050,%eax
  8020ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020af:	c1 e2 04             	shl    $0x4,%edx
  8020b2:	01 d0                	add    %edx,%eax
  8020b4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020b9:	a1 50 50 80 00       	mov    0x805050,%eax
  8020be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c1:	c1 e2 04             	shl    $0x4,%edx
  8020c4:	01 d0                	add    %edx,%eax
  8020c6:	a3 48 51 80 00       	mov    %eax,0x805148
  8020cb:	a1 50 50 80 00       	mov    0x805050,%eax
  8020d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d3:	c1 e2 04             	shl    $0x4,%edx
  8020d6:	01 d0                	add    %edx,%eax
  8020d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020df:	a1 54 51 80 00       	mov    0x805154,%eax
  8020e4:	40                   	inc    %eax
  8020e5:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020ea:	ff 45 f4             	incl   -0xc(%ebp)
  8020ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020f3:	0f 82 56 ff ff ff    	jb     80204f <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020f9:	90                   	nop
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	8b 00                	mov    (%eax),%eax
  802107:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80210a:	eb 19                	jmp    802125 <find_block+0x29>
	{
		if(va==point->sva)
  80210c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210f:	8b 40 08             	mov    0x8(%eax),%eax
  802112:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802115:	75 05                	jne    80211c <find_block+0x20>
		   return point;
  802117:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211a:	eb 36                	jmp    802152 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	8b 40 08             	mov    0x8(%eax),%eax
  802122:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802125:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802129:	74 07                	je     802132 <find_block+0x36>
  80212b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212e:	8b 00                	mov    (%eax),%eax
  802130:	eb 05                	jmp    802137 <find_block+0x3b>
  802132:	b8 00 00 00 00       	mov    $0x0,%eax
  802137:	8b 55 08             	mov    0x8(%ebp),%edx
  80213a:	89 42 08             	mov    %eax,0x8(%edx)
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	8b 40 08             	mov    0x8(%eax),%eax
  802143:	85 c0                	test   %eax,%eax
  802145:	75 c5                	jne    80210c <find_block+0x10>
  802147:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80214b:	75 bf                	jne    80210c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80214d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80215a:	a1 40 50 80 00       	mov    0x805040,%eax
  80215f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802162:	a1 44 50 80 00       	mov    0x805044,%eax
  802167:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80216a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802170:	74 24                	je     802196 <insert_sorted_allocList+0x42>
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	8b 50 08             	mov    0x8(%eax),%edx
  802178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217b:	8b 40 08             	mov    0x8(%eax),%eax
  80217e:	39 c2                	cmp    %eax,%edx
  802180:	76 14                	jbe    802196 <insert_sorted_allocList+0x42>
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	8b 50 08             	mov    0x8(%eax),%edx
  802188:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218b:	8b 40 08             	mov    0x8(%eax),%eax
  80218e:	39 c2                	cmp    %eax,%edx
  802190:	0f 82 60 01 00 00    	jb     8022f6 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802196:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80219a:	75 65                	jne    802201 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80219c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a0:	75 14                	jne    8021b6 <insert_sorted_allocList+0x62>
  8021a2:	83 ec 04             	sub    $0x4,%esp
  8021a5:	68 f4 40 80 00       	push   $0x8040f4
  8021aa:	6a 6b                	push   $0x6b
  8021ac:	68 17 41 80 00       	push   $0x804117
  8021b1:	e8 07 e1 ff ff       	call   8002bd <_panic>
  8021b6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	89 10                	mov    %edx,(%eax)
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	8b 00                	mov    (%eax),%eax
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	74 0d                	je     8021d7 <insert_sorted_allocList+0x83>
  8021ca:	a1 40 50 80 00       	mov    0x805040,%eax
  8021cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d2:	89 50 04             	mov    %edx,0x4(%eax)
  8021d5:	eb 08                	jmp    8021df <insert_sorted_allocList+0x8b>
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	a3 44 50 80 00       	mov    %eax,0x805044
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	a3 40 50 80 00       	mov    %eax,0x805040
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021f6:	40                   	inc    %eax
  8021f7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021fc:	e9 dc 01 00 00       	jmp    8023dd <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	8b 50 08             	mov    0x8(%eax),%edx
  802207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220a:	8b 40 08             	mov    0x8(%eax),%eax
  80220d:	39 c2                	cmp    %eax,%edx
  80220f:	77 6c                	ja     80227d <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802211:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802215:	74 06                	je     80221d <insert_sorted_allocList+0xc9>
  802217:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221b:	75 14                	jne    802231 <insert_sorted_allocList+0xdd>
  80221d:	83 ec 04             	sub    $0x4,%esp
  802220:	68 30 41 80 00       	push   $0x804130
  802225:	6a 6f                	push   $0x6f
  802227:	68 17 41 80 00       	push   $0x804117
  80222c:	e8 8c e0 ff ff       	call   8002bd <_panic>
  802231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802234:	8b 50 04             	mov    0x4(%eax),%edx
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	89 50 04             	mov    %edx,0x4(%eax)
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802243:	89 10                	mov    %edx,(%eax)
  802245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802248:	8b 40 04             	mov    0x4(%eax),%eax
  80224b:	85 c0                	test   %eax,%eax
  80224d:	74 0d                	je     80225c <insert_sorted_allocList+0x108>
  80224f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802252:	8b 40 04             	mov    0x4(%eax),%eax
  802255:	8b 55 08             	mov    0x8(%ebp),%edx
  802258:	89 10                	mov    %edx,(%eax)
  80225a:	eb 08                	jmp    802264 <insert_sorted_allocList+0x110>
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	a3 40 50 80 00       	mov    %eax,0x805040
  802264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802267:	8b 55 08             	mov    0x8(%ebp),%edx
  80226a:	89 50 04             	mov    %edx,0x4(%eax)
  80226d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802272:	40                   	inc    %eax
  802273:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802278:	e9 60 01 00 00       	jmp    8023dd <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	8b 50 08             	mov    0x8(%eax),%edx
  802283:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802286:	8b 40 08             	mov    0x8(%eax),%eax
  802289:	39 c2                	cmp    %eax,%edx
  80228b:	0f 82 4c 01 00 00    	jb     8023dd <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802291:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802295:	75 14                	jne    8022ab <insert_sorted_allocList+0x157>
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	68 68 41 80 00       	push   $0x804168
  80229f:	6a 73                	push   $0x73
  8022a1:	68 17 41 80 00       	push   $0x804117
  8022a6:	e8 12 e0 ff ff       	call   8002bd <_panic>
  8022ab:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	89 50 04             	mov    %edx,0x4(%eax)
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	8b 40 04             	mov    0x4(%eax),%eax
  8022bd:	85 c0                	test   %eax,%eax
  8022bf:	74 0c                	je     8022cd <insert_sorted_allocList+0x179>
  8022c1:	a1 44 50 80 00       	mov    0x805044,%eax
  8022c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c9:	89 10                	mov    %edx,(%eax)
  8022cb:	eb 08                	jmp    8022d5 <insert_sorted_allocList+0x181>
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	a3 40 50 80 00       	mov    %eax,0x805040
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	a3 44 50 80 00       	mov    %eax,0x805044
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022e6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022eb:	40                   	inc    %eax
  8022ec:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022f1:	e9 e7 00 00 00       	jmp    8023dd <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802303:	a1 40 50 80 00       	mov    0x805040,%eax
  802308:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230b:	e9 9d 00 00 00       	jmp    8023ad <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	8b 00                	mov    (%eax),%eax
  802315:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	8b 50 08             	mov    0x8(%eax),%edx
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	8b 40 08             	mov    0x8(%eax),%eax
  802324:	39 c2                	cmp    %eax,%edx
  802326:	76 7d                	jbe    8023a5 <insert_sorted_allocList+0x251>
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	8b 50 08             	mov    0x8(%eax),%edx
  80232e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802331:	8b 40 08             	mov    0x8(%eax),%eax
  802334:	39 c2                	cmp    %eax,%edx
  802336:	73 6d                	jae    8023a5 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233c:	74 06                	je     802344 <insert_sorted_allocList+0x1f0>
  80233e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802342:	75 14                	jne    802358 <insert_sorted_allocList+0x204>
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	68 8c 41 80 00       	push   $0x80418c
  80234c:	6a 7f                	push   $0x7f
  80234e:	68 17 41 80 00       	push   $0x804117
  802353:	e8 65 df ff ff       	call   8002bd <_panic>
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 10                	mov    (%eax),%edx
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	89 10                	mov    %edx,(%eax)
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	8b 00                	mov    (%eax),%eax
  802367:	85 c0                	test   %eax,%eax
  802369:	74 0b                	je     802376 <insert_sorted_allocList+0x222>
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 00                	mov    (%eax),%eax
  802370:	8b 55 08             	mov    0x8(%ebp),%edx
  802373:	89 50 04             	mov    %edx,0x4(%eax)
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 55 08             	mov    0x8(%ebp),%edx
  80237c:	89 10                	mov    %edx,(%eax)
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802384:	89 50 04             	mov    %edx,0x4(%eax)
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	8b 00                	mov    (%eax),%eax
  80238c:	85 c0                	test   %eax,%eax
  80238e:	75 08                	jne    802398 <insert_sorted_allocList+0x244>
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	a3 44 50 80 00       	mov    %eax,0x805044
  802398:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80239d:	40                   	inc    %eax
  80239e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023a3:	eb 39                	jmp    8023de <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023a5:	a1 48 50 80 00       	mov    0x805048,%eax
  8023aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b1:	74 07                	je     8023ba <insert_sorted_allocList+0x266>
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	8b 00                	mov    (%eax),%eax
  8023b8:	eb 05                	jmp    8023bf <insert_sorted_allocList+0x26b>
  8023ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bf:	a3 48 50 80 00       	mov    %eax,0x805048
  8023c4:	a1 48 50 80 00       	mov    0x805048,%eax
  8023c9:	85 c0                	test   %eax,%eax
  8023cb:	0f 85 3f ff ff ff    	jne    802310 <insert_sorted_allocList+0x1bc>
  8023d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d5:	0f 85 35 ff ff ff    	jne    802310 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023db:	eb 01                	jmp    8023de <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023dd:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023de:	90                   	nop
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8023ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ef:	e9 85 01 00 00       	jmp    802579 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023fd:	0f 82 6e 01 00 00    	jb     802571 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802406:	8b 40 0c             	mov    0xc(%eax),%eax
  802409:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240c:	0f 85 8a 00 00 00    	jne    80249c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802412:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802416:	75 17                	jne    80242f <alloc_block_FF+0x4e>
  802418:	83 ec 04             	sub    $0x4,%esp
  80241b:	68 c0 41 80 00       	push   $0x8041c0
  802420:	68 93 00 00 00       	push   $0x93
  802425:	68 17 41 80 00       	push   $0x804117
  80242a:	e8 8e de ff ff       	call   8002bd <_panic>
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	85 c0                	test   %eax,%eax
  802436:	74 10                	je     802448 <alloc_block_FF+0x67>
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 00                	mov    (%eax),%eax
  80243d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802440:	8b 52 04             	mov    0x4(%edx),%edx
  802443:	89 50 04             	mov    %edx,0x4(%eax)
  802446:	eb 0b                	jmp    802453 <alloc_block_FF+0x72>
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 40 04             	mov    0x4(%eax),%eax
  802459:	85 c0                	test   %eax,%eax
  80245b:	74 0f                	je     80246c <alloc_block_FF+0x8b>
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	8b 40 04             	mov    0x4(%eax),%eax
  802463:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802466:	8b 12                	mov    (%edx),%edx
  802468:	89 10                	mov    %edx,(%eax)
  80246a:	eb 0a                	jmp    802476 <alloc_block_FF+0x95>
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 00                	mov    (%eax),%eax
  802471:	a3 38 51 80 00       	mov    %eax,0x805138
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802489:	a1 44 51 80 00       	mov    0x805144,%eax
  80248e:	48                   	dec    %eax
  80248f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	e9 10 01 00 00       	jmp    8025ac <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a5:	0f 86 c6 00 00 00    	jbe    802571 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024ab:	a1 48 51 80 00       	mov    0x805148,%eax
  8024b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 50 08             	mov    0x8(%eax),%edx
  8024b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bc:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c5:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024cc:	75 17                	jne    8024e5 <alloc_block_FF+0x104>
  8024ce:	83 ec 04             	sub    $0x4,%esp
  8024d1:	68 c0 41 80 00       	push   $0x8041c0
  8024d6:	68 9b 00 00 00       	push   $0x9b
  8024db:	68 17 41 80 00       	push   $0x804117
  8024e0:	e8 d8 dd ff ff       	call   8002bd <_panic>
  8024e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	74 10                	je     8024fe <alloc_block_FF+0x11d>
  8024ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f1:	8b 00                	mov    (%eax),%eax
  8024f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f6:	8b 52 04             	mov    0x4(%edx),%edx
  8024f9:	89 50 04             	mov    %edx,0x4(%eax)
  8024fc:	eb 0b                	jmp    802509 <alloc_block_FF+0x128>
  8024fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802501:	8b 40 04             	mov    0x4(%eax),%eax
  802504:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250c:	8b 40 04             	mov    0x4(%eax),%eax
  80250f:	85 c0                	test   %eax,%eax
  802511:	74 0f                	je     802522 <alloc_block_FF+0x141>
  802513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802516:	8b 40 04             	mov    0x4(%eax),%eax
  802519:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80251c:	8b 12                	mov    (%edx),%edx
  80251e:	89 10                	mov    %edx,(%eax)
  802520:	eb 0a                	jmp    80252c <alloc_block_FF+0x14b>
  802522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802525:	8b 00                	mov    (%eax),%eax
  802527:	a3 48 51 80 00       	mov    %eax,0x805148
  80252c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802538:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80253f:	a1 54 51 80 00       	mov    0x805154,%eax
  802544:	48                   	dec    %eax
  802545:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	8b 50 08             	mov    0x8(%eax),%edx
  802550:	8b 45 08             	mov    0x8(%ebp),%eax
  802553:	01 c2                	add    %eax,%edx
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 40 0c             	mov    0xc(%eax),%eax
  802561:	2b 45 08             	sub    0x8(%ebp),%eax
  802564:	89 c2                	mov    %eax,%edx
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80256c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256f:	eb 3b                	jmp    8025ac <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802571:	a1 40 51 80 00       	mov    0x805140,%eax
  802576:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257d:	74 07                	je     802586 <alloc_block_FF+0x1a5>
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 00                	mov    (%eax),%eax
  802584:	eb 05                	jmp    80258b <alloc_block_FF+0x1aa>
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
  80258b:	a3 40 51 80 00       	mov    %eax,0x805140
  802590:	a1 40 51 80 00       	mov    0x805140,%eax
  802595:	85 c0                	test   %eax,%eax
  802597:	0f 85 57 fe ff ff    	jne    8023f4 <alloc_block_FF+0x13>
  80259d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a1:	0f 85 4d fe ff ff    	jne    8023f4 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025b4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025bb:	a1 38 51 80 00       	mov    0x805138,%eax
  8025c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c3:	e9 df 00 00 00       	jmp    8026a7 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d1:	0f 82 c8 00 00 00    	jb     80269f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 40 0c             	mov    0xc(%eax),%eax
  8025dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e0:	0f 85 8a 00 00 00    	jne    802670 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ea:	75 17                	jne    802603 <alloc_block_BF+0x55>
  8025ec:	83 ec 04             	sub    $0x4,%esp
  8025ef:	68 c0 41 80 00       	push   $0x8041c0
  8025f4:	68 b7 00 00 00       	push   $0xb7
  8025f9:	68 17 41 80 00       	push   $0x804117
  8025fe:	e8 ba dc ff ff       	call   8002bd <_panic>
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	85 c0                	test   %eax,%eax
  80260a:	74 10                	je     80261c <alloc_block_BF+0x6e>
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 00                	mov    (%eax),%eax
  802611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802614:	8b 52 04             	mov    0x4(%edx),%edx
  802617:	89 50 04             	mov    %edx,0x4(%eax)
  80261a:	eb 0b                	jmp    802627 <alloc_block_BF+0x79>
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 40 04             	mov    0x4(%eax),%eax
  802622:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	8b 40 04             	mov    0x4(%eax),%eax
  80262d:	85 c0                	test   %eax,%eax
  80262f:	74 0f                	je     802640 <alloc_block_BF+0x92>
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 40 04             	mov    0x4(%eax),%eax
  802637:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263a:	8b 12                	mov    (%edx),%edx
  80263c:	89 10                	mov    %edx,(%eax)
  80263e:	eb 0a                	jmp    80264a <alloc_block_BF+0x9c>
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 00                	mov    (%eax),%eax
  802645:	a3 38 51 80 00       	mov    %eax,0x805138
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80265d:	a1 44 51 80 00       	mov    0x805144,%eax
  802662:	48                   	dec    %eax
  802663:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	e9 4d 01 00 00       	jmp    8027bd <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 40 0c             	mov    0xc(%eax),%eax
  802676:	3b 45 08             	cmp    0x8(%ebp),%eax
  802679:	76 24                	jbe    80269f <alloc_block_BF+0xf1>
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 40 0c             	mov    0xc(%eax),%eax
  802681:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802684:	73 19                	jae    80269f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802686:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 40 0c             	mov    0xc(%eax),%eax
  802693:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 40 08             	mov    0x8(%eax),%eax
  80269c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80269f:	a1 40 51 80 00       	mov    0x805140,%eax
  8026a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ab:	74 07                	je     8026b4 <alloc_block_BF+0x106>
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 00                	mov    (%eax),%eax
  8026b2:	eb 05                	jmp    8026b9 <alloc_block_BF+0x10b>
  8026b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b9:	a3 40 51 80 00       	mov    %eax,0x805140
  8026be:	a1 40 51 80 00       	mov    0x805140,%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	0f 85 fd fe ff ff    	jne    8025c8 <alloc_block_BF+0x1a>
  8026cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cf:	0f 85 f3 fe ff ff    	jne    8025c8 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026d9:	0f 84 d9 00 00 00    	je     8027b8 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026df:	a1 48 51 80 00       	mov    0x805148,%eax
  8026e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026ed:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f6:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026fd:	75 17                	jne    802716 <alloc_block_BF+0x168>
  8026ff:	83 ec 04             	sub    $0x4,%esp
  802702:	68 c0 41 80 00       	push   $0x8041c0
  802707:	68 c7 00 00 00       	push   $0xc7
  80270c:	68 17 41 80 00       	push   $0x804117
  802711:	e8 a7 db ff ff       	call   8002bd <_panic>
  802716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802719:	8b 00                	mov    (%eax),%eax
  80271b:	85 c0                	test   %eax,%eax
  80271d:	74 10                	je     80272f <alloc_block_BF+0x181>
  80271f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802727:	8b 52 04             	mov    0x4(%edx),%edx
  80272a:	89 50 04             	mov    %edx,0x4(%eax)
  80272d:	eb 0b                	jmp    80273a <alloc_block_BF+0x18c>
  80272f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802732:	8b 40 04             	mov    0x4(%eax),%eax
  802735:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80273a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273d:	8b 40 04             	mov    0x4(%eax),%eax
  802740:	85 c0                	test   %eax,%eax
  802742:	74 0f                	je     802753 <alloc_block_BF+0x1a5>
  802744:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802747:	8b 40 04             	mov    0x4(%eax),%eax
  80274a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80274d:	8b 12                	mov    (%edx),%edx
  80274f:	89 10                	mov    %edx,(%eax)
  802751:	eb 0a                	jmp    80275d <alloc_block_BF+0x1af>
  802753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802756:	8b 00                	mov    (%eax),%eax
  802758:	a3 48 51 80 00       	mov    %eax,0x805148
  80275d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802760:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802769:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802770:	a1 54 51 80 00       	mov    0x805154,%eax
  802775:	48                   	dec    %eax
  802776:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80277b:	83 ec 08             	sub    $0x8,%esp
  80277e:	ff 75 ec             	pushl  -0x14(%ebp)
  802781:	68 38 51 80 00       	push   $0x805138
  802786:	e8 71 f9 ff ff       	call   8020fc <find_block>
  80278b:	83 c4 10             	add    $0x10,%esp
  80278e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802791:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802794:	8b 50 08             	mov    0x8(%eax),%edx
  802797:	8b 45 08             	mov    0x8(%ebp),%eax
  80279a:	01 c2                	add    %eax,%edx
  80279c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a8:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ab:	89 c2                	mov    %eax,%edx
  8027ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b0:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b6:	eb 05                	jmp    8027bd <alloc_block_BF+0x20f>
	}
	return NULL;
  8027b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027bd:	c9                   	leave  
  8027be:	c3                   	ret    

008027bf <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027bf:	55                   	push   %ebp
  8027c0:	89 e5                	mov    %esp,%ebp
  8027c2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027c5:	a1 28 50 80 00       	mov    0x805028,%eax
  8027ca:	85 c0                	test   %eax,%eax
  8027cc:	0f 85 de 01 00 00    	jne    8029b0 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8027d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027da:	e9 9e 01 00 00       	jmp    80297d <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e8:	0f 82 87 01 00 00    	jb     802975 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f7:	0f 85 95 00 00 00    	jne    802892 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802801:	75 17                	jne    80281a <alloc_block_NF+0x5b>
  802803:	83 ec 04             	sub    $0x4,%esp
  802806:	68 c0 41 80 00       	push   $0x8041c0
  80280b:	68 e0 00 00 00       	push   $0xe0
  802810:	68 17 41 80 00       	push   $0x804117
  802815:	e8 a3 da ff ff       	call   8002bd <_panic>
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 00                	mov    (%eax),%eax
  80281f:	85 c0                	test   %eax,%eax
  802821:	74 10                	je     802833 <alloc_block_NF+0x74>
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282b:	8b 52 04             	mov    0x4(%edx),%edx
  80282e:	89 50 04             	mov    %edx,0x4(%eax)
  802831:	eb 0b                	jmp    80283e <alloc_block_NF+0x7f>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	8b 40 04             	mov    0x4(%eax),%eax
  802844:	85 c0                	test   %eax,%eax
  802846:	74 0f                	je     802857 <alloc_block_NF+0x98>
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 40 04             	mov    0x4(%eax),%eax
  80284e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802851:	8b 12                	mov    (%edx),%edx
  802853:	89 10                	mov    %edx,(%eax)
  802855:	eb 0a                	jmp    802861 <alloc_block_NF+0xa2>
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 00                	mov    (%eax),%eax
  80285c:	a3 38 51 80 00       	mov    %eax,0x805138
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802874:	a1 44 51 80 00       	mov    0x805144,%eax
  802879:	48                   	dec    %eax
  80287a:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 08             	mov    0x8(%eax),%eax
  802885:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	e9 f8 04 00 00       	jmp    802d8a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 40 0c             	mov    0xc(%eax),%eax
  802898:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289b:	0f 86 d4 00 00 00    	jbe    802975 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028a1:	a1 48 51 80 00       	mov    0x805148,%eax
  8028a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 50 08             	mov    0x8(%eax),%edx
  8028af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b2:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028bb:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028c2:	75 17                	jne    8028db <alloc_block_NF+0x11c>
  8028c4:	83 ec 04             	sub    $0x4,%esp
  8028c7:	68 c0 41 80 00       	push   $0x8041c0
  8028cc:	68 e9 00 00 00       	push   $0xe9
  8028d1:	68 17 41 80 00       	push   $0x804117
  8028d6:	e8 e2 d9 ff ff       	call   8002bd <_panic>
  8028db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	74 10                	je     8028f4 <alloc_block_NF+0x135>
  8028e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e7:	8b 00                	mov    (%eax),%eax
  8028e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ec:	8b 52 04             	mov    0x4(%edx),%edx
  8028ef:	89 50 04             	mov    %edx,0x4(%eax)
  8028f2:	eb 0b                	jmp    8028ff <alloc_block_NF+0x140>
  8028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f7:	8b 40 04             	mov    0x4(%eax),%eax
  8028fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802902:	8b 40 04             	mov    0x4(%eax),%eax
  802905:	85 c0                	test   %eax,%eax
  802907:	74 0f                	je     802918 <alloc_block_NF+0x159>
  802909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290c:	8b 40 04             	mov    0x4(%eax),%eax
  80290f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802912:	8b 12                	mov    (%edx),%edx
  802914:	89 10                	mov    %edx,(%eax)
  802916:	eb 0a                	jmp    802922 <alloc_block_NF+0x163>
  802918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	a3 48 51 80 00       	mov    %eax,0x805148
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802935:	a1 54 51 80 00       	mov    0x805154,%eax
  80293a:	48                   	dec    %eax
  80293b:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802943:	8b 40 08             	mov    0x8(%eax),%eax
  802946:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	8b 50 08             	mov    0x8(%eax),%edx
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	01 c2                	add    %eax,%edx
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 40 0c             	mov    0xc(%eax),%eax
  802962:	2b 45 08             	sub    0x8(%ebp),%eax
  802965:	89 c2                	mov    %eax,%edx
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80296d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802970:	e9 15 04 00 00       	jmp    802d8a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802975:	a1 40 51 80 00       	mov    0x805140,%eax
  80297a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802981:	74 07                	je     80298a <alloc_block_NF+0x1cb>
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	eb 05                	jmp    80298f <alloc_block_NF+0x1d0>
  80298a:	b8 00 00 00 00       	mov    $0x0,%eax
  80298f:	a3 40 51 80 00       	mov    %eax,0x805140
  802994:	a1 40 51 80 00       	mov    0x805140,%eax
  802999:	85 c0                	test   %eax,%eax
  80299b:	0f 85 3e fe ff ff    	jne    8027df <alloc_block_NF+0x20>
  8029a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a5:	0f 85 34 fe ff ff    	jne    8027df <alloc_block_NF+0x20>
  8029ab:	e9 d5 03 00 00       	jmp    802d85 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029b0:	a1 38 51 80 00       	mov    0x805138,%eax
  8029b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b8:	e9 b1 01 00 00       	jmp    802b6e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 50 08             	mov    0x8(%eax),%edx
  8029c3:	a1 28 50 80 00       	mov    0x805028,%eax
  8029c8:	39 c2                	cmp    %eax,%edx
  8029ca:	0f 82 96 01 00 00    	jb     802b66 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d9:	0f 82 87 01 00 00    	jb     802b66 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e8:	0f 85 95 00 00 00    	jne    802a83 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f2:	75 17                	jne    802a0b <alloc_block_NF+0x24c>
  8029f4:	83 ec 04             	sub    $0x4,%esp
  8029f7:	68 c0 41 80 00       	push   $0x8041c0
  8029fc:	68 fc 00 00 00       	push   $0xfc
  802a01:	68 17 41 80 00       	push   $0x804117
  802a06:	e8 b2 d8 ff ff       	call   8002bd <_panic>
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	74 10                	je     802a24 <alloc_block_NF+0x265>
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1c:	8b 52 04             	mov    0x4(%edx),%edx
  802a1f:	89 50 04             	mov    %edx,0x4(%eax)
  802a22:	eb 0b                	jmp    802a2f <alloc_block_NF+0x270>
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 40 04             	mov    0x4(%eax),%eax
  802a2a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 40 04             	mov    0x4(%eax),%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	74 0f                	je     802a48 <alloc_block_NF+0x289>
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 40 04             	mov    0x4(%eax),%eax
  802a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a42:	8b 12                	mov    (%edx),%edx
  802a44:	89 10                	mov    %edx,(%eax)
  802a46:	eb 0a                	jmp    802a52 <alloc_block_NF+0x293>
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	a3 38 51 80 00       	mov    %eax,0x805138
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a65:	a1 44 51 80 00       	mov    0x805144,%eax
  802a6a:	48                   	dec    %eax
  802a6b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 40 08             	mov    0x8(%eax),%eax
  802a76:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	e9 07 03 00 00       	jmp    802d8a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 40 0c             	mov    0xc(%eax),%eax
  802a89:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a8c:	0f 86 d4 00 00 00    	jbe    802b66 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a92:	a1 48 51 80 00       	mov    0x805148,%eax
  802a97:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 50 08             	mov    0x8(%eax),%edx
  802aa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802aa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa9:	8b 55 08             	mov    0x8(%ebp),%edx
  802aac:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aaf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ab3:	75 17                	jne    802acc <alloc_block_NF+0x30d>
  802ab5:	83 ec 04             	sub    $0x4,%esp
  802ab8:	68 c0 41 80 00       	push   $0x8041c0
  802abd:	68 04 01 00 00       	push   $0x104
  802ac2:	68 17 41 80 00       	push   $0x804117
  802ac7:	e8 f1 d7 ff ff       	call   8002bd <_panic>
  802acc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	74 10                	je     802ae5 <alloc_block_NF+0x326>
  802ad5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802add:	8b 52 04             	mov    0x4(%edx),%edx
  802ae0:	89 50 04             	mov    %edx,0x4(%eax)
  802ae3:	eb 0b                	jmp    802af0 <alloc_block_NF+0x331>
  802ae5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae8:	8b 40 04             	mov    0x4(%eax),%eax
  802aeb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af3:	8b 40 04             	mov    0x4(%eax),%eax
  802af6:	85 c0                	test   %eax,%eax
  802af8:	74 0f                	je     802b09 <alloc_block_NF+0x34a>
  802afa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afd:	8b 40 04             	mov    0x4(%eax),%eax
  802b00:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b03:	8b 12                	mov    (%edx),%edx
  802b05:	89 10                	mov    %edx,(%eax)
  802b07:	eb 0a                	jmp    802b13 <alloc_block_NF+0x354>
  802b09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	a3 48 51 80 00       	mov    %eax,0x805148
  802b13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b26:	a1 54 51 80 00       	mov    0x805154,%eax
  802b2b:	48                   	dec    %eax
  802b2c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b34:	8b 40 08             	mov    0x8(%eax),%eax
  802b37:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 50 08             	mov    0x8(%eax),%edx
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	01 c2                	add    %eax,%edx
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 40 0c             	mov    0xc(%eax),%eax
  802b53:	2b 45 08             	sub    0x8(%ebp),%eax
  802b56:	89 c2                	mov    %eax,%edx
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b61:	e9 24 02 00 00       	jmp    802d8a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b66:	a1 40 51 80 00       	mov    0x805140,%eax
  802b6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b72:	74 07                	je     802b7b <alloc_block_NF+0x3bc>
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	eb 05                	jmp    802b80 <alloc_block_NF+0x3c1>
  802b7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b80:	a3 40 51 80 00       	mov    %eax,0x805140
  802b85:	a1 40 51 80 00       	mov    0x805140,%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	0f 85 2b fe ff ff    	jne    8029bd <alloc_block_NF+0x1fe>
  802b92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b96:	0f 85 21 fe ff ff    	jne    8029bd <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b9c:	a1 38 51 80 00       	mov    0x805138,%eax
  802ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba4:	e9 ae 01 00 00       	jmp    802d57 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	8b 50 08             	mov    0x8(%eax),%edx
  802baf:	a1 28 50 80 00       	mov    0x805028,%eax
  802bb4:	39 c2                	cmp    %eax,%edx
  802bb6:	0f 83 93 01 00 00    	jae    802d4f <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc5:	0f 82 84 01 00 00    	jb     802d4f <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd4:	0f 85 95 00 00 00    	jne    802c6f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bde:	75 17                	jne    802bf7 <alloc_block_NF+0x438>
  802be0:	83 ec 04             	sub    $0x4,%esp
  802be3:	68 c0 41 80 00       	push   $0x8041c0
  802be8:	68 14 01 00 00       	push   $0x114
  802bed:	68 17 41 80 00       	push   $0x804117
  802bf2:	e8 c6 d6 ff ff       	call   8002bd <_panic>
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 10                	je     802c10 <alloc_block_NF+0x451>
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 00                	mov    (%eax),%eax
  802c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c08:	8b 52 04             	mov    0x4(%edx),%edx
  802c0b:	89 50 04             	mov    %edx,0x4(%eax)
  802c0e:	eb 0b                	jmp    802c1b <alloc_block_NF+0x45c>
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 40 04             	mov    0x4(%eax),%eax
  802c16:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	8b 40 04             	mov    0x4(%eax),%eax
  802c21:	85 c0                	test   %eax,%eax
  802c23:	74 0f                	je     802c34 <alloc_block_NF+0x475>
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 40 04             	mov    0x4(%eax),%eax
  802c2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c2e:	8b 12                	mov    (%edx),%edx
  802c30:	89 10                	mov    %edx,(%eax)
  802c32:	eb 0a                	jmp    802c3e <alloc_block_NF+0x47f>
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	a3 38 51 80 00       	mov    %eax,0x805138
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c51:	a1 44 51 80 00       	mov    0x805144,%eax
  802c56:	48                   	dec    %eax
  802c57:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 40 08             	mov    0x8(%eax),%eax
  802c62:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	e9 1b 01 00 00       	jmp    802d8a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 40 0c             	mov    0xc(%eax),%eax
  802c75:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c78:	0f 86 d1 00 00 00    	jbe    802d4f <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c7e:	a1 48 51 80 00       	mov    0x805148,%eax
  802c83:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	8b 50 08             	mov    0x8(%eax),%edx
  802c8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c95:	8b 55 08             	mov    0x8(%ebp),%edx
  802c98:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c9f:	75 17                	jne    802cb8 <alloc_block_NF+0x4f9>
  802ca1:	83 ec 04             	sub    $0x4,%esp
  802ca4:	68 c0 41 80 00       	push   $0x8041c0
  802ca9:	68 1c 01 00 00       	push   $0x11c
  802cae:	68 17 41 80 00       	push   $0x804117
  802cb3:	e8 05 d6 ff ff       	call   8002bd <_panic>
  802cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	85 c0                	test   %eax,%eax
  802cbf:	74 10                	je     802cd1 <alloc_block_NF+0x512>
  802cc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc9:	8b 52 04             	mov    0x4(%edx),%edx
  802ccc:	89 50 04             	mov    %edx,0x4(%eax)
  802ccf:	eb 0b                	jmp    802cdc <alloc_block_NF+0x51d>
  802cd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd4:	8b 40 04             	mov    0x4(%eax),%eax
  802cd7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdf:	8b 40 04             	mov    0x4(%eax),%eax
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	74 0f                	je     802cf5 <alloc_block_NF+0x536>
  802ce6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce9:	8b 40 04             	mov    0x4(%eax),%eax
  802cec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cef:	8b 12                	mov    (%edx),%edx
  802cf1:	89 10                	mov    %edx,(%eax)
  802cf3:	eb 0a                	jmp    802cff <alloc_block_NF+0x540>
  802cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	a3 48 51 80 00       	mov    %eax,0x805148
  802cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d12:	a1 54 51 80 00       	mov    0x805154,%eax
  802d17:	48                   	dec    %eax
  802d18:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d20:	8b 40 08             	mov    0x8(%eax),%eax
  802d23:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 50 08             	mov    0x8(%eax),%edx
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	01 c2                	add    %eax,%edx
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3f:	2b 45 08             	sub    0x8(%ebp),%eax
  802d42:	89 c2                	mov    %eax,%edx
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4d:	eb 3b                	jmp    802d8a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d4f:	a1 40 51 80 00       	mov    0x805140,%eax
  802d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d5b:	74 07                	je     802d64 <alloc_block_NF+0x5a5>
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	eb 05                	jmp    802d69 <alloc_block_NF+0x5aa>
  802d64:	b8 00 00 00 00       	mov    $0x0,%eax
  802d69:	a3 40 51 80 00       	mov    %eax,0x805140
  802d6e:	a1 40 51 80 00       	mov    0x805140,%eax
  802d73:	85 c0                	test   %eax,%eax
  802d75:	0f 85 2e fe ff ff    	jne    802ba9 <alloc_block_NF+0x3ea>
  802d7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7f:	0f 85 24 fe ff ff    	jne    802ba9 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d8a:	c9                   	leave  
  802d8b:	c3                   	ret    

00802d8c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d8c:	55                   	push   %ebp
  802d8d:	89 e5                	mov    %esp,%ebp
  802d8f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d92:	a1 38 51 80 00       	mov    0x805138,%eax
  802d97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d9a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d9f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802da2:	a1 38 51 80 00       	mov    0x805138,%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	74 14                	je     802dbf <insert_sorted_with_merge_freeList+0x33>
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	8b 50 08             	mov    0x8(%eax),%edx
  802db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db4:	8b 40 08             	mov    0x8(%eax),%eax
  802db7:	39 c2                	cmp    %eax,%edx
  802db9:	0f 87 9b 01 00 00    	ja     802f5a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802dbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc3:	75 17                	jne    802ddc <insert_sorted_with_merge_freeList+0x50>
  802dc5:	83 ec 04             	sub    $0x4,%esp
  802dc8:	68 f4 40 80 00       	push   $0x8040f4
  802dcd:	68 38 01 00 00       	push   $0x138
  802dd2:	68 17 41 80 00       	push   $0x804117
  802dd7:	e8 e1 d4 ff ff       	call   8002bd <_panic>
  802ddc:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	89 10                	mov    %edx,(%eax)
  802de7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dea:	8b 00                	mov    (%eax),%eax
  802dec:	85 c0                	test   %eax,%eax
  802dee:	74 0d                	je     802dfd <insert_sorted_with_merge_freeList+0x71>
  802df0:	a1 38 51 80 00       	mov    0x805138,%eax
  802df5:	8b 55 08             	mov    0x8(%ebp),%edx
  802df8:	89 50 04             	mov    %edx,0x4(%eax)
  802dfb:	eb 08                	jmp    802e05 <insert_sorted_with_merge_freeList+0x79>
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	a3 38 51 80 00       	mov    %eax,0x805138
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e17:	a1 44 51 80 00       	mov    0x805144,%eax
  802e1c:	40                   	inc    %eax
  802e1d:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e26:	0f 84 a8 06 00 00    	je     8034d4 <insert_sorted_with_merge_freeList+0x748>
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	8b 50 08             	mov    0x8(%eax),%edx
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	8b 40 0c             	mov    0xc(%eax),%eax
  802e38:	01 c2                	add    %eax,%edx
  802e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3d:	8b 40 08             	mov    0x8(%eax),%eax
  802e40:	39 c2                	cmp    %eax,%edx
  802e42:	0f 85 8c 06 00 00    	jne    8034d4 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	8b 50 0c             	mov    0xc(%eax),%edx
  802e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e51:	8b 40 0c             	mov    0xc(%eax),%eax
  802e54:	01 c2                	add    %eax,%edx
  802e56:	8b 45 08             	mov    0x8(%ebp),%eax
  802e59:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e60:	75 17                	jne    802e79 <insert_sorted_with_merge_freeList+0xed>
  802e62:	83 ec 04             	sub    $0x4,%esp
  802e65:	68 c0 41 80 00       	push   $0x8041c0
  802e6a:	68 3c 01 00 00       	push   $0x13c
  802e6f:	68 17 41 80 00       	push   $0x804117
  802e74:	e8 44 d4 ff ff       	call   8002bd <_panic>
  802e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7c:	8b 00                	mov    (%eax),%eax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	74 10                	je     802e92 <insert_sorted_with_merge_freeList+0x106>
  802e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e85:	8b 00                	mov    (%eax),%eax
  802e87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e8a:	8b 52 04             	mov    0x4(%edx),%edx
  802e8d:	89 50 04             	mov    %edx,0x4(%eax)
  802e90:	eb 0b                	jmp    802e9d <insert_sorted_with_merge_freeList+0x111>
  802e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e95:	8b 40 04             	mov    0x4(%eax),%eax
  802e98:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea0:	8b 40 04             	mov    0x4(%eax),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	74 0f                	je     802eb6 <insert_sorted_with_merge_freeList+0x12a>
  802ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eaa:	8b 40 04             	mov    0x4(%eax),%eax
  802ead:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eb0:	8b 12                	mov    (%edx),%edx
  802eb2:	89 10                	mov    %edx,(%eax)
  802eb4:	eb 0a                	jmp    802ec0 <insert_sorted_with_merge_freeList+0x134>
  802eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb9:	8b 00                	mov    (%eax),%eax
  802ebb:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed8:	48                   	dec    %eax
  802ed9:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eeb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ef2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ef6:	75 17                	jne    802f0f <insert_sorted_with_merge_freeList+0x183>
  802ef8:	83 ec 04             	sub    $0x4,%esp
  802efb:	68 f4 40 80 00       	push   $0x8040f4
  802f00:	68 3f 01 00 00       	push   $0x13f
  802f05:	68 17 41 80 00       	push   $0x804117
  802f0a:	e8 ae d3 ff ff       	call   8002bd <_panic>
  802f0f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f18:	89 10                	mov    %edx,(%eax)
  802f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1d:	8b 00                	mov    (%eax),%eax
  802f1f:	85 c0                	test   %eax,%eax
  802f21:	74 0d                	je     802f30 <insert_sorted_with_merge_freeList+0x1a4>
  802f23:	a1 48 51 80 00       	mov    0x805148,%eax
  802f28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f2b:	89 50 04             	mov    %edx,0x4(%eax)
  802f2e:	eb 08                	jmp    802f38 <insert_sorted_with_merge_freeList+0x1ac>
  802f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f33:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3b:	a3 48 51 80 00       	mov    %eax,0x805148
  802f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4a:	a1 54 51 80 00       	mov    0x805154,%eax
  802f4f:	40                   	inc    %eax
  802f50:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f55:	e9 7a 05 00 00       	jmp    8034d4 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	8b 50 08             	mov    0x8(%eax),%edx
  802f60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f63:	8b 40 08             	mov    0x8(%eax),%eax
  802f66:	39 c2                	cmp    %eax,%edx
  802f68:	0f 82 14 01 00 00    	jb     803082 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f71:	8b 50 08             	mov    0x8(%eax),%edx
  802f74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f77:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7a:	01 c2                	add    %eax,%edx
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	8b 40 08             	mov    0x8(%eax),%eax
  802f82:	39 c2                	cmp    %eax,%edx
  802f84:	0f 85 90 00 00 00    	jne    80301a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8d:	8b 50 0c             	mov    0xc(%eax),%edx
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	8b 40 0c             	mov    0xc(%eax),%eax
  802f96:	01 c2                	add    %eax,%edx
  802f98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb6:	75 17                	jne    802fcf <insert_sorted_with_merge_freeList+0x243>
  802fb8:	83 ec 04             	sub    $0x4,%esp
  802fbb:	68 f4 40 80 00       	push   $0x8040f4
  802fc0:	68 49 01 00 00       	push   $0x149
  802fc5:	68 17 41 80 00       	push   $0x804117
  802fca:	e8 ee d2 ff ff       	call   8002bd <_panic>
  802fcf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	89 10                	mov    %edx,(%eax)
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	74 0d                	je     802ff0 <insert_sorted_with_merge_freeList+0x264>
  802fe3:	a1 48 51 80 00       	mov    0x805148,%eax
  802fe8:	8b 55 08             	mov    0x8(%ebp),%edx
  802feb:	89 50 04             	mov    %edx,0x4(%eax)
  802fee:	eb 08                	jmp    802ff8 <insert_sorted_with_merge_freeList+0x26c>
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	a3 48 51 80 00       	mov    %eax,0x805148
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300a:	a1 54 51 80 00       	mov    0x805154,%eax
  80300f:	40                   	inc    %eax
  803010:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803015:	e9 bb 04 00 00       	jmp    8034d5 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80301a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301e:	75 17                	jne    803037 <insert_sorted_with_merge_freeList+0x2ab>
  803020:	83 ec 04             	sub    $0x4,%esp
  803023:	68 68 41 80 00       	push   $0x804168
  803028:	68 4c 01 00 00       	push   $0x14c
  80302d:	68 17 41 80 00       	push   $0x804117
  803032:	e8 86 d2 ff ff       	call   8002bd <_panic>
  803037:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	89 50 04             	mov    %edx,0x4(%eax)
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	8b 40 04             	mov    0x4(%eax),%eax
  803049:	85 c0                	test   %eax,%eax
  80304b:	74 0c                	je     803059 <insert_sorted_with_merge_freeList+0x2cd>
  80304d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803052:	8b 55 08             	mov    0x8(%ebp),%edx
  803055:	89 10                	mov    %edx,(%eax)
  803057:	eb 08                	jmp    803061 <insert_sorted_with_merge_freeList+0x2d5>
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	a3 38 51 80 00       	mov    %eax,0x805138
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803072:	a1 44 51 80 00       	mov    0x805144,%eax
  803077:	40                   	inc    %eax
  803078:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80307d:	e9 53 04 00 00       	jmp    8034d5 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803082:	a1 38 51 80 00       	mov    0x805138,%eax
  803087:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80308a:	e9 15 04 00 00       	jmp    8034a4 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	8b 50 08             	mov    0x8(%eax),%edx
  80309d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a0:	8b 40 08             	mov    0x8(%eax),%eax
  8030a3:	39 c2                	cmp    %eax,%edx
  8030a5:	0f 86 f1 03 00 00    	jbe    80349c <insert_sorted_with_merge_freeList+0x710>
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	8b 50 08             	mov    0x8(%eax),%edx
  8030b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b4:	8b 40 08             	mov    0x8(%eax),%eax
  8030b7:	39 c2                	cmp    %eax,%edx
  8030b9:	0f 83 dd 03 00 00    	jae    80349c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c2:	8b 50 08             	mov    0x8(%eax),%edx
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cb:	01 c2                	add    %eax,%edx
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	8b 40 08             	mov    0x8(%eax),%eax
  8030d3:	39 c2                	cmp    %eax,%edx
  8030d5:	0f 85 b9 01 00 00    	jne    803294 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030db:	8b 45 08             	mov    0x8(%ebp),%eax
  8030de:	8b 50 08             	mov    0x8(%eax),%edx
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e7:	01 c2                	add    %eax,%edx
  8030e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ec:	8b 40 08             	mov    0x8(%eax),%eax
  8030ef:	39 c2                	cmp    %eax,%edx
  8030f1:	0f 85 0d 01 00 00    	jne    803204 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fa:	8b 50 0c             	mov    0xc(%eax),%edx
  8030fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803100:	8b 40 0c             	mov    0xc(%eax),%eax
  803103:	01 c2                	add    %eax,%edx
  803105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803108:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80310b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80310f:	75 17                	jne    803128 <insert_sorted_with_merge_freeList+0x39c>
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	68 c0 41 80 00       	push   $0x8041c0
  803119:	68 5c 01 00 00       	push   $0x15c
  80311e:	68 17 41 80 00       	push   $0x804117
  803123:	e8 95 d1 ff ff       	call   8002bd <_panic>
  803128:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312b:	8b 00                	mov    (%eax),%eax
  80312d:	85 c0                	test   %eax,%eax
  80312f:	74 10                	je     803141 <insert_sorted_with_merge_freeList+0x3b5>
  803131:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803134:	8b 00                	mov    (%eax),%eax
  803136:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803139:	8b 52 04             	mov    0x4(%edx),%edx
  80313c:	89 50 04             	mov    %edx,0x4(%eax)
  80313f:	eb 0b                	jmp    80314c <insert_sorted_with_merge_freeList+0x3c0>
  803141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803144:	8b 40 04             	mov    0x4(%eax),%eax
  803147:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80314c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314f:	8b 40 04             	mov    0x4(%eax),%eax
  803152:	85 c0                	test   %eax,%eax
  803154:	74 0f                	je     803165 <insert_sorted_with_merge_freeList+0x3d9>
  803156:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803159:	8b 40 04             	mov    0x4(%eax),%eax
  80315c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80315f:	8b 12                	mov    (%edx),%edx
  803161:	89 10                	mov    %edx,(%eax)
  803163:	eb 0a                	jmp    80316f <insert_sorted_with_merge_freeList+0x3e3>
  803165:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803168:	8b 00                	mov    (%eax),%eax
  80316a:	a3 38 51 80 00       	mov    %eax,0x805138
  80316f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803172:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803182:	a1 44 51 80 00       	mov    0x805144,%eax
  803187:	48                   	dec    %eax
  803188:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80318d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803190:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803197:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031a5:	75 17                	jne    8031be <insert_sorted_with_merge_freeList+0x432>
  8031a7:	83 ec 04             	sub    $0x4,%esp
  8031aa:	68 f4 40 80 00       	push   $0x8040f4
  8031af:	68 5f 01 00 00       	push   $0x15f
  8031b4:	68 17 41 80 00       	push   $0x804117
  8031b9:	e8 ff d0 ff ff       	call   8002bd <_panic>
  8031be:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	89 10                	mov    %edx,(%eax)
  8031c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cc:	8b 00                	mov    (%eax),%eax
  8031ce:	85 c0                	test   %eax,%eax
  8031d0:	74 0d                	je     8031df <insert_sorted_with_merge_freeList+0x453>
  8031d2:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031da:	89 50 04             	mov    %edx,0x4(%eax)
  8031dd:	eb 08                	jmp    8031e7 <insert_sorted_with_merge_freeList+0x45b>
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ea:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f9:	a1 54 51 80 00       	mov    0x805154,%eax
  8031fe:	40                   	inc    %eax
  8031ff:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803207:	8b 50 0c             	mov    0xc(%eax),%edx
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	8b 40 0c             	mov    0xc(%eax),%eax
  803210:	01 c2                	add    %eax,%edx
  803212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803215:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80322c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803230:	75 17                	jne    803249 <insert_sorted_with_merge_freeList+0x4bd>
  803232:	83 ec 04             	sub    $0x4,%esp
  803235:	68 f4 40 80 00       	push   $0x8040f4
  80323a:	68 64 01 00 00       	push   $0x164
  80323f:	68 17 41 80 00       	push   $0x804117
  803244:	e8 74 d0 ff ff       	call   8002bd <_panic>
  803249:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	89 10                	mov    %edx,(%eax)
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	8b 00                	mov    (%eax),%eax
  803259:	85 c0                	test   %eax,%eax
  80325b:	74 0d                	je     80326a <insert_sorted_with_merge_freeList+0x4de>
  80325d:	a1 48 51 80 00       	mov    0x805148,%eax
  803262:	8b 55 08             	mov    0x8(%ebp),%edx
  803265:	89 50 04             	mov    %edx,0x4(%eax)
  803268:	eb 08                	jmp    803272 <insert_sorted_with_merge_freeList+0x4e6>
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	a3 48 51 80 00       	mov    %eax,0x805148
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803284:	a1 54 51 80 00       	mov    0x805154,%eax
  803289:	40                   	inc    %eax
  80328a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80328f:	e9 41 02 00 00       	jmp    8034d5 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803294:	8b 45 08             	mov    0x8(%ebp),%eax
  803297:	8b 50 08             	mov    0x8(%eax),%edx
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a0:	01 c2                	add    %eax,%edx
  8032a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a5:	8b 40 08             	mov    0x8(%eax),%eax
  8032a8:	39 c2                	cmp    %eax,%edx
  8032aa:	0f 85 7c 01 00 00    	jne    80342c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032b4:	74 06                	je     8032bc <insert_sorted_with_merge_freeList+0x530>
  8032b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ba:	75 17                	jne    8032d3 <insert_sorted_with_merge_freeList+0x547>
  8032bc:	83 ec 04             	sub    $0x4,%esp
  8032bf:	68 30 41 80 00       	push   $0x804130
  8032c4:	68 69 01 00 00       	push   $0x169
  8032c9:	68 17 41 80 00       	push   $0x804117
  8032ce:	e8 ea cf ff ff       	call   8002bd <_panic>
  8032d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d6:	8b 50 04             	mov    0x4(%eax),%edx
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	89 50 04             	mov    %edx,0x4(%eax)
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e5:	89 10                	mov    %edx,(%eax)
  8032e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ea:	8b 40 04             	mov    0x4(%eax),%eax
  8032ed:	85 c0                	test   %eax,%eax
  8032ef:	74 0d                	je     8032fe <insert_sorted_with_merge_freeList+0x572>
  8032f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f4:	8b 40 04             	mov    0x4(%eax),%eax
  8032f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032fa:	89 10                	mov    %edx,(%eax)
  8032fc:	eb 08                	jmp    803306 <insert_sorted_with_merge_freeList+0x57a>
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	a3 38 51 80 00       	mov    %eax,0x805138
  803306:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803309:	8b 55 08             	mov    0x8(%ebp),%edx
  80330c:	89 50 04             	mov    %edx,0x4(%eax)
  80330f:	a1 44 51 80 00       	mov    0x805144,%eax
  803314:	40                   	inc    %eax
  803315:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80331a:	8b 45 08             	mov    0x8(%ebp),%eax
  80331d:	8b 50 0c             	mov    0xc(%eax),%edx
  803320:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803323:	8b 40 0c             	mov    0xc(%eax),%eax
  803326:	01 c2                	add    %eax,%edx
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80332e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803332:	75 17                	jne    80334b <insert_sorted_with_merge_freeList+0x5bf>
  803334:	83 ec 04             	sub    $0x4,%esp
  803337:	68 c0 41 80 00       	push   $0x8041c0
  80333c:	68 6b 01 00 00       	push   $0x16b
  803341:	68 17 41 80 00       	push   $0x804117
  803346:	e8 72 cf ff ff       	call   8002bd <_panic>
  80334b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	74 10                	je     803364 <insert_sorted_with_merge_freeList+0x5d8>
  803354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335c:	8b 52 04             	mov    0x4(%edx),%edx
  80335f:	89 50 04             	mov    %edx,0x4(%eax)
  803362:	eb 0b                	jmp    80336f <insert_sorted_with_merge_freeList+0x5e3>
  803364:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803367:	8b 40 04             	mov    0x4(%eax),%eax
  80336a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80336f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803372:	8b 40 04             	mov    0x4(%eax),%eax
  803375:	85 c0                	test   %eax,%eax
  803377:	74 0f                	je     803388 <insert_sorted_with_merge_freeList+0x5fc>
  803379:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337c:	8b 40 04             	mov    0x4(%eax),%eax
  80337f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803382:	8b 12                	mov    (%edx),%edx
  803384:	89 10                	mov    %edx,(%eax)
  803386:	eb 0a                	jmp    803392 <insert_sorted_with_merge_freeList+0x606>
  803388:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338b:	8b 00                	mov    (%eax),%eax
  80338d:	a3 38 51 80 00       	mov    %eax,0x805138
  803392:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803395:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80339b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8033aa:	48                   	dec    %eax
  8033ab:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033c8:	75 17                	jne    8033e1 <insert_sorted_with_merge_freeList+0x655>
  8033ca:	83 ec 04             	sub    $0x4,%esp
  8033cd:	68 f4 40 80 00       	push   $0x8040f4
  8033d2:	68 6e 01 00 00       	push   $0x16e
  8033d7:	68 17 41 80 00       	push   $0x804117
  8033dc:	e8 dc ce ff ff       	call   8002bd <_panic>
  8033e1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ea:	89 10                	mov    %edx,(%eax)
  8033ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ef:	8b 00                	mov    (%eax),%eax
  8033f1:	85 c0                	test   %eax,%eax
  8033f3:	74 0d                	je     803402 <insert_sorted_with_merge_freeList+0x676>
  8033f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8033fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033fd:	89 50 04             	mov    %edx,0x4(%eax)
  803400:	eb 08                	jmp    80340a <insert_sorted_with_merge_freeList+0x67e>
  803402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803405:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80340a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340d:	a3 48 51 80 00       	mov    %eax,0x805148
  803412:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803415:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341c:	a1 54 51 80 00       	mov    0x805154,%eax
  803421:	40                   	inc    %eax
  803422:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803427:	e9 a9 00 00 00       	jmp    8034d5 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80342c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803430:	74 06                	je     803438 <insert_sorted_with_merge_freeList+0x6ac>
  803432:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803436:	75 17                	jne    80344f <insert_sorted_with_merge_freeList+0x6c3>
  803438:	83 ec 04             	sub    $0x4,%esp
  80343b:	68 8c 41 80 00       	push   $0x80418c
  803440:	68 73 01 00 00       	push   $0x173
  803445:	68 17 41 80 00       	push   $0x804117
  80344a:	e8 6e ce ff ff       	call   8002bd <_panic>
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	8b 10                	mov    (%eax),%edx
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	89 10                	mov    %edx,(%eax)
  803459:	8b 45 08             	mov    0x8(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	85 c0                	test   %eax,%eax
  803460:	74 0b                	je     80346d <insert_sorted_with_merge_freeList+0x6e1>
  803462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803465:	8b 00                	mov    (%eax),%eax
  803467:	8b 55 08             	mov    0x8(%ebp),%edx
  80346a:	89 50 04             	mov    %edx,0x4(%eax)
  80346d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803470:	8b 55 08             	mov    0x8(%ebp),%edx
  803473:	89 10                	mov    %edx,(%eax)
  803475:	8b 45 08             	mov    0x8(%ebp),%eax
  803478:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80347b:	89 50 04             	mov    %edx,0x4(%eax)
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	8b 00                	mov    (%eax),%eax
  803483:	85 c0                	test   %eax,%eax
  803485:	75 08                	jne    80348f <insert_sorted_with_merge_freeList+0x703>
  803487:	8b 45 08             	mov    0x8(%ebp),%eax
  80348a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80348f:	a1 44 51 80 00       	mov    0x805144,%eax
  803494:	40                   	inc    %eax
  803495:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80349a:	eb 39                	jmp    8034d5 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80349c:	a1 40 51 80 00       	mov    0x805140,%eax
  8034a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a8:	74 07                	je     8034b1 <insert_sorted_with_merge_freeList+0x725>
  8034aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ad:	8b 00                	mov    (%eax),%eax
  8034af:	eb 05                	jmp    8034b6 <insert_sorted_with_merge_freeList+0x72a>
  8034b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b6:	a3 40 51 80 00       	mov    %eax,0x805140
  8034bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8034c0:	85 c0                	test   %eax,%eax
  8034c2:	0f 85 c7 fb ff ff    	jne    80308f <insert_sorted_with_merge_freeList+0x303>
  8034c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034cc:	0f 85 bd fb ff ff    	jne    80308f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034d2:	eb 01                	jmp    8034d5 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034d4:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034d5:	90                   	nop
  8034d6:	c9                   	leave  
  8034d7:	c3                   	ret    

008034d8 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8034d8:	55                   	push   %ebp
  8034d9:	89 e5                	mov    %esp,%ebp
  8034db:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8034de:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e1:	89 d0                	mov    %edx,%eax
  8034e3:	c1 e0 02             	shl    $0x2,%eax
  8034e6:	01 d0                	add    %edx,%eax
  8034e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034ef:	01 d0                	add    %edx,%eax
  8034f1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034f8:	01 d0                	add    %edx,%eax
  8034fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803501:	01 d0                	add    %edx,%eax
  803503:	c1 e0 04             	shl    $0x4,%eax
  803506:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803509:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803510:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803513:	83 ec 0c             	sub    $0xc,%esp
  803516:	50                   	push   %eax
  803517:	e8 26 e7 ff ff       	call   801c42 <sys_get_virtual_time>
  80351c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80351f:	eb 41                	jmp    803562 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803521:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803524:	83 ec 0c             	sub    $0xc,%esp
  803527:	50                   	push   %eax
  803528:	e8 15 e7 ff ff       	call   801c42 <sys_get_virtual_time>
  80352d:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803530:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803533:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803536:	29 c2                	sub    %eax,%edx
  803538:	89 d0                	mov    %edx,%eax
  80353a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80353d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803540:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803543:	89 d1                	mov    %edx,%ecx
  803545:	29 c1                	sub    %eax,%ecx
  803547:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80354a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80354d:	39 c2                	cmp    %eax,%edx
  80354f:	0f 97 c0             	seta   %al
  803552:	0f b6 c0             	movzbl %al,%eax
  803555:	29 c1                	sub    %eax,%ecx
  803557:	89 c8                	mov    %ecx,%eax
  803559:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80355c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80355f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803565:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803568:	72 b7                	jb     803521 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80356a:	90                   	nop
  80356b:	c9                   	leave  
  80356c:	c3                   	ret    

0080356d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80356d:	55                   	push   %ebp
  80356e:	89 e5                	mov    %esp,%ebp
  803570:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803573:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80357a:	eb 03                	jmp    80357f <busy_wait+0x12>
  80357c:	ff 45 fc             	incl   -0x4(%ebp)
  80357f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803582:	3b 45 08             	cmp    0x8(%ebp),%eax
  803585:	72 f5                	jb     80357c <busy_wait+0xf>
	return i;
  803587:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80358a:	c9                   	leave  
  80358b:	c3                   	ret    

0080358c <__udivdi3>:
  80358c:	55                   	push   %ebp
  80358d:	57                   	push   %edi
  80358e:	56                   	push   %esi
  80358f:	53                   	push   %ebx
  803590:	83 ec 1c             	sub    $0x1c,%esp
  803593:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803597:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80359b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80359f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035a3:	89 ca                	mov    %ecx,%edx
  8035a5:	89 f8                	mov    %edi,%eax
  8035a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035ab:	85 f6                	test   %esi,%esi
  8035ad:	75 2d                	jne    8035dc <__udivdi3+0x50>
  8035af:	39 cf                	cmp    %ecx,%edi
  8035b1:	77 65                	ja     803618 <__udivdi3+0x8c>
  8035b3:	89 fd                	mov    %edi,%ebp
  8035b5:	85 ff                	test   %edi,%edi
  8035b7:	75 0b                	jne    8035c4 <__udivdi3+0x38>
  8035b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8035be:	31 d2                	xor    %edx,%edx
  8035c0:	f7 f7                	div    %edi
  8035c2:	89 c5                	mov    %eax,%ebp
  8035c4:	31 d2                	xor    %edx,%edx
  8035c6:	89 c8                	mov    %ecx,%eax
  8035c8:	f7 f5                	div    %ebp
  8035ca:	89 c1                	mov    %eax,%ecx
  8035cc:	89 d8                	mov    %ebx,%eax
  8035ce:	f7 f5                	div    %ebp
  8035d0:	89 cf                	mov    %ecx,%edi
  8035d2:	89 fa                	mov    %edi,%edx
  8035d4:	83 c4 1c             	add    $0x1c,%esp
  8035d7:	5b                   	pop    %ebx
  8035d8:	5e                   	pop    %esi
  8035d9:	5f                   	pop    %edi
  8035da:	5d                   	pop    %ebp
  8035db:	c3                   	ret    
  8035dc:	39 ce                	cmp    %ecx,%esi
  8035de:	77 28                	ja     803608 <__udivdi3+0x7c>
  8035e0:	0f bd fe             	bsr    %esi,%edi
  8035e3:	83 f7 1f             	xor    $0x1f,%edi
  8035e6:	75 40                	jne    803628 <__udivdi3+0x9c>
  8035e8:	39 ce                	cmp    %ecx,%esi
  8035ea:	72 0a                	jb     8035f6 <__udivdi3+0x6a>
  8035ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035f0:	0f 87 9e 00 00 00    	ja     803694 <__udivdi3+0x108>
  8035f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035fb:	89 fa                	mov    %edi,%edx
  8035fd:	83 c4 1c             	add    $0x1c,%esp
  803600:	5b                   	pop    %ebx
  803601:	5e                   	pop    %esi
  803602:	5f                   	pop    %edi
  803603:	5d                   	pop    %ebp
  803604:	c3                   	ret    
  803605:	8d 76 00             	lea    0x0(%esi),%esi
  803608:	31 ff                	xor    %edi,%edi
  80360a:	31 c0                	xor    %eax,%eax
  80360c:	89 fa                	mov    %edi,%edx
  80360e:	83 c4 1c             	add    $0x1c,%esp
  803611:	5b                   	pop    %ebx
  803612:	5e                   	pop    %esi
  803613:	5f                   	pop    %edi
  803614:	5d                   	pop    %ebp
  803615:	c3                   	ret    
  803616:	66 90                	xchg   %ax,%ax
  803618:	89 d8                	mov    %ebx,%eax
  80361a:	f7 f7                	div    %edi
  80361c:	31 ff                	xor    %edi,%edi
  80361e:	89 fa                	mov    %edi,%edx
  803620:	83 c4 1c             	add    $0x1c,%esp
  803623:	5b                   	pop    %ebx
  803624:	5e                   	pop    %esi
  803625:	5f                   	pop    %edi
  803626:	5d                   	pop    %ebp
  803627:	c3                   	ret    
  803628:	bd 20 00 00 00       	mov    $0x20,%ebp
  80362d:	89 eb                	mov    %ebp,%ebx
  80362f:	29 fb                	sub    %edi,%ebx
  803631:	89 f9                	mov    %edi,%ecx
  803633:	d3 e6                	shl    %cl,%esi
  803635:	89 c5                	mov    %eax,%ebp
  803637:	88 d9                	mov    %bl,%cl
  803639:	d3 ed                	shr    %cl,%ebp
  80363b:	89 e9                	mov    %ebp,%ecx
  80363d:	09 f1                	or     %esi,%ecx
  80363f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803643:	89 f9                	mov    %edi,%ecx
  803645:	d3 e0                	shl    %cl,%eax
  803647:	89 c5                	mov    %eax,%ebp
  803649:	89 d6                	mov    %edx,%esi
  80364b:	88 d9                	mov    %bl,%cl
  80364d:	d3 ee                	shr    %cl,%esi
  80364f:	89 f9                	mov    %edi,%ecx
  803651:	d3 e2                	shl    %cl,%edx
  803653:	8b 44 24 08          	mov    0x8(%esp),%eax
  803657:	88 d9                	mov    %bl,%cl
  803659:	d3 e8                	shr    %cl,%eax
  80365b:	09 c2                	or     %eax,%edx
  80365d:	89 d0                	mov    %edx,%eax
  80365f:	89 f2                	mov    %esi,%edx
  803661:	f7 74 24 0c          	divl   0xc(%esp)
  803665:	89 d6                	mov    %edx,%esi
  803667:	89 c3                	mov    %eax,%ebx
  803669:	f7 e5                	mul    %ebp
  80366b:	39 d6                	cmp    %edx,%esi
  80366d:	72 19                	jb     803688 <__udivdi3+0xfc>
  80366f:	74 0b                	je     80367c <__udivdi3+0xf0>
  803671:	89 d8                	mov    %ebx,%eax
  803673:	31 ff                	xor    %edi,%edi
  803675:	e9 58 ff ff ff       	jmp    8035d2 <__udivdi3+0x46>
  80367a:	66 90                	xchg   %ax,%ax
  80367c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803680:	89 f9                	mov    %edi,%ecx
  803682:	d3 e2                	shl    %cl,%edx
  803684:	39 c2                	cmp    %eax,%edx
  803686:	73 e9                	jae    803671 <__udivdi3+0xe5>
  803688:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80368b:	31 ff                	xor    %edi,%edi
  80368d:	e9 40 ff ff ff       	jmp    8035d2 <__udivdi3+0x46>
  803692:	66 90                	xchg   %ax,%ax
  803694:	31 c0                	xor    %eax,%eax
  803696:	e9 37 ff ff ff       	jmp    8035d2 <__udivdi3+0x46>
  80369b:	90                   	nop

0080369c <__umoddi3>:
  80369c:	55                   	push   %ebp
  80369d:	57                   	push   %edi
  80369e:	56                   	push   %esi
  80369f:	53                   	push   %ebx
  8036a0:	83 ec 1c             	sub    $0x1c,%esp
  8036a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036bb:	89 f3                	mov    %esi,%ebx
  8036bd:	89 fa                	mov    %edi,%edx
  8036bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036c3:	89 34 24             	mov    %esi,(%esp)
  8036c6:	85 c0                	test   %eax,%eax
  8036c8:	75 1a                	jne    8036e4 <__umoddi3+0x48>
  8036ca:	39 f7                	cmp    %esi,%edi
  8036cc:	0f 86 a2 00 00 00    	jbe    803774 <__umoddi3+0xd8>
  8036d2:	89 c8                	mov    %ecx,%eax
  8036d4:	89 f2                	mov    %esi,%edx
  8036d6:	f7 f7                	div    %edi
  8036d8:	89 d0                	mov    %edx,%eax
  8036da:	31 d2                	xor    %edx,%edx
  8036dc:	83 c4 1c             	add    $0x1c,%esp
  8036df:	5b                   	pop    %ebx
  8036e0:	5e                   	pop    %esi
  8036e1:	5f                   	pop    %edi
  8036e2:	5d                   	pop    %ebp
  8036e3:	c3                   	ret    
  8036e4:	39 f0                	cmp    %esi,%eax
  8036e6:	0f 87 ac 00 00 00    	ja     803798 <__umoddi3+0xfc>
  8036ec:	0f bd e8             	bsr    %eax,%ebp
  8036ef:	83 f5 1f             	xor    $0x1f,%ebp
  8036f2:	0f 84 ac 00 00 00    	je     8037a4 <__umoddi3+0x108>
  8036f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8036fd:	29 ef                	sub    %ebp,%edi
  8036ff:	89 fe                	mov    %edi,%esi
  803701:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803705:	89 e9                	mov    %ebp,%ecx
  803707:	d3 e0                	shl    %cl,%eax
  803709:	89 d7                	mov    %edx,%edi
  80370b:	89 f1                	mov    %esi,%ecx
  80370d:	d3 ef                	shr    %cl,%edi
  80370f:	09 c7                	or     %eax,%edi
  803711:	89 e9                	mov    %ebp,%ecx
  803713:	d3 e2                	shl    %cl,%edx
  803715:	89 14 24             	mov    %edx,(%esp)
  803718:	89 d8                	mov    %ebx,%eax
  80371a:	d3 e0                	shl    %cl,%eax
  80371c:	89 c2                	mov    %eax,%edx
  80371e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803722:	d3 e0                	shl    %cl,%eax
  803724:	89 44 24 04          	mov    %eax,0x4(%esp)
  803728:	8b 44 24 08          	mov    0x8(%esp),%eax
  80372c:	89 f1                	mov    %esi,%ecx
  80372e:	d3 e8                	shr    %cl,%eax
  803730:	09 d0                	or     %edx,%eax
  803732:	d3 eb                	shr    %cl,%ebx
  803734:	89 da                	mov    %ebx,%edx
  803736:	f7 f7                	div    %edi
  803738:	89 d3                	mov    %edx,%ebx
  80373a:	f7 24 24             	mull   (%esp)
  80373d:	89 c6                	mov    %eax,%esi
  80373f:	89 d1                	mov    %edx,%ecx
  803741:	39 d3                	cmp    %edx,%ebx
  803743:	0f 82 87 00 00 00    	jb     8037d0 <__umoddi3+0x134>
  803749:	0f 84 91 00 00 00    	je     8037e0 <__umoddi3+0x144>
  80374f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803753:	29 f2                	sub    %esi,%edx
  803755:	19 cb                	sbb    %ecx,%ebx
  803757:	89 d8                	mov    %ebx,%eax
  803759:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80375d:	d3 e0                	shl    %cl,%eax
  80375f:	89 e9                	mov    %ebp,%ecx
  803761:	d3 ea                	shr    %cl,%edx
  803763:	09 d0                	or     %edx,%eax
  803765:	89 e9                	mov    %ebp,%ecx
  803767:	d3 eb                	shr    %cl,%ebx
  803769:	89 da                	mov    %ebx,%edx
  80376b:	83 c4 1c             	add    $0x1c,%esp
  80376e:	5b                   	pop    %ebx
  80376f:	5e                   	pop    %esi
  803770:	5f                   	pop    %edi
  803771:	5d                   	pop    %ebp
  803772:	c3                   	ret    
  803773:	90                   	nop
  803774:	89 fd                	mov    %edi,%ebp
  803776:	85 ff                	test   %edi,%edi
  803778:	75 0b                	jne    803785 <__umoddi3+0xe9>
  80377a:	b8 01 00 00 00       	mov    $0x1,%eax
  80377f:	31 d2                	xor    %edx,%edx
  803781:	f7 f7                	div    %edi
  803783:	89 c5                	mov    %eax,%ebp
  803785:	89 f0                	mov    %esi,%eax
  803787:	31 d2                	xor    %edx,%edx
  803789:	f7 f5                	div    %ebp
  80378b:	89 c8                	mov    %ecx,%eax
  80378d:	f7 f5                	div    %ebp
  80378f:	89 d0                	mov    %edx,%eax
  803791:	e9 44 ff ff ff       	jmp    8036da <__umoddi3+0x3e>
  803796:	66 90                	xchg   %ax,%ax
  803798:	89 c8                	mov    %ecx,%eax
  80379a:	89 f2                	mov    %esi,%edx
  80379c:	83 c4 1c             	add    $0x1c,%esp
  80379f:	5b                   	pop    %ebx
  8037a0:	5e                   	pop    %esi
  8037a1:	5f                   	pop    %edi
  8037a2:	5d                   	pop    %ebp
  8037a3:	c3                   	ret    
  8037a4:	3b 04 24             	cmp    (%esp),%eax
  8037a7:	72 06                	jb     8037af <__umoddi3+0x113>
  8037a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037ad:	77 0f                	ja     8037be <__umoddi3+0x122>
  8037af:	89 f2                	mov    %esi,%edx
  8037b1:	29 f9                	sub    %edi,%ecx
  8037b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037b7:	89 14 24             	mov    %edx,(%esp)
  8037ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037c2:	8b 14 24             	mov    (%esp),%edx
  8037c5:	83 c4 1c             	add    $0x1c,%esp
  8037c8:	5b                   	pop    %ebx
  8037c9:	5e                   	pop    %esi
  8037ca:	5f                   	pop    %edi
  8037cb:	5d                   	pop    %ebp
  8037cc:	c3                   	ret    
  8037cd:	8d 76 00             	lea    0x0(%esi),%esi
  8037d0:	2b 04 24             	sub    (%esp),%eax
  8037d3:	19 fa                	sbb    %edi,%edx
  8037d5:	89 d1                	mov    %edx,%ecx
  8037d7:	89 c6                	mov    %eax,%esi
  8037d9:	e9 71 ff ff ff       	jmp    80374f <__umoddi3+0xb3>
  8037de:	66 90                	xchg   %ax,%ax
  8037e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037e4:	72 ea                	jb     8037d0 <__umoddi3+0x134>
  8037e6:	89 d9                	mov    %ebx,%ecx
  8037e8:	e9 62 ff ff ff       	jmp    80374f <__umoddi3+0xb3>
