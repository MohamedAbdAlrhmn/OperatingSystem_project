
obj/user/tst_envfree3:     file format elf32-i386


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
  800031:	e8 5f 01 00 00       	call   800195 <libmain>
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
	// Testing scenario 3: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 a0 36 80 00       	push   $0x8036a0
  80004a:	e8 06 15 00 00       	call   801555 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 57 17 00 00       	call   8017ba <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 ef 17 00 00       	call   80185a <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 b0 36 80 00       	push   $0x8036b0
  800079:	e8 07 05 00 00       	call   800585 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 e3 36 80 00       	push   $0x8036e3
  800099:	e8 8e 19 00 00       	call   801a2c <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 ec 36 80 00       	push   $0x8036ec
  8000bc:	e8 6b 19 00 00       	call   801a2c <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 78 19 00 00       	call   801a4a <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 9a 32 00 00       	call   80337c <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 5a 19 00 00       	call   801a4a <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 b7 16 00 00       	call   8017ba <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 f8 36 80 00       	push   $0x8036f8
  80010c:	e8 74 04 00 00       	call   800585 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 47 19 00 00       	call   801a66 <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 39 19 00 00       	call   801a66 <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 85 16 00 00       	call   8017ba <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 1d 17 00 00       	call   80185a <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 2c 37 80 00       	push   $0x80372c
  800153:	e8 2d 04 00 00       	call   800585 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 7c 37 80 00       	push   $0x80377c
  800163:	6a 23                	push   $0x23
  800165:	68 b2 37 80 00       	push   $0x8037b2
  80016a:	e8 62 01 00 00       	call   8002d1 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 c8 37 80 00       	push   $0x8037c8
  80017a:	e8 06 04 00 00       	call   800585 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 28 38 80 00       	push   $0x803828
  80018a:	e8 f6 03 00 00       	call   800585 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
	return;
  800192:	90                   	nop
}
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80019b:	e8 fa 18 00 00       	call   801a9a <sys_getenvindex>
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a6:	89 d0                	mov    %edx,%eax
  8001a8:	c1 e0 03             	shl    $0x3,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	01 c0                	add    %eax,%eax
  8001af:	01 d0                	add    %edx,%eax
  8001b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b8:	01 d0                	add    %edx,%eax
  8001ba:	c1 e0 04             	shl    $0x4,%eax
  8001bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c2:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8001cc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001d2:	84 c0                	test   %al,%al
  8001d4:	74 0f                	je     8001e5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8001db:	05 5c 05 00 00       	add    $0x55c,%eax
  8001e0:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e9:	7e 0a                	jle    8001f5 <libmain+0x60>
		binaryname = argv[0];
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	e8 35 fe ff ff       	call   800038 <_main>
  800203:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800206:	e8 9c 16 00 00       	call   8018a7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 8c 38 80 00       	push   $0x80388c
  800213:	e8 6d 03 00 00       	call   800585 <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80021b:	a1 20 50 80 00       	mov    0x805020,%eax
  800220:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800226:	a1 20 50 80 00       	mov    0x805020,%eax
  80022b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800231:	83 ec 04             	sub    $0x4,%esp
  800234:	52                   	push   %edx
  800235:	50                   	push   %eax
  800236:	68 b4 38 80 00       	push   $0x8038b4
  80023b:	e8 45 03 00 00       	call   800585 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800243:	a1 20 50 80 00       	mov    0x805020,%eax
  800248:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024e:	a1 20 50 80 00       	mov    0x805020,%eax
  800253:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800259:	a1 20 50 80 00       	mov    0x805020,%eax
  80025e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800264:	51                   	push   %ecx
  800265:	52                   	push   %edx
  800266:	50                   	push   %eax
  800267:	68 dc 38 80 00       	push   $0x8038dc
  80026c:	e8 14 03 00 00       	call   800585 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 34 39 80 00       	push   $0x803934
  800288:	e8 f8 02 00 00       	call   800585 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 8c 38 80 00       	push   $0x80388c
  800298:	e8 e8 02 00 00       	call   800585 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a0:	e8 1c 16 00 00       	call   8018c1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a5:	e8 19 00 00 00       	call   8002c3 <exit>
}
  8002aa:	90                   	nop
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	6a 00                	push   $0x0
  8002b8:	e8 a9 17 00 00       	call   801a66 <sys_destroy_env>
  8002bd:	83 c4 10             	add    $0x10,%esp
}
  8002c0:	90                   	nop
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <exit>:

void
exit(void)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c9:	e8 fe 17 00 00       	call   801acc <sys_exit_env>
}
  8002ce:	90                   	nop
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8002da:	83 c0 04             	add    $0x4,%eax
  8002dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002e0:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	74 16                	je     8002ff <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	50                   	push   %eax
  8002f2:	68 48 39 80 00       	push   $0x803948
  8002f7:	e8 89 02 00 00       	call   800585 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ff:	a1 00 50 80 00       	mov    0x805000,%eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	50                   	push   %eax
  80030b:	68 4d 39 80 00       	push   $0x80394d
  800310:	e8 70 02 00 00       	call   800585 <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800318:	8b 45 10             	mov    0x10(%ebp),%eax
  80031b:	83 ec 08             	sub    $0x8,%esp
  80031e:	ff 75 f4             	pushl  -0xc(%ebp)
  800321:	50                   	push   %eax
  800322:	e8 f3 01 00 00       	call   80051a <vcprintf>
  800327:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	6a 00                	push   $0x0
  80032f:	68 69 39 80 00       	push   $0x803969
  800334:	e8 e1 01 00 00       	call   80051a <vcprintf>
  800339:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80033c:	e8 82 ff ff ff       	call   8002c3 <exit>

	// should not return here
	while (1) ;
  800341:	eb fe                	jmp    800341 <_panic+0x70>

00800343 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800349:	a1 20 50 80 00       	mov    0x805020,%eax
  80034e:	8b 50 74             	mov    0x74(%eax),%edx
  800351:	8b 45 0c             	mov    0xc(%ebp),%eax
  800354:	39 c2                	cmp    %eax,%edx
  800356:	74 14                	je     80036c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 6c 39 80 00       	push   $0x80396c
  800360:	6a 26                	push   $0x26
  800362:	68 b8 39 80 00       	push   $0x8039b8
  800367:	e8 65 ff ff ff       	call   8002d1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80036c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800373:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80037a:	e9 c2 00 00 00       	jmp    800441 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800382:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	8b 00                	mov    (%eax),%eax
  800390:	85 c0                	test   %eax,%eax
  800392:	75 08                	jne    80039c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800394:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800397:	e9 a2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80039c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003aa:	eb 69                	jmp    800415 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ba:	89 d0                	mov    %edx,%eax
  8003bc:	01 c0                	add    %eax,%eax
  8003be:	01 d0                	add    %edx,%eax
  8003c0:	c1 e0 03             	shl    $0x3,%eax
  8003c3:	01 c8                	add    %ecx,%eax
  8003c5:	8a 40 04             	mov    0x4(%eax),%al
  8003c8:	84 c0                	test   %al,%al
  8003ca:	75 46                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003cc:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003da:	89 d0                	mov    %edx,%eax
  8003dc:	01 c0                	add    %eax,%eax
  8003de:	01 d0                	add    %edx,%eax
  8003e0:	c1 e0 03             	shl    $0x3,%eax
  8003e3:	01 c8                	add    %ecx,%eax
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	01 c8                	add    %ecx,%eax
  800403:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800405:	39 c2                	cmp    %eax,%edx
  800407:	75 09                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800409:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800410:	eb 12                	jmp    800424 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800412:	ff 45 e8             	incl   -0x18(%ebp)
  800415:	a1 20 50 80 00       	mov    0x805020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	77 88                	ja     8003ac <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800424:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800428:	75 14                	jne    80043e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80042a:	83 ec 04             	sub    $0x4,%esp
  80042d:	68 c4 39 80 00       	push   $0x8039c4
  800432:	6a 3a                	push   $0x3a
  800434:	68 b8 39 80 00       	push   $0x8039b8
  800439:	e8 93 fe ff ff       	call   8002d1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043e:	ff 45 f0             	incl   -0x10(%ebp)
  800441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800444:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800447:	0f 8c 32 ff ff ff    	jl     80037f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800454:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80045b:	eb 26                	jmp    800483 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045d:	a1 20 50 80 00       	mov    0x805020,%eax
  800462:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800468:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80046b:	89 d0                	mov    %edx,%eax
  80046d:	01 c0                	add    %eax,%eax
  80046f:	01 d0                	add    %edx,%eax
  800471:	c1 e0 03             	shl    $0x3,%eax
  800474:	01 c8                	add    %ecx,%eax
  800476:	8a 40 04             	mov    0x4(%eax),%al
  800479:	3c 01                	cmp    $0x1,%al
  80047b:	75 03                	jne    800480 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800480:	ff 45 e0             	incl   -0x20(%ebp)
  800483:	a1 20 50 80 00       	mov    0x805020,%eax
  800488:	8b 50 74             	mov    0x74(%eax),%edx
  80048b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048e:	39 c2                	cmp    %eax,%edx
  800490:	77 cb                	ja     80045d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800495:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800498:	74 14                	je     8004ae <CheckWSWithoutLastIndex+0x16b>
		panic(
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 18 3a 80 00       	push   $0x803a18
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 b8 39 80 00       	push   $0x8039b8
  8004a9:	e8 23 fe ff ff       	call   8002d1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ae:	90                   	nop
  8004af:	c9                   	leave  
  8004b0:	c3                   	ret    

008004b1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c2:	89 0a                	mov    %ecx,(%edx)
  8004c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c7:	88 d1                	mov    %dl,%cl
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 2c                	jne    800508 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004dc:	a0 24 50 80 00       	mov    0x805024,%al
  8004e1:	0f b6 c0             	movzbl %al,%eax
  8004e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e7:	8b 12                	mov    (%edx),%edx
  8004e9:	89 d1                	mov    %edx,%ecx
  8004eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ee:	83 c2 08             	add    $0x8,%edx
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	50                   	push   %eax
  8004f5:	51                   	push   %ecx
  8004f6:	52                   	push   %edx
  8004f7:	e8 fd 11 00 00       	call   8016f9 <sys_cputs>
  8004fc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	8b 40 04             	mov    0x4(%eax),%eax
  80050e:	8d 50 01             	lea    0x1(%eax),%edx
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	89 50 04             	mov    %edx,0x4(%eax)
}
  800517:	90                   	nop
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800523:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80052a:	00 00 00 
	b.cnt = 0;
  80052d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800534:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 08             	pushl  0x8(%ebp)
  80053d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800543:	50                   	push   %eax
  800544:	68 b1 04 80 00       	push   $0x8004b1
  800549:	e8 11 02 00 00       	call   80075f <vprintfmt>
  80054e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800551:	a0 24 50 80 00       	mov    0x805024,%al
  800556:	0f b6 c0             	movzbl %al,%eax
  800559:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	50                   	push   %eax
  800563:	52                   	push   %edx
  800564:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056a:	83 c0 08             	add    $0x8,%eax
  80056d:	50                   	push   %eax
  80056e:	e8 86 11 00 00       	call   8016f9 <sys_cputs>
  800573:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800576:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80057d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <cprintf>:

int cprintf(const char *fmt, ...) {
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80058b:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800592:	8d 45 0c             	lea    0xc(%ebp),%eax
  800595:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a1:	50                   	push   %eax
  8005a2:	e8 73 ff ff ff       	call   80051a <vcprintf>
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b8:	e8 ea 12 00 00       	call   8018a7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cc:	50                   	push   %eax
  8005cd:	e8 48 ff ff ff       	call   80051a <vcprintf>
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d8:	e8 e4 12 00 00       	call   8018c1 <sys_enable_interrupt>
	return cnt;
  8005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e0:	c9                   	leave  
  8005e1:	c3                   	ret    

008005e2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	53                   	push   %ebx
  8005e6:	83 ec 14             	sub    $0x14,%esp
  8005e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800600:	77 55                	ja     800657 <printnum+0x75>
  800602:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800605:	72 05                	jb     80060c <printnum+0x2a>
  800607:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80060a:	77 4b                	ja     800657 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800612:	8b 45 18             	mov    0x18(%ebp),%eax
  800615:	ba 00 00 00 00       	mov    $0x0,%edx
  80061a:	52                   	push   %edx
  80061b:	50                   	push   %eax
  80061c:	ff 75 f4             	pushl  -0xc(%ebp)
  80061f:	ff 75 f0             	pushl  -0x10(%ebp)
  800622:	e8 09 2e 00 00       	call   803430 <__udivdi3>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	83 ec 04             	sub    $0x4,%esp
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	53                   	push   %ebx
  800631:	ff 75 18             	pushl  0x18(%ebp)
  800634:	52                   	push   %edx
  800635:	50                   	push   %eax
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	ff 75 08             	pushl  0x8(%ebp)
  80063c:	e8 a1 ff ff ff       	call   8005e2 <printnum>
  800641:	83 c4 20             	add    $0x20,%esp
  800644:	eb 1a                	jmp    800660 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	ff 75 20             	pushl  0x20(%ebp)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
  800654:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800657:	ff 4d 1c             	decl   0x1c(%ebp)
  80065a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065e:	7f e6                	jg     800646 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800660:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800663:	bb 00 00 00 00       	mov    $0x0,%ebx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066e:	53                   	push   %ebx
  80066f:	51                   	push   %ecx
  800670:	52                   	push   %edx
  800671:	50                   	push   %eax
  800672:	e8 c9 2e 00 00       	call   803540 <__umoddi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	05 94 3c 80 00       	add    $0x803c94,%eax
  80067f:	8a 00                	mov    (%eax),%al
  800681:	0f be c0             	movsbl %al,%eax
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	50                   	push   %eax
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	ff d0                	call   *%eax
  800690:	83 c4 10             	add    $0x10,%esp
}
  800693:	90                   	nop
  800694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800697:	c9                   	leave  
  800698:	c3                   	ret    

00800699 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a0:	7e 1c                	jle    8006be <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	8d 50 08             	lea    0x8(%eax),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	89 10                	mov    %edx,(%eax)
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	83 e8 08             	sub    $0x8,%eax
  8006b7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	eb 40                	jmp    8006fe <getuint+0x65>
	else if (lflag)
  8006be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c2:	74 1e                	je     8006e2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	8d 50 04             	lea    0x4(%eax),%edx
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	89 10                	mov    %edx,(%eax)
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	83 e8 04             	sub    $0x4,%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e0:	eb 1c                	jmp    8006fe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 10                	mov    %edx,(%eax)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	83 e8 04             	sub    $0x4,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    

00800700 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800703:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800707:	7e 1c                	jle    800725 <getint+0x25>
		return va_arg(*ap, long long);
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	8d 50 08             	lea    0x8(%eax),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	89 10                	mov    %edx,(%eax)
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	83 e8 08             	sub    $0x8,%eax
  80071e:	8b 50 04             	mov    0x4(%eax),%edx
  800721:	8b 00                	mov    (%eax),%eax
  800723:	eb 38                	jmp    80075d <getint+0x5d>
	else if (lflag)
  800725:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800729:	74 1a                	je     800745 <getint+0x45>
		return va_arg(*ap, long);
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	8d 50 04             	lea    0x4(%eax),%edx
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	89 10                	mov    %edx,(%eax)
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	83 e8 04             	sub    $0x4,%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	99                   	cltd   
  800743:	eb 18                	jmp    80075d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	8d 50 04             	lea    0x4(%eax),%edx
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	89 10                	mov    %edx,(%eax)
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	83 e8 04             	sub    $0x4,%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	99                   	cltd   
}
  80075d:	5d                   	pop    %ebp
  80075e:	c3                   	ret    

0080075f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	56                   	push   %esi
  800763:	53                   	push   %ebx
  800764:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800767:	eb 17                	jmp    800780 <vprintfmt+0x21>
			if (ch == '\0')
  800769:	85 db                	test   %ebx,%ebx
  80076b:	0f 84 af 03 00 00    	je     800b20 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	53                   	push   %ebx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	ff d0                	call   *%eax
  80077d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800780:	8b 45 10             	mov    0x10(%ebp),%eax
  800783:	8d 50 01             	lea    0x1(%eax),%edx
  800786:	89 55 10             	mov    %edx,0x10(%ebp)
  800789:	8a 00                	mov    (%eax),%al
  80078b:	0f b6 d8             	movzbl %al,%ebx
  80078e:	83 fb 25             	cmp    $0x25,%ebx
  800791:	75 d6                	jne    800769 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800793:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800797:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b6:	8d 50 01             	lea    0x1(%eax),%edx
  8007b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8007bc:	8a 00                	mov    (%eax),%al
  8007be:	0f b6 d8             	movzbl %al,%ebx
  8007c1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c4:	83 f8 55             	cmp    $0x55,%eax
  8007c7:	0f 87 2b 03 00 00    	ja     800af8 <vprintfmt+0x399>
  8007cd:	8b 04 85 b8 3c 80 00 	mov    0x803cb8(,%eax,4),%eax
  8007d4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007da:	eb d7                	jmp    8007b3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007dc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007e0:	eb d1                	jmp    8007b3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ec:	89 d0                	mov    %edx,%eax
  8007ee:	c1 e0 02             	shl    $0x2,%eax
  8007f1:	01 d0                	add    %edx,%eax
  8007f3:	01 c0                	add    %eax,%eax
  8007f5:	01 d8                	add    %ebx,%eax
  8007f7:	83 e8 30             	sub    $0x30,%eax
  8007fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800805:	83 fb 2f             	cmp    $0x2f,%ebx
  800808:	7e 3e                	jle    800848 <vprintfmt+0xe9>
  80080a:	83 fb 39             	cmp    $0x39,%ebx
  80080d:	7f 39                	jg     800848 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800812:	eb d5                	jmp    8007e9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	83 c0 04             	add    $0x4,%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	83 e8 04             	sub    $0x4,%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800828:	eb 1f                	jmp    800849 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	79 83                	jns    8007b3 <vprintfmt+0x54>
				width = 0;
  800830:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800837:	e9 77 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80083c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800843:	e9 6b ff ff ff       	jmp    8007b3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800848:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800849:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084d:	0f 89 60 ff ff ff    	jns    8007b3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800856:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800859:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800860:	e9 4e ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800865:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800868:	e9 46 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	83 c0 04             	add    $0x4,%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 e8 04             	sub    $0x4,%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	50                   	push   %eax
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			break;
  80088d:	e9 89 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 c0 04             	add    $0x4,%eax
  800898:	89 45 14             	mov    %eax,0x14(%ebp)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a3:	85 db                	test   %ebx,%ebx
  8008a5:	79 02                	jns    8008a9 <vprintfmt+0x14a>
				err = -err;
  8008a7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a9:	83 fb 64             	cmp    $0x64,%ebx
  8008ac:	7f 0b                	jg     8008b9 <vprintfmt+0x15a>
  8008ae:	8b 34 9d 00 3b 80 00 	mov    0x803b00(,%ebx,4),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 19                	jne    8008d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b9:	53                   	push   %ebx
  8008ba:	68 a5 3c 80 00       	push   $0x803ca5
  8008bf:	ff 75 0c             	pushl  0xc(%ebp)
  8008c2:	ff 75 08             	pushl  0x8(%ebp)
  8008c5:	e8 5e 02 00 00       	call   800b28 <printfmt>
  8008ca:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008cd:	e9 49 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d2:	56                   	push   %esi
  8008d3:	68 ae 3c 80 00       	push   $0x803cae
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	e8 45 02 00 00       	call   800b28 <printfmt>
  8008e3:	83 c4 10             	add    $0x10,%esp
			break;
  8008e6:	e9 30 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	83 c0 04             	add    $0x4,%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 30                	mov    (%eax),%esi
  8008fc:	85 f6                	test   %esi,%esi
  8008fe:	75 05                	jne    800905 <vprintfmt+0x1a6>
				p = "(null)";
  800900:	be b1 3c 80 00       	mov    $0x803cb1,%esi
			if (width > 0 && padc != '-')
  800905:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800909:	7e 6d                	jle    800978 <vprintfmt+0x219>
  80090b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090f:	74 67                	je     800978 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800911:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	50                   	push   %eax
  800918:	56                   	push   %esi
  800919:	e8 0c 03 00 00       	call   800c2a <strnlen>
  80091e:	83 c4 10             	add    $0x10,%esp
  800921:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800924:	eb 16                	jmp    80093c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800926:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	50                   	push   %eax
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800939:	ff 4d e4             	decl   -0x1c(%ebp)
  80093c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800940:	7f e4                	jg     800926 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800942:	eb 34                	jmp    800978 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800944:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800948:	74 1c                	je     800966 <vprintfmt+0x207>
  80094a:	83 fb 1f             	cmp    $0x1f,%ebx
  80094d:	7e 05                	jle    800954 <vprintfmt+0x1f5>
  80094f:	83 fb 7e             	cmp    $0x7e,%ebx
  800952:	7e 12                	jle    800966 <vprintfmt+0x207>
					putch('?', putdat);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	6a 3f                	push   $0x3f
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	ff d0                	call   *%eax
  800961:	83 c4 10             	add    $0x10,%esp
  800964:	eb 0f                	jmp    800975 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	ff d0                	call   *%eax
  800972:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800975:	ff 4d e4             	decl   -0x1c(%ebp)
  800978:	89 f0                	mov    %esi,%eax
  80097a:	8d 70 01             	lea    0x1(%eax),%esi
  80097d:	8a 00                	mov    (%eax),%al
  80097f:	0f be d8             	movsbl %al,%ebx
  800982:	85 db                	test   %ebx,%ebx
  800984:	74 24                	je     8009aa <vprintfmt+0x24b>
  800986:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80098a:	78 b8                	js     800944 <vprintfmt+0x1e5>
  80098c:	ff 4d e0             	decl   -0x20(%ebp)
  80098f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800993:	79 af                	jns    800944 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800995:	eb 13                	jmp    8009aa <vprintfmt+0x24b>
				putch(' ', putdat);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	6a 20                	push   $0x20
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	ff d0                	call   *%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ae:	7f e7                	jg     800997 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009b0:	e9 66 01 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009be:	50                   	push   %eax
  8009bf:	e8 3c fd ff ff       	call   800700 <getint>
  8009c4:	83 c4 10             	add    $0x10,%esp
  8009c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d3:	85 d2                	test   %edx,%edx
  8009d5:	79 23                	jns    8009fa <vprintfmt+0x29b>
				putch('-', putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	6a 2d                	push   $0x2d
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ed:	f7 d8                	neg    %eax
  8009ef:	83 d2 00             	adc    $0x0,%edx
  8009f2:	f7 da                	neg    %edx
  8009f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a01:	e9 bc 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 e8             	pushl  -0x18(%ebp)
  800a0c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	e8 84 fc ff ff       	call   800699 <getuint>
  800a15:	83 c4 10             	add    $0x10,%esp
  800a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a25:	e9 98 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	6a 58                	push   $0x58
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	ff d0                	call   *%eax
  800a37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	6a 58                	push   $0x58
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	ff d0                	call   *%eax
  800a47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	6a 58                	push   $0x58
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	ff d0                	call   *%eax
  800a57:	83 c4 10             	add    $0x10,%esp
			break;
  800a5a:	e9 bc 00 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	6a 30                	push   $0x30
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	ff d0                	call   *%eax
  800a6c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	6a 78                	push   $0x78
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	ff d0                	call   *%eax
  800a7c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	83 c0 04             	add    $0x4,%eax
  800a85:	89 45 14             	mov    %eax,0x14(%ebp)
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 e8 04             	sub    $0x4,%eax
  800a8e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a9a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 e7 fb ff ff       	call   800699 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800abb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac9:	83 ec 04             	sub    $0x4,%esp
  800acc:	52                   	push   %edx
  800acd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ad0:	50                   	push   %eax
  800ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	ff 75 08             	pushl  0x8(%ebp)
  800add:	e8 00 fb ff ff       	call   8005e2 <printnum>
  800ae2:	83 c4 20             	add    $0x20,%esp
			break;
  800ae5:	eb 34                	jmp    800b1b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	53                   	push   %ebx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
			break;
  800af6:	eb 23                	jmp    800b1b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 25                	push   $0x25
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b08:	ff 4d 10             	decl   0x10(%ebp)
  800b0b:	eb 03                	jmp    800b10 <vprintfmt+0x3b1>
  800b0d:	ff 4d 10             	decl   0x10(%ebp)
  800b10:	8b 45 10             	mov    0x10(%ebp),%eax
  800b13:	48                   	dec    %eax
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	3c 25                	cmp    $0x25,%al
  800b18:	75 f3                	jne    800b0d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b1a:	90                   	nop
		}
	}
  800b1b:	e9 47 fc ff ff       	jmp    800767 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b20:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b31:	83 c0 04             	add    $0x4,%eax
  800b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b37:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3d:	50                   	push   %eax
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 16 fc ff ff       	call   80075f <vprintfmt>
  800b49:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b4c:	90                   	nop
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 08             	mov    0x8(%eax),%eax
  800b58:	8d 50 01             	lea    0x1(%eax),%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8b 10                	mov    (%eax),%edx
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 40 04             	mov    0x4(%eax),%eax
  800b6c:	39 c2                	cmp    %eax,%edx
  800b6e:	73 12                	jae    800b82 <sprintputch+0x33>
		*b->buf++ = ch;
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	8b 00                	mov    (%eax),%eax
  800b75:	8d 48 01             	lea    0x1(%eax),%ecx
  800b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7b:	89 0a                	mov    %ecx,(%edx)
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	88 10                	mov    %dl,(%eax)
}
  800b82:	90                   	nop
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	01 d0                	add    %edx,%eax
  800b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800baa:	74 06                	je     800bb2 <vsnprintf+0x2d>
  800bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb0:	7f 07                	jg     800bb9 <vsnprintf+0x34>
		return -E_INVAL;
  800bb2:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb7:	eb 20                	jmp    800bd9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb9:	ff 75 14             	pushl  0x14(%ebp)
  800bbc:	ff 75 10             	pushl  0x10(%ebp)
  800bbf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc2:	50                   	push   %eax
  800bc3:	68 4f 0b 80 00       	push   $0x800b4f
  800bc8:	e8 92 fb ff ff       	call   80075f <vprintfmt>
  800bcd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be1:	8d 45 10             	lea    0x10(%ebp),%eax
  800be4:	83 c0 04             	add    $0x4,%eax
  800be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bea:	8b 45 10             	mov    0x10(%ebp),%eax
  800bed:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf0:	50                   	push   %eax
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	ff 75 08             	pushl  0x8(%ebp)
  800bf7:	e8 89 ff ff ff       	call   800b85 <vsnprintf>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c14:	eb 06                	jmp    800c1c <strlen+0x15>
		n++;
  800c16:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c19:	ff 45 08             	incl   0x8(%ebp)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 f1                	jne    800c16 <strlen+0xf>
		n++;
	return n;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 09                	jmp    800c42 <strnlen+0x18>
		n++;
  800c39:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c3c:	ff 45 08             	incl   0x8(%ebp)
  800c3f:	ff 4d 0c             	decl   0xc(%ebp)
  800c42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c46:	74 09                	je     800c51 <strnlen+0x27>
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	84 c0                	test   %al,%al
  800c4f:	75 e8                	jne    800c39 <strnlen+0xf>
		n++;
	return n;
  800c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c62:	90                   	nop
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	84 c0                	test   %al,%al
  800c7d:	75 e4                	jne    800c63 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c97:	eb 1f                	jmp    800cb8 <strncpy+0x34>
		*dst++ = *src;
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca5:	8a 12                	mov    (%edx),%dl
  800ca7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	74 03                	je     800cb5 <strncpy+0x31>
			src++;
  800cb2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb5:	ff 45 fc             	incl   -0x4(%ebp)
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbe:	72 d9                	jb     800c99 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd5:	74 30                	je     800d07 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd7:	eb 16                	jmp    800cef <strlcpy+0x2a>
			*dst++ = *src++;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8d 50 01             	lea    0x1(%eax),%edx
  800cdf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ceb:	8a 12                	mov    (%edx),%dl
  800ced:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cef:	ff 4d 10             	decl   0x10(%ebp)
  800cf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf6:	74 09                	je     800d01 <strlcpy+0x3c>
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	84 c0                	test   %al,%al
  800cff:	75 d8                	jne    800cd9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d07:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	29 c2                	sub    %eax,%edx
  800d0f:	89 d0                	mov    %edx,%eax
}
  800d11:	c9                   	leave  
  800d12:	c3                   	ret    

00800d13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d16:	eb 06                	jmp    800d1e <strcmp+0xb>
		p++, q++;
  800d18:	ff 45 08             	incl   0x8(%ebp)
  800d1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strcmp+0x22>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 e3                	je     800d18 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f b6 d0             	movzbl %al,%edx
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f b6 c0             	movzbl %al,%eax
  800d45:	29 c2                	sub    %eax,%edx
  800d47:	89 d0                	mov    %edx,%eax
}
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4e:	eb 09                	jmp    800d59 <strncmp+0xe>
		n--, p++, q++;
  800d50:	ff 4d 10             	decl   0x10(%ebp)
  800d53:	ff 45 08             	incl   0x8(%ebp)
  800d56:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	74 17                	je     800d76 <strncmp+0x2b>
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	74 0e                	je     800d76 <strncmp+0x2b>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 10                	mov    (%eax),%dl
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	38 c2                	cmp    %al,%dl
  800d74:	74 da                	je     800d50 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	75 07                	jne    800d83 <strncmp+0x38>
		return 0;
  800d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d81:	eb 14                	jmp    800d97 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	0f b6 d0             	movzbl %al,%edx
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	0f b6 c0             	movzbl %al,%eax
  800d93:	29 c2                	sub    %eax,%edx
  800d95:	89 d0                	mov    %edx,%eax
}
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 04             	sub    $0x4,%esp
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da5:	eb 12                	jmp    800db9 <strchr+0x20>
		if (*s == c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800daf:	75 05                	jne    800db6 <strchr+0x1d>
			return (char *) s;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	eb 11                	jmp    800dc7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db6:	ff 45 08             	incl   0x8(%ebp)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	84 c0                	test   %al,%al
  800dc0:	75 e5                	jne    800da7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 04             	sub    $0x4,%esp
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd5:	eb 0d                	jmp    800de4 <strfind+0x1b>
		if (*s == c)
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddf:	74 0e                	je     800def <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 ea                	jne    800dd7 <strfind+0xe>
  800ded:	eb 01                	jmp    800df0 <strfind+0x27>
		if (*s == c)
			break;
  800def:	90                   	nop
	return (char *) s;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e01:	8b 45 10             	mov    0x10(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e07:	eb 0e                	jmp    800e17 <memset+0x22>
		*p++ = c;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e15:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e17:	ff 4d f8             	decl   -0x8(%ebp)
  800e1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1e:	79 e9                	jns    800e09 <memset+0x14>
		*p++ = c;

	return v;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e37:	eb 16                	jmp    800e4f <memcpy+0x2a>
		*d++ = *s++;
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e55:	89 55 10             	mov    %edx,0x10(%ebp)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	75 dd                	jne    800e39 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e79:	73 50                	jae    800ecb <memmove+0x6a>
  800e7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e81:	01 d0                	add    %edx,%eax
  800e83:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e86:	76 43                	jbe    800ecb <memmove+0x6a>
		s += n;
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e91:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e94:	eb 10                	jmp    800ea6 <memmove+0x45>
			*--d = *--s;
  800e96:	ff 4d f8             	decl   -0x8(%ebp)
  800e99:	ff 4d fc             	decl   -0x4(%ebp)
  800e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9f:	8a 10                	mov    (%eax),%dl
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eac:	89 55 10             	mov    %edx,0x10(%ebp)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	75 e3                	jne    800e96 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb3:	eb 23                	jmp    800ed8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8d 50 01             	lea    0x1(%eax),%edx
  800ebb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec7:	8a 12                	mov    (%edx),%dl
  800ec9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ece:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	75 dd                	jne    800eb5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eef:	eb 2a                	jmp    800f1b <memcmp+0x3e>
		if (*s1 != *s2)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	38 c2                	cmp    %al,%dl
  800efd:	74 16                	je     800f15 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	0f b6 d0             	movzbl %al,%edx
  800f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	29 c2                	sub    %eax,%edx
  800f11:	89 d0                	mov    %edx,%eax
  800f13:	eb 18                	jmp    800f2d <memcmp+0x50>
		s1++, s2++;
  800f15:	ff 45 fc             	incl   -0x4(%ebp)
  800f18:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 c9                	jne    800ef1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2d:	c9                   	leave  
  800f2e:	c3                   	ret    

00800f2f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	01 d0                	add    %edx,%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f40:	eb 15                	jmp    800f57 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 d0             	movzbl %al,%edx
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	0f b6 c0             	movzbl %al,%eax
  800f50:	39 c2                	cmp    %eax,%edx
  800f52:	74 0d                	je     800f61 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5d:	72 e3                	jb     800f42 <memfind+0x13>
  800f5f:	eb 01                	jmp    800f62 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f61:	90                   	nop
	return (void *) s;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f74:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7b:	eb 03                	jmp    800f80 <strtol+0x19>
		s++;
  800f7d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 20                	cmp    $0x20,%al
  800f87:	74 f4                	je     800f7d <strtol+0x16>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 09                	cmp    $0x9,%al
  800f90:	74 eb                	je     800f7d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 2b                	cmp    $0x2b,%al
  800f99:	75 05                	jne    800fa0 <strtol+0x39>
		s++;
  800f9b:	ff 45 08             	incl   0x8(%ebp)
  800f9e:	eb 13                	jmp    800fb3 <strtol+0x4c>
	else if (*s == '-')
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 2d                	cmp    $0x2d,%al
  800fa7:	75 0a                	jne    800fb3 <strtol+0x4c>
		s++, neg = 1;
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	74 06                	je     800fbf <strtol+0x58>
  800fb9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fbd:	75 20                	jne    800fdf <strtol+0x78>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 30                	cmp    $0x30,%al
  800fc6:	75 17                	jne    800fdf <strtol+0x78>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	40                   	inc    %eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 78                	cmp    $0x78,%al
  800fd0:	75 0d                	jne    800fdf <strtol+0x78>
		s += 2, base = 16;
  800fd2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fdd:	eb 28                	jmp    801007 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 15                	jne    800ffa <strtol+0x93>
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3c 30                	cmp    $0x30,%al
  800fec:	75 0c                	jne    800ffa <strtol+0x93>
		s++, base = 8;
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff8:	eb 0d                	jmp    801007 <strtol+0xa0>
	else if (base == 0)
  800ffa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffe:	75 07                	jne    801007 <strtol+0xa0>
		base = 10;
  801000:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3c 2f                	cmp    $0x2f,%al
  80100e:	7e 19                	jle    801029 <strtol+0xc2>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 39                	cmp    $0x39,%al
  801017:	7f 10                	jg     801029 <strtol+0xc2>
			dig = *s - '0';
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	0f be c0             	movsbl %al,%eax
  801021:	83 e8 30             	sub    $0x30,%eax
  801024:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801027:	eb 42                	jmp    80106b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 60                	cmp    $0x60,%al
  801030:	7e 19                	jle    80104b <strtol+0xe4>
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 7a                	cmp    $0x7a,%al
  801039:	7f 10                	jg     80104b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	0f be c0             	movsbl %al,%eax
  801043:	83 e8 57             	sub    $0x57,%eax
  801046:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801049:	eb 20                	jmp    80106b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 40                	cmp    $0x40,%al
  801052:	7e 39                	jle    80108d <strtol+0x126>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 5a                	cmp    $0x5a,%al
  80105b:	7f 30                	jg     80108d <strtol+0x126>
			dig = *s - 'A' + 10;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 37             	sub    $0x37,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801071:	7d 19                	jge    80108c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801073:	ff 45 08             	incl   0x8(%ebp)
  801076:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801079:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107d:	89 c2                	mov    %eax,%edx
  80107f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801082:	01 d0                	add    %edx,%eax
  801084:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801087:	e9 7b ff ff ff       	jmp    801007 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80108c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801091:	74 08                	je     80109b <strtol+0x134>
		*endptr = (char *) s;
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80109b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109f:	74 07                	je     8010a8 <strtol+0x141>
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	f7 d8                	neg    %eax
  8010a6:	eb 03                	jmp    8010ab <strtol+0x144>
  8010a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <ltostr>:

void
ltostr(long value, char *str)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c5:	79 13                	jns    8010da <ltostr+0x2d>
	{
		neg = 1;
  8010c7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010e2:	99                   	cltd   
  8010e3:	f7 f9                	idiv   %ecx
  8010e5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010eb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f1:	89 c2                	mov    %eax,%edx
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010fb:	83 c2 30             	add    $0x30,%edx
  8010fe:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801100:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801103:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801108:	f7 e9                	imul   %ecx
  80110a:	c1 fa 02             	sar    $0x2,%edx
  80110d:	89 c8                	mov    %ecx,%eax
  80110f:	c1 f8 1f             	sar    $0x1f,%eax
  801112:	29 c2                	sub    %eax,%edx
  801114:	89 d0                	mov    %edx,%eax
  801116:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801119:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801121:	f7 e9                	imul   %ecx
  801123:	c1 fa 02             	sar    $0x2,%edx
  801126:	89 c8                	mov    %ecx,%eax
  801128:	c1 f8 1f             	sar    $0x1f,%eax
  80112b:	29 c2                	sub    %eax,%edx
  80112d:	89 d0                	mov    %edx,%eax
  80112f:	c1 e0 02             	shl    $0x2,%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	01 c0                	add    %eax,%eax
  801136:	29 c1                	sub    %eax,%ecx
  801138:	89 ca                	mov    %ecx,%edx
  80113a:	85 d2                	test   %edx,%edx
  80113c:	75 9c                	jne    8010da <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	48                   	dec    %eax
  801149:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80114c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801150:	74 3d                	je     80118f <ltostr+0xe2>
		start = 1 ;
  801152:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801159:	eb 34                	jmp    80118f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80115b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	01 c8                	add    %ecx,%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80117c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 c2                	add    %eax,%edx
  801184:	8a 45 eb             	mov    -0x15(%ebp),%al
  801187:	88 02                	mov    %al,(%edx)
		start++ ;
  801189:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80118c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801192:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801195:	7c c4                	jl     80115b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801197:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011a2:	90                   	nop
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 54 fa ff ff       	call   800c07 <strlen>
  8011b3:	83 c4 04             	add    $0x4,%esp
  8011b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	e8 46 fa ff ff       	call   800c07 <strlen>
  8011c1:	83 c4 04             	add    $0x4,%esp
  8011c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d5:	eb 17                	jmp    8011ee <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	01 c2                	add    %eax,%edx
  8011df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	01 c8                	add    %ecx,%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011eb:	ff 45 fc             	incl   -0x4(%ebp)
  8011ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f4:	7c e1                	jl     8011d7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801204:	eb 1f                	jmp    801225 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120f:	89 c2                	mov    %eax,%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 c2                	add    %eax,%edx
  801216:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	01 c8                	add    %ecx,%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801222:	ff 45 f8             	incl   -0x8(%ebp)
  801225:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801228:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122b:	7c d9                	jl     801206 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 d0                	add    %edx,%eax
  801235:	c6 00 00             	movb   $0x0,(%eax)
}
  801238:	90                   	nop
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801253:	8b 45 10             	mov    0x10(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125e:	eb 0c                	jmp    80126c <strsplit+0x31>
			*string++ = 0;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8d 50 01             	lea    0x1(%eax),%edx
  801266:	89 55 08             	mov    %edx,0x8(%ebp)
  801269:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	74 18                	je     80128d <strsplit+0x52>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	0f be c0             	movsbl %al,%eax
  80127d:	50                   	push   %eax
  80127e:	ff 75 0c             	pushl  0xc(%ebp)
  801281:	e8 13 fb ff ff       	call   800d99 <strchr>
  801286:	83 c4 08             	add    $0x8,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 d3                	jne    801260 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	84 c0                	test   %al,%al
  801294:	74 5a                	je     8012f0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801296:	8b 45 14             	mov    0x14(%ebp),%eax
  801299:	8b 00                	mov    (%eax),%eax
  80129b:	83 f8 0f             	cmp    $0xf,%eax
  80129e:	75 07                	jne    8012a7 <strsplit+0x6c>
		{
			return 0;
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a5:	eb 66                	jmp    80130d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012aa:	8b 00                	mov    (%eax),%eax
  8012ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8012af:	8b 55 14             	mov    0x14(%ebp),%edx
  8012b2:	89 0a                	mov    %ecx,(%edx)
  8012b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	01 c2                	add    %eax,%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c5:	eb 03                	jmp    8012ca <strsplit+0x8f>
			string++;
  8012c7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	84 c0                	test   %al,%al
  8012d1:	74 8b                	je     80125e <strsplit+0x23>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	0f be c0             	movsbl %al,%eax
  8012db:	50                   	push   %eax
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 b5 fa ff ff       	call   800d99 <strchr>
  8012e4:	83 c4 08             	add    $0x8,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	74 dc                	je     8012c7 <strsplit+0x8c>
			string++;
	}
  8012eb:	e9 6e ff ff ff       	jmp    80125e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f4:	8b 00                	mov    (%eax),%eax
  8012f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 d0                	add    %edx,%eax
  801302:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801308:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801315:	a1 04 50 80 00       	mov    0x805004,%eax
  80131a:	85 c0                	test   %eax,%eax
  80131c:	74 1f                	je     80133d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131e:	e8 1d 00 00 00       	call   801340 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 10 3e 80 00       	push   $0x803e10
  80132b:	e8 55 f2 ff ff       	call   800585 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801333:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80133a:	00 00 00 
	}
}
  80133d:	90                   	nop
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801346:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80134d:	00 00 00 
  801350:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801357:	00 00 00 
  80135a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801361:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801364:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80136b:	00 00 00 
  80136e:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801375:	00 00 00 
  801378:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80137f:	00 00 00 
	uint32 arr_size = 0;
  801382:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801389:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801398:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139d:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8013a2:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8013a9:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8013ac:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8013b3:	a1 20 51 80 00       	mov    0x805120,%eax
  8013b8:	c1 e0 04             	shl    $0x4,%eax
  8013bb:	89 c2                	mov    %eax,%edx
  8013bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c0:	01 d0                	add    %edx,%eax
  8013c2:	48                   	dec    %eax
  8013c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8013c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ce:	f7 75 ec             	divl   -0x14(%ebp)
  8013d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013d4:	29 d0                	sub    %edx,%eax
  8013d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8013d9:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ed:	83 ec 04             	sub    $0x4,%esp
  8013f0:	6a 06                	push   $0x6
  8013f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8013f5:	50                   	push   %eax
  8013f6:	e8 42 04 00 00       	call   80183d <sys_allocate_chunk>
  8013fb:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013fe:	a1 20 51 80 00       	mov    0x805120,%eax
  801403:	83 ec 0c             	sub    $0xc,%esp
  801406:	50                   	push   %eax
  801407:	e8 b7 0a 00 00       	call   801ec3 <initialize_MemBlocksList>
  80140c:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  80140f:	a1 48 51 80 00       	mov    0x805148,%eax
  801414:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  801417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801421:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801424:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  80142b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80142f:	75 14                	jne    801445 <initialize_dyn_block_system+0x105>
  801431:	83 ec 04             	sub    $0x4,%esp
  801434:	68 35 3e 80 00       	push   $0x803e35
  801439:	6a 33                	push   $0x33
  80143b:	68 53 3e 80 00       	push   $0x803e53
  801440:	e8 8c ee ff ff       	call   8002d1 <_panic>
  801445:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801448:	8b 00                	mov    (%eax),%eax
  80144a:	85 c0                	test   %eax,%eax
  80144c:	74 10                	je     80145e <initialize_dyn_block_system+0x11e>
  80144e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801451:	8b 00                	mov    (%eax),%eax
  801453:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801456:	8b 52 04             	mov    0x4(%edx),%edx
  801459:	89 50 04             	mov    %edx,0x4(%eax)
  80145c:	eb 0b                	jmp    801469 <initialize_dyn_block_system+0x129>
  80145e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801461:	8b 40 04             	mov    0x4(%eax),%eax
  801464:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801469:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146c:	8b 40 04             	mov    0x4(%eax),%eax
  80146f:	85 c0                	test   %eax,%eax
  801471:	74 0f                	je     801482 <initialize_dyn_block_system+0x142>
  801473:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801476:	8b 40 04             	mov    0x4(%eax),%eax
  801479:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80147c:	8b 12                	mov    (%edx),%edx
  80147e:	89 10                	mov    %edx,(%eax)
  801480:	eb 0a                	jmp    80148c <initialize_dyn_block_system+0x14c>
  801482:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801485:	8b 00                	mov    (%eax),%eax
  801487:	a3 48 51 80 00       	mov    %eax,0x805148
  80148c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801495:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801498:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80149f:	a1 54 51 80 00       	mov    0x805154,%eax
  8014a4:	48                   	dec    %eax
  8014a5:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8014aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014ae:	75 14                	jne    8014c4 <initialize_dyn_block_system+0x184>
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	68 60 3e 80 00       	push   $0x803e60
  8014b8:	6a 34                	push   $0x34
  8014ba:	68 53 3e 80 00       	push   $0x803e53
  8014bf:	e8 0d ee ff ff       	call   8002d1 <_panic>
  8014c4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8014ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014cd:	89 10                	mov    %edx,(%eax)
  8014cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d2:	8b 00                	mov    (%eax),%eax
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	74 0d                	je     8014e5 <initialize_dyn_block_system+0x1a5>
  8014d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8014dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014e0:	89 50 04             	mov    %edx,0x4(%eax)
  8014e3:	eb 08                	jmp    8014ed <initialize_dyn_block_system+0x1ad>
  8014e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8014ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8014f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014ff:	a1 44 51 80 00       	mov    0x805144,%eax
  801504:	40                   	inc    %eax
  801505:	a3 44 51 80 00       	mov    %eax,0x805144
}
  80150a:	90                   	nop
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801513:	e8 f7 fd ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  801518:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151c:	75 07                	jne    801525 <malloc+0x18>
  80151e:	b8 00 00 00 00       	mov    $0x0,%eax
  801523:	eb 14                	jmp    801539 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801525:	83 ec 04             	sub    $0x4,%esp
  801528:	68 84 3e 80 00       	push   $0x803e84
  80152d:	6a 46                	push   $0x46
  80152f:	68 53 3e 80 00       	push   $0x803e53
  801534:	e8 98 ed ff ff       	call   8002d1 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801541:	83 ec 04             	sub    $0x4,%esp
  801544:	68 ac 3e 80 00       	push   $0x803eac
  801549:	6a 61                	push   $0x61
  80154b:	68 53 3e 80 00       	push   $0x803e53
  801550:	e8 7c ed ff ff       	call   8002d1 <_panic>

00801555 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 38             	sub    $0x38,%esp
  80155b:	8b 45 10             	mov    0x10(%ebp),%eax
  80155e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801561:	e8 a9 fd ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  801566:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80156a:	75 0a                	jne    801576 <smalloc+0x21>
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
  801571:	e9 9e 00 00 00       	jmp    801614 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801576:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80157d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801583:	01 d0                	add    %edx,%eax
  801585:	48                   	dec    %eax
  801586:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801589:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158c:	ba 00 00 00 00       	mov    $0x0,%edx
  801591:	f7 75 f0             	divl   -0x10(%ebp)
  801594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801597:	29 d0                	sub    %edx,%eax
  801599:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80159c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015a3:	e8 63 06 00 00       	call   801c0b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	74 11                	je     8015bd <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8015ac:	83 ec 0c             	sub    $0xc,%esp
  8015af:	ff 75 e8             	pushl  -0x18(%ebp)
  8015b2:	e8 ce 0c 00 00       	call   802285 <alloc_block_FF>
  8015b7:	83 c4 10             	add    $0x10,%esp
  8015ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015c1:	74 4c                	je     80160f <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c6:	8b 40 08             	mov    0x8(%eax),%eax
  8015c9:	89 c2                	mov    %eax,%edx
  8015cb:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015cf:	52                   	push   %edx
  8015d0:	50                   	push   %eax
  8015d1:	ff 75 0c             	pushl  0xc(%ebp)
  8015d4:	ff 75 08             	pushl  0x8(%ebp)
  8015d7:	e8 b4 03 00 00       	call   801990 <sys_createSharedObject>
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8015e2:	83 ec 08             	sub    $0x8,%esp
  8015e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8015e8:	68 cf 3e 80 00       	push   $0x803ecf
  8015ed:	e8 93 ef ff ff       	call   800585 <cprintf>
  8015f2:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015f5:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015f9:	74 14                	je     80160f <smalloc+0xba>
  8015fb:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015ff:	74 0e                	je     80160f <smalloc+0xba>
  801601:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801605:	74 08                	je     80160f <smalloc+0xba>
			return (void*) mem_block->sva;
  801607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160a:	8b 40 08             	mov    0x8(%eax),%eax
  80160d:	eb 05                	jmp    801614 <smalloc+0xbf>
	}
	return NULL;
  80160f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80161c:	e8 ee fc ff ff       	call   80130f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801621:	83 ec 04             	sub    $0x4,%esp
  801624:	68 e4 3e 80 00       	push   $0x803ee4
  801629:	68 ab 00 00 00       	push   $0xab
  80162e:	68 53 3e 80 00       	push   $0x803e53
  801633:	e8 99 ec ff ff       	call   8002d1 <_panic>

00801638 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80163e:	e8 cc fc ff ff       	call   80130f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	68 08 3f 80 00       	push   $0x803f08
  80164b:	68 ef 00 00 00       	push   $0xef
  801650:	68 53 3e 80 00       	push   $0x803e53
  801655:	e8 77 ec ff ff       	call   8002d1 <_panic>

0080165a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	68 30 3f 80 00       	push   $0x803f30
  801668:	68 03 01 00 00       	push   $0x103
  80166d:	68 53 3e 80 00       	push   $0x803e53
  801672:	e8 5a ec ff ff       	call   8002d1 <_panic>

00801677 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80167d:	83 ec 04             	sub    $0x4,%esp
  801680:	68 54 3f 80 00       	push   $0x803f54
  801685:	68 0e 01 00 00       	push   $0x10e
  80168a:	68 53 3e 80 00       	push   $0x803e53
  80168f:	e8 3d ec ff ff       	call   8002d1 <_panic>

00801694 <shrink>:

}
void shrink(uint32 newSize)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
  801697:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	68 54 3f 80 00       	push   $0x803f54
  8016a2:	68 13 01 00 00       	push   $0x113
  8016a7:	68 53 3e 80 00       	push   $0x803e53
  8016ac:	e8 20 ec ff ff       	call   8002d1 <_panic>

008016b1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
  8016b4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	68 54 3f 80 00       	push   $0x803f54
  8016bf:	68 18 01 00 00       	push   $0x118
  8016c4:	68 53 3e 80 00       	push   $0x803e53
  8016c9:	e8 03 ec ff ff       	call   8002d1 <_panic>

008016ce <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	57                   	push   %edi
  8016d2:	56                   	push   %esi
  8016d3:	53                   	push   %ebx
  8016d4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016e3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016e6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016e9:	cd 30                	int    $0x30
  8016eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016f1:	83 c4 10             	add    $0x10,%esp
  8016f4:	5b                   	pop    %ebx
  8016f5:	5e                   	pop    %esi
  8016f6:	5f                   	pop    %edi
  8016f7:	5d                   	pop    %ebp
  8016f8:	c3                   	ret    

008016f9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 04             	sub    $0x4,%esp
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801705:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	52                   	push   %edx
  801711:	ff 75 0c             	pushl  0xc(%ebp)
  801714:	50                   	push   %eax
  801715:	6a 00                	push   $0x0
  801717:	e8 b2 ff ff ff       	call   8016ce <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	90                   	nop
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <sys_cgetc>:

int
sys_cgetc(void)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 01                	push   $0x1
  801731:	e8 98 ff ff ff       	call   8016ce <syscall>
  801736:	83 c4 18             	add    $0x18,%esp
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80173e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	52                   	push   %edx
  80174b:	50                   	push   %eax
  80174c:	6a 05                	push   $0x5
  80174e:	e8 7b ff ff ff       	call   8016ce <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	56                   	push   %esi
  80175c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80175d:	8b 75 18             	mov    0x18(%ebp),%esi
  801760:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801763:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801766:	8b 55 0c             	mov    0xc(%ebp),%edx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	56                   	push   %esi
  80176d:	53                   	push   %ebx
  80176e:	51                   	push   %ecx
  80176f:	52                   	push   %edx
  801770:	50                   	push   %eax
  801771:	6a 06                	push   $0x6
  801773:	e8 56 ff ff ff       	call   8016ce <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177e:	5b                   	pop    %ebx
  80177f:	5e                   	pop    %esi
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    

00801782 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801785:	8b 55 0c             	mov    0xc(%ebp),%edx
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	52                   	push   %edx
  801792:	50                   	push   %eax
  801793:	6a 07                	push   $0x7
  801795:	e8 34 ff ff ff       	call   8016ce <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	ff 75 0c             	pushl  0xc(%ebp)
  8017ab:	ff 75 08             	pushl  0x8(%ebp)
  8017ae:	6a 08                	push   $0x8
  8017b0:	e8 19 ff ff ff       	call   8016ce <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 09                	push   $0x9
  8017c9:	e8 00 ff ff ff       	call   8016ce <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 0a                	push   $0xa
  8017e2:	e8 e7 fe ff ff       	call   8016ce <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 0b                	push   $0xb
  8017fb:	e8 ce fe ff ff       	call   8016ce <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	ff 75 0c             	pushl  0xc(%ebp)
  801811:	ff 75 08             	pushl  0x8(%ebp)
  801814:	6a 0f                	push   $0xf
  801816:	e8 b3 fe ff ff       	call   8016ce <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
	return;
  80181e:	90                   	nop
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	ff 75 0c             	pushl  0xc(%ebp)
  80182d:	ff 75 08             	pushl  0x8(%ebp)
  801830:	6a 10                	push   $0x10
  801832:	e8 97 fe ff ff       	call   8016ce <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
	return ;
  80183a:	90                   	nop
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	ff 75 10             	pushl  0x10(%ebp)
  801847:	ff 75 0c             	pushl  0xc(%ebp)
  80184a:	ff 75 08             	pushl  0x8(%ebp)
  80184d:	6a 11                	push   $0x11
  80184f:	e8 7a fe ff ff       	call   8016ce <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
	return ;
  801857:	90                   	nop
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 0c                	push   $0xc
  801869:	e8 60 fe ff ff       	call   8016ce <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	ff 75 08             	pushl  0x8(%ebp)
  801881:	6a 0d                	push   $0xd
  801883:	e8 46 fe ff ff       	call   8016ce <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 0e                	push   $0xe
  80189c:	e8 2d fe ff ff       	call   8016ce <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	90                   	nop
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 13                	push   $0x13
  8018b6:	e8 13 fe ff ff       	call   8016ce <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	90                   	nop
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 14                	push   $0x14
  8018d0:	e8 f9 fd ff ff       	call   8016ce <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	90                   	nop
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_cputc>:


void
sys_cputc(const char c)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	83 ec 04             	sub    $0x4,%esp
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018e7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	50                   	push   %eax
  8018f4:	6a 15                	push   $0x15
  8018f6:	e8 d3 fd ff ff       	call   8016ce <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 16                	push   $0x16
  801910:	e8 b9 fd ff ff       	call   8016ce <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	90                   	nop
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	50                   	push   %eax
  80192b:	6a 17                	push   $0x17
  80192d:	e8 9c fd ff ff       	call   8016ce <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80193a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	52                   	push   %edx
  801947:	50                   	push   %eax
  801948:	6a 1a                	push   $0x1a
  80194a:	e8 7f fd ff ff       	call   8016ce <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	52                   	push   %edx
  801964:	50                   	push   %eax
  801965:	6a 18                	push   $0x18
  801967:	e8 62 fd ff ff       	call   8016ce <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	90                   	nop
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801975:	8b 55 0c             	mov    0xc(%ebp),%edx
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	52                   	push   %edx
  801982:	50                   	push   %eax
  801983:	6a 19                	push   $0x19
  801985:	e8 44 fd ff ff       	call   8016ce <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	90                   	nop
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	83 ec 04             	sub    $0x4,%esp
  801996:	8b 45 10             	mov    0x10(%ebp),%eax
  801999:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80199c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80199f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	6a 00                	push   $0x0
  8019a8:	51                   	push   %ecx
  8019a9:	52                   	push   %edx
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	50                   	push   %eax
  8019ae:	6a 1b                	push   $0x1b
  8019b0:	e8 19 fd ff ff       	call   8016ce <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	52                   	push   %edx
  8019ca:	50                   	push   %eax
  8019cb:	6a 1c                	push   $0x1c
  8019cd:	e8 fc fc ff ff       	call   8016ce <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	51                   	push   %ecx
  8019e8:	52                   	push   %edx
  8019e9:	50                   	push   %eax
  8019ea:	6a 1d                	push   $0x1d
  8019ec:	e8 dd fc ff ff       	call   8016ce <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	52                   	push   %edx
  801a06:	50                   	push   %eax
  801a07:	6a 1e                	push   $0x1e
  801a09:	e8 c0 fc ff ff       	call   8016ce <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 1f                	push   $0x1f
  801a22:	e8 a7 fc ff ff       	call   8016ce <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	ff 75 14             	pushl  0x14(%ebp)
  801a37:	ff 75 10             	pushl  0x10(%ebp)
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	50                   	push   %eax
  801a3e:	6a 20                	push   $0x20
  801a40:	e8 89 fc ff ff       	call   8016ce <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	50                   	push   %eax
  801a59:	6a 21                	push   $0x21
  801a5b:	e8 6e fc ff ff       	call   8016ce <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	90                   	nop
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	50                   	push   %eax
  801a75:	6a 22                	push   $0x22
  801a77:	e8 52 fc ff ff       	call   8016ce <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 02                	push   $0x2
  801a90:	e8 39 fc ff ff       	call   8016ce <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 03                	push   $0x3
  801aa9:	e8 20 fc ff ff       	call   8016ce <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 04                	push   $0x4
  801ac2:	e8 07 fc ff ff       	call   8016ce <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_exit_env>:


void sys_exit_env(void)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 23                	push   $0x23
  801adb:	e8 ee fb ff ff       	call   8016ce <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	90                   	nop
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801aec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aef:	8d 50 04             	lea    0x4(%eax),%edx
  801af2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	52                   	push   %edx
  801afc:	50                   	push   %eax
  801afd:	6a 24                	push   $0x24
  801aff:	e8 ca fb ff ff       	call   8016ce <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
	return result;
  801b07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b10:	89 01                	mov    %eax,(%ecx)
  801b12:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	c9                   	leave  
  801b19:	c2 04 00             	ret    $0x4

00801b1c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	ff 75 10             	pushl  0x10(%ebp)
  801b26:	ff 75 0c             	pushl  0xc(%ebp)
  801b29:	ff 75 08             	pushl  0x8(%ebp)
  801b2c:	6a 12                	push   $0x12
  801b2e:	e8 9b fb ff ff       	call   8016ce <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
	return ;
  801b36:	90                   	nop
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 25                	push   $0x25
  801b48:	e8 81 fb ff ff       	call   8016ce <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 04             	sub    $0x4,%esp
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b5e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	50                   	push   %eax
  801b6b:	6a 26                	push   $0x26
  801b6d:	e8 5c fb ff ff       	call   8016ce <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
	return ;
  801b75:	90                   	nop
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <rsttst>:
void rsttst()
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 28                	push   $0x28
  801b87:	e8 42 fb ff ff       	call   8016ce <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8f:	90                   	nop
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b9e:	8b 55 18             	mov    0x18(%ebp),%edx
  801ba1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ba5:	52                   	push   %edx
  801ba6:	50                   	push   %eax
  801ba7:	ff 75 10             	pushl  0x10(%ebp)
  801baa:	ff 75 0c             	pushl  0xc(%ebp)
  801bad:	ff 75 08             	pushl  0x8(%ebp)
  801bb0:	6a 27                	push   $0x27
  801bb2:	e8 17 fb ff ff       	call   8016ce <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bba:	90                   	nop
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <chktst>:
void chktst(uint32 n)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	ff 75 08             	pushl  0x8(%ebp)
  801bcb:	6a 29                	push   $0x29
  801bcd:	e8 fc fa ff ff       	call   8016ce <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd5:	90                   	nop
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <inctst>:

void inctst()
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 2a                	push   $0x2a
  801be7:	e8 e2 fa ff ff       	call   8016ce <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
	return ;
  801bef:	90                   	nop
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <gettst>:
uint32 gettst()
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 2b                	push   $0x2b
  801c01:	e8 c8 fa ff ff       	call   8016ce <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 2c                	push   $0x2c
  801c1d:	e8 ac fa ff ff       	call   8016ce <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
  801c25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c28:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c2c:	75 07                	jne    801c35 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c33:	eb 05                	jmp    801c3a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 2c                	push   $0x2c
  801c4e:	e8 7b fa ff ff       	call   8016ce <syscall>
  801c53:	83 c4 18             	add    $0x18,%esp
  801c56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c59:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c5d:	75 07                	jne    801c66 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c64:	eb 05                	jmp    801c6b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 2c                	push   $0x2c
  801c7f:	e8 4a fa ff ff       	call   8016ce <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
  801c87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c8a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c8e:	75 07                	jne    801c97 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c90:	b8 01 00 00 00       	mov    $0x1,%eax
  801c95:	eb 05                	jmp    801c9c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 2c                	push   $0x2c
  801cb0:	e8 19 fa ff ff       	call   8016ce <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
  801cb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cbb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cbf:	75 07                	jne    801cc8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cc1:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc6:	eb 05                	jmp    801ccd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	ff 75 08             	pushl  0x8(%ebp)
  801cdd:	6a 2d                	push   $0x2d
  801cdf:	e8 ea f9 ff ff       	call   8016ce <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce7:	90                   	nop
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	53                   	push   %ebx
  801cfd:	51                   	push   %ecx
  801cfe:	52                   	push   %edx
  801cff:	50                   	push   %eax
  801d00:	6a 2e                	push   $0x2e
  801d02:	e8 c7 f9 ff ff       	call   8016ce <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	52                   	push   %edx
  801d1f:	50                   	push   %eax
  801d20:	6a 2f                	push   $0x2f
  801d22:	e8 a7 f9 ff ff       	call   8016ce <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	68 64 3f 80 00       	push   $0x803f64
  801d3a:	e8 46 e8 ff ff       	call   800585 <cprintf>
  801d3f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d49:	83 ec 0c             	sub    $0xc,%esp
  801d4c:	68 90 3f 80 00       	push   $0x803f90
  801d51:	e8 2f e8 ff ff       	call   800585 <cprintf>
  801d56:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d59:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d5d:	a1 38 51 80 00       	mov    0x805138,%eax
  801d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d65:	eb 56                	jmp    801dbd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d6b:	74 1c                	je     801d89 <print_mem_block_lists+0x5d>
  801d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d70:	8b 50 08             	mov    0x8(%eax),%edx
  801d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d76:	8b 48 08             	mov    0x8(%eax),%ecx
  801d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7f:	01 c8                	add    %ecx,%eax
  801d81:	39 c2                	cmp    %eax,%edx
  801d83:	73 04                	jae    801d89 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d85:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8c:	8b 50 08             	mov    0x8(%eax),%edx
  801d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d92:	8b 40 0c             	mov    0xc(%eax),%eax
  801d95:	01 c2                	add    %eax,%edx
  801d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9a:	8b 40 08             	mov    0x8(%eax),%eax
  801d9d:	83 ec 04             	sub    $0x4,%esp
  801da0:	52                   	push   %edx
  801da1:	50                   	push   %eax
  801da2:	68 a5 3f 80 00       	push   $0x803fa5
  801da7:	e8 d9 e7 ff ff       	call   800585 <cprintf>
  801dac:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801db5:	a1 40 51 80 00       	mov    0x805140,%eax
  801dba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc1:	74 07                	je     801dca <print_mem_block_lists+0x9e>
  801dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc6:	8b 00                	mov    (%eax),%eax
  801dc8:	eb 05                	jmp    801dcf <print_mem_block_lists+0xa3>
  801dca:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcf:	a3 40 51 80 00       	mov    %eax,0x805140
  801dd4:	a1 40 51 80 00       	mov    0x805140,%eax
  801dd9:	85 c0                	test   %eax,%eax
  801ddb:	75 8a                	jne    801d67 <print_mem_block_lists+0x3b>
  801ddd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de1:	75 84                	jne    801d67 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801de3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801de7:	75 10                	jne    801df9 <print_mem_block_lists+0xcd>
  801de9:	83 ec 0c             	sub    $0xc,%esp
  801dec:	68 b4 3f 80 00       	push   $0x803fb4
  801df1:	e8 8f e7 ff ff       	call   800585 <cprintf>
  801df6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801df9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e00:	83 ec 0c             	sub    $0xc,%esp
  801e03:	68 d8 3f 80 00       	push   $0x803fd8
  801e08:	e8 78 e7 ff ff       	call   800585 <cprintf>
  801e0d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e10:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e14:	a1 40 50 80 00       	mov    0x805040,%eax
  801e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e1c:	eb 56                	jmp    801e74 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e22:	74 1c                	je     801e40 <print_mem_block_lists+0x114>
  801e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e27:	8b 50 08             	mov    0x8(%eax),%edx
  801e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2d:	8b 48 08             	mov    0x8(%eax),%ecx
  801e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e33:	8b 40 0c             	mov    0xc(%eax),%eax
  801e36:	01 c8                	add    %ecx,%eax
  801e38:	39 c2                	cmp    %eax,%edx
  801e3a:	73 04                	jae    801e40 <print_mem_block_lists+0x114>
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
  801e59:	68 a5 3f 80 00       	push   $0x803fa5
  801e5e:	e8 22 e7 ff ff       	call   800585 <cprintf>
  801e63:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e6c:	a1 48 50 80 00       	mov    0x805048,%eax
  801e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e78:	74 07                	je     801e81 <print_mem_block_lists+0x155>
  801e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7d:	8b 00                	mov    (%eax),%eax
  801e7f:	eb 05                	jmp    801e86 <print_mem_block_lists+0x15a>
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
  801e86:	a3 48 50 80 00       	mov    %eax,0x805048
  801e8b:	a1 48 50 80 00       	mov    0x805048,%eax
  801e90:	85 c0                	test   %eax,%eax
  801e92:	75 8a                	jne    801e1e <print_mem_block_lists+0xf2>
  801e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e98:	75 84                	jne    801e1e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e9a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e9e:	75 10                	jne    801eb0 <print_mem_block_lists+0x184>
  801ea0:	83 ec 0c             	sub    $0xc,%esp
  801ea3:	68 f0 3f 80 00       	push   $0x803ff0
  801ea8:	e8 d8 e6 ff ff       	call   800585 <cprintf>
  801ead:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	68 64 3f 80 00       	push   $0x803f64
  801eb8:	e8 c8 e6 ff ff       	call   800585 <cprintf>
  801ebd:	83 c4 10             	add    $0x10,%esp

}
  801ec0:	90                   	nop
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ec9:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ed0:	00 00 00 
  801ed3:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801eda:	00 00 00 
  801edd:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ee4:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ee7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eee:	e9 9e 00 00 00       	jmp    801f91 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ef3:	a1 50 50 80 00       	mov    0x805050,%eax
  801ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efb:	c1 e2 04             	shl    $0x4,%edx
  801efe:	01 d0                	add    %edx,%eax
  801f00:	85 c0                	test   %eax,%eax
  801f02:	75 14                	jne    801f18 <initialize_MemBlocksList+0x55>
  801f04:	83 ec 04             	sub    $0x4,%esp
  801f07:	68 18 40 80 00       	push   $0x804018
  801f0c:	6a 46                	push   $0x46
  801f0e:	68 3b 40 80 00       	push   $0x80403b
  801f13:	e8 b9 e3 ff ff       	call   8002d1 <_panic>
  801f18:	a1 50 50 80 00       	mov    0x805050,%eax
  801f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f20:	c1 e2 04             	shl    $0x4,%edx
  801f23:	01 d0                	add    %edx,%eax
  801f25:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f2b:	89 10                	mov    %edx,(%eax)
  801f2d:	8b 00                	mov    (%eax),%eax
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	74 18                	je     801f4b <initialize_MemBlocksList+0x88>
  801f33:	a1 48 51 80 00       	mov    0x805148,%eax
  801f38:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f3e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f41:	c1 e1 04             	shl    $0x4,%ecx
  801f44:	01 ca                	add    %ecx,%edx
  801f46:	89 50 04             	mov    %edx,0x4(%eax)
  801f49:	eb 12                	jmp    801f5d <initialize_MemBlocksList+0x9a>
  801f4b:	a1 50 50 80 00       	mov    0x805050,%eax
  801f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f53:	c1 e2 04             	shl    $0x4,%edx
  801f56:	01 d0                	add    %edx,%eax
  801f58:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f5d:	a1 50 50 80 00       	mov    0x805050,%eax
  801f62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f65:	c1 e2 04             	shl    $0x4,%edx
  801f68:	01 d0                	add    %edx,%eax
  801f6a:	a3 48 51 80 00       	mov    %eax,0x805148
  801f6f:	a1 50 50 80 00       	mov    0x805050,%eax
  801f74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f77:	c1 e2 04             	shl    $0x4,%edx
  801f7a:	01 d0                	add    %edx,%eax
  801f7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f83:	a1 54 51 80 00       	mov    0x805154,%eax
  801f88:	40                   	inc    %eax
  801f89:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f8e:	ff 45 f4             	incl   -0xc(%ebp)
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f97:	0f 82 56 ff ff ff    	jb     801ef3 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f9d:	90                   	nop
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	8b 00                	mov    (%eax),%eax
  801fab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fae:	eb 19                	jmp    801fc9 <find_block+0x29>
	{
		if(va==point->sva)
  801fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb3:	8b 40 08             	mov    0x8(%eax),%eax
  801fb6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fb9:	75 05                	jne    801fc0 <find_block+0x20>
		   return point;
  801fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fbe:	eb 36                	jmp    801ff6 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc3:	8b 40 08             	mov    0x8(%eax),%eax
  801fc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fc9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fcd:	74 07                	je     801fd6 <find_block+0x36>
  801fcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd2:	8b 00                	mov    (%eax),%eax
  801fd4:	eb 05                	jmp    801fdb <find_block+0x3b>
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  801fde:	89 42 08             	mov    %eax,0x8(%edx)
  801fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe4:	8b 40 08             	mov    0x8(%eax),%eax
  801fe7:	85 c0                	test   %eax,%eax
  801fe9:	75 c5                	jne    801fb0 <find_block+0x10>
  801feb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fef:	75 bf                	jne    801fb0 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801ff1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
  801ffb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801ffe:	a1 40 50 80 00       	mov    0x805040,%eax
  802003:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802006:	a1 44 50 80 00       	mov    0x805044,%eax
  80200b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80200e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802011:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802014:	74 24                	je     80203a <insert_sorted_allocList+0x42>
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	8b 50 08             	mov    0x8(%eax),%edx
  80201c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201f:	8b 40 08             	mov    0x8(%eax),%eax
  802022:	39 c2                	cmp    %eax,%edx
  802024:	76 14                	jbe    80203a <insert_sorted_allocList+0x42>
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	8b 50 08             	mov    0x8(%eax),%edx
  80202c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80202f:	8b 40 08             	mov    0x8(%eax),%eax
  802032:	39 c2                	cmp    %eax,%edx
  802034:	0f 82 60 01 00 00    	jb     80219a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80203a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80203e:	75 65                	jne    8020a5 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802040:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802044:	75 14                	jne    80205a <insert_sorted_allocList+0x62>
  802046:	83 ec 04             	sub    $0x4,%esp
  802049:	68 18 40 80 00       	push   $0x804018
  80204e:	6a 6b                	push   $0x6b
  802050:	68 3b 40 80 00       	push   $0x80403b
  802055:	e8 77 e2 ff ff       	call   8002d1 <_panic>
  80205a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	89 10                	mov    %edx,(%eax)
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	8b 00                	mov    (%eax),%eax
  80206a:	85 c0                	test   %eax,%eax
  80206c:	74 0d                	je     80207b <insert_sorted_allocList+0x83>
  80206e:	a1 40 50 80 00       	mov    0x805040,%eax
  802073:	8b 55 08             	mov    0x8(%ebp),%edx
  802076:	89 50 04             	mov    %edx,0x4(%eax)
  802079:	eb 08                	jmp    802083 <insert_sorted_allocList+0x8b>
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	a3 44 50 80 00       	mov    %eax,0x805044
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	a3 40 50 80 00       	mov    %eax,0x805040
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802095:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80209a:	40                   	inc    %eax
  80209b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020a0:	e9 dc 01 00 00       	jmp    802281 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	8b 50 08             	mov    0x8(%eax),%edx
  8020ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ae:	8b 40 08             	mov    0x8(%eax),%eax
  8020b1:	39 c2                	cmp    %eax,%edx
  8020b3:	77 6c                	ja     802121 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020b9:	74 06                	je     8020c1 <insert_sorted_allocList+0xc9>
  8020bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020bf:	75 14                	jne    8020d5 <insert_sorted_allocList+0xdd>
  8020c1:	83 ec 04             	sub    $0x4,%esp
  8020c4:	68 54 40 80 00       	push   $0x804054
  8020c9:	6a 6f                	push   $0x6f
  8020cb:	68 3b 40 80 00       	push   $0x80403b
  8020d0:	e8 fc e1 ff ff       	call   8002d1 <_panic>
  8020d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d8:	8b 50 04             	mov    0x4(%eax),%edx
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	89 50 04             	mov    %edx,0x4(%eax)
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020e7:	89 10                	mov    %edx,(%eax)
  8020e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ec:	8b 40 04             	mov    0x4(%eax),%eax
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	74 0d                	je     802100 <insert_sorted_allocList+0x108>
  8020f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f6:	8b 40 04             	mov    0x4(%eax),%eax
  8020f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020fc:	89 10                	mov    %edx,(%eax)
  8020fe:	eb 08                	jmp    802108 <insert_sorted_allocList+0x110>
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	a3 40 50 80 00       	mov    %eax,0x805040
  802108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210b:	8b 55 08             	mov    0x8(%ebp),%edx
  80210e:	89 50 04             	mov    %edx,0x4(%eax)
  802111:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802116:	40                   	inc    %eax
  802117:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80211c:	e9 60 01 00 00       	jmp    802281 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	8b 50 08             	mov    0x8(%eax),%edx
  802127:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80212a:	8b 40 08             	mov    0x8(%eax),%eax
  80212d:	39 c2                	cmp    %eax,%edx
  80212f:	0f 82 4c 01 00 00    	jb     802281 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802135:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802139:	75 14                	jne    80214f <insert_sorted_allocList+0x157>
  80213b:	83 ec 04             	sub    $0x4,%esp
  80213e:	68 8c 40 80 00       	push   $0x80408c
  802143:	6a 73                	push   $0x73
  802145:	68 3b 40 80 00       	push   $0x80403b
  80214a:	e8 82 e1 ff ff       	call   8002d1 <_panic>
  80214f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	89 50 04             	mov    %edx,0x4(%eax)
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	8b 40 04             	mov    0x4(%eax),%eax
  802161:	85 c0                	test   %eax,%eax
  802163:	74 0c                	je     802171 <insert_sorted_allocList+0x179>
  802165:	a1 44 50 80 00       	mov    0x805044,%eax
  80216a:	8b 55 08             	mov    0x8(%ebp),%edx
  80216d:	89 10                	mov    %edx,(%eax)
  80216f:	eb 08                	jmp    802179 <insert_sorted_allocList+0x181>
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	a3 40 50 80 00       	mov    %eax,0x805040
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	a3 44 50 80 00       	mov    %eax,0x805044
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80218a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80218f:	40                   	inc    %eax
  802190:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802195:	e9 e7 00 00 00       	jmp    802281 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80219a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021a7:	a1 40 50 80 00       	mov    0x805040,%eax
  8021ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021af:	e9 9d 00 00 00       	jmp    802251 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b7:	8b 00                	mov    (%eax),%eax
  8021b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	8b 50 08             	mov    0x8(%eax),%edx
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	8b 40 08             	mov    0x8(%eax),%eax
  8021c8:	39 c2                	cmp    %eax,%edx
  8021ca:	76 7d                	jbe    802249 <insert_sorted_allocList+0x251>
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	8b 50 08             	mov    0x8(%eax),%edx
  8021d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021d5:	8b 40 08             	mov    0x8(%eax),%eax
  8021d8:	39 c2                	cmp    %eax,%edx
  8021da:	73 6d                	jae    802249 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e0:	74 06                	je     8021e8 <insert_sorted_allocList+0x1f0>
  8021e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e6:	75 14                	jne    8021fc <insert_sorted_allocList+0x204>
  8021e8:	83 ec 04             	sub    $0x4,%esp
  8021eb:	68 b0 40 80 00       	push   $0x8040b0
  8021f0:	6a 7f                	push   $0x7f
  8021f2:	68 3b 40 80 00       	push   $0x80403b
  8021f7:	e8 d5 e0 ff ff       	call   8002d1 <_panic>
  8021fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ff:	8b 10                	mov    (%eax),%edx
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	89 10                	mov    %edx,(%eax)
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	8b 00                	mov    (%eax),%eax
  80220b:	85 c0                	test   %eax,%eax
  80220d:	74 0b                	je     80221a <insert_sorted_allocList+0x222>
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	8b 00                	mov    (%eax),%eax
  802214:	8b 55 08             	mov    0x8(%ebp),%edx
  802217:	89 50 04             	mov    %edx,0x4(%eax)
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	8b 55 08             	mov    0x8(%ebp),%edx
  802220:	89 10                	mov    %edx,(%eax)
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802228:	89 50 04             	mov    %edx,0x4(%eax)
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	8b 00                	mov    (%eax),%eax
  802230:	85 c0                	test   %eax,%eax
  802232:	75 08                	jne    80223c <insert_sorted_allocList+0x244>
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	a3 44 50 80 00       	mov    %eax,0x805044
  80223c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802241:	40                   	inc    %eax
  802242:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802247:	eb 39                	jmp    802282 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802249:	a1 48 50 80 00       	mov    0x805048,%eax
  80224e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802251:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802255:	74 07                	je     80225e <insert_sorted_allocList+0x266>
  802257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225a:	8b 00                	mov    (%eax),%eax
  80225c:	eb 05                	jmp    802263 <insert_sorted_allocList+0x26b>
  80225e:	b8 00 00 00 00       	mov    $0x0,%eax
  802263:	a3 48 50 80 00       	mov    %eax,0x805048
  802268:	a1 48 50 80 00       	mov    0x805048,%eax
  80226d:	85 c0                	test   %eax,%eax
  80226f:	0f 85 3f ff ff ff    	jne    8021b4 <insert_sorted_allocList+0x1bc>
  802275:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802279:	0f 85 35 ff ff ff    	jne    8021b4 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80227f:	eb 01                	jmp    802282 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802281:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802282:	90                   	nop
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80228b:	a1 38 51 80 00       	mov    0x805138,%eax
  802290:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802293:	e9 85 01 00 00       	jmp    80241d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229b:	8b 40 0c             	mov    0xc(%eax),%eax
  80229e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022a1:	0f 82 6e 01 00 00    	jb     802415 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022b0:	0f 85 8a 00 00 00    	jne    802340 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ba:	75 17                	jne    8022d3 <alloc_block_FF+0x4e>
  8022bc:	83 ec 04             	sub    $0x4,%esp
  8022bf:	68 e4 40 80 00       	push   $0x8040e4
  8022c4:	68 93 00 00 00       	push   $0x93
  8022c9:	68 3b 40 80 00       	push   $0x80403b
  8022ce:	e8 fe df ff ff       	call   8002d1 <_panic>
  8022d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d6:	8b 00                	mov    (%eax),%eax
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	74 10                	je     8022ec <alloc_block_FF+0x67>
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	8b 00                	mov    (%eax),%eax
  8022e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e4:	8b 52 04             	mov    0x4(%edx),%edx
  8022e7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ea:	eb 0b                	jmp    8022f7 <alloc_block_FF+0x72>
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	8b 40 04             	mov    0x4(%eax),%eax
  8022f2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	8b 40 04             	mov    0x4(%eax),%eax
  8022fd:	85 c0                	test   %eax,%eax
  8022ff:	74 0f                	je     802310 <alloc_block_FF+0x8b>
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 40 04             	mov    0x4(%eax),%eax
  802307:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230a:	8b 12                	mov    (%edx),%edx
  80230c:	89 10                	mov    %edx,(%eax)
  80230e:	eb 0a                	jmp    80231a <alloc_block_FF+0x95>
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	8b 00                	mov    (%eax),%eax
  802315:	a3 38 51 80 00       	mov    %eax,0x805138
  80231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80232d:	a1 44 51 80 00       	mov    0x805144,%eax
  802332:	48                   	dec    %eax
  802333:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	e9 10 01 00 00       	jmp    802450 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 40 0c             	mov    0xc(%eax),%eax
  802346:	3b 45 08             	cmp    0x8(%ebp),%eax
  802349:	0f 86 c6 00 00 00    	jbe    802415 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80234f:	a1 48 51 80 00       	mov    0x805148,%eax
  802354:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 50 08             	mov    0x8(%eax),%edx
  80235d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802360:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802363:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802366:	8b 55 08             	mov    0x8(%ebp),%edx
  802369:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80236c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802370:	75 17                	jne    802389 <alloc_block_FF+0x104>
  802372:	83 ec 04             	sub    $0x4,%esp
  802375:	68 e4 40 80 00       	push   $0x8040e4
  80237a:	68 9b 00 00 00       	push   $0x9b
  80237f:	68 3b 40 80 00       	push   $0x80403b
  802384:	e8 48 df ff ff       	call   8002d1 <_panic>
  802389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238c:	8b 00                	mov    (%eax),%eax
  80238e:	85 c0                	test   %eax,%eax
  802390:	74 10                	je     8023a2 <alloc_block_FF+0x11d>
  802392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802395:	8b 00                	mov    (%eax),%eax
  802397:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80239a:	8b 52 04             	mov    0x4(%edx),%edx
  80239d:	89 50 04             	mov    %edx,0x4(%eax)
  8023a0:	eb 0b                	jmp    8023ad <alloc_block_FF+0x128>
  8023a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a5:	8b 40 04             	mov    0x4(%eax),%eax
  8023a8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b0:	8b 40 04             	mov    0x4(%eax),%eax
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	74 0f                	je     8023c6 <alloc_block_FF+0x141>
  8023b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ba:	8b 40 04             	mov    0x4(%eax),%eax
  8023bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023c0:	8b 12                	mov    (%edx),%edx
  8023c2:	89 10                	mov    %edx,(%eax)
  8023c4:	eb 0a                	jmp    8023d0 <alloc_block_FF+0x14b>
  8023c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c9:	8b 00                	mov    (%eax),%eax
  8023cb:	a3 48 51 80 00       	mov    %eax,0x805148
  8023d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e3:	a1 54 51 80 00       	mov    0x805154,%eax
  8023e8:	48                   	dec    %eax
  8023e9:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	8b 50 08             	mov    0x8(%eax),%edx
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	01 c2                	add    %eax,%edx
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	8b 40 0c             	mov    0xc(%eax),%eax
  802405:	2b 45 08             	sub    0x8(%ebp),%eax
  802408:	89 c2                	mov    %eax,%edx
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802413:	eb 3b                	jmp    802450 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802415:	a1 40 51 80 00       	mov    0x805140,%eax
  80241a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80241d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802421:	74 07                	je     80242a <alloc_block_FF+0x1a5>
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 00                	mov    (%eax),%eax
  802428:	eb 05                	jmp    80242f <alloc_block_FF+0x1aa>
  80242a:	b8 00 00 00 00       	mov    $0x0,%eax
  80242f:	a3 40 51 80 00       	mov    %eax,0x805140
  802434:	a1 40 51 80 00       	mov    0x805140,%eax
  802439:	85 c0                	test   %eax,%eax
  80243b:	0f 85 57 fe ff ff    	jne    802298 <alloc_block_FF+0x13>
  802441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802445:	0f 85 4d fe ff ff    	jne    802298 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80244b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802458:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80245f:	a1 38 51 80 00       	mov    0x805138,%eax
  802464:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802467:	e9 df 00 00 00       	jmp    80254b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 0c             	mov    0xc(%eax),%eax
  802472:	3b 45 08             	cmp    0x8(%ebp),%eax
  802475:	0f 82 c8 00 00 00    	jb     802543 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 40 0c             	mov    0xc(%eax),%eax
  802481:	3b 45 08             	cmp    0x8(%ebp),%eax
  802484:	0f 85 8a 00 00 00    	jne    802514 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80248a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248e:	75 17                	jne    8024a7 <alloc_block_BF+0x55>
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	68 e4 40 80 00       	push   $0x8040e4
  802498:	68 b7 00 00 00       	push   $0xb7
  80249d:	68 3b 40 80 00       	push   $0x80403b
  8024a2:	e8 2a de ff ff       	call   8002d1 <_panic>
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 00                	mov    (%eax),%eax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	74 10                	je     8024c0 <alloc_block_BF+0x6e>
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b8:	8b 52 04             	mov    0x4(%edx),%edx
  8024bb:	89 50 04             	mov    %edx,0x4(%eax)
  8024be:	eb 0b                	jmp    8024cb <alloc_block_BF+0x79>
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 40 04             	mov    0x4(%eax),%eax
  8024c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 40 04             	mov    0x4(%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 0f                	je     8024e4 <alloc_block_BF+0x92>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 40 04             	mov    0x4(%eax),%eax
  8024db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024de:	8b 12                	mov    (%edx),%edx
  8024e0:	89 10                	mov    %edx,(%eax)
  8024e2:	eb 0a                	jmp    8024ee <alloc_block_BF+0x9c>
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	a3 38 51 80 00       	mov    %eax,0x805138
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802501:	a1 44 51 80 00       	mov    0x805144,%eax
  802506:	48                   	dec    %eax
  802507:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	e9 4d 01 00 00       	jmp    802661 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 40 0c             	mov    0xc(%eax),%eax
  80251a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251d:	76 24                	jbe    802543 <alloc_block_BF+0xf1>
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 40 0c             	mov    0xc(%eax),%eax
  802525:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802528:	73 19                	jae    802543 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80252a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 40 0c             	mov    0xc(%eax),%eax
  802537:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 40 08             	mov    0x8(%eax),%eax
  802540:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802543:	a1 40 51 80 00       	mov    0x805140,%eax
  802548:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254f:	74 07                	je     802558 <alloc_block_BF+0x106>
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 00                	mov    (%eax),%eax
  802556:	eb 05                	jmp    80255d <alloc_block_BF+0x10b>
  802558:	b8 00 00 00 00       	mov    $0x0,%eax
  80255d:	a3 40 51 80 00       	mov    %eax,0x805140
  802562:	a1 40 51 80 00       	mov    0x805140,%eax
  802567:	85 c0                	test   %eax,%eax
  802569:	0f 85 fd fe ff ff    	jne    80246c <alloc_block_BF+0x1a>
  80256f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802573:	0f 85 f3 fe ff ff    	jne    80246c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802579:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80257d:	0f 84 d9 00 00 00    	je     80265c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802583:	a1 48 51 80 00       	mov    0x805148,%eax
  802588:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80258b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802591:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802597:	8b 55 08             	mov    0x8(%ebp),%edx
  80259a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80259d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025a1:	75 17                	jne    8025ba <alloc_block_BF+0x168>
  8025a3:	83 ec 04             	sub    $0x4,%esp
  8025a6:	68 e4 40 80 00       	push   $0x8040e4
  8025ab:	68 c7 00 00 00       	push   $0xc7
  8025b0:	68 3b 40 80 00       	push   $0x80403b
  8025b5:	e8 17 dd ff ff       	call   8002d1 <_panic>
  8025ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	74 10                	je     8025d3 <alloc_block_BF+0x181>
  8025c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c6:	8b 00                	mov    (%eax),%eax
  8025c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025cb:	8b 52 04             	mov    0x4(%edx),%edx
  8025ce:	89 50 04             	mov    %edx,0x4(%eax)
  8025d1:	eb 0b                	jmp    8025de <alloc_block_BF+0x18c>
  8025d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d6:	8b 40 04             	mov    0x4(%eax),%eax
  8025d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e1:	8b 40 04             	mov    0x4(%eax),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 0f                	je     8025f7 <alloc_block_BF+0x1a5>
  8025e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025eb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025f1:	8b 12                	mov    (%edx),%edx
  8025f3:	89 10                	mov    %edx,(%eax)
  8025f5:	eb 0a                	jmp    802601 <alloc_block_BF+0x1af>
  8025f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	a3 48 51 80 00       	mov    %eax,0x805148
  802601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802604:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802614:	a1 54 51 80 00       	mov    0x805154,%eax
  802619:	48                   	dec    %eax
  80261a:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80261f:	83 ec 08             	sub    $0x8,%esp
  802622:	ff 75 ec             	pushl  -0x14(%ebp)
  802625:	68 38 51 80 00       	push   $0x805138
  80262a:	e8 71 f9 ff ff       	call   801fa0 <find_block>
  80262f:	83 c4 10             	add    $0x10,%esp
  802632:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802635:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802638:	8b 50 08             	mov    0x8(%eax),%edx
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	01 c2                	add    %eax,%edx
  802640:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802643:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802646:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802649:	8b 40 0c             	mov    0xc(%eax),%eax
  80264c:	2b 45 08             	sub    0x8(%ebp),%eax
  80264f:	89 c2                	mov    %eax,%edx
  802651:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802654:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265a:	eb 05                	jmp    802661 <alloc_block_BF+0x20f>
	}
	return NULL;
  80265c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802661:	c9                   	leave  
  802662:	c3                   	ret    

00802663 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802669:	a1 28 50 80 00       	mov    0x805028,%eax
  80266e:	85 c0                	test   %eax,%eax
  802670:	0f 85 de 01 00 00    	jne    802854 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802676:	a1 38 51 80 00       	mov    0x805138,%eax
  80267b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267e:	e9 9e 01 00 00       	jmp    802821 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 40 0c             	mov    0xc(%eax),%eax
  802689:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268c:	0f 82 87 01 00 00    	jb     802819 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 40 0c             	mov    0xc(%eax),%eax
  802698:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269b:	0f 85 95 00 00 00    	jne    802736 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a5:	75 17                	jne    8026be <alloc_block_NF+0x5b>
  8026a7:	83 ec 04             	sub    $0x4,%esp
  8026aa:	68 e4 40 80 00       	push   $0x8040e4
  8026af:	68 e0 00 00 00       	push   $0xe0
  8026b4:	68 3b 40 80 00       	push   $0x80403b
  8026b9:	e8 13 dc ff ff       	call   8002d1 <_panic>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	74 10                	je     8026d7 <alloc_block_NF+0x74>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 00                	mov    (%eax),%eax
  8026cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cf:	8b 52 04             	mov    0x4(%edx),%edx
  8026d2:	89 50 04             	mov    %edx,0x4(%eax)
  8026d5:	eb 0b                	jmp    8026e2 <alloc_block_NF+0x7f>
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 40 04             	mov    0x4(%eax),%eax
  8026dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 40 04             	mov    0x4(%eax),%eax
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	74 0f                	je     8026fb <alloc_block_NF+0x98>
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 40 04             	mov    0x4(%eax),%eax
  8026f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f5:	8b 12                	mov    (%edx),%edx
  8026f7:	89 10                	mov    %edx,(%eax)
  8026f9:	eb 0a                	jmp    802705 <alloc_block_NF+0xa2>
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 00                	mov    (%eax),%eax
  802700:	a3 38 51 80 00       	mov    %eax,0x805138
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802718:	a1 44 51 80 00       	mov    0x805144,%eax
  80271d:	48                   	dec    %eax
  80271e:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 40 08             	mov    0x8(%eax),%eax
  802729:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	e9 f8 04 00 00       	jmp    802c2e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 40 0c             	mov    0xc(%eax),%eax
  80273c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273f:	0f 86 d4 00 00 00    	jbe    802819 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802745:	a1 48 51 80 00       	mov    0x805148,%eax
  80274a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	8b 50 08             	mov    0x8(%eax),%edx
  802753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802756:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802759:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275c:	8b 55 08             	mov    0x8(%ebp),%edx
  80275f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802762:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802766:	75 17                	jne    80277f <alloc_block_NF+0x11c>
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	68 e4 40 80 00       	push   $0x8040e4
  802770:	68 e9 00 00 00       	push   $0xe9
  802775:	68 3b 40 80 00       	push   $0x80403b
  80277a:	e8 52 db ff ff       	call   8002d1 <_panic>
  80277f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	74 10                	je     802798 <alloc_block_NF+0x135>
  802788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802790:	8b 52 04             	mov    0x4(%edx),%edx
  802793:	89 50 04             	mov    %edx,0x4(%eax)
  802796:	eb 0b                	jmp    8027a3 <alloc_block_NF+0x140>
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	8b 40 04             	mov    0x4(%eax),%eax
  80279e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a6:	8b 40 04             	mov    0x4(%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	74 0f                	je     8027bc <alloc_block_NF+0x159>
  8027ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b0:	8b 40 04             	mov    0x4(%eax),%eax
  8027b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027b6:	8b 12                	mov    (%edx),%edx
  8027b8:	89 10                	mov    %edx,(%eax)
  8027ba:	eb 0a                	jmp    8027c6 <alloc_block_NF+0x163>
  8027bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bf:	8b 00                	mov    (%eax),%eax
  8027c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8027c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8027de:	48                   	dec    %eax
  8027df:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e7:	8b 40 08             	mov    0x8(%eax),%eax
  8027ea:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 50 08             	mov    0x8(%eax),%edx
  8027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f8:	01 c2                	add    %eax,%edx
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 40 0c             	mov    0xc(%eax),%eax
  802806:	2b 45 08             	sub    0x8(%ebp),%eax
  802809:	89 c2                	mov    %eax,%edx
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802814:	e9 15 04 00 00       	jmp    802c2e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802819:	a1 40 51 80 00       	mov    0x805140,%eax
  80281e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802825:	74 07                	je     80282e <alloc_block_NF+0x1cb>
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	eb 05                	jmp    802833 <alloc_block_NF+0x1d0>
  80282e:	b8 00 00 00 00       	mov    $0x0,%eax
  802833:	a3 40 51 80 00       	mov    %eax,0x805140
  802838:	a1 40 51 80 00       	mov    0x805140,%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	0f 85 3e fe ff ff    	jne    802683 <alloc_block_NF+0x20>
  802845:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802849:	0f 85 34 fe ff ff    	jne    802683 <alloc_block_NF+0x20>
  80284f:	e9 d5 03 00 00       	jmp    802c29 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802854:	a1 38 51 80 00       	mov    0x805138,%eax
  802859:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285c:	e9 b1 01 00 00       	jmp    802a12 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	8b 50 08             	mov    0x8(%eax),%edx
  802867:	a1 28 50 80 00       	mov    0x805028,%eax
  80286c:	39 c2                	cmp    %eax,%edx
  80286e:	0f 82 96 01 00 00    	jb     802a0a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 40 0c             	mov    0xc(%eax),%eax
  80287a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287d:	0f 82 87 01 00 00    	jb     802a0a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	8b 40 0c             	mov    0xc(%eax),%eax
  802889:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288c:	0f 85 95 00 00 00    	jne    802927 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802892:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802896:	75 17                	jne    8028af <alloc_block_NF+0x24c>
  802898:	83 ec 04             	sub    $0x4,%esp
  80289b:	68 e4 40 80 00       	push   $0x8040e4
  8028a0:	68 fc 00 00 00       	push   $0xfc
  8028a5:	68 3b 40 80 00       	push   $0x80403b
  8028aa:	e8 22 da ff ff       	call   8002d1 <_panic>
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 00                	mov    (%eax),%eax
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	74 10                	je     8028c8 <alloc_block_NF+0x265>
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 00                	mov    (%eax),%eax
  8028bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c0:	8b 52 04             	mov    0x4(%edx),%edx
  8028c3:	89 50 04             	mov    %edx,0x4(%eax)
  8028c6:	eb 0b                	jmp    8028d3 <alloc_block_NF+0x270>
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 40 04             	mov    0x4(%eax),%eax
  8028d9:	85 c0                	test   %eax,%eax
  8028db:	74 0f                	je     8028ec <alloc_block_NF+0x289>
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 40 04             	mov    0x4(%eax),%eax
  8028e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e6:	8b 12                	mov    (%edx),%edx
  8028e8:	89 10                	mov    %edx,(%eax)
  8028ea:	eb 0a                	jmp    8028f6 <alloc_block_NF+0x293>
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802909:	a1 44 51 80 00       	mov    0x805144,%eax
  80290e:	48                   	dec    %eax
  80290f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 40 08             	mov    0x8(%eax),%eax
  80291a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	e9 07 03 00 00       	jmp    802c2e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	8b 40 0c             	mov    0xc(%eax),%eax
  80292d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802930:	0f 86 d4 00 00 00    	jbe    802a0a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802936:	a1 48 51 80 00       	mov    0x805148,%eax
  80293b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 50 08             	mov    0x8(%eax),%edx
  802944:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802947:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80294a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294d:	8b 55 08             	mov    0x8(%ebp),%edx
  802950:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802953:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802957:	75 17                	jne    802970 <alloc_block_NF+0x30d>
  802959:	83 ec 04             	sub    $0x4,%esp
  80295c:	68 e4 40 80 00       	push   $0x8040e4
  802961:	68 04 01 00 00       	push   $0x104
  802966:	68 3b 40 80 00       	push   $0x80403b
  80296b:	e8 61 d9 ff ff       	call   8002d1 <_panic>
  802970:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	85 c0                	test   %eax,%eax
  802977:	74 10                	je     802989 <alloc_block_NF+0x326>
  802979:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297c:	8b 00                	mov    (%eax),%eax
  80297e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802981:	8b 52 04             	mov    0x4(%edx),%edx
  802984:	89 50 04             	mov    %edx,0x4(%eax)
  802987:	eb 0b                	jmp    802994 <alloc_block_NF+0x331>
  802989:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298c:	8b 40 04             	mov    0x4(%eax),%eax
  80298f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802994:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802997:	8b 40 04             	mov    0x4(%eax),%eax
  80299a:	85 c0                	test   %eax,%eax
  80299c:	74 0f                	je     8029ad <alloc_block_NF+0x34a>
  80299e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a1:	8b 40 04             	mov    0x4(%eax),%eax
  8029a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029a7:	8b 12                	mov    (%edx),%edx
  8029a9:	89 10                	mov    %edx,(%eax)
  8029ab:	eb 0a                	jmp    8029b7 <alloc_block_NF+0x354>
  8029ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	a3 48 51 80 00       	mov    %eax,0x805148
  8029b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8029cf:	48                   	dec    %eax
  8029d0:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d8:	8b 40 08             	mov    0x8(%eax),%eax
  8029db:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 50 08             	mov    0x8(%eax),%edx
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	01 c2                	add    %eax,%edx
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f7:	2b 45 08             	sub    0x8(%ebp),%eax
  8029fa:	89 c2                	mov    %eax,%edx
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a05:	e9 24 02 00 00       	jmp    802c2e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a0a:	a1 40 51 80 00       	mov    0x805140,%eax
  802a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a16:	74 07                	je     802a1f <alloc_block_NF+0x3bc>
  802a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1b:	8b 00                	mov    (%eax),%eax
  802a1d:	eb 05                	jmp    802a24 <alloc_block_NF+0x3c1>
  802a1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a24:	a3 40 51 80 00       	mov    %eax,0x805140
  802a29:	a1 40 51 80 00       	mov    0x805140,%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	0f 85 2b fe ff ff    	jne    802861 <alloc_block_NF+0x1fe>
  802a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3a:	0f 85 21 fe ff ff    	jne    802861 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a40:	a1 38 51 80 00       	mov    0x805138,%eax
  802a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a48:	e9 ae 01 00 00       	jmp    802bfb <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 50 08             	mov    0x8(%eax),%edx
  802a53:	a1 28 50 80 00       	mov    0x805028,%eax
  802a58:	39 c2                	cmp    %eax,%edx
  802a5a:	0f 83 93 01 00 00    	jae    802bf3 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 40 0c             	mov    0xc(%eax),%eax
  802a66:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a69:	0f 82 84 01 00 00    	jb     802bf3 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	8b 40 0c             	mov    0xc(%eax),%eax
  802a75:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a78:	0f 85 95 00 00 00    	jne    802b13 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a82:	75 17                	jne    802a9b <alloc_block_NF+0x438>
  802a84:	83 ec 04             	sub    $0x4,%esp
  802a87:	68 e4 40 80 00       	push   $0x8040e4
  802a8c:	68 14 01 00 00       	push   $0x114
  802a91:	68 3b 40 80 00       	push   $0x80403b
  802a96:	e8 36 d8 ff ff       	call   8002d1 <_panic>
  802a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	74 10                	je     802ab4 <alloc_block_NF+0x451>
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aac:	8b 52 04             	mov    0x4(%edx),%edx
  802aaf:	89 50 04             	mov    %edx,0x4(%eax)
  802ab2:	eb 0b                	jmp    802abf <alloc_block_NF+0x45c>
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 40 04             	mov    0x4(%eax),%eax
  802aba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 40 04             	mov    0x4(%eax),%eax
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	74 0f                	je     802ad8 <alloc_block_NF+0x475>
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	8b 40 04             	mov    0x4(%eax),%eax
  802acf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad2:	8b 12                	mov    (%edx),%edx
  802ad4:	89 10                	mov    %edx,(%eax)
  802ad6:	eb 0a                	jmp    802ae2 <alloc_block_NF+0x47f>
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	a3 38 51 80 00       	mov    %eax,0x805138
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af5:	a1 44 51 80 00       	mov    0x805144,%eax
  802afa:	48                   	dec    %eax
  802afb:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 40 08             	mov    0x8(%eax),%eax
  802b06:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	e9 1b 01 00 00       	jmp    802c2e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b16:	8b 40 0c             	mov    0xc(%eax),%eax
  802b19:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b1c:	0f 86 d1 00 00 00    	jbe    802bf3 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b22:	a1 48 51 80 00       	mov    0x805148,%eax
  802b27:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 50 08             	mov    0x8(%eax),%edx
  802b30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b33:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b39:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b43:	75 17                	jne    802b5c <alloc_block_NF+0x4f9>
  802b45:	83 ec 04             	sub    $0x4,%esp
  802b48:	68 e4 40 80 00       	push   $0x8040e4
  802b4d:	68 1c 01 00 00       	push   $0x11c
  802b52:	68 3b 40 80 00       	push   $0x80403b
  802b57:	e8 75 d7 ff ff       	call   8002d1 <_panic>
  802b5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5f:	8b 00                	mov    (%eax),%eax
  802b61:	85 c0                	test   %eax,%eax
  802b63:	74 10                	je     802b75 <alloc_block_NF+0x512>
  802b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b68:	8b 00                	mov    (%eax),%eax
  802b6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b6d:	8b 52 04             	mov    0x4(%edx),%edx
  802b70:	89 50 04             	mov    %edx,0x4(%eax)
  802b73:	eb 0b                	jmp    802b80 <alloc_block_NF+0x51d>
  802b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b78:	8b 40 04             	mov    0x4(%eax),%eax
  802b7b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b83:	8b 40 04             	mov    0x4(%eax),%eax
  802b86:	85 c0                	test   %eax,%eax
  802b88:	74 0f                	je     802b99 <alloc_block_NF+0x536>
  802b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8d:	8b 40 04             	mov    0x4(%eax),%eax
  802b90:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b93:	8b 12                	mov    (%edx),%edx
  802b95:	89 10                	mov    %edx,(%eax)
  802b97:	eb 0a                	jmp    802ba3 <alloc_block_NF+0x540>
  802b99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9c:	8b 00                	mov    (%eax),%eax
  802b9e:	a3 48 51 80 00       	mov    %eax,0x805148
  802ba3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb6:	a1 54 51 80 00       	mov    0x805154,%eax
  802bbb:	48                   	dec    %eax
  802bbc:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc4:	8b 40 08             	mov    0x8(%eax),%eax
  802bc7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 50 08             	mov    0x8(%eax),%edx
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	01 c2                	add    %eax,%edx
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 40 0c             	mov    0xc(%eax),%eax
  802be3:	2b 45 08             	sub    0x8(%ebp),%eax
  802be6:	89 c2                	mov    %eax,%edx
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf1:	eb 3b                	jmp    802c2e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bf3:	a1 40 51 80 00       	mov    0x805140,%eax
  802bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bff:	74 07                	je     802c08 <alloc_block_NF+0x5a5>
  802c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c04:	8b 00                	mov    (%eax),%eax
  802c06:	eb 05                	jmp    802c0d <alloc_block_NF+0x5aa>
  802c08:	b8 00 00 00 00       	mov    $0x0,%eax
  802c0d:	a3 40 51 80 00       	mov    %eax,0x805140
  802c12:	a1 40 51 80 00       	mov    0x805140,%eax
  802c17:	85 c0                	test   %eax,%eax
  802c19:	0f 85 2e fe ff ff    	jne    802a4d <alloc_block_NF+0x3ea>
  802c1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c23:	0f 85 24 fe ff ff    	jne    802a4d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c2e:	c9                   	leave  
  802c2f:	c3                   	ret    

00802c30 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c30:	55                   	push   %ebp
  802c31:	89 e5                	mov    %esp,%ebp
  802c33:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c36:	a1 38 51 80 00       	mov    0x805138,%eax
  802c3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c3e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c43:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c46:	a1 38 51 80 00       	mov    0x805138,%eax
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	74 14                	je     802c63 <insert_sorted_with_merge_freeList+0x33>
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	8b 50 08             	mov    0x8(%eax),%edx
  802c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c58:	8b 40 08             	mov    0x8(%eax),%eax
  802c5b:	39 c2                	cmp    %eax,%edx
  802c5d:	0f 87 9b 01 00 00    	ja     802dfe <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c67:	75 17                	jne    802c80 <insert_sorted_with_merge_freeList+0x50>
  802c69:	83 ec 04             	sub    $0x4,%esp
  802c6c:	68 18 40 80 00       	push   $0x804018
  802c71:	68 38 01 00 00       	push   $0x138
  802c76:	68 3b 40 80 00       	push   $0x80403b
  802c7b:	e8 51 d6 ff ff       	call   8002d1 <_panic>
  802c80:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	89 10                	mov    %edx,(%eax)
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	8b 00                	mov    (%eax),%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	74 0d                	je     802ca1 <insert_sorted_with_merge_freeList+0x71>
  802c94:	a1 38 51 80 00       	mov    0x805138,%eax
  802c99:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9c:	89 50 04             	mov    %edx,0x4(%eax)
  802c9f:	eb 08                	jmp    802ca9 <insert_sorted_with_merge_freeList+0x79>
  802ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cac:	a3 38 51 80 00       	mov    %eax,0x805138
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbb:	a1 44 51 80 00       	mov    0x805144,%eax
  802cc0:	40                   	inc    %eax
  802cc1:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cca:	0f 84 a8 06 00 00    	je     803378 <insert_sorted_with_merge_freeList+0x748>
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	8b 50 08             	mov    0x8(%eax),%edx
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdc:	01 c2                	add    %eax,%edx
  802cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce1:	8b 40 08             	mov    0x8(%eax),%eax
  802ce4:	39 c2                	cmp    %eax,%edx
  802ce6:	0f 85 8c 06 00 00    	jne    803378 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	8b 50 0c             	mov    0xc(%eax),%edx
  802cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf8:	01 c2                	add    %eax,%edx
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d04:	75 17                	jne    802d1d <insert_sorted_with_merge_freeList+0xed>
  802d06:	83 ec 04             	sub    $0x4,%esp
  802d09:	68 e4 40 80 00       	push   $0x8040e4
  802d0e:	68 3c 01 00 00       	push   $0x13c
  802d13:	68 3b 40 80 00       	push   $0x80403b
  802d18:	e8 b4 d5 ff ff       	call   8002d1 <_panic>
  802d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d20:	8b 00                	mov    (%eax),%eax
  802d22:	85 c0                	test   %eax,%eax
  802d24:	74 10                	je     802d36 <insert_sorted_with_merge_freeList+0x106>
  802d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d29:	8b 00                	mov    (%eax),%eax
  802d2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2e:	8b 52 04             	mov    0x4(%edx),%edx
  802d31:	89 50 04             	mov    %edx,0x4(%eax)
  802d34:	eb 0b                	jmp    802d41 <insert_sorted_with_merge_freeList+0x111>
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	8b 40 04             	mov    0x4(%eax),%eax
  802d3c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d44:	8b 40 04             	mov    0x4(%eax),%eax
  802d47:	85 c0                	test   %eax,%eax
  802d49:	74 0f                	je     802d5a <insert_sorted_with_merge_freeList+0x12a>
  802d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4e:	8b 40 04             	mov    0x4(%eax),%eax
  802d51:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d54:	8b 12                	mov    (%edx),%edx
  802d56:	89 10                	mov    %edx,(%eax)
  802d58:	eb 0a                	jmp    802d64 <insert_sorted_with_merge_freeList+0x134>
  802d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5d:	8b 00                	mov    (%eax),%eax
  802d5f:	a3 38 51 80 00       	mov    %eax,0x805138
  802d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d77:	a1 44 51 80 00       	mov    0x805144,%eax
  802d7c:	48                   	dec    %eax
  802d7d:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d85:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9a:	75 17                	jne    802db3 <insert_sorted_with_merge_freeList+0x183>
  802d9c:	83 ec 04             	sub    $0x4,%esp
  802d9f:	68 18 40 80 00       	push   $0x804018
  802da4:	68 3f 01 00 00       	push   $0x13f
  802da9:	68 3b 40 80 00       	push   $0x80403b
  802dae:	e8 1e d5 ff ff       	call   8002d1 <_panic>
  802db3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbc:	89 10                	mov    %edx,(%eax)
  802dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	85 c0                	test   %eax,%eax
  802dc5:	74 0d                	je     802dd4 <insert_sorted_with_merge_freeList+0x1a4>
  802dc7:	a1 48 51 80 00       	mov    0x805148,%eax
  802dcc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dcf:	89 50 04             	mov    %edx,0x4(%eax)
  802dd2:	eb 08                	jmp    802ddc <insert_sorted_with_merge_freeList+0x1ac>
  802dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddf:	a3 48 51 80 00       	mov    %eax,0x805148
  802de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dee:	a1 54 51 80 00       	mov    0x805154,%eax
  802df3:	40                   	inc    %eax
  802df4:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802df9:	e9 7a 05 00 00       	jmp    803378 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	8b 50 08             	mov    0x8(%eax),%edx
  802e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e07:	8b 40 08             	mov    0x8(%eax),%eax
  802e0a:	39 c2                	cmp    %eax,%edx
  802e0c:	0f 82 14 01 00 00    	jb     802f26 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e15:	8b 50 08             	mov    0x8(%eax),%edx
  802e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1e:	01 c2                	add    %eax,%edx
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	8b 40 08             	mov    0x8(%eax),%eax
  802e26:	39 c2                	cmp    %eax,%edx
  802e28:	0f 85 90 00 00 00    	jne    802ebe <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e31:	8b 50 0c             	mov    0xc(%eax),%edx
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3a:	01 c2                	add    %eax,%edx
  802e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3f:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5a:	75 17                	jne    802e73 <insert_sorted_with_merge_freeList+0x243>
  802e5c:	83 ec 04             	sub    $0x4,%esp
  802e5f:	68 18 40 80 00       	push   $0x804018
  802e64:	68 49 01 00 00       	push   $0x149
  802e69:	68 3b 40 80 00       	push   $0x80403b
  802e6e:	e8 5e d4 ff ff       	call   8002d1 <_panic>
  802e73:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	89 10                	mov    %edx,(%eax)
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	8b 00                	mov    (%eax),%eax
  802e83:	85 c0                	test   %eax,%eax
  802e85:	74 0d                	je     802e94 <insert_sorted_with_merge_freeList+0x264>
  802e87:	a1 48 51 80 00       	mov    0x805148,%eax
  802e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e8f:	89 50 04             	mov    %edx,0x4(%eax)
  802e92:	eb 08                	jmp    802e9c <insert_sorted_with_merge_freeList+0x26c>
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eae:	a1 54 51 80 00       	mov    0x805154,%eax
  802eb3:	40                   	inc    %eax
  802eb4:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802eb9:	e9 bb 04 00 00       	jmp    803379 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ebe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec2:	75 17                	jne    802edb <insert_sorted_with_merge_freeList+0x2ab>
  802ec4:	83 ec 04             	sub    $0x4,%esp
  802ec7:	68 8c 40 80 00       	push   $0x80408c
  802ecc:	68 4c 01 00 00       	push   $0x14c
  802ed1:	68 3b 40 80 00       	push   $0x80403b
  802ed6:	e8 f6 d3 ff ff       	call   8002d1 <_panic>
  802edb:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	89 50 04             	mov    %edx,0x4(%eax)
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	8b 40 04             	mov    0x4(%eax),%eax
  802eed:	85 c0                	test   %eax,%eax
  802eef:	74 0c                	je     802efd <insert_sorted_with_merge_freeList+0x2cd>
  802ef1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef9:	89 10                	mov    %edx,(%eax)
  802efb:	eb 08                	jmp    802f05 <insert_sorted_with_merge_freeList+0x2d5>
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	a3 38 51 80 00       	mov    %eax,0x805138
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f16:	a1 44 51 80 00       	mov    0x805144,%eax
  802f1b:	40                   	inc    %eax
  802f1c:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f21:	e9 53 04 00 00       	jmp    803379 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f26:	a1 38 51 80 00       	mov    0x805138,%eax
  802f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2e:	e9 15 04 00 00       	jmp    803348 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	8b 50 08             	mov    0x8(%eax),%edx
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	8b 40 08             	mov    0x8(%eax),%eax
  802f47:	39 c2                	cmp    %eax,%edx
  802f49:	0f 86 f1 03 00 00    	jbe    803340 <insert_sorted_with_merge_freeList+0x710>
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 50 08             	mov    0x8(%eax),%edx
  802f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f58:	8b 40 08             	mov    0x8(%eax),%eax
  802f5b:	39 c2                	cmp    %eax,%edx
  802f5d:	0f 83 dd 03 00 00    	jae    803340 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 50 08             	mov    0x8(%eax),%edx
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6f:	01 c2                	add    %eax,%edx
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	8b 40 08             	mov    0x8(%eax),%eax
  802f77:	39 c2                	cmp    %eax,%edx
  802f79:	0f 85 b9 01 00 00    	jne    803138 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	8b 50 08             	mov    0x8(%eax),%edx
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8b:	01 c2                	add    %eax,%edx
  802f8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f90:	8b 40 08             	mov    0x8(%eax),%eax
  802f93:	39 c2                	cmp    %eax,%edx
  802f95:	0f 85 0d 01 00 00    	jne    8030a8 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9e:	8b 50 0c             	mov    0xc(%eax),%edx
  802fa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa7:	01 c2                	add    %eax,%edx
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802faf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fb3:	75 17                	jne    802fcc <insert_sorted_with_merge_freeList+0x39c>
  802fb5:	83 ec 04             	sub    $0x4,%esp
  802fb8:	68 e4 40 80 00       	push   $0x8040e4
  802fbd:	68 5c 01 00 00       	push   $0x15c
  802fc2:	68 3b 40 80 00       	push   $0x80403b
  802fc7:	e8 05 d3 ff ff       	call   8002d1 <_panic>
  802fcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcf:	8b 00                	mov    (%eax),%eax
  802fd1:	85 c0                	test   %eax,%eax
  802fd3:	74 10                	je     802fe5 <insert_sorted_with_merge_freeList+0x3b5>
  802fd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fdd:	8b 52 04             	mov    0x4(%edx),%edx
  802fe0:	89 50 04             	mov    %edx,0x4(%eax)
  802fe3:	eb 0b                	jmp    802ff0 <insert_sorted_with_merge_freeList+0x3c0>
  802fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe8:	8b 40 04             	mov    0x4(%eax),%eax
  802feb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff3:	8b 40 04             	mov    0x4(%eax),%eax
  802ff6:	85 c0                	test   %eax,%eax
  802ff8:	74 0f                	je     803009 <insert_sorted_with_merge_freeList+0x3d9>
  802ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffd:	8b 40 04             	mov    0x4(%eax),%eax
  803000:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803003:	8b 12                	mov    (%edx),%edx
  803005:	89 10                	mov    %edx,(%eax)
  803007:	eb 0a                	jmp    803013 <insert_sorted_with_merge_freeList+0x3e3>
  803009:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300c:	8b 00                	mov    (%eax),%eax
  80300e:	a3 38 51 80 00       	mov    %eax,0x805138
  803013:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803016:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803026:	a1 44 51 80 00       	mov    0x805144,%eax
  80302b:	48                   	dec    %eax
  80302c:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803031:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803034:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803045:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803049:	75 17                	jne    803062 <insert_sorted_with_merge_freeList+0x432>
  80304b:	83 ec 04             	sub    $0x4,%esp
  80304e:	68 18 40 80 00       	push   $0x804018
  803053:	68 5f 01 00 00       	push   $0x15f
  803058:	68 3b 40 80 00       	push   $0x80403b
  80305d:	e8 6f d2 ff ff       	call   8002d1 <_panic>
  803062:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803068:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306b:	89 10                	mov    %edx,(%eax)
  80306d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803070:	8b 00                	mov    (%eax),%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	74 0d                	je     803083 <insert_sorted_with_merge_freeList+0x453>
  803076:	a1 48 51 80 00       	mov    0x805148,%eax
  80307b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80307e:	89 50 04             	mov    %edx,0x4(%eax)
  803081:	eb 08                	jmp    80308b <insert_sorted_with_merge_freeList+0x45b>
  803083:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803086:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80308b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308e:	a3 48 51 80 00       	mov    %eax,0x805148
  803093:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803096:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309d:	a1 54 51 80 00       	mov    0x805154,%eax
  8030a2:	40                   	inc    %eax
  8030a3:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b4:	01 c2                	add    %eax,%edx
  8030b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b9:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d4:	75 17                	jne    8030ed <insert_sorted_with_merge_freeList+0x4bd>
  8030d6:	83 ec 04             	sub    $0x4,%esp
  8030d9:	68 18 40 80 00       	push   $0x804018
  8030de:	68 64 01 00 00       	push   $0x164
  8030e3:	68 3b 40 80 00       	push   $0x80403b
  8030e8:	e8 e4 d1 ff ff       	call   8002d1 <_panic>
  8030ed:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	89 10                	mov    %edx,(%eax)
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	85 c0                	test   %eax,%eax
  8030ff:	74 0d                	je     80310e <insert_sorted_with_merge_freeList+0x4de>
  803101:	a1 48 51 80 00       	mov    0x805148,%eax
  803106:	8b 55 08             	mov    0x8(%ebp),%edx
  803109:	89 50 04             	mov    %edx,0x4(%eax)
  80310c:	eb 08                	jmp    803116 <insert_sorted_with_merge_freeList+0x4e6>
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	a3 48 51 80 00       	mov    %eax,0x805148
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803128:	a1 54 51 80 00       	mov    0x805154,%eax
  80312d:	40                   	inc    %eax
  80312e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803133:	e9 41 02 00 00       	jmp    803379 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	8b 50 08             	mov    0x8(%eax),%edx
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	8b 40 0c             	mov    0xc(%eax),%eax
  803144:	01 c2                	add    %eax,%edx
  803146:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803149:	8b 40 08             	mov    0x8(%eax),%eax
  80314c:	39 c2                	cmp    %eax,%edx
  80314e:	0f 85 7c 01 00 00    	jne    8032d0 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803154:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803158:	74 06                	je     803160 <insert_sorted_with_merge_freeList+0x530>
  80315a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80315e:	75 17                	jne    803177 <insert_sorted_with_merge_freeList+0x547>
  803160:	83 ec 04             	sub    $0x4,%esp
  803163:	68 54 40 80 00       	push   $0x804054
  803168:	68 69 01 00 00       	push   $0x169
  80316d:	68 3b 40 80 00       	push   $0x80403b
  803172:	e8 5a d1 ff ff       	call   8002d1 <_panic>
  803177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317a:	8b 50 04             	mov    0x4(%eax),%edx
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	89 50 04             	mov    %edx,0x4(%eax)
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803189:	89 10                	mov    %edx,(%eax)
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	8b 40 04             	mov    0x4(%eax),%eax
  803191:	85 c0                	test   %eax,%eax
  803193:	74 0d                	je     8031a2 <insert_sorted_with_merge_freeList+0x572>
  803195:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803198:	8b 40 04             	mov    0x4(%eax),%eax
  80319b:	8b 55 08             	mov    0x8(%ebp),%edx
  80319e:	89 10                	mov    %edx,(%eax)
  8031a0:	eb 08                	jmp    8031aa <insert_sorted_with_merge_freeList+0x57a>
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	a3 38 51 80 00       	mov    %eax,0x805138
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b0:	89 50 04             	mov    %edx,0x4(%eax)
  8031b3:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b8:	40                   	inc    %eax
  8031b9:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ca:	01 c2                	add    %eax,%edx
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031d6:	75 17                	jne    8031ef <insert_sorted_with_merge_freeList+0x5bf>
  8031d8:	83 ec 04             	sub    $0x4,%esp
  8031db:	68 e4 40 80 00       	push   $0x8040e4
  8031e0:	68 6b 01 00 00       	push   $0x16b
  8031e5:	68 3b 40 80 00       	push   $0x80403b
  8031ea:	e8 e2 d0 ff ff       	call   8002d1 <_panic>
  8031ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f2:	8b 00                	mov    (%eax),%eax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	74 10                	je     803208 <insert_sorted_with_merge_freeList+0x5d8>
  8031f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fb:	8b 00                	mov    (%eax),%eax
  8031fd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803200:	8b 52 04             	mov    0x4(%edx),%edx
  803203:	89 50 04             	mov    %edx,0x4(%eax)
  803206:	eb 0b                	jmp    803213 <insert_sorted_with_merge_freeList+0x5e3>
  803208:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320b:	8b 40 04             	mov    0x4(%eax),%eax
  80320e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803213:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803216:	8b 40 04             	mov    0x4(%eax),%eax
  803219:	85 c0                	test   %eax,%eax
  80321b:	74 0f                	je     80322c <insert_sorted_with_merge_freeList+0x5fc>
  80321d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803220:	8b 40 04             	mov    0x4(%eax),%eax
  803223:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803226:	8b 12                	mov    (%edx),%edx
  803228:	89 10                	mov    %edx,(%eax)
  80322a:	eb 0a                	jmp    803236 <insert_sorted_with_merge_freeList+0x606>
  80322c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322f:	8b 00                	mov    (%eax),%eax
  803231:	a3 38 51 80 00       	mov    %eax,0x805138
  803236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803242:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803249:	a1 44 51 80 00       	mov    0x805144,%eax
  80324e:	48                   	dec    %eax
  80324f:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803254:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803257:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803268:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80326c:	75 17                	jne    803285 <insert_sorted_with_merge_freeList+0x655>
  80326e:	83 ec 04             	sub    $0x4,%esp
  803271:	68 18 40 80 00       	push   $0x804018
  803276:	68 6e 01 00 00       	push   $0x16e
  80327b:	68 3b 40 80 00       	push   $0x80403b
  803280:	e8 4c d0 ff ff       	call   8002d1 <_panic>
  803285:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80328b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328e:	89 10                	mov    %edx,(%eax)
  803290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803293:	8b 00                	mov    (%eax),%eax
  803295:	85 c0                	test   %eax,%eax
  803297:	74 0d                	je     8032a6 <insert_sorted_with_merge_freeList+0x676>
  803299:	a1 48 51 80 00       	mov    0x805148,%eax
  80329e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a1:	89 50 04             	mov    %edx,0x4(%eax)
  8032a4:	eb 08                	jmp    8032ae <insert_sorted_with_merge_freeList+0x67e>
  8032a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8032b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8032c5:	40                   	inc    %eax
  8032c6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032cb:	e9 a9 00 00 00       	jmp    803379 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d4:	74 06                	je     8032dc <insert_sorted_with_merge_freeList+0x6ac>
  8032d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032da:	75 17                	jne    8032f3 <insert_sorted_with_merge_freeList+0x6c3>
  8032dc:	83 ec 04             	sub    $0x4,%esp
  8032df:	68 b0 40 80 00       	push   $0x8040b0
  8032e4:	68 73 01 00 00       	push   $0x173
  8032e9:	68 3b 40 80 00       	push   $0x80403b
  8032ee:	e8 de cf ff ff       	call   8002d1 <_panic>
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	8b 10                	mov    (%eax),%edx
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	89 10                	mov    %edx,(%eax)
  8032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803300:	8b 00                	mov    (%eax),%eax
  803302:	85 c0                	test   %eax,%eax
  803304:	74 0b                	je     803311 <insert_sorted_with_merge_freeList+0x6e1>
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	8b 00                	mov    (%eax),%eax
  80330b:	8b 55 08             	mov    0x8(%ebp),%edx
  80330e:	89 50 04             	mov    %edx,0x4(%eax)
  803311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803314:	8b 55 08             	mov    0x8(%ebp),%edx
  803317:	89 10                	mov    %edx,(%eax)
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80331f:	89 50 04             	mov    %edx,0x4(%eax)
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	8b 00                	mov    (%eax),%eax
  803327:	85 c0                	test   %eax,%eax
  803329:	75 08                	jne    803333 <insert_sorted_with_merge_freeList+0x703>
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803333:	a1 44 51 80 00       	mov    0x805144,%eax
  803338:	40                   	inc    %eax
  803339:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80333e:	eb 39                	jmp    803379 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803340:	a1 40 51 80 00       	mov    0x805140,%eax
  803345:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803348:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80334c:	74 07                	je     803355 <insert_sorted_with_merge_freeList+0x725>
  80334e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803351:	8b 00                	mov    (%eax),%eax
  803353:	eb 05                	jmp    80335a <insert_sorted_with_merge_freeList+0x72a>
  803355:	b8 00 00 00 00       	mov    $0x0,%eax
  80335a:	a3 40 51 80 00       	mov    %eax,0x805140
  80335f:	a1 40 51 80 00       	mov    0x805140,%eax
  803364:	85 c0                	test   %eax,%eax
  803366:	0f 85 c7 fb ff ff    	jne    802f33 <insert_sorted_with_merge_freeList+0x303>
  80336c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803370:	0f 85 bd fb ff ff    	jne    802f33 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803376:	eb 01                	jmp    803379 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803378:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803379:	90                   	nop
  80337a:	c9                   	leave  
  80337b:	c3                   	ret    

0080337c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80337c:	55                   	push   %ebp
  80337d:	89 e5                	mov    %esp,%ebp
  80337f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803382:	8b 55 08             	mov    0x8(%ebp),%edx
  803385:	89 d0                	mov    %edx,%eax
  803387:	c1 e0 02             	shl    $0x2,%eax
  80338a:	01 d0                	add    %edx,%eax
  80338c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803393:	01 d0                	add    %edx,%eax
  803395:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80339c:	01 d0                	add    %edx,%eax
  80339e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033a5:	01 d0                	add    %edx,%eax
  8033a7:	c1 e0 04             	shl    $0x4,%eax
  8033aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8033ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8033b4:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033b7:	83 ec 0c             	sub    $0xc,%esp
  8033ba:	50                   	push   %eax
  8033bb:	e8 26 e7 ff ff       	call   801ae6 <sys_get_virtual_time>
  8033c0:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033c3:	eb 41                	jmp    803406 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033c8:	83 ec 0c             	sub    $0xc,%esp
  8033cb:	50                   	push   %eax
  8033cc:	e8 15 e7 ff ff       	call   801ae6 <sys_get_virtual_time>
  8033d1:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033da:	29 c2                	sub    %eax,%edx
  8033dc:	89 d0                	mov    %edx,%eax
  8033de:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033e7:	89 d1                	mov    %edx,%ecx
  8033e9:	29 c1                	sub    %eax,%ecx
  8033eb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033f1:	39 c2                	cmp    %eax,%edx
  8033f3:	0f 97 c0             	seta   %al
  8033f6:	0f b6 c0             	movzbl %al,%eax
  8033f9:	29 c1                	sub    %eax,%ecx
  8033fb:	89 c8                	mov    %ecx,%eax
  8033fd:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803400:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803403:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803409:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80340c:	72 b7                	jb     8033c5 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80340e:	90                   	nop
  80340f:	c9                   	leave  
  803410:	c3                   	ret    

00803411 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803411:	55                   	push   %ebp
  803412:	89 e5                	mov    %esp,%ebp
  803414:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803417:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80341e:	eb 03                	jmp    803423 <busy_wait+0x12>
  803420:	ff 45 fc             	incl   -0x4(%ebp)
  803423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803426:	3b 45 08             	cmp    0x8(%ebp),%eax
  803429:	72 f5                	jb     803420 <busy_wait+0xf>
	return i;
  80342b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80342e:	c9                   	leave  
  80342f:	c3                   	ret    

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
