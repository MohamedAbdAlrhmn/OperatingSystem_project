
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
  800045:	68 20 36 80 00       	push   $0x803620
  80004a:	e8 03 15 00 00       	call   801552 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 c7 16 00 00       	call   80172a <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 5f 17 00 00       	call   8017ca <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 36 80 00       	push   $0x803630
  800079:	e8 04 05 00 00       	call   800582 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000, (myEnv->SecondListSize),50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 63 36 80 00       	push   $0x803663
  800099:	e8 fe 18 00 00       	call   80199c <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	6a 14                	push   $0x14
  8000b4:	68 6c 36 80 00       	push   $0x80366c
  8000b9:	e8 de 18 00 00       	call   80199c <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 eb 18 00 00       	call   8019ba <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 10 27 00 00       	push   $0x2710
  8000da:	e8 0d 32 00 00       	call   8032ec <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e8:	e8 cd 18 00 00       	call   8019ba <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f0:	90                   	nop
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	83 f8 02             	cmp    $0x2,%eax
  8000f9:	75 f6                	jne    8000f1 <_main+0xb9>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fb:	e8 2a 16 00 00       	call   80172a <sys_calculate_free_frames>
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	68 78 36 80 00       	push   $0x803678
  800109:	e8 74 04 00 00       	call   800582 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 e8             	pushl  -0x18(%ebp)
  800117:	e8 ba 18 00 00       	call   8019d6 <sys_destroy_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 ac 18 00 00       	call   8019d6 <sys_destroy_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80012d:	e8 f8 15 00 00       	call   80172a <sys_calculate_free_frames>
  800132:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800135:	e8 90 16 00 00       	call   8017ca <sys_pf_calculate_allocated_pages>
  80013a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80013d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800143:	74 27                	je     80016c <_main+0x134>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 e0             	pushl  -0x20(%ebp)
  80014b:	68 ac 36 80 00       	push   $0x8036ac
  800150:	e8 2d 04 00 00       	call   800582 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 fc 36 80 00       	push   $0x8036fc
  800160:	6a 23                	push   $0x23
  800162:	68 32 37 80 00       	push   $0x803732
  800167:	e8 62 01 00 00       	call   8002ce <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 e0             	pushl  -0x20(%ebp)
  800172:	68 48 37 80 00       	push   $0x803748
  800177:	e8 06 04 00 00       	call   800582 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 a8 37 80 00       	push   $0x8037a8
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
  800198:	e8 6d 18 00 00       	call   801a0a <sys_getenvindex>
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
  800203:	e8 0f 16 00 00       	call   801817 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 0c 38 80 00       	push   $0x80380c
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
  800233:	68 34 38 80 00       	push   $0x803834
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
  800264:	68 5c 38 80 00       	push   $0x80385c
  800269:	e8 14 03 00 00       	call   800582 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 50 80 00       	mov    0x805020,%eax
  800276:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 b4 38 80 00       	push   $0x8038b4
  800285:	e8 f8 02 00 00       	call   800582 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 0c 38 80 00       	push   $0x80380c
  800295:	e8 e8 02 00 00       	call   800582 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029d:	e8 8f 15 00 00       	call   801831 <sys_enable_interrupt>

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
  8002b5:	e8 1c 17 00 00       	call   8019d6 <sys_destroy_env>
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
  8002c6:	e8 71 17 00 00       	call   801a3c <sys_exit_env>
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
  8002ef:	68 c8 38 80 00       	push   $0x8038c8
  8002f4:	e8 89 02 00 00       	call   800582 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fc:	a1 00 50 80 00       	mov    0x805000,%eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	50                   	push   %eax
  800308:	68 cd 38 80 00       	push   $0x8038cd
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
  80032c:	68 e9 38 80 00       	push   $0x8038e9
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
  800358:	68 ec 38 80 00       	push   $0x8038ec
  80035d:	6a 26                	push   $0x26
  80035f:	68 38 39 80 00       	push   $0x803938
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
  80042a:	68 44 39 80 00       	push   $0x803944
  80042f:	6a 3a                	push   $0x3a
  800431:	68 38 39 80 00       	push   $0x803938
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
  80049a:	68 98 39 80 00       	push   $0x803998
  80049f:	6a 44                	push   $0x44
  8004a1:	68 38 39 80 00       	push   $0x803938
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
  8004f4:	e8 70 11 00 00       	call   801669 <sys_cputs>
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
  80056b:	e8 f9 10 00 00       	call   801669 <sys_cputs>
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
  8005b5:	e8 5d 12 00 00       	call   801817 <sys_disable_interrupt>
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
  8005d5:	e8 57 12 00 00       	call   801831 <sys_enable_interrupt>
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
  80061f:	e8 7c 2d 00 00       	call   8033a0 <__udivdi3>
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
  80066f:	e8 3c 2e 00 00       	call   8034b0 <__umoddi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	05 14 3c 80 00       	add    $0x803c14,%eax
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
  8007ca:	8b 04 85 38 3c 80 00 	mov    0x803c38(,%eax,4),%eax
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
  8008ab:	8b 34 9d 80 3a 80 00 	mov    0x803a80(,%ebx,4),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 19                	jne    8008cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b6:	53                   	push   %ebx
  8008b7:	68 25 3c 80 00       	push   $0x803c25
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
  8008d0:	68 2e 3c 80 00       	push   $0x803c2e
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
  8008fd:	be 31 3c 80 00       	mov    $0x803c31,%esi
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
  801323:	68 90 3d 80 00       	push   $0x803d90
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
  8013f3:	e8 b5 03 00 00       	call   8017ad <sys_allocate_chunk>
  8013f8:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013fb:	a1 20 51 80 00       	mov    0x805120,%eax
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	50                   	push   %eax
  801404:	e8 2a 0a 00 00       	call   801e33 <initialize_MemBlocksList>
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
  801431:	68 b5 3d 80 00       	push   $0x803db5
  801436:	6a 33                	push   $0x33
  801438:	68 d3 3d 80 00       	push   $0x803dd3
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
  8014b0:	68 e0 3d 80 00       	push   $0x803de0
  8014b5:	6a 34                	push   $0x34
  8014b7:	68 d3 3d 80 00       	push   $0x803dd3
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
  801525:	68 04 3e 80 00       	push   $0x803e04
  80152a:	6a 46                	push   $0x46
  80152c:	68 d3 3d 80 00       	push   $0x803dd3
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
  801541:	68 2c 3e 80 00       	push   $0x803e2c
  801546:	6a 61                	push   $0x61
  801548:	68 d3 3d 80 00       	push   $0x803dd3
  80154d:	e8 7c ed ff ff       	call   8002ce <_panic>

00801552 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	83 ec 18             	sub    $0x18,%esp
  801558:	8b 45 10             	mov    0x10(%ebp),%eax
  80155b:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80155e:	e8 a9 fd ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  801563:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801567:	75 07                	jne    801570 <smalloc+0x1e>
  801569:	b8 00 00 00 00       	mov    $0x0,%eax
  80156e:	eb 14                	jmp    801584 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801570:	83 ec 04             	sub    $0x4,%esp
  801573:	68 50 3e 80 00       	push   $0x803e50
  801578:	6a 76                	push   $0x76
  80157a:	68 d3 3d 80 00       	push   $0x803dd3
  80157f:	e8 4a ed ff ff       	call   8002ce <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80158c:	e8 7b fd ff ff       	call   80130c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801591:	83 ec 04             	sub    $0x4,%esp
  801594:	68 78 3e 80 00       	push   $0x803e78
  801599:	68 93 00 00 00       	push   $0x93
  80159e:	68 d3 3d 80 00       	push   $0x803dd3
  8015a3:	e8 26 ed ff ff       	call   8002ce <_panic>

008015a8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ae:	e8 59 fd ff ff       	call   80130c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015b3:	83 ec 04             	sub    $0x4,%esp
  8015b6:	68 9c 3e 80 00       	push   $0x803e9c
  8015bb:	68 c5 00 00 00       	push   $0xc5
  8015c0:	68 d3 3d 80 00       	push   $0x803dd3
  8015c5:	e8 04 ed ff ff       	call   8002ce <_panic>

008015ca <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015d0:	83 ec 04             	sub    $0x4,%esp
  8015d3:	68 c4 3e 80 00       	push   $0x803ec4
  8015d8:	68 d9 00 00 00       	push   $0xd9
  8015dd:	68 d3 3d 80 00       	push   $0x803dd3
  8015e2:	e8 e7 ec ff ff       	call   8002ce <_panic>

008015e7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015ed:	83 ec 04             	sub    $0x4,%esp
  8015f0:	68 e8 3e 80 00       	push   $0x803ee8
  8015f5:	68 e4 00 00 00       	push   $0xe4
  8015fa:	68 d3 3d 80 00       	push   $0x803dd3
  8015ff:	e8 ca ec ff ff       	call   8002ce <_panic>

00801604 <shrink>:

}
void shrink(uint32 newSize)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80160a:	83 ec 04             	sub    $0x4,%esp
  80160d:	68 e8 3e 80 00       	push   $0x803ee8
  801612:	68 e9 00 00 00       	push   $0xe9
  801617:	68 d3 3d 80 00       	push   $0x803dd3
  80161c:	e8 ad ec ff ff       	call   8002ce <_panic>

00801621 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801627:	83 ec 04             	sub    $0x4,%esp
  80162a:	68 e8 3e 80 00       	push   $0x803ee8
  80162f:	68 ee 00 00 00       	push   $0xee
  801634:	68 d3 3d 80 00       	push   $0x803dd3
  801639:	e8 90 ec ff ff       	call   8002ce <_panic>

0080163e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	57                   	push   %edi
  801642:	56                   	push   %esi
  801643:	53                   	push   %ebx
  801644:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801650:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801653:	8b 7d 18             	mov    0x18(%ebp),%edi
  801656:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801659:	cd 30                	int    $0x30
  80165b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80165e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	5b                   	pop    %ebx
  801665:	5e                   	pop    %esi
  801666:	5f                   	pop    %edi
  801667:	5d                   	pop    %ebp
  801668:	c3                   	ret    

00801669 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	8b 45 10             	mov    0x10(%ebp),%eax
  801672:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801675:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	52                   	push   %edx
  801681:	ff 75 0c             	pushl  0xc(%ebp)
  801684:	50                   	push   %eax
  801685:	6a 00                	push   $0x0
  801687:	e8 b2 ff ff ff       	call   80163e <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
}
  80168f:	90                   	nop
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_cgetc>:

int
sys_cgetc(void)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 01                	push   $0x1
  8016a1:	e8 98 ff ff ff       	call   80163e <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	52                   	push   %edx
  8016bb:	50                   	push   %eax
  8016bc:	6a 05                	push   $0x5
  8016be:	e8 7b ff ff ff       	call   80163e <syscall>
  8016c3:	83 c4 18             	add    $0x18,%esp
}
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	56                   	push   %esi
  8016cc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8016d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	56                   	push   %esi
  8016dd:	53                   	push   %ebx
  8016de:	51                   	push   %ecx
  8016df:	52                   	push   %edx
  8016e0:	50                   	push   %eax
  8016e1:	6a 06                	push   $0x6
  8016e3:	e8 56 ff ff ff       	call   80163e <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016ee:	5b                   	pop    %ebx
  8016ef:	5e                   	pop    %esi
  8016f0:	5d                   	pop    %ebp
  8016f1:	c3                   	ret    

008016f2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	52                   	push   %edx
  801702:	50                   	push   %eax
  801703:	6a 07                	push   $0x7
  801705:	e8 34 ff ff ff       	call   80163e <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	ff 75 0c             	pushl  0xc(%ebp)
  80171b:	ff 75 08             	pushl  0x8(%ebp)
  80171e:	6a 08                	push   $0x8
  801720:	e8 19 ff ff ff       	call   80163e <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 09                	push   $0x9
  801739:	e8 00 ff ff ff       	call   80163e <syscall>
  80173e:	83 c4 18             	add    $0x18,%esp
}
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 0a                	push   $0xa
  801752:	e8 e7 fe ff ff       	call   80163e <syscall>
  801757:	83 c4 18             	add    $0x18,%esp
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 0b                	push   $0xb
  80176b:	e8 ce fe ff ff       	call   80163e <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	6a 0f                	push   $0xf
  801786:	e8 b3 fe ff ff       	call   80163e <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
	return;
  80178e:	90                   	nop
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	ff 75 08             	pushl  0x8(%ebp)
  8017a0:	6a 10                	push   $0x10
  8017a2:	e8 97 fe ff ff       	call   80163e <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017aa:	90                   	nop
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	ff 75 10             	pushl  0x10(%ebp)
  8017b7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ba:	ff 75 08             	pushl  0x8(%ebp)
  8017bd:	6a 11                	push   $0x11
  8017bf:	e8 7a fe ff ff       	call   80163e <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c7:	90                   	nop
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 0c                	push   $0xc
  8017d9:	e8 60 fe ff ff       	call   80163e <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	ff 75 08             	pushl  0x8(%ebp)
  8017f1:	6a 0d                	push   $0xd
  8017f3:	e8 46 fe ff ff       	call   80163e <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 0e                	push   $0xe
  80180c:	e8 2d fe ff ff       	call   80163e <syscall>
  801811:	83 c4 18             	add    $0x18,%esp
}
  801814:	90                   	nop
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 13                	push   $0x13
  801826:	e8 13 fe ff ff       	call   80163e <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	90                   	nop
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 14                	push   $0x14
  801840:	e8 f9 fd ff ff       	call   80163e <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	90                   	nop
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_cputc>:


void
sys_cputc(const char c)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 04             	sub    $0x4,%esp
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801857:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	50                   	push   %eax
  801864:	6a 15                	push   $0x15
  801866:	e8 d3 fd ff ff       	call   80163e <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	90                   	nop
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 16                	push   $0x16
  801880:	e8 b9 fd ff ff       	call   80163e <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	90                   	nop
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	50                   	push   %eax
  80189b:	6a 17                	push   $0x17
  80189d:	e8 9c fd ff ff       	call   80163e <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	52                   	push   %edx
  8018b7:	50                   	push   %eax
  8018b8:	6a 1a                	push   $0x1a
  8018ba:	e8 7f fd ff ff       	call   80163e <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	52                   	push   %edx
  8018d4:	50                   	push   %eax
  8018d5:	6a 18                	push   $0x18
  8018d7:	e8 62 fd ff ff       	call   80163e <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	90                   	nop
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	52                   	push   %edx
  8018f2:	50                   	push   %eax
  8018f3:	6a 19                	push   $0x19
  8018f5:	e8 44 fd ff ff       	call   80163e <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	90                   	nop
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 04             	sub    $0x4,%esp
  801906:	8b 45 10             	mov    0x10(%ebp),%eax
  801909:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80190c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80190f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	6a 00                	push   $0x0
  801918:	51                   	push   %ecx
  801919:	52                   	push   %edx
  80191a:	ff 75 0c             	pushl  0xc(%ebp)
  80191d:	50                   	push   %eax
  80191e:	6a 1b                	push   $0x1b
  801920:	e8 19 fd ff ff       	call   80163e <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80192d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	52                   	push   %edx
  80193a:	50                   	push   %eax
  80193b:	6a 1c                	push   $0x1c
  80193d:	e8 fc fc ff ff       	call   80163e <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80194a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80194d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	51                   	push   %ecx
  801958:	52                   	push   %edx
  801959:	50                   	push   %eax
  80195a:	6a 1d                	push   $0x1d
  80195c:	e8 dd fc ff ff       	call   80163e <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	52                   	push   %edx
  801976:	50                   	push   %eax
  801977:	6a 1e                	push   $0x1e
  801979:	e8 c0 fc ff ff       	call   80163e <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 1f                	push   $0x1f
  801992:	e8 a7 fc ff ff       	call   80163e <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	ff 75 14             	pushl  0x14(%ebp)
  8019a7:	ff 75 10             	pushl  0x10(%ebp)
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	50                   	push   %eax
  8019ae:	6a 20                	push   $0x20
  8019b0:	e8 89 fc ff ff       	call   80163e <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	50                   	push   %eax
  8019c9:	6a 21                	push   $0x21
  8019cb:	e8 6e fc ff ff       	call   80163e <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	90                   	nop
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	50                   	push   %eax
  8019e5:	6a 22                	push   $0x22
  8019e7:	e8 52 fc ff ff       	call   80163e <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 02                	push   $0x2
  801a00:	e8 39 fc ff ff       	call   80163e <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 03                	push   $0x3
  801a19:	e8 20 fc ff ff       	call   80163e <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 04                	push   $0x4
  801a32:	e8 07 fc ff ff       	call   80163e <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_exit_env>:


void sys_exit_env(void)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 23                	push   $0x23
  801a4b:	e8 ee fb ff ff       	call   80163e <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	90                   	nop
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a5c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a5f:	8d 50 04             	lea    0x4(%eax),%edx
  801a62:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	52                   	push   %edx
  801a6c:	50                   	push   %eax
  801a6d:	6a 24                	push   $0x24
  801a6f:	e8 ca fb ff ff       	call   80163e <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
	return result;
  801a77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a80:	89 01                	mov    %eax,(%ecx)
  801a82:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	c9                   	leave  
  801a89:	c2 04 00             	ret    $0x4

00801a8c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	ff 75 10             	pushl  0x10(%ebp)
  801a96:	ff 75 0c             	pushl  0xc(%ebp)
  801a99:	ff 75 08             	pushl  0x8(%ebp)
  801a9c:	6a 12                	push   $0x12
  801a9e:	e8 9b fb ff ff       	call   80163e <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa6:	90                   	nop
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 25                	push   $0x25
  801ab8:	e8 81 fb ff ff       	call   80163e <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 04             	sub    $0x4,%esp
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ace:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	50                   	push   %eax
  801adb:	6a 26                	push   $0x26
  801add:	e8 5c fb ff ff       	call   80163e <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae5:	90                   	nop
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <rsttst>:
void rsttst()
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 28                	push   $0x28
  801af7:	e8 42 fb ff ff       	call   80163e <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
	return ;
  801aff:	90                   	nop
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b0e:	8b 55 18             	mov    0x18(%ebp),%edx
  801b11:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b15:	52                   	push   %edx
  801b16:	50                   	push   %eax
  801b17:	ff 75 10             	pushl  0x10(%ebp)
  801b1a:	ff 75 0c             	pushl  0xc(%ebp)
  801b1d:	ff 75 08             	pushl  0x8(%ebp)
  801b20:	6a 27                	push   $0x27
  801b22:	e8 17 fb ff ff       	call   80163e <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2a:	90                   	nop
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <chktst>:
void chktst(uint32 n)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	ff 75 08             	pushl  0x8(%ebp)
  801b3b:	6a 29                	push   $0x29
  801b3d:	e8 fc fa ff ff       	call   80163e <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
	return ;
  801b45:	90                   	nop
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <inctst>:

void inctst()
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 2a                	push   $0x2a
  801b57:	e8 e2 fa ff ff       	call   80163e <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5f:	90                   	nop
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <gettst>:
uint32 gettst()
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 2b                	push   $0x2b
  801b71:	e8 c8 fa ff ff       	call   80163e <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
  801b7e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 2c                	push   $0x2c
  801b8d:	e8 ac fa ff ff       	call   80163e <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
  801b95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b98:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b9c:	75 07                	jne    801ba5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba3:	eb 05                	jmp    801baa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ba5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 2c                	push   $0x2c
  801bbe:	e8 7b fa ff ff       	call   80163e <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
  801bc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bc9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bcd:	75 07                	jne    801bd6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bcf:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd4:	eb 05                	jmp    801bdb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 2c                	push   $0x2c
  801bef:	e8 4a fa ff ff       	call   80163e <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
  801bf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bfa:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bfe:	75 07                	jne    801c07 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c00:	b8 01 00 00 00       	mov    $0x1,%eax
  801c05:	eb 05                	jmp    801c0c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 2c                	push   $0x2c
  801c20:	e8 19 fa ff ff       	call   80163e <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
  801c28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c2b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c2f:	75 07                	jne    801c38 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c31:	b8 01 00 00 00       	mov    $0x1,%eax
  801c36:	eb 05                	jmp    801c3d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	ff 75 08             	pushl  0x8(%ebp)
  801c4d:	6a 2d                	push   $0x2d
  801c4f:	e8 ea f9 ff ff       	call   80163e <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
	return ;
  801c57:	90                   	nop
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c5e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c61:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	6a 00                	push   $0x0
  801c6c:	53                   	push   %ebx
  801c6d:	51                   	push   %ecx
  801c6e:	52                   	push   %edx
  801c6f:	50                   	push   %eax
  801c70:	6a 2e                	push   $0x2e
  801c72:	e8 c7 f9 ff ff       	call   80163e <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	52                   	push   %edx
  801c8f:	50                   	push   %eax
  801c90:	6a 2f                	push   $0x2f
  801c92:	e8 a7 f9 ff ff       	call   80163e <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ca2:	83 ec 0c             	sub    $0xc,%esp
  801ca5:	68 f8 3e 80 00       	push   $0x803ef8
  801caa:	e8 d3 e8 ff ff       	call   800582 <cprintf>
  801caf:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cb2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cb9:	83 ec 0c             	sub    $0xc,%esp
  801cbc:	68 24 3f 80 00       	push   $0x803f24
  801cc1:	e8 bc e8 ff ff       	call   800582 <cprintf>
  801cc6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cc9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ccd:	a1 38 51 80 00       	mov    0x805138,%eax
  801cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cd5:	eb 56                	jmp    801d2d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cdb:	74 1c                	je     801cf9 <print_mem_block_lists+0x5d>
  801cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce0:	8b 50 08             	mov    0x8(%eax),%edx
  801ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce6:	8b 48 08             	mov    0x8(%eax),%ecx
  801ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cec:	8b 40 0c             	mov    0xc(%eax),%eax
  801cef:	01 c8                	add    %ecx,%eax
  801cf1:	39 c2                	cmp    %eax,%edx
  801cf3:	73 04                	jae    801cf9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cf5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfc:	8b 50 08             	mov    0x8(%eax),%edx
  801cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d02:	8b 40 0c             	mov    0xc(%eax),%eax
  801d05:	01 c2                	add    %eax,%edx
  801d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0a:	8b 40 08             	mov    0x8(%eax),%eax
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	52                   	push   %edx
  801d11:	50                   	push   %eax
  801d12:	68 39 3f 80 00       	push   $0x803f39
  801d17:	e8 66 e8 ff ff       	call   800582 <cprintf>
  801d1c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d25:	a1 40 51 80 00       	mov    0x805140,%eax
  801d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d31:	74 07                	je     801d3a <print_mem_block_lists+0x9e>
  801d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d36:	8b 00                	mov    (%eax),%eax
  801d38:	eb 05                	jmp    801d3f <print_mem_block_lists+0xa3>
  801d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3f:	a3 40 51 80 00       	mov    %eax,0x805140
  801d44:	a1 40 51 80 00       	mov    0x805140,%eax
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	75 8a                	jne    801cd7 <print_mem_block_lists+0x3b>
  801d4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d51:	75 84                	jne    801cd7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d53:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d57:	75 10                	jne    801d69 <print_mem_block_lists+0xcd>
  801d59:	83 ec 0c             	sub    $0xc,%esp
  801d5c:	68 48 3f 80 00       	push   $0x803f48
  801d61:	e8 1c e8 ff ff       	call   800582 <cprintf>
  801d66:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d69:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d70:	83 ec 0c             	sub    $0xc,%esp
  801d73:	68 6c 3f 80 00       	push   $0x803f6c
  801d78:	e8 05 e8 ff ff       	call   800582 <cprintf>
  801d7d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d80:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d84:	a1 40 50 80 00       	mov    0x805040,%eax
  801d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d8c:	eb 56                	jmp    801de4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d92:	74 1c                	je     801db0 <print_mem_block_lists+0x114>
  801d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d97:	8b 50 08             	mov    0x8(%eax),%edx
  801d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9d:	8b 48 08             	mov    0x8(%eax),%ecx
  801da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da3:	8b 40 0c             	mov    0xc(%eax),%eax
  801da6:	01 c8                	add    %ecx,%eax
  801da8:	39 c2                	cmp    %eax,%edx
  801daa:	73 04                	jae    801db0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801dac:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db3:	8b 50 08             	mov    0x8(%eax),%edx
  801db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbc:	01 c2                	add    %eax,%edx
  801dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc1:	8b 40 08             	mov    0x8(%eax),%eax
  801dc4:	83 ec 04             	sub    $0x4,%esp
  801dc7:	52                   	push   %edx
  801dc8:	50                   	push   %eax
  801dc9:	68 39 3f 80 00       	push   $0x803f39
  801dce:	e8 af e7 ff ff       	call   800582 <cprintf>
  801dd3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ddc:	a1 48 50 80 00       	mov    0x805048,%eax
  801de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de8:	74 07                	je     801df1 <print_mem_block_lists+0x155>
  801dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ded:	8b 00                	mov    (%eax),%eax
  801def:	eb 05                	jmp    801df6 <print_mem_block_lists+0x15a>
  801df1:	b8 00 00 00 00       	mov    $0x0,%eax
  801df6:	a3 48 50 80 00       	mov    %eax,0x805048
  801dfb:	a1 48 50 80 00       	mov    0x805048,%eax
  801e00:	85 c0                	test   %eax,%eax
  801e02:	75 8a                	jne    801d8e <print_mem_block_lists+0xf2>
  801e04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e08:	75 84                	jne    801d8e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e0a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e0e:	75 10                	jne    801e20 <print_mem_block_lists+0x184>
  801e10:	83 ec 0c             	sub    $0xc,%esp
  801e13:	68 84 3f 80 00       	push   $0x803f84
  801e18:	e8 65 e7 ff ff       	call   800582 <cprintf>
  801e1d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e20:	83 ec 0c             	sub    $0xc,%esp
  801e23:	68 f8 3e 80 00       	push   $0x803ef8
  801e28:	e8 55 e7 ff ff       	call   800582 <cprintf>
  801e2d:	83 c4 10             	add    $0x10,%esp

}
  801e30:	90                   	nop
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e39:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e40:	00 00 00 
  801e43:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801e4a:	00 00 00 
  801e4d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801e54:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e5e:	e9 9e 00 00 00       	jmp    801f01 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e63:	a1 50 50 80 00       	mov    0x805050,%eax
  801e68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6b:	c1 e2 04             	shl    $0x4,%edx
  801e6e:	01 d0                	add    %edx,%eax
  801e70:	85 c0                	test   %eax,%eax
  801e72:	75 14                	jne    801e88 <initialize_MemBlocksList+0x55>
  801e74:	83 ec 04             	sub    $0x4,%esp
  801e77:	68 ac 3f 80 00       	push   $0x803fac
  801e7c:	6a 46                	push   $0x46
  801e7e:	68 cf 3f 80 00       	push   $0x803fcf
  801e83:	e8 46 e4 ff ff       	call   8002ce <_panic>
  801e88:	a1 50 50 80 00       	mov    0x805050,%eax
  801e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e90:	c1 e2 04             	shl    $0x4,%edx
  801e93:	01 d0                	add    %edx,%eax
  801e95:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801e9b:	89 10                	mov    %edx,(%eax)
  801e9d:	8b 00                	mov    (%eax),%eax
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	74 18                	je     801ebb <initialize_MemBlocksList+0x88>
  801ea3:	a1 48 51 80 00       	mov    0x805148,%eax
  801ea8:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801eae:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801eb1:	c1 e1 04             	shl    $0x4,%ecx
  801eb4:	01 ca                	add    %ecx,%edx
  801eb6:	89 50 04             	mov    %edx,0x4(%eax)
  801eb9:	eb 12                	jmp    801ecd <initialize_MemBlocksList+0x9a>
  801ebb:	a1 50 50 80 00       	mov    0x805050,%eax
  801ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec3:	c1 e2 04             	shl    $0x4,%edx
  801ec6:	01 d0                	add    %edx,%eax
  801ec8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ecd:	a1 50 50 80 00       	mov    0x805050,%eax
  801ed2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed5:	c1 e2 04             	shl    $0x4,%edx
  801ed8:	01 d0                	add    %edx,%eax
  801eda:	a3 48 51 80 00       	mov    %eax,0x805148
  801edf:	a1 50 50 80 00       	mov    0x805050,%eax
  801ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee7:	c1 e2 04             	shl    $0x4,%edx
  801eea:	01 d0                	add    %edx,%eax
  801eec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ef3:	a1 54 51 80 00       	mov    0x805154,%eax
  801ef8:	40                   	inc    %eax
  801ef9:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801efe:	ff 45 f4             	incl   -0xc(%ebp)
  801f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f04:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f07:	0f 82 56 ff ff ff    	jb     801e63 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f0d:	90                   	nop
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	8b 00                	mov    (%eax),%eax
  801f1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f1e:	eb 19                	jmp    801f39 <find_block+0x29>
	{
		if(va==point->sva)
  801f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f23:	8b 40 08             	mov    0x8(%eax),%eax
  801f26:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f29:	75 05                	jne    801f30 <find_block+0x20>
		   return point;
  801f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f2e:	eb 36                	jmp    801f66 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	8b 40 08             	mov    0x8(%eax),%eax
  801f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f39:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f3d:	74 07                	je     801f46 <find_block+0x36>
  801f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f42:	8b 00                	mov    (%eax),%eax
  801f44:	eb 05                	jmp    801f4b <find_block+0x3b>
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  801f4e:	89 42 08             	mov    %eax,0x8(%edx)
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	8b 40 08             	mov    0x8(%eax),%eax
  801f57:	85 c0                	test   %eax,%eax
  801f59:	75 c5                	jne    801f20 <find_block+0x10>
  801f5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f5f:	75 bf                	jne    801f20 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f6e:	a1 40 50 80 00       	mov    0x805040,%eax
  801f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f76:	a1 44 50 80 00       	mov    0x805044,%eax
  801f7b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f81:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f84:	74 24                	je     801faa <insert_sorted_allocList+0x42>
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	8b 50 08             	mov    0x8(%eax),%edx
  801f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8f:	8b 40 08             	mov    0x8(%eax),%eax
  801f92:	39 c2                	cmp    %eax,%edx
  801f94:	76 14                	jbe    801faa <insert_sorted_allocList+0x42>
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	8b 50 08             	mov    0x8(%eax),%edx
  801f9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f9f:	8b 40 08             	mov    0x8(%eax),%eax
  801fa2:	39 c2                	cmp    %eax,%edx
  801fa4:	0f 82 60 01 00 00    	jb     80210a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801faa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fae:	75 65                	jne    802015 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fb0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fb4:	75 14                	jne    801fca <insert_sorted_allocList+0x62>
  801fb6:	83 ec 04             	sub    $0x4,%esp
  801fb9:	68 ac 3f 80 00       	push   $0x803fac
  801fbe:	6a 6b                	push   $0x6b
  801fc0:	68 cf 3f 80 00       	push   $0x803fcf
  801fc5:	e8 04 e3 ff ff       	call   8002ce <_panic>
  801fca:	8b 15 40 50 80 00    	mov    0x805040,%edx
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	89 10                	mov    %edx,(%eax)
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	8b 00                	mov    (%eax),%eax
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	74 0d                	je     801feb <insert_sorted_allocList+0x83>
  801fde:	a1 40 50 80 00       	mov    0x805040,%eax
  801fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe6:	89 50 04             	mov    %edx,0x4(%eax)
  801fe9:	eb 08                	jmp    801ff3 <insert_sorted_allocList+0x8b>
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	a3 44 50 80 00       	mov    %eax,0x805044
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	a3 40 50 80 00       	mov    %eax,0x805040
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802005:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80200a:	40                   	inc    %eax
  80200b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802010:	e9 dc 01 00 00       	jmp    8021f1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	8b 50 08             	mov    0x8(%eax),%edx
  80201b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201e:	8b 40 08             	mov    0x8(%eax),%eax
  802021:	39 c2                	cmp    %eax,%edx
  802023:	77 6c                	ja     802091 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802025:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802029:	74 06                	je     802031 <insert_sorted_allocList+0xc9>
  80202b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80202f:	75 14                	jne    802045 <insert_sorted_allocList+0xdd>
  802031:	83 ec 04             	sub    $0x4,%esp
  802034:	68 e8 3f 80 00       	push   $0x803fe8
  802039:	6a 6f                	push   $0x6f
  80203b:	68 cf 3f 80 00       	push   $0x803fcf
  802040:	e8 89 e2 ff ff       	call   8002ce <_panic>
  802045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802048:	8b 50 04             	mov    0x4(%eax),%edx
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	89 50 04             	mov    %edx,0x4(%eax)
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802057:	89 10                	mov    %edx,(%eax)
  802059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205c:	8b 40 04             	mov    0x4(%eax),%eax
  80205f:	85 c0                	test   %eax,%eax
  802061:	74 0d                	je     802070 <insert_sorted_allocList+0x108>
  802063:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802066:	8b 40 04             	mov    0x4(%eax),%eax
  802069:	8b 55 08             	mov    0x8(%ebp),%edx
  80206c:	89 10                	mov    %edx,(%eax)
  80206e:	eb 08                	jmp    802078 <insert_sorted_allocList+0x110>
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	a3 40 50 80 00       	mov    %eax,0x805040
  802078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207b:	8b 55 08             	mov    0x8(%ebp),%edx
  80207e:	89 50 04             	mov    %edx,0x4(%eax)
  802081:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802086:	40                   	inc    %eax
  802087:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80208c:	e9 60 01 00 00       	jmp    8021f1 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	8b 50 08             	mov    0x8(%eax),%edx
  802097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209a:	8b 40 08             	mov    0x8(%eax),%eax
  80209d:	39 c2                	cmp    %eax,%edx
  80209f:	0f 82 4c 01 00 00    	jb     8021f1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020a9:	75 14                	jne    8020bf <insert_sorted_allocList+0x157>
  8020ab:	83 ec 04             	sub    $0x4,%esp
  8020ae:	68 20 40 80 00       	push   $0x804020
  8020b3:	6a 73                	push   $0x73
  8020b5:	68 cf 3f 80 00       	push   $0x803fcf
  8020ba:	e8 0f e2 ff ff       	call   8002ce <_panic>
  8020bf:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	89 50 04             	mov    %edx,0x4(%eax)
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	8b 40 04             	mov    0x4(%eax),%eax
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	74 0c                	je     8020e1 <insert_sorted_allocList+0x179>
  8020d5:	a1 44 50 80 00       	mov    0x805044,%eax
  8020da:	8b 55 08             	mov    0x8(%ebp),%edx
  8020dd:	89 10                	mov    %edx,(%eax)
  8020df:	eb 08                	jmp    8020e9 <insert_sorted_allocList+0x181>
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	a3 40 50 80 00       	mov    %eax,0x805040
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	a3 44 50 80 00       	mov    %eax,0x805044
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020fa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020ff:	40                   	inc    %eax
  802100:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802105:	e9 e7 00 00 00       	jmp    8021f1 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80210a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802110:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802117:	a1 40 50 80 00       	mov    0x805040,%eax
  80211c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80211f:	e9 9d 00 00 00       	jmp    8021c1 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 00                	mov    (%eax),%eax
  802129:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	8b 50 08             	mov    0x8(%eax),%edx
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	8b 40 08             	mov    0x8(%eax),%eax
  802138:	39 c2                	cmp    %eax,%edx
  80213a:	76 7d                	jbe    8021b9 <insert_sorted_allocList+0x251>
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	8b 50 08             	mov    0x8(%eax),%edx
  802142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802145:	8b 40 08             	mov    0x8(%eax),%eax
  802148:	39 c2                	cmp    %eax,%edx
  80214a:	73 6d                	jae    8021b9 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80214c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802150:	74 06                	je     802158 <insert_sorted_allocList+0x1f0>
  802152:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802156:	75 14                	jne    80216c <insert_sorted_allocList+0x204>
  802158:	83 ec 04             	sub    $0x4,%esp
  80215b:	68 44 40 80 00       	push   $0x804044
  802160:	6a 7f                	push   $0x7f
  802162:	68 cf 3f 80 00       	push   $0x803fcf
  802167:	e8 62 e1 ff ff       	call   8002ce <_panic>
  80216c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216f:	8b 10                	mov    (%eax),%edx
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	89 10                	mov    %edx,(%eax)
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	8b 00                	mov    (%eax),%eax
  80217b:	85 c0                	test   %eax,%eax
  80217d:	74 0b                	je     80218a <insert_sorted_allocList+0x222>
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 00                	mov    (%eax),%eax
  802184:	8b 55 08             	mov    0x8(%ebp),%edx
  802187:	89 50 04             	mov    %edx,0x4(%eax)
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 55 08             	mov    0x8(%ebp),%edx
  802190:	89 10                	mov    %edx,(%eax)
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802198:	89 50 04             	mov    %edx,0x4(%eax)
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	8b 00                	mov    (%eax),%eax
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	75 08                	jne    8021ac <insert_sorted_allocList+0x244>
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	a3 44 50 80 00       	mov    %eax,0x805044
  8021ac:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021b1:	40                   	inc    %eax
  8021b2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8021b7:	eb 39                	jmp    8021f2 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021b9:	a1 48 50 80 00       	mov    0x805048,%eax
  8021be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c5:	74 07                	je     8021ce <insert_sorted_allocList+0x266>
  8021c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ca:	8b 00                	mov    (%eax),%eax
  8021cc:	eb 05                	jmp    8021d3 <insert_sorted_allocList+0x26b>
  8021ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d3:	a3 48 50 80 00       	mov    %eax,0x805048
  8021d8:	a1 48 50 80 00       	mov    0x805048,%eax
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	0f 85 3f ff ff ff    	jne    802124 <insert_sorted_allocList+0x1bc>
  8021e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e9:	0f 85 35 ff ff ff    	jne    802124 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021ef:	eb 01                	jmp    8021f2 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021f1:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021f2:	90                   	nop
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021fb:	a1 38 51 80 00       	mov    0x805138,%eax
  802200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802203:	e9 85 01 00 00       	jmp    80238d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220b:	8b 40 0c             	mov    0xc(%eax),%eax
  80220e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802211:	0f 82 6e 01 00 00    	jb     802385 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221a:	8b 40 0c             	mov    0xc(%eax),%eax
  80221d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802220:	0f 85 8a 00 00 00    	jne    8022b0 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802226:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222a:	75 17                	jne    802243 <alloc_block_FF+0x4e>
  80222c:	83 ec 04             	sub    $0x4,%esp
  80222f:	68 78 40 80 00       	push   $0x804078
  802234:	68 93 00 00 00       	push   $0x93
  802239:	68 cf 3f 80 00       	push   $0x803fcf
  80223e:	e8 8b e0 ff ff       	call   8002ce <_panic>
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	8b 00                	mov    (%eax),%eax
  802248:	85 c0                	test   %eax,%eax
  80224a:	74 10                	je     80225c <alloc_block_FF+0x67>
  80224c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224f:	8b 00                	mov    (%eax),%eax
  802251:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802254:	8b 52 04             	mov    0x4(%edx),%edx
  802257:	89 50 04             	mov    %edx,0x4(%eax)
  80225a:	eb 0b                	jmp    802267 <alloc_block_FF+0x72>
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 40 04             	mov    0x4(%eax),%eax
  802262:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226a:	8b 40 04             	mov    0x4(%eax),%eax
  80226d:	85 c0                	test   %eax,%eax
  80226f:	74 0f                	je     802280 <alloc_block_FF+0x8b>
  802271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802274:	8b 40 04             	mov    0x4(%eax),%eax
  802277:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227a:	8b 12                	mov    (%edx),%edx
  80227c:	89 10                	mov    %edx,(%eax)
  80227e:	eb 0a                	jmp    80228a <alloc_block_FF+0x95>
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	a3 38 51 80 00       	mov    %eax,0x805138
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80229d:	a1 44 51 80 00       	mov    0x805144,%eax
  8022a2:	48                   	dec    %eax
  8022a3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	e9 10 01 00 00       	jmp    8023c0 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022b9:	0f 86 c6 00 00 00    	jbe    802385 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8022c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 50 08             	mov    0x8(%eax),%edx
  8022cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d0:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d9:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022e0:	75 17                	jne    8022f9 <alloc_block_FF+0x104>
  8022e2:	83 ec 04             	sub    $0x4,%esp
  8022e5:	68 78 40 80 00       	push   $0x804078
  8022ea:	68 9b 00 00 00       	push   $0x9b
  8022ef:	68 cf 3f 80 00       	push   $0x803fcf
  8022f4:	e8 d5 df ff ff       	call   8002ce <_panic>
  8022f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fc:	8b 00                	mov    (%eax),%eax
  8022fe:	85 c0                	test   %eax,%eax
  802300:	74 10                	je     802312 <alloc_block_FF+0x11d>
  802302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802305:	8b 00                	mov    (%eax),%eax
  802307:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80230a:	8b 52 04             	mov    0x4(%edx),%edx
  80230d:	89 50 04             	mov    %edx,0x4(%eax)
  802310:	eb 0b                	jmp    80231d <alloc_block_FF+0x128>
  802312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802315:	8b 40 04             	mov    0x4(%eax),%eax
  802318:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802320:	8b 40 04             	mov    0x4(%eax),%eax
  802323:	85 c0                	test   %eax,%eax
  802325:	74 0f                	je     802336 <alloc_block_FF+0x141>
  802327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232a:	8b 40 04             	mov    0x4(%eax),%eax
  80232d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802330:	8b 12                	mov    (%edx),%edx
  802332:	89 10                	mov    %edx,(%eax)
  802334:	eb 0a                	jmp    802340 <alloc_block_FF+0x14b>
  802336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802339:	8b 00                	mov    (%eax),%eax
  80233b:	a3 48 51 80 00       	mov    %eax,0x805148
  802340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802353:	a1 54 51 80 00       	mov    0x805154,%eax
  802358:	48                   	dec    %eax
  802359:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	8b 50 08             	mov    0x8(%eax),%edx
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	01 c2                	add    %eax,%edx
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	8b 40 0c             	mov    0xc(%eax),%eax
  802375:	2b 45 08             	sub    0x8(%ebp),%eax
  802378:	89 c2                	mov    %eax,%edx
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802383:	eb 3b                	jmp    8023c0 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802385:	a1 40 51 80 00       	mov    0x805140,%eax
  80238a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802391:	74 07                	je     80239a <alloc_block_FF+0x1a5>
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	8b 00                	mov    (%eax),%eax
  802398:	eb 05                	jmp    80239f <alloc_block_FF+0x1aa>
  80239a:	b8 00 00 00 00       	mov    $0x0,%eax
  80239f:	a3 40 51 80 00       	mov    %eax,0x805140
  8023a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	0f 85 57 fe ff ff    	jne    802208 <alloc_block_FF+0x13>
  8023b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b5:	0f 85 4d fe ff ff    	jne    802208 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8023d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d7:	e9 df 00 00 00       	jmp    8024bb <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e5:	0f 82 c8 00 00 00    	jb     8024b3 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f4:	0f 85 8a 00 00 00    	jne    802484 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fe:	75 17                	jne    802417 <alloc_block_BF+0x55>
  802400:	83 ec 04             	sub    $0x4,%esp
  802403:	68 78 40 80 00       	push   $0x804078
  802408:	68 b7 00 00 00       	push   $0xb7
  80240d:	68 cf 3f 80 00       	push   $0x803fcf
  802412:	e8 b7 de ff ff       	call   8002ce <_panic>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	85 c0                	test   %eax,%eax
  80241e:	74 10                	je     802430 <alloc_block_BF+0x6e>
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 00                	mov    (%eax),%eax
  802425:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802428:	8b 52 04             	mov    0x4(%edx),%edx
  80242b:	89 50 04             	mov    %edx,0x4(%eax)
  80242e:	eb 0b                	jmp    80243b <alloc_block_BF+0x79>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 40 04             	mov    0x4(%eax),%eax
  802436:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 40 04             	mov    0x4(%eax),%eax
  802441:	85 c0                	test   %eax,%eax
  802443:	74 0f                	je     802454 <alloc_block_BF+0x92>
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 40 04             	mov    0x4(%eax),%eax
  80244b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244e:	8b 12                	mov    (%edx),%edx
  802450:	89 10                	mov    %edx,(%eax)
  802452:	eb 0a                	jmp    80245e <alloc_block_BF+0x9c>
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 00                	mov    (%eax),%eax
  802459:	a3 38 51 80 00       	mov    %eax,0x805138
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802471:	a1 44 51 80 00       	mov    0x805144,%eax
  802476:	48                   	dec    %eax
  802477:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	e9 4d 01 00 00       	jmp    8025d1 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 0c             	mov    0xc(%eax),%eax
  80248a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80248d:	76 24                	jbe    8024b3 <alloc_block_BF+0xf1>
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 40 0c             	mov    0xc(%eax),%eax
  802495:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802498:	73 19                	jae    8024b3 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80249a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 40 08             	mov    0x8(%eax),%eax
  8024b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8024b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bf:	74 07                	je     8024c8 <alloc_block_BF+0x106>
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 00                	mov    (%eax),%eax
  8024c6:	eb 05                	jmp    8024cd <alloc_block_BF+0x10b>
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cd:	a3 40 51 80 00       	mov    %eax,0x805140
  8024d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	0f 85 fd fe ff ff    	jne    8023dc <alloc_block_BF+0x1a>
  8024df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e3:	0f 85 f3 fe ff ff    	jne    8023dc <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8024e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024ed:	0f 84 d9 00 00 00    	je     8025cc <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024f3:	a1 48 51 80 00       	mov    0x805148,%eax
  8024f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802501:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802504:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802507:	8b 55 08             	mov    0x8(%ebp),%edx
  80250a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80250d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802511:	75 17                	jne    80252a <alloc_block_BF+0x168>
  802513:	83 ec 04             	sub    $0x4,%esp
  802516:	68 78 40 80 00       	push   $0x804078
  80251b:	68 c7 00 00 00       	push   $0xc7
  802520:	68 cf 3f 80 00       	push   $0x803fcf
  802525:	e8 a4 dd ff ff       	call   8002ce <_panic>
  80252a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252d:	8b 00                	mov    (%eax),%eax
  80252f:	85 c0                	test   %eax,%eax
  802531:	74 10                	je     802543 <alloc_block_BF+0x181>
  802533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802536:	8b 00                	mov    (%eax),%eax
  802538:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80253b:	8b 52 04             	mov    0x4(%edx),%edx
  80253e:	89 50 04             	mov    %edx,0x4(%eax)
  802541:	eb 0b                	jmp    80254e <alloc_block_BF+0x18c>
  802543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802546:	8b 40 04             	mov    0x4(%eax),%eax
  802549:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80254e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802551:	8b 40 04             	mov    0x4(%eax),%eax
  802554:	85 c0                	test   %eax,%eax
  802556:	74 0f                	je     802567 <alloc_block_BF+0x1a5>
  802558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255b:	8b 40 04             	mov    0x4(%eax),%eax
  80255e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802561:	8b 12                	mov    (%edx),%edx
  802563:	89 10                	mov    %edx,(%eax)
  802565:	eb 0a                	jmp    802571 <alloc_block_BF+0x1af>
  802567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256a:	8b 00                	mov    (%eax),%eax
  80256c:	a3 48 51 80 00       	mov    %eax,0x805148
  802571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802574:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80257a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802584:	a1 54 51 80 00       	mov    0x805154,%eax
  802589:	48                   	dec    %eax
  80258a:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80258f:	83 ec 08             	sub    $0x8,%esp
  802592:	ff 75 ec             	pushl  -0x14(%ebp)
  802595:	68 38 51 80 00       	push   $0x805138
  80259a:	e8 71 f9 ff ff       	call   801f10 <find_block>
  80259f:	83 c4 10             	add    $0x10,%esp
  8025a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a8:	8b 50 08             	mov    0x8(%eax),%edx
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	01 c2                	add    %eax,%edx
  8025b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b3:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8025bf:	89 c2                	mov    %eax,%edx
  8025c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c4:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ca:	eb 05                	jmp    8025d1 <alloc_block_BF+0x20f>
	}
	return NULL;
  8025cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d1:	c9                   	leave  
  8025d2:	c3                   	ret    

008025d3 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025d3:	55                   	push   %ebp
  8025d4:	89 e5                	mov    %esp,%ebp
  8025d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025d9:	a1 28 50 80 00       	mov    0x805028,%eax
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	0f 85 de 01 00 00    	jne    8027c4 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8025eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ee:	e9 9e 01 00 00       	jmp    802791 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025fc:	0f 82 87 01 00 00    	jb     802789 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 40 0c             	mov    0xc(%eax),%eax
  802608:	3b 45 08             	cmp    0x8(%ebp),%eax
  80260b:	0f 85 95 00 00 00    	jne    8026a6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802615:	75 17                	jne    80262e <alloc_block_NF+0x5b>
  802617:	83 ec 04             	sub    $0x4,%esp
  80261a:	68 78 40 80 00       	push   $0x804078
  80261f:	68 e0 00 00 00       	push   $0xe0
  802624:	68 cf 3f 80 00       	push   $0x803fcf
  802629:	e8 a0 dc ff ff       	call   8002ce <_panic>
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	85 c0                	test   %eax,%eax
  802635:	74 10                	je     802647 <alloc_block_NF+0x74>
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263f:	8b 52 04             	mov    0x4(%edx),%edx
  802642:	89 50 04             	mov    %edx,0x4(%eax)
  802645:	eb 0b                	jmp    802652 <alloc_block_NF+0x7f>
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 40 04             	mov    0x4(%eax),%eax
  80264d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 40 04             	mov    0x4(%eax),%eax
  802658:	85 c0                	test   %eax,%eax
  80265a:	74 0f                	je     80266b <alloc_block_NF+0x98>
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 40 04             	mov    0x4(%eax),%eax
  802662:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802665:	8b 12                	mov    (%edx),%edx
  802667:	89 10                	mov    %edx,(%eax)
  802669:	eb 0a                	jmp    802675 <alloc_block_NF+0xa2>
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 00                	mov    (%eax),%eax
  802670:	a3 38 51 80 00       	mov    %eax,0x805138
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802688:	a1 44 51 80 00       	mov    0x805144,%eax
  80268d:	48                   	dec    %eax
  80268e:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 40 08             	mov    0x8(%eax),%eax
  802699:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	e9 f8 04 00 00       	jmp    802b9e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026af:	0f 86 d4 00 00 00    	jbe    802789 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8026ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 50 08             	mov    0x8(%eax),%edx
  8026c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c6:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cf:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026d6:	75 17                	jne    8026ef <alloc_block_NF+0x11c>
  8026d8:	83 ec 04             	sub    $0x4,%esp
  8026db:	68 78 40 80 00       	push   $0x804078
  8026e0:	68 e9 00 00 00       	push   $0xe9
  8026e5:	68 cf 3f 80 00       	push   $0x803fcf
  8026ea:	e8 df db ff ff       	call   8002ce <_panic>
  8026ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f2:	8b 00                	mov    (%eax),%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	74 10                	je     802708 <alloc_block_NF+0x135>
  8026f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fb:	8b 00                	mov    (%eax),%eax
  8026fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802700:	8b 52 04             	mov    0x4(%edx),%edx
  802703:	89 50 04             	mov    %edx,0x4(%eax)
  802706:	eb 0b                	jmp    802713 <alloc_block_NF+0x140>
  802708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270b:	8b 40 04             	mov    0x4(%eax),%eax
  80270e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802716:	8b 40 04             	mov    0x4(%eax),%eax
  802719:	85 c0                	test   %eax,%eax
  80271b:	74 0f                	je     80272c <alloc_block_NF+0x159>
  80271d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802720:	8b 40 04             	mov    0x4(%eax),%eax
  802723:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802726:	8b 12                	mov    (%edx),%edx
  802728:	89 10                	mov    %edx,(%eax)
  80272a:	eb 0a                	jmp    802736 <alloc_block_NF+0x163>
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	8b 00                	mov    (%eax),%eax
  802731:	a3 48 51 80 00       	mov    %eax,0x805148
  802736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802739:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802749:	a1 54 51 80 00       	mov    0x805154,%eax
  80274e:	48                   	dec    %eax
  80274f:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802757:	8b 40 08             	mov    0x8(%eax),%eax
  80275a:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 50 08             	mov    0x8(%eax),%edx
  802765:	8b 45 08             	mov    0x8(%ebp),%eax
  802768:	01 c2                	add    %eax,%edx
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 40 0c             	mov    0xc(%eax),%eax
  802776:	2b 45 08             	sub    0x8(%ebp),%eax
  802779:	89 c2                	mov    %eax,%edx
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802781:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802784:	e9 15 04 00 00       	jmp    802b9e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802789:	a1 40 51 80 00       	mov    0x805140,%eax
  80278e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802795:	74 07                	je     80279e <alloc_block_NF+0x1cb>
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	eb 05                	jmp    8027a3 <alloc_block_NF+0x1d0>
  80279e:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a3:	a3 40 51 80 00       	mov    %eax,0x805140
  8027a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	0f 85 3e fe ff ff    	jne    8025f3 <alloc_block_NF+0x20>
  8027b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b9:	0f 85 34 fe ff ff    	jne    8025f3 <alloc_block_NF+0x20>
  8027bf:	e9 d5 03 00 00       	jmp    802b99 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027c4:	a1 38 51 80 00       	mov    0x805138,%eax
  8027c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027cc:	e9 b1 01 00 00       	jmp    802982 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 50 08             	mov    0x8(%eax),%edx
  8027d7:	a1 28 50 80 00       	mov    0x805028,%eax
  8027dc:	39 c2                	cmp    %eax,%edx
  8027de:	0f 82 96 01 00 00    	jb     80297a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ed:	0f 82 87 01 00 00    	jb     80297a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027fc:	0f 85 95 00 00 00    	jne    802897 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802806:	75 17                	jne    80281f <alloc_block_NF+0x24c>
  802808:	83 ec 04             	sub    $0x4,%esp
  80280b:	68 78 40 80 00       	push   $0x804078
  802810:	68 fc 00 00 00       	push   $0xfc
  802815:	68 cf 3f 80 00       	push   $0x803fcf
  80281a:	e8 af da ff ff       	call   8002ce <_panic>
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	85 c0                	test   %eax,%eax
  802826:	74 10                	je     802838 <alloc_block_NF+0x265>
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 00                	mov    (%eax),%eax
  80282d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802830:	8b 52 04             	mov    0x4(%edx),%edx
  802833:	89 50 04             	mov    %edx,0x4(%eax)
  802836:	eb 0b                	jmp    802843 <alloc_block_NF+0x270>
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 40 04             	mov    0x4(%eax),%eax
  80283e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	74 0f                	je     80285c <alloc_block_NF+0x289>
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	8b 40 04             	mov    0x4(%eax),%eax
  802853:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802856:	8b 12                	mov    (%edx),%edx
  802858:	89 10                	mov    %edx,(%eax)
  80285a:	eb 0a                	jmp    802866 <alloc_block_NF+0x293>
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 00                	mov    (%eax),%eax
  802861:	a3 38 51 80 00       	mov    %eax,0x805138
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802879:	a1 44 51 80 00       	mov    0x805144,%eax
  80287e:	48                   	dec    %eax
  80287f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8b 40 08             	mov    0x8(%eax),%eax
  80288a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	e9 07 03 00 00       	jmp    802b9e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	8b 40 0c             	mov    0xc(%eax),%eax
  80289d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a0:	0f 86 d4 00 00 00    	jbe    80297a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8028ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 50 08             	mov    0x8(%eax),%edx
  8028b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028c3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028c7:	75 17                	jne    8028e0 <alloc_block_NF+0x30d>
  8028c9:	83 ec 04             	sub    $0x4,%esp
  8028cc:	68 78 40 80 00       	push   $0x804078
  8028d1:	68 04 01 00 00       	push   $0x104
  8028d6:	68 cf 3f 80 00       	push   $0x803fcf
  8028db:	e8 ee d9 ff ff       	call   8002ce <_panic>
  8028e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	85 c0                	test   %eax,%eax
  8028e7:	74 10                	je     8028f9 <alloc_block_NF+0x326>
  8028e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ec:	8b 00                	mov    (%eax),%eax
  8028ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028f1:	8b 52 04             	mov    0x4(%edx),%edx
  8028f4:	89 50 04             	mov    %edx,0x4(%eax)
  8028f7:	eb 0b                	jmp    802904 <alloc_block_NF+0x331>
  8028f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fc:	8b 40 04             	mov    0x4(%eax),%eax
  8028ff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	85 c0                	test   %eax,%eax
  80290c:	74 0f                	je     80291d <alloc_block_NF+0x34a>
  80290e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802911:	8b 40 04             	mov    0x4(%eax),%eax
  802914:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802917:	8b 12                	mov    (%edx),%edx
  802919:	89 10                	mov    %edx,(%eax)
  80291b:	eb 0a                	jmp    802927 <alloc_block_NF+0x354>
  80291d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802920:	8b 00                	mov    (%eax),%eax
  802922:	a3 48 51 80 00       	mov    %eax,0x805148
  802927:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802930:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802933:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293a:	a1 54 51 80 00       	mov    0x805154,%eax
  80293f:	48                   	dec    %eax
  802940:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802945:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802948:	8b 40 08             	mov    0x8(%eax),%eax
  80294b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 50 08             	mov    0x8(%eax),%edx
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	01 c2                	add    %eax,%edx
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	8b 40 0c             	mov    0xc(%eax),%eax
  802967:	2b 45 08             	sub    0x8(%ebp),%eax
  80296a:	89 c2                	mov    %eax,%edx
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802972:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802975:	e9 24 02 00 00       	jmp    802b9e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80297a:	a1 40 51 80 00       	mov    0x805140,%eax
  80297f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802982:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802986:	74 07                	je     80298f <alloc_block_NF+0x3bc>
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	eb 05                	jmp    802994 <alloc_block_NF+0x3c1>
  80298f:	b8 00 00 00 00       	mov    $0x0,%eax
  802994:	a3 40 51 80 00       	mov    %eax,0x805140
  802999:	a1 40 51 80 00       	mov    0x805140,%eax
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	0f 85 2b fe ff ff    	jne    8027d1 <alloc_block_NF+0x1fe>
  8029a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029aa:	0f 85 21 fe ff ff    	jne    8027d1 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029b0:	a1 38 51 80 00       	mov    0x805138,%eax
  8029b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b8:	e9 ae 01 00 00       	jmp    802b6b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c0:	8b 50 08             	mov    0x8(%eax),%edx
  8029c3:	a1 28 50 80 00       	mov    0x805028,%eax
  8029c8:	39 c2                	cmp    %eax,%edx
  8029ca:	0f 83 93 01 00 00    	jae    802b63 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d9:	0f 82 84 01 00 00    	jb     802b63 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e8:	0f 85 95 00 00 00    	jne    802a83 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f2:	75 17                	jne    802a0b <alloc_block_NF+0x438>
  8029f4:	83 ec 04             	sub    $0x4,%esp
  8029f7:	68 78 40 80 00       	push   $0x804078
  8029fc:	68 14 01 00 00       	push   $0x114
  802a01:	68 cf 3f 80 00       	push   $0x803fcf
  802a06:	e8 c3 d8 ff ff       	call   8002ce <_panic>
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	74 10                	je     802a24 <alloc_block_NF+0x451>
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1c:	8b 52 04             	mov    0x4(%edx),%edx
  802a1f:	89 50 04             	mov    %edx,0x4(%eax)
  802a22:	eb 0b                	jmp    802a2f <alloc_block_NF+0x45c>
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 40 04             	mov    0x4(%eax),%eax
  802a2a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 40 04             	mov    0x4(%eax),%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	74 0f                	je     802a48 <alloc_block_NF+0x475>
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 40 04             	mov    0x4(%eax),%eax
  802a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a42:	8b 12                	mov    (%edx),%edx
  802a44:	89 10                	mov    %edx,(%eax)
  802a46:	eb 0a                	jmp    802a52 <alloc_block_NF+0x47f>
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
  802a7e:	e9 1b 01 00 00       	jmp    802b9e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 40 0c             	mov    0xc(%eax),%eax
  802a89:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a8c:	0f 86 d1 00 00 00    	jbe    802b63 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a92:	a1 48 51 80 00       	mov    0x805148,%eax
  802a97:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 50 08             	mov    0x8(%eax),%edx
  802aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa9:	8b 55 08             	mov    0x8(%ebp),%edx
  802aac:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aaf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ab3:	75 17                	jne    802acc <alloc_block_NF+0x4f9>
  802ab5:	83 ec 04             	sub    $0x4,%esp
  802ab8:	68 78 40 80 00       	push   $0x804078
  802abd:	68 1c 01 00 00       	push   $0x11c
  802ac2:	68 cf 3f 80 00       	push   $0x803fcf
  802ac7:	e8 02 d8 ff ff       	call   8002ce <_panic>
  802acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	74 10                	je     802ae5 <alloc_block_NF+0x512>
  802ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad8:	8b 00                	mov    (%eax),%eax
  802ada:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802add:	8b 52 04             	mov    0x4(%edx),%edx
  802ae0:	89 50 04             	mov    %edx,0x4(%eax)
  802ae3:	eb 0b                	jmp    802af0 <alloc_block_NF+0x51d>
  802ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae8:	8b 40 04             	mov    0x4(%eax),%eax
  802aeb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af3:	8b 40 04             	mov    0x4(%eax),%eax
  802af6:	85 c0                	test   %eax,%eax
  802af8:	74 0f                	je     802b09 <alloc_block_NF+0x536>
  802afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afd:	8b 40 04             	mov    0x4(%eax),%eax
  802b00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b03:	8b 12                	mov    (%edx),%edx
  802b05:	89 10                	mov    %edx,(%eax)
  802b07:	eb 0a                	jmp    802b13 <alloc_block_NF+0x540>
  802b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0c:	8b 00                	mov    (%eax),%eax
  802b0e:	a3 48 51 80 00       	mov    %eax,0x805148
  802b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b26:	a1 54 51 80 00       	mov    0x805154,%eax
  802b2b:	48                   	dec    %eax
  802b2c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
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
  802b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b61:	eb 3b                	jmp    802b9e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b63:	a1 40 51 80 00       	mov    0x805140,%eax
  802b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6f:	74 07                	je     802b78 <alloc_block_NF+0x5a5>
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	eb 05                	jmp    802b7d <alloc_block_NF+0x5aa>
  802b78:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7d:	a3 40 51 80 00       	mov    %eax,0x805140
  802b82:	a1 40 51 80 00       	mov    0x805140,%eax
  802b87:	85 c0                	test   %eax,%eax
  802b89:	0f 85 2e fe ff ff    	jne    8029bd <alloc_block_NF+0x3ea>
  802b8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b93:	0f 85 24 fe ff ff    	jne    8029bd <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b9e:	c9                   	leave  
  802b9f:	c3                   	ret    

00802ba0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ba0:	55                   	push   %ebp
  802ba1:	89 e5                	mov    %esp,%ebp
  802ba3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ba6:	a1 38 51 80 00       	mov    0x805138,%eax
  802bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bae:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bb3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bb6:	a1 38 51 80 00       	mov    0x805138,%eax
  802bbb:	85 c0                	test   %eax,%eax
  802bbd:	74 14                	je     802bd3 <insert_sorted_with_merge_freeList+0x33>
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	8b 50 08             	mov    0x8(%eax),%edx
  802bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc8:	8b 40 08             	mov    0x8(%eax),%eax
  802bcb:	39 c2                	cmp    %eax,%edx
  802bcd:	0f 87 9b 01 00 00    	ja     802d6e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd7:	75 17                	jne    802bf0 <insert_sorted_with_merge_freeList+0x50>
  802bd9:	83 ec 04             	sub    $0x4,%esp
  802bdc:	68 ac 3f 80 00       	push   $0x803fac
  802be1:	68 38 01 00 00       	push   $0x138
  802be6:	68 cf 3f 80 00       	push   $0x803fcf
  802beb:	e8 de d6 ff ff       	call   8002ce <_panic>
  802bf0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	89 10                	mov    %edx,(%eax)
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	74 0d                	je     802c11 <insert_sorted_with_merge_freeList+0x71>
  802c04:	a1 38 51 80 00       	mov    0x805138,%eax
  802c09:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0c:	89 50 04             	mov    %edx,0x4(%eax)
  802c0f:	eb 08                	jmp    802c19 <insert_sorted_with_merge_freeList+0x79>
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c19:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1c:	a3 38 51 80 00       	mov    %eax,0x805138
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c30:	40                   	inc    %eax
  802c31:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c3a:	0f 84 a8 06 00 00    	je     8032e8 <insert_sorted_with_merge_freeList+0x748>
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	8b 50 08             	mov    0x8(%eax),%edx
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4c:	01 c2                	add    %eax,%edx
  802c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c51:	8b 40 08             	mov    0x8(%eax),%eax
  802c54:	39 c2                	cmp    %eax,%edx
  802c56:	0f 85 8c 06 00 00    	jne    8032e8 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c65:	8b 40 0c             	mov    0xc(%eax),%eax
  802c68:	01 c2                	add    %eax,%edx
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c74:	75 17                	jne    802c8d <insert_sorted_with_merge_freeList+0xed>
  802c76:	83 ec 04             	sub    $0x4,%esp
  802c79:	68 78 40 80 00       	push   $0x804078
  802c7e:	68 3c 01 00 00       	push   $0x13c
  802c83:	68 cf 3f 80 00       	push   $0x803fcf
  802c88:	e8 41 d6 ff ff       	call   8002ce <_panic>
  802c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	74 10                	je     802ca6 <insert_sorted_with_merge_freeList+0x106>
  802c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c99:	8b 00                	mov    (%eax),%eax
  802c9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c9e:	8b 52 04             	mov    0x4(%edx),%edx
  802ca1:	89 50 04             	mov    %edx,0x4(%eax)
  802ca4:	eb 0b                	jmp    802cb1 <insert_sorted_with_merge_freeList+0x111>
  802ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca9:	8b 40 04             	mov    0x4(%eax),%eax
  802cac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	74 0f                	je     802cca <insert_sorted_with_merge_freeList+0x12a>
  802cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbe:	8b 40 04             	mov    0x4(%eax),%eax
  802cc1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc4:	8b 12                	mov    (%edx),%edx
  802cc6:	89 10                	mov    %edx,(%eax)
  802cc8:	eb 0a                	jmp    802cd4 <insert_sorted_with_merge_freeList+0x134>
  802cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	a3 38 51 80 00       	mov    %eax,0x805138
  802cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce7:	a1 44 51 80 00       	mov    0x805144,%eax
  802cec:	48                   	dec    %eax
  802ced:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0a:	75 17                	jne    802d23 <insert_sorted_with_merge_freeList+0x183>
  802d0c:	83 ec 04             	sub    $0x4,%esp
  802d0f:	68 ac 3f 80 00       	push   $0x803fac
  802d14:	68 3f 01 00 00       	push   $0x13f
  802d19:	68 cf 3f 80 00       	push   $0x803fcf
  802d1e:	e8 ab d5 ff ff       	call   8002ce <_panic>
  802d23:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2c:	89 10                	mov    %edx,(%eax)
  802d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 0d                	je     802d44 <insert_sorted_with_merge_freeList+0x1a4>
  802d37:	a1 48 51 80 00       	mov    0x805148,%eax
  802d3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3f:	89 50 04             	mov    %edx,0x4(%eax)
  802d42:	eb 08                	jmp    802d4c <insert_sorted_with_merge_freeList+0x1ac>
  802d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d47:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4f:	a3 48 51 80 00       	mov    %eax,0x805148
  802d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5e:	a1 54 51 80 00       	mov    0x805154,%eax
  802d63:	40                   	inc    %eax
  802d64:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d69:	e9 7a 05 00 00       	jmp    8032e8 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	8b 50 08             	mov    0x8(%eax),%edx
  802d74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d77:	8b 40 08             	mov    0x8(%eax),%eax
  802d7a:	39 c2                	cmp    %eax,%edx
  802d7c:	0f 82 14 01 00 00    	jb     802e96 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d85:	8b 50 08             	mov    0x8(%eax),%edx
  802d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8e:	01 c2                	add    %eax,%edx
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	8b 40 08             	mov    0x8(%eax),%eax
  802d96:	39 c2                	cmp    %eax,%edx
  802d98:	0f 85 90 00 00 00    	jne    802e2e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da1:	8b 50 0c             	mov    0xc(%eax),%edx
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	8b 40 0c             	mov    0xc(%eax),%eax
  802daa:	01 c2                	add    %eax,%edx
  802dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802daf:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dca:	75 17                	jne    802de3 <insert_sorted_with_merge_freeList+0x243>
  802dcc:	83 ec 04             	sub    $0x4,%esp
  802dcf:	68 ac 3f 80 00       	push   $0x803fac
  802dd4:	68 49 01 00 00       	push   $0x149
  802dd9:	68 cf 3f 80 00       	push   $0x803fcf
  802dde:	e8 eb d4 ff ff       	call   8002ce <_panic>
  802de3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	89 10                	mov    %edx,(%eax)
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	8b 00                	mov    (%eax),%eax
  802df3:	85 c0                	test   %eax,%eax
  802df5:	74 0d                	je     802e04 <insert_sorted_with_merge_freeList+0x264>
  802df7:	a1 48 51 80 00       	mov    0x805148,%eax
  802dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  802dff:	89 50 04             	mov    %edx,0x4(%eax)
  802e02:	eb 08                	jmp    802e0c <insert_sorted_with_merge_freeList+0x26c>
  802e04:	8b 45 08             	mov    0x8(%ebp),%eax
  802e07:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	a3 48 51 80 00       	mov    %eax,0x805148
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1e:	a1 54 51 80 00       	mov    0x805154,%eax
  802e23:	40                   	inc    %eax
  802e24:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e29:	e9 bb 04 00 00       	jmp    8032e9 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e32:	75 17                	jne    802e4b <insert_sorted_with_merge_freeList+0x2ab>
  802e34:	83 ec 04             	sub    $0x4,%esp
  802e37:	68 20 40 80 00       	push   $0x804020
  802e3c:	68 4c 01 00 00       	push   $0x14c
  802e41:	68 cf 3f 80 00       	push   $0x803fcf
  802e46:	e8 83 d4 ff ff       	call   8002ce <_panic>
  802e4b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	89 50 04             	mov    %edx,0x4(%eax)
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 0c                	je     802e6d <insert_sorted_with_merge_freeList+0x2cd>
  802e61:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e66:	8b 55 08             	mov    0x8(%ebp),%edx
  802e69:	89 10                	mov    %edx,(%eax)
  802e6b:	eb 08                	jmp    802e75 <insert_sorted_with_merge_freeList+0x2d5>
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	a3 38 51 80 00       	mov    %eax,0x805138
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e86:	a1 44 51 80 00       	mov    0x805144,%eax
  802e8b:	40                   	inc    %eax
  802e8c:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e91:	e9 53 04 00 00       	jmp    8032e9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e96:	a1 38 51 80 00       	mov    0x805138,%eax
  802e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e9e:	e9 15 04 00 00       	jmp    8032b8 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	8b 50 08             	mov    0x8(%eax),%edx
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	8b 40 08             	mov    0x8(%eax),%eax
  802eb7:	39 c2                	cmp    %eax,%edx
  802eb9:	0f 86 f1 03 00 00    	jbe    8032b0 <insert_sorted_with_merge_freeList+0x710>
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	8b 50 08             	mov    0x8(%eax),%edx
  802ec5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec8:	8b 40 08             	mov    0x8(%eax),%eax
  802ecb:	39 c2                	cmp    %eax,%edx
  802ecd:	0f 83 dd 03 00 00    	jae    8032b0 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 50 08             	mov    0x8(%eax),%edx
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 40 0c             	mov    0xc(%eax),%eax
  802edf:	01 c2                	add    %eax,%edx
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	8b 40 08             	mov    0x8(%eax),%eax
  802ee7:	39 c2                	cmp    %eax,%edx
  802ee9:	0f 85 b9 01 00 00    	jne    8030a8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	8b 50 08             	mov    0x8(%eax),%edx
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  802efb:	01 c2                	add    %eax,%edx
  802efd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f00:	8b 40 08             	mov    0x8(%eax),%eax
  802f03:	39 c2                	cmp    %eax,%edx
  802f05:	0f 85 0d 01 00 00    	jne    803018 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f14:	8b 40 0c             	mov    0xc(%eax),%eax
  802f17:	01 c2                	add    %eax,%edx
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f23:	75 17                	jne    802f3c <insert_sorted_with_merge_freeList+0x39c>
  802f25:	83 ec 04             	sub    $0x4,%esp
  802f28:	68 78 40 80 00       	push   $0x804078
  802f2d:	68 5c 01 00 00       	push   $0x15c
  802f32:	68 cf 3f 80 00       	push   $0x803fcf
  802f37:	e8 92 d3 ff ff       	call   8002ce <_panic>
  802f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3f:	8b 00                	mov    (%eax),%eax
  802f41:	85 c0                	test   %eax,%eax
  802f43:	74 10                	je     802f55 <insert_sorted_with_merge_freeList+0x3b5>
  802f45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f4d:	8b 52 04             	mov    0x4(%edx),%edx
  802f50:	89 50 04             	mov    %edx,0x4(%eax)
  802f53:	eb 0b                	jmp    802f60 <insert_sorted_with_merge_freeList+0x3c0>
  802f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f58:	8b 40 04             	mov    0x4(%eax),%eax
  802f5b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f63:	8b 40 04             	mov    0x4(%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 0f                	je     802f79 <insert_sorted_with_merge_freeList+0x3d9>
  802f6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6d:	8b 40 04             	mov    0x4(%eax),%eax
  802f70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f73:	8b 12                	mov    (%edx),%edx
  802f75:	89 10                	mov    %edx,(%eax)
  802f77:	eb 0a                	jmp    802f83 <insert_sorted_with_merge_freeList+0x3e3>
  802f79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	a3 38 51 80 00       	mov    %eax,0x805138
  802f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f96:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9b:	48                   	dec    %eax
  802f9c:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802fa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fb5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fb9:	75 17                	jne    802fd2 <insert_sorted_with_merge_freeList+0x432>
  802fbb:	83 ec 04             	sub    $0x4,%esp
  802fbe:	68 ac 3f 80 00       	push   $0x803fac
  802fc3:	68 5f 01 00 00       	push   $0x15f
  802fc8:	68 cf 3f 80 00       	push   $0x803fcf
  802fcd:	e8 fc d2 ff ff       	call   8002ce <_panic>
  802fd2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdb:	89 10                	mov    %edx,(%eax)
  802fdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe0:	8b 00                	mov    (%eax),%eax
  802fe2:	85 c0                	test   %eax,%eax
  802fe4:	74 0d                	je     802ff3 <insert_sorted_with_merge_freeList+0x453>
  802fe6:	a1 48 51 80 00       	mov    0x805148,%eax
  802feb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fee:	89 50 04             	mov    %edx,0x4(%eax)
  802ff1:	eb 08                	jmp    802ffb <insert_sorted_with_merge_freeList+0x45b>
  802ff3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ffb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffe:	a3 48 51 80 00       	mov    %eax,0x805148
  803003:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803006:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300d:	a1 54 51 80 00       	mov    0x805154,%eax
  803012:	40                   	inc    %eax
  803013:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301b:	8b 50 0c             	mov    0xc(%eax),%edx
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	8b 40 0c             	mov    0xc(%eax),%eax
  803024:	01 c2                	add    %eax,%edx
  803026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803029:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803040:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803044:	75 17                	jne    80305d <insert_sorted_with_merge_freeList+0x4bd>
  803046:	83 ec 04             	sub    $0x4,%esp
  803049:	68 ac 3f 80 00       	push   $0x803fac
  80304e:	68 64 01 00 00       	push   $0x164
  803053:	68 cf 3f 80 00       	push   $0x803fcf
  803058:	e8 71 d2 ff ff       	call   8002ce <_panic>
  80305d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803063:	8b 45 08             	mov    0x8(%ebp),%eax
  803066:	89 10                	mov    %edx,(%eax)
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	8b 00                	mov    (%eax),%eax
  80306d:	85 c0                	test   %eax,%eax
  80306f:	74 0d                	je     80307e <insert_sorted_with_merge_freeList+0x4de>
  803071:	a1 48 51 80 00       	mov    0x805148,%eax
  803076:	8b 55 08             	mov    0x8(%ebp),%edx
  803079:	89 50 04             	mov    %edx,0x4(%eax)
  80307c:	eb 08                	jmp    803086 <insert_sorted_with_merge_freeList+0x4e6>
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	a3 48 51 80 00       	mov    %eax,0x805148
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803098:	a1 54 51 80 00       	mov    0x805154,%eax
  80309d:	40                   	inc    %eax
  80309e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8030a3:	e9 41 02 00 00       	jmp    8032e9 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	8b 50 08             	mov    0x8(%eax),%edx
  8030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b4:	01 c2                	add    %eax,%edx
  8030b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b9:	8b 40 08             	mov    0x8(%eax),%eax
  8030bc:	39 c2                	cmp    %eax,%edx
  8030be:	0f 85 7c 01 00 00    	jne    803240 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030c8:	74 06                	je     8030d0 <insert_sorted_with_merge_freeList+0x530>
  8030ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ce:	75 17                	jne    8030e7 <insert_sorted_with_merge_freeList+0x547>
  8030d0:	83 ec 04             	sub    $0x4,%esp
  8030d3:	68 e8 3f 80 00       	push   $0x803fe8
  8030d8:	68 69 01 00 00       	push   $0x169
  8030dd:	68 cf 3f 80 00       	push   $0x803fcf
  8030e2:	e8 e7 d1 ff ff       	call   8002ce <_panic>
  8030e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ea:	8b 50 04             	mov    0x4(%eax),%edx
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	89 50 04             	mov    %edx,0x4(%eax)
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030f9:	89 10                	mov    %edx,(%eax)
  8030fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fe:	8b 40 04             	mov    0x4(%eax),%eax
  803101:	85 c0                	test   %eax,%eax
  803103:	74 0d                	je     803112 <insert_sorted_with_merge_freeList+0x572>
  803105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803108:	8b 40 04             	mov    0x4(%eax),%eax
  80310b:	8b 55 08             	mov    0x8(%ebp),%edx
  80310e:	89 10                	mov    %edx,(%eax)
  803110:	eb 08                	jmp    80311a <insert_sorted_with_merge_freeList+0x57a>
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	a3 38 51 80 00       	mov    %eax,0x805138
  80311a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311d:	8b 55 08             	mov    0x8(%ebp),%edx
  803120:	89 50 04             	mov    %edx,0x4(%eax)
  803123:	a1 44 51 80 00       	mov    0x805144,%eax
  803128:	40                   	inc    %eax
  803129:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	8b 50 0c             	mov    0xc(%eax),%edx
  803134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803137:	8b 40 0c             	mov    0xc(%eax),%eax
  80313a:	01 c2                	add    %eax,%edx
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803142:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803146:	75 17                	jne    80315f <insert_sorted_with_merge_freeList+0x5bf>
  803148:	83 ec 04             	sub    $0x4,%esp
  80314b:	68 78 40 80 00       	push   $0x804078
  803150:	68 6b 01 00 00       	push   $0x16b
  803155:	68 cf 3f 80 00       	push   $0x803fcf
  80315a:	e8 6f d1 ff ff       	call   8002ce <_panic>
  80315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803162:	8b 00                	mov    (%eax),%eax
  803164:	85 c0                	test   %eax,%eax
  803166:	74 10                	je     803178 <insert_sorted_with_merge_freeList+0x5d8>
  803168:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316b:	8b 00                	mov    (%eax),%eax
  80316d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803170:	8b 52 04             	mov    0x4(%edx),%edx
  803173:	89 50 04             	mov    %edx,0x4(%eax)
  803176:	eb 0b                	jmp    803183 <insert_sorted_with_merge_freeList+0x5e3>
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	8b 40 04             	mov    0x4(%eax),%eax
  80317e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	8b 40 04             	mov    0x4(%eax),%eax
  803189:	85 c0                	test   %eax,%eax
  80318b:	74 0f                	je     80319c <insert_sorted_with_merge_freeList+0x5fc>
  80318d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803190:	8b 40 04             	mov    0x4(%eax),%eax
  803193:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803196:	8b 12                	mov    (%edx),%edx
  803198:	89 10                	mov    %edx,(%eax)
  80319a:	eb 0a                	jmp    8031a6 <insert_sorted_with_merge_freeList+0x606>
  80319c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319f:	8b 00                	mov    (%eax),%eax
  8031a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8031be:	48                   	dec    %eax
  8031bf:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031dc:	75 17                	jne    8031f5 <insert_sorted_with_merge_freeList+0x655>
  8031de:	83 ec 04             	sub    $0x4,%esp
  8031e1:	68 ac 3f 80 00       	push   $0x803fac
  8031e6:	68 6e 01 00 00       	push   $0x16e
  8031eb:	68 cf 3f 80 00       	push   $0x803fcf
  8031f0:	e8 d9 d0 ff ff       	call   8002ce <_panic>
  8031f5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fe:	89 10                	mov    %edx,(%eax)
  803200:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803203:	8b 00                	mov    (%eax),%eax
  803205:	85 c0                	test   %eax,%eax
  803207:	74 0d                	je     803216 <insert_sorted_with_merge_freeList+0x676>
  803209:	a1 48 51 80 00       	mov    0x805148,%eax
  80320e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803211:	89 50 04             	mov    %edx,0x4(%eax)
  803214:	eb 08                	jmp    80321e <insert_sorted_with_merge_freeList+0x67e>
  803216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803219:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80321e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803221:	a3 48 51 80 00       	mov    %eax,0x805148
  803226:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803229:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803230:	a1 54 51 80 00       	mov    0x805154,%eax
  803235:	40                   	inc    %eax
  803236:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80323b:	e9 a9 00 00 00       	jmp    8032e9 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803240:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803244:	74 06                	je     80324c <insert_sorted_with_merge_freeList+0x6ac>
  803246:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80324a:	75 17                	jne    803263 <insert_sorted_with_merge_freeList+0x6c3>
  80324c:	83 ec 04             	sub    $0x4,%esp
  80324f:	68 44 40 80 00       	push   $0x804044
  803254:	68 73 01 00 00       	push   $0x173
  803259:	68 cf 3f 80 00       	push   $0x803fcf
  80325e:	e8 6b d0 ff ff       	call   8002ce <_panic>
  803263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803266:	8b 10                	mov    (%eax),%edx
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	89 10                	mov    %edx,(%eax)
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	8b 00                	mov    (%eax),%eax
  803272:	85 c0                	test   %eax,%eax
  803274:	74 0b                	je     803281 <insert_sorted_with_merge_freeList+0x6e1>
  803276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	8b 55 08             	mov    0x8(%ebp),%edx
  80327e:	89 50 04             	mov    %edx,0x4(%eax)
  803281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803284:	8b 55 08             	mov    0x8(%ebp),%edx
  803287:	89 10                	mov    %edx,(%eax)
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80328f:	89 50 04             	mov    %edx,0x4(%eax)
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	8b 00                	mov    (%eax),%eax
  803297:	85 c0                	test   %eax,%eax
  803299:	75 08                	jne    8032a3 <insert_sorted_with_merge_freeList+0x703>
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a3:	a1 44 51 80 00       	mov    0x805144,%eax
  8032a8:	40                   	inc    %eax
  8032a9:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8032ae:	eb 39                	jmp    8032e9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8032b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032bc:	74 07                	je     8032c5 <insert_sorted_with_merge_freeList+0x725>
  8032be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c1:	8b 00                	mov    (%eax),%eax
  8032c3:	eb 05                	jmp    8032ca <insert_sorted_with_merge_freeList+0x72a>
  8032c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032ca:	a3 40 51 80 00       	mov    %eax,0x805140
  8032cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8032d4:	85 c0                	test   %eax,%eax
  8032d6:	0f 85 c7 fb ff ff    	jne    802ea3 <insert_sorted_with_merge_freeList+0x303>
  8032dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e0:	0f 85 bd fb ff ff    	jne    802ea3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032e6:	eb 01                	jmp    8032e9 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032e8:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032e9:	90                   	nop
  8032ea:	c9                   	leave  
  8032eb:	c3                   	ret    

008032ec <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032ec:	55                   	push   %ebp
  8032ed:	89 e5                	mov    %esp,%ebp
  8032ef:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f5:	89 d0                	mov    %edx,%eax
  8032f7:	c1 e0 02             	shl    $0x2,%eax
  8032fa:	01 d0                	add    %edx,%eax
  8032fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803303:	01 d0                	add    %edx,%eax
  803305:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80330c:	01 d0                	add    %edx,%eax
  80330e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803315:	01 d0                	add    %edx,%eax
  803317:	c1 e0 04             	shl    $0x4,%eax
  80331a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80331d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803324:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803327:	83 ec 0c             	sub    $0xc,%esp
  80332a:	50                   	push   %eax
  80332b:	e8 26 e7 ff ff       	call   801a56 <sys_get_virtual_time>
  803330:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803333:	eb 41                	jmp    803376 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803335:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803338:	83 ec 0c             	sub    $0xc,%esp
  80333b:	50                   	push   %eax
  80333c:	e8 15 e7 ff ff       	call   801a56 <sys_get_virtual_time>
  803341:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803344:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803347:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334a:	29 c2                	sub    %eax,%edx
  80334c:	89 d0                	mov    %edx,%eax
  80334e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803351:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803357:	89 d1                	mov    %edx,%ecx
  803359:	29 c1                	sub    %eax,%ecx
  80335b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80335e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803361:	39 c2                	cmp    %eax,%edx
  803363:	0f 97 c0             	seta   %al
  803366:	0f b6 c0             	movzbl %al,%eax
  803369:	29 c1                	sub    %eax,%ecx
  80336b:	89 c8                	mov    %ecx,%eax
  80336d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803370:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803373:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803379:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80337c:	72 b7                	jb     803335 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80337e:	90                   	nop
  80337f:	c9                   	leave  
  803380:	c3                   	ret    

00803381 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803381:	55                   	push   %ebp
  803382:	89 e5                	mov    %esp,%ebp
  803384:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803387:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80338e:	eb 03                	jmp    803393 <busy_wait+0x12>
  803390:	ff 45 fc             	incl   -0x4(%ebp)
  803393:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803396:	3b 45 08             	cmp    0x8(%ebp),%eax
  803399:	72 f5                	jb     803390 <busy_wait+0xf>
	return i;
  80339b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80339e:	c9                   	leave  
  80339f:	c3                   	ret    

008033a0 <__udivdi3>:
  8033a0:	55                   	push   %ebp
  8033a1:	57                   	push   %edi
  8033a2:	56                   	push   %esi
  8033a3:	53                   	push   %ebx
  8033a4:	83 ec 1c             	sub    $0x1c,%esp
  8033a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033b7:	89 ca                	mov    %ecx,%edx
  8033b9:	89 f8                	mov    %edi,%eax
  8033bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033bf:	85 f6                	test   %esi,%esi
  8033c1:	75 2d                	jne    8033f0 <__udivdi3+0x50>
  8033c3:	39 cf                	cmp    %ecx,%edi
  8033c5:	77 65                	ja     80342c <__udivdi3+0x8c>
  8033c7:	89 fd                	mov    %edi,%ebp
  8033c9:	85 ff                	test   %edi,%edi
  8033cb:	75 0b                	jne    8033d8 <__udivdi3+0x38>
  8033cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8033d2:	31 d2                	xor    %edx,%edx
  8033d4:	f7 f7                	div    %edi
  8033d6:	89 c5                	mov    %eax,%ebp
  8033d8:	31 d2                	xor    %edx,%edx
  8033da:	89 c8                	mov    %ecx,%eax
  8033dc:	f7 f5                	div    %ebp
  8033de:	89 c1                	mov    %eax,%ecx
  8033e0:	89 d8                	mov    %ebx,%eax
  8033e2:	f7 f5                	div    %ebp
  8033e4:	89 cf                	mov    %ecx,%edi
  8033e6:	89 fa                	mov    %edi,%edx
  8033e8:	83 c4 1c             	add    $0x1c,%esp
  8033eb:	5b                   	pop    %ebx
  8033ec:	5e                   	pop    %esi
  8033ed:	5f                   	pop    %edi
  8033ee:	5d                   	pop    %ebp
  8033ef:	c3                   	ret    
  8033f0:	39 ce                	cmp    %ecx,%esi
  8033f2:	77 28                	ja     80341c <__udivdi3+0x7c>
  8033f4:	0f bd fe             	bsr    %esi,%edi
  8033f7:	83 f7 1f             	xor    $0x1f,%edi
  8033fa:	75 40                	jne    80343c <__udivdi3+0x9c>
  8033fc:	39 ce                	cmp    %ecx,%esi
  8033fe:	72 0a                	jb     80340a <__udivdi3+0x6a>
  803400:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803404:	0f 87 9e 00 00 00    	ja     8034a8 <__udivdi3+0x108>
  80340a:	b8 01 00 00 00       	mov    $0x1,%eax
  80340f:	89 fa                	mov    %edi,%edx
  803411:	83 c4 1c             	add    $0x1c,%esp
  803414:	5b                   	pop    %ebx
  803415:	5e                   	pop    %esi
  803416:	5f                   	pop    %edi
  803417:	5d                   	pop    %ebp
  803418:	c3                   	ret    
  803419:	8d 76 00             	lea    0x0(%esi),%esi
  80341c:	31 ff                	xor    %edi,%edi
  80341e:	31 c0                	xor    %eax,%eax
  803420:	89 fa                	mov    %edi,%edx
  803422:	83 c4 1c             	add    $0x1c,%esp
  803425:	5b                   	pop    %ebx
  803426:	5e                   	pop    %esi
  803427:	5f                   	pop    %edi
  803428:	5d                   	pop    %ebp
  803429:	c3                   	ret    
  80342a:	66 90                	xchg   %ax,%ax
  80342c:	89 d8                	mov    %ebx,%eax
  80342e:	f7 f7                	div    %edi
  803430:	31 ff                	xor    %edi,%edi
  803432:	89 fa                	mov    %edi,%edx
  803434:	83 c4 1c             	add    $0x1c,%esp
  803437:	5b                   	pop    %ebx
  803438:	5e                   	pop    %esi
  803439:	5f                   	pop    %edi
  80343a:	5d                   	pop    %ebp
  80343b:	c3                   	ret    
  80343c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803441:	89 eb                	mov    %ebp,%ebx
  803443:	29 fb                	sub    %edi,%ebx
  803445:	89 f9                	mov    %edi,%ecx
  803447:	d3 e6                	shl    %cl,%esi
  803449:	89 c5                	mov    %eax,%ebp
  80344b:	88 d9                	mov    %bl,%cl
  80344d:	d3 ed                	shr    %cl,%ebp
  80344f:	89 e9                	mov    %ebp,%ecx
  803451:	09 f1                	or     %esi,%ecx
  803453:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803457:	89 f9                	mov    %edi,%ecx
  803459:	d3 e0                	shl    %cl,%eax
  80345b:	89 c5                	mov    %eax,%ebp
  80345d:	89 d6                	mov    %edx,%esi
  80345f:	88 d9                	mov    %bl,%cl
  803461:	d3 ee                	shr    %cl,%esi
  803463:	89 f9                	mov    %edi,%ecx
  803465:	d3 e2                	shl    %cl,%edx
  803467:	8b 44 24 08          	mov    0x8(%esp),%eax
  80346b:	88 d9                	mov    %bl,%cl
  80346d:	d3 e8                	shr    %cl,%eax
  80346f:	09 c2                	or     %eax,%edx
  803471:	89 d0                	mov    %edx,%eax
  803473:	89 f2                	mov    %esi,%edx
  803475:	f7 74 24 0c          	divl   0xc(%esp)
  803479:	89 d6                	mov    %edx,%esi
  80347b:	89 c3                	mov    %eax,%ebx
  80347d:	f7 e5                	mul    %ebp
  80347f:	39 d6                	cmp    %edx,%esi
  803481:	72 19                	jb     80349c <__udivdi3+0xfc>
  803483:	74 0b                	je     803490 <__udivdi3+0xf0>
  803485:	89 d8                	mov    %ebx,%eax
  803487:	31 ff                	xor    %edi,%edi
  803489:	e9 58 ff ff ff       	jmp    8033e6 <__udivdi3+0x46>
  80348e:	66 90                	xchg   %ax,%ax
  803490:	8b 54 24 08          	mov    0x8(%esp),%edx
  803494:	89 f9                	mov    %edi,%ecx
  803496:	d3 e2                	shl    %cl,%edx
  803498:	39 c2                	cmp    %eax,%edx
  80349a:	73 e9                	jae    803485 <__udivdi3+0xe5>
  80349c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80349f:	31 ff                	xor    %edi,%edi
  8034a1:	e9 40 ff ff ff       	jmp    8033e6 <__udivdi3+0x46>
  8034a6:	66 90                	xchg   %ax,%ax
  8034a8:	31 c0                	xor    %eax,%eax
  8034aa:	e9 37 ff ff ff       	jmp    8033e6 <__udivdi3+0x46>
  8034af:	90                   	nop

008034b0 <__umoddi3>:
  8034b0:	55                   	push   %ebp
  8034b1:	57                   	push   %edi
  8034b2:	56                   	push   %esi
  8034b3:	53                   	push   %ebx
  8034b4:	83 ec 1c             	sub    $0x1c,%esp
  8034b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034cf:	89 f3                	mov    %esi,%ebx
  8034d1:	89 fa                	mov    %edi,%edx
  8034d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034d7:	89 34 24             	mov    %esi,(%esp)
  8034da:	85 c0                	test   %eax,%eax
  8034dc:	75 1a                	jne    8034f8 <__umoddi3+0x48>
  8034de:	39 f7                	cmp    %esi,%edi
  8034e0:	0f 86 a2 00 00 00    	jbe    803588 <__umoddi3+0xd8>
  8034e6:	89 c8                	mov    %ecx,%eax
  8034e8:	89 f2                	mov    %esi,%edx
  8034ea:	f7 f7                	div    %edi
  8034ec:	89 d0                	mov    %edx,%eax
  8034ee:	31 d2                	xor    %edx,%edx
  8034f0:	83 c4 1c             	add    $0x1c,%esp
  8034f3:	5b                   	pop    %ebx
  8034f4:	5e                   	pop    %esi
  8034f5:	5f                   	pop    %edi
  8034f6:	5d                   	pop    %ebp
  8034f7:	c3                   	ret    
  8034f8:	39 f0                	cmp    %esi,%eax
  8034fa:	0f 87 ac 00 00 00    	ja     8035ac <__umoddi3+0xfc>
  803500:	0f bd e8             	bsr    %eax,%ebp
  803503:	83 f5 1f             	xor    $0x1f,%ebp
  803506:	0f 84 ac 00 00 00    	je     8035b8 <__umoddi3+0x108>
  80350c:	bf 20 00 00 00       	mov    $0x20,%edi
  803511:	29 ef                	sub    %ebp,%edi
  803513:	89 fe                	mov    %edi,%esi
  803515:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803519:	89 e9                	mov    %ebp,%ecx
  80351b:	d3 e0                	shl    %cl,%eax
  80351d:	89 d7                	mov    %edx,%edi
  80351f:	89 f1                	mov    %esi,%ecx
  803521:	d3 ef                	shr    %cl,%edi
  803523:	09 c7                	or     %eax,%edi
  803525:	89 e9                	mov    %ebp,%ecx
  803527:	d3 e2                	shl    %cl,%edx
  803529:	89 14 24             	mov    %edx,(%esp)
  80352c:	89 d8                	mov    %ebx,%eax
  80352e:	d3 e0                	shl    %cl,%eax
  803530:	89 c2                	mov    %eax,%edx
  803532:	8b 44 24 08          	mov    0x8(%esp),%eax
  803536:	d3 e0                	shl    %cl,%eax
  803538:	89 44 24 04          	mov    %eax,0x4(%esp)
  80353c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803540:	89 f1                	mov    %esi,%ecx
  803542:	d3 e8                	shr    %cl,%eax
  803544:	09 d0                	or     %edx,%eax
  803546:	d3 eb                	shr    %cl,%ebx
  803548:	89 da                	mov    %ebx,%edx
  80354a:	f7 f7                	div    %edi
  80354c:	89 d3                	mov    %edx,%ebx
  80354e:	f7 24 24             	mull   (%esp)
  803551:	89 c6                	mov    %eax,%esi
  803553:	89 d1                	mov    %edx,%ecx
  803555:	39 d3                	cmp    %edx,%ebx
  803557:	0f 82 87 00 00 00    	jb     8035e4 <__umoddi3+0x134>
  80355d:	0f 84 91 00 00 00    	je     8035f4 <__umoddi3+0x144>
  803563:	8b 54 24 04          	mov    0x4(%esp),%edx
  803567:	29 f2                	sub    %esi,%edx
  803569:	19 cb                	sbb    %ecx,%ebx
  80356b:	89 d8                	mov    %ebx,%eax
  80356d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803571:	d3 e0                	shl    %cl,%eax
  803573:	89 e9                	mov    %ebp,%ecx
  803575:	d3 ea                	shr    %cl,%edx
  803577:	09 d0                	or     %edx,%eax
  803579:	89 e9                	mov    %ebp,%ecx
  80357b:	d3 eb                	shr    %cl,%ebx
  80357d:	89 da                	mov    %ebx,%edx
  80357f:	83 c4 1c             	add    $0x1c,%esp
  803582:	5b                   	pop    %ebx
  803583:	5e                   	pop    %esi
  803584:	5f                   	pop    %edi
  803585:	5d                   	pop    %ebp
  803586:	c3                   	ret    
  803587:	90                   	nop
  803588:	89 fd                	mov    %edi,%ebp
  80358a:	85 ff                	test   %edi,%edi
  80358c:	75 0b                	jne    803599 <__umoddi3+0xe9>
  80358e:	b8 01 00 00 00       	mov    $0x1,%eax
  803593:	31 d2                	xor    %edx,%edx
  803595:	f7 f7                	div    %edi
  803597:	89 c5                	mov    %eax,%ebp
  803599:	89 f0                	mov    %esi,%eax
  80359b:	31 d2                	xor    %edx,%edx
  80359d:	f7 f5                	div    %ebp
  80359f:	89 c8                	mov    %ecx,%eax
  8035a1:	f7 f5                	div    %ebp
  8035a3:	89 d0                	mov    %edx,%eax
  8035a5:	e9 44 ff ff ff       	jmp    8034ee <__umoddi3+0x3e>
  8035aa:	66 90                	xchg   %ax,%ax
  8035ac:	89 c8                	mov    %ecx,%eax
  8035ae:	89 f2                	mov    %esi,%edx
  8035b0:	83 c4 1c             	add    $0x1c,%esp
  8035b3:	5b                   	pop    %ebx
  8035b4:	5e                   	pop    %esi
  8035b5:	5f                   	pop    %edi
  8035b6:	5d                   	pop    %ebp
  8035b7:	c3                   	ret    
  8035b8:	3b 04 24             	cmp    (%esp),%eax
  8035bb:	72 06                	jb     8035c3 <__umoddi3+0x113>
  8035bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035c1:	77 0f                	ja     8035d2 <__umoddi3+0x122>
  8035c3:	89 f2                	mov    %esi,%edx
  8035c5:	29 f9                	sub    %edi,%ecx
  8035c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035cb:	89 14 24             	mov    %edx,(%esp)
  8035ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035d6:	8b 14 24             	mov    (%esp),%edx
  8035d9:	83 c4 1c             	add    $0x1c,%esp
  8035dc:	5b                   	pop    %ebx
  8035dd:	5e                   	pop    %esi
  8035de:	5f                   	pop    %edi
  8035df:	5d                   	pop    %ebp
  8035e0:	c3                   	ret    
  8035e1:	8d 76 00             	lea    0x0(%esi),%esi
  8035e4:	2b 04 24             	sub    (%esp),%eax
  8035e7:	19 fa                	sbb    %edi,%edx
  8035e9:	89 d1                	mov    %edx,%ecx
  8035eb:	89 c6                	mov    %eax,%esi
  8035ed:	e9 71 ff ff ff       	jmp    803563 <__umoddi3+0xb3>
  8035f2:	66 90                	xchg   %ax,%ax
  8035f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035f8:	72 ea                	jb     8035e4 <__umoddi3+0x134>
  8035fa:	89 d9                	mov    %ebx,%ecx
  8035fc:	e9 62 ff ff ff       	jmp    803563 <__umoddi3+0xb3>
