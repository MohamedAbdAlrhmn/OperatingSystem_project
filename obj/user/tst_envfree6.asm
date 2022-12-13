
obj/user/tst_envfree6:     file format elf32-i386


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
  800031:	e8 5c 01 00 00       	call   800192 <libmain>
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
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 36 80 00       	push   $0x8036c0
  80004a:	e8 50 15 00 00       	call   80159f <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 7c 17 00 00       	call   8017df <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 14 18 00 00       	call   80187f <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 36 80 00       	push   $0x8036d0
  800079:	e8 04 05 00 00       	call   800582 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000, (myEnv->SecondListSize),50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 03 37 80 00       	push   $0x803703
  800099:	e8 b3 19 00 00       	call   801a51 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	6a 14                	push   $0x14
  8000b4:	68 0c 37 80 00       	push   $0x80370c
  8000b9:	e8 93 19 00 00       	call   801a51 <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 a0 19 00 00       	call   801a6f <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 10 27 00 00       	push   $0x2710
  8000da:	e8 c2 32 00 00       	call   8033a1 <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e8:	e8 82 19 00 00       	call   801a6f <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f0:	90                   	nop
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	83 f8 02             	cmp    $0x2,%eax
  8000f9:	75 f6                	jne    8000f1 <_main+0xb9>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fb:	e8 df 16 00 00       	call   8017df <sys_calculate_free_frames>
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	68 18 37 80 00       	push   $0x803718
  800109:	e8 74 04 00 00       	call   800582 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 e8             	pushl  -0x18(%ebp)
  800117:	e8 6f 19 00 00       	call   801a8b <sys_destroy_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 61 19 00 00       	call   801a8b <sys_destroy_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80012d:	e8 ad 16 00 00       	call   8017df <sys_calculate_free_frames>
  800132:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800135:	e8 45 17 00 00       	call   80187f <sys_pf_calculate_allocated_pages>
  80013a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80013d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800143:	74 27                	je     80016c <_main+0x134>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 e0             	pushl  -0x20(%ebp)
  80014b:	68 4c 37 80 00       	push   $0x80374c
  800150:	e8 2d 04 00 00       	call   800582 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 9c 37 80 00       	push   $0x80379c
  800160:	6a 23                	push   $0x23
  800162:	68 d2 37 80 00       	push   $0x8037d2
  800167:	e8 62 01 00 00       	call   8002ce <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 e0             	pushl  -0x20(%ebp)
  800172:	68 e8 37 80 00       	push   $0x8037e8
  800177:	e8 06 04 00 00       	call   800582 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 48 38 80 00       	push   $0x803848
  800187:	e8 f6 03 00 00       	call   800582 <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp
	return;
  80018f:	90                   	nop
}
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800198:	e8 22 19 00 00       	call   801abf <sys_getenvindex>
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a3:	89 d0                	mov    %edx,%eax
  8001a5:	c1 e0 03             	shl    $0x3,%eax
  8001a8:	01 d0                	add    %edx,%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	01 d0                	add    %edx,%eax
  8001ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b5:	01 d0                	add    %edx,%eax
  8001b7:	c1 e0 04             	shl    $0x4,%eax
  8001ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bf:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c4:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c9:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001cf:	84 c0                	test   %al,%al
  8001d1:	74 0f                	je     8001e2 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8001d8:	05 5c 05 00 00       	add    $0x55c,%eax
  8001dd:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e6:	7e 0a                	jle    8001f2 <libmain+0x60>
		binaryname = argv[0];
  8001e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001eb:	8b 00                	mov    (%eax),%eax
  8001ed:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 38 fe ff ff       	call   800038 <_main>
  800200:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800203:	e8 c4 16 00 00       	call   8018cc <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 ac 38 80 00       	push   $0x8038ac
  800210:	e8 6d 03 00 00       	call   800582 <cprintf>
  800215:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800218:	a1 20 50 80 00       	mov    0x805020,%eax
  80021d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800223:	a1 20 50 80 00       	mov    0x805020,%eax
  800228:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	52                   	push   %edx
  800232:	50                   	push   %eax
  800233:	68 d4 38 80 00       	push   $0x8038d4
  800238:	e8 45 03 00 00       	call   800582 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800240:	a1 20 50 80 00       	mov    0x805020,%eax
  800245:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024b:	a1 20 50 80 00       	mov    0x805020,%eax
  800250:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800256:	a1 20 50 80 00       	mov    0x805020,%eax
  80025b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800261:	51                   	push   %ecx
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	68 fc 38 80 00       	push   $0x8038fc
  800269:	e8 14 03 00 00       	call   800582 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 50 80 00       	mov    0x805020,%eax
  800276:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 54 39 80 00       	push   $0x803954
  800285:	e8 f8 02 00 00       	call   800582 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 ac 38 80 00       	push   $0x8038ac
  800295:	e8 e8 02 00 00       	call   800582 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029d:	e8 44 16 00 00       	call   8018e6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a2:	e8 19 00 00 00       	call   8002c0 <exit>
}
  8002a7:	90                   	nop
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b0:	83 ec 0c             	sub    $0xc,%esp
  8002b3:	6a 00                	push   $0x0
  8002b5:	e8 d1 17 00 00       	call   801a8b <sys_destroy_env>
  8002ba:	83 c4 10             	add    $0x10,%esp
}
  8002bd:	90                   	nop
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <exit>:

void
exit(void)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c6:	e8 26 18 00 00       	call   801af1 <sys_exit_env>
}
  8002cb:	90                   	nop
  8002cc:	c9                   	leave  
  8002cd:	c3                   	ret    

008002ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d4:	8d 45 10             	lea    0x10(%ebp),%eax
  8002d7:	83 c0 04             	add    $0x4,%eax
  8002da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002dd:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002e2:	85 c0                	test   %eax,%eax
  8002e4:	74 16                	je     8002fc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e6:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	50                   	push   %eax
  8002ef:	68 68 39 80 00       	push   $0x803968
  8002f4:	e8 89 02 00 00       	call   800582 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fc:	a1 00 50 80 00       	mov    0x805000,%eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	50                   	push   %eax
  800308:	68 6d 39 80 00       	push   $0x80396d
  80030d:	e8 70 02 00 00       	call   800582 <cprintf>
  800312:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800315:	8b 45 10             	mov    0x10(%ebp),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 f4             	pushl  -0xc(%ebp)
  80031e:	50                   	push   %eax
  80031f:	e8 f3 01 00 00       	call   800517 <vcprintf>
  800324:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	6a 00                	push   $0x0
  80032c:	68 89 39 80 00       	push   $0x803989
  800331:	e8 e1 01 00 00       	call   800517 <vcprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800339:	e8 82 ff ff ff       	call   8002c0 <exit>

	// should not return here
	while (1) ;
  80033e:	eb fe                	jmp    80033e <_panic+0x70>

00800340 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800346:	a1 20 50 80 00       	mov    0x805020,%eax
  80034b:	8b 50 74             	mov    0x74(%eax),%edx
  80034e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800351:	39 c2                	cmp    %eax,%edx
  800353:	74 14                	je     800369 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	68 8c 39 80 00       	push   $0x80398c
  80035d:	6a 26                	push   $0x26
  80035f:	68 d8 39 80 00       	push   $0x8039d8
  800364:	e8 65 ff ff ff       	call   8002ce <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800370:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800377:	e9 c2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	01 d0                	add    %edx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	85 c0                	test   %eax,%eax
  80038f:	75 08                	jne    800399 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800391:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800394:	e9 a2 00 00 00       	jmp    80043b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800399:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a7:	eb 69                	jmp    800412 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ae:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b7:	89 d0                	mov    %edx,%eax
  8003b9:	01 c0                	add    %eax,%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	c1 e0 03             	shl    $0x3,%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8a 40 04             	mov    0x4(%eax),%al
  8003c5:	84 c0                	test   %al,%al
  8003c7:	75 46                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8003ce:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d7:	89 d0                	mov    %edx,%eax
  8003d9:	01 c0                	add    %eax,%eax
  8003db:	01 d0                	add    %edx,%eax
  8003dd:	c1 e0 03             	shl    $0x3,%eax
  8003e0:	01 c8                	add    %ecx,%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ef:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800402:	39 c2                	cmp    %eax,%edx
  800404:	75 09                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800406:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80040d:	eb 12                	jmp    800421 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040f:	ff 45 e8             	incl   -0x18(%ebp)
  800412:	a1 20 50 80 00       	mov    0x805020,%eax
  800417:	8b 50 74             	mov    0x74(%eax),%edx
  80041a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	77 88                	ja     8003a9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800421:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800425:	75 14                	jne    80043b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800427:	83 ec 04             	sub    $0x4,%esp
  80042a:	68 e4 39 80 00       	push   $0x8039e4
  80042f:	6a 3a                	push   $0x3a
  800431:	68 d8 39 80 00       	push   $0x8039d8
  800436:	e8 93 fe ff ff       	call   8002ce <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043b:	ff 45 f0             	incl   -0x10(%ebp)
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800444:	0f 8c 32 ff ff ff    	jl     80037c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800451:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800458:	eb 26                	jmp    800480 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045a:	a1 20 50 80 00       	mov    0x805020,%eax
  80045f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800468:	89 d0                	mov    %edx,%eax
  80046a:	01 c0                	add    %eax,%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	c1 e0 03             	shl    $0x3,%eax
  800471:	01 c8                	add    %ecx,%eax
  800473:	8a 40 04             	mov    0x4(%eax),%al
  800476:	3c 01                	cmp    $0x1,%al
  800478:	75 03                	jne    80047d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047d:	ff 45 e0             	incl   -0x20(%ebp)
  800480:	a1 20 50 80 00       	mov    0x805020,%eax
  800485:	8b 50 74             	mov    0x74(%eax),%edx
  800488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048b:	39 c2                	cmp    %eax,%edx
  80048d:	77 cb                	ja     80045a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800495:	74 14                	je     8004ab <CheckWSWithoutLastIndex+0x16b>
		panic(
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	68 38 3a 80 00       	push   $0x803a38
  80049f:	6a 44                	push   $0x44
  8004a1:	68 d8 39 80 00       	push   $0x8039d8
  8004a6:	e8 23 fe ff ff       	call   8002ce <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bf:	89 0a                	mov    %ecx,(%edx)
  8004c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c4:	88 d1                	mov    %dl,%cl
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d7:	75 2c                	jne    800505 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004d9:	a0 24 50 80 00       	mov    0x805024,%al
  8004de:	0f b6 c0             	movzbl %al,%eax
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	8b 12                	mov    (%edx),%edx
  8004e6:	89 d1                	mov    %edx,%ecx
  8004e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004eb:	83 c2 08             	add    $0x8,%edx
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	50                   	push   %eax
  8004f2:	51                   	push   %ecx
  8004f3:	52                   	push   %edx
  8004f4:	e8 25 12 00 00       	call   80171e <sys_cputs>
  8004f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
  800508:	8b 40 04             	mov    0x4(%eax),%eax
  80050b:	8d 50 01             	lea    0x1(%eax),%edx
  80050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800511:	89 50 04             	mov    %edx,0x4(%eax)
}
  800514:	90                   	nop
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800520:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800527:	00 00 00 
	b.cnt = 0;
  80052a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800531:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	ff 75 08             	pushl  0x8(%ebp)
  80053a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800540:	50                   	push   %eax
  800541:	68 ae 04 80 00       	push   $0x8004ae
  800546:	e8 11 02 00 00       	call   80075c <vprintfmt>
  80054b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80054e:	a0 24 50 80 00       	mov    0x805024,%al
  800553:	0f b6 c0             	movzbl %al,%eax
  800556:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055c:	83 ec 04             	sub    $0x4,%esp
  80055f:	50                   	push   %eax
  800560:	52                   	push   %edx
  800561:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800567:	83 c0 08             	add    $0x8,%eax
  80056a:	50                   	push   %eax
  80056b:	e8 ae 11 00 00       	call   80171e <sys_cputs>
  800570:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800573:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80057a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <cprintf>:

int cprintf(const char *fmt, ...) {
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800588:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80058f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	ff 75 f4             	pushl  -0xc(%ebp)
  80059e:	50                   	push   %eax
  80059f:	e8 73 ff ff ff       	call   800517 <vcprintf>
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b5:	e8 12 13 00 00       	call   8018cc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c9:	50                   	push   %eax
  8005ca:	e8 48 ff ff ff       	call   800517 <vcprintf>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d5:	e8 0c 13 00 00       	call   8018e6 <sys_enable_interrupt>
	return cnt;
  8005da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	53                   	push   %ebx
  8005e3:	83 ec 14             	sub    $0x14,%esp
  8005e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005fd:	77 55                	ja     800654 <printnum+0x75>
  8005ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800602:	72 05                	jb     800609 <printnum+0x2a>
  800604:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800607:	77 4b                	ja     800654 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800609:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80060f:	8b 45 18             	mov    0x18(%ebp),%eax
  800612:	ba 00 00 00 00       	mov    $0x0,%edx
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	ff 75 f4             	pushl  -0xc(%ebp)
  80061c:	ff 75 f0             	pushl  -0x10(%ebp)
  80061f:	e8 34 2e 00 00       	call   803458 <__udivdi3>
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	83 ec 04             	sub    $0x4,%esp
  80062a:	ff 75 20             	pushl  0x20(%ebp)
  80062d:	53                   	push   %ebx
  80062e:	ff 75 18             	pushl  0x18(%ebp)
  800631:	52                   	push   %edx
  800632:	50                   	push   %eax
  800633:	ff 75 0c             	pushl  0xc(%ebp)
  800636:	ff 75 08             	pushl  0x8(%ebp)
  800639:	e8 a1 ff ff ff       	call   8005df <printnum>
  80063e:	83 c4 20             	add    $0x20,%esp
  800641:	eb 1a                	jmp    80065d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	ff 75 20             	pushl  0x20(%ebp)
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	ff d0                	call   *%eax
  800651:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800654:	ff 4d 1c             	decl   0x1c(%ebp)
  800657:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065b:	7f e6                	jg     800643 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80065d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800660:	bb 00 00 00 00       	mov    $0x0,%ebx
  800665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066b:	53                   	push   %ebx
  80066c:	51                   	push   %ecx
  80066d:	52                   	push   %edx
  80066e:	50                   	push   %eax
  80066f:	e8 f4 2e 00 00       	call   803568 <__umoddi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	05 b4 3c 80 00       	add    $0x803cb4,%eax
  80067c:	8a 00                	mov    (%eax),%al
  80067e:	0f be c0             	movsbl %al,%eax
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	50                   	push   %eax
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	ff d0                	call   *%eax
  80068d:	83 c4 10             	add    $0x10,%esp
}
  800690:	90                   	nop
  800691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800694:	c9                   	leave  
  800695:	c3                   	ret    

00800696 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800696:	55                   	push   %ebp
  800697:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800699:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069d:	7e 1c                	jle    8006bb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8d 50 08             	lea    0x8(%eax),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	89 10                	mov    %edx,(%eax)
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	83 e8 08             	sub    $0x8,%eax
  8006b4:	8b 50 04             	mov    0x4(%eax),%edx
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	eb 40                	jmp    8006fb <getuint+0x65>
	else if (lflag)
  8006bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006bf:	74 1e                	je     8006df <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	8d 50 04             	lea    0x4(%eax),%edx
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	89 10                	mov    %edx,(%eax)
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	83 e8 04             	sub    $0x4,%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dd:	eb 1c                	jmp    8006fb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	8d 50 04             	lea    0x4(%eax),%edx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	89 10                	mov    %edx,(%eax)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	83 e8 04             	sub    $0x4,%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getint+0x25>
		return va_arg(*ap, long long);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 50 08             	lea    0x8(%eax),%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 10                	mov    %edx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	83 e8 08             	sub    $0x8,%eax
  80071b:	8b 50 04             	mov    0x4(%eax),%edx
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	eb 38                	jmp    80075a <getint+0x5d>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1a                	je     800742 <getint+0x45>
		return va_arg(*ap, long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	99                   	cltd   
  800740:	eb 18                	jmp    80075a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	8d 50 04             	lea    0x4(%eax),%edx
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	89 10                	mov    %edx,(%eax)
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	83 e8 04             	sub    $0x4,%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	99                   	cltd   
}
  80075a:	5d                   	pop    %ebp
  80075b:	c3                   	ret    

0080075c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	56                   	push   %esi
  800760:	53                   	push   %ebx
  800761:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	eb 17                	jmp    80077d <vprintfmt+0x21>
			if (ch == '\0')
  800766:	85 db                	test   %ebx,%ebx
  800768:	0f 84 af 03 00 00    	je     800b1d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	53                   	push   %ebx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077d:	8b 45 10             	mov    0x10(%ebp),%eax
  800780:	8d 50 01             	lea    0x1(%eax),%edx
  800783:	89 55 10             	mov    %edx,0x10(%ebp)
  800786:	8a 00                	mov    (%eax),%al
  800788:	0f b6 d8             	movzbl %al,%ebx
  80078b:	83 fb 25             	cmp    $0x25,%ebx
  80078e:	75 d6                	jne    800766 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800790:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800794:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b3:	8d 50 01             	lea    0x1(%eax),%edx
  8007b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b9:	8a 00                	mov    (%eax),%al
  8007bb:	0f b6 d8             	movzbl %al,%ebx
  8007be:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c1:	83 f8 55             	cmp    $0x55,%eax
  8007c4:	0f 87 2b 03 00 00    	ja     800af5 <vprintfmt+0x399>
  8007ca:	8b 04 85 d8 3c 80 00 	mov    0x803cd8(,%eax,4),%eax
  8007d1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007d7:	eb d7                	jmp    8007b0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007dd:	eb d1                	jmp    8007b0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007e9:	89 d0                	mov    %edx,%eax
  8007eb:	c1 e0 02             	shl    $0x2,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	01 c0                	add    %eax,%eax
  8007f2:	01 d8                	add    %ebx,%eax
  8007f4:	83 e8 30             	sub    $0x30,%eax
  8007f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fd:	8a 00                	mov    (%eax),%al
  8007ff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800802:	83 fb 2f             	cmp    $0x2f,%ebx
  800805:	7e 3e                	jle    800845 <vprintfmt+0xe9>
  800807:	83 fb 39             	cmp    $0x39,%ebx
  80080a:	7f 39                	jg     800845 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80080f:	eb d5                	jmp    8007e6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	83 c0 04             	add    $0x4,%eax
  800817:	89 45 14             	mov    %eax,0x14(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	83 e8 04             	sub    $0x4,%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800825:	eb 1f                	jmp    800846 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800827:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082b:	79 83                	jns    8007b0 <vprintfmt+0x54>
				width = 0;
  80082d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800834:	e9 77 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800839:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800840:	e9 6b ff ff ff       	jmp    8007b0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800845:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800846:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084a:	0f 89 60 ff ff ff    	jns    8007b0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800850:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800856:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80085d:	e9 4e ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800862:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800865:	e9 46 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	83 c0 04             	add    $0x4,%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 e8 04             	sub    $0x4,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	50                   	push   %eax
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
			break;
  80088a:	e9 89 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	83 c0 04             	add    $0x4,%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	83 e8 04             	sub    $0x4,%eax
  80089e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a0:	85 db                	test   %ebx,%ebx
  8008a2:	79 02                	jns    8008a6 <vprintfmt+0x14a>
				err = -err;
  8008a4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a6:	83 fb 64             	cmp    $0x64,%ebx
  8008a9:	7f 0b                	jg     8008b6 <vprintfmt+0x15a>
  8008ab:	8b 34 9d 20 3b 80 00 	mov    0x803b20(,%ebx,4),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 19                	jne    8008cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b6:	53                   	push   %ebx
  8008b7:	68 c5 3c 80 00       	push   $0x803cc5
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 5e 02 00 00       	call   800b25 <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ca:	e9 49 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008cf:	56                   	push   %esi
  8008d0:	68 ce 3c 80 00       	push   $0x803cce
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 45 02 00 00       	call   800b25 <printfmt>
  8008e0:	83 c4 10             	add    $0x10,%esp
			break;
  8008e3:	e9 30 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	83 c0 04             	add    $0x4,%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 30                	mov    (%eax),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 05                	jne    800902 <vprintfmt+0x1a6>
				p = "(null)";
  8008fd:	be d1 3c 80 00       	mov    $0x803cd1,%esi
			if (width > 0 && padc != '-')
  800902:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800906:	7e 6d                	jle    800975 <vprintfmt+0x219>
  800908:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090c:	74 67                	je     800975 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80090e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	50                   	push   %eax
  800915:	56                   	push   %esi
  800916:	e8 0c 03 00 00       	call   800c27 <strnlen>
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800921:	eb 16                	jmp    800939 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800923:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	50                   	push   %eax
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800936:	ff 4d e4             	decl   -0x1c(%ebp)
  800939:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093d:	7f e4                	jg     800923 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093f:	eb 34                	jmp    800975 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800941:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800945:	74 1c                	je     800963 <vprintfmt+0x207>
  800947:	83 fb 1f             	cmp    $0x1f,%ebx
  80094a:	7e 05                	jle    800951 <vprintfmt+0x1f5>
  80094c:	83 fb 7e             	cmp    $0x7e,%ebx
  80094f:	7e 12                	jle    800963 <vprintfmt+0x207>
					putch('?', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	6a 3f                	push   $0x3f
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	eb 0f                	jmp    800972 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	53                   	push   %ebx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	ff d0                	call   *%eax
  80096f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800972:	ff 4d e4             	decl   -0x1c(%ebp)
  800975:	89 f0                	mov    %esi,%eax
  800977:	8d 70 01             	lea    0x1(%eax),%esi
  80097a:	8a 00                	mov    (%eax),%al
  80097c:	0f be d8             	movsbl %al,%ebx
  80097f:	85 db                	test   %ebx,%ebx
  800981:	74 24                	je     8009a7 <vprintfmt+0x24b>
  800983:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800987:	78 b8                	js     800941 <vprintfmt+0x1e5>
  800989:	ff 4d e0             	decl   -0x20(%ebp)
  80098c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800990:	79 af                	jns    800941 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800992:	eb 13                	jmp    8009a7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	6a 20                	push   $0x20
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	ff d0                	call   *%eax
  8009a1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ab:	7f e7                	jg     800994 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009ad:	e9 66 01 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bb:	50                   	push   %eax
  8009bc:	e8 3c fd ff ff       	call   8006fd <getint>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d0:	85 d2                	test   %edx,%edx
  8009d2:	79 23                	jns    8009f7 <vprintfmt+0x29b>
				putch('-', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 2d                	push   $0x2d
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ea:	f7 d8                	neg    %eax
  8009ec:	83 d2 00             	adc    $0x0,%edx
  8009ef:	f7 da                	neg    %edx
  8009f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009fe:	e9 bc 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 e8             	pushl  -0x18(%ebp)
  800a09:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0c:	50                   	push   %eax
  800a0d:	e8 84 fc ff ff       	call   800696 <getuint>
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a22:	e9 98 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 58                	push   $0x58
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	6a 58                	push   $0x58
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	6a 58                	push   $0x58
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
			break;
  800a57:	e9 bc 00 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	6a 30                	push   $0x30
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	ff d0                	call   *%eax
  800a69:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	6a 78                	push   $0x78
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a9e:	eb 1f                	jmp    800abf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa6:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa9:	50                   	push   %eax
  800aaa:	e8 e7 fb ff ff       	call   800696 <getuint>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ab8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800abf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac6:	83 ec 04             	sub    $0x4,%esp
  800ac9:	52                   	push   %edx
  800aca:	ff 75 e4             	pushl  -0x1c(%ebp)
  800acd:	50                   	push   %eax
  800ace:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	ff 75 08             	pushl  0x8(%ebp)
  800ada:	e8 00 fb ff ff       	call   8005df <printnum>
  800adf:	83 c4 20             	add    $0x20,%esp
			break;
  800ae2:	eb 34                	jmp    800b18 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	53                   	push   %ebx
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	eb 23                	jmp    800b18 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	6a 25                	push   $0x25
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b05:	ff 4d 10             	decl   0x10(%ebp)
  800b08:	eb 03                	jmp    800b0d <vprintfmt+0x3b1>
  800b0a:	ff 4d 10             	decl   0x10(%ebp)
  800b0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b10:	48                   	dec    %eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	3c 25                	cmp    $0x25,%al
  800b15:	75 f3                	jne    800b0a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b17:	90                   	nop
		}
	}
  800b18:	e9 47 fc ff ff       	jmp    800764 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b2e:	83 c0 04             	add    $0x4,%eax
  800b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b34:	8b 45 10             	mov    0x10(%ebp),%eax
  800b37:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3a:	50                   	push   %eax
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 16 fc ff ff       	call   80075c <vprintfmt>
  800b46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b49:	90                   	nop
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8b 40 08             	mov    0x8(%eax),%eax
  800b55:	8d 50 01             	lea    0x1(%eax),%edx
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 10                	mov    (%eax),%edx
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8b 40 04             	mov    0x4(%eax),%eax
  800b69:	39 c2                	cmp    %eax,%edx
  800b6b:	73 12                	jae    800b7f <sprintputch+0x33>
		*b->buf++ = ch;
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	8d 48 01             	lea    0x1(%eax),%ecx
  800b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b78:	89 0a                	mov    %ecx,(%edx)
  800b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7d:	88 10                	mov    %dl,(%eax)
}
  800b7f:	90                   	nop
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	01 d0                	add    %edx,%eax
  800b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba7:	74 06                	je     800baf <vsnprintf+0x2d>
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	7f 07                	jg     800bb6 <vsnprintf+0x34>
		return -E_INVAL;
  800baf:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb4:	eb 20                	jmp    800bd6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb6:	ff 75 14             	pushl  0x14(%ebp)
  800bb9:	ff 75 10             	pushl  0x10(%ebp)
  800bbc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bbf:	50                   	push   %eax
  800bc0:	68 4c 0b 80 00       	push   $0x800b4c
  800bc5:	e8 92 fb ff ff       	call   80075c <vprintfmt>
  800bca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bde:	8d 45 10             	lea    0x10(%ebp),%eax
  800be1:	83 c0 04             	add    $0x4,%eax
  800be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	ff 75 f4             	pushl  -0xc(%ebp)
  800bed:	50                   	push   %eax
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	ff 75 08             	pushl  0x8(%ebp)
  800bf4:	e8 89 ff ff ff       	call   800b82 <vsnprintf>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c11:	eb 06                	jmp    800c19 <strlen+0x15>
		n++;
  800c13:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c16:	ff 45 08             	incl   0x8(%ebp)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	84 c0                	test   %al,%al
  800c20:	75 f1                	jne    800c13 <strlen+0xf>
		n++;
	return n;
  800c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c34:	eb 09                	jmp    800c3f <strnlen+0x18>
		n++;
  800c36:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c39:	ff 45 08             	incl   0x8(%ebp)
  800c3c:	ff 4d 0c             	decl   0xc(%ebp)
  800c3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c43:	74 09                	je     800c4e <strnlen+0x27>
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	84 c0                	test   %al,%al
  800c4c:	75 e8                	jne    800c36 <strnlen+0xf>
		n++;
	return n;
  800c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c5f:	90                   	nop
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8d 50 01             	lea    0x1(%eax),%edx
  800c66:	89 55 08             	mov    %edx,0x8(%ebp)
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c72:	8a 12                	mov    (%edx),%dl
  800c74:	88 10                	mov    %dl,(%eax)
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 e4                	jne    800c60 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c94:	eb 1f                	jmp    800cb5 <strncpy+0x34>
		*dst++ = *src;
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca2:	8a 12                	mov    (%edx),%dl
  800ca4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	74 03                	je     800cb2 <strncpy+0x31>
			src++;
  800caf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb2:	ff 45 fc             	incl   -0x4(%ebp)
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbb:	72 d9                	jb     800c96 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc0:	c9                   	leave  
  800cc1:	c3                   	ret    

00800cc2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd2:	74 30                	je     800d04 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd4:	eb 16                	jmp    800cec <strlcpy+0x2a>
			*dst++ = *src++;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8d 50 01             	lea    0x1(%eax),%edx
  800cdc:	89 55 08             	mov    %edx,0x8(%ebp)
  800cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce8:	8a 12                	mov    (%edx),%dl
  800cea:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cec:	ff 4d 10             	decl   0x10(%ebp)
  800cef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf3:	74 09                	je     800cfe <strlcpy+0x3c>
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 d8                	jne    800cd6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0a:	29 c2                	sub    %eax,%edx
  800d0c:	89 d0                	mov    %edx,%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d13:	eb 06                	jmp    800d1b <strcmp+0xb>
		p++, q++;
  800d15:	ff 45 08             	incl   0x8(%ebp)
  800d18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	84 c0                	test   %al,%al
  800d22:	74 0e                	je     800d32 <strcmp+0x22>
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8a 10                	mov    (%eax),%dl
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	38 c2                	cmp    %al,%dl
  800d30:	74 e3                	je     800d15 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f b6 d0             	movzbl %al,%edx
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f b6 c0             	movzbl %al,%eax
  800d42:	29 c2                	sub    %eax,%edx
  800d44:	89 d0                	mov    %edx,%eax
}
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4b:	eb 09                	jmp    800d56 <strncmp+0xe>
		n--, p++, q++;
  800d4d:	ff 4d 10             	decl   0x10(%ebp)
  800d50:	ff 45 08             	incl   0x8(%ebp)
  800d53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 17                	je     800d73 <strncmp+0x2b>
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	74 0e                	je     800d73 <strncmp+0x2b>
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 10                	mov    (%eax),%dl
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	38 c2                	cmp    %al,%dl
  800d71:	74 da                	je     800d4d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d77:	75 07                	jne    800d80 <strncmp+0x38>
		return 0;
  800d79:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7e:	eb 14                	jmp    800d94 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 d0             	movzbl %al,%edx
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	0f b6 c0             	movzbl %al,%eax
  800d90:	29 c2                	sub    %eax,%edx
  800d92:	89 d0                	mov    %edx,%eax
}
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 04             	sub    $0x4,%esp
  800d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da2:	eb 12                	jmp    800db6 <strchr+0x20>
		if (*s == c)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dac:	75 05                	jne    800db3 <strchr+0x1d>
			return (char *) s;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	eb 11                	jmp    800dc4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db3:	ff 45 08             	incl   0x8(%ebp)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	75 e5                	jne    800da4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 04             	sub    $0x4,%esp
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd2:	eb 0d                	jmp    800de1 <strfind+0x1b>
		if (*s == c)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddc:	74 0e                	je     800dec <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dde:	ff 45 08             	incl   0x8(%ebp)
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	84 c0                	test   %al,%al
  800de8:	75 ea                	jne    800dd4 <strfind+0xe>
  800dea:	eb 01                	jmp    800ded <strfind+0x27>
		if (*s == c)
			break;
  800dec:	90                   	nop
	return (char *) s;
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e04:	eb 0e                	jmp    800e14 <memset+0x22>
		*p++ = c;
  800e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e09:	8d 50 01             	lea    0x1(%eax),%edx
  800e0c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e12:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e14:	ff 4d f8             	decl   -0x8(%ebp)
  800e17:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1b:	79 e9                	jns    800e06 <memset+0x14>
		*p++ = c;

	return v;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e34:	eb 16                	jmp    800e4c <memcpy+0x2a>
		*d++ = *s++;
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	8d 50 01             	lea    0x1(%eax),%edx
  800e3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e48:	8a 12                	mov    (%edx),%dl
  800e4a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 dd                	jne    800e36 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e76:	73 50                	jae    800ec8 <memmove+0x6a>
  800e78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	01 d0                	add    %edx,%eax
  800e80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e83:	76 43                	jbe    800ec8 <memmove+0x6a>
		s += n;
  800e85:	8b 45 10             	mov    0x10(%ebp),%eax
  800e88:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e91:	eb 10                	jmp    800ea3 <memmove+0x45>
			*--d = *--s;
  800e93:	ff 4d f8             	decl   -0x8(%ebp)
  800e96:	ff 4d fc             	decl   -0x4(%ebp)
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	8a 10                	mov    (%eax),%dl
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	75 e3                	jne    800e93 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb0:	eb 23                	jmp    800ed5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb5:	8d 50 01             	lea    0x1(%eax),%edx
  800eb8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ebe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec4:	8a 12                	mov    (%edx),%dl
  800ec6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ece:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	75 dd                	jne    800eb2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed8:	c9                   	leave  
  800ed9:	c3                   	ret    

00800eda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eec:	eb 2a                	jmp    800f18 <memcmp+0x3e>
		if (*s1 != *s2)
  800eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef1:	8a 10                	mov    (%eax),%dl
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	38 c2                	cmp    %al,%dl
  800efa:	74 16                	je     800f12 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	0f b6 d0             	movzbl %al,%edx
  800f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	0f b6 c0             	movzbl %al,%eax
  800f0c:	29 c2                	sub    %eax,%edx
  800f0e:	89 d0                	mov    %edx,%eax
  800f10:	eb 18                	jmp    800f2a <memcmp+0x50>
		s1++, s2++;
  800f12:	ff 45 fc             	incl   -0x4(%ebp)
  800f15:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	75 c9                	jne    800eee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 d0                	add    %edx,%eax
  800f3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f3d:	eb 15                	jmp    800f54 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	0f b6 d0             	movzbl %al,%edx
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	0f b6 c0             	movzbl %al,%eax
  800f4d:	39 c2                	cmp    %eax,%edx
  800f4f:	74 0d                	je     800f5e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f51:	ff 45 08             	incl   0x8(%ebp)
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5a:	72 e3                	jb     800f3f <memfind+0x13>
  800f5c:	eb 01                	jmp    800f5f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f5e:	90                   	nop
	return (void *) s;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f78:	eb 03                	jmp    800f7d <strtol+0x19>
		s++;
  800f7a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 20                	cmp    $0x20,%al
  800f84:	74 f4                	je     800f7a <strtol+0x16>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 09                	cmp    $0x9,%al
  800f8d:	74 eb                	je     800f7a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 2b                	cmp    $0x2b,%al
  800f96:	75 05                	jne    800f9d <strtol+0x39>
		s++;
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	eb 13                	jmp    800fb0 <strtol+0x4c>
	else if (*s == '-')
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 2d                	cmp    $0x2d,%al
  800fa4:	75 0a                	jne    800fb0 <strtol+0x4c>
		s++, neg = 1;
  800fa6:	ff 45 08             	incl   0x8(%ebp)
  800fa9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb4:	74 06                	je     800fbc <strtol+0x58>
  800fb6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fba:	75 20                	jne    800fdc <strtol+0x78>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 30                	cmp    $0x30,%al
  800fc3:	75 17                	jne    800fdc <strtol+0x78>
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	40                   	inc    %eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 78                	cmp    $0x78,%al
  800fcd:	75 0d                	jne    800fdc <strtol+0x78>
		s += 2, base = 16;
  800fcf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fda:	eb 28                	jmp    801004 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe0:	75 15                	jne    800ff7 <strtol+0x93>
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	3c 30                	cmp    $0x30,%al
  800fe9:	75 0c                	jne    800ff7 <strtol+0x93>
		s++, base = 8;
  800feb:	ff 45 08             	incl   0x8(%ebp)
  800fee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff5:	eb 0d                	jmp    801004 <strtol+0xa0>
	else if (base == 0)
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 07                	jne    801004 <strtol+0xa0>
		base = 10;
  800ffd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2f                	cmp    $0x2f,%al
  80100b:	7e 19                	jle    801026 <strtol+0xc2>
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 39                	cmp    $0x39,%al
  801014:	7f 10                	jg     801026 <strtol+0xc2>
			dig = *s - '0';
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	0f be c0             	movsbl %al,%eax
  80101e:	83 e8 30             	sub    $0x30,%eax
  801021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801024:	eb 42                	jmp    801068 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 60                	cmp    $0x60,%al
  80102d:	7e 19                	jle    801048 <strtol+0xe4>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 7a                	cmp    $0x7a,%al
  801036:	7f 10                	jg     801048 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	83 e8 57             	sub    $0x57,%eax
  801043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801046:	eb 20                	jmp    801068 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 40                	cmp    $0x40,%al
  80104f:	7e 39                	jle    80108a <strtol+0x126>
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 5a                	cmp    $0x5a,%al
  801058:	7f 30                	jg     80108a <strtol+0x126>
			dig = *s - 'A' + 10;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	0f be c0             	movsbl %al,%eax
  801062:	83 e8 37             	sub    $0x37,%eax
  801065:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80106e:	7d 19                	jge    801089 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801070:	ff 45 08             	incl   0x8(%ebp)
  801073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801076:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107f:	01 d0                	add    %edx,%eax
  801081:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801084:	e9 7b ff ff ff       	jmp    801004 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801089:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108e:	74 08                	je     801098 <strtol+0x134>
		*endptr = (char *) s;
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801098:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109c:	74 07                	je     8010a5 <strtol+0x141>
  80109e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a1:	f7 d8                	neg    %eax
  8010a3:	eb 03                	jmp    8010a8 <strtol+0x144>
  8010a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <ltostr>:

void
ltostr(long value, char *str)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c2:	79 13                	jns    8010d7 <ltostr+0x2d>
	{
		neg = 1;
  8010c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010df:	99                   	cltd   
  8010e0:	f7 f9                	idiv   %ecx
  8010e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	83 c2 30             	add    $0x30,%edx
  8010fb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801100:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801105:	f7 e9                	imul   %ecx
  801107:	c1 fa 02             	sar    $0x2,%edx
  80110a:	89 c8                	mov    %ecx,%eax
  80110c:	c1 f8 1f             	sar    $0x1f,%eax
  80110f:	29 c2                	sub    %eax,%edx
  801111:	89 d0                	mov    %edx,%eax
  801113:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801116:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801119:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80111e:	f7 e9                	imul   %ecx
  801120:	c1 fa 02             	sar    $0x2,%edx
  801123:	89 c8                	mov    %ecx,%eax
  801125:	c1 f8 1f             	sar    $0x1f,%eax
  801128:	29 c2                	sub    %eax,%edx
  80112a:	89 d0                	mov    %edx,%eax
  80112c:	c1 e0 02             	shl    $0x2,%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	01 c0                	add    %eax,%eax
  801133:	29 c1                	sub    %eax,%ecx
  801135:	89 ca                	mov    %ecx,%edx
  801137:	85 d2                	test   %edx,%edx
  801139:	75 9c                	jne    8010d7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	48                   	dec    %eax
  801146:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801149:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114d:	74 3d                	je     80118c <ltostr+0xe2>
		start = 1 ;
  80114f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801156:	eb 34                	jmp    80118c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801165:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	01 c2                	add    %eax,%edx
  80116d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	01 c8                	add    %ecx,%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801179:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	01 c2                	add    %eax,%edx
  801181:	8a 45 eb             	mov    -0x15(%ebp),%al
  801184:	88 02                	mov    %al,(%edx)
		start++ ;
  801186:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801189:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801192:	7c c4                	jl     801158 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801194:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80119f:	90                   	nop
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011a8:	ff 75 08             	pushl  0x8(%ebp)
  8011ab:	e8 54 fa ff ff       	call   800c04 <strlen>
  8011b0:	83 c4 04             	add    $0x4,%esp
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b6:	ff 75 0c             	pushl  0xc(%ebp)
  8011b9:	e8 46 fa ff ff       	call   800c04 <strlen>
  8011be:	83 c4 04             	add    $0x4,%esp
  8011c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d2:	eb 17                	jmp    8011eb <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	01 c2                	add    %eax,%edx
  8011dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	01 c8                	add    %ecx,%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011e8:	ff 45 fc             	incl   -0x4(%ebp)
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f1:	7c e1                	jl     8011d4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801201:	eb 1f                	jmp    801222 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801206:	8d 50 01             	lea    0x1(%eax),%edx
  801209:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120c:	89 c2                	mov    %eax,%edx
  80120e:	8b 45 10             	mov    0x10(%ebp),%eax
  801211:	01 c2                	add    %eax,%edx
  801213:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 c8                	add    %ecx,%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80121f:	ff 45 f8             	incl   -0x8(%ebp)
  801222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801225:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801228:	7c d9                	jl     801203 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	c6 00 00             	movb   $0x0,(%eax)
}
  801235:	90                   	nop
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123b:	8b 45 14             	mov    0x14(%ebp),%eax
  80123e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801250:	8b 45 10             	mov    0x10(%ebp),%eax
  801253:	01 d0                	add    %edx,%eax
  801255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125b:	eb 0c                	jmp    801269 <strsplit+0x31>
			*string++ = 0;
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 08             	mov    %edx,0x8(%ebp)
  801266:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	84 c0                	test   %al,%al
  801270:	74 18                	je     80128a <strsplit+0x52>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	0f be c0             	movsbl %al,%eax
  80127a:	50                   	push   %eax
  80127b:	ff 75 0c             	pushl  0xc(%ebp)
  80127e:	e8 13 fb ff ff       	call   800d96 <strchr>
  801283:	83 c4 08             	add    $0x8,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	75 d3                	jne    80125d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	84 c0                	test   %al,%al
  801291:	74 5a                	je     8012ed <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	83 f8 0f             	cmp    $0xf,%eax
  80129b:	75 07                	jne    8012a4 <strsplit+0x6c>
		{
			return 0;
  80129d:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a2:	eb 66                	jmp    80130a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a7:	8b 00                	mov    (%eax),%eax
  8012a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ac:	8b 55 14             	mov    0x14(%ebp),%edx
  8012af:	89 0a                	mov    %ecx,(%edx)
  8012b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c2:	eb 03                	jmp    8012c7 <strsplit+0x8f>
			string++;
  8012c4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	84 c0                	test   %al,%al
  8012ce:	74 8b                	je     80125b <strsplit+0x23>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	0f be c0             	movsbl %al,%eax
  8012d8:	50                   	push   %eax
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	e8 b5 fa ff ff       	call   800d96 <strchr>
  8012e1:	83 c4 08             	add    $0x8,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	74 dc                	je     8012c4 <strsplit+0x8c>
			string++;
	}
  8012e8:	e9 6e ff ff ff       	jmp    80125b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012ed:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	8b 00                	mov    (%eax),%eax
  8012f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fd:	01 d0                	add    %edx,%eax
  8012ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801305:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801312:	a1 04 50 80 00       	mov    0x805004,%eax
  801317:	85 c0                	test   %eax,%eax
  801319:	74 1f                	je     80133a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131b:	e8 1d 00 00 00       	call   80133d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	68 30 3e 80 00       	push   $0x803e30
  801328:	e8 55 f2 ff ff       	call   800582 <cprintf>
  80132d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801330:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801337:	00 00 00 
	}
}
  80133a:	90                   	nop
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801343:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80134a:	00 00 00 
  80134d:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801354:	00 00 00 
  801357:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80135e:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801361:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801368:	00 00 00 
  80136b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801372:	00 00 00 
  801375:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80137c:	00 00 00 
	uint32 arr_size = 0;
  80137f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801386:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80138d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801390:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801395:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139a:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80139f:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8013a6:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8013a9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8013b0:	a1 20 51 80 00       	mov    0x805120,%eax
  8013b5:	c1 e0 04             	shl    $0x4,%eax
  8013b8:	89 c2                	mov    %eax,%edx
  8013ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013bd:	01 d0                	add    %edx,%eax
  8013bf:	48                   	dec    %eax
  8013c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8013c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013cb:	f7 75 ec             	divl   -0x14(%ebp)
  8013ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013d1:	29 d0                	sub    %edx,%eax
  8013d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8013d6:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ea:	83 ec 04             	sub    $0x4,%esp
  8013ed:	6a 06                	push   $0x6
  8013ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8013f2:	50                   	push   %eax
  8013f3:	e8 6a 04 00 00       	call   801862 <sys_allocate_chunk>
  8013f8:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013fb:	a1 20 51 80 00       	mov    0x805120,%eax
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	50                   	push   %eax
  801404:	e8 df 0a 00 00       	call   801ee8 <initialize_MemBlocksList>
  801409:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  80140c:	a1 48 51 80 00       	mov    0x805148,%eax
  801411:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801414:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801417:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  80141e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801421:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801428:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80142c:	75 14                	jne    801442 <initialize_dyn_block_system+0x105>
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	68 55 3e 80 00       	push   $0x803e55
  801436:	6a 33                	push   $0x33
  801438:	68 73 3e 80 00       	push   $0x803e73
  80143d:	e8 8c ee ff ff       	call   8002ce <_panic>
  801442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801445:	8b 00                	mov    (%eax),%eax
  801447:	85 c0                	test   %eax,%eax
  801449:	74 10                	je     80145b <initialize_dyn_block_system+0x11e>
  80144b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144e:	8b 00                	mov    (%eax),%eax
  801450:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801453:	8b 52 04             	mov    0x4(%edx),%edx
  801456:	89 50 04             	mov    %edx,0x4(%eax)
  801459:	eb 0b                	jmp    801466 <initialize_dyn_block_system+0x129>
  80145b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145e:	8b 40 04             	mov    0x4(%eax),%eax
  801461:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801466:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801469:	8b 40 04             	mov    0x4(%eax),%eax
  80146c:	85 c0                	test   %eax,%eax
  80146e:	74 0f                	je     80147f <initialize_dyn_block_system+0x142>
  801470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801473:	8b 40 04             	mov    0x4(%eax),%eax
  801476:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801479:	8b 12                	mov    (%edx),%edx
  80147b:	89 10                	mov    %edx,(%eax)
  80147d:	eb 0a                	jmp    801489 <initialize_dyn_block_system+0x14c>
  80147f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801482:	8b 00                	mov    (%eax),%eax
  801484:	a3 48 51 80 00       	mov    %eax,0x805148
  801489:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801495:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80149c:	a1 54 51 80 00       	mov    0x805154,%eax
  8014a1:	48                   	dec    %eax
  8014a2:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8014a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014ab:	75 14                	jne    8014c1 <initialize_dyn_block_system+0x184>
  8014ad:	83 ec 04             	sub    $0x4,%esp
  8014b0:	68 80 3e 80 00       	push   $0x803e80
  8014b5:	6a 34                	push   $0x34
  8014b7:	68 73 3e 80 00       	push   $0x803e73
  8014bc:	e8 0d ee ff ff       	call   8002ce <_panic>
  8014c1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8014c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ca:	89 10                	mov    %edx,(%eax)
  8014cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014cf:	8b 00                	mov    (%eax),%eax
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	74 0d                	je     8014e2 <initialize_dyn_block_system+0x1a5>
  8014d5:	a1 38 51 80 00       	mov    0x805138,%eax
  8014da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014dd:	89 50 04             	mov    %edx,0x4(%eax)
  8014e0:	eb 08                	jmp    8014ea <initialize_dyn_block_system+0x1ad>
  8014e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8014ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ed:	a3 38 51 80 00       	mov    %eax,0x805138
  8014f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014fc:	a1 44 51 80 00       	mov    0x805144,%eax
  801501:	40                   	inc    %eax
  801502:	a3 44 51 80 00       	mov    %eax,0x805144
}
  801507:	90                   	nop
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801510:	e8 f7 fd ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  801515:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801519:	75 07                	jne    801522 <malloc+0x18>
  80151b:	b8 00 00 00 00       	mov    $0x0,%eax
  801520:	eb 61                	jmp    801583 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801522:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801529:	8b 55 08             	mov    0x8(%ebp),%edx
  80152c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152f:	01 d0                	add    %edx,%eax
  801531:	48                   	dec    %eax
  801532:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801538:	ba 00 00 00 00       	mov    $0x0,%edx
  80153d:	f7 75 f0             	divl   -0x10(%ebp)
  801540:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801543:	29 d0                	sub    %edx,%eax
  801545:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801548:	e8 e3 06 00 00       	call   801c30 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80154d:	85 c0                	test   %eax,%eax
  80154f:	74 11                	je     801562 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801551:	83 ec 0c             	sub    $0xc,%esp
  801554:	ff 75 e8             	pushl  -0x18(%ebp)
  801557:	e8 4e 0d 00 00       	call   8022aa <alloc_block_FF>
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801562:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801566:	74 16                	je     80157e <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801568:	83 ec 0c             	sub    $0xc,%esp
  80156b:	ff 75 f4             	pushl  -0xc(%ebp)
  80156e:	e8 aa 0a 00 00       	call   80201d <insert_sorted_allocList>
  801573:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801579:	8b 40 08             	mov    0x8(%eax),%eax
  80157c:	eb 05                	jmp    801583 <malloc+0x79>
	}

    return NULL;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80158b:	83 ec 04             	sub    $0x4,%esp
  80158e:	68 a4 3e 80 00       	push   $0x803ea4
  801593:	6a 6f                	push   $0x6f
  801595:	68 73 3e 80 00       	push   $0x803e73
  80159a:	e8 2f ed ff ff       	call   8002ce <_panic>

0080159f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 38             	sub    $0x38,%esp
  8015a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a8:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ab:	e8 5c fd ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  8015b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b4:	75 07                	jne    8015bd <smalloc+0x1e>
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bb:	eb 7c                	jmp    801639 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015bd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ca:	01 d0                	add    %edx,%eax
  8015cc:	48                   	dec    %eax
  8015cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d8:	f7 75 f0             	divl   -0x10(%ebp)
  8015db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015de:	29 d0                	sub    %edx,%eax
  8015e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015e3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015ea:	e8 41 06 00 00       	call   801c30 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	74 11                	je     801604 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8015f3:	83 ec 0c             	sub    $0xc,%esp
  8015f6:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f9:	e8 ac 0c 00 00       	call   8022aa <alloc_block_FF>
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801608:	74 2a                	je     801634 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80160a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160d:	8b 40 08             	mov    0x8(%eax),%eax
  801610:	89 c2                	mov    %eax,%edx
  801612:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801616:	52                   	push   %edx
  801617:	50                   	push   %eax
  801618:	ff 75 0c             	pushl  0xc(%ebp)
  80161b:	ff 75 08             	pushl  0x8(%ebp)
  80161e:	e8 92 03 00 00       	call   8019b5 <sys_createSharedObject>
  801623:	83 c4 10             	add    $0x10,%esp
  801626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801629:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80162d:	74 05                	je     801634 <smalloc+0x95>
			return (void*)virtual_address;
  80162f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801632:	eb 05                	jmp    801639 <smalloc+0x9a>
	}
	return NULL;
  801634:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801641:	e8 c6 fc ff ff       	call   80130c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	68 c8 3e 80 00       	push   $0x803ec8
  80164e:	68 b0 00 00 00       	push   $0xb0
  801653:	68 73 3e 80 00       	push   $0x803e73
  801658:	e8 71 ec ff ff       	call   8002ce <_panic>

0080165d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801663:	e8 a4 fc ff ff       	call   80130c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801668:	83 ec 04             	sub    $0x4,%esp
  80166b:	68 ec 3e 80 00       	push   $0x803eec
  801670:	68 f4 00 00 00       	push   $0xf4
  801675:	68 73 3e 80 00       	push   $0x803e73
  80167a:	e8 4f ec ff ff       	call   8002ce <_panic>

0080167f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801685:	83 ec 04             	sub    $0x4,%esp
  801688:	68 14 3f 80 00       	push   $0x803f14
  80168d:	68 08 01 00 00       	push   $0x108
  801692:	68 73 3e 80 00       	push   $0x803e73
  801697:	e8 32 ec ff ff       	call   8002ce <_panic>

0080169c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016a2:	83 ec 04             	sub    $0x4,%esp
  8016a5:	68 38 3f 80 00       	push   $0x803f38
  8016aa:	68 13 01 00 00       	push   $0x113
  8016af:	68 73 3e 80 00       	push   $0x803e73
  8016b4:	e8 15 ec ff ff       	call   8002ce <_panic>

008016b9 <shrink>:

}
void shrink(uint32 newSize)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016bf:	83 ec 04             	sub    $0x4,%esp
  8016c2:	68 38 3f 80 00       	push   $0x803f38
  8016c7:	68 18 01 00 00       	push   $0x118
  8016cc:	68 73 3e 80 00       	push   $0x803e73
  8016d1:	e8 f8 eb ff ff       	call   8002ce <_panic>

008016d6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	68 38 3f 80 00       	push   $0x803f38
  8016e4:	68 1d 01 00 00       	push   $0x11d
  8016e9:	68 73 3e 80 00       	push   $0x803e73
  8016ee:	e8 db eb ff ff       	call   8002ce <_panic>

008016f3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	57                   	push   %edi
  8016f7:	56                   	push   %esi
  8016f8:	53                   	push   %ebx
  8016f9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801702:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801705:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801708:	8b 7d 18             	mov    0x18(%ebp),%edi
  80170b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80170e:	cd 30                	int    $0x30
  801710:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801713:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	5b                   	pop    %ebx
  80171a:	5e                   	pop    %esi
  80171b:	5f                   	pop    %edi
  80171c:	5d                   	pop    %ebp
  80171d:	c3                   	ret    

0080171e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 04             	sub    $0x4,%esp
  801724:	8b 45 10             	mov    0x10(%ebp),%eax
  801727:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80172a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80172e:	8b 45 08             	mov    0x8(%ebp),%eax
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	52                   	push   %edx
  801736:	ff 75 0c             	pushl  0xc(%ebp)
  801739:	50                   	push   %eax
  80173a:	6a 00                	push   $0x0
  80173c:	e8 b2 ff ff ff       	call   8016f3 <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	90                   	nop
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_cgetc>:

int
sys_cgetc(void)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 01                	push   $0x1
  801756:	e8 98 ff ff ff       	call   8016f3 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801763:	8b 55 0c             	mov    0xc(%ebp),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	52                   	push   %edx
  801770:	50                   	push   %eax
  801771:	6a 05                	push   $0x5
  801773:	e8 7b ff ff ff       	call   8016f3 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	56                   	push   %esi
  801781:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801782:	8b 75 18             	mov    0x18(%ebp),%esi
  801785:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801788:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80178b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	56                   	push   %esi
  801792:	53                   	push   %ebx
  801793:	51                   	push   %ecx
  801794:	52                   	push   %edx
  801795:	50                   	push   %eax
  801796:	6a 06                	push   $0x6
  801798:	e8 56 ff ff ff       	call   8016f3 <syscall>
  80179d:	83 c4 18             	add    $0x18,%esp
}
  8017a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a3:	5b                   	pop    %ebx
  8017a4:	5e                   	pop    %esi
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    

008017a7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	52                   	push   %edx
  8017b7:	50                   	push   %eax
  8017b8:	6a 07                	push   $0x7
  8017ba:	e8 34 ff ff ff       	call   8016f3 <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	6a 08                	push   $0x8
  8017d5:	e8 19 ff ff ff       	call   8016f3 <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 09                	push   $0x9
  8017ee:	e8 00 ff ff ff       	call   8016f3 <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 0a                	push   $0xa
  801807:	e8 e7 fe ff ff       	call   8016f3 <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 0b                	push   $0xb
  801820:	e8 ce fe ff ff       	call   8016f3 <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	ff 75 0c             	pushl  0xc(%ebp)
  801836:	ff 75 08             	pushl  0x8(%ebp)
  801839:	6a 0f                	push   $0xf
  80183b:	e8 b3 fe ff ff       	call   8016f3 <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
	return;
  801843:	90                   	nop
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	ff 75 08             	pushl  0x8(%ebp)
  801855:	6a 10                	push   $0x10
  801857:	e8 97 fe ff ff       	call   8016f3 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
	return ;
  80185f:	90                   	nop
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	ff 75 10             	pushl  0x10(%ebp)
  80186c:	ff 75 0c             	pushl  0xc(%ebp)
  80186f:	ff 75 08             	pushl  0x8(%ebp)
  801872:	6a 11                	push   $0x11
  801874:	e8 7a fe ff ff       	call   8016f3 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
	return ;
  80187c:	90                   	nop
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 0c                	push   $0xc
  80188e:	e8 60 fe ff ff       	call   8016f3 <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	ff 75 08             	pushl  0x8(%ebp)
  8018a6:	6a 0d                	push   $0xd
  8018a8:	e8 46 fe ff ff       	call   8016f3 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 0e                	push   $0xe
  8018c1:	e8 2d fe ff ff       	call   8016f3 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	90                   	nop
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 13                	push   $0x13
  8018db:	e8 13 fe ff ff       	call   8016f3 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	90                   	nop
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 14                	push   $0x14
  8018f5:	e8 f9 fd ff ff       	call   8016f3 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	90                   	nop
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_cputc>:


void
sys_cputc(const char c)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 04             	sub    $0x4,%esp
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80190c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	50                   	push   %eax
  801919:	6a 15                	push   $0x15
  80191b:	e8 d3 fd ff ff       	call   8016f3 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	90                   	nop
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 16                	push   $0x16
  801935:	e8 b9 fd ff ff       	call   8016f3 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	90                   	nop
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	50                   	push   %eax
  801950:	6a 17                	push   $0x17
  801952:	e8 9c fd ff ff       	call   8016f3 <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80195f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	52                   	push   %edx
  80196c:	50                   	push   %eax
  80196d:	6a 1a                	push   $0x1a
  80196f:	e8 7f fd ff ff       	call   8016f3 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80197c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	52                   	push   %edx
  801989:	50                   	push   %eax
  80198a:	6a 18                	push   $0x18
  80198c:	e8 62 fd ff ff       	call   8016f3 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	90                   	nop
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80199a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	52                   	push   %edx
  8019a7:	50                   	push   %eax
  8019a8:	6a 19                	push   $0x19
  8019aa:	e8 44 fd ff ff       	call   8016f3 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	90                   	nop
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 04             	sub    $0x4,%esp
  8019bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019be:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019c1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	6a 00                	push   $0x0
  8019cd:	51                   	push   %ecx
  8019ce:	52                   	push   %edx
  8019cf:	ff 75 0c             	pushl  0xc(%ebp)
  8019d2:	50                   	push   %eax
  8019d3:	6a 1b                	push   $0x1b
  8019d5:	e8 19 fd ff ff       	call   8016f3 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	52                   	push   %edx
  8019ef:	50                   	push   %eax
  8019f0:	6a 1c                	push   $0x1c
  8019f2:	e8 fc fc ff ff       	call   8016f3 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	51                   	push   %ecx
  801a0d:	52                   	push   %edx
  801a0e:	50                   	push   %eax
  801a0f:	6a 1d                	push   $0x1d
  801a11:	e8 dd fc ff ff       	call   8016f3 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	52                   	push   %edx
  801a2b:	50                   	push   %eax
  801a2c:	6a 1e                	push   $0x1e
  801a2e:	e8 c0 fc ff ff       	call   8016f3 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 1f                	push   $0x1f
  801a47:	e8 a7 fc ff ff       	call   8016f3 <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	6a 00                	push   $0x0
  801a59:	ff 75 14             	pushl  0x14(%ebp)
  801a5c:	ff 75 10             	pushl  0x10(%ebp)
  801a5f:	ff 75 0c             	pushl  0xc(%ebp)
  801a62:	50                   	push   %eax
  801a63:	6a 20                	push   $0x20
  801a65:	e8 89 fc ff ff       	call   8016f3 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	50                   	push   %eax
  801a7e:	6a 21                	push   $0x21
  801a80:	e8 6e fc ff ff       	call   8016f3 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	90                   	nop
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	50                   	push   %eax
  801a9a:	6a 22                	push   $0x22
  801a9c:	e8 52 fc ff ff       	call   8016f3 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 02                	push   $0x2
  801ab5:	e8 39 fc ff ff       	call   8016f3 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 03                	push   $0x3
  801ace:	e8 20 fc ff ff       	call   8016f3 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 04                	push   $0x4
  801ae7:	e8 07 fc ff ff       	call   8016f3 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_exit_env>:


void sys_exit_env(void)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 23                	push   $0x23
  801b00:	e8 ee fb ff ff       	call   8016f3 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	90                   	nop
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b11:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b14:	8d 50 04             	lea    0x4(%eax),%edx
  801b17:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	52                   	push   %edx
  801b21:	50                   	push   %eax
  801b22:	6a 24                	push   $0x24
  801b24:	e8 ca fb ff ff       	call   8016f3 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
	return result;
  801b2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b35:	89 01                	mov    %eax,(%ecx)
  801b37:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	c9                   	leave  
  801b3e:	c2 04 00             	ret    $0x4

00801b41 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	ff 75 10             	pushl  0x10(%ebp)
  801b4b:	ff 75 0c             	pushl  0xc(%ebp)
  801b4e:	ff 75 08             	pushl  0x8(%ebp)
  801b51:	6a 12                	push   $0x12
  801b53:	e8 9b fb ff ff       	call   8016f3 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5b:	90                   	nop
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_rcr2>:
uint32 sys_rcr2()
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 25                	push   $0x25
  801b6d:	e8 81 fb ff ff       	call   8016f3 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 04             	sub    $0x4,%esp
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b83:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	50                   	push   %eax
  801b90:	6a 26                	push   $0x26
  801b92:	e8 5c fb ff ff       	call   8016f3 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9a:	90                   	nop
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <rsttst>:
void rsttst()
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 28                	push   $0x28
  801bac:	e8 42 fb ff ff       	call   8016f3 <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb4:	90                   	nop
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bc3:	8b 55 18             	mov    0x18(%ebp),%edx
  801bc6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bca:	52                   	push   %edx
  801bcb:	50                   	push   %eax
  801bcc:	ff 75 10             	pushl  0x10(%ebp)
  801bcf:	ff 75 0c             	pushl  0xc(%ebp)
  801bd2:	ff 75 08             	pushl  0x8(%ebp)
  801bd5:	6a 27                	push   $0x27
  801bd7:	e8 17 fb ff ff       	call   8016f3 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdf:	90                   	nop
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <chktst>:
void chktst(uint32 n)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	ff 75 08             	pushl  0x8(%ebp)
  801bf0:	6a 29                	push   $0x29
  801bf2:	e8 fc fa ff ff       	call   8016f3 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfa:	90                   	nop
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <inctst>:

void inctst()
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 2a                	push   $0x2a
  801c0c:	e8 e2 fa ff ff       	call   8016f3 <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
	return ;
  801c14:	90                   	nop
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <gettst>:
uint32 gettst()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 2b                	push   $0x2b
  801c26:	e8 c8 fa ff ff       	call   8016f3 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 2c                	push   $0x2c
  801c42:	e8 ac fa ff ff       	call   8016f3 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
  801c4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c4d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c51:	75 07                	jne    801c5a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c53:	b8 01 00 00 00       	mov    $0x1,%eax
  801c58:	eb 05                	jmp    801c5f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 2c                	push   $0x2c
  801c73:	e8 7b fa ff ff       	call   8016f3 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
  801c7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c7e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c82:	75 07                	jne    801c8b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c84:	b8 01 00 00 00       	mov    $0x1,%eax
  801c89:	eb 05                	jmp    801c90 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 2c                	push   $0x2c
  801ca4:	e8 4a fa ff ff       	call   8016f3 <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
  801cac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801caf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cb3:	75 07                	jne    801cbc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cba:	eb 05                	jmp    801cc1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 2c                	push   $0x2c
  801cd5:	e8 19 fa ff ff       	call   8016f3 <syscall>
  801cda:	83 c4 18             	add    $0x18,%esp
  801cdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ce0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ce4:	75 07                	jne    801ced <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ce6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ceb:	eb 05                	jmp    801cf2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ced:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	ff 75 08             	pushl  0x8(%ebp)
  801d02:	6a 2d                	push   $0x2d
  801d04:	e8 ea f9 ff ff       	call   8016f3 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0c:	90                   	nop
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d13:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d16:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	6a 00                	push   $0x0
  801d21:	53                   	push   %ebx
  801d22:	51                   	push   %ecx
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 2e                	push   $0x2e
  801d27:	e8 c7 f9 ff ff       	call   8016f3 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	52                   	push   %edx
  801d44:	50                   	push   %eax
  801d45:	6a 2f                	push   $0x2f
  801d47:	e8 a7 f9 ff ff       	call   8016f3 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d57:	83 ec 0c             	sub    $0xc,%esp
  801d5a:	68 48 3f 80 00       	push   $0x803f48
  801d5f:	e8 1e e8 ff ff       	call   800582 <cprintf>
  801d64:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d6e:	83 ec 0c             	sub    $0xc,%esp
  801d71:	68 74 3f 80 00       	push   $0x803f74
  801d76:	e8 07 e8 ff ff       	call   800582 <cprintf>
  801d7b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d7e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d82:	a1 38 51 80 00       	mov    0x805138,%eax
  801d87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d8a:	eb 56                	jmp    801de2 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d90:	74 1c                	je     801dae <print_mem_block_lists+0x5d>
  801d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d95:	8b 50 08             	mov    0x8(%eax),%edx
  801d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9b:	8b 48 08             	mov    0x8(%eax),%ecx
  801d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da1:	8b 40 0c             	mov    0xc(%eax),%eax
  801da4:	01 c8                	add    %ecx,%eax
  801da6:	39 c2                	cmp    %eax,%edx
  801da8:	73 04                	jae    801dae <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801daa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db1:	8b 50 08             	mov    0x8(%eax),%edx
  801db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db7:	8b 40 0c             	mov    0xc(%eax),%eax
  801dba:	01 c2                	add    %eax,%edx
  801dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbf:	8b 40 08             	mov    0x8(%eax),%eax
  801dc2:	83 ec 04             	sub    $0x4,%esp
  801dc5:	52                   	push   %edx
  801dc6:	50                   	push   %eax
  801dc7:	68 89 3f 80 00       	push   $0x803f89
  801dcc:	e8 b1 e7 ff ff       	call   800582 <cprintf>
  801dd1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dda:	a1 40 51 80 00       	mov    0x805140,%eax
  801ddf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de6:	74 07                	je     801def <print_mem_block_lists+0x9e>
  801de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801deb:	8b 00                	mov    (%eax),%eax
  801ded:	eb 05                	jmp    801df4 <print_mem_block_lists+0xa3>
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
  801df4:	a3 40 51 80 00       	mov    %eax,0x805140
  801df9:	a1 40 51 80 00       	mov    0x805140,%eax
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	75 8a                	jne    801d8c <print_mem_block_lists+0x3b>
  801e02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e06:	75 84                	jne    801d8c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e08:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e0c:	75 10                	jne    801e1e <print_mem_block_lists+0xcd>
  801e0e:	83 ec 0c             	sub    $0xc,%esp
  801e11:	68 98 3f 80 00       	push   $0x803f98
  801e16:	e8 67 e7 ff ff       	call   800582 <cprintf>
  801e1b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e1e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e25:	83 ec 0c             	sub    $0xc,%esp
  801e28:	68 bc 3f 80 00       	push   $0x803fbc
  801e2d:	e8 50 e7 ff ff       	call   800582 <cprintf>
  801e32:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e35:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e39:	a1 40 50 80 00       	mov    0x805040,%eax
  801e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e41:	eb 56                	jmp    801e99 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e47:	74 1c                	je     801e65 <print_mem_block_lists+0x114>
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	8b 50 08             	mov    0x8(%eax),%edx
  801e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e52:	8b 48 08             	mov    0x8(%eax),%ecx
  801e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e58:	8b 40 0c             	mov    0xc(%eax),%eax
  801e5b:	01 c8                	add    %ecx,%eax
  801e5d:	39 c2                	cmp    %eax,%edx
  801e5f:	73 04                	jae    801e65 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e61:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e68:	8b 50 08             	mov    0x8(%eax),%edx
  801e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e71:	01 c2                	add    %eax,%edx
  801e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e76:	8b 40 08             	mov    0x8(%eax),%eax
  801e79:	83 ec 04             	sub    $0x4,%esp
  801e7c:	52                   	push   %edx
  801e7d:	50                   	push   %eax
  801e7e:	68 89 3f 80 00       	push   $0x803f89
  801e83:	e8 fa e6 ff ff       	call   800582 <cprintf>
  801e88:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e91:	a1 48 50 80 00       	mov    0x805048,%eax
  801e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e9d:	74 07                	je     801ea6 <print_mem_block_lists+0x155>
  801e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea2:	8b 00                	mov    (%eax),%eax
  801ea4:	eb 05                	jmp    801eab <print_mem_block_lists+0x15a>
  801ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  801eab:	a3 48 50 80 00       	mov    %eax,0x805048
  801eb0:	a1 48 50 80 00       	mov    0x805048,%eax
  801eb5:	85 c0                	test   %eax,%eax
  801eb7:	75 8a                	jne    801e43 <print_mem_block_lists+0xf2>
  801eb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ebd:	75 84                	jne    801e43 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ebf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ec3:	75 10                	jne    801ed5 <print_mem_block_lists+0x184>
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	68 d4 3f 80 00       	push   $0x803fd4
  801ecd:	e8 b0 e6 ff ff       	call   800582 <cprintf>
  801ed2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ed5:	83 ec 0c             	sub    $0xc,%esp
  801ed8:	68 48 3f 80 00       	push   $0x803f48
  801edd:	e8 a0 e6 ff ff       	call   800582 <cprintf>
  801ee2:	83 c4 10             	add    $0x10,%esp

}
  801ee5:	90                   	nop
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801eee:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ef5:	00 00 00 
  801ef8:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801eff:	00 00 00 
  801f02:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f09:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f13:	e9 9e 00 00 00       	jmp    801fb6 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f18:	a1 50 50 80 00       	mov    0x805050,%eax
  801f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f20:	c1 e2 04             	shl    $0x4,%edx
  801f23:	01 d0                	add    %edx,%eax
  801f25:	85 c0                	test   %eax,%eax
  801f27:	75 14                	jne    801f3d <initialize_MemBlocksList+0x55>
  801f29:	83 ec 04             	sub    $0x4,%esp
  801f2c:	68 fc 3f 80 00       	push   $0x803ffc
  801f31:	6a 46                	push   $0x46
  801f33:	68 1f 40 80 00       	push   $0x80401f
  801f38:	e8 91 e3 ff ff       	call   8002ce <_panic>
  801f3d:	a1 50 50 80 00       	mov    0x805050,%eax
  801f42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f45:	c1 e2 04             	shl    $0x4,%edx
  801f48:	01 d0                	add    %edx,%eax
  801f4a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f50:	89 10                	mov    %edx,(%eax)
  801f52:	8b 00                	mov    (%eax),%eax
  801f54:	85 c0                	test   %eax,%eax
  801f56:	74 18                	je     801f70 <initialize_MemBlocksList+0x88>
  801f58:	a1 48 51 80 00       	mov    0x805148,%eax
  801f5d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f63:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f66:	c1 e1 04             	shl    $0x4,%ecx
  801f69:	01 ca                	add    %ecx,%edx
  801f6b:	89 50 04             	mov    %edx,0x4(%eax)
  801f6e:	eb 12                	jmp    801f82 <initialize_MemBlocksList+0x9a>
  801f70:	a1 50 50 80 00       	mov    0x805050,%eax
  801f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f78:	c1 e2 04             	shl    $0x4,%edx
  801f7b:	01 d0                	add    %edx,%eax
  801f7d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f82:	a1 50 50 80 00       	mov    0x805050,%eax
  801f87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8a:	c1 e2 04             	shl    $0x4,%edx
  801f8d:	01 d0                	add    %edx,%eax
  801f8f:	a3 48 51 80 00       	mov    %eax,0x805148
  801f94:	a1 50 50 80 00       	mov    0x805050,%eax
  801f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9c:	c1 e2 04             	shl    $0x4,%edx
  801f9f:	01 d0                	add    %edx,%eax
  801fa1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fa8:	a1 54 51 80 00       	mov    0x805154,%eax
  801fad:	40                   	inc    %eax
  801fae:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fb3:	ff 45 f4             	incl   -0xc(%ebp)
  801fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb9:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fbc:	0f 82 56 ff ff ff    	jb     801f18 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fc2:	90                   	nop
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	8b 00                	mov    (%eax),%eax
  801fd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fd3:	eb 19                	jmp    801fee <find_block+0x29>
	{
		if(va==point->sva)
  801fd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd8:	8b 40 08             	mov    0x8(%eax),%eax
  801fdb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fde:	75 05                	jne    801fe5 <find_block+0x20>
		   return point;
  801fe0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe3:	eb 36                	jmp    80201b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	8b 40 08             	mov    0x8(%eax),%eax
  801feb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fee:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ff2:	74 07                	je     801ffb <find_block+0x36>
  801ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff7:	8b 00                	mov    (%eax),%eax
  801ff9:	eb 05                	jmp    802000 <find_block+0x3b>
  801ffb:	b8 00 00 00 00       	mov    $0x0,%eax
  802000:	8b 55 08             	mov    0x8(%ebp),%edx
  802003:	89 42 08             	mov    %eax,0x8(%edx)
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	8b 40 08             	mov    0x8(%eax),%eax
  80200c:	85 c0                	test   %eax,%eax
  80200e:	75 c5                	jne    801fd5 <find_block+0x10>
  802010:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802014:	75 bf                	jne    801fd5 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802023:	a1 40 50 80 00       	mov    0x805040,%eax
  802028:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80202b:	a1 44 50 80 00       	mov    0x805044,%eax
  802030:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802036:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802039:	74 24                	je     80205f <insert_sorted_allocList+0x42>
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	8b 50 08             	mov    0x8(%eax),%edx
  802041:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802044:	8b 40 08             	mov    0x8(%eax),%eax
  802047:	39 c2                	cmp    %eax,%edx
  802049:	76 14                	jbe    80205f <insert_sorted_allocList+0x42>
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	8b 50 08             	mov    0x8(%eax),%edx
  802051:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802054:	8b 40 08             	mov    0x8(%eax),%eax
  802057:	39 c2                	cmp    %eax,%edx
  802059:	0f 82 60 01 00 00    	jb     8021bf <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80205f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802063:	75 65                	jne    8020ca <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802065:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802069:	75 14                	jne    80207f <insert_sorted_allocList+0x62>
  80206b:	83 ec 04             	sub    $0x4,%esp
  80206e:	68 fc 3f 80 00       	push   $0x803ffc
  802073:	6a 6b                	push   $0x6b
  802075:	68 1f 40 80 00       	push   $0x80401f
  80207a:	e8 4f e2 ff ff       	call   8002ce <_panic>
  80207f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	89 10                	mov    %edx,(%eax)
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	8b 00                	mov    (%eax),%eax
  80208f:	85 c0                	test   %eax,%eax
  802091:	74 0d                	je     8020a0 <insert_sorted_allocList+0x83>
  802093:	a1 40 50 80 00       	mov    0x805040,%eax
  802098:	8b 55 08             	mov    0x8(%ebp),%edx
  80209b:	89 50 04             	mov    %edx,0x4(%eax)
  80209e:	eb 08                	jmp    8020a8 <insert_sorted_allocList+0x8b>
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	a3 44 50 80 00       	mov    %eax,0x805044
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	a3 40 50 80 00       	mov    %eax,0x805040
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ba:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020bf:	40                   	inc    %eax
  8020c0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020c5:	e9 dc 01 00 00       	jmp    8022a6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	8b 50 08             	mov    0x8(%eax),%edx
  8020d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d3:	8b 40 08             	mov    0x8(%eax),%eax
  8020d6:	39 c2                	cmp    %eax,%edx
  8020d8:	77 6c                	ja     802146 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020de:	74 06                	je     8020e6 <insert_sorted_allocList+0xc9>
  8020e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020e4:	75 14                	jne    8020fa <insert_sorted_allocList+0xdd>
  8020e6:	83 ec 04             	sub    $0x4,%esp
  8020e9:	68 38 40 80 00       	push   $0x804038
  8020ee:	6a 6f                	push   $0x6f
  8020f0:	68 1f 40 80 00       	push   $0x80401f
  8020f5:	e8 d4 e1 ff ff       	call   8002ce <_panic>
  8020fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fd:	8b 50 04             	mov    0x4(%eax),%edx
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	89 50 04             	mov    %edx,0x4(%eax)
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80210c:	89 10                	mov    %edx,(%eax)
  80210e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802111:	8b 40 04             	mov    0x4(%eax),%eax
  802114:	85 c0                	test   %eax,%eax
  802116:	74 0d                	je     802125 <insert_sorted_allocList+0x108>
  802118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211b:	8b 40 04             	mov    0x4(%eax),%eax
  80211e:	8b 55 08             	mov    0x8(%ebp),%edx
  802121:	89 10                	mov    %edx,(%eax)
  802123:	eb 08                	jmp    80212d <insert_sorted_allocList+0x110>
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	a3 40 50 80 00       	mov    %eax,0x805040
  80212d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802130:	8b 55 08             	mov    0x8(%ebp),%edx
  802133:	89 50 04             	mov    %edx,0x4(%eax)
  802136:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80213b:	40                   	inc    %eax
  80213c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802141:	e9 60 01 00 00       	jmp    8022a6 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	8b 50 08             	mov    0x8(%eax),%edx
  80214c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80214f:	8b 40 08             	mov    0x8(%eax),%eax
  802152:	39 c2                	cmp    %eax,%edx
  802154:	0f 82 4c 01 00 00    	jb     8022a6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80215a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80215e:	75 14                	jne    802174 <insert_sorted_allocList+0x157>
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	68 70 40 80 00       	push   $0x804070
  802168:	6a 73                	push   $0x73
  80216a:	68 1f 40 80 00       	push   $0x80401f
  80216f:	e8 5a e1 ff ff       	call   8002ce <_panic>
  802174:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	89 50 04             	mov    %edx,0x4(%eax)
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	8b 40 04             	mov    0x4(%eax),%eax
  802186:	85 c0                	test   %eax,%eax
  802188:	74 0c                	je     802196 <insert_sorted_allocList+0x179>
  80218a:	a1 44 50 80 00       	mov    0x805044,%eax
  80218f:	8b 55 08             	mov    0x8(%ebp),%edx
  802192:	89 10                	mov    %edx,(%eax)
  802194:	eb 08                	jmp    80219e <insert_sorted_allocList+0x181>
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	a3 40 50 80 00       	mov    %eax,0x805040
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	a3 44 50 80 00       	mov    %eax,0x805044
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021af:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021b4:	40                   	inc    %eax
  8021b5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021ba:	e9 e7 00 00 00       	jmp    8022a6 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021cc:	a1 40 50 80 00       	mov    0x805040,%eax
  8021d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d4:	e9 9d 00 00 00       	jmp    802276 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	8b 00                	mov    (%eax),%eax
  8021de:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	8b 50 08             	mov    0x8(%eax),%edx
  8021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ea:	8b 40 08             	mov    0x8(%eax),%eax
  8021ed:	39 c2                	cmp    %eax,%edx
  8021ef:	76 7d                	jbe    80226e <insert_sorted_allocList+0x251>
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	8b 50 08             	mov    0x8(%eax),%edx
  8021f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021fa:	8b 40 08             	mov    0x8(%eax),%eax
  8021fd:	39 c2                	cmp    %eax,%edx
  8021ff:	73 6d                	jae    80226e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802201:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802205:	74 06                	je     80220d <insert_sorted_allocList+0x1f0>
  802207:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80220b:	75 14                	jne    802221 <insert_sorted_allocList+0x204>
  80220d:	83 ec 04             	sub    $0x4,%esp
  802210:	68 94 40 80 00       	push   $0x804094
  802215:	6a 7f                	push   $0x7f
  802217:	68 1f 40 80 00       	push   $0x80401f
  80221c:	e8 ad e0 ff ff       	call   8002ce <_panic>
  802221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802224:	8b 10                	mov    (%eax),%edx
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	89 10                	mov    %edx,(%eax)
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	8b 00                	mov    (%eax),%eax
  802230:	85 c0                	test   %eax,%eax
  802232:	74 0b                	je     80223f <insert_sorted_allocList+0x222>
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	8b 00                	mov    (%eax),%eax
  802239:	8b 55 08             	mov    0x8(%ebp),%edx
  80223c:	89 50 04             	mov    %edx,0x4(%eax)
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	8b 55 08             	mov    0x8(%ebp),%edx
  802245:	89 10                	mov    %edx,(%eax)
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224d:	89 50 04             	mov    %edx,0x4(%eax)
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	8b 00                	mov    (%eax),%eax
  802255:	85 c0                	test   %eax,%eax
  802257:	75 08                	jne    802261 <insert_sorted_allocList+0x244>
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	a3 44 50 80 00       	mov    %eax,0x805044
  802261:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802266:	40                   	inc    %eax
  802267:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80226c:	eb 39                	jmp    8022a7 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80226e:	a1 48 50 80 00       	mov    0x805048,%eax
  802273:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227a:	74 07                	je     802283 <insert_sorted_allocList+0x266>
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	8b 00                	mov    (%eax),%eax
  802281:	eb 05                	jmp    802288 <insert_sorted_allocList+0x26b>
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
  802288:	a3 48 50 80 00       	mov    %eax,0x805048
  80228d:	a1 48 50 80 00       	mov    0x805048,%eax
  802292:	85 c0                	test   %eax,%eax
  802294:	0f 85 3f ff ff ff    	jne    8021d9 <insert_sorted_allocList+0x1bc>
  80229a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80229e:	0f 85 35 ff ff ff    	jne    8021d9 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022a4:	eb 01                	jmp    8022a7 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022a6:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022a7:	90                   	nop
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
  8022ad:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022b0:	a1 38 51 80 00       	mov    0x805138,%eax
  8022b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b8:	e9 85 01 00 00       	jmp    802442 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c6:	0f 82 6e 01 00 00    	jb     80243a <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d5:	0f 85 8a 00 00 00    	jne    802365 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022df:	75 17                	jne    8022f8 <alloc_block_FF+0x4e>
  8022e1:	83 ec 04             	sub    $0x4,%esp
  8022e4:	68 c8 40 80 00       	push   $0x8040c8
  8022e9:	68 93 00 00 00       	push   $0x93
  8022ee:	68 1f 40 80 00       	push   $0x80401f
  8022f3:	e8 d6 df ff ff       	call   8002ce <_panic>
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	8b 00                	mov    (%eax),%eax
  8022fd:	85 c0                	test   %eax,%eax
  8022ff:	74 10                	je     802311 <alloc_block_FF+0x67>
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 00                	mov    (%eax),%eax
  802306:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802309:	8b 52 04             	mov    0x4(%edx),%edx
  80230c:	89 50 04             	mov    %edx,0x4(%eax)
  80230f:	eb 0b                	jmp    80231c <alloc_block_FF+0x72>
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	8b 40 04             	mov    0x4(%eax),%eax
  802317:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 40 04             	mov    0x4(%eax),%eax
  802322:	85 c0                	test   %eax,%eax
  802324:	74 0f                	je     802335 <alloc_block_FF+0x8b>
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	8b 40 04             	mov    0x4(%eax),%eax
  80232c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232f:	8b 12                	mov    (%edx),%edx
  802331:	89 10                	mov    %edx,(%eax)
  802333:	eb 0a                	jmp    80233f <alloc_block_FF+0x95>
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	8b 00                	mov    (%eax),%eax
  80233a:	a3 38 51 80 00       	mov    %eax,0x805138
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802352:	a1 44 51 80 00       	mov    0x805144,%eax
  802357:	48                   	dec    %eax
  802358:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	e9 10 01 00 00       	jmp    802475 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 40 0c             	mov    0xc(%eax),%eax
  80236b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80236e:	0f 86 c6 00 00 00    	jbe    80243a <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802374:	a1 48 51 80 00       	mov    0x805148,%eax
  802379:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	8b 50 08             	mov    0x8(%eax),%edx
  802382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802385:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238b:	8b 55 08             	mov    0x8(%ebp),%edx
  80238e:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802391:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802395:	75 17                	jne    8023ae <alloc_block_FF+0x104>
  802397:	83 ec 04             	sub    $0x4,%esp
  80239a:	68 c8 40 80 00       	push   $0x8040c8
  80239f:	68 9b 00 00 00       	push   $0x9b
  8023a4:	68 1f 40 80 00       	push   $0x80401f
  8023a9:	e8 20 df ff ff       	call   8002ce <_panic>
  8023ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b1:	8b 00                	mov    (%eax),%eax
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	74 10                	je     8023c7 <alloc_block_FF+0x11d>
  8023b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ba:	8b 00                	mov    (%eax),%eax
  8023bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023bf:	8b 52 04             	mov    0x4(%edx),%edx
  8023c2:	89 50 04             	mov    %edx,0x4(%eax)
  8023c5:	eb 0b                	jmp    8023d2 <alloc_block_FF+0x128>
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ca:	8b 40 04             	mov    0x4(%eax),%eax
  8023cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d5:	8b 40 04             	mov    0x4(%eax),%eax
  8023d8:	85 c0                	test   %eax,%eax
  8023da:	74 0f                	je     8023eb <alloc_block_FF+0x141>
  8023dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023df:	8b 40 04             	mov    0x4(%eax),%eax
  8023e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e5:	8b 12                	mov    (%edx),%edx
  8023e7:	89 10                	mov    %edx,(%eax)
  8023e9:	eb 0a                	jmp    8023f5 <alloc_block_FF+0x14b>
  8023eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8023f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802401:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802408:	a1 54 51 80 00       	mov    0x805154,%eax
  80240d:	48                   	dec    %eax
  80240e:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 50 08             	mov    0x8(%eax),%edx
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	01 c2                	add    %eax,%edx
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802427:	8b 40 0c             	mov    0xc(%eax),%eax
  80242a:	2b 45 08             	sub    0x8(%ebp),%eax
  80242d:	89 c2                	mov    %eax,%edx
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802438:	eb 3b                	jmp    802475 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80243a:	a1 40 51 80 00       	mov    0x805140,%eax
  80243f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802446:	74 07                	je     80244f <alloc_block_FF+0x1a5>
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	8b 00                	mov    (%eax),%eax
  80244d:	eb 05                	jmp    802454 <alloc_block_FF+0x1aa>
  80244f:	b8 00 00 00 00       	mov    $0x0,%eax
  802454:	a3 40 51 80 00       	mov    %eax,0x805140
  802459:	a1 40 51 80 00       	mov    0x805140,%eax
  80245e:	85 c0                	test   %eax,%eax
  802460:	0f 85 57 fe ff ff    	jne    8022bd <alloc_block_FF+0x13>
  802466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246a:	0f 85 4d fe ff ff    	jne    8022bd <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802470:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80247d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802484:	a1 38 51 80 00       	mov    0x805138,%eax
  802489:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248c:	e9 df 00 00 00       	jmp    802570 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 40 0c             	mov    0xc(%eax),%eax
  802497:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249a:	0f 82 c8 00 00 00    	jb     802568 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a9:	0f 85 8a 00 00 00    	jne    802539 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b3:	75 17                	jne    8024cc <alloc_block_BF+0x55>
  8024b5:	83 ec 04             	sub    $0x4,%esp
  8024b8:	68 c8 40 80 00       	push   $0x8040c8
  8024bd:	68 b7 00 00 00       	push   $0xb7
  8024c2:	68 1f 40 80 00       	push   $0x80401f
  8024c7:	e8 02 de ff ff       	call   8002ce <_panic>
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 10                	je     8024e5 <alloc_block_BF+0x6e>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024dd:	8b 52 04             	mov    0x4(%edx),%edx
  8024e0:	89 50 04             	mov    %edx,0x4(%eax)
  8024e3:	eb 0b                	jmp    8024f0 <alloc_block_BF+0x79>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 04             	mov    0x4(%eax),%eax
  8024eb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 40 04             	mov    0x4(%eax),%eax
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	74 0f                	je     802509 <alloc_block_BF+0x92>
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 40 04             	mov    0x4(%eax),%eax
  802500:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802503:	8b 12                	mov    (%edx),%edx
  802505:	89 10                	mov    %edx,(%eax)
  802507:	eb 0a                	jmp    802513 <alloc_block_BF+0x9c>
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 00                	mov    (%eax),%eax
  80250e:	a3 38 51 80 00       	mov    %eax,0x805138
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802526:	a1 44 51 80 00       	mov    0x805144,%eax
  80252b:	48                   	dec    %eax
  80252c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	e9 4d 01 00 00       	jmp    802686 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 40 0c             	mov    0xc(%eax),%eax
  80253f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802542:	76 24                	jbe    802568 <alloc_block_BF+0xf1>
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 40 0c             	mov    0xc(%eax),%eax
  80254a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80254d:	73 19                	jae    802568 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80254f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 40 0c             	mov    0xc(%eax),%eax
  80255c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 40 08             	mov    0x8(%eax),%eax
  802565:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802568:	a1 40 51 80 00       	mov    0x805140,%eax
  80256d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802574:	74 07                	je     80257d <alloc_block_BF+0x106>
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 00                	mov    (%eax),%eax
  80257b:	eb 05                	jmp    802582 <alloc_block_BF+0x10b>
  80257d:	b8 00 00 00 00       	mov    $0x0,%eax
  802582:	a3 40 51 80 00       	mov    %eax,0x805140
  802587:	a1 40 51 80 00       	mov    0x805140,%eax
  80258c:	85 c0                	test   %eax,%eax
  80258e:	0f 85 fd fe ff ff    	jne    802491 <alloc_block_BF+0x1a>
  802594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802598:	0f 85 f3 fe ff ff    	jne    802491 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80259e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025a2:	0f 84 d9 00 00 00    	je     802681 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025a8:	a1 48 51 80 00       	mov    0x805148,%eax
  8025ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025b6:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8025bf:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025c6:	75 17                	jne    8025df <alloc_block_BF+0x168>
  8025c8:	83 ec 04             	sub    $0x4,%esp
  8025cb:	68 c8 40 80 00       	push   $0x8040c8
  8025d0:	68 c7 00 00 00       	push   $0xc7
  8025d5:	68 1f 40 80 00       	push   $0x80401f
  8025da:	e8 ef dc ff ff       	call   8002ce <_panic>
  8025df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 10                	je     8025f8 <alloc_block_BF+0x181>
  8025e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025f0:	8b 52 04             	mov    0x4(%edx),%edx
  8025f3:	89 50 04             	mov    %edx,0x4(%eax)
  8025f6:	eb 0b                	jmp    802603 <alloc_block_BF+0x18c>
  8025f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fb:	8b 40 04             	mov    0x4(%eax),%eax
  8025fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802606:	8b 40 04             	mov    0x4(%eax),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	74 0f                	je     80261c <alloc_block_BF+0x1a5>
  80260d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802610:	8b 40 04             	mov    0x4(%eax),%eax
  802613:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802616:	8b 12                	mov    (%edx),%edx
  802618:	89 10                	mov    %edx,(%eax)
  80261a:	eb 0a                	jmp    802626 <alloc_block_BF+0x1af>
  80261c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261f:	8b 00                	mov    (%eax),%eax
  802621:	a3 48 51 80 00       	mov    %eax,0x805148
  802626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802639:	a1 54 51 80 00       	mov    0x805154,%eax
  80263e:	48                   	dec    %eax
  80263f:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802644:	83 ec 08             	sub    $0x8,%esp
  802647:	ff 75 ec             	pushl  -0x14(%ebp)
  80264a:	68 38 51 80 00       	push   $0x805138
  80264f:	e8 71 f9 ff ff       	call   801fc5 <find_block>
  802654:	83 c4 10             	add    $0x10,%esp
  802657:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80265a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265d:	8b 50 08             	mov    0x8(%eax),%edx
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	01 c2                	add    %eax,%edx
  802665:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802668:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80266b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266e:	8b 40 0c             	mov    0xc(%eax),%eax
  802671:	2b 45 08             	sub    0x8(%ebp),%eax
  802674:	89 c2                	mov    %eax,%edx
  802676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802679:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80267c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267f:	eb 05                	jmp    802686 <alloc_block_BF+0x20f>
	}
	return NULL;
  802681:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80268e:	a1 28 50 80 00       	mov    0x805028,%eax
  802693:	85 c0                	test   %eax,%eax
  802695:	0f 85 de 01 00 00    	jne    802879 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80269b:	a1 38 51 80 00       	mov    0x805138,%eax
  8026a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a3:	e9 9e 01 00 00       	jmp    802846 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b1:	0f 82 87 01 00 00    	jb     80283e <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c0:	0f 85 95 00 00 00    	jne    80275b <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ca:	75 17                	jne    8026e3 <alloc_block_NF+0x5b>
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	68 c8 40 80 00       	push   $0x8040c8
  8026d4:	68 e0 00 00 00       	push   $0xe0
  8026d9:	68 1f 40 80 00       	push   $0x80401f
  8026de:	e8 eb db ff ff       	call   8002ce <_panic>
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 00                	mov    (%eax),%eax
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	74 10                	je     8026fc <alloc_block_NF+0x74>
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f4:	8b 52 04             	mov    0x4(%edx),%edx
  8026f7:	89 50 04             	mov    %edx,0x4(%eax)
  8026fa:	eb 0b                	jmp    802707 <alloc_block_NF+0x7f>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 04             	mov    0x4(%eax),%eax
  802702:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 40 04             	mov    0x4(%eax),%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	74 0f                	je     802720 <alloc_block_NF+0x98>
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 40 04             	mov    0x4(%eax),%eax
  802717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271a:	8b 12                	mov    (%edx),%edx
  80271c:	89 10                	mov    %edx,(%eax)
  80271e:	eb 0a                	jmp    80272a <alloc_block_NF+0xa2>
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	a3 38 51 80 00       	mov    %eax,0x805138
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273d:	a1 44 51 80 00       	mov    0x805144,%eax
  802742:	48                   	dec    %eax
  802743:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 40 08             	mov    0x8(%eax),%eax
  80274e:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	e9 f8 04 00 00       	jmp    802c53 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 40 0c             	mov    0xc(%eax),%eax
  802761:	3b 45 08             	cmp    0x8(%ebp),%eax
  802764:	0f 86 d4 00 00 00    	jbe    80283e <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80276a:	a1 48 51 80 00       	mov    0x805148,%eax
  80276f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 50 08             	mov    0x8(%eax),%edx
  802778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277b:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80277e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802781:	8b 55 08             	mov    0x8(%ebp),%edx
  802784:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802787:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80278b:	75 17                	jne    8027a4 <alloc_block_NF+0x11c>
  80278d:	83 ec 04             	sub    $0x4,%esp
  802790:	68 c8 40 80 00       	push   $0x8040c8
  802795:	68 e9 00 00 00       	push   $0xe9
  80279a:	68 1f 40 80 00       	push   $0x80401f
  80279f:	e8 2a db ff ff       	call   8002ce <_panic>
  8027a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	74 10                	je     8027bd <alloc_block_NF+0x135>
  8027ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b0:	8b 00                	mov    (%eax),%eax
  8027b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027b5:	8b 52 04             	mov    0x4(%edx),%edx
  8027b8:	89 50 04             	mov    %edx,0x4(%eax)
  8027bb:	eb 0b                	jmp    8027c8 <alloc_block_NF+0x140>
  8027bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c0:	8b 40 04             	mov    0x4(%eax),%eax
  8027c3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ce:	85 c0                	test   %eax,%eax
  8027d0:	74 0f                	je     8027e1 <alloc_block_NF+0x159>
  8027d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d5:	8b 40 04             	mov    0x4(%eax),%eax
  8027d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027db:	8b 12                	mov    (%edx),%edx
  8027dd:	89 10                	mov    %edx,(%eax)
  8027df:	eb 0a                	jmp    8027eb <alloc_block_NF+0x163>
  8027e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e4:	8b 00                	mov    (%eax),%eax
  8027e6:	a3 48 51 80 00       	mov    %eax,0x805148
  8027eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027fe:	a1 54 51 80 00       	mov    0x805154,%eax
  802803:	48                   	dec    %eax
  802804:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280c:	8b 40 08             	mov    0x8(%eax),%eax
  80280f:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 50 08             	mov    0x8(%eax),%edx
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	01 c2                	add    %eax,%edx
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 40 0c             	mov    0xc(%eax),%eax
  80282b:	2b 45 08             	sub    0x8(%ebp),%eax
  80282e:	89 c2                	mov    %eax,%edx
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802839:	e9 15 04 00 00       	jmp    802c53 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80283e:	a1 40 51 80 00       	mov    0x805140,%eax
  802843:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802846:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284a:	74 07                	je     802853 <alloc_block_NF+0x1cb>
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	eb 05                	jmp    802858 <alloc_block_NF+0x1d0>
  802853:	b8 00 00 00 00       	mov    $0x0,%eax
  802858:	a3 40 51 80 00       	mov    %eax,0x805140
  80285d:	a1 40 51 80 00       	mov    0x805140,%eax
  802862:	85 c0                	test   %eax,%eax
  802864:	0f 85 3e fe ff ff    	jne    8026a8 <alloc_block_NF+0x20>
  80286a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286e:	0f 85 34 fe ff ff    	jne    8026a8 <alloc_block_NF+0x20>
  802874:	e9 d5 03 00 00       	jmp    802c4e <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802879:	a1 38 51 80 00       	mov    0x805138,%eax
  80287e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802881:	e9 b1 01 00 00       	jmp    802a37 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 50 08             	mov    0x8(%eax),%edx
  80288c:	a1 28 50 80 00       	mov    0x805028,%eax
  802891:	39 c2                	cmp    %eax,%edx
  802893:	0f 82 96 01 00 00    	jb     802a2f <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	8b 40 0c             	mov    0xc(%eax),%eax
  80289f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a2:	0f 82 87 01 00 00    	jb     802a2f <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b1:	0f 85 95 00 00 00    	jne    80294c <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bb:	75 17                	jne    8028d4 <alloc_block_NF+0x24c>
  8028bd:	83 ec 04             	sub    $0x4,%esp
  8028c0:	68 c8 40 80 00       	push   $0x8040c8
  8028c5:	68 fc 00 00 00       	push   $0xfc
  8028ca:	68 1f 40 80 00       	push   $0x80401f
  8028cf:	e8 fa d9 ff ff       	call   8002ce <_panic>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	74 10                	je     8028ed <alloc_block_NF+0x265>
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 00                	mov    (%eax),%eax
  8028e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e5:	8b 52 04             	mov    0x4(%edx),%edx
  8028e8:	89 50 04             	mov    %edx,0x4(%eax)
  8028eb:	eb 0b                	jmp    8028f8 <alloc_block_NF+0x270>
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 40 04             	mov    0x4(%eax),%eax
  8028f3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 40 04             	mov    0x4(%eax),%eax
  8028fe:	85 c0                	test   %eax,%eax
  802900:	74 0f                	je     802911 <alloc_block_NF+0x289>
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	8b 40 04             	mov    0x4(%eax),%eax
  802908:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290b:	8b 12                	mov    (%edx),%edx
  80290d:	89 10                	mov    %edx,(%eax)
  80290f:	eb 0a                	jmp    80291b <alloc_block_NF+0x293>
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 00                	mov    (%eax),%eax
  802916:	a3 38 51 80 00       	mov    %eax,0x805138
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292e:	a1 44 51 80 00       	mov    0x805144,%eax
  802933:	48                   	dec    %eax
  802934:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 40 08             	mov    0x8(%eax),%eax
  80293f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	e9 07 03 00 00       	jmp    802c53 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 40 0c             	mov    0xc(%eax),%eax
  802952:	3b 45 08             	cmp    0x8(%ebp),%eax
  802955:	0f 86 d4 00 00 00    	jbe    802a2f <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80295b:	a1 48 51 80 00       	mov    0x805148,%eax
  802960:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 50 08             	mov    0x8(%eax),%edx
  802969:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80296f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802972:	8b 55 08             	mov    0x8(%ebp),%edx
  802975:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802978:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80297c:	75 17                	jne    802995 <alloc_block_NF+0x30d>
  80297e:	83 ec 04             	sub    $0x4,%esp
  802981:	68 c8 40 80 00       	push   $0x8040c8
  802986:	68 04 01 00 00       	push   $0x104
  80298b:	68 1f 40 80 00       	push   $0x80401f
  802990:	e8 39 d9 ff ff       	call   8002ce <_panic>
  802995:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802998:	8b 00                	mov    (%eax),%eax
  80299a:	85 c0                	test   %eax,%eax
  80299c:	74 10                	je     8029ae <alloc_block_NF+0x326>
  80299e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a1:	8b 00                	mov    (%eax),%eax
  8029a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029a6:	8b 52 04             	mov    0x4(%edx),%edx
  8029a9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ac:	eb 0b                	jmp    8029b9 <alloc_block_NF+0x331>
  8029ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b1:	8b 40 04             	mov    0x4(%eax),%eax
  8029b4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bc:	8b 40 04             	mov    0x4(%eax),%eax
  8029bf:	85 c0                	test   %eax,%eax
  8029c1:	74 0f                	je     8029d2 <alloc_block_NF+0x34a>
  8029c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c6:	8b 40 04             	mov    0x4(%eax),%eax
  8029c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029cc:	8b 12                	mov    (%edx),%edx
  8029ce:	89 10                	mov    %edx,(%eax)
  8029d0:	eb 0a                	jmp    8029dc <alloc_block_NF+0x354>
  8029d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d5:	8b 00                	mov    (%eax),%eax
  8029d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8029dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ef:	a1 54 51 80 00       	mov    0x805154,%eax
  8029f4:	48                   	dec    %eax
  8029f5:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029fd:	8b 40 08             	mov    0x8(%eax),%eax
  802a00:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	8b 50 08             	mov    0x8(%eax),%edx
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	01 c2                	add    %eax,%edx
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1c:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1f:	89 c2                	mov    %eax,%edx
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2a:	e9 24 02 00 00       	jmp    802c53 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a2f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3b:	74 07                	je     802a44 <alloc_block_NF+0x3bc>
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 00                	mov    (%eax),%eax
  802a42:	eb 05                	jmp    802a49 <alloc_block_NF+0x3c1>
  802a44:	b8 00 00 00 00       	mov    $0x0,%eax
  802a49:	a3 40 51 80 00       	mov    %eax,0x805140
  802a4e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a53:	85 c0                	test   %eax,%eax
  802a55:	0f 85 2b fe ff ff    	jne    802886 <alloc_block_NF+0x1fe>
  802a5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5f:	0f 85 21 fe ff ff    	jne    802886 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a65:	a1 38 51 80 00       	mov    0x805138,%eax
  802a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a6d:	e9 ae 01 00 00       	jmp    802c20 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 50 08             	mov    0x8(%eax),%edx
  802a78:	a1 28 50 80 00       	mov    0x805028,%eax
  802a7d:	39 c2                	cmp    %eax,%edx
  802a7f:	0f 83 93 01 00 00    	jae    802c18 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a8e:	0f 82 84 01 00 00    	jb     802c18 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a97:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a9d:	0f 85 95 00 00 00    	jne    802b38 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802aa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa7:	75 17                	jne    802ac0 <alloc_block_NF+0x438>
  802aa9:	83 ec 04             	sub    $0x4,%esp
  802aac:	68 c8 40 80 00       	push   $0x8040c8
  802ab1:	68 14 01 00 00       	push   $0x114
  802ab6:	68 1f 40 80 00       	push   $0x80401f
  802abb:	e8 0e d8 ff ff       	call   8002ce <_panic>
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 00                	mov    (%eax),%eax
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	74 10                	je     802ad9 <alloc_block_NF+0x451>
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	8b 00                	mov    (%eax),%eax
  802ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad1:	8b 52 04             	mov    0x4(%edx),%edx
  802ad4:	89 50 04             	mov    %edx,0x4(%eax)
  802ad7:	eb 0b                	jmp    802ae4 <alloc_block_NF+0x45c>
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 40 04             	mov    0x4(%eax),%eax
  802adf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 40 04             	mov    0x4(%eax),%eax
  802aea:	85 c0                	test   %eax,%eax
  802aec:	74 0f                	je     802afd <alloc_block_NF+0x475>
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	8b 40 04             	mov    0x4(%eax),%eax
  802af4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af7:	8b 12                	mov    (%edx),%edx
  802af9:	89 10                	mov    %edx,(%eax)
  802afb:	eb 0a                	jmp    802b07 <alloc_block_NF+0x47f>
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	a3 38 51 80 00       	mov    %eax,0x805138
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1a:	a1 44 51 80 00       	mov    0x805144,%eax
  802b1f:	48                   	dec    %eax
  802b20:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 40 08             	mov    0x8(%eax),%eax
  802b2b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	e9 1b 01 00 00       	jmp    802c53 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b41:	0f 86 d1 00 00 00    	jbe    802c18 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b47:	a1 48 51 80 00       	mov    0x805148,%eax
  802b4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	8b 50 08             	mov    0x8(%eax),%edx
  802b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b58:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b61:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b68:	75 17                	jne    802b81 <alloc_block_NF+0x4f9>
  802b6a:	83 ec 04             	sub    $0x4,%esp
  802b6d:	68 c8 40 80 00       	push   $0x8040c8
  802b72:	68 1c 01 00 00       	push   $0x11c
  802b77:	68 1f 40 80 00       	push   $0x80401f
  802b7c:	e8 4d d7 ff ff       	call   8002ce <_panic>
  802b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b84:	8b 00                	mov    (%eax),%eax
  802b86:	85 c0                	test   %eax,%eax
  802b88:	74 10                	je     802b9a <alloc_block_NF+0x512>
  802b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8d:	8b 00                	mov    (%eax),%eax
  802b8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b92:	8b 52 04             	mov    0x4(%edx),%edx
  802b95:	89 50 04             	mov    %edx,0x4(%eax)
  802b98:	eb 0b                	jmp    802ba5 <alloc_block_NF+0x51d>
  802b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ba0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba8:	8b 40 04             	mov    0x4(%eax),%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	74 0f                	je     802bbe <alloc_block_NF+0x536>
  802baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb2:	8b 40 04             	mov    0x4(%eax),%eax
  802bb5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb8:	8b 12                	mov    (%edx),%edx
  802bba:	89 10                	mov    %edx,(%eax)
  802bbc:	eb 0a                	jmp    802bc8 <alloc_block_NF+0x540>
  802bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	a3 48 51 80 00       	mov    %eax,0x805148
  802bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdb:	a1 54 51 80 00       	mov    0x805154,%eax
  802be0:	48                   	dec    %eax
  802be1:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802be6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be9:	8b 40 08             	mov    0x8(%eax),%eax
  802bec:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 50 08             	mov    0x8(%eax),%edx
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	01 c2                	add    %eax,%edx
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 40 0c             	mov    0xc(%eax),%eax
  802c08:	2b 45 08             	sub    0x8(%ebp),%eax
  802c0b:	89 c2                	mov    %eax,%edx
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c16:	eb 3b                	jmp    802c53 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c18:	a1 40 51 80 00       	mov    0x805140,%eax
  802c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c24:	74 07                	je     802c2d <alloc_block_NF+0x5a5>
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	eb 05                	jmp    802c32 <alloc_block_NF+0x5aa>
  802c2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c32:	a3 40 51 80 00       	mov    %eax,0x805140
  802c37:	a1 40 51 80 00       	mov    0x805140,%eax
  802c3c:	85 c0                	test   %eax,%eax
  802c3e:	0f 85 2e fe ff ff    	jne    802a72 <alloc_block_NF+0x3ea>
  802c44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c48:	0f 85 24 fe ff ff    	jne    802a72 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c53:	c9                   	leave  
  802c54:	c3                   	ret    

00802c55 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c55:	55                   	push   %ebp
  802c56:	89 e5                	mov    %esp,%ebp
  802c58:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c5b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c63:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c68:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c6b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c70:	85 c0                	test   %eax,%eax
  802c72:	74 14                	je     802c88 <insert_sorted_with_merge_freeList+0x33>
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	8b 50 08             	mov    0x8(%eax),%edx
  802c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7d:	8b 40 08             	mov    0x8(%eax),%eax
  802c80:	39 c2                	cmp    %eax,%edx
  802c82:	0f 87 9b 01 00 00    	ja     802e23 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c8c:	75 17                	jne    802ca5 <insert_sorted_with_merge_freeList+0x50>
  802c8e:	83 ec 04             	sub    $0x4,%esp
  802c91:	68 fc 3f 80 00       	push   $0x803ffc
  802c96:	68 38 01 00 00       	push   $0x138
  802c9b:	68 1f 40 80 00       	push   $0x80401f
  802ca0:	e8 29 d6 ff ff       	call   8002ce <_panic>
  802ca5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	89 10                	mov    %edx,(%eax)
  802cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb3:	8b 00                	mov    (%eax),%eax
  802cb5:	85 c0                	test   %eax,%eax
  802cb7:	74 0d                	je     802cc6 <insert_sorted_with_merge_freeList+0x71>
  802cb9:	a1 38 51 80 00       	mov    0x805138,%eax
  802cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc1:	89 50 04             	mov    %edx,0x4(%eax)
  802cc4:	eb 08                	jmp    802cce <insert_sorted_with_merge_freeList+0x79>
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	a3 38 51 80 00       	mov    %eax,0x805138
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ce5:	40                   	inc    %eax
  802ce6:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ceb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cef:	0f 84 a8 06 00 00    	je     80339d <insert_sorted_with_merge_freeList+0x748>
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	8b 50 08             	mov    0x8(%eax),%edx
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802d01:	01 c2                	add    %eax,%edx
  802d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d06:	8b 40 08             	mov    0x8(%eax),%eax
  802d09:	39 c2                	cmp    %eax,%edx
  802d0b:	0f 85 8c 06 00 00    	jne    80339d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	8b 50 0c             	mov    0xc(%eax),%edx
  802d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1d:	01 c2                	add    %eax,%edx
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d29:	75 17                	jne    802d42 <insert_sorted_with_merge_freeList+0xed>
  802d2b:	83 ec 04             	sub    $0x4,%esp
  802d2e:	68 c8 40 80 00       	push   $0x8040c8
  802d33:	68 3c 01 00 00       	push   $0x13c
  802d38:	68 1f 40 80 00       	push   $0x80401f
  802d3d:	e8 8c d5 ff ff       	call   8002ce <_panic>
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	85 c0                	test   %eax,%eax
  802d49:	74 10                	je     802d5b <insert_sorted_with_merge_freeList+0x106>
  802d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d53:	8b 52 04             	mov    0x4(%edx),%edx
  802d56:	89 50 04             	mov    %edx,0x4(%eax)
  802d59:	eb 0b                	jmp    802d66 <insert_sorted_with_merge_freeList+0x111>
  802d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5e:	8b 40 04             	mov    0x4(%eax),%eax
  802d61:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	8b 40 04             	mov    0x4(%eax),%eax
  802d6c:	85 c0                	test   %eax,%eax
  802d6e:	74 0f                	je     802d7f <insert_sorted_with_merge_freeList+0x12a>
  802d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d73:	8b 40 04             	mov    0x4(%eax),%eax
  802d76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d79:	8b 12                	mov    (%edx),%edx
  802d7b:	89 10                	mov    %edx,(%eax)
  802d7d:	eb 0a                	jmp    802d89 <insert_sorted_with_merge_freeList+0x134>
  802d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	a3 38 51 80 00       	mov    %eax,0x805138
  802d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9c:	a1 44 51 80 00       	mov    0x805144,%eax
  802da1:	48                   	dec    %eax
  802da2:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dbf:	75 17                	jne    802dd8 <insert_sorted_with_merge_freeList+0x183>
  802dc1:	83 ec 04             	sub    $0x4,%esp
  802dc4:	68 fc 3f 80 00       	push   $0x803ffc
  802dc9:	68 3f 01 00 00       	push   $0x13f
  802dce:	68 1f 40 80 00       	push   $0x80401f
  802dd3:	e8 f6 d4 ff ff       	call   8002ce <_panic>
  802dd8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	89 10                	mov    %edx,(%eax)
  802de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de6:	8b 00                	mov    (%eax),%eax
  802de8:	85 c0                	test   %eax,%eax
  802dea:	74 0d                	je     802df9 <insert_sorted_with_merge_freeList+0x1a4>
  802dec:	a1 48 51 80 00       	mov    0x805148,%eax
  802df1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df4:	89 50 04             	mov    %edx,0x4(%eax)
  802df7:	eb 08                	jmp    802e01 <insert_sorted_with_merge_freeList+0x1ac>
  802df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e04:	a3 48 51 80 00       	mov    %eax,0x805148
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e13:	a1 54 51 80 00       	mov    0x805154,%eax
  802e18:	40                   	inc    %eax
  802e19:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e1e:	e9 7a 05 00 00       	jmp    80339d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	8b 50 08             	mov    0x8(%eax),%edx
  802e29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2c:	8b 40 08             	mov    0x8(%eax),%eax
  802e2f:	39 c2                	cmp    %eax,%edx
  802e31:	0f 82 14 01 00 00    	jb     802f4b <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3a:	8b 50 08             	mov    0x8(%eax),%edx
  802e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e40:	8b 40 0c             	mov    0xc(%eax),%eax
  802e43:	01 c2                	add    %eax,%edx
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	8b 40 08             	mov    0x8(%eax),%eax
  802e4b:	39 c2                	cmp    %eax,%edx
  802e4d:	0f 85 90 00 00 00    	jne    802ee3 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e56:	8b 50 0c             	mov    0xc(%eax),%edx
  802e59:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5f:	01 c2                	add    %eax,%edx
  802e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e64:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7f:	75 17                	jne    802e98 <insert_sorted_with_merge_freeList+0x243>
  802e81:	83 ec 04             	sub    $0x4,%esp
  802e84:	68 fc 3f 80 00       	push   $0x803ffc
  802e89:	68 49 01 00 00       	push   $0x149
  802e8e:	68 1f 40 80 00       	push   $0x80401f
  802e93:	e8 36 d4 ff ff       	call   8002ce <_panic>
  802e98:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	89 10                	mov    %edx,(%eax)
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	74 0d                	je     802eb9 <insert_sorted_with_merge_freeList+0x264>
  802eac:	a1 48 51 80 00       	mov    0x805148,%eax
  802eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb4:	89 50 04             	mov    %edx,0x4(%eax)
  802eb7:	eb 08                	jmp    802ec1 <insert_sorted_with_merge_freeList+0x26c>
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ed8:	40                   	inc    %eax
  802ed9:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ede:	e9 bb 04 00 00       	jmp    80339e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ee3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee7:	75 17                	jne    802f00 <insert_sorted_with_merge_freeList+0x2ab>
  802ee9:	83 ec 04             	sub    $0x4,%esp
  802eec:	68 70 40 80 00       	push   $0x804070
  802ef1:	68 4c 01 00 00       	push   $0x14c
  802ef6:	68 1f 40 80 00       	push   $0x80401f
  802efb:	e8 ce d3 ff ff       	call   8002ce <_panic>
  802f00:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	89 50 04             	mov    %edx,0x4(%eax)
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	8b 40 04             	mov    0x4(%eax),%eax
  802f12:	85 c0                	test   %eax,%eax
  802f14:	74 0c                	je     802f22 <insert_sorted_with_merge_freeList+0x2cd>
  802f16:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1e:	89 10                	mov    %edx,(%eax)
  802f20:	eb 08                	jmp    802f2a <insert_sorted_with_merge_freeList+0x2d5>
  802f22:	8b 45 08             	mov    0x8(%ebp),%eax
  802f25:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3b:	a1 44 51 80 00       	mov    0x805144,%eax
  802f40:	40                   	inc    %eax
  802f41:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f46:	e9 53 04 00 00       	jmp    80339e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f4b:	a1 38 51 80 00       	mov    0x805138,%eax
  802f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f53:	e9 15 04 00 00       	jmp    80336d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	8b 50 08             	mov    0x8(%eax),%edx
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	8b 40 08             	mov    0x8(%eax),%eax
  802f6c:	39 c2                	cmp    %eax,%edx
  802f6e:	0f 86 f1 03 00 00    	jbe    803365 <insert_sorted_with_merge_freeList+0x710>
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	8b 50 08             	mov    0x8(%eax),%edx
  802f7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7d:	8b 40 08             	mov    0x8(%eax),%eax
  802f80:	39 c2                	cmp    %eax,%edx
  802f82:	0f 83 dd 03 00 00    	jae    803365 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 50 08             	mov    0x8(%eax),%edx
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	8b 40 0c             	mov    0xc(%eax),%eax
  802f94:	01 c2                	add    %eax,%edx
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	8b 40 08             	mov    0x8(%eax),%eax
  802f9c:	39 c2                	cmp    %eax,%edx
  802f9e:	0f 85 b9 01 00 00    	jne    80315d <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	8b 50 08             	mov    0x8(%eax),%edx
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb0:	01 c2                	add    %eax,%edx
  802fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb5:	8b 40 08             	mov    0x8(%eax),%eax
  802fb8:	39 c2                	cmp    %eax,%edx
  802fba:	0f 85 0d 01 00 00    	jne    8030cd <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc3:	8b 50 0c             	mov    0xc(%eax),%edx
  802fc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcc:	01 c2                	add    %eax,%edx
  802fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd1:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fd4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd8:	75 17                	jne    802ff1 <insert_sorted_with_merge_freeList+0x39c>
  802fda:	83 ec 04             	sub    $0x4,%esp
  802fdd:	68 c8 40 80 00       	push   $0x8040c8
  802fe2:	68 5c 01 00 00       	push   $0x15c
  802fe7:	68 1f 40 80 00       	push   $0x80401f
  802fec:	e8 dd d2 ff ff       	call   8002ce <_panic>
  802ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff4:	8b 00                	mov    (%eax),%eax
  802ff6:	85 c0                	test   %eax,%eax
  802ff8:	74 10                	je     80300a <insert_sorted_with_merge_freeList+0x3b5>
  802ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803002:	8b 52 04             	mov    0x4(%edx),%edx
  803005:	89 50 04             	mov    %edx,0x4(%eax)
  803008:	eb 0b                	jmp    803015 <insert_sorted_with_merge_freeList+0x3c0>
  80300a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300d:	8b 40 04             	mov    0x4(%eax),%eax
  803010:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803018:	8b 40 04             	mov    0x4(%eax),%eax
  80301b:	85 c0                	test   %eax,%eax
  80301d:	74 0f                	je     80302e <insert_sorted_with_merge_freeList+0x3d9>
  80301f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803022:	8b 40 04             	mov    0x4(%eax),%eax
  803025:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803028:	8b 12                	mov    (%edx),%edx
  80302a:	89 10                	mov    %edx,(%eax)
  80302c:	eb 0a                	jmp    803038 <insert_sorted_with_merge_freeList+0x3e3>
  80302e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803031:	8b 00                	mov    (%eax),%eax
  803033:	a3 38 51 80 00       	mov    %eax,0x805138
  803038:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803041:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803044:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304b:	a1 44 51 80 00       	mov    0x805144,%eax
  803050:	48                   	dec    %eax
  803051:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803056:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803059:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803060:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803063:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80306a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80306e:	75 17                	jne    803087 <insert_sorted_with_merge_freeList+0x432>
  803070:	83 ec 04             	sub    $0x4,%esp
  803073:	68 fc 3f 80 00       	push   $0x803ffc
  803078:	68 5f 01 00 00       	push   $0x15f
  80307d:	68 1f 40 80 00       	push   $0x80401f
  803082:	e8 47 d2 ff ff       	call   8002ce <_panic>
  803087:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80308d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803090:	89 10                	mov    %edx,(%eax)
  803092:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803095:	8b 00                	mov    (%eax),%eax
  803097:	85 c0                	test   %eax,%eax
  803099:	74 0d                	je     8030a8 <insert_sorted_with_merge_freeList+0x453>
  80309b:	a1 48 51 80 00       	mov    0x805148,%eax
  8030a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a3:	89 50 04             	mov    %edx,0x4(%eax)
  8030a6:	eb 08                	jmp    8030b0 <insert_sorted_with_merge_freeList+0x45b>
  8030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b3:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c2:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c7:	40                   	inc    %eax
  8030c8:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d9:	01 c2                	add    %eax,%edx
  8030db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030de:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f9:	75 17                	jne    803112 <insert_sorted_with_merge_freeList+0x4bd>
  8030fb:	83 ec 04             	sub    $0x4,%esp
  8030fe:	68 fc 3f 80 00       	push   $0x803ffc
  803103:	68 64 01 00 00       	push   $0x164
  803108:	68 1f 40 80 00       	push   $0x80401f
  80310d:	e8 bc d1 ff ff       	call   8002ce <_panic>
  803112:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	89 10                	mov    %edx,(%eax)
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	85 c0                	test   %eax,%eax
  803124:	74 0d                	je     803133 <insert_sorted_with_merge_freeList+0x4de>
  803126:	a1 48 51 80 00       	mov    0x805148,%eax
  80312b:	8b 55 08             	mov    0x8(%ebp),%edx
  80312e:	89 50 04             	mov    %edx,0x4(%eax)
  803131:	eb 08                	jmp    80313b <insert_sorted_with_merge_freeList+0x4e6>
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	a3 48 51 80 00       	mov    %eax,0x805148
  803143:	8b 45 08             	mov    0x8(%ebp),%eax
  803146:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314d:	a1 54 51 80 00       	mov    0x805154,%eax
  803152:	40                   	inc    %eax
  803153:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803158:	e9 41 02 00 00       	jmp    80339e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	8b 50 08             	mov    0x8(%eax),%edx
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	8b 40 0c             	mov    0xc(%eax),%eax
  803169:	01 c2                	add    %eax,%edx
  80316b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316e:	8b 40 08             	mov    0x8(%eax),%eax
  803171:	39 c2                	cmp    %eax,%edx
  803173:	0f 85 7c 01 00 00    	jne    8032f5 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803179:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80317d:	74 06                	je     803185 <insert_sorted_with_merge_freeList+0x530>
  80317f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803183:	75 17                	jne    80319c <insert_sorted_with_merge_freeList+0x547>
  803185:	83 ec 04             	sub    $0x4,%esp
  803188:	68 38 40 80 00       	push   $0x804038
  80318d:	68 69 01 00 00       	push   $0x169
  803192:	68 1f 40 80 00       	push   $0x80401f
  803197:	e8 32 d1 ff ff       	call   8002ce <_panic>
  80319c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319f:	8b 50 04             	mov    0x4(%eax),%edx
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	89 50 04             	mov    %edx,0x4(%eax)
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ae:	89 10                	mov    %edx,(%eax)
  8031b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b3:	8b 40 04             	mov    0x4(%eax),%eax
  8031b6:	85 c0                	test   %eax,%eax
  8031b8:	74 0d                	je     8031c7 <insert_sorted_with_merge_freeList+0x572>
  8031ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bd:	8b 40 04             	mov    0x4(%eax),%eax
  8031c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c3:	89 10                	mov    %edx,(%eax)
  8031c5:	eb 08                	jmp    8031cf <insert_sorted_with_merge_freeList+0x57a>
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	a3 38 51 80 00       	mov    %eax,0x805138
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d5:	89 50 04             	mov    %edx,0x4(%eax)
  8031d8:	a1 44 51 80 00       	mov    0x805144,%eax
  8031dd:	40                   	inc    %eax
  8031de:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	8b 50 0c             	mov    0xc(%eax),%edx
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ef:	01 c2                	add    %eax,%edx
  8031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f4:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031fb:	75 17                	jne    803214 <insert_sorted_with_merge_freeList+0x5bf>
  8031fd:	83 ec 04             	sub    $0x4,%esp
  803200:	68 c8 40 80 00       	push   $0x8040c8
  803205:	68 6b 01 00 00       	push   $0x16b
  80320a:	68 1f 40 80 00       	push   $0x80401f
  80320f:	e8 ba d0 ff ff       	call   8002ce <_panic>
  803214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803217:	8b 00                	mov    (%eax),%eax
  803219:	85 c0                	test   %eax,%eax
  80321b:	74 10                	je     80322d <insert_sorted_with_merge_freeList+0x5d8>
  80321d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803220:	8b 00                	mov    (%eax),%eax
  803222:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803225:	8b 52 04             	mov    0x4(%edx),%edx
  803228:	89 50 04             	mov    %edx,0x4(%eax)
  80322b:	eb 0b                	jmp    803238 <insert_sorted_with_merge_freeList+0x5e3>
  80322d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803230:	8b 40 04             	mov    0x4(%eax),%eax
  803233:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803238:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323b:	8b 40 04             	mov    0x4(%eax),%eax
  80323e:	85 c0                	test   %eax,%eax
  803240:	74 0f                	je     803251 <insert_sorted_with_merge_freeList+0x5fc>
  803242:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803245:	8b 40 04             	mov    0x4(%eax),%eax
  803248:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80324b:	8b 12                	mov    (%edx),%edx
  80324d:	89 10                	mov    %edx,(%eax)
  80324f:	eb 0a                	jmp    80325b <insert_sorted_with_merge_freeList+0x606>
  803251:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803254:	8b 00                	mov    (%eax),%eax
  803256:	a3 38 51 80 00       	mov    %eax,0x805138
  80325b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803267:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326e:	a1 44 51 80 00       	mov    0x805144,%eax
  803273:	48                   	dec    %eax
  803274:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803279:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803286:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80328d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803291:	75 17                	jne    8032aa <insert_sorted_with_merge_freeList+0x655>
  803293:	83 ec 04             	sub    $0x4,%esp
  803296:	68 fc 3f 80 00       	push   $0x803ffc
  80329b:	68 6e 01 00 00       	push   $0x16e
  8032a0:	68 1f 40 80 00       	push   $0x80401f
  8032a5:	e8 24 d0 ff ff       	call   8002ce <_panic>
  8032aa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b3:	89 10                	mov    %edx,(%eax)
  8032b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b8:	8b 00                	mov    (%eax),%eax
  8032ba:	85 c0                	test   %eax,%eax
  8032bc:	74 0d                	je     8032cb <insert_sorted_with_merge_freeList+0x676>
  8032be:	a1 48 51 80 00       	mov    0x805148,%eax
  8032c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c6:	89 50 04             	mov    %edx,0x4(%eax)
  8032c9:	eb 08                	jmp    8032d3 <insert_sorted_with_merge_freeList+0x67e>
  8032cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ce:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d6:	a3 48 51 80 00       	mov    %eax,0x805148
  8032db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e5:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ea:	40                   	inc    %eax
  8032eb:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032f0:	e9 a9 00 00 00       	jmp    80339e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f9:	74 06                	je     803301 <insert_sorted_with_merge_freeList+0x6ac>
  8032fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ff:	75 17                	jne    803318 <insert_sorted_with_merge_freeList+0x6c3>
  803301:	83 ec 04             	sub    $0x4,%esp
  803304:	68 94 40 80 00       	push   $0x804094
  803309:	68 73 01 00 00       	push   $0x173
  80330e:	68 1f 40 80 00       	push   $0x80401f
  803313:	e8 b6 cf ff ff       	call   8002ce <_panic>
  803318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331b:	8b 10                	mov    (%eax),%edx
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	89 10                	mov    %edx,(%eax)
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	8b 00                	mov    (%eax),%eax
  803327:	85 c0                	test   %eax,%eax
  803329:	74 0b                	je     803336 <insert_sorted_with_merge_freeList+0x6e1>
  80332b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332e:	8b 00                	mov    (%eax),%eax
  803330:	8b 55 08             	mov    0x8(%ebp),%edx
  803333:	89 50 04             	mov    %edx,0x4(%eax)
  803336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803339:	8b 55 08             	mov    0x8(%ebp),%edx
  80333c:	89 10                	mov    %edx,(%eax)
  80333e:	8b 45 08             	mov    0x8(%ebp),%eax
  803341:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803344:	89 50 04             	mov    %edx,0x4(%eax)
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	8b 00                	mov    (%eax),%eax
  80334c:	85 c0                	test   %eax,%eax
  80334e:	75 08                	jne    803358 <insert_sorted_with_merge_freeList+0x703>
  803350:	8b 45 08             	mov    0x8(%ebp),%eax
  803353:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803358:	a1 44 51 80 00       	mov    0x805144,%eax
  80335d:	40                   	inc    %eax
  80335e:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803363:	eb 39                	jmp    80339e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803365:	a1 40 51 80 00       	mov    0x805140,%eax
  80336a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80336d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803371:	74 07                	je     80337a <insert_sorted_with_merge_freeList+0x725>
  803373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803376:	8b 00                	mov    (%eax),%eax
  803378:	eb 05                	jmp    80337f <insert_sorted_with_merge_freeList+0x72a>
  80337a:	b8 00 00 00 00       	mov    $0x0,%eax
  80337f:	a3 40 51 80 00       	mov    %eax,0x805140
  803384:	a1 40 51 80 00       	mov    0x805140,%eax
  803389:	85 c0                	test   %eax,%eax
  80338b:	0f 85 c7 fb ff ff    	jne    802f58 <insert_sorted_with_merge_freeList+0x303>
  803391:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803395:	0f 85 bd fb ff ff    	jne    802f58 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80339b:	eb 01                	jmp    80339e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80339d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80339e:	90                   	nop
  80339f:	c9                   	leave  
  8033a0:	c3                   	ret    

008033a1 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8033a1:	55                   	push   %ebp
  8033a2:	89 e5                	mov    %esp,%ebp
  8033a4:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8033a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033aa:	89 d0                	mov    %edx,%eax
  8033ac:	c1 e0 02             	shl    $0x2,%eax
  8033af:	01 d0                	add    %edx,%eax
  8033b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033b8:	01 d0                	add    %edx,%eax
  8033ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033c1:	01 d0                	add    %edx,%eax
  8033c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033ca:	01 d0                	add    %edx,%eax
  8033cc:	c1 e0 04             	shl    $0x4,%eax
  8033cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8033d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8033d9:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033dc:	83 ec 0c             	sub    $0xc,%esp
  8033df:	50                   	push   %eax
  8033e0:	e8 26 e7 ff ff       	call   801b0b <sys_get_virtual_time>
  8033e5:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033e8:	eb 41                	jmp    80342b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033ea:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033ed:	83 ec 0c             	sub    $0xc,%esp
  8033f0:	50                   	push   %eax
  8033f1:	e8 15 e7 ff ff       	call   801b0b <sys_get_virtual_time>
  8033f6:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ff:	29 c2                	sub    %eax,%edx
  803401:	89 d0                	mov    %edx,%eax
  803403:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803406:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80340c:	89 d1                	mov    %edx,%ecx
  80340e:	29 c1                	sub    %eax,%ecx
  803410:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803413:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803416:	39 c2                	cmp    %eax,%edx
  803418:	0f 97 c0             	seta   %al
  80341b:	0f b6 c0             	movzbl %al,%eax
  80341e:	29 c1                	sub    %eax,%ecx
  803420:	89 c8                	mov    %ecx,%eax
  803422:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803425:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803428:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80342b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803431:	72 b7                	jb     8033ea <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803433:	90                   	nop
  803434:	c9                   	leave  
  803435:	c3                   	ret    

00803436 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803436:	55                   	push   %ebp
  803437:	89 e5                	mov    %esp,%ebp
  803439:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80343c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803443:	eb 03                	jmp    803448 <busy_wait+0x12>
  803445:	ff 45 fc             	incl   -0x4(%ebp)
  803448:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80344b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80344e:	72 f5                	jb     803445 <busy_wait+0xf>
	return i;
  803450:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803453:	c9                   	leave  
  803454:	c3                   	ret    
  803455:	66 90                	xchg   %ax,%ax
  803457:	90                   	nop

00803458 <__udivdi3>:
  803458:	55                   	push   %ebp
  803459:	57                   	push   %edi
  80345a:	56                   	push   %esi
  80345b:	53                   	push   %ebx
  80345c:	83 ec 1c             	sub    $0x1c,%esp
  80345f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803463:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803467:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80346b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80346f:	89 ca                	mov    %ecx,%edx
  803471:	89 f8                	mov    %edi,%eax
  803473:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803477:	85 f6                	test   %esi,%esi
  803479:	75 2d                	jne    8034a8 <__udivdi3+0x50>
  80347b:	39 cf                	cmp    %ecx,%edi
  80347d:	77 65                	ja     8034e4 <__udivdi3+0x8c>
  80347f:	89 fd                	mov    %edi,%ebp
  803481:	85 ff                	test   %edi,%edi
  803483:	75 0b                	jne    803490 <__udivdi3+0x38>
  803485:	b8 01 00 00 00       	mov    $0x1,%eax
  80348a:	31 d2                	xor    %edx,%edx
  80348c:	f7 f7                	div    %edi
  80348e:	89 c5                	mov    %eax,%ebp
  803490:	31 d2                	xor    %edx,%edx
  803492:	89 c8                	mov    %ecx,%eax
  803494:	f7 f5                	div    %ebp
  803496:	89 c1                	mov    %eax,%ecx
  803498:	89 d8                	mov    %ebx,%eax
  80349a:	f7 f5                	div    %ebp
  80349c:	89 cf                	mov    %ecx,%edi
  80349e:	89 fa                	mov    %edi,%edx
  8034a0:	83 c4 1c             	add    $0x1c,%esp
  8034a3:	5b                   	pop    %ebx
  8034a4:	5e                   	pop    %esi
  8034a5:	5f                   	pop    %edi
  8034a6:	5d                   	pop    %ebp
  8034a7:	c3                   	ret    
  8034a8:	39 ce                	cmp    %ecx,%esi
  8034aa:	77 28                	ja     8034d4 <__udivdi3+0x7c>
  8034ac:	0f bd fe             	bsr    %esi,%edi
  8034af:	83 f7 1f             	xor    $0x1f,%edi
  8034b2:	75 40                	jne    8034f4 <__udivdi3+0x9c>
  8034b4:	39 ce                	cmp    %ecx,%esi
  8034b6:	72 0a                	jb     8034c2 <__udivdi3+0x6a>
  8034b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034bc:	0f 87 9e 00 00 00    	ja     803560 <__udivdi3+0x108>
  8034c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034c7:	89 fa                	mov    %edi,%edx
  8034c9:	83 c4 1c             	add    $0x1c,%esp
  8034cc:	5b                   	pop    %ebx
  8034cd:	5e                   	pop    %esi
  8034ce:	5f                   	pop    %edi
  8034cf:	5d                   	pop    %ebp
  8034d0:	c3                   	ret    
  8034d1:	8d 76 00             	lea    0x0(%esi),%esi
  8034d4:	31 ff                	xor    %edi,%edi
  8034d6:	31 c0                	xor    %eax,%eax
  8034d8:	89 fa                	mov    %edi,%edx
  8034da:	83 c4 1c             	add    $0x1c,%esp
  8034dd:	5b                   	pop    %ebx
  8034de:	5e                   	pop    %esi
  8034df:	5f                   	pop    %edi
  8034e0:	5d                   	pop    %ebp
  8034e1:	c3                   	ret    
  8034e2:	66 90                	xchg   %ax,%ax
  8034e4:	89 d8                	mov    %ebx,%eax
  8034e6:	f7 f7                	div    %edi
  8034e8:	31 ff                	xor    %edi,%edi
  8034ea:	89 fa                	mov    %edi,%edx
  8034ec:	83 c4 1c             	add    $0x1c,%esp
  8034ef:	5b                   	pop    %ebx
  8034f0:	5e                   	pop    %esi
  8034f1:	5f                   	pop    %edi
  8034f2:	5d                   	pop    %ebp
  8034f3:	c3                   	ret    
  8034f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034f9:	89 eb                	mov    %ebp,%ebx
  8034fb:	29 fb                	sub    %edi,%ebx
  8034fd:	89 f9                	mov    %edi,%ecx
  8034ff:	d3 e6                	shl    %cl,%esi
  803501:	89 c5                	mov    %eax,%ebp
  803503:	88 d9                	mov    %bl,%cl
  803505:	d3 ed                	shr    %cl,%ebp
  803507:	89 e9                	mov    %ebp,%ecx
  803509:	09 f1                	or     %esi,%ecx
  80350b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80350f:	89 f9                	mov    %edi,%ecx
  803511:	d3 e0                	shl    %cl,%eax
  803513:	89 c5                	mov    %eax,%ebp
  803515:	89 d6                	mov    %edx,%esi
  803517:	88 d9                	mov    %bl,%cl
  803519:	d3 ee                	shr    %cl,%esi
  80351b:	89 f9                	mov    %edi,%ecx
  80351d:	d3 e2                	shl    %cl,%edx
  80351f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803523:	88 d9                	mov    %bl,%cl
  803525:	d3 e8                	shr    %cl,%eax
  803527:	09 c2                	or     %eax,%edx
  803529:	89 d0                	mov    %edx,%eax
  80352b:	89 f2                	mov    %esi,%edx
  80352d:	f7 74 24 0c          	divl   0xc(%esp)
  803531:	89 d6                	mov    %edx,%esi
  803533:	89 c3                	mov    %eax,%ebx
  803535:	f7 e5                	mul    %ebp
  803537:	39 d6                	cmp    %edx,%esi
  803539:	72 19                	jb     803554 <__udivdi3+0xfc>
  80353b:	74 0b                	je     803548 <__udivdi3+0xf0>
  80353d:	89 d8                	mov    %ebx,%eax
  80353f:	31 ff                	xor    %edi,%edi
  803541:	e9 58 ff ff ff       	jmp    80349e <__udivdi3+0x46>
  803546:	66 90                	xchg   %ax,%ax
  803548:	8b 54 24 08          	mov    0x8(%esp),%edx
  80354c:	89 f9                	mov    %edi,%ecx
  80354e:	d3 e2                	shl    %cl,%edx
  803550:	39 c2                	cmp    %eax,%edx
  803552:	73 e9                	jae    80353d <__udivdi3+0xe5>
  803554:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803557:	31 ff                	xor    %edi,%edi
  803559:	e9 40 ff ff ff       	jmp    80349e <__udivdi3+0x46>
  80355e:	66 90                	xchg   %ax,%ax
  803560:	31 c0                	xor    %eax,%eax
  803562:	e9 37 ff ff ff       	jmp    80349e <__udivdi3+0x46>
  803567:	90                   	nop

00803568 <__umoddi3>:
  803568:	55                   	push   %ebp
  803569:	57                   	push   %edi
  80356a:	56                   	push   %esi
  80356b:	53                   	push   %ebx
  80356c:	83 ec 1c             	sub    $0x1c,%esp
  80356f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803573:	8b 74 24 34          	mov    0x34(%esp),%esi
  803577:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80357b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80357f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803583:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803587:	89 f3                	mov    %esi,%ebx
  803589:	89 fa                	mov    %edi,%edx
  80358b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80358f:	89 34 24             	mov    %esi,(%esp)
  803592:	85 c0                	test   %eax,%eax
  803594:	75 1a                	jne    8035b0 <__umoddi3+0x48>
  803596:	39 f7                	cmp    %esi,%edi
  803598:	0f 86 a2 00 00 00    	jbe    803640 <__umoddi3+0xd8>
  80359e:	89 c8                	mov    %ecx,%eax
  8035a0:	89 f2                	mov    %esi,%edx
  8035a2:	f7 f7                	div    %edi
  8035a4:	89 d0                	mov    %edx,%eax
  8035a6:	31 d2                	xor    %edx,%edx
  8035a8:	83 c4 1c             	add    $0x1c,%esp
  8035ab:	5b                   	pop    %ebx
  8035ac:	5e                   	pop    %esi
  8035ad:	5f                   	pop    %edi
  8035ae:	5d                   	pop    %ebp
  8035af:	c3                   	ret    
  8035b0:	39 f0                	cmp    %esi,%eax
  8035b2:	0f 87 ac 00 00 00    	ja     803664 <__umoddi3+0xfc>
  8035b8:	0f bd e8             	bsr    %eax,%ebp
  8035bb:	83 f5 1f             	xor    $0x1f,%ebp
  8035be:	0f 84 ac 00 00 00    	je     803670 <__umoddi3+0x108>
  8035c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8035c9:	29 ef                	sub    %ebp,%edi
  8035cb:	89 fe                	mov    %edi,%esi
  8035cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035d1:	89 e9                	mov    %ebp,%ecx
  8035d3:	d3 e0                	shl    %cl,%eax
  8035d5:	89 d7                	mov    %edx,%edi
  8035d7:	89 f1                	mov    %esi,%ecx
  8035d9:	d3 ef                	shr    %cl,%edi
  8035db:	09 c7                	or     %eax,%edi
  8035dd:	89 e9                	mov    %ebp,%ecx
  8035df:	d3 e2                	shl    %cl,%edx
  8035e1:	89 14 24             	mov    %edx,(%esp)
  8035e4:	89 d8                	mov    %ebx,%eax
  8035e6:	d3 e0                	shl    %cl,%eax
  8035e8:	89 c2                	mov    %eax,%edx
  8035ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035ee:	d3 e0                	shl    %cl,%eax
  8035f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035f8:	89 f1                	mov    %esi,%ecx
  8035fa:	d3 e8                	shr    %cl,%eax
  8035fc:	09 d0                	or     %edx,%eax
  8035fe:	d3 eb                	shr    %cl,%ebx
  803600:	89 da                	mov    %ebx,%edx
  803602:	f7 f7                	div    %edi
  803604:	89 d3                	mov    %edx,%ebx
  803606:	f7 24 24             	mull   (%esp)
  803609:	89 c6                	mov    %eax,%esi
  80360b:	89 d1                	mov    %edx,%ecx
  80360d:	39 d3                	cmp    %edx,%ebx
  80360f:	0f 82 87 00 00 00    	jb     80369c <__umoddi3+0x134>
  803615:	0f 84 91 00 00 00    	je     8036ac <__umoddi3+0x144>
  80361b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80361f:	29 f2                	sub    %esi,%edx
  803621:	19 cb                	sbb    %ecx,%ebx
  803623:	89 d8                	mov    %ebx,%eax
  803625:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803629:	d3 e0                	shl    %cl,%eax
  80362b:	89 e9                	mov    %ebp,%ecx
  80362d:	d3 ea                	shr    %cl,%edx
  80362f:	09 d0                	or     %edx,%eax
  803631:	89 e9                	mov    %ebp,%ecx
  803633:	d3 eb                	shr    %cl,%ebx
  803635:	89 da                	mov    %ebx,%edx
  803637:	83 c4 1c             	add    $0x1c,%esp
  80363a:	5b                   	pop    %ebx
  80363b:	5e                   	pop    %esi
  80363c:	5f                   	pop    %edi
  80363d:	5d                   	pop    %ebp
  80363e:	c3                   	ret    
  80363f:	90                   	nop
  803640:	89 fd                	mov    %edi,%ebp
  803642:	85 ff                	test   %edi,%edi
  803644:	75 0b                	jne    803651 <__umoddi3+0xe9>
  803646:	b8 01 00 00 00       	mov    $0x1,%eax
  80364b:	31 d2                	xor    %edx,%edx
  80364d:	f7 f7                	div    %edi
  80364f:	89 c5                	mov    %eax,%ebp
  803651:	89 f0                	mov    %esi,%eax
  803653:	31 d2                	xor    %edx,%edx
  803655:	f7 f5                	div    %ebp
  803657:	89 c8                	mov    %ecx,%eax
  803659:	f7 f5                	div    %ebp
  80365b:	89 d0                	mov    %edx,%eax
  80365d:	e9 44 ff ff ff       	jmp    8035a6 <__umoddi3+0x3e>
  803662:	66 90                	xchg   %ax,%ax
  803664:	89 c8                	mov    %ecx,%eax
  803666:	89 f2                	mov    %esi,%edx
  803668:	83 c4 1c             	add    $0x1c,%esp
  80366b:	5b                   	pop    %ebx
  80366c:	5e                   	pop    %esi
  80366d:	5f                   	pop    %edi
  80366e:	5d                   	pop    %ebp
  80366f:	c3                   	ret    
  803670:	3b 04 24             	cmp    (%esp),%eax
  803673:	72 06                	jb     80367b <__umoddi3+0x113>
  803675:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803679:	77 0f                	ja     80368a <__umoddi3+0x122>
  80367b:	89 f2                	mov    %esi,%edx
  80367d:	29 f9                	sub    %edi,%ecx
  80367f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803683:	89 14 24             	mov    %edx,(%esp)
  803686:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80368a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80368e:	8b 14 24             	mov    (%esp),%edx
  803691:	83 c4 1c             	add    $0x1c,%esp
  803694:	5b                   	pop    %ebx
  803695:	5e                   	pop    %esi
  803696:	5f                   	pop    %edi
  803697:	5d                   	pop    %ebp
  803698:	c3                   	ret    
  803699:	8d 76 00             	lea    0x0(%esi),%esi
  80369c:	2b 04 24             	sub    (%esp),%eax
  80369f:	19 fa                	sbb    %edi,%edx
  8036a1:	89 d1                	mov    %edx,%ecx
  8036a3:	89 c6                	mov    %eax,%esi
  8036a5:	e9 71 ff ff ff       	jmp    80361b <__umoddi3+0xb3>
  8036aa:	66 90                	xchg   %ax,%ax
  8036ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036b0:	72 ea                	jb     80369c <__umoddi3+0x134>
  8036b2:	89 d9                	mov    %ebx,%ecx
  8036b4:	e9 62 ff ff ff       	jmp    80361b <__umoddi3+0xb3>
