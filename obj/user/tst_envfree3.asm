
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
  800045:	68 c0 36 80 00       	push   $0x8036c0
  80004a:	e8 53 15 00 00       	call   8015a2 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 7f 17 00 00       	call   8017e2 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 17 18 00 00       	call   801882 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 36 80 00       	push   $0x8036d0
  800079:	e8 07 05 00 00       	call   800585 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 03 37 80 00       	push   $0x803703
  800099:	e8 b6 19 00 00       	call   801a54 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 0c 37 80 00       	push   $0x80370c
  8000bc:	e8 93 19 00 00       	call   801a54 <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 a0 19 00 00       	call   801a72 <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 c2 32 00 00       	call   8033a4 <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 82 19 00 00       	call   801a72 <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 df 16 00 00       	call   8017e2 <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 18 37 80 00       	push   $0x803718
  80010c:	e8 74 04 00 00       	call   800585 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 6f 19 00 00       	call   801a8e <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 61 19 00 00       	call   801a8e <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 ad 16 00 00       	call   8017e2 <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 45 17 00 00       	call   801882 <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 4c 37 80 00       	push   $0x80374c
  800153:	e8 2d 04 00 00       	call   800585 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 9c 37 80 00       	push   $0x80379c
  800163:	6a 23                	push   $0x23
  800165:	68 d2 37 80 00       	push   $0x8037d2
  80016a:	e8 62 01 00 00       	call   8002d1 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 e8 37 80 00       	push   $0x8037e8
  80017a:	e8 06 04 00 00       	call   800585 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 48 38 80 00       	push   $0x803848
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
  80019b:	e8 22 19 00 00       	call   801ac2 <sys_getenvindex>
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
  800206:	e8 c4 16 00 00       	call   8018cf <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 ac 38 80 00       	push   $0x8038ac
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
  800236:	68 d4 38 80 00       	push   $0x8038d4
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
  800267:	68 fc 38 80 00       	push   $0x8038fc
  80026c:	e8 14 03 00 00       	call   800585 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 54 39 80 00       	push   $0x803954
  800288:	e8 f8 02 00 00       	call   800585 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 ac 38 80 00       	push   $0x8038ac
  800298:	e8 e8 02 00 00       	call   800585 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a0:	e8 44 16 00 00       	call   8018e9 <sys_enable_interrupt>

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
  8002b8:	e8 d1 17 00 00       	call   801a8e <sys_destroy_env>
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
  8002c9:	e8 26 18 00 00       	call   801af4 <sys_exit_env>
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
  8002f2:	68 68 39 80 00       	push   $0x803968
  8002f7:	e8 89 02 00 00       	call   800585 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ff:	a1 00 50 80 00       	mov    0x805000,%eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	50                   	push   %eax
  80030b:	68 6d 39 80 00       	push   $0x80396d
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
  80032f:	68 89 39 80 00       	push   $0x803989
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
  80035b:	68 8c 39 80 00       	push   $0x80398c
  800360:	6a 26                	push   $0x26
  800362:	68 d8 39 80 00       	push   $0x8039d8
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
  80042d:	68 e4 39 80 00       	push   $0x8039e4
  800432:	6a 3a                	push   $0x3a
  800434:	68 d8 39 80 00       	push   $0x8039d8
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
  80049d:	68 38 3a 80 00       	push   $0x803a38
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 d8 39 80 00       	push   $0x8039d8
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
  8004f7:	e8 25 12 00 00       	call   801721 <sys_cputs>
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
  80056e:	e8 ae 11 00 00       	call   801721 <sys_cputs>
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
  8005b8:	e8 12 13 00 00       	call   8018cf <sys_disable_interrupt>
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
  8005d8:	e8 0c 13 00 00       	call   8018e9 <sys_enable_interrupt>
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
  800622:	e8 31 2e 00 00       	call   803458 <__udivdi3>
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
  800672:	e8 f1 2e 00 00       	call   803568 <__umoddi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	05 b4 3c 80 00       	add    $0x803cb4,%eax
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
  8007cd:	8b 04 85 d8 3c 80 00 	mov    0x803cd8(,%eax,4),%eax
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
  8008ae:	8b 34 9d 20 3b 80 00 	mov    0x803b20(,%ebx,4),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 19                	jne    8008d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b9:	53                   	push   %ebx
  8008ba:	68 c5 3c 80 00       	push   $0x803cc5
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
  8008d3:	68 ce 3c 80 00       	push   $0x803cce
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
  800900:	be d1 3c 80 00       	mov    $0x803cd1,%esi
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
  801326:	68 30 3e 80 00       	push   $0x803e30
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
  8013f6:	e8 6a 04 00 00       	call   801865 <sys_allocate_chunk>
  8013fb:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013fe:	a1 20 51 80 00       	mov    0x805120,%eax
  801403:	83 ec 0c             	sub    $0xc,%esp
  801406:	50                   	push   %eax
  801407:	e8 df 0a 00 00       	call   801eeb <initialize_MemBlocksList>
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
  801434:	68 55 3e 80 00       	push   $0x803e55
  801439:	6a 33                	push   $0x33
  80143b:	68 73 3e 80 00       	push   $0x803e73
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
  8014b3:	68 80 3e 80 00       	push   $0x803e80
  8014b8:	6a 34                	push   $0x34
  8014ba:	68 73 3e 80 00       	push   $0x803e73
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
  80154b:	e8 e3 06 00 00       	call   801c33 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801550:	85 c0                	test   %eax,%eax
  801552:	74 11                	je     801565 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801554:	83 ec 0c             	sub    $0xc,%esp
  801557:	ff 75 e8             	pushl  -0x18(%ebp)
  80155a:	e8 4e 0d 00 00       	call   8022ad <alloc_block_FF>
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
  801571:	e8 aa 0a 00 00       	call   802020 <insert_sorted_allocList>
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
  801591:	68 a4 3e 80 00       	push   $0x803ea4
  801596:	6a 6f                	push   $0x6f
  801598:	68 73 3e 80 00       	push   $0x803e73
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
  8015b7:	75 07                	jne    8015c0 <smalloc+0x1e>
  8015b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015be:	eb 7c                	jmp    80163c <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
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
  8015ed:	e8 41 06 00 00       	call   801c33 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	74 11                	je     801607 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8015f6:	83 ec 0c             	sub    $0xc,%esp
  8015f9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015fc:	e8 ac 0c 00 00       	call   8022ad <alloc_block_FF>
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80160b:	74 2a                	je     801637 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80160d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801610:	8b 40 08             	mov    0x8(%eax),%eax
  801613:	89 c2                	mov    %eax,%edx
  801615:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801619:	52                   	push   %edx
  80161a:	50                   	push   %eax
  80161b:	ff 75 0c             	pushl  0xc(%ebp)
  80161e:	ff 75 08             	pushl  0x8(%ebp)
  801621:	e8 92 03 00 00       	call   8019b8 <sys_createSharedObject>
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80162c:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801630:	74 05                	je     801637 <smalloc+0x95>
			return (void*)virtual_address;
  801632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801635:	eb 05                	jmp    80163c <smalloc+0x9a>
	}
	return NULL;
  801637:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80163c:	c9                   	leave  
  80163d:	c3                   	ret    

0080163e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801644:	e8 c6 fc ff ff       	call   80130f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	68 c8 3e 80 00       	push   $0x803ec8
  801651:	68 b0 00 00 00       	push   $0xb0
  801656:	68 73 3e 80 00       	push   $0x803e73
  80165b:	e8 71 ec ff ff       	call   8002d1 <_panic>

00801660 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801666:	e8 a4 fc ff ff       	call   80130f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80166b:	83 ec 04             	sub    $0x4,%esp
  80166e:	68 ec 3e 80 00       	push   $0x803eec
  801673:	68 f4 00 00 00       	push   $0xf4
  801678:	68 73 3e 80 00       	push   $0x803e73
  80167d:	e8 4f ec ff ff       	call   8002d1 <_panic>

00801682 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
  801685:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	68 14 3f 80 00       	push   $0x803f14
  801690:	68 08 01 00 00       	push   $0x108
  801695:	68 73 3e 80 00       	push   $0x803e73
  80169a:	e8 32 ec ff ff       	call   8002d1 <_panic>

0080169f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016a5:	83 ec 04             	sub    $0x4,%esp
  8016a8:	68 38 3f 80 00       	push   $0x803f38
  8016ad:	68 13 01 00 00       	push   $0x113
  8016b2:	68 73 3e 80 00       	push   $0x803e73
  8016b7:	e8 15 ec ff ff       	call   8002d1 <_panic>

008016bc <shrink>:

}
void shrink(uint32 newSize)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016c2:	83 ec 04             	sub    $0x4,%esp
  8016c5:	68 38 3f 80 00       	push   $0x803f38
  8016ca:	68 18 01 00 00       	push   $0x118
  8016cf:	68 73 3e 80 00       	push   $0x803e73
  8016d4:	e8 f8 eb ff ff       	call   8002d1 <_panic>

008016d9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016df:	83 ec 04             	sub    $0x4,%esp
  8016e2:	68 38 3f 80 00       	push   $0x803f38
  8016e7:	68 1d 01 00 00       	push   $0x11d
  8016ec:	68 73 3e 80 00       	push   $0x803e73
  8016f1:	e8 db eb ff ff       	call   8002d1 <_panic>

008016f6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	57                   	push   %edi
  8016fa:	56                   	push   %esi
  8016fb:	53                   	push   %ebx
  8016fc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8b 55 0c             	mov    0xc(%ebp),%edx
  801705:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801708:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80170b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80170e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801711:	cd 30                	int    $0x30
  801713:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801716:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	5b                   	pop    %ebx
  80171d:	5e                   	pop    %esi
  80171e:	5f                   	pop    %edi
  80171f:	5d                   	pop    %ebp
  801720:	c3                   	ret    

00801721 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	8b 45 10             	mov    0x10(%ebp),%eax
  80172a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80172d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	52                   	push   %edx
  801739:	ff 75 0c             	pushl  0xc(%ebp)
  80173c:	50                   	push   %eax
  80173d:	6a 00                	push   $0x0
  80173f:	e8 b2 ff ff ff       	call   8016f6 <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
}
  801747:	90                   	nop
  801748:	c9                   	leave  
  801749:	c3                   	ret    

0080174a <sys_cgetc>:

int
sys_cgetc(void)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 01                	push   $0x1
  801759:	e8 98 ff ff ff       	call   8016f6 <syscall>
  80175e:	83 c4 18             	add    $0x18,%esp
}
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801766:	8b 55 0c             	mov    0xc(%ebp),%edx
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	6a 05                	push   $0x5
  801776:	e8 7b ff ff ff       	call   8016f6 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	56                   	push   %esi
  801784:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801785:	8b 75 18             	mov    0x18(%ebp),%esi
  801788:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80178b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	56                   	push   %esi
  801795:	53                   	push   %ebx
  801796:	51                   	push   %ecx
  801797:	52                   	push   %edx
  801798:	50                   	push   %eax
  801799:	6a 06                	push   $0x6
  80179b:	e8 56 ff ff ff       	call   8016f6 <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    

008017aa <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	52                   	push   %edx
  8017ba:	50                   	push   %eax
  8017bb:	6a 07                	push   $0x7
  8017bd:	e8 34 ff ff ff       	call   8016f6 <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	ff 75 08             	pushl  0x8(%ebp)
  8017d6:	6a 08                	push   $0x8
  8017d8:	e8 19 ff ff ff       	call   8016f6 <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 09                	push   $0x9
  8017f1:	e8 00 ff ff ff       	call   8016f6 <syscall>
  8017f6:	83 c4 18             	add    $0x18,%esp
}
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    

008017fb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 0a                	push   $0xa
  80180a:	e8 e7 fe ff ff       	call   8016f6 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 0b                	push   $0xb
  801823:	e8 ce fe ff ff       	call   8016f6 <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	ff 75 08             	pushl  0x8(%ebp)
  80183c:	6a 0f                	push   $0xf
  80183e:	e8 b3 fe ff ff       	call   8016f6 <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
	return;
  801846:	90                   	nop
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	ff 75 0c             	pushl  0xc(%ebp)
  801855:	ff 75 08             	pushl  0x8(%ebp)
  801858:	6a 10                	push   $0x10
  80185a:	e8 97 fe ff ff       	call   8016f6 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
	return ;
  801862:	90                   	nop
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	ff 75 10             	pushl  0x10(%ebp)
  80186f:	ff 75 0c             	pushl  0xc(%ebp)
  801872:	ff 75 08             	pushl  0x8(%ebp)
  801875:	6a 11                	push   $0x11
  801877:	e8 7a fe ff ff       	call   8016f6 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
	return ;
  80187f:	90                   	nop
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 0c                	push   $0xc
  801891:	e8 60 fe ff ff       	call   8016f6 <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	ff 75 08             	pushl  0x8(%ebp)
  8018a9:	6a 0d                	push   $0xd
  8018ab:	e8 46 fe ff ff       	call   8016f6 <syscall>
  8018b0:	83 c4 18             	add    $0x18,%esp
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 0e                	push   $0xe
  8018c4:	e8 2d fe ff ff       	call   8016f6 <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	90                   	nop
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 13                	push   $0x13
  8018de:	e8 13 fe ff ff       	call   8016f6 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	90                   	nop
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 14                	push   $0x14
  8018f8:	e8 f9 fd ff ff       	call   8016f6 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	90                   	nop
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_cputc>:


void
sys_cputc(const char c)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80190f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	50                   	push   %eax
  80191c:	6a 15                	push   $0x15
  80191e:	e8 d3 fd ff ff       	call   8016f6 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	90                   	nop
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 16                	push   $0x16
  801938:	e8 b9 fd ff ff       	call   8016f6 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	90                   	nop
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	ff 75 0c             	pushl  0xc(%ebp)
  801952:	50                   	push   %eax
  801953:	6a 17                	push   $0x17
  801955:	e8 9c fd ff ff       	call   8016f6 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801962:	8b 55 0c             	mov    0xc(%ebp),%edx
  801965:	8b 45 08             	mov    0x8(%ebp),%eax
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	52                   	push   %edx
  80196f:	50                   	push   %eax
  801970:	6a 1a                	push   $0x1a
  801972:	e8 7f fd ff ff       	call   8016f6 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80197f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	52                   	push   %edx
  80198c:	50                   	push   %eax
  80198d:	6a 18                	push   $0x18
  80198f:	e8 62 fd ff ff       	call   8016f6 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	90                   	nop
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80199d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	52                   	push   %edx
  8019aa:	50                   	push   %eax
  8019ab:	6a 19                	push   $0x19
  8019ad:	e8 44 fd ff ff       	call   8016f6 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	90                   	nop
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 04             	sub    $0x4,%esp
  8019be:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019c4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019c7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	6a 00                	push   $0x0
  8019d0:	51                   	push   %ecx
  8019d1:	52                   	push   %edx
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	50                   	push   %eax
  8019d6:	6a 1b                	push   $0x1b
  8019d8:	e8 19 fd ff ff       	call   8016f6 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	52                   	push   %edx
  8019f2:	50                   	push   %eax
  8019f3:	6a 1c                	push   $0x1c
  8019f5:	e8 fc fc ff ff       	call   8016f6 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	51                   	push   %ecx
  801a10:	52                   	push   %edx
  801a11:	50                   	push   %eax
  801a12:	6a 1d                	push   $0x1d
  801a14:	e8 dd fc ff ff       	call   8016f6 <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	52                   	push   %edx
  801a2e:	50                   	push   %eax
  801a2f:	6a 1e                	push   $0x1e
  801a31:	e8 c0 fc ff ff       	call   8016f6 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 1f                	push   $0x1f
  801a4a:	e8 a7 fc ff ff       	call   8016f6 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	6a 00                	push   $0x0
  801a5c:	ff 75 14             	pushl  0x14(%ebp)
  801a5f:	ff 75 10             	pushl  0x10(%ebp)
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	50                   	push   %eax
  801a66:	6a 20                	push   $0x20
  801a68:	e8 89 fc ff ff       	call   8016f6 <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	50                   	push   %eax
  801a81:	6a 21                	push   $0x21
  801a83:	e8 6e fc ff ff       	call   8016f6 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	90                   	nop
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	50                   	push   %eax
  801a9d:	6a 22                	push   $0x22
  801a9f:	e8 52 fc ff ff       	call   8016f6 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 02                	push   $0x2
  801ab8:	e8 39 fc ff ff       	call   8016f6 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 03                	push   $0x3
  801ad1:	e8 20 fc ff ff       	call   8016f6 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 04                	push   $0x4
  801aea:	e8 07 fc ff ff       	call   8016f6 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_exit_env>:


void sys_exit_env(void)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 23                	push   $0x23
  801b03:	e8 ee fb ff ff       	call   8016f6 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	90                   	nop
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b14:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b17:	8d 50 04             	lea    0x4(%eax),%edx
  801b1a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	52                   	push   %edx
  801b24:	50                   	push   %eax
  801b25:	6a 24                	push   $0x24
  801b27:	e8 ca fb ff ff       	call   8016f6 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
	return result;
  801b2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b32:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b35:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b38:	89 01                	mov    %eax,(%ecx)
  801b3a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	c9                   	leave  
  801b41:	c2 04 00             	ret    $0x4

00801b44 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	ff 75 10             	pushl  0x10(%ebp)
  801b4e:	ff 75 0c             	pushl  0xc(%ebp)
  801b51:	ff 75 08             	pushl  0x8(%ebp)
  801b54:	6a 12                	push   $0x12
  801b56:	e8 9b fb ff ff       	call   8016f6 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5e:	90                   	nop
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 25                	push   $0x25
  801b70:	e8 81 fb ff ff       	call   8016f6 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 04             	sub    $0x4,%esp
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b86:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	50                   	push   %eax
  801b93:	6a 26                	push   $0x26
  801b95:	e8 5c fb ff ff       	call   8016f6 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9d:	90                   	nop
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <rsttst>:
void rsttst()
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 28                	push   $0x28
  801baf:	e8 42 fb ff ff       	call   8016f6 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb7:	90                   	nop
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bc6:	8b 55 18             	mov    0x18(%ebp),%edx
  801bc9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bcd:	52                   	push   %edx
  801bce:	50                   	push   %eax
  801bcf:	ff 75 10             	pushl  0x10(%ebp)
  801bd2:	ff 75 0c             	pushl  0xc(%ebp)
  801bd5:	ff 75 08             	pushl  0x8(%ebp)
  801bd8:	6a 27                	push   $0x27
  801bda:	e8 17 fb ff ff       	call   8016f6 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801be2:	90                   	nop
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <chktst>:
void chktst(uint32 n)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	ff 75 08             	pushl  0x8(%ebp)
  801bf3:	6a 29                	push   $0x29
  801bf5:	e8 fc fa ff ff       	call   8016f6 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfd:	90                   	nop
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <inctst>:

void inctst()
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 2a                	push   $0x2a
  801c0f:	e8 e2 fa ff ff       	call   8016f6 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
	return ;
  801c17:	90                   	nop
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <gettst>:
uint32 gettst()
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 2b                	push   $0x2b
  801c29:	e8 c8 fa ff ff       	call   8016f6 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 2c                	push   $0x2c
  801c45:	e8 ac fa ff ff       	call   8016f6 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
  801c4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c50:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c54:	75 07                	jne    801c5d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c56:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5b:	eb 05                	jmp    801c62 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 2c                	push   $0x2c
  801c76:	e8 7b fa ff ff       	call   8016f6 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
  801c7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c81:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c85:	75 07                	jne    801c8e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c87:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8c:	eb 05                	jmp    801c93 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 2c                	push   $0x2c
  801ca7:	e8 4a fa ff ff       	call   8016f6 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
  801caf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cb2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cb6:	75 07                	jne    801cbf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cb8:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbd:	eb 05                	jmp    801cc4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 2c                	push   $0x2c
  801cd8:	e8 19 fa ff ff       	call   8016f6 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
  801ce0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ce3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ce7:	75 07                	jne    801cf0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ce9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cee:	eb 05                	jmp    801cf5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	ff 75 08             	pushl  0x8(%ebp)
  801d05:	6a 2d                	push   $0x2d
  801d07:	e8 ea f9 ff ff       	call   8016f6 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0f:	90                   	nop
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d16:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	6a 00                	push   $0x0
  801d24:	53                   	push   %ebx
  801d25:	51                   	push   %ecx
  801d26:	52                   	push   %edx
  801d27:	50                   	push   %eax
  801d28:	6a 2e                	push   $0x2e
  801d2a:	e8 c7 f9 ff ff       	call   8016f6 <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
}
  801d32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	52                   	push   %edx
  801d47:	50                   	push   %eax
  801d48:	6a 2f                	push   $0x2f
  801d4a:	e8 a7 f9 ff ff       	call   8016f6 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d5a:	83 ec 0c             	sub    $0xc,%esp
  801d5d:	68 48 3f 80 00       	push   $0x803f48
  801d62:	e8 1e e8 ff ff       	call   800585 <cprintf>
  801d67:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d71:	83 ec 0c             	sub    $0xc,%esp
  801d74:	68 74 3f 80 00       	push   $0x803f74
  801d79:	e8 07 e8 ff ff       	call   800585 <cprintf>
  801d7e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d81:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d85:	a1 38 51 80 00       	mov    0x805138,%eax
  801d8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d8d:	eb 56                	jmp    801de5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d93:	74 1c                	je     801db1 <print_mem_block_lists+0x5d>
  801d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d98:	8b 50 08             	mov    0x8(%eax),%edx
  801d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9e:	8b 48 08             	mov    0x8(%eax),%ecx
  801da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da4:	8b 40 0c             	mov    0xc(%eax),%eax
  801da7:	01 c8                	add    %ecx,%eax
  801da9:	39 c2                	cmp    %eax,%edx
  801dab:	73 04                	jae    801db1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801dad:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db4:	8b 50 08             	mov    0x8(%eax),%edx
  801db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dba:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbd:	01 c2                	add    %eax,%edx
  801dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc2:	8b 40 08             	mov    0x8(%eax),%eax
  801dc5:	83 ec 04             	sub    $0x4,%esp
  801dc8:	52                   	push   %edx
  801dc9:	50                   	push   %eax
  801dca:	68 89 3f 80 00       	push   $0x803f89
  801dcf:	e8 b1 e7 ff ff       	call   800585 <cprintf>
  801dd4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ddd:	a1 40 51 80 00       	mov    0x805140,%eax
  801de2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de9:	74 07                	je     801df2 <print_mem_block_lists+0x9e>
  801deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dee:	8b 00                	mov    (%eax),%eax
  801df0:	eb 05                	jmp    801df7 <print_mem_block_lists+0xa3>
  801df2:	b8 00 00 00 00       	mov    $0x0,%eax
  801df7:	a3 40 51 80 00       	mov    %eax,0x805140
  801dfc:	a1 40 51 80 00       	mov    0x805140,%eax
  801e01:	85 c0                	test   %eax,%eax
  801e03:	75 8a                	jne    801d8f <print_mem_block_lists+0x3b>
  801e05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e09:	75 84                	jne    801d8f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e0b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e0f:	75 10                	jne    801e21 <print_mem_block_lists+0xcd>
  801e11:	83 ec 0c             	sub    $0xc,%esp
  801e14:	68 98 3f 80 00       	push   $0x803f98
  801e19:	e8 67 e7 ff ff       	call   800585 <cprintf>
  801e1e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e21:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	68 bc 3f 80 00       	push   $0x803fbc
  801e30:	e8 50 e7 ff ff       	call   800585 <cprintf>
  801e35:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e38:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e3c:	a1 40 50 80 00       	mov    0x805040,%eax
  801e41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e44:	eb 56                	jmp    801e9c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e4a:	74 1c                	je     801e68 <print_mem_block_lists+0x114>
  801e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4f:	8b 50 08             	mov    0x8(%eax),%edx
  801e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e55:	8b 48 08             	mov    0x8(%eax),%ecx
  801e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e5e:	01 c8                	add    %ecx,%eax
  801e60:	39 c2                	cmp    %eax,%edx
  801e62:	73 04                	jae    801e68 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e64:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6b:	8b 50 08             	mov    0x8(%eax),%edx
  801e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e71:	8b 40 0c             	mov    0xc(%eax),%eax
  801e74:	01 c2                	add    %eax,%edx
  801e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e79:	8b 40 08             	mov    0x8(%eax),%eax
  801e7c:	83 ec 04             	sub    $0x4,%esp
  801e7f:	52                   	push   %edx
  801e80:	50                   	push   %eax
  801e81:	68 89 3f 80 00       	push   $0x803f89
  801e86:	e8 fa e6 ff ff       	call   800585 <cprintf>
  801e8b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e94:	a1 48 50 80 00       	mov    0x805048,%eax
  801e99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea0:	74 07                	je     801ea9 <print_mem_block_lists+0x155>
  801ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea5:	8b 00                	mov    (%eax),%eax
  801ea7:	eb 05                	jmp    801eae <print_mem_block_lists+0x15a>
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eae:	a3 48 50 80 00       	mov    %eax,0x805048
  801eb3:	a1 48 50 80 00       	mov    0x805048,%eax
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	75 8a                	jne    801e46 <print_mem_block_lists+0xf2>
  801ebc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec0:	75 84                	jne    801e46 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ec2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ec6:	75 10                	jne    801ed8 <print_mem_block_lists+0x184>
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	68 d4 3f 80 00       	push   $0x803fd4
  801ed0:	e8 b0 e6 ff ff       	call   800585 <cprintf>
  801ed5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ed8:	83 ec 0c             	sub    $0xc,%esp
  801edb:	68 48 3f 80 00       	push   $0x803f48
  801ee0:	e8 a0 e6 ff ff       	call   800585 <cprintf>
  801ee5:	83 c4 10             	add    $0x10,%esp

}
  801ee8:	90                   	nop
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ef1:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ef8:	00 00 00 
  801efb:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f02:	00 00 00 
  801f05:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f0c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f16:	e9 9e 00 00 00       	jmp    801fb9 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f1b:	a1 50 50 80 00       	mov    0x805050,%eax
  801f20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f23:	c1 e2 04             	shl    $0x4,%edx
  801f26:	01 d0                	add    %edx,%eax
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	75 14                	jne    801f40 <initialize_MemBlocksList+0x55>
  801f2c:	83 ec 04             	sub    $0x4,%esp
  801f2f:	68 fc 3f 80 00       	push   $0x803ffc
  801f34:	6a 46                	push   $0x46
  801f36:	68 1f 40 80 00       	push   $0x80401f
  801f3b:	e8 91 e3 ff ff       	call   8002d1 <_panic>
  801f40:	a1 50 50 80 00       	mov    0x805050,%eax
  801f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f48:	c1 e2 04             	shl    $0x4,%edx
  801f4b:	01 d0                	add    %edx,%eax
  801f4d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f53:	89 10                	mov    %edx,(%eax)
  801f55:	8b 00                	mov    (%eax),%eax
  801f57:	85 c0                	test   %eax,%eax
  801f59:	74 18                	je     801f73 <initialize_MemBlocksList+0x88>
  801f5b:	a1 48 51 80 00       	mov    0x805148,%eax
  801f60:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f66:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f69:	c1 e1 04             	shl    $0x4,%ecx
  801f6c:	01 ca                	add    %ecx,%edx
  801f6e:	89 50 04             	mov    %edx,0x4(%eax)
  801f71:	eb 12                	jmp    801f85 <initialize_MemBlocksList+0x9a>
  801f73:	a1 50 50 80 00       	mov    0x805050,%eax
  801f78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7b:	c1 e2 04             	shl    $0x4,%edx
  801f7e:	01 d0                	add    %edx,%eax
  801f80:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f85:	a1 50 50 80 00       	mov    0x805050,%eax
  801f8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8d:	c1 e2 04             	shl    $0x4,%edx
  801f90:	01 d0                	add    %edx,%eax
  801f92:	a3 48 51 80 00       	mov    %eax,0x805148
  801f97:	a1 50 50 80 00       	mov    0x805050,%eax
  801f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9f:	c1 e2 04             	shl    $0x4,%edx
  801fa2:	01 d0                	add    %edx,%eax
  801fa4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fab:	a1 54 51 80 00       	mov    0x805154,%eax
  801fb0:	40                   	inc    %eax
  801fb1:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fb6:	ff 45 f4             	incl   -0xc(%ebp)
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fbf:	0f 82 56 ff ff ff    	jb     801f1b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fc5:	90                   	nop
  801fc6:	c9                   	leave  
  801fc7:	c3                   	ret    

00801fc8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	8b 00                	mov    (%eax),%eax
  801fd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fd6:	eb 19                	jmp    801ff1 <find_block+0x29>
	{
		if(va==point->sva)
  801fd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fdb:	8b 40 08             	mov    0x8(%eax),%eax
  801fde:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fe1:	75 05                	jne    801fe8 <find_block+0x20>
		   return point;
  801fe3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe6:	eb 36                	jmp    80201e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	8b 40 08             	mov    0x8(%eax),%eax
  801fee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ff1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ff5:	74 07                	je     801ffe <find_block+0x36>
  801ff7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ffa:	8b 00                	mov    (%eax),%eax
  801ffc:	eb 05                	jmp    802003 <find_block+0x3b>
  801ffe:	b8 00 00 00 00       	mov    $0x0,%eax
  802003:	8b 55 08             	mov    0x8(%ebp),%edx
  802006:	89 42 08             	mov    %eax,0x8(%edx)
  802009:	8b 45 08             	mov    0x8(%ebp),%eax
  80200c:	8b 40 08             	mov    0x8(%eax),%eax
  80200f:	85 c0                	test   %eax,%eax
  802011:	75 c5                	jne    801fd8 <find_block+0x10>
  802013:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802017:	75 bf                	jne    801fd8 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802019:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802026:	a1 40 50 80 00       	mov    0x805040,%eax
  80202b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80202e:	a1 44 50 80 00       	mov    0x805044,%eax
  802033:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802039:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80203c:	74 24                	je     802062 <insert_sorted_allocList+0x42>
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	8b 50 08             	mov    0x8(%eax),%edx
  802044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802047:	8b 40 08             	mov    0x8(%eax),%eax
  80204a:	39 c2                	cmp    %eax,%edx
  80204c:	76 14                	jbe    802062 <insert_sorted_allocList+0x42>
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	8b 50 08             	mov    0x8(%eax),%edx
  802054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802057:	8b 40 08             	mov    0x8(%eax),%eax
  80205a:	39 c2                	cmp    %eax,%edx
  80205c:	0f 82 60 01 00 00    	jb     8021c2 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802062:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802066:	75 65                	jne    8020cd <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802068:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80206c:	75 14                	jne    802082 <insert_sorted_allocList+0x62>
  80206e:	83 ec 04             	sub    $0x4,%esp
  802071:	68 fc 3f 80 00       	push   $0x803ffc
  802076:	6a 6b                	push   $0x6b
  802078:	68 1f 40 80 00       	push   $0x80401f
  80207d:	e8 4f e2 ff ff       	call   8002d1 <_panic>
  802082:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	89 10                	mov    %edx,(%eax)
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	8b 00                	mov    (%eax),%eax
  802092:	85 c0                	test   %eax,%eax
  802094:	74 0d                	je     8020a3 <insert_sorted_allocList+0x83>
  802096:	a1 40 50 80 00       	mov    0x805040,%eax
  80209b:	8b 55 08             	mov    0x8(%ebp),%edx
  80209e:	89 50 04             	mov    %edx,0x4(%eax)
  8020a1:	eb 08                	jmp    8020ab <insert_sorted_allocList+0x8b>
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	a3 44 50 80 00       	mov    %eax,0x805044
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	a3 40 50 80 00       	mov    %eax,0x805040
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020bd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020c2:	40                   	inc    %eax
  8020c3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020c8:	e9 dc 01 00 00       	jmp    8022a9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	8b 50 08             	mov    0x8(%eax),%edx
  8020d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d6:	8b 40 08             	mov    0x8(%eax),%eax
  8020d9:	39 c2                	cmp    %eax,%edx
  8020db:	77 6c                	ja     802149 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020e1:	74 06                	je     8020e9 <insert_sorted_allocList+0xc9>
  8020e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020e7:	75 14                	jne    8020fd <insert_sorted_allocList+0xdd>
  8020e9:	83 ec 04             	sub    $0x4,%esp
  8020ec:	68 38 40 80 00       	push   $0x804038
  8020f1:	6a 6f                	push   $0x6f
  8020f3:	68 1f 40 80 00       	push   $0x80401f
  8020f8:	e8 d4 e1 ff ff       	call   8002d1 <_panic>
  8020fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802100:	8b 50 04             	mov    0x4(%eax),%edx
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	89 50 04             	mov    %edx,0x4(%eax)
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80210f:	89 10                	mov    %edx,(%eax)
  802111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802114:	8b 40 04             	mov    0x4(%eax),%eax
  802117:	85 c0                	test   %eax,%eax
  802119:	74 0d                	je     802128 <insert_sorted_allocList+0x108>
  80211b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211e:	8b 40 04             	mov    0x4(%eax),%eax
  802121:	8b 55 08             	mov    0x8(%ebp),%edx
  802124:	89 10                	mov    %edx,(%eax)
  802126:	eb 08                	jmp    802130 <insert_sorted_allocList+0x110>
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	a3 40 50 80 00       	mov    %eax,0x805040
  802130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802133:	8b 55 08             	mov    0x8(%ebp),%edx
  802136:	89 50 04             	mov    %edx,0x4(%eax)
  802139:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80213e:	40                   	inc    %eax
  80213f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802144:	e9 60 01 00 00       	jmp    8022a9 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8b 50 08             	mov    0x8(%eax),%edx
  80214f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802152:	8b 40 08             	mov    0x8(%eax),%eax
  802155:	39 c2                	cmp    %eax,%edx
  802157:	0f 82 4c 01 00 00    	jb     8022a9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80215d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802161:	75 14                	jne    802177 <insert_sorted_allocList+0x157>
  802163:	83 ec 04             	sub    $0x4,%esp
  802166:	68 70 40 80 00       	push   $0x804070
  80216b:	6a 73                	push   $0x73
  80216d:	68 1f 40 80 00       	push   $0x80401f
  802172:	e8 5a e1 ff ff       	call   8002d1 <_panic>
  802177:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	89 50 04             	mov    %edx,0x4(%eax)
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	8b 40 04             	mov    0x4(%eax),%eax
  802189:	85 c0                	test   %eax,%eax
  80218b:	74 0c                	je     802199 <insert_sorted_allocList+0x179>
  80218d:	a1 44 50 80 00       	mov    0x805044,%eax
  802192:	8b 55 08             	mov    0x8(%ebp),%edx
  802195:	89 10                	mov    %edx,(%eax)
  802197:	eb 08                	jmp    8021a1 <insert_sorted_allocList+0x181>
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	a3 40 50 80 00       	mov    %eax,0x805040
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	a3 44 50 80 00       	mov    %eax,0x805044
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021b2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021b7:	40                   	inc    %eax
  8021b8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021bd:	e9 e7 00 00 00       	jmp    8022a9 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021cf:	a1 40 50 80 00       	mov    0x805040,%eax
  8021d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d7:	e9 9d 00 00 00       	jmp    802279 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021df:	8b 00                	mov    (%eax),%eax
  8021e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	8b 40 08             	mov    0x8(%eax),%eax
  8021f0:	39 c2                	cmp    %eax,%edx
  8021f2:	76 7d                	jbe    802271 <insert_sorted_allocList+0x251>
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	8b 50 08             	mov    0x8(%eax),%edx
  8021fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021fd:	8b 40 08             	mov    0x8(%eax),%eax
  802200:	39 c2                	cmp    %eax,%edx
  802202:	73 6d                	jae    802271 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802208:	74 06                	je     802210 <insert_sorted_allocList+0x1f0>
  80220a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80220e:	75 14                	jne    802224 <insert_sorted_allocList+0x204>
  802210:	83 ec 04             	sub    $0x4,%esp
  802213:	68 94 40 80 00       	push   $0x804094
  802218:	6a 7f                	push   $0x7f
  80221a:	68 1f 40 80 00       	push   $0x80401f
  80221f:	e8 ad e0 ff ff       	call   8002d1 <_panic>
  802224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802227:	8b 10                	mov    (%eax),%edx
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	89 10                	mov    %edx,(%eax)
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	8b 00                	mov    (%eax),%eax
  802233:	85 c0                	test   %eax,%eax
  802235:	74 0b                	je     802242 <insert_sorted_allocList+0x222>
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	8b 00                	mov    (%eax),%eax
  80223c:	8b 55 08             	mov    0x8(%ebp),%edx
  80223f:	89 50 04             	mov    %edx,0x4(%eax)
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 55 08             	mov    0x8(%ebp),%edx
  802248:	89 10                	mov    %edx,(%eax)
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802250:	89 50 04             	mov    %edx,0x4(%eax)
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	8b 00                	mov    (%eax),%eax
  802258:	85 c0                	test   %eax,%eax
  80225a:	75 08                	jne    802264 <insert_sorted_allocList+0x244>
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	a3 44 50 80 00       	mov    %eax,0x805044
  802264:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802269:	40                   	inc    %eax
  80226a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80226f:	eb 39                	jmp    8022aa <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802271:	a1 48 50 80 00       	mov    0x805048,%eax
  802276:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227d:	74 07                	je     802286 <insert_sorted_allocList+0x266>
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	8b 00                	mov    (%eax),%eax
  802284:	eb 05                	jmp    80228b <insert_sorted_allocList+0x26b>
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
  80228b:	a3 48 50 80 00       	mov    %eax,0x805048
  802290:	a1 48 50 80 00       	mov    0x805048,%eax
  802295:	85 c0                	test   %eax,%eax
  802297:	0f 85 3f ff ff ff    	jne    8021dc <insert_sorted_allocList+0x1bc>
  80229d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a1:	0f 85 35 ff ff ff    	jne    8021dc <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022a7:	eb 01                	jmp    8022aa <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022a9:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022aa:	90                   	nop
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8022b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022bb:	e9 85 01 00 00       	jmp    802445 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c9:	0f 82 6e 01 00 00    	jb     80243d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d8:	0f 85 8a 00 00 00    	jne    802368 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e2:	75 17                	jne    8022fb <alloc_block_FF+0x4e>
  8022e4:	83 ec 04             	sub    $0x4,%esp
  8022e7:	68 c8 40 80 00       	push   $0x8040c8
  8022ec:	68 93 00 00 00       	push   $0x93
  8022f1:	68 1f 40 80 00       	push   $0x80401f
  8022f6:	e8 d6 df ff ff       	call   8002d1 <_panic>
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 00                	mov    (%eax),%eax
  802300:	85 c0                	test   %eax,%eax
  802302:	74 10                	je     802314 <alloc_block_FF+0x67>
  802304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802307:	8b 00                	mov    (%eax),%eax
  802309:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230c:	8b 52 04             	mov    0x4(%edx),%edx
  80230f:	89 50 04             	mov    %edx,0x4(%eax)
  802312:	eb 0b                	jmp    80231f <alloc_block_FF+0x72>
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	8b 40 04             	mov    0x4(%eax),%eax
  80231a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	8b 40 04             	mov    0x4(%eax),%eax
  802325:	85 c0                	test   %eax,%eax
  802327:	74 0f                	je     802338 <alloc_block_FF+0x8b>
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	8b 40 04             	mov    0x4(%eax),%eax
  80232f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802332:	8b 12                	mov    (%edx),%edx
  802334:	89 10                	mov    %edx,(%eax)
  802336:	eb 0a                	jmp    802342 <alloc_block_FF+0x95>
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	8b 00                	mov    (%eax),%eax
  80233d:	a3 38 51 80 00       	mov    %eax,0x805138
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802355:	a1 44 51 80 00       	mov    0x805144,%eax
  80235a:	48                   	dec    %eax
  80235b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	e9 10 01 00 00       	jmp    802478 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 40 0c             	mov    0xc(%eax),%eax
  80236e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802371:	0f 86 c6 00 00 00    	jbe    80243d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802377:	a1 48 51 80 00       	mov    0x805148,%eax
  80237c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	8b 50 08             	mov    0x8(%eax),%edx
  802385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802388:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80238b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238e:	8b 55 08             	mov    0x8(%ebp),%edx
  802391:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802394:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802398:	75 17                	jne    8023b1 <alloc_block_FF+0x104>
  80239a:	83 ec 04             	sub    $0x4,%esp
  80239d:	68 c8 40 80 00       	push   $0x8040c8
  8023a2:	68 9b 00 00 00       	push   $0x9b
  8023a7:	68 1f 40 80 00       	push   $0x80401f
  8023ac:	e8 20 df ff ff       	call   8002d1 <_panic>
  8023b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b4:	8b 00                	mov    (%eax),%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	74 10                	je     8023ca <alloc_block_FF+0x11d>
  8023ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bd:	8b 00                	mov    (%eax),%eax
  8023bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023c2:	8b 52 04             	mov    0x4(%edx),%edx
  8023c5:	89 50 04             	mov    %edx,0x4(%eax)
  8023c8:	eb 0b                	jmp    8023d5 <alloc_block_FF+0x128>
  8023ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cd:	8b 40 04             	mov    0x4(%eax),%eax
  8023d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d8:	8b 40 04             	mov    0x4(%eax),%eax
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	74 0f                	je     8023ee <alloc_block_FF+0x141>
  8023df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e2:	8b 40 04             	mov    0x4(%eax),%eax
  8023e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e8:	8b 12                	mov    (%edx),%edx
  8023ea:	89 10                	mov    %edx,(%eax)
  8023ec:	eb 0a                	jmp    8023f8 <alloc_block_FF+0x14b>
  8023ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	a3 48 51 80 00       	mov    %eax,0x805148
  8023f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802404:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80240b:	a1 54 51 80 00       	mov    0x805154,%eax
  802410:	48                   	dec    %eax
  802411:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 50 08             	mov    0x8(%eax),%edx
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	01 c2                	add    %eax,%edx
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 40 0c             	mov    0xc(%eax),%eax
  80242d:	2b 45 08             	sub    0x8(%ebp),%eax
  802430:	89 c2                	mov    %eax,%edx
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243b:	eb 3b                	jmp    802478 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80243d:	a1 40 51 80 00       	mov    0x805140,%eax
  802442:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802445:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802449:	74 07                	je     802452 <alloc_block_FF+0x1a5>
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 00                	mov    (%eax),%eax
  802450:	eb 05                	jmp    802457 <alloc_block_FF+0x1aa>
  802452:	b8 00 00 00 00       	mov    $0x0,%eax
  802457:	a3 40 51 80 00       	mov    %eax,0x805140
  80245c:	a1 40 51 80 00       	mov    0x805140,%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	0f 85 57 fe ff ff    	jne    8022c0 <alloc_block_FF+0x13>
  802469:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246d:	0f 85 4d fe ff ff    	jne    8022c0 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802473:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802480:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802487:	a1 38 51 80 00       	mov    0x805138,%eax
  80248c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248f:	e9 df 00 00 00       	jmp    802573 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 40 0c             	mov    0xc(%eax),%eax
  80249a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249d:	0f 82 c8 00 00 00    	jb     80256b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ac:	0f 85 8a 00 00 00    	jne    80253c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b6:	75 17                	jne    8024cf <alloc_block_BF+0x55>
  8024b8:	83 ec 04             	sub    $0x4,%esp
  8024bb:	68 c8 40 80 00       	push   $0x8040c8
  8024c0:	68 b7 00 00 00       	push   $0xb7
  8024c5:	68 1f 40 80 00       	push   $0x80401f
  8024ca:	e8 02 de ff ff       	call   8002d1 <_panic>
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 00                	mov    (%eax),%eax
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	74 10                	je     8024e8 <alloc_block_BF+0x6e>
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 00                	mov    (%eax),%eax
  8024dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e0:	8b 52 04             	mov    0x4(%edx),%edx
  8024e3:	89 50 04             	mov    %edx,0x4(%eax)
  8024e6:	eb 0b                	jmp    8024f3 <alloc_block_BF+0x79>
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 40 04             	mov    0x4(%eax),%eax
  8024ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	8b 40 04             	mov    0x4(%eax),%eax
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	74 0f                	je     80250c <alloc_block_BF+0x92>
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 40 04             	mov    0x4(%eax),%eax
  802503:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802506:	8b 12                	mov    (%edx),%edx
  802508:	89 10                	mov    %edx,(%eax)
  80250a:	eb 0a                	jmp    802516 <alloc_block_BF+0x9c>
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 00                	mov    (%eax),%eax
  802511:	a3 38 51 80 00       	mov    %eax,0x805138
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802529:	a1 44 51 80 00       	mov    0x805144,%eax
  80252e:	48                   	dec    %eax
  80252f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	e9 4d 01 00 00       	jmp    802689 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 0c             	mov    0xc(%eax),%eax
  802542:	3b 45 08             	cmp    0x8(%ebp),%eax
  802545:	76 24                	jbe    80256b <alloc_block_BF+0xf1>
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 40 0c             	mov    0xc(%eax),%eax
  80254d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802550:	73 19                	jae    80256b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802552:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 40 0c             	mov    0xc(%eax),%eax
  80255f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 40 08             	mov    0x8(%eax),%eax
  802568:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80256b:	a1 40 51 80 00       	mov    0x805140,%eax
  802570:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802573:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802577:	74 07                	je     802580 <alloc_block_BF+0x106>
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 00                	mov    (%eax),%eax
  80257e:	eb 05                	jmp    802585 <alloc_block_BF+0x10b>
  802580:	b8 00 00 00 00       	mov    $0x0,%eax
  802585:	a3 40 51 80 00       	mov    %eax,0x805140
  80258a:	a1 40 51 80 00       	mov    0x805140,%eax
  80258f:	85 c0                	test   %eax,%eax
  802591:	0f 85 fd fe ff ff    	jne    802494 <alloc_block_BF+0x1a>
  802597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259b:	0f 85 f3 fe ff ff    	jne    802494 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025a5:	0f 84 d9 00 00 00    	je     802684 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025ab:	a1 48 51 80 00       	mov    0x805148,%eax
  8025b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025b9:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c2:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025c9:	75 17                	jne    8025e2 <alloc_block_BF+0x168>
  8025cb:	83 ec 04             	sub    $0x4,%esp
  8025ce:	68 c8 40 80 00       	push   $0x8040c8
  8025d3:	68 c7 00 00 00       	push   $0xc7
  8025d8:	68 1f 40 80 00       	push   $0x80401f
  8025dd:	e8 ef dc ff ff       	call   8002d1 <_panic>
  8025e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e5:	8b 00                	mov    (%eax),%eax
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	74 10                	je     8025fb <alloc_block_BF+0x181>
  8025eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025f3:	8b 52 04             	mov    0x4(%edx),%edx
  8025f6:	89 50 04             	mov    %edx,0x4(%eax)
  8025f9:	eb 0b                	jmp    802606 <alloc_block_BF+0x18c>
  8025fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fe:	8b 40 04             	mov    0x4(%eax),%eax
  802601:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802609:	8b 40 04             	mov    0x4(%eax),%eax
  80260c:	85 c0                	test   %eax,%eax
  80260e:	74 0f                	je     80261f <alloc_block_BF+0x1a5>
  802610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802613:	8b 40 04             	mov    0x4(%eax),%eax
  802616:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802619:	8b 12                	mov    (%edx),%edx
  80261b:	89 10                	mov    %edx,(%eax)
  80261d:	eb 0a                	jmp    802629 <alloc_block_BF+0x1af>
  80261f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	a3 48 51 80 00       	mov    %eax,0x805148
  802629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802635:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263c:	a1 54 51 80 00       	mov    0x805154,%eax
  802641:	48                   	dec    %eax
  802642:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802647:	83 ec 08             	sub    $0x8,%esp
  80264a:	ff 75 ec             	pushl  -0x14(%ebp)
  80264d:	68 38 51 80 00       	push   $0x805138
  802652:	e8 71 f9 ff ff       	call   801fc8 <find_block>
  802657:	83 c4 10             	add    $0x10,%esp
  80265a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80265d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802660:	8b 50 08             	mov    0x8(%eax),%edx
  802663:	8b 45 08             	mov    0x8(%ebp),%eax
  802666:	01 c2                	add    %eax,%edx
  802668:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80266e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802671:	8b 40 0c             	mov    0xc(%eax),%eax
  802674:	2b 45 08             	sub    0x8(%ebp),%eax
  802677:	89 c2                	mov    %eax,%edx
  802679:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80267f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802682:	eb 05                	jmp    802689 <alloc_block_BF+0x20f>
	}
	return NULL;
  802684:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802689:	c9                   	leave  
  80268a:	c3                   	ret    

0080268b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80268b:	55                   	push   %ebp
  80268c:	89 e5                	mov    %esp,%ebp
  80268e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802691:	a1 28 50 80 00       	mov    0x805028,%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	0f 85 de 01 00 00    	jne    80287c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80269e:	a1 38 51 80 00       	mov    0x805138,%eax
  8026a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a6:	e9 9e 01 00 00       	jmp    802849 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b4:	0f 82 87 01 00 00    	jb     802841 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c3:	0f 85 95 00 00 00    	jne    80275e <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cd:	75 17                	jne    8026e6 <alloc_block_NF+0x5b>
  8026cf:	83 ec 04             	sub    $0x4,%esp
  8026d2:	68 c8 40 80 00       	push   $0x8040c8
  8026d7:	68 e0 00 00 00       	push   $0xe0
  8026dc:	68 1f 40 80 00       	push   $0x80401f
  8026e1:	e8 eb db ff ff       	call   8002d1 <_panic>
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 00                	mov    (%eax),%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	74 10                	je     8026ff <alloc_block_NF+0x74>
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	8b 00                	mov    (%eax),%eax
  8026f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f7:	8b 52 04             	mov    0x4(%edx),%edx
  8026fa:	89 50 04             	mov    %edx,0x4(%eax)
  8026fd:	eb 0b                	jmp    80270a <alloc_block_NF+0x7f>
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 40 04             	mov    0x4(%eax),%eax
  802705:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 40 04             	mov    0x4(%eax),%eax
  802710:	85 c0                	test   %eax,%eax
  802712:	74 0f                	je     802723 <alloc_block_NF+0x98>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 04             	mov    0x4(%eax),%eax
  80271a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271d:	8b 12                	mov    (%edx),%edx
  80271f:	89 10                	mov    %edx,(%eax)
  802721:	eb 0a                	jmp    80272d <alloc_block_NF+0xa2>
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 00                	mov    (%eax),%eax
  802728:	a3 38 51 80 00       	mov    %eax,0x805138
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802740:	a1 44 51 80 00       	mov    0x805144,%eax
  802745:	48                   	dec    %eax
  802746:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 40 08             	mov    0x8(%eax),%eax
  802751:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	e9 f8 04 00 00       	jmp    802c56 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 40 0c             	mov    0xc(%eax),%eax
  802764:	3b 45 08             	cmp    0x8(%ebp),%eax
  802767:	0f 86 d4 00 00 00    	jbe    802841 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80276d:	a1 48 51 80 00       	mov    0x805148,%eax
  802772:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 50 08             	mov    0x8(%eax),%edx
  80277b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802781:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802784:	8b 55 08             	mov    0x8(%ebp),%edx
  802787:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80278a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80278e:	75 17                	jne    8027a7 <alloc_block_NF+0x11c>
  802790:	83 ec 04             	sub    $0x4,%esp
  802793:	68 c8 40 80 00       	push   $0x8040c8
  802798:	68 e9 00 00 00       	push   $0xe9
  80279d:	68 1f 40 80 00       	push   $0x80401f
  8027a2:	e8 2a db ff ff       	call   8002d1 <_panic>
  8027a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027aa:	8b 00                	mov    (%eax),%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	74 10                	je     8027c0 <alloc_block_NF+0x135>
  8027b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b3:	8b 00                	mov    (%eax),%eax
  8027b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027b8:	8b 52 04             	mov    0x4(%edx),%edx
  8027bb:	89 50 04             	mov    %edx,0x4(%eax)
  8027be:	eb 0b                	jmp    8027cb <alloc_block_NF+0x140>
  8027c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c3:	8b 40 04             	mov    0x4(%eax),%eax
  8027c6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ce:	8b 40 04             	mov    0x4(%eax),%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	74 0f                	je     8027e4 <alloc_block_NF+0x159>
  8027d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d8:	8b 40 04             	mov    0x4(%eax),%eax
  8027db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027de:	8b 12                	mov    (%edx),%edx
  8027e0:	89 10                	mov    %edx,(%eax)
  8027e2:	eb 0a                	jmp    8027ee <alloc_block_NF+0x163>
  8027e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e7:	8b 00                	mov    (%eax),%eax
  8027e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8027ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802801:	a1 54 51 80 00       	mov    0x805154,%eax
  802806:	48                   	dec    %eax
  802807:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80280c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280f:	8b 40 08             	mov    0x8(%eax),%eax
  802812:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 50 08             	mov    0x8(%eax),%edx
  80281d:	8b 45 08             	mov    0x8(%ebp),%eax
  802820:	01 c2                	add    %eax,%edx
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 40 0c             	mov    0xc(%eax),%eax
  80282e:	2b 45 08             	sub    0x8(%ebp),%eax
  802831:	89 c2                	mov    %eax,%edx
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283c:	e9 15 04 00 00       	jmp    802c56 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802841:	a1 40 51 80 00       	mov    0x805140,%eax
  802846:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802849:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284d:	74 07                	je     802856 <alloc_block_NF+0x1cb>
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	eb 05                	jmp    80285b <alloc_block_NF+0x1d0>
  802856:	b8 00 00 00 00       	mov    $0x0,%eax
  80285b:	a3 40 51 80 00       	mov    %eax,0x805140
  802860:	a1 40 51 80 00       	mov    0x805140,%eax
  802865:	85 c0                	test   %eax,%eax
  802867:	0f 85 3e fe ff ff    	jne    8026ab <alloc_block_NF+0x20>
  80286d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802871:	0f 85 34 fe ff ff    	jne    8026ab <alloc_block_NF+0x20>
  802877:	e9 d5 03 00 00       	jmp    802c51 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80287c:	a1 38 51 80 00       	mov    0x805138,%eax
  802881:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802884:	e9 b1 01 00 00       	jmp    802a3a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 50 08             	mov    0x8(%eax),%edx
  80288f:	a1 28 50 80 00       	mov    0x805028,%eax
  802894:	39 c2                	cmp    %eax,%edx
  802896:	0f 82 96 01 00 00    	jb     802a32 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a5:	0f 82 87 01 00 00    	jb     802a32 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b4:	0f 85 95 00 00 00    	jne    80294f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028be:	75 17                	jne    8028d7 <alloc_block_NF+0x24c>
  8028c0:	83 ec 04             	sub    $0x4,%esp
  8028c3:	68 c8 40 80 00       	push   $0x8040c8
  8028c8:	68 fc 00 00 00       	push   $0xfc
  8028cd:	68 1f 40 80 00       	push   $0x80401f
  8028d2:	e8 fa d9 ff ff       	call   8002d1 <_panic>
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	74 10                	je     8028f0 <alloc_block_NF+0x265>
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e8:	8b 52 04             	mov    0x4(%edx),%edx
  8028eb:	89 50 04             	mov    %edx,0x4(%eax)
  8028ee:	eb 0b                	jmp    8028fb <alloc_block_NF+0x270>
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 40 04             	mov    0x4(%eax),%eax
  8028f6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	8b 40 04             	mov    0x4(%eax),%eax
  802901:	85 c0                	test   %eax,%eax
  802903:	74 0f                	je     802914 <alloc_block_NF+0x289>
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	8b 40 04             	mov    0x4(%eax),%eax
  80290b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290e:	8b 12                	mov    (%edx),%edx
  802910:	89 10                	mov    %edx,(%eax)
  802912:	eb 0a                	jmp    80291e <alloc_block_NF+0x293>
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	a3 38 51 80 00       	mov    %eax,0x805138
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802931:	a1 44 51 80 00       	mov    0x805144,%eax
  802936:	48                   	dec    %eax
  802937:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 08             	mov    0x8(%eax),%eax
  802942:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	e9 07 03 00 00       	jmp    802c56 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 40 0c             	mov    0xc(%eax),%eax
  802955:	3b 45 08             	cmp    0x8(%ebp),%eax
  802958:	0f 86 d4 00 00 00    	jbe    802a32 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80295e:	a1 48 51 80 00       	mov    0x805148,%eax
  802963:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 50 08             	mov    0x8(%eax),%edx
  80296c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802972:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802975:	8b 55 08             	mov    0x8(%ebp),%edx
  802978:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80297b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80297f:	75 17                	jne    802998 <alloc_block_NF+0x30d>
  802981:	83 ec 04             	sub    $0x4,%esp
  802984:	68 c8 40 80 00       	push   $0x8040c8
  802989:	68 04 01 00 00       	push   $0x104
  80298e:	68 1f 40 80 00       	push   $0x80401f
  802993:	e8 39 d9 ff ff       	call   8002d1 <_panic>
  802998:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	85 c0                	test   %eax,%eax
  80299f:	74 10                	je     8029b1 <alloc_block_NF+0x326>
  8029a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a4:	8b 00                	mov    (%eax),%eax
  8029a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029a9:	8b 52 04             	mov    0x4(%edx),%edx
  8029ac:	89 50 04             	mov    %edx,0x4(%eax)
  8029af:	eb 0b                	jmp    8029bc <alloc_block_NF+0x331>
  8029b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b4:	8b 40 04             	mov    0x4(%eax),%eax
  8029b7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bf:	8b 40 04             	mov    0x4(%eax),%eax
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	74 0f                	je     8029d5 <alloc_block_NF+0x34a>
  8029c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c9:	8b 40 04             	mov    0x4(%eax),%eax
  8029cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029cf:	8b 12                	mov    (%edx),%edx
  8029d1:	89 10                	mov    %edx,(%eax)
  8029d3:	eb 0a                	jmp    8029df <alloc_block_NF+0x354>
  8029d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d8:	8b 00                	mov    (%eax),%eax
  8029da:	a3 48 51 80 00       	mov    %eax,0x805148
  8029df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8029f7:	48                   	dec    %eax
  8029f8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a00:	8b 40 08             	mov    0x8(%eax),%eax
  802a03:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 50 08             	mov    0x8(%eax),%edx
  802a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a11:	01 c2                	add    %eax,%edx
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a22:	89 c2                	mov    %eax,%edx
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2d:	e9 24 02 00 00       	jmp    802c56 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a32:	a1 40 51 80 00       	mov    0x805140,%eax
  802a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3e:	74 07                	je     802a47 <alloc_block_NF+0x3bc>
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 00                	mov    (%eax),%eax
  802a45:	eb 05                	jmp    802a4c <alloc_block_NF+0x3c1>
  802a47:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4c:	a3 40 51 80 00       	mov    %eax,0x805140
  802a51:	a1 40 51 80 00       	mov    0x805140,%eax
  802a56:	85 c0                	test   %eax,%eax
  802a58:	0f 85 2b fe ff ff    	jne    802889 <alloc_block_NF+0x1fe>
  802a5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a62:	0f 85 21 fe ff ff    	jne    802889 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a68:	a1 38 51 80 00       	mov    0x805138,%eax
  802a6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a70:	e9 ae 01 00 00       	jmp    802c23 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a78:	8b 50 08             	mov    0x8(%eax),%edx
  802a7b:	a1 28 50 80 00       	mov    0x805028,%eax
  802a80:	39 c2                	cmp    %eax,%edx
  802a82:	0f 83 93 01 00 00    	jae    802c1b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a91:	0f 82 84 01 00 00    	jb     802c1b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa0:	0f 85 95 00 00 00    	jne    802b3b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802aa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aaa:	75 17                	jne    802ac3 <alloc_block_NF+0x438>
  802aac:	83 ec 04             	sub    $0x4,%esp
  802aaf:	68 c8 40 80 00       	push   $0x8040c8
  802ab4:	68 14 01 00 00       	push   $0x114
  802ab9:	68 1f 40 80 00       	push   $0x80401f
  802abe:	e8 0e d8 ff ff       	call   8002d1 <_panic>
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 10                	je     802adc <alloc_block_NF+0x451>
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad4:	8b 52 04             	mov    0x4(%edx),%edx
  802ad7:	89 50 04             	mov    %edx,0x4(%eax)
  802ada:	eb 0b                	jmp    802ae7 <alloc_block_NF+0x45c>
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 40 04             	mov    0x4(%eax),%eax
  802ae2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	8b 40 04             	mov    0x4(%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	74 0f                	je     802b00 <alloc_block_NF+0x475>
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 40 04             	mov    0x4(%eax),%eax
  802af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afa:	8b 12                	mov    (%edx),%edx
  802afc:	89 10                	mov    %edx,(%eax)
  802afe:	eb 0a                	jmp    802b0a <alloc_block_NF+0x47f>
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	a3 38 51 80 00       	mov    %eax,0x805138
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1d:	a1 44 51 80 00       	mov    0x805144,%eax
  802b22:	48                   	dec    %eax
  802b23:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 40 08             	mov    0x8(%eax),%eax
  802b2e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	e9 1b 01 00 00       	jmp    802c56 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b44:	0f 86 d1 00 00 00    	jbe    802c1b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b4a:	a1 48 51 80 00       	mov    0x805148,%eax
  802b4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 50 08             	mov    0x8(%eax),%edx
  802b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b61:	8b 55 08             	mov    0x8(%ebp),%edx
  802b64:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b6b:	75 17                	jne    802b84 <alloc_block_NF+0x4f9>
  802b6d:	83 ec 04             	sub    $0x4,%esp
  802b70:	68 c8 40 80 00       	push   $0x8040c8
  802b75:	68 1c 01 00 00       	push   $0x11c
  802b7a:	68 1f 40 80 00       	push   $0x80401f
  802b7f:	e8 4d d7 ff ff       	call   8002d1 <_panic>
  802b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b87:	8b 00                	mov    (%eax),%eax
  802b89:	85 c0                	test   %eax,%eax
  802b8b:	74 10                	je     802b9d <alloc_block_NF+0x512>
  802b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b95:	8b 52 04             	mov    0x4(%edx),%edx
  802b98:	89 50 04             	mov    %edx,0x4(%eax)
  802b9b:	eb 0b                	jmp    802ba8 <alloc_block_NF+0x51d>
  802b9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba0:	8b 40 04             	mov    0x4(%eax),%eax
  802ba3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bab:	8b 40 04             	mov    0x4(%eax),%eax
  802bae:	85 c0                	test   %eax,%eax
  802bb0:	74 0f                	je     802bc1 <alloc_block_NF+0x536>
  802bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb5:	8b 40 04             	mov    0x4(%eax),%eax
  802bb8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bbb:	8b 12                	mov    (%edx),%edx
  802bbd:	89 10                	mov    %edx,(%eax)
  802bbf:	eb 0a                	jmp    802bcb <alloc_block_NF+0x540>
  802bc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	a3 48 51 80 00       	mov    %eax,0x805148
  802bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bde:	a1 54 51 80 00       	mov    0x805154,%eax
  802be3:	48                   	dec    %eax
  802be4:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bec:	8b 40 08             	mov    0x8(%eax),%eax
  802bef:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 50 08             	mov    0x8(%eax),%edx
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	01 c2                	add    %eax,%edx
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0b:	2b 45 08             	sub    0x8(%ebp),%eax
  802c0e:	89 c2                	mov    %eax,%edx
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c19:	eb 3b                	jmp    802c56 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c1b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c27:	74 07                	je     802c30 <alloc_block_NF+0x5a5>
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	eb 05                	jmp    802c35 <alloc_block_NF+0x5aa>
  802c30:	b8 00 00 00 00       	mov    $0x0,%eax
  802c35:	a3 40 51 80 00       	mov    %eax,0x805140
  802c3a:	a1 40 51 80 00       	mov    0x805140,%eax
  802c3f:	85 c0                	test   %eax,%eax
  802c41:	0f 85 2e fe ff ff    	jne    802a75 <alloc_block_NF+0x3ea>
  802c47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4b:	0f 85 24 fe ff ff    	jne    802a75 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c56:	c9                   	leave  
  802c57:	c3                   	ret    

00802c58 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c58:	55                   	push   %ebp
  802c59:	89 e5                	mov    %esp,%ebp
  802c5b:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c5e:	a1 38 51 80 00       	mov    0x805138,%eax
  802c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c66:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c6b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c6e:	a1 38 51 80 00       	mov    0x805138,%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 14                	je     802c8b <insert_sorted_with_merge_freeList+0x33>
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	8b 50 08             	mov    0x8(%eax),%edx
  802c7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c80:	8b 40 08             	mov    0x8(%eax),%eax
  802c83:	39 c2                	cmp    %eax,%edx
  802c85:	0f 87 9b 01 00 00    	ja     802e26 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c8f:	75 17                	jne    802ca8 <insert_sorted_with_merge_freeList+0x50>
  802c91:	83 ec 04             	sub    $0x4,%esp
  802c94:	68 fc 3f 80 00       	push   $0x803ffc
  802c99:	68 38 01 00 00       	push   $0x138
  802c9e:	68 1f 40 80 00       	push   $0x80401f
  802ca3:	e8 29 d6 ff ff       	call   8002d1 <_panic>
  802ca8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	89 10                	mov    %edx,(%eax)
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 0d                	je     802cc9 <insert_sorted_with_merge_freeList+0x71>
  802cbc:	a1 38 51 80 00       	mov    0x805138,%eax
  802cc1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc4:	89 50 04             	mov    %edx,0x4(%eax)
  802cc7:	eb 08                	jmp    802cd1 <insert_sorted_with_merge_freeList+0x79>
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	a3 38 51 80 00       	mov    %eax,0x805138
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ce8:	40                   	inc    %eax
  802ce9:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf2:	0f 84 a8 06 00 00    	je     8033a0 <insert_sorted_with_merge_freeList+0x748>
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	8b 50 08             	mov    0x8(%eax),%edx
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	8b 40 0c             	mov    0xc(%eax),%eax
  802d04:	01 c2                	add    %eax,%edx
  802d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d09:	8b 40 08             	mov    0x8(%eax),%eax
  802d0c:	39 c2                	cmp    %eax,%edx
  802d0e:	0f 85 8c 06 00 00    	jne    8033a0 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	8b 50 0c             	mov    0xc(%eax),%edx
  802d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d20:	01 c2                	add    %eax,%edx
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d2c:	75 17                	jne    802d45 <insert_sorted_with_merge_freeList+0xed>
  802d2e:	83 ec 04             	sub    $0x4,%esp
  802d31:	68 c8 40 80 00       	push   $0x8040c8
  802d36:	68 3c 01 00 00       	push   $0x13c
  802d3b:	68 1f 40 80 00       	push   $0x80401f
  802d40:	e8 8c d5 ff ff       	call   8002d1 <_panic>
  802d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	85 c0                	test   %eax,%eax
  802d4c:	74 10                	je     802d5e <insert_sorted_with_merge_freeList+0x106>
  802d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d51:	8b 00                	mov    (%eax),%eax
  802d53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d56:	8b 52 04             	mov    0x4(%edx),%edx
  802d59:	89 50 04             	mov    %edx,0x4(%eax)
  802d5c:	eb 0b                	jmp    802d69 <insert_sorted_with_merge_freeList+0x111>
  802d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6c:	8b 40 04             	mov    0x4(%eax),%eax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	74 0f                	je     802d82 <insert_sorted_with_merge_freeList+0x12a>
  802d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d76:	8b 40 04             	mov    0x4(%eax),%eax
  802d79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d7c:	8b 12                	mov    (%edx),%edx
  802d7e:	89 10                	mov    %edx,(%eax)
  802d80:	eb 0a                	jmp    802d8c <insert_sorted_with_merge_freeList+0x134>
  802d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d85:	8b 00                	mov    (%eax),%eax
  802d87:	a3 38 51 80 00       	mov    %eax,0x805138
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9f:	a1 44 51 80 00       	mov    0x805144,%eax
  802da4:	48                   	dec    %eax
  802da5:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802dbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc2:	75 17                	jne    802ddb <insert_sorted_with_merge_freeList+0x183>
  802dc4:	83 ec 04             	sub    $0x4,%esp
  802dc7:	68 fc 3f 80 00       	push   $0x803ffc
  802dcc:	68 3f 01 00 00       	push   $0x13f
  802dd1:	68 1f 40 80 00       	push   $0x80401f
  802dd6:	e8 f6 d4 ff ff       	call   8002d1 <_panic>
  802ddb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de4:	89 10                	mov    %edx,(%eax)
  802de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	85 c0                	test   %eax,%eax
  802ded:	74 0d                	je     802dfc <insert_sorted_with_merge_freeList+0x1a4>
  802def:	a1 48 51 80 00       	mov    0x805148,%eax
  802df4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802df7:	89 50 04             	mov    %edx,0x4(%eax)
  802dfa:	eb 08                	jmp    802e04 <insert_sorted_with_merge_freeList+0x1ac>
  802dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	a3 48 51 80 00       	mov    %eax,0x805148
  802e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e16:	a1 54 51 80 00       	mov    0x805154,%eax
  802e1b:	40                   	inc    %eax
  802e1c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e21:	e9 7a 05 00 00       	jmp    8033a0 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	8b 50 08             	mov    0x8(%eax),%edx
  802e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2f:	8b 40 08             	mov    0x8(%eax),%eax
  802e32:	39 c2                	cmp    %eax,%edx
  802e34:	0f 82 14 01 00 00    	jb     802f4e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3d:	8b 50 08             	mov    0x8(%eax),%edx
  802e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e43:	8b 40 0c             	mov    0xc(%eax),%eax
  802e46:	01 c2                	add    %eax,%edx
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	8b 40 08             	mov    0x8(%eax),%eax
  802e4e:	39 c2                	cmp    %eax,%edx
  802e50:	0f 85 90 00 00 00    	jne    802ee6 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e59:	8b 50 0c             	mov    0xc(%eax),%edx
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e62:	01 c2                	add    %eax,%edx
  802e64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e67:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e82:	75 17                	jne    802e9b <insert_sorted_with_merge_freeList+0x243>
  802e84:	83 ec 04             	sub    $0x4,%esp
  802e87:	68 fc 3f 80 00       	push   $0x803ffc
  802e8c:	68 49 01 00 00       	push   $0x149
  802e91:	68 1f 40 80 00       	push   $0x80401f
  802e96:	e8 36 d4 ff ff       	call   8002d1 <_panic>
  802e9b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	89 10                	mov    %edx,(%eax)
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	85 c0                	test   %eax,%eax
  802ead:	74 0d                	je     802ebc <insert_sorted_with_merge_freeList+0x264>
  802eaf:	a1 48 51 80 00       	mov    0x805148,%eax
  802eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb7:	89 50 04             	mov    %edx,0x4(%eax)
  802eba:	eb 08                	jmp    802ec4 <insert_sorted_with_merge_freeList+0x26c>
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	a3 48 51 80 00       	mov    %eax,0x805148
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed6:	a1 54 51 80 00       	mov    0x805154,%eax
  802edb:	40                   	inc    %eax
  802edc:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ee1:	e9 bb 04 00 00       	jmp    8033a1 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ee6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eea:	75 17                	jne    802f03 <insert_sorted_with_merge_freeList+0x2ab>
  802eec:	83 ec 04             	sub    $0x4,%esp
  802eef:	68 70 40 80 00       	push   $0x804070
  802ef4:	68 4c 01 00 00       	push   $0x14c
  802ef9:	68 1f 40 80 00       	push   $0x80401f
  802efe:	e8 ce d3 ff ff       	call   8002d1 <_panic>
  802f03:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	89 50 04             	mov    %edx,0x4(%eax)
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	8b 40 04             	mov    0x4(%eax),%eax
  802f15:	85 c0                	test   %eax,%eax
  802f17:	74 0c                	je     802f25 <insert_sorted_with_merge_freeList+0x2cd>
  802f19:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f21:	89 10                	mov    %edx,(%eax)
  802f23:	eb 08                	jmp    802f2d <insert_sorted_with_merge_freeList+0x2d5>
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3e:	a1 44 51 80 00       	mov    0x805144,%eax
  802f43:	40                   	inc    %eax
  802f44:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f49:	e9 53 04 00 00       	jmp    8033a1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f4e:	a1 38 51 80 00       	mov    0x805138,%eax
  802f53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f56:	e9 15 04 00 00       	jmp    803370 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	8b 00                	mov    (%eax),%eax
  802f60:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	8b 50 08             	mov    0x8(%eax),%edx
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	8b 40 08             	mov    0x8(%eax),%eax
  802f6f:	39 c2                	cmp    %eax,%edx
  802f71:	0f 86 f1 03 00 00    	jbe    803368 <insert_sorted_with_merge_freeList+0x710>
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 50 08             	mov    0x8(%eax),%edx
  802f7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f80:	8b 40 08             	mov    0x8(%eax),%eax
  802f83:	39 c2                	cmp    %eax,%edx
  802f85:	0f 83 dd 03 00 00    	jae    803368 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	8b 50 08             	mov    0x8(%eax),%edx
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	8b 40 0c             	mov    0xc(%eax),%eax
  802f97:	01 c2                	add    %eax,%edx
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	8b 40 08             	mov    0x8(%eax),%eax
  802f9f:	39 c2                	cmp    %eax,%edx
  802fa1:	0f 85 b9 01 00 00    	jne    803160 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	8b 50 08             	mov    0x8(%eax),%edx
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb3:	01 c2                	add    %eax,%edx
  802fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb8:	8b 40 08             	mov    0x8(%eax),%eax
  802fbb:	39 c2                	cmp    %eax,%edx
  802fbd:	0f 85 0d 01 00 00    	jne    8030d0 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	8b 50 0c             	mov    0xc(%eax),%edx
  802fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcf:	01 c2                	add    %eax,%edx
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fd7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fdb:	75 17                	jne    802ff4 <insert_sorted_with_merge_freeList+0x39c>
  802fdd:	83 ec 04             	sub    $0x4,%esp
  802fe0:	68 c8 40 80 00       	push   $0x8040c8
  802fe5:	68 5c 01 00 00       	push   $0x15c
  802fea:	68 1f 40 80 00       	push   $0x80401f
  802fef:	e8 dd d2 ff ff       	call   8002d1 <_panic>
  802ff4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	85 c0                	test   %eax,%eax
  802ffb:	74 10                	je     80300d <insert_sorted_with_merge_freeList+0x3b5>
  802ffd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803000:	8b 00                	mov    (%eax),%eax
  803002:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803005:	8b 52 04             	mov    0x4(%edx),%edx
  803008:	89 50 04             	mov    %edx,0x4(%eax)
  80300b:	eb 0b                	jmp    803018 <insert_sorted_with_merge_freeList+0x3c0>
  80300d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803010:	8b 40 04             	mov    0x4(%eax),%eax
  803013:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803018:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301b:	8b 40 04             	mov    0x4(%eax),%eax
  80301e:	85 c0                	test   %eax,%eax
  803020:	74 0f                	je     803031 <insert_sorted_with_merge_freeList+0x3d9>
  803022:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803025:	8b 40 04             	mov    0x4(%eax),%eax
  803028:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80302b:	8b 12                	mov    (%edx),%edx
  80302d:	89 10                	mov    %edx,(%eax)
  80302f:	eb 0a                	jmp    80303b <insert_sorted_with_merge_freeList+0x3e3>
  803031:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803034:	8b 00                	mov    (%eax),%eax
  803036:	a3 38 51 80 00       	mov    %eax,0x805138
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803044:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803047:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304e:	a1 44 51 80 00       	mov    0x805144,%eax
  803053:	48                   	dec    %eax
  803054:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803059:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803063:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803066:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80306d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803071:	75 17                	jne    80308a <insert_sorted_with_merge_freeList+0x432>
  803073:	83 ec 04             	sub    $0x4,%esp
  803076:	68 fc 3f 80 00       	push   $0x803ffc
  80307b:	68 5f 01 00 00       	push   $0x15f
  803080:	68 1f 40 80 00       	push   $0x80401f
  803085:	e8 47 d2 ff ff       	call   8002d1 <_panic>
  80308a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803090:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803093:	89 10                	mov    %edx,(%eax)
  803095:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803098:	8b 00                	mov    (%eax),%eax
  80309a:	85 c0                	test   %eax,%eax
  80309c:	74 0d                	je     8030ab <insert_sorted_with_merge_freeList+0x453>
  80309e:	a1 48 51 80 00       	mov    0x805148,%eax
  8030a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a6:	89 50 04             	mov    %edx,0x4(%eax)
  8030a9:	eb 08                	jmp    8030b3 <insert_sorted_with_merge_freeList+0x45b>
  8030ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8030bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ca:	40                   	inc    %eax
  8030cb:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030dc:	01 c2                	add    %eax,%edx
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fc:	75 17                	jne    803115 <insert_sorted_with_merge_freeList+0x4bd>
  8030fe:	83 ec 04             	sub    $0x4,%esp
  803101:	68 fc 3f 80 00       	push   $0x803ffc
  803106:	68 64 01 00 00       	push   $0x164
  80310b:	68 1f 40 80 00       	push   $0x80401f
  803110:	e8 bc d1 ff ff       	call   8002d1 <_panic>
  803115:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	89 10                	mov    %edx,(%eax)
  803120:	8b 45 08             	mov    0x8(%ebp),%eax
  803123:	8b 00                	mov    (%eax),%eax
  803125:	85 c0                	test   %eax,%eax
  803127:	74 0d                	je     803136 <insert_sorted_with_merge_freeList+0x4de>
  803129:	a1 48 51 80 00       	mov    0x805148,%eax
  80312e:	8b 55 08             	mov    0x8(%ebp),%edx
  803131:	89 50 04             	mov    %edx,0x4(%eax)
  803134:	eb 08                	jmp    80313e <insert_sorted_with_merge_freeList+0x4e6>
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	a3 48 51 80 00       	mov    %eax,0x805148
  803146:	8b 45 08             	mov    0x8(%ebp),%eax
  803149:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803150:	a1 54 51 80 00       	mov    0x805154,%eax
  803155:	40                   	inc    %eax
  803156:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80315b:	e9 41 02 00 00       	jmp    8033a1 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	8b 50 08             	mov    0x8(%eax),%edx
  803166:	8b 45 08             	mov    0x8(%ebp),%eax
  803169:	8b 40 0c             	mov    0xc(%eax),%eax
  80316c:	01 c2                	add    %eax,%edx
  80316e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803171:	8b 40 08             	mov    0x8(%eax),%eax
  803174:	39 c2                	cmp    %eax,%edx
  803176:	0f 85 7c 01 00 00    	jne    8032f8 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80317c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803180:	74 06                	je     803188 <insert_sorted_with_merge_freeList+0x530>
  803182:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803186:	75 17                	jne    80319f <insert_sorted_with_merge_freeList+0x547>
  803188:	83 ec 04             	sub    $0x4,%esp
  80318b:	68 38 40 80 00       	push   $0x804038
  803190:	68 69 01 00 00       	push   $0x169
  803195:	68 1f 40 80 00       	push   $0x80401f
  80319a:	e8 32 d1 ff ff       	call   8002d1 <_panic>
  80319f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a2:	8b 50 04             	mov    0x4(%eax),%edx
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	89 50 04             	mov    %edx,0x4(%eax)
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b1:	89 10                	mov    %edx,(%eax)
  8031b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b6:	8b 40 04             	mov    0x4(%eax),%eax
  8031b9:	85 c0                	test   %eax,%eax
  8031bb:	74 0d                	je     8031ca <insert_sorted_with_merge_freeList+0x572>
  8031bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c0:	8b 40 04             	mov    0x4(%eax),%eax
  8031c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c6:	89 10                	mov    %edx,(%eax)
  8031c8:	eb 08                	jmp    8031d2 <insert_sorted_with_merge_freeList+0x57a>
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8031d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d8:	89 50 04             	mov    %edx,0x4(%eax)
  8031db:	a1 44 51 80 00       	mov    0x805144,%eax
  8031e0:	40                   	inc    %eax
  8031e1:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8031ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f2:	01 c2                	add    %eax,%edx
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031fe:	75 17                	jne    803217 <insert_sorted_with_merge_freeList+0x5bf>
  803200:	83 ec 04             	sub    $0x4,%esp
  803203:	68 c8 40 80 00       	push   $0x8040c8
  803208:	68 6b 01 00 00       	push   $0x16b
  80320d:	68 1f 40 80 00       	push   $0x80401f
  803212:	e8 ba d0 ff ff       	call   8002d1 <_panic>
  803217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321a:	8b 00                	mov    (%eax),%eax
  80321c:	85 c0                	test   %eax,%eax
  80321e:	74 10                	je     803230 <insert_sorted_with_merge_freeList+0x5d8>
  803220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803223:	8b 00                	mov    (%eax),%eax
  803225:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803228:	8b 52 04             	mov    0x4(%edx),%edx
  80322b:	89 50 04             	mov    %edx,0x4(%eax)
  80322e:	eb 0b                	jmp    80323b <insert_sorted_with_merge_freeList+0x5e3>
  803230:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803233:	8b 40 04             	mov    0x4(%eax),%eax
  803236:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80323b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323e:	8b 40 04             	mov    0x4(%eax),%eax
  803241:	85 c0                	test   %eax,%eax
  803243:	74 0f                	je     803254 <insert_sorted_with_merge_freeList+0x5fc>
  803245:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803248:	8b 40 04             	mov    0x4(%eax),%eax
  80324b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80324e:	8b 12                	mov    (%edx),%edx
  803250:	89 10                	mov    %edx,(%eax)
  803252:	eb 0a                	jmp    80325e <insert_sorted_with_merge_freeList+0x606>
  803254:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803257:	8b 00                	mov    (%eax),%eax
  803259:	a3 38 51 80 00       	mov    %eax,0x805138
  80325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803261:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803267:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803271:	a1 44 51 80 00       	mov    0x805144,%eax
  803276:	48                   	dec    %eax
  803277:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80327c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803286:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803289:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803290:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803294:	75 17                	jne    8032ad <insert_sorted_with_merge_freeList+0x655>
  803296:	83 ec 04             	sub    $0x4,%esp
  803299:	68 fc 3f 80 00       	push   $0x803ffc
  80329e:	68 6e 01 00 00       	push   $0x16e
  8032a3:	68 1f 40 80 00       	push   $0x80401f
  8032a8:	e8 24 d0 ff ff       	call   8002d1 <_panic>
  8032ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	89 10                	mov    %edx,(%eax)
  8032b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bb:	8b 00                	mov    (%eax),%eax
  8032bd:	85 c0                	test   %eax,%eax
  8032bf:	74 0d                	je     8032ce <insert_sorted_with_merge_freeList+0x676>
  8032c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c9:	89 50 04             	mov    %edx,0x4(%eax)
  8032cc:	eb 08                	jmp    8032d6 <insert_sorted_with_merge_freeList+0x67e>
  8032ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ed:	40                   	inc    %eax
  8032ee:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032f3:	e9 a9 00 00 00       	jmp    8033a1 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fc:	74 06                	je     803304 <insert_sorted_with_merge_freeList+0x6ac>
  8032fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803302:	75 17                	jne    80331b <insert_sorted_with_merge_freeList+0x6c3>
  803304:	83 ec 04             	sub    $0x4,%esp
  803307:	68 94 40 80 00       	push   $0x804094
  80330c:	68 73 01 00 00       	push   $0x173
  803311:	68 1f 40 80 00       	push   $0x80401f
  803316:	e8 b6 cf ff ff       	call   8002d1 <_panic>
  80331b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331e:	8b 10                	mov    (%eax),%edx
  803320:	8b 45 08             	mov    0x8(%ebp),%eax
  803323:	89 10                	mov    %edx,(%eax)
  803325:	8b 45 08             	mov    0x8(%ebp),%eax
  803328:	8b 00                	mov    (%eax),%eax
  80332a:	85 c0                	test   %eax,%eax
  80332c:	74 0b                	je     803339 <insert_sorted_with_merge_freeList+0x6e1>
  80332e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803331:	8b 00                	mov    (%eax),%eax
  803333:	8b 55 08             	mov    0x8(%ebp),%edx
  803336:	89 50 04             	mov    %edx,0x4(%eax)
  803339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333c:	8b 55 08             	mov    0x8(%ebp),%edx
  80333f:	89 10                	mov    %edx,(%eax)
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803347:	89 50 04             	mov    %edx,0x4(%eax)
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	8b 00                	mov    (%eax),%eax
  80334f:	85 c0                	test   %eax,%eax
  803351:	75 08                	jne    80335b <insert_sorted_with_merge_freeList+0x703>
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80335b:	a1 44 51 80 00       	mov    0x805144,%eax
  803360:	40                   	inc    %eax
  803361:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803366:	eb 39                	jmp    8033a1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803368:	a1 40 51 80 00       	mov    0x805140,%eax
  80336d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803370:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803374:	74 07                	je     80337d <insert_sorted_with_merge_freeList+0x725>
  803376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803379:	8b 00                	mov    (%eax),%eax
  80337b:	eb 05                	jmp    803382 <insert_sorted_with_merge_freeList+0x72a>
  80337d:	b8 00 00 00 00       	mov    $0x0,%eax
  803382:	a3 40 51 80 00       	mov    %eax,0x805140
  803387:	a1 40 51 80 00       	mov    0x805140,%eax
  80338c:	85 c0                	test   %eax,%eax
  80338e:	0f 85 c7 fb ff ff    	jne    802f5b <insert_sorted_with_merge_freeList+0x303>
  803394:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803398:	0f 85 bd fb ff ff    	jne    802f5b <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80339e:	eb 01                	jmp    8033a1 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033a0:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033a1:	90                   	nop
  8033a2:	c9                   	leave  
  8033a3:	c3                   	ret    

008033a4 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8033a4:	55                   	push   %ebp
  8033a5:	89 e5                	mov    %esp,%ebp
  8033a7:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8033aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ad:	89 d0                	mov    %edx,%eax
  8033af:	c1 e0 02             	shl    $0x2,%eax
  8033b2:	01 d0                	add    %edx,%eax
  8033b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033bb:	01 d0                	add    %edx,%eax
  8033bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033c4:	01 d0                	add    %edx,%eax
  8033c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033cd:	01 d0                	add    %edx,%eax
  8033cf:	c1 e0 04             	shl    $0x4,%eax
  8033d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8033d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8033dc:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033df:	83 ec 0c             	sub    $0xc,%esp
  8033e2:	50                   	push   %eax
  8033e3:	e8 26 e7 ff ff       	call   801b0e <sys_get_virtual_time>
  8033e8:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033eb:	eb 41                	jmp    80342e <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033f0:	83 ec 0c             	sub    $0xc,%esp
  8033f3:	50                   	push   %eax
  8033f4:	e8 15 e7 ff ff       	call   801b0e <sys_get_virtual_time>
  8033f9:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803402:	29 c2                	sub    %eax,%edx
  803404:	89 d0                	mov    %edx,%eax
  803406:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803409:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80340c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80340f:	89 d1                	mov    %edx,%ecx
  803411:	29 c1                	sub    %eax,%ecx
  803413:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803416:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803419:	39 c2                	cmp    %eax,%edx
  80341b:	0f 97 c0             	seta   %al
  80341e:	0f b6 c0             	movzbl %al,%eax
  803421:	29 c1                	sub    %eax,%ecx
  803423:	89 c8                	mov    %ecx,%eax
  803425:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803428:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80342b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803434:	72 b7                	jb     8033ed <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803436:	90                   	nop
  803437:	c9                   	leave  
  803438:	c3                   	ret    

00803439 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803439:	55                   	push   %ebp
  80343a:	89 e5                	mov    %esp,%ebp
  80343c:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80343f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803446:	eb 03                	jmp    80344b <busy_wait+0x12>
  803448:	ff 45 fc             	incl   -0x4(%ebp)
  80344b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80344e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803451:	72 f5                	jb     803448 <busy_wait+0xf>
	return i;
  803453:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803456:	c9                   	leave  
  803457:	c3                   	ret    

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
