
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
  800045:	68 a0 36 80 00       	push   $0x8036a0
  80004a:	e8 03 15 00 00       	call   801552 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 54 17 00 00       	call   8017b7 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 ec 17 00 00       	call   801857 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 b0 36 80 00       	push   $0x8036b0
  800079:	e8 04 05 00 00       	call   800582 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000, (myEnv->SecondListSize),50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 e3 36 80 00       	push   $0x8036e3
  800099:	e8 8b 19 00 00       	call   801a29 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	6a 14                	push   $0x14
  8000b4:	68 ec 36 80 00       	push   $0x8036ec
  8000b9:	e8 6b 19 00 00       	call   801a29 <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 78 19 00 00       	call   801a47 <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 10 27 00 00       	push   $0x2710
  8000da:	e8 9a 32 00 00       	call   803379 <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e8:	e8 5a 19 00 00       	call   801a47 <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f0:	90                   	nop
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	83 f8 02             	cmp    $0x2,%eax
  8000f9:	75 f6                	jne    8000f1 <_main+0xb9>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fb:	e8 b7 16 00 00       	call   8017b7 <sys_calculate_free_frames>
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	68 f8 36 80 00       	push   $0x8036f8
  800109:	e8 74 04 00 00       	call   800582 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 e8             	pushl  -0x18(%ebp)
  800117:	e8 47 19 00 00       	call   801a63 <sys_destroy_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 39 19 00 00       	call   801a63 <sys_destroy_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80012d:	e8 85 16 00 00       	call   8017b7 <sys_calculate_free_frames>
  800132:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800135:	e8 1d 17 00 00       	call   801857 <sys_pf_calculate_allocated_pages>
  80013a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80013d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800143:	74 27                	je     80016c <_main+0x134>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 e0             	pushl  -0x20(%ebp)
  80014b:	68 2c 37 80 00       	push   $0x80372c
  800150:	e8 2d 04 00 00       	call   800582 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 7c 37 80 00       	push   $0x80377c
  800160:	6a 23                	push   $0x23
  800162:	68 b2 37 80 00       	push   $0x8037b2
  800167:	e8 62 01 00 00       	call   8002ce <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 e0             	pushl  -0x20(%ebp)
  800172:	68 c8 37 80 00       	push   $0x8037c8
  800177:	e8 06 04 00 00       	call   800582 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 28 38 80 00       	push   $0x803828
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
  800198:	e8 fa 18 00 00       	call   801a97 <sys_getenvindex>
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
  800203:	e8 9c 16 00 00       	call   8018a4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 8c 38 80 00       	push   $0x80388c
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
  800233:	68 b4 38 80 00       	push   $0x8038b4
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
  800264:	68 dc 38 80 00       	push   $0x8038dc
  800269:	e8 14 03 00 00       	call   800582 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 50 80 00       	mov    0x805020,%eax
  800276:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 34 39 80 00       	push   $0x803934
  800285:	e8 f8 02 00 00       	call   800582 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 8c 38 80 00       	push   $0x80388c
  800295:	e8 e8 02 00 00       	call   800582 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029d:	e8 1c 16 00 00       	call   8018be <sys_enable_interrupt>

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
  8002b5:	e8 a9 17 00 00       	call   801a63 <sys_destroy_env>
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
  8002c6:	e8 fe 17 00 00       	call   801ac9 <sys_exit_env>
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
  8002ef:	68 48 39 80 00       	push   $0x803948
  8002f4:	e8 89 02 00 00       	call   800582 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fc:	a1 00 50 80 00       	mov    0x805000,%eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	50                   	push   %eax
  800308:	68 4d 39 80 00       	push   $0x80394d
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
  80032c:	68 69 39 80 00       	push   $0x803969
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
  800358:	68 6c 39 80 00       	push   $0x80396c
  80035d:	6a 26                	push   $0x26
  80035f:	68 b8 39 80 00       	push   $0x8039b8
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
  80042a:	68 c4 39 80 00       	push   $0x8039c4
  80042f:	6a 3a                	push   $0x3a
  800431:	68 b8 39 80 00       	push   $0x8039b8
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
  80049a:	68 18 3a 80 00       	push   $0x803a18
  80049f:	6a 44                	push   $0x44
  8004a1:	68 b8 39 80 00       	push   $0x8039b8
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
  8004f4:	e8 fd 11 00 00       	call   8016f6 <sys_cputs>
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
  80056b:	e8 86 11 00 00       	call   8016f6 <sys_cputs>
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
  8005b5:	e8 ea 12 00 00       	call   8018a4 <sys_disable_interrupt>
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
  8005d5:	e8 e4 12 00 00       	call   8018be <sys_enable_interrupt>
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
  80061f:	e8 0c 2e 00 00       	call   803430 <__udivdi3>
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
  80066f:	e8 cc 2e 00 00       	call   803540 <__umoddi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	05 94 3c 80 00       	add    $0x803c94,%eax
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
  8007ca:	8b 04 85 b8 3c 80 00 	mov    0x803cb8(,%eax,4),%eax
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
  8008ab:	8b 34 9d 00 3b 80 00 	mov    0x803b00(,%ebx,4),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 19                	jne    8008cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b6:	53                   	push   %ebx
  8008b7:	68 a5 3c 80 00       	push   $0x803ca5
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
  8008d0:	68 ae 3c 80 00       	push   $0x803cae
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
  8008fd:	be b1 3c 80 00       	mov    $0x803cb1,%esi
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
  801323:	68 10 3e 80 00       	push   $0x803e10
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
  8013f3:	e8 42 04 00 00       	call   80183a <sys_allocate_chunk>
  8013f8:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013fb:	a1 20 51 80 00       	mov    0x805120,%eax
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	50                   	push   %eax
  801404:	e8 b7 0a 00 00       	call   801ec0 <initialize_MemBlocksList>
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
  801431:	68 35 3e 80 00       	push   $0x803e35
  801436:	6a 33                	push   $0x33
  801438:	68 53 3e 80 00       	push   $0x803e53
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
  8014b0:	68 60 3e 80 00       	push   $0x803e60
  8014b5:	6a 34                	push   $0x34
  8014b7:	68 53 3e 80 00       	push   $0x803e53
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
  80150d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801510:	e8 f7 fd ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  801515:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801519:	75 07                	jne    801522 <malloc+0x18>
  80151b:	b8 00 00 00 00       	mov    $0x0,%eax
  801520:	eb 14                	jmp    801536 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801522:	83 ec 04             	sub    $0x4,%esp
  801525:	68 84 3e 80 00       	push   $0x803e84
  80152a:	6a 46                	push   $0x46
  80152c:	68 53 3e 80 00       	push   $0x803e53
  801531:	e8 98 ed ff ff       	call   8002ce <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80153e:	83 ec 04             	sub    $0x4,%esp
  801541:	68 ac 3e 80 00       	push   $0x803eac
  801546:	6a 61                	push   $0x61
  801548:	68 53 3e 80 00       	push   $0x803e53
  80154d:	e8 7c ed ff ff       	call   8002ce <_panic>

00801552 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	83 ec 38             	sub    $0x38,%esp
  801558:	8b 45 10             	mov    0x10(%ebp),%eax
  80155b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80155e:	e8 a9 fd ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  801563:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801567:	75 0a                	jne    801573 <smalloc+0x21>
  801569:	b8 00 00 00 00       	mov    $0x0,%eax
  80156e:	e9 9e 00 00 00       	jmp    801611 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801573:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80157a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801580:	01 d0                	add    %edx,%eax
  801582:	48                   	dec    %eax
  801583:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801589:	ba 00 00 00 00       	mov    $0x0,%edx
  80158e:	f7 75 f0             	divl   -0x10(%ebp)
  801591:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801594:	29 d0                	sub    %edx,%eax
  801596:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801599:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015a0:	e8 63 06 00 00       	call   801c08 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	74 11                	je     8015ba <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8015a9:	83 ec 0c             	sub    $0xc,%esp
  8015ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8015af:	e8 ce 0c 00 00       	call   802282 <alloc_block_FF>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015be:	74 4c                	je     80160c <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	8b 40 08             	mov    0x8(%eax),%eax
  8015c6:	89 c2                	mov    %eax,%edx
  8015c8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015cc:	52                   	push   %edx
  8015cd:	50                   	push   %eax
  8015ce:	ff 75 0c             	pushl  0xc(%ebp)
  8015d1:	ff 75 08             	pushl  0x8(%ebp)
  8015d4:	e8 b4 03 00 00       	call   80198d <sys_createSharedObject>
  8015d9:	83 c4 10             	add    $0x10,%esp
  8015dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8015df:	83 ec 08             	sub    $0x8,%esp
  8015e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8015e5:	68 cf 3e 80 00       	push   $0x803ecf
  8015ea:	e8 93 ef ff ff       	call   800582 <cprintf>
  8015ef:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015f2:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015f6:	74 14                	je     80160c <smalloc+0xba>
  8015f8:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015fc:	74 0e                	je     80160c <smalloc+0xba>
  8015fe:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801602:	74 08                	je     80160c <smalloc+0xba>
			return (void*) mem_block->sva;
  801604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801607:	8b 40 08             	mov    0x8(%eax),%eax
  80160a:	eb 05                	jmp    801611 <smalloc+0xbf>
	}
	return NULL;
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801619:	e8 ee fc ff ff       	call   80130c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80161e:	83 ec 04             	sub    $0x4,%esp
  801621:	68 e4 3e 80 00       	push   $0x803ee4
  801626:	68 ab 00 00 00       	push   $0xab
  80162b:	68 53 3e 80 00       	push   $0x803e53
  801630:	e8 99 ec ff ff       	call   8002ce <_panic>

00801635 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80163b:	e8 cc fc ff ff       	call   80130c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801640:	83 ec 04             	sub    $0x4,%esp
  801643:	68 08 3f 80 00       	push   $0x803f08
  801648:	68 ef 00 00 00       	push   $0xef
  80164d:	68 53 3e 80 00       	push   $0x803e53
  801652:	e8 77 ec ff ff       	call   8002ce <_panic>

00801657 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80165d:	83 ec 04             	sub    $0x4,%esp
  801660:	68 30 3f 80 00       	push   $0x803f30
  801665:	68 03 01 00 00       	push   $0x103
  80166a:	68 53 3e 80 00       	push   $0x803e53
  80166f:	e8 5a ec ff ff       	call   8002ce <_panic>

00801674 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80167a:	83 ec 04             	sub    $0x4,%esp
  80167d:	68 54 3f 80 00       	push   $0x803f54
  801682:	68 0e 01 00 00       	push   $0x10e
  801687:	68 53 3e 80 00       	push   $0x803e53
  80168c:	e8 3d ec ff ff       	call   8002ce <_panic>

00801691 <shrink>:

}
void shrink(uint32 newSize)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
  801694:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801697:	83 ec 04             	sub    $0x4,%esp
  80169a:	68 54 3f 80 00       	push   $0x803f54
  80169f:	68 13 01 00 00       	push   $0x113
  8016a4:	68 53 3e 80 00       	push   $0x803e53
  8016a9:	e8 20 ec ff ff       	call   8002ce <_panic>

008016ae <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016b4:	83 ec 04             	sub    $0x4,%esp
  8016b7:	68 54 3f 80 00       	push   $0x803f54
  8016bc:	68 18 01 00 00       	push   $0x118
  8016c1:	68 53 3e 80 00       	push   $0x803e53
  8016c6:	e8 03 ec ff ff       	call   8002ce <_panic>

008016cb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	57                   	push   %edi
  8016cf:	56                   	push   %esi
  8016d0:	53                   	push   %ebx
  8016d1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016e0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016e3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016e6:	cd 30                	int    $0x30
  8016e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016ee:	83 c4 10             	add    $0x10,%esp
  8016f1:	5b                   	pop    %ebx
  8016f2:	5e                   	pop    %esi
  8016f3:	5f                   	pop    %edi
  8016f4:	5d                   	pop    %ebp
  8016f5:	c3                   	ret    

008016f6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801702:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	52                   	push   %edx
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	50                   	push   %eax
  801712:	6a 00                	push   $0x0
  801714:	e8 b2 ff ff ff       	call   8016cb <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	90                   	nop
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_cgetc>:

int
sys_cgetc(void)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 01                	push   $0x1
  80172e:	e8 98 ff ff ff       	call   8016cb <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80173b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	52                   	push   %edx
  801748:	50                   	push   %eax
  801749:	6a 05                	push   $0x5
  80174b:	e8 7b ff ff ff       	call   8016cb <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	56                   	push   %esi
  801759:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80175a:	8b 75 18             	mov    0x18(%ebp),%esi
  80175d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801760:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801763:	8b 55 0c             	mov    0xc(%ebp),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	56                   	push   %esi
  80176a:	53                   	push   %ebx
  80176b:	51                   	push   %ecx
  80176c:	52                   	push   %edx
  80176d:	50                   	push   %eax
  80176e:	6a 06                	push   $0x6
  801770:	e8 56 ff ff ff       	call   8016cb <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177b:	5b                   	pop    %ebx
  80177c:	5e                   	pop    %esi
  80177d:	5d                   	pop    %ebp
  80177e:	c3                   	ret    

0080177f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801782:	8b 55 0c             	mov    0xc(%ebp),%edx
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	52                   	push   %edx
  80178f:	50                   	push   %eax
  801790:	6a 07                	push   $0x7
  801792:	e8 34 ff ff ff       	call   8016cb <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	ff 75 0c             	pushl  0xc(%ebp)
  8017a8:	ff 75 08             	pushl  0x8(%ebp)
  8017ab:	6a 08                	push   $0x8
  8017ad:	e8 19 ff ff ff       	call   8016cb <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 09                	push   $0x9
  8017c6:	e8 00 ff ff ff       	call   8016cb <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 0a                	push   $0xa
  8017df:	e8 e7 fe ff ff       	call   8016cb <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 0b                	push   $0xb
  8017f8:	e8 ce fe ff ff       	call   8016cb <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	ff 75 08             	pushl  0x8(%ebp)
  801811:	6a 0f                	push   $0xf
  801813:	e8 b3 fe ff ff       	call   8016cb <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
	return;
  80181b:	90                   	nop
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	ff 75 0c             	pushl  0xc(%ebp)
  80182a:	ff 75 08             	pushl  0x8(%ebp)
  80182d:	6a 10                	push   $0x10
  80182f:	e8 97 fe ff ff       	call   8016cb <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
	return ;
  801837:	90                   	nop
}
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	ff 75 10             	pushl  0x10(%ebp)
  801844:	ff 75 0c             	pushl  0xc(%ebp)
  801847:	ff 75 08             	pushl  0x8(%ebp)
  80184a:	6a 11                	push   $0x11
  80184c:	e8 7a fe ff ff       	call   8016cb <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
	return ;
  801854:	90                   	nop
}
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 0c                	push   $0xc
  801866:	e8 60 fe ff ff       	call   8016cb <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	ff 75 08             	pushl  0x8(%ebp)
  80187e:	6a 0d                	push   $0xd
  801880:	e8 46 fe ff ff       	call   8016cb <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 0e                	push   $0xe
  801899:	e8 2d fe ff ff       	call   8016cb <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	90                   	nop
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 13                	push   $0x13
  8018b3:	e8 13 fe ff ff       	call   8016cb <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	90                   	nop
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 14                	push   $0x14
  8018cd:	e8 f9 fd ff ff       	call   8016cb <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	90                   	nop
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 04             	sub    $0x4,%esp
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	50                   	push   %eax
  8018f1:	6a 15                	push   $0x15
  8018f3:	e8 d3 fd ff ff       	call   8016cb <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
}
  8018fb:	90                   	nop
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 16                	push   $0x16
  80190d:	e8 b9 fd ff ff       	call   8016cb <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	90                   	nop
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	50                   	push   %eax
  801928:	6a 17                	push   $0x17
  80192a:	e8 9c fd ff ff       	call   8016cb <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	6a 1a                	push   $0x1a
  801947:	e8 7f fd ff ff       	call   8016cb <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801954:	8b 55 0c             	mov    0xc(%ebp),%edx
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	52                   	push   %edx
  801961:	50                   	push   %eax
  801962:	6a 18                	push   $0x18
  801964:	e8 62 fd ff ff       	call   8016cb <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	90                   	nop
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801972:	8b 55 0c             	mov    0xc(%ebp),%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	52                   	push   %edx
  80197f:	50                   	push   %eax
  801980:	6a 19                	push   $0x19
  801982:	e8 44 fd ff ff       	call   8016cb <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	90                   	nop
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 04             	sub    $0x4,%esp
  801993:	8b 45 10             	mov    0x10(%ebp),%eax
  801996:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801999:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80199c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	6a 00                	push   $0x0
  8019a5:	51                   	push   %ecx
  8019a6:	52                   	push   %edx
  8019a7:	ff 75 0c             	pushl  0xc(%ebp)
  8019aa:	50                   	push   %eax
  8019ab:	6a 1b                	push   $0x1b
  8019ad:	e8 19 fd ff ff       	call   8016cb <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	52                   	push   %edx
  8019c7:	50                   	push   %eax
  8019c8:	6a 1c                	push   $0x1c
  8019ca:	e8 fc fc ff ff       	call   8016cb <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	51                   	push   %ecx
  8019e5:	52                   	push   %edx
  8019e6:	50                   	push   %eax
  8019e7:	6a 1d                	push   $0x1d
  8019e9:	e8 dd fc ff ff       	call   8016cb <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	52                   	push   %edx
  801a03:	50                   	push   %eax
  801a04:	6a 1e                	push   $0x1e
  801a06:	e8 c0 fc ff ff       	call   8016cb <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 1f                	push   $0x1f
  801a1f:	e8 a7 fc ff ff       	call   8016cb <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	6a 00                	push   $0x0
  801a31:	ff 75 14             	pushl  0x14(%ebp)
  801a34:	ff 75 10             	pushl  0x10(%ebp)
  801a37:	ff 75 0c             	pushl  0xc(%ebp)
  801a3a:	50                   	push   %eax
  801a3b:	6a 20                	push   $0x20
  801a3d:	e8 89 fc ff ff       	call   8016cb <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	50                   	push   %eax
  801a56:	6a 21                	push   $0x21
  801a58:	e8 6e fc ff ff       	call   8016cb <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	90                   	nop
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	50                   	push   %eax
  801a72:	6a 22                	push   $0x22
  801a74:	e8 52 fc ff ff       	call   8016cb <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 02                	push   $0x2
  801a8d:	e8 39 fc ff ff       	call   8016cb <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 03                	push   $0x3
  801aa6:	e8 20 fc ff ff       	call   8016cb <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 04                	push   $0x4
  801abf:	e8 07 fc ff ff       	call   8016cb <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_exit_env>:


void sys_exit_env(void)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 23                	push   $0x23
  801ad8:	e8 ee fb ff ff       	call   8016cb <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	90                   	nop
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ae9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aec:	8d 50 04             	lea    0x4(%eax),%edx
  801aef:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	52                   	push   %edx
  801af9:	50                   	push   %eax
  801afa:	6a 24                	push   $0x24
  801afc:	e8 ca fb ff ff       	call   8016cb <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
	return result;
  801b04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b0d:	89 01                	mov    %eax,(%ecx)
  801b0f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	c9                   	leave  
  801b16:	c2 04 00             	ret    $0x4

00801b19 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	ff 75 10             	pushl  0x10(%ebp)
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	ff 75 08             	pushl  0x8(%ebp)
  801b29:	6a 12                	push   $0x12
  801b2b:	e8 9b fb ff ff       	call   8016cb <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
	return ;
  801b33:	90                   	nop
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 25                	push   $0x25
  801b45:	e8 81 fb ff ff       	call   8016cb <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 04             	sub    $0x4,%esp
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b5b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	50                   	push   %eax
  801b68:	6a 26                	push   $0x26
  801b6a:	e8 5c fb ff ff       	call   8016cb <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b72:	90                   	nop
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <rsttst>:
void rsttst()
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 28                	push   $0x28
  801b84:	e8 42 fb ff ff       	call   8016cb <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8c:	90                   	nop
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 04             	sub    $0x4,%esp
  801b95:	8b 45 14             	mov    0x14(%ebp),%eax
  801b98:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b9b:	8b 55 18             	mov    0x18(%ebp),%edx
  801b9e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ba2:	52                   	push   %edx
  801ba3:	50                   	push   %eax
  801ba4:	ff 75 10             	pushl  0x10(%ebp)
  801ba7:	ff 75 0c             	pushl  0xc(%ebp)
  801baa:	ff 75 08             	pushl  0x8(%ebp)
  801bad:	6a 27                	push   $0x27
  801baf:	e8 17 fb ff ff       	call   8016cb <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb7:	90                   	nop
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <chktst>:
void chktst(uint32 n)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	ff 75 08             	pushl  0x8(%ebp)
  801bc8:	6a 29                	push   $0x29
  801bca:	e8 fc fa ff ff       	call   8016cb <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd2:	90                   	nop
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <inctst>:

void inctst()
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 2a                	push   $0x2a
  801be4:	e8 e2 fa ff ff       	call   8016cb <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bec:	90                   	nop
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <gettst>:
uint32 gettst()
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 2b                	push   $0x2b
  801bfe:	e8 c8 fa ff ff       	call   8016cb <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 2c                	push   $0x2c
  801c1a:	e8 ac fa ff ff       	call   8016cb <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
  801c22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c25:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c29:	75 07                	jne    801c32 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c30:	eb 05                	jmp    801c37 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 2c                	push   $0x2c
  801c4b:	e8 7b fa ff ff       	call   8016cb <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
  801c53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c56:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c5a:	75 07                	jne    801c63 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c61:	eb 05                	jmp    801c68 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 2c                	push   $0x2c
  801c7c:	e8 4a fa ff ff       	call   8016cb <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
  801c84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c87:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c8b:	75 07                	jne    801c94 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c92:	eb 05                	jmp    801c99 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 2c                	push   $0x2c
  801cad:	e8 19 fa ff ff       	call   8016cb <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
  801cb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cb8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cbc:	75 07                	jne    801cc5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc3:	eb 05                	jmp    801cca <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	ff 75 08             	pushl  0x8(%ebp)
  801cda:	6a 2d                	push   $0x2d
  801cdc:	e8 ea f9 ff ff       	call   8016cb <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce4:	90                   	nop
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ceb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	6a 00                	push   $0x0
  801cf9:	53                   	push   %ebx
  801cfa:	51                   	push   %ecx
  801cfb:	52                   	push   %edx
  801cfc:	50                   	push   %eax
  801cfd:	6a 2e                	push   $0x2e
  801cff:	e8 c7 f9 ff ff       	call   8016cb <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
}
  801d07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	52                   	push   %edx
  801d1c:	50                   	push   %eax
  801d1d:	6a 2f                	push   $0x2f
  801d1f:	e8 a7 f9 ff ff       	call   8016cb <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d2f:	83 ec 0c             	sub    $0xc,%esp
  801d32:	68 64 3f 80 00       	push   $0x803f64
  801d37:	e8 46 e8 ff ff       	call   800582 <cprintf>
  801d3c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d3f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d46:	83 ec 0c             	sub    $0xc,%esp
  801d49:	68 90 3f 80 00       	push   $0x803f90
  801d4e:	e8 2f e8 ff ff       	call   800582 <cprintf>
  801d53:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d56:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d5a:	a1 38 51 80 00       	mov    0x805138,%eax
  801d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d62:	eb 56                	jmp    801dba <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d68:	74 1c                	je     801d86 <print_mem_block_lists+0x5d>
  801d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6d:	8b 50 08             	mov    0x8(%eax),%edx
  801d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d73:	8b 48 08             	mov    0x8(%eax),%ecx
  801d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d79:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7c:	01 c8                	add    %ecx,%eax
  801d7e:	39 c2                	cmp    %eax,%edx
  801d80:	73 04                	jae    801d86 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d82:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d89:	8b 50 08             	mov    0x8(%eax),%edx
  801d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d92:	01 c2                	add    %eax,%edx
  801d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d97:	8b 40 08             	mov    0x8(%eax),%eax
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	52                   	push   %edx
  801d9e:	50                   	push   %eax
  801d9f:	68 a5 3f 80 00       	push   $0x803fa5
  801da4:	e8 d9 e7 ff ff       	call   800582 <cprintf>
  801da9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801db2:	a1 40 51 80 00       	mov    0x805140,%eax
  801db7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dbe:	74 07                	je     801dc7 <print_mem_block_lists+0x9e>
  801dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc3:	8b 00                	mov    (%eax),%eax
  801dc5:	eb 05                	jmp    801dcc <print_mem_block_lists+0xa3>
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcc:	a3 40 51 80 00       	mov    %eax,0x805140
  801dd1:	a1 40 51 80 00       	mov    0x805140,%eax
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	75 8a                	jne    801d64 <print_mem_block_lists+0x3b>
  801dda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dde:	75 84                	jne    801d64 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801de0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801de4:	75 10                	jne    801df6 <print_mem_block_lists+0xcd>
  801de6:	83 ec 0c             	sub    $0xc,%esp
  801de9:	68 b4 3f 80 00       	push   $0x803fb4
  801dee:	e8 8f e7 ff ff       	call   800582 <cprintf>
  801df3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801df6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dfd:	83 ec 0c             	sub    $0xc,%esp
  801e00:	68 d8 3f 80 00       	push   $0x803fd8
  801e05:	e8 78 e7 ff ff       	call   800582 <cprintf>
  801e0a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e0d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e11:	a1 40 50 80 00       	mov    0x805040,%eax
  801e16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e19:	eb 56                	jmp    801e71 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e1f:	74 1c                	je     801e3d <print_mem_block_lists+0x114>
  801e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e24:	8b 50 08             	mov    0x8(%eax),%edx
  801e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2a:	8b 48 08             	mov    0x8(%eax),%ecx
  801e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e30:	8b 40 0c             	mov    0xc(%eax),%eax
  801e33:	01 c8                	add    %ecx,%eax
  801e35:	39 c2                	cmp    %eax,%edx
  801e37:	73 04                	jae    801e3d <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e39:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e40:	8b 50 08             	mov    0x8(%eax),%edx
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	8b 40 0c             	mov    0xc(%eax),%eax
  801e49:	01 c2                	add    %eax,%edx
  801e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4e:	8b 40 08             	mov    0x8(%eax),%eax
  801e51:	83 ec 04             	sub    $0x4,%esp
  801e54:	52                   	push   %edx
  801e55:	50                   	push   %eax
  801e56:	68 a5 3f 80 00       	push   $0x803fa5
  801e5b:	e8 22 e7 ff ff       	call   800582 <cprintf>
  801e60:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e66:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e69:	a1 48 50 80 00       	mov    0x805048,%eax
  801e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e75:	74 07                	je     801e7e <print_mem_block_lists+0x155>
  801e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7a:	8b 00                	mov    (%eax),%eax
  801e7c:	eb 05                	jmp    801e83 <print_mem_block_lists+0x15a>
  801e7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e83:	a3 48 50 80 00       	mov    %eax,0x805048
  801e88:	a1 48 50 80 00       	mov    0x805048,%eax
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	75 8a                	jne    801e1b <print_mem_block_lists+0xf2>
  801e91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e95:	75 84                	jne    801e1b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e97:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e9b:	75 10                	jne    801ead <print_mem_block_lists+0x184>
  801e9d:	83 ec 0c             	sub    $0xc,%esp
  801ea0:	68 f0 3f 80 00       	push   $0x803ff0
  801ea5:	e8 d8 e6 ff ff       	call   800582 <cprintf>
  801eaa:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ead:	83 ec 0c             	sub    $0xc,%esp
  801eb0:	68 64 3f 80 00       	push   $0x803f64
  801eb5:	e8 c8 e6 ff ff       	call   800582 <cprintf>
  801eba:	83 c4 10             	add    $0x10,%esp

}
  801ebd:	90                   	nop
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ec6:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ecd:	00 00 00 
  801ed0:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ed7:	00 00 00 
  801eda:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ee1:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ee4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eeb:	e9 9e 00 00 00       	jmp    801f8e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ef0:	a1 50 50 80 00       	mov    0x805050,%eax
  801ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef8:	c1 e2 04             	shl    $0x4,%edx
  801efb:	01 d0                	add    %edx,%eax
  801efd:	85 c0                	test   %eax,%eax
  801eff:	75 14                	jne    801f15 <initialize_MemBlocksList+0x55>
  801f01:	83 ec 04             	sub    $0x4,%esp
  801f04:	68 18 40 80 00       	push   $0x804018
  801f09:	6a 46                	push   $0x46
  801f0b:	68 3b 40 80 00       	push   $0x80403b
  801f10:	e8 b9 e3 ff ff       	call   8002ce <_panic>
  801f15:	a1 50 50 80 00       	mov    0x805050,%eax
  801f1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1d:	c1 e2 04             	shl    $0x4,%edx
  801f20:	01 d0                	add    %edx,%eax
  801f22:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f28:	89 10                	mov    %edx,(%eax)
  801f2a:	8b 00                	mov    (%eax),%eax
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	74 18                	je     801f48 <initialize_MemBlocksList+0x88>
  801f30:	a1 48 51 80 00       	mov    0x805148,%eax
  801f35:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f3b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f3e:	c1 e1 04             	shl    $0x4,%ecx
  801f41:	01 ca                	add    %ecx,%edx
  801f43:	89 50 04             	mov    %edx,0x4(%eax)
  801f46:	eb 12                	jmp    801f5a <initialize_MemBlocksList+0x9a>
  801f48:	a1 50 50 80 00       	mov    0x805050,%eax
  801f4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f50:	c1 e2 04             	shl    $0x4,%edx
  801f53:	01 d0                	add    %edx,%eax
  801f55:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f5a:	a1 50 50 80 00       	mov    0x805050,%eax
  801f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f62:	c1 e2 04             	shl    $0x4,%edx
  801f65:	01 d0                	add    %edx,%eax
  801f67:	a3 48 51 80 00       	mov    %eax,0x805148
  801f6c:	a1 50 50 80 00       	mov    0x805050,%eax
  801f71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f74:	c1 e2 04             	shl    $0x4,%edx
  801f77:	01 d0                	add    %edx,%eax
  801f79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f80:	a1 54 51 80 00       	mov    0x805154,%eax
  801f85:	40                   	inc    %eax
  801f86:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f8b:	ff 45 f4             	incl   -0xc(%ebp)
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f94:	0f 82 56 ff ff ff    	jb     801ef0 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f9a:	90                   	nop
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	8b 00                	mov    (%eax),%eax
  801fa8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fab:	eb 19                	jmp    801fc6 <find_block+0x29>
	{
		if(va==point->sva)
  801fad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb0:	8b 40 08             	mov    0x8(%eax),%eax
  801fb3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fb6:	75 05                	jne    801fbd <find_block+0x20>
		   return point;
  801fb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fbb:	eb 36                	jmp    801ff3 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	8b 40 08             	mov    0x8(%eax),%eax
  801fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fca:	74 07                	je     801fd3 <find_block+0x36>
  801fcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fcf:	8b 00                	mov    (%eax),%eax
  801fd1:	eb 05                	jmp    801fd8 <find_block+0x3b>
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	8b 55 08             	mov    0x8(%ebp),%edx
  801fdb:	89 42 08             	mov    %eax,0x8(%edx)
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	8b 40 08             	mov    0x8(%eax),%eax
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	75 c5                	jne    801fad <find_block+0x10>
  801fe8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fec:	75 bf                	jne    801fad <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801ffb:	a1 40 50 80 00       	mov    0x805040,%eax
  802000:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802003:	a1 44 50 80 00       	mov    0x805044,%eax
  802008:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80200b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802011:	74 24                	je     802037 <insert_sorted_allocList+0x42>
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	8b 50 08             	mov    0x8(%eax),%edx
  802019:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201c:	8b 40 08             	mov    0x8(%eax),%eax
  80201f:	39 c2                	cmp    %eax,%edx
  802021:	76 14                	jbe    802037 <insert_sorted_allocList+0x42>
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	8b 50 08             	mov    0x8(%eax),%edx
  802029:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202c:	8b 40 08             	mov    0x8(%eax),%eax
  80202f:	39 c2                	cmp    %eax,%edx
  802031:	0f 82 60 01 00 00    	jb     802197 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802037:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80203b:	75 65                	jne    8020a2 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80203d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802041:	75 14                	jne    802057 <insert_sorted_allocList+0x62>
  802043:	83 ec 04             	sub    $0x4,%esp
  802046:	68 18 40 80 00       	push   $0x804018
  80204b:	6a 6b                	push   $0x6b
  80204d:	68 3b 40 80 00       	push   $0x80403b
  802052:	e8 77 e2 ff ff       	call   8002ce <_panic>
  802057:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80205d:	8b 45 08             	mov    0x8(%ebp),%eax
  802060:	89 10                	mov    %edx,(%eax)
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	8b 00                	mov    (%eax),%eax
  802067:	85 c0                	test   %eax,%eax
  802069:	74 0d                	je     802078 <insert_sorted_allocList+0x83>
  80206b:	a1 40 50 80 00       	mov    0x805040,%eax
  802070:	8b 55 08             	mov    0x8(%ebp),%edx
  802073:	89 50 04             	mov    %edx,0x4(%eax)
  802076:	eb 08                	jmp    802080 <insert_sorted_allocList+0x8b>
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	a3 44 50 80 00       	mov    %eax,0x805044
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	a3 40 50 80 00       	mov    %eax,0x805040
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802092:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802097:	40                   	inc    %eax
  802098:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80209d:	e9 dc 01 00 00       	jmp    80227e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	8b 50 08             	mov    0x8(%eax),%edx
  8020a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ab:	8b 40 08             	mov    0x8(%eax),%eax
  8020ae:	39 c2                	cmp    %eax,%edx
  8020b0:	77 6c                	ja     80211e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020b6:	74 06                	je     8020be <insert_sorted_allocList+0xc9>
  8020b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020bc:	75 14                	jne    8020d2 <insert_sorted_allocList+0xdd>
  8020be:	83 ec 04             	sub    $0x4,%esp
  8020c1:	68 54 40 80 00       	push   $0x804054
  8020c6:	6a 6f                	push   $0x6f
  8020c8:	68 3b 40 80 00       	push   $0x80403b
  8020cd:	e8 fc e1 ff ff       	call   8002ce <_panic>
  8020d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d5:	8b 50 04             	mov    0x4(%eax),%edx
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	89 50 04             	mov    %edx,0x4(%eax)
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020e4:	89 10                	mov    %edx,(%eax)
  8020e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e9:	8b 40 04             	mov    0x4(%eax),%eax
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	74 0d                	je     8020fd <insert_sorted_allocList+0x108>
  8020f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f3:	8b 40 04             	mov    0x4(%eax),%eax
  8020f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f9:	89 10                	mov    %edx,(%eax)
  8020fb:	eb 08                	jmp    802105 <insert_sorted_allocList+0x110>
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	a3 40 50 80 00       	mov    %eax,0x805040
  802105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802108:	8b 55 08             	mov    0x8(%ebp),%edx
  80210b:	89 50 04             	mov    %edx,0x4(%eax)
  80210e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802113:	40                   	inc    %eax
  802114:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802119:	e9 60 01 00 00       	jmp    80227e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80211e:	8b 45 08             	mov    0x8(%ebp),%eax
  802121:	8b 50 08             	mov    0x8(%eax),%edx
  802124:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802127:	8b 40 08             	mov    0x8(%eax),%eax
  80212a:	39 c2                	cmp    %eax,%edx
  80212c:	0f 82 4c 01 00 00    	jb     80227e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802132:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802136:	75 14                	jne    80214c <insert_sorted_allocList+0x157>
  802138:	83 ec 04             	sub    $0x4,%esp
  80213b:	68 8c 40 80 00       	push   $0x80408c
  802140:	6a 73                	push   $0x73
  802142:	68 3b 40 80 00       	push   $0x80403b
  802147:	e8 82 e1 ff ff       	call   8002ce <_panic>
  80214c:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	89 50 04             	mov    %edx,0x4(%eax)
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	8b 40 04             	mov    0x4(%eax),%eax
  80215e:	85 c0                	test   %eax,%eax
  802160:	74 0c                	je     80216e <insert_sorted_allocList+0x179>
  802162:	a1 44 50 80 00       	mov    0x805044,%eax
  802167:	8b 55 08             	mov    0x8(%ebp),%edx
  80216a:	89 10                	mov    %edx,(%eax)
  80216c:	eb 08                	jmp    802176 <insert_sorted_allocList+0x181>
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	a3 40 50 80 00       	mov    %eax,0x805040
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	a3 44 50 80 00       	mov    %eax,0x805044
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802187:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80218c:	40                   	inc    %eax
  80218d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802192:	e9 e7 00 00 00       	jmp    80227e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80219d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021a4:	a1 40 50 80 00       	mov    0x805040,%eax
  8021a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ac:	e9 9d 00 00 00       	jmp    80224e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 00                	mov    (%eax),%eax
  8021b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	8b 50 08             	mov    0x8(%eax),%edx
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	8b 40 08             	mov    0x8(%eax),%eax
  8021c5:	39 c2                	cmp    %eax,%edx
  8021c7:	76 7d                	jbe    802246 <insert_sorted_allocList+0x251>
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	8b 50 08             	mov    0x8(%eax),%edx
  8021cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021d2:	8b 40 08             	mov    0x8(%eax),%eax
  8021d5:	39 c2                	cmp    %eax,%edx
  8021d7:	73 6d                	jae    802246 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021dd:	74 06                	je     8021e5 <insert_sorted_allocList+0x1f0>
  8021df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e3:	75 14                	jne    8021f9 <insert_sorted_allocList+0x204>
  8021e5:	83 ec 04             	sub    $0x4,%esp
  8021e8:	68 b0 40 80 00       	push   $0x8040b0
  8021ed:	6a 7f                	push   $0x7f
  8021ef:	68 3b 40 80 00       	push   $0x80403b
  8021f4:	e8 d5 e0 ff ff       	call   8002ce <_panic>
  8021f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fc:	8b 10                	mov    (%eax),%edx
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	89 10                	mov    %edx,(%eax)
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	8b 00                	mov    (%eax),%eax
  802208:	85 c0                	test   %eax,%eax
  80220a:	74 0b                	je     802217 <insert_sorted_allocList+0x222>
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	8b 00                	mov    (%eax),%eax
  802211:	8b 55 08             	mov    0x8(%ebp),%edx
  802214:	89 50 04             	mov    %edx,0x4(%eax)
  802217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221a:	8b 55 08             	mov    0x8(%ebp),%edx
  80221d:	89 10                	mov    %edx,(%eax)
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802225:	89 50 04             	mov    %edx,0x4(%eax)
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	8b 00                	mov    (%eax),%eax
  80222d:	85 c0                	test   %eax,%eax
  80222f:	75 08                	jne    802239 <insert_sorted_allocList+0x244>
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	a3 44 50 80 00       	mov    %eax,0x805044
  802239:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80223e:	40                   	inc    %eax
  80223f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802244:	eb 39                	jmp    80227f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802246:	a1 48 50 80 00       	mov    0x805048,%eax
  80224b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802252:	74 07                	je     80225b <insert_sorted_allocList+0x266>
  802254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802257:	8b 00                	mov    (%eax),%eax
  802259:	eb 05                	jmp    802260 <insert_sorted_allocList+0x26b>
  80225b:	b8 00 00 00 00       	mov    $0x0,%eax
  802260:	a3 48 50 80 00       	mov    %eax,0x805048
  802265:	a1 48 50 80 00       	mov    0x805048,%eax
  80226a:	85 c0                	test   %eax,%eax
  80226c:	0f 85 3f ff ff ff    	jne    8021b1 <insert_sorted_allocList+0x1bc>
  802272:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802276:	0f 85 35 ff ff ff    	jne    8021b1 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80227c:	eb 01                	jmp    80227f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80227e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80227f:	90                   	nop
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802288:	a1 38 51 80 00       	mov    0x805138,%eax
  80228d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802290:	e9 85 01 00 00       	jmp    80241a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	8b 40 0c             	mov    0xc(%eax),%eax
  80229b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80229e:	0f 82 6e 01 00 00    	jb     802412 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8022aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ad:	0f 85 8a 00 00 00    	jne    80233d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b7:	75 17                	jne    8022d0 <alloc_block_FF+0x4e>
  8022b9:	83 ec 04             	sub    $0x4,%esp
  8022bc:	68 e4 40 80 00       	push   $0x8040e4
  8022c1:	68 93 00 00 00       	push   $0x93
  8022c6:	68 3b 40 80 00       	push   $0x80403b
  8022cb:	e8 fe df ff ff       	call   8002ce <_panic>
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	8b 00                	mov    (%eax),%eax
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	74 10                	je     8022e9 <alloc_block_FF+0x67>
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	8b 00                	mov    (%eax),%eax
  8022de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e1:	8b 52 04             	mov    0x4(%edx),%edx
  8022e4:	89 50 04             	mov    %edx,0x4(%eax)
  8022e7:	eb 0b                	jmp    8022f4 <alloc_block_FF+0x72>
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 40 04             	mov    0x4(%eax),%eax
  8022ef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 40 04             	mov    0x4(%eax),%eax
  8022fa:	85 c0                	test   %eax,%eax
  8022fc:	74 0f                	je     80230d <alloc_block_FF+0x8b>
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	8b 40 04             	mov    0x4(%eax),%eax
  802304:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802307:	8b 12                	mov    (%edx),%edx
  802309:	89 10                	mov    %edx,(%eax)
  80230b:	eb 0a                	jmp    802317 <alloc_block_FF+0x95>
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8b 00                	mov    (%eax),%eax
  802312:	a3 38 51 80 00       	mov    %eax,0x805138
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80232a:	a1 44 51 80 00       	mov    0x805144,%eax
  80232f:	48                   	dec    %eax
  802330:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802338:	e9 10 01 00 00       	jmp    80244d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 40 0c             	mov    0xc(%eax),%eax
  802343:	3b 45 08             	cmp    0x8(%ebp),%eax
  802346:	0f 86 c6 00 00 00    	jbe    802412 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80234c:	a1 48 51 80 00       	mov    0x805148,%eax
  802351:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 50 08             	mov    0x8(%eax),%edx
  80235a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802363:	8b 55 08             	mov    0x8(%ebp),%edx
  802366:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802369:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80236d:	75 17                	jne    802386 <alloc_block_FF+0x104>
  80236f:	83 ec 04             	sub    $0x4,%esp
  802372:	68 e4 40 80 00       	push   $0x8040e4
  802377:	68 9b 00 00 00       	push   $0x9b
  80237c:	68 3b 40 80 00       	push   $0x80403b
  802381:	e8 48 df ff ff       	call   8002ce <_panic>
  802386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802389:	8b 00                	mov    (%eax),%eax
  80238b:	85 c0                	test   %eax,%eax
  80238d:	74 10                	je     80239f <alloc_block_FF+0x11d>
  80238f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802392:	8b 00                	mov    (%eax),%eax
  802394:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802397:	8b 52 04             	mov    0x4(%edx),%edx
  80239a:	89 50 04             	mov    %edx,0x4(%eax)
  80239d:	eb 0b                	jmp    8023aa <alloc_block_FF+0x128>
  80239f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a2:	8b 40 04             	mov    0x4(%eax),%eax
  8023a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ad:	8b 40 04             	mov    0x4(%eax),%eax
  8023b0:	85 c0                	test   %eax,%eax
  8023b2:	74 0f                	je     8023c3 <alloc_block_FF+0x141>
  8023b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023bd:	8b 12                	mov    (%edx),%edx
  8023bf:	89 10                	mov    %edx,(%eax)
  8023c1:	eb 0a                	jmp    8023cd <alloc_block_FF+0x14b>
  8023c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c6:	8b 00                	mov    (%eax),%eax
  8023c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8023cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e0:	a1 54 51 80 00       	mov    0x805154,%eax
  8023e5:	48                   	dec    %eax
  8023e6:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 50 08             	mov    0x8(%eax),%edx
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	01 c2                	add    %eax,%edx
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802402:	2b 45 08             	sub    0x8(%ebp),%eax
  802405:	89 c2                	mov    %eax,%edx
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80240d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802410:	eb 3b                	jmp    80244d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802412:	a1 40 51 80 00       	mov    0x805140,%eax
  802417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80241a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241e:	74 07                	je     802427 <alloc_block_FF+0x1a5>
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 00                	mov    (%eax),%eax
  802425:	eb 05                	jmp    80242c <alloc_block_FF+0x1aa>
  802427:	b8 00 00 00 00       	mov    $0x0,%eax
  80242c:	a3 40 51 80 00       	mov    %eax,0x805140
  802431:	a1 40 51 80 00       	mov    0x805140,%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	0f 85 57 fe ff ff    	jne    802295 <alloc_block_FF+0x13>
  80243e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802442:	0f 85 4d fe ff ff    	jne    802295 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802455:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80245c:	a1 38 51 80 00       	mov    0x805138,%eax
  802461:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802464:	e9 df 00 00 00       	jmp    802548 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	8b 40 0c             	mov    0xc(%eax),%eax
  80246f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802472:	0f 82 c8 00 00 00    	jb     802540 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 40 0c             	mov    0xc(%eax),%eax
  80247e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802481:	0f 85 8a 00 00 00    	jne    802511 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802487:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248b:	75 17                	jne    8024a4 <alloc_block_BF+0x55>
  80248d:	83 ec 04             	sub    $0x4,%esp
  802490:	68 e4 40 80 00       	push   $0x8040e4
  802495:	68 b7 00 00 00       	push   $0xb7
  80249a:	68 3b 40 80 00       	push   $0x80403b
  80249f:	e8 2a de ff ff       	call   8002ce <_panic>
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 00                	mov    (%eax),%eax
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	74 10                	je     8024bd <alloc_block_BF+0x6e>
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 00                	mov    (%eax),%eax
  8024b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b5:	8b 52 04             	mov    0x4(%edx),%edx
  8024b8:	89 50 04             	mov    %edx,0x4(%eax)
  8024bb:	eb 0b                	jmp    8024c8 <alloc_block_BF+0x79>
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	8b 40 04             	mov    0x4(%eax),%eax
  8024c3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 40 04             	mov    0x4(%eax),%eax
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	74 0f                	je     8024e1 <alloc_block_BF+0x92>
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	8b 40 04             	mov    0x4(%eax),%eax
  8024d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024db:	8b 12                	mov    (%edx),%edx
  8024dd:	89 10                	mov    %edx,(%eax)
  8024df:	eb 0a                	jmp    8024eb <alloc_block_BF+0x9c>
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 00                	mov    (%eax),%eax
  8024e6:	a3 38 51 80 00       	mov    %eax,0x805138
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024fe:	a1 44 51 80 00       	mov    0x805144,%eax
  802503:	48                   	dec    %eax
  802504:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	e9 4d 01 00 00       	jmp    80265e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 40 0c             	mov    0xc(%eax),%eax
  802517:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251a:	76 24                	jbe    802540 <alloc_block_BF+0xf1>
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 40 0c             	mov    0xc(%eax),%eax
  802522:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802525:	73 19                	jae    802540 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802527:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	8b 40 0c             	mov    0xc(%eax),%eax
  802534:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 08             	mov    0x8(%eax),%eax
  80253d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802540:	a1 40 51 80 00       	mov    0x805140,%eax
  802545:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254c:	74 07                	je     802555 <alloc_block_BF+0x106>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	eb 05                	jmp    80255a <alloc_block_BF+0x10b>
  802555:	b8 00 00 00 00       	mov    $0x0,%eax
  80255a:	a3 40 51 80 00       	mov    %eax,0x805140
  80255f:	a1 40 51 80 00       	mov    0x805140,%eax
  802564:	85 c0                	test   %eax,%eax
  802566:	0f 85 fd fe ff ff    	jne    802469 <alloc_block_BF+0x1a>
  80256c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802570:	0f 85 f3 fe ff ff    	jne    802469 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802576:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80257a:	0f 84 d9 00 00 00    	je     802659 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802580:	a1 48 51 80 00       	mov    0x805148,%eax
  802585:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80258e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802594:	8b 55 08             	mov    0x8(%ebp),%edx
  802597:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80259a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80259e:	75 17                	jne    8025b7 <alloc_block_BF+0x168>
  8025a0:	83 ec 04             	sub    $0x4,%esp
  8025a3:	68 e4 40 80 00       	push   $0x8040e4
  8025a8:	68 c7 00 00 00       	push   $0xc7
  8025ad:	68 3b 40 80 00       	push   $0x80403b
  8025b2:	e8 17 dd ff ff       	call   8002ce <_panic>
  8025b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	74 10                	je     8025d0 <alloc_block_BF+0x181>
  8025c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025c8:	8b 52 04             	mov    0x4(%edx),%edx
  8025cb:	89 50 04             	mov    %edx,0x4(%eax)
  8025ce:	eb 0b                	jmp    8025db <alloc_block_BF+0x18c>
  8025d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d3:	8b 40 04             	mov    0x4(%eax),%eax
  8025d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025de:	8b 40 04             	mov    0x4(%eax),%eax
  8025e1:	85 c0                	test   %eax,%eax
  8025e3:	74 0f                	je     8025f4 <alloc_block_BF+0x1a5>
  8025e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e8:	8b 40 04             	mov    0x4(%eax),%eax
  8025eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025ee:	8b 12                	mov    (%edx),%edx
  8025f0:	89 10                	mov    %edx,(%eax)
  8025f2:	eb 0a                	jmp    8025fe <alloc_block_BF+0x1af>
  8025f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f7:	8b 00                	mov    (%eax),%eax
  8025f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8025fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802601:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802611:	a1 54 51 80 00       	mov    0x805154,%eax
  802616:	48                   	dec    %eax
  802617:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80261c:	83 ec 08             	sub    $0x8,%esp
  80261f:	ff 75 ec             	pushl  -0x14(%ebp)
  802622:	68 38 51 80 00       	push   $0x805138
  802627:	e8 71 f9 ff ff       	call   801f9d <find_block>
  80262c:	83 c4 10             	add    $0x10,%esp
  80262f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802635:	8b 50 08             	mov    0x8(%eax),%edx
  802638:	8b 45 08             	mov    0x8(%ebp),%eax
  80263b:	01 c2                	add    %eax,%edx
  80263d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802640:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802643:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802646:	8b 40 0c             	mov    0xc(%eax),%eax
  802649:	2b 45 08             	sub    0x8(%ebp),%eax
  80264c:	89 c2                	mov    %eax,%edx
  80264e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802651:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802654:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802657:	eb 05                	jmp    80265e <alloc_block_BF+0x20f>
	}
	return NULL;
  802659:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80265e:	c9                   	leave  
  80265f:	c3                   	ret    

00802660 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
  802663:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802666:	a1 28 50 80 00       	mov    0x805028,%eax
  80266b:	85 c0                	test   %eax,%eax
  80266d:	0f 85 de 01 00 00    	jne    802851 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802673:	a1 38 51 80 00       	mov    0x805138,%eax
  802678:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267b:	e9 9e 01 00 00       	jmp    80281e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 40 0c             	mov    0xc(%eax),%eax
  802686:	3b 45 08             	cmp    0x8(%ebp),%eax
  802689:	0f 82 87 01 00 00    	jb     802816 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 0c             	mov    0xc(%eax),%eax
  802695:	3b 45 08             	cmp    0x8(%ebp),%eax
  802698:	0f 85 95 00 00 00    	jne    802733 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80269e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a2:	75 17                	jne    8026bb <alloc_block_NF+0x5b>
  8026a4:	83 ec 04             	sub    $0x4,%esp
  8026a7:	68 e4 40 80 00       	push   $0x8040e4
  8026ac:	68 e0 00 00 00       	push   $0xe0
  8026b1:	68 3b 40 80 00       	push   $0x80403b
  8026b6:	e8 13 dc ff ff       	call   8002ce <_panic>
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	8b 00                	mov    (%eax),%eax
  8026c0:	85 c0                	test   %eax,%eax
  8026c2:	74 10                	je     8026d4 <alloc_block_NF+0x74>
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cc:	8b 52 04             	mov    0x4(%edx),%edx
  8026cf:	89 50 04             	mov    %edx,0x4(%eax)
  8026d2:	eb 0b                	jmp    8026df <alloc_block_NF+0x7f>
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 40 04             	mov    0x4(%eax),%eax
  8026da:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 40 04             	mov    0x4(%eax),%eax
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	74 0f                	je     8026f8 <alloc_block_NF+0x98>
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	8b 40 04             	mov    0x4(%eax),%eax
  8026ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f2:	8b 12                	mov    (%edx),%edx
  8026f4:	89 10                	mov    %edx,(%eax)
  8026f6:	eb 0a                	jmp    802702 <alloc_block_NF+0xa2>
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 00                	mov    (%eax),%eax
  8026fd:	a3 38 51 80 00       	mov    %eax,0x805138
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802715:	a1 44 51 80 00       	mov    0x805144,%eax
  80271a:	48                   	dec    %eax
  80271b:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 40 08             	mov    0x8(%eax),%eax
  802726:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	e9 f8 04 00 00       	jmp    802c2b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 40 0c             	mov    0xc(%eax),%eax
  802739:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273c:	0f 86 d4 00 00 00    	jbe    802816 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802742:	a1 48 51 80 00       	mov    0x805148,%eax
  802747:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 50 08             	mov    0x8(%eax),%edx
  802750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802753:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802759:	8b 55 08             	mov    0x8(%ebp),%edx
  80275c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80275f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802763:	75 17                	jne    80277c <alloc_block_NF+0x11c>
  802765:	83 ec 04             	sub    $0x4,%esp
  802768:	68 e4 40 80 00       	push   $0x8040e4
  80276d:	68 e9 00 00 00       	push   $0xe9
  802772:	68 3b 40 80 00       	push   $0x80403b
  802777:	e8 52 db ff ff       	call   8002ce <_panic>
  80277c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277f:	8b 00                	mov    (%eax),%eax
  802781:	85 c0                	test   %eax,%eax
  802783:	74 10                	je     802795 <alloc_block_NF+0x135>
  802785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802788:	8b 00                	mov    (%eax),%eax
  80278a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80278d:	8b 52 04             	mov    0x4(%edx),%edx
  802790:	89 50 04             	mov    %edx,0x4(%eax)
  802793:	eb 0b                	jmp    8027a0 <alloc_block_NF+0x140>
  802795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802798:	8b 40 04             	mov    0x4(%eax),%eax
  80279b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	8b 40 04             	mov    0x4(%eax),%eax
  8027a6:	85 c0                	test   %eax,%eax
  8027a8:	74 0f                	je     8027b9 <alloc_block_NF+0x159>
  8027aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ad:	8b 40 04             	mov    0x4(%eax),%eax
  8027b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027b3:	8b 12                	mov    (%edx),%edx
  8027b5:	89 10                	mov    %edx,(%eax)
  8027b7:	eb 0a                	jmp    8027c3 <alloc_block_NF+0x163>
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	8b 00                	mov    (%eax),%eax
  8027be:	a3 48 51 80 00       	mov    %eax,0x805148
  8027c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8027db:	48                   	dec    %eax
  8027dc:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e4:	8b 40 08             	mov    0x8(%eax),%eax
  8027e7:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	8b 50 08             	mov    0x8(%eax),%edx
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	01 c2                	add    %eax,%edx
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 40 0c             	mov    0xc(%eax),%eax
  802803:	2b 45 08             	sub    0x8(%ebp),%eax
  802806:	89 c2                	mov    %eax,%edx
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802811:	e9 15 04 00 00       	jmp    802c2b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802816:	a1 40 51 80 00       	mov    0x805140,%eax
  80281b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802822:	74 07                	je     80282b <alloc_block_NF+0x1cb>
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	eb 05                	jmp    802830 <alloc_block_NF+0x1d0>
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
  802830:	a3 40 51 80 00       	mov    %eax,0x805140
  802835:	a1 40 51 80 00       	mov    0x805140,%eax
  80283a:	85 c0                	test   %eax,%eax
  80283c:	0f 85 3e fe ff ff    	jne    802680 <alloc_block_NF+0x20>
  802842:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802846:	0f 85 34 fe ff ff    	jne    802680 <alloc_block_NF+0x20>
  80284c:	e9 d5 03 00 00       	jmp    802c26 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802851:	a1 38 51 80 00       	mov    0x805138,%eax
  802856:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802859:	e9 b1 01 00 00       	jmp    802a0f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 50 08             	mov    0x8(%eax),%edx
  802864:	a1 28 50 80 00       	mov    0x805028,%eax
  802869:	39 c2                	cmp    %eax,%edx
  80286b:	0f 82 96 01 00 00    	jb     802a07 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 40 0c             	mov    0xc(%eax),%eax
  802877:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287a:	0f 82 87 01 00 00    	jb     802a07 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 40 0c             	mov    0xc(%eax),%eax
  802886:	3b 45 08             	cmp    0x8(%ebp),%eax
  802889:	0f 85 95 00 00 00    	jne    802924 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80288f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802893:	75 17                	jne    8028ac <alloc_block_NF+0x24c>
  802895:	83 ec 04             	sub    $0x4,%esp
  802898:	68 e4 40 80 00       	push   $0x8040e4
  80289d:	68 fc 00 00 00       	push   $0xfc
  8028a2:	68 3b 40 80 00       	push   $0x80403b
  8028a7:	e8 22 da ff ff       	call   8002ce <_panic>
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	74 10                	je     8028c5 <alloc_block_NF+0x265>
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	8b 00                	mov    (%eax),%eax
  8028ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bd:	8b 52 04             	mov    0x4(%edx),%edx
  8028c0:	89 50 04             	mov    %edx,0x4(%eax)
  8028c3:	eb 0b                	jmp    8028d0 <alloc_block_NF+0x270>
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 40 04             	mov    0x4(%eax),%eax
  8028cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 40 04             	mov    0x4(%eax),%eax
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 0f                	je     8028e9 <alloc_block_NF+0x289>
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	8b 40 04             	mov    0x4(%eax),%eax
  8028e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e3:	8b 12                	mov    (%edx),%edx
  8028e5:	89 10                	mov    %edx,(%eax)
  8028e7:	eb 0a                	jmp    8028f3 <alloc_block_NF+0x293>
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	8b 00                	mov    (%eax),%eax
  8028ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802906:	a1 44 51 80 00       	mov    0x805144,%eax
  80290b:	48                   	dec    %eax
  80290c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 40 08             	mov    0x8(%eax),%eax
  802917:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	e9 07 03 00 00       	jmp    802c2b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 40 0c             	mov    0xc(%eax),%eax
  80292a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292d:	0f 86 d4 00 00 00    	jbe    802a07 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802933:	a1 48 51 80 00       	mov    0x805148,%eax
  802938:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 50 08             	mov    0x8(%eax),%edx
  802941:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802944:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802947:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294a:	8b 55 08             	mov    0x8(%ebp),%edx
  80294d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802950:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802954:	75 17                	jne    80296d <alloc_block_NF+0x30d>
  802956:	83 ec 04             	sub    $0x4,%esp
  802959:	68 e4 40 80 00       	push   $0x8040e4
  80295e:	68 04 01 00 00       	push   $0x104
  802963:	68 3b 40 80 00       	push   $0x80403b
  802968:	e8 61 d9 ff ff       	call   8002ce <_panic>
  80296d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	74 10                	je     802986 <alloc_block_NF+0x326>
  802976:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802979:	8b 00                	mov    (%eax),%eax
  80297b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80297e:	8b 52 04             	mov    0x4(%edx),%edx
  802981:	89 50 04             	mov    %edx,0x4(%eax)
  802984:	eb 0b                	jmp    802991 <alloc_block_NF+0x331>
  802986:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802989:	8b 40 04             	mov    0x4(%eax),%eax
  80298c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802991:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802994:	8b 40 04             	mov    0x4(%eax),%eax
  802997:	85 c0                	test   %eax,%eax
  802999:	74 0f                	je     8029aa <alloc_block_NF+0x34a>
  80299b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299e:	8b 40 04             	mov    0x4(%eax),%eax
  8029a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029a4:	8b 12                	mov    (%edx),%edx
  8029a6:	89 10                	mov    %edx,(%eax)
  8029a8:	eb 0a                	jmp    8029b4 <alloc_block_NF+0x354>
  8029aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ad:	8b 00                	mov    (%eax),%eax
  8029af:	a3 48 51 80 00       	mov    %eax,0x805148
  8029b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8029cc:	48                   	dec    %eax
  8029cd:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d5:	8b 40 08             	mov    0x8(%eax),%eax
  8029d8:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	8b 50 08             	mov    0x8(%eax),%edx
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	01 c2                	add    %eax,%edx
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f4:	2b 45 08             	sub    0x8(%ebp),%eax
  8029f7:	89 c2                	mov    %eax,%edx
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a02:	e9 24 02 00 00       	jmp    802c2b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a07:	a1 40 51 80 00       	mov    0x805140,%eax
  802a0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a13:	74 07                	je     802a1c <alloc_block_NF+0x3bc>
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	eb 05                	jmp    802a21 <alloc_block_NF+0x3c1>
  802a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a21:	a3 40 51 80 00       	mov    %eax,0x805140
  802a26:	a1 40 51 80 00       	mov    0x805140,%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	0f 85 2b fe ff ff    	jne    80285e <alloc_block_NF+0x1fe>
  802a33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a37:	0f 85 21 fe ff ff    	jne    80285e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a3d:	a1 38 51 80 00       	mov    0x805138,%eax
  802a42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a45:	e9 ae 01 00 00       	jmp    802bf8 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 50 08             	mov    0x8(%eax),%edx
  802a50:	a1 28 50 80 00       	mov    0x805028,%eax
  802a55:	39 c2                	cmp    %eax,%edx
  802a57:	0f 83 93 01 00 00    	jae    802bf0 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8b 40 0c             	mov    0xc(%eax),%eax
  802a63:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a66:	0f 82 84 01 00 00    	jb     802bf0 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a72:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a75:	0f 85 95 00 00 00    	jne    802b10 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7f:	75 17                	jne    802a98 <alloc_block_NF+0x438>
  802a81:	83 ec 04             	sub    $0x4,%esp
  802a84:	68 e4 40 80 00       	push   $0x8040e4
  802a89:	68 14 01 00 00       	push   $0x114
  802a8e:	68 3b 40 80 00       	push   $0x80403b
  802a93:	e8 36 d8 ff ff       	call   8002ce <_panic>
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 00                	mov    (%eax),%eax
  802a9d:	85 c0                	test   %eax,%eax
  802a9f:	74 10                	je     802ab1 <alloc_block_NF+0x451>
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 00                	mov    (%eax),%eax
  802aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa9:	8b 52 04             	mov    0x4(%edx),%edx
  802aac:	89 50 04             	mov    %edx,0x4(%eax)
  802aaf:	eb 0b                	jmp    802abc <alloc_block_NF+0x45c>
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 40 04             	mov    0x4(%eax),%eax
  802ab7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abf:	8b 40 04             	mov    0x4(%eax),%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	74 0f                	je     802ad5 <alloc_block_NF+0x475>
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 40 04             	mov    0x4(%eax),%eax
  802acc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802acf:	8b 12                	mov    (%edx),%edx
  802ad1:	89 10                	mov    %edx,(%eax)
  802ad3:	eb 0a                	jmp    802adf <alloc_block_NF+0x47f>
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	a3 38 51 80 00       	mov    %eax,0x805138
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af2:	a1 44 51 80 00       	mov    0x805144,%eax
  802af7:	48                   	dec    %eax
  802af8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 40 08             	mov    0x8(%eax),%eax
  802b03:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	e9 1b 01 00 00       	jmp    802c2b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 40 0c             	mov    0xc(%eax),%eax
  802b16:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b19:	0f 86 d1 00 00 00    	jbe    802bf0 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b1f:	a1 48 51 80 00       	mov    0x805148,%eax
  802b24:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 50 08             	mov    0x8(%eax),%edx
  802b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b30:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b36:	8b 55 08             	mov    0x8(%ebp),%edx
  802b39:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b40:	75 17                	jne    802b59 <alloc_block_NF+0x4f9>
  802b42:	83 ec 04             	sub    $0x4,%esp
  802b45:	68 e4 40 80 00       	push   $0x8040e4
  802b4a:	68 1c 01 00 00       	push   $0x11c
  802b4f:	68 3b 40 80 00       	push   $0x80403b
  802b54:	e8 75 d7 ff ff       	call   8002ce <_panic>
  802b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	74 10                	je     802b72 <alloc_block_NF+0x512>
  802b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b6a:	8b 52 04             	mov    0x4(%edx),%edx
  802b6d:	89 50 04             	mov    %edx,0x4(%eax)
  802b70:	eb 0b                	jmp    802b7d <alloc_block_NF+0x51d>
  802b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b75:	8b 40 04             	mov    0x4(%eax),%eax
  802b78:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b80:	8b 40 04             	mov    0x4(%eax),%eax
  802b83:	85 c0                	test   %eax,%eax
  802b85:	74 0f                	je     802b96 <alloc_block_NF+0x536>
  802b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8a:	8b 40 04             	mov    0x4(%eax),%eax
  802b8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b90:	8b 12                	mov    (%edx),%edx
  802b92:	89 10                	mov    %edx,(%eax)
  802b94:	eb 0a                	jmp    802ba0 <alloc_block_NF+0x540>
  802b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b99:	8b 00                	mov    (%eax),%eax
  802b9b:	a3 48 51 80 00       	mov    %eax,0x805148
  802ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb3:	a1 54 51 80 00       	mov    0x805154,%eax
  802bb8:	48                   	dec    %eax
  802bb9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc1:	8b 40 08             	mov    0x8(%eax),%eax
  802bc4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 50 08             	mov    0x8(%eax),%edx
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	01 c2                	add    %eax,%edx
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802be0:	2b 45 08             	sub    0x8(%ebp),%eax
  802be3:	89 c2                	mov    %eax,%edx
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bee:	eb 3b                	jmp    802c2b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bf0:	a1 40 51 80 00       	mov    0x805140,%eax
  802bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfc:	74 07                	je     802c05 <alloc_block_NF+0x5a5>
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	eb 05                	jmp    802c0a <alloc_block_NF+0x5aa>
  802c05:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0a:	a3 40 51 80 00       	mov    %eax,0x805140
  802c0f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c14:	85 c0                	test   %eax,%eax
  802c16:	0f 85 2e fe ff ff    	jne    802a4a <alloc_block_NF+0x3ea>
  802c1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c20:	0f 85 24 fe ff ff    	jne    802a4a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c2b:	c9                   	leave  
  802c2c:	c3                   	ret    

00802c2d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c2d:	55                   	push   %ebp
  802c2e:	89 e5                	mov    %esp,%ebp
  802c30:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c33:	a1 38 51 80 00       	mov    0x805138,%eax
  802c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c3b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c40:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c43:	a1 38 51 80 00       	mov    0x805138,%eax
  802c48:	85 c0                	test   %eax,%eax
  802c4a:	74 14                	je     802c60 <insert_sorted_with_merge_freeList+0x33>
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	8b 50 08             	mov    0x8(%eax),%edx
  802c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c55:	8b 40 08             	mov    0x8(%eax),%eax
  802c58:	39 c2                	cmp    %eax,%edx
  802c5a:	0f 87 9b 01 00 00    	ja     802dfb <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c64:	75 17                	jne    802c7d <insert_sorted_with_merge_freeList+0x50>
  802c66:	83 ec 04             	sub    $0x4,%esp
  802c69:	68 18 40 80 00       	push   $0x804018
  802c6e:	68 38 01 00 00       	push   $0x138
  802c73:	68 3b 40 80 00       	push   $0x80403b
  802c78:	e8 51 d6 ff ff       	call   8002ce <_panic>
  802c7d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c83:	8b 45 08             	mov    0x8(%ebp),%eax
  802c86:	89 10                	mov    %edx,(%eax)
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	85 c0                	test   %eax,%eax
  802c8f:	74 0d                	je     802c9e <insert_sorted_with_merge_freeList+0x71>
  802c91:	a1 38 51 80 00       	mov    0x805138,%eax
  802c96:	8b 55 08             	mov    0x8(%ebp),%edx
  802c99:	89 50 04             	mov    %edx,0x4(%eax)
  802c9c:	eb 08                	jmp    802ca6 <insert_sorted_with_merge_freeList+0x79>
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	a3 38 51 80 00       	mov    %eax,0x805138
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb8:	a1 44 51 80 00       	mov    0x805144,%eax
  802cbd:	40                   	inc    %eax
  802cbe:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cc7:	0f 84 a8 06 00 00    	je     803375 <insert_sorted_with_merge_freeList+0x748>
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd9:	01 c2                	add    %eax,%edx
  802cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cde:	8b 40 08             	mov    0x8(%eax),%eax
  802ce1:	39 c2                	cmp    %eax,%edx
  802ce3:	0f 85 8c 06 00 00    	jne    803375 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 50 0c             	mov    0xc(%eax),%edx
  802cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf5:	01 c2                	add    %eax,%edx
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d01:	75 17                	jne    802d1a <insert_sorted_with_merge_freeList+0xed>
  802d03:	83 ec 04             	sub    $0x4,%esp
  802d06:	68 e4 40 80 00       	push   $0x8040e4
  802d0b:	68 3c 01 00 00       	push   $0x13c
  802d10:	68 3b 40 80 00       	push   $0x80403b
  802d15:	e8 b4 d5 ff ff       	call   8002ce <_panic>
  802d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 10                	je     802d33 <insert_sorted_with_merge_freeList+0x106>
  802d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2b:	8b 52 04             	mov    0x4(%edx),%edx
  802d2e:	89 50 04             	mov    %edx,0x4(%eax)
  802d31:	eb 0b                	jmp    802d3e <insert_sorted_with_merge_freeList+0x111>
  802d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d36:	8b 40 04             	mov    0x4(%eax),%eax
  802d39:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	85 c0                	test   %eax,%eax
  802d46:	74 0f                	je     802d57 <insert_sorted_with_merge_freeList+0x12a>
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	8b 40 04             	mov    0x4(%eax),%eax
  802d4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d51:	8b 12                	mov    (%edx),%edx
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	eb 0a                	jmp    802d61 <insert_sorted_with_merge_freeList+0x134>
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	a3 38 51 80 00       	mov    %eax,0x805138
  802d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d74:	a1 44 51 80 00       	mov    0x805144,%eax
  802d79:	48                   	dec    %eax
  802d7a:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d82:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d97:	75 17                	jne    802db0 <insert_sorted_with_merge_freeList+0x183>
  802d99:	83 ec 04             	sub    $0x4,%esp
  802d9c:	68 18 40 80 00       	push   $0x804018
  802da1:	68 3f 01 00 00       	push   $0x13f
  802da6:	68 3b 40 80 00       	push   $0x80403b
  802dab:	e8 1e d5 ff ff       	call   8002ce <_panic>
  802db0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db9:	89 10                	mov    %edx,(%eax)
  802dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbe:	8b 00                	mov    (%eax),%eax
  802dc0:	85 c0                	test   %eax,%eax
  802dc2:	74 0d                	je     802dd1 <insert_sorted_with_merge_freeList+0x1a4>
  802dc4:	a1 48 51 80 00       	mov    0x805148,%eax
  802dc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dcc:	89 50 04             	mov    %edx,0x4(%eax)
  802dcf:	eb 08                	jmp    802dd9 <insert_sorted_with_merge_freeList+0x1ac>
  802dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddc:	a3 48 51 80 00       	mov    %eax,0x805148
  802de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802deb:	a1 54 51 80 00       	mov    0x805154,%eax
  802df0:	40                   	inc    %eax
  802df1:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802df6:	e9 7a 05 00 00       	jmp    803375 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 50 08             	mov    0x8(%eax),%edx
  802e01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e04:	8b 40 08             	mov    0x8(%eax),%eax
  802e07:	39 c2                	cmp    %eax,%edx
  802e09:	0f 82 14 01 00 00    	jb     802f23 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e12:	8b 50 08             	mov    0x8(%eax),%edx
  802e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e18:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1b:	01 c2                	add    %eax,%edx
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	8b 40 08             	mov    0x8(%eax),%eax
  802e23:	39 c2                	cmp    %eax,%edx
  802e25:	0f 85 90 00 00 00    	jne    802ebb <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	8b 40 0c             	mov    0xc(%eax),%eax
  802e37:	01 c2                	add    %eax,%edx
  802e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e57:	75 17                	jne    802e70 <insert_sorted_with_merge_freeList+0x243>
  802e59:	83 ec 04             	sub    $0x4,%esp
  802e5c:	68 18 40 80 00       	push   $0x804018
  802e61:	68 49 01 00 00       	push   $0x149
  802e66:	68 3b 40 80 00       	push   $0x80403b
  802e6b:	e8 5e d4 ff ff       	call   8002ce <_panic>
  802e70:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	89 10                	mov    %edx,(%eax)
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	85 c0                	test   %eax,%eax
  802e82:	74 0d                	je     802e91 <insert_sorted_with_merge_freeList+0x264>
  802e84:	a1 48 51 80 00       	mov    0x805148,%eax
  802e89:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8c:	89 50 04             	mov    %edx,0x4(%eax)
  802e8f:	eb 08                	jmp    802e99 <insert_sorted_with_merge_freeList+0x26c>
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eab:	a1 54 51 80 00       	mov    0x805154,%eax
  802eb0:	40                   	inc    %eax
  802eb1:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802eb6:	e9 bb 04 00 00       	jmp    803376 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ebb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ebf:	75 17                	jne    802ed8 <insert_sorted_with_merge_freeList+0x2ab>
  802ec1:	83 ec 04             	sub    $0x4,%esp
  802ec4:	68 8c 40 80 00       	push   $0x80408c
  802ec9:	68 4c 01 00 00       	push   $0x14c
  802ece:	68 3b 40 80 00       	push   $0x80403b
  802ed3:	e8 f6 d3 ff ff       	call   8002ce <_panic>
  802ed8:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	89 50 04             	mov    %edx,0x4(%eax)
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	8b 40 04             	mov    0x4(%eax),%eax
  802eea:	85 c0                	test   %eax,%eax
  802eec:	74 0c                	je     802efa <insert_sorted_with_merge_freeList+0x2cd>
  802eee:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef6:	89 10                	mov    %edx,(%eax)
  802ef8:	eb 08                	jmp    802f02 <insert_sorted_with_merge_freeList+0x2d5>
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	a3 38 51 80 00       	mov    %eax,0x805138
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f13:	a1 44 51 80 00       	mov    0x805144,%eax
  802f18:	40                   	inc    %eax
  802f19:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f1e:	e9 53 04 00 00       	jmp    803376 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f23:	a1 38 51 80 00       	mov    0x805138,%eax
  802f28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2b:	e9 15 04 00 00       	jmp    803345 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 00                	mov    (%eax),%eax
  802f35:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	8b 50 08             	mov    0x8(%eax),%edx
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 40 08             	mov    0x8(%eax),%eax
  802f44:	39 c2                	cmp    %eax,%edx
  802f46:	0f 86 f1 03 00 00    	jbe    80333d <insert_sorted_with_merge_freeList+0x710>
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	8b 50 08             	mov    0x8(%eax),%edx
  802f52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f55:	8b 40 08             	mov    0x8(%eax),%eax
  802f58:	39 c2                	cmp    %eax,%edx
  802f5a:	0f 83 dd 03 00 00    	jae    80333d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	8b 50 08             	mov    0x8(%eax),%edx
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6c:	01 c2                	add    %eax,%edx
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	8b 40 08             	mov    0x8(%eax),%eax
  802f74:	39 c2                	cmp    %eax,%edx
  802f76:	0f 85 b9 01 00 00    	jne    803135 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	8b 50 08             	mov    0x8(%eax),%edx
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	8b 40 0c             	mov    0xc(%eax),%eax
  802f88:	01 c2                	add    %eax,%edx
  802f8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8d:	8b 40 08             	mov    0x8(%eax),%eax
  802f90:	39 c2                	cmp    %eax,%edx
  802f92:	0f 85 0d 01 00 00    	jne    8030a5 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 50 0c             	mov    0xc(%eax),%edx
  802f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa4:	01 c2                	add    %eax,%edx
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fb0:	75 17                	jne    802fc9 <insert_sorted_with_merge_freeList+0x39c>
  802fb2:	83 ec 04             	sub    $0x4,%esp
  802fb5:	68 e4 40 80 00       	push   $0x8040e4
  802fba:	68 5c 01 00 00       	push   $0x15c
  802fbf:	68 3b 40 80 00       	push   $0x80403b
  802fc4:	e8 05 d3 ff ff       	call   8002ce <_panic>
  802fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcc:	8b 00                	mov    (%eax),%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	74 10                	je     802fe2 <insert_sorted_with_merge_freeList+0x3b5>
  802fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd5:	8b 00                	mov    (%eax),%eax
  802fd7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fda:	8b 52 04             	mov    0x4(%edx),%edx
  802fdd:	89 50 04             	mov    %edx,0x4(%eax)
  802fe0:	eb 0b                	jmp    802fed <insert_sorted_with_merge_freeList+0x3c0>
  802fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe5:	8b 40 04             	mov    0x4(%eax),%eax
  802fe8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff0:	8b 40 04             	mov    0x4(%eax),%eax
  802ff3:	85 c0                	test   %eax,%eax
  802ff5:	74 0f                	je     803006 <insert_sorted_with_merge_freeList+0x3d9>
  802ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffa:	8b 40 04             	mov    0x4(%eax),%eax
  802ffd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803000:	8b 12                	mov    (%edx),%edx
  803002:	89 10                	mov    %edx,(%eax)
  803004:	eb 0a                	jmp    803010 <insert_sorted_with_merge_freeList+0x3e3>
  803006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803009:	8b 00                	mov    (%eax),%eax
  80300b:	a3 38 51 80 00       	mov    %eax,0x805138
  803010:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803013:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803023:	a1 44 51 80 00       	mov    0x805144,%eax
  803028:	48                   	dec    %eax
  803029:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80302e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803031:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803038:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803042:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803046:	75 17                	jne    80305f <insert_sorted_with_merge_freeList+0x432>
  803048:	83 ec 04             	sub    $0x4,%esp
  80304b:	68 18 40 80 00       	push   $0x804018
  803050:	68 5f 01 00 00       	push   $0x15f
  803055:	68 3b 40 80 00       	push   $0x80403b
  80305a:	e8 6f d2 ff ff       	call   8002ce <_panic>
  80305f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803065:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803068:	89 10                	mov    %edx,(%eax)
  80306a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	85 c0                	test   %eax,%eax
  803071:	74 0d                	je     803080 <insert_sorted_with_merge_freeList+0x453>
  803073:	a1 48 51 80 00       	mov    0x805148,%eax
  803078:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80307b:	89 50 04             	mov    %edx,0x4(%eax)
  80307e:	eb 08                	jmp    803088 <insert_sorted_with_merge_freeList+0x45b>
  803080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803083:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803088:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308b:	a3 48 51 80 00       	mov    %eax,0x805148
  803090:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803093:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309a:	a1 54 51 80 00       	mov    0x805154,%eax
  80309f:	40                   	inc    %eax
  8030a0:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b1:	01 c2                	add    %eax,%edx
  8030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b6:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d1:	75 17                	jne    8030ea <insert_sorted_with_merge_freeList+0x4bd>
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	68 18 40 80 00       	push   $0x804018
  8030db:	68 64 01 00 00       	push   $0x164
  8030e0:	68 3b 40 80 00       	push   $0x80403b
  8030e5:	e8 e4 d1 ff ff       	call   8002ce <_panic>
  8030ea:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	89 10                	mov    %edx,(%eax)
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	8b 00                	mov    (%eax),%eax
  8030fa:	85 c0                	test   %eax,%eax
  8030fc:	74 0d                	je     80310b <insert_sorted_with_merge_freeList+0x4de>
  8030fe:	a1 48 51 80 00       	mov    0x805148,%eax
  803103:	8b 55 08             	mov    0x8(%ebp),%edx
  803106:	89 50 04             	mov    %edx,0x4(%eax)
  803109:	eb 08                	jmp    803113 <insert_sorted_with_merge_freeList+0x4e6>
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	a3 48 51 80 00       	mov    %eax,0x805148
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803125:	a1 54 51 80 00       	mov    0x805154,%eax
  80312a:	40                   	inc    %eax
  80312b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803130:	e9 41 02 00 00       	jmp    803376 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803135:	8b 45 08             	mov    0x8(%ebp),%eax
  803138:	8b 50 08             	mov    0x8(%eax),%edx
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	8b 40 0c             	mov    0xc(%eax),%eax
  803141:	01 c2                	add    %eax,%edx
  803143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803146:	8b 40 08             	mov    0x8(%eax),%eax
  803149:	39 c2                	cmp    %eax,%edx
  80314b:	0f 85 7c 01 00 00    	jne    8032cd <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803151:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803155:	74 06                	je     80315d <insert_sorted_with_merge_freeList+0x530>
  803157:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80315b:	75 17                	jne    803174 <insert_sorted_with_merge_freeList+0x547>
  80315d:	83 ec 04             	sub    $0x4,%esp
  803160:	68 54 40 80 00       	push   $0x804054
  803165:	68 69 01 00 00       	push   $0x169
  80316a:	68 3b 40 80 00       	push   $0x80403b
  80316f:	e8 5a d1 ff ff       	call   8002ce <_panic>
  803174:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803177:	8b 50 04             	mov    0x4(%eax),%edx
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	89 50 04             	mov    %edx,0x4(%eax)
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803186:	89 10                	mov    %edx,(%eax)
  803188:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318b:	8b 40 04             	mov    0x4(%eax),%eax
  80318e:	85 c0                	test   %eax,%eax
  803190:	74 0d                	je     80319f <insert_sorted_with_merge_freeList+0x572>
  803192:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803195:	8b 40 04             	mov    0x4(%eax),%eax
  803198:	8b 55 08             	mov    0x8(%ebp),%edx
  80319b:	89 10                	mov    %edx,(%eax)
  80319d:	eb 08                	jmp    8031a7 <insert_sorted_with_merge_freeList+0x57a>
  80319f:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a2:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ad:	89 50 04             	mov    %edx,0x4(%eax)
  8031b0:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b5:	40                   	inc    %eax
  8031b6:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031be:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c7:	01 c2                	add    %eax,%edx
  8031c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cc:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031d3:	75 17                	jne    8031ec <insert_sorted_with_merge_freeList+0x5bf>
  8031d5:	83 ec 04             	sub    $0x4,%esp
  8031d8:	68 e4 40 80 00       	push   $0x8040e4
  8031dd:	68 6b 01 00 00       	push   $0x16b
  8031e2:	68 3b 40 80 00       	push   $0x80403b
  8031e7:	e8 e2 d0 ff ff       	call   8002ce <_panic>
  8031ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ef:	8b 00                	mov    (%eax),%eax
  8031f1:	85 c0                	test   %eax,%eax
  8031f3:	74 10                	je     803205 <insert_sorted_with_merge_freeList+0x5d8>
  8031f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031fd:	8b 52 04             	mov    0x4(%edx),%edx
  803200:	89 50 04             	mov    %edx,0x4(%eax)
  803203:	eb 0b                	jmp    803210 <insert_sorted_with_merge_freeList+0x5e3>
  803205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803208:	8b 40 04             	mov    0x4(%eax),%eax
  80320b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803213:	8b 40 04             	mov    0x4(%eax),%eax
  803216:	85 c0                	test   %eax,%eax
  803218:	74 0f                	je     803229 <insert_sorted_with_merge_freeList+0x5fc>
  80321a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321d:	8b 40 04             	mov    0x4(%eax),%eax
  803220:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803223:	8b 12                	mov    (%edx),%edx
  803225:	89 10                	mov    %edx,(%eax)
  803227:	eb 0a                	jmp    803233 <insert_sorted_with_merge_freeList+0x606>
  803229:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	a3 38 51 80 00       	mov    %eax,0x805138
  803233:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803236:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803246:	a1 44 51 80 00       	mov    0x805144,%eax
  80324b:	48                   	dec    %eax
  80324c:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803251:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803254:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80325b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803265:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803269:	75 17                	jne    803282 <insert_sorted_with_merge_freeList+0x655>
  80326b:	83 ec 04             	sub    $0x4,%esp
  80326e:	68 18 40 80 00       	push   $0x804018
  803273:	68 6e 01 00 00       	push   $0x16e
  803278:	68 3b 40 80 00       	push   $0x80403b
  80327d:	e8 4c d0 ff ff       	call   8002ce <_panic>
  803282:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803288:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328b:	89 10                	mov    %edx,(%eax)
  80328d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803290:	8b 00                	mov    (%eax),%eax
  803292:	85 c0                	test   %eax,%eax
  803294:	74 0d                	je     8032a3 <insert_sorted_with_merge_freeList+0x676>
  803296:	a1 48 51 80 00       	mov    0x805148,%eax
  80329b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329e:	89 50 04             	mov    %edx,0x4(%eax)
  8032a1:	eb 08                	jmp    8032ab <insert_sorted_with_merge_freeList+0x67e>
  8032a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ae:	a3 48 51 80 00       	mov    %eax,0x805148
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032bd:	a1 54 51 80 00       	mov    0x805154,%eax
  8032c2:	40                   	inc    %eax
  8032c3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032c8:	e9 a9 00 00 00       	jmp    803376 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d1:	74 06                	je     8032d9 <insert_sorted_with_merge_freeList+0x6ac>
  8032d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d7:	75 17                	jne    8032f0 <insert_sorted_with_merge_freeList+0x6c3>
  8032d9:	83 ec 04             	sub    $0x4,%esp
  8032dc:	68 b0 40 80 00       	push   $0x8040b0
  8032e1:	68 73 01 00 00       	push   $0x173
  8032e6:	68 3b 40 80 00       	push   $0x80403b
  8032eb:	e8 de cf ff ff       	call   8002ce <_panic>
  8032f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f3:	8b 10                	mov    (%eax),%edx
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	89 10                	mov    %edx,(%eax)
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	8b 00                	mov    (%eax),%eax
  8032ff:	85 c0                	test   %eax,%eax
  803301:	74 0b                	je     80330e <insert_sorted_with_merge_freeList+0x6e1>
  803303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803306:	8b 00                	mov    (%eax),%eax
  803308:	8b 55 08             	mov    0x8(%ebp),%edx
  80330b:	89 50 04             	mov    %edx,0x4(%eax)
  80330e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803311:	8b 55 08             	mov    0x8(%ebp),%edx
  803314:	89 10                	mov    %edx,(%eax)
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80331c:	89 50 04             	mov    %edx,0x4(%eax)
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	8b 00                	mov    (%eax),%eax
  803324:	85 c0                	test   %eax,%eax
  803326:	75 08                	jne    803330 <insert_sorted_with_merge_freeList+0x703>
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803330:	a1 44 51 80 00       	mov    0x805144,%eax
  803335:	40                   	inc    %eax
  803336:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80333b:	eb 39                	jmp    803376 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80333d:	a1 40 51 80 00       	mov    0x805140,%eax
  803342:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803345:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803349:	74 07                	je     803352 <insert_sorted_with_merge_freeList+0x725>
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	eb 05                	jmp    803357 <insert_sorted_with_merge_freeList+0x72a>
  803352:	b8 00 00 00 00       	mov    $0x0,%eax
  803357:	a3 40 51 80 00       	mov    %eax,0x805140
  80335c:	a1 40 51 80 00       	mov    0x805140,%eax
  803361:	85 c0                	test   %eax,%eax
  803363:	0f 85 c7 fb ff ff    	jne    802f30 <insert_sorted_with_merge_freeList+0x303>
  803369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336d:	0f 85 bd fb ff ff    	jne    802f30 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803373:	eb 01                	jmp    803376 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803375:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803376:	90                   	nop
  803377:	c9                   	leave  
  803378:	c3                   	ret    

00803379 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803379:	55                   	push   %ebp
  80337a:	89 e5                	mov    %esp,%ebp
  80337c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80337f:	8b 55 08             	mov    0x8(%ebp),%edx
  803382:	89 d0                	mov    %edx,%eax
  803384:	c1 e0 02             	shl    $0x2,%eax
  803387:	01 d0                	add    %edx,%eax
  803389:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803390:	01 d0                	add    %edx,%eax
  803392:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803399:	01 d0                	add    %edx,%eax
  80339b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033a2:	01 d0                	add    %edx,%eax
  8033a4:	c1 e0 04             	shl    $0x4,%eax
  8033a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8033aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8033b1:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033b4:	83 ec 0c             	sub    $0xc,%esp
  8033b7:	50                   	push   %eax
  8033b8:	e8 26 e7 ff ff       	call   801ae3 <sys_get_virtual_time>
  8033bd:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033c0:	eb 41                	jmp    803403 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033c2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033c5:	83 ec 0c             	sub    $0xc,%esp
  8033c8:	50                   	push   %eax
  8033c9:	e8 15 e7 ff ff       	call   801ae3 <sys_get_virtual_time>
  8033ce:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d7:	29 c2                	sub    %eax,%edx
  8033d9:	89 d0                	mov    %edx,%eax
  8033db:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e4:	89 d1                	mov    %edx,%ecx
  8033e6:	29 c1                	sub    %eax,%ecx
  8033e8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033ee:	39 c2                	cmp    %eax,%edx
  8033f0:	0f 97 c0             	seta   %al
  8033f3:	0f b6 c0             	movzbl %al,%eax
  8033f6:	29 c1                	sub    %eax,%ecx
  8033f8:	89 c8                	mov    %ecx,%eax
  8033fa:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803400:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803406:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803409:	72 b7                	jb     8033c2 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80340b:	90                   	nop
  80340c:	c9                   	leave  
  80340d:	c3                   	ret    

0080340e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80340e:	55                   	push   %ebp
  80340f:	89 e5                	mov    %esp,%ebp
  803411:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80341b:	eb 03                	jmp    803420 <busy_wait+0x12>
  80341d:	ff 45 fc             	incl   -0x4(%ebp)
  803420:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803423:	3b 45 08             	cmp    0x8(%ebp),%eax
  803426:	72 f5                	jb     80341d <busy_wait+0xf>
	return i;
  803428:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80342b:	c9                   	leave  
  80342c:	c3                   	ret    
  80342d:	66 90                	xchg   %ax,%ax
  80342f:	90                   	nop

00803430 <__udivdi3>:
  803430:	55                   	push   %ebp
  803431:	57                   	push   %edi
  803432:	56                   	push   %esi
  803433:	53                   	push   %ebx
  803434:	83 ec 1c             	sub    $0x1c,%esp
  803437:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80343b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80343f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803443:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803447:	89 ca                	mov    %ecx,%edx
  803449:	89 f8                	mov    %edi,%eax
  80344b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80344f:	85 f6                	test   %esi,%esi
  803451:	75 2d                	jne    803480 <__udivdi3+0x50>
  803453:	39 cf                	cmp    %ecx,%edi
  803455:	77 65                	ja     8034bc <__udivdi3+0x8c>
  803457:	89 fd                	mov    %edi,%ebp
  803459:	85 ff                	test   %edi,%edi
  80345b:	75 0b                	jne    803468 <__udivdi3+0x38>
  80345d:	b8 01 00 00 00       	mov    $0x1,%eax
  803462:	31 d2                	xor    %edx,%edx
  803464:	f7 f7                	div    %edi
  803466:	89 c5                	mov    %eax,%ebp
  803468:	31 d2                	xor    %edx,%edx
  80346a:	89 c8                	mov    %ecx,%eax
  80346c:	f7 f5                	div    %ebp
  80346e:	89 c1                	mov    %eax,%ecx
  803470:	89 d8                	mov    %ebx,%eax
  803472:	f7 f5                	div    %ebp
  803474:	89 cf                	mov    %ecx,%edi
  803476:	89 fa                	mov    %edi,%edx
  803478:	83 c4 1c             	add    $0x1c,%esp
  80347b:	5b                   	pop    %ebx
  80347c:	5e                   	pop    %esi
  80347d:	5f                   	pop    %edi
  80347e:	5d                   	pop    %ebp
  80347f:	c3                   	ret    
  803480:	39 ce                	cmp    %ecx,%esi
  803482:	77 28                	ja     8034ac <__udivdi3+0x7c>
  803484:	0f bd fe             	bsr    %esi,%edi
  803487:	83 f7 1f             	xor    $0x1f,%edi
  80348a:	75 40                	jne    8034cc <__udivdi3+0x9c>
  80348c:	39 ce                	cmp    %ecx,%esi
  80348e:	72 0a                	jb     80349a <__udivdi3+0x6a>
  803490:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803494:	0f 87 9e 00 00 00    	ja     803538 <__udivdi3+0x108>
  80349a:	b8 01 00 00 00       	mov    $0x1,%eax
  80349f:	89 fa                	mov    %edi,%edx
  8034a1:	83 c4 1c             	add    $0x1c,%esp
  8034a4:	5b                   	pop    %ebx
  8034a5:	5e                   	pop    %esi
  8034a6:	5f                   	pop    %edi
  8034a7:	5d                   	pop    %ebp
  8034a8:	c3                   	ret    
  8034a9:	8d 76 00             	lea    0x0(%esi),%esi
  8034ac:	31 ff                	xor    %edi,%edi
  8034ae:	31 c0                	xor    %eax,%eax
  8034b0:	89 fa                	mov    %edi,%edx
  8034b2:	83 c4 1c             	add    $0x1c,%esp
  8034b5:	5b                   	pop    %ebx
  8034b6:	5e                   	pop    %esi
  8034b7:	5f                   	pop    %edi
  8034b8:	5d                   	pop    %ebp
  8034b9:	c3                   	ret    
  8034ba:	66 90                	xchg   %ax,%ax
  8034bc:	89 d8                	mov    %ebx,%eax
  8034be:	f7 f7                	div    %edi
  8034c0:	31 ff                	xor    %edi,%edi
  8034c2:	89 fa                	mov    %edi,%edx
  8034c4:	83 c4 1c             	add    $0x1c,%esp
  8034c7:	5b                   	pop    %ebx
  8034c8:	5e                   	pop    %esi
  8034c9:	5f                   	pop    %edi
  8034ca:	5d                   	pop    %ebp
  8034cb:	c3                   	ret    
  8034cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034d1:	89 eb                	mov    %ebp,%ebx
  8034d3:	29 fb                	sub    %edi,%ebx
  8034d5:	89 f9                	mov    %edi,%ecx
  8034d7:	d3 e6                	shl    %cl,%esi
  8034d9:	89 c5                	mov    %eax,%ebp
  8034db:	88 d9                	mov    %bl,%cl
  8034dd:	d3 ed                	shr    %cl,%ebp
  8034df:	89 e9                	mov    %ebp,%ecx
  8034e1:	09 f1                	or     %esi,%ecx
  8034e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034e7:	89 f9                	mov    %edi,%ecx
  8034e9:	d3 e0                	shl    %cl,%eax
  8034eb:	89 c5                	mov    %eax,%ebp
  8034ed:	89 d6                	mov    %edx,%esi
  8034ef:	88 d9                	mov    %bl,%cl
  8034f1:	d3 ee                	shr    %cl,%esi
  8034f3:	89 f9                	mov    %edi,%ecx
  8034f5:	d3 e2                	shl    %cl,%edx
  8034f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034fb:	88 d9                	mov    %bl,%cl
  8034fd:	d3 e8                	shr    %cl,%eax
  8034ff:	09 c2                	or     %eax,%edx
  803501:	89 d0                	mov    %edx,%eax
  803503:	89 f2                	mov    %esi,%edx
  803505:	f7 74 24 0c          	divl   0xc(%esp)
  803509:	89 d6                	mov    %edx,%esi
  80350b:	89 c3                	mov    %eax,%ebx
  80350d:	f7 e5                	mul    %ebp
  80350f:	39 d6                	cmp    %edx,%esi
  803511:	72 19                	jb     80352c <__udivdi3+0xfc>
  803513:	74 0b                	je     803520 <__udivdi3+0xf0>
  803515:	89 d8                	mov    %ebx,%eax
  803517:	31 ff                	xor    %edi,%edi
  803519:	e9 58 ff ff ff       	jmp    803476 <__udivdi3+0x46>
  80351e:	66 90                	xchg   %ax,%ax
  803520:	8b 54 24 08          	mov    0x8(%esp),%edx
  803524:	89 f9                	mov    %edi,%ecx
  803526:	d3 e2                	shl    %cl,%edx
  803528:	39 c2                	cmp    %eax,%edx
  80352a:	73 e9                	jae    803515 <__udivdi3+0xe5>
  80352c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80352f:	31 ff                	xor    %edi,%edi
  803531:	e9 40 ff ff ff       	jmp    803476 <__udivdi3+0x46>
  803536:	66 90                	xchg   %ax,%ax
  803538:	31 c0                	xor    %eax,%eax
  80353a:	e9 37 ff ff ff       	jmp    803476 <__udivdi3+0x46>
  80353f:	90                   	nop

00803540 <__umoddi3>:
  803540:	55                   	push   %ebp
  803541:	57                   	push   %edi
  803542:	56                   	push   %esi
  803543:	53                   	push   %ebx
  803544:	83 ec 1c             	sub    $0x1c,%esp
  803547:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80354b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80354f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803553:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803557:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80355b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80355f:	89 f3                	mov    %esi,%ebx
  803561:	89 fa                	mov    %edi,%edx
  803563:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803567:	89 34 24             	mov    %esi,(%esp)
  80356a:	85 c0                	test   %eax,%eax
  80356c:	75 1a                	jne    803588 <__umoddi3+0x48>
  80356e:	39 f7                	cmp    %esi,%edi
  803570:	0f 86 a2 00 00 00    	jbe    803618 <__umoddi3+0xd8>
  803576:	89 c8                	mov    %ecx,%eax
  803578:	89 f2                	mov    %esi,%edx
  80357a:	f7 f7                	div    %edi
  80357c:	89 d0                	mov    %edx,%eax
  80357e:	31 d2                	xor    %edx,%edx
  803580:	83 c4 1c             	add    $0x1c,%esp
  803583:	5b                   	pop    %ebx
  803584:	5e                   	pop    %esi
  803585:	5f                   	pop    %edi
  803586:	5d                   	pop    %ebp
  803587:	c3                   	ret    
  803588:	39 f0                	cmp    %esi,%eax
  80358a:	0f 87 ac 00 00 00    	ja     80363c <__umoddi3+0xfc>
  803590:	0f bd e8             	bsr    %eax,%ebp
  803593:	83 f5 1f             	xor    $0x1f,%ebp
  803596:	0f 84 ac 00 00 00    	je     803648 <__umoddi3+0x108>
  80359c:	bf 20 00 00 00       	mov    $0x20,%edi
  8035a1:	29 ef                	sub    %ebp,%edi
  8035a3:	89 fe                	mov    %edi,%esi
  8035a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035a9:	89 e9                	mov    %ebp,%ecx
  8035ab:	d3 e0                	shl    %cl,%eax
  8035ad:	89 d7                	mov    %edx,%edi
  8035af:	89 f1                	mov    %esi,%ecx
  8035b1:	d3 ef                	shr    %cl,%edi
  8035b3:	09 c7                	or     %eax,%edi
  8035b5:	89 e9                	mov    %ebp,%ecx
  8035b7:	d3 e2                	shl    %cl,%edx
  8035b9:	89 14 24             	mov    %edx,(%esp)
  8035bc:	89 d8                	mov    %ebx,%eax
  8035be:	d3 e0                	shl    %cl,%eax
  8035c0:	89 c2                	mov    %eax,%edx
  8035c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035c6:	d3 e0                	shl    %cl,%eax
  8035c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035d0:	89 f1                	mov    %esi,%ecx
  8035d2:	d3 e8                	shr    %cl,%eax
  8035d4:	09 d0                	or     %edx,%eax
  8035d6:	d3 eb                	shr    %cl,%ebx
  8035d8:	89 da                	mov    %ebx,%edx
  8035da:	f7 f7                	div    %edi
  8035dc:	89 d3                	mov    %edx,%ebx
  8035de:	f7 24 24             	mull   (%esp)
  8035e1:	89 c6                	mov    %eax,%esi
  8035e3:	89 d1                	mov    %edx,%ecx
  8035e5:	39 d3                	cmp    %edx,%ebx
  8035e7:	0f 82 87 00 00 00    	jb     803674 <__umoddi3+0x134>
  8035ed:	0f 84 91 00 00 00    	je     803684 <__umoddi3+0x144>
  8035f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035f7:	29 f2                	sub    %esi,%edx
  8035f9:	19 cb                	sbb    %ecx,%ebx
  8035fb:	89 d8                	mov    %ebx,%eax
  8035fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803601:	d3 e0                	shl    %cl,%eax
  803603:	89 e9                	mov    %ebp,%ecx
  803605:	d3 ea                	shr    %cl,%edx
  803607:	09 d0                	or     %edx,%eax
  803609:	89 e9                	mov    %ebp,%ecx
  80360b:	d3 eb                	shr    %cl,%ebx
  80360d:	89 da                	mov    %ebx,%edx
  80360f:	83 c4 1c             	add    $0x1c,%esp
  803612:	5b                   	pop    %ebx
  803613:	5e                   	pop    %esi
  803614:	5f                   	pop    %edi
  803615:	5d                   	pop    %ebp
  803616:	c3                   	ret    
  803617:	90                   	nop
  803618:	89 fd                	mov    %edi,%ebp
  80361a:	85 ff                	test   %edi,%edi
  80361c:	75 0b                	jne    803629 <__umoddi3+0xe9>
  80361e:	b8 01 00 00 00       	mov    $0x1,%eax
  803623:	31 d2                	xor    %edx,%edx
  803625:	f7 f7                	div    %edi
  803627:	89 c5                	mov    %eax,%ebp
  803629:	89 f0                	mov    %esi,%eax
  80362b:	31 d2                	xor    %edx,%edx
  80362d:	f7 f5                	div    %ebp
  80362f:	89 c8                	mov    %ecx,%eax
  803631:	f7 f5                	div    %ebp
  803633:	89 d0                	mov    %edx,%eax
  803635:	e9 44 ff ff ff       	jmp    80357e <__umoddi3+0x3e>
  80363a:	66 90                	xchg   %ax,%ax
  80363c:	89 c8                	mov    %ecx,%eax
  80363e:	89 f2                	mov    %esi,%edx
  803640:	83 c4 1c             	add    $0x1c,%esp
  803643:	5b                   	pop    %ebx
  803644:	5e                   	pop    %esi
  803645:	5f                   	pop    %edi
  803646:	5d                   	pop    %ebp
  803647:	c3                   	ret    
  803648:	3b 04 24             	cmp    (%esp),%eax
  80364b:	72 06                	jb     803653 <__umoddi3+0x113>
  80364d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803651:	77 0f                	ja     803662 <__umoddi3+0x122>
  803653:	89 f2                	mov    %esi,%edx
  803655:	29 f9                	sub    %edi,%ecx
  803657:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80365b:	89 14 24             	mov    %edx,(%esp)
  80365e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803662:	8b 44 24 04          	mov    0x4(%esp),%eax
  803666:	8b 14 24             	mov    (%esp),%edx
  803669:	83 c4 1c             	add    $0x1c,%esp
  80366c:	5b                   	pop    %ebx
  80366d:	5e                   	pop    %esi
  80366e:	5f                   	pop    %edi
  80366f:	5d                   	pop    %ebp
  803670:	c3                   	ret    
  803671:	8d 76 00             	lea    0x0(%esi),%esi
  803674:	2b 04 24             	sub    (%esp),%eax
  803677:	19 fa                	sbb    %edi,%edx
  803679:	89 d1                	mov    %edx,%ecx
  80367b:	89 c6                	mov    %eax,%esi
  80367d:	e9 71 ff ff ff       	jmp    8035f3 <__umoddi3+0xb3>
  803682:	66 90                	xchg   %ax,%ax
  803684:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803688:	72 ea                	jb     803674 <__umoddi3+0x134>
  80368a:	89 d9                	mov    %ebx,%ecx
  80368c:	e9 62 ff ff ff       	jmp    8035f3 <__umoddi3+0xb3>
