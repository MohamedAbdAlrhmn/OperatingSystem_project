
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
  800045:	68 60 37 80 00       	push   $0x803760
  80004a:	e8 53 15 00 00       	call   8015a2 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 11 18 00 00       	call   801874 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 a9 18 00 00       	call   801914 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 70 37 80 00       	push   $0x803770
  800079:	e8 07 05 00 00       	call   800585 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 a3 37 80 00       	push   $0x8037a3
  800099:	e8 48 1a 00 00       	call   801ae6 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 ac 37 80 00       	push   $0x8037ac
  8000bc:	e8 25 1a 00 00       	call   801ae6 <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 32 1a 00 00       	call   801b04 <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 54 33 00 00       	call   803436 <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 14 1a 00 00       	call   801b04 <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 71 17 00 00       	call   801874 <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 b8 37 80 00       	push   $0x8037b8
  80010c:	e8 74 04 00 00       	call   800585 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 01 1a 00 00       	call   801b20 <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 f3 19 00 00       	call   801b20 <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 3f 17 00 00       	call   801874 <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 d7 17 00 00       	call   801914 <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 ec 37 80 00       	push   $0x8037ec
  800153:	e8 2d 04 00 00       	call   800585 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 3c 38 80 00       	push   $0x80383c
  800163:	6a 23                	push   $0x23
  800165:	68 72 38 80 00       	push   $0x803872
  80016a:	e8 62 01 00 00       	call   8002d1 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 88 38 80 00       	push   $0x803888
  80017a:	e8 06 04 00 00       	call   800585 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 e8 38 80 00       	push   $0x8038e8
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
  80019b:	e8 b4 19 00 00       	call   801b54 <sys_getenvindex>
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
  800206:	e8 56 17 00 00       	call   801961 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 4c 39 80 00       	push   $0x80394c
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
  800236:	68 74 39 80 00       	push   $0x803974
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
  800267:	68 9c 39 80 00       	push   $0x80399c
  80026c:	e8 14 03 00 00       	call   800585 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 f4 39 80 00       	push   $0x8039f4
  800288:	e8 f8 02 00 00       	call   800585 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 4c 39 80 00       	push   $0x80394c
  800298:	e8 e8 02 00 00       	call   800585 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a0:	e8 d6 16 00 00       	call   80197b <sys_enable_interrupt>

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
  8002b8:	e8 63 18 00 00       	call   801b20 <sys_destroy_env>
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
  8002c9:	e8 b8 18 00 00       	call   801b86 <sys_exit_env>
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
  8002f2:	68 08 3a 80 00       	push   $0x803a08
  8002f7:	e8 89 02 00 00       	call   800585 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ff:	a1 00 50 80 00       	mov    0x805000,%eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	50                   	push   %eax
  80030b:	68 0d 3a 80 00       	push   $0x803a0d
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
  80032f:	68 29 3a 80 00       	push   $0x803a29
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
  80035b:	68 2c 3a 80 00       	push   $0x803a2c
  800360:	6a 26                	push   $0x26
  800362:	68 78 3a 80 00       	push   $0x803a78
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
  80042d:	68 84 3a 80 00       	push   $0x803a84
  800432:	6a 3a                	push   $0x3a
  800434:	68 78 3a 80 00       	push   $0x803a78
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
  80049d:	68 d8 3a 80 00       	push   $0x803ad8
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 78 3a 80 00       	push   $0x803a78
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
  8004f7:	e8 b7 12 00 00       	call   8017b3 <sys_cputs>
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
  80056e:	e8 40 12 00 00       	call   8017b3 <sys_cputs>
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
  8005b8:	e8 a4 13 00 00       	call   801961 <sys_disable_interrupt>
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
  8005d8:	e8 9e 13 00 00       	call   80197b <sys_enable_interrupt>
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
  800622:	e8 c5 2e 00 00       	call   8034ec <__udivdi3>
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
  800672:	e8 85 2f 00 00       	call   8035fc <__umoddi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	05 54 3d 80 00       	add    $0x803d54,%eax
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
  8007cd:	8b 04 85 78 3d 80 00 	mov    0x803d78(,%eax,4),%eax
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
  8008ae:	8b 34 9d c0 3b 80 00 	mov    0x803bc0(,%ebx,4),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 19                	jne    8008d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b9:	53                   	push   %ebx
  8008ba:	68 65 3d 80 00       	push   $0x803d65
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
  8008d3:	68 6e 3d 80 00       	push   $0x803d6e
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
  800900:	be 71 3d 80 00       	mov    $0x803d71,%esi
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
  801326:	68 d0 3e 80 00       	push   $0x803ed0
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
  8013f6:	e8 fc 04 00 00       	call   8018f7 <sys_allocate_chunk>
  8013fb:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013fe:	a1 20 51 80 00       	mov    0x805120,%eax
  801403:	83 ec 0c             	sub    $0xc,%esp
  801406:	50                   	push   %eax
  801407:	e8 71 0b 00 00       	call   801f7d <initialize_MemBlocksList>
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
  801434:	68 f5 3e 80 00       	push   $0x803ef5
  801439:	6a 33                	push   $0x33
  80143b:	68 13 3f 80 00       	push   $0x803f13
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
  8014b3:	68 20 3f 80 00       	push   $0x803f20
  8014b8:	6a 34                	push   $0x34
  8014ba:	68 13 3f 80 00       	push   $0x803f13
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
  801510:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801513:	e8 f7 fd ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  801518:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151c:	75 07                	jne    801525 <malloc+0x18>
  80151e:	b8 00 00 00 00       	mov    $0x0,%eax
  801523:	eb 61                	jmp    801586 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801525:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80152c:	8b 55 08             	mov    0x8(%ebp),%edx
  80152f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801532:	01 d0                	add    %edx,%eax
  801534:	48                   	dec    %eax
  801535:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153b:	ba 00 00 00 00       	mov    $0x0,%edx
  801540:	f7 75 f0             	divl   -0x10(%ebp)
  801543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801546:	29 d0                	sub    %edx,%eax
  801548:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80154b:	e8 75 07 00 00       	call   801cc5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801550:	85 c0                	test   %eax,%eax
  801552:	74 11                	je     801565 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801554:	83 ec 0c             	sub    $0xc,%esp
  801557:	ff 75 e8             	pushl  -0x18(%ebp)
  80155a:	e8 e0 0d 00 00       	call   80233f <alloc_block_FF>
  80155f:	83 c4 10             	add    $0x10,%esp
  801562:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801565:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801569:	74 16                	je     801581 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80156b:	83 ec 0c             	sub    $0xc,%esp
  80156e:	ff 75 f4             	pushl  -0xc(%ebp)
  801571:	e8 3c 0b 00 00       	call   8020b2 <insert_sorted_allocList>
  801576:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157c:	8b 40 08             	mov    0x8(%eax),%eax
  80157f:	eb 05                	jmp    801586 <malloc+0x79>
	}

    return NULL;
  801581:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80158e:	83 ec 04             	sub    $0x4,%esp
  801591:	68 44 3f 80 00       	push   $0x803f44
  801596:	6a 6f                	push   $0x6f
  801598:	68 13 3f 80 00       	push   $0x803f13
  80159d:	e8 2f ed ff ff       	call   8002d1 <_panic>

008015a2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 38             	sub    $0x38,%esp
  8015a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ab:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ae:	e8 5c fd ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  8015b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b7:	75 0a                	jne    8015c3 <smalloc+0x21>
  8015b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015be:	e9 8b 00 00 00       	jmp    80164e <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015c3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d0:	01 d0                	add    %edx,%eax
  8015d2:	48                   	dec    %eax
  8015d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015de:	f7 75 f0             	divl   -0x10(%ebp)
  8015e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e4:	29 d0                	sub    %edx,%eax
  8015e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015e9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015f0:	e8 d0 06 00 00       	call   801cc5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	74 11                	je     80160a <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8015f9:	83 ec 0c             	sub    $0xc,%esp
  8015fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ff:	e8 3b 0d 00 00       	call   80233f <alloc_block_FF>
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80160a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80160e:	74 39                	je     801649 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801613:	8b 40 08             	mov    0x8(%eax),%eax
  801616:	89 c2                	mov    %eax,%edx
  801618:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80161c:	52                   	push   %edx
  80161d:	50                   	push   %eax
  80161e:	ff 75 0c             	pushl  0xc(%ebp)
  801621:	ff 75 08             	pushl  0x8(%ebp)
  801624:	e8 21 04 00 00       	call   801a4a <sys_createSharedObject>
  801629:	83 c4 10             	add    $0x10,%esp
  80162c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80162f:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801633:	74 14                	je     801649 <smalloc+0xa7>
  801635:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801639:	74 0e                	je     801649 <smalloc+0xa7>
  80163b:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80163f:	74 08                	je     801649 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801644:	8b 40 08             	mov    0x8(%eax),%eax
  801647:	eb 05                	jmp    80164e <smalloc+0xac>
	}
	return NULL;
  801649:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801656:	e8 b4 fc ff ff       	call   80130f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80165b:	83 ec 08             	sub    $0x8,%esp
  80165e:	ff 75 0c             	pushl  0xc(%ebp)
  801661:	ff 75 08             	pushl  0x8(%ebp)
  801664:	e8 0b 04 00 00       	call   801a74 <sys_getSizeOfSharedObject>
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80166f:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801673:	74 76                	je     8016eb <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801675:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80167c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80167f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801682:	01 d0                	add    %edx,%eax
  801684:	48                   	dec    %eax
  801685:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801688:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80168b:	ba 00 00 00 00       	mov    $0x0,%edx
  801690:	f7 75 ec             	divl   -0x14(%ebp)
  801693:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801696:	29 d0                	sub    %edx,%eax
  801698:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80169b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016a2:	e8 1e 06 00 00       	call   801cc5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016a7:	85 c0                	test   %eax,%eax
  8016a9:	74 11                	je     8016bc <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8016ab:	83 ec 0c             	sub    $0xc,%esp
  8016ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016b1:	e8 89 0c 00 00       	call   80233f <alloc_block_FF>
  8016b6:	83 c4 10             	add    $0x10,%esp
  8016b9:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8016bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016c0:	74 29                	je     8016eb <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8016c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c5:	8b 40 08             	mov    0x8(%eax),%eax
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	50                   	push   %eax
  8016cc:	ff 75 0c             	pushl  0xc(%ebp)
  8016cf:	ff 75 08             	pushl  0x8(%ebp)
  8016d2:	e8 ba 03 00 00       	call   801a91 <sys_getSharedObject>
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8016dd:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8016e1:	74 08                	je     8016eb <sget+0x9b>
				return (void *)mem_block->sva;
  8016e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e6:	8b 40 08             	mov    0x8(%eax),%eax
  8016e9:	eb 05                	jmp    8016f0 <sget+0xa0>
		}
	}
	return (void *)NULL;
  8016eb:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016f8:	e8 12 fc ff ff       	call   80130f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016fd:	83 ec 04             	sub    $0x4,%esp
  801700:	68 68 3f 80 00       	push   $0x803f68
  801705:	68 f1 00 00 00       	push   $0xf1
  80170a:	68 13 3f 80 00       	push   $0x803f13
  80170f:	e8 bd eb ff ff       	call   8002d1 <_panic>

00801714 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80171a:	83 ec 04             	sub    $0x4,%esp
  80171d:	68 90 3f 80 00       	push   $0x803f90
  801722:	68 05 01 00 00       	push   $0x105
  801727:	68 13 3f 80 00       	push   $0x803f13
  80172c:	e8 a0 eb ff ff       	call   8002d1 <_panic>

00801731 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801731:	55                   	push   %ebp
  801732:	89 e5                	mov    %esp,%ebp
  801734:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801737:	83 ec 04             	sub    $0x4,%esp
  80173a:	68 b4 3f 80 00       	push   $0x803fb4
  80173f:	68 10 01 00 00       	push   $0x110
  801744:	68 13 3f 80 00       	push   $0x803f13
  801749:	e8 83 eb ff ff       	call   8002d1 <_panic>

0080174e <shrink>:

}
void shrink(uint32 newSize)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	68 b4 3f 80 00       	push   $0x803fb4
  80175c:	68 15 01 00 00       	push   $0x115
  801761:	68 13 3f 80 00       	push   $0x803f13
  801766:	e8 66 eb ff ff       	call   8002d1 <_panic>

0080176b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801771:	83 ec 04             	sub    $0x4,%esp
  801774:	68 b4 3f 80 00       	push   $0x803fb4
  801779:	68 1a 01 00 00       	push   $0x11a
  80177e:	68 13 3f 80 00       	push   $0x803f13
  801783:	e8 49 eb ff ff       	call   8002d1 <_panic>

00801788 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	57                   	push   %edi
  80178c:	56                   	push   %esi
  80178d:	53                   	push   %ebx
  80178e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8b 55 0c             	mov    0xc(%ebp),%edx
  801797:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80179a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80179d:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017a0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017a3:	cd 30                	int    $0x30
  8017a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017ab:	83 c4 10             	add    $0x10,%esp
  8017ae:	5b                   	pop    %ebx
  8017af:	5e                   	pop    %esi
  8017b0:	5f                   	pop    %edi
  8017b1:	5d                   	pop    %ebp
  8017b2:	c3                   	ret    

008017b3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 04             	sub    $0x4,%esp
  8017b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017bf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	52                   	push   %edx
  8017cb:	ff 75 0c             	pushl  0xc(%ebp)
  8017ce:	50                   	push   %eax
  8017cf:	6a 00                	push   $0x0
  8017d1:	e8 b2 ff ff ff       	call   801788 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	90                   	nop
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_cgetc>:

int
sys_cgetc(void)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 01                	push   $0x1
  8017eb:	e8 98 ff ff ff       	call   801788 <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	52                   	push   %edx
  801805:	50                   	push   %eax
  801806:	6a 05                	push   $0x5
  801808:	e8 7b ff ff ff       	call   801788 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	56                   	push   %esi
  801816:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801817:	8b 75 18             	mov    0x18(%ebp),%esi
  80181a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80181d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801820:	8b 55 0c             	mov    0xc(%ebp),%edx
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	56                   	push   %esi
  801827:	53                   	push   %ebx
  801828:	51                   	push   %ecx
  801829:	52                   	push   %edx
  80182a:	50                   	push   %eax
  80182b:	6a 06                	push   $0x6
  80182d:	e8 56 ff ff ff       	call   801788 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801838:	5b                   	pop    %ebx
  801839:	5e                   	pop    %esi
  80183a:	5d                   	pop    %ebp
  80183b:	c3                   	ret    

0080183c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80183f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	52                   	push   %edx
  80184c:	50                   	push   %eax
  80184d:	6a 07                	push   $0x7
  80184f:	e8 34 ff ff ff       	call   801788 <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	ff 75 0c             	pushl  0xc(%ebp)
  801865:	ff 75 08             	pushl  0x8(%ebp)
  801868:	6a 08                	push   $0x8
  80186a:	e8 19 ff ff ff       	call   801788 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 09                	push   $0x9
  801883:	e8 00 ff ff ff       	call   801788 <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 0a                	push   $0xa
  80189c:	e8 e7 fe ff ff       	call   801788 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 0b                	push   $0xb
  8018b5:	e8 ce fe ff ff       	call   801788 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	ff 75 0c             	pushl  0xc(%ebp)
  8018cb:	ff 75 08             	pushl  0x8(%ebp)
  8018ce:	6a 0f                	push   $0xf
  8018d0:	e8 b3 fe ff ff       	call   801788 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
	return;
  8018d8:	90                   	nop
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	ff 75 0c             	pushl  0xc(%ebp)
  8018e7:	ff 75 08             	pushl  0x8(%ebp)
  8018ea:	6a 10                	push   $0x10
  8018ec:	e8 97 fe ff ff       	call   801788 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f4:	90                   	nop
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	ff 75 10             	pushl  0x10(%ebp)
  801901:	ff 75 0c             	pushl  0xc(%ebp)
  801904:	ff 75 08             	pushl  0x8(%ebp)
  801907:	6a 11                	push   $0x11
  801909:	e8 7a fe ff ff       	call   801788 <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
	return ;
  801911:	90                   	nop
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 0c                	push   $0xc
  801923:	e8 60 fe ff ff       	call   801788 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	ff 75 08             	pushl  0x8(%ebp)
  80193b:	6a 0d                	push   $0xd
  80193d:	e8 46 fe ff ff       	call   801788 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 0e                	push   $0xe
  801956:	e8 2d fe ff ff       	call   801788 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	90                   	nop
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 13                	push   $0x13
  801970:	e8 13 fe ff ff       	call   801788 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 14                	push   $0x14
  80198a:	e8 f9 fd ff ff       	call   801788 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	90                   	nop
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_cputc>:


void
sys_cputc(const char c)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 04             	sub    $0x4,%esp
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	50                   	push   %eax
  8019ae:	6a 15                	push   $0x15
  8019b0:	e8 d3 fd ff ff       	call   801788 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	90                   	nop
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 16                	push   $0x16
  8019ca:	e8 b9 fd ff ff       	call   801788 <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	90                   	nop
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	ff 75 0c             	pushl  0xc(%ebp)
  8019e4:	50                   	push   %eax
  8019e5:	6a 17                	push   $0x17
  8019e7:	e8 9c fd ff ff       	call   801788 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	52                   	push   %edx
  801a01:	50                   	push   %eax
  801a02:	6a 1a                	push   $0x1a
  801a04:	e8 7f fd ff ff       	call   801788 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	52                   	push   %edx
  801a1e:	50                   	push   %eax
  801a1f:	6a 18                	push   $0x18
  801a21:	e8 62 fd ff ff       	call   801788 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	90                   	nop
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	52                   	push   %edx
  801a3c:	50                   	push   %eax
  801a3d:	6a 19                	push   $0x19
  801a3f:	e8 44 fd ff ff       	call   801788 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	90                   	nop
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	8b 45 10             	mov    0x10(%ebp),%eax
  801a53:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a56:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a59:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	6a 00                	push   $0x0
  801a62:	51                   	push   %ecx
  801a63:	52                   	push   %edx
  801a64:	ff 75 0c             	pushl  0xc(%ebp)
  801a67:	50                   	push   %eax
  801a68:	6a 1b                	push   $0x1b
  801a6a:	e8 19 fd ff ff       	call   801788 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	52                   	push   %edx
  801a84:	50                   	push   %eax
  801a85:	6a 1c                	push   $0x1c
  801a87:	e8 fc fc ff ff       	call   801788 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a94:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	51                   	push   %ecx
  801aa2:	52                   	push   %edx
  801aa3:	50                   	push   %eax
  801aa4:	6a 1d                	push   $0x1d
  801aa6:	e8 dd fc ff ff       	call   801788 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	52                   	push   %edx
  801ac0:	50                   	push   %eax
  801ac1:	6a 1e                	push   $0x1e
  801ac3:	e8 c0 fc ff ff       	call   801788 <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 1f                	push   $0x1f
  801adc:	e8 a7 fc ff ff       	call   801788 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	6a 00                	push   $0x0
  801aee:	ff 75 14             	pushl  0x14(%ebp)
  801af1:	ff 75 10             	pushl  0x10(%ebp)
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	50                   	push   %eax
  801af8:	6a 20                	push   $0x20
  801afa:	e8 89 fc ff ff       	call   801788 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	50                   	push   %eax
  801b13:	6a 21                	push   $0x21
  801b15:	e8 6e fc ff ff       	call   801788 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	90                   	nop
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	50                   	push   %eax
  801b2f:	6a 22                	push   $0x22
  801b31:	e8 52 fc ff ff       	call   801788 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 02                	push   $0x2
  801b4a:	e8 39 fc ff ff       	call   801788 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 03                	push   $0x3
  801b63:	e8 20 fc ff ff       	call   801788 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 04                	push   $0x4
  801b7c:	e8 07 fc ff ff       	call   801788 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_exit_env>:


void sys_exit_env(void)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 23                	push   $0x23
  801b95:	e8 ee fb ff ff       	call   801788 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	90                   	nop
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ba6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ba9:	8d 50 04             	lea    0x4(%eax),%edx
  801bac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	52                   	push   %edx
  801bb6:	50                   	push   %eax
  801bb7:	6a 24                	push   $0x24
  801bb9:	e8 ca fb ff ff       	call   801788 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
	return result;
  801bc1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bc7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bca:	89 01                	mov    %eax,(%ecx)
  801bcc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	c9                   	leave  
  801bd3:	c2 04 00             	ret    $0x4

00801bd6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	ff 75 10             	pushl  0x10(%ebp)
  801be0:	ff 75 0c             	pushl  0xc(%ebp)
  801be3:	ff 75 08             	pushl  0x8(%ebp)
  801be6:	6a 12                	push   $0x12
  801be8:	e8 9b fb ff ff       	call   801788 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf0:	90                   	nop
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 25                	push   $0x25
  801c02:	e8 81 fb ff ff       	call   801788 <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 04             	sub    $0x4,%esp
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c18:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	50                   	push   %eax
  801c25:	6a 26                	push   $0x26
  801c27:	e8 5c fb ff ff       	call   801788 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2f:	90                   	nop
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <rsttst>:
void rsttst()
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 28                	push   $0x28
  801c41:	e8 42 fb ff ff       	call   801788 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
	return ;
  801c49:	90                   	nop
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	83 ec 04             	sub    $0x4,%esp
  801c52:	8b 45 14             	mov    0x14(%ebp),%eax
  801c55:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c58:	8b 55 18             	mov    0x18(%ebp),%edx
  801c5b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c5f:	52                   	push   %edx
  801c60:	50                   	push   %eax
  801c61:	ff 75 10             	pushl  0x10(%ebp)
  801c64:	ff 75 0c             	pushl  0xc(%ebp)
  801c67:	ff 75 08             	pushl  0x8(%ebp)
  801c6a:	6a 27                	push   $0x27
  801c6c:	e8 17 fb ff ff       	call   801788 <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
	return ;
  801c74:	90                   	nop
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <chktst>:
void chktst(uint32 n)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	ff 75 08             	pushl  0x8(%ebp)
  801c85:	6a 29                	push   $0x29
  801c87:	e8 fc fa ff ff       	call   801788 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8f:	90                   	nop
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <inctst>:

void inctst()
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 2a                	push   $0x2a
  801ca1:	e8 e2 fa ff ff       	call   801788 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca9:	90                   	nop
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <gettst>:
uint32 gettst()
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 2b                	push   $0x2b
  801cbb:	e8 c8 fa ff ff       	call   801788 <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 2c                	push   $0x2c
  801cd7:	e8 ac fa ff ff       	call   801788 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
  801cdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ce2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ce6:	75 07                	jne    801cef <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ce8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ced:	eb 05                	jmp    801cf4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 2c                	push   $0x2c
  801d08:	e8 7b fa ff ff       	call   801788 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
  801d10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d13:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d17:	75 07                	jne    801d20 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d19:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1e:	eb 05                	jmp    801d25 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
  801d2a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 2c                	push   $0x2c
  801d39:	e8 4a fa ff ff       	call   801788 <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
  801d41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d44:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d48:	75 07                	jne    801d51 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4f:	eb 05                	jmp    801d56 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
  801d5b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 2c                	push   $0x2c
  801d6a:	e8 19 fa ff ff       	call   801788 <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
  801d72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d75:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d79:	75 07                	jne    801d82 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d7b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d80:	eb 05                	jmp    801d87 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	ff 75 08             	pushl  0x8(%ebp)
  801d97:	6a 2d                	push   $0x2d
  801d99:	e8 ea f9 ff ff       	call   801788 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801da1:	90                   	nop
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801da8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	6a 00                	push   $0x0
  801db6:	53                   	push   %ebx
  801db7:	51                   	push   %ecx
  801db8:	52                   	push   %edx
  801db9:	50                   	push   %eax
  801dba:	6a 2e                	push   $0x2e
  801dbc:	e8 c7 f9 ff ff       	call   801788 <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
}
  801dc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	52                   	push   %edx
  801dd9:	50                   	push   %eax
  801dda:	6a 2f                	push   $0x2f
  801ddc:	e8 a7 f9 ff ff       	call   801788 <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dec:	83 ec 0c             	sub    $0xc,%esp
  801def:	68 c4 3f 80 00       	push   $0x803fc4
  801df4:	e8 8c e7 ff ff       	call   800585 <cprintf>
  801df9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801dfc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e03:	83 ec 0c             	sub    $0xc,%esp
  801e06:	68 f0 3f 80 00       	push   $0x803ff0
  801e0b:	e8 75 e7 ff ff       	call   800585 <cprintf>
  801e10:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e13:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e17:	a1 38 51 80 00       	mov    0x805138,%eax
  801e1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e1f:	eb 56                	jmp    801e77 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e25:	74 1c                	je     801e43 <print_mem_block_lists+0x5d>
  801e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2a:	8b 50 08             	mov    0x8(%eax),%edx
  801e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e30:	8b 48 08             	mov    0x8(%eax),%ecx
  801e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e36:	8b 40 0c             	mov    0xc(%eax),%eax
  801e39:	01 c8                	add    %ecx,%eax
  801e3b:	39 c2                	cmp    %eax,%edx
  801e3d:	73 04                	jae    801e43 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e3f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	8b 50 08             	mov    0x8(%eax),%edx
  801e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4f:	01 c2                	add    %eax,%edx
  801e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e54:	8b 40 08             	mov    0x8(%eax),%eax
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	52                   	push   %edx
  801e5b:	50                   	push   %eax
  801e5c:	68 05 40 80 00       	push   $0x804005
  801e61:	e8 1f e7 ff ff       	call   800585 <cprintf>
  801e66:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e6f:	a1 40 51 80 00       	mov    0x805140,%eax
  801e74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e7b:	74 07                	je     801e84 <print_mem_block_lists+0x9e>
  801e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e80:	8b 00                	mov    (%eax),%eax
  801e82:	eb 05                	jmp    801e89 <print_mem_block_lists+0xa3>
  801e84:	b8 00 00 00 00       	mov    $0x0,%eax
  801e89:	a3 40 51 80 00       	mov    %eax,0x805140
  801e8e:	a1 40 51 80 00       	mov    0x805140,%eax
  801e93:	85 c0                	test   %eax,%eax
  801e95:	75 8a                	jne    801e21 <print_mem_block_lists+0x3b>
  801e97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e9b:	75 84                	jne    801e21 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e9d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ea1:	75 10                	jne    801eb3 <print_mem_block_lists+0xcd>
  801ea3:	83 ec 0c             	sub    $0xc,%esp
  801ea6:	68 14 40 80 00       	push   $0x804014
  801eab:	e8 d5 e6 ff ff       	call   800585 <cprintf>
  801eb0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801eb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801eba:	83 ec 0c             	sub    $0xc,%esp
  801ebd:	68 38 40 80 00       	push   $0x804038
  801ec2:	e8 be e6 ff ff       	call   800585 <cprintf>
  801ec7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801eca:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ece:	a1 40 50 80 00       	mov    0x805040,%eax
  801ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed6:	eb 56                	jmp    801f2e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ed8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801edc:	74 1c                	je     801efa <print_mem_block_lists+0x114>
  801ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee1:	8b 50 08             	mov    0x8(%eax),%edx
  801ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee7:	8b 48 08             	mov    0x8(%eax),%ecx
  801eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eed:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef0:	01 c8                	add    %ecx,%eax
  801ef2:	39 c2                	cmp    %eax,%edx
  801ef4:	73 04                	jae    801efa <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ef6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efd:	8b 50 08             	mov    0x8(%eax),%edx
  801f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f03:	8b 40 0c             	mov    0xc(%eax),%eax
  801f06:	01 c2                	add    %eax,%edx
  801f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0b:	8b 40 08             	mov    0x8(%eax),%eax
  801f0e:	83 ec 04             	sub    $0x4,%esp
  801f11:	52                   	push   %edx
  801f12:	50                   	push   %eax
  801f13:	68 05 40 80 00       	push   $0x804005
  801f18:	e8 68 e6 ff ff       	call   800585 <cprintf>
  801f1d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f26:	a1 48 50 80 00       	mov    0x805048,%eax
  801f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f32:	74 07                	je     801f3b <print_mem_block_lists+0x155>
  801f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f37:	8b 00                	mov    (%eax),%eax
  801f39:	eb 05                	jmp    801f40 <print_mem_block_lists+0x15a>
  801f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f40:	a3 48 50 80 00       	mov    %eax,0x805048
  801f45:	a1 48 50 80 00       	mov    0x805048,%eax
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	75 8a                	jne    801ed8 <print_mem_block_lists+0xf2>
  801f4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f52:	75 84                	jne    801ed8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f54:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f58:	75 10                	jne    801f6a <print_mem_block_lists+0x184>
  801f5a:	83 ec 0c             	sub    $0xc,%esp
  801f5d:	68 50 40 80 00       	push   $0x804050
  801f62:	e8 1e e6 ff ff       	call   800585 <cprintf>
  801f67:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f6a:	83 ec 0c             	sub    $0xc,%esp
  801f6d:	68 c4 3f 80 00       	push   $0x803fc4
  801f72:	e8 0e e6 ff ff       	call   800585 <cprintf>
  801f77:	83 c4 10             	add    $0x10,%esp

}
  801f7a:	90                   	nop
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f83:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f8a:	00 00 00 
  801f8d:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f94:	00 00 00 
  801f97:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f9e:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fa1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fa8:	e9 9e 00 00 00       	jmp    80204b <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801fad:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb5:	c1 e2 04             	shl    $0x4,%edx
  801fb8:	01 d0                	add    %edx,%eax
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	75 14                	jne    801fd2 <initialize_MemBlocksList+0x55>
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	68 78 40 80 00       	push   $0x804078
  801fc6:	6a 46                	push   $0x46
  801fc8:	68 9b 40 80 00       	push   $0x80409b
  801fcd:	e8 ff e2 ff ff       	call   8002d1 <_panic>
  801fd2:	a1 50 50 80 00       	mov    0x805050,%eax
  801fd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fda:	c1 e2 04             	shl    $0x4,%edx
  801fdd:	01 d0                	add    %edx,%eax
  801fdf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fe5:	89 10                	mov    %edx,(%eax)
  801fe7:	8b 00                	mov    (%eax),%eax
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	74 18                	je     802005 <initialize_MemBlocksList+0x88>
  801fed:	a1 48 51 80 00       	mov    0x805148,%eax
  801ff2:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801ff8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ffb:	c1 e1 04             	shl    $0x4,%ecx
  801ffe:	01 ca                	add    %ecx,%edx
  802000:	89 50 04             	mov    %edx,0x4(%eax)
  802003:	eb 12                	jmp    802017 <initialize_MemBlocksList+0x9a>
  802005:	a1 50 50 80 00       	mov    0x805050,%eax
  80200a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200d:	c1 e2 04             	shl    $0x4,%edx
  802010:	01 d0                	add    %edx,%eax
  802012:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802017:	a1 50 50 80 00       	mov    0x805050,%eax
  80201c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201f:	c1 e2 04             	shl    $0x4,%edx
  802022:	01 d0                	add    %edx,%eax
  802024:	a3 48 51 80 00       	mov    %eax,0x805148
  802029:	a1 50 50 80 00       	mov    0x805050,%eax
  80202e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802031:	c1 e2 04             	shl    $0x4,%edx
  802034:	01 d0                	add    %edx,%eax
  802036:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80203d:	a1 54 51 80 00       	mov    0x805154,%eax
  802042:	40                   	inc    %eax
  802043:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802048:	ff 45 f4             	incl   -0xc(%ebp)
  80204b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802051:	0f 82 56 ff ff ff    	jb     801fad <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802057:	90                   	nop
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	8b 00                	mov    (%eax),%eax
  802065:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802068:	eb 19                	jmp    802083 <find_block+0x29>
	{
		if(va==point->sva)
  80206a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206d:	8b 40 08             	mov    0x8(%eax),%eax
  802070:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802073:	75 05                	jne    80207a <find_block+0x20>
		   return point;
  802075:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802078:	eb 36                	jmp    8020b0 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80207a:	8b 45 08             	mov    0x8(%ebp),%eax
  80207d:	8b 40 08             	mov    0x8(%eax),%eax
  802080:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802083:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802087:	74 07                	je     802090 <find_block+0x36>
  802089:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80208c:	8b 00                	mov    (%eax),%eax
  80208e:	eb 05                	jmp    802095 <find_block+0x3b>
  802090:	b8 00 00 00 00       	mov    $0x0,%eax
  802095:	8b 55 08             	mov    0x8(%ebp),%edx
  802098:	89 42 08             	mov    %eax,0x8(%edx)
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	8b 40 08             	mov    0x8(%eax),%eax
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	75 c5                	jne    80206a <find_block+0x10>
  8020a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020a9:	75 bf                	jne    80206a <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020b8:	a1 40 50 80 00       	mov    0x805040,%eax
  8020bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020c0:	a1 44 50 80 00       	mov    0x805044,%eax
  8020c5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020ce:	74 24                	je     8020f4 <insert_sorted_allocList+0x42>
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	8b 50 08             	mov    0x8(%eax),%edx
  8020d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d9:	8b 40 08             	mov    0x8(%eax),%eax
  8020dc:	39 c2                	cmp    %eax,%edx
  8020de:	76 14                	jbe    8020f4 <insert_sorted_allocList+0x42>
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	8b 50 08             	mov    0x8(%eax),%edx
  8020e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e9:	8b 40 08             	mov    0x8(%eax),%eax
  8020ec:	39 c2                	cmp    %eax,%edx
  8020ee:	0f 82 60 01 00 00    	jb     802254 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020f8:	75 65                	jne    80215f <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020fe:	75 14                	jne    802114 <insert_sorted_allocList+0x62>
  802100:	83 ec 04             	sub    $0x4,%esp
  802103:	68 78 40 80 00       	push   $0x804078
  802108:	6a 6b                	push   $0x6b
  80210a:	68 9b 40 80 00       	push   $0x80409b
  80210f:	e8 bd e1 ff ff       	call   8002d1 <_panic>
  802114:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	89 10                	mov    %edx,(%eax)
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	8b 00                	mov    (%eax),%eax
  802124:	85 c0                	test   %eax,%eax
  802126:	74 0d                	je     802135 <insert_sorted_allocList+0x83>
  802128:	a1 40 50 80 00       	mov    0x805040,%eax
  80212d:	8b 55 08             	mov    0x8(%ebp),%edx
  802130:	89 50 04             	mov    %edx,0x4(%eax)
  802133:	eb 08                	jmp    80213d <insert_sorted_allocList+0x8b>
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	a3 44 50 80 00       	mov    %eax,0x805044
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	a3 40 50 80 00       	mov    %eax,0x805040
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80214f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802154:	40                   	inc    %eax
  802155:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80215a:	e9 dc 01 00 00       	jmp    80233b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8b 50 08             	mov    0x8(%eax),%edx
  802165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802168:	8b 40 08             	mov    0x8(%eax),%eax
  80216b:	39 c2                	cmp    %eax,%edx
  80216d:	77 6c                	ja     8021db <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80216f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802173:	74 06                	je     80217b <insert_sorted_allocList+0xc9>
  802175:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802179:	75 14                	jne    80218f <insert_sorted_allocList+0xdd>
  80217b:	83 ec 04             	sub    $0x4,%esp
  80217e:	68 b4 40 80 00       	push   $0x8040b4
  802183:	6a 6f                	push   $0x6f
  802185:	68 9b 40 80 00       	push   $0x80409b
  80218a:	e8 42 e1 ff ff       	call   8002d1 <_panic>
  80218f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802192:	8b 50 04             	mov    0x4(%eax),%edx
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	89 50 04             	mov    %edx,0x4(%eax)
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021a1:	89 10                	mov    %edx,(%eax)
  8021a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a6:	8b 40 04             	mov    0x4(%eax),%eax
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	74 0d                	je     8021ba <insert_sorted_allocList+0x108>
  8021ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b0:	8b 40 04             	mov    0x4(%eax),%eax
  8021b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b6:	89 10                	mov    %edx,(%eax)
  8021b8:	eb 08                	jmp    8021c2 <insert_sorted_allocList+0x110>
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	a3 40 50 80 00       	mov    %eax,0x805040
  8021c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c8:	89 50 04             	mov    %edx,0x4(%eax)
  8021cb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021d0:	40                   	inc    %eax
  8021d1:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021d6:	e9 60 01 00 00       	jmp    80233b <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	8b 50 08             	mov    0x8(%eax),%edx
  8021e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e4:	8b 40 08             	mov    0x8(%eax),%eax
  8021e7:	39 c2                	cmp    %eax,%edx
  8021e9:	0f 82 4c 01 00 00    	jb     80233b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f3:	75 14                	jne    802209 <insert_sorted_allocList+0x157>
  8021f5:	83 ec 04             	sub    $0x4,%esp
  8021f8:	68 ec 40 80 00       	push   $0x8040ec
  8021fd:	6a 73                	push   $0x73
  8021ff:	68 9b 40 80 00       	push   $0x80409b
  802204:	e8 c8 e0 ff ff       	call   8002d1 <_panic>
  802209:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	89 50 04             	mov    %edx,0x4(%eax)
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	8b 40 04             	mov    0x4(%eax),%eax
  80221b:	85 c0                	test   %eax,%eax
  80221d:	74 0c                	je     80222b <insert_sorted_allocList+0x179>
  80221f:	a1 44 50 80 00       	mov    0x805044,%eax
  802224:	8b 55 08             	mov    0x8(%ebp),%edx
  802227:	89 10                	mov    %edx,(%eax)
  802229:	eb 08                	jmp    802233 <insert_sorted_allocList+0x181>
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	a3 40 50 80 00       	mov    %eax,0x805040
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	a3 44 50 80 00       	mov    %eax,0x805044
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802244:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802249:	40                   	inc    %eax
  80224a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80224f:	e9 e7 00 00 00       	jmp    80233b <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802257:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80225a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802261:	a1 40 50 80 00       	mov    0x805040,%eax
  802266:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802269:	e9 9d 00 00 00       	jmp    80230b <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	8b 00                	mov    (%eax),%eax
  802273:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	8b 50 08             	mov    0x8(%eax),%edx
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	8b 40 08             	mov    0x8(%eax),%eax
  802282:	39 c2                	cmp    %eax,%edx
  802284:	76 7d                	jbe    802303 <insert_sorted_allocList+0x251>
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	8b 50 08             	mov    0x8(%eax),%edx
  80228c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80228f:	8b 40 08             	mov    0x8(%eax),%eax
  802292:	39 c2                	cmp    %eax,%edx
  802294:	73 6d                	jae    802303 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802296:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80229a:	74 06                	je     8022a2 <insert_sorted_allocList+0x1f0>
  80229c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a0:	75 14                	jne    8022b6 <insert_sorted_allocList+0x204>
  8022a2:	83 ec 04             	sub    $0x4,%esp
  8022a5:	68 10 41 80 00       	push   $0x804110
  8022aa:	6a 7f                	push   $0x7f
  8022ac:	68 9b 40 80 00       	push   $0x80409b
  8022b1:	e8 1b e0 ff ff       	call   8002d1 <_panic>
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 10                	mov    (%eax),%edx
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	89 10                	mov    %edx,(%eax)
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	8b 00                	mov    (%eax),%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 0b                	je     8022d4 <insert_sorted_allocList+0x222>
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	8b 00                	mov    (%eax),%eax
  8022ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d1:	89 50 04             	mov    %edx,0x4(%eax)
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022da:	89 10                	mov    %edx,(%eax)
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e2:	89 50 04             	mov    %edx,0x4(%eax)
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	8b 00                	mov    (%eax),%eax
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	75 08                	jne    8022f6 <insert_sorted_allocList+0x244>
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	a3 44 50 80 00       	mov    %eax,0x805044
  8022f6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022fb:	40                   	inc    %eax
  8022fc:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802301:	eb 39                	jmp    80233c <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802303:	a1 48 50 80 00       	mov    0x805048,%eax
  802308:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230f:	74 07                	je     802318 <insert_sorted_allocList+0x266>
  802311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802314:	8b 00                	mov    (%eax),%eax
  802316:	eb 05                	jmp    80231d <insert_sorted_allocList+0x26b>
  802318:	b8 00 00 00 00       	mov    $0x0,%eax
  80231d:	a3 48 50 80 00       	mov    %eax,0x805048
  802322:	a1 48 50 80 00       	mov    0x805048,%eax
  802327:	85 c0                	test   %eax,%eax
  802329:	0f 85 3f ff ff ff    	jne    80226e <insert_sorted_allocList+0x1bc>
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802333:	0f 85 35 ff ff ff    	jne    80226e <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802339:	eb 01                	jmp    80233c <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80233b:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80233c:	90                   	nop
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802345:	a1 38 51 80 00       	mov    0x805138,%eax
  80234a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234d:	e9 85 01 00 00       	jmp    8024d7 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802355:	8b 40 0c             	mov    0xc(%eax),%eax
  802358:	3b 45 08             	cmp    0x8(%ebp),%eax
  80235b:	0f 82 6e 01 00 00    	jb     8024cf <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	8b 40 0c             	mov    0xc(%eax),%eax
  802367:	3b 45 08             	cmp    0x8(%ebp),%eax
  80236a:	0f 85 8a 00 00 00    	jne    8023fa <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802370:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802374:	75 17                	jne    80238d <alloc_block_FF+0x4e>
  802376:	83 ec 04             	sub    $0x4,%esp
  802379:	68 44 41 80 00       	push   $0x804144
  80237e:	68 93 00 00 00       	push   $0x93
  802383:	68 9b 40 80 00       	push   $0x80409b
  802388:	e8 44 df ff ff       	call   8002d1 <_panic>
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	85 c0                	test   %eax,%eax
  802394:	74 10                	je     8023a6 <alloc_block_FF+0x67>
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 00                	mov    (%eax),%eax
  80239b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239e:	8b 52 04             	mov    0x4(%edx),%edx
  8023a1:	89 50 04             	mov    %edx,0x4(%eax)
  8023a4:	eb 0b                	jmp    8023b1 <alloc_block_FF+0x72>
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 40 04             	mov    0x4(%eax),%eax
  8023ac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 40 04             	mov    0x4(%eax),%eax
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	74 0f                	je     8023ca <alloc_block_FF+0x8b>
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	8b 40 04             	mov    0x4(%eax),%eax
  8023c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c4:	8b 12                	mov    (%edx),%edx
  8023c6:	89 10                	mov    %edx,(%eax)
  8023c8:	eb 0a                	jmp    8023d4 <alloc_block_FF+0x95>
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 00                	mov    (%eax),%eax
  8023cf:	a3 38 51 80 00       	mov    %eax,0x805138
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e7:	a1 44 51 80 00       	mov    0x805144,%eax
  8023ec:	48                   	dec    %eax
  8023ed:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	e9 10 01 00 00       	jmp    80250a <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802400:	3b 45 08             	cmp    0x8(%ebp),%eax
  802403:	0f 86 c6 00 00 00    	jbe    8024cf <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802409:	a1 48 51 80 00       	mov    0x805148,%eax
  80240e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802414:	8b 50 08             	mov    0x8(%eax),%edx
  802417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241a:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80241d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802420:	8b 55 08             	mov    0x8(%ebp),%edx
  802423:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802426:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80242a:	75 17                	jne    802443 <alloc_block_FF+0x104>
  80242c:	83 ec 04             	sub    $0x4,%esp
  80242f:	68 44 41 80 00       	push   $0x804144
  802434:	68 9b 00 00 00       	push   $0x9b
  802439:	68 9b 40 80 00       	push   $0x80409b
  80243e:	e8 8e de ff ff       	call   8002d1 <_panic>
  802443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802446:	8b 00                	mov    (%eax),%eax
  802448:	85 c0                	test   %eax,%eax
  80244a:	74 10                	je     80245c <alloc_block_FF+0x11d>
  80244c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244f:	8b 00                	mov    (%eax),%eax
  802451:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802454:	8b 52 04             	mov    0x4(%edx),%edx
  802457:	89 50 04             	mov    %edx,0x4(%eax)
  80245a:	eb 0b                	jmp    802467 <alloc_block_FF+0x128>
  80245c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245f:	8b 40 04             	mov    0x4(%eax),%eax
  802462:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246a:	8b 40 04             	mov    0x4(%eax),%eax
  80246d:	85 c0                	test   %eax,%eax
  80246f:	74 0f                	je     802480 <alloc_block_FF+0x141>
  802471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802474:	8b 40 04             	mov    0x4(%eax),%eax
  802477:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80247a:	8b 12                	mov    (%edx),%edx
  80247c:	89 10                	mov    %edx,(%eax)
  80247e:	eb 0a                	jmp    80248a <alloc_block_FF+0x14b>
  802480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802483:	8b 00                	mov    (%eax),%eax
  802485:	a3 48 51 80 00       	mov    %eax,0x805148
  80248a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802496:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80249d:	a1 54 51 80 00       	mov    0x805154,%eax
  8024a2:	48                   	dec    %eax
  8024a3:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 50 08             	mov    0x8(%eax),%edx
  8024ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b1:	01 c2                	add    %eax,%edx
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8024c2:	89 c2                	mov    %eax,%edx
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cd:	eb 3b                	jmp    80250a <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8024d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024db:	74 07                	je     8024e4 <alloc_block_FF+0x1a5>
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	8b 00                	mov    (%eax),%eax
  8024e2:	eb 05                	jmp    8024e9 <alloc_block_FF+0x1aa>
  8024e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e9:	a3 40 51 80 00       	mov    %eax,0x805140
  8024ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8024f3:	85 c0                	test   %eax,%eax
  8024f5:	0f 85 57 fe ff ff    	jne    802352 <alloc_block_FF+0x13>
  8024fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ff:	0f 85 4d fe ff ff    	jne    802352 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802505:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802512:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802519:	a1 38 51 80 00       	mov    0x805138,%eax
  80251e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802521:	e9 df 00 00 00       	jmp    802605 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 40 0c             	mov    0xc(%eax),%eax
  80252c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252f:	0f 82 c8 00 00 00    	jb     8025fd <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	8b 40 0c             	mov    0xc(%eax),%eax
  80253b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253e:	0f 85 8a 00 00 00    	jne    8025ce <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802544:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802548:	75 17                	jne    802561 <alloc_block_BF+0x55>
  80254a:	83 ec 04             	sub    $0x4,%esp
  80254d:	68 44 41 80 00       	push   $0x804144
  802552:	68 b7 00 00 00       	push   $0xb7
  802557:	68 9b 40 80 00       	push   $0x80409b
  80255c:	e8 70 dd ff ff       	call   8002d1 <_panic>
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 00                	mov    (%eax),%eax
  802566:	85 c0                	test   %eax,%eax
  802568:	74 10                	je     80257a <alloc_block_BF+0x6e>
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 00                	mov    (%eax),%eax
  80256f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802572:	8b 52 04             	mov    0x4(%edx),%edx
  802575:	89 50 04             	mov    %edx,0x4(%eax)
  802578:	eb 0b                	jmp    802585 <alloc_block_BF+0x79>
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 40 04             	mov    0x4(%eax),%eax
  802580:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 40 04             	mov    0x4(%eax),%eax
  80258b:	85 c0                	test   %eax,%eax
  80258d:	74 0f                	je     80259e <alloc_block_BF+0x92>
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 40 04             	mov    0x4(%eax),%eax
  802595:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802598:	8b 12                	mov    (%edx),%edx
  80259a:	89 10                	mov    %edx,(%eax)
  80259c:	eb 0a                	jmp    8025a8 <alloc_block_BF+0x9c>
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 00                	mov    (%eax),%eax
  8025a3:	a3 38 51 80 00       	mov    %eax,0x805138
  8025a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8025c0:	48                   	dec    %eax
  8025c1:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	e9 4d 01 00 00       	jmp    80271b <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d7:	76 24                	jbe    8025fd <alloc_block_BF+0xf1>
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025e2:	73 19                	jae    8025fd <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025e4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 40 08             	mov    0x8(%eax),%eax
  8025fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025fd:	a1 40 51 80 00       	mov    0x805140,%eax
  802602:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802605:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802609:	74 07                	je     802612 <alloc_block_BF+0x106>
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	8b 00                	mov    (%eax),%eax
  802610:	eb 05                	jmp    802617 <alloc_block_BF+0x10b>
  802612:	b8 00 00 00 00       	mov    $0x0,%eax
  802617:	a3 40 51 80 00       	mov    %eax,0x805140
  80261c:	a1 40 51 80 00       	mov    0x805140,%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	0f 85 fd fe ff ff    	jne    802526 <alloc_block_BF+0x1a>
  802629:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262d:	0f 85 f3 fe ff ff    	jne    802526 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802633:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802637:	0f 84 d9 00 00 00    	je     802716 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80263d:	a1 48 51 80 00       	mov    0x805148,%eax
  802642:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802648:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80264b:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80264e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802651:	8b 55 08             	mov    0x8(%ebp),%edx
  802654:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802657:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80265b:	75 17                	jne    802674 <alloc_block_BF+0x168>
  80265d:	83 ec 04             	sub    $0x4,%esp
  802660:	68 44 41 80 00       	push   $0x804144
  802665:	68 c7 00 00 00       	push   $0xc7
  80266a:	68 9b 40 80 00       	push   $0x80409b
  80266f:	e8 5d dc ff ff       	call   8002d1 <_panic>
  802674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	85 c0                	test   %eax,%eax
  80267b:	74 10                	je     80268d <alloc_block_BF+0x181>
  80267d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802685:	8b 52 04             	mov    0x4(%edx),%edx
  802688:	89 50 04             	mov    %edx,0x4(%eax)
  80268b:	eb 0b                	jmp    802698 <alloc_block_BF+0x18c>
  80268d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802690:	8b 40 04             	mov    0x4(%eax),%eax
  802693:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269b:	8b 40 04             	mov    0x4(%eax),%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	74 0f                	je     8026b1 <alloc_block_BF+0x1a5>
  8026a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a5:	8b 40 04             	mov    0x4(%eax),%eax
  8026a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ab:	8b 12                	mov    (%edx),%edx
  8026ad:	89 10                	mov    %edx,(%eax)
  8026af:	eb 0a                	jmp    8026bb <alloc_block_BF+0x1af>
  8026b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b4:	8b 00                	mov    (%eax),%eax
  8026b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8026bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8026d3:	48                   	dec    %eax
  8026d4:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026d9:	83 ec 08             	sub    $0x8,%esp
  8026dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8026df:	68 38 51 80 00       	push   $0x805138
  8026e4:	e8 71 f9 ff ff       	call   80205a <find_block>
  8026e9:	83 c4 10             	add    $0x10,%esp
  8026ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f2:	8b 50 08             	mov    0x8(%eax),%edx
  8026f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f8:	01 c2                	add    %eax,%edx
  8026fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fd:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802703:	8b 40 0c             	mov    0xc(%eax),%eax
  802706:	2b 45 08             	sub    0x8(%ebp),%eax
  802709:	89 c2                	mov    %eax,%edx
  80270b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270e:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802714:	eb 05                	jmp    80271b <alloc_block_BF+0x20f>
	}
	return NULL;
  802716:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80271b:	c9                   	leave  
  80271c:	c3                   	ret    

0080271d <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802723:	a1 28 50 80 00       	mov    0x805028,%eax
  802728:	85 c0                	test   %eax,%eax
  80272a:	0f 85 de 01 00 00    	jne    80290e <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802730:	a1 38 51 80 00       	mov    0x805138,%eax
  802735:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802738:	e9 9e 01 00 00       	jmp    8028db <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 40 0c             	mov    0xc(%eax),%eax
  802743:	3b 45 08             	cmp    0x8(%ebp),%eax
  802746:	0f 82 87 01 00 00    	jb     8028d3 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 40 0c             	mov    0xc(%eax),%eax
  802752:	3b 45 08             	cmp    0x8(%ebp),%eax
  802755:	0f 85 95 00 00 00    	jne    8027f0 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80275b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275f:	75 17                	jne    802778 <alloc_block_NF+0x5b>
  802761:	83 ec 04             	sub    $0x4,%esp
  802764:	68 44 41 80 00       	push   $0x804144
  802769:	68 e0 00 00 00       	push   $0xe0
  80276e:	68 9b 40 80 00       	push   $0x80409b
  802773:	e8 59 db ff ff       	call   8002d1 <_panic>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	74 10                	je     802791 <alloc_block_NF+0x74>
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 00                	mov    (%eax),%eax
  802786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802789:	8b 52 04             	mov    0x4(%edx),%edx
  80278c:	89 50 04             	mov    %edx,0x4(%eax)
  80278f:	eb 0b                	jmp    80279c <alloc_block_NF+0x7f>
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 40 04             	mov    0x4(%eax),%eax
  802797:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 40 04             	mov    0x4(%eax),%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	74 0f                	je     8027b5 <alloc_block_NF+0x98>
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027af:	8b 12                	mov    (%edx),%edx
  8027b1:	89 10                	mov    %edx,(%eax)
  8027b3:	eb 0a                	jmp    8027bf <alloc_block_NF+0xa2>
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 00                	mov    (%eax),%eax
  8027ba:	a3 38 51 80 00       	mov    %eax,0x805138
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d2:	a1 44 51 80 00       	mov    0x805144,%eax
  8027d7:	48                   	dec    %eax
  8027d8:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 40 08             	mov    0x8(%eax),%eax
  8027e3:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	e9 f8 04 00 00       	jmp    802ce8 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f9:	0f 86 d4 00 00 00    	jbe    8028d3 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027ff:	a1 48 51 80 00       	mov    0x805148,%eax
  802804:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	8b 50 08             	mov    0x8(%eax),%edx
  80280d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802810:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802816:	8b 55 08             	mov    0x8(%ebp),%edx
  802819:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80281c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802820:	75 17                	jne    802839 <alloc_block_NF+0x11c>
  802822:	83 ec 04             	sub    $0x4,%esp
  802825:	68 44 41 80 00       	push   $0x804144
  80282a:	68 e9 00 00 00       	push   $0xe9
  80282f:	68 9b 40 80 00       	push   $0x80409b
  802834:	e8 98 da ff ff       	call   8002d1 <_panic>
  802839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	74 10                	je     802852 <alloc_block_NF+0x135>
  802842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284a:	8b 52 04             	mov    0x4(%edx),%edx
  80284d:	89 50 04             	mov    %edx,0x4(%eax)
  802850:	eb 0b                	jmp    80285d <alloc_block_NF+0x140>
  802852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802855:	8b 40 04             	mov    0x4(%eax),%eax
  802858:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80285d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802860:	8b 40 04             	mov    0x4(%eax),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	74 0f                	je     802876 <alloc_block_NF+0x159>
  802867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286a:	8b 40 04             	mov    0x4(%eax),%eax
  80286d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802870:	8b 12                	mov    (%edx),%edx
  802872:	89 10                	mov    %edx,(%eax)
  802874:	eb 0a                	jmp    802880 <alloc_block_NF+0x163>
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	a3 48 51 80 00       	mov    %eax,0x805148
  802880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802883:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802893:	a1 54 51 80 00       	mov    0x805154,%eax
  802898:	48                   	dec    %eax
  802899:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80289e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a1:	8b 40 08             	mov    0x8(%eax),%eax
  8028a4:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 50 08             	mov    0x8(%eax),%edx
  8028af:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b2:	01 c2                	add    %eax,%edx
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c0:	2b 45 08             	sub    0x8(%ebp),%eax
  8028c3:	89 c2                	mov    %eax,%edx
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ce:	e9 15 04 00 00       	jmp    802ce8 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028d3:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028df:	74 07                	je     8028e8 <alloc_block_NF+0x1cb>
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	8b 00                	mov    (%eax),%eax
  8028e6:	eb 05                	jmp    8028ed <alloc_block_NF+0x1d0>
  8028e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ed:	a3 40 51 80 00       	mov    %eax,0x805140
  8028f2:	a1 40 51 80 00       	mov    0x805140,%eax
  8028f7:	85 c0                	test   %eax,%eax
  8028f9:	0f 85 3e fe ff ff    	jne    80273d <alloc_block_NF+0x20>
  8028ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802903:	0f 85 34 fe ff ff    	jne    80273d <alloc_block_NF+0x20>
  802909:	e9 d5 03 00 00       	jmp    802ce3 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80290e:	a1 38 51 80 00       	mov    0x805138,%eax
  802913:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802916:	e9 b1 01 00 00       	jmp    802acc <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 50 08             	mov    0x8(%eax),%edx
  802921:	a1 28 50 80 00       	mov    0x805028,%eax
  802926:	39 c2                	cmp    %eax,%edx
  802928:	0f 82 96 01 00 00    	jb     802ac4 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	8b 40 0c             	mov    0xc(%eax),%eax
  802934:	3b 45 08             	cmp    0x8(%ebp),%eax
  802937:	0f 82 87 01 00 00    	jb     802ac4 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	8b 40 0c             	mov    0xc(%eax),%eax
  802943:	3b 45 08             	cmp    0x8(%ebp),%eax
  802946:	0f 85 95 00 00 00    	jne    8029e1 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80294c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802950:	75 17                	jne    802969 <alloc_block_NF+0x24c>
  802952:	83 ec 04             	sub    $0x4,%esp
  802955:	68 44 41 80 00       	push   $0x804144
  80295a:	68 fc 00 00 00       	push   $0xfc
  80295f:	68 9b 40 80 00       	push   $0x80409b
  802964:	e8 68 d9 ff ff       	call   8002d1 <_panic>
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 00                	mov    (%eax),%eax
  80296e:	85 c0                	test   %eax,%eax
  802970:	74 10                	je     802982 <alloc_block_NF+0x265>
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 00                	mov    (%eax),%eax
  802977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297a:	8b 52 04             	mov    0x4(%edx),%edx
  80297d:	89 50 04             	mov    %edx,0x4(%eax)
  802980:	eb 0b                	jmp    80298d <alloc_block_NF+0x270>
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 40 04             	mov    0x4(%eax),%eax
  802988:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	85 c0                	test   %eax,%eax
  802995:	74 0f                	je     8029a6 <alloc_block_NF+0x289>
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 40 04             	mov    0x4(%eax),%eax
  80299d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a0:	8b 12                	mov    (%edx),%edx
  8029a2:	89 10                	mov    %edx,(%eax)
  8029a4:	eb 0a                	jmp    8029b0 <alloc_block_NF+0x293>
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 00                	mov    (%eax),%eax
  8029ab:	a3 38 51 80 00       	mov    %eax,0x805138
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c3:	a1 44 51 80 00       	mov    0x805144,%eax
  8029c8:	48                   	dec    %eax
  8029c9:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 40 08             	mov    0x8(%eax),%eax
  8029d4:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	e9 07 03 00 00       	jmp    802ce8 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ea:	0f 86 d4 00 00 00    	jbe    802ac4 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8029f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 50 08             	mov    0x8(%eax),%edx
  8029fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a01:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a07:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a0d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a11:	75 17                	jne    802a2a <alloc_block_NF+0x30d>
  802a13:	83 ec 04             	sub    $0x4,%esp
  802a16:	68 44 41 80 00       	push   $0x804144
  802a1b:	68 04 01 00 00       	push   $0x104
  802a20:	68 9b 40 80 00       	push   $0x80409b
  802a25:	e8 a7 d8 ff ff       	call   8002d1 <_panic>
  802a2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2d:	8b 00                	mov    (%eax),%eax
  802a2f:	85 c0                	test   %eax,%eax
  802a31:	74 10                	je     802a43 <alloc_block_NF+0x326>
  802a33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a36:	8b 00                	mov    (%eax),%eax
  802a38:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a3b:	8b 52 04             	mov    0x4(%edx),%edx
  802a3e:	89 50 04             	mov    %edx,0x4(%eax)
  802a41:	eb 0b                	jmp    802a4e <alloc_block_NF+0x331>
  802a43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a46:	8b 40 04             	mov    0x4(%eax),%eax
  802a49:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a51:	8b 40 04             	mov    0x4(%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 0f                	je     802a67 <alloc_block_NF+0x34a>
  802a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5b:	8b 40 04             	mov    0x4(%eax),%eax
  802a5e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a61:	8b 12                	mov    (%edx),%edx
  802a63:	89 10                	mov    %edx,(%eax)
  802a65:	eb 0a                	jmp    802a71 <alloc_block_NF+0x354>
  802a67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	a3 48 51 80 00       	mov    %eax,0x805148
  802a71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a84:	a1 54 51 80 00       	mov    0x805154,%eax
  802a89:	48                   	dec    %eax
  802a8a:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a92:	8b 40 08             	mov    0x8(%eax),%eax
  802a95:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 50 08             	mov    0x8(%eax),%edx
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	01 c2                	add    %eax,%edx
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab1:	2b 45 08             	sub    0x8(%ebp),%eax
  802ab4:	89 c2                	mov    %eax,%edx
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802abc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abf:	e9 24 02 00 00       	jmp    802ce8 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ac4:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802acc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad0:	74 07                	je     802ad9 <alloc_block_NF+0x3bc>
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 00                	mov    (%eax),%eax
  802ad7:	eb 05                	jmp    802ade <alloc_block_NF+0x3c1>
  802ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  802ade:	a3 40 51 80 00       	mov    %eax,0x805140
  802ae3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ae8:	85 c0                	test   %eax,%eax
  802aea:	0f 85 2b fe ff ff    	jne    80291b <alloc_block_NF+0x1fe>
  802af0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af4:	0f 85 21 fe ff ff    	jne    80291b <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802afa:	a1 38 51 80 00       	mov    0x805138,%eax
  802aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b02:	e9 ae 01 00 00       	jmp    802cb5 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 50 08             	mov    0x8(%eax),%edx
  802b0d:	a1 28 50 80 00       	mov    0x805028,%eax
  802b12:	39 c2                	cmp    %eax,%edx
  802b14:	0f 83 93 01 00 00    	jae    802cad <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b20:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b23:	0f 82 84 01 00 00    	jb     802cad <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b32:	0f 85 95 00 00 00    	jne    802bcd <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3c:	75 17                	jne    802b55 <alloc_block_NF+0x438>
  802b3e:	83 ec 04             	sub    $0x4,%esp
  802b41:	68 44 41 80 00       	push   $0x804144
  802b46:	68 14 01 00 00       	push   $0x114
  802b4b:	68 9b 40 80 00       	push   $0x80409b
  802b50:	e8 7c d7 ff ff       	call   8002d1 <_panic>
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	85 c0                	test   %eax,%eax
  802b5c:	74 10                	je     802b6e <alloc_block_NF+0x451>
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 00                	mov    (%eax),%eax
  802b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b66:	8b 52 04             	mov    0x4(%edx),%edx
  802b69:	89 50 04             	mov    %edx,0x4(%eax)
  802b6c:	eb 0b                	jmp    802b79 <alloc_block_NF+0x45c>
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 40 04             	mov    0x4(%eax),%eax
  802b74:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 40 04             	mov    0x4(%eax),%eax
  802b7f:	85 c0                	test   %eax,%eax
  802b81:	74 0f                	je     802b92 <alloc_block_NF+0x475>
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 40 04             	mov    0x4(%eax),%eax
  802b89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8c:	8b 12                	mov    (%edx),%edx
  802b8e:	89 10                	mov    %edx,(%eax)
  802b90:	eb 0a                	jmp    802b9c <alloc_block_NF+0x47f>
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	a3 38 51 80 00       	mov    %eax,0x805138
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802baf:	a1 44 51 80 00       	mov    0x805144,%eax
  802bb4:	48                   	dec    %eax
  802bb5:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 40 08             	mov    0x8(%eax),%eax
  802bc0:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	e9 1b 01 00 00       	jmp    802ce8 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd6:	0f 86 d1 00 00 00    	jbe    802cad <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bdc:	a1 48 51 80 00       	mov    0x805148,%eax
  802be1:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 50 08             	mov    0x8(%eax),%edx
  802bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bed:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf3:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf6:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bfd:	75 17                	jne    802c16 <alloc_block_NF+0x4f9>
  802bff:	83 ec 04             	sub    $0x4,%esp
  802c02:	68 44 41 80 00       	push   $0x804144
  802c07:	68 1c 01 00 00       	push   $0x11c
  802c0c:	68 9b 40 80 00       	push   $0x80409b
  802c11:	e8 bb d6 ff ff       	call   8002d1 <_panic>
  802c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	74 10                	je     802c2f <alloc_block_NF+0x512>
  802c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c27:	8b 52 04             	mov    0x4(%edx),%edx
  802c2a:	89 50 04             	mov    %edx,0x4(%eax)
  802c2d:	eb 0b                	jmp    802c3a <alloc_block_NF+0x51d>
  802c2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c32:	8b 40 04             	mov    0x4(%eax),%eax
  802c35:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3d:	8b 40 04             	mov    0x4(%eax),%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	74 0f                	je     802c53 <alloc_block_NF+0x536>
  802c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c47:	8b 40 04             	mov    0x4(%eax),%eax
  802c4a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c4d:	8b 12                	mov    (%edx),%edx
  802c4f:	89 10                	mov    %edx,(%eax)
  802c51:	eb 0a                	jmp    802c5d <alloc_block_NF+0x540>
  802c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	a3 48 51 80 00       	mov    %eax,0x805148
  802c5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c70:	a1 54 51 80 00       	mov    0x805154,%eax
  802c75:	48                   	dec    %eax
  802c76:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7e:	8b 40 08             	mov    0x8(%eax),%eax
  802c81:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	8b 50 08             	mov    0x8(%eax),%edx
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	01 c2                	add    %eax,%edx
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9d:	2b 45 08             	sub    0x8(%ebp),%eax
  802ca0:	89 c2                	mov    %eax,%edx
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cab:	eb 3b                	jmp    802ce8 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cad:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb9:	74 07                	je     802cc2 <alloc_block_NF+0x5a5>
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	eb 05                	jmp    802cc7 <alloc_block_NF+0x5aa>
  802cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc7:	a3 40 51 80 00       	mov    %eax,0x805140
  802ccc:	a1 40 51 80 00       	mov    0x805140,%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	0f 85 2e fe ff ff    	jne    802b07 <alloc_block_NF+0x3ea>
  802cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdd:	0f 85 24 fe ff ff    	jne    802b07 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ce3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ce8:	c9                   	leave  
  802ce9:	c3                   	ret    

00802cea <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cea:	55                   	push   %ebp
  802ceb:	89 e5                	mov    %esp,%ebp
  802ced:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cf0:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cf8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cfd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d00:	a1 38 51 80 00       	mov    0x805138,%eax
  802d05:	85 c0                	test   %eax,%eax
  802d07:	74 14                	je     802d1d <insert_sorted_with_merge_freeList+0x33>
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	8b 50 08             	mov    0x8(%eax),%edx
  802d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d12:	8b 40 08             	mov    0x8(%eax),%eax
  802d15:	39 c2                	cmp    %eax,%edx
  802d17:	0f 87 9b 01 00 00    	ja     802eb8 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d21:	75 17                	jne    802d3a <insert_sorted_with_merge_freeList+0x50>
  802d23:	83 ec 04             	sub    $0x4,%esp
  802d26:	68 78 40 80 00       	push   $0x804078
  802d2b:	68 38 01 00 00       	push   $0x138
  802d30:	68 9b 40 80 00       	push   $0x80409b
  802d35:	e8 97 d5 ff ff       	call   8002d1 <_panic>
  802d3a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	89 10                	mov    %edx,(%eax)
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	85 c0                	test   %eax,%eax
  802d4c:	74 0d                	je     802d5b <insert_sorted_with_merge_freeList+0x71>
  802d4e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d53:	8b 55 08             	mov    0x8(%ebp),%edx
  802d56:	89 50 04             	mov    %edx,0x4(%eax)
  802d59:	eb 08                	jmp    802d63 <insert_sorted_with_merge_freeList+0x79>
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	a3 38 51 80 00       	mov    %eax,0x805138
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d75:	a1 44 51 80 00       	mov    0x805144,%eax
  802d7a:	40                   	inc    %eax
  802d7b:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d84:	0f 84 a8 06 00 00    	je     803432 <insert_sorted_with_merge_freeList+0x748>
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	8b 50 08             	mov    0x8(%eax),%edx
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	8b 40 0c             	mov    0xc(%eax),%eax
  802d96:	01 c2                	add    %eax,%edx
  802d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9b:	8b 40 08             	mov    0x8(%eax),%eax
  802d9e:	39 c2                	cmp    %eax,%edx
  802da0:	0f 85 8c 06 00 00    	jne    803432 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	8b 50 0c             	mov    0xc(%eax),%edx
  802dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daf:	8b 40 0c             	mov    0xc(%eax),%eax
  802db2:	01 c2                	add    %eax,%edx
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802dba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dbe:	75 17                	jne    802dd7 <insert_sorted_with_merge_freeList+0xed>
  802dc0:	83 ec 04             	sub    $0x4,%esp
  802dc3:	68 44 41 80 00       	push   $0x804144
  802dc8:	68 3c 01 00 00       	push   $0x13c
  802dcd:	68 9b 40 80 00       	push   $0x80409b
  802dd2:	e8 fa d4 ff ff       	call   8002d1 <_panic>
  802dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	85 c0                	test   %eax,%eax
  802dde:	74 10                	je     802df0 <insert_sorted_with_merge_freeList+0x106>
  802de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de8:	8b 52 04             	mov    0x4(%edx),%edx
  802deb:	89 50 04             	mov    %edx,0x4(%eax)
  802dee:	eb 0b                	jmp    802dfb <insert_sorted_with_merge_freeList+0x111>
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	8b 40 04             	mov    0x4(%eax),%eax
  802df6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfe:	8b 40 04             	mov    0x4(%eax),%eax
  802e01:	85 c0                	test   %eax,%eax
  802e03:	74 0f                	je     802e14 <insert_sorted_with_merge_freeList+0x12a>
  802e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e08:	8b 40 04             	mov    0x4(%eax),%eax
  802e0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e0e:	8b 12                	mov    (%edx),%edx
  802e10:	89 10                	mov    %edx,(%eax)
  802e12:	eb 0a                	jmp    802e1e <insert_sorted_with_merge_freeList+0x134>
  802e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e17:	8b 00                	mov    (%eax),%eax
  802e19:	a3 38 51 80 00       	mov    %eax,0x805138
  802e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e31:	a1 44 51 80 00       	mov    0x805144,%eax
  802e36:	48                   	dec    %eax
  802e37:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e54:	75 17                	jne    802e6d <insert_sorted_with_merge_freeList+0x183>
  802e56:	83 ec 04             	sub    $0x4,%esp
  802e59:	68 78 40 80 00       	push   $0x804078
  802e5e:	68 3f 01 00 00       	push   $0x13f
  802e63:	68 9b 40 80 00       	push   $0x80409b
  802e68:	e8 64 d4 ff ff       	call   8002d1 <_panic>
  802e6d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e76:	89 10                	mov    %edx,(%eax)
  802e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7b:	8b 00                	mov    (%eax),%eax
  802e7d:	85 c0                	test   %eax,%eax
  802e7f:	74 0d                	je     802e8e <insert_sorted_with_merge_freeList+0x1a4>
  802e81:	a1 48 51 80 00       	mov    0x805148,%eax
  802e86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e89:	89 50 04             	mov    %edx,0x4(%eax)
  802e8c:	eb 08                	jmp    802e96 <insert_sorted_with_merge_freeList+0x1ac>
  802e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e91:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e99:	a3 48 51 80 00       	mov    %eax,0x805148
  802e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea8:	a1 54 51 80 00       	mov    0x805154,%eax
  802ead:	40                   	inc    %eax
  802eae:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802eb3:	e9 7a 05 00 00       	jmp    803432 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	8b 50 08             	mov    0x8(%eax),%edx
  802ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec1:	8b 40 08             	mov    0x8(%eax),%eax
  802ec4:	39 c2                	cmp    %eax,%edx
  802ec6:	0f 82 14 01 00 00    	jb     802fe0 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecf:	8b 50 08             	mov    0x8(%eax),%edx
  802ed2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed8:	01 c2                	add    %eax,%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	8b 40 08             	mov    0x8(%eax),%eax
  802ee0:	39 c2                	cmp    %eax,%edx
  802ee2:	0f 85 90 00 00 00    	jne    802f78 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eeb:	8b 50 0c             	mov    0xc(%eax),%edx
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef4:	01 c2                	add    %eax,%edx
  802ef6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef9:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f14:	75 17                	jne    802f2d <insert_sorted_with_merge_freeList+0x243>
  802f16:	83 ec 04             	sub    $0x4,%esp
  802f19:	68 78 40 80 00       	push   $0x804078
  802f1e:	68 49 01 00 00       	push   $0x149
  802f23:	68 9b 40 80 00       	push   $0x80409b
  802f28:	e8 a4 d3 ff ff       	call   8002d1 <_panic>
  802f2d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	74 0d                	je     802f4e <insert_sorted_with_merge_freeList+0x264>
  802f41:	a1 48 51 80 00       	mov    0x805148,%eax
  802f46:	8b 55 08             	mov    0x8(%ebp),%edx
  802f49:	89 50 04             	mov    %edx,0x4(%eax)
  802f4c:	eb 08                	jmp    802f56 <insert_sorted_with_merge_freeList+0x26c>
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	a3 48 51 80 00       	mov    %eax,0x805148
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f68:	a1 54 51 80 00       	mov    0x805154,%eax
  802f6d:	40                   	inc    %eax
  802f6e:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f73:	e9 bb 04 00 00       	jmp    803433 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7c:	75 17                	jne    802f95 <insert_sorted_with_merge_freeList+0x2ab>
  802f7e:	83 ec 04             	sub    $0x4,%esp
  802f81:	68 ec 40 80 00       	push   $0x8040ec
  802f86:	68 4c 01 00 00       	push   $0x14c
  802f8b:	68 9b 40 80 00       	push   $0x80409b
  802f90:	e8 3c d3 ff ff       	call   8002d1 <_panic>
  802f95:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	89 50 04             	mov    %edx,0x4(%eax)
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	8b 40 04             	mov    0x4(%eax),%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	74 0c                	je     802fb7 <insert_sorted_with_merge_freeList+0x2cd>
  802fab:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb3:	89 10                	mov    %edx,(%eax)
  802fb5:	eb 08                	jmp    802fbf <insert_sorted_with_merge_freeList+0x2d5>
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	a3 38 51 80 00       	mov    %eax,0x805138
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd0:	a1 44 51 80 00       	mov    0x805144,%eax
  802fd5:	40                   	inc    %eax
  802fd6:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fdb:	e9 53 04 00 00       	jmp    803433 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fe0:	a1 38 51 80 00       	mov    0x805138,%eax
  802fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe8:	e9 15 04 00 00       	jmp    803402 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	8b 50 08             	mov    0x8(%eax),%edx
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 40 08             	mov    0x8(%eax),%eax
  803001:	39 c2                	cmp    %eax,%edx
  803003:	0f 86 f1 03 00 00    	jbe    8033fa <insert_sorted_with_merge_freeList+0x710>
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	8b 50 08             	mov    0x8(%eax),%edx
  80300f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803012:	8b 40 08             	mov    0x8(%eax),%eax
  803015:	39 c2                	cmp    %eax,%edx
  803017:	0f 83 dd 03 00 00    	jae    8033fa <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 50 08             	mov    0x8(%eax),%edx
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 40 0c             	mov    0xc(%eax),%eax
  803029:	01 c2                	add    %eax,%edx
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	8b 40 08             	mov    0x8(%eax),%eax
  803031:	39 c2                	cmp    %eax,%edx
  803033:	0f 85 b9 01 00 00    	jne    8031f2 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	8b 50 08             	mov    0x8(%eax),%edx
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	8b 40 0c             	mov    0xc(%eax),%eax
  803045:	01 c2                	add    %eax,%edx
  803047:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304a:	8b 40 08             	mov    0x8(%eax),%eax
  80304d:	39 c2                	cmp    %eax,%edx
  80304f:	0f 85 0d 01 00 00    	jne    803162 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803058:	8b 50 0c             	mov    0xc(%eax),%edx
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	8b 40 0c             	mov    0xc(%eax),%eax
  803061:	01 c2                	add    %eax,%edx
  803063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803066:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803069:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80306d:	75 17                	jne    803086 <insert_sorted_with_merge_freeList+0x39c>
  80306f:	83 ec 04             	sub    $0x4,%esp
  803072:	68 44 41 80 00       	push   $0x804144
  803077:	68 5c 01 00 00       	push   $0x15c
  80307c:	68 9b 40 80 00       	push   $0x80409b
  803081:	e8 4b d2 ff ff       	call   8002d1 <_panic>
  803086:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	85 c0                	test   %eax,%eax
  80308d:	74 10                	je     80309f <insert_sorted_with_merge_freeList+0x3b5>
  80308f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803097:	8b 52 04             	mov    0x4(%edx),%edx
  80309a:	89 50 04             	mov    %edx,0x4(%eax)
  80309d:	eb 0b                	jmp    8030aa <insert_sorted_with_merge_freeList+0x3c0>
  80309f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a2:	8b 40 04             	mov    0x4(%eax),%eax
  8030a5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ad:	8b 40 04             	mov    0x4(%eax),%eax
  8030b0:	85 c0                	test   %eax,%eax
  8030b2:	74 0f                	je     8030c3 <insert_sorted_with_merge_freeList+0x3d9>
  8030b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030bd:	8b 12                	mov    (%edx),%edx
  8030bf:	89 10                	mov    %edx,(%eax)
  8030c1:	eb 0a                	jmp    8030cd <insert_sorted_with_merge_freeList+0x3e3>
  8030c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c6:	8b 00                	mov    (%eax),%eax
  8030c8:	a3 38 51 80 00       	mov    %eax,0x805138
  8030cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e0:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e5:	48                   	dec    %eax
  8030e6:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803103:	75 17                	jne    80311c <insert_sorted_with_merge_freeList+0x432>
  803105:	83 ec 04             	sub    $0x4,%esp
  803108:	68 78 40 80 00       	push   $0x804078
  80310d:	68 5f 01 00 00       	push   $0x15f
  803112:	68 9b 40 80 00       	push   $0x80409b
  803117:	e8 b5 d1 ff ff       	call   8002d1 <_panic>
  80311c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803122:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803125:	89 10                	mov    %edx,(%eax)
  803127:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	85 c0                	test   %eax,%eax
  80312e:	74 0d                	je     80313d <insert_sorted_with_merge_freeList+0x453>
  803130:	a1 48 51 80 00       	mov    0x805148,%eax
  803135:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803138:	89 50 04             	mov    %edx,0x4(%eax)
  80313b:	eb 08                	jmp    803145 <insert_sorted_with_merge_freeList+0x45b>
  80313d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803140:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803148:	a3 48 51 80 00       	mov    %eax,0x805148
  80314d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803150:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803157:	a1 54 51 80 00       	mov    0x805154,%eax
  80315c:	40                   	inc    %eax
  80315d:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803165:	8b 50 0c             	mov    0xc(%eax),%edx
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	8b 40 0c             	mov    0xc(%eax),%eax
  80316e:	01 c2                	add    %eax,%edx
  803170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803173:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80318a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318e:	75 17                	jne    8031a7 <insert_sorted_with_merge_freeList+0x4bd>
  803190:	83 ec 04             	sub    $0x4,%esp
  803193:	68 78 40 80 00       	push   $0x804078
  803198:	68 64 01 00 00       	push   $0x164
  80319d:	68 9b 40 80 00       	push   $0x80409b
  8031a2:	e8 2a d1 ff ff       	call   8002d1 <_panic>
  8031a7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	89 10                	mov    %edx,(%eax)
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	8b 00                	mov    (%eax),%eax
  8031b7:	85 c0                	test   %eax,%eax
  8031b9:	74 0d                	je     8031c8 <insert_sorted_with_merge_freeList+0x4de>
  8031bb:	a1 48 51 80 00       	mov    0x805148,%eax
  8031c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c3:	89 50 04             	mov    %edx,0x4(%eax)
  8031c6:	eb 08                	jmp    8031d0 <insert_sorted_with_merge_freeList+0x4e6>
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d3:	a3 48 51 80 00       	mov    %eax,0x805148
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e2:	a1 54 51 80 00       	mov    0x805154,%eax
  8031e7:	40                   	inc    %eax
  8031e8:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031ed:	e9 41 02 00 00       	jmp    803433 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	8b 50 08             	mov    0x8(%eax),%edx
  8031f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fe:	01 c2                	add    %eax,%edx
  803200:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803203:	8b 40 08             	mov    0x8(%eax),%eax
  803206:	39 c2                	cmp    %eax,%edx
  803208:	0f 85 7c 01 00 00    	jne    80338a <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80320e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803212:	74 06                	je     80321a <insert_sorted_with_merge_freeList+0x530>
  803214:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803218:	75 17                	jne    803231 <insert_sorted_with_merge_freeList+0x547>
  80321a:	83 ec 04             	sub    $0x4,%esp
  80321d:	68 b4 40 80 00       	push   $0x8040b4
  803222:	68 69 01 00 00       	push   $0x169
  803227:	68 9b 40 80 00       	push   $0x80409b
  80322c:	e8 a0 d0 ff ff       	call   8002d1 <_panic>
  803231:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803234:	8b 50 04             	mov    0x4(%eax),%edx
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	89 50 04             	mov    %edx,0x4(%eax)
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803243:	89 10                	mov    %edx,(%eax)
  803245:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803248:	8b 40 04             	mov    0x4(%eax),%eax
  80324b:	85 c0                	test   %eax,%eax
  80324d:	74 0d                	je     80325c <insert_sorted_with_merge_freeList+0x572>
  80324f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803252:	8b 40 04             	mov    0x4(%eax),%eax
  803255:	8b 55 08             	mov    0x8(%ebp),%edx
  803258:	89 10                	mov    %edx,(%eax)
  80325a:	eb 08                	jmp    803264 <insert_sorted_with_merge_freeList+0x57a>
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	a3 38 51 80 00       	mov    %eax,0x805138
  803264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803267:	8b 55 08             	mov    0x8(%ebp),%edx
  80326a:	89 50 04             	mov    %edx,0x4(%eax)
  80326d:	a1 44 51 80 00       	mov    0x805144,%eax
  803272:	40                   	inc    %eax
  803273:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	8b 50 0c             	mov    0xc(%eax),%edx
  80327e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803281:	8b 40 0c             	mov    0xc(%eax),%eax
  803284:	01 c2                	add    %eax,%edx
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80328c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803290:	75 17                	jne    8032a9 <insert_sorted_with_merge_freeList+0x5bf>
  803292:	83 ec 04             	sub    $0x4,%esp
  803295:	68 44 41 80 00       	push   $0x804144
  80329a:	68 6b 01 00 00       	push   $0x16b
  80329f:	68 9b 40 80 00       	push   $0x80409b
  8032a4:	e8 28 d0 ff ff       	call   8002d1 <_panic>
  8032a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ac:	8b 00                	mov    (%eax),%eax
  8032ae:	85 c0                	test   %eax,%eax
  8032b0:	74 10                	je     8032c2 <insert_sorted_with_merge_freeList+0x5d8>
  8032b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b5:	8b 00                	mov    (%eax),%eax
  8032b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ba:	8b 52 04             	mov    0x4(%edx),%edx
  8032bd:	89 50 04             	mov    %edx,0x4(%eax)
  8032c0:	eb 0b                	jmp    8032cd <insert_sorted_with_merge_freeList+0x5e3>
  8032c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c5:	8b 40 04             	mov    0x4(%eax),%eax
  8032c8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d0:	8b 40 04             	mov    0x4(%eax),%eax
  8032d3:	85 c0                	test   %eax,%eax
  8032d5:	74 0f                	je     8032e6 <insert_sorted_with_merge_freeList+0x5fc>
  8032d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032da:	8b 40 04             	mov    0x4(%eax),%eax
  8032dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e0:	8b 12                	mov    (%edx),%edx
  8032e2:	89 10                	mov    %edx,(%eax)
  8032e4:	eb 0a                	jmp    8032f0 <insert_sorted_with_merge_freeList+0x606>
  8032e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e9:	8b 00                	mov    (%eax),%eax
  8032eb:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803303:	a1 44 51 80 00       	mov    0x805144,%eax
  803308:	48                   	dec    %eax
  803309:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803311:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803318:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803322:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803326:	75 17                	jne    80333f <insert_sorted_with_merge_freeList+0x655>
  803328:	83 ec 04             	sub    $0x4,%esp
  80332b:	68 78 40 80 00       	push   $0x804078
  803330:	68 6e 01 00 00       	push   $0x16e
  803335:	68 9b 40 80 00       	push   $0x80409b
  80333a:	e8 92 cf ff ff       	call   8002d1 <_panic>
  80333f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803345:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803348:	89 10                	mov    %edx,(%eax)
  80334a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334d:	8b 00                	mov    (%eax),%eax
  80334f:	85 c0                	test   %eax,%eax
  803351:	74 0d                	je     803360 <insert_sorted_with_merge_freeList+0x676>
  803353:	a1 48 51 80 00       	mov    0x805148,%eax
  803358:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335b:	89 50 04             	mov    %edx,0x4(%eax)
  80335e:	eb 08                	jmp    803368 <insert_sorted_with_merge_freeList+0x67e>
  803360:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803363:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336b:	a3 48 51 80 00       	mov    %eax,0x805148
  803370:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803373:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337a:	a1 54 51 80 00       	mov    0x805154,%eax
  80337f:	40                   	inc    %eax
  803380:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803385:	e9 a9 00 00 00       	jmp    803433 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80338a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338e:	74 06                	je     803396 <insert_sorted_with_merge_freeList+0x6ac>
  803390:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803394:	75 17                	jne    8033ad <insert_sorted_with_merge_freeList+0x6c3>
  803396:	83 ec 04             	sub    $0x4,%esp
  803399:	68 10 41 80 00       	push   $0x804110
  80339e:	68 73 01 00 00       	push   $0x173
  8033a3:	68 9b 40 80 00       	push   $0x80409b
  8033a8:	e8 24 cf ff ff       	call   8002d1 <_panic>
  8033ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b0:	8b 10                	mov    (%eax),%edx
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	89 10                	mov    %edx,(%eax)
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	8b 00                	mov    (%eax),%eax
  8033bc:	85 c0                	test   %eax,%eax
  8033be:	74 0b                	je     8033cb <insert_sorted_with_merge_freeList+0x6e1>
  8033c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c8:	89 50 04             	mov    %edx,0x4(%eax)
  8033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d1:	89 10                	mov    %edx,(%eax)
  8033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033d9:	89 50 04             	mov    %edx,0x4(%eax)
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	8b 00                	mov    (%eax),%eax
  8033e1:	85 c0                	test   %eax,%eax
  8033e3:	75 08                	jne    8033ed <insert_sorted_with_merge_freeList+0x703>
  8033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8033f2:	40                   	inc    %eax
  8033f3:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033f8:	eb 39                	jmp    803433 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8033ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803406:	74 07                	je     80340f <insert_sorted_with_merge_freeList+0x725>
  803408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340b:	8b 00                	mov    (%eax),%eax
  80340d:	eb 05                	jmp    803414 <insert_sorted_with_merge_freeList+0x72a>
  80340f:	b8 00 00 00 00       	mov    $0x0,%eax
  803414:	a3 40 51 80 00       	mov    %eax,0x805140
  803419:	a1 40 51 80 00       	mov    0x805140,%eax
  80341e:	85 c0                	test   %eax,%eax
  803420:	0f 85 c7 fb ff ff    	jne    802fed <insert_sorted_with_merge_freeList+0x303>
  803426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80342a:	0f 85 bd fb ff ff    	jne    802fed <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803430:	eb 01                	jmp    803433 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803432:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803433:	90                   	nop
  803434:	c9                   	leave  
  803435:	c3                   	ret    

00803436 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803436:	55                   	push   %ebp
  803437:	89 e5                	mov    %esp,%ebp
  803439:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80343c:	8b 55 08             	mov    0x8(%ebp),%edx
  80343f:	89 d0                	mov    %edx,%eax
  803441:	c1 e0 02             	shl    $0x2,%eax
  803444:	01 d0                	add    %edx,%eax
  803446:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80344d:	01 d0                	add    %edx,%eax
  80344f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803456:	01 d0                	add    %edx,%eax
  803458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80345f:	01 d0                	add    %edx,%eax
  803461:	c1 e0 04             	shl    $0x4,%eax
  803464:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803467:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80346e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803471:	83 ec 0c             	sub    $0xc,%esp
  803474:	50                   	push   %eax
  803475:	e8 26 e7 ff ff       	call   801ba0 <sys_get_virtual_time>
  80347a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80347d:	eb 41                	jmp    8034c0 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80347f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803482:	83 ec 0c             	sub    $0xc,%esp
  803485:	50                   	push   %eax
  803486:	e8 15 e7 ff ff       	call   801ba0 <sys_get_virtual_time>
  80348b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80348e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803491:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803494:	29 c2                	sub    %eax,%edx
  803496:	89 d0                	mov    %edx,%eax
  803498:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80349b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80349e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034a1:	89 d1                	mov    %edx,%ecx
  8034a3:	29 c1                	sub    %eax,%ecx
  8034a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8034a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ab:	39 c2                	cmp    %eax,%edx
  8034ad:	0f 97 c0             	seta   %al
  8034b0:	0f b6 c0             	movzbl %al,%eax
  8034b3:	29 c1                	sub    %eax,%ecx
  8034b5:	89 c8                	mov    %ecx,%eax
  8034b7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8034ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034c6:	72 b7                	jb     80347f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8034c8:	90                   	nop
  8034c9:	c9                   	leave  
  8034ca:	c3                   	ret    

008034cb <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8034cb:	55                   	push   %ebp
  8034cc:	89 e5                	mov    %esp,%ebp
  8034ce:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8034d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8034d8:	eb 03                	jmp    8034dd <busy_wait+0x12>
  8034da:	ff 45 fc             	incl   -0x4(%ebp)
  8034dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034e3:	72 f5                	jb     8034da <busy_wait+0xf>
	return i;
  8034e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8034e8:	c9                   	leave  
  8034e9:	c3                   	ret    
  8034ea:	66 90                	xchg   %ax,%ax

008034ec <__udivdi3>:
  8034ec:	55                   	push   %ebp
  8034ed:	57                   	push   %edi
  8034ee:	56                   	push   %esi
  8034ef:	53                   	push   %ebx
  8034f0:	83 ec 1c             	sub    $0x1c,%esp
  8034f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803503:	89 ca                	mov    %ecx,%edx
  803505:	89 f8                	mov    %edi,%eax
  803507:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80350b:	85 f6                	test   %esi,%esi
  80350d:	75 2d                	jne    80353c <__udivdi3+0x50>
  80350f:	39 cf                	cmp    %ecx,%edi
  803511:	77 65                	ja     803578 <__udivdi3+0x8c>
  803513:	89 fd                	mov    %edi,%ebp
  803515:	85 ff                	test   %edi,%edi
  803517:	75 0b                	jne    803524 <__udivdi3+0x38>
  803519:	b8 01 00 00 00       	mov    $0x1,%eax
  80351e:	31 d2                	xor    %edx,%edx
  803520:	f7 f7                	div    %edi
  803522:	89 c5                	mov    %eax,%ebp
  803524:	31 d2                	xor    %edx,%edx
  803526:	89 c8                	mov    %ecx,%eax
  803528:	f7 f5                	div    %ebp
  80352a:	89 c1                	mov    %eax,%ecx
  80352c:	89 d8                	mov    %ebx,%eax
  80352e:	f7 f5                	div    %ebp
  803530:	89 cf                	mov    %ecx,%edi
  803532:	89 fa                	mov    %edi,%edx
  803534:	83 c4 1c             	add    $0x1c,%esp
  803537:	5b                   	pop    %ebx
  803538:	5e                   	pop    %esi
  803539:	5f                   	pop    %edi
  80353a:	5d                   	pop    %ebp
  80353b:	c3                   	ret    
  80353c:	39 ce                	cmp    %ecx,%esi
  80353e:	77 28                	ja     803568 <__udivdi3+0x7c>
  803540:	0f bd fe             	bsr    %esi,%edi
  803543:	83 f7 1f             	xor    $0x1f,%edi
  803546:	75 40                	jne    803588 <__udivdi3+0x9c>
  803548:	39 ce                	cmp    %ecx,%esi
  80354a:	72 0a                	jb     803556 <__udivdi3+0x6a>
  80354c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803550:	0f 87 9e 00 00 00    	ja     8035f4 <__udivdi3+0x108>
  803556:	b8 01 00 00 00       	mov    $0x1,%eax
  80355b:	89 fa                	mov    %edi,%edx
  80355d:	83 c4 1c             	add    $0x1c,%esp
  803560:	5b                   	pop    %ebx
  803561:	5e                   	pop    %esi
  803562:	5f                   	pop    %edi
  803563:	5d                   	pop    %ebp
  803564:	c3                   	ret    
  803565:	8d 76 00             	lea    0x0(%esi),%esi
  803568:	31 ff                	xor    %edi,%edi
  80356a:	31 c0                	xor    %eax,%eax
  80356c:	89 fa                	mov    %edi,%edx
  80356e:	83 c4 1c             	add    $0x1c,%esp
  803571:	5b                   	pop    %ebx
  803572:	5e                   	pop    %esi
  803573:	5f                   	pop    %edi
  803574:	5d                   	pop    %ebp
  803575:	c3                   	ret    
  803576:	66 90                	xchg   %ax,%ax
  803578:	89 d8                	mov    %ebx,%eax
  80357a:	f7 f7                	div    %edi
  80357c:	31 ff                	xor    %edi,%edi
  80357e:	89 fa                	mov    %edi,%edx
  803580:	83 c4 1c             	add    $0x1c,%esp
  803583:	5b                   	pop    %ebx
  803584:	5e                   	pop    %esi
  803585:	5f                   	pop    %edi
  803586:	5d                   	pop    %ebp
  803587:	c3                   	ret    
  803588:	bd 20 00 00 00       	mov    $0x20,%ebp
  80358d:	89 eb                	mov    %ebp,%ebx
  80358f:	29 fb                	sub    %edi,%ebx
  803591:	89 f9                	mov    %edi,%ecx
  803593:	d3 e6                	shl    %cl,%esi
  803595:	89 c5                	mov    %eax,%ebp
  803597:	88 d9                	mov    %bl,%cl
  803599:	d3 ed                	shr    %cl,%ebp
  80359b:	89 e9                	mov    %ebp,%ecx
  80359d:	09 f1                	or     %esi,%ecx
  80359f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035a3:	89 f9                	mov    %edi,%ecx
  8035a5:	d3 e0                	shl    %cl,%eax
  8035a7:	89 c5                	mov    %eax,%ebp
  8035a9:	89 d6                	mov    %edx,%esi
  8035ab:	88 d9                	mov    %bl,%cl
  8035ad:	d3 ee                	shr    %cl,%esi
  8035af:	89 f9                	mov    %edi,%ecx
  8035b1:	d3 e2                	shl    %cl,%edx
  8035b3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035b7:	88 d9                	mov    %bl,%cl
  8035b9:	d3 e8                	shr    %cl,%eax
  8035bb:	09 c2                	or     %eax,%edx
  8035bd:	89 d0                	mov    %edx,%eax
  8035bf:	89 f2                	mov    %esi,%edx
  8035c1:	f7 74 24 0c          	divl   0xc(%esp)
  8035c5:	89 d6                	mov    %edx,%esi
  8035c7:	89 c3                	mov    %eax,%ebx
  8035c9:	f7 e5                	mul    %ebp
  8035cb:	39 d6                	cmp    %edx,%esi
  8035cd:	72 19                	jb     8035e8 <__udivdi3+0xfc>
  8035cf:	74 0b                	je     8035dc <__udivdi3+0xf0>
  8035d1:	89 d8                	mov    %ebx,%eax
  8035d3:	31 ff                	xor    %edi,%edi
  8035d5:	e9 58 ff ff ff       	jmp    803532 <__udivdi3+0x46>
  8035da:	66 90                	xchg   %ax,%ax
  8035dc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035e0:	89 f9                	mov    %edi,%ecx
  8035e2:	d3 e2                	shl    %cl,%edx
  8035e4:	39 c2                	cmp    %eax,%edx
  8035e6:	73 e9                	jae    8035d1 <__udivdi3+0xe5>
  8035e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035eb:	31 ff                	xor    %edi,%edi
  8035ed:	e9 40 ff ff ff       	jmp    803532 <__udivdi3+0x46>
  8035f2:	66 90                	xchg   %ax,%ax
  8035f4:	31 c0                	xor    %eax,%eax
  8035f6:	e9 37 ff ff ff       	jmp    803532 <__udivdi3+0x46>
  8035fb:	90                   	nop

008035fc <__umoddi3>:
  8035fc:	55                   	push   %ebp
  8035fd:	57                   	push   %edi
  8035fe:	56                   	push   %esi
  8035ff:	53                   	push   %ebx
  803600:	83 ec 1c             	sub    $0x1c,%esp
  803603:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803607:	8b 74 24 34          	mov    0x34(%esp),%esi
  80360b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80360f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803613:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803617:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80361b:	89 f3                	mov    %esi,%ebx
  80361d:	89 fa                	mov    %edi,%edx
  80361f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803623:	89 34 24             	mov    %esi,(%esp)
  803626:	85 c0                	test   %eax,%eax
  803628:	75 1a                	jne    803644 <__umoddi3+0x48>
  80362a:	39 f7                	cmp    %esi,%edi
  80362c:	0f 86 a2 00 00 00    	jbe    8036d4 <__umoddi3+0xd8>
  803632:	89 c8                	mov    %ecx,%eax
  803634:	89 f2                	mov    %esi,%edx
  803636:	f7 f7                	div    %edi
  803638:	89 d0                	mov    %edx,%eax
  80363a:	31 d2                	xor    %edx,%edx
  80363c:	83 c4 1c             	add    $0x1c,%esp
  80363f:	5b                   	pop    %ebx
  803640:	5e                   	pop    %esi
  803641:	5f                   	pop    %edi
  803642:	5d                   	pop    %ebp
  803643:	c3                   	ret    
  803644:	39 f0                	cmp    %esi,%eax
  803646:	0f 87 ac 00 00 00    	ja     8036f8 <__umoddi3+0xfc>
  80364c:	0f bd e8             	bsr    %eax,%ebp
  80364f:	83 f5 1f             	xor    $0x1f,%ebp
  803652:	0f 84 ac 00 00 00    	je     803704 <__umoddi3+0x108>
  803658:	bf 20 00 00 00       	mov    $0x20,%edi
  80365d:	29 ef                	sub    %ebp,%edi
  80365f:	89 fe                	mov    %edi,%esi
  803661:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803665:	89 e9                	mov    %ebp,%ecx
  803667:	d3 e0                	shl    %cl,%eax
  803669:	89 d7                	mov    %edx,%edi
  80366b:	89 f1                	mov    %esi,%ecx
  80366d:	d3 ef                	shr    %cl,%edi
  80366f:	09 c7                	or     %eax,%edi
  803671:	89 e9                	mov    %ebp,%ecx
  803673:	d3 e2                	shl    %cl,%edx
  803675:	89 14 24             	mov    %edx,(%esp)
  803678:	89 d8                	mov    %ebx,%eax
  80367a:	d3 e0                	shl    %cl,%eax
  80367c:	89 c2                	mov    %eax,%edx
  80367e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803682:	d3 e0                	shl    %cl,%eax
  803684:	89 44 24 04          	mov    %eax,0x4(%esp)
  803688:	8b 44 24 08          	mov    0x8(%esp),%eax
  80368c:	89 f1                	mov    %esi,%ecx
  80368e:	d3 e8                	shr    %cl,%eax
  803690:	09 d0                	or     %edx,%eax
  803692:	d3 eb                	shr    %cl,%ebx
  803694:	89 da                	mov    %ebx,%edx
  803696:	f7 f7                	div    %edi
  803698:	89 d3                	mov    %edx,%ebx
  80369a:	f7 24 24             	mull   (%esp)
  80369d:	89 c6                	mov    %eax,%esi
  80369f:	89 d1                	mov    %edx,%ecx
  8036a1:	39 d3                	cmp    %edx,%ebx
  8036a3:	0f 82 87 00 00 00    	jb     803730 <__umoddi3+0x134>
  8036a9:	0f 84 91 00 00 00    	je     803740 <__umoddi3+0x144>
  8036af:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036b3:	29 f2                	sub    %esi,%edx
  8036b5:	19 cb                	sbb    %ecx,%ebx
  8036b7:	89 d8                	mov    %ebx,%eax
  8036b9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036bd:	d3 e0                	shl    %cl,%eax
  8036bf:	89 e9                	mov    %ebp,%ecx
  8036c1:	d3 ea                	shr    %cl,%edx
  8036c3:	09 d0                	or     %edx,%eax
  8036c5:	89 e9                	mov    %ebp,%ecx
  8036c7:	d3 eb                	shr    %cl,%ebx
  8036c9:	89 da                	mov    %ebx,%edx
  8036cb:	83 c4 1c             	add    $0x1c,%esp
  8036ce:	5b                   	pop    %ebx
  8036cf:	5e                   	pop    %esi
  8036d0:	5f                   	pop    %edi
  8036d1:	5d                   	pop    %ebp
  8036d2:	c3                   	ret    
  8036d3:	90                   	nop
  8036d4:	89 fd                	mov    %edi,%ebp
  8036d6:	85 ff                	test   %edi,%edi
  8036d8:	75 0b                	jne    8036e5 <__umoddi3+0xe9>
  8036da:	b8 01 00 00 00       	mov    $0x1,%eax
  8036df:	31 d2                	xor    %edx,%edx
  8036e1:	f7 f7                	div    %edi
  8036e3:	89 c5                	mov    %eax,%ebp
  8036e5:	89 f0                	mov    %esi,%eax
  8036e7:	31 d2                	xor    %edx,%edx
  8036e9:	f7 f5                	div    %ebp
  8036eb:	89 c8                	mov    %ecx,%eax
  8036ed:	f7 f5                	div    %ebp
  8036ef:	89 d0                	mov    %edx,%eax
  8036f1:	e9 44 ff ff ff       	jmp    80363a <__umoddi3+0x3e>
  8036f6:	66 90                	xchg   %ax,%ax
  8036f8:	89 c8                	mov    %ecx,%eax
  8036fa:	89 f2                	mov    %esi,%edx
  8036fc:	83 c4 1c             	add    $0x1c,%esp
  8036ff:	5b                   	pop    %ebx
  803700:	5e                   	pop    %esi
  803701:	5f                   	pop    %edi
  803702:	5d                   	pop    %ebp
  803703:	c3                   	ret    
  803704:	3b 04 24             	cmp    (%esp),%eax
  803707:	72 06                	jb     80370f <__umoddi3+0x113>
  803709:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80370d:	77 0f                	ja     80371e <__umoddi3+0x122>
  80370f:	89 f2                	mov    %esi,%edx
  803711:	29 f9                	sub    %edi,%ecx
  803713:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803717:	89 14 24             	mov    %edx,(%esp)
  80371a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80371e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803722:	8b 14 24             	mov    (%esp),%edx
  803725:	83 c4 1c             	add    $0x1c,%esp
  803728:	5b                   	pop    %ebx
  803729:	5e                   	pop    %esi
  80372a:	5f                   	pop    %edi
  80372b:	5d                   	pop    %ebp
  80372c:	c3                   	ret    
  80372d:	8d 76 00             	lea    0x0(%esi),%esi
  803730:	2b 04 24             	sub    (%esp),%eax
  803733:	19 fa                	sbb    %edi,%edx
  803735:	89 d1                	mov    %edx,%ecx
  803737:	89 c6                	mov    %eax,%esi
  803739:	e9 71 ff ff ff       	jmp    8036af <__umoddi3+0xb3>
  80373e:	66 90                	xchg   %ax,%ax
  803740:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803744:	72 ea                	jb     803730 <__umoddi3+0x134>
  803746:	89 d9                	mov    %ebx,%ecx
  803748:	e9 62 ff ff ff       	jmp    8036af <__umoddi3+0xb3>
