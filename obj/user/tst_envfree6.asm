
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
  800045:	68 20 38 80 00       	push   $0x803820
  80004a:	e8 06 16 00 00       	call   801655 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 c4 18 00 00       	call   801927 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 5c 19 00 00       	call   8019c7 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 38 80 00       	push   $0x803830
  800079:	e8 04 05 00 00       	call   800582 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000, (myEnv->SecondListSize),50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 63 38 80 00       	push   $0x803863
  800099:	e8 fb 1a 00 00       	call   801b99 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	6a 14                	push   $0x14
  8000b4:	68 6c 38 80 00       	push   $0x80386c
  8000b9:	e8 db 1a 00 00       	call   801b99 <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 e8 1a 00 00       	call   801bb7 <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 10 27 00 00       	push   $0x2710
  8000da:	e8 0a 34 00 00       	call   8034e9 <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e8:	e8 ca 1a 00 00       	call   801bb7 <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f0:	90                   	nop
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	83 f8 02             	cmp    $0x2,%eax
  8000f9:	75 f6                	jne    8000f1 <_main+0xb9>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fb:	e8 27 18 00 00       	call   801927 <sys_calculate_free_frames>
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	68 78 38 80 00       	push   $0x803878
  800109:	e8 74 04 00 00       	call   800582 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 e8             	pushl  -0x18(%ebp)
  800117:	e8 b7 1a 00 00       	call   801bd3 <sys_destroy_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 a9 1a 00 00       	call   801bd3 <sys_destroy_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80012d:	e8 f5 17 00 00       	call   801927 <sys_calculate_free_frames>
  800132:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800135:	e8 8d 18 00 00       	call   8019c7 <sys_pf_calculate_allocated_pages>
  80013a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80013d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800143:	74 27                	je     80016c <_main+0x134>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 e0             	pushl  -0x20(%ebp)
  80014b:	68 ac 38 80 00       	push   $0x8038ac
  800150:	e8 2d 04 00 00       	call   800582 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 fc 38 80 00       	push   $0x8038fc
  800160:	6a 23                	push   $0x23
  800162:	68 32 39 80 00       	push   $0x803932
  800167:	e8 62 01 00 00       	call   8002ce <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 e0             	pushl  -0x20(%ebp)
  800172:	68 48 39 80 00       	push   $0x803948
  800177:	e8 06 04 00 00       	call   800582 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 a8 39 80 00       	push   $0x8039a8
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
  800198:	e8 6a 1a 00 00       	call   801c07 <sys_getenvindex>
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
  800203:	e8 0c 18 00 00       	call   801a14 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 0c 3a 80 00       	push   $0x803a0c
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
  800233:	68 34 3a 80 00       	push   $0x803a34
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
  800264:	68 5c 3a 80 00       	push   $0x803a5c
  800269:	e8 14 03 00 00       	call   800582 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 50 80 00       	mov    0x805020,%eax
  800276:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 b4 3a 80 00       	push   $0x803ab4
  800285:	e8 f8 02 00 00       	call   800582 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 0c 3a 80 00       	push   $0x803a0c
  800295:	e8 e8 02 00 00       	call   800582 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029d:	e8 8c 17 00 00       	call   801a2e <sys_enable_interrupt>

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
  8002b5:	e8 19 19 00 00       	call   801bd3 <sys_destroy_env>
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
  8002c6:	e8 6e 19 00 00       	call   801c39 <sys_exit_env>
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
  8002ef:	68 c8 3a 80 00       	push   $0x803ac8
  8002f4:	e8 89 02 00 00       	call   800582 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fc:	a1 00 50 80 00       	mov    0x805000,%eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	50                   	push   %eax
  800308:	68 cd 3a 80 00       	push   $0x803acd
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
  80032c:	68 e9 3a 80 00       	push   $0x803ae9
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
  800358:	68 ec 3a 80 00       	push   $0x803aec
  80035d:	6a 26                	push   $0x26
  80035f:	68 38 3b 80 00       	push   $0x803b38
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
  80042a:	68 44 3b 80 00       	push   $0x803b44
  80042f:	6a 3a                	push   $0x3a
  800431:	68 38 3b 80 00       	push   $0x803b38
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
  80049a:	68 98 3b 80 00       	push   $0x803b98
  80049f:	6a 44                	push   $0x44
  8004a1:	68 38 3b 80 00       	push   $0x803b38
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
  8004f4:	e8 6d 13 00 00       	call   801866 <sys_cputs>
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
  80056b:	e8 f6 12 00 00       	call   801866 <sys_cputs>
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
  8005b5:	e8 5a 14 00 00       	call   801a14 <sys_disable_interrupt>
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
  8005d5:	e8 54 14 00 00       	call   801a2e <sys_enable_interrupt>
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
  80061f:	e8 7c 2f 00 00       	call   8035a0 <__udivdi3>
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
  80066f:	e8 3c 30 00 00       	call   8036b0 <__umoddi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	05 14 3e 80 00       	add    $0x803e14,%eax
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
  8007ca:	8b 04 85 38 3e 80 00 	mov    0x803e38(,%eax,4),%eax
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
  8008ab:	8b 34 9d 80 3c 80 00 	mov    0x803c80(,%ebx,4),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 19                	jne    8008cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b6:	53                   	push   %ebx
  8008b7:	68 25 3e 80 00       	push   $0x803e25
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
  8008d0:	68 2e 3e 80 00       	push   $0x803e2e
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
  8008fd:	be 31 3e 80 00       	mov    $0x803e31,%esi
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
  801323:	68 90 3f 80 00       	push   $0x803f90
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
  8013f3:	e8 b2 05 00 00       	call   8019aa <sys_allocate_chunk>
  8013f8:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013fb:	a1 20 51 80 00       	mov    0x805120,%eax
  801400:	83 ec 0c             	sub    $0xc,%esp
  801403:	50                   	push   %eax
  801404:	e8 27 0c 00 00       	call   802030 <initialize_MemBlocksList>
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
  801431:	68 b5 3f 80 00       	push   $0x803fb5
  801436:	6a 33                	push   $0x33
  801438:	68 d3 3f 80 00       	push   $0x803fd3
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
  8014b0:	68 e0 3f 80 00       	push   $0x803fe0
  8014b5:	6a 34                	push   $0x34
  8014b7:	68 d3 3f 80 00       	push   $0x803fd3
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
  801548:	e8 2b 08 00 00       	call   801d78 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80154d:	85 c0                	test   %eax,%eax
  80154f:	74 11                	je     801562 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801551:	83 ec 0c             	sub    $0xc,%esp
  801554:	ff 75 e8             	pushl  -0x18(%ebp)
  801557:	e8 96 0e 00 00       	call   8023f2 <alloc_block_FF>
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
  80156e:	e8 f2 0b 00 00       	call   802165 <insert_sorted_allocList>
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
  801588:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	83 ec 08             	sub    $0x8,%esp
  801591:	50                   	push   %eax
  801592:	68 40 50 80 00       	push   $0x805040
  801597:	e8 71 0b 00 00       	call   80210d <find_block>
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8015a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015a6:	0f 84 a6 00 00 00    	je     801652 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015af:	8b 50 0c             	mov    0xc(%eax),%edx
  8015b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b5:	8b 40 08             	mov    0x8(%eax),%eax
  8015b8:	83 ec 08             	sub    $0x8,%esp
  8015bb:	52                   	push   %edx
  8015bc:	50                   	push   %eax
  8015bd:	e8 b0 03 00 00       	call   801972 <sys_free_user_mem>
  8015c2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8015c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015c9:	75 14                	jne    8015df <free+0x5a>
  8015cb:	83 ec 04             	sub    $0x4,%esp
  8015ce:	68 b5 3f 80 00       	push   $0x803fb5
  8015d3:	6a 74                	push   $0x74
  8015d5:	68 d3 3f 80 00       	push   $0x803fd3
  8015da:	e8 ef ec ff ff       	call   8002ce <_panic>
  8015df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e2:	8b 00                	mov    (%eax),%eax
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	74 10                	je     8015f8 <free+0x73>
  8015e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015eb:	8b 00                	mov    (%eax),%eax
  8015ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f0:	8b 52 04             	mov    0x4(%edx),%edx
  8015f3:	89 50 04             	mov    %edx,0x4(%eax)
  8015f6:	eb 0b                	jmp    801603 <free+0x7e>
  8015f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fb:	8b 40 04             	mov    0x4(%eax),%eax
  8015fe:	a3 44 50 80 00       	mov    %eax,0x805044
  801603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801606:	8b 40 04             	mov    0x4(%eax),%eax
  801609:	85 c0                	test   %eax,%eax
  80160b:	74 0f                	je     80161c <free+0x97>
  80160d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801610:	8b 40 04             	mov    0x4(%eax),%eax
  801613:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801616:	8b 12                	mov    (%edx),%edx
  801618:	89 10                	mov    %edx,(%eax)
  80161a:	eb 0a                	jmp    801626 <free+0xa1>
  80161c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161f:	8b 00                	mov    (%eax),%eax
  801621:	a3 40 50 80 00       	mov    %eax,0x805040
  801626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80162f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801639:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80163e:	48                   	dec    %eax
  80163f:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801644:	83 ec 0c             	sub    $0xc,%esp
  801647:	ff 75 f4             	pushl  -0xc(%ebp)
  80164a:	e8 4e 17 00 00       	call   802d9d <insert_sorted_with_merge_freeList>
  80164f:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801652:	90                   	nop
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 38             	sub    $0x38,%esp
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801661:	e8 a6 fc ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  801666:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80166a:	75 0a                	jne    801676 <smalloc+0x21>
  80166c:	b8 00 00 00 00       	mov    $0x0,%eax
  801671:	e9 8b 00 00 00       	jmp    801701 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801676:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80167d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801683:	01 d0                	add    %edx,%eax
  801685:	48                   	dec    %eax
  801686:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801689:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168c:	ba 00 00 00 00       	mov    $0x0,%edx
  801691:	f7 75 f0             	divl   -0x10(%ebp)
  801694:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801697:	29 d0                	sub    %edx,%eax
  801699:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80169c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016a3:	e8 d0 06 00 00       	call   801d78 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016a8:	85 c0                	test   %eax,%eax
  8016aa:	74 11                	je     8016bd <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8016ac:	83 ec 0c             	sub    $0xc,%esp
  8016af:	ff 75 e8             	pushl  -0x18(%ebp)
  8016b2:	e8 3b 0d 00 00       	call   8023f2 <alloc_block_FF>
  8016b7:	83 c4 10             	add    $0x10,%esp
  8016ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8016bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016c1:	74 39                	je     8016fc <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c6:	8b 40 08             	mov    0x8(%eax),%eax
  8016c9:	89 c2                	mov    %eax,%edx
  8016cb:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016cf:	52                   	push   %edx
  8016d0:	50                   	push   %eax
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	ff 75 08             	pushl  0x8(%ebp)
  8016d7:	e8 21 04 00 00       	call   801afd <sys_createSharedObject>
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016e2:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016e6:	74 14                	je     8016fc <smalloc+0xa7>
  8016e8:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016ec:	74 0e                	je     8016fc <smalloc+0xa7>
  8016ee:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016f2:	74 08                	je     8016fc <smalloc+0xa7>
			return (void*) mem_block->sva;
  8016f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f7:	8b 40 08             	mov    0x8(%eax),%eax
  8016fa:	eb 05                	jmp    801701 <smalloc+0xac>
	}
	return NULL;
  8016fc:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801709:	e8 fe fb ff ff       	call   80130c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80170e:	83 ec 08             	sub    $0x8,%esp
  801711:	ff 75 0c             	pushl  0xc(%ebp)
  801714:	ff 75 08             	pushl  0x8(%ebp)
  801717:	e8 0b 04 00 00       	call   801b27 <sys_getSizeOfSharedObject>
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801722:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801726:	74 76                	je     80179e <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801728:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80172f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801732:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801735:	01 d0                	add    %edx,%eax
  801737:	48                   	dec    %eax
  801738:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80173b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80173e:	ba 00 00 00 00       	mov    $0x0,%edx
  801743:	f7 75 ec             	divl   -0x14(%ebp)
  801746:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801749:	29 d0                	sub    %edx,%eax
  80174b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80174e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801755:	e8 1e 06 00 00       	call   801d78 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80175a:	85 c0                	test   %eax,%eax
  80175c:	74 11                	je     80176f <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80175e:	83 ec 0c             	sub    $0xc,%esp
  801761:	ff 75 e4             	pushl  -0x1c(%ebp)
  801764:	e8 89 0c 00 00       	call   8023f2 <alloc_block_FF>
  801769:	83 c4 10             	add    $0x10,%esp
  80176c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80176f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801773:	74 29                	je     80179e <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801778:	8b 40 08             	mov    0x8(%eax),%eax
  80177b:	83 ec 04             	sub    $0x4,%esp
  80177e:	50                   	push   %eax
  80177f:	ff 75 0c             	pushl  0xc(%ebp)
  801782:	ff 75 08             	pushl  0x8(%ebp)
  801785:	e8 ba 03 00 00       	call   801b44 <sys_getSharedObject>
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801790:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801794:	74 08                	je     80179e <sget+0x9b>
				return (void *)mem_block->sva;
  801796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801799:	8b 40 08             	mov    0x8(%eax),%eax
  80179c:	eb 05                	jmp    8017a3 <sget+0xa0>
		}
	}
	return NULL;
  80179e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ab:	e8 5c fb ff ff       	call   80130c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017b0:	83 ec 04             	sub    $0x4,%esp
  8017b3:	68 04 40 80 00       	push   $0x804004
  8017b8:	68 f7 00 00 00       	push   $0xf7
  8017bd:	68 d3 3f 80 00       	push   $0x803fd3
  8017c2:	e8 07 eb ff ff       	call   8002ce <_panic>

008017c7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017cd:	83 ec 04             	sub    $0x4,%esp
  8017d0:	68 2c 40 80 00       	push   $0x80402c
  8017d5:	68 0c 01 00 00       	push   $0x10c
  8017da:	68 d3 3f 80 00       	push   $0x803fd3
  8017df:	e8 ea ea ff ff       	call   8002ce <_panic>

008017e4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ea:	83 ec 04             	sub    $0x4,%esp
  8017ed:	68 50 40 80 00       	push   $0x804050
  8017f2:	68 44 01 00 00       	push   $0x144
  8017f7:	68 d3 3f 80 00       	push   $0x803fd3
  8017fc:	e8 cd ea ff ff       	call   8002ce <_panic>

00801801 <shrink>:

}
void shrink(uint32 newSize)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801807:	83 ec 04             	sub    $0x4,%esp
  80180a:	68 50 40 80 00       	push   $0x804050
  80180f:	68 49 01 00 00       	push   $0x149
  801814:	68 d3 3f 80 00       	push   $0x803fd3
  801819:	e8 b0 ea ff ff       	call   8002ce <_panic>

0080181e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801824:	83 ec 04             	sub    $0x4,%esp
  801827:	68 50 40 80 00       	push   $0x804050
  80182c:	68 4e 01 00 00       	push   $0x14e
  801831:	68 d3 3f 80 00       	push   $0x803fd3
  801836:	e8 93 ea ff ff       	call   8002ce <_panic>

0080183b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	57                   	push   %edi
  80183f:	56                   	push   %esi
  801840:	53                   	push   %ebx
  801841:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80184d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801850:	8b 7d 18             	mov    0x18(%ebp),%edi
  801853:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801856:	cd 30                	int    $0x30
  801858:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80185b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	5b                   	pop    %ebx
  801862:	5e                   	pop    %esi
  801863:	5f                   	pop    %edi
  801864:	5d                   	pop    %ebp
  801865:	c3                   	ret    

00801866 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	83 ec 04             	sub    $0x4,%esp
  80186c:	8b 45 10             	mov    0x10(%ebp),%eax
  80186f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801872:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	52                   	push   %edx
  80187e:	ff 75 0c             	pushl  0xc(%ebp)
  801881:	50                   	push   %eax
  801882:	6a 00                	push   $0x0
  801884:	e8 b2 ff ff ff       	call   80183b <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	90                   	nop
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_cgetc>:

int
sys_cgetc(void)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 01                	push   $0x1
  80189e:	e8 98 ff ff ff       	call   80183b <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	52                   	push   %edx
  8018b8:	50                   	push   %eax
  8018b9:	6a 05                	push   $0x5
  8018bb:	e8 7b ff ff ff       	call   80183b <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	56                   	push   %esi
  8018c9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018ca:	8b 75 18             	mov    0x18(%ebp),%esi
  8018cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	56                   	push   %esi
  8018da:	53                   	push   %ebx
  8018db:	51                   	push   %ecx
  8018dc:	52                   	push   %edx
  8018dd:	50                   	push   %eax
  8018de:	6a 06                	push   $0x6
  8018e0:	e8 56 ff ff ff       	call   80183b <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018eb:	5b                   	pop    %ebx
  8018ec:	5e                   	pop    %esi
  8018ed:	5d                   	pop    %ebp
  8018ee:	c3                   	ret    

008018ef <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	52                   	push   %edx
  8018ff:	50                   	push   %eax
  801900:	6a 07                	push   $0x7
  801902:	e8 34 ff ff ff       	call   80183b <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	ff 75 0c             	pushl  0xc(%ebp)
  801918:	ff 75 08             	pushl  0x8(%ebp)
  80191b:	6a 08                	push   $0x8
  80191d:	e8 19 ff ff ff       	call   80183b <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 09                	push   $0x9
  801936:	e8 00 ff ff ff       	call   80183b <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 0a                	push   $0xa
  80194f:	e8 e7 fe ff ff       	call   80183b <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 0b                	push   $0xb
  801968:	e8 ce fe ff ff       	call   80183b <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	ff 75 0c             	pushl  0xc(%ebp)
  80197e:	ff 75 08             	pushl  0x8(%ebp)
  801981:	6a 0f                	push   $0xf
  801983:	e8 b3 fe ff ff       	call   80183b <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
	return;
  80198b:	90                   	nop
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	ff 75 08             	pushl  0x8(%ebp)
  80199d:	6a 10                	push   $0x10
  80199f:	e8 97 fe ff ff       	call   80183b <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a7:	90                   	nop
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	ff 75 10             	pushl  0x10(%ebp)
  8019b4:	ff 75 0c             	pushl  0xc(%ebp)
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	6a 11                	push   $0x11
  8019bc:	e8 7a fe ff ff       	call   80183b <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c4:	90                   	nop
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 0c                	push   $0xc
  8019d6:	e8 60 fe ff ff       	call   80183b <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	ff 75 08             	pushl  0x8(%ebp)
  8019ee:	6a 0d                	push   $0xd
  8019f0:	e8 46 fe ff ff       	call   80183b <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 0e                	push   $0xe
  801a09:	e8 2d fe ff ff       	call   80183b <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	90                   	nop
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 13                	push   $0x13
  801a23:	e8 13 fe ff ff       	call   80183b <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	90                   	nop
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 14                	push   $0x14
  801a3d:	e8 f9 fd ff ff       	call   80183b <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	90                   	nop
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a54:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	50                   	push   %eax
  801a61:	6a 15                	push   $0x15
  801a63:	e8 d3 fd ff ff       	call   80183b <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 16                	push   $0x16
  801a7d:	e8 b9 fd ff ff       	call   80183b <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	90                   	nop
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	ff 75 0c             	pushl  0xc(%ebp)
  801a97:	50                   	push   %eax
  801a98:	6a 17                	push   $0x17
  801a9a:	e8 9c fd ff ff       	call   80183b <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	52                   	push   %edx
  801ab4:	50                   	push   %eax
  801ab5:	6a 1a                	push   $0x1a
  801ab7:	e8 7f fd ff ff       	call   80183b <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	52                   	push   %edx
  801ad1:	50                   	push   %eax
  801ad2:	6a 18                	push   $0x18
  801ad4:	e8 62 fd ff ff       	call   80183b <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	90                   	nop
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	52                   	push   %edx
  801aef:	50                   	push   %eax
  801af0:	6a 19                	push   $0x19
  801af2:	e8 44 fd ff ff       	call   80183b <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	90                   	nop
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	83 ec 04             	sub    $0x4,%esp
  801b03:	8b 45 10             	mov    0x10(%ebp),%eax
  801b06:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b09:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b0c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	6a 00                	push   $0x0
  801b15:	51                   	push   %ecx
  801b16:	52                   	push   %edx
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	50                   	push   %eax
  801b1b:	6a 1b                	push   $0x1b
  801b1d:	e8 19 fd ff ff       	call   80183b <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	52                   	push   %edx
  801b37:	50                   	push   %eax
  801b38:	6a 1c                	push   $0x1c
  801b3a:	e8 fc fc ff ff       	call   80183b <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b47:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	51                   	push   %ecx
  801b55:	52                   	push   %edx
  801b56:	50                   	push   %eax
  801b57:	6a 1d                	push   $0x1d
  801b59:	e8 dd fc ff ff       	call   80183b <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	52                   	push   %edx
  801b73:	50                   	push   %eax
  801b74:	6a 1e                	push   $0x1e
  801b76:	e8 c0 fc ff ff       	call   80183b <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 1f                	push   $0x1f
  801b8f:	e8 a7 fc ff ff       	call   80183b <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9f:	6a 00                	push   $0x0
  801ba1:	ff 75 14             	pushl  0x14(%ebp)
  801ba4:	ff 75 10             	pushl  0x10(%ebp)
  801ba7:	ff 75 0c             	pushl  0xc(%ebp)
  801baa:	50                   	push   %eax
  801bab:	6a 20                	push   $0x20
  801bad:	e8 89 fc ff ff       	call   80183b <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bba:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	50                   	push   %eax
  801bc6:	6a 21                	push   $0x21
  801bc8:	e8 6e fc ff ff       	call   80183b <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
}
  801bd0:	90                   	nop
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	50                   	push   %eax
  801be2:	6a 22                	push   $0x22
  801be4:	e8 52 fc ff ff       	call   80183b <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 02                	push   $0x2
  801bfd:	e8 39 fc ff ff       	call   80183b <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 03                	push   $0x3
  801c16:	e8 20 fc ff ff       	call   80183b <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 04                	push   $0x4
  801c2f:	e8 07 fc ff ff       	call   80183b <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_exit_env>:


void sys_exit_env(void)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 23                	push   $0x23
  801c48:	e8 ee fb ff ff       	call   80183b <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	90                   	nop
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c59:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5c:	8d 50 04             	lea    0x4(%eax),%edx
  801c5f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	52                   	push   %edx
  801c69:	50                   	push   %eax
  801c6a:	6a 24                	push   $0x24
  801c6c:	e8 ca fb ff ff       	call   80183b <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
	return result;
  801c74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c7d:	89 01                	mov    %eax,(%ecx)
  801c7f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	c9                   	leave  
  801c86:	c2 04 00             	ret    $0x4

00801c89 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	ff 75 10             	pushl  0x10(%ebp)
  801c93:	ff 75 0c             	pushl  0xc(%ebp)
  801c96:	ff 75 08             	pushl  0x8(%ebp)
  801c99:	6a 12                	push   $0x12
  801c9b:	e8 9b fb ff ff       	call   80183b <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca3:	90                   	nop
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 25                	push   $0x25
  801cb5:	e8 81 fb ff ff       	call   80183b <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ccb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	50                   	push   %eax
  801cd8:	6a 26                	push   $0x26
  801cda:	e8 5c fb ff ff       	call   80183b <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce2:	90                   	nop
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <rsttst>:
void rsttst()
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 28                	push   $0x28
  801cf4:	e8 42 fb ff ff       	call   80183b <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfc:	90                   	nop
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	8b 45 14             	mov    0x14(%ebp),%eax
  801d08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d0b:	8b 55 18             	mov    0x18(%ebp),%edx
  801d0e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d12:	52                   	push   %edx
  801d13:	50                   	push   %eax
  801d14:	ff 75 10             	pushl  0x10(%ebp)
  801d17:	ff 75 0c             	pushl  0xc(%ebp)
  801d1a:	ff 75 08             	pushl  0x8(%ebp)
  801d1d:	6a 27                	push   $0x27
  801d1f:	e8 17 fb ff ff       	call   80183b <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
	return ;
  801d27:	90                   	nop
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <chktst>:
void chktst(uint32 n)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	ff 75 08             	pushl  0x8(%ebp)
  801d38:	6a 29                	push   $0x29
  801d3a:	e8 fc fa ff ff       	call   80183b <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d42:	90                   	nop
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <inctst>:

void inctst()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 2a                	push   $0x2a
  801d54:	e8 e2 fa ff ff       	call   80183b <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5c:	90                   	nop
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <gettst>:
uint32 gettst()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 2b                	push   $0x2b
  801d6e:	e8 c8 fa ff ff       	call   80183b <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 2c                	push   $0x2c
  801d8a:	e8 ac fa ff ff       	call   80183b <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
  801d92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d95:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d99:	75 07                	jne    801da2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801da0:	eb 05                	jmp    801da7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 2c                	push   $0x2c
  801dbb:	e8 7b fa ff ff       	call   80183b <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
  801dc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dc6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dca:	75 07                	jne    801dd3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dcc:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd1:	eb 05                	jmp    801dd8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 2c                	push   $0x2c
  801dec:	e8 4a fa ff ff       	call   80183b <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
  801df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dfb:	75 07                	jne    801e04 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dfd:	b8 01 00 00 00       	mov    $0x1,%eax
  801e02:	eb 05                	jmp    801e09 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 2c                	push   $0x2c
  801e1d:	e8 19 fa ff ff       	call   80183b <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
  801e25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e28:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e2c:	75 07                	jne    801e35 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e33:	eb 05                	jmp    801e3a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	ff 75 08             	pushl  0x8(%ebp)
  801e4a:	6a 2d                	push   $0x2d
  801e4c:	e8 ea f9 ff ff       	call   80183b <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
	return ;
  801e54:	90                   	nop
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e5b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	6a 00                	push   $0x0
  801e69:	53                   	push   %ebx
  801e6a:	51                   	push   %ecx
  801e6b:	52                   	push   %edx
  801e6c:	50                   	push   %eax
  801e6d:	6a 2e                	push   $0x2e
  801e6f:	e8 c7 f9 ff ff       	call   80183b <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
}
  801e77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	52                   	push   %edx
  801e8c:	50                   	push   %eax
  801e8d:	6a 2f                	push   $0x2f
  801e8f:	e8 a7 f9 ff ff       	call   80183b <syscall>
  801e94:	83 c4 18             	add    $0x18,%esp
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	68 60 40 80 00       	push   $0x804060
  801ea7:	e8 d6 e6 ff ff       	call   800582 <cprintf>
  801eac:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801eaf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eb6:	83 ec 0c             	sub    $0xc,%esp
  801eb9:	68 8c 40 80 00       	push   $0x80408c
  801ebe:	e8 bf e6 ff ff       	call   800582 <cprintf>
  801ec3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ec6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eca:	a1 38 51 80 00       	mov    0x805138,%eax
  801ecf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed2:	eb 56                	jmp    801f2a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ed4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed8:	74 1c                	je     801ef6 <print_mem_block_lists+0x5d>
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	8b 50 08             	mov    0x8(%eax),%edx
  801ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee3:	8b 48 08             	mov    0x8(%eax),%ecx
  801ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee9:	8b 40 0c             	mov    0xc(%eax),%eax
  801eec:	01 c8                	add    %ecx,%eax
  801eee:	39 c2                	cmp    %eax,%edx
  801ef0:	73 04                	jae    801ef6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ef2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef9:	8b 50 08             	mov    0x8(%eax),%edx
  801efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eff:	8b 40 0c             	mov    0xc(%eax),%eax
  801f02:	01 c2                	add    %eax,%edx
  801f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f07:	8b 40 08             	mov    0x8(%eax),%eax
  801f0a:	83 ec 04             	sub    $0x4,%esp
  801f0d:	52                   	push   %edx
  801f0e:	50                   	push   %eax
  801f0f:	68 a1 40 80 00       	push   $0x8040a1
  801f14:	e8 69 e6 ff ff       	call   800582 <cprintf>
  801f19:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f22:	a1 40 51 80 00       	mov    0x805140,%eax
  801f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2e:	74 07                	je     801f37 <print_mem_block_lists+0x9e>
  801f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f33:	8b 00                	mov    (%eax),%eax
  801f35:	eb 05                	jmp    801f3c <print_mem_block_lists+0xa3>
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	a3 40 51 80 00       	mov    %eax,0x805140
  801f41:	a1 40 51 80 00       	mov    0x805140,%eax
  801f46:	85 c0                	test   %eax,%eax
  801f48:	75 8a                	jne    801ed4 <print_mem_block_lists+0x3b>
  801f4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4e:	75 84                	jne    801ed4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f50:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f54:	75 10                	jne    801f66 <print_mem_block_lists+0xcd>
  801f56:	83 ec 0c             	sub    $0xc,%esp
  801f59:	68 b0 40 80 00       	push   $0x8040b0
  801f5e:	e8 1f e6 ff ff       	call   800582 <cprintf>
  801f63:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f66:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f6d:	83 ec 0c             	sub    $0xc,%esp
  801f70:	68 d4 40 80 00       	push   $0x8040d4
  801f75:	e8 08 e6 ff ff       	call   800582 <cprintf>
  801f7a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f7d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f81:	a1 40 50 80 00       	mov    0x805040,%eax
  801f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f89:	eb 56                	jmp    801fe1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8f:	74 1c                	je     801fad <print_mem_block_lists+0x114>
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	8b 50 08             	mov    0x8(%eax),%edx
  801f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa3:	01 c8                	add    %ecx,%eax
  801fa5:	39 c2                	cmp    %eax,%edx
  801fa7:	73 04                	jae    801fad <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fa9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	8b 50 08             	mov    0x8(%eax),%edx
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb9:	01 c2                	add    %eax,%edx
  801fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbe:	8b 40 08             	mov    0x8(%eax),%eax
  801fc1:	83 ec 04             	sub    $0x4,%esp
  801fc4:	52                   	push   %edx
  801fc5:	50                   	push   %eax
  801fc6:	68 a1 40 80 00       	push   $0x8040a1
  801fcb:	e8 b2 e5 ff ff       	call   800582 <cprintf>
  801fd0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd9:	a1 48 50 80 00       	mov    0x805048,%eax
  801fde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe5:	74 07                	je     801fee <print_mem_block_lists+0x155>
  801fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fea:	8b 00                	mov    (%eax),%eax
  801fec:	eb 05                	jmp    801ff3 <print_mem_block_lists+0x15a>
  801fee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff3:	a3 48 50 80 00       	mov    %eax,0x805048
  801ff8:	a1 48 50 80 00       	mov    0x805048,%eax
  801ffd:	85 c0                	test   %eax,%eax
  801fff:	75 8a                	jne    801f8b <print_mem_block_lists+0xf2>
  802001:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802005:	75 84                	jne    801f8b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802007:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80200b:	75 10                	jne    80201d <print_mem_block_lists+0x184>
  80200d:	83 ec 0c             	sub    $0xc,%esp
  802010:	68 ec 40 80 00       	push   $0x8040ec
  802015:	e8 68 e5 ff ff       	call   800582 <cprintf>
  80201a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80201d:	83 ec 0c             	sub    $0xc,%esp
  802020:	68 60 40 80 00       	push   $0x804060
  802025:	e8 58 e5 ff ff       	call   800582 <cprintf>
  80202a:	83 c4 10             	add    $0x10,%esp

}
  80202d:	90                   	nop
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802036:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80203d:	00 00 00 
  802040:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802047:	00 00 00 
  80204a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802051:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802054:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80205b:	e9 9e 00 00 00       	jmp    8020fe <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802060:	a1 50 50 80 00       	mov    0x805050,%eax
  802065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802068:	c1 e2 04             	shl    $0x4,%edx
  80206b:	01 d0                	add    %edx,%eax
  80206d:	85 c0                	test   %eax,%eax
  80206f:	75 14                	jne    802085 <initialize_MemBlocksList+0x55>
  802071:	83 ec 04             	sub    $0x4,%esp
  802074:	68 14 41 80 00       	push   $0x804114
  802079:	6a 46                	push   $0x46
  80207b:	68 37 41 80 00       	push   $0x804137
  802080:	e8 49 e2 ff ff       	call   8002ce <_panic>
  802085:	a1 50 50 80 00       	mov    0x805050,%eax
  80208a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208d:	c1 e2 04             	shl    $0x4,%edx
  802090:	01 d0                	add    %edx,%eax
  802092:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802098:	89 10                	mov    %edx,(%eax)
  80209a:	8b 00                	mov    (%eax),%eax
  80209c:	85 c0                	test   %eax,%eax
  80209e:	74 18                	je     8020b8 <initialize_MemBlocksList+0x88>
  8020a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8020a5:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020ab:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020ae:	c1 e1 04             	shl    $0x4,%ecx
  8020b1:	01 ca                	add    %ecx,%edx
  8020b3:	89 50 04             	mov    %edx,0x4(%eax)
  8020b6:	eb 12                	jmp    8020ca <initialize_MemBlocksList+0x9a>
  8020b8:	a1 50 50 80 00       	mov    0x805050,%eax
  8020bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c0:	c1 e2 04             	shl    $0x4,%edx
  8020c3:	01 d0                	add    %edx,%eax
  8020c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020ca:	a1 50 50 80 00       	mov    0x805050,%eax
  8020cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d2:	c1 e2 04             	shl    $0x4,%edx
  8020d5:	01 d0                	add    %edx,%eax
  8020d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8020dc:	a1 50 50 80 00       	mov    0x805050,%eax
  8020e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e4:	c1 e2 04             	shl    $0x4,%edx
  8020e7:	01 d0                	add    %edx,%eax
  8020e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8020f5:	40                   	inc    %eax
  8020f6:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020fb:	ff 45 f4             	incl   -0xc(%ebp)
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	3b 45 08             	cmp    0x8(%ebp),%eax
  802104:	0f 82 56 ff ff ff    	jb     802060 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80210a:	90                   	nop
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	8b 00                	mov    (%eax),%eax
  802118:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80211b:	eb 19                	jmp    802136 <find_block+0x29>
	{
		if(va==point->sva)
  80211d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802120:	8b 40 08             	mov    0x8(%eax),%eax
  802123:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802126:	75 05                	jne    80212d <find_block+0x20>
		   return point;
  802128:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212b:	eb 36                	jmp    802163 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	8b 40 08             	mov    0x8(%eax),%eax
  802133:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802136:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80213a:	74 07                	je     802143 <find_block+0x36>
  80213c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213f:	8b 00                	mov    (%eax),%eax
  802141:	eb 05                	jmp    802148 <find_block+0x3b>
  802143:	b8 00 00 00 00       	mov    $0x0,%eax
  802148:	8b 55 08             	mov    0x8(%ebp),%edx
  80214b:	89 42 08             	mov    %eax,0x8(%edx)
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	8b 40 08             	mov    0x8(%eax),%eax
  802154:	85 c0                	test   %eax,%eax
  802156:	75 c5                	jne    80211d <find_block+0x10>
  802158:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80215c:	75 bf                	jne    80211d <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80215e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80216b:	a1 40 50 80 00       	mov    0x805040,%eax
  802170:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802173:	a1 44 50 80 00       	mov    0x805044,%eax
  802178:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80217b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802181:	74 24                	je     8021a7 <insert_sorted_allocList+0x42>
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	8b 50 08             	mov    0x8(%eax),%edx
  802189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218c:	8b 40 08             	mov    0x8(%eax),%eax
  80218f:	39 c2                	cmp    %eax,%edx
  802191:	76 14                	jbe    8021a7 <insert_sorted_allocList+0x42>
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8b 50 08             	mov    0x8(%eax),%edx
  802199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219c:	8b 40 08             	mov    0x8(%eax),%eax
  80219f:	39 c2                	cmp    %eax,%edx
  8021a1:	0f 82 60 01 00 00    	jb     802307 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ab:	75 65                	jne    802212 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b1:	75 14                	jne    8021c7 <insert_sorted_allocList+0x62>
  8021b3:	83 ec 04             	sub    $0x4,%esp
  8021b6:	68 14 41 80 00       	push   $0x804114
  8021bb:	6a 6b                	push   $0x6b
  8021bd:	68 37 41 80 00       	push   $0x804137
  8021c2:	e8 07 e1 ff ff       	call   8002ce <_panic>
  8021c7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	89 10                	mov    %edx,(%eax)
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	8b 00                	mov    (%eax),%eax
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	74 0d                	je     8021e8 <insert_sorted_allocList+0x83>
  8021db:	a1 40 50 80 00       	mov    0x805040,%eax
  8021e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e3:	89 50 04             	mov    %edx,0x4(%eax)
  8021e6:	eb 08                	jmp    8021f0 <insert_sorted_allocList+0x8b>
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	a3 44 50 80 00       	mov    %eax,0x805044
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	a3 40 50 80 00       	mov    %eax,0x805040
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802202:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802207:	40                   	inc    %eax
  802208:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80220d:	e9 dc 01 00 00       	jmp    8023ee <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	8b 50 08             	mov    0x8(%eax),%edx
  802218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221b:	8b 40 08             	mov    0x8(%eax),%eax
  80221e:	39 c2                	cmp    %eax,%edx
  802220:	77 6c                	ja     80228e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802222:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802226:	74 06                	je     80222e <insert_sorted_allocList+0xc9>
  802228:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80222c:	75 14                	jne    802242 <insert_sorted_allocList+0xdd>
  80222e:	83 ec 04             	sub    $0x4,%esp
  802231:	68 50 41 80 00       	push   $0x804150
  802236:	6a 6f                	push   $0x6f
  802238:	68 37 41 80 00       	push   $0x804137
  80223d:	e8 8c e0 ff ff       	call   8002ce <_panic>
  802242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802245:	8b 50 04             	mov    0x4(%eax),%edx
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	89 50 04             	mov    %edx,0x4(%eax)
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802254:	89 10                	mov    %edx,(%eax)
  802256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802259:	8b 40 04             	mov    0x4(%eax),%eax
  80225c:	85 c0                	test   %eax,%eax
  80225e:	74 0d                	je     80226d <insert_sorted_allocList+0x108>
  802260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802263:	8b 40 04             	mov    0x4(%eax),%eax
  802266:	8b 55 08             	mov    0x8(%ebp),%edx
  802269:	89 10                	mov    %edx,(%eax)
  80226b:	eb 08                	jmp    802275 <insert_sorted_allocList+0x110>
  80226d:	8b 45 08             	mov    0x8(%ebp),%eax
  802270:	a3 40 50 80 00       	mov    %eax,0x805040
  802275:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802278:	8b 55 08             	mov    0x8(%ebp),%edx
  80227b:	89 50 04             	mov    %edx,0x4(%eax)
  80227e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802283:	40                   	inc    %eax
  802284:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802289:	e9 60 01 00 00       	jmp    8023ee <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	8b 50 08             	mov    0x8(%eax),%edx
  802294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802297:	8b 40 08             	mov    0x8(%eax),%eax
  80229a:	39 c2                	cmp    %eax,%edx
  80229c:	0f 82 4c 01 00 00    	jb     8023ee <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a6:	75 14                	jne    8022bc <insert_sorted_allocList+0x157>
  8022a8:	83 ec 04             	sub    $0x4,%esp
  8022ab:	68 88 41 80 00       	push   $0x804188
  8022b0:	6a 73                	push   $0x73
  8022b2:	68 37 41 80 00       	push   $0x804137
  8022b7:	e8 12 e0 ff ff       	call   8002ce <_panic>
  8022bc:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	89 50 04             	mov    %edx,0x4(%eax)
  8022c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cb:	8b 40 04             	mov    0x4(%eax),%eax
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	74 0c                	je     8022de <insert_sorted_allocList+0x179>
  8022d2:	a1 44 50 80 00       	mov    0x805044,%eax
  8022d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022da:	89 10                	mov    %edx,(%eax)
  8022dc:	eb 08                	jmp    8022e6 <insert_sorted_allocList+0x181>
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	a3 40 50 80 00       	mov    %eax,0x805040
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	a3 44 50 80 00       	mov    %eax,0x805044
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022fc:	40                   	inc    %eax
  8022fd:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802302:	e9 e7 00 00 00       	jmp    8023ee <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80230d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802314:	a1 40 50 80 00       	mov    0x805040,%eax
  802319:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231c:	e9 9d 00 00 00       	jmp    8023be <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 00                	mov    (%eax),%eax
  802326:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	8b 50 08             	mov    0x8(%eax),%edx
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	8b 40 08             	mov    0x8(%eax),%eax
  802335:	39 c2                	cmp    %eax,%edx
  802337:	76 7d                	jbe    8023b6 <insert_sorted_allocList+0x251>
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	8b 50 08             	mov    0x8(%eax),%edx
  80233f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802342:	8b 40 08             	mov    0x8(%eax),%eax
  802345:	39 c2                	cmp    %eax,%edx
  802347:	73 6d                	jae    8023b6 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802349:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234d:	74 06                	je     802355 <insert_sorted_allocList+0x1f0>
  80234f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802353:	75 14                	jne    802369 <insert_sorted_allocList+0x204>
  802355:	83 ec 04             	sub    $0x4,%esp
  802358:	68 ac 41 80 00       	push   $0x8041ac
  80235d:	6a 7f                	push   $0x7f
  80235f:	68 37 41 80 00       	push   $0x804137
  802364:	e8 65 df ff ff       	call   8002ce <_panic>
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 10                	mov    (%eax),%edx
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	89 10                	mov    %edx,(%eax)
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	8b 00                	mov    (%eax),%eax
  802378:	85 c0                	test   %eax,%eax
  80237a:	74 0b                	je     802387 <insert_sorted_allocList+0x222>
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	8b 00                	mov    (%eax),%eax
  802381:	8b 55 08             	mov    0x8(%ebp),%edx
  802384:	89 50 04             	mov    %edx,0x4(%eax)
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 55 08             	mov    0x8(%ebp),%edx
  80238d:	89 10                	mov    %edx,(%eax)
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802395:	89 50 04             	mov    %edx,0x4(%eax)
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	8b 00                	mov    (%eax),%eax
  80239d:	85 c0                	test   %eax,%eax
  80239f:	75 08                	jne    8023a9 <insert_sorted_allocList+0x244>
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	a3 44 50 80 00       	mov    %eax,0x805044
  8023a9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023ae:	40                   	inc    %eax
  8023af:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023b4:	eb 39                	jmp    8023ef <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023b6:	a1 48 50 80 00       	mov    0x805048,%eax
  8023bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c2:	74 07                	je     8023cb <insert_sorted_allocList+0x266>
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 00                	mov    (%eax),%eax
  8023c9:	eb 05                	jmp    8023d0 <insert_sorted_allocList+0x26b>
  8023cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d0:	a3 48 50 80 00       	mov    %eax,0x805048
  8023d5:	a1 48 50 80 00       	mov    0x805048,%eax
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	0f 85 3f ff ff ff    	jne    802321 <insert_sorted_allocList+0x1bc>
  8023e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e6:	0f 85 35 ff ff ff    	jne    802321 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023ec:	eb 01                	jmp    8023ef <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023ee:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023ef:	90                   	nop
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023f8:	a1 38 51 80 00       	mov    0x805138,%eax
  8023fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802400:	e9 85 01 00 00       	jmp    80258a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 40 0c             	mov    0xc(%eax),%eax
  80240b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240e:	0f 82 6e 01 00 00    	jb     802582 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	8b 40 0c             	mov    0xc(%eax),%eax
  80241a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241d:	0f 85 8a 00 00 00    	jne    8024ad <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802423:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802427:	75 17                	jne    802440 <alloc_block_FF+0x4e>
  802429:	83 ec 04             	sub    $0x4,%esp
  80242c:	68 e0 41 80 00       	push   $0x8041e0
  802431:	68 93 00 00 00       	push   $0x93
  802436:	68 37 41 80 00       	push   $0x804137
  80243b:	e8 8e de ff ff       	call   8002ce <_panic>
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	8b 00                	mov    (%eax),%eax
  802445:	85 c0                	test   %eax,%eax
  802447:	74 10                	je     802459 <alloc_block_FF+0x67>
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802451:	8b 52 04             	mov    0x4(%edx),%edx
  802454:	89 50 04             	mov    %edx,0x4(%eax)
  802457:	eb 0b                	jmp    802464 <alloc_block_FF+0x72>
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 40 04             	mov    0x4(%eax),%eax
  80245f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 40 04             	mov    0x4(%eax),%eax
  80246a:	85 c0                	test   %eax,%eax
  80246c:	74 0f                	je     80247d <alloc_block_FF+0x8b>
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 40 04             	mov    0x4(%eax),%eax
  802474:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802477:	8b 12                	mov    (%edx),%edx
  802479:	89 10                	mov    %edx,(%eax)
  80247b:	eb 0a                	jmp    802487 <alloc_block_FF+0x95>
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	a3 38 51 80 00       	mov    %eax,0x805138
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80249a:	a1 44 51 80 00       	mov    0x805144,%eax
  80249f:	48                   	dec    %eax
  8024a0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	e9 10 01 00 00       	jmp    8025bd <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b6:	0f 86 c6 00 00 00    	jbe    802582 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024bc:	a1 48 51 80 00       	mov    0x805148,%eax
  8024c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 50 08             	mov    0x8(%eax),%edx
  8024ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cd:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d6:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024dd:	75 17                	jne    8024f6 <alloc_block_FF+0x104>
  8024df:	83 ec 04             	sub    $0x4,%esp
  8024e2:	68 e0 41 80 00       	push   $0x8041e0
  8024e7:	68 9b 00 00 00       	push   $0x9b
  8024ec:	68 37 41 80 00       	push   $0x804137
  8024f1:	e8 d8 dd ff ff       	call   8002ce <_panic>
  8024f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f9:	8b 00                	mov    (%eax),%eax
  8024fb:	85 c0                	test   %eax,%eax
  8024fd:	74 10                	je     80250f <alloc_block_FF+0x11d>
  8024ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802502:	8b 00                	mov    (%eax),%eax
  802504:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802507:	8b 52 04             	mov    0x4(%edx),%edx
  80250a:	89 50 04             	mov    %edx,0x4(%eax)
  80250d:	eb 0b                	jmp    80251a <alloc_block_FF+0x128>
  80250f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802512:	8b 40 04             	mov    0x4(%eax),%eax
  802515:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80251a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251d:	8b 40 04             	mov    0x4(%eax),%eax
  802520:	85 c0                	test   %eax,%eax
  802522:	74 0f                	je     802533 <alloc_block_FF+0x141>
  802524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802527:	8b 40 04             	mov    0x4(%eax),%eax
  80252a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252d:	8b 12                	mov    (%edx),%edx
  80252f:	89 10                	mov    %edx,(%eax)
  802531:	eb 0a                	jmp    80253d <alloc_block_FF+0x14b>
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802536:	8b 00                	mov    (%eax),%eax
  802538:	a3 48 51 80 00       	mov    %eax,0x805148
  80253d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802550:	a1 54 51 80 00       	mov    0x805154,%eax
  802555:	48                   	dec    %eax
  802556:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 50 08             	mov    0x8(%eax),%edx
  802561:	8b 45 08             	mov    0x8(%ebp),%eax
  802564:	01 c2                	add    %eax,%edx
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 40 0c             	mov    0xc(%eax),%eax
  802572:	2b 45 08             	sub    0x8(%ebp),%eax
  802575:	89 c2                	mov    %eax,%edx
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80257d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802580:	eb 3b                	jmp    8025bd <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802582:	a1 40 51 80 00       	mov    0x805140,%eax
  802587:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258e:	74 07                	je     802597 <alloc_block_FF+0x1a5>
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 00                	mov    (%eax),%eax
  802595:	eb 05                	jmp    80259c <alloc_block_FF+0x1aa>
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
  80259c:	a3 40 51 80 00       	mov    %eax,0x805140
  8025a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	0f 85 57 fe ff ff    	jne    802405 <alloc_block_FF+0x13>
  8025ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b2:	0f 85 4d fe ff ff    	jne    802405 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025bd:	c9                   	leave  
  8025be:	c3                   	ret    

008025bf <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025bf:	55                   	push   %ebp
  8025c0:	89 e5                	mov    %esp,%ebp
  8025c2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025cc:	a1 38 51 80 00       	mov    0x805138,%eax
  8025d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d4:	e9 df 00 00 00       	jmp    8026b8 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e2:	0f 82 c8 00 00 00    	jb     8026b0 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f1:	0f 85 8a 00 00 00    	jne    802681 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fb:	75 17                	jne    802614 <alloc_block_BF+0x55>
  8025fd:	83 ec 04             	sub    $0x4,%esp
  802600:	68 e0 41 80 00       	push   $0x8041e0
  802605:	68 b7 00 00 00       	push   $0xb7
  80260a:	68 37 41 80 00       	push   $0x804137
  80260f:	e8 ba dc ff ff       	call   8002ce <_panic>
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	8b 00                	mov    (%eax),%eax
  802619:	85 c0                	test   %eax,%eax
  80261b:	74 10                	je     80262d <alloc_block_BF+0x6e>
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 00                	mov    (%eax),%eax
  802622:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802625:	8b 52 04             	mov    0x4(%edx),%edx
  802628:	89 50 04             	mov    %edx,0x4(%eax)
  80262b:	eb 0b                	jmp    802638 <alloc_block_BF+0x79>
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 40 04             	mov    0x4(%eax),%eax
  802633:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 40 04             	mov    0x4(%eax),%eax
  80263e:	85 c0                	test   %eax,%eax
  802640:	74 0f                	je     802651 <alloc_block_BF+0x92>
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 40 04             	mov    0x4(%eax),%eax
  802648:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264b:	8b 12                	mov    (%edx),%edx
  80264d:	89 10                	mov    %edx,(%eax)
  80264f:	eb 0a                	jmp    80265b <alloc_block_BF+0x9c>
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 00                	mov    (%eax),%eax
  802656:	a3 38 51 80 00       	mov    %eax,0x805138
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80266e:	a1 44 51 80 00       	mov    0x805144,%eax
  802673:	48                   	dec    %eax
  802674:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	e9 4d 01 00 00       	jmp    8027ce <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	8b 40 0c             	mov    0xc(%eax),%eax
  802687:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268a:	76 24                	jbe    8026b0 <alloc_block_BF+0xf1>
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 40 0c             	mov    0xc(%eax),%eax
  802692:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802695:	73 19                	jae    8026b0 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802697:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 40 08             	mov    0x8(%eax),%eax
  8026ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8026b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bc:	74 07                	je     8026c5 <alloc_block_BF+0x106>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	eb 05                	jmp    8026ca <alloc_block_BF+0x10b>
  8026c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ca:	a3 40 51 80 00       	mov    %eax,0x805140
  8026cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8026d4:	85 c0                	test   %eax,%eax
  8026d6:	0f 85 fd fe ff ff    	jne    8025d9 <alloc_block_BF+0x1a>
  8026dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e0:	0f 85 f3 fe ff ff    	jne    8025d9 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026ea:	0f 84 d9 00 00 00    	je     8027c9 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8026f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026fe:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802704:	8b 55 08             	mov    0x8(%ebp),%edx
  802707:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80270a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80270e:	75 17                	jne    802727 <alloc_block_BF+0x168>
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	68 e0 41 80 00       	push   $0x8041e0
  802718:	68 c7 00 00 00       	push   $0xc7
  80271d:	68 37 41 80 00       	push   $0x804137
  802722:	e8 a7 db ff ff       	call   8002ce <_panic>
  802727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272a:	8b 00                	mov    (%eax),%eax
  80272c:	85 c0                	test   %eax,%eax
  80272e:	74 10                	je     802740 <alloc_block_BF+0x181>
  802730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802733:	8b 00                	mov    (%eax),%eax
  802735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802738:	8b 52 04             	mov    0x4(%edx),%edx
  80273b:	89 50 04             	mov    %edx,0x4(%eax)
  80273e:	eb 0b                	jmp    80274b <alloc_block_BF+0x18c>
  802740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802743:	8b 40 04             	mov    0x4(%eax),%eax
  802746:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80274b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274e:	8b 40 04             	mov    0x4(%eax),%eax
  802751:	85 c0                	test   %eax,%eax
  802753:	74 0f                	je     802764 <alloc_block_BF+0x1a5>
  802755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802758:	8b 40 04             	mov    0x4(%eax),%eax
  80275b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80275e:	8b 12                	mov    (%edx),%edx
  802760:	89 10                	mov    %edx,(%eax)
  802762:	eb 0a                	jmp    80276e <alloc_block_BF+0x1af>
  802764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802767:	8b 00                	mov    (%eax),%eax
  802769:	a3 48 51 80 00       	mov    %eax,0x805148
  80276e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802771:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802781:	a1 54 51 80 00       	mov    0x805154,%eax
  802786:	48                   	dec    %eax
  802787:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80278c:	83 ec 08             	sub    $0x8,%esp
  80278f:	ff 75 ec             	pushl  -0x14(%ebp)
  802792:	68 38 51 80 00       	push   $0x805138
  802797:	e8 71 f9 ff ff       	call   80210d <find_block>
  80279c:	83 c4 10             	add    $0x10,%esp
  80279f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a5:	8b 50 08             	mov    0x8(%eax),%edx
  8027a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ab:	01 c2                	add    %eax,%edx
  8027ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b0:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b9:	2b 45 08             	sub    0x8(%ebp),%eax
  8027bc:	89 c2                	mov    %eax,%edx
  8027be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c1:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c7:	eb 05                	jmp    8027ce <alloc_block_BF+0x20f>
	}
	return NULL;
  8027c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
  8027d3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027d6:	a1 28 50 80 00       	mov    0x805028,%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	0f 85 de 01 00 00    	jne    8029c1 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027e3:	a1 38 51 80 00       	mov    0x805138,%eax
  8027e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027eb:	e9 9e 01 00 00       	jmp    80298e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f9:	0f 82 87 01 00 00    	jb     802986 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 40 0c             	mov    0xc(%eax),%eax
  802805:	3b 45 08             	cmp    0x8(%ebp),%eax
  802808:	0f 85 95 00 00 00    	jne    8028a3 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80280e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802812:	75 17                	jne    80282b <alloc_block_NF+0x5b>
  802814:	83 ec 04             	sub    $0x4,%esp
  802817:	68 e0 41 80 00       	push   $0x8041e0
  80281c:	68 e0 00 00 00       	push   $0xe0
  802821:	68 37 41 80 00       	push   $0x804137
  802826:	e8 a3 da ff ff       	call   8002ce <_panic>
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 00                	mov    (%eax),%eax
  802830:	85 c0                	test   %eax,%eax
  802832:	74 10                	je     802844 <alloc_block_NF+0x74>
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 00                	mov    (%eax),%eax
  802839:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283c:	8b 52 04             	mov    0x4(%edx),%edx
  80283f:	89 50 04             	mov    %edx,0x4(%eax)
  802842:	eb 0b                	jmp    80284f <alloc_block_NF+0x7f>
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 40 04             	mov    0x4(%eax),%eax
  80284a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 40 04             	mov    0x4(%eax),%eax
  802855:	85 c0                	test   %eax,%eax
  802857:	74 0f                	je     802868 <alloc_block_NF+0x98>
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 40 04             	mov    0x4(%eax),%eax
  80285f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802862:	8b 12                	mov    (%edx),%edx
  802864:	89 10                	mov    %edx,(%eax)
  802866:	eb 0a                	jmp    802872 <alloc_block_NF+0xa2>
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 00                	mov    (%eax),%eax
  80286d:	a3 38 51 80 00       	mov    %eax,0x805138
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802885:	a1 44 51 80 00       	mov    0x805144,%eax
  80288a:	48                   	dec    %eax
  80288b:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 08             	mov    0x8(%eax),%eax
  802896:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	e9 f8 04 00 00       	jmp    802d9b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ac:	0f 86 d4 00 00 00    	jbe    802986 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8028b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 50 08             	mov    0x8(%eax),%edx
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028cc:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028d3:	75 17                	jne    8028ec <alloc_block_NF+0x11c>
  8028d5:	83 ec 04             	sub    $0x4,%esp
  8028d8:	68 e0 41 80 00       	push   $0x8041e0
  8028dd:	68 e9 00 00 00       	push   $0xe9
  8028e2:	68 37 41 80 00       	push   $0x804137
  8028e7:	e8 e2 d9 ff ff       	call   8002ce <_panic>
  8028ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	74 10                	je     802905 <alloc_block_NF+0x135>
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028fd:	8b 52 04             	mov    0x4(%edx),%edx
  802900:	89 50 04             	mov    %edx,0x4(%eax)
  802903:	eb 0b                	jmp    802910 <alloc_block_NF+0x140>
  802905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802908:	8b 40 04             	mov    0x4(%eax),%eax
  80290b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802913:	8b 40 04             	mov    0x4(%eax),%eax
  802916:	85 c0                	test   %eax,%eax
  802918:	74 0f                	je     802929 <alloc_block_NF+0x159>
  80291a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291d:	8b 40 04             	mov    0x4(%eax),%eax
  802920:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802923:	8b 12                	mov    (%edx),%edx
  802925:	89 10                	mov    %edx,(%eax)
  802927:	eb 0a                	jmp    802933 <alloc_block_NF+0x163>
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	8b 00                	mov    (%eax),%eax
  80292e:	a3 48 51 80 00       	mov    %eax,0x805148
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802946:	a1 54 51 80 00       	mov    0x805154,%eax
  80294b:	48                   	dec    %eax
  80294c:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802954:	8b 40 08             	mov    0x8(%eax),%eax
  802957:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 50 08             	mov    0x8(%eax),%edx
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	01 c2                	add    %eax,%edx
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	8b 40 0c             	mov    0xc(%eax),%eax
  802973:	2b 45 08             	sub    0x8(%ebp),%eax
  802976:	89 c2                	mov    %eax,%edx
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	e9 15 04 00 00       	jmp    802d9b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802986:	a1 40 51 80 00       	mov    0x805140,%eax
  80298b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80298e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802992:	74 07                	je     80299b <alloc_block_NF+0x1cb>
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 00                	mov    (%eax),%eax
  802999:	eb 05                	jmp    8029a0 <alloc_block_NF+0x1d0>
  80299b:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a0:	a3 40 51 80 00       	mov    %eax,0x805140
  8029a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8029aa:	85 c0                	test   %eax,%eax
  8029ac:	0f 85 3e fe ff ff    	jne    8027f0 <alloc_block_NF+0x20>
  8029b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b6:	0f 85 34 fe ff ff    	jne    8027f0 <alloc_block_NF+0x20>
  8029bc:	e9 d5 03 00 00       	jmp    802d96 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029c1:	a1 38 51 80 00       	mov    0x805138,%eax
  8029c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c9:	e9 b1 01 00 00       	jmp    802b7f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 50 08             	mov    0x8(%eax),%edx
  8029d4:	a1 28 50 80 00       	mov    0x805028,%eax
  8029d9:	39 c2                	cmp    %eax,%edx
  8029db:	0f 82 96 01 00 00    	jb     802b77 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ea:	0f 82 87 01 00 00    	jb     802b77 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f9:	0f 85 95 00 00 00    	jne    802a94 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a03:	75 17                	jne    802a1c <alloc_block_NF+0x24c>
  802a05:	83 ec 04             	sub    $0x4,%esp
  802a08:	68 e0 41 80 00       	push   $0x8041e0
  802a0d:	68 fc 00 00 00       	push   $0xfc
  802a12:	68 37 41 80 00       	push   $0x804137
  802a17:	e8 b2 d8 ff ff       	call   8002ce <_panic>
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 00                	mov    (%eax),%eax
  802a21:	85 c0                	test   %eax,%eax
  802a23:	74 10                	je     802a35 <alloc_block_NF+0x265>
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2d:	8b 52 04             	mov    0x4(%edx),%edx
  802a30:	89 50 04             	mov    %edx,0x4(%eax)
  802a33:	eb 0b                	jmp    802a40 <alloc_block_NF+0x270>
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 40 04             	mov    0x4(%eax),%eax
  802a3b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 40 04             	mov    0x4(%eax),%eax
  802a46:	85 c0                	test   %eax,%eax
  802a48:	74 0f                	je     802a59 <alloc_block_NF+0x289>
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 40 04             	mov    0x4(%eax),%eax
  802a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a53:	8b 12                	mov    (%edx),%edx
  802a55:	89 10                	mov    %edx,(%eax)
  802a57:	eb 0a                	jmp    802a63 <alloc_block_NF+0x293>
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 00                	mov    (%eax),%eax
  802a5e:	a3 38 51 80 00       	mov    %eax,0x805138
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a76:	a1 44 51 80 00       	mov    0x805144,%eax
  802a7b:	48                   	dec    %eax
  802a7c:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 40 08             	mov    0x8(%eax),%eax
  802a87:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	e9 07 03 00 00       	jmp    802d9b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a97:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a9d:	0f 86 d4 00 00 00    	jbe    802b77 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aa3:	a1 48 51 80 00       	mov    0x805148,%eax
  802aa8:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 50 08             	mov    0x8(%eax),%edx
  802ab1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ab7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aba:	8b 55 08             	mov    0x8(%ebp),%edx
  802abd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ac0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ac4:	75 17                	jne    802add <alloc_block_NF+0x30d>
  802ac6:	83 ec 04             	sub    $0x4,%esp
  802ac9:	68 e0 41 80 00       	push   $0x8041e0
  802ace:	68 04 01 00 00       	push   $0x104
  802ad3:	68 37 41 80 00       	push   $0x804137
  802ad8:	e8 f1 d7 ff ff       	call   8002ce <_panic>
  802add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae0:	8b 00                	mov    (%eax),%eax
  802ae2:	85 c0                	test   %eax,%eax
  802ae4:	74 10                	je     802af6 <alloc_block_NF+0x326>
  802ae6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aee:	8b 52 04             	mov    0x4(%edx),%edx
  802af1:	89 50 04             	mov    %edx,0x4(%eax)
  802af4:	eb 0b                	jmp    802b01 <alloc_block_NF+0x331>
  802af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af9:	8b 40 04             	mov    0x4(%eax),%eax
  802afc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 0f                	je     802b1a <alloc_block_NF+0x34a>
  802b0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0e:	8b 40 04             	mov    0x4(%eax),%eax
  802b11:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b14:	8b 12                	mov    (%edx),%edx
  802b16:	89 10                	mov    %edx,(%eax)
  802b18:	eb 0a                	jmp    802b24 <alloc_block_NF+0x354>
  802b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	a3 48 51 80 00       	mov    %eax,0x805148
  802b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b37:	a1 54 51 80 00       	mov    0x805154,%eax
  802b3c:	48                   	dec    %eax
  802b3d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b45:	8b 40 08             	mov    0x8(%eax),%eax
  802b48:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 50 08             	mov    0x8(%eax),%edx
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	01 c2                	add    %eax,%edx
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 40 0c             	mov    0xc(%eax),%eax
  802b64:	2b 45 08             	sub    0x8(%ebp),%eax
  802b67:	89 c2                	mov    %eax,%edx
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b72:	e9 24 02 00 00       	jmp    802d9b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b77:	a1 40 51 80 00       	mov    0x805140,%eax
  802b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b83:	74 07                	je     802b8c <alloc_block_NF+0x3bc>
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	eb 05                	jmp    802b91 <alloc_block_NF+0x3c1>
  802b8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b91:	a3 40 51 80 00       	mov    %eax,0x805140
  802b96:	a1 40 51 80 00       	mov    0x805140,%eax
  802b9b:	85 c0                	test   %eax,%eax
  802b9d:	0f 85 2b fe ff ff    	jne    8029ce <alloc_block_NF+0x1fe>
  802ba3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba7:	0f 85 21 fe ff ff    	jne    8029ce <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bad:	a1 38 51 80 00       	mov    0x805138,%eax
  802bb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb5:	e9 ae 01 00 00       	jmp    802d68 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 50 08             	mov    0x8(%eax),%edx
  802bc0:	a1 28 50 80 00       	mov    0x805028,%eax
  802bc5:	39 c2                	cmp    %eax,%edx
  802bc7:	0f 83 93 01 00 00    	jae    802d60 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd6:	0f 82 84 01 00 00    	jb     802d60 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	8b 40 0c             	mov    0xc(%eax),%eax
  802be2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be5:	0f 85 95 00 00 00    	jne    802c80 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802beb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bef:	75 17                	jne    802c08 <alloc_block_NF+0x438>
  802bf1:	83 ec 04             	sub    $0x4,%esp
  802bf4:	68 e0 41 80 00       	push   $0x8041e0
  802bf9:	68 14 01 00 00       	push   $0x114
  802bfe:	68 37 41 80 00       	push   $0x804137
  802c03:	e8 c6 d6 ff ff       	call   8002ce <_panic>
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	8b 00                	mov    (%eax),%eax
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	74 10                	je     802c21 <alloc_block_NF+0x451>
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 00                	mov    (%eax),%eax
  802c16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c19:	8b 52 04             	mov    0x4(%edx),%edx
  802c1c:	89 50 04             	mov    %edx,0x4(%eax)
  802c1f:	eb 0b                	jmp    802c2c <alloc_block_NF+0x45c>
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 40 04             	mov    0x4(%eax),%eax
  802c27:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 40 04             	mov    0x4(%eax),%eax
  802c32:	85 c0                	test   %eax,%eax
  802c34:	74 0f                	je     802c45 <alloc_block_NF+0x475>
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	8b 40 04             	mov    0x4(%eax),%eax
  802c3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3f:	8b 12                	mov    (%edx),%edx
  802c41:	89 10                	mov    %edx,(%eax)
  802c43:	eb 0a                	jmp    802c4f <alloc_block_NF+0x47f>
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 00                	mov    (%eax),%eax
  802c4a:	a3 38 51 80 00       	mov    %eax,0x805138
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c62:	a1 44 51 80 00       	mov    0x805144,%eax
  802c67:	48                   	dec    %eax
  802c68:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 40 08             	mov    0x8(%eax),%eax
  802c73:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	e9 1b 01 00 00       	jmp    802d9b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 40 0c             	mov    0xc(%eax),%eax
  802c86:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c89:	0f 86 d1 00 00 00    	jbe    802d60 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c8f:	a1 48 51 80 00       	mov    0x805148,%eax
  802c94:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 50 08             	mov    0x8(%eax),%edx
  802c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cb0:	75 17                	jne    802cc9 <alloc_block_NF+0x4f9>
  802cb2:	83 ec 04             	sub    $0x4,%esp
  802cb5:	68 e0 41 80 00       	push   $0x8041e0
  802cba:	68 1c 01 00 00       	push   $0x11c
  802cbf:	68 37 41 80 00       	push   $0x804137
  802cc4:	e8 05 d6 ff ff       	call   8002ce <_panic>
  802cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccc:	8b 00                	mov    (%eax),%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	74 10                	je     802ce2 <alloc_block_NF+0x512>
  802cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cda:	8b 52 04             	mov    0x4(%edx),%edx
  802cdd:	89 50 04             	mov    %edx,0x4(%eax)
  802ce0:	eb 0b                	jmp    802ced <alloc_block_NF+0x51d>
  802ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce5:	8b 40 04             	mov    0x4(%eax),%eax
  802ce8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ced:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	85 c0                	test   %eax,%eax
  802cf5:	74 0f                	je     802d06 <alloc_block_NF+0x536>
  802cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfa:	8b 40 04             	mov    0x4(%eax),%eax
  802cfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d00:	8b 12                	mov    (%edx),%edx
  802d02:	89 10                	mov    %edx,(%eax)
  802d04:	eb 0a                	jmp    802d10 <alloc_block_NF+0x540>
  802d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d09:	8b 00                	mov    (%eax),%eax
  802d0b:	a3 48 51 80 00       	mov    %eax,0x805148
  802d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d23:	a1 54 51 80 00       	mov    0x805154,%eax
  802d28:	48                   	dec    %eax
  802d29:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d31:	8b 40 08             	mov    0x8(%eax),%eax
  802d34:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	8b 50 08             	mov    0x8(%eax),%edx
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	01 c2                	add    %eax,%edx
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d50:	2b 45 08             	sub    0x8(%ebp),%eax
  802d53:	89 c2                	mov    %eax,%edx
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5e:	eb 3b                	jmp    802d9b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d60:	a1 40 51 80 00       	mov    0x805140,%eax
  802d65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6c:	74 07                	je     802d75 <alloc_block_NF+0x5a5>
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 00                	mov    (%eax),%eax
  802d73:	eb 05                	jmp    802d7a <alloc_block_NF+0x5aa>
  802d75:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7a:	a3 40 51 80 00       	mov    %eax,0x805140
  802d7f:	a1 40 51 80 00       	mov    0x805140,%eax
  802d84:	85 c0                	test   %eax,%eax
  802d86:	0f 85 2e fe ff ff    	jne    802bba <alloc_block_NF+0x3ea>
  802d8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d90:	0f 85 24 fe ff ff    	jne    802bba <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d9b:	c9                   	leave  
  802d9c:	c3                   	ret    

00802d9d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d9d:	55                   	push   %ebp
  802d9e:	89 e5                	mov    %esp,%ebp
  802da0:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802da3:	a1 38 51 80 00       	mov    0x805138,%eax
  802da8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802dab:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802db0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802db3:	a1 38 51 80 00       	mov    0x805138,%eax
  802db8:	85 c0                	test   %eax,%eax
  802dba:	74 14                	je     802dd0 <insert_sorted_with_merge_freeList+0x33>
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	8b 50 08             	mov    0x8(%eax),%edx
  802dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc5:	8b 40 08             	mov    0x8(%eax),%eax
  802dc8:	39 c2                	cmp    %eax,%edx
  802dca:	0f 87 9b 01 00 00    	ja     802f6b <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802dd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd4:	75 17                	jne    802ded <insert_sorted_with_merge_freeList+0x50>
  802dd6:	83 ec 04             	sub    $0x4,%esp
  802dd9:	68 14 41 80 00       	push   $0x804114
  802dde:	68 38 01 00 00       	push   $0x138
  802de3:	68 37 41 80 00       	push   $0x804137
  802de8:	e8 e1 d4 ff ff       	call   8002ce <_panic>
  802ded:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	89 10                	mov    %edx,(%eax)
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	8b 00                	mov    (%eax),%eax
  802dfd:	85 c0                	test   %eax,%eax
  802dff:	74 0d                	je     802e0e <insert_sorted_with_merge_freeList+0x71>
  802e01:	a1 38 51 80 00       	mov    0x805138,%eax
  802e06:	8b 55 08             	mov    0x8(%ebp),%edx
  802e09:	89 50 04             	mov    %edx,0x4(%eax)
  802e0c:	eb 08                	jmp    802e16 <insert_sorted_with_merge_freeList+0x79>
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	a3 38 51 80 00       	mov    %eax,0x805138
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e28:	a1 44 51 80 00       	mov    0x805144,%eax
  802e2d:	40                   	inc    %eax
  802e2e:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e37:	0f 84 a8 06 00 00    	je     8034e5 <insert_sorted_with_merge_freeList+0x748>
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	8b 50 08             	mov    0x8(%eax),%edx
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	8b 40 0c             	mov    0xc(%eax),%eax
  802e49:	01 c2                	add    %eax,%edx
  802e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4e:	8b 40 08             	mov    0x8(%eax),%eax
  802e51:	39 c2                	cmp    %eax,%edx
  802e53:	0f 85 8c 06 00 00    	jne    8034e5 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e59:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e62:	8b 40 0c             	mov    0xc(%eax),%eax
  802e65:	01 c2                	add    %eax,%edx
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e71:	75 17                	jne    802e8a <insert_sorted_with_merge_freeList+0xed>
  802e73:	83 ec 04             	sub    $0x4,%esp
  802e76:	68 e0 41 80 00       	push   $0x8041e0
  802e7b:	68 3c 01 00 00       	push   $0x13c
  802e80:	68 37 41 80 00       	push   $0x804137
  802e85:	e8 44 d4 ff ff       	call   8002ce <_panic>
  802e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8d:	8b 00                	mov    (%eax),%eax
  802e8f:	85 c0                	test   %eax,%eax
  802e91:	74 10                	je     802ea3 <insert_sorted_with_merge_freeList+0x106>
  802e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e96:	8b 00                	mov    (%eax),%eax
  802e98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e9b:	8b 52 04             	mov    0x4(%edx),%edx
  802e9e:	89 50 04             	mov    %edx,0x4(%eax)
  802ea1:	eb 0b                	jmp    802eae <insert_sorted_with_merge_freeList+0x111>
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	8b 40 04             	mov    0x4(%eax),%eax
  802ea9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb1:	8b 40 04             	mov    0x4(%eax),%eax
  802eb4:	85 c0                	test   %eax,%eax
  802eb6:	74 0f                	je     802ec7 <insert_sorted_with_merge_freeList+0x12a>
  802eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebb:	8b 40 04             	mov    0x4(%eax),%eax
  802ebe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec1:	8b 12                	mov    (%edx),%edx
  802ec3:	89 10                	mov    %edx,(%eax)
  802ec5:	eb 0a                	jmp    802ed1 <insert_sorted_with_merge_freeList+0x134>
  802ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	a3 38 51 80 00       	mov    %eax,0x805138
  802ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee4:	a1 44 51 80 00       	mov    0x805144,%eax
  802ee9:	48                   	dec    %eax
  802eea:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f07:	75 17                	jne    802f20 <insert_sorted_with_merge_freeList+0x183>
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 14 41 80 00       	push   $0x804114
  802f11:	68 3f 01 00 00       	push   $0x13f
  802f16:	68 37 41 80 00       	push   $0x804137
  802f1b:	e8 ae d3 ff ff       	call   8002ce <_panic>
  802f20:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f29:	89 10                	mov    %edx,(%eax)
  802f2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	85 c0                	test   %eax,%eax
  802f32:	74 0d                	je     802f41 <insert_sorted_with_merge_freeList+0x1a4>
  802f34:	a1 48 51 80 00       	mov    0x805148,%eax
  802f39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f3c:	89 50 04             	mov    %edx,0x4(%eax)
  802f3f:	eb 08                	jmp    802f49 <insert_sorted_with_merge_freeList+0x1ac>
  802f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f44:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4c:	a3 48 51 80 00       	mov    %eax,0x805148
  802f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5b:	a1 54 51 80 00       	mov    0x805154,%eax
  802f60:	40                   	inc    %eax
  802f61:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f66:	e9 7a 05 00 00       	jmp    8034e5 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	8b 50 08             	mov    0x8(%eax),%edx
  802f71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f74:	8b 40 08             	mov    0x8(%eax),%eax
  802f77:	39 c2                	cmp    %eax,%edx
  802f79:	0f 82 14 01 00 00    	jb     803093 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f82:	8b 50 08             	mov    0x8(%eax),%edx
  802f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f88:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8b:	01 c2                	add    %eax,%edx
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 40 08             	mov    0x8(%eax),%eax
  802f93:	39 c2                	cmp    %eax,%edx
  802f95:	0f 85 90 00 00 00    	jne    80302b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9e:	8b 50 0c             	mov    0xc(%eax),%edx
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa7:	01 c2                	add    %eax,%edx
  802fa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fac:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc7:	75 17                	jne    802fe0 <insert_sorted_with_merge_freeList+0x243>
  802fc9:	83 ec 04             	sub    $0x4,%esp
  802fcc:	68 14 41 80 00       	push   $0x804114
  802fd1:	68 49 01 00 00       	push   $0x149
  802fd6:	68 37 41 80 00       	push   $0x804137
  802fdb:	e8 ee d2 ff ff       	call   8002ce <_panic>
  802fe0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe9:	89 10                	mov    %edx,(%eax)
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	74 0d                	je     803001 <insert_sorted_with_merge_freeList+0x264>
  802ff4:	a1 48 51 80 00       	mov    0x805148,%eax
  802ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffc:	89 50 04             	mov    %edx,0x4(%eax)
  802fff:	eb 08                	jmp    803009 <insert_sorted_with_merge_freeList+0x26c>
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	a3 48 51 80 00       	mov    %eax,0x805148
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301b:	a1 54 51 80 00       	mov    0x805154,%eax
  803020:	40                   	inc    %eax
  803021:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803026:	e9 bb 04 00 00       	jmp    8034e6 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80302b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302f:	75 17                	jne    803048 <insert_sorted_with_merge_freeList+0x2ab>
  803031:	83 ec 04             	sub    $0x4,%esp
  803034:	68 88 41 80 00       	push   $0x804188
  803039:	68 4c 01 00 00       	push   $0x14c
  80303e:	68 37 41 80 00       	push   $0x804137
  803043:	e8 86 d2 ff ff       	call   8002ce <_panic>
  803048:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	89 50 04             	mov    %edx,0x4(%eax)
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	74 0c                	je     80306a <insert_sorted_with_merge_freeList+0x2cd>
  80305e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803063:	8b 55 08             	mov    0x8(%ebp),%edx
  803066:	89 10                	mov    %edx,(%eax)
  803068:	eb 08                	jmp    803072 <insert_sorted_with_merge_freeList+0x2d5>
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	a3 38 51 80 00       	mov    %eax,0x805138
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803083:	a1 44 51 80 00       	mov    0x805144,%eax
  803088:	40                   	inc    %eax
  803089:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80308e:	e9 53 04 00 00       	jmp    8034e6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803093:	a1 38 51 80 00       	mov    0x805138,%eax
  803098:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80309b:	e9 15 04 00 00       	jmp    8034b5 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	8b 50 08             	mov    0x8(%eax),%edx
  8030ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b1:	8b 40 08             	mov    0x8(%eax),%eax
  8030b4:	39 c2                	cmp    %eax,%edx
  8030b6:	0f 86 f1 03 00 00    	jbe    8034ad <insert_sorted_with_merge_freeList+0x710>
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	8b 50 08             	mov    0x8(%eax),%edx
  8030c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c5:	8b 40 08             	mov    0x8(%eax),%eax
  8030c8:	39 c2                	cmp    %eax,%edx
  8030ca:	0f 83 dd 03 00 00    	jae    8034ad <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	8b 50 08             	mov    0x8(%eax),%edx
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030dc:	01 c2                	add    %eax,%edx
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	8b 40 08             	mov    0x8(%eax),%eax
  8030e4:	39 c2                	cmp    %eax,%edx
  8030e6:	0f 85 b9 01 00 00    	jne    8032a5 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	8b 50 08             	mov    0x8(%eax),%edx
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f8:	01 c2                	add    %eax,%edx
  8030fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fd:	8b 40 08             	mov    0x8(%eax),%eax
  803100:	39 c2                	cmp    %eax,%edx
  803102:	0f 85 0d 01 00 00    	jne    803215 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	8b 50 0c             	mov    0xc(%eax),%edx
  80310e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803111:	8b 40 0c             	mov    0xc(%eax),%eax
  803114:	01 c2                	add    %eax,%edx
  803116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803119:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80311c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803120:	75 17                	jne    803139 <insert_sorted_with_merge_freeList+0x39c>
  803122:	83 ec 04             	sub    $0x4,%esp
  803125:	68 e0 41 80 00       	push   $0x8041e0
  80312a:	68 5c 01 00 00       	push   $0x15c
  80312f:	68 37 41 80 00       	push   $0x804137
  803134:	e8 95 d1 ff ff       	call   8002ce <_panic>
  803139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	74 10                	je     803152 <insert_sorted_with_merge_freeList+0x3b5>
  803142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80314a:	8b 52 04             	mov    0x4(%edx),%edx
  80314d:	89 50 04             	mov    %edx,0x4(%eax)
  803150:	eb 0b                	jmp    80315d <insert_sorted_with_merge_freeList+0x3c0>
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	8b 40 04             	mov    0x4(%eax),%eax
  803158:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80315d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803160:	8b 40 04             	mov    0x4(%eax),%eax
  803163:	85 c0                	test   %eax,%eax
  803165:	74 0f                	je     803176 <insert_sorted_with_merge_freeList+0x3d9>
  803167:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316a:	8b 40 04             	mov    0x4(%eax),%eax
  80316d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803170:	8b 12                	mov    (%edx),%edx
  803172:	89 10                	mov    %edx,(%eax)
  803174:	eb 0a                	jmp    803180 <insert_sorted_with_merge_freeList+0x3e3>
  803176:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803179:	8b 00                	mov    (%eax),%eax
  80317b:	a3 38 51 80 00       	mov    %eax,0x805138
  803180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803183:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803193:	a1 44 51 80 00       	mov    0x805144,%eax
  803198:	48                   	dec    %eax
  803199:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80319e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031b6:	75 17                	jne    8031cf <insert_sorted_with_merge_freeList+0x432>
  8031b8:	83 ec 04             	sub    $0x4,%esp
  8031bb:	68 14 41 80 00       	push   $0x804114
  8031c0:	68 5f 01 00 00       	push   $0x15f
  8031c5:	68 37 41 80 00       	push   $0x804137
  8031ca:	e8 ff d0 ff ff       	call   8002ce <_panic>
  8031cf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d8:	89 10                	mov    %edx,(%eax)
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	85 c0                	test   %eax,%eax
  8031e1:	74 0d                	je     8031f0 <insert_sorted_with_merge_freeList+0x453>
  8031e3:	a1 48 51 80 00       	mov    0x805148,%eax
  8031e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031eb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ee:	eb 08                	jmp    8031f8 <insert_sorted_with_merge_freeList+0x45b>
  8031f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fb:	a3 48 51 80 00       	mov    %eax,0x805148
  803200:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803203:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320a:	a1 54 51 80 00       	mov    0x805154,%eax
  80320f:	40                   	inc    %eax
  803210:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803218:	8b 50 0c             	mov    0xc(%eax),%edx
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	8b 40 0c             	mov    0xc(%eax),%eax
  803221:	01 c2                	add    %eax,%edx
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803233:	8b 45 08             	mov    0x8(%ebp),%eax
  803236:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80323d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803241:	75 17                	jne    80325a <insert_sorted_with_merge_freeList+0x4bd>
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	68 14 41 80 00       	push   $0x804114
  80324b:	68 64 01 00 00       	push   $0x164
  803250:	68 37 41 80 00       	push   $0x804137
  803255:	e8 74 d0 ff ff       	call   8002ce <_panic>
  80325a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803260:	8b 45 08             	mov    0x8(%ebp),%eax
  803263:	89 10                	mov    %edx,(%eax)
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	8b 00                	mov    (%eax),%eax
  80326a:	85 c0                	test   %eax,%eax
  80326c:	74 0d                	je     80327b <insert_sorted_with_merge_freeList+0x4de>
  80326e:	a1 48 51 80 00       	mov    0x805148,%eax
  803273:	8b 55 08             	mov    0x8(%ebp),%edx
  803276:	89 50 04             	mov    %edx,0x4(%eax)
  803279:	eb 08                	jmp    803283 <insert_sorted_with_merge_freeList+0x4e6>
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	a3 48 51 80 00       	mov    %eax,0x805148
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803295:	a1 54 51 80 00       	mov    0x805154,%eax
  80329a:	40                   	inc    %eax
  80329b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032a0:	e9 41 02 00 00       	jmp    8034e6 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	8b 50 08             	mov    0x8(%eax),%edx
  8032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b1:	01 c2                	add    %eax,%edx
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	8b 40 08             	mov    0x8(%eax),%eax
  8032b9:	39 c2                	cmp    %eax,%edx
  8032bb:	0f 85 7c 01 00 00    	jne    80343d <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032c5:	74 06                	je     8032cd <insert_sorted_with_merge_freeList+0x530>
  8032c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032cb:	75 17                	jne    8032e4 <insert_sorted_with_merge_freeList+0x547>
  8032cd:	83 ec 04             	sub    $0x4,%esp
  8032d0:	68 50 41 80 00       	push   $0x804150
  8032d5:	68 69 01 00 00       	push   $0x169
  8032da:	68 37 41 80 00       	push   $0x804137
  8032df:	e8 ea cf ff ff       	call   8002ce <_panic>
  8032e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e7:	8b 50 04             	mov    0x4(%eax),%edx
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	89 50 04             	mov    %edx,0x4(%eax)
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f6:	89 10                	mov    %edx,(%eax)
  8032f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fb:	8b 40 04             	mov    0x4(%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	74 0d                	je     80330f <insert_sorted_with_merge_freeList+0x572>
  803302:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803305:	8b 40 04             	mov    0x4(%eax),%eax
  803308:	8b 55 08             	mov    0x8(%ebp),%edx
  80330b:	89 10                	mov    %edx,(%eax)
  80330d:	eb 08                	jmp    803317 <insert_sorted_with_merge_freeList+0x57a>
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	a3 38 51 80 00       	mov    %eax,0x805138
  803317:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331a:	8b 55 08             	mov    0x8(%ebp),%edx
  80331d:	89 50 04             	mov    %edx,0x4(%eax)
  803320:	a1 44 51 80 00       	mov    0x805144,%eax
  803325:	40                   	inc    %eax
  803326:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	8b 50 0c             	mov    0xc(%eax),%edx
  803331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803334:	8b 40 0c             	mov    0xc(%eax),%eax
  803337:	01 c2                	add    %eax,%edx
  803339:	8b 45 08             	mov    0x8(%ebp),%eax
  80333c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80333f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803343:	75 17                	jne    80335c <insert_sorted_with_merge_freeList+0x5bf>
  803345:	83 ec 04             	sub    $0x4,%esp
  803348:	68 e0 41 80 00       	push   $0x8041e0
  80334d:	68 6b 01 00 00       	push   $0x16b
  803352:	68 37 41 80 00       	push   $0x804137
  803357:	e8 72 cf ff ff       	call   8002ce <_panic>
  80335c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335f:	8b 00                	mov    (%eax),%eax
  803361:	85 c0                	test   %eax,%eax
  803363:	74 10                	je     803375 <insert_sorted_with_merge_freeList+0x5d8>
  803365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803368:	8b 00                	mov    (%eax),%eax
  80336a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80336d:	8b 52 04             	mov    0x4(%edx),%edx
  803370:	89 50 04             	mov    %edx,0x4(%eax)
  803373:	eb 0b                	jmp    803380 <insert_sorted_with_merge_freeList+0x5e3>
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	8b 40 04             	mov    0x4(%eax),%eax
  80337b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803380:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803383:	8b 40 04             	mov    0x4(%eax),%eax
  803386:	85 c0                	test   %eax,%eax
  803388:	74 0f                	je     803399 <insert_sorted_with_merge_freeList+0x5fc>
  80338a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338d:	8b 40 04             	mov    0x4(%eax),%eax
  803390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803393:	8b 12                	mov    (%edx),%edx
  803395:	89 10                	mov    %edx,(%eax)
  803397:	eb 0a                	jmp    8033a3 <insert_sorted_with_merge_freeList+0x606>
  803399:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339c:	8b 00                	mov    (%eax),%eax
  80339e:	a3 38 51 80 00       	mov    %eax,0x805138
  8033a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b6:	a1 44 51 80 00       	mov    0x805144,%eax
  8033bb:	48                   	dec    %eax
  8033bc:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033d9:	75 17                	jne    8033f2 <insert_sorted_with_merge_freeList+0x655>
  8033db:	83 ec 04             	sub    $0x4,%esp
  8033de:	68 14 41 80 00       	push   $0x804114
  8033e3:	68 6e 01 00 00       	push   $0x16e
  8033e8:	68 37 41 80 00       	push   $0x804137
  8033ed:	e8 dc ce ff ff       	call   8002ce <_panic>
  8033f2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fb:	89 10                	mov    %edx,(%eax)
  8033fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803400:	8b 00                	mov    (%eax),%eax
  803402:	85 c0                	test   %eax,%eax
  803404:	74 0d                	je     803413 <insert_sorted_with_merge_freeList+0x676>
  803406:	a1 48 51 80 00       	mov    0x805148,%eax
  80340b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80340e:	89 50 04             	mov    %edx,0x4(%eax)
  803411:	eb 08                	jmp    80341b <insert_sorted_with_merge_freeList+0x67e>
  803413:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803416:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80341b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341e:	a3 48 51 80 00       	mov    %eax,0x805148
  803423:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803426:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342d:	a1 54 51 80 00       	mov    0x805154,%eax
  803432:	40                   	inc    %eax
  803433:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803438:	e9 a9 00 00 00       	jmp    8034e6 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80343d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803441:	74 06                	je     803449 <insert_sorted_with_merge_freeList+0x6ac>
  803443:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803447:	75 17                	jne    803460 <insert_sorted_with_merge_freeList+0x6c3>
  803449:	83 ec 04             	sub    $0x4,%esp
  80344c:	68 ac 41 80 00       	push   $0x8041ac
  803451:	68 73 01 00 00       	push   $0x173
  803456:	68 37 41 80 00       	push   $0x804137
  80345b:	e8 6e ce ff ff       	call   8002ce <_panic>
  803460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803463:	8b 10                	mov    (%eax),%edx
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	89 10                	mov    %edx,(%eax)
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	8b 00                	mov    (%eax),%eax
  80346f:	85 c0                	test   %eax,%eax
  803471:	74 0b                	je     80347e <insert_sorted_with_merge_freeList+0x6e1>
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	8b 00                	mov    (%eax),%eax
  803478:	8b 55 08             	mov    0x8(%ebp),%edx
  80347b:	89 50 04             	mov    %edx,0x4(%eax)
  80347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803481:	8b 55 08             	mov    0x8(%ebp),%edx
  803484:	89 10                	mov    %edx,(%eax)
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80348c:	89 50 04             	mov    %edx,0x4(%eax)
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	8b 00                	mov    (%eax),%eax
  803494:	85 c0                	test   %eax,%eax
  803496:	75 08                	jne    8034a0 <insert_sorted_with_merge_freeList+0x703>
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8034a5:	40                   	inc    %eax
  8034a6:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034ab:	eb 39                	jmp    8034e6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034ad:	a1 40 51 80 00       	mov    0x805140,%eax
  8034b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b9:	74 07                	je     8034c2 <insert_sorted_with_merge_freeList+0x725>
  8034bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034be:	8b 00                	mov    (%eax),%eax
  8034c0:	eb 05                	jmp    8034c7 <insert_sorted_with_merge_freeList+0x72a>
  8034c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c7:	a3 40 51 80 00       	mov    %eax,0x805140
  8034cc:	a1 40 51 80 00       	mov    0x805140,%eax
  8034d1:	85 c0                	test   %eax,%eax
  8034d3:	0f 85 c7 fb ff ff    	jne    8030a0 <insert_sorted_with_merge_freeList+0x303>
  8034d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034dd:	0f 85 bd fb ff ff    	jne    8030a0 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034e3:	eb 01                	jmp    8034e6 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034e5:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034e6:	90                   	nop
  8034e7:	c9                   	leave  
  8034e8:	c3                   	ret    

008034e9 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8034e9:	55                   	push   %ebp
  8034ea:	89 e5                	mov    %esp,%ebp
  8034ec:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8034ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f2:	89 d0                	mov    %edx,%eax
  8034f4:	c1 e0 02             	shl    $0x2,%eax
  8034f7:	01 d0                	add    %edx,%eax
  8034f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803500:	01 d0                	add    %edx,%eax
  803502:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803509:	01 d0                	add    %edx,%eax
  80350b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803512:	01 d0                	add    %edx,%eax
  803514:	c1 e0 04             	shl    $0x4,%eax
  803517:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80351a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803521:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803524:	83 ec 0c             	sub    $0xc,%esp
  803527:	50                   	push   %eax
  803528:	e8 26 e7 ff ff       	call   801c53 <sys_get_virtual_time>
  80352d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803530:	eb 41                	jmp    803573 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803532:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803535:	83 ec 0c             	sub    $0xc,%esp
  803538:	50                   	push   %eax
  803539:	e8 15 e7 ff ff       	call   801c53 <sys_get_virtual_time>
  80353e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803541:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803544:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803547:	29 c2                	sub    %eax,%edx
  803549:	89 d0                	mov    %edx,%eax
  80354b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80354e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803551:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803554:	89 d1                	mov    %edx,%ecx
  803556:	29 c1                	sub    %eax,%ecx
  803558:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80355b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80355e:	39 c2                	cmp    %eax,%edx
  803560:	0f 97 c0             	seta   %al
  803563:	0f b6 c0             	movzbl %al,%eax
  803566:	29 c1                	sub    %eax,%ecx
  803568:	89 c8                	mov    %ecx,%eax
  80356a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80356d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803570:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803576:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803579:	72 b7                	jb     803532 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80357b:	90                   	nop
  80357c:	c9                   	leave  
  80357d:	c3                   	ret    

0080357e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80357e:	55                   	push   %ebp
  80357f:	89 e5                	mov    %esp,%ebp
  803581:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803584:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80358b:	eb 03                	jmp    803590 <busy_wait+0x12>
  80358d:	ff 45 fc             	incl   -0x4(%ebp)
  803590:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803593:	3b 45 08             	cmp    0x8(%ebp),%eax
  803596:	72 f5                	jb     80358d <busy_wait+0xf>
	return i;
  803598:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80359b:	c9                   	leave  
  80359c:	c3                   	ret    
  80359d:	66 90                	xchg   %ax,%ax
  80359f:	90                   	nop

008035a0 <__udivdi3>:
  8035a0:	55                   	push   %ebp
  8035a1:	57                   	push   %edi
  8035a2:	56                   	push   %esi
  8035a3:	53                   	push   %ebx
  8035a4:	83 ec 1c             	sub    $0x1c,%esp
  8035a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035b7:	89 ca                	mov    %ecx,%edx
  8035b9:	89 f8                	mov    %edi,%eax
  8035bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035bf:	85 f6                	test   %esi,%esi
  8035c1:	75 2d                	jne    8035f0 <__udivdi3+0x50>
  8035c3:	39 cf                	cmp    %ecx,%edi
  8035c5:	77 65                	ja     80362c <__udivdi3+0x8c>
  8035c7:	89 fd                	mov    %edi,%ebp
  8035c9:	85 ff                	test   %edi,%edi
  8035cb:	75 0b                	jne    8035d8 <__udivdi3+0x38>
  8035cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8035d2:	31 d2                	xor    %edx,%edx
  8035d4:	f7 f7                	div    %edi
  8035d6:	89 c5                	mov    %eax,%ebp
  8035d8:	31 d2                	xor    %edx,%edx
  8035da:	89 c8                	mov    %ecx,%eax
  8035dc:	f7 f5                	div    %ebp
  8035de:	89 c1                	mov    %eax,%ecx
  8035e0:	89 d8                	mov    %ebx,%eax
  8035e2:	f7 f5                	div    %ebp
  8035e4:	89 cf                	mov    %ecx,%edi
  8035e6:	89 fa                	mov    %edi,%edx
  8035e8:	83 c4 1c             	add    $0x1c,%esp
  8035eb:	5b                   	pop    %ebx
  8035ec:	5e                   	pop    %esi
  8035ed:	5f                   	pop    %edi
  8035ee:	5d                   	pop    %ebp
  8035ef:	c3                   	ret    
  8035f0:	39 ce                	cmp    %ecx,%esi
  8035f2:	77 28                	ja     80361c <__udivdi3+0x7c>
  8035f4:	0f bd fe             	bsr    %esi,%edi
  8035f7:	83 f7 1f             	xor    $0x1f,%edi
  8035fa:	75 40                	jne    80363c <__udivdi3+0x9c>
  8035fc:	39 ce                	cmp    %ecx,%esi
  8035fe:	72 0a                	jb     80360a <__udivdi3+0x6a>
  803600:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803604:	0f 87 9e 00 00 00    	ja     8036a8 <__udivdi3+0x108>
  80360a:	b8 01 00 00 00       	mov    $0x1,%eax
  80360f:	89 fa                	mov    %edi,%edx
  803611:	83 c4 1c             	add    $0x1c,%esp
  803614:	5b                   	pop    %ebx
  803615:	5e                   	pop    %esi
  803616:	5f                   	pop    %edi
  803617:	5d                   	pop    %ebp
  803618:	c3                   	ret    
  803619:	8d 76 00             	lea    0x0(%esi),%esi
  80361c:	31 ff                	xor    %edi,%edi
  80361e:	31 c0                	xor    %eax,%eax
  803620:	89 fa                	mov    %edi,%edx
  803622:	83 c4 1c             	add    $0x1c,%esp
  803625:	5b                   	pop    %ebx
  803626:	5e                   	pop    %esi
  803627:	5f                   	pop    %edi
  803628:	5d                   	pop    %ebp
  803629:	c3                   	ret    
  80362a:	66 90                	xchg   %ax,%ax
  80362c:	89 d8                	mov    %ebx,%eax
  80362e:	f7 f7                	div    %edi
  803630:	31 ff                	xor    %edi,%edi
  803632:	89 fa                	mov    %edi,%edx
  803634:	83 c4 1c             	add    $0x1c,%esp
  803637:	5b                   	pop    %ebx
  803638:	5e                   	pop    %esi
  803639:	5f                   	pop    %edi
  80363a:	5d                   	pop    %ebp
  80363b:	c3                   	ret    
  80363c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803641:	89 eb                	mov    %ebp,%ebx
  803643:	29 fb                	sub    %edi,%ebx
  803645:	89 f9                	mov    %edi,%ecx
  803647:	d3 e6                	shl    %cl,%esi
  803649:	89 c5                	mov    %eax,%ebp
  80364b:	88 d9                	mov    %bl,%cl
  80364d:	d3 ed                	shr    %cl,%ebp
  80364f:	89 e9                	mov    %ebp,%ecx
  803651:	09 f1                	or     %esi,%ecx
  803653:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803657:	89 f9                	mov    %edi,%ecx
  803659:	d3 e0                	shl    %cl,%eax
  80365b:	89 c5                	mov    %eax,%ebp
  80365d:	89 d6                	mov    %edx,%esi
  80365f:	88 d9                	mov    %bl,%cl
  803661:	d3 ee                	shr    %cl,%esi
  803663:	89 f9                	mov    %edi,%ecx
  803665:	d3 e2                	shl    %cl,%edx
  803667:	8b 44 24 08          	mov    0x8(%esp),%eax
  80366b:	88 d9                	mov    %bl,%cl
  80366d:	d3 e8                	shr    %cl,%eax
  80366f:	09 c2                	or     %eax,%edx
  803671:	89 d0                	mov    %edx,%eax
  803673:	89 f2                	mov    %esi,%edx
  803675:	f7 74 24 0c          	divl   0xc(%esp)
  803679:	89 d6                	mov    %edx,%esi
  80367b:	89 c3                	mov    %eax,%ebx
  80367d:	f7 e5                	mul    %ebp
  80367f:	39 d6                	cmp    %edx,%esi
  803681:	72 19                	jb     80369c <__udivdi3+0xfc>
  803683:	74 0b                	je     803690 <__udivdi3+0xf0>
  803685:	89 d8                	mov    %ebx,%eax
  803687:	31 ff                	xor    %edi,%edi
  803689:	e9 58 ff ff ff       	jmp    8035e6 <__udivdi3+0x46>
  80368e:	66 90                	xchg   %ax,%ax
  803690:	8b 54 24 08          	mov    0x8(%esp),%edx
  803694:	89 f9                	mov    %edi,%ecx
  803696:	d3 e2                	shl    %cl,%edx
  803698:	39 c2                	cmp    %eax,%edx
  80369a:	73 e9                	jae    803685 <__udivdi3+0xe5>
  80369c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80369f:	31 ff                	xor    %edi,%edi
  8036a1:	e9 40 ff ff ff       	jmp    8035e6 <__udivdi3+0x46>
  8036a6:	66 90                	xchg   %ax,%ax
  8036a8:	31 c0                	xor    %eax,%eax
  8036aa:	e9 37 ff ff ff       	jmp    8035e6 <__udivdi3+0x46>
  8036af:	90                   	nop

008036b0 <__umoddi3>:
  8036b0:	55                   	push   %ebp
  8036b1:	57                   	push   %edi
  8036b2:	56                   	push   %esi
  8036b3:	53                   	push   %ebx
  8036b4:	83 ec 1c             	sub    $0x1c,%esp
  8036b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036cf:	89 f3                	mov    %esi,%ebx
  8036d1:	89 fa                	mov    %edi,%edx
  8036d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036d7:	89 34 24             	mov    %esi,(%esp)
  8036da:	85 c0                	test   %eax,%eax
  8036dc:	75 1a                	jne    8036f8 <__umoddi3+0x48>
  8036de:	39 f7                	cmp    %esi,%edi
  8036e0:	0f 86 a2 00 00 00    	jbe    803788 <__umoddi3+0xd8>
  8036e6:	89 c8                	mov    %ecx,%eax
  8036e8:	89 f2                	mov    %esi,%edx
  8036ea:	f7 f7                	div    %edi
  8036ec:	89 d0                	mov    %edx,%eax
  8036ee:	31 d2                	xor    %edx,%edx
  8036f0:	83 c4 1c             	add    $0x1c,%esp
  8036f3:	5b                   	pop    %ebx
  8036f4:	5e                   	pop    %esi
  8036f5:	5f                   	pop    %edi
  8036f6:	5d                   	pop    %ebp
  8036f7:	c3                   	ret    
  8036f8:	39 f0                	cmp    %esi,%eax
  8036fa:	0f 87 ac 00 00 00    	ja     8037ac <__umoddi3+0xfc>
  803700:	0f bd e8             	bsr    %eax,%ebp
  803703:	83 f5 1f             	xor    $0x1f,%ebp
  803706:	0f 84 ac 00 00 00    	je     8037b8 <__umoddi3+0x108>
  80370c:	bf 20 00 00 00       	mov    $0x20,%edi
  803711:	29 ef                	sub    %ebp,%edi
  803713:	89 fe                	mov    %edi,%esi
  803715:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803719:	89 e9                	mov    %ebp,%ecx
  80371b:	d3 e0                	shl    %cl,%eax
  80371d:	89 d7                	mov    %edx,%edi
  80371f:	89 f1                	mov    %esi,%ecx
  803721:	d3 ef                	shr    %cl,%edi
  803723:	09 c7                	or     %eax,%edi
  803725:	89 e9                	mov    %ebp,%ecx
  803727:	d3 e2                	shl    %cl,%edx
  803729:	89 14 24             	mov    %edx,(%esp)
  80372c:	89 d8                	mov    %ebx,%eax
  80372e:	d3 e0                	shl    %cl,%eax
  803730:	89 c2                	mov    %eax,%edx
  803732:	8b 44 24 08          	mov    0x8(%esp),%eax
  803736:	d3 e0                	shl    %cl,%eax
  803738:	89 44 24 04          	mov    %eax,0x4(%esp)
  80373c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803740:	89 f1                	mov    %esi,%ecx
  803742:	d3 e8                	shr    %cl,%eax
  803744:	09 d0                	or     %edx,%eax
  803746:	d3 eb                	shr    %cl,%ebx
  803748:	89 da                	mov    %ebx,%edx
  80374a:	f7 f7                	div    %edi
  80374c:	89 d3                	mov    %edx,%ebx
  80374e:	f7 24 24             	mull   (%esp)
  803751:	89 c6                	mov    %eax,%esi
  803753:	89 d1                	mov    %edx,%ecx
  803755:	39 d3                	cmp    %edx,%ebx
  803757:	0f 82 87 00 00 00    	jb     8037e4 <__umoddi3+0x134>
  80375d:	0f 84 91 00 00 00    	je     8037f4 <__umoddi3+0x144>
  803763:	8b 54 24 04          	mov    0x4(%esp),%edx
  803767:	29 f2                	sub    %esi,%edx
  803769:	19 cb                	sbb    %ecx,%ebx
  80376b:	89 d8                	mov    %ebx,%eax
  80376d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803771:	d3 e0                	shl    %cl,%eax
  803773:	89 e9                	mov    %ebp,%ecx
  803775:	d3 ea                	shr    %cl,%edx
  803777:	09 d0                	or     %edx,%eax
  803779:	89 e9                	mov    %ebp,%ecx
  80377b:	d3 eb                	shr    %cl,%ebx
  80377d:	89 da                	mov    %ebx,%edx
  80377f:	83 c4 1c             	add    $0x1c,%esp
  803782:	5b                   	pop    %ebx
  803783:	5e                   	pop    %esi
  803784:	5f                   	pop    %edi
  803785:	5d                   	pop    %ebp
  803786:	c3                   	ret    
  803787:	90                   	nop
  803788:	89 fd                	mov    %edi,%ebp
  80378a:	85 ff                	test   %edi,%edi
  80378c:	75 0b                	jne    803799 <__umoddi3+0xe9>
  80378e:	b8 01 00 00 00       	mov    $0x1,%eax
  803793:	31 d2                	xor    %edx,%edx
  803795:	f7 f7                	div    %edi
  803797:	89 c5                	mov    %eax,%ebp
  803799:	89 f0                	mov    %esi,%eax
  80379b:	31 d2                	xor    %edx,%edx
  80379d:	f7 f5                	div    %ebp
  80379f:	89 c8                	mov    %ecx,%eax
  8037a1:	f7 f5                	div    %ebp
  8037a3:	89 d0                	mov    %edx,%eax
  8037a5:	e9 44 ff ff ff       	jmp    8036ee <__umoddi3+0x3e>
  8037aa:	66 90                	xchg   %ax,%ax
  8037ac:	89 c8                	mov    %ecx,%eax
  8037ae:	89 f2                	mov    %esi,%edx
  8037b0:	83 c4 1c             	add    $0x1c,%esp
  8037b3:	5b                   	pop    %ebx
  8037b4:	5e                   	pop    %esi
  8037b5:	5f                   	pop    %edi
  8037b6:	5d                   	pop    %ebp
  8037b7:	c3                   	ret    
  8037b8:	3b 04 24             	cmp    (%esp),%eax
  8037bb:	72 06                	jb     8037c3 <__umoddi3+0x113>
  8037bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037c1:	77 0f                	ja     8037d2 <__umoddi3+0x122>
  8037c3:	89 f2                	mov    %esi,%edx
  8037c5:	29 f9                	sub    %edi,%ecx
  8037c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037cb:	89 14 24             	mov    %edx,(%esp)
  8037ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037d6:	8b 14 24             	mov    (%esp),%edx
  8037d9:	83 c4 1c             	add    $0x1c,%esp
  8037dc:	5b                   	pop    %ebx
  8037dd:	5e                   	pop    %esi
  8037de:	5f                   	pop    %edi
  8037df:	5d                   	pop    %ebp
  8037e0:	c3                   	ret    
  8037e1:	8d 76 00             	lea    0x0(%esi),%esi
  8037e4:	2b 04 24             	sub    (%esp),%eax
  8037e7:	19 fa                	sbb    %edi,%edx
  8037e9:	89 d1                	mov    %edx,%ecx
  8037eb:	89 c6                	mov    %eax,%esi
  8037ed:	e9 71 ff ff ff       	jmp    803763 <__umoddi3+0xb3>
  8037f2:	66 90                	xchg   %ax,%ax
  8037f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037f8:	72 ea                	jb     8037e4 <__umoddi3+0x134>
  8037fa:	89 d9                	mov    %ebx,%ecx
  8037fc:	e9 62 ff ff ff       	jmp    803763 <__umoddi3+0xb3>
