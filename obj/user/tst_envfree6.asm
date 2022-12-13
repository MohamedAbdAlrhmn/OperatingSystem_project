
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
  800045:	68 60 37 80 00       	push   $0x803760
  80004a:	e8 50 15 00 00       	call   80159f <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 0e 18 00 00       	call   801871 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 a6 18 00 00       	call   801911 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 70 37 80 00       	push   $0x803770
  800079:	e8 04 05 00 00       	call   800582 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000, (myEnv->SecondListSize),50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 a3 37 80 00       	push   $0x8037a3
  800099:	e8 45 1a 00 00       	call   801ae3 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	6a 14                	push   $0x14
  8000b4:	68 ac 37 80 00       	push   $0x8037ac
  8000b9:	e8 25 1a 00 00       	call   801ae3 <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 32 1a 00 00       	call   801b01 <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 10 27 00 00       	push   $0x2710
  8000da:	e8 54 33 00 00       	call   803433 <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e8:	e8 14 1a 00 00       	call   801b01 <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f0:	90                   	nop
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	83 f8 02             	cmp    $0x2,%eax
  8000f9:	75 f6                	jne    8000f1 <_main+0xb9>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fb:	e8 71 17 00 00       	call   801871 <sys_calculate_free_frames>
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	68 b8 37 80 00       	push   $0x8037b8
  800109:	e8 74 04 00 00       	call   800582 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 e8             	pushl  -0x18(%ebp)
  800117:	e8 01 1a 00 00       	call   801b1d <sys_destroy_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 f3 19 00 00       	call   801b1d <sys_destroy_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80012d:	e8 3f 17 00 00       	call   801871 <sys_calculate_free_frames>
  800132:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800135:	e8 d7 17 00 00       	call   801911 <sys_pf_calculate_allocated_pages>
  80013a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80013d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800143:	74 27                	je     80016c <_main+0x134>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 e0             	pushl  -0x20(%ebp)
  80014b:	68 ec 37 80 00       	push   $0x8037ec
  800150:	e8 2d 04 00 00       	call   800582 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 3c 38 80 00       	push   $0x80383c
  800160:	6a 23                	push   $0x23
  800162:	68 72 38 80 00       	push   $0x803872
  800167:	e8 62 01 00 00       	call   8002ce <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 e0             	pushl  -0x20(%ebp)
  800172:	68 88 38 80 00       	push   $0x803888
  800177:	e8 06 04 00 00       	call   800582 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 e8 38 80 00       	push   $0x8038e8
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
  800198:	e8 b4 19 00 00       	call   801b51 <sys_getenvindex>
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
  800203:	e8 56 17 00 00       	call   80195e <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 4c 39 80 00       	push   $0x80394c
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
  800233:	68 74 39 80 00       	push   $0x803974
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
  800264:	68 9c 39 80 00       	push   $0x80399c
  800269:	e8 14 03 00 00       	call   800582 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 50 80 00       	mov    0x805020,%eax
  800276:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 f4 39 80 00       	push   $0x8039f4
  800285:	e8 f8 02 00 00       	call   800582 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 4c 39 80 00       	push   $0x80394c
  800295:	e8 e8 02 00 00       	call   800582 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029d:	e8 d6 16 00 00       	call   801978 <sys_enable_interrupt>

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
  8002b5:	e8 63 18 00 00       	call   801b1d <sys_destroy_env>
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
  8002c6:	e8 b8 18 00 00       	call   801b83 <sys_exit_env>
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
  8002ef:	68 08 3a 80 00       	push   $0x803a08
  8002f4:	e8 89 02 00 00       	call   800582 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fc:	a1 00 50 80 00       	mov    0x805000,%eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	50                   	push   %eax
  800308:	68 0d 3a 80 00       	push   $0x803a0d
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
  80032c:	68 29 3a 80 00       	push   $0x803a29
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
  800358:	68 2c 3a 80 00       	push   $0x803a2c
  80035d:	6a 26                	push   $0x26
  80035f:	68 78 3a 80 00       	push   $0x803a78
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
  80042a:	68 84 3a 80 00       	push   $0x803a84
  80042f:	6a 3a                	push   $0x3a
  800431:	68 78 3a 80 00       	push   $0x803a78
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
  80049a:	68 d8 3a 80 00       	push   $0x803ad8
  80049f:	6a 44                	push   $0x44
  8004a1:	68 78 3a 80 00       	push   $0x803a78
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
  8004f4:	e8 b7 12 00 00       	call   8017b0 <sys_cputs>
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
  80056b:	e8 40 12 00 00       	call   8017b0 <sys_cputs>
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
  8005b5:	e8 a4 13 00 00       	call   80195e <sys_disable_interrupt>
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
  8005d5:	e8 9e 13 00 00       	call   801978 <sys_enable_interrupt>
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
  80061f:	e8 c4 2e 00 00       	call   8034e8 <__udivdi3>
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
  80066f:	e8 84 2f 00 00       	call   8035f8 <__umoddi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	05 54 3d 80 00       	add    $0x803d54,%eax
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
  8007ca:	8b 04 85 78 3d 80 00 	mov    0x803d78(,%eax,4),%eax
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
  8008ab:	8b 34 9d c0 3b 80 00 	mov    0x803bc0(,%ebx,4),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 19                	jne    8008cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b6:	53                   	push   %ebx
  8008b7:	68 65 3d 80 00       	push   $0x803d65
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
  8008d0:	68 6e 3d 80 00       	push   $0x803d6e
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
  8008fd:	be 71 3d 80 00       	mov    $0x803d71,%esi
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
  801323:	68 d0 3e 80 00       	push   $0x803ed0
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
  8013f3:	e8 fc 04 00 00       	call   8018f4 <sys_allocate_chunk>
  8013f8:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013fb:	a1 20 51 80 00       	mov    0x805120,%eax
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	50                   	push   %eax
  801404:	e8 71 0b 00 00       	call   801f7a <initialize_MemBlocksList>
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
  801431:	68 f5 3e 80 00       	push   $0x803ef5
  801436:	6a 33                	push   $0x33
  801438:	68 13 3f 80 00       	push   $0x803f13
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
  8014b0:	68 20 3f 80 00       	push   $0x803f20
  8014b5:	6a 34                	push   $0x34
  8014b7:	68 13 3f 80 00       	push   $0x803f13
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
  801548:	e8 75 07 00 00       	call   801cc2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80154d:	85 c0                	test   %eax,%eax
  80154f:	74 11                	je     801562 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801551:	83 ec 0c             	sub    $0xc,%esp
  801554:	ff 75 e8             	pushl  -0x18(%ebp)
  801557:	e8 e0 0d 00 00       	call   80233c <alloc_block_FF>
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
  80156e:	e8 3c 0b 00 00       	call   8020af <insert_sorted_allocList>
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
  80158e:	68 44 3f 80 00       	push   $0x803f44
  801593:	6a 6f                	push   $0x6f
  801595:	68 13 3f 80 00       	push   $0x803f13
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
  8015b4:	75 0a                	jne    8015c0 <smalloc+0x21>
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bb:	e9 8b 00 00 00       	jmp    80164b <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015c0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cd:	01 d0                	add    %edx,%eax
  8015cf:	48                   	dec    %eax
  8015d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015db:	f7 75 f0             	divl   -0x10(%ebp)
  8015de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e1:	29 d0                	sub    %edx,%eax
  8015e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015e6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015ed:	e8 d0 06 00 00       	call   801cc2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	74 11                	je     801607 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8015f6:	83 ec 0c             	sub    $0xc,%esp
  8015f9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015fc:	e8 3b 0d 00 00       	call   80233c <alloc_block_FF>
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80160b:	74 39                	je     801646 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80160d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801610:	8b 40 08             	mov    0x8(%eax),%eax
  801613:	89 c2                	mov    %eax,%edx
  801615:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801619:	52                   	push   %edx
  80161a:	50                   	push   %eax
  80161b:	ff 75 0c             	pushl  0xc(%ebp)
  80161e:	ff 75 08             	pushl  0x8(%ebp)
  801621:	e8 21 04 00 00       	call   801a47 <sys_createSharedObject>
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80162c:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801630:	74 14                	je     801646 <smalloc+0xa7>
  801632:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801636:	74 0e                	je     801646 <smalloc+0xa7>
  801638:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80163c:	74 08                	je     801646 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801641:	8b 40 08             	mov    0x8(%eax),%eax
  801644:	eb 05                	jmp    80164b <smalloc+0xac>
	}
	return NULL;
  801646:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801653:	e8 b4 fc ff ff       	call   80130c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801658:	83 ec 08             	sub    $0x8,%esp
  80165b:	ff 75 0c             	pushl  0xc(%ebp)
  80165e:	ff 75 08             	pushl  0x8(%ebp)
  801661:	e8 0b 04 00 00       	call   801a71 <sys_getSizeOfSharedObject>
  801666:	83 c4 10             	add    $0x10,%esp
  801669:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80166c:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801670:	74 76                	je     8016e8 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801672:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801679:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80167c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167f:	01 d0                	add    %edx,%eax
  801681:	48                   	dec    %eax
  801682:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801685:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801688:	ba 00 00 00 00       	mov    $0x0,%edx
  80168d:	f7 75 ec             	divl   -0x14(%ebp)
  801690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801693:	29 d0                	sub    %edx,%eax
  801695:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801698:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80169f:	e8 1e 06 00 00       	call   801cc2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016a4:	85 c0                	test   %eax,%eax
  8016a6:	74 11                	je     8016b9 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8016a8:	83 ec 0c             	sub    $0xc,%esp
  8016ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016ae:	e8 89 0c 00 00       	call   80233c <alloc_block_FF>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8016b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016bd:	74 29                	je     8016e8 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8016bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c2:	8b 40 08             	mov    0x8(%eax),%eax
  8016c5:	83 ec 04             	sub    $0x4,%esp
  8016c8:	50                   	push   %eax
  8016c9:	ff 75 0c             	pushl  0xc(%ebp)
  8016cc:	ff 75 08             	pushl  0x8(%ebp)
  8016cf:	e8 ba 03 00 00       	call   801a8e <sys_getSharedObject>
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8016da:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8016de:	74 08                	je     8016e8 <sget+0x9b>
				return (void *)mem_block->sva;
  8016e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e3:	8b 40 08             	mov    0x8(%eax),%eax
  8016e6:	eb 05                	jmp    8016ed <sget+0xa0>
		}
	}
	return (void *)NULL;
  8016e8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016f5:	e8 12 fc ff ff       	call   80130c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	68 68 3f 80 00       	push   $0x803f68
  801702:	68 f1 00 00 00       	push   $0xf1
  801707:	68 13 3f 80 00       	push   $0x803f13
  80170c:	e8 bd eb ff ff       	call   8002ce <_panic>

00801711 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	68 90 3f 80 00       	push   $0x803f90
  80171f:	68 05 01 00 00       	push   $0x105
  801724:	68 13 3f 80 00       	push   $0x803f13
  801729:	e8 a0 eb ff ff       	call   8002ce <_panic>

0080172e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801734:	83 ec 04             	sub    $0x4,%esp
  801737:	68 b4 3f 80 00       	push   $0x803fb4
  80173c:	68 10 01 00 00       	push   $0x110
  801741:	68 13 3f 80 00       	push   $0x803f13
  801746:	e8 83 eb ff ff       	call   8002ce <_panic>

0080174b <shrink>:

}
void shrink(uint32 newSize)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801751:	83 ec 04             	sub    $0x4,%esp
  801754:	68 b4 3f 80 00       	push   $0x803fb4
  801759:	68 15 01 00 00       	push   $0x115
  80175e:	68 13 3f 80 00       	push   $0x803f13
  801763:	e8 66 eb ff ff       	call   8002ce <_panic>

00801768 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80176e:	83 ec 04             	sub    $0x4,%esp
  801771:	68 b4 3f 80 00       	push   $0x803fb4
  801776:	68 1a 01 00 00       	push   $0x11a
  80177b:	68 13 3f 80 00       	push   $0x803f13
  801780:	e8 49 eb ff ff       	call   8002ce <_panic>

00801785 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	57                   	push   %edi
  801789:	56                   	push   %esi
  80178a:	53                   	push   %ebx
  80178b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	8b 55 0c             	mov    0xc(%ebp),%edx
  801794:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801797:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80179a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80179d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017a0:	cd 30                	int    $0x30
  8017a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	5b                   	pop    %ebx
  8017ac:	5e                   	pop    %esi
  8017ad:	5f                   	pop    %edi
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017bc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	52                   	push   %edx
  8017c8:	ff 75 0c             	pushl  0xc(%ebp)
  8017cb:	50                   	push   %eax
  8017cc:	6a 00                	push   $0x0
  8017ce:	e8 b2 ff ff ff       	call   801785 <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
}
  8017d6:	90                   	nop
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 01                	push   $0x1
  8017e8:	e8 98 ff ff ff       	call   801785 <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	52                   	push   %edx
  801802:	50                   	push   %eax
  801803:	6a 05                	push   $0x5
  801805:	e8 7b ff ff ff       	call   801785 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	56                   	push   %esi
  801813:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801814:	8b 75 18             	mov    0x18(%ebp),%esi
  801817:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80181a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	56                   	push   %esi
  801824:	53                   	push   %ebx
  801825:	51                   	push   %ecx
  801826:	52                   	push   %edx
  801827:	50                   	push   %eax
  801828:	6a 06                	push   $0x6
  80182a:	e8 56 ff ff ff       	call   801785 <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
}
  801832:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801835:	5b                   	pop    %ebx
  801836:	5e                   	pop    %esi
  801837:	5d                   	pop    %ebp
  801838:	c3                   	ret    

00801839 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80183c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	52                   	push   %edx
  801849:	50                   	push   %eax
  80184a:	6a 07                	push   $0x7
  80184c:	e8 34 ff ff ff       	call   801785 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	ff 75 08             	pushl  0x8(%ebp)
  801865:	6a 08                	push   $0x8
  801867:	e8 19 ff ff ff       	call   801785 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 09                	push   $0x9
  801880:	e8 00 ff ff ff       	call   801785 <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 0a                	push   $0xa
  801899:	e8 e7 fe ff ff       	call   801785 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 0b                	push   $0xb
  8018b2:	e8 ce fe ff ff       	call   801785 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	6a 0f                	push   $0xf
  8018cd:	e8 b3 fe ff ff       	call   801785 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return;
  8018d5:	90                   	nop
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	ff 75 0c             	pushl  0xc(%ebp)
  8018e4:	ff 75 08             	pushl  0x8(%ebp)
  8018e7:	6a 10                	push   $0x10
  8018e9:	e8 97 fe ff ff       	call   801785 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f1:	90                   	nop
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	ff 75 10             	pushl  0x10(%ebp)
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	ff 75 08             	pushl  0x8(%ebp)
  801904:	6a 11                	push   $0x11
  801906:	e8 7a fe ff ff       	call   801785 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
	return ;
  80190e:	90                   	nop
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 0c                	push   $0xc
  801920:	e8 60 fe ff ff       	call   801785 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	ff 75 08             	pushl  0x8(%ebp)
  801938:	6a 0d                	push   $0xd
  80193a:	e8 46 fe ff ff       	call   801785 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 0e                	push   $0xe
  801953:	e8 2d fe ff ff       	call   801785 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	90                   	nop
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 13                	push   $0x13
  80196d:	e8 13 fe ff ff       	call   801785 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	90                   	nop
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 14                	push   $0x14
  801987:	e8 f9 fd ff ff       	call   801785 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	90                   	nop
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_cputc>:


void
sys_cputc(const char c)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 04             	sub    $0x4,%esp
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80199e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	50                   	push   %eax
  8019ab:	6a 15                	push   $0x15
  8019ad:	e8 d3 fd ff ff       	call   801785 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	90                   	nop
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 16                	push   $0x16
  8019c7:	e8 b9 fd ff ff       	call   801785 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	50                   	push   %eax
  8019e2:	6a 17                	push   $0x17
  8019e4:	e8 9c fd ff ff       	call   801785 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	52                   	push   %edx
  8019fe:	50                   	push   %eax
  8019ff:	6a 1a                	push   $0x1a
  801a01:	e8 7f fd ff ff       	call   801785 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	52                   	push   %edx
  801a1b:	50                   	push   %eax
  801a1c:	6a 18                	push   $0x18
  801a1e:	e8 62 fd ff ff       	call   801785 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	90                   	nop
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	52                   	push   %edx
  801a39:	50                   	push   %eax
  801a3a:	6a 19                	push   $0x19
  801a3c:	e8 44 fd ff ff       	call   801785 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	90                   	nop
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 04             	sub    $0x4,%esp
  801a4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a50:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a53:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a56:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	6a 00                	push   $0x0
  801a5f:	51                   	push   %ecx
  801a60:	52                   	push   %edx
  801a61:	ff 75 0c             	pushl  0xc(%ebp)
  801a64:	50                   	push   %eax
  801a65:	6a 1b                	push   $0x1b
  801a67:	e8 19 fd ff ff       	call   801785 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a77:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	52                   	push   %edx
  801a81:	50                   	push   %eax
  801a82:	6a 1c                	push   $0x1c
  801a84:	e8 fc fc ff ff       	call   801785 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	51                   	push   %ecx
  801a9f:	52                   	push   %edx
  801aa0:	50                   	push   %eax
  801aa1:	6a 1d                	push   $0x1d
  801aa3:	e8 dd fc ff ff       	call   801785 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	52                   	push   %edx
  801abd:	50                   	push   %eax
  801abe:	6a 1e                	push   $0x1e
  801ac0:	e8 c0 fc ff ff       	call   801785 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 1f                	push   $0x1f
  801ad9:	e8 a7 fc ff ff       	call   801785 <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	6a 00                	push   $0x0
  801aeb:	ff 75 14             	pushl  0x14(%ebp)
  801aee:	ff 75 10             	pushl  0x10(%ebp)
  801af1:	ff 75 0c             	pushl  0xc(%ebp)
  801af4:	50                   	push   %eax
  801af5:	6a 20                	push   $0x20
  801af7:	e8 89 fc ff ff       	call   801785 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	50                   	push   %eax
  801b10:	6a 21                	push   $0x21
  801b12:	e8 6e fc ff ff       	call   801785 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	90                   	nop
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	50                   	push   %eax
  801b2c:	6a 22                	push   $0x22
  801b2e:	e8 52 fc ff ff       	call   801785 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 02                	push   $0x2
  801b47:	e8 39 fc ff ff       	call   801785 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 03                	push   $0x3
  801b60:	e8 20 fc ff ff       	call   801785 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 04                	push   $0x4
  801b79:	e8 07 fc ff ff       	call   801785 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_exit_env>:


void sys_exit_env(void)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 23                	push   $0x23
  801b92:	e8 ee fb ff ff       	call   801785 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	90                   	nop
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ba3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ba6:	8d 50 04             	lea    0x4(%eax),%edx
  801ba9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	52                   	push   %edx
  801bb3:	50                   	push   %eax
  801bb4:	6a 24                	push   $0x24
  801bb6:	e8 ca fb ff ff       	call   801785 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
	return result;
  801bbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bc7:	89 01                	mov    %eax,(%ecx)
  801bc9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	c9                   	leave  
  801bd0:	c2 04 00             	ret    $0x4

00801bd3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	ff 75 10             	pushl  0x10(%ebp)
  801bdd:	ff 75 0c             	pushl  0xc(%ebp)
  801be0:	ff 75 08             	pushl  0x8(%ebp)
  801be3:	6a 12                	push   $0x12
  801be5:	e8 9b fb ff ff       	call   801785 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
	return ;
  801bed:	90                   	nop
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 25                	push   $0x25
  801bff:	e8 81 fb ff ff       	call   801785 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 04             	sub    $0x4,%esp
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c15:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	50                   	push   %eax
  801c22:	6a 26                	push   $0x26
  801c24:	e8 5c fb ff ff       	call   801785 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2c:	90                   	nop
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <rsttst>:
void rsttst()
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 28                	push   $0x28
  801c3e:	e8 42 fb ff ff       	call   801785 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
	return ;
  801c46:	90                   	nop
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c52:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c55:	8b 55 18             	mov    0x18(%ebp),%edx
  801c58:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c5c:	52                   	push   %edx
  801c5d:	50                   	push   %eax
  801c5e:	ff 75 10             	pushl  0x10(%ebp)
  801c61:	ff 75 0c             	pushl  0xc(%ebp)
  801c64:	ff 75 08             	pushl  0x8(%ebp)
  801c67:	6a 27                	push   $0x27
  801c69:	e8 17 fb ff ff       	call   801785 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c71:	90                   	nop
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <chktst>:
void chktst(uint32 n)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	ff 75 08             	pushl  0x8(%ebp)
  801c82:	6a 29                	push   $0x29
  801c84:	e8 fc fa ff ff       	call   801785 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8c:	90                   	nop
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <inctst>:

void inctst()
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 2a                	push   $0x2a
  801c9e:	e8 e2 fa ff ff       	call   801785 <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca6:	90                   	nop
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <gettst>:
uint32 gettst()
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 2b                	push   $0x2b
  801cb8:	e8 c8 fa ff ff       	call   801785 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 2c                	push   $0x2c
  801cd4:	e8 ac fa ff ff       	call   801785 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
  801cdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cdf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ce3:	75 07                	jne    801cec <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ce5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cea:	eb 05                	jmp    801cf1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 2c                	push   $0x2c
  801d05:	e8 7b fa ff ff       	call   801785 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
  801d0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d10:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d14:	75 07                	jne    801d1d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d16:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1b:	eb 05                	jmp    801d22 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 2c                	push   $0x2c
  801d36:	e8 4a fa ff ff       	call   801785 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
  801d3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d41:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d45:	75 07                	jne    801d4e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d47:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4c:	eb 05                	jmp    801d53 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 2c                	push   $0x2c
  801d67:	e8 19 fa ff ff       	call   801785 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
  801d6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d72:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d76:	75 07                	jne    801d7f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d78:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7d:	eb 05                	jmp    801d84 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	ff 75 08             	pushl  0x8(%ebp)
  801d94:	6a 2d                	push   $0x2d
  801d96:	e8 ea f9 ff ff       	call   801785 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9e:	90                   	nop
}
  801d9f:	c9                   	leave  
  801da0:	c3                   	ret    

00801da1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801da5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801da8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	6a 00                	push   $0x0
  801db3:	53                   	push   %ebx
  801db4:	51                   	push   %ecx
  801db5:	52                   	push   %edx
  801db6:	50                   	push   %eax
  801db7:	6a 2e                	push   $0x2e
  801db9:	e8 c7 f9 ff ff       	call   801785 <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
}
  801dc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	52                   	push   %edx
  801dd6:	50                   	push   %eax
  801dd7:	6a 2f                	push   $0x2f
  801dd9:	e8 a7 f9 ff ff       	call   801785 <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801de9:	83 ec 0c             	sub    $0xc,%esp
  801dec:	68 c4 3f 80 00       	push   $0x803fc4
  801df1:	e8 8c e7 ff ff       	call   800582 <cprintf>
  801df6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801df9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	68 f0 3f 80 00       	push   $0x803ff0
  801e08:	e8 75 e7 ff ff       	call   800582 <cprintf>
  801e0d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e10:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e14:	a1 38 51 80 00       	mov    0x805138,%eax
  801e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e1c:	eb 56                	jmp    801e74 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e22:	74 1c                	je     801e40 <print_mem_block_lists+0x5d>
  801e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e27:	8b 50 08             	mov    0x8(%eax),%edx
  801e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2d:	8b 48 08             	mov    0x8(%eax),%ecx
  801e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e33:	8b 40 0c             	mov    0xc(%eax),%eax
  801e36:	01 c8                	add    %ecx,%eax
  801e38:	39 c2                	cmp    %eax,%edx
  801e3a:	73 04                	jae    801e40 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e3c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e43:	8b 50 08             	mov    0x8(%eax),%edx
  801e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e49:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4c:	01 c2                	add    %eax,%edx
  801e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e51:	8b 40 08             	mov    0x8(%eax),%eax
  801e54:	83 ec 04             	sub    $0x4,%esp
  801e57:	52                   	push   %edx
  801e58:	50                   	push   %eax
  801e59:	68 05 40 80 00       	push   $0x804005
  801e5e:	e8 1f e7 ff ff       	call   800582 <cprintf>
  801e63:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e6c:	a1 40 51 80 00       	mov    0x805140,%eax
  801e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e78:	74 07                	je     801e81 <print_mem_block_lists+0x9e>
  801e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7d:	8b 00                	mov    (%eax),%eax
  801e7f:	eb 05                	jmp    801e86 <print_mem_block_lists+0xa3>
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
  801e86:	a3 40 51 80 00       	mov    %eax,0x805140
  801e8b:	a1 40 51 80 00       	mov    0x805140,%eax
  801e90:	85 c0                	test   %eax,%eax
  801e92:	75 8a                	jne    801e1e <print_mem_block_lists+0x3b>
  801e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e98:	75 84                	jne    801e1e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e9a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e9e:	75 10                	jne    801eb0 <print_mem_block_lists+0xcd>
  801ea0:	83 ec 0c             	sub    $0xc,%esp
  801ea3:	68 14 40 80 00       	push   $0x804014
  801ea8:	e8 d5 e6 ff ff       	call   800582 <cprintf>
  801ead:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801eb0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801eb7:	83 ec 0c             	sub    $0xc,%esp
  801eba:	68 38 40 80 00       	push   $0x804038
  801ebf:	e8 be e6 ff ff       	call   800582 <cprintf>
  801ec4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ec7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ecb:	a1 40 50 80 00       	mov    0x805040,%eax
  801ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed3:	eb 56                	jmp    801f2b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ed5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed9:	74 1c                	je     801ef7 <print_mem_block_lists+0x114>
  801edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ede:	8b 50 08             	mov    0x8(%eax),%edx
  801ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee4:	8b 48 08             	mov    0x8(%eax),%ecx
  801ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eea:	8b 40 0c             	mov    0xc(%eax),%eax
  801eed:	01 c8                	add    %ecx,%eax
  801eef:	39 c2                	cmp    %eax,%edx
  801ef1:	73 04                	jae    801ef7 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ef3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	8b 50 08             	mov    0x8(%eax),%edx
  801efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f00:	8b 40 0c             	mov    0xc(%eax),%eax
  801f03:	01 c2                	add    %eax,%edx
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	8b 40 08             	mov    0x8(%eax),%eax
  801f0b:	83 ec 04             	sub    $0x4,%esp
  801f0e:	52                   	push   %edx
  801f0f:	50                   	push   %eax
  801f10:	68 05 40 80 00       	push   $0x804005
  801f15:	e8 68 e6 ff ff       	call   800582 <cprintf>
  801f1a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f23:	a1 48 50 80 00       	mov    0x805048,%eax
  801f28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2f:	74 07                	je     801f38 <print_mem_block_lists+0x155>
  801f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f34:	8b 00                	mov    (%eax),%eax
  801f36:	eb 05                	jmp    801f3d <print_mem_block_lists+0x15a>
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3d:	a3 48 50 80 00       	mov    %eax,0x805048
  801f42:	a1 48 50 80 00       	mov    0x805048,%eax
  801f47:	85 c0                	test   %eax,%eax
  801f49:	75 8a                	jne    801ed5 <print_mem_block_lists+0xf2>
  801f4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4f:	75 84                	jne    801ed5 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f51:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f55:	75 10                	jne    801f67 <print_mem_block_lists+0x184>
  801f57:	83 ec 0c             	sub    $0xc,%esp
  801f5a:	68 50 40 80 00       	push   $0x804050
  801f5f:	e8 1e e6 ff ff       	call   800582 <cprintf>
  801f64:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f67:	83 ec 0c             	sub    $0xc,%esp
  801f6a:	68 c4 3f 80 00       	push   $0x803fc4
  801f6f:	e8 0e e6 ff ff       	call   800582 <cprintf>
  801f74:	83 c4 10             	add    $0x10,%esp

}
  801f77:	90                   	nop
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f80:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f87:	00 00 00 
  801f8a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f91:	00 00 00 
  801f94:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f9b:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fa5:	e9 9e 00 00 00       	jmp    802048 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801faa:	a1 50 50 80 00       	mov    0x805050,%eax
  801faf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb2:	c1 e2 04             	shl    $0x4,%edx
  801fb5:	01 d0                	add    %edx,%eax
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	75 14                	jne    801fcf <initialize_MemBlocksList+0x55>
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	68 78 40 80 00       	push   $0x804078
  801fc3:	6a 46                	push   $0x46
  801fc5:	68 9b 40 80 00       	push   $0x80409b
  801fca:	e8 ff e2 ff ff       	call   8002ce <_panic>
  801fcf:	a1 50 50 80 00       	mov    0x805050,%eax
  801fd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd7:	c1 e2 04             	shl    $0x4,%edx
  801fda:	01 d0                	add    %edx,%eax
  801fdc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fe2:	89 10                	mov    %edx,(%eax)
  801fe4:	8b 00                	mov    (%eax),%eax
  801fe6:	85 c0                	test   %eax,%eax
  801fe8:	74 18                	je     802002 <initialize_MemBlocksList+0x88>
  801fea:	a1 48 51 80 00       	mov    0x805148,%eax
  801fef:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801ff5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ff8:	c1 e1 04             	shl    $0x4,%ecx
  801ffb:	01 ca                	add    %ecx,%edx
  801ffd:	89 50 04             	mov    %edx,0x4(%eax)
  802000:	eb 12                	jmp    802014 <initialize_MemBlocksList+0x9a>
  802002:	a1 50 50 80 00       	mov    0x805050,%eax
  802007:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200a:	c1 e2 04             	shl    $0x4,%edx
  80200d:	01 d0                	add    %edx,%eax
  80200f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802014:	a1 50 50 80 00       	mov    0x805050,%eax
  802019:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201c:	c1 e2 04             	shl    $0x4,%edx
  80201f:	01 d0                	add    %edx,%eax
  802021:	a3 48 51 80 00       	mov    %eax,0x805148
  802026:	a1 50 50 80 00       	mov    0x805050,%eax
  80202b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202e:	c1 e2 04             	shl    $0x4,%edx
  802031:	01 d0                	add    %edx,%eax
  802033:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80203a:	a1 54 51 80 00       	mov    0x805154,%eax
  80203f:	40                   	inc    %eax
  802040:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802045:	ff 45 f4             	incl   -0xc(%ebp)
  802048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80204e:	0f 82 56 ff ff ff    	jb     801faa <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802054:	90                   	nop
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	8b 00                	mov    (%eax),%eax
  802062:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802065:	eb 19                	jmp    802080 <find_block+0x29>
	{
		if(va==point->sva)
  802067:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206a:	8b 40 08             	mov    0x8(%eax),%eax
  80206d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802070:	75 05                	jne    802077 <find_block+0x20>
		   return point;
  802072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802075:	eb 36                	jmp    8020ad <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	8b 40 08             	mov    0x8(%eax),%eax
  80207d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802080:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802084:	74 07                	je     80208d <find_block+0x36>
  802086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802089:	8b 00                	mov    (%eax),%eax
  80208b:	eb 05                	jmp    802092 <find_block+0x3b>
  80208d:	b8 00 00 00 00       	mov    $0x0,%eax
  802092:	8b 55 08             	mov    0x8(%ebp),%edx
  802095:	89 42 08             	mov    %eax,0x8(%edx)
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	8b 40 08             	mov    0x8(%eax),%eax
  80209e:	85 c0                	test   %eax,%eax
  8020a0:	75 c5                	jne    802067 <find_block+0x10>
  8020a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020a6:	75 bf                	jne    802067 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020b5:	a1 40 50 80 00       	mov    0x805040,%eax
  8020ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020bd:	a1 44 50 80 00       	mov    0x805044,%eax
  8020c2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020cb:	74 24                	je     8020f1 <insert_sorted_allocList+0x42>
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	8b 50 08             	mov    0x8(%eax),%edx
  8020d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d6:	8b 40 08             	mov    0x8(%eax),%eax
  8020d9:	39 c2                	cmp    %eax,%edx
  8020db:	76 14                	jbe    8020f1 <insert_sorted_allocList+0x42>
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	8b 50 08             	mov    0x8(%eax),%edx
  8020e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e6:	8b 40 08             	mov    0x8(%eax),%eax
  8020e9:	39 c2                	cmp    %eax,%edx
  8020eb:	0f 82 60 01 00 00    	jb     802251 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020f5:	75 65                	jne    80215c <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020fb:	75 14                	jne    802111 <insert_sorted_allocList+0x62>
  8020fd:	83 ec 04             	sub    $0x4,%esp
  802100:	68 78 40 80 00       	push   $0x804078
  802105:	6a 6b                	push   $0x6b
  802107:	68 9b 40 80 00       	push   $0x80409b
  80210c:	e8 bd e1 ff ff       	call   8002ce <_panic>
  802111:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	89 10                	mov    %edx,(%eax)
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	8b 00                	mov    (%eax),%eax
  802121:	85 c0                	test   %eax,%eax
  802123:	74 0d                	je     802132 <insert_sorted_allocList+0x83>
  802125:	a1 40 50 80 00       	mov    0x805040,%eax
  80212a:	8b 55 08             	mov    0x8(%ebp),%edx
  80212d:	89 50 04             	mov    %edx,0x4(%eax)
  802130:	eb 08                	jmp    80213a <insert_sorted_allocList+0x8b>
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	a3 44 50 80 00       	mov    %eax,0x805044
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	a3 40 50 80 00       	mov    %eax,0x805040
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80214c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802151:	40                   	inc    %eax
  802152:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802157:	e9 dc 01 00 00       	jmp    802338 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	8b 50 08             	mov    0x8(%eax),%edx
  802162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802165:	8b 40 08             	mov    0x8(%eax),%eax
  802168:	39 c2                	cmp    %eax,%edx
  80216a:	77 6c                	ja     8021d8 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80216c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802170:	74 06                	je     802178 <insert_sorted_allocList+0xc9>
  802172:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802176:	75 14                	jne    80218c <insert_sorted_allocList+0xdd>
  802178:	83 ec 04             	sub    $0x4,%esp
  80217b:	68 b4 40 80 00       	push   $0x8040b4
  802180:	6a 6f                	push   $0x6f
  802182:	68 9b 40 80 00       	push   $0x80409b
  802187:	e8 42 e1 ff ff       	call   8002ce <_panic>
  80218c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218f:	8b 50 04             	mov    0x4(%eax),%edx
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	89 50 04             	mov    %edx,0x4(%eax)
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80219e:	89 10                	mov    %edx,(%eax)
  8021a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a3:	8b 40 04             	mov    0x4(%eax),%eax
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	74 0d                	je     8021b7 <insert_sorted_allocList+0x108>
  8021aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ad:	8b 40 04             	mov    0x4(%eax),%eax
  8021b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b3:	89 10                	mov    %edx,(%eax)
  8021b5:	eb 08                	jmp    8021bf <insert_sorted_allocList+0x110>
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	a3 40 50 80 00       	mov    %eax,0x805040
  8021bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c5:	89 50 04             	mov    %edx,0x4(%eax)
  8021c8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021cd:	40                   	inc    %eax
  8021ce:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021d3:	e9 60 01 00 00       	jmp    802338 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	8b 50 08             	mov    0x8(%eax),%edx
  8021de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e1:	8b 40 08             	mov    0x8(%eax),%eax
  8021e4:	39 c2                	cmp    %eax,%edx
  8021e6:	0f 82 4c 01 00 00    	jb     802338 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f0:	75 14                	jne    802206 <insert_sorted_allocList+0x157>
  8021f2:	83 ec 04             	sub    $0x4,%esp
  8021f5:	68 ec 40 80 00       	push   $0x8040ec
  8021fa:	6a 73                	push   $0x73
  8021fc:	68 9b 40 80 00       	push   $0x80409b
  802201:	e8 c8 e0 ff ff       	call   8002ce <_panic>
  802206:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	89 50 04             	mov    %edx,0x4(%eax)
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	8b 40 04             	mov    0x4(%eax),%eax
  802218:	85 c0                	test   %eax,%eax
  80221a:	74 0c                	je     802228 <insert_sorted_allocList+0x179>
  80221c:	a1 44 50 80 00       	mov    0x805044,%eax
  802221:	8b 55 08             	mov    0x8(%ebp),%edx
  802224:	89 10                	mov    %edx,(%eax)
  802226:	eb 08                	jmp    802230 <insert_sorted_allocList+0x181>
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	a3 40 50 80 00       	mov    %eax,0x805040
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	a3 44 50 80 00       	mov    %eax,0x805044
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802241:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802246:	40                   	inc    %eax
  802247:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80224c:	e9 e7 00 00 00       	jmp    802338 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802254:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802257:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80225e:	a1 40 50 80 00       	mov    0x805040,%eax
  802263:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802266:	e9 9d 00 00 00       	jmp    802308 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 00                	mov    (%eax),%eax
  802270:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	8b 50 08             	mov    0x8(%eax),%edx
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	8b 40 08             	mov    0x8(%eax),%eax
  80227f:	39 c2                	cmp    %eax,%edx
  802281:	76 7d                	jbe    802300 <insert_sorted_allocList+0x251>
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	8b 50 08             	mov    0x8(%eax),%edx
  802289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80228c:	8b 40 08             	mov    0x8(%eax),%eax
  80228f:	39 c2                	cmp    %eax,%edx
  802291:	73 6d                	jae    802300 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802293:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802297:	74 06                	je     80229f <insert_sorted_allocList+0x1f0>
  802299:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229d:	75 14                	jne    8022b3 <insert_sorted_allocList+0x204>
  80229f:	83 ec 04             	sub    $0x4,%esp
  8022a2:	68 10 41 80 00       	push   $0x804110
  8022a7:	6a 7f                	push   $0x7f
  8022a9:	68 9b 40 80 00       	push   $0x80409b
  8022ae:	e8 1b e0 ff ff       	call   8002ce <_panic>
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 10                	mov    (%eax),%edx
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	89 10                	mov    %edx,(%eax)
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	8b 00                	mov    (%eax),%eax
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	74 0b                	je     8022d1 <insert_sorted_allocList+0x222>
  8022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ce:	89 50 04             	mov    %edx,0x4(%eax)
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d7:	89 10                	mov    %edx,(%eax)
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022df:	89 50 04             	mov    %edx,0x4(%eax)
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	8b 00                	mov    (%eax),%eax
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	75 08                	jne    8022f3 <insert_sorted_allocList+0x244>
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	a3 44 50 80 00       	mov    %eax,0x805044
  8022f3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022f8:	40                   	inc    %eax
  8022f9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022fe:	eb 39                	jmp    802339 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802300:	a1 48 50 80 00       	mov    0x805048,%eax
  802305:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802308:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230c:	74 07                	je     802315 <insert_sorted_allocList+0x266>
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 00                	mov    (%eax),%eax
  802313:	eb 05                	jmp    80231a <insert_sorted_allocList+0x26b>
  802315:	b8 00 00 00 00       	mov    $0x0,%eax
  80231a:	a3 48 50 80 00       	mov    %eax,0x805048
  80231f:	a1 48 50 80 00       	mov    0x805048,%eax
  802324:	85 c0                	test   %eax,%eax
  802326:	0f 85 3f ff ff ff    	jne    80226b <insert_sorted_allocList+0x1bc>
  80232c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802330:	0f 85 35 ff ff ff    	jne    80226b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802336:	eb 01                	jmp    802339 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802338:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802339:	90                   	nop
  80233a:	c9                   	leave  
  80233b:	c3                   	ret    

0080233c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80233c:	55                   	push   %ebp
  80233d:	89 e5                	mov    %esp,%ebp
  80233f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802342:	a1 38 51 80 00       	mov    0x805138,%eax
  802347:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234a:	e9 85 01 00 00       	jmp    8024d4 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 40 0c             	mov    0xc(%eax),%eax
  802355:	3b 45 08             	cmp    0x8(%ebp),%eax
  802358:	0f 82 6e 01 00 00    	jb     8024cc <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	8b 40 0c             	mov    0xc(%eax),%eax
  802364:	3b 45 08             	cmp    0x8(%ebp),%eax
  802367:	0f 85 8a 00 00 00    	jne    8023f7 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80236d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802371:	75 17                	jne    80238a <alloc_block_FF+0x4e>
  802373:	83 ec 04             	sub    $0x4,%esp
  802376:	68 44 41 80 00       	push   $0x804144
  80237b:	68 93 00 00 00       	push   $0x93
  802380:	68 9b 40 80 00       	push   $0x80409b
  802385:	e8 44 df ff ff       	call   8002ce <_panic>
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 00                	mov    (%eax),%eax
  80238f:	85 c0                	test   %eax,%eax
  802391:	74 10                	je     8023a3 <alloc_block_FF+0x67>
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	8b 00                	mov    (%eax),%eax
  802398:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239b:	8b 52 04             	mov    0x4(%edx),%edx
  80239e:	89 50 04             	mov    %edx,0x4(%eax)
  8023a1:	eb 0b                	jmp    8023ae <alloc_block_FF+0x72>
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	8b 40 04             	mov    0x4(%eax),%eax
  8023a9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 40 04             	mov    0x4(%eax),%eax
  8023b4:	85 c0                	test   %eax,%eax
  8023b6:	74 0f                	je     8023c7 <alloc_block_FF+0x8b>
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	8b 40 04             	mov    0x4(%eax),%eax
  8023be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c1:	8b 12                	mov    (%edx),%edx
  8023c3:	89 10                	mov    %edx,(%eax)
  8023c5:	eb 0a                	jmp    8023d1 <alloc_block_FF+0x95>
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 00                	mov    (%eax),%eax
  8023cc:	a3 38 51 80 00       	mov    %eax,0x805138
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e4:	a1 44 51 80 00       	mov    0x805144,%eax
  8023e9:	48                   	dec    %eax
  8023ea:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	e9 10 01 00 00       	jmp    802507 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802400:	0f 86 c6 00 00 00    	jbe    8024cc <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802406:	a1 48 51 80 00       	mov    0x805148,%eax
  80240b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 50 08             	mov    0x8(%eax),%edx
  802414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802417:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80241a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241d:	8b 55 08             	mov    0x8(%ebp),%edx
  802420:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802423:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802427:	75 17                	jne    802440 <alloc_block_FF+0x104>
  802429:	83 ec 04             	sub    $0x4,%esp
  80242c:	68 44 41 80 00       	push   $0x804144
  802431:	68 9b 00 00 00       	push   $0x9b
  802436:	68 9b 40 80 00       	push   $0x80409b
  80243b:	e8 8e de ff ff       	call   8002ce <_panic>
  802440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802443:	8b 00                	mov    (%eax),%eax
  802445:	85 c0                	test   %eax,%eax
  802447:	74 10                	je     802459 <alloc_block_FF+0x11d>
  802449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802451:	8b 52 04             	mov    0x4(%edx),%edx
  802454:	89 50 04             	mov    %edx,0x4(%eax)
  802457:	eb 0b                	jmp    802464 <alloc_block_FF+0x128>
  802459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245c:	8b 40 04             	mov    0x4(%eax),%eax
  80245f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802467:	8b 40 04             	mov    0x4(%eax),%eax
  80246a:	85 c0                	test   %eax,%eax
  80246c:	74 0f                	je     80247d <alloc_block_FF+0x141>
  80246e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802471:	8b 40 04             	mov    0x4(%eax),%eax
  802474:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802477:	8b 12                	mov    (%edx),%edx
  802479:	89 10                	mov    %edx,(%eax)
  80247b:	eb 0a                	jmp    802487 <alloc_block_FF+0x14b>
  80247d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	a3 48 51 80 00       	mov    %eax,0x805148
  802487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802493:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80249a:	a1 54 51 80 00       	mov    0x805154,%eax
  80249f:	48                   	dec    %eax
  8024a0:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	8b 50 08             	mov    0x8(%eax),%edx
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	01 c2                	add    %eax,%edx
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8024bf:	89 c2                	mov    %eax,%edx
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ca:	eb 3b                	jmp    802507 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024cc:	a1 40 51 80 00       	mov    0x805140,%eax
  8024d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d8:	74 07                	je     8024e1 <alloc_block_FF+0x1a5>
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 00                	mov    (%eax),%eax
  8024df:	eb 05                	jmp    8024e6 <alloc_block_FF+0x1aa>
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e6:	a3 40 51 80 00       	mov    %eax,0x805140
  8024eb:	a1 40 51 80 00       	mov    0x805140,%eax
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	0f 85 57 fe ff ff    	jne    80234f <alloc_block_FF+0x13>
  8024f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fc:	0f 85 4d fe ff ff    	jne    80234f <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802502:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80250f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802516:	a1 38 51 80 00       	mov    0x805138,%eax
  80251b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80251e:	e9 df 00 00 00       	jmp    802602 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 40 0c             	mov    0xc(%eax),%eax
  802529:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252c:	0f 82 c8 00 00 00    	jb     8025fa <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 40 0c             	mov    0xc(%eax),%eax
  802538:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253b:	0f 85 8a 00 00 00    	jne    8025cb <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802541:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802545:	75 17                	jne    80255e <alloc_block_BF+0x55>
  802547:	83 ec 04             	sub    $0x4,%esp
  80254a:	68 44 41 80 00       	push   $0x804144
  80254f:	68 b7 00 00 00       	push   $0xb7
  802554:	68 9b 40 80 00       	push   $0x80409b
  802559:	e8 70 dd ff ff       	call   8002ce <_panic>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 00                	mov    (%eax),%eax
  802563:	85 c0                	test   %eax,%eax
  802565:	74 10                	je     802577 <alloc_block_BF+0x6e>
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	8b 00                	mov    (%eax),%eax
  80256c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256f:	8b 52 04             	mov    0x4(%edx),%edx
  802572:	89 50 04             	mov    %edx,0x4(%eax)
  802575:	eb 0b                	jmp    802582 <alloc_block_BF+0x79>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 40 04             	mov    0x4(%eax),%eax
  80257d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 40 04             	mov    0x4(%eax),%eax
  802588:	85 c0                	test   %eax,%eax
  80258a:	74 0f                	je     80259b <alloc_block_BF+0x92>
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 40 04             	mov    0x4(%eax),%eax
  802592:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802595:	8b 12                	mov    (%edx),%edx
  802597:	89 10                	mov    %edx,(%eax)
  802599:	eb 0a                	jmp    8025a5 <alloc_block_BF+0x9c>
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 00                	mov    (%eax),%eax
  8025a0:	a3 38 51 80 00       	mov    %eax,0x805138
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b8:	a1 44 51 80 00       	mov    0x805144,%eax
  8025bd:	48                   	dec    %eax
  8025be:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	e9 4d 01 00 00       	jmp    802718 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d4:	76 24                	jbe    8025fa <alloc_block_BF+0xf1>
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025df:	73 19                	jae    8025fa <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025e1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 40 08             	mov    0x8(%eax),%eax
  8025f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802606:	74 07                	je     80260f <alloc_block_BF+0x106>
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 00                	mov    (%eax),%eax
  80260d:	eb 05                	jmp    802614 <alloc_block_BF+0x10b>
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
  802614:	a3 40 51 80 00       	mov    %eax,0x805140
  802619:	a1 40 51 80 00       	mov    0x805140,%eax
  80261e:	85 c0                	test   %eax,%eax
  802620:	0f 85 fd fe ff ff    	jne    802523 <alloc_block_BF+0x1a>
  802626:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262a:	0f 85 f3 fe ff ff    	jne    802523 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802630:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802634:	0f 84 d9 00 00 00    	je     802713 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80263a:	a1 48 51 80 00       	mov    0x805148,%eax
  80263f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802645:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802648:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80264b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264e:	8b 55 08             	mov    0x8(%ebp),%edx
  802651:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802654:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802658:	75 17                	jne    802671 <alloc_block_BF+0x168>
  80265a:	83 ec 04             	sub    $0x4,%esp
  80265d:	68 44 41 80 00       	push   $0x804144
  802662:	68 c7 00 00 00       	push   $0xc7
  802667:	68 9b 40 80 00       	push   $0x80409b
  80266c:	e8 5d dc ff ff       	call   8002ce <_panic>
  802671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802674:	8b 00                	mov    (%eax),%eax
  802676:	85 c0                	test   %eax,%eax
  802678:	74 10                	je     80268a <alloc_block_BF+0x181>
  80267a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267d:	8b 00                	mov    (%eax),%eax
  80267f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802682:	8b 52 04             	mov    0x4(%edx),%edx
  802685:	89 50 04             	mov    %edx,0x4(%eax)
  802688:	eb 0b                	jmp    802695 <alloc_block_BF+0x18c>
  80268a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268d:	8b 40 04             	mov    0x4(%eax),%eax
  802690:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802698:	8b 40 04             	mov    0x4(%eax),%eax
  80269b:	85 c0                	test   %eax,%eax
  80269d:	74 0f                	je     8026ae <alloc_block_BF+0x1a5>
  80269f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a2:	8b 40 04             	mov    0x4(%eax),%eax
  8026a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026a8:	8b 12                	mov    (%edx),%edx
  8026aa:	89 10                	mov    %edx,(%eax)
  8026ac:	eb 0a                	jmp    8026b8 <alloc_block_BF+0x1af>
  8026ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	a3 48 51 80 00       	mov    %eax,0x805148
  8026b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026cb:	a1 54 51 80 00       	mov    0x805154,%eax
  8026d0:	48                   	dec    %eax
  8026d1:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026d6:	83 ec 08             	sub    $0x8,%esp
  8026d9:	ff 75 ec             	pushl  -0x14(%ebp)
  8026dc:	68 38 51 80 00       	push   $0x805138
  8026e1:	e8 71 f9 ff ff       	call   802057 <find_block>
  8026e6:	83 c4 10             	add    $0x10,%esp
  8026e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ef:	8b 50 08             	mov    0x8(%eax),%edx
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	01 c2                	add    %eax,%edx
  8026f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fa:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802700:	8b 40 0c             	mov    0xc(%eax),%eax
  802703:	2b 45 08             	sub    0x8(%ebp),%eax
  802706:	89 c2                	mov    %eax,%edx
  802708:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270b:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80270e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802711:	eb 05                	jmp    802718 <alloc_block_BF+0x20f>
	}
	return NULL;
  802713:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802718:	c9                   	leave  
  802719:	c3                   	ret    

0080271a <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
  80271d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802720:	a1 28 50 80 00       	mov    0x805028,%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	0f 85 de 01 00 00    	jne    80290b <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80272d:	a1 38 51 80 00       	mov    0x805138,%eax
  802732:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802735:	e9 9e 01 00 00       	jmp    8028d8 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 40 0c             	mov    0xc(%eax),%eax
  802740:	3b 45 08             	cmp    0x8(%ebp),%eax
  802743:	0f 82 87 01 00 00    	jb     8028d0 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 40 0c             	mov    0xc(%eax),%eax
  80274f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802752:	0f 85 95 00 00 00    	jne    8027ed <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275c:	75 17                	jne    802775 <alloc_block_NF+0x5b>
  80275e:	83 ec 04             	sub    $0x4,%esp
  802761:	68 44 41 80 00       	push   $0x804144
  802766:	68 e0 00 00 00       	push   $0xe0
  80276b:	68 9b 40 80 00       	push   $0x80409b
  802770:	e8 59 db ff ff       	call   8002ce <_panic>
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 00                	mov    (%eax),%eax
  80277a:	85 c0                	test   %eax,%eax
  80277c:	74 10                	je     80278e <alloc_block_NF+0x74>
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 00                	mov    (%eax),%eax
  802783:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802786:	8b 52 04             	mov    0x4(%edx),%edx
  802789:	89 50 04             	mov    %edx,0x4(%eax)
  80278c:	eb 0b                	jmp    802799 <alloc_block_NF+0x7f>
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 40 04             	mov    0x4(%eax),%eax
  802794:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 04             	mov    0x4(%eax),%eax
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	74 0f                	je     8027b2 <alloc_block_NF+0x98>
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 40 04             	mov    0x4(%eax),%eax
  8027a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ac:	8b 12                	mov    (%edx),%edx
  8027ae:	89 10                	mov    %edx,(%eax)
  8027b0:	eb 0a                	jmp    8027bc <alloc_block_NF+0xa2>
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 00                	mov    (%eax),%eax
  8027b7:	a3 38 51 80 00       	mov    %eax,0x805138
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027cf:	a1 44 51 80 00       	mov    0x805144,%eax
  8027d4:	48                   	dec    %eax
  8027d5:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 40 08             	mov    0x8(%eax),%eax
  8027e0:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	e9 f8 04 00 00       	jmp    802ce5 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f6:	0f 86 d4 00 00 00    	jbe    8028d0 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027fc:	a1 48 51 80 00       	mov    0x805148,%eax
  802801:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 50 08             	mov    0x8(%eax),%edx
  80280a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280d:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802813:	8b 55 08             	mov    0x8(%ebp),%edx
  802816:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802819:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80281d:	75 17                	jne    802836 <alloc_block_NF+0x11c>
  80281f:	83 ec 04             	sub    $0x4,%esp
  802822:	68 44 41 80 00       	push   $0x804144
  802827:	68 e9 00 00 00       	push   $0xe9
  80282c:	68 9b 40 80 00       	push   $0x80409b
  802831:	e8 98 da ff ff       	call   8002ce <_panic>
  802836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802839:	8b 00                	mov    (%eax),%eax
  80283b:	85 c0                	test   %eax,%eax
  80283d:	74 10                	je     80284f <alloc_block_NF+0x135>
  80283f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802847:	8b 52 04             	mov    0x4(%edx),%edx
  80284a:	89 50 04             	mov    %edx,0x4(%eax)
  80284d:	eb 0b                	jmp    80285a <alloc_block_NF+0x140>
  80284f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802852:	8b 40 04             	mov    0x4(%eax),%eax
  802855:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80285a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285d:	8b 40 04             	mov    0x4(%eax),%eax
  802860:	85 c0                	test   %eax,%eax
  802862:	74 0f                	je     802873 <alloc_block_NF+0x159>
  802864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802867:	8b 40 04             	mov    0x4(%eax),%eax
  80286a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80286d:	8b 12                	mov    (%edx),%edx
  80286f:	89 10                	mov    %edx,(%eax)
  802871:	eb 0a                	jmp    80287d <alloc_block_NF+0x163>
  802873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802876:	8b 00                	mov    (%eax),%eax
  802878:	a3 48 51 80 00       	mov    %eax,0x805148
  80287d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802880:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802889:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802890:	a1 54 51 80 00       	mov    0x805154,%eax
  802895:	48                   	dec    %eax
  802896:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80289b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289e:	8b 40 08             	mov    0x8(%eax),%eax
  8028a1:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 50 08             	mov    0x8(%eax),%edx
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	01 c2                	add    %eax,%edx
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bd:	2b 45 08             	sub    0x8(%ebp),%eax
  8028c0:	89 c2                	mov    %eax,%edx
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cb:	e9 15 04 00 00       	jmp    802ce5 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028dc:	74 07                	je     8028e5 <alloc_block_NF+0x1cb>
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	8b 00                	mov    (%eax),%eax
  8028e3:	eb 05                	jmp    8028ea <alloc_block_NF+0x1d0>
  8028e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ea:	a3 40 51 80 00       	mov    %eax,0x805140
  8028ef:	a1 40 51 80 00       	mov    0x805140,%eax
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	0f 85 3e fe ff ff    	jne    80273a <alloc_block_NF+0x20>
  8028fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802900:	0f 85 34 fe ff ff    	jne    80273a <alloc_block_NF+0x20>
  802906:	e9 d5 03 00 00       	jmp    802ce0 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80290b:	a1 38 51 80 00       	mov    0x805138,%eax
  802910:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802913:	e9 b1 01 00 00       	jmp    802ac9 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 50 08             	mov    0x8(%eax),%edx
  80291e:	a1 28 50 80 00       	mov    0x805028,%eax
  802923:	39 c2                	cmp    %eax,%edx
  802925:	0f 82 96 01 00 00    	jb     802ac1 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 40 0c             	mov    0xc(%eax),%eax
  802931:	3b 45 08             	cmp    0x8(%ebp),%eax
  802934:	0f 82 87 01 00 00    	jb     802ac1 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 40 0c             	mov    0xc(%eax),%eax
  802940:	3b 45 08             	cmp    0x8(%ebp),%eax
  802943:	0f 85 95 00 00 00    	jne    8029de <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802949:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294d:	75 17                	jne    802966 <alloc_block_NF+0x24c>
  80294f:	83 ec 04             	sub    $0x4,%esp
  802952:	68 44 41 80 00       	push   $0x804144
  802957:	68 fc 00 00 00       	push   $0xfc
  80295c:	68 9b 40 80 00       	push   $0x80409b
  802961:	e8 68 d9 ff ff       	call   8002ce <_panic>
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 00                	mov    (%eax),%eax
  80296b:	85 c0                	test   %eax,%eax
  80296d:	74 10                	je     80297f <alloc_block_NF+0x265>
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 00                	mov    (%eax),%eax
  802974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802977:	8b 52 04             	mov    0x4(%edx),%edx
  80297a:	89 50 04             	mov    %edx,0x4(%eax)
  80297d:	eb 0b                	jmp    80298a <alloc_block_NF+0x270>
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 40 04             	mov    0x4(%eax),%eax
  802985:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 40 04             	mov    0x4(%eax),%eax
  802990:	85 c0                	test   %eax,%eax
  802992:	74 0f                	je     8029a3 <alloc_block_NF+0x289>
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 04             	mov    0x4(%eax),%eax
  80299a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80299d:	8b 12                	mov    (%edx),%edx
  80299f:	89 10                	mov    %edx,(%eax)
  8029a1:	eb 0a                	jmp    8029ad <alloc_block_NF+0x293>
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8029c5:	48                   	dec    %eax
  8029c6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	8b 40 08             	mov    0x8(%eax),%eax
  8029d1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	e9 07 03 00 00       	jmp    802ce5 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e7:	0f 86 d4 00 00 00    	jbe    802ac1 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8029f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f8:	8b 50 08             	mov    0x8(%eax),%edx
  8029fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029fe:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a04:	8b 55 08             	mov    0x8(%ebp),%edx
  802a07:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a0a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a0e:	75 17                	jne    802a27 <alloc_block_NF+0x30d>
  802a10:	83 ec 04             	sub    $0x4,%esp
  802a13:	68 44 41 80 00       	push   $0x804144
  802a18:	68 04 01 00 00       	push   $0x104
  802a1d:	68 9b 40 80 00       	push   $0x80409b
  802a22:	e8 a7 d8 ff ff       	call   8002ce <_panic>
  802a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2a:	8b 00                	mov    (%eax),%eax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	74 10                	je     802a40 <alloc_block_NF+0x326>
  802a30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a38:	8b 52 04             	mov    0x4(%edx),%edx
  802a3b:	89 50 04             	mov    %edx,0x4(%eax)
  802a3e:	eb 0b                	jmp    802a4b <alloc_block_NF+0x331>
  802a40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a43:	8b 40 04             	mov    0x4(%eax),%eax
  802a46:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4e:	8b 40 04             	mov    0x4(%eax),%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	74 0f                	je     802a64 <alloc_block_NF+0x34a>
  802a55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a58:	8b 40 04             	mov    0x4(%eax),%eax
  802a5b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a5e:	8b 12                	mov    (%edx),%edx
  802a60:	89 10                	mov    %edx,(%eax)
  802a62:	eb 0a                	jmp    802a6e <alloc_block_NF+0x354>
  802a64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	a3 48 51 80 00       	mov    %eax,0x805148
  802a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a81:	a1 54 51 80 00       	mov    0x805154,%eax
  802a86:	48                   	dec    %eax
  802a87:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8f:	8b 40 08             	mov    0x8(%eax),%eax
  802a92:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 50 08             	mov    0x8(%eax),%edx
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	01 c2                	add    %eax,%edx
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 40 0c             	mov    0xc(%eax),%eax
  802aae:	2b 45 08             	sub    0x8(%ebp),%eax
  802ab1:	89 c2                	mov    %eax,%edx
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abc:	e9 24 02 00 00       	jmp    802ce5 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ac1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acd:	74 07                	je     802ad6 <alloc_block_NF+0x3bc>
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 00                	mov    (%eax),%eax
  802ad4:	eb 05                	jmp    802adb <alloc_block_NF+0x3c1>
  802ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  802adb:	a3 40 51 80 00       	mov    %eax,0x805140
  802ae0:	a1 40 51 80 00       	mov    0x805140,%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	0f 85 2b fe ff ff    	jne    802918 <alloc_block_NF+0x1fe>
  802aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af1:	0f 85 21 fe ff ff    	jne    802918 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802af7:	a1 38 51 80 00       	mov    0x805138,%eax
  802afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aff:	e9 ae 01 00 00       	jmp    802cb2 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 50 08             	mov    0x8(%eax),%edx
  802b0a:	a1 28 50 80 00       	mov    0x805028,%eax
  802b0f:	39 c2                	cmp    %eax,%edx
  802b11:	0f 83 93 01 00 00    	jae    802caa <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b20:	0f 82 84 01 00 00    	jb     802caa <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2f:	0f 85 95 00 00 00    	jne    802bca <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b39:	75 17                	jne    802b52 <alloc_block_NF+0x438>
  802b3b:	83 ec 04             	sub    $0x4,%esp
  802b3e:	68 44 41 80 00       	push   $0x804144
  802b43:	68 14 01 00 00       	push   $0x114
  802b48:	68 9b 40 80 00       	push   $0x80409b
  802b4d:	e8 7c d7 ff ff       	call   8002ce <_panic>
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	85 c0                	test   %eax,%eax
  802b59:	74 10                	je     802b6b <alloc_block_NF+0x451>
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 00                	mov    (%eax),%eax
  802b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b63:	8b 52 04             	mov    0x4(%edx),%edx
  802b66:	89 50 04             	mov    %edx,0x4(%eax)
  802b69:	eb 0b                	jmp    802b76 <alloc_block_NF+0x45c>
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 40 04             	mov    0x4(%eax),%eax
  802b71:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 40 04             	mov    0x4(%eax),%eax
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	74 0f                	je     802b8f <alloc_block_NF+0x475>
  802b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b83:	8b 40 04             	mov    0x4(%eax),%eax
  802b86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b89:	8b 12                	mov    (%edx),%edx
  802b8b:	89 10                	mov    %edx,(%eax)
  802b8d:	eb 0a                	jmp    802b99 <alloc_block_NF+0x47f>
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 00                	mov    (%eax),%eax
  802b94:	a3 38 51 80 00       	mov    %eax,0x805138
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bac:	a1 44 51 80 00       	mov    0x805144,%eax
  802bb1:	48                   	dec    %eax
  802bb2:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	8b 40 08             	mov    0x8(%eax),%eax
  802bbd:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	e9 1b 01 00 00       	jmp    802ce5 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd3:	0f 86 d1 00 00 00    	jbe    802caa <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bd9:	a1 48 51 80 00       	mov    0x805148,%eax
  802bde:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 50 08             	mov    0x8(%eax),%edx
  802be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bea:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bf6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bfa:	75 17                	jne    802c13 <alloc_block_NF+0x4f9>
  802bfc:	83 ec 04             	sub    $0x4,%esp
  802bff:	68 44 41 80 00       	push   $0x804144
  802c04:	68 1c 01 00 00       	push   $0x11c
  802c09:	68 9b 40 80 00       	push   $0x80409b
  802c0e:	e8 bb d6 ff ff       	call   8002ce <_panic>
  802c13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c16:	8b 00                	mov    (%eax),%eax
  802c18:	85 c0                	test   %eax,%eax
  802c1a:	74 10                	je     802c2c <alloc_block_NF+0x512>
  802c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1f:	8b 00                	mov    (%eax),%eax
  802c21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c24:	8b 52 04             	mov    0x4(%edx),%edx
  802c27:	89 50 04             	mov    %edx,0x4(%eax)
  802c2a:	eb 0b                	jmp    802c37 <alloc_block_NF+0x51d>
  802c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2f:	8b 40 04             	mov    0x4(%eax),%eax
  802c32:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3a:	8b 40 04             	mov    0x4(%eax),%eax
  802c3d:	85 c0                	test   %eax,%eax
  802c3f:	74 0f                	je     802c50 <alloc_block_NF+0x536>
  802c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c44:	8b 40 04             	mov    0x4(%eax),%eax
  802c47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c4a:	8b 12                	mov    (%edx),%edx
  802c4c:	89 10                	mov    %edx,(%eax)
  802c4e:	eb 0a                	jmp    802c5a <alloc_block_NF+0x540>
  802c50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	a3 48 51 80 00       	mov    %eax,0x805148
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6d:	a1 54 51 80 00       	mov    0x805154,%eax
  802c72:	48                   	dec    %eax
  802c73:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7b:	8b 40 08             	mov    0x8(%eax),%eax
  802c7e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 50 08             	mov    0x8(%eax),%edx
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	01 c2                	add    %eax,%edx
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9a:	2b 45 08             	sub    0x8(%ebp),%eax
  802c9d:	89 c2                	mov    %eax,%edx
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca8:	eb 3b                	jmp    802ce5 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802caa:	a1 40 51 80 00       	mov    0x805140,%eax
  802caf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb6:	74 07                	je     802cbf <alloc_block_NF+0x5a5>
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	eb 05                	jmp    802cc4 <alloc_block_NF+0x5aa>
  802cbf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc4:	a3 40 51 80 00       	mov    %eax,0x805140
  802cc9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	0f 85 2e fe ff ff    	jne    802b04 <alloc_block_NF+0x3ea>
  802cd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cda:	0f 85 24 fe ff ff    	jne    802b04 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ce0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ce5:	c9                   	leave  
  802ce6:	c3                   	ret    

00802ce7 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ce7:	55                   	push   %ebp
  802ce8:	89 e5                	mov    %esp,%ebp
  802cea:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ced:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cf5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cfa:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cfd:	a1 38 51 80 00       	mov    0x805138,%eax
  802d02:	85 c0                	test   %eax,%eax
  802d04:	74 14                	je     802d1a <insert_sorted_with_merge_freeList+0x33>
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	8b 50 08             	mov    0x8(%eax),%edx
  802d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0f:	8b 40 08             	mov    0x8(%eax),%eax
  802d12:	39 c2                	cmp    %eax,%edx
  802d14:	0f 87 9b 01 00 00    	ja     802eb5 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d1e:	75 17                	jne    802d37 <insert_sorted_with_merge_freeList+0x50>
  802d20:	83 ec 04             	sub    $0x4,%esp
  802d23:	68 78 40 80 00       	push   $0x804078
  802d28:	68 38 01 00 00       	push   $0x138
  802d2d:	68 9b 40 80 00       	push   $0x80409b
  802d32:	e8 97 d5 ff ff       	call   8002ce <_panic>
  802d37:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d40:	89 10                	mov    %edx,(%eax)
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	85 c0                	test   %eax,%eax
  802d49:	74 0d                	je     802d58 <insert_sorted_with_merge_freeList+0x71>
  802d4b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d50:	8b 55 08             	mov    0x8(%ebp),%edx
  802d53:	89 50 04             	mov    %edx,0x4(%eax)
  802d56:	eb 08                	jmp    802d60 <insert_sorted_with_merge_freeList+0x79>
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	a3 38 51 80 00       	mov    %eax,0x805138
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d72:	a1 44 51 80 00       	mov    0x805144,%eax
  802d77:	40                   	inc    %eax
  802d78:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d81:	0f 84 a8 06 00 00    	je     80342f <insert_sorted_with_merge_freeList+0x748>
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	8b 50 08             	mov    0x8(%eax),%edx
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	8b 40 0c             	mov    0xc(%eax),%eax
  802d93:	01 c2                	add    %eax,%edx
  802d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d98:	8b 40 08             	mov    0x8(%eax),%eax
  802d9b:	39 c2                	cmp    %eax,%edx
  802d9d:	0f 85 8c 06 00 00    	jne    80342f <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	8b 50 0c             	mov    0xc(%eax),%edx
  802da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dac:	8b 40 0c             	mov    0xc(%eax),%eax
  802daf:	01 c2                	add    %eax,%edx
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802db7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dbb:	75 17                	jne    802dd4 <insert_sorted_with_merge_freeList+0xed>
  802dbd:	83 ec 04             	sub    $0x4,%esp
  802dc0:	68 44 41 80 00       	push   $0x804144
  802dc5:	68 3c 01 00 00       	push   $0x13c
  802dca:	68 9b 40 80 00       	push   $0x80409b
  802dcf:	e8 fa d4 ff ff       	call   8002ce <_panic>
  802dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	74 10                	je     802ded <insert_sorted_with_merge_freeList+0x106>
  802ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de0:	8b 00                	mov    (%eax),%eax
  802de2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de5:	8b 52 04             	mov    0x4(%edx),%edx
  802de8:	89 50 04             	mov    %edx,0x4(%eax)
  802deb:	eb 0b                	jmp    802df8 <insert_sorted_with_merge_freeList+0x111>
  802ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df0:	8b 40 04             	mov    0x4(%eax),%eax
  802df3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	8b 40 04             	mov    0x4(%eax),%eax
  802dfe:	85 c0                	test   %eax,%eax
  802e00:	74 0f                	je     802e11 <insert_sorted_with_merge_freeList+0x12a>
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	8b 40 04             	mov    0x4(%eax),%eax
  802e08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e0b:	8b 12                	mov    (%edx),%edx
  802e0d:	89 10                	mov    %edx,(%eax)
  802e0f:	eb 0a                	jmp    802e1b <insert_sorted_with_merge_freeList+0x134>
  802e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e14:	8b 00                	mov    (%eax),%eax
  802e16:	a3 38 51 80 00       	mov    %eax,0x805138
  802e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e33:	48                   	dec    %eax
  802e34:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e51:	75 17                	jne    802e6a <insert_sorted_with_merge_freeList+0x183>
  802e53:	83 ec 04             	sub    $0x4,%esp
  802e56:	68 78 40 80 00       	push   $0x804078
  802e5b:	68 3f 01 00 00       	push   $0x13f
  802e60:	68 9b 40 80 00       	push   $0x80409b
  802e65:	e8 64 d4 ff ff       	call   8002ce <_panic>
  802e6a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e73:	89 10                	mov    %edx,(%eax)
  802e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e78:	8b 00                	mov    (%eax),%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	74 0d                	je     802e8b <insert_sorted_with_merge_freeList+0x1a4>
  802e7e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e86:	89 50 04             	mov    %edx,0x4(%eax)
  802e89:	eb 08                	jmp    802e93 <insert_sorted_with_merge_freeList+0x1ac>
  802e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e96:	a3 48 51 80 00       	mov    %eax,0x805148
  802e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea5:	a1 54 51 80 00       	mov    0x805154,%eax
  802eaa:	40                   	inc    %eax
  802eab:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802eb0:	e9 7a 05 00 00       	jmp    80342f <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	8b 50 08             	mov    0x8(%eax),%edx
  802ebb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebe:	8b 40 08             	mov    0x8(%eax),%eax
  802ec1:	39 c2                	cmp    %eax,%edx
  802ec3:	0f 82 14 01 00 00    	jb     802fdd <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecc:	8b 50 08             	mov    0x8(%eax),%edx
  802ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed5:	01 c2                	add    %eax,%edx
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	8b 40 08             	mov    0x8(%eax),%eax
  802edd:	39 c2                	cmp    %eax,%edx
  802edf:	0f 85 90 00 00 00    	jne    802f75 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee8:	8b 50 0c             	mov    0xc(%eax),%edx
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef1:	01 c2                	add    %eax,%edx
  802ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef6:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f11:	75 17                	jne    802f2a <insert_sorted_with_merge_freeList+0x243>
  802f13:	83 ec 04             	sub    $0x4,%esp
  802f16:	68 78 40 80 00       	push   $0x804078
  802f1b:	68 49 01 00 00       	push   $0x149
  802f20:	68 9b 40 80 00       	push   $0x80409b
  802f25:	e8 a4 d3 ff ff       	call   8002ce <_panic>
  802f2a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	89 10                	mov    %edx,(%eax)
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	8b 00                	mov    (%eax),%eax
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	74 0d                	je     802f4b <insert_sorted_with_merge_freeList+0x264>
  802f3e:	a1 48 51 80 00       	mov    0x805148,%eax
  802f43:	8b 55 08             	mov    0x8(%ebp),%edx
  802f46:	89 50 04             	mov    %edx,0x4(%eax)
  802f49:	eb 08                	jmp    802f53 <insert_sorted_with_merge_freeList+0x26c>
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	a3 48 51 80 00       	mov    %eax,0x805148
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f65:	a1 54 51 80 00       	mov    0x805154,%eax
  802f6a:	40                   	inc    %eax
  802f6b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f70:	e9 bb 04 00 00       	jmp    803430 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f79:	75 17                	jne    802f92 <insert_sorted_with_merge_freeList+0x2ab>
  802f7b:	83 ec 04             	sub    $0x4,%esp
  802f7e:	68 ec 40 80 00       	push   $0x8040ec
  802f83:	68 4c 01 00 00       	push   $0x14c
  802f88:	68 9b 40 80 00       	push   $0x80409b
  802f8d:	e8 3c d3 ff ff       	call   8002ce <_panic>
  802f92:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f98:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9b:	89 50 04             	mov    %edx,0x4(%eax)
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	8b 40 04             	mov    0x4(%eax),%eax
  802fa4:	85 c0                	test   %eax,%eax
  802fa6:	74 0c                	je     802fb4 <insert_sorted_with_merge_freeList+0x2cd>
  802fa8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fad:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb0:	89 10                	mov    %edx,(%eax)
  802fb2:	eb 08                	jmp    802fbc <insert_sorted_with_merge_freeList+0x2d5>
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	a3 38 51 80 00       	mov    %eax,0x805138
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fcd:	a1 44 51 80 00       	mov    0x805144,%eax
  802fd2:	40                   	inc    %eax
  802fd3:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fd8:	e9 53 04 00 00       	jmp    803430 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fdd:	a1 38 51 80 00       	mov    0x805138,%eax
  802fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe5:	e9 15 04 00 00       	jmp    8033ff <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fed:	8b 00                	mov    (%eax),%eax
  802fef:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff5:	8b 50 08             	mov    0x8(%eax),%edx
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	8b 40 08             	mov    0x8(%eax),%eax
  802ffe:	39 c2                	cmp    %eax,%edx
  803000:	0f 86 f1 03 00 00    	jbe    8033f7 <insert_sorted_with_merge_freeList+0x710>
  803006:	8b 45 08             	mov    0x8(%ebp),%eax
  803009:	8b 50 08             	mov    0x8(%eax),%edx
  80300c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300f:	8b 40 08             	mov    0x8(%eax),%eax
  803012:	39 c2                	cmp    %eax,%edx
  803014:	0f 83 dd 03 00 00    	jae    8033f7 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	8b 50 08             	mov    0x8(%eax),%edx
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	8b 40 0c             	mov    0xc(%eax),%eax
  803026:	01 c2                	add    %eax,%edx
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	8b 40 08             	mov    0x8(%eax),%eax
  80302e:	39 c2                	cmp    %eax,%edx
  803030:	0f 85 b9 01 00 00    	jne    8031ef <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	8b 50 08             	mov    0x8(%eax),%edx
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	8b 40 0c             	mov    0xc(%eax),%eax
  803042:	01 c2                	add    %eax,%edx
  803044:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803047:	8b 40 08             	mov    0x8(%eax),%eax
  80304a:	39 c2                	cmp    %eax,%edx
  80304c:	0f 85 0d 01 00 00    	jne    80315f <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 50 0c             	mov    0xc(%eax),%edx
  803058:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305b:	8b 40 0c             	mov    0xc(%eax),%eax
  80305e:	01 c2                	add    %eax,%edx
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803066:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80306a:	75 17                	jne    803083 <insert_sorted_with_merge_freeList+0x39c>
  80306c:	83 ec 04             	sub    $0x4,%esp
  80306f:	68 44 41 80 00       	push   $0x804144
  803074:	68 5c 01 00 00       	push   $0x15c
  803079:	68 9b 40 80 00       	push   $0x80409b
  80307e:	e8 4b d2 ff ff       	call   8002ce <_panic>
  803083:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	85 c0                	test   %eax,%eax
  80308a:	74 10                	je     80309c <insert_sorted_with_merge_freeList+0x3b5>
  80308c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803094:	8b 52 04             	mov    0x4(%edx),%edx
  803097:	89 50 04             	mov    %edx,0x4(%eax)
  80309a:	eb 0b                	jmp    8030a7 <insert_sorted_with_merge_freeList+0x3c0>
  80309c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309f:	8b 40 04             	mov    0x4(%eax),%eax
  8030a2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030aa:	8b 40 04             	mov    0x4(%eax),%eax
  8030ad:	85 c0                	test   %eax,%eax
  8030af:	74 0f                	je     8030c0 <insert_sorted_with_merge_freeList+0x3d9>
  8030b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b4:	8b 40 04             	mov    0x4(%eax),%eax
  8030b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ba:	8b 12                	mov    (%edx),%edx
  8030bc:	89 10                	mov    %edx,(%eax)
  8030be:	eb 0a                	jmp    8030ca <insert_sorted_with_merge_freeList+0x3e3>
  8030c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e2:	48                   	dec    %eax
  8030e3:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803100:	75 17                	jne    803119 <insert_sorted_with_merge_freeList+0x432>
  803102:	83 ec 04             	sub    $0x4,%esp
  803105:	68 78 40 80 00       	push   $0x804078
  80310a:	68 5f 01 00 00       	push   $0x15f
  80310f:	68 9b 40 80 00       	push   $0x80409b
  803114:	e8 b5 d1 ff ff       	call   8002ce <_panic>
  803119:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80311f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803122:	89 10                	mov    %edx,(%eax)
  803124:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803127:	8b 00                	mov    (%eax),%eax
  803129:	85 c0                	test   %eax,%eax
  80312b:	74 0d                	je     80313a <insert_sorted_with_merge_freeList+0x453>
  80312d:	a1 48 51 80 00       	mov    0x805148,%eax
  803132:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803135:	89 50 04             	mov    %edx,0x4(%eax)
  803138:	eb 08                	jmp    803142 <insert_sorted_with_merge_freeList+0x45b>
  80313a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803145:	a3 48 51 80 00       	mov    %eax,0x805148
  80314a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803154:	a1 54 51 80 00       	mov    0x805154,%eax
  803159:	40                   	inc    %eax
  80315a:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80315f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803162:	8b 50 0c             	mov    0xc(%eax),%edx
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	8b 40 0c             	mov    0xc(%eax),%eax
  80316b:	01 c2                	add    %eax,%edx
  80316d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803170:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803187:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318b:	75 17                	jne    8031a4 <insert_sorted_with_merge_freeList+0x4bd>
  80318d:	83 ec 04             	sub    $0x4,%esp
  803190:	68 78 40 80 00       	push   $0x804078
  803195:	68 64 01 00 00       	push   $0x164
  80319a:	68 9b 40 80 00       	push   $0x80409b
  80319f:	e8 2a d1 ff ff       	call   8002ce <_panic>
  8031a4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	89 10                	mov    %edx,(%eax)
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	8b 00                	mov    (%eax),%eax
  8031b4:	85 c0                	test   %eax,%eax
  8031b6:	74 0d                	je     8031c5 <insert_sorted_with_merge_freeList+0x4de>
  8031b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8031bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c0:	89 50 04             	mov    %edx,0x4(%eax)
  8031c3:	eb 08                	jmp    8031cd <insert_sorted_with_merge_freeList+0x4e6>
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031df:	a1 54 51 80 00       	mov    0x805154,%eax
  8031e4:	40                   	inc    %eax
  8031e5:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031ea:	e9 41 02 00 00       	jmp    803430 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	8b 50 08             	mov    0x8(%eax),%edx
  8031f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fb:	01 c2                	add    %eax,%edx
  8031fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803200:	8b 40 08             	mov    0x8(%eax),%eax
  803203:	39 c2                	cmp    %eax,%edx
  803205:	0f 85 7c 01 00 00    	jne    803387 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80320b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80320f:	74 06                	je     803217 <insert_sorted_with_merge_freeList+0x530>
  803211:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803215:	75 17                	jne    80322e <insert_sorted_with_merge_freeList+0x547>
  803217:	83 ec 04             	sub    $0x4,%esp
  80321a:	68 b4 40 80 00       	push   $0x8040b4
  80321f:	68 69 01 00 00       	push   $0x169
  803224:	68 9b 40 80 00       	push   $0x80409b
  803229:	e8 a0 d0 ff ff       	call   8002ce <_panic>
  80322e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803231:	8b 50 04             	mov    0x4(%eax),%edx
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	89 50 04             	mov    %edx,0x4(%eax)
  80323a:	8b 45 08             	mov    0x8(%ebp),%eax
  80323d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803240:	89 10                	mov    %edx,(%eax)
  803242:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803245:	8b 40 04             	mov    0x4(%eax),%eax
  803248:	85 c0                	test   %eax,%eax
  80324a:	74 0d                	je     803259 <insert_sorted_with_merge_freeList+0x572>
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	8b 40 04             	mov    0x4(%eax),%eax
  803252:	8b 55 08             	mov    0x8(%ebp),%edx
  803255:	89 10                	mov    %edx,(%eax)
  803257:	eb 08                	jmp    803261 <insert_sorted_with_merge_freeList+0x57a>
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	a3 38 51 80 00       	mov    %eax,0x805138
  803261:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803264:	8b 55 08             	mov    0x8(%ebp),%edx
  803267:	89 50 04             	mov    %edx,0x4(%eax)
  80326a:	a1 44 51 80 00       	mov    0x805144,%eax
  80326f:	40                   	inc    %eax
  803270:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	8b 50 0c             	mov    0xc(%eax),%edx
  80327b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327e:	8b 40 0c             	mov    0xc(%eax),%eax
  803281:	01 c2                	add    %eax,%edx
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803289:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80328d:	75 17                	jne    8032a6 <insert_sorted_with_merge_freeList+0x5bf>
  80328f:	83 ec 04             	sub    $0x4,%esp
  803292:	68 44 41 80 00       	push   $0x804144
  803297:	68 6b 01 00 00       	push   $0x16b
  80329c:	68 9b 40 80 00       	push   $0x80409b
  8032a1:	e8 28 d0 ff ff       	call   8002ce <_panic>
  8032a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	85 c0                	test   %eax,%eax
  8032ad:	74 10                	je     8032bf <insert_sorted_with_merge_freeList+0x5d8>
  8032af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b2:	8b 00                	mov    (%eax),%eax
  8032b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032b7:	8b 52 04             	mov    0x4(%edx),%edx
  8032ba:	89 50 04             	mov    %edx,0x4(%eax)
  8032bd:	eb 0b                	jmp    8032ca <insert_sorted_with_merge_freeList+0x5e3>
  8032bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c2:	8b 40 04             	mov    0x4(%eax),%eax
  8032c5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	8b 40 04             	mov    0x4(%eax),%eax
  8032d0:	85 c0                	test   %eax,%eax
  8032d2:	74 0f                	je     8032e3 <insert_sorted_with_merge_freeList+0x5fc>
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	8b 40 04             	mov    0x4(%eax),%eax
  8032da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032dd:	8b 12                	mov    (%edx),%edx
  8032df:	89 10                	mov    %edx,(%eax)
  8032e1:	eb 0a                	jmp    8032ed <insert_sorted_with_merge_freeList+0x606>
  8032e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e6:	8b 00                	mov    (%eax),%eax
  8032e8:	a3 38 51 80 00       	mov    %eax,0x805138
  8032ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803300:	a1 44 51 80 00       	mov    0x805144,%eax
  803305:	48                   	dec    %eax
  803306:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80330b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803315:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803318:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80331f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803323:	75 17                	jne    80333c <insert_sorted_with_merge_freeList+0x655>
  803325:	83 ec 04             	sub    $0x4,%esp
  803328:	68 78 40 80 00       	push   $0x804078
  80332d:	68 6e 01 00 00       	push   $0x16e
  803332:	68 9b 40 80 00       	push   $0x80409b
  803337:	e8 92 cf ff ff       	call   8002ce <_panic>
  80333c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803342:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803345:	89 10                	mov    %edx,(%eax)
  803347:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334a:	8b 00                	mov    (%eax),%eax
  80334c:	85 c0                	test   %eax,%eax
  80334e:	74 0d                	je     80335d <insert_sorted_with_merge_freeList+0x676>
  803350:	a1 48 51 80 00       	mov    0x805148,%eax
  803355:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803358:	89 50 04             	mov    %edx,0x4(%eax)
  80335b:	eb 08                	jmp    803365 <insert_sorted_with_merge_freeList+0x67e>
  80335d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803360:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803368:	a3 48 51 80 00       	mov    %eax,0x805148
  80336d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803370:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803377:	a1 54 51 80 00       	mov    0x805154,%eax
  80337c:	40                   	inc    %eax
  80337d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803382:	e9 a9 00 00 00       	jmp    803430 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803387:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338b:	74 06                	je     803393 <insert_sorted_with_merge_freeList+0x6ac>
  80338d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803391:	75 17                	jne    8033aa <insert_sorted_with_merge_freeList+0x6c3>
  803393:	83 ec 04             	sub    $0x4,%esp
  803396:	68 10 41 80 00       	push   $0x804110
  80339b:	68 73 01 00 00       	push   $0x173
  8033a0:	68 9b 40 80 00       	push   $0x80409b
  8033a5:	e8 24 cf ff ff       	call   8002ce <_panic>
  8033aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ad:	8b 10                	mov    (%eax),%edx
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	89 10                	mov    %edx,(%eax)
  8033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b7:	8b 00                	mov    (%eax),%eax
  8033b9:	85 c0                	test   %eax,%eax
  8033bb:	74 0b                	je     8033c8 <insert_sorted_with_merge_freeList+0x6e1>
  8033bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c0:	8b 00                	mov    (%eax),%eax
  8033c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c5:	89 50 04             	mov    %edx,0x4(%eax)
  8033c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ce:	89 10                	mov    %edx,(%eax)
  8033d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033d6:	89 50 04             	mov    %edx,0x4(%eax)
  8033d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dc:	8b 00                	mov    (%eax),%eax
  8033de:	85 c0                	test   %eax,%eax
  8033e0:	75 08                	jne    8033ea <insert_sorted_with_merge_freeList+0x703>
  8033e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ef:	40                   	inc    %eax
  8033f0:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033f5:	eb 39                	jmp    803430 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8033fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803403:	74 07                	je     80340c <insert_sorted_with_merge_freeList+0x725>
  803405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803408:	8b 00                	mov    (%eax),%eax
  80340a:	eb 05                	jmp    803411 <insert_sorted_with_merge_freeList+0x72a>
  80340c:	b8 00 00 00 00       	mov    $0x0,%eax
  803411:	a3 40 51 80 00       	mov    %eax,0x805140
  803416:	a1 40 51 80 00       	mov    0x805140,%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	0f 85 c7 fb ff ff    	jne    802fea <insert_sorted_with_merge_freeList+0x303>
  803423:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803427:	0f 85 bd fb ff ff    	jne    802fea <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80342d:	eb 01                	jmp    803430 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80342f:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803430:	90                   	nop
  803431:	c9                   	leave  
  803432:	c3                   	ret    

00803433 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803433:	55                   	push   %ebp
  803434:	89 e5                	mov    %esp,%ebp
  803436:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803439:	8b 55 08             	mov    0x8(%ebp),%edx
  80343c:	89 d0                	mov    %edx,%eax
  80343e:	c1 e0 02             	shl    $0x2,%eax
  803441:	01 d0                	add    %edx,%eax
  803443:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80344a:	01 d0                	add    %edx,%eax
  80344c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803453:	01 d0                	add    %edx,%eax
  803455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80345c:	01 d0                	add    %edx,%eax
  80345e:	c1 e0 04             	shl    $0x4,%eax
  803461:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803464:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80346b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80346e:	83 ec 0c             	sub    $0xc,%esp
  803471:	50                   	push   %eax
  803472:	e8 26 e7 ff ff       	call   801b9d <sys_get_virtual_time>
  803477:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80347a:	eb 41                	jmp    8034bd <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80347c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80347f:	83 ec 0c             	sub    $0xc,%esp
  803482:	50                   	push   %eax
  803483:	e8 15 e7 ff ff       	call   801b9d <sys_get_virtual_time>
  803488:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80348b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80348e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803491:	29 c2                	sub    %eax,%edx
  803493:	89 d0                	mov    %edx,%eax
  803495:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803498:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80349b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80349e:	89 d1                	mov    %edx,%ecx
  8034a0:	29 c1                	sub    %eax,%ecx
  8034a2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8034a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a8:	39 c2                	cmp    %eax,%edx
  8034aa:	0f 97 c0             	seta   %al
  8034ad:	0f b6 c0             	movzbl %al,%eax
  8034b0:	29 c1                	sub    %eax,%ecx
  8034b2:	89 c8                	mov    %ecx,%eax
  8034b4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8034b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8034bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034c3:	72 b7                	jb     80347c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8034c5:	90                   	nop
  8034c6:	c9                   	leave  
  8034c7:	c3                   	ret    

008034c8 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8034c8:	55                   	push   %ebp
  8034c9:	89 e5                	mov    %esp,%ebp
  8034cb:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8034ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8034d5:	eb 03                	jmp    8034da <busy_wait+0x12>
  8034d7:	ff 45 fc             	incl   -0x4(%ebp)
  8034da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034e0:	72 f5                	jb     8034d7 <busy_wait+0xf>
	return i;
  8034e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8034e5:	c9                   	leave  
  8034e6:	c3                   	ret    
  8034e7:	90                   	nop

008034e8 <__udivdi3>:
  8034e8:	55                   	push   %ebp
  8034e9:	57                   	push   %edi
  8034ea:	56                   	push   %esi
  8034eb:	53                   	push   %ebx
  8034ec:	83 ec 1c             	sub    $0x1c,%esp
  8034ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034ff:	89 ca                	mov    %ecx,%edx
  803501:	89 f8                	mov    %edi,%eax
  803503:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803507:	85 f6                	test   %esi,%esi
  803509:	75 2d                	jne    803538 <__udivdi3+0x50>
  80350b:	39 cf                	cmp    %ecx,%edi
  80350d:	77 65                	ja     803574 <__udivdi3+0x8c>
  80350f:	89 fd                	mov    %edi,%ebp
  803511:	85 ff                	test   %edi,%edi
  803513:	75 0b                	jne    803520 <__udivdi3+0x38>
  803515:	b8 01 00 00 00       	mov    $0x1,%eax
  80351a:	31 d2                	xor    %edx,%edx
  80351c:	f7 f7                	div    %edi
  80351e:	89 c5                	mov    %eax,%ebp
  803520:	31 d2                	xor    %edx,%edx
  803522:	89 c8                	mov    %ecx,%eax
  803524:	f7 f5                	div    %ebp
  803526:	89 c1                	mov    %eax,%ecx
  803528:	89 d8                	mov    %ebx,%eax
  80352a:	f7 f5                	div    %ebp
  80352c:	89 cf                	mov    %ecx,%edi
  80352e:	89 fa                	mov    %edi,%edx
  803530:	83 c4 1c             	add    $0x1c,%esp
  803533:	5b                   	pop    %ebx
  803534:	5e                   	pop    %esi
  803535:	5f                   	pop    %edi
  803536:	5d                   	pop    %ebp
  803537:	c3                   	ret    
  803538:	39 ce                	cmp    %ecx,%esi
  80353a:	77 28                	ja     803564 <__udivdi3+0x7c>
  80353c:	0f bd fe             	bsr    %esi,%edi
  80353f:	83 f7 1f             	xor    $0x1f,%edi
  803542:	75 40                	jne    803584 <__udivdi3+0x9c>
  803544:	39 ce                	cmp    %ecx,%esi
  803546:	72 0a                	jb     803552 <__udivdi3+0x6a>
  803548:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80354c:	0f 87 9e 00 00 00    	ja     8035f0 <__udivdi3+0x108>
  803552:	b8 01 00 00 00       	mov    $0x1,%eax
  803557:	89 fa                	mov    %edi,%edx
  803559:	83 c4 1c             	add    $0x1c,%esp
  80355c:	5b                   	pop    %ebx
  80355d:	5e                   	pop    %esi
  80355e:	5f                   	pop    %edi
  80355f:	5d                   	pop    %ebp
  803560:	c3                   	ret    
  803561:	8d 76 00             	lea    0x0(%esi),%esi
  803564:	31 ff                	xor    %edi,%edi
  803566:	31 c0                	xor    %eax,%eax
  803568:	89 fa                	mov    %edi,%edx
  80356a:	83 c4 1c             	add    $0x1c,%esp
  80356d:	5b                   	pop    %ebx
  80356e:	5e                   	pop    %esi
  80356f:	5f                   	pop    %edi
  803570:	5d                   	pop    %ebp
  803571:	c3                   	ret    
  803572:	66 90                	xchg   %ax,%ax
  803574:	89 d8                	mov    %ebx,%eax
  803576:	f7 f7                	div    %edi
  803578:	31 ff                	xor    %edi,%edi
  80357a:	89 fa                	mov    %edi,%edx
  80357c:	83 c4 1c             	add    $0x1c,%esp
  80357f:	5b                   	pop    %ebx
  803580:	5e                   	pop    %esi
  803581:	5f                   	pop    %edi
  803582:	5d                   	pop    %ebp
  803583:	c3                   	ret    
  803584:	bd 20 00 00 00       	mov    $0x20,%ebp
  803589:	89 eb                	mov    %ebp,%ebx
  80358b:	29 fb                	sub    %edi,%ebx
  80358d:	89 f9                	mov    %edi,%ecx
  80358f:	d3 e6                	shl    %cl,%esi
  803591:	89 c5                	mov    %eax,%ebp
  803593:	88 d9                	mov    %bl,%cl
  803595:	d3 ed                	shr    %cl,%ebp
  803597:	89 e9                	mov    %ebp,%ecx
  803599:	09 f1                	or     %esi,%ecx
  80359b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80359f:	89 f9                	mov    %edi,%ecx
  8035a1:	d3 e0                	shl    %cl,%eax
  8035a3:	89 c5                	mov    %eax,%ebp
  8035a5:	89 d6                	mov    %edx,%esi
  8035a7:	88 d9                	mov    %bl,%cl
  8035a9:	d3 ee                	shr    %cl,%esi
  8035ab:	89 f9                	mov    %edi,%ecx
  8035ad:	d3 e2                	shl    %cl,%edx
  8035af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035b3:	88 d9                	mov    %bl,%cl
  8035b5:	d3 e8                	shr    %cl,%eax
  8035b7:	09 c2                	or     %eax,%edx
  8035b9:	89 d0                	mov    %edx,%eax
  8035bb:	89 f2                	mov    %esi,%edx
  8035bd:	f7 74 24 0c          	divl   0xc(%esp)
  8035c1:	89 d6                	mov    %edx,%esi
  8035c3:	89 c3                	mov    %eax,%ebx
  8035c5:	f7 e5                	mul    %ebp
  8035c7:	39 d6                	cmp    %edx,%esi
  8035c9:	72 19                	jb     8035e4 <__udivdi3+0xfc>
  8035cb:	74 0b                	je     8035d8 <__udivdi3+0xf0>
  8035cd:	89 d8                	mov    %ebx,%eax
  8035cf:	31 ff                	xor    %edi,%edi
  8035d1:	e9 58 ff ff ff       	jmp    80352e <__udivdi3+0x46>
  8035d6:	66 90                	xchg   %ax,%ax
  8035d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035dc:	89 f9                	mov    %edi,%ecx
  8035de:	d3 e2                	shl    %cl,%edx
  8035e0:	39 c2                	cmp    %eax,%edx
  8035e2:	73 e9                	jae    8035cd <__udivdi3+0xe5>
  8035e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035e7:	31 ff                	xor    %edi,%edi
  8035e9:	e9 40 ff ff ff       	jmp    80352e <__udivdi3+0x46>
  8035ee:	66 90                	xchg   %ax,%ax
  8035f0:	31 c0                	xor    %eax,%eax
  8035f2:	e9 37 ff ff ff       	jmp    80352e <__udivdi3+0x46>
  8035f7:	90                   	nop

008035f8 <__umoddi3>:
  8035f8:	55                   	push   %ebp
  8035f9:	57                   	push   %edi
  8035fa:	56                   	push   %esi
  8035fb:	53                   	push   %ebx
  8035fc:	83 ec 1c             	sub    $0x1c,%esp
  8035ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803603:	8b 74 24 34          	mov    0x34(%esp),%esi
  803607:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80360b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80360f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803613:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803617:	89 f3                	mov    %esi,%ebx
  803619:	89 fa                	mov    %edi,%edx
  80361b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80361f:	89 34 24             	mov    %esi,(%esp)
  803622:	85 c0                	test   %eax,%eax
  803624:	75 1a                	jne    803640 <__umoddi3+0x48>
  803626:	39 f7                	cmp    %esi,%edi
  803628:	0f 86 a2 00 00 00    	jbe    8036d0 <__umoddi3+0xd8>
  80362e:	89 c8                	mov    %ecx,%eax
  803630:	89 f2                	mov    %esi,%edx
  803632:	f7 f7                	div    %edi
  803634:	89 d0                	mov    %edx,%eax
  803636:	31 d2                	xor    %edx,%edx
  803638:	83 c4 1c             	add    $0x1c,%esp
  80363b:	5b                   	pop    %ebx
  80363c:	5e                   	pop    %esi
  80363d:	5f                   	pop    %edi
  80363e:	5d                   	pop    %ebp
  80363f:	c3                   	ret    
  803640:	39 f0                	cmp    %esi,%eax
  803642:	0f 87 ac 00 00 00    	ja     8036f4 <__umoddi3+0xfc>
  803648:	0f bd e8             	bsr    %eax,%ebp
  80364b:	83 f5 1f             	xor    $0x1f,%ebp
  80364e:	0f 84 ac 00 00 00    	je     803700 <__umoddi3+0x108>
  803654:	bf 20 00 00 00       	mov    $0x20,%edi
  803659:	29 ef                	sub    %ebp,%edi
  80365b:	89 fe                	mov    %edi,%esi
  80365d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803661:	89 e9                	mov    %ebp,%ecx
  803663:	d3 e0                	shl    %cl,%eax
  803665:	89 d7                	mov    %edx,%edi
  803667:	89 f1                	mov    %esi,%ecx
  803669:	d3 ef                	shr    %cl,%edi
  80366b:	09 c7                	or     %eax,%edi
  80366d:	89 e9                	mov    %ebp,%ecx
  80366f:	d3 e2                	shl    %cl,%edx
  803671:	89 14 24             	mov    %edx,(%esp)
  803674:	89 d8                	mov    %ebx,%eax
  803676:	d3 e0                	shl    %cl,%eax
  803678:	89 c2                	mov    %eax,%edx
  80367a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80367e:	d3 e0                	shl    %cl,%eax
  803680:	89 44 24 04          	mov    %eax,0x4(%esp)
  803684:	8b 44 24 08          	mov    0x8(%esp),%eax
  803688:	89 f1                	mov    %esi,%ecx
  80368a:	d3 e8                	shr    %cl,%eax
  80368c:	09 d0                	or     %edx,%eax
  80368e:	d3 eb                	shr    %cl,%ebx
  803690:	89 da                	mov    %ebx,%edx
  803692:	f7 f7                	div    %edi
  803694:	89 d3                	mov    %edx,%ebx
  803696:	f7 24 24             	mull   (%esp)
  803699:	89 c6                	mov    %eax,%esi
  80369b:	89 d1                	mov    %edx,%ecx
  80369d:	39 d3                	cmp    %edx,%ebx
  80369f:	0f 82 87 00 00 00    	jb     80372c <__umoddi3+0x134>
  8036a5:	0f 84 91 00 00 00    	je     80373c <__umoddi3+0x144>
  8036ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036af:	29 f2                	sub    %esi,%edx
  8036b1:	19 cb                	sbb    %ecx,%ebx
  8036b3:	89 d8                	mov    %ebx,%eax
  8036b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036b9:	d3 e0                	shl    %cl,%eax
  8036bb:	89 e9                	mov    %ebp,%ecx
  8036bd:	d3 ea                	shr    %cl,%edx
  8036bf:	09 d0                	or     %edx,%eax
  8036c1:	89 e9                	mov    %ebp,%ecx
  8036c3:	d3 eb                	shr    %cl,%ebx
  8036c5:	89 da                	mov    %ebx,%edx
  8036c7:	83 c4 1c             	add    $0x1c,%esp
  8036ca:	5b                   	pop    %ebx
  8036cb:	5e                   	pop    %esi
  8036cc:	5f                   	pop    %edi
  8036cd:	5d                   	pop    %ebp
  8036ce:	c3                   	ret    
  8036cf:	90                   	nop
  8036d0:	89 fd                	mov    %edi,%ebp
  8036d2:	85 ff                	test   %edi,%edi
  8036d4:	75 0b                	jne    8036e1 <__umoddi3+0xe9>
  8036d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036db:	31 d2                	xor    %edx,%edx
  8036dd:	f7 f7                	div    %edi
  8036df:	89 c5                	mov    %eax,%ebp
  8036e1:	89 f0                	mov    %esi,%eax
  8036e3:	31 d2                	xor    %edx,%edx
  8036e5:	f7 f5                	div    %ebp
  8036e7:	89 c8                	mov    %ecx,%eax
  8036e9:	f7 f5                	div    %ebp
  8036eb:	89 d0                	mov    %edx,%eax
  8036ed:	e9 44 ff ff ff       	jmp    803636 <__umoddi3+0x3e>
  8036f2:	66 90                	xchg   %ax,%ax
  8036f4:	89 c8                	mov    %ecx,%eax
  8036f6:	89 f2                	mov    %esi,%edx
  8036f8:	83 c4 1c             	add    $0x1c,%esp
  8036fb:	5b                   	pop    %ebx
  8036fc:	5e                   	pop    %esi
  8036fd:	5f                   	pop    %edi
  8036fe:	5d                   	pop    %ebp
  8036ff:	c3                   	ret    
  803700:	3b 04 24             	cmp    (%esp),%eax
  803703:	72 06                	jb     80370b <__umoddi3+0x113>
  803705:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803709:	77 0f                	ja     80371a <__umoddi3+0x122>
  80370b:	89 f2                	mov    %esi,%edx
  80370d:	29 f9                	sub    %edi,%ecx
  80370f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803713:	89 14 24             	mov    %edx,(%esp)
  803716:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80371a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80371e:	8b 14 24             	mov    (%esp),%edx
  803721:	83 c4 1c             	add    $0x1c,%esp
  803724:	5b                   	pop    %ebx
  803725:	5e                   	pop    %esi
  803726:	5f                   	pop    %edi
  803727:	5d                   	pop    %ebp
  803728:	c3                   	ret    
  803729:	8d 76 00             	lea    0x0(%esi),%esi
  80372c:	2b 04 24             	sub    (%esp),%eax
  80372f:	19 fa                	sbb    %edi,%edx
  803731:	89 d1                	mov    %edx,%ecx
  803733:	89 c6                	mov    %eax,%esi
  803735:	e9 71 ff ff ff       	jmp    8036ab <__umoddi3+0xb3>
  80373a:	66 90                	xchg   %ax,%ax
  80373c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803740:	72 ea                	jb     80372c <__umoddi3+0x134>
  803742:	89 d9                	mov    %ebx,%ecx
  803744:	e9 62 ff ff ff       	jmp    8036ab <__umoddi3+0xb3>
