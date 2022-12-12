
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
  800045:	68 80 36 80 00       	push   $0x803680
  80004a:	e8 06 15 00 00       	call   801555 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 32 17 00 00       	call   801795 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 ca 17 00 00       	call   801835 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 90 36 80 00       	push   $0x803690
  800079:	e8 07 05 00 00       	call   800585 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 c3 36 80 00       	push   $0x8036c3
  800099:	e8 69 19 00 00       	call   801a07 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 cc 36 80 00       	push   $0x8036cc
  8000bc:	e8 46 19 00 00       	call   801a07 <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 53 19 00 00       	call   801a25 <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 75 32 00 00       	call   803357 <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 35 19 00 00       	call   801a25 <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 92 16 00 00       	call   801795 <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 d8 36 80 00       	push   $0x8036d8
  80010c:	e8 74 04 00 00       	call   800585 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 22 19 00 00       	call   801a41 <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 14 19 00 00       	call   801a41 <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 60 16 00 00       	call   801795 <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 f8 16 00 00       	call   801835 <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 0c 37 80 00       	push   $0x80370c
  800153:	e8 2d 04 00 00       	call   800585 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 5c 37 80 00       	push   $0x80375c
  800163:	6a 23                	push   $0x23
  800165:	68 92 37 80 00       	push   $0x803792
  80016a:	e8 62 01 00 00       	call   8002d1 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 a8 37 80 00       	push   $0x8037a8
  80017a:	e8 06 04 00 00       	call   800585 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 08 38 80 00       	push   $0x803808
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
  80019b:	e8 d5 18 00 00       	call   801a75 <sys_getenvindex>
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
  800206:	e8 77 16 00 00       	call   801882 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 6c 38 80 00       	push   $0x80386c
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
  800236:	68 94 38 80 00       	push   $0x803894
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
  800267:	68 bc 38 80 00       	push   $0x8038bc
  80026c:	e8 14 03 00 00       	call   800585 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 14 39 80 00       	push   $0x803914
  800288:	e8 f8 02 00 00       	call   800585 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 6c 38 80 00       	push   $0x80386c
  800298:	e8 e8 02 00 00       	call   800585 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a0:	e8 f7 15 00 00       	call   80189c <sys_enable_interrupt>

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
  8002b8:	e8 84 17 00 00       	call   801a41 <sys_destroy_env>
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
  8002c9:	e8 d9 17 00 00       	call   801aa7 <sys_exit_env>
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
  8002f2:	68 28 39 80 00       	push   $0x803928
  8002f7:	e8 89 02 00 00       	call   800585 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ff:	a1 00 50 80 00       	mov    0x805000,%eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	50                   	push   %eax
  80030b:	68 2d 39 80 00       	push   $0x80392d
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
  80032f:	68 49 39 80 00       	push   $0x803949
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
  80035b:	68 4c 39 80 00       	push   $0x80394c
  800360:	6a 26                	push   $0x26
  800362:	68 98 39 80 00       	push   $0x803998
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
  80042d:	68 a4 39 80 00       	push   $0x8039a4
  800432:	6a 3a                	push   $0x3a
  800434:	68 98 39 80 00       	push   $0x803998
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
  80049d:	68 f8 39 80 00       	push   $0x8039f8
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 98 39 80 00       	push   $0x803998
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
  8004f7:	e8 d8 11 00 00       	call   8016d4 <sys_cputs>
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
  80056e:	e8 61 11 00 00       	call   8016d4 <sys_cputs>
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
  8005b8:	e8 c5 12 00 00       	call   801882 <sys_disable_interrupt>
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
  8005d8:	e8 bf 12 00 00       	call   80189c <sys_enable_interrupt>
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
  800622:	e8 e5 2d 00 00       	call   80340c <__udivdi3>
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
  800672:	e8 a5 2e 00 00       	call   80351c <__umoddi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	05 74 3c 80 00       	add    $0x803c74,%eax
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
  8007cd:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
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
  8008ae:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 19                	jne    8008d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b9:	53                   	push   %ebx
  8008ba:	68 85 3c 80 00       	push   $0x803c85
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
  8008d3:	68 8e 3c 80 00       	push   $0x803c8e
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
  800900:	be 91 3c 80 00       	mov    $0x803c91,%esi
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
  801326:	68 f0 3d 80 00       	push   $0x803df0
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
  8013f6:	e8 1d 04 00 00       	call   801818 <sys_allocate_chunk>
  8013fb:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013fe:	a1 20 51 80 00       	mov    0x805120,%eax
  801403:	83 ec 0c             	sub    $0xc,%esp
  801406:	50                   	push   %eax
  801407:	e8 92 0a 00 00       	call   801e9e <initialize_MemBlocksList>
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
  801434:	68 15 3e 80 00       	push   $0x803e15
  801439:	6a 33                	push   $0x33
  80143b:	68 33 3e 80 00       	push   $0x803e33
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
  8014b3:	68 40 3e 80 00       	push   $0x803e40
  8014b8:	6a 34                	push   $0x34
  8014ba:	68 33 3e 80 00       	push   $0x803e33
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
  801528:	68 64 3e 80 00       	push   $0x803e64
  80152d:	6a 46                	push   $0x46
  80152f:	68 33 3e 80 00       	push   $0x803e33
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
  801544:	68 8c 3e 80 00       	push   $0x803e8c
  801549:	6a 61                	push   $0x61
  80154b:	68 33 3e 80 00       	push   $0x803e33
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
  80156a:	75 07                	jne    801573 <smalloc+0x1e>
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
  801571:	eb 7c                	jmp    8015ef <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
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
  8015a0:	e8 41 06 00 00       	call   801be6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	74 11                	je     8015ba <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8015a9:	83 ec 0c             	sub    $0xc,%esp
  8015ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8015af:	e8 ac 0c 00 00       	call   802260 <alloc_block_FF>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015be:	74 2a                	je     8015ea <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	8b 40 08             	mov    0x8(%eax),%eax
  8015c6:	89 c2                	mov    %eax,%edx
  8015c8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015cc:	52                   	push   %edx
  8015cd:	50                   	push   %eax
  8015ce:	ff 75 0c             	pushl  0xc(%ebp)
  8015d1:	ff 75 08             	pushl  0x8(%ebp)
  8015d4:	e8 92 03 00 00       	call   80196b <sys_createSharedObject>
  8015d9:	83 c4 10             	add    $0x10,%esp
  8015dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8015df:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8015e3:	74 05                	je     8015ea <smalloc+0x95>
			return (void*)virtual_address;
  8015e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e8:	eb 05                	jmp    8015ef <smalloc+0x9a>
	}
	return NULL;
  8015ea:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f7:	e8 13 fd ff ff       	call   80130f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015fc:	83 ec 04             	sub    $0x4,%esp
  8015ff:	68 b0 3e 80 00       	push   $0x803eb0
  801604:	68 a2 00 00 00       	push   $0xa2
  801609:	68 33 3e 80 00       	push   $0x803e33
  80160e:	e8 be ec ff ff       	call   8002d1 <_panic>

00801613 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801619:	e8 f1 fc ff ff       	call   80130f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80161e:	83 ec 04             	sub    $0x4,%esp
  801621:	68 d4 3e 80 00       	push   $0x803ed4
  801626:	68 e6 00 00 00       	push   $0xe6
  80162b:	68 33 3e 80 00       	push   $0x803e33
  801630:	e8 9c ec ff ff       	call   8002d1 <_panic>

00801635 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80163b:	83 ec 04             	sub    $0x4,%esp
  80163e:	68 fc 3e 80 00       	push   $0x803efc
  801643:	68 fa 00 00 00       	push   $0xfa
  801648:	68 33 3e 80 00       	push   $0x803e33
  80164d:	e8 7f ec ff ff       	call   8002d1 <_panic>

00801652 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801658:	83 ec 04             	sub    $0x4,%esp
  80165b:	68 20 3f 80 00       	push   $0x803f20
  801660:	68 05 01 00 00       	push   $0x105
  801665:	68 33 3e 80 00       	push   $0x803e33
  80166a:	e8 62 ec ff ff       	call   8002d1 <_panic>

0080166f <shrink>:

}
void shrink(uint32 newSize)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801675:	83 ec 04             	sub    $0x4,%esp
  801678:	68 20 3f 80 00       	push   $0x803f20
  80167d:	68 0a 01 00 00       	push   $0x10a
  801682:	68 33 3e 80 00       	push   $0x803e33
  801687:	e8 45 ec ff ff       	call   8002d1 <_panic>

0080168c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801692:	83 ec 04             	sub    $0x4,%esp
  801695:	68 20 3f 80 00       	push   $0x803f20
  80169a:	68 0f 01 00 00       	push   $0x10f
  80169f:	68 33 3e 80 00       	push   $0x803e33
  8016a4:	e8 28 ec ff ff       	call   8002d1 <_panic>

008016a9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	57                   	push   %edi
  8016ad:	56                   	push   %esi
  8016ae:	53                   	push   %ebx
  8016af:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016be:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016c1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016c4:	cd 30                	int    $0x30
  8016c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016cc:	83 c4 10             	add    $0x10,%esp
  8016cf:	5b                   	pop    %ebx
  8016d0:	5e                   	pop    %esi
  8016d1:	5f                   	pop    %edi
  8016d2:	5d                   	pop    %ebp
  8016d3:	c3                   	ret    

008016d4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	8b 45 10             	mov    0x10(%ebp),%eax
  8016dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016e0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	52                   	push   %edx
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	50                   	push   %eax
  8016f0:	6a 00                	push   $0x0
  8016f2:	e8 b2 ff ff ff       	call   8016a9 <syscall>
  8016f7:	83 c4 18             	add    $0x18,%esp
}
  8016fa:	90                   	nop
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sys_cgetc>:

int
sys_cgetc(void)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 01                	push   $0x1
  80170c:	e8 98 ff ff ff       	call   8016a9 <syscall>
  801711:	83 c4 18             	add    $0x18,%esp
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	52                   	push   %edx
  801726:	50                   	push   %eax
  801727:	6a 05                	push   $0x5
  801729:	e8 7b ff ff ff       	call   8016a9 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	56                   	push   %esi
  801737:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801738:	8b 75 18             	mov    0x18(%ebp),%esi
  80173b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801741:	8b 55 0c             	mov    0xc(%ebp),%edx
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	56                   	push   %esi
  801748:	53                   	push   %ebx
  801749:	51                   	push   %ecx
  80174a:	52                   	push   %edx
  80174b:	50                   	push   %eax
  80174c:	6a 06                	push   $0x6
  80174e:	e8 56 ff ff ff       	call   8016a9 <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801759:	5b                   	pop    %ebx
  80175a:	5e                   	pop    %esi
  80175b:	5d                   	pop    %ebp
  80175c:	c3                   	ret    

0080175d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801760:	8b 55 0c             	mov    0xc(%ebp),%edx
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	52                   	push   %edx
  80176d:	50                   	push   %eax
  80176e:	6a 07                	push   $0x7
  801770:	e8 34 ff ff ff       	call   8016a9 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	ff 75 0c             	pushl  0xc(%ebp)
  801786:	ff 75 08             	pushl  0x8(%ebp)
  801789:	6a 08                	push   $0x8
  80178b:	e8 19 ff ff ff       	call   8016a9 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 09                	push   $0x9
  8017a4:	e8 00 ff ff ff       	call   8016a9 <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 0a                	push   $0xa
  8017bd:	e8 e7 fe ff ff       	call   8016a9 <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 0b                	push   $0xb
  8017d6:	e8 ce fe ff ff       	call   8016a9 <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ec:	ff 75 08             	pushl  0x8(%ebp)
  8017ef:	6a 0f                	push   $0xf
  8017f1:	e8 b3 fe ff ff       	call   8016a9 <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
	return;
  8017f9:	90                   	nop
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	ff 75 08             	pushl  0x8(%ebp)
  80180b:	6a 10                	push   $0x10
  80180d:	e8 97 fe ff ff       	call   8016a9 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
	return ;
  801815:	90                   	nop
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	ff 75 10             	pushl  0x10(%ebp)
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	6a 11                	push   $0x11
  80182a:	e8 7a fe ff ff       	call   8016a9 <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
	return ;
  801832:	90                   	nop
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 0c                	push   $0xc
  801844:	e8 60 fe ff ff       	call   8016a9 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	ff 75 08             	pushl  0x8(%ebp)
  80185c:	6a 0d                	push   $0xd
  80185e:	e8 46 fe ff ff       	call   8016a9 <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 0e                	push   $0xe
  801877:	e8 2d fe ff ff       	call   8016a9 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	90                   	nop
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 13                	push   $0x13
  801891:	e8 13 fe ff ff       	call   8016a9 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	90                   	nop
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 14                	push   $0x14
  8018ab:	e8 f9 fd ff ff       	call   8016a9 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	90                   	nop
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 04             	sub    $0x4,%esp
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018c2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	50                   	push   %eax
  8018cf:	6a 15                	push   $0x15
  8018d1:	e8 d3 fd ff ff       	call   8016a9 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	90                   	nop
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 16                	push   $0x16
  8018eb:	e8 b9 fd ff ff       	call   8016a9 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	90                   	nop
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	50                   	push   %eax
  801906:	6a 17                	push   $0x17
  801908:	e8 9c fd ff ff       	call   8016a9 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801915:	8b 55 0c             	mov    0xc(%ebp),%edx
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	52                   	push   %edx
  801922:	50                   	push   %eax
  801923:	6a 1a                	push   $0x1a
  801925:	e8 7f fd ff ff       	call   8016a9 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801932:	8b 55 0c             	mov    0xc(%ebp),%edx
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	52                   	push   %edx
  80193f:	50                   	push   %eax
  801940:	6a 18                	push   $0x18
  801942:	e8 62 fd ff ff       	call   8016a9 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	90                   	nop
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801950:	8b 55 0c             	mov    0xc(%ebp),%edx
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	52                   	push   %edx
  80195d:	50                   	push   %eax
  80195e:	6a 19                	push   $0x19
  801960:	e8 44 fd ff ff       	call   8016a9 <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	90                   	nop
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 04             	sub    $0x4,%esp
  801971:	8b 45 10             	mov    0x10(%ebp),%eax
  801974:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801977:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80197a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	6a 00                	push   $0x0
  801983:	51                   	push   %ecx
  801984:	52                   	push   %edx
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	50                   	push   %eax
  801989:	6a 1b                	push   $0x1b
  80198b:	e8 19 fd ff ff       	call   8016a9 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801998:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	52                   	push   %edx
  8019a5:	50                   	push   %eax
  8019a6:	6a 1c                	push   $0x1c
  8019a8:	e8 fc fc ff ff       	call   8016a9 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	51                   	push   %ecx
  8019c3:	52                   	push   %edx
  8019c4:	50                   	push   %eax
  8019c5:	6a 1d                	push   $0x1d
  8019c7:	e8 dd fc ff ff       	call   8016a9 <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	52                   	push   %edx
  8019e1:	50                   	push   %eax
  8019e2:	6a 1e                	push   $0x1e
  8019e4:	e8 c0 fc ff ff       	call   8016a9 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 1f                	push   $0x1f
  8019fd:	e8 a7 fc ff ff       	call   8016a9 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	6a 00                	push   $0x0
  801a0f:	ff 75 14             	pushl  0x14(%ebp)
  801a12:	ff 75 10             	pushl  0x10(%ebp)
  801a15:	ff 75 0c             	pushl  0xc(%ebp)
  801a18:	50                   	push   %eax
  801a19:	6a 20                	push   $0x20
  801a1b:	e8 89 fc ff ff       	call   8016a9 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	50                   	push   %eax
  801a34:	6a 21                	push   $0x21
  801a36:	e8 6e fc ff ff       	call   8016a9 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	90                   	nop
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	50                   	push   %eax
  801a50:	6a 22                	push   $0x22
  801a52:	e8 52 fc ff ff       	call   8016a9 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 02                	push   $0x2
  801a6b:	e8 39 fc ff ff       	call   8016a9 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 03                	push   $0x3
  801a84:	e8 20 fc ff ff       	call   8016a9 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 04                	push   $0x4
  801a9d:	e8 07 fc ff ff       	call   8016a9 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_exit_env>:


void sys_exit_env(void)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 23                	push   $0x23
  801ab6:	e8 ee fb ff ff       	call   8016a9 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	90                   	nop
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ac7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aca:	8d 50 04             	lea    0x4(%eax),%edx
  801acd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	52                   	push   %edx
  801ad7:	50                   	push   %eax
  801ad8:	6a 24                	push   $0x24
  801ada:	e8 ca fb ff ff       	call   8016a9 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
	return result;
  801ae2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ae5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ae8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aeb:	89 01                	mov    %eax,(%ecx)
  801aed:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	c9                   	leave  
  801af4:	c2 04 00             	ret    $0x4

00801af7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	ff 75 10             	pushl  0x10(%ebp)
  801b01:	ff 75 0c             	pushl  0xc(%ebp)
  801b04:	ff 75 08             	pushl  0x8(%ebp)
  801b07:	6a 12                	push   $0x12
  801b09:	e8 9b fb ff ff       	call   8016a9 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b11:	90                   	nop
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 25                	push   $0x25
  801b23:	e8 81 fb ff ff       	call   8016a9 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	83 ec 04             	sub    $0x4,%esp
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b39:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	50                   	push   %eax
  801b46:	6a 26                	push   $0x26
  801b48:	e8 5c fb ff ff       	call   8016a9 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b50:	90                   	nop
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <rsttst>:
void rsttst()
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 28                	push   $0x28
  801b62:	e8 42 fb ff ff       	call   8016a9 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6a:	90                   	nop
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	83 ec 04             	sub    $0x4,%esp
  801b73:	8b 45 14             	mov    0x14(%ebp),%eax
  801b76:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b79:	8b 55 18             	mov    0x18(%ebp),%edx
  801b7c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b80:	52                   	push   %edx
  801b81:	50                   	push   %eax
  801b82:	ff 75 10             	pushl  0x10(%ebp)
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	ff 75 08             	pushl  0x8(%ebp)
  801b8b:	6a 27                	push   $0x27
  801b8d:	e8 17 fb ff ff       	call   8016a9 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
	return ;
  801b95:	90                   	nop
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <chktst>:
void chktst(uint32 n)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	ff 75 08             	pushl  0x8(%ebp)
  801ba6:	6a 29                	push   $0x29
  801ba8:	e8 fc fa ff ff       	call   8016a9 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb0:	90                   	nop
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <inctst>:

void inctst()
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 2a                	push   $0x2a
  801bc2:	e8 e2 fa ff ff       	call   8016a9 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bca:	90                   	nop
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <gettst>:
uint32 gettst()
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 2b                	push   $0x2b
  801bdc:	e8 c8 fa ff ff       	call   8016a9 <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 2c                	push   $0x2c
  801bf8:	e8 ac fa ff ff       	call   8016a9 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
  801c00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c03:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c07:	75 07                	jne    801c10 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c09:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0e:	eb 05                	jmp    801c15 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 2c                	push   $0x2c
  801c29:	e8 7b fa ff ff       	call   8016a9 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
  801c31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c34:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c38:	75 07                	jne    801c41 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3f:	eb 05                	jmp    801c46 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 2c                	push   $0x2c
  801c5a:	e8 4a fa ff ff       	call   8016a9 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
  801c62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c65:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c69:	75 07                	jne    801c72 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c70:	eb 05                	jmp    801c77 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 2c                	push   $0x2c
  801c8b:	e8 19 fa ff ff       	call   8016a9 <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
  801c93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c96:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c9a:	75 07                	jne    801ca3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca1:	eb 05                	jmp    801ca8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ca3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	ff 75 08             	pushl  0x8(%ebp)
  801cb8:	6a 2d                	push   $0x2d
  801cba:	e8 ea f9 ff ff       	call   8016a9 <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc2:	90                   	nop
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ccc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ccf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	6a 00                	push   $0x0
  801cd7:	53                   	push   %ebx
  801cd8:	51                   	push   %ecx
  801cd9:	52                   	push   %edx
  801cda:	50                   	push   %eax
  801cdb:	6a 2e                	push   $0x2e
  801cdd:	e8 c7 f9 ff ff       	call   8016a9 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ced:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	52                   	push   %edx
  801cfa:	50                   	push   %eax
  801cfb:	6a 2f                	push   $0x2f
  801cfd:	e8 a7 f9 ff ff       	call   8016a9 <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d0d:	83 ec 0c             	sub    $0xc,%esp
  801d10:	68 30 3f 80 00       	push   $0x803f30
  801d15:	e8 6b e8 ff ff       	call   800585 <cprintf>
  801d1a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d1d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d24:	83 ec 0c             	sub    $0xc,%esp
  801d27:	68 5c 3f 80 00       	push   $0x803f5c
  801d2c:	e8 54 e8 ff ff       	call   800585 <cprintf>
  801d31:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d34:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d38:	a1 38 51 80 00       	mov    0x805138,%eax
  801d3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d40:	eb 56                	jmp    801d98 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d46:	74 1c                	je     801d64 <print_mem_block_lists+0x5d>
  801d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4b:	8b 50 08             	mov    0x8(%eax),%edx
  801d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d51:	8b 48 08             	mov    0x8(%eax),%ecx
  801d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d57:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5a:	01 c8                	add    %ecx,%eax
  801d5c:	39 c2                	cmp    %eax,%edx
  801d5e:	73 04                	jae    801d64 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d60:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d67:	8b 50 08             	mov    0x8(%eax),%edx
  801d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d70:	01 c2                	add    %eax,%edx
  801d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d75:	8b 40 08             	mov    0x8(%eax),%eax
  801d78:	83 ec 04             	sub    $0x4,%esp
  801d7b:	52                   	push   %edx
  801d7c:	50                   	push   %eax
  801d7d:	68 71 3f 80 00       	push   $0x803f71
  801d82:	e8 fe e7 ff ff       	call   800585 <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d90:	a1 40 51 80 00       	mov    0x805140,%eax
  801d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d9c:	74 07                	je     801da5 <print_mem_block_lists+0x9e>
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da1:	8b 00                	mov    (%eax),%eax
  801da3:	eb 05                	jmp    801daa <print_mem_block_lists+0xa3>
  801da5:	b8 00 00 00 00       	mov    $0x0,%eax
  801daa:	a3 40 51 80 00       	mov    %eax,0x805140
  801daf:	a1 40 51 80 00       	mov    0x805140,%eax
  801db4:	85 c0                	test   %eax,%eax
  801db6:	75 8a                	jne    801d42 <print_mem_block_lists+0x3b>
  801db8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dbc:	75 84                	jne    801d42 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dbe:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dc2:	75 10                	jne    801dd4 <print_mem_block_lists+0xcd>
  801dc4:	83 ec 0c             	sub    $0xc,%esp
  801dc7:	68 80 3f 80 00       	push   $0x803f80
  801dcc:	e8 b4 e7 ff ff       	call   800585 <cprintf>
  801dd1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dd4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ddb:	83 ec 0c             	sub    $0xc,%esp
  801dde:	68 a4 3f 80 00       	push   $0x803fa4
  801de3:	e8 9d e7 ff ff       	call   800585 <cprintf>
  801de8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801deb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801def:	a1 40 50 80 00       	mov    0x805040,%eax
  801df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df7:	eb 56                	jmp    801e4f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801df9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dfd:	74 1c                	je     801e1b <print_mem_block_lists+0x114>
  801dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e02:	8b 50 08             	mov    0x8(%eax),%edx
  801e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e08:	8b 48 08             	mov    0x8(%eax),%ecx
  801e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e11:	01 c8                	add    %ecx,%eax
  801e13:	39 c2                	cmp    %eax,%edx
  801e15:	73 04                	jae    801e1b <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e17:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1e:	8b 50 08             	mov    0x8(%eax),%edx
  801e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e24:	8b 40 0c             	mov    0xc(%eax),%eax
  801e27:	01 c2                	add    %eax,%edx
  801e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2c:	8b 40 08             	mov    0x8(%eax),%eax
  801e2f:	83 ec 04             	sub    $0x4,%esp
  801e32:	52                   	push   %edx
  801e33:	50                   	push   %eax
  801e34:	68 71 3f 80 00       	push   $0x803f71
  801e39:	e8 47 e7 ff ff       	call   800585 <cprintf>
  801e3e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e47:	a1 48 50 80 00       	mov    0x805048,%eax
  801e4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e53:	74 07                	je     801e5c <print_mem_block_lists+0x155>
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	8b 00                	mov    (%eax),%eax
  801e5a:	eb 05                	jmp    801e61 <print_mem_block_lists+0x15a>
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e61:	a3 48 50 80 00       	mov    %eax,0x805048
  801e66:	a1 48 50 80 00       	mov    0x805048,%eax
  801e6b:	85 c0                	test   %eax,%eax
  801e6d:	75 8a                	jne    801df9 <print_mem_block_lists+0xf2>
  801e6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e73:	75 84                	jne    801df9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e75:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e79:	75 10                	jne    801e8b <print_mem_block_lists+0x184>
  801e7b:	83 ec 0c             	sub    $0xc,%esp
  801e7e:	68 bc 3f 80 00       	push   $0x803fbc
  801e83:	e8 fd e6 ff ff       	call   800585 <cprintf>
  801e88:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e8b:	83 ec 0c             	sub    $0xc,%esp
  801e8e:	68 30 3f 80 00       	push   $0x803f30
  801e93:	e8 ed e6 ff ff       	call   800585 <cprintf>
  801e98:	83 c4 10             	add    $0x10,%esp

}
  801e9b:	90                   	nop
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ea4:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801eab:	00 00 00 
  801eae:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801eb5:	00 00 00 
  801eb8:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ebf:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ec2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ec9:	e9 9e 00 00 00       	jmp    801f6c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ece:	a1 50 50 80 00       	mov    0x805050,%eax
  801ed3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed6:	c1 e2 04             	shl    $0x4,%edx
  801ed9:	01 d0                	add    %edx,%eax
  801edb:	85 c0                	test   %eax,%eax
  801edd:	75 14                	jne    801ef3 <initialize_MemBlocksList+0x55>
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	68 e4 3f 80 00       	push   $0x803fe4
  801ee7:	6a 46                	push   $0x46
  801ee9:	68 07 40 80 00       	push   $0x804007
  801eee:	e8 de e3 ff ff       	call   8002d1 <_panic>
  801ef3:	a1 50 50 80 00       	mov    0x805050,%eax
  801ef8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efb:	c1 e2 04             	shl    $0x4,%edx
  801efe:	01 d0                	add    %edx,%eax
  801f00:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f06:	89 10                	mov    %edx,(%eax)
  801f08:	8b 00                	mov    (%eax),%eax
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	74 18                	je     801f26 <initialize_MemBlocksList+0x88>
  801f0e:	a1 48 51 80 00       	mov    0x805148,%eax
  801f13:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f19:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f1c:	c1 e1 04             	shl    $0x4,%ecx
  801f1f:	01 ca                	add    %ecx,%edx
  801f21:	89 50 04             	mov    %edx,0x4(%eax)
  801f24:	eb 12                	jmp    801f38 <initialize_MemBlocksList+0x9a>
  801f26:	a1 50 50 80 00       	mov    0x805050,%eax
  801f2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2e:	c1 e2 04             	shl    $0x4,%edx
  801f31:	01 d0                	add    %edx,%eax
  801f33:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f38:	a1 50 50 80 00       	mov    0x805050,%eax
  801f3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f40:	c1 e2 04             	shl    $0x4,%edx
  801f43:	01 d0                	add    %edx,%eax
  801f45:	a3 48 51 80 00       	mov    %eax,0x805148
  801f4a:	a1 50 50 80 00       	mov    0x805050,%eax
  801f4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f52:	c1 e2 04             	shl    $0x4,%edx
  801f55:	01 d0                	add    %edx,%eax
  801f57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f5e:	a1 54 51 80 00       	mov    0x805154,%eax
  801f63:	40                   	inc    %eax
  801f64:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f69:	ff 45 f4             	incl   -0xc(%ebp)
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f72:	0f 82 56 ff ff ff    	jb     801ece <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f78:	90                   	nop
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	8b 00                	mov    (%eax),%eax
  801f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f89:	eb 19                	jmp    801fa4 <find_block+0x29>
	{
		if(va==point->sva)
  801f8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f8e:	8b 40 08             	mov    0x8(%eax),%eax
  801f91:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f94:	75 05                	jne    801f9b <find_block+0x20>
		   return point;
  801f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f99:	eb 36                	jmp    801fd1 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	8b 40 08             	mov    0x8(%eax),%eax
  801fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fa4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fa8:	74 07                	je     801fb1 <find_block+0x36>
  801faa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fad:	8b 00                	mov    (%eax),%eax
  801faf:	eb 05                	jmp    801fb6 <find_block+0x3b>
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb9:	89 42 08             	mov    %eax,0x8(%edx)
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	8b 40 08             	mov    0x8(%eax),%eax
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	75 c5                	jne    801f8b <find_block+0x10>
  801fc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fca:	75 bf                	jne    801f8b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fd9:	a1 40 50 80 00       	mov    0x805040,%eax
  801fde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fe1:	a1 44 50 80 00       	mov    0x805044,%eax
  801fe6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fec:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fef:	74 24                	je     802015 <insert_sorted_allocList+0x42>
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	8b 50 08             	mov    0x8(%eax),%edx
  801ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffa:	8b 40 08             	mov    0x8(%eax),%eax
  801ffd:	39 c2                	cmp    %eax,%edx
  801fff:	76 14                	jbe    802015 <insert_sorted_allocList+0x42>
  802001:	8b 45 08             	mov    0x8(%ebp),%eax
  802004:	8b 50 08             	mov    0x8(%eax),%edx
  802007:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80200a:	8b 40 08             	mov    0x8(%eax),%eax
  80200d:	39 c2                	cmp    %eax,%edx
  80200f:	0f 82 60 01 00 00    	jb     802175 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802015:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802019:	75 65                	jne    802080 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80201b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80201f:	75 14                	jne    802035 <insert_sorted_allocList+0x62>
  802021:	83 ec 04             	sub    $0x4,%esp
  802024:	68 e4 3f 80 00       	push   $0x803fe4
  802029:	6a 6b                	push   $0x6b
  80202b:	68 07 40 80 00       	push   $0x804007
  802030:	e8 9c e2 ff ff       	call   8002d1 <_panic>
  802035:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 10                	mov    %edx,(%eax)
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	8b 00                	mov    (%eax),%eax
  802045:	85 c0                	test   %eax,%eax
  802047:	74 0d                	je     802056 <insert_sorted_allocList+0x83>
  802049:	a1 40 50 80 00       	mov    0x805040,%eax
  80204e:	8b 55 08             	mov    0x8(%ebp),%edx
  802051:	89 50 04             	mov    %edx,0x4(%eax)
  802054:	eb 08                	jmp    80205e <insert_sorted_allocList+0x8b>
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	a3 44 50 80 00       	mov    %eax,0x805044
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	a3 40 50 80 00       	mov    %eax,0x805040
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802070:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802075:	40                   	inc    %eax
  802076:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80207b:	e9 dc 01 00 00       	jmp    80225c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	8b 50 08             	mov    0x8(%eax),%edx
  802086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802089:	8b 40 08             	mov    0x8(%eax),%eax
  80208c:	39 c2                	cmp    %eax,%edx
  80208e:	77 6c                	ja     8020fc <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802090:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802094:	74 06                	je     80209c <insert_sorted_allocList+0xc9>
  802096:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80209a:	75 14                	jne    8020b0 <insert_sorted_allocList+0xdd>
  80209c:	83 ec 04             	sub    $0x4,%esp
  80209f:	68 20 40 80 00       	push   $0x804020
  8020a4:	6a 6f                	push   $0x6f
  8020a6:	68 07 40 80 00       	push   $0x804007
  8020ab:	e8 21 e2 ff ff       	call   8002d1 <_panic>
  8020b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b3:	8b 50 04             	mov    0x4(%eax),%edx
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	89 50 04             	mov    %edx,0x4(%eax)
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020c2:	89 10                	mov    %edx,(%eax)
  8020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c7:	8b 40 04             	mov    0x4(%eax),%eax
  8020ca:	85 c0                	test   %eax,%eax
  8020cc:	74 0d                	je     8020db <insert_sorted_allocList+0x108>
  8020ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d1:	8b 40 04             	mov    0x4(%eax),%eax
  8020d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d7:	89 10                	mov    %edx,(%eax)
  8020d9:	eb 08                	jmp    8020e3 <insert_sorted_allocList+0x110>
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	a3 40 50 80 00       	mov    %eax,0x805040
  8020e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e9:	89 50 04             	mov    %edx,0x4(%eax)
  8020ec:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020f1:	40                   	inc    %eax
  8020f2:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020f7:	e9 60 01 00 00       	jmp    80225c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	8b 50 08             	mov    0x8(%eax),%edx
  802102:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802105:	8b 40 08             	mov    0x8(%eax),%eax
  802108:	39 c2                	cmp    %eax,%edx
  80210a:	0f 82 4c 01 00 00    	jb     80225c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802110:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802114:	75 14                	jne    80212a <insert_sorted_allocList+0x157>
  802116:	83 ec 04             	sub    $0x4,%esp
  802119:	68 58 40 80 00       	push   $0x804058
  80211e:	6a 73                	push   $0x73
  802120:	68 07 40 80 00       	push   $0x804007
  802125:	e8 a7 e1 ff ff       	call   8002d1 <_panic>
  80212a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	89 50 04             	mov    %edx,0x4(%eax)
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	8b 40 04             	mov    0x4(%eax),%eax
  80213c:	85 c0                	test   %eax,%eax
  80213e:	74 0c                	je     80214c <insert_sorted_allocList+0x179>
  802140:	a1 44 50 80 00       	mov    0x805044,%eax
  802145:	8b 55 08             	mov    0x8(%ebp),%edx
  802148:	89 10                	mov    %edx,(%eax)
  80214a:	eb 08                	jmp    802154 <insert_sorted_allocList+0x181>
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	a3 40 50 80 00       	mov    %eax,0x805040
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	a3 44 50 80 00       	mov    %eax,0x805044
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802165:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80216a:	40                   	inc    %eax
  80216b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802170:	e9 e7 00 00 00       	jmp    80225c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802178:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80217b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802182:	a1 40 50 80 00       	mov    0x805040,%eax
  802187:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218a:	e9 9d 00 00 00       	jmp    80222c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80218f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802192:	8b 00                	mov    (%eax),%eax
  802194:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	8b 50 08             	mov    0x8(%eax),%edx
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	8b 40 08             	mov    0x8(%eax),%eax
  8021a3:	39 c2                	cmp    %eax,%edx
  8021a5:	76 7d                	jbe    802224 <insert_sorted_allocList+0x251>
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	8b 50 08             	mov    0x8(%eax),%edx
  8021ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021b0:	8b 40 08             	mov    0x8(%eax),%eax
  8021b3:	39 c2                	cmp    %eax,%edx
  8021b5:	73 6d                	jae    802224 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bb:	74 06                	je     8021c3 <insert_sorted_allocList+0x1f0>
  8021bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021c1:	75 14                	jne    8021d7 <insert_sorted_allocList+0x204>
  8021c3:	83 ec 04             	sub    $0x4,%esp
  8021c6:	68 7c 40 80 00       	push   $0x80407c
  8021cb:	6a 7f                	push   $0x7f
  8021cd:	68 07 40 80 00       	push   $0x804007
  8021d2:	e8 fa e0 ff ff       	call   8002d1 <_panic>
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	8b 10                	mov    (%eax),%edx
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	89 10                	mov    %edx,(%eax)
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	8b 00                	mov    (%eax),%eax
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	74 0b                	je     8021f5 <insert_sorted_allocList+0x222>
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	8b 00                	mov    (%eax),%eax
  8021ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f2:	89 50 04             	mov    %edx,0x4(%eax)
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fb:	89 10                	mov    %edx,(%eax)
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802203:	89 50 04             	mov    %edx,0x4(%eax)
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	8b 00                	mov    (%eax),%eax
  80220b:	85 c0                	test   %eax,%eax
  80220d:	75 08                	jne    802217 <insert_sorted_allocList+0x244>
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	a3 44 50 80 00       	mov    %eax,0x805044
  802217:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80221c:	40                   	inc    %eax
  80221d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802222:	eb 39                	jmp    80225d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802224:	a1 48 50 80 00       	mov    0x805048,%eax
  802229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80222c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802230:	74 07                	je     802239 <insert_sorted_allocList+0x266>
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	8b 00                	mov    (%eax),%eax
  802237:	eb 05                	jmp    80223e <insert_sorted_allocList+0x26b>
  802239:	b8 00 00 00 00       	mov    $0x0,%eax
  80223e:	a3 48 50 80 00       	mov    %eax,0x805048
  802243:	a1 48 50 80 00       	mov    0x805048,%eax
  802248:	85 c0                	test   %eax,%eax
  80224a:	0f 85 3f ff ff ff    	jne    80218f <insert_sorted_allocList+0x1bc>
  802250:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802254:	0f 85 35 ff ff ff    	jne    80218f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80225a:	eb 01                	jmp    80225d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80225c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80225d:	90                   	nop
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802266:	a1 38 51 80 00       	mov    0x805138,%eax
  80226b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226e:	e9 85 01 00 00       	jmp    8023f8 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	8b 40 0c             	mov    0xc(%eax),%eax
  802279:	3b 45 08             	cmp    0x8(%ebp),%eax
  80227c:	0f 82 6e 01 00 00    	jb     8023f0 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	8b 40 0c             	mov    0xc(%eax),%eax
  802288:	3b 45 08             	cmp    0x8(%ebp),%eax
  80228b:	0f 85 8a 00 00 00    	jne    80231b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802291:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802295:	75 17                	jne    8022ae <alloc_block_FF+0x4e>
  802297:	83 ec 04             	sub    $0x4,%esp
  80229a:	68 b0 40 80 00       	push   $0x8040b0
  80229f:	68 93 00 00 00       	push   $0x93
  8022a4:	68 07 40 80 00       	push   $0x804007
  8022a9:	e8 23 e0 ff ff       	call   8002d1 <_panic>
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	8b 00                	mov    (%eax),%eax
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	74 10                	je     8022c7 <alloc_block_FF+0x67>
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 00                	mov    (%eax),%eax
  8022bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bf:	8b 52 04             	mov    0x4(%edx),%edx
  8022c2:	89 50 04             	mov    %edx,0x4(%eax)
  8022c5:	eb 0b                	jmp    8022d2 <alloc_block_FF+0x72>
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 40 04             	mov    0x4(%eax),%eax
  8022cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 40 04             	mov    0x4(%eax),%eax
  8022d8:	85 c0                	test   %eax,%eax
  8022da:	74 0f                	je     8022eb <alloc_block_FF+0x8b>
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	8b 40 04             	mov    0x4(%eax),%eax
  8022e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e5:	8b 12                	mov    (%edx),%edx
  8022e7:	89 10                	mov    %edx,(%eax)
  8022e9:	eb 0a                	jmp    8022f5 <alloc_block_FF+0x95>
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 00                	mov    (%eax),%eax
  8022f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802308:	a1 44 51 80 00       	mov    0x805144,%eax
  80230d:	48                   	dec    %eax
  80230e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	e9 10 01 00 00       	jmp    80242b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 40 0c             	mov    0xc(%eax),%eax
  802321:	3b 45 08             	cmp    0x8(%ebp),%eax
  802324:	0f 86 c6 00 00 00    	jbe    8023f0 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80232a:	a1 48 51 80 00       	mov    0x805148,%eax
  80232f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	8b 50 08             	mov    0x8(%eax),%edx
  802338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80233e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802341:	8b 55 08             	mov    0x8(%ebp),%edx
  802344:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802347:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80234b:	75 17                	jne    802364 <alloc_block_FF+0x104>
  80234d:	83 ec 04             	sub    $0x4,%esp
  802350:	68 b0 40 80 00       	push   $0x8040b0
  802355:	68 9b 00 00 00       	push   $0x9b
  80235a:	68 07 40 80 00       	push   $0x804007
  80235f:	e8 6d df ff ff       	call   8002d1 <_panic>
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802367:	8b 00                	mov    (%eax),%eax
  802369:	85 c0                	test   %eax,%eax
  80236b:	74 10                	je     80237d <alloc_block_FF+0x11d>
  80236d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802370:	8b 00                	mov    (%eax),%eax
  802372:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802375:	8b 52 04             	mov    0x4(%edx),%edx
  802378:	89 50 04             	mov    %edx,0x4(%eax)
  80237b:	eb 0b                	jmp    802388 <alloc_block_FF+0x128>
  80237d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802380:	8b 40 04             	mov    0x4(%eax),%eax
  802383:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238b:	8b 40 04             	mov    0x4(%eax),%eax
  80238e:	85 c0                	test   %eax,%eax
  802390:	74 0f                	je     8023a1 <alloc_block_FF+0x141>
  802392:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802395:	8b 40 04             	mov    0x4(%eax),%eax
  802398:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80239b:	8b 12                	mov    (%edx),%edx
  80239d:	89 10                	mov    %edx,(%eax)
  80239f:	eb 0a                	jmp    8023ab <alloc_block_FF+0x14b>
  8023a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a4:	8b 00                	mov    (%eax),%eax
  8023a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8023ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023be:	a1 54 51 80 00       	mov    0x805154,%eax
  8023c3:	48                   	dec    %eax
  8023c4:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 50 08             	mov    0x8(%eax),%edx
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	01 c2                	add    %eax,%edx
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e0:	2b 45 08             	sub    0x8(%ebp),%eax
  8023e3:	89 c2                	mov    %eax,%edx
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ee:	eb 3b                	jmp    80242b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8023f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fc:	74 07                	je     802405 <alloc_block_FF+0x1a5>
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	eb 05                	jmp    80240a <alloc_block_FF+0x1aa>
  802405:	b8 00 00 00 00       	mov    $0x0,%eax
  80240a:	a3 40 51 80 00       	mov    %eax,0x805140
  80240f:	a1 40 51 80 00       	mov    0x805140,%eax
  802414:	85 c0                	test   %eax,%eax
  802416:	0f 85 57 fe ff ff    	jne    802273 <alloc_block_FF+0x13>
  80241c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802420:	0f 85 4d fe ff ff    	jne    802273 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
  802430:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802433:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80243a:	a1 38 51 80 00       	mov    0x805138,%eax
  80243f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802442:	e9 df 00 00 00       	jmp    802526 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 40 0c             	mov    0xc(%eax),%eax
  80244d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802450:	0f 82 c8 00 00 00    	jb     80251e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 40 0c             	mov    0xc(%eax),%eax
  80245c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245f:	0f 85 8a 00 00 00    	jne    8024ef <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802465:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802469:	75 17                	jne    802482 <alloc_block_BF+0x55>
  80246b:	83 ec 04             	sub    $0x4,%esp
  80246e:	68 b0 40 80 00       	push   $0x8040b0
  802473:	68 b7 00 00 00       	push   $0xb7
  802478:	68 07 40 80 00       	push   $0x804007
  80247d:	e8 4f de ff ff       	call   8002d1 <_panic>
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 00                	mov    (%eax),%eax
  802487:	85 c0                	test   %eax,%eax
  802489:	74 10                	je     80249b <alloc_block_BF+0x6e>
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 00                	mov    (%eax),%eax
  802490:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802493:	8b 52 04             	mov    0x4(%edx),%edx
  802496:	89 50 04             	mov    %edx,0x4(%eax)
  802499:	eb 0b                	jmp    8024a6 <alloc_block_BF+0x79>
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	8b 40 04             	mov    0x4(%eax),%eax
  8024a1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	74 0f                	je     8024bf <alloc_block_BF+0x92>
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 40 04             	mov    0x4(%eax),%eax
  8024b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b9:	8b 12                	mov    (%edx),%edx
  8024bb:	89 10                	mov    %edx,(%eax)
  8024bd:	eb 0a                	jmp    8024c9 <alloc_block_BF+0x9c>
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	a3 38 51 80 00       	mov    %eax,0x805138
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024dc:	a1 44 51 80 00       	mov    0x805144,%eax
  8024e1:	48                   	dec    %eax
  8024e2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	e9 4d 01 00 00       	jmp    80263c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f8:	76 24                	jbe    80251e <alloc_block_BF+0xf1>
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802500:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802503:	73 19                	jae    80251e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802505:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 40 0c             	mov    0xc(%eax),%eax
  802512:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 40 08             	mov    0x8(%eax),%eax
  80251b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80251e:	a1 40 51 80 00       	mov    0x805140,%eax
  802523:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252a:	74 07                	je     802533 <alloc_block_BF+0x106>
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 00                	mov    (%eax),%eax
  802531:	eb 05                	jmp    802538 <alloc_block_BF+0x10b>
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	a3 40 51 80 00       	mov    %eax,0x805140
  80253d:	a1 40 51 80 00       	mov    0x805140,%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	0f 85 fd fe ff ff    	jne    802447 <alloc_block_BF+0x1a>
  80254a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254e:	0f 85 f3 fe ff ff    	jne    802447 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802554:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802558:	0f 84 d9 00 00 00    	je     802637 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80255e:	a1 48 51 80 00       	mov    0x805148,%eax
  802563:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802569:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80256c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80256f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802572:	8b 55 08             	mov    0x8(%ebp),%edx
  802575:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802578:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80257c:	75 17                	jne    802595 <alloc_block_BF+0x168>
  80257e:	83 ec 04             	sub    $0x4,%esp
  802581:	68 b0 40 80 00       	push   $0x8040b0
  802586:	68 c7 00 00 00       	push   $0xc7
  80258b:	68 07 40 80 00       	push   $0x804007
  802590:	e8 3c dd ff ff       	call   8002d1 <_panic>
  802595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	85 c0                	test   %eax,%eax
  80259c:	74 10                	je     8025ae <alloc_block_BF+0x181>
  80259e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a1:	8b 00                	mov    (%eax),%eax
  8025a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a6:	8b 52 04             	mov    0x4(%edx),%edx
  8025a9:	89 50 04             	mov    %edx,0x4(%eax)
  8025ac:	eb 0b                	jmp    8025b9 <alloc_block_BF+0x18c>
  8025ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b1:	8b 40 04             	mov    0x4(%eax),%eax
  8025b4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bc:	8b 40 04             	mov    0x4(%eax),%eax
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	74 0f                	je     8025d2 <alloc_block_BF+0x1a5>
  8025c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c6:	8b 40 04             	mov    0x4(%eax),%eax
  8025c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025cc:	8b 12                	mov    (%edx),%edx
  8025ce:	89 10                	mov    %edx,(%eax)
  8025d0:	eb 0a                	jmp    8025dc <alloc_block_BF+0x1af>
  8025d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8025dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ef:	a1 54 51 80 00       	mov    0x805154,%eax
  8025f4:	48                   	dec    %eax
  8025f5:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025fa:	83 ec 08             	sub    $0x8,%esp
  8025fd:	ff 75 ec             	pushl  -0x14(%ebp)
  802600:	68 38 51 80 00       	push   $0x805138
  802605:	e8 71 f9 ff ff       	call   801f7b <find_block>
  80260a:	83 c4 10             	add    $0x10,%esp
  80260d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802613:	8b 50 08             	mov    0x8(%eax),%edx
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	01 c2                	add    %eax,%edx
  80261b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802621:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802624:	8b 40 0c             	mov    0xc(%eax),%eax
  802627:	2b 45 08             	sub    0x8(%ebp),%eax
  80262a:	89 c2                	mov    %eax,%edx
  80262c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802635:	eb 05                	jmp    80263c <alloc_block_BF+0x20f>
	}
	return NULL;
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
  802641:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802644:	a1 28 50 80 00       	mov    0x805028,%eax
  802649:	85 c0                	test   %eax,%eax
  80264b:	0f 85 de 01 00 00    	jne    80282f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802651:	a1 38 51 80 00       	mov    0x805138,%eax
  802656:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802659:	e9 9e 01 00 00       	jmp    8027fc <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 40 0c             	mov    0xc(%eax),%eax
  802664:	3b 45 08             	cmp    0x8(%ebp),%eax
  802667:	0f 82 87 01 00 00    	jb     8027f4 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 40 0c             	mov    0xc(%eax),%eax
  802673:	3b 45 08             	cmp    0x8(%ebp),%eax
  802676:	0f 85 95 00 00 00    	jne    802711 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80267c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802680:	75 17                	jne    802699 <alloc_block_NF+0x5b>
  802682:	83 ec 04             	sub    $0x4,%esp
  802685:	68 b0 40 80 00       	push   $0x8040b0
  80268a:	68 e0 00 00 00       	push   $0xe0
  80268f:	68 07 40 80 00       	push   $0x804007
  802694:	e8 38 dc ff ff       	call   8002d1 <_panic>
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 00                	mov    (%eax),%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	74 10                	je     8026b2 <alloc_block_NF+0x74>
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 00                	mov    (%eax),%eax
  8026a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026aa:	8b 52 04             	mov    0x4(%edx),%edx
  8026ad:	89 50 04             	mov    %edx,0x4(%eax)
  8026b0:	eb 0b                	jmp    8026bd <alloc_block_NF+0x7f>
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 04             	mov    0x4(%eax),%eax
  8026b8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 40 04             	mov    0x4(%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	74 0f                	je     8026d6 <alloc_block_NF+0x98>
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d0:	8b 12                	mov    (%edx),%edx
  8026d2:	89 10                	mov    %edx,(%eax)
  8026d4:	eb 0a                	jmp    8026e0 <alloc_block_NF+0xa2>
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 00                	mov    (%eax),%eax
  8026db:	a3 38 51 80 00       	mov    %eax,0x805138
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f3:	a1 44 51 80 00       	mov    0x805144,%eax
  8026f8:	48                   	dec    %eax
  8026f9:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 40 08             	mov    0x8(%eax),%eax
  802704:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	e9 f8 04 00 00       	jmp    802c09 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 40 0c             	mov    0xc(%eax),%eax
  802717:	3b 45 08             	cmp    0x8(%ebp),%eax
  80271a:	0f 86 d4 00 00 00    	jbe    8027f4 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802720:	a1 48 51 80 00       	mov    0x805148,%eax
  802725:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 50 08             	mov    0x8(%eax),%edx
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802737:	8b 55 08             	mov    0x8(%ebp),%edx
  80273a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80273d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802741:	75 17                	jne    80275a <alloc_block_NF+0x11c>
  802743:	83 ec 04             	sub    $0x4,%esp
  802746:	68 b0 40 80 00       	push   $0x8040b0
  80274b:	68 e9 00 00 00       	push   $0xe9
  802750:	68 07 40 80 00       	push   $0x804007
  802755:	e8 77 db ff ff       	call   8002d1 <_panic>
  80275a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	85 c0                	test   %eax,%eax
  802761:	74 10                	je     802773 <alloc_block_NF+0x135>
  802763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802766:	8b 00                	mov    (%eax),%eax
  802768:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80276b:	8b 52 04             	mov    0x4(%edx),%edx
  80276e:	89 50 04             	mov    %edx,0x4(%eax)
  802771:	eb 0b                	jmp    80277e <alloc_block_NF+0x140>
  802773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802776:	8b 40 04             	mov    0x4(%eax),%eax
  802779:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80277e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802781:	8b 40 04             	mov    0x4(%eax),%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	74 0f                	je     802797 <alloc_block_NF+0x159>
  802788:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278b:	8b 40 04             	mov    0x4(%eax),%eax
  80278e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802791:	8b 12                	mov    (%edx),%edx
  802793:	89 10                	mov    %edx,(%eax)
  802795:	eb 0a                	jmp    8027a1 <alloc_block_NF+0x163>
  802797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	a3 48 51 80 00       	mov    %eax,0x805148
  8027a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8027b9:	48                   	dec    %eax
  8027ba:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c2:	8b 40 08             	mov    0x8(%eax),%eax
  8027c5:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 50 08             	mov    0x8(%eax),%edx
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	01 c2                	add    %eax,%edx
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e1:	2b 45 08             	sub    0x8(%ebp),%eax
  8027e4:	89 c2                	mov    %eax,%edx
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ef:	e9 15 04 00 00       	jmp    802c09 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027f4:	a1 40 51 80 00       	mov    0x805140,%eax
  8027f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802800:	74 07                	je     802809 <alloc_block_NF+0x1cb>
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 00                	mov    (%eax),%eax
  802807:	eb 05                	jmp    80280e <alloc_block_NF+0x1d0>
  802809:	b8 00 00 00 00       	mov    $0x0,%eax
  80280e:	a3 40 51 80 00       	mov    %eax,0x805140
  802813:	a1 40 51 80 00       	mov    0x805140,%eax
  802818:	85 c0                	test   %eax,%eax
  80281a:	0f 85 3e fe ff ff    	jne    80265e <alloc_block_NF+0x20>
  802820:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802824:	0f 85 34 fe ff ff    	jne    80265e <alloc_block_NF+0x20>
  80282a:	e9 d5 03 00 00       	jmp    802c04 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80282f:	a1 38 51 80 00       	mov    0x805138,%eax
  802834:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802837:	e9 b1 01 00 00       	jmp    8029ed <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 50 08             	mov    0x8(%eax),%edx
  802842:	a1 28 50 80 00       	mov    0x805028,%eax
  802847:	39 c2                	cmp    %eax,%edx
  802849:	0f 82 96 01 00 00    	jb     8029e5 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 40 0c             	mov    0xc(%eax),%eax
  802855:	3b 45 08             	cmp    0x8(%ebp),%eax
  802858:	0f 82 87 01 00 00    	jb     8029e5 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 40 0c             	mov    0xc(%eax),%eax
  802864:	3b 45 08             	cmp    0x8(%ebp),%eax
  802867:	0f 85 95 00 00 00    	jne    802902 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80286d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802871:	75 17                	jne    80288a <alloc_block_NF+0x24c>
  802873:	83 ec 04             	sub    $0x4,%esp
  802876:	68 b0 40 80 00       	push   $0x8040b0
  80287b:	68 fc 00 00 00       	push   $0xfc
  802880:	68 07 40 80 00       	push   $0x804007
  802885:	e8 47 da ff ff       	call   8002d1 <_panic>
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 00                	mov    (%eax),%eax
  80288f:	85 c0                	test   %eax,%eax
  802891:	74 10                	je     8028a3 <alloc_block_NF+0x265>
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 00                	mov    (%eax),%eax
  802898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289b:	8b 52 04             	mov    0x4(%edx),%edx
  80289e:	89 50 04             	mov    %edx,0x4(%eax)
  8028a1:	eb 0b                	jmp    8028ae <alloc_block_NF+0x270>
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 40 04             	mov    0x4(%eax),%eax
  8028a9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 40 04             	mov    0x4(%eax),%eax
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	74 0f                	je     8028c7 <alloc_block_NF+0x289>
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 40 04             	mov    0x4(%eax),%eax
  8028be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c1:	8b 12                	mov    (%edx),%edx
  8028c3:	89 10                	mov    %edx,(%eax)
  8028c5:	eb 0a                	jmp    8028d1 <alloc_block_NF+0x293>
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	a3 38 51 80 00       	mov    %eax,0x805138
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e4:	a1 44 51 80 00       	mov    0x805144,%eax
  8028e9:	48                   	dec    %eax
  8028ea:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 40 08             	mov    0x8(%eax),%eax
  8028f5:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	e9 07 03 00 00       	jmp    802c09 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	8b 40 0c             	mov    0xc(%eax),%eax
  802908:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290b:	0f 86 d4 00 00 00    	jbe    8029e5 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802911:	a1 48 51 80 00       	mov    0x805148,%eax
  802916:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	8b 50 08             	mov    0x8(%eax),%edx
  80291f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802922:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802925:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802928:	8b 55 08             	mov    0x8(%ebp),%edx
  80292b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80292e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802932:	75 17                	jne    80294b <alloc_block_NF+0x30d>
  802934:	83 ec 04             	sub    $0x4,%esp
  802937:	68 b0 40 80 00       	push   $0x8040b0
  80293c:	68 04 01 00 00       	push   $0x104
  802941:	68 07 40 80 00       	push   $0x804007
  802946:	e8 86 d9 ff ff       	call   8002d1 <_panic>
  80294b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	74 10                	je     802964 <alloc_block_NF+0x326>
  802954:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80295c:	8b 52 04             	mov    0x4(%edx),%edx
  80295f:	89 50 04             	mov    %edx,0x4(%eax)
  802962:	eb 0b                	jmp    80296f <alloc_block_NF+0x331>
  802964:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802967:	8b 40 04             	mov    0x4(%eax),%eax
  80296a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80296f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802972:	8b 40 04             	mov    0x4(%eax),%eax
  802975:	85 c0                	test   %eax,%eax
  802977:	74 0f                	je     802988 <alloc_block_NF+0x34a>
  802979:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297c:	8b 40 04             	mov    0x4(%eax),%eax
  80297f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802982:	8b 12                	mov    (%edx),%edx
  802984:	89 10                	mov    %edx,(%eax)
  802986:	eb 0a                	jmp    802992 <alloc_block_NF+0x354>
  802988:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	a3 48 51 80 00       	mov    %eax,0x805148
  802992:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802995:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a5:	a1 54 51 80 00       	mov    0x805154,%eax
  8029aa:	48                   	dec    %eax
  8029ab:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b3:	8b 40 08             	mov    0x8(%eax),%eax
  8029b6:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 50 08             	mov    0x8(%eax),%edx
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	01 c2                	add    %eax,%edx
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d2:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d5:	89 c2                	mov    %eax,%edx
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e0:	e9 24 02 00 00       	jmp    802c09 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f1:	74 07                	je     8029fa <alloc_block_NF+0x3bc>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	eb 05                	jmp    8029ff <alloc_block_NF+0x3c1>
  8029fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ff:	a3 40 51 80 00       	mov    %eax,0x805140
  802a04:	a1 40 51 80 00       	mov    0x805140,%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	0f 85 2b fe ff ff    	jne    80283c <alloc_block_NF+0x1fe>
  802a11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a15:	0f 85 21 fe ff ff    	jne    80283c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a1b:	a1 38 51 80 00       	mov    0x805138,%eax
  802a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a23:	e9 ae 01 00 00       	jmp    802bd6 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 50 08             	mov    0x8(%eax),%edx
  802a2e:	a1 28 50 80 00       	mov    0x805028,%eax
  802a33:	39 c2                	cmp    %eax,%edx
  802a35:	0f 83 93 01 00 00    	jae    802bce <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a44:	0f 82 84 01 00 00    	jb     802bce <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a50:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a53:	0f 85 95 00 00 00    	jne    802aee <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5d:	75 17                	jne    802a76 <alloc_block_NF+0x438>
  802a5f:	83 ec 04             	sub    $0x4,%esp
  802a62:	68 b0 40 80 00       	push   $0x8040b0
  802a67:	68 14 01 00 00       	push   $0x114
  802a6c:	68 07 40 80 00       	push   $0x804007
  802a71:	e8 5b d8 ff ff       	call   8002d1 <_panic>
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	8b 00                	mov    (%eax),%eax
  802a7b:	85 c0                	test   %eax,%eax
  802a7d:	74 10                	je     802a8f <alloc_block_NF+0x451>
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a87:	8b 52 04             	mov    0x4(%edx),%edx
  802a8a:	89 50 04             	mov    %edx,0x4(%eax)
  802a8d:	eb 0b                	jmp    802a9a <alloc_block_NF+0x45c>
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 40 04             	mov    0x4(%eax),%eax
  802a95:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 40 04             	mov    0x4(%eax),%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	74 0f                	je     802ab3 <alloc_block_NF+0x475>
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 04             	mov    0x4(%eax),%eax
  802aaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aad:	8b 12                	mov    (%edx),%edx
  802aaf:	89 10                	mov    %edx,(%eax)
  802ab1:	eb 0a                	jmp    802abd <alloc_block_NF+0x47f>
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 00                	mov    (%eax),%eax
  802ab8:	a3 38 51 80 00       	mov    %eax,0x805138
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ad5:	48                   	dec    %eax
  802ad6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 08             	mov    0x8(%eax),%eax
  802ae1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	e9 1b 01 00 00       	jmp    802c09 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	8b 40 0c             	mov    0xc(%eax),%eax
  802af4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af7:	0f 86 d1 00 00 00    	jbe    802bce <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802afd:	a1 48 51 80 00       	mov    0x805148,%eax
  802b02:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 50 08             	mov    0x8(%eax),%edx
  802b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b14:	8b 55 08             	mov    0x8(%ebp),%edx
  802b17:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b1e:	75 17                	jne    802b37 <alloc_block_NF+0x4f9>
  802b20:	83 ec 04             	sub    $0x4,%esp
  802b23:	68 b0 40 80 00       	push   $0x8040b0
  802b28:	68 1c 01 00 00       	push   $0x11c
  802b2d:	68 07 40 80 00       	push   $0x804007
  802b32:	e8 9a d7 ff ff       	call   8002d1 <_panic>
  802b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3a:	8b 00                	mov    (%eax),%eax
  802b3c:	85 c0                	test   %eax,%eax
  802b3e:	74 10                	je     802b50 <alloc_block_NF+0x512>
  802b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b43:	8b 00                	mov    (%eax),%eax
  802b45:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b48:	8b 52 04             	mov    0x4(%edx),%edx
  802b4b:	89 50 04             	mov    %edx,0x4(%eax)
  802b4e:	eb 0b                	jmp    802b5b <alloc_block_NF+0x51d>
  802b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b53:	8b 40 04             	mov    0x4(%eax),%eax
  802b56:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5e:	8b 40 04             	mov    0x4(%eax),%eax
  802b61:	85 c0                	test   %eax,%eax
  802b63:	74 0f                	je     802b74 <alloc_block_NF+0x536>
  802b65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b68:	8b 40 04             	mov    0x4(%eax),%eax
  802b6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b6e:	8b 12                	mov    (%edx),%edx
  802b70:	89 10                	mov    %edx,(%eax)
  802b72:	eb 0a                	jmp    802b7e <alloc_block_NF+0x540>
  802b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	a3 48 51 80 00       	mov    %eax,0x805148
  802b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b91:	a1 54 51 80 00       	mov    0x805154,%eax
  802b96:	48                   	dec    %eax
  802b97:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ba2:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 50 08             	mov    0x8(%eax),%edx
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	01 c2                	add    %eax,%edx
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbe:	2b 45 08             	sub    0x8(%ebp),%eax
  802bc1:	89 c2                	mov    %eax,%edx
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcc:	eb 3b                	jmp    802c09 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bce:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bda:	74 07                	je     802be3 <alloc_block_NF+0x5a5>
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	eb 05                	jmp    802be8 <alloc_block_NF+0x5aa>
  802be3:	b8 00 00 00 00       	mov    $0x0,%eax
  802be8:	a3 40 51 80 00       	mov    %eax,0x805140
  802bed:	a1 40 51 80 00       	mov    0x805140,%eax
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	0f 85 2e fe ff ff    	jne    802a28 <alloc_block_NF+0x3ea>
  802bfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfe:	0f 85 24 fe ff ff    	jne    802a28 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c09:	c9                   	leave  
  802c0a:	c3                   	ret    

00802c0b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c0b:	55                   	push   %ebp
  802c0c:	89 e5                	mov    %esp,%ebp
  802c0e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c11:	a1 38 51 80 00       	mov    0x805138,%eax
  802c16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c19:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c1e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c21:	a1 38 51 80 00       	mov    0x805138,%eax
  802c26:	85 c0                	test   %eax,%eax
  802c28:	74 14                	je     802c3e <insert_sorted_with_merge_freeList+0x33>
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	8b 50 08             	mov    0x8(%eax),%edx
  802c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c33:	8b 40 08             	mov    0x8(%eax),%eax
  802c36:	39 c2                	cmp    %eax,%edx
  802c38:	0f 87 9b 01 00 00    	ja     802dd9 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c3e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c42:	75 17                	jne    802c5b <insert_sorted_with_merge_freeList+0x50>
  802c44:	83 ec 04             	sub    $0x4,%esp
  802c47:	68 e4 3f 80 00       	push   $0x803fe4
  802c4c:	68 38 01 00 00       	push   $0x138
  802c51:	68 07 40 80 00       	push   $0x804007
  802c56:	e8 76 d6 ff ff       	call   8002d1 <_panic>
  802c5b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	89 10                	mov    %edx,(%eax)
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	74 0d                	je     802c7c <insert_sorted_with_merge_freeList+0x71>
  802c6f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c74:	8b 55 08             	mov    0x8(%ebp),%edx
  802c77:	89 50 04             	mov    %edx,0x4(%eax)
  802c7a:	eb 08                	jmp    802c84 <insert_sorted_with_merge_freeList+0x79>
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	a3 38 51 80 00       	mov    %eax,0x805138
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c96:	a1 44 51 80 00       	mov    0x805144,%eax
  802c9b:	40                   	inc    %eax
  802c9c:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ca1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca5:	0f 84 a8 06 00 00    	je     803353 <insert_sorted_with_merge_freeList+0x748>
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	8b 50 08             	mov    0x8(%eax),%edx
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb7:	01 c2                	add    %eax,%edx
  802cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbc:	8b 40 08             	mov    0x8(%eax),%eax
  802cbf:	39 c2                	cmp    %eax,%edx
  802cc1:	0f 85 8c 06 00 00    	jne    803353 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	8b 50 0c             	mov    0xc(%eax),%edx
  802ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd3:	01 c2                	add    %eax,%edx
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cdf:	75 17                	jne    802cf8 <insert_sorted_with_merge_freeList+0xed>
  802ce1:	83 ec 04             	sub    $0x4,%esp
  802ce4:	68 b0 40 80 00       	push   $0x8040b0
  802ce9:	68 3c 01 00 00       	push   $0x13c
  802cee:	68 07 40 80 00       	push   $0x804007
  802cf3:	e8 d9 d5 ff ff       	call   8002d1 <_panic>
  802cf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfb:	8b 00                	mov    (%eax),%eax
  802cfd:	85 c0                	test   %eax,%eax
  802cff:	74 10                	je     802d11 <insert_sorted_with_merge_freeList+0x106>
  802d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d04:	8b 00                	mov    (%eax),%eax
  802d06:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d09:	8b 52 04             	mov    0x4(%edx),%edx
  802d0c:	89 50 04             	mov    %edx,0x4(%eax)
  802d0f:	eb 0b                	jmp    802d1c <insert_sorted_with_merge_freeList+0x111>
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	8b 40 04             	mov    0x4(%eax),%eax
  802d17:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1f:	8b 40 04             	mov    0x4(%eax),%eax
  802d22:	85 c0                	test   %eax,%eax
  802d24:	74 0f                	je     802d35 <insert_sorted_with_merge_freeList+0x12a>
  802d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d29:	8b 40 04             	mov    0x4(%eax),%eax
  802d2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2f:	8b 12                	mov    (%edx),%edx
  802d31:	89 10                	mov    %edx,(%eax)
  802d33:	eb 0a                	jmp    802d3f <insert_sorted_with_merge_freeList+0x134>
  802d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	a3 38 51 80 00       	mov    %eax,0x805138
  802d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d52:	a1 44 51 80 00       	mov    0x805144,%eax
  802d57:	48                   	dec    %eax
  802d58:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d75:	75 17                	jne    802d8e <insert_sorted_with_merge_freeList+0x183>
  802d77:	83 ec 04             	sub    $0x4,%esp
  802d7a:	68 e4 3f 80 00       	push   $0x803fe4
  802d7f:	68 3f 01 00 00       	push   $0x13f
  802d84:	68 07 40 80 00       	push   $0x804007
  802d89:	e8 43 d5 ff ff       	call   8002d1 <_panic>
  802d8e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d97:	89 10                	mov    %edx,(%eax)
  802d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9c:	8b 00                	mov    (%eax),%eax
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	74 0d                	je     802daf <insert_sorted_with_merge_freeList+0x1a4>
  802da2:	a1 48 51 80 00       	mov    0x805148,%eax
  802da7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802daa:	89 50 04             	mov    %edx,0x4(%eax)
  802dad:	eb 08                	jmp    802db7 <insert_sorted_with_merge_freeList+0x1ac>
  802daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dba:	a3 48 51 80 00       	mov    %eax,0x805148
  802dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc9:	a1 54 51 80 00       	mov    0x805154,%eax
  802dce:	40                   	inc    %eax
  802dcf:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dd4:	e9 7a 05 00 00       	jmp    803353 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	8b 50 08             	mov    0x8(%eax),%edx
  802ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de2:	8b 40 08             	mov    0x8(%eax),%eax
  802de5:	39 c2                	cmp    %eax,%edx
  802de7:	0f 82 14 01 00 00    	jb     802f01 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df0:	8b 50 08             	mov    0x8(%eax),%edx
  802df3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df6:	8b 40 0c             	mov    0xc(%eax),%eax
  802df9:	01 c2                	add    %eax,%edx
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 40 08             	mov    0x8(%eax),%eax
  802e01:	39 c2                	cmp    %eax,%edx
  802e03:	0f 85 90 00 00 00    	jne    802e99 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 40 0c             	mov    0xc(%eax),%eax
  802e15:	01 c2                	add    %eax,%edx
  802e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e35:	75 17                	jne    802e4e <insert_sorted_with_merge_freeList+0x243>
  802e37:	83 ec 04             	sub    $0x4,%esp
  802e3a:	68 e4 3f 80 00       	push   $0x803fe4
  802e3f:	68 49 01 00 00       	push   $0x149
  802e44:	68 07 40 80 00       	push   $0x804007
  802e49:	e8 83 d4 ff ff       	call   8002d1 <_panic>
  802e4e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	89 10                	mov    %edx,(%eax)
  802e59:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5c:	8b 00                	mov    (%eax),%eax
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	74 0d                	je     802e6f <insert_sorted_with_merge_freeList+0x264>
  802e62:	a1 48 51 80 00       	mov    0x805148,%eax
  802e67:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6a:	89 50 04             	mov    %edx,0x4(%eax)
  802e6d:	eb 08                	jmp    802e77 <insert_sorted_with_merge_freeList+0x26c>
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	a3 48 51 80 00       	mov    %eax,0x805148
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e89:	a1 54 51 80 00       	mov    0x805154,%eax
  802e8e:	40                   	inc    %eax
  802e8f:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e94:	e9 bb 04 00 00       	jmp    803354 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9d:	75 17                	jne    802eb6 <insert_sorted_with_merge_freeList+0x2ab>
  802e9f:	83 ec 04             	sub    $0x4,%esp
  802ea2:	68 58 40 80 00       	push   $0x804058
  802ea7:	68 4c 01 00 00       	push   $0x14c
  802eac:	68 07 40 80 00       	push   $0x804007
  802eb1:	e8 1b d4 ff ff       	call   8002d1 <_panic>
  802eb6:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	89 50 04             	mov    %edx,0x4(%eax)
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 40 04             	mov    0x4(%eax),%eax
  802ec8:	85 c0                	test   %eax,%eax
  802eca:	74 0c                	je     802ed8 <insert_sorted_with_merge_freeList+0x2cd>
  802ecc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed4:	89 10                	mov    %edx,(%eax)
  802ed6:	eb 08                	jmp    802ee0 <insert_sorted_with_merge_freeList+0x2d5>
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	a3 38 51 80 00       	mov    %eax,0x805138
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ef6:	40                   	inc    %eax
  802ef7:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802efc:	e9 53 04 00 00       	jmp    803354 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f01:	a1 38 51 80 00       	mov    0x805138,%eax
  802f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f09:	e9 15 04 00 00       	jmp    803323 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	8b 50 08             	mov    0x8(%eax),%edx
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 40 08             	mov    0x8(%eax),%eax
  802f22:	39 c2                	cmp    %eax,%edx
  802f24:	0f 86 f1 03 00 00    	jbe    80331b <insert_sorted_with_merge_freeList+0x710>
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	8b 50 08             	mov    0x8(%eax),%edx
  802f30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f33:	8b 40 08             	mov    0x8(%eax),%eax
  802f36:	39 c2                	cmp    %eax,%edx
  802f38:	0f 83 dd 03 00 00    	jae    80331b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 50 08             	mov    0x8(%eax),%edx
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4a:	01 c2                	add    %eax,%edx
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	8b 40 08             	mov    0x8(%eax),%eax
  802f52:	39 c2                	cmp    %eax,%edx
  802f54:	0f 85 b9 01 00 00    	jne    803113 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	8b 50 08             	mov    0x8(%eax),%edx
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	8b 40 0c             	mov    0xc(%eax),%eax
  802f66:	01 c2                	add    %eax,%edx
  802f68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6b:	8b 40 08             	mov    0x8(%eax),%eax
  802f6e:	39 c2                	cmp    %eax,%edx
  802f70:	0f 85 0d 01 00 00    	jne    803083 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 50 0c             	mov    0xc(%eax),%edx
  802f7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f82:	01 c2                	add    %eax,%edx
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f8e:	75 17                	jne    802fa7 <insert_sorted_with_merge_freeList+0x39c>
  802f90:	83 ec 04             	sub    $0x4,%esp
  802f93:	68 b0 40 80 00       	push   $0x8040b0
  802f98:	68 5c 01 00 00       	push   $0x15c
  802f9d:	68 07 40 80 00       	push   $0x804007
  802fa2:	e8 2a d3 ff ff       	call   8002d1 <_panic>
  802fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faa:	8b 00                	mov    (%eax),%eax
  802fac:	85 c0                	test   %eax,%eax
  802fae:	74 10                	je     802fc0 <insert_sorted_with_merge_freeList+0x3b5>
  802fb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb3:	8b 00                	mov    (%eax),%eax
  802fb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb8:	8b 52 04             	mov    0x4(%edx),%edx
  802fbb:	89 50 04             	mov    %edx,0x4(%eax)
  802fbe:	eb 0b                	jmp    802fcb <insert_sorted_with_merge_freeList+0x3c0>
  802fc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc3:	8b 40 04             	mov    0x4(%eax),%eax
  802fc6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fce:	8b 40 04             	mov    0x4(%eax),%eax
  802fd1:	85 c0                	test   %eax,%eax
  802fd3:	74 0f                	je     802fe4 <insert_sorted_with_merge_freeList+0x3d9>
  802fd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd8:	8b 40 04             	mov    0x4(%eax),%eax
  802fdb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fde:	8b 12                	mov    (%edx),%edx
  802fe0:	89 10                	mov    %edx,(%eax)
  802fe2:	eb 0a                	jmp    802fee <insert_sorted_with_merge_freeList+0x3e3>
  802fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe7:	8b 00                	mov    (%eax),%eax
  802fe9:	a3 38 51 80 00       	mov    %eax,0x805138
  802fee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803001:	a1 44 51 80 00       	mov    0x805144,%eax
  803006:	48                   	dec    %eax
  803007:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80300c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803016:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803019:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803020:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803024:	75 17                	jne    80303d <insert_sorted_with_merge_freeList+0x432>
  803026:	83 ec 04             	sub    $0x4,%esp
  803029:	68 e4 3f 80 00       	push   $0x803fe4
  80302e:	68 5f 01 00 00       	push   $0x15f
  803033:	68 07 40 80 00       	push   $0x804007
  803038:	e8 94 d2 ff ff       	call   8002d1 <_panic>
  80303d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803043:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803046:	89 10                	mov    %edx,(%eax)
  803048:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	85 c0                	test   %eax,%eax
  80304f:	74 0d                	je     80305e <insert_sorted_with_merge_freeList+0x453>
  803051:	a1 48 51 80 00       	mov    0x805148,%eax
  803056:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803059:	89 50 04             	mov    %edx,0x4(%eax)
  80305c:	eb 08                	jmp    803066 <insert_sorted_with_merge_freeList+0x45b>
  80305e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803061:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803066:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803069:	a3 48 51 80 00       	mov    %eax,0x805148
  80306e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803071:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803078:	a1 54 51 80 00       	mov    0x805154,%eax
  80307d:	40                   	inc    %eax
  80307e:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	8b 50 0c             	mov    0xc(%eax),%edx
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	8b 40 0c             	mov    0xc(%eax),%eax
  80308f:	01 c2                	add    %eax,%edx
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030af:	75 17                	jne    8030c8 <insert_sorted_with_merge_freeList+0x4bd>
  8030b1:	83 ec 04             	sub    $0x4,%esp
  8030b4:	68 e4 3f 80 00       	push   $0x803fe4
  8030b9:	68 64 01 00 00       	push   $0x164
  8030be:	68 07 40 80 00       	push   $0x804007
  8030c3:	e8 09 d2 ff ff       	call   8002d1 <_panic>
  8030c8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	89 10                	mov    %edx,(%eax)
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	8b 00                	mov    (%eax),%eax
  8030d8:	85 c0                	test   %eax,%eax
  8030da:	74 0d                	je     8030e9 <insert_sorted_with_merge_freeList+0x4de>
  8030dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e4:	89 50 04             	mov    %edx,0x4(%eax)
  8030e7:	eb 08                	jmp    8030f1 <insert_sorted_with_merge_freeList+0x4e6>
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f4:	a3 48 51 80 00       	mov    %eax,0x805148
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803103:	a1 54 51 80 00       	mov    0x805154,%eax
  803108:	40                   	inc    %eax
  803109:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80310e:	e9 41 02 00 00       	jmp    803354 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	8b 50 08             	mov    0x8(%eax),%edx
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	8b 40 0c             	mov    0xc(%eax),%eax
  80311f:	01 c2                	add    %eax,%edx
  803121:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803124:	8b 40 08             	mov    0x8(%eax),%eax
  803127:	39 c2                	cmp    %eax,%edx
  803129:	0f 85 7c 01 00 00    	jne    8032ab <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80312f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803133:	74 06                	je     80313b <insert_sorted_with_merge_freeList+0x530>
  803135:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803139:	75 17                	jne    803152 <insert_sorted_with_merge_freeList+0x547>
  80313b:	83 ec 04             	sub    $0x4,%esp
  80313e:	68 20 40 80 00       	push   $0x804020
  803143:	68 69 01 00 00       	push   $0x169
  803148:	68 07 40 80 00       	push   $0x804007
  80314d:	e8 7f d1 ff ff       	call   8002d1 <_panic>
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	8b 50 04             	mov    0x4(%eax),%edx
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	89 50 04             	mov    %edx,0x4(%eax)
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803164:	89 10                	mov    %edx,(%eax)
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	8b 40 04             	mov    0x4(%eax),%eax
  80316c:	85 c0                	test   %eax,%eax
  80316e:	74 0d                	je     80317d <insert_sorted_with_merge_freeList+0x572>
  803170:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803173:	8b 40 04             	mov    0x4(%eax),%eax
  803176:	8b 55 08             	mov    0x8(%ebp),%edx
  803179:	89 10                	mov    %edx,(%eax)
  80317b:	eb 08                	jmp    803185 <insert_sorted_with_merge_freeList+0x57a>
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	a3 38 51 80 00       	mov    %eax,0x805138
  803185:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803188:	8b 55 08             	mov    0x8(%ebp),%edx
  80318b:	89 50 04             	mov    %edx,0x4(%eax)
  80318e:	a1 44 51 80 00       	mov    0x805144,%eax
  803193:	40                   	inc    %eax
  803194:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	8b 50 0c             	mov    0xc(%eax),%edx
  80319f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a5:	01 c2                	add    %eax,%edx
  8031a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031aa:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031b1:	75 17                	jne    8031ca <insert_sorted_with_merge_freeList+0x5bf>
  8031b3:	83 ec 04             	sub    $0x4,%esp
  8031b6:	68 b0 40 80 00       	push   $0x8040b0
  8031bb:	68 6b 01 00 00       	push   $0x16b
  8031c0:	68 07 40 80 00       	push   $0x804007
  8031c5:	e8 07 d1 ff ff       	call   8002d1 <_panic>
  8031ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cd:	8b 00                	mov    (%eax),%eax
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	74 10                	je     8031e3 <insert_sorted_with_merge_freeList+0x5d8>
  8031d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d6:	8b 00                	mov    (%eax),%eax
  8031d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031db:	8b 52 04             	mov    0x4(%edx),%edx
  8031de:	89 50 04             	mov    %edx,0x4(%eax)
  8031e1:	eb 0b                	jmp    8031ee <insert_sorted_with_merge_freeList+0x5e3>
  8031e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e6:	8b 40 04             	mov    0x4(%eax),%eax
  8031e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f1:	8b 40 04             	mov    0x4(%eax),%eax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	74 0f                	je     803207 <insert_sorted_with_merge_freeList+0x5fc>
  8031f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fb:	8b 40 04             	mov    0x4(%eax),%eax
  8031fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803201:	8b 12                	mov    (%edx),%edx
  803203:	89 10                	mov    %edx,(%eax)
  803205:	eb 0a                	jmp    803211 <insert_sorted_with_merge_freeList+0x606>
  803207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	a3 38 51 80 00       	mov    %eax,0x805138
  803211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803214:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803224:	a1 44 51 80 00       	mov    0x805144,%eax
  803229:	48                   	dec    %eax
  80322a:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80322f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803232:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803243:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803247:	75 17                	jne    803260 <insert_sorted_with_merge_freeList+0x655>
  803249:	83 ec 04             	sub    $0x4,%esp
  80324c:	68 e4 3f 80 00       	push   $0x803fe4
  803251:	68 6e 01 00 00       	push   $0x16e
  803256:	68 07 40 80 00       	push   $0x804007
  80325b:	e8 71 d0 ff ff       	call   8002d1 <_panic>
  803260:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803269:	89 10                	mov    %edx,(%eax)
  80326b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	85 c0                	test   %eax,%eax
  803272:	74 0d                	je     803281 <insert_sorted_with_merge_freeList+0x676>
  803274:	a1 48 51 80 00       	mov    0x805148,%eax
  803279:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80327c:	89 50 04             	mov    %edx,0x4(%eax)
  80327f:	eb 08                	jmp    803289 <insert_sorted_with_merge_freeList+0x67e>
  803281:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803284:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328c:	a3 48 51 80 00       	mov    %eax,0x805148
  803291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803294:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329b:	a1 54 51 80 00       	mov    0x805154,%eax
  8032a0:	40                   	inc    %eax
  8032a1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032a6:	e9 a9 00 00 00       	jmp    803354 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032af:	74 06                	je     8032b7 <insert_sorted_with_merge_freeList+0x6ac>
  8032b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b5:	75 17                	jne    8032ce <insert_sorted_with_merge_freeList+0x6c3>
  8032b7:	83 ec 04             	sub    $0x4,%esp
  8032ba:	68 7c 40 80 00       	push   $0x80407c
  8032bf:	68 73 01 00 00       	push   $0x173
  8032c4:	68 07 40 80 00       	push   $0x804007
  8032c9:	e8 03 d0 ff ff       	call   8002d1 <_panic>
  8032ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d1:	8b 10                	mov    (%eax),%edx
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	89 10                	mov    %edx,(%eax)
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	8b 00                	mov    (%eax),%eax
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	74 0b                	je     8032ec <insert_sorted_with_merge_freeList+0x6e1>
  8032e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e4:	8b 00                	mov    (%eax),%eax
  8032e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e9:	89 50 04             	mov    %edx,0x4(%eax)
  8032ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f2:	89 10                	mov    %edx,(%eax)
  8032f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032fa:	89 50 04             	mov    %edx,0x4(%eax)
  8032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803300:	8b 00                	mov    (%eax),%eax
  803302:	85 c0                	test   %eax,%eax
  803304:	75 08                	jne    80330e <insert_sorted_with_merge_freeList+0x703>
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80330e:	a1 44 51 80 00       	mov    0x805144,%eax
  803313:	40                   	inc    %eax
  803314:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803319:	eb 39                	jmp    803354 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80331b:	a1 40 51 80 00       	mov    0x805140,%eax
  803320:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803323:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803327:	74 07                	je     803330 <insert_sorted_with_merge_freeList+0x725>
  803329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332c:	8b 00                	mov    (%eax),%eax
  80332e:	eb 05                	jmp    803335 <insert_sorted_with_merge_freeList+0x72a>
  803330:	b8 00 00 00 00       	mov    $0x0,%eax
  803335:	a3 40 51 80 00       	mov    %eax,0x805140
  80333a:	a1 40 51 80 00       	mov    0x805140,%eax
  80333f:	85 c0                	test   %eax,%eax
  803341:	0f 85 c7 fb ff ff    	jne    802f0e <insert_sorted_with_merge_freeList+0x303>
  803347:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80334b:	0f 85 bd fb ff ff    	jne    802f0e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803351:	eb 01                	jmp    803354 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803353:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803354:	90                   	nop
  803355:	c9                   	leave  
  803356:	c3                   	ret    

00803357 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803357:	55                   	push   %ebp
  803358:	89 e5                	mov    %esp,%ebp
  80335a:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80335d:	8b 55 08             	mov    0x8(%ebp),%edx
  803360:	89 d0                	mov    %edx,%eax
  803362:	c1 e0 02             	shl    $0x2,%eax
  803365:	01 d0                	add    %edx,%eax
  803367:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80336e:	01 d0                	add    %edx,%eax
  803370:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803377:	01 d0                	add    %edx,%eax
  803379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803380:	01 d0                	add    %edx,%eax
  803382:	c1 e0 04             	shl    $0x4,%eax
  803385:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803388:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80338f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803392:	83 ec 0c             	sub    $0xc,%esp
  803395:	50                   	push   %eax
  803396:	e8 26 e7 ff ff       	call   801ac1 <sys_get_virtual_time>
  80339b:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80339e:	eb 41                	jmp    8033e1 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033a3:	83 ec 0c             	sub    $0xc,%esp
  8033a6:	50                   	push   %eax
  8033a7:	e8 15 e7 ff ff       	call   801ac1 <sys_get_virtual_time>
  8033ac:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b5:	29 c2                	sub    %eax,%edx
  8033b7:	89 d0                	mov    %edx,%eax
  8033b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c2:	89 d1                	mov    %edx,%ecx
  8033c4:	29 c1                	sub    %eax,%ecx
  8033c6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033cc:	39 c2                	cmp    %eax,%edx
  8033ce:	0f 97 c0             	seta   %al
  8033d1:	0f b6 c0             	movzbl %al,%eax
  8033d4:	29 c1                	sub    %eax,%ecx
  8033d6:	89 c8                	mov    %ecx,%eax
  8033d8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033de:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033e7:	72 b7                	jb     8033a0 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033e9:	90                   	nop
  8033ea:	c9                   	leave  
  8033eb:	c3                   	ret    

008033ec <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033ec:	55                   	push   %ebp
  8033ed:	89 e5                	mov    %esp,%ebp
  8033ef:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033f9:	eb 03                	jmp    8033fe <busy_wait+0x12>
  8033fb:	ff 45 fc             	incl   -0x4(%ebp)
  8033fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803401:	3b 45 08             	cmp    0x8(%ebp),%eax
  803404:	72 f5                	jb     8033fb <busy_wait+0xf>
	return i;
  803406:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803409:	c9                   	leave  
  80340a:	c3                   	ret    
  80340b:	90                   	nop

0080340c <__udivdi3>:
  80340c:	55                   	push   %ebp
  80340d:	57                   	push   %edi
  80340e:	56                   	push   %esi
  80340f:	53                   	push   %ebx
  803410:	83 ec 1c             	sub    $0x1c,%esp
  803413:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803417:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80341b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80341f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803423:	89 ca                	mov    %ecx,%edx
  803425:	89 f8                	mov    %edi,%eax
  803427:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80342b:	85 f6                	test   %esi,%esi
  80342d:	75 2d                	jne    80345c <__udivdi3+0x50>
  80342f:	39 cf                	cmp    %ecx,%edi
  803431:	77 65                	ja     803498 <__udivdi3+0x8c>
  803433:	89 fd                	mov    %edi,%ebp
  803435:	85 ff                	test   %edi,%edi
  803437:	75 0b                	jne    803444 <__udivdi3+0x38>
  803439:	b8 01 00 00 00       	mov    $0x1,%eax
  80343e:	31 d2                	xor    %edx,%edx
  803440:	f7 f7                	div    %edi
  803442:	89 c5                	mov    %eax,%ebp
  803444:	31 d2                	xor    %edx,%edx
  803446:	89 c8                	mov    %ecx,%eax
  803448:	f7 f5                	div    %ebp
  80344a:	89 c1                	mov    %eax,%ecx
  80344c:	89 d8                	mov    %ebx,%eax
  80344e:	f7 f5                	div    %ebp
  803450:	89 cf                	mov    %ecx,%edi
  803452:	89 fa                	mov    %edi,%edx
  803454:	83 c4 1c             	add    $0x1c,%esp
  803457:	5b                   	pop    %ebx
  803458:	5e                   	pop    %esi
  803459:	5f                   	pop    %edi
  80345a:	5d                   	pop    %ebp
  80345b:	c3                   	ret    
  80345c:	39 ce                	cmp    %ecx,%esi
  80345e:	77 28                	ja     803488 <__udivdi3+0x7c>
  803460:	0f bd fe             	bsr    %esi,%edi
  803463:	83 f7 1f             	xor    $0x1f,%edi
  803466:	75 40                	jne    8034a8 <__udivdi3+0x9c>
  803468:	39 ce                	cmp    %ecx,%esi
  80346a:	72 0a                	jb     803476 <__udivdi3+0x6a>
  80346c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803470:	0f 87 9e 00 00 00    	ja     803514 <__udivdi3+0x108>
  803476:	b8 01 00 00 00       	mov    $0x1,%eax
  80347b:	89 fa                	mov    %edi,%edx
  80347d:	83 c4 1c             	add    $0x1c,%esp
  803480:	5b                   	pop    %ebx
  803481:	5e                   	pop    %esi
  803482:	5f                   	pop    %edi
  803483:	5d                   	pop    %ebp
  803484:	c3                   	ret    
  803485:	8d 76 00             	lea    0x0(%esi),%esi
  803488:	31 ff                	xor    %edi,%edi
  80348a:	31 c0                	xor    %eax,%eax
  80348c:	89 fa                	mov    %edi,%edx
  80348e:	83 c4 1c             	add    $0x1c,%esp
  803491:	5b                   	pop    %ebx
  803492:	5e                   	pop    %esi
  803493:	5f                   	pop    %edi
  803494:	5d                   	pop    %ebp
  803495:	c3                   	ret    
  803496:	66 90                	xchg   %ax,%ax
  803498:	89 d8                	mov    %ebx,%eax
  80349a:	f7 f7                	div    %edi
  80349c:	31 ff                	xor    %edi,%edi
  80349e:	89 fa                	mov    %edi,%edx
  8034a0:	83 c4 1c             	add    $0x1c,%esp
  8034a3:	5b                   	pop    %ebx
  8034a4:	5e                   	pop    %esi
  8034a5:	5f                   	pop    %edi
  8034a6:	5d                   	pop    %ebp
  8034a7:	c3                   	ret    
  8034a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034ad:	89 eb                	mov    %ebp,%ebx
  8034af:	29 fb                	sub    %edi,%ebx
  8034b1:	89 f9                	mov    %edi,%ecx
  8034b3:	d3 e6                	shl    %cl,%esi
  8034b5:	89 c5                	mov    %eax,%ebp
  8034b7:	88 d9                	mov    %bl,%cl
  8034b9:	d3 ed                	shr    %cl,%ebp
  8034bb:	89 e9                	mov    %ebp,%ecx
  8034bd:	09 f1                	or     %esi,%ecx
  8034bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034c3:	89 f9                	mov    %edi,%ecx
  8034c5:	d3 e0                	shl    %cl,%eax
  8034c7:	89 c5                	mov    %eax,%ebp
  8034c9:	89 d6                	mov    %edx,%esi
  8034cb:	88 d9                	mov    %bl,%cl
  8034cd:	d3 ee                	shr    %cl,%esi
  8034cf:	89 f9                	mov    %edi,%ecx
  8034d1:	d3 e2                	shl    %cl,%edx
  8034d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034d7:	88 d9                	mov    %bl,%cl
  8034d9:	d3 e8                	shr    %cl,%eax
  8034db:	09 c2                	or     %eax,%edx
  8034dd:	89 d0                	mov    %edx,%eax
  8034df:	89 f2                	mov    %esi,%edx
  8034e1:	f7 74 24 0c          	divl   0xc(%esp)
  8034e5:	89 d6                	mov    %edx,%esi
  8034e7:	89 c3                	mov    %eax,%ebx
  8034e9:	f7 e5                	mul    %ebp
  8034eb:	39 d6                	cmp    %edx,%esi
  8034ed:	72 19                	jb     803508 <__udivdi3+0xfc>
  8034ef:	74 0b                	je     8034fc <__udivdi3+0xf0>
  8034f1:	89 d8                	mov    %ebx,%eax
  8034f3:	31 ff                	xor    %edi,%edi
  8034f5:	e9 58 ff ff ff       	jmp    803452 <__udivdi3+0x46>
  8034fa:	66 90                	xchg   %ax,%ax
  8034fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803500:	89 f9                	mov    %edi,%ecx
  803502:	d3 e2                	shl    %cl,%edx
  803504:	39 c2                	cmp    %eax,%edx
  803506:	73 e9                	jae    8034f1 <__udivdi3+0xe5>
  803508:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80350b:	31 ff                	xor    %edi,%edi
  80350d:	e9 40 ff ff ff       	jmp    803452 <__udivdi3+0x46>
  803512:	66 90                	xchg   %ax,%ax
  803514:	31 c0                	xor    %eax,%eax
  803516:	e9 37 ff ff ff       	jmp    803452 <__udivdi3+0x46>
  80351b:	90                   	nop

0080351c <__umoddi3>:
  80351c:	55                   	push   %ebp
  80351d:	57                   	push   %edi
  80351e:	56                   	push   %esi
  80351f:	53                   	push   %ebx
  803520:	83 ec 1c             	sub    $0x1c,%esp
  803523:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803527:	8b 74 24 34          	mov    0x34(%esp),%esi
  80352b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80352f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803533:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803537:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80353b:	89 f3                	mov    %esi,%ebx
  80353d:	89 fa                	mov    %edi,%edx
  80353f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803543:	89 34 24             	mov    %esi,(%esp)
  803546:	85 c0                	test   %eax,%eax
  803548:	75 1a                	jne    803564 <__umoddi3+0x48>
  80354a:	39 f7                	cmp    %esi,%edi
  80354c:	0f 86 a2 00 00 00    	jbe    8035f4 <__umoddi3+0xd8>
  803552:	89 c8                	mov    %ecx,%eax
  803554:	89 f2                	mov    %esi,%edx
  803556:	f7 f7                	div    %edi
  803558:	89 d0                	mov    %edx,%eax
  80355a:	31 d2                	xor    %edx,%edx
  80355c:	83 c4 1c             	add    $0x1c,%esp
  80355f:	5b                   	pop    %ebx
  803560:	5e                   	pop    %esi
  803561:	5f                   	pop    %edi
  803562:	5d                   	pop    %ebp
  803563:	c3                   	ret    
  803564:	39 f0                	cmp    %esi,%eax
  803566:	0f 87 ac 00 00 00    	ja     803618 <__umoddi3+0xfc>
  80356c:	0f bd e8             	bsr    %eax,%ebp
  80356f:	83 f5 1f             	xor    $0x1f,%ebp
  803572:	0f 84 ac 00 00 00    	je     803624 <__umoddi3+0x108>
  803578:	bf 20 00 00 00       	mov    $0x20,%edi
  80357d:	29 ef                	sub    %ebp,%edi
  80357f:	89 fe                	mov    %edi,%esi
  803581:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803585:	89 e9                	mov    %ebp,%ecx
  803587:	d3 e0                	shl    %cl,%eax
  803589:	89 d7                	mov    %edx,%edi
  80358b:	89 f1                	mov    %esi,%ecx
  80358d:	d3 ef                	shr    %cl,%edi
  80358f:	09 c7                	or     %eax,%edi
  803591:	89 e9                	mov    %ebp,%ecx
  803593:	d3 e2                	shl    %cl,%edx
  803595:	89 14 24             	mov    %edx,(%esp)
  803598:	89 d8                	mov    %ebx,%eax
  80359a:	d3 e0                	shl    %cl,%eax
  80359c:	89 c2                	mov    %eax,%edx
  80359e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a2:	d3 e0                	shl    %cl,%eax
  8035a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035ac:	89 f1                	mov    %esi,%ecx
  8035ae:	d3 e8                	shr    %cl,%eax
  8035b0:	09 d0                	or     %edx,%eax
  8035b2:	d3 eb                	shr    %cl,%ebx
  8035b4:	89 da                	mov    %ebx,%edx
  8035b6:	f7 f7                	div    %edi
  8035b8:	89 d3                	mov    %edx,%ebx
  8035ba:	f7 24 24             	mull   (%esp)
  8035bd:	89 c6                	mov    %eax,%esi
  8035bf:	89 d1                	mov    %edx,%ecx
  8035c1:	39 d3                	cmp    %edx,%ebx
  8035c3:	0f 82 87 00 00 00    	jb     803650 <__umoddi3+0x134>
  8035c9:	0f 84 91 00 00 00    	je     803660 <__umoddi3+0x144>
  8035cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035d3:	29 f2                	sub    %esi,%edx
  8035d5:	19 cb                	sbb    %ecx,%ebx
  8035d7:	89 d8                	mov    %ebx,%eax
  8035d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035dd:	d3 e0                	shl    %cl,%eax
  8035df:	89 e9                	mov    %ebp,%ecx
  8035e1:	d3 ea                	shr    %cl,%edx
  8035e3:	09 d0                	or     %edx,%eax
  8035e5:	89 e9                	mov    %ebp,%ecx
  8035e7:	d3 eb                	shr    %cl,%ebx
  8035e9:	89 da                	mov    %ebx,%edx
  8035eb:	83 c4 1c             	add    $0x1c,%esp
  8035ee:	5b                   	pop    %ebx
  8035ef:	5e                   	pop    %esi
  8035f0:	5f                   	pop    %edi
  8035f1:	5d                   	pop    %ebp
  8035f2:	c3                   	ret    
  8035f3:	90                   	nop
  8035f4:	89 fd                	mov    %edi,%ebp
  8035f6:	85 ff                	test   %edi,%edi
  8035f8:	75 0b                	jne    803605 <__umoddi3+0xe9>
  8035fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8035ff:	31 d2                	xor    %edx,%edx
  803601:	f7 f7                	div    %edi
  803603:	89 c5                	mov    %eax,%ebp
  803605:	89 f0                	mov    %esi,%eax
  803607:	31 d2                	xor    %edx,%edx
  803609:	f7 f5                	div    %ebp
  80360b:	89 c8                	mov    %ecx,%eax
  80360d:	f7 f5                	div    %ebp
  80360f:	89 d0                	mov    %edx,%eax
  803611:	e9 44 ff ff ff       	jmp    80355a <__umoddi3+0x3e>
  803616:	66 90                	xchg   %ax,%ax
  803618:	89 c8                	mov    %ecx,%eax
  80361a:	89 f2                	mov    %esi,%edx
  80361c:	83 c4 1c             	add    $0x1c,%esp
  80361f:	5b                   	pop    %ebx
  803620:	5e                   	pop    %esi
  803621:	5f                   	pop    %edi
  803622:	5d                   	pop    %ebp
  803623:	c3                   	ret    
  803624:	3b 04 24             	cmp    (%esp),%eax
  803627:	72 06                	jb     80362f <__umoddi3+0x113>
  803629:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80362d:	77 0f                	ja     80363e <__umoddi3+0x122>
  80362f:	89 f2                	mov    %esi,%edx
  803631:	29 f9                	sub    %edi,%ecx
  803633:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803637:	89 14 24             	mov    %edx,(%esp)
  80363a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80363e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803642:	8b 14 24             	mov    (%esp),%edx
  803645:	83 c4 1c             	add    $0x1c,%esp
  803648:	5b                   	pop    %ebx
  803649:	5e                   	pop    %esi
  80364a:	5f                   	pop    %edi
  80364b:	5d                   	pop    %ebp
  80364c:	c3                   	ret    
  80364d:	8d 76 00             	lea    0x0(%esi),%esi
  803650:	2b 04 24             	sub    (%esp),%eax
  803653:	19 fa                	sbb    %edi,%edx
  803655:	89 d1                	mov    %edx,%ecx
  803657:	89 c6                	mov    %eax,%esi
  803659:	e9 71 ff ff ff       	jmp    8035cf <__umoddi3+0xb3>
  80365e:	66 90                	xchg   %ax,%ax
  803660:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803664:	72 ea                	jb     803650 <__umoddi3+0x134>
  803666:	89 d9                	mov    %ebx,%ecx
  803668:	e9 62 ff ff ff       	jmp    8035cf <__umoddi3+0xb3>
