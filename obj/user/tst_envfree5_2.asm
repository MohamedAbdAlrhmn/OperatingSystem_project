
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
  800045:	68 40 37 80 00       	push   $0x803740
  80004a:	e8 3f 15 00 00       	call   80158e <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 fd 17 00 00       	call   801860 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 95 18 00 00       	call   801900 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 50 37 80 00       	push   $0x803750
  800079:	e8 f3 04 00 00       	call   800571 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 83 37 80 00       	push   $0x803783
  80008f:	e8 3e 1a 00 00       	call   801ad2 <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 8c 37 80 00       	push   $0x80378c
  8000a8:	e8 25 1a 00 00       	call   801ad2 <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 32 1a 00 00       	call   801af0 <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 54 33 00 00       	call   803422 <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 14 1a 00 00       	call   801af0 <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 71 17 00 00       	call   801860 <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 98 37 80 00       	push   $0x803798
  8000f8:	e8 74 04 00 00       	call   800571 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 01 1a 00 00       	call   801b0c <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 f3 19 00 00       	call   801b0c <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 3f 17 00 00       	call   801860 <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 d7 17 00 00       	call   801900 <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 cc 37 80 00       	push   $0x8037cc
  80013f:	e8 2d 04 00 00       	call   800571 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 1c 38 80 00       	push   $0x80381c
  80014f:	6a 23                	push   $0x23
  800151:	68 52 38 80 00       	push   $0x803852
  800156:	e8 62 01 00 00       	call   8002bd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 68 38 80 00       	push   $0x803868
  800166:	e8 06 04 00 00       	call   800571 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 c8 38 80 00       	push   $0x8038c8
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
  800187:	e8 b4 19 00 00       	call   801b40 <sys_getenvindex>
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
  8001f2:	e8 56 17 00 00       	call   80194d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 2c 39 80 00       	push   $0x80392c
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
  800222:	68 54 39 80 00       	push   $0x803954
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
  800253:	68 7c 39 80 00       	push   $0x80397c
  800258:	e8 14 03 00 00       	call   800571 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 d4 39 80 00       	push   $0x8039d4
  800274:	e8 f8 02 00 00       	call   800571 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 2c 39 80 00       	push   $0x80392c
  800284:	e8 e8 02 00 00       	call   800571 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80028c:	e8 d6 16 00 00       	call   801967 <sys_enable_interrupt>

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
  8002a4:	e8 63 18 00 00       	call   801b0c <sys_destroy_env>
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
  8002b5:	e8 b8 18 00 00       	call   801b72 <sys_exit_env>
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
  8002de:	68 e8 39 80 00       	push   $0x8039e8
  8002e3:	e8 89 02 00 00       	call   800571 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002eb:	a1 00 50 80 00       	mov    0x805000,%eax
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	68 ed 39 80 00       	push   $0x8039ed
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
  80031b:	68 09 3a 80 00       	push   $0x803a09
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
  800347:	68 0c 3a 80 00       	push   $0x803a0c
  80034c:	6a 26                	push   $0x26
  80034e:	68 58 3a 80 00       	push   $0x803a58
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
  800419:	68 64 3a 80 00       	push   $0x803a64
  80041e:	6a 3a                	push   $0x3a
  800420:	68 58 3a 80 00       	push   $0x803a58
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
  800489:	68 b8 3a 80 00       	push   $0x803ab8
  80048e:	6a 44                	push   $0x44
  800490:	68 58 3a 80 00       	push   $0x803a58
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
  8004e3:	e8 b7 12 00 00       	call   80179f <sys_cputs>
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
  80055a:	e8 40 12 00 00       	call   80179f <sys_cputs>
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
  8005a4:	e8 a4 13 00 00       	call   80194d <sys_disable_interrupt>
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
  8005c4:	e8 9e 13 00 00       	call   801967 <sys_enable_interrupt>
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
  80060e:	e8 c5 2e 00 00       	call   8034d8 <__udivdi3>
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
  80065e:	e8 85 2f 00 00       	call   8035e8 <__umoddi3>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	05 34 3d 80 00       	add    $0x803d34,%eax
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
  8007b9:	8b 04 85 58 3d 80 00 	mov    0x803d58(,%eax,4),%eax
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
  80089a:	8b 34 9d a0 3b 80 00 	mov    0x803ba0(,%ebx,4),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 19                	jne    8008be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a5:	53                   	push   %ebx
  8008a6:	68 45 3d 80 00       	push   $0x803d45
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
  8008bf:	68 4e 3d 80 00       	push   $0x803d4e
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
  8008ec:	be 51 3d 80 00       	mov    $0x803d51,%esi
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
  801312:	68 b0 3e 80 00       	push   $0x803eb0
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
  8013e2:	e8 fc 04 00 00       	call   8018e3 <sys_allocate_chunk>
  8013e7:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ea:	a1 20 51 80 00       	mov    0x805120,%eax
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	50                   	push   %eax
  8013f3:	e8 71 0b 00 00       	call   801f69 <initialize_MemBlocksList>
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
  801420:	68 d5 3e 80 00       	push   $0x803ed5
  801425:	6a 33                	push   $0x33
  801427:	68 f3 3e 80 00       	push   $0x803ef3
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
  80149f:	68 00 3f 80 00       	push   $0x803f00
  8014a4:	6a 34                	push   $0x34
  8014a6:	68 f3 3e 80 00       	push   $0x803ef3
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
  801537:	e8 75 07 00 00       	call   801cb1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80153c:	85 c0                	test   %eax,%eax
  80153e:	74 11                	je     801551 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801540:	83 ec 0c             	sub    $0xc,%esp
  801543:	ff 75 e8             	pushl  -0x18(%ebp)
  801546:	e8 e0 0d 00 00       	call   80232b <alloc_block_FF>
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
  80155d:	e8 3c 0b 00 00       	call   80209e <insert_sorted_allocList>
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
  801577:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	68 24 3f 80 00       	push   $0x803f24
  801582:	6a 6f                	push   $0x6f
  801584:	68 f3 3e 80 00       	push   $0x803ef3
  801589:	e8 2f ed ff ff       	call   8002bd <_panic>

0080158e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
  801591:	83 ec 38             	sub    $0x38,%esp
  801594:	8b 45 10             	mov    0x10(%ebp),%eax
  801597:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80159a:	e8 5c fd ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  80159f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015a3:	75 0a                	jne    8015af <smalloc+0x21>
  8015a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015aa:	e9 8b 00 00 00       	jmp    80163a <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015af:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bc:	01 d0                	add    %edx,%eax
  8015be:	48                   	dec    %eax
  8015bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ca:	f7 75 f0             	divl   -0x10(%ebp)
  8015cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d0:	29 d0                	sub    %edx,%eax
  8015d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015d5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015dc:	e8 d0 06 00 00       	call   801cb1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015e1:	85 c0                	test   %eax,%eax
  8015e3:	74 11                	je     8015f6 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8015e5:	83 ec 0c             	sub    $0xc,%esp
  8015e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8015eb:	e8 3b 0d 00 00       	call   80232b <alloc_block_FF>
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8015f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015fa:	74 39                	je     801635 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ff:	8b 40 08             	mov    0x8(%eax),%eax
  801602:	89 c2                	mov    %eax,%edx
  801604:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801608:	52                   	push   %edx
  801609:	50                   	push   %eax
  80160a:	ff 75 0c             	pushl  0xc(%ebp)
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	e8 21 04 00 00       	call   801a36 <sys_createSharedObject>
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80161b:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80161f:	74 14                	je     801635 <smalloc+0xa7>
  801621:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801625:	74 0e                	je     801635 <smalloc+0xa7>
  801627:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80162b:	74 08                	je     801635 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801630:	8b 40 08             	mov    0x8(%eax),%eax
  801633:	eb 05                	jmp    80163a <smalloc+0xac>
	}
	return NULL;
  801635:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801642:	e8 b4 fc ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801647:	83 ec 08             	sub    $0x8,%esp
  80164a:	ff 75 0c             	pushl  0xc(%ebp)
  80164d:	ff 75 08             	pushl  0x8(%ebp)
  801650:	e8 0b 04 00 00       	call   801a60 <sys_getSizeOfSharedObject>
  801655:	83 c4 10             	add    $0x10,%esp
  801658:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80165b:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80165f:	74 76                	je     8016d7 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801661:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801668:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166e:	01 d0                	add    %edx,%eax
  801670:	48                   	dec    %eax
  801671:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801674:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801677:	ba 00 00 00 00       	mov    $0x0,%edx
  80167c:	f7 75 ec             	divl   -0x14(%ebp)
  80167f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801682:	29 d0                	sub    %edx,%eax
  801684:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801687:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80168e:	e8 1e 06 00 00       	call   801cb1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801693:	85 c0                	test   %eax,%eax
  801695:	74 11                	je     8016a8 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801697:	83 ec 0c             	sub    $0xc,%esp
  80169a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80169d:	e8 89 0c 00 00       	call   80232b <alloc_block_FF>
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8016a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016ac:	74 29                	je     8016d7 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8016ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b1:	8b 40 08             	mov    0x8(%eax),%eax
  8016b4:	83 ec 04             	sub    $0x4,%esp
  8016b7:	50                   	push   %eax
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	ff 75 08             	pushl  0x8(%ebp)
  8016be:	e8 ba 03 00 00       	call   801a7d <sys_getSharedObject>
  8016c3:	83 c4 10             	add    $0x10,%esp
  8016c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8016c9:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8016cd:	74 08                	je     8016d7 <sget+0x9b>
				return (void *)mem_block->sva;
  8016cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d2:	8b 40 08             	mov    0x8(%eax),%eax
  8016d5:	eb 05                	jmp    8016dc <sget+0xa0>
		}
	}
	return (void *)NULL;
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016e4:	e8 12 fc ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016e9:	83 ec 04             	sub    $0x4,%esp
  8016ec:	68 48 3f 80 00       	push   $0x803f48
  8016f1:	68 f1 00 00 00       	push   $0xf1
  8016f6:	68 f3 3e 80 00       	push   $0x803ef3
  8016fb:	e8 bd eb ff ff       	call   8002bd <_panic>

00801700 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801706:	83 ec 04             	sub    $0x4,%esp
  801709:	68 70 3f 80 00       	push   $0x803f70
  80170e:	68 05 01 00 00       	push   $0x105
  801713:	68 f3 3e 80 00       	push   $0x803ef3
  801718:	e8 a0 eb ff ff       	call   8002bd <_panic>

0080171d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
  801720:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801723:	83 ec 04             	sub    $0x4,%esp
  801726:	68 94 3f 80 00       	push   $0x803f94
  80172b:	68 10 01 00 00       	push   $0x110
  801730:	68 f3 3e 80 00       	push   $0x803ef3
  801735:	e8 83 eb ff ff       	call   8002bd <_panic>

0080173a <shrink>:

}
void shrink(uint32 newSize)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	68 94 3f 80 00       	push   $0x803f94
  801748:	68 15 01 00 00       	push   $0x115
  80174d:	68 f3 3e 80 00       	push   $0x803ef3
  801752:	e8 66 eb ff ff       	call   8002bd <_panic>

00801757 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80175d:	83 ec 04             	sub    $0x4,%esp
  801760:	68 94 3f 80 00       	push   $0x803f94
  801765:	68 1a 01 00 00       	push   $0x11a
  80176a:	68 f3 3e 80 00       	push   $0x803ef3
  80176f:	e8 49 eb ff ff       	call   8002bd <_panic>

00801774 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	57                   	push   %edi
  801778:	56                   	push   %esi
  801779:	53                   	push   %ebx
  80177a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	8b 55 0c             	mov    0xc(%ebp),%edx
  801783:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801786:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801789:	8b 7d 18             	mov    0x18(%ebp),%edi
  80178c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80178f:	cd 30                	int    $0x30
  801791:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801794:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	5b                   	pop    %ebx
  80179b:	5e                   	pop    %esi
  80179c:	5f                   	pop    %edi
  80179d:	5d                   	pop    %ebp
  80179e:	c3                   	ret    

0080179f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	52                   	push   %edx
  8017b7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ba:	50                   	push   %eax
  8017bb:	6a 00                	push   $0x0
  8017bd:	e8 b2 ff ff ff       	call   801774 <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	90                   	nop
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 01                	push   $0x1
  8017d7:	e8 98 ff ff ff       	call   801774 <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	52                   	push   %edx
  8017f1:	50                   	push   %eax
  8017f2:	6a 05                	push   $0x5
  8017f4:	e8 7b ff ff ff       	call   801774 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
  801801:	56                   	push   %esi
  801802:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801803:	8b 75 18             	mov    0x18(%ebp),%esi
  801806:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801809:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180f:	8b 45 08             	mov    0x8(%ebp),%eax
  801812:	56                   	push   %esi
  801813:	53                   	push   %ebx
  801814:	51                   	push   %ecx
  801815:	52                   	push   %edx
  801816:	50                   	push   %eax
  801817:	6a 06                	push   $0x6
  801819:	e8 56 ff ff ff       	call   801774 <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
}
  801821:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801824:	5b                   	pop    %ebx
  801825:	5e                   	pop    %esi
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    

00801828 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80182b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	52                   	push   %edx
  801838:	50                   	push   %eax
  801839:	6a 07                	push   $0x7
  80183b:	e8 34 ff ff ff       	call   801774 <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	ff 75 08             	pushl  0x8(%ebp)
  801854:	6a 08                	push   $0x8
  801856:	e8 19 ff ff ff       	call   801774 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 09                	push   $0x9
  80186f:	e8 00 ff ff ff       	call   801774 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 0a                	push   $0xa
  801888:	e8 e7 fe ff ff       	call   801774 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 0b                	push   $0xb
  8018a1:	e8 ce fe ff ff       	call   801774 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	ff 75 0c             	pushl  0xc(%ebp)
  8018b7:	ff 75 08             	pushl  0x8(%ebp)
  8018ba:	6a 0f                	push   $0xf
  8018bc:	e8 b3 fe ff ff       	call   801774 <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
	return;
  8018c4:	90                   	nop
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	ff 75 0c             	pushl  0xc(%ebp)
  8018d3:	ff 75 08             	pushl  0x8(%ebp)
  8018d6:	6a 10                	push   $0x10
  8018d8:	e8 97 fe ff ff       	call   801774 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e0:	90                   	nop
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	ff 75 10             	pushl  0x10(%ebp)
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	ff 75 08             	pushl  0x8(%ebp)
  8018f3:	6a 11                	push   $0x11
  8018f5:	e8 7a fe ff ff       	call   801774 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fd:	90                   	nop
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 0c                	push   $0xc
  80190f:	e8 60 fe ff ff       	call   801774 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	ff 75 08             	pushl  0x8(%ebp)
  801927:	6a 0d                	push   $0xd
  801929:	e8 46 fe ff ff       	call   801774 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 0e                	push   $0xe
  801942:	e8 2d fe ff ff       	call   801774 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	90                   	nop
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 13                	push   $0x13
  80195c:	e8 13 fe ff ff       	call   801774 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	90                   	nop
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 14                	push   $0x14
  801976:	e8 f9 fd ff ff       	call   801774 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	90                   	nop
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_cputc>:


void
sys_cputc(const char c)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 04             	sub    $0x4,%esp
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80198d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	50                   	push   %eax
  80199a:	6a 15                	push   $0x15
  80199c:	e8 d3 fd ff ff       	call   801774 <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
}
  8019a4:	90                   	nop
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 16                	push   $0x16
  8019b6:	e8 b9 fd ff ff       	call   801774 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	90                   	nop
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	ff 75 0c             	pushl  0xc(%ebp)
  8019d0:	50                   	push   %eax
  8019d1:	6a 17                	push   $0x17
  8019d3:	e8 9c fd ff ff       	call   801774 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	52                   	push   %edx
  8019ed:	50                   	push   %eax
  8019ee:	6a 1a                	push   $0x1a
  8019f0:	e8 7f fd ff ff       	call   801774 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	52                   	push   %edx
  801a0a:	50                   	push   %eax
  801a0b:	6a 18                	push   $0x18
  801a0d:	e8 62 fd ff ff       	call   801774 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	52                   	push   %edx
  801a28:	50                   	push   %eax
  801a29:	6a 19                	push   $0x19
  801a2b:	e8 44 fd ff ff       	call   801774 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	90                   	nop
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a42:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a45:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	6a 00                	push   $0x0
  801a4e:	51                   	push   %ecx
  801a4f:	52                   	push   %edx
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	50                   	push   %eax
  801a54:	6a 1b                	push   $0x1b
  801a56:	e8 19 fd ff ff       	call   801774 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	52                   	push   %edx
  801a70:	50                   	push   %eax
  801a71:	6a 1c                	push   $0x1c
  801a73:	e8 fc fc ff ff       	call   801774 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a80:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a86:	8b 45 08             	mov    0x8(%ebp),%eax
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	51                   	push   %ecx
  801a8e:	52                   	push   %edx
  801a8f:	50                   	push   %eax
  801a90:	6a 1d                	push   $0x1d
  801a92:	e8 dd fc ff ff       	call   801774 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	52                   	push   %edx
  801aac:	50                   	push   %eax
  801aad:	6a 1e                	push   $0x1e
  801aaf:	e8 c0 fc ff ff       	call   801774 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 1f                	push   $0x1f
  801ac8:	e8 a7 fc ff ff       	call   801774 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	ff 75 14             	pushl  0x14(%ebp)
  801add:	ff 75 10             	pushl  0x10(%ebp)
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	50                   	push   %eax
  801ae4:	6a 20                	push   $0x20
  801ae6:	e8 89 fc ff ff       	call   801774 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	50                   	push   %eax
  801aff:	6a 21                	push   $0x21
  801b01:	e8 6e fc ff ff       	call   801774 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	90                   	nop
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	50                   	push   %eax
  801b1b:	6a 22                	push   $0x22
  801b1d:	e8 52 fc ff ff       	call   801774 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 02                	push   $0x2
  801b36:	e8 39 fc ff ff       	call   801774 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 03                	push   $0x3
  801b4f:	e8 20 fc ff ff       	call   801774 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 04                	push   $0x4
  801b68:	e8 07 fc ff ff       	call   801774 <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_exit_env>:


void sys_exit_env(void)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 23                	push   $0x23
  801b81:	e8 ee fb ff ff       	call   801774 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	90                   	nop
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b92:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b95:	8d 50 04             	lea    0x4(%eax),%edx
  801b98:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 24                	push   $0x24
  801ba5:	e8 ca fb ff ff       	call   801774 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
	return result;
  801bad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb6:	89 01                	mov    %eax,(%ecx)
  801bb8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	c9                   	leave  
  801bbf:	c2 04 00             	ret    $0x4

00801bc2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	ff 75 10             	pushl  0x10(%ebp)
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	ff 75 08             	pushl  0x8(%ebp)
  801bd2:	6a 12                	push   $0x12
  801bd4:	e8 9b fb ff ff       	call   801774 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdc:	90                   	nop
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_rcr2>:
uint32 sys_rcr2()
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 25                	push   $0x25
  801bee:	e8 81 fb ff ff       	call   801774 <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 04             	sub    $0x4,%esp
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c04:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	50                   	push   %eax
  801c11:	6a 26                	push   $0x26
  801c13:	e8 5c fb ff ff       	call   801774 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1b:	90                   	nop
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <rsttst>:
void rsttst()
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 28                	push   $0x28
  801c2d:	e8 42 fb ff ff       	call   801774 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
	return ;
  801c35:	90                   	nop
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	83 ec 04             	sub    $0x4,%esp
  801c3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c44:	8b 55 18             	mov    0x18(%ebp),%edx
  801c47:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c4b:	52                   	push   %edx
  801c4c:	50                   	push   %eax
  801c4d:	ff 75 10             	pushl  0x10(%ebp)
  801c50:	ff 75 0c             	pushl  0xc(%ebp)
  801c53:	ff 75 08             	pushl  0x8(%ebp)
  801c56:	6a 27                	push   $0x27
  801c58:	e8 17 fb ff ff       	call   801774 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c60:	90                   	nop
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <chktst>:
void chktst(uint32 n)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	ff 75 08             	pushl  0x8(%ebp)
  801c71:	6a 29                	push   $0x29
  801c73:	e8 fc fa ff ff       	call   801774 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7b:	90                   	nop
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <inctst>:

void inctst()
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 2a                	push   $0x2a
  801c8d:	e8 e2 fa ff ff       	call   801774 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
	return ;
  801c95:	90                   	nop
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <gettst>:
uint32 gettst()
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 2b                	push   $0x2b
  801ca7:	e8 c8 fa ff ff       	call   801774 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
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
  801cc3:	e8 ac fa ff ff       	call   801774 <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
  801ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cce:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cd2:	75 07                	jne    801cdb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cd4:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd9:	eb 05                	jmp    801ce0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
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
  801cf4:	e8 7b fa ff ff       	call   801774 <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
  801cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cff:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d03:	75 07                	jne    801d0c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d05:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0a:	eb 05                	jmp    801d11 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
  801d16:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 2c                	push   $0x2c
  801d25:	e8 4a fa ff ff       	call   801774 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
  801d2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d30:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d34:	75 07                	jne    801d3d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d36:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3b:	eb 05                	jmp    801d42 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 2c                	push   $0x2c
  801d56:	e8 19 fa ff ff       	call   801774 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
  801d5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d61:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d65:	75 07                	jne    801d6e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d67:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6c:	eb 05                	jmp    801d73 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	ff 75 08             	pushl  0x8(%ebp)
  801d83:	6a 2d                	push   $0x2d
  801d85:	e8 ea f9 ff ff       	call   801774 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8d:	90                   	nop
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d94:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	6a 00                	push   $0x0
  801da2:	53                   	push   %ebx
  801da3:	51                   	push   %ecx
  801da4:	52                   	push   %edx
  801da5:	50                   	push   %eax
  801da6:	6a 2e                	push   $0x2e
  801da8:	e8 c7 f9 ff ff       	call   801774 <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
}
  801db0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	52                   	push   %edx
  801dc5:	50                   	push   %eax
  801dc6:	6a 2f                	push   $0x2f
  801dc8:	e8 a7 f9 ff ff       	call   801774 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	68 a4 3f 80 00       	push   $0x803fa4
  801de0:	e8 8c e7 ff ff       	call   800571 <cprintf>
  801de5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801de8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801def:	83 ec 0c             	sub    $0xc,%esp
  801df2:	68 d0 3f 80 00       	push   $0x803fd0
  801df7:	e8 75 e7 ff ff       	call   800571 <cprintf>
  801dfc:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801dff:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e03:	a1 38 51 80 00       	mov    0x805138,%eax
  801e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e0b:	eb 56                	jmp    801e63 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e11:	74 1c                	je     801e2f <print_mem_block_lists+0x5d>
  801e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e16:	8b 50 08             	mov    0x8(%eax),%edx
  801e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1c:	8b 48 08             	mov    0x8(%eax),%ecx
  801e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e22:	8b 40 0c             	mov    0xc(%eax),%eax
  801e25:	01 c8                	add    %ecx,%eax
  801e27:	39 c2                	cmp    %eax,%edx
  801e29:	73 04                	jae    801e2f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e2b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e32:	8b 50 08             	mov    0x8(%eax),%edx
  801e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e38:	8b 40 0c             	mov    0xc(%eax),%eax
  801e3b:	01 c2                	add    %eax,%edx
  801e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e40:	8b 40 08             	mov    0x8(%eax),%eax
  801e43:	83 ec 04             	sub    $0x4,%esp
  801e46:	52                   	push   %edx
  801e47:	50                   	push   %eax
  801e48:	68 e5 3f 80 00       	push   $0x803fe5
  801e4d:	e8 1f e7 ff ff       	call   800571 <cprintf>
  801e52:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e5b:	a1 40 51 80 00       	mov    0x805140,%eax
  801e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e67:	74 07                	je     801e70 <print_mem_block_lists+0x9e>
  801e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6c:	8b 00                	mov    (%eax),%eax
  801e6e:	eb 05                	jmp    801e75 <print_mem_block_lists+0xa3>
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
  801e75:	a3 40 51 80 00       	mov    %eax,0x805140
  801e7a:	a1 40 51 80 00       	mov    0x805140,%eax
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	75 8a                	jne    801e0d <print_mem_block_lists+0x3b>
  801e83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e87:	75 84                	jne    801e0d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e89:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e8d:	75 10                	jne    801e9f <print_mem_block_lists+0xcd>
  801e8f:	83 ec 0c             	sub    $0xc,%esp
  801e92:	68 f4 3f 80 00       	push   $0x803ff4
  801e97:	e8 d5 e6 ff ff       	call   800571 <cprintf>
  801e9c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ea6:	83 ec 0c             	sub    $0xc,%esp
  801ea9:	68 18 40 80 00       	push   $0x804018
  801eae:	e8 be e6 ff ff       	call   800571 <cprintf>
  801eb3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801eb6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eba:	a1 40 50 80 00       	mov    0x805040,%eax
  801ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec2:	eb 56                	jmp    801f1a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ec4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ec8:	74 1c                	je     801ee6 <print_mem_block_lists+0x114>
  801eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecd:	8b 50 08             	mov    0x8(%eax),%edx
  801ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed3:	8b 48 08             	mov    0x8(%eax),%ecx
  801ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed9:	8b 40 0c             	mov    0xc(%eax),%eax
  801edc:	01 c8                	add    %ecx,%eax
  801ede:	39 c2                	cmp    %eax,%edx
  801ee0:	73 04                	jae    801ee6 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ee2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee9:	8b 50 08             	mov    0x8(%eax),%edx
  801eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eef:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef2:	01 c2                	add    %eax,%edx
  801ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef7:	8b 40 08             	mov    0x8(%eax),%eax
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	52                   	push   %edx
  801efe:	50                   	push   %eax
  801eff:	68 e5 3f 80 00       	push   $0x803fe5
  801f04:	e8 68 e6 ff ff       	call   800571 <cprintf>
  801f09:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f12:	a1 48 50 80 00       	mov    0x805048,%eax
  801f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f1e:	74 07                	je     801f27 <print_mem_block_lists+0x155>
  801f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f23:	8b 00                	mov    (%eax),%eax
  801f25:	eb 05                	jmp    801f2c <print_mem_block_lists+0x15a>
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2c:	a3 48 50 80 00       	mov    %eax,0x805048
  801f31:	a1 48 50 80 00       	mov    0x805048,%eax
  801f36:	85 c0                	test   %eax,%eax
  801f38:	75 8a                	jne    801ec4 <print_mem_block_lists+0xf2>
  801f3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f3e:	75 84                	jne    801ec4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f40:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f44:	75 10                	jne    801f56 <print_mem_block_lists+0x184>
  801f46:	83 ec 0c             	sub    $0xc,%esp
  801f49:	68 30 40 80 00       	push   $0x804030
  801f4e:	e8 1e e6 ff ff       	call   800571 <cprintf>
  801f53:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f56:	83 ec 0c             	sub    $0xc,%esp
  801f59:	68 a4 3f 80 00       	push   $0x803fa4
  801f5e:	e8 0e e6 ff ff       	call   800571 <cprintf>
  801f63:	83 c4 10             	add    $0x10,%esp

}
  801f66:	90                   	nop
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f6f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f76:	00 00 00 
  801f79:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f80:	00 00 00 
  801f83:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f8a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f94:	e9 9e 00 00 00       	jmp    802037 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f99:	a1 50 50 80 00       	mov    0x805050,%eax
  801f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa1:	c1 e2 04             	shl    $0x4,%edx
  801fa4:	01 d0                	add    %edx,%eax
  801fa6:	85 c0                	test   %eax,%eax
  801fa8:	75 14                	jne    801fbe <initialize_MemBlocksList+0x55>
  801faa:	83 ec 04             	sub    $0x4,%esp
  801fad:	68 58 40 80 00       	push   $0x804058
  801fb2:	6a 46                	push   $0x46
  801fb4:	68 7b 40 80 00       	push   $0x80407b
  801fb9:	e8 ff e2 ff ff       	call   8002bd <_panic>
  801fbe:	a1 50 50 80 00       	mov    0x805050,%eax
  801fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc6:	c1 e2 04             	shl    $0x4,%edx
  801fc9:	01 d0                	add    %edx,%eax
  801fcb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fd1:	89 10                	mov    %edx,(%eax)
  801fd3:	8b 00                	mov    (%eax),%eax
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	74 18                	je     801ff1 <initialize_MemBlocksList+0x88>
  801fd9:	a1 48 51 80 00       	mov    0x805148,%eax
  801fde:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fe4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fe7:	c1 e1 04             	shl    $0x4,%ecx
  801fea:	01 ca                	add    %ecx,%edx
  801fec:	89 50 04             	mov    %edx,0x4(%eax)
  801fef:	eb 12                	jmp    802003 <initialize_MemBlocksList+0x9a>
  801ff1:	a1 50 50 80 00       	mov    0x805050,%eax
  801ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff9:	c1 e2 04             	shl    $0x4,%edx
  801ffc:	01 d0                	add    %edx,%eax
  801ffe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802003:	a1 50 50 80 00       	mov    0x805050,%eax
  802008:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200b:	c1 e2 04             	shl    $0x4,%edx
  80200e:	01 d0                	add    %edx,%eax
  802010:	a3 48 51 80 00       	mov    %eax,0x805148
  802015:	a1 50 50 80 00       	mov    0x805050,%eax
  80201a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201d:	c1 e2 04             	shl    $0x4,%edx
  802020:	01 d0                	add    %edx,%eax
  802022:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802029:	a1 54 51 80 00       	mov    0x805154,%eax
  80202e:	40                   	inc    %eax
  80202f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802034:	ff 45 f4             	incl   -0xc(%ebp)
  802037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80203d:	0f 82 56 ff ff ff    	jb     801f99 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802043:	90                   	nop
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	8b 00                	mov    (%eax),%eax
  802051:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802054:	eb 19                	jmp    80206f <find_block+0x29>
	{
		if(va==point->sva)
  802056:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802059:	8b 40 08             	mov    0x8(%eax),%eax
  80205c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80205f:	75 05                	jne    802066 <find_block+0x20>
		   return point;
  802061:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802064:	eb 36                	jmp    80209c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	8b 40 08             	mov    0x8(%eax),%eax
  80206c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80206f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802073:	74 07                	je     80207c <find_block+0x36>
  802075:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802078:	8b 00                	mov    (%eax),%eax
  80207a:	eb 05                	jmp    802081 <find_block+0x3b>
  80207c:	b8 00 00 00 00       	mov    $0x0,%eax
  802081:	8b 55 08             	mov    0x8(%ebp),%edx
  802084:	89 42 08             	mov    %eax,0x8(%edx)
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	8b 40 08             	mov    0x8(%eax),%eax
  80208d:	85 c0                	test   %eax,%eax
  80208f:	75 c5                	jne    802056 <find_block+0x10>
  802091:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802095:	75 bf                	jne    802056 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020a4:	a1 40 50 80 00       	mov    0x805040,%eax
  8020a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020ac:	a1 44 50 80 00       	mov    0x805044,%eax
  8020b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020ba:	74 24                	je     8020e0 <insert_sorted_allocList+0x42>
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	8b 50 08             	mov    0x8(%eax),%edx
  8020c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c5:	8b 40 08             	mov    0x8(%eax),%eax
  8020c8:	39 c2                	cmp    %eax,%edx
  8020ca:	76 14                	jbe    8020e0 <insert_sorted_allocList+0x42>
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	8b 50 08             	mov    0x8(%eax),%edx
  8020d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d5:	8b 40 08             	mov    0x8(%eax),%eax
  8020d8:	39 c2                	cmp    %eax,%edx
  8020da:	0f 82 60 01 00 00    	jb     802240 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020e4:	75 65                	jne    80214b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ea:	75 14                	jne    802100 <insert_sorted_allocList+0x62>
  8020ec:	83 ec 04             	sub    $0x4,%esp
  8020ef:	68 58 40 80 00       	push   $0x804058
  8020f4:	6a 6b                	push   $0x6b
  8020f6:	68 7b 40 80 00       	push   $0x80407b
  8020fb:	e8 bd e1 ff ff       	call   8002bd <_panic>
  802100:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	89 10                	mov    %edx,(%eax)
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	8b 00                	mov    (%eax),%eax
  802110:	85 c0                	test   %eax,%eax
  802112:	74 0d                	je     802121 <insert_sorted_allocList+0x83>
  802114:	a1 40 50 80 00       	mov    0x805040,%eax
  802119:	8b 55 08             	mov    0x8(%ebp),%edx
  80211c:	89 50 04             	mov    %edx,0x4(%eax)
  80211f:	eb 08                	jmp    802129 <insert_sorted_allocList+0x8b>
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	a3 44 50 80 00       	mov    %eax,0x805044
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	a3 40 50 80 00       	mov    %eax,0x805040
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80213b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802140:	40                   	inc    %eax
  802141:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802146:	e9 dc 01 00 00       	jmp    802327 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	8b 50 08             	mov    0x8(%eax),%edx
  802151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802154:	8b 40 08             	mov    0x8(%eax),%eax
  802157:	39 c2                	cmp    %eax,%edx
  802159:	77 6c                	ja     8021c7 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80215b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80215f:	74 06                	je     802167 <insert_sorted_allocList+0xc9>
  802161:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802165:	75 14                	jne    80217b <insert_sorted_allocList+0xdd>
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	68 94 40 80 00       	push   $0x804094
  80216f:	6a 6f                	push   $0x6f
  802171:	68 7b 40 80 00       	push   $0x80407b
  802176:	e8 42 e1 ff ff       	call   8002bd <_panic>
  80217b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217e:	8b 50 04             	mov    0x4(%eax),%edx
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	89 50 04             	mov    %edx,0x4(%eax)
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80218d:	89 10                	mov    %edx,(%eax)
  80218f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802192:	8b 40 04             	mov    0x4(%eax),%eax
  802195:	85 c0                	test   %eax,%eax
  802197:	74 0d                	je     8021a6 <insert_sorted_allocList+0x108>
  802199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219c:	8b 40 04             	mov    0x4(%eax),%eax
  80219f:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a2:	89 10                	mov    %edx,(%eax)
  8021a4:	eb 08                	jmp    8021ae <insert_sorted_allocList+0x110>
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	a3 40 50 80 00       	mov    %eax,0x805040
  8021ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b4:	89 50 04             	mov    %edx,0x4(%eax)
  8021b7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021bc:	40                   	inc    %eax
  8021bd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021c2:	e9 60 01 00 00       	jmp    802327 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	8b 50 08             	mov    0x8(%eax),%edx
  8021cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d0:	8b 40 08             	mov    0x8(%eax),%eax
  8021d3:	39 c2                	cmp    %eax,%edx
  8021d5:	0f 82 4c 01 00 00    	jb     802327 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021df:	75 14                	jne    8021f5 <insert_sorted_allocList+0x157>
  8021e1:	83 ec 04             	sub    $0x4,%esp
  8021e4:	68 cc 40 80 00       	push   $0x8040cc
  8021e9:	6a 73                	push   $0x73
  8021eb:	68 7b 40 80 00       	push   $0x80407b
  8021f0:	e8 c8 e0 ff ff       	call   8002bd <_panic>
  8021f5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	89 50 04             	mov    %edx,0x4(%eax)
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	8b 40 04             	mov    0x4(%eax),%eax
  802207:	85 c0                	test   %eax,%eax
  802209:	74 0c                	je     802217 <insert_sorted_allocList+0x179>
  80220b:	a1 44 50 80 00       	mov    0x805044,%eax
  802210:	8b 55 08             	mov    0x8(%ebp),%edx
  802213:	89 10                	mov    %edx,(%eax)
  802215:	eb 08                	jmp    80221f <insert_sorted_allocList+0x181>
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	a3 40 50 80 00       	mov    %eax,0x805040
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	a3 44 50 80 00       	mov    %eax,0x805044
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802230:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802235:	40                   	inc    %eax
  802236:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80223b:	e9 e7 00 00 00       	jmp    802327 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802243:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802246:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80224d:	a1 40 50 80 00       	mov    0x805040,%eax
  802252:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802255:	e9 9d 00 00 00       	jmp    8022f7 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	8b 00                	mov    (%eax),%eax
  80225f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	8b 50 08             	mov    0x8(%eax),%edx
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	8b 40 08             	mov    0x8(%eax),%eax
  80226e:	39 c2                	cmp    %eax,%edx
  802270:	76 7d                	jbe    8022ef <insert_sorted_allocList+0x251>
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	8b 50 08             	mov    0x8(%eax),%edx
  802278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80227b:	8b 40 08             	mov    0x8(%eax),%eax
  80227e:	39 c2                	cmp    %eax,%edx
  802280:	73 6d                	jae    8022ef <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802286:	74 06                	je     80228e <insert_sorted_allocList+0x1f0>
  802288:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80228c:	75 14                	jne    8022a2 <insert_sorted_allocList+0x204>
  80228e:	83 ec 04             	sub    $0x4,%esp
  802291:	68 f0 40 80 00       	push   $0x8040f0
  802296:	6a 7f                	push   $0x7f
  802298:	68 7b 40 80 00       	push   $0x80407b
  80229d:	e8 1b e0 ff ff       	call   8002bd <_panic>
  8022a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a5:	8b 10                	mov    (%eax),%edx
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	89 10                	mov    %edx,(%eax)
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8b 00                	mov    (%eax),%eax
  8022b1:	85 c0                	test   %eax,%eax
  8022b3:	74 0b                	je     8022c0 <insert_sorted_allocList+0x222>
  8022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b8:	8b 00                	mov    (%eax),%eax
  8022ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bd:	89 50 04             	mov    %edx,0x4(%eax)
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c6:	89 10                	mov    %edx,(%eax)
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ce:	89 50 04             	mov    %edx,0x4(%eax)
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	8b 00                	mov    (%eax),%eax
  8022d6:	85 c0                	test   %eax,%eax
  8022d8:	75 08                	jne    8022e2 <insert_sorted_allocList+0x244>
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	a3 44 50 80 00       	mov    %eax,0x805044
  8022e2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022e7:	40                   	inc    %eax
  8022e8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022ed:	eb 39                	jmp    802328 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022ef:	a1 48 50 80 00       	mov    0x805048,%eax
  8022f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fb:	74 07                	je     802304 <insert_sorted_allocList+0x266>
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 00                	mov    (%eax),%eax
  802302:	eb 05                	jmp    802309 <insert_sorted_allocList+0x26b>
  802304:	b8 00 00 00 00       	mov    $0x0,%eax
  802309:	a3 48 50 80 00       	mov    %eax,0x805048
  80230e:	a1 48 50 80 00       	mov    0x805048,%eax
  802313:	85 c0                	test   %eax,%eax
  802315:	0f 85 3f ff ff ff    	jne    80225a <insert_sorted_allocList+0x1bc>
  80231b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231f:	0f 85 35 ff ff ff    	jne    80225a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802325:	eb 01                	jmp    802328 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802327:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802328:	90                   	nop
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802331:	a1 38 51 80 00       	mov    0x805138,%eax
  802336:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802339:	e9 85 01 00 00       	jmp    8024c3 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 40 0c             	mov    0xc(%eax),%eax
  802344:	3b 45 08             	cmp    0x8(%ebp),%eax
  802347:	0f 82 6e 01 00 00    	jb     8024bb <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 40 0c             	mov    0xc(%eax),%eax
  802353:	3b 45 08             	cmp    0x8(%ebp),%eax
  802356:	0f 85 8a 00 00 00    	jne    8023e6 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80235c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802360:	75 17                	jne    802379 <alloc_block_FF+0x4e>
  802362:	83 ec 04             	sub    $0x4,%esp
  802365:	68 24 41 80 00       	push   $0x804124
  80236a:	68 93 00 00 00       	push   $0x93
  80236f:	68 7b 40 80 00       	push   $0x80407b
  802374:	e8 44 df ff ff       	call   8002bd <_panic>
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 00                	mov    (%eax),%eax
  80237e:	85 c0                	test   %eax,%eax
  802380:	74 10                	je     802392 <alloc_block_FF+0x67>
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 00                	mov    (%eax),%eax
  802387:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238a:	8b 52 04             	mov    0x4(%edx),%edx
  80238d:	89 50 04             	mov    %edx,0x4(%eax)
  802390:	eb 0b                	jmp    80239d <alloc_block_FF+0x72>
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 40 04             	mov    0x4(%eax),%eax
  802398:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 40 04             	mov    0x4(%eax),%eax
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	74 0f                	je     8023b6 <alloc_block_FF+0x8b>
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 40 04             	mov    0x4(%eax),%eax
  8023ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b0:	8b 12                	mov    (%edx),%edx
  8023b2:	89 10                	mov    %edx,(%eax)
  8023b4:	eb 0a                	jmp    8023c0 <alloc_block_FF+0x95>
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 00                	mov    (%eax),%eax
  8023bb:	a3 38 51 80 00       	mov    %eax,0x805138
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d3:	a1 44 51 80 00       	mov    0x805144,%eax
  8023d8:	48                   	dec    %eax
  8023d9:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	e9 10 01 00 00       	jmp    8024f6 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ef:	0f 86 c6 00 00 00    	jbe    8024bb <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8023fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 50 08             	mov    0x8(%eax),%edx
  802403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802406:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240c:	8b 55 08             	mov    0x8(%ebp),%edx
  80240f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802412:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802416:	75 17                	jne    80242f <alloc_block_FF+0x104>
  802418:	83 ec 04             	sub    $0x4,%esp
  80241b:	68 24 41 80 00       	push   $0x804124
  802420:	68 9b 00 00 00       	push   $0x9b
  802425:	68 7b 40 80 00       	push   $0x80407b
  80242a:	e8 8e de ff ff       	call   8002bd <_panic>
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	85 c0                	test   %eax,%eax
  802436:	74 10                	je     802448 <alloc_block_FF+0x11d>
  802438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243b:	8b 00                	mov    (%eax),%eax
  80243d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802440:	8b 52 04             	mov    0x4(%edx),%edx
  802443:	89 50 04             	mov    %edx,0x4(%eax)
  802446:	eb 0b                	jmp    802453 <alloc_block_FF+0x128>
  802448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802456:	8b 40 04             	mov    0x4(%eax),%eax
  802459:	85 c0                	test   %eax,%eax
  80245b:	74 0f                	je     80246c <alloc_block_FF+0x141>
  80245d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802460:	8b 40 04             	mov    0x4(%eax),%eax
  802463:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802466:	8b 12                	mov    (%edx),%edx
  802468:	89 10                	mov    %edx,(%eax)
  80246a:	eb 0a                	jmp    802476 <alloc_block_FF+0x14b>
  80246c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246f:	8b 00                	mov    (%eax),%eax
  802471:	a3 48 51 80 00       	mov    %eax,0x805148
  802476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80247f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802482:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802489:	a1 54 51 80 00       	mov    0x805154,%eax
  80248e:	48                   	dec    %eax
  80248f:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 50 08             	mov    0x8(%eax),%edx
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	01 c2                	add    %eax,%edx
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ab:	2b 45 08             	sub    0x8(%ebp),%eax
  8024ae:	89 c2                	mov    %eax,%edx
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b9:	eb 3b                	jmp    8024f6 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8024c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c7:	74 07                	je     8024d0 <alloc_block_FF+0x1a5>
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 00                	mov    (%eax),%eax
  8024ce:	eb 05                	jmp    8024d5 <alloc_block_FF+0x1aa>
  8024d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d5:	a3 40 51 80 00       	mov    %eax,0x805140
  8024da:	a1 40 51 80 00       	mov    0x805140,%eax
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	0f 85 57 fe ff ff    	jne    80233e <alloc_block_FF+0x13>
  8024e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024eb:	0f 85 4d fe ff ff    	jne    80233e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f6:	c9                   	leave  
  8024f7:	c3                   	ret    

008024f8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024fe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802505:	a1 38 51 80 00       	mov    0x805138,%eax
  80250a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250d:	e9 df 00 00 00       	jmp    8025f1 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 40 0c             	mov    0xc(%eax),%eax
  802518:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251b:	0f 82 c8 00 00 00    	jb     8025e9 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 40 0c             	mov    0xc(%eax),%eax
  802527:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252a:	0f 85 8a 00 00 00    	jne    8025ba <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802530:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802534:	75 17                	jne    80254d <alloc_block_BF+0x55>
  802536:	83 ec 04             	sub    $0x4,%esp
  802539:	68 24 41 80 00       	push   $0x804124
  80253e:	68 b7 00 00 00       	push   $0xb7
  802543:	68 7b 40 80 00       	push   $0x80407b
  802548:	e8 70 dd ff ff       	call   8002bd <_panic>
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 00                	mov    (%eax),%eax
  802552:	85 c0                	test   %eax,%eax
  802554:	74 10                	je     802566 <alloc_block_BF+0x6e>
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 00                	mov    (%eax),%eax
  80255b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255e:	8b 52 04             	mov    0x4(%edx),%edx
  802561:	89 50 04             	mov    %edx,0x4(%eax)
  802564:	eb 0b                	jmp    802571 <alloc_block_BF+0x79>
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 40 04             	mov    0x4(%eax),%eax
  80256c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 40 04             	mov    0x4(%eax),%eax
  802577:	85 c0                	test   %eax,%eax
  802579:	74 0f                	je     80258a <alloc_block_BF+0x92>
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	8b 40 04             	mov    0x4(%eax),%eax
  802581:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802584:	8b 12                	mov    (%edx),%edx
  802586:	89 10                	mov    %edx,(%eax)
  802588:	eb 0a                	jmp    802594 <alloc_block_BF+0x9c>
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 00                	mov    (%eax),%eax
  80258f:	a3 38 51 80 00       	mov    %eax,0x805138
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8025ac:	48                   	dec    %eax
  8025ad:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	e9 4d 01 00 00       	jmp    802707 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c3:	76 24                	jbe    8025e9 <alloc_block_BF+0xf1>
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025ce:	73 19                	jae    8025e9 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025d0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 40 0c             	mov    0xc(%eax),%eax
  8025dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	8b 40 08             	mov    0x8(%eax),%eax
  8025e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025e9:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f5:	74 07                	je     8025fe <alloc_block_BF+0x106>
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	eb 05                	jmp    802603 <alloc_block_BF+0x10b>
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	a3 40 51 80 00       	mov    %eax,0x805140
  802608:	a1 40 51 80 00       	mov    0x805140,%eax
  80260d:	85 c0                	test   %eax,%eax
  80260f:	0f 85 fd fe ff ff    	jne    802512 <alloc_block_BF+0x1a>
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	0f 85 f3 fe ff ff    	jne    802512 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80261f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802623:	0f 84 d9 00 00 00    	je     802702 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802629:	a1 48 51 80 00       	mov    0x805148,%eax
  80262e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802634:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802637:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80263a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263d:	8b 55 08             	mov    0x8(%ebp),%edx
  802640:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802643:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802647:	75 17                	jne    802660 <alloc_block_BF+0x168>
  802649:	83 ec 04             	sub    $0x4,%esp
  80264c:	68 24 41 80 00       	push   $0x804124
  802651:	68 c7 00 00 00       	push   $0xc7
  802656:	68 7b 40 80 00       	push   $0x80407b
  80265b:	e8 5d dc ff ff       	call   8002bd <_panic>
  802660:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802663:	8b 00                	mov    (%eax),%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	74 10                	je     802679 <alloc_block_BF+0x181>
  802669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266c:	8b 00                	mov    (%eax),%eax
  80266e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802671:	8b 52 04             	mov    0x4(%edx),%edx
  802674:	89 50 04             	mov    %edx,0x4(%eax)
  802677:	eb 0b                	jmp    802684 <alloc_block_BF+0x18c>
  802679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267c:	8b 40 04             	mov    0x4(%eax),%eax
  80267f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802687:	8b 40 04             	mov    0x4(%eax),%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	74 0f                	je     80269d <alloc_block_BF+0x1a5>
  80268e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802691:	8b 40 04             	mov    0x4(%eax),%eax
  802694:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802697:	8b 12                	mov    (%edx),%edx
  802699:	89 10                	mov    %edx,(%eax)
  80269b:	eb 0a                	jmp    8026a7 <alloc_block_BF+0x1af>
  80269d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a0:	8b 00                	mov    (%eax),%eax
  8026a2:	a3 48 51 80 00       	mov    %eax,0x805148
  8026a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8026bf:	48                   	dec    %eax
  8026c0:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026c5:	83 ec 08             	sub    $0x8,%esp
  8026c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8026cb:	68 38 51 80 00       	push   $0x805138
  8026d0:	e8 71 f9 ff ff       	call   802046 <find_block>
  8026d5:	83 c4 10             	add    $0x10,%esp
  8026d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026de:	8b 50 08             	mov    0x8(%eax),%edx
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	01 c2                	add    %eax,%edx
  8026e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e9:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f2:	2b 45 08             	sub    0x8(%ebp),%eax
  8026f5:	89 c2                	mov    %eax,%edx
  8026f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fa:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802700:	eb 05                	jmp    802707 <alloc_block_BF+0x20f>
	}
	return NULL;
  802702:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802707:	c9                   	leave  
  802708:	c3                   	ret    

00802709 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802709:	55                   	push   %ebp
  80270a:	89 e5                	mov    %esp,%ebp
  80270c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80270f:	a1 28 50 80 00       	mov    0x805028,%eax
  802714:	85 c0                	test   %eax,%eax
  802716:	0f 85 de 01 00 00    	jne    8028fa <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80271c:	a1 38 51 80 00       	mov    0x805138,%eax
  802721:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802724:	e9 9e 01 00 00       	jmp    8028c7 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 40 0c             	mov    0xc(%eax),%eax
  80272f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802732:	0f 82 87 01 00 00    	jb     8028bf <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 40 0c             	mov    0xc(%eax),%eax
  80273e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802741:	0f 85 95 00 00 00    	jne    8027dc <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274b:	75 17                	jne    802764 <alloc_block_NF+0x5b>
  80274d:	83 ec 04             	sub    $0x4,%esp
  802750:	68 24 41 80 00       	push   $0x804124
  802755:	68 e0 00 00 00       	push   $0xe0
  80275a:	68 7b 40 80 00       	push   $0x80407b
  80275f:	e8 59 db ff ff       	call   8002bd <_panic>
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 00                	mov    (%eax),%eax
  802769:	85 c0                	test   %eax,%eax
  80276b:	74 10                	je     80277d <alloc_block_NF+0x74>
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 00                	mov    (%eax),%eax
  802772:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802775:	8b 52 04             	mov    0x4(%edx),%edx
  802778:	89 50 04             	mov    %edx,0x4(%eax)
  80277b:	eb 0b                	jmp    802788 <alloc_block_NF+0x7f>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 40 04             	mov    0x4(%eax),%eax
  802783:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 40 04             	mov    0x4(%eax),%eax
  80278e:	85 c0                	test   %eax,%eax
  802790:	74 0f                	je     8027a1 <alloc_block_NF+0x98>
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 40 04             	mov    0x4(%eax),%eax
  802798:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279b:	8b 12                	mov    (%edx),%edx
  80279d:	89 10                	mov    %edx,(%eax)
  80279f:	eb 0a                	jmp    8027ab <alloc_block_NF+0xa2>
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027be:	a1 44 51 80 00       	mov    0x805144,%eax
  8027c3:	48                   	dec    %eax
  8027c4:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 40 08             	mov    0x8(%eax),%eax
  8027cf:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	e9 f8 04 00 00       	jmp    802cd4 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e5:	0f 86 d4 00 00 00    	jbe    8028bf <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027eb:	a1 48 51 80 00       	mov    0x805148,%eax
  8027f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 50 08             	mov    0x8(%eax),%edx
  8027f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fc:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802802:	8b 55 08             	mov    0x8(%ebp),%edx
  802805:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802808:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80280c:	75 17                	jne    802825 <alloc_block_NF+0x11c>
  80280e:	83 ec 04             	sub    $0x4,%esp
  802811:	68 24 41 80 00       	push   $0x804124
  802816:	68 e9 00 00 00       	push   $0xe9
  80281b:	68 7b 40 80 00       	push   $0x80407b
  802820:	e8 98 da ff ff       	call   8002bd <_panic>
  802825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802828:	8b 00                	mov    (%eax),%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	74 10                	je     80283e <alloc_block_NF+0x135>
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802836:	8b 52 04             	mov    0x4(%edx),%edx
  802839:	89 50 04             	mov    %edx,0x4(%eax)
  80283c:	eb 0b                	jmp    802849 <alloc_block_NF+0x140>
  80283e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802841:	8b 40 04             	mov    0x4(%eax),%eax
  802844:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284c:	8b 40 04             	mov    0x4(%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 0f                	je     802862 <alloc_block_NF+0x159>
  802853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802856:	8b 40 04             	mov    0x4(%eax),%eax
  802859:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80285c:	8b 12                	mov    (%edx),%edx
  80285e:	89 10                	mov    %edx,(%eax)
  802860:	eb 0a                	jmp    80286c <alloc_block_NF+0x163>
  802862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802865:	8b 00                	mov    (%eax),%eax
  802867:	a3 48 51 80 00       	mov    %eax,0x805148
  80286c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802878:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287f:	a1 54 51 80 00       	mov    0x805154,%eax
  802884:	48                   	dec    %eax
  802885:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80288a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288d:	8b 40 08             	mov    0x8(%eax),%eax
  802890:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 50 08             	mov    0x8(%eax),%edx
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	01 c2                	add    %eax,%edx
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8028af:	89 c2                	mov    %eax,%edx
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ba:	e9 15 04 00 00       	jmp    802cd4 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028bf:	a1 40 51 80 00       	mov    0x805140,%eax
  8028c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cb:	74 07                	je     8028d4 <alloc_block_NF+0x1cb>
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 00                	mov    (%eax),%eax
  8028d2:	eb 05                	jmp    8028d9 <alloc_block_NF+0x1d0>
  8028d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d9:	a3 40 51 80 00       	mov    %eax,0x805140
  8028de:	a1 40 51 80 00       	mov    0x805140,%eax
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	0f 85 3e fe ff ff    	jne    802729 <alloc_block_NF+0x20>
  8028eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ef:	0f 85 34 fe ff ff    	jne    802729 <alloc_block_NF+0x20>
  8028f5:	e9 d5 03 00 00       	jmp    802ccf <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028fa:	a1 38 51 80 00       	mov    0x805138,%eax
  8028ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802902:	e9 b1 01 00 00       	jmp    802ab8 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	8b 50 08             	mov    0x8(%eax),%edx
  80290d:	a1 28 50 80 00       	mov    0x805028,%eax
  802912:	39 c2                	cmp    %eax,%edx
  802914:	0f 82 96 01 00 00    	jb     802ab0 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 40 0c             	mov    0xc(%eax),%eax
  802920:	3b 45 08             	cmp    0x8(%ebp),%eax
  802923:	0f 82 87 01 00 00    	jb     802ab0 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 40 0c             	mov    0xc(%eax),%eax
  80292f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802932:	0f 85 95 00 00 00    	jne    8029cd <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802938:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293c:	75 17                	jne    802955 <alloc_block_NF+0x24c>
  80293e:	83 ec 04             	sub    $0x4,%esp
  802941:	68 24 41 80 00       	push   $0x804124
  802946:	68 fc 00 00 00       	push   $0xfc
  80294b:	68 7b 40 80 00       	push   $0x80407b
  802950:	e8 68 d9 ff ff       	call   8002bd <_panic>
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	85 c0                	test   %eax,%eax
  80295c:	74 10                	je     80296e <alloc_block_NF+0x265>
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 00                	mov    (%eax),%eax
  802963:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802966:	8b 52 04             	mov    0x4(%edx),%edx
  802969:	89 50 04             	mov    %edx,0x4(%eax)
  80296c:	eb 0b                	jmp    802979 <alloc_block_NF+0x270>
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 40 04             	mov    0x4(%eax),%eax
  802974:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 40 04             	mov    0x4(%eax),%eax
  80297f:	85 c0                	test   %eax,%eax
  802981:	74 0f                	je     802992 <alloc_block_NF+0x289>
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 40 04             	mov    0x4(%eax),%eax
  802989:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298c:	8b 12                	mov    (%edx),%edx
  80298e:	89 10                	mov    %edx,(%eax)
  802990:	eb 0a                	jmp    80299c <alloc_block_NF+0x293>
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	a3 38 51 80 00       	mov    %eax,0x805138
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029af:	a1 44 51 80 00       	mov    0x805144,%eax
  8029b4:	48                   	dec    %eax
  8029b5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 40 08             	mov    0x8(%eax),%eax
  8029c0:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	e9 07 03 00 00       	jmp    802cd4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d6:	0f 86 d4 00 00 00    	jbe    802ab0 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8029e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ed:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f6:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029fd:	75 17                	jne    802a16 <alloc_block_NF+0x30d>
  8029ff:	83 ec 04             	sub    $0x4,%esp
  802a02:	68 24 41 80 00       	push   $0x804124
  802a07:	68 04 01 00 00       	push   $0x104
  802a0c:	68 7b 40 80 00       	push   $0x80407b
  802a11:	e8 a7 d8 ff ff       	call   8002bd <_panic>
  802a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	74 10                	je     802a2f <alloc_block_NF+0x326>
  802a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a27:	8b 52 04             	mov    0x4(%edx),%edx
  802a2a:	89 50 04             	mov    %edx,0x4(%eax)
  802a2d:	eb 0b                	jmp    802a3a <alloc_block_NF+0x331>
  802a2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a32:	8b 40 04             	mov    0x4(%eax),%eax
  802a35:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3d:	8b 40 04             	mov    0x4(%eax),%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	74 0f                	je     802a53 <alloc_block_NF+0x34a>
  802a44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a47:	8b 40 04             	mov    0x4(%eax),%eax
  802a4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a4d:	8b 12                	mov    (%edx),%edx
  802a4f:	89 10                	mov    %edx,(%eax)
  802a51:	eb 0a                	jmp    802a5d <alloc_block_NF+0x354>
  802a53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	a3 48 51 80 00       	mov    %eax,0x805148
  802a5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a70:	a1 54 51 80 00       	mov    0x805154,%eax
  802a75:	48                   	dec    %eax
  802a76:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7e:	8b 40 08             	mov    0x8(%eax),%eax
  802a81:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 50 08             	mov    0x8(%eax),%edx
  802a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8f:	01 c2                	add    %eax,%edx
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9d:	2b 45 08             	sub    0x8(%ebp),%eax
  802aa0:	89 c2                	mov    %eax,%edx
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802aa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aab:	e9 24 02 00 00       	jmp    802cd4 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ab0:	a1 40 51 80 00       	mov    0x805140,%eax
  802ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802abc:	74 07                	je     802ac5 <alloc_block_NF+0x3bc>
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 00                	mov    (%eax),%eax
  802ac3:	eb 05                	jmp    802aca <alloc_block_NF+0x3c1>
  802ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  802aca:	a3 40 51 80 00       	mov    %eax,0x805140
  802acf:	a1 40 51 80 00       	mov    0x805140,%eax
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	0f 85 2b fe ff ff    	jne    802907 <alloc_block_NF+0x1fe>
  802adc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae0:	0f 85 21 fe ff ff    	jne    802907 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ae6:	a1 38 51 80 00       	mov    0x805138,%eax
  802aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aee:	e9 ae 01 00 00       	jmp    802ca1 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	8b 50 08             	mov    0x8(%eax),%edx
  802af9:	a1 28 50 80 00       	mov    0x805028,%eax
  802afe:	39 c2                	cmp    %eax,%edx
  802b00:	0f 83 93 01 00 00    	jae    802c99 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b09:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b0f:	0f 82 84 01 00 00    	jb     802c99 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b1e:	0f 85 95 00 00 00    	jne    802bb9 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b28:	75 17                	jne    802b41 <alloc_block_NF+0x438>
  802b2a:	83 ec 04             	sub    $0x4,%esp
  802b2d:	68 24 41 80 00       	push   $0x804124
  802b32:	68 14 01 00 00       	push   $0x114
  802b37:	68 7b 40 80 00       	push   $0x80407b
  802b3c:	e8 7c d7 ff ff       	call   8002bd <_panic>
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 00                	mov    (%eax),%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	74 10                	je     802b5a <alloc_block_NF+0x451>
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b52:	8b 52 04             	mov    0x4(%edx),%edx
  802b55:	89 50 04             	mov    %edx,0x4(%eax)
  802b58:	eb 0b                	jmp    802b65 <alloc_block_NF+0x45c>
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 40 04             	mov    0x4(%eax),%eax
  802b60:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	8b 40 04             	mov    0x4(%eax),%eax
  802b6b:	85 c0                	test   %eax,%eax
  802b6d:	74 0f                	je     802b7e <alloc_block_NF+0x475>
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 40 04             	mov    0x4(%eax),%eax
  802b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b78:	8b 12                	mov    (%edx),%edx
  802b7a:	89 10                	mov    %edx,(%eax)
  802b7c:	eb 0a                	jmp    802b88 <alloc_block_NF+0x47f>
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	a3 38 51 80 00       	mov    %eax,0x805138
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9b:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba0:	48                   	dec    %eax
  802ba1:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 40 08             	mov    0x8(%eax),%eax
  802bac:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	e9 1b 01 00 00       	jmp    802cd4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc2:	0f 86 d1 00 00 00    	jbe    802c99 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bc8:	a1 48 51 80 00       	mov    0x805148,%eax
  802bcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 50 08             	mov    0x8(%eax),%edx
  802bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  802be2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802be5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802be9:	75 17                	jne    802c02 <alloc_block_NF+0x4f9>
  802beb:	83 ec 04             	sub    $0x4,%esp
  802bee:	68 24 41 80 00       	push   $0x804124
  802bf3:	68 1c 01 00 00       	push   $0x11c
  802bf8:	68 7b 40 80 00       	push   $0x80407b
  802bfd:	e8 bb d6 ff ff       	call   8002bd <_panic>
  802c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c05:	8b 00                	mov    (%eax),%eax
  802c07:	85 c0                	test   %eax,%eax
  802c09:	74 10                	je     802c1b <alloc_block_NF+0x512>
  802c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c13:	8b 52 04             	mov    0x4(%edx),%edx
  802c16:	89 50 04             	mov    %edx,0x4(%eax)
  802c19:	eb 0b                	jmp    802c26 <alloc_block_NF+0x51d>
  802c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1e:	8b 40 04             	mov    0x4(%eax),%eax
  802c21:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c29:	8b 40 04             	mov    0x4(%eax),%eax
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	74 0f                	je     802c3f <alloc_block_NF+0x536>
  802c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c33:	8b 40 04             	mov    0x4(%eax),%eax
  802c36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c39:	8b 12                	mov    (%edx),%edx
  802c3b:	89 10                	mov    %edx,(%eax)
  802c3d:	eb 0a                	jmp    802c49 <alloc_block_NF+0x540>
  802c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c42:	8b 00                	mov    (%eax),%eax
  802c44:	a3 48 51 80 00       	mov    %eax,0x805148
  802c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5c:	a1 54 51 80 00       	mov    0x805154,%eax
  802c61:	48                   	dec    %eax
  802c62:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6a:	8b 40 08             	mov    0x8(%eax),%eax
  802c6d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	8b 50 08             	mov    0x8(%eax),%edx
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	01 c2                	add    %eax,%edx
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 40 0c             	mov    0xc(%eax),%eax
  802c89:	2b 45 08             	sub    0x8(%ebp),%eax
  802c8c:	89 c2                	mov    %eax,%edx
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c97:	eb 3b                	jmp    802cd4 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c99:	a1 40 51 80 00       	mov    0x805140,%eax
  802c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca5:	74 07                	je     802cae <alloc_block_NF+0x5a5>
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 00                	mov    (%eax),%eax
  802cac:	eb 05                	jmp    802cb3 <alloc_block_NF+0x5aa>
  802cae:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb3:	a3 40 51 80 00       	mov    %eax,0x805140
  802cb8:	a1 40 51 80 00       	mov    0x805140,%eax
  802cbd:	85 c0                	test   %eax,%eax
  802cbf:	0f 85 2e fe ff ff    	jne    802af3 <alloc_block_NF+0x3ea>
  802cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc9:	0f 85 24 fe ff ff    	jne    802af3 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ccf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cd4:	c9                   	leave  
  802cd5:	c3                   	ret    

00802cd6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cd6:	55                   	push   %ebp
  802cd7:	89 e5                	mov    %esp,%ebp
  802cd9:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cdc:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ce4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ce9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cec:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf1:	85 c0                	test   %eax,%eax
  802cf3:	74 14                	je     802d09 <insert_sorted_with_merge_freeList+0x33>
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	8b 50 08             	mov    0x8(%eax),%edx
  802cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfe:	8b 40 08             	mov    0x8(%eax),%eax
  802d01:	39 c2                	cmp    %eax,%edx
  802d03:	0f 87 9b 01 00 00    	ja     802ea4 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0d:	75 17                	jne    802d26 <insert_sorted_with_merge_freeList+0x50>
  802d0f:	83 ec 04             	sub    $0x4,%esp
  802d12:	68 58 40 80 00       	push   $0x804058
  802d17:	68 38 01 00 00       	push   $0x138
  802d1c:	68 7b 40 80 00       	push   $0x80407b
  802d21:	e8 97 d5 ff ff       	call   8002bd <_panic>
  802d26:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	89 10                	mov    %edx,(%eax)
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	85 c0                	test   %eax,%eax
  802d38:	74 0d                	je     802d47 <insert_sorted_with_merge_freeList+0x71>
  802d3a:	a1 38 51 80 00       	mov    0x805138,%eax
  802d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d42:	89 50 04             	mov    %edx,0x4(%eax)
  802d45:	eb 08                	jmp    802d4f <insert_sorted_with_merge_freeList+0x79>
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	a3 38 51 80 00       	mov    %eax,0x805138
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d61:	a1 44 51 80 00       	mov    0x805144,%eax
  802d66:	40                   	inc    %eax
  802d67:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d70:	0f 84 a8 06 00 00    	je     80341e <insert_sorted_with_merge_freeList+0x748>
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	8b 50 08             	mov    0x8(%eax),%edx
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d82:	01 c2                	add    %eax,%edx
  802d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d87:	8b 40 08             	mov    0x8(%eax),%eax
  802d8a:	39 c2                	cmp    %eax,%edx
  802d8c:	0f 85 8c 06 00 00    	jne    80341e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	8b 50 0c             	mov    0xc(%eax),%edx
  802d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9e:	01 c2                	add    %eax,%edx
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802da6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802daa:	75 17                	jne    802dc3 <insert_sorted_with_merge_freeList+0xed>
  802dac:	83 ec 04             	sub    $0x4,%esp
  802daf:	68 24 41 80 00       	push   $0x804124
  802db4:	68 3c 01 00 00       	push   $0x13c
  802db9:	68 7b 40 80 00       	push   $0x80407b
  802dbe:	e8 fa d4 ff ff       	call   8002bd <_panic>
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	8b 00                	mov    (%eax),%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	74 10                	je     802ddc <insert_sorted_with_merge_freeList+0x106>
  802dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dd4:	8b 52 04             	mov    0x4(%edx),%edx
  802dd7:	89 50 04             	mov    %edx,0x4(%eax)
  802dda:	eb 0b                	jmp    802de7 <insert_sorted_with_merge_freeList+0x111>
  802ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddf:	8b 40 04             	mov    0x4(%eax),%eax
  802de2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dea:	8b 40 04             	mov    0x4(%eax),%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	74 0f                	je     802e00 <insert_sorted_with_merge_freeList+0x12a>
  802df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df4:	8b 40 04             	mov    0x4(%eax),%eax
  802df7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dfa:	8b 12                	mov    (%edx),%edx
  802dfc:	89 10                	mov    %edx,(%eax)
  802dfe:	eb 0a                	jmp    802e0a <insert_sorted_with_merge_freeList+0x134>
  802e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	a3 38 51 80 00       	mov    %eax,0x805138
  802e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e22:	48                   	dec    %eax
  802e23:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e40:	75 17                	jne    802e59 <insert_sorted_with_merge_freeList+0x183>
  802e42:	83 ec 04             	sub    $0x4,%esp
  802e45:	68 58 40 80 00       	push   $0x804058
  802e4a:	68 3f 01 00 00       	push   $0x13f
  802e4f:	68 7b 40 80 00       	push   $0x80407b
  802e54:	e8 64 d4 ff ff       	call   8002bd <_panic>
  802e59:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e62:	89 10                	mov    %edx,(%eax)
  802e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e67:	8b 00                	mov    (%eax),%eax
  802e69:	85 c0                	test   %eax,%eax
  802e6b:	74 0d                	je     802e7a <insert_sorted_with_merge_freeList+0x1a4>
  802e6d:	a1 48 51 80 00       	mov    0x805148,%eax
  802e72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e75:	89 50 04             	mov    %edx,0x4(%eax)
  802e78:	eb 08                	jmp    802e82 <insert_sorted_with_merge_freeList+0x1ac>
  802e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e85:	a3 48 51 80 00       	mov    %eax,0x805148
  802e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e94:	a1 54 51 80 00       	mov    0x805154,%eax
  802e99:	40                   	inc    %eax
  802e9a:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e9f:	e9 7a 05 00 00       	jmp    80341e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	8b 50 08             	mov    0x8(%eax),%edx
  802eaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ead:	8b 40 08             	mov    0x8(%eax),%eax
  802eb0:	39 c2                	cmp    %eax,%edx
  802eb2:	0f 82 14 01 00 00    	jb     802fcc <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802eb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebb:	8b 50 08             	mov    0x8(%eax),%edx
  802ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec4:	01 c2                	add    %eax,%edx
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	8b 40 08             	mov    0x8(%eax),%eax
  802ecc:	39 c2                	cmp    %eax,%edx
  802ece:	0f 85 90 00 00 00    	jne    802f64 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ed4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed7:	8b 50 0c             	mov    0xc(%eax),%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee0:	01 c2                	add    %eax,%edx
  802ee2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee5:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802efc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f00:	75 17                	jne    802f19 <insert_sorted_with_merge_freeList+0x243>
  802f02:	83 ec 04             	sub    $0x4,%esp
  802f05:	68 58 40 80 00       	push   $0x804058
  802f0a:	68 49 01 00 00       	push   $0x149
  802f0f:	68 7b 40 80 00       	push   $0x80407b
  802f14:	e8 a4 d3 ff ff       	call   8002bd <_panic>
  802f19:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	89 10                	mov    %edx,(%eax)
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 0d                	je     802f3a <insert_sorted_with_merge_freeList+0x264>
  802f2d:	a1 48 51 80 00       	mov    0x805148,%eax
  802f32:	8b 55 08             	mov    0x8(%ebp),%edx
  802f35:	89 50 04             	mov    %edx,0x4(%eax)
  802f38:	eb 08                	jmp    802f42 <insert_sorted_with_merge_freeList+0x26c>
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	a3 48 51 80 00       	mov    %eax,0x805148
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f54:	a1 54 51 80 00       	mov    0x805154,%eax
  802f59:	40                   	inc    %eax
  802f5a:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f5f:	e9 bb 04 00 00       	jmp    80341f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f68:	75 17                	jne    802f81 <insert_sorted_with_merge_freeList+0x2ab>
  802f6a:	83 ec 04             	sub    $0x4,%esp
  802f6d:	68 cc 40 80 00       	push   $0x8040cc
  802f72:	68 4c 01 00 00       	push   $0x14c
  802f77:	68 7b 40 80 00       	push   $0x80407b
  802f7c:	e8 3c d3 ff ff       	call   8002bd <_panic>
  802f81:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	89 50 04             	mov    %edx,0x4(%eax)
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 40 04             	mov    0x4(%eax),%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	74 0c                	je     802fa3 <insert_sorted_with_merge_freeList+0x2cd>
  802f97:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9f:	89 10                	mov    %edx,(%eax)
  802fa1:	eb 08                	jmp    802fab <insert_sorted_with_merge_freeList+0x2d5>
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	a3 38 51 80 00       	mov    %eax,0x805138
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbc:	a1 44 51 80 00       	mov    0x805144,%eax
  802fc1:	40                   	inc    %eax
  802fc2:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fc7:	e9 53 04 00 00       	jmp    80341f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fcc:	a1 38 51 80 00       	mov    0x805138,%eax
  802fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fd4:	e9 15 04 00 00       	jmp    8033ee <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	8b 50 08             	mov    0x8(%eax),%edx
  802fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fea:	8b 40 08             	mov    0x8(%eax),%eax
  802fed:	39 c2                	cmp    %eax,%edx
  802fef:	0f 86 f1 03 00 00    	jbe    8033e6 <insert_sorted_with_merge_freeList+0x710>
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	8b 50 08             	mov    0x8(%eax),%edx
  802ffb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffe:	8b 40 08             	mov    0x8(%eax),%eax
  803001:	39 c2                	cmp    %eax,%edx
  803003:	0f 83 dd 03 00 00    	jae    8033e6 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 50 08             	mov    0x8(%eax),%edx
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	8b 40 0c             	mov    0xc(%eax),%eax
  803015:	01 c2                	add    %eax,%edx
  803017:	8b 45 08             	mov    0x8(%ebp),%eax
  80301a:	8b 40 08             	mov    0x8(%eax),%eax
  80301d:	39 c2                	cmp    %eax,%edx
  80301f:	0f 85 b9 01 00 00    	jne    8031de <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	8b 50 08             	mov    0x8(%eax),%edx
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	8b 40 0c             	mov    0xc(%eax),%eax
  803031:	01 c2                	add    %eax,%edx
  803033:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803036:	8b 40 08             	mov    0x8(%eax),%eax
  803039:	39 c2                	cmp    %eax,%edx
  80303b:	0f 85 0d 01 00 00    	jne    80314e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803044:	8b 50 0c             	mov    0xc(%eax),%edx
  803047:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304a:	8b 40 0c             	mov    0xc(%eax),%eax
  80304d:	01 c2                	add    %eax,%edx
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803055:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803059:	75 17                	jne    803072 <insert_sorted_with_merge_freeList+0x39c>
  80305b:	83 ec 04             	sub    $0x4,%esp
  80305e:	68 24 41 80 00       	push   $0x804124
  803063:	68 5c 01 00 00       	push   $0x15c
  803068:	68 7b 40 80 00       	push   $0x80407b
  80306d:	e8 4b d2 ff ff       	call   8002bd <_panic>
  803072:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803075:	8b 00                	mov    (%eax),%eax
  803077:	85 c0                	test   %eax,%eax
  803079:	74 10                	je     80308b <insert_sorted_with_merge_freeList+0x3b5>
  80307b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307e:	8b 00                	mov    (%eax),%eax
  803080:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803083:	8b 52 04             	mov    0x4(%edx),%edx
  803086:	89 50 04             	mov    %edx,0x4(%eax)
  803089:	eb 0b                	jmp    803096 <insert_sorted_with_merge_freeList+0x3c0>
  80308b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308e:	8b 40 04             	mov    0x4(%eax),%eax
  803091:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803096:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803099:	8b 40 04             	mov    0x4(%eax),%eax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	74 0f                	je     8030af <insert_sorted_with_merge_freeList+0x3d9>
  8030a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a3:	8b 40 04             	mov    0x4(%eax),%eax
  8030a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a9:	8b 12                	mov    (%edx),%edx
  8030ab:	89 10                	mov    %edx,(%eax)
  8030ad:	eb 0a                	jmp    8030b9 <insert_sorted_with_merge_freeList+0x3e3>
  8030af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b2:	8b 00                	mov    (%eax),%eax
  8030b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d1:	48                   	dec    %eax
  8030d2:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030ef:	75 17                	jne    803108 <insert_sorted_with_merge_freeList+0x432>
  8030f1:	83 ec 04             	sub    $0x4,%esp
  8030f4:	68 58 40 80 00       	push   $0x804058
  8030f9:	68 5f 01 00 00       	push   $0x15f
  8030fe:	68 7b 40 80 00       	push   $0x80407b
  803103:	e8 b5 d1 ff ff       	call   8002bd <_panic>
  803108:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80310e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803111:	89 10                	mov    %edx,(%eax)
  803113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803116:	8b 00                	mov    (%eax),%eax
  803118:	85 c0                	test   %eax,%eax
  80311a:	74 0d                	je     803129 <insert_sorted_with_merge_freeList+0x453>
  80311c:	a1 48 51 80 00       	mov    0x805148,%eax
  803121:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803124:	89 50 04             	mov    %edx,0x4(%eax)
  803127:	eb 08                	jmp    803131 <insert_sorted_with_merge_freeList+0x45b>
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803131:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803134:	a3 48 51 80 00       	mov    %eax,0x805148
  803139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803143:	a1 54 51 80 00       	mov    0x805154,%eax
  803148:	40                   	inc    %eax
  803149:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	8b 50 0c             	mov    0xc(%eax),%edx
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	8b 40 0c             	mov    0xc(%eax),%eax
  80315a:	01 c2                	add    %eax,%edx
  80315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803176:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317a:	75 17                	jne    803193 <insert_sorted_with_merge_freeList+0x4bd>
  80317c:	83 ec 04             	sub    $0x4,%esp
  80317f:	68 58 40 80 00       	push   $0x804058
  803184:	68 64 01 00 00       	push   $0x164
  803189:	68 7b 40 80 00       	push   $0x80407b
  80318e:	e8 2a d1 ff ff       	call   8002bd <_panic>
  803193:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	89 10                	mov    %edx,(%eax)
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	74 0d                	je     8031b4 <insert_sorted_with_merge_freeList+0x4de>
  8031a7:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8031af:	89 50 04             	mov    %edx,0x4(%eax)
  8031b2:	eb 08                	jmp    8031bc <insert_sorted_with_merge_freeList+0x4e6>
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8031d3:	40                   	inc    %eax
  8031d4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031d9:	e9 41 02 00 00       	jmp    80341f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	8b 50 08             	mov    0x8(%eax),%edx
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ea:	01 c2                	add    %eax,%edx
  8031ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ef:	8b 40 08             	mov    0x8(%eax),%eax
  8031f2:	39 c2                	cmp    %eax,%edx
  8031f4:	0f 85 7c 01 00 00    	jne    803376 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031fe:	74 06                	je     803206 <insert_sorted_with_merge_freeList+0x530>
  803200:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803204:	75 17                	jne    80321d <insert_sorted_with_merge_freeList+0x547>
  803206:	83 ec 04             	sub    $0x4,%esp
  803209:	68 94 40 80 00       	push   $0x804094
  80320e:	68 69 01 00 00       	push   $0x169
  803213:	68 7b 40 80 00       	push   $0x80407b
  803218:	e8 a0 d0 ff ff       	call   8002bd <_panic>
  80321d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803220:	8b 50 04             	mov    0x4(%eax),%edx
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	89 50 04             	mov    %edx,0x4(%eax)
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322f:	89 10                	mov    %edx,(%eax)
  803231:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803234:	8b 40 04             	mov    0x4(%eax),%eax
  803237:	85 c0                	test   %eax,%eax
  803239:	74 0d                	je     803248 <insert_sorted_with_merge_freeList+0x572>
  80323b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323e:	8b 40 04             	mov    0x4(%eax),%eax
  803241:	8b 55 08             	mov    0x8(%ebp),%edx
  803244:	89 10                	mov    %edx,(%eax)
  803246:	eb 08                	jmp    803250 <insert_sorted_with_merge_freeList+0x57a>
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	a3 38 51 80 00       	mov    %eax,0x805138
  803250:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803253:	8b 55 08             	mov    0x8(%ebp),%edx
  803256:	89 50 04             	mov    %edx,0x4(%eax)
  803259:	a1 44 51 80 00       	mov    0x805144,%eax
  80325e:	40                   	inc    %eax
  80325f:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	8b 50 0c             	mov    0xc(%eax),%edx
  80326a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326d:	8b 40 0c             	mov    0xc(%eax),%eax
  803270:	01 c2                	add    %eax,%edx
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803278:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80327c:	75 17                	jne    803295 <insert_sorted_with_merge_freeList+0x5bf>
  80327e:	83 ec 04             	sub    $0x4,%esp
  803281:	68 24 41 80 00       	push   $0x804124
  803286:	68 6b 01 00 00       	push   $0x16b
  80328b:	68 7b 40 80 00       	push   $0x80407b
  803290:	e8 28 d0 ff ff       	call   8002bd <_panic>
  803295:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803298:	8b 00                	mov    (%eax),%eax
  80329a:	85 c0                	test   %eax,%eax
  80329c:	74 10                	je     8032ae <insert_sorted_with_merge_freeList+0x5d8>
  80329e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a1:	8b 00                	mov    (%eax),%eax
  8032a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a6:	8b 52 04             	mov    0x4(%edx),%edx
  8032a9:	89 50 04             	mov    %edx,0x4(%eax)
  8032ac:	eb 0b                	jmp    8032b9 <insert_sorted_with_merge_freeList+0x5e3>
  8032ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b1:	8b 40 04             	mov    0x4(%eax),%eax
  8032b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bc:	8b 40 04             	mov    0x4(%eax),%eax
  8032bf:	85 c0                	test   %eax,%eax
  8032c1:	74 0f                	je     8032d2 <insert_sorted_with_merge_freeList+0x5fc>
  8032c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c6:	8b 40 04             	mov    0x4(%eax),%eax
  8032c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032cc:	8b 12                	mov    (%edx),%edx
  8032ce:	89 10                	mov    %edx,(%eax)
  8032d0:	eb 0a                	jmp    8032dc <insert_sorted_with_merge_freeList+0x606>
  8032d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d5:	8b 00                	mov    (%eax),%eax
  8032d7:	a3 38 51 80 00       	mov    %eax,0x805138
  8032dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f4:	48                   	dec    %eax
  8032f5:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803304:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803307:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80330e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803312:	75 17                	jne    80332b <insert_sorted_with_merge_freeList+0x655>
  803314:	83 ec 04             	sub    $0x4,%esp
  803317:	68 58 40 80 00       	push   $0x804058
  80331c:	68 6e 01 00 00       	push   $0x16e
  803321:	68 7b 40 80 00       	push   $0x80407b
  803326:	e8 92 cf ff ff       	call   8002bd <_panic>
  80332b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803334:	89 10                	mov    %edx,(%eax)
  803336:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	85 c0                	test   %eax,%eax
  80333d:	74 0d                	je     80334c <insert_sorted_with_merge_freeList+0x676>
  80333f:	a1 48 51 80 00       	mov    0x805148,%eax
  803344:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803347:	89 50 04             	mov    %edx,0x4(%eax)
  80334a:	eb 08                	jmp    803354 <insert_sorted_with_merge_freeList+0x67e>
  80334c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803357:	a3 48 51 80 00       	mov    %eax,0x805148
  80335c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803366:	a1 54 51 80 00       	mov    0x805154,%eax
  80336b:	40                   	inc    %eax
  80336c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803371:	e9 a9 00 00 00       	jmp    80341f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337a:	74 06                	je     803382 <insert_sorted_with_merge_freeList+0x6ac>
  80337c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803380:	75 17                	jne    803399 <insert_sorted_with_merge_freeList+0x6c3>
  803382:	83 ec 04             	sub    $0x4,%esp
  803385:	68 f0 40 80 00       	push   $0x8040f0
  80338a:	68 73 01 00 00       	push   $0x173
  80338f:	68 7b 40 80 00       	push   $0x80407b
  803394:	e8 24 cf ff ff       	call   8002bd <_panic>
  803399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339c:	8b 10                	mov    (%eax),%edx
  80339e:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a1:	89 10                	mov    %edx,(%eax)
  8033a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a6:	8b 00                	mov    (%eax),%eax
  8033a8:	85 c0                	test   %eax,%eax
  8033aa:	74 0b                	je     8033b7 <insert_sorted_with_merge_freeList+0x6e1>
  8033ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b4:	89 50 04             	mov    %edx,0x4(%eax)
  8033b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8033bd:	89 10                	mov    %edx,(%eax)
  8033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033c5:	89 50 04             	mov    %edx,0x4(%eax)
  8033c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cb:	8b 00                	mov    (%eax),%eax
  8033cd:	85 c0                	test   %eax,%eax
  8033cf:	75 08                	jne    8033d9 <insert_sorted_with_merge_freeList+0x703>
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d9:	a1 44 51 80 00       	mov    0x805144,%eax
  8033de:	40                   	inc    %eax
  8033df:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033e4:	eb 39                	jmp    80341f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8033eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f2:	74 07                	je     8033fb <insert_sorted_with_merge_freeList+0x725>
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	8b 00                	mov    (%eax),%eax
  8033f9:	eb 05                	jmp    803400 <insert_sorted_with_merge_freeList+0x72a>
  8033fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803400:	a3 40 51 80 00       	mov    %eax,0x805140
  803405:	a1 40 51 80 00       	mov    0x805140,%eax
  80340a:	85 c0                	test   %eax,%eax
  80340c:	0f 85 c7 fb ff ff    	jne    802fd9 <insert_sorted_with_merge_freeList+0x303>
  803412:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803416:	0f 85 bd fb ff ff    	jne    802fd9 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80341c:	eb 01                	jmp    80341f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80341e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80341f:	90                   	nop
  803420:	c9                   	leave  
  803421:	c3                   	ret    

00803422 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803422:	55                   	push   %ebp
  803423:	89 e5                	mov    %esp,%ebp
  803425:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803428:	8b 55 08             	mov    0x8(%ebp),%edx
  80342b:	89 d0                	mov    %edx,%eax
  80342d:	c1 e0 02             	shl    $0x2,%eax
  803430:	01 d0                	add    %edx,%eax
  803432:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803439:	01 d0                	add    %edx,%eax
  80343b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803442:	01 d0                	add    %edx,%eax
  803444:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80344b:	01 d0                	add    %edx,%eax
  80344d:	c1 e0 04             	shl    $0x4,%eax
  803450:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803453:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80345a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80345d:	83 ec 0c             	sub    $0xc,%esp
  803460:	50                   	push   %eax
  803461:	e8 26 e7 ff ff       	call   801b8c <sys_get_virtual_time>
  803466:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803469:	eb 41                	jmp    8034ac <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80346b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80346e:	83 ec 0c             	sub    $0xc,%esp
  803471:	50                   	push   %eax
  803472:	e8 15 e7 ff ff       	call   801b8c <sys_get_virtual_time>
  803477:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80347a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80347d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803480:	29 c2                	sub    %eax,%edx
  803482:	89 d0                	mov    %edx,%eax
  803484:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803487:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80348a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80348d:	89 d1                	mov    %edx,%ecx
  80348f:	29 c1                	sub    %eax,%ecx
  803491:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803494:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803497:	39 c2                	cmp    %eax,%edx
  803499:	0f 97 c0             	seta   %al
  80349c:	0f b6 c0             	movzbl %al,%eax
  80349f:	29 c1                	sub    %eax,%ecx
  8034a1:	89 c8                	mov    %ecx,%eax
  8034a3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8034a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8034ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034b2:	72 b7                	jb     80346b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8034b4:	90                   	nop
  8034b5:	c9                   	leave  
  8034b6:	c3                   	ret    

008034b7 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8034b7:	55                   	push   %ebp
  8034b8:	89 e5                	mov    %esp,%ebp
  8034ba:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8034bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8034c4:	eb 03                	jmp    8034c9 <busy_wait+0x12>
  8034c6:	ff 45 fc             	incl   -0x4(%ebp)
  8034c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034cf:	72 f5                	jb     8034c6 <busy_wait+0xf>
	return i;
  8034d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8034d4:	c9                   	leave  
  8034d5:	c3                   	ret    
  8034d6:	66 90                	xchg   %ax,%ax

008034d8 <__udivdi3>:
  8034d8:	55                   	push   %ebp
  8034d9:	57                   	push   %edi
  8034da:	56                   	push   %esi
  8034db:	53                   	push   %ebx
  8034dc:	83 ec 1c             	sub    $0x1c,%esp
  8034df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034ef:	89 ca                	mov    %ecx,%edx
  8034f1:	89 f8                	mov    %edi,%eax
  8034f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034f7:	85 f6                	test   %esi,%esi
  8034f9:	75 2d                	jne    803528 <__udivdi3+0x50>
  8034fb:	39 cf                	cmp    %ecx,%edi
  8034fd:	77 65                	ja     803564 <__udivdi3+0x8c>
  8034ff:	89 fd                	mov    %edi,%ebp
  803501:	85 ff                	test   %edi,%edi
  803503:	75 0b                	jne    803510 <__udivdi3+0x38>
  803505:	b8 01 00 00 00       	mov    $0x1,%eax
  80350a:	31 d2                	xor    %edx,%edx
  80350c:	f7 f7                	div    %edi
  80350e:	89 c5                	mov    %eax,%ebp
  803510:	31 d2                	xor    %edx,%edx
  803512:	89 c8                	mov    %ecx,%eax
  803514:	f7 f5                	div    %ebp
  803516:	89 c1                	mov    %eax,%ecx
  803518:	89 d8                	mov    %ebx,%eax
  80351a:	f7 f5                	div    %ebp
  80351c:	89 cf                	mov    %ecx,%edi
  80351e:	89 fa                	mov    %edi,%edx
  803520:	83 c4 1c             	add    $0x1c,%esp
  803523:	5b                   	pop    %ebx
  803524:	5e                   	pop    %esi
  803525:	5f                   	pop    %edi
  803526:	5d                   	pop    %ebp
  803527:	c3                   	ret    
  803528:	39 ce                	cmp    %ecx,%esi
  80352a:	77 28                	ja     803554 <__udivdi3+0x7c>
  80352c:	0f bd fe             	bsr    %esi,%edi
  80352f:	83 f7 1f             	xor    $0x1f,%edi
  803532:	75 40                	jne    803574 <__udivdi3+0x9c>
  803534:	39 ce                	cmp    %ecx,%esi
  803536:	72 0a                	jb     803542 <__udivdi3+0x6a>
  803538:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80353c:	0f 87 9e 00 00 00    	ja     8035e0 <__udivdi3+0x108>
  803542:	b8 01 00 00 00       	mov    $0x1,%eax
  803547:	89 fa                	mov    %edi,%edx
  803549:	83 c4 1c             	add    $0x1c,%esp
  80354c:	5b                   	pop    %ebx
  80354d:	5e                   	pop    %esi
  80354e:	5f                   	pop    %edi
  80354f:	5d                   	pop    %ebp
  803550:	c3                   	ret    
  803551:	8d 76 00             	lea    0x0(%esi),%esi
  803554:	31 ff                	xor    %edi,%edi
  803556:	31 c0                	xor    %eax,%eax
  803558:	89 fa                	mov    %edi,%edx
  80355a:	83 c4 1c             	add    $0x1c,%esp
  80355d:	5b                   	pop    %ebx
  80355e:	5e                   	pop    %esi
  80355f:	5f                   	pop    %edi
  803560:	5d                   	pop    %ebp
  803561:	c3                   	ret    
  803562:	66 90                	xchg   %ax,%ax
  803564:	89 d8                	mov    %ebx,%eax
  803566:	f7 f7                	div    %edi
  803568:	31 ff                	xor    %edi,%edi
  80356a:	89 fa                	mov    %edi,%edx
  80356c:	83 c4 1c             	add    $0x1c,%esp
  80356f:	5b                   	pop    %ebx
  803570:	5e                   	pop    %esi
  803571:	5f                   	pop    %edi
  803572:	5d                   	pop    %ebp
  803573:	c3                   	ret    
  803574:	bd 20 00 00 00       	mov    $0x20,%ebp
  803579:	89 eb                	mov    %ebp,%ebx
  80357b:	29 fb                	sub    %edi,%ebx
  80357d:	89 f9                	mov    %edi,%ecx
  80357f:	d3 e6                	shl    %cl,%esi
  803581:	89 c5                	mov    %eax,%ebp
  803583:	88 d9                	mov    %bl,%cl
  803585:	d3 ed                	shr    %cl,%ebp
  803587:	89 e9                	mov    %ebp,%ecx
  803589:	09 f1                	or     %esi,%ecx
  80358b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80358f:	89 f9                	mov    %edi,%ecx
  803591:	d3 e0                	shl    %cl,%eax
  803593:	89 c5                	mov    %eax,%ebp
  803595:	89 d6                	mov    %edx,%esi
  803597:	88 d9                	mov    %bl,%cl
  803599:	d3 ee                	shr    %cl,%esi
  80359b:	89 f9                	mov    %edi,%ecx
  80359d:	d3 e2                	shl    %cl,%edx
  80359f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a3:	88 d9                	mov    %bl,%cl
  8035a5:	d3 e8                	shr    %cl,%eax
  8035a7:	09 c2                	or     %eax,%edx
  8035a9:	89 d0                	mov    %edx,%eax
  8035ab:	89 f2                	mov    %esi,%edx
  8035ad:	f7 74 24 0c          	divl   0xc(%esp)
  8035b1:	89 d6                	mov    %edx,%esi
  8035b3:	89 c3                	mov    %eax,%ebx
  8035b5:	f7 e5                	mul    %ebp
  8035b7:	39 d6                	cmp    %edx,%esi
  8035b9:	72 19                	jb     8035d4 <__udivdi3+0xfc>
  8035bb:	74 0b                	je     8035c8 <__udivdi3+0xf0>
  8035bd:	89 d8                	mov    %ebx,%eax
  8035bf:	31 ff                	xor    %edi,%edi
  8035c1:	e9 58 ff ff ff       	jmp    80351e <__udivdi3+0x46>
  8035c6:	66 90                	xchg   %ax,%ax
  8035c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035cc:	89 f9                	mov    %edi,%ecx
  8035ce:	d3 e2                	shl    %cl,%edx
  8035d0:	39 c2                	cmp    %eax,%edx
  8035d2:	73 e9                	jae    8035bd <__udivdi3+0xe5>
  8035d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035d7:	31 ff                	xor    %edi,%edi
  8035d9:	e9 40 ff ff ff       	jmp    80351e <__udivdi3+0x46>
  8035de:	66 90                	xchg   %ax,%ax
  8035e0:	31 c0                	xor    %eax,%eax
  8035e2:	e9 37 ff ff ff       	jmp    80351e <__udivdi3+0x46>
  8035e7:	90                   	nop

008035e8 <__umoddi3>:
  8035e8:	55                   	push   %ebp
  8035e9:	57                   	push   %edi
  8035ea:	56                   	push   %esi
  8035eb:	53                   	push   %ebx
  8035ec:	83 ec 1c             	sub    $0x1c,%esp
  8035ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803603:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803607:	89 f3                	mov    %esi,%ebx
  803609:	89 fa                	mov    %edi,%edx
  80360b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80360f:	89 34 24             	mov    %esi,(%esp)
  803612:	85 c0                	test   %eax,%eax
  803614:	75 1a                	jne    803630 <__umoddi3+0x48>
  803616:	39 f7                	cmp    %esi,%edi
  803618:	0f 86 a2 00 00 00    	jbe    8036c0 <__umoddi3+0xd8>
  80361e:	89 c8                	mov    %ecx,%eax
  803620:	89 f2                	mov    %esi,%edx
  803622:	f7 f7                	div    %edi
  803624:	89 d0                	mov    %edx,%eax
  803626:	31 d2                	xor    %edx,%edx
  803628:	83 c4 1c             	add    $0x1c,%esp
  80362b:	5b                   	pop    %ebx
  80362c:	5e                   	pop    %esi
  80362d:	5f                   	pop    %edi
  80362e:	5d                   	pop    %ebp
  80362f:	c3                   	ret    
  803630:	39 f0                	cmp    %esi,%eax
  803632:	0f 87 ac 00 00 00    	ja     8036e4 <__umoddi3+0xfc>
  803638:	0f bd e8             	bsr    %eax,%ebp
  80363b:	83 f5 1f             	xor    $0x1f,%ebp
  80363e:	0f 84 ac 00 00 00    	je     8036f0 <__umoddi3+0x108>
  803644:	bf 20 00 00 00       	mov    $0x20,%edi
  803649:	29 ef                	sub    %ebp,%edi
  80364b:	89 fe                	mov    %edi,%esi
  80364d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803651:	89 e9                	mov    %ebp,%ecx
  803653:	d3 e0                	shl    %cl,%eax
  803655:	89 d7                	mov    %edx,%edi
  803657:	89 f1                	mov    %esi,%ecx
  803659:	d3 ef                	shr    %cl,%edi
  80365b:	09 c7                	or     %eax,%edi
  80365d:	89 e9                	mov    %ebp,%ecx
  80365f:	d3 e2                	shl    %cl,%edx
  803661:	89 14 24             	mov    %edx,(%esp)
  803664:	89 d8                	mov    %ebx,%eax
  803666:	d3 e0                	shl    %cl,%eax
  803668:	89 c2                	mov    %eax,%edx
  80366a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80366e:	d3 e0                	shl    %cl,%eax
  803670:	89 44 24 04          	mov    %eax,0x4(%esp)
  803674:	8b 44 24 08          	mov    0x8(%esp),%eax
  803678:	89 f1                	mov    %esi,%ecx
  80367a:	d3 e8                	shr    %cl,%eax
  80367c:	09 d0                	or     %edx,%eax
  80367e:	d3 eb                	shr    %cl,%ebx
  803680:	89 da                	mov    %ebx,%edx
  803682:	f7 f7                	div    %edi
  803684:	89 d3                	mov    %edx,%ebx
  803686:	f7 24 24             	mull   (%esp)
  803689:	89 c6                	mov    %eax,%esi
  80368b:	89 d1                	mov    %edx,%ecx
  80368d:	39 d3                	cmp    %edx,%ebx
  80368f:	0f 82 87 00 00 00    	jb     80371c <__umoddi3+0x134>
  803695:	0f 84 91 00 00 00    	je     80372c <__umoddi3+0x144>
  80369b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80369f:	29 f2                	sub    %esi,%edx
  8036a1:	19 cb                	sbb    %ecx,%ebx
  8036a3:	89 d8                	mov    %ebx,%eax
  8036a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036a9:	d3 e0                	shl    %cl,%eax
  8036ab:	89 e9                	mov    %ebp,%ecx
  8036ad:	d3 ea                	shr    %cl,%edx
  8036af:	09 d0                	or     %edx,%eax
  8036b1:	89 e9                	mov    %ebp,%ecx
  8036b3:	d3 eb                	shr    %cl,%ebx
  8036b5:	89 da                	mov    %ebx,%edx
  8036b7:	83 c4 1c             	add    $0x1c,%esp
  8036ba:	5b                   	pop    %ebx
  8036bb:	5e                   	pop    %esi
  8036bc:	5f                   	pop    %edi
  8036bd:	5d                   	pop    %ebp
  8036be:	c3                   	ret    
  8036bf:	90                   	nop
  8036c0:	89 fd                	mov    %edi,%ebp
  8036c2:	85 ff                	test   %edi,%edi
  8036c4:	75 0b                	jne    8036d1 <__umoddi3+0xe9>
  8036c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036cb:	31 d2                	xor    %edx,%edx
  8036cd:	f7 f7                	div    %edi
  8036cf:	89 c5                	mov    %eax,%ebp
  8036d1:	89 f0                	mov    %esi,%eax
  8036d3:	31 d2                	xor    %edx,%edx
  8036d5:	f7 f5                	div    %ebp
  8036d7:	89 c8                	mov    %ecx,%eax
  8036d9:	f7 f5                	div    %ebp
  8036db:	89 d0                	mov    %edx,%eax
  8036dd:	e9 44 ff ff ff       	jmp    803626 <__umoddi3+0x3e>
  8036e2:	66 90                	xchg   %ax,%ax
  8036e4:	89 c8                	mov    %ecx,%eax
  8036e6:	89 f2                	mov    %esi,%edx
  8036e8:	83 c4 1c             	add    $0x1c,%esp
  8036eb:	5b                   	pop    %ebx
  8036ec:	5e                   	pop    %esi
  8036ed:	5f                   	pop    %edi
  8036ee:	5d                   	pop    %ebp
  8036ef:	c3                   	ret    
  8036f0:	3b 04 24             	cmp    (%esp),%eax
  8036f3:	72 06                	jb     8036fb <__umoddi3+0x113>
  8036f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036f9:	77 0f                	ja     80370a <__umoddi3+0x122>
  8036fb:	89 f2                	mov    %esi,%edx
  8036fd:	29 f9                	sub    %edi,%ecx
  8036ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803703:	89 14 24             	mov    %edx,(%esp)
  803706:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80370a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80370e:	8b 14 24             	mov    (%esp),%edx
  803711:	83 c4 1c             	add    $0x1c,%esp
  803714:	5b                   	pop    %ebx
  803715:	5e                   	pop    %esi
  803716:	5f                   	pop    %edi
  803717:	5d                   	pop    %ebp
  803718:	c3                   	ret    
  803719:	8d 76 00             	lea    0x0(%esi),%esi
  80371c:	2b 04 24             	sub    (%esp),%eax
  80371f:	19 fa                	sbb    %edi,%edx
  803721:	89 d1                	mov    %edx,%ecx
  803723:	89 c6                	mov    %eax,%esi
  803725:	e9 71 ff ff ff       	jmp    80369b <__umoddi3+0xb3>
  80372a:	66 90                	xchg   %ax,%ax
  80372c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803730:	72 ea                	jb     80371c <__umoddi3+0x134>
  803732:	89 d9                	mov    %ebx,%ecx
  803734:	e9 62 ff ff ff       	jmp    80369b <__umoddi3+0xb3>
