
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
  800045:	68 80 36 80 00       	push   $0x803680
  80004a:	e8 03 15 00 00       	call   801552 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 2f 17 00 00       	call   801792 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 c7 17 00 00       	call   801832 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 90 36 80 00       	push   $0x803690
  800079:	e8 04 05 00 00       	call   800582 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000, (myEnv->SecondListSize),50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 c3 36 80 00       	push   $0x8036c3
  800099:	e8 66 19 00 00       	call   801a04 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	6a 14                	push   $0x14
  8000b4:	68 cc 36 80 00       	push   $0x8036cc
  8000b9:	e8 46 19 00 00       	call   801a04 <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 53 19 00 00       	call   801a22 <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 10 27 00 00       	push   $0x2710
  8000da:	e8 75 32 00 00       	call   803354 <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e8:	e8 35 19 00 00       	call   801a22 <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f0:	90                   	nop
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	83 f8 02             	cmp    $0x2,%eax
  8000f9:	75 f6                	jne    8000f1 <_main+0xb9>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fb:	e8 92 16 00 00       	call   801792 <sys_calculate_free_frames>
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	68 d8 36 80 00       	push   $0x8036d8
  800109:	e8 74 04 00 00       	call   800582 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 e8             	pushl  -0x18(%ebp)
  800117:	e8 22 19 00 00       	call   801a3e <sys_destroy_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 14 19 00 00       	call   801a3e <sys_destroy_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80012d:	e8 60 16 00 00       	call   801792 <sys_calculate_free_frames>
  800132:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800135:	e8 f8 16 00 00       	call   801832 <sys_pf_calculate_allocated_pages>
  80013a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80013d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800143:	74 27                	je     80016c <_main+0x134>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 e0             	pushl  -0x20(%ebp)
  80014b:	68 0c 37 80 00       	push   $0x80370c
  800150:	e8 2d 04 00 00       	call   800582 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 5c 37 80 00       	push   $0x80375c
  800160:	6a 23                	push   $0x23
  800162:	68 92 37 80 00       	push   $0x803792
  800167:	e8 62 01 00 00       	call   8002ce <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 e0             	pushl  -0x20(%ebp)
  800172:	68 a8 37 80 00       	push   $0x8037a8
  800177:	e8 06 04 00 00       	call   800582 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 08 38 80 00       	push   $0x803808
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
  800198:	e8 d5 18 00 00       	call   801a72 <sys_getenvindex>
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
  800203:	e8 77 16 00 00       	call   80187f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 6c 38 80 00       	push   $0x80386c
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
  800233:	68 94 38 80 00       	push   $0x803894
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
  800264:	68 bc 38 80 00       	push   $0x8038bc
  800269:	e8 14 03 00 00       	call   800582 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 50 80 00       	mov    0x805020,%eax
  800276:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 14 39 80 00       	push   $0x803914
  800285:	e8 f8 02 00 00       	call   800582 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 6c 38 80 00       	push   $0x80386c
  800295:	e8 e8 02 00 00       	call   800582 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029d:	e8 f7 15 00 00       	call   801899 <sys_enable_interrupt>

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
  8002b5:	e8 84 17 00 00       	call   801a3e <sys_destroy_env>
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
  8002c6:	e8 d9 17 00 00       	call   801aa4 <sys_exit_env>
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
  8002ef:	68 28 39 80 00       	push   $0x803928
  8002f4:	e8 89 02 00 00       	call   800582 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fc:	a1 00 50 80 00       	mov    0x805000,%eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	50                   	push   %eax
  800308:	68 2d 39 80 00       	push   $0x80392d
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
  80032c:	68 49 39 80 00       	push   $0x803949
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
  800358:	68 4c 39 80 00       	push   $0x80394c
  80035d:	6a 26                	push   $0x26
  80035f:	68 98 39 80 00       	push   $0x803998
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
  80042a:	68 a4 39 80 00       	push   $0x8039a4
  80042f:	6a 3a                	push   $0x3a
  800431:	68 98 39 80 00       	push   $0x803998
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
  80049a:	68 f8 39 80 00       	push   $0x8039f8
  80049f:	6a 44                	push   $0x44
  8004a1:	68 98 39 80 00       	push   $0x803998
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
  8004f4:	e8 d8 11 00 00       	call   8016d1 <sys_cputs>
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
  80056b:	e8 61 11 00 00       	call   8016d1 <sys_cputs>
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
  8005b5:	e8 c5 12 00 00       	call   80187f <sys_disable_interrupt>
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
  8005d5:	e8 bf 12 00 00       	call   801899 <sys_enable_interrupt>
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
  80061f:	e8 e4 2d 00 00       	call   803408 <__udivdi3>
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
  80066f:	e8 a4 2e 00 00       	call   803518 <__umoddi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	05 74 3c 80 00       	add    $0x803c74,%eax
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
  8007ca:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
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
  8008ab:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 19                	jne    8008cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b6:	53                   	push   %ebx
  8008b7:	68 85 3c 80 00       	push   $0x803c85
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
  8008d0:	68 8e 3c 80 00       	push   $0x803c8e
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
  8008fd:	be 91 3c 80 00       	mov    $0x803c91,%esi
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
  801323:	68 f0 3d 80 00       	push   $0x803df0
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
  8013f3:	e8 1d 04 00 00       	call   801815 <sys_allocate_chunk>
  8013f8:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013fb:	a1 20 51 80 00       	mov    0x805120,%eax
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	50                   	push   %eax
  801404:	e8 92 0a 00 00       	call   801e9b <initialize_MemBlocksList>
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
  801431:	68 15 3e 80 00       	push   $0x803e15
  801436:	6a 33                	push   $0x33
  801438:	68 33 3e 80 00       	push   $0x803e33
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
  8014b0:	68 40 3e 80 00       	push   $0x803e40
  8014b5:	6a 34                	push   $0x34
  8014b7:	68 33 3e 80 00       	push   $0x803e33
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
  801525:	68 64 3e 80 00       	push   $0x803e64
  80152a:	6a 46                	push   $0x46
  80152c:	68 33 3e 80 00       	push   $0x803e33
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
  801541:	68 8c 3e 80 00       	push   $0x803e8c
  801546:	6a 61                	push   $0x61
  801548:	68 33 3e 80 00       	push   $0x803e33
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
  801567:	75 07                	jne    801570 <smalloc+0x1e>
  801569:	b8 00 00 00 00       	mov    $0x0,%eax
  80156e:	eb 7c                	jmp    8015ec <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801570:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157d:	01 d0                	add    %edx,%eax
  80157f:	48                   	dec    %eax
  801580:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801583:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801586:	ba 00 00 00 00       	mov    $0x0,%edx
  80158b:	f7 75 f0             	divl   -0x10(%ebp)
  80158e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801591:	29 d0                	sub    %edx,%eax
  801593:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801596:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80159d:	e8 41 06 00 00       	call   801be3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015a2:	85 c0                	test   %eax,%eax
  8015a4:	74 11                	je     8015b7 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8015a6:	83 ec 0c             	sub    $0xc,%esp
  8015a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ac:	e8 ac 0c 00 00       	call   80225d <alloc_block_FF>
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015bb:	74 2a                	je     8015e7 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c0:	8b 40 08             	mov    0x8(%eax),%eax
  8015c3:	89 c2                	mov    %eax,%edx
  8015c5:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015c9:	52                   	push   %edx
  8015ca:	50                   	push   %eax
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	ff 75 08             	pushl  0x8(%ebp)
  8015d1:	e8 92 03 00 00       	call   801968 <sys_createSharedObject>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8015dc:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8015e0:	74 05                	je     8015e7 <smalloc+0x95>
			return (void*)virtual_address;
  8015e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e5:	eb 05                	jmp    8015ec <smalloc+0x9a>
	}
	return NULL;
  8015e7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    

008015ee <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f4:	e8 13 fd ff ff       	call   80130c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	68 b0 3e 80 00       	push   $0x803eb0
  801601:	68 a2 00 00 00       	push   $0xa2
  801606:	68 33 3e 80 00       	push   $0x803e33
  80160b:	e8 be ec ff ff       	call   8002ce <_panic>

00801610 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801616:	e8 f1 fc ff ff       	call   80130c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	68 d4 3e 80 00       	push   $0x803ed4
  801623:	68 e6 00 00 00       	push   $0xe6
  801628:	68 33 3e 80 00       	push   $0x803e33
  80162d:	e8 9c ec ff ff       	call   8002ce <_panic>

00801632 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801638:	83 ec 04             	sub    $0x4,%esp
  80163b:	68 fc 3e 80 00       	push   $0x803efc
  801640:	68 fa 00 00 00       	push   $0xfa
  801645:	68 33 3e 80 00       	push   $0x803e33
  80164a:	e8 7f ec ff ff       	call   8002ce <_panic>

0080164f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801655:	83 ec 04             	sub    $0x4,%esp
  801658:	68 20 3f 80 00       	push   $0x803f20
  80165d:	68 05 01 00 00       	push   $0x105
  801662:	68 33 3e 80 00       	push   $0x803e33
  801667:	e8 62 ec ff ff       	call   8002ce <_panic>

0080166c <shrink>:

}
void shrink(uint32 newSize)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801672:	83 ec 04             	sub    $0x4,%esp
  801675:	68 20 3f 80 00       	push   $0x803f20
  80167a:	68 0a 01 00 00       	push   $0x10a
  80167f:	68 33 3e 80 00       	push   $0x803e33
  801684:	e8 45 ec ff ff       	call   8002ce <_panic>

00801689 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80168f:	83 ec 04             	sub    $0x4,%esp
  801692:	68 20 3f 80 00       	push   $0x803f20
  801697:	68 0f 01 00 00       	push   $0x10f
  80169c:	68 33 3e 80 00       	push   $0x803e33
  8016a1:	e8 28 ec ff ff       	call   8002ce <_panic>

008016a6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	57                   	push   %edi
  8016aa:	56                   	push   %esi
  8016ab:	53                   	push   %ebx
  8016ac:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016bb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016be:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016c1:	cd 30                	int    $0x30
  8016c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	5b                   	pop    %ebx
  8016cd:	5e                   	pop    %esi
  8016ce:	5f                   	pop    %edi
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    

008016d1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016da:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016dd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	52                   	push   %edx
  8016e9:	ff 75 0c             	pushl  0xc(%ebp)
  8016ec:	50                   	push   %eax
  8016ed:	6a 00                	push   $0x0
  8016ef:	e8 b2 ff ff ff       	call   8016a6 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	90                   	nop
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_cgetc>:

int
sys_cgetc(void)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 01                	push   $0x1
  801709:	e8 98 ff ff ff       	call   8016a6 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801716:	8b 55 0c             	mov    0xc(%ebp),%edx
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	52                   	push   %edx
  801723:	50                   	push   %eax
  801724:	6a 05                	push   $0x5
  801726:	e8 7b ff ff ff       	call   8016a6 <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	56                   	push   %esi
  801734:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801735:	8b 75 18             	mov    0x18(%ebp),%esi
  801738:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	56                   	push   %esi
  801745:	53                   	push   %ebx
  801746:	51                   	push   %ecx
  801747:	52                   	push   %edx
  801748:	50                   	push   %eax
  801749:	6a 06                	push   $0x6
  80174b:	e8 56 ff ff ff       	call   8016a6 <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801756:	5b                   	pop    %ebx
  801757:	5e                   	pop    %esi
  801758:	5d                   	pop    %ebp
  801759:	c3                   	ret    

0080175a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80175d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	52                   	push   %edx
  80176a:	50                   	push   %eax
  80176b:	6a 07                	push   $0x7
  80176d:	e8 34 ff ff ff       	call   8016a6 <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	ff 75 0c             	pushl  0xc(%ebp)
  801783:	ff 75 08             	pushl  0x8(%ebp)
  801786:	6a 08                	push   $0x8
  801788:	e8 19 ff ff ff       	call   8016a6 <syscall>
  80178d:	83 c4 18             	add    $0x18,%esp
}
  801790:	c9                   	leave  
  801791:	c3                   	ret    

00801792 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 09                	push   $0x9
  8017a1:	e8 00 ff ff ff       	call   8016a6 <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 0a                	push   $0xa
  8017ba:	e8 e7 fe ff ff       	call   8016a6 <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
}
  8017c2:	c9                   	leave  
  8017c3:	c3                   	ret    

008017c4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 0b                	push   $0xb
  8017d3:	e8 ce fe ff ff       	call   8016a6 <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	ff 75 0c             	pushl  0xc(%ebp)
  8017e9:	ff 75 08             	pushl  0x8(%ebp)
  8017ec:	6a 0f                	push   $0xf
  8017ee:	e8 b3 fe ff ff       	call   8016a6 <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
	return;
  8017f6:	90                   	nop
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	ff 75 08             	pushl  0x8(%ebp)
  801808:	6a 10                	push   $0x10
  80180a:	e8 97 fe ff ff       	call   8016a6 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
	return ;
  801812:	90                   	nop
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	ff 75 10             	pushl  0x10(%ebp)
  80181f:	ff 75 0c             	pushl  0xc(%ebp)
  801822:	ff 75 08             	pushl  0x8(%ebp)
  801825:	6a 11                	push   $0x11
  801827:	e8 7a fe ff ff       	call   8016a6 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
	return ;
  80182f:	90                   	nop
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 0c                	push   $0xc
  801841:	e8 60 fe ff ff       	call   8016a6 <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	ff 75 08             	pushl  0x8(%ebp)
  801859:	6a 0d                	push   $0xd
  80185b:	e8 46 fe ff ff       	call   8016a6 <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 0e                	push   $0xe
  801874:	e8 2d fe ff ff       	call   8016a6 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
}
  80187c:	90                   	nop
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 13                	push   $0x13
  80188e:	e8 13 fe ff ff       	call   8016a6 <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	90                   	nop
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 14                	push   $0x14
  8018a8:	e8 f9 fd ff ff       	call   8016a6 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	90                   	nop
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	83 ec 04             	sub    $0x4,%esp
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018bf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	50                   	push   %eax
  8018cc:	6a 15                	push   $0x15
  8018ce:	e8 d3 fd ff ff       	call   8016a6 <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	90                   	nop
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 16                	push   $0x16
  8018e8:	e8 b9 fd ff ff       	call   8016a6 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	90                   	nop
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	ff 75 0c             	pushl  0xc(%ebp)
  801902:	50                   	push   %eax
  801903:	6a 17                	push   $0x17
  801905:	e8 9c fd ff ff       	call   8016a6 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801912:	8b 55 0c             	mov    0xc(%ebp),%edx
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	52                   	push   %edx
  80191f:	50                   	push   %eax
  801920:	6a 1a                	push   $0x1a
  801922:	e8 7f fd ff ff       	call   8016a6 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80192f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	52                   	push   %edx
  80193c:	50                   	push   %eax
  80193d:	6a 18                	push   $0x18
  80193f:	e8 62 fd ff ff       	call   8016a6 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	90                   	nop
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80194d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	52                   	push   %edx
  80195a:	50                   	push   %eax
  80195b:	6a 19                	push   $0x19
  80195d:	e8 44 fd ff ff       	call   8016a6 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	90                   	nop
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	83 ec 04             	sub    $0x4,%esp
  80196e:	8b 45 10             	mov    0x10(%ebp),%eax
  801971:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801974:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801977:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	6a 00                	push   $0x0
  801980:	51                   	push   %ecx
  801981:	52                   	push   %edx
  801982:	ff 75 0c             	pushl  0xc(%ebp)
  801985:	50                   	push   %eax
  801986:	6a 1b                	push   $0x1b
  801988:	e8 19 fd ff ff       	call   8016a6 <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801995:	8b 55 0c             	mov    0xc(%ebp),%edx
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	52                   	push   %edx
  8019a2:	50                   	push   %eax
  8019a3:	6a 1c                	push   $0x1c
  8019a5:	e8 fc fc ff ff       	call   8016a6 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	51                   	push   %ecx
  8019c0:	52                   	push   %edx
  8019c1:	50                   	push   %eax
  8019c2:	6a 1d                	push   $0x1d
  8019c4:	e8 dd fc ff ff       	call   8016a6 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	52                   	push   %edx
  8019de:	50                   	push   %eax
  8019df:	6a 1e                	push   $0x1e
  8019e1:	e8 c0 fc ff ff       	call   8016a6 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 1f                	push   $0x1f
  8019fa:	e8 a7 fc ff ff       	call   8016a6 <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	6a 00                	push   $0x0
  801a0c:	ff 75 14             	pushl  0x14(%ebp)
  801a0f:	ff 75 10             	pushl  0x10(%ebp)
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	50                   	push   %eax
  801a16:	6a 20                	push   $0x20
  801a18:	e8 89 fc ff ff       	call   8016a6 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	50                   	push   %eax
  801a31:	6a 21                	push   $0x21
  801a33:	e8 6e fc ff ff       	call   8016a6 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	90                   	nop
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	50                   	push   %eax
  801a4d:	6a 22                	push   $0x22
  801a4f:	e8 52 fc ff ff       	call   8016a6 <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 02                	push   $0x2
  801a68:	e8 39 fc ff ff       	call   8016a6 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 03                	push   $0x3
  801a81:	e8 20 fc ff ff       	call   8016a6 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 04                	push   $0x4
  801a9a:	e8 07 fc ff ff       	call   8016a6 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_exit_env>:


void sys_exit_env(void)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 23                	push   $0x23
  801ab3:	e8 ee fb ff ff       	call   8016a6 <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	90                   	nop
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ac4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ac7:	8d 50 04             	lea    0x4(%eax),%edx
  801aca:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	52                   	push   %edx
  801ad4:	50                   	push   %eax
  801ad5:	6a 24                	push   $0x24
  801ad7:	e8 ca fb ff ff       	call   8016a6 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
	return result;
  801adf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ae2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ae5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ae8:	89 01                	mov    %eax,(%ecx)
  801aea:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	c9                   	leave  
  801af1:	c2 04 00             	ret    $0x4

00801af4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	ff 75 10             	pushl  0x10(%ebp)
  801afe:	ff 75 0c             	pushl  0xc(%ebp)
  801b01:	ff 75 08             	pushl  0x8(%ebp)
  801b04:	6a 12                	push   $0x12
  801b06:	e8 9b fb ff ff       	call   8016a6 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0e:	90                   	nop
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 25                	push   $0x25
  801b20:	e8 81 fb ff ff       	call   8016a6 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 04             	sub    $0x4,%esp
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b36:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	50                   	push   %eax
  801b43:	6a 26                	push   $0x26
  801b45:	e8 5c fb ff ff       	call   8016a6 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4d:	90                   	nop
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <rsttst>:
void rsttst()
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 28                	push   $0x28
  801b5f:	e8 42 fb ff ff       	call   8016a6 <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
	return ;
  801b67:	90                   	nop
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 04             	sub    $0x4,%esp
  801b70:	8b 45 14             	mov    0x14(%ebp),%eax
  801b73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b76:	8b 55 18             	mov    0x18(%ebp),%edx
  801b79:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b7d:	52                   	push   %edx
  801b7e:	50                   	push   %eax
  801b7f:	ff 75 10             	pushl  0x10(%ebp)
  801b82:	ff 75 0c             	pushl  0xc(%ebp)
  801b85:	ff 75 08             	pushl  0x8(%ebp)
  801b88:	6a 27                	push   $0x27
  801b8a:	e8 17 fb ff ff       	call   8016a6 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b92:	90                   	nop
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <chktst>:
void chktst(uint32 n)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	ff 75 08             	pushl  0x8(%ebp)
  801ba3:	6a 29                	push   $0x29
  801ba5:	e8 fc fa ff ff       	call   8016a6 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
	return ;
  801bad:	90                   	nop
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <inctst>:

void inctst()
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 2a                	push   $0x2a
  801bbf:	e8 e2 fa ff ff       	call   8016a6 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc7:	90                   	nop
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <gettst>:
uint32 gettst()
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 2b                	push   $0x2b
  801bd9:	e8 c8 fa ff ff       	call   8016a6 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 2c                	push   $0x2c
  801bf5:	e8 ac fa ff ff       	call   8016a6 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
  801bfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c00:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c04:	75 07                	jne    801c0d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c06:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0b:	eb 05                	jmp    801c12 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 2c                	push   $0x2c
  801c26:	e8 7b fa ff ff       	call   8016a6 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
  801c2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c31:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c35:	75 07                	jne    801c3e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c37:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3c:	eb 05                	jmp    801c43 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 2c                	push   $0x2c
  801c57:	e8 4a fa ff ff       	call   8016a6 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
  801c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c62:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c66:	75 07                	jne    801c6f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c68:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6d:	eb 05                	jmp    801c74 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801c88:	e8 19 fa ff ff       	call   8016a6 <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
  801c90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c93:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c97:	75 07                	jne    801ca0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c99:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9e:	eb 05                	jmp    801ca5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	ff 75 08             	pushl  0x8(%ebp)
  801cb5:	6a 2d                	push   $0x2d
  801cb7:	e8 ea f9 ff ff       	call   8016a6 <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbf:	90                   	nop
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cc6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	6a 00                	push   $0x0
  801cd4:	53                   	push   %ebx
  801cd5:	51                   	push   %ecx
  801cd6:	52                   	push   %edx
  801cd7:	50                   	push   %eax
  801cd8:	6a 2e                	push   $0x2e
  801cda:	e8 c7 f9 ff ff       	call   8016a6 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	52                   	push   %edx
  801cf7:	50                   	push   %eax
  801cf8:	6a 2f                	push   $0x2f
  801cfa:	e8 a7 f9 ff ff       	call   8016a6 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d0a:	83 ec 0c             	sub    $0xc,%esp
  801d0d:	68 30 3f 80 00       	push   $0x803f30
  801d12:	e8 6b e8 ff ff       	call   800582 <cprintf>
  801d17:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d21:	83 ec 0c             	sub    $0xc,%esp
  801d24:	68 5c 3f 80 00       	push   $0x803f5c
  801d29:	e8 54 e8 ff ff       	call   800582 <cprintf>
  801d2e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d31:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d35:	a1 38 51 80 00       	mov    0x805138,%eax
  801d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d3d:	eb 56                	jmp    801d95 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d43:	74 1c                	je     801d61 <print_mem_block_lists+0x5d>
  801d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d48:	8b 50 08             	mov    0x8(%eax),%edx
  801d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4e:	8b 48 08             	mov    0x8(%eax),%ecx
  801d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d54:	8b 40 0c             	mov    0xc(%eax),%eax
  801d57:	01 c8                	add    %ecx,%eax
  801d59:	39 c2                	cmp    %eax,%edx
  801d5b:	73 04                	jae    801d61 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d5d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d64:	8b 50 08             	mov    0x8(%eax),%edx
  801d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d6d:	01 c2                	add    %eax,%edx
  801d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d72:	8b 40 08             	mov    0x8(%eax),%eax
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	52                   	push   %edx
  801d79:	50                   	push   %eax
  801d7a:	68 71 3f 80 00       	push   $0x803f71
  801d7f:	e8 fe e7 ff ff       	call   800582 <cprintf>
  801d84:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d8d:	a1 40 51 80 00       	mov    0x805140,%eax
  801d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d99:	74 07                	je     801da2 <print_mem_block_lists+0x9e>
  801d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9e:	8b 00                	mov    (%eax),%eax
  801da0:	eb 05                	jmp    801da7 <print_mem_block_lists+0xa3>
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
  801da7:	a3 40 51 80 00       	mov    %eax,0x805140
  801dac:	a1 40 51 80 00       	mov    0x805140,%eax
  801db1:	85 c0                	test   %eax,%eax
  801db3:	75 8a                	jne    801d3f <print_mem_block_lists+0x3b>
  801db5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db9:	75 84                	jne    801d3f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dbb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dbf:	75 10                	jne    801dd1 <print_mem_block_lists+0xcd>
  801dc1:	83 ec 0c             	sub    $0xc,%esp
  801dc4:	68 80 3f 80 00       	push   $0x803f80
  801dc9:	e8 b4 e7 ff ff       	call   800582 <cprintf>
  801dce:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dd1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	68 a4 3f 80 00       	push   $0x803fa4
  801de0:	e8 9d e7 ff ff       	call   800582 <cprintf>
  801de5:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801de8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dec:	a1 40 50 80 00       	mov    0x805040,%eax
  801df1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df4:	eb 56                	jmp    801e4c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801df6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dfa:	74 1c                	je     801e18 <print_mem_block_lists+0x114>
  801dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dff:	8b 50 08             	mov    0x8(%eax),%edx
  801e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e05:	8b 48 08             	mov    0x8(%eax),%ecx
  801e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0e:	01 c8                	add    %ecx,%eax
  801e10:	39 c2                	cmp    %eax,%edx
  801e12:	73 04                	jae    801e18 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e14:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	8b 50 08             	mov    0x8(%eax),%edx
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	8b 40 0c             	mov    0xc(%eax),%eax
  801e24:	01 c2                	add    %eax,%edx
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	8b 40 08             	mov    0x8(%eax),%eax
  801e2c:	83 ec 04             	sub    $0x4,%esp
  801e2f:	52                   	push   %edx
  801e30:	50                   	push   %eax
  801e31:	68 71 3f 80 00       	push   $0x803f71
  801e36:	e8 47 e7 ff ff       	call   800582 <cprintf>
  801e3b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e44:	a1 48 50 80 00       	mov    0x805048,%eax
  801e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e50:	74 07                	je     801e59 <print_mem_block_lists+0x155>
  801e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e55:	8b 00                	mov    (%eax),%eax
  801e57:	eb 05                	jmp    801e5e <print_mem_block_lists+0x15a>
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5e:	a3 48 50 80 00       	mov    %eax,0x805048
  801e63:	a1 48 50 80 00       	mov    0x805048,%eax
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	75 8a                	jne    801df6 <print_mem_block_lists+0xf2>
  801e6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e70:	75 84                	jne    801df6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e72:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e76:	75 10                	jne    801e88 <print_mem_block_lists+0x184>
  801e78:	83 ec 0c             	sub    $0xc,%esp
  801e7b:	68 bc 3f 80 00       	push   $0x803fbc
  801e80:	e8 fd e6 ff ff       	call   800582 <cprintf>
  801e85:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e88:	83 ec 0c             	sub    $0xc,%esp
  801e8b:	68 30 3f 80 00       	push   $0x803f30
  801e90:	e8 ed e6 ff ff       	call   800582 <cprintf>
  801e95:	83 c4 10             	add    $0x10,%esp

}
  801e98:	90                   	nop
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ea1:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ea8:	00 00 00 
  801eab:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801eb2:	00 00 00 
  801eb5:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ebc:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ebf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ec6:	e9 9e 00 00 00       	jmp    801f69 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ecb:	a1 50 50 80 00       	mov    0x805050,%eax
  801ed0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed3:	c1 e2 04             	shl    $0x4,%edx
  801ed6:	01 d0                	add    %edx,%eax
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	75 14                	jne    801ef0 <initialize_MemBlocksList+0x55>
  801edc:	83 ec 04             	sub    $0x4,%esp
  801edf:	68 e4 3f 80 00       	push   $0x803fe4
  801ee4:	6a 46                	push   $0x46
  801ee6:	68 07 40 80 00       	push   $0x804007
  801eeb:	e8 de e3 ff ff       	call   8002ce <_panic>
  801ef0:	a1 50 50 80 00       	mov    0x805050,%eax
  801ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef8:	c1 e2 04             	shl    $0x4,%edx
  801efb:	01 d0                	add    %edx,%eax
  801efd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f03:	89 10                	mov    %edx,(%eax)
  801f05:	8b 00                	mov    (%eax),%eax
  801f07:	85 c0                	test   %eax,%eax
  801f09:	74 18                	je     801f23 <initialize_MemBlocksList+0x88>
  801f0b:	a1 48 51 80 00       	mov    0x805148,%eax
  801f10:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f16:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f19:	c1 e1 04             	shl    $0x4,%ecx
  801f1c:	01 ca                	add    %ecx,%edx
  801f1e:	89 50 04             	mov    %edx,0x4(%eax)
  801f21:	eb 12                	jmp    801f35 <initialize_MemBlocksList+0x9a>
  801f23:	a1 50 50 80 00       	mov    0x805050,%eax
  801f28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2b:	c1 e2 04             	shl    $0x4,%edx
  801f2e:	01 d0                	add    %edx,%eax
  801f30:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f35:	a1 50 50 80 00       	mov    0x805050,%eax
  801f3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3d:	c1 e2 04             	shl    $0x4,%edx
  801f40:	01 d0                	add    %edx,%eax
  801f42:	a3 48 51 80 00       	mov    %eax,0x805148
  801f47:	a1 50 50 80 00       	mov    0x805050,%eax
  801f4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4f:	c1 e2 04             	shl    $0x4,%edx
  801f52:	01 d0                	add    %edx,%eax
  801f54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f5b:	a1 54 51 80 00       	mov    0x805154,%eax
  801f60:	40                   	inc    %eax
  801f61:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f66:	ff 45 f4             	incl   -0xc(%ebp)
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f6f:	0f 82 56 ff ff ff    	jb     801ecb <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f75:	90                   	nop
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	8b 00                	mov    (%eax),%eax
  801f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f86:	eb 19                	jmp    801fa1 <find_block+0x29>
	{
		if(va==point->sva)
  801f88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f8b:	8b 40 08             	mov    0x8(%eax),%eax
  801f8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f91:	75 05                	jne    801f98 <find_block+0x20>
		   return point;
  801f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f96:	eb 36                	jmp    801fce <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	8b 40 08             	mov    0x8(%eax),%eax
  801f9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fa1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fa5:	74 07                	je     801fae <find_block+0x36>
  801fa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801faa:	8b 00                	mov    (%eax),%eax
  801fac:	eb 05                	jmp    801fb3 <find_block+0x3b>
  801fae:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb6:	89 42 08             	mov    %eax,0x8(%edx)
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	8b 40 08             	mov    0x8(%eax),%eax
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	75 c5                	jne    801f88 <find_block+0x10>
  801fc3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fc7:	75 bf                	jne    801f88 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fd6:	a1 40 50 80 00       	mov    0x805040,%eax
  801fdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fde:	a1 44 50 80 00       	mov    0x805044,%eax
  801fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fec:	74 24                	je     802012 <insert_sorted_allocList+0x42>
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	8b 50 08             	mov    0x8(%eax),%edx
  801ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff7:	8b 40 08             	mov    0x8(%eax),%eax
  801ffa:	39 c2                	cmp    %eax,%edx
  801ffc:	76 14                	jbe    802012 <insert_sorted_allocList+0x42>
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	8b 50 08             	mov    0x8(%eax),%edx
  802004:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802007:	8b 40 08             	mov    0x8(%eax),%eax
  80200a:	39 c2                	cmp    %eax,%edx
  80200c:	0f 82 60 01 00 00    	jb     802172 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802012:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802016:	75 65                	jne    80207d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802018:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80201c:	75 14                	jne    802032 <insert_sorted_allocList+0x62>
  80201e:	83 ec 04             	sub    $0x4,%esp
  802021:	68 e4 3f 80 00       	push   $0x803fe4
  802026:	6a 6b                	push   $0x6b
  802028:	68 07 40 80 00       	push   $0x804007
  80202d:	e8 9c e2 ff ff       	call   8002ce <_panic>
  802032:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	89 10                	mov    %edx,(%eax)
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	8b 00                	mov    (%eax),%eax
  802042:	85 c0                	test   %eax,%eax
  802044:	74 0d                	je     802053 <insert_sorted_allocList+0x83>
  802046:	a1 40 50 80 00       	mov    0x805040,%eax
  80204b:	8b 55 08             	mov    0x8(%ebp),%edx
  80204e:	89 50 04             	mov    %edx,0x4(%eax)
  802051:	eb 08                	jmp    80205b <insert_sorted_allocList+0x8b>
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	a3 44 50 80 00       	mov    %eax,0x805044
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	a3 40 50 80 00       	mov    %eax,0x805040
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80206d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802072:	40                   	inc    %eax
  802073:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802078:	e9 dc 01 00 00       	jmp    802259 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	8b 50 08             	mov    0x8(%eax),%edx
  802083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802086:	8b 40 08             	mov    0x8(%eax),%eax
  802089:	39 c2                	cmp    %eax,%edx
  80208b:	77 6c                	ja     8020f9 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80208d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802091:	74 06                	je     802099 <insert_sorted_allocList+0xc9>
  802093:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802097:	75 14                	jne    8020ad <insert_sorted_allocList+0xdd>
  802099:	83 ec 04             	sub    $0x4,%esp
  80209c:	68 20 40 80 00       	push   $0x804020
  8020a1:	6a 6f                	push   $0x6f
  8020a3:	68 07 40 80 00       	push   $0x804007
  8020a8:	e8 21 e2 ff ff       	call   8002ce <_panic>
  8020ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b0:	8b 50 04             	mov    0x4(%eax),%edx
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	89 50 04             	mov    %edx,0x4(%eax)
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020bf:	89 10                	mov    %edx,(%eax)
  8020c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c4:	8b 40 04             	mov    0x4(%eax),%eax
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	74 0d                	je     8020d8 <insert_sorted_allocList+0x108>
  8020cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ce:	8b 40 04             	mov    0x4(%eax),%eax
  8020d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d4:	89 10                	mov    %edx,(%eax)
  8020d6:	eb 08                	jmp    8020e0 <insert_sorted_allocList+0x110>
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	a3 40 50 80 00       	mov    %eax,0x805040
  8020e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e6:	89 50 04             	mov    %edx,0x4(%eax)
  8020e9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020ee:	40                   	inc    %eax
  8020ef:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020f4:	e9 60 01 00 00       	jmp    802259 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	8b 50 08             	mov    0x8(%eax),%edx
  8020ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802102:	8b 40 08             	mov    0x8(%eax),%eax
  802105:	39 c2                	cmp    %eax,%edx
  802107:	0f 82 4c 01 00 00    	jb     802259 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80210d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802111:	75 14                	jne    802127 <insert_sorted_allocList+0x157>
  802113:	83 ec 04             	sub    $0x4,%esp
  802116:	68 58 40 80 00       	push   $0x804058
  80211b:	6a 73                	push   $0x73
  80211d:	68 07 40 80 00       	push   $0x804007
  802122:	e8 a7 e1 ff ff       	call   8002ce <_panic>
  802127:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	89 50 04             	mov    %edx,0x4(%eax)
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	8b 40 04             	mov    0x4(%eax),%eax
  802139:	85 c0                	test   %eax,%eax
  80213b:	74 0c                	je     802149 <insert_sorted_allocList+0x179>
  80213d:	a1 44 50 80 00       	mov    0x805044,%eax
  802142:	8b 55 08             	mov    0x8(%ebp),%edx
  802145:	89 10                	mov    %edx,(%eax)
  802147:	eb 08                	jmp    802151 <insert_sorted_allocList+0x181>
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	a3 40 50 80 00       	mov    %eax,0x805040
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	a3 44 50 80 00       	mov    %eax,0x805044
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802162:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802167:	40                   	inc    %eax
  802168:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80216d:	e9 e7 00 00 00       	jmp    802259 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802172:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802175:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802178:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80217f:	a1 40 50 80 00       	mov    0x805040,%eax
  802184:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802187:	e9 9d 00 00 00       	jmp    802229 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	8b 50 08             	mov    0x8(%eax),%edx
  80219a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219d:	8b 40 08             	mov    0x8(%eax),%eax
  8021a0:	39 c2                	cmp    %eax,%edx
  8021a2:	76 7d                	jbe    802221 <insert_sorted_allocList+0x251>
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	8b 50 08             	mov    0x8(%eax),%edx
  8021aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ad:	8b 40 08             	mov    0x8(%eax),%eax
  8021b0:	39 c2                	cmp    %eax,%edx
  8021b2:	73 6d                	jae    802221 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b8:	74 06                	je     8021c0 <insert_sorted_allocList+0x1f0>
  8021ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021be:	75 14                	jne    8021d4 <insert_sorted_allocList+0x204>
  8021c0:	83 ec 04             	sub    $0x4,%esp
  8021c3:	68 7c 40 80 00       	push   $0x80407c
  8021c8:	6a 7f                	push   $0x7f
  8021ca:	68 07 40 80 00       	push   $0x804007
  8021cf:	e8 fa e0 ff ff       	call   8002ce <_panic>
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	8b 10                	mov    (%eax),%edx
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	89 10                	mov    %edx,(%eax)
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	8b 00                	mov    (%eax),%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	74 0b                	je     8021f2 <insert_sorted_allocList+0x222>
  8021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ea:	8b 00                	mov    (%eax),%eax
  8021ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ef:	89 50 04             	mov    %edx,0x4(%eax)
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f8:	89 10                	mov    %edx,(%eax)
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802200:	89 50 04             	mov    %edx,0x4(%eax)
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	8b 00                	mov    (%eax),%eax
  802208:	85 c0                	test   %eax,%eax
  80220a:	75 08                	jne    802214 <insert_sorted_allocList+0x244>
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	a3 44 50 80 00       	mov    %eax,0x805044
  802214:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802219:	40                   	inc    %eax
  80221a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80221f:	eb 39                	jmp    80225a <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802221:	a1 48 50 80 00       	mov    0x805048,%eax
  802226:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802229:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222d:	74 07                	je     802236 <insert_sorted_allocList+0x266>
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	8b 00                	mov    (%eax),%eax
  802234:	eb 05                	jmp    80223b <insert_sorted_allocList+0x26b>
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
  80223b:	a3 48 50 80 00       	mov    %eax,0x805048
  802240:	a1 48 50 80 00       	mov    0x805048,%eax
  802245:	85 c0                	test   %eax,%eax
  802247:	0f 85 3f ff ff ff    	jne    80218c <insert_sorted_allocList+0x1bc>
  80224d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802251:	0f 85 35 ff ff ff    	jne    80218c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802257:	eb 01                	jmp    80225a <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802259:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80225a:	90                   	nop
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802263:	a1 38 51 80 00       	mov    0x805138,%eax
  802268:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226b:	e9 85 01 00 00       	jmp    8023f5 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802273:	8b 40 0c             	mov    0xc(%eax),%eax
  802276:	3b 45 08             	cmp    0x8(%ebp),%eax
  802279:	0f 82 6e 01 00 00    	jb     8023ed <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	8b 40 0c             	mov    0xc(%eax),%eax
  802285:	3b 45 08             	cmp    0x8(%ebp),%eax
  802288:	0f 85 8a 00 00 00    	jne    802318 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80228e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802292:	75 17                	jne    8022ab <alloc_block_FF+0x4e>
  802294:	83 ec 04             	sub    $0x4,%esp
  802297:	68 b0 40 80 00       	push   $0x8040b0
  80229c:	68 93 00 00 00       	push   $0x93
  8022a1:	68 07 40 80 00       	push   $0x804007
  8022a6:	e8 23 e0 ff ff       	call   8002ce <_panic>
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	8b 00                	mov    (%eax),%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	74 10                	je     8022c4 <alloc_block_FF+0x67>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 00                	mov    (%eax),%eax
  8022b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bc:	8b 52 04             	mov    0x4(%edx),%edx
  8022bf:	89 50 04             	mov    %edx,0x4(%eax)
  8022c2:	eb 0b                	jmp    8022cf <alloc_block_FF+0x72>
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 40 04             	mov    0x4(%eax),%eax
  8022d5:	85 c0                	test   %eax,%eax
  8022d7:	74 0f                	je     8022e8 <alloc_block_FF+0x8b>
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	8b 40 04             	mov    0x4(%eax),%eax
  8022df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e2:	8b 12                	mov    (%edx),%edx
  8022e4:	89 10                	mov    %edx,(%eax)
  8022e6:	eb 0a                	jmp    8022f2 <alloc_block_FF+0x95>
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 00                	mov    (%eax),%eax
  8022ed:	a3 38 51 80 00       	mov    %eax,0x805138
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802305:	a1 44 51 80 00       	mov    0x805144,%eax
  80230a:	48                   	dec    %eax
  80230b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	e9 10 01 00 00       	jmp    802428 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 40 0c             	mov    0xc(%eax),%eax
  80231e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802321:	0f 86 c6 00 00 00    	jbe    8023ed <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802327:	a1 48 51 80 00       	mov    0x805148,%eax
  80232c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	8b 50 08             	mov    0x8(%eax),%edx
  802335:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802338:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80233b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233e:	8b 55 08             	mov    0x8(%ebp),%edx
  802341:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802344:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802348:	75 17                	jne    802361 <alloc_block_FF+0x104>
  80234a:	83 ec 04             	sub    $0x4,%esp
  80234d:	68 b0 40 80 00       	push   $0x8040b0
  802352:	68 9b 00 00 00       	push   $0x9b
  802357:	68 07 40 80 00       	push   $0x804007
  80235c:	e8 6d df ff ff       	call   8002ce <_panic>
  802361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802364:	8b 00                	mov    (%eax),%eax
  802366:	85 c0                	test   %eax,%eax
  802368:	74 10                	je     80237a <alloc_block_FF+0x11d>
  80236a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236d:	8b 00                	mov    (%eax),%eax
  80236f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802372:	8b 52 04             	mov    0x4(%edx),%edx
  802375:	89 50 04             	mov    %edx,0x4(%eax)
  802378:	eb 0b                	jmp    802385 <alloc_block_FF+0x128>
  80237a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237d:	8b 40 04             	mov    0x4(%eax),%eax
  802380:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802388:	8b 40 04             	mov    0x4(%eax),%eax
  80238b:	85 c0                	test   %eax,%eax
  80238d:	74 0f                	je     80239e <alloc_block_FF+0x141>
  80238f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802392:	8b 40 04             	mov    0x4(%eax),%eax
  802395:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802398:	8b 12                	mov    (%edx),%edx
  80239a:	89 10                	mov    %edx,(%eax)
  80239c:	eb 0a                	jmp    8023a8 <alloc_block_FF+0x14b>
  80239e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a1:	8b 00                	mov    (%eax),%eax
  8023a3:	a3 48 51 80 00       	mov    %eax,0x805148
  8023a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8023c0:	48                   	dec    %eax
  8023c1:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 50 08             	mov    0x8(%eax),%edx
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	01 c2                	add    %eax,%edx
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023da:	8b 40 0c             	mov    0xc(%eax),%eax
  8023dd:	2b 45 08             	sub    0x8(%ebp),%eax
  8023e0:	89 c2                	mov    %eax,%edx
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023eb:	eb 3b                	jmp    802428 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023ed:	a1 40 51 80 00       	mov    0x805140,%eax
  8023f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f9:	74 07                	je     802402 <alloc_block_FF+0x1a5>
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 00                	mov    (%eax),%eax
  802400:	eb 05                	jmp    802407 <alloc_block_FF+0x1aa>
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
  802407:	a3 40 51 80 00       	mov    %eax,0x805140
  80240c:	a1 40 51 80 00       	mov    0x805140,%eax
  802411:	85 c0                	test   %eax,%eax
  802413:	0f 85 57 fe ff ff    	jne    802270 <alloc_block_FF+0x13>
  802419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241d:	0f 85 4d fe ff ff    	jne    802270 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802423:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
  80242d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802430:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802437:	a1 38 51 80 00       	mov    0x805138,%eax
  80243c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243f:	e9 df 00 00 00       	jmp    802523 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 40 0c             	mov    0xc(%eax),%eax
  80244a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244d:	0f 82 c8 00 00 00    	jb     80251b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 40 0c             	mov    0xc(%eax),%eax
  802459:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245c:	0f 85 8a 00 00 00    	jne    8024ec <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802462:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802466:	75 17                	jne    80247f <alloc_block_BF+0x55>
  802468:	83 ec 04             	sub    $0x4,%esp
  80246b:	68 b0 40 80 00       	push   $0x8040b0
  802470:	68 b7 00 00 00       	push   $0xb7
  802475:	68 07 40 80 00       	push   $0x804007
  80247a:	e8 4f de ff ff       	call   8002ce <_panic>
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	8b 00                	mov    (%eax),%eax
  802484:	85 c0                	test   %eax,%eax
  802486:	74 10                	je     802498 <alloc_block_BF+0x6e>
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 00                	mov    (%eax),%eax
  80248d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802490:	8b 52 04             	mov    0x4(%edx),%edx
  802493:	89 50 04             	mov    %edx,0x4(%eax)
  802496:	eb 0b                	jmp    8024a3 <alloc_block_BF+0x79>
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 40 04             	mov    0x4(%eax),%eax
  80249e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 40 04             	mov    0x4(%eax),%eax
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	74 0f                	je     8024bc <alloc_block_BF+0x92>
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 40 04             	mov    0x4(%eax),%eax
  8024b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b6:	8b 12                	mov    (%edx),%edx
  8024b8:	89 10                	mov    %edx,(%eax)
  8024ba:	eb 0a                	jmp    8024c6 <alloc_block_BF+0x9c>
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 00                	mov    (%eax),%eax
  8024c1:	a3 38 51 80 00       	mov    %eax,0x805138
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d9:	a1 44 51 80 00       	mov    0x805144,%eax
  8024de:	48                   	dec    %eax
  8024df:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	e9 4d 01 00 00       	jmp    802639 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f5:	76 24                	jbe    80251b <alloc_block_BF+0xf1>
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802500:	73 19                	jae    80251b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802502:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 40 0c             	mov    0xc(%eax),%eax
  80250f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 40 08             	mov    0x8(%eax),%eax
  802518:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80251b:	a1 40 51 80 00       	mov    0x805140,%eax
  802520:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802523:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802527:	74 07                	je     802530 <alloc_block_BF+0x106>
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	eb 05                	jmp    802535 <alloc_block_BF+0x10b>
  802530:	b8 00 00 00 00       	mov    $0x0,%eax
  802535:	a3 40 51 80 00       	mov    %eax,0x805140
  80253a:	a1 40 51 80 00       	mov    0x805140,%eax
  80253f:	85 c0                	test   %eax,%eax
  802541:	0f 85 fd fe ff ff    	jne    802444 <alloc_block_BF+0x1a>
  802547:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254b:	0f 85 f3 fe ff ff    	jne    802444 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802551:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802555:	0f 84 d9 00 00 00    	je     802634 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80255b:	a1 48 51 80 00       	mov    0x805148,%eax
  802560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802566:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802569:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80256c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256f:	8b 55 08             	mov    0x8(%ebp),%edx
  802572:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802575:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802579:	75 17                	jne    802592 <alloc_block_BF+0x168>
  80257b:	83 ec 04             	sub    $0x4,%esp
  80257e:	68 b0 40 80 00       	push   $0x8040b0
  802583:	68 c7 00 00 00       	push   $0xc7
  802588:	68 07 40 80 00       	push   $0x804007
  80258d:	e8 3c dd ff ff       	call   8002ce <_panic>
  802592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802595:	8b 00                	mov    (%eax),%eax
  802597:	85 c0                	test   %eax,%eax
  802599:	74 10                	je     8025ab <alloc_block_BF+0x181>
  80259b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259e:	8b 00                	mov    (%eax),%eax
  8025a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a3:	8b 52 04             	mov    0x4(%edx),%edx
  8025a6:	89 50 04             	mov    %edx,0x4(%eax)
  8025a9:	eb 0b                	jmp    8025b6 <alloc_block_BF+0x18c>
  8025ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ae:	8b 40 04             	mov    0x4(%eax),%eax
  8025b1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b9:	8b 40 04             	mov    0x4(%eax),%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	74 0f                	je     8025cf <alloc_block_BF+0x1a5>
  8025c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c3:	8b 40 04             	mov    0x4(%eax),%eax
  8025c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025c9:	8b 12                	mov    (%edx),%edx
  8025cb:	89 10                	mov    %edx,(%eax)
  8025cd:	eb 0a                	jmp    8025d9 <alloc_block_BF+0x1af>
  8025cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	a3 48 51 80 00       	mov    %eax,0x805148
  8025d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ec:	a1 54 51 80 00       	mov    0x805154,%eax
  8025f1:	48                   	dec    %eax
  8025f2:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025f7:	83 ec 08             	sub    $0x8,%esp
  8025fa:	ff 75 ec             	pushl  -0x14(%ebp)
  8025fd:	68 38 51 80 00       	push   $0x805138
  802602:	e8 71 f9 ff ff       	call   801f78 <find_block>
  802607:	83 c4 10             	add    $0x10,%esp
  80260a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80260d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802610:	8b 50 08             	mov    0x8(%eax),%edx
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	01 c2                	add    %eax,%edx
  802618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80261e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802621:	8b 40 0c             	mov    0xc(%eax),%eax
  802624:	2b 45 08             	sub    0x8(%ebp),%eax
  802627:	89 c2                	mov    %eax,%edx
  802629:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80262f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802632:	eb 05                	jmp    802639 <alloc_block_BF+0x20f>
	}
	return NULL;
  802634:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802639:	c9                   	leave  
  80263a:	c3                   	ret    

0080263b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802641:	a1 28 50 80 00       	mov    0x805028,%eax
  802646:	85 c0                	test   %eax,%eax
  802648:	0f 85 de 01 00 00    	jne    80282c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80264e:	a1 38 51 80 00       	mov    0x805138,%eax
  802653:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802656:	e9 9e 01 00 00       	jmp    8027f9 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 40 0c             	mov    0xc(%eax),%eax
  802661:	3b 45 08             	cmp    0x8(%ebp),%eax
  802664:	0f 82 87 01 00 00    	jb     8027f1 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	8b 40 0c             	mov    0xc(%eax),%eax
  802670:	3b 45 08             	cmp    0x8(%ebp),%eax
  802673:	0f 85 95 00 00 00    	jne    80270e <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267d:	75 17                	jne    802696 <alloc_block_NF+0x5b>
  80267f:	83 ec 04             	sub    $0x4,%esp
  802682:	68 b0 40 80 00       	push   $0x8040b0
  802687:	68 e0 00 00 00       	push   $0xe0
  80268c:	68 07 40 80 00       	push   $0x804007
  802691:	e8 38 dc ff ff       	call   8002ce <_panic>
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 00                	mov    (%eax),%eax
  80269b:	85 c0                	test   %eax,%eax
  80269d:	74 10                	je     8026af <alloc_block_NF+0x74>
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 00                	mov    (%eax),%eax
  8026a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a7:	8b 52 04             	mov    0x4(%edx),%edx
  8026aa:	89 50 04             	mov    %edx,0x4(%eax)
  8026ad:	eb 0b                	jmp    8026ba <alloc_block_NF+0x7f>
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 40 04             	mov    0x4(%eax),%eax
  8026b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	85 c0                	test   %eax,%eax
  8026c2:	74 0f                	je     8026d3 <alloc_block_NF+0x98>
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cd:	8b 12                	mov    (%edx),%edx
  8026cf:	89 10                	mov    %edx,(%eax)
  8026d1:	eb 0a                	jmp    8026dd <alloc_block_NF+0xa2>
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	a3 38 51 80 00       	mov    %eax,0x805138
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8026f5:	48                   	dec    %eax
  8026f6:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 40 08             	mov    0x8(%eax),%eax
  802701:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	e9 f8 04 00 00       	jmp    802c06 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 40 0c             	mov    0xc(%eax),%eax
  802714:	3b 45 08             	cmp    0x8(%ebp),%eax
  802717:	0f 86 d4 00 00 00    	jbe    8027f1 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80271d:	a1 48 51 80 00       	mov    0x805148,%eax
  802722:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 50 08             	mov    0x8(%eax),%edx
  80272b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802734:	8b 55 08             	mov    0x8(%ebp),%edx
  802737:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80273a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80273e:	75 17                	jne    802757 <alloc_block_NF+0x11c>
  802740:	83 ec 04             	sub    $0x4,%esp
  802743:	68 b0 40 80 00       	push   $0x8040b0
  802748:	68 e9 00 00 00       	push   $0xe9
  80274d:	68 07 40 80 00       	push   $0x804007
  802752:	e8 77 db ff ff       	call   8002ce <_panic>
  802757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275a:	8b 00                	mov    (%eax),%eax
  80275c:	85 c0                	test   %eax,%eax
  80275e:	74 10                	je     802770 <alloc_block_NF+0x135>
  802760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802768:	8b 52 04             	mov    0x4(%edx),%edx
  80276b:	89 50 04             	mov    %edx,0x4(%eax)
  80276e:	eb 0b                	jmp    80277b <alloc_block_NF+0x140>
  802770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802773:	8b 40 04             	mov    0x4(%eax),%eax
  802776:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80277b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277e:	8b 40 04             	mov    0x4(%eax),%eax
  802781:	85 c0                	test   %eax,%eax
  802783:	74 0f                	je     802794 <alloc_block_NF+0x159>
  802785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802788:	8b 40 04             	mov    0x4(%eax),%eax
  80278b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80278e:	8b 12                	mov    (%edx),%edx
  802790:	89 10                	mov    %edx,(%eax)
  802792:	eb 0a                	jmp    80279e <alloc_block_NF+0x163>
  802794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802797:	8b 00                	mov    (%eax),%eax
  802799:	a3 48 51 80 00       	mov    %eax,0x805148
  80279e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b1:	a1 54 51 80 00       	mov    0x805154,%eax
  8027b6:	48                   	dec    %eax
  8027b7:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bf:	8b 40 08             	mov    0x8(%eax),%eax
  8027c2:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 50 08             	mov    0x8(%eax),%edx
  8027cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d0:	01 c2                	add    %eax,%edx
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 40 0c             	mov    0xc(%eax),%eax
  8027de:	2b 45 08             	sub    0x8(%ebp),%eax
  8027e1:	89 c2                	mov    %eax,%edx
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ec:	e9 15 04 00 00       	jmp    802c06 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027f1:	a1 40 51 80 00       	mov    0x805140,%eax
  8027f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fd:	74 07                	je     802806 <alloc_block_NF+0x1cb>
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 00                	mov    (%eax),%eax
  802804:	eb 05                	jmp    80280b <alloc_block_NF+0x1d0>
  802806:	b8 00 00 00 00       	mov    $0x0,%eax
  80280b:	a3 40 51 80 00       	mov    %eax,0x805140
  802810:	a1 40 51 80 00       	mov    0x805140,%eax
  802815:	85 c0                	test   %eax,%eax
  802817:	0f 85 3e fe ff ff    	jne    80265b <alloc_block_NF+0x20>
  80281d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802821:	0f 85 34 fe ff ff    	jne    80265b <alloc_block_NF+0x20>
  802827:	e9 d5 03 00 00       	jmp    802c01 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80282c:	a1 38 51 80 00       	mov    0x805138,%eax
  802831:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802834:	e9 b1 01 00 00       	jmp    8029ea <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 50 08             	mov    0x8(%eax),%edx
  80283f:	a1 28 50 80 00       	mov    0x805028,%eax
  802844:	39 c2                	cmp    %eax,%edx
  802846:	0f 82 96 01 00 00    	jb     8029e2 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 40 0c             	mov    0xc(%eax),%eax
  802852:	3b 45 08             	cmp    0x8(%ebp),%eax
  802855:	0f 82 87 01 00 00    	jb     8029e2 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	8b 40 0c             	mov    0xc(%eax),%eax
  802861:	3b 45 08             	cmp    0x8(%ebp),%eax
  802864:	0f 85 95 00 00 00    	jne    8028ff <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80286a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286e:	75 17                	jne    802887 <alloc_block_NF+0x24c>
  802870:	83 ec 04             	sub    $0x4,%esp
  802873:	68 b0 40 80 00       	push   $0x8040b0
  802878:	68 fc 00 00 00       	push   $0xfc
  80287d:	68 07 40 80 00       	push   $0x804007
  802882:	e8 47 da ff ff       	call   8002ce <_panic>
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 00                	mov    (%eax),%eax
  80288c:	85 c0                	test   %eax,%eax
  80288e:	74 10                	je     8028a0 <alloc_block_NF+0x265>
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802898:	8b 52 04             	mov    0x4(%edx),%edx
  80289b:	89 50 04             	mov    %edx,0x4(%eax)
  80289e:	eb 0b                	jmp    8028ab <alloc_block_NF+0x270>
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 40 04             	mov    0x4(%eax),%eax
  8028a6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 04             	mov    0x4(%eax),%eax
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	74 0f                	je     8028c4 <alloc_block_NF+0x289>
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	8b 40 04             	mov    0x4(%eax),%eax
  8028bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028be:	8b 12                	mov    (%edx),%edx
  8028c0:	89 10                	mov    %edx,(%eax)
  8028c2:	eb 0a                	jmp    8028ce <alloc_block_NF+0x293>
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 00                	mov    (%eax),%eax
  8028c9:	a3 38 51 80 00       	mov    %eax,0x805138
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e1:	a1 44 51 80 00       	mov    0x805144,%eax
  8028e6:	48                   	dec    %eax
  8028e7:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 40 08             	mov    0x8(%eax),%eax
  8028f2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	e9 07 03 00 00       	jmp    802c06 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	8b 40 0c             	mov    0xc(%eax),%eax
  802905:	3b 45 08             	cmp    0x8(%ebp),%eax
  802908:	0f 86 d4 00 00 00    	jbe    8029e2 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80290e:	a1 48 51 80 00       	mov    0x805148,%eax
  802913:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 50 08             	mov    0x8(%eax),%edx
  80291c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802922:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802925:	8b 55 08             	mov    0x8(%ebp),%edx
  802928:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80292b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80292f:	75 17                	jne    802948 <alloc_block_NF+0x30d>
  802931:	83 ec 04             	sub    $0x4,%esp
  802934:	68 b0 40 80 00       	push   $0x8040b0
  802939:	68 04 01 00 00       	push   $0x104
  80293e:	68 07 40 80 00       	push   $0x804007
  802943:	e8 86 d9 ff ff       	call   8002ce <_panic>
  802948:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294b:	8b 00                	mov    (%eax),%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	74 10                	je     802961 <alloc_block_NF+0x326>
  802951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802959:	8b 52 04             	mov    0x4(%edx),%edx
  80295c:	89 50 04             	mov    %edx,0x4(%eax)
  80295f:	eb 0b                	jmp    80296c <alloc_block_NF+0x331>
  802961:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802964:	8b 40 04             	mov    0x4(%eax),%eax
  802967:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80296c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296f:	8b 40 04             	mov    0x4(%eax),%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	74 0f                	je     802985 <alloc_block_NF+0x34a>
  802976:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802979:	8b 40 04             	mov    0x4(%eax),%eax
  80297c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80297f:	8b 12                	mov    (%edx),%edx
  802981:	89 10                	mov    %edx,(%eax)
  802983:	eb 0a                	jmp    80298f <alloc_block_NF+0x354>
  802985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802988:	8b 00                	mov    (%eax),%eax
  80298a:	a3 48 51 80 00       	mov    %eax,0x805148
  80298f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802992:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802998:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a2:	a1 54 51 80 00       	mov    0x805154,%eax
  8029a7:	48                   	dec    %eax
  8029a8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b0:	8b 40 08             	mov    0x8(%eax),%eax
  8029b3:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 50 08             	mov    0x8(%eax),%edx
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	01 c2                	add    %eax,%edx
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cf:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d2:	89 c2                	mov    %eax,%edx
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029dd:	e9 24 02 00 00       	jmp    802c06 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029e2:	a1 40 51 80 00       	mov    0x805140,%eax
  8029e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ee:	74 07                	je     8029f7 <alloc_block_NF+0x3bc>
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 00                	mov    (%eax),%eax
  8029f5:	eb 05                	jmp    8029fc <alloc_block_NF+0x3c1>
  8029f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fc:	a3 40 51 80 00       	mov    %eax,0x805140
  802a01:	a1 40 51 80 00       	mov    0x805140,%eax
  802a06:	85 c0                	test   %eax,%eax
  802a08:	0f 85 2b fe ff ff    	jne    802839 <alloc_block_NF+0x1fe>
  802a0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a12:	0f 85 21 fe ff ff    	jne    802839 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a18:	a1 38 51 80 00       	mov    0x805138,%eax
  802a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a20:	e9 ae 01 00 00       	jmp    802bd3 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 50 08             	mov    0x8(%eax),%edx
  802a2b:	a1 28 50 80 00       	mov    0x805028,%eax
  802a30:	39 c2                	cmp    %eax,%edx
  802a32:	0f 83 93 01 00 00    	jae    802bcb <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a41:	0f 82 84 01 00 00    	jb     802bcb <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a50:	0f 85 95 00 00 00    	jne    802aeb <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5a:	75 17                	jne    802a73 <alloc_block_NF+0x438>
  802a5c:	83 ec 04             	sub    $0x4,%esp
  802a5f:	68 b0 40 80 00       	push   $0x8040b0
  802a64:	68 14 01 00 00       	push   $0x114
  802a69:	68 07 40 80 00       	push   $0x804007
  802a6e:	e8 5b d8 ff ff       	call   8002ce <_panic>
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	8b 00                	mov    (%eax),%eax
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	74 10                	je     802a8c <alloc_block_NF+0x451>
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 00                	mov    (%eax),%eax
  802a81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a84:	8b 52 04             	mov    0x4(%edx),%edx
  802a87:	89 50 04             	mov    %edx,0x4(%eax)
  802a8a:	eb 0b                	jmp    802a97 <alloc_block_NF+0x45c>
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 40 04             	mov    0x4(%eax),%eax
  802a92:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 40 04             	mov    0x4(%eax),%eax
  802a9d:	85 c0                	test   %eax,%eax
  802a9f:	74 0f                	je     802ab0 <alloc_block_NF+0x475>
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 40 04             	mov    0x4(%eax),%eax
  802aa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aaa:	8b 12                	mov    (%edx),%edx
  802aac:	89 10                	mov    %edx,(%eax)
  802aae:	eb 0a                	jmp    802aba <alloc_block_NF+0x47f>
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 00                	mov    (%eax),%eax
  802ab5:	a3 38 51 80 00       	mov    %eax,0x805138
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acd:	a1 44 51 80 00       	mov    0x805144,%eax
  802ad2:	48                   	dec    %eax
  802ad3:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 40 08             	mov    0x8(%eax),%eax
  802ade:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	e9 1b 01 00 00       	jmp    802c06 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 40 0c             	mov    0xc(%eax),%eax
  802af1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af4:	0f 86 d1 00 00 00    	jbe    802bcb <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802afa:	a1 48 51 80 00       	mov    0x805148,%eax
  802aff:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 50 08             	mov    0x8(%eax),%edx
  802b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b11:	8b 55 08             	mov    0x8(%ebp),%edx
  802b14:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b1b:	75 17                	jne    802b34 <alloc_block_NF+0x4f9>
  802b1d:	83 ec 04             	sub    $0x4,%esp
  802b20:	68 b0 40 80 00       	push   $0x8040b0
  802b25:	68 1c 01 00 00       	push   $0x11c
  802b2a:	68 07 40 80 00       	push   $0x804007
  802b2f:	e8 9a d7 ff ff       	call   8002ce <_panic>
  802b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b37:	8b 00                	mov    (%eax),%eax
  802b39:	85 c0                	test   %eax,%eax
  802b3b:	74 10                	je     802b4d <alloc_block_NF+0x512>
  802b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b45:	8b 52 04             	mov    0x4(%edx),%edx
  802b48:	89 50 04             	mov    %edx,0x4(%eax)
  802b4b:	eb 0b                	jmp    802b58 <alloc_block_NF+0x51d>
  802b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b50:	8b 40 04             	mov    0x4(%eax),%eax
  802b53:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5b:	8b 40 04             	mov    0x4(%eax),%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	74 0f                	je     802b71 <alloc_block_NF+0x536>
  802b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b65:	8b 40 04             	mov    0x4(%eax),%eax
  802b68:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b6b:	8b 12                	mov    (%edx),%edx
  802b6d:	89 10                	mov    %edx,(%eax)
  802b6f:	eb 0a                	jmp    802b7b <alloc_block_NF+0x540>
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	a3 48 51 80 00       	mov    %eax,0x805148
  802b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8e:	a1 54 51 80 00       	mov    0x805154,%eax
  802b93:	48                   	dec    %eax
  802b94:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9c:	8b 40 08             	mov    0x8(%eax),%eax
  802b9f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 50 08             	mov    0x8(%eax),%edx
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	01 c2                	add    %eax,%edx
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbb:	2b 45 08             	sub    0x8(%ebp),%eax
  802bbe:	89 c2                	mov    %eax,%edx
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc9:	eb 3b                	jmp    802c06 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bcb:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd7:	74 07                	je     802be0 <alloc_block_NF+0x5a5>
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	eb 05                	jmp    802be5 <alloc_block_NF+0x5aa>
  802be0:	b8 00 00 00 00       	mov    $0x0,%eax
  802be5:	a3 40 51 80 00       	mov    %eax,0x805140
  802bea:	a1 40 51 80 00       	mov    0x805140,%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	0f 85 2e fe ff ff    	jne    802a25 <alloc_block_NF+0x3ea>
  802bf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfb:	0f 85 24 fe ff ff    	jne    802a25 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c06:	c9                   	leave  
  802c07:	c3                   	ret    

00802c08 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c08:	55                   	push   %ebp
  802c09:	89 e5                	mov    %esp,%ebp
  802c0b:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c0e:	a1 38 51 80 00       	mov    0x805138,%eax
  802c13:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c16:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c1b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c1e:	a1 38 51 80 00       	mov    0x805138,%eax
  802c23:	85 c0                	test   %eax,%eax
  802c25:	74 14                	je     802c3b <insert_sorted_with_merge_freeList+0x33>
  802c27:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2a:	8b 50 08             	mov    0x8(%eax),%edx
  802c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c30:	8b 40 08             	mov    0x8(%eax),%eax
  802c33:	39 c2                	cmp    %eax,%edx
  802c35:	0f 87 9b 01 00 00    	ja     802dd6 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3f:	75 17                	jne    802c58 <insert_sorted_with_merge_freeList+0x50>
  802c41:	83 ec 04             	sub    $0x4,%esp
  802c44:	68 e4 3f 80 00       	push   $0x803fe4
  802c49:	68 38 01 00 00       	push   $0x138
  802c4e:	68 07 40 80 00       	push   $0x804007
  802c53:	e8 76 d6 ff ff       	call   8002ce <_panic>
  802c58:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	89 10                	mov    %edx,(%eax)
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	8b 00                	mov    (%eax),%eax
  802c68:	85 c0                	test   %eax,%eax
  802c6a:	74 0d                	je     802c79 <insert_sorted_with_merge_freeList+0x71>
  802c6c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c71:	8b 55 08             	mov    0x8(%ebp),%edx
  802c74:	89 50 04             	mov    %edx,0x4(%eax)
  802c77:	eb 08                	jmp    802c81 <insert_sorted_with_merge_freeList+0x79>
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	a3 38 51 80 00       	mov    %eax,0x805138
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c93:	a1 44 51 80 00       	mov    0x805144,%eax
  802c98:	40                   	inc    %eax
  802c99:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca2:	0f 84 a8 06 00 00    	je     803350 <insert_sorted_with_merge_freeList+0x748>
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	8b 50 08             	mov    0x8(%eax),%edx
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb4:	01 c2                	add    %eax,%edx
  802cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb9:	8b 40 08             	mov    0x8(%eax),%eax
  802cbc:	39 c2                	cmp    %eax,%edx
  802cbe:	0f 85 8c 06 00 00    	jne    803350 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc7:	8b 50 0c             	mov    0xc(%eax),%edx
  802cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd0:	01 c2                	add    %eax,%edx
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cd8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cdc:	75 17                	jne    802cf5 <insert_sorted_with_merge_freeList+0xed>
  802cde:	83 ec 04             	sub    $0x4,%esp
  802ce1:	68 b0 40 80 00       	push   $0x8040b0
  802ce6:	68 3c 01 00 00       	push   $0x13c
  802ceb:	68 07 40 80 00       	push   $0x804007
  802cf0:	e8 d9 d5 ff ff       	call   8002ce <_panic>
  802cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	74 10                	je     802d0e <insert_sorted_with_merge_freeList+0x106>
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 00                	mov    (%eax),%eax
  802d03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d06:	8b 52 04             	mov    0x4(%edx),%edx
  802d09:	89 50 04             	mov    %edx,0x4(%eax)
  802d0c:	eb 0b                	jmp    802d19 <insert_sorted_with_merge_freeList+0x111>
  802d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d11:	8b 40 04             	mov    0x4(%eax),%eax
  802d14:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	8b 40 04             	mov    0x4(%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 0f                	je     802d32 <insert_sorted_with_merge_freeList+0x12a>
  802d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d26:	8b 40 04             	mov    0x4(%eax),%eax
  802d29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2c:	8b 12                	mov    (%edx),%edx
  802d2e:	89 10                	mov    %edx,(%eax)
  802d30:	eb 0a                	jmp    802d3c <insert_sorted_with_merge_freeList+0x134>
  802d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d35:	8b 00                	mov    (%eax),%eax
  802d37:	a3 38 51 80 00       	mov    %eax,0x805138
  802d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d54:	48                   	dec    %eax
  802d55:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d72:	75 17                	jne    802d8b <insert_sorted_with_merge_freeList+0x183>
  802d74:	83 ec 04             	sub    $0x4,%esp
  802d77:	68 e4 3f 80 00       	push   $0x803fe4
  802d7c:	68 3f 01 00 00       	push   $0x13f
  802d81:	68 07 40 80 00       	push   $0x804007
  802d86:	e8 43 d5 ff ff       	call   8002ce <_panic>
  802d8b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	89 10                	mov    %edx,(%eax)
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	8b 00                	mov    (%eax),%eax
  802d9b:	85 c0                	test   %eax,%eax
  802d9d:	74 0d                	je     802dac <insert_sorted_with_merge_freeList+0x1a4>
  802d9f:	a1 48 51 80 00       	mov    0x805148,%eax
  802da4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da7:	89 50 04             	mov    %edx,0x4(%eax)
  802daa:	eb 08                	jmp    802db4 <insert_sorted_with_merge_freeList+0x1ac>
  802dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db7:	a3 48 51 80 00       	mov    %eax,0x805148
  802dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc6:	a1 54 51 80 00       	mov    0x805154,%eax
  802dcb:	40                   	inc    %eax
  802dcc:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dd1:	e9 7a 05 00 00       	jmp    803350 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	8b 50 08             	mov    0x8(%eax),%edx
  802ddc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddf:	8b 40 08             	mov    0x8(%eax),%eax
  802de2:	39 c2                	cmp    %eax,%edx
  802de4:	0f 82 14 01 00 00    	jb     802efe <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ded:	8b 50 08             	mov    0x8(%eax),%edx
  802df0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df3:	8b 40 0c             	mov    0xc(%eax),%eax
  802df6:	01 c2                	add    %eax,%edx
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	8b 40 08             	mov    0x8(%eax),%eax
  802dfe:	39 c2                	cmp    %eax,%edx
  802e00:	0f 85 90 00 00 00    	jne    802e96 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e09:	8b 50 0c             	mov    0xc(%eax),%edx
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e12:	01 c2                	add    %eax,%edx
  802e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e17:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e32:	75 17                	jne    802e4b <insert_sorted_with_merge_freeList+0x243>
  802e34:	83 ec 04             	sub    $0x4,%esp
  802e37:	68 e4 3f 80 00       	push   $0x803fe4
  802e3c:	68 49 01 00 00       	push   $0x149
  802e41:	68 07 40 80 00       	push   $0x804007
  802e46:	e8 83 d4 ff ff       	call   8002ce <_panic>
  802e4b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	89 10                	mov    %edx,(%eax)
  802e56:	8b 45 08             	mov    0x8(%ebp),%eax
  802e59:	8b 00                	mov    (%eax),%eax
  802e5b:	85 c0                	test   %eax,%eax
  802e5d:	74 0d                	je     802e6c <insert_sorted_with_merge_freeList+0x264>
  802e5f:	a1 48 51 80 00       	mov    0x805148,%eax
  802e64:	8b 55 08             	mov    0x8(%ebp),%edx
  802e67:	89 50 04             	mov    %edx,0x4(%eax)
  802e6a:	eb 08                	jmp    802e74 <insert_sorted_with_merge_freeList+0x26c>
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	a3 48 51 80 00       	mov    %eax,0x805148
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e86:	a1 54 51 80 00       	mov    0x805154,%eax
  802e8b:	40                   	inc    %eax
  802e8c:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e91:	e9 bb 04 00 00       	jmp    803351 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9a:	75 17                	jne    802eb3 <insert_sorted_with_merge_freeList+0x2ab>
  802e9c:	83 ec 04             	sub    $0x4,%esp
  802e9f:	68 58 40 80 00       	push   $0x804058
  802ea4:	68 4c 01 00 00       	push   $0x14c
  802ea9:	68 07 40 80 00       	push   $0x804007
  802eae:	e8 1b d4 ff ff       	call   8002ce <_panic>
  802eb3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	89 50 04             	mov    %edx,0x4(%eax)
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	8b 40 04             	mov    0x4(%eax),%eax
  802ec5:	85 c0                	test   %eax,%eax
  802ec7:	74 0c                	je     802ed5 <insert_sorted_with_merge_freeList+0x2cd>
  802ec9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ece:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed1:	89 10                	mov    %edx,(%eax)
  802ed3:	eb 08                	jmp    802edd <insert_sorted_with_merge_freeList+0x2d5>
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	a3 38 51 80 00       	mov    %eax,0x805138
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eee:	a1 44 51 80 00       	mov    0x805144,%eax
  802ef3:	40                   	inc    %eax
  802ef4:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ef9:	e9 53 04 00 00       	jmp    803351 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802efe:	a1 38 51 80 00       	mov    0x805138,%eax
  802f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f06:	e9 15 04 00 00       	jmp    803320 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	8b 50 08             	mov    0x8(%eax),%edx
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	8b 40 08             	mov    0x8(%eax),%eax
  802f1f:	39 c2                	cmp    %eax,%edx
  802f21:	0f 86 f1 03 00 00    	jbe    803318 <insert_sorted_with_merge_freeList+0x710>
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	8b 50 08             	mov    0x8(%eax),%edx
  802f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f30:	8b 40 08             	mov    0x8(%eax),%eax
  802f33:	39 c2                	cmp    %eax,%edx
  802f35:	0f 83 dd 03 00 00    	jae    803318 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 50 08             	mov    0x8(%eax),%edx
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	8b 40 0c             	mov    0xc(%eax),%eax
  802f47:	01 c2                	add    %eax,%edx
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	8b 40 08             	mov    0x8(%eax),%eax
  802f4f:	39 c2                	cmp    %eax,%edx
  802f51:	0f 85 b9 01 00 00    	jne    803110 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	8b 50 08             	mov    0x8(%eax),%edx
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	8b 40 0c             	mov    0xc(%eax),%eax
  802f63:	01 c2                	add    %eax,%edx
  802f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f68:	8b 40 08             	mov    0x8(%eax),%eax
  802f6b:	39 c2                	cmp    %eax,%edx
  802f6d:	0f 85 0d 01 00 00    	jne    803080 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 50 0c             	mov    0xc(%eax),%edx
  802f79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7f:	01 c2                	add    %eax,%edx
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f8b:	75 17                	jne    802fa4 <insert_sorted_with_merge_freeList+0x39c>
  802f8d:	83 ec 04             	sub    $0x4,%esp
  802f90:	68 b0 40 80 00       	push   $0x8040b0
  802f95:	68 5c 01 00 00       	push   $0x15c
  802f9a:	68 07 40 80 00       	push   $0x804007
  802f9f:	e8 2a d3 ff ff       	call   8002ce <_panic>
  802fa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa7:	8b 00                	mov    (%eax),%eax
  802fa9:	85 c0                	test   %eax,%eax
  802fab:	74 10                	je     802fbd <insert_sorted_with_merge_freeList+0x3b5>
  802fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb5:	8b 52 04             	mov    0x4(%edx),%edx
  802fb8:	89 50 04             	mov    %edx,0x4(%eax)
  802fbb:	eb 0b                	jmp    802fc8 <insert_sorted_with_merge_freeList+0x3c0>
  802fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc0:	8b 40 04             	mov    0x4(%eax),%eax
  802fc3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcb:	8b 40 04             	mov    0x4(%eax),%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	74 0f                	je     802fe1 <insert_sorted_with_merge_freeList+0x3d9>
  802fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd5:	8b 40 04             	mov    0x4(%eax),%eax
  802fd8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fdb:	8b 12                	mov    (%edx),%edx
  802fdd:	89 10                	mov    %edx,(%eax)
  802fdf:	eb 0a                	jmp    802feb <insert_sorted_with_merge_freeList+0x3e3>
  802fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe4:	8b 00                	mov    (%eax),%eax
  802fe6:	a3 38 51 80 00       	mov    %eax,0x805138
  802feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffe:	a1 44 51 80 00       	mov    0x805144,%eax
  803003:	48                   	dec    %eax
  803004:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803009:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803013:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803016:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80301d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803021:	75 17                	jne    80303a <insert_sorted_with_merge_freeList+0x432>
  803023:	83 ec 04             	sub    $0x4,%esp
  803026:	68 e4 3f 80 00       	push   $0x803fe4
  80302b:	68 5f 01 00 00       	push   $0x15f
  803030:	68 07 40 80 00       	push   $0x804007
  803035:	e8 94 d2 ff ff       	call   8002ce <_panic>
  80303a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803040:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803043:	89 10                	mov    %edx,(%eax)
  803045:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803048:	8b 00                	mov    (%eax),%eax
  80304a:	85 c0                	test   %eax,%eax
  80304c:	74 0d                	je     80305b <insert_sorted_with_merge_freeList+0x453>
  80304e:	a1 48 51 80 00       	mov    0x805148,%eax
  803053:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803056:	89 50 04             	mov    %edx,0x4(%eax)
  803059:	eb 08                	jmp    803063 <insert_sorted_with_merge_freeList+0x45b>
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803063:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803066:	a3 48 51 80 00       	mov    %eax,0x805148
  80306b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803075:	a1 54 51 80 00       	mov    0x805154,%eax
  80307a:	40                   	inc    %eax
  80307b:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 50 0c             	mov    0xc(%eax),%edx
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	8b 40 0c             	mov    0xc(%eax),%eax
  80308c:	01 c2                	add    %eax,%edx
  80308e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803091:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80309e:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ac:	75 17                	jne    8030c5 <insert_sorted_with_merge_freeList+0x4bd>
  8030ae:	83 ec 04             	sub    $0x4,%esp
  8030b1:	68 e4 3f 80 00       	push   $0x803fe4
  8030b6:	68 64 01 00 00       	push   $0x164
  8030bb:	68 07 40 80 00       	push   $0x804007
  8030c0:	e8 09 d2 ff ff       	call   8002ce <_panic>
  8030c5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	89 10                	mov    %edx,(%eax)
  8030d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d3:	8b 00                	mov    (%eax),%eax
  8030d5:	85 c0                	test   %eax,%eax
  8030d7:	74 0d                	je     8030e6 <insert_sorted_with_merge_freeList+0x4de>
  8030d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8030de:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e1:	89 50 04             	mov    %edx,0x4(%eax)
  8030e4:	eb 08                	jmp    8030ee <insert_sorted_with_merge_freeList+0x4e6>
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803100:	a1 54 51 80 00       	mov    0x805154,%eax
  803105:	40                   	inc    %eax
  803106:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80310b:	e9 41 02 00 00       	jmp    803351 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	8b 50 08             	mov    0x8(%eax),%edx
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	8b 40 0c             	mov    0xc(%eax),%eax
  80311c:	01 c2                	add    %eax,%edx
  80311e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803121:	8b 40 08             	mov    0x8(%eax),%eax
  803124:	39 c2                	cmp    %eax,%edx
  803126:	0f 85 7c 01 00 00    	jne    8032a8 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80312c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803130:	74 06                	je     803138 <insert_sorted_with_merge_freeList+0x530>
  803132:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803136:	75 17                	jne    80314f <insert_sorted_with_merge_freeList+0x547>
  803138:	83 ec 04             	sub    $0x4,%esp
  80313b:	68 20 40 80 00       	push   $0x804020
  803140:	68 69 01 00 00       	push   $0x169
  803145:	68 07 40 80 00       	push   $0x804007
  80314a:	e8 7f d1 ff ff       	call   8002ce <_panic>
  80314f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803152:	8b 50 04             	mov    0x4(%eax),%edx
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	89 50 04             	mov    %edx,0x4(%eax)
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803161:	89 10                	mov    %edx,(%eax)
  803163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803166:	8b 40 04             	mov    0x4(%eax),%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	74 0d                	je     80317a <insert_sorted_with_merge_freeList+0x572>
  80316d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803170:	8b 40 04             	mov    0x4(%eax),%eax
  803173:	8b 55 08             	mov    0x8(%ebp),%edx
  803176:	89 10                	mov    %edx,(%eax)
  803178:	eb 08                	jmp    803182 <insert_sorted_with_merge_freeList+0x57a>
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	a3 38 51 80 00       	mov    %eax,0x805138
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	8b 55 08             	mov    0x8(%ebp),%edx
  803188:	89 50 04             	mov    %edx,0x4(%eax)
  80318b:	a1 44 51 80 00       	mov    0x805144,%eax
  803190:	40                   	inc    %eax
  803191:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	8b 50 0c             	mov    0xc(%eax),%edx
  80319c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319f:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a2:	01 c2                	add    %eax,%edx
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ae:	75 17                	jne    8031c7 <insert_sorted_with_merge_freeList+0x5bf>
  8031b0:	83 ec 04             	sub    $0x4,%esp
  8031b3:	68 b0 40 80 00       	push   $0x8040b0
  8031b8:	68 6b 01 00 00       	push   $0x16b
  8031bd:	68 07 40 80 00       	push   $0x804007
  8031c2:	e8 07 d1 ff ff       	call   8002ce <_panic>
  8031c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	85 c0                	test   %eax,%eax
  8031ce:	74 10                	je     8031e0 <insert_sorted_with_merge_freeList+0x5d8>
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	8b 00                	mov    (%eax),%eax
  8031d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d8:	8b 52 04             	mov    0x4(%edx),%edx
  8031db:	89 50 04             	mov    %edx,0x4(%eax)
  8031de:	eb 0b                	jmp    8031eb <insert_sorted_with_merge_freeList+0x5e3>
  8031e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e3:	8b 40 04             	mov    0x4(%eax),%eax
  8031e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ee:	8b 40 04             	mov    0x4(%eax),%eax
  8031f1:	85 c0                	test   %eax,%eax
  8031f3:	74 0f                	je     803204 <insert_sorted_with_merge_freeList+0x5fc>
  8031f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f8:	8b 40 04             	mov    0x4(%eax),%eax
  8031fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031fe:	8b 12                	mov    (%edx),%edx
  803200:	89 10                	mov    %edx,(%eax)
  803202:	eb 0a                	jmp    80320e <insert_sorted_with_merge_freeList+0x606>
  803204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803207:	8b 00                	mov    (%eax),%eax
  803209:	a3 38 51 80 00       	mov    %eax,0x805138
  80320e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803211:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803221:	a1 44 51 80 00       	mov    0x805144,%eax
  803226:	48                   	dec    %eax
  803227:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80322c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803239:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803240:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803244:	75 17                	jne    80325d <insert_sorted_with_merge_freeList+0x655>
  803246:	83 ec 04             	sub    $0x4,%esp
  803249:	68 e4 3f 80 00       	push   $0x803fe4
  80324e:	68 6e 01 00 00       	push   $0x16e
  803253:	68 07 40 80 00       	push   $0x804007
  803258:	e8 71 d0 ff ff       	call   8002ce <_panic>
  80325d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803263:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803266:	89 10                	mov    %edx,(%eax)
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	85 c0                	test   %eax,%eax
  80326f:	74 0d                	je     80327e <insert_sorted_with_merge_freeList+0x676>
  803271:	a1 48 51 80 00       	mov    0x805148,%eax
  803276:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803279:	89 50 04             	mov    %edx,0x4(%eax)
  80327c:	eb 08                	jmp    803286 <insert_sorted_with_merge_freeList+0x67e>
  80327e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803281:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803286:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803289:	a3 48 51 80 00       	mov    %eax,0x805148
  80328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803291:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803298:	a1 54 51 80 00       	mov    0x805154,%eax
  80329d:	40                   	inc    %eax
  80329e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032a3:	e9 a9 00 00 00       	jmp    803351 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ac:	74 06                	je     8032b4 <insert_sorted_with_merge_freeList+0x6ac>
  8032ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b2:	75 17                	jne    8032cb <insert_sorted_with_merge_freeList+0x6c3>
  8032b4:	83 ec 04             	sub    $0x4,%esp
  8032b7:	68 7c 40 80 00       	push   $0x80407c
  8032bc:	68 73 01 00 00       	push   $0x173
  8032c1:	68 07 40 80 00       	push   $0x804007
  8032c6:	e8 03 d0 ff ff       	call   8002ce <_panic>
  8032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ce:	8b 10                	mov    (%eax),%edx
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	89 10                	mov    %edx,(%eax)
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	8b 00                	mov    (%eax),%eax
  8032da:	85 c0                	test   %eax,%eax
  8032dc:	74 0b                	je     8032e9 <insert_sorted_with_merge_freeList+0x6e1>
  8032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e1:	8b 00                	mov    (%eax),%eax
  8032e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e6:	89 50 04             	mov    %edx,0x4(%eax)
  8032e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ef:	89 10                	mov    %edx,(%eax)
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f7:	89 50 04             	mov    %edx,0x4(%eax)
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	8b 00                	mov    (%eax),%eax
  8032ff:	85 c0                	test   %eax,%eax
  803301:	75 08                	jne    80330b <insert_sorted_with_merge_freeList+0x703>
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80330b:	a1 44 51 80 00       	mov    0x805144,%eax
  803310:	40                   	inc    %eax
  803311:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803316:	eb 39                	jmp    803351 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803318:	a1 40 51 80 00       	mov    0x805140,%eax
  80331d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803320:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803324:	74 07                	je     80332d <insert_sorted_with_merge_freeList+0x725>
  803326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803329:	8b 00                	mov    (%eax),%eax
  80332b:	eb 05                	jmp    803332 <insert_sorted_with_merge_freeList+0x72a>
  80332d:	b8 00 00 00 00       	mov    $0x0,%eax
  803332:	a3 40 51 80 00       	mov    %eax,0x805140
  803337:	a1 40 51 80 00       	mov    0x805140,%eax
  80333c:	85 c0                	test   %eax,%eax
  80333e:	0f 85 c7 fb ff ff    	jne    802f0b <insert_sorted_with_merge_freeList+0x303>
  803344:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803348:	0f 85 bd fb ff ff    	jne    802f0b <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80334e:	eb 01                	jmp    803351 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803350:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803351:	90                   	nop
  803352:	c9                   	leave  
  803353:	c3                   	ret    

00803354 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803354:	55                   	push   %ebp
  803355:	89 e5                	mov    %esp,%ebp
  803357:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80335a:	8b 55 08             	mov    0x8(%ebp),%edx
  80335d:	89 d0                	mov    %edx,%eax
  80335f:	c1 e0 02             	shl    $0x2,%eax
  803362:	01 d0                	add    %edx,%eax
  803364:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80336b:	01 d0                	add    %edx,%eax
  80336d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803374:	01 d0                	add    %edx,%eax
  803376:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80337d:	01 d0                	add    %edx,%eax
  80337f:	c1 e0 04             	shl    $0x4,%eax
  803382:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803385:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80338c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80338f:	83 ec 0c             	sub    $0xc,%esp
  803392:	50                   	push   %eax
  803393:	e8 26 e7 ff ff       	call   801abe <sys_get_virtual_time>
  803398:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80339b:	eb 41                	jmp    8033de <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80339d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033a0:	83 ec 0c             	sub    $0xc,%esp
  8033a3:	50                   	push   %eax
  8033a4:	e8 15 e7 ff ff       	call   801abe <sys_get_virtual_time>
  8033a9:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b2:	29 c2                	sub    %eax,%edx
  8033b4:	89 d0                	mov    %edx,%eax
  8033b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033bf:	89 d1                	mov    %edx,%ecx
  8033c1:	29 c1                	sub    %eax,%ecx
  8033c3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033c9:	39 c2                	cmp    %eax,%edx
  8033cb:	0f 97 c0             	seta   %al
  8033ce:	0f b6 c0             	movzbl %al,%eax
  8033d1:	29 c1                	sub    %eax,%ecx
  8033d3:	89 c8                	mov    %ecx,%eax
  8033d5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033db:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033e4:	72 b7                	jb     80339d <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033e6:	90                   	nop
  8033e7:	c9                   	leave  
  8033e8:	c3                   	ret    

008033e9 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033e9:	55                   	push   %ebp
  8033ea:	89 e5                	mov    %esp,%ebp
  8033ec:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033f6:	eb 03                	jmp    8033fb <busy_wait+0x12>
  8033f8:	ff 45 fc             	incl   -0x4(%ebp)
  8033fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  803401:	72 f5                	jb     8033f8 <busy_wait+0xf>
	return i;
  803403:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803406:	c9                   	leave  
  803407:	c3                   	ret    

00803408 <__udivdi3>:
  803408:	55                   	push   %ebp
  803409:	57                   	push   %edi
  80340a:	56                   	push   %esi
  80340b:	53                   	push   %ebx
  80340c:	83 ec 1c             	sub    $0x1c,%esp
  80340f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803413:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803417:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80341b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80341f:	89 ca                	mov    %ecx,%edx
  803421:	89 f8                	mov    %edi,%eax
  803423:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803427:	85 f6                	test   %esi,%esi
  803429:	75 2d                	jne    803458 <__udivdi3+0x50>
  80342b:	39 cf                	cmp    %ecx,%edi
  80342d:	77 65                	ja     803494 <__udivdi3+0x8c>
  80342f:	89 fd                	mov    %edi,%ebp
  803431:	85 ff                	test   %edi,%edi
  803433:	75 0b                	jne    803440 <__udivdi3+0x38>
  803435:	b8 01 00 00 00       	mov    $0x1,%eax
  80343a:	31 d2                	xor    %edx,%edx
  80343c:	f7 f7                	div    %edi
  80343e:	89 c5                	mov    %eax,%ebp
  803440:	31 d2                	xor    %edx,%edx
  803442:	89 c8                	mov    %ecx,%eax
  803444:	f7 f5                	div    %ebp
  803446:	89 c1                	mov    %eax,%ecx
  803448:	89 d8                	mov    %ebx,%eax
  80344a:	f7 f5                	div    %ebp
  80344c:	89 cf                	mov    %ecx,%edi
  80344e:	89 fa                	mov    %edi,%edx
  803450:	83 c4 1c             	add    $0x1c,%esp
  803453:	5b                   	pop    %ebx
  803454:	5e                   	pop    %esi
  803455:	5f                   	pop    %edi
  803456:	5d                   	pop    %ebp
  803457:	c3                   	ret    
  803458:	39 ce                	cmp    %ecx,%esi
  80345a:	77 28                	ja     803484 <__udivdi3+0x7c>
  80345c:	0f bd fe             	bsr    %esi,%edi
  80345f:	83 f7 1f             	xor    $0x1f,%edi
  803462:	75 40                	jne    8034a4 <__udivdi3+0x9c>
  803464:	39 ce                	cmp    %ecx,%esi
  803466:	72 0a                	jb     803472 <__udivdi3+0x6a>
  803468:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80346c:	0f 87 9e 00 00 00    	ja     803510 <__udivdi3+0x108>
  803472:	b8 01 00 00 00       	mov    $0x1,%eax
  803477:	89 fa                	mov    %edi,%edx
  803479:	83 c4 1c             	add    $0x1c,%esp
  80347c:	5b                   	pop    %ebx
  80347d:	5e                   	pop    %esi
  80347e:	5f                   	pop    %edi
  80347f:	5d                   	pop    %ebp
  803480:	c3                   	ret    
  803481:	8d 76 00             	lea    0x0(%esi),%esi
  803484:	31 ff                	xor    %edi,%edi
  803486:	31 c0                	xor    %eax,%eax
  803488:	89 fa                	mov    %edi,%edx
  80348a:	83 c4 1c             	add    $0x1c,%esp
  80348d:	5b                   	pop    %ebx
  80348e:	5e                   	pop    %esi
  80348f:	5f                   	pop    %edi
  803490:	5d                   	pop    %ebp
  803491:	c3                   	ret    
  803492:	66 90                	xchg   %ax,%ax
  803494:	89 d8                	mov    %ebx,%eax
  803496:	f7 f7                	div    %edi
  803498:	31 ff                	xor    %edi,%edi
  80349a:	89 fa                	mov    %edi,%edx
  80349c:	83 c4 1c             	add    $0x1c,%esp
  80349f:	5b                   	pop    %ebx
  8034a0:	5e                   	pop    %esi
  8034a1:	5f                   	pop    %edi
  8034a2:	5d                   	pop    %ebp
  8034a3:	c3                   	ret    
  8034a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034a9:	89 eb                	mov    %ebp,%ebx
  8034ab:	29 fb                	sub    %edi,%ebx
  8034ad:	89 f9                	mov    %edi,%ecx
  8034af:	d3 e6                	shl    %cl,%esi
  8034b1:	89 c5                	mov    %eax,%ebp
  8034b3:	88 d9                	mov    %bl,%cl
  8034b5:	d3 ed                	shr    %cl,%ebp
  8034b7:	89 e9                	mov    %ebp,%ecx
  8034b9:	09 f1                	or     %esi,%ecx
  8034bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034bf:	89 f9                	mov    %edi,%ecx
  8034c1:	d3 e0                	shl    %cl,%eax
  8034c3:	89 c5                	mov    %eax,%ebp
  8034c5:	89 d6                	mov    %edx,%esi
  8034c7:	88 d9                	mov    %bl,%cl
  8034c9:	d3 ee                	shr    %cl,%esi
  8034cb:	89 f9                	mov    %edi,%ecx
  8034cd:	d3 e2                	shl    %cl,%edx
  8034cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034d3:	88 d9                	mov    %bl,%cl
  8034d5:	d3 e8                	shr    %cl,%eax
  8034d7:	09 c2                	or     %eax,%edx
  8034d9:	89 d0                	mov    %edx,%eax
  8034db:	89 f2                	mov    %esi,%edx
  8034dd:	f7 74 24 0c          	divl   0xc(%esp)
  8034e1:	89 d6                	mov    %edx,%esi
  8034e3:	89 c3                	mov    %eax,%ebx
  8034e5:	f7 e5                	mul    %ebp
  8034e7:	39 d6                	cmp    %edx,%esi
  8034e9:	72 19                	jb     803504 <__udivdi3+0xfc>
  8034eb:	74 0b                	je     8034f8 <__udivdi3+0xf0>
  8034ed:	89 d8                	mov    %ebx,%eax
  8034ef:	31 ff                	xor    %edi,%edi
  8034f1:	e9 58 ff ff ff       	jmp    80344e <__udivdi3+0x46>
  8034f6:	66 90                	xchg   %ax,%ax
  8034f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034fc:	89 f9                	mov    %edi,%ecx
  8034fe:	d3 e2                	shl    %cl,%edx
  803500:	39 c2                	cmp    %eax,%edx
  803502:	73 e9                	jae    8034ed <__udivdi3+0xe5>
  803504:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803507:	31 ff                	xor    %edi,%edi
  803509:	e9 40 ff ff ff       	jmp    80344e <__udivdi3+0x46>
  80350e:	66 90                	xchg   %ax,%ax
  803510:	31 c0                	xor    %eax,%eax
  803512:	e9 37 ff ff ff       	jmp    80344e <__udivdi3+0x46>
  803517:	90                   	nop

00803518 <__umoddi3>:
  803518:	55                   	push   %ebp
  803519:	57                   	push   %edi
  80351a:	56                   	push   %esi
  80351b:	53                   	push   %ebx
  80351c:	83 ec 1c             	sub    $0x1c,%esp
  80351f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803523:	8b 74 24 34          	mov    0x34(%esp),%esi
  803527:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80352b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80352f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803533:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803537:	89 f3                	mov    %esi,%ebx
  803539:	89 fa                	mov    %edi,%edx
  80353b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80353f:	89 34 24             	mov    %esi,(%esp)
  803542:	85 c0                	test   %eax,%eax
  803544:	75 1a                	jne    803560 <__umoddi3+0x48>
  803546:	39 f7                	cmp    %esi,%edi
  803548:	0f 86 a2 00 00 00    	jbe    8035f0 <__umoddi3+0xd8>
  80354e:	89 c8                	mov    %ecx,%eax
  803550:	89 f2                	mov    %esi,%edx
  803552:	f7 f7                	div    %edi
  803554:	89 d0                	mov    %edx,%eax
  803556:	31 d2                	xor    %edx,%edx
  803558:	83 c4 1c             	add    $0x1c,%esp
  80355b:	5b                   	pop    %ebx
  80355c:	5e                   	pop    %esi
  80355d:	5f                   	pop    %edi
  80355e:	5d                   	pop    %ebp
  80355f:	c3                   	ret    
  803560:	39 f0                	cmp    %esi,%eax
  803562:	0f 87 ac 00 00 00    	ja     803614 <__umoddi3+0xfc>
  803568:	0f bd e8             	bsr    %eax,%ebp
  80356b:	83 f5 1f             	xor    $0x1f,%ebp
  80356e:	0f 84 ac 00 00 00    	je     803620 <__umoddi3+0x108>
  803574:	bf 20 00 00 00       	mov    $0x20,%edi
  803579:	29 ef                	sub    %ebp,%edi
  80357b:	89 fe                	mov    %edi,%esi
  80357d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803581:	89 e9                	mov    %ebp,%ecx
  803583:	d3 e0                	shl    %cl,%eax
  803585:	89 d7                	mov    %edx,%edi
  803587:	89 f1                	mov    %esi,%ecx
  803589:	d3 ef                	shr    %cl,%edi
  80358b:	09 c7                	or     %eax,%edi
  80358d:	89 e9                	mov    %ebp,%ecx
  80358f:	d3 e2                	shl    %cl,%edx
  803591:	89 14 24             	mov    %edx,(%esp)
  803594:	89 d8                	mov    %ebx,%eax
  803596:	d3 e0                	shl    %cl,%eax
  803598:	89 c2                	mov    %eax,%edx
  80359a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80359e:	d3 e0                	shl    %cl,%eax
  8035a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a8:	89 f1                	mov    %esi,%ecx
  8035aa:	d3 e8                	shr    %cl,%eax
  8035ac:	09 d0                	or     %edx,%eax
  8035ae:	d3 eb                	shr    %cl,%ebx
  8035b0:	89 da                	mov    %ebx,%edx
  8035b2:	f7 f7                	div    %edi
  8035b4:	89 d3                	mov    %edx,%ebx
  8035b6:	f7 24 24             	mull   (%esp)
  8035b9:	89 c6                	mov    %eax,%esi
  8035bb:	89 d1                	mov    %edx,%ecx
  8035bd:	39 d3                	cmp    %edx,%ebx
  8035bf:	0f 82 87 00 00 00    	jb     80364c <__umoddi3+0x134>
  8035c5:	0f 84 91 00 00 00    	je     80365c <__umoddi3+0x144>
  8035cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035cf:	29 f2                	sub    %esi,%edx
  8035d1:	19 cb                	sbb    %ecx,%ebx
  8035d3:	89 d8                	mov    %ebx,%eax
  8035d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035d9:	d3 e0                	shl    %cl,%eax
  8035db:	89 e9                	mov    %ebp,%ecx
  8035dd:	d3 ea                	shr    %cl,%edx
  8035df:	09 d0                	or     %edx,%eax
  8035e1:	89 e9                	mov    %ebp,%ecx
  8035e3:	d3 eb                	shr    %cl,%ebx
  8035e5:	89 da                	mov    %ebx,%edx
  8035e7:	83 c4 1c             	add    $0x1c,%esp
  8035ea:	5b                   	pop    %ebx
  8035eb:	5e                   	pop    %esi
  8035ec:	5f                   	pop    %edi
  8035ed:	5d                   	pop    %ebp
  8035ee:	c3                   	ret    
  8035ef:	90                   	nop
  8035f0:	89 fd                	mov    %edi,%ebp
  8035f2:	85 ff                	test   %edi,%edi
  8035f4:	75 0b                	jne    803601 <__umoddi3+0xe9>
  8035f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035fb:	31 d2                	xor    %edx,%edx
  8035fd:	f7 f7                	div    %edi
  8035ff:	89 c5                	mov    %eax,%ebp
  803601:	89 f0                	mov    %esi,%eax
  803603:	31 d2                	xor    %edx,%edx
  803605:	f7 f5                	div    %ebp
  803607:	89 c8                	mov    %ecx,%eax
  803609:	f7 f5                	div    %ebp
  80360b:	89 d0                	mov    %edx,%eax
  80360d:	e9 44 ff ff ff       	jmp    803556 <__umoddi3+0x3e>
  803612:	66 90                	xchg   %ax,%ax
  803614:	89 c8                	mov    %ecx,%eax
  803616:	89 f2                	mov    %esi,%edx
  803618:	83 c4 1c             	add    $0x1c,%esp
  80361b:	5b                   	pop    %ebx
  80361c:	5e                   	pop    %esi
  80361d:	5f                   	pop    %edi
  80361e:	5d                   	pop    %ebp
  80361f:	c3                   	ret    
  803620:	3b 04 24             	cmp    (%esp),%eax
  803623:	72 06                	jb     80362b <__umoddi3+0x113>
  803625:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803629:	77 0f                	ja     80363a <__umoddi3+0x122>
  80362b:	89 f2                	mov    %esi,%edx
  80362d:	29 f9                	sub    %edi,%ecx
  80362f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803633:	89 14 24             	mov    %edx,(%esp)
  803636:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80363a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80363e:	8b 14 24             	mov    (%esp),%edx
  803641:	83 c4 1c             	add    $0x1c,%esp
  803644:	5b                   	pop    %ebx
  803645:	5e                   	pop    %esi
  803646:	5f                   	pop    %edi
  803647:	5d                   	pop    %ebp
  803648:	c3                   	ret    
  803649:	8d 76 00             	lea    0x0(%esi),%esi
  80364c:	2b 04 24             	sub    (%esp),%eax
  80364f:	19 fa                	sbb    %edi,%edx
  803651:	89 d1                	mov    %edx,%ecx
  803653:	89 c6                	mov    %eax,%esi
  803655:	e9 71 ff ff ff       	jmp    8035cb <__umoddi3+0xb3>
  80365a:	66 90                	xchg   %ax,%ax
  80365c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803660:	72 ea                	jb     80364c <__umoddi3+0x134>
  803662:	89 d9                	mov    %ebx,%ecx
  803664:	e9 62 ff ff ff       	jmp    8035cb <__umoddi3+0xb3>
