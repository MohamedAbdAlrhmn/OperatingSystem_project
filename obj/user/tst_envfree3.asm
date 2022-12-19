
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
  800045:	68 20 38 80 00       	push   $0x803820
  80004a:	e8 09 16 00 00       	call   801658 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 c7 18 00 00       	call   80192a <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 5f 19 00 00       	call   8019ca <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 38 80 00       	push   $0x803830
  800079:	e8 07 05 00 00       	call   800585 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 63 38 80 00       	push   $0x803863
  800099:	e8 fe 1a 00 00       	call   801b9c <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 6c 38 80 00       	push   $0x80386c
  8000bc:	e8 db 1a 00 00       	call   801b9c <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 e8 1a 00 00       	call   801bba <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 0a 34 00 00       	call   8034ec <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 ca 1a 00 00       	call   801bba <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 27 18 00 00       	call   80192a <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 78 38 80 00       	push   $0x803878
  80010c:	e8 74 04 00 00       	call   800585 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 b7 1a 00 00       	call   801bd6 <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 a9 1a 00 00       	call   801bd6 <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 f5 17 00 00       	call   80192a <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 8d 18 00 00       	call   8019ca <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 ac 38 80 00       	push   $0x8038ac
  800153:	e8 2d 04 00 00       	call   800585 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 fc 38 80 00       	push   $0x8038fc
  800163:	6a 23                	push   $0x23
  800165:	68 32 39 80 00       	push   $0x803932
  80016a:	e8 62 01 00 00       	call   8002d1 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 48 39 80 00       	push   $0x803948
  80017a:	e8 06 04 00 00       	call   800585 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 a8 39 80 00       	push   $0x8039a8
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
  80019b:	e8 6a 1a 00 00       	call   801c0a <sys_getenvindex>
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
  800206:	e8 0c 18 00 00       	call   801a17 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 0c 3a 80 00       	push   $0x803a0c
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
  800236:	68 34 3a 80 00       	push   $0x803a34
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
  800267:	68 5c 3a 80 00       	push   $0x803a5c
  80026c:	e8 14 03 00 00       	call   800585 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 b4 3a 80 00       	push   $0x803ab4
  800288:	e8 f8 02 00 00       	call   800585 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 0c 3a 80 00       	push   $0x803a0c
  800298:	e8 e8 02 00 00       	call   800585 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a0:	e8 8c 17 00 00       	call   801a31 <sys_enable_interrupt>

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
  8002b8:	e8 19 19 00 00       	call   801bd6 <sys_destroy_env>
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
  8002c9:	e8 6e 19 00 00       	call   801c3c <sys_exit_env>
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
  8002f2:	68 c8 3a 80 00       	push   $0x803ac8
  8002f7:	e8 89 02 00 00       	call   800585 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ff:	a1 00 50 80 00       	mov    0x805000,%eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	50                   	push   %eax
  80030b:	68 cd 3a 80 00       	push   $0x803acd
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
  80032f:	68 e9 3a 80 00       	push   $0x803ae9
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
  80035b:	68 ec 3a 80 00       	push   $0x803aec
  800360:	6a 26                	push   $0x26
  800362:	68 38 3b 80 00       	push   $0x803b38
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
  80042d:	68 44 3b 80 00       	push   $0x803b44
  800432:	6a 3a                	push   $0x3a
  800434:	68 38 3b 80 00       	push   $0x803b38
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
  80049d:	68 98 3b 80 00       	push   $0x803b98
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 38 3b 80 00       	push   $0x803b38
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
  8004f7:	e8 6d 13 00 00       	call   801869 <sys_cputs>
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
  80056e:	e8 f6 12 00 00       	call   801869 <sys_cputs>
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
  8005b8:	e8 5a 14 00 00       	call   801a17 <sys_disable_interrupt>
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
  8005d8:	e8 54 14 00 00       	call   801a31 <sys_enable_interrupt>
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
  800622:	e8 79 2f 00 00       	call   8035a0 <__udivdi3>
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
  800672:	e8 39 30 00 00       	call   8036b0 <__umoddi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	05 14 3e 80 00       	add    $0x803e14,%eax
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
  8007cd:	8b 04 85 38 3e 80 00 	mov    0x803e38(,%eax,4),%eax
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
  8008ae:	8b 34 9d 80 3c 80 00 	mov    0x803c80(,%ebx,4),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 19                	jne    8008d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b9:	53                   	push   %ebx
  8008ba:	68 25 3e 80 00       	push   $0x803e25
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
  8008d3:	68 2e 3e 80 00       	push   $0x803e2e
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
  800900:	be 31 3e 80 00       	mov    $0x803e31,%esi
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
  801326:	68 90 3f 80 00       	push   $0x803f90
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
  8013f6:	e8 b2 05 00 00       	call   8019ad <sys_allocate_chunk>
  8013fb:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013fe:	a1 20 51 80 00       	mov    0x805120,%eax
  801403:	83 ec 0c             	sub    $0xc,%esp
  801406:	50                   	push   %eax
  801407:	e8 27 0c 00 00       	call   802033 <initialize_MemBlocksList>
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
  801434:	68 b5 3f 80 00       	push   $0x803fb5
  801439:	6a 33                	push   $0x33
  80143b:	68 d3 3f 80 00       	push   $0x803fd3
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
  8014b3:	68 e0 3f 80 00       	push   $0x803fe0
  8014b8:	6a 34                	push   $0x34
  8014ba:	68 d3 3f 80 00       	push   $0x803fd3
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
  80154b:	e8 2b 08 00 00       	call   801d7b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801550:	85 c0                	test   %eax,%eax
  801552:	74 11                	je     801565 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801554:	83 ec 0c             	sub    $0xc,%esp
  801557:	ff 75 e8             	pushl  -0x18(%ebp)
  80155a:	e8 96 0e 00 00       	call   8023f5 <alloc_block_FF>
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
  801571:	e8 f2 0b 00 00       	call   802168 <insert_sorted_allocList>
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
  80158b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	50                   	push   %eax
  801595:	68 40 50 80 00       	push   $0x805040
  80159a:	e8 71 0b 00 00       	call   802110 <find_block>
  80159f:	83 c4 10             	add    $0x10,%esp
  8015a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8015a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015a9:	0f 84 a6 00 00 00    	je     801655 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8015af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b2:	8b 50 0c             	mov    0xc(%eax),%edx
  8015b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b8:	8b 40 08             	mov    0x8(%eax),%eax
  8015bb:	83 ec 08             	sub    $0x8,%esp
  8015be:	52                   	push   %edx
  8015bf:	50                   	push   %eax
  8015c0:	e8 b0 03 00 00       	call   801975 <sys_free_user_mem>
  8015c5:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8015c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015cc:	75 14                	jne    8015e2 <free+0x5a>
  8015ce:	83 ec 04             	sub    $0x4,%esp
  8015d1:	68 b5 3f 80 00       	push   $0x803fb5
  8015d6:	6a 74                	push   $0x74
  8015d8:	68 d3 3f 80 00       	push   $0x803fd3
  8015dd:	e8 ef ec ff ff       	call   8002d1 <_panic>
  8015e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e5:	8b 00                	mov    (%eax),%eax
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	74 10                	je     8015fb <free+0x73>
  8015eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ee:	8b 00                	mov    (%eax),%eax
  8015f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f3:	8b 52 04             	mov    0x4(%edx),%edx
  8015f6:	89 50 04             	mov    %edx,0x4(%eax)
  8015f9:	eb 0b                	jmp    801606 <free+0x7e>
  8015fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fe:	8b 40 04             	mov    0x4(%eax),%eax
  801601:	a3 44 50 80 00       	mov    %eax,0x805044
  801606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801609:	8b 40 04             	mov    0x4(%eax),%eax
  80160c:	85 c0                	test   %eax,%eax
  80160e:	74 0f                	je     80161f <free+0x97>
  801610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801613:	8b 40 04             	mov    0x4(%eax),%eax
  801616:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801619:	8b 12                	mov    (%edx),%edx
  80161b:	89 10                	mov    %edx,(%eax)
  80161d:	eb 0a                	jmp    801629 <free+0xa1>
  80161f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801622:	8b 00                	mov    (%eax),%eax
  801624:	a3 40 50 80 00       	mov    %eax,0x805040
  801629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801635:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80163c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801641:	48                   	dec    %eax
  801642:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801647:	83 ec 0c             	sub    $0xc,%esp
  80164a:	ff 75 f4             	pushl  -0xc(%ebp)
  80164d:	e8 4e 17 00 00       	call   802da0 <insert_sorted_with_merge_freeList>
  801652:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801655:	90                   	nop
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 38             	sub    $0x38,%esp
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801664:	e8 a6 fc ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  801669:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80166d:	75 0a                	jne    801679 <smalloc+0x21>
  80166f:	b8 00 00 00 00       	mov    $0x0,%eax
  801674:	e9 8b 00 00 00       	jmp    801704 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801679:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801680:	8b 55 0c             	mov    0xc(%ebp),%edx
  801683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801686:	01 d0                	add    %edx,%eax
  801688:	48                   	dec    %eax
  801689:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80168c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168f:	ba 00 00 00 00       	mov    $0x0,%edx
  801694:	f7 75 f0             	divl   -0x10(%ebp)
  801697:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169a:	29 d0                	sub    %edx,%eax
  80169c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80169f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016a6:	e8 d0 06 00 00       	call   801d7b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	74 11                	je     8016c0 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8016af:	83 ec 0c             	sub    $0xc,%esp
  8016b2:	ff 75 e8             	pushl  -0x18(%ebp)
  8016b5:	e8 3b 0d 00 00       	call   8023f5 <alloc_block_FF>
  8016ba:	83 c4 10             	add    $0x10,%esp
  8016bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8016c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016c4:	74 39                	je     8016ff <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	8b 40 08             	mov    0x8(%eax),%eax
  8016cc:	89 c2                	mov    %eax,%edx
  8016ce:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016d2:	52                   	push   %edx
  8016d3:	50                   	push   %eax
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	ff 75 08             	pushl  0x8(%ebp)
  8016da:	e8 21 04 00 00       	call   801b00 <sys_createSharedObject>
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016e5:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016e9:	74 14                	je     8016ff <smalloc+0xa7>
  8016eb:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016ef:	74 0e                	je     8016ff <smalloc+0xa7>
  8016f1:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016f5:	74 08                	je     8016ff <smalloc+0xa7>
			return (void*) mem_block->sva;
  8016f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fa:	8b 40 08             	mov    0x8(%eax),%eax
  8016fd:	eb 05                	jmp    801704 <smalloc+0xac>
	}
	return NULL;
  8016ff:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80170c:	e8 fe fb ff ff       	call   80130f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801711:	83 ec 08             	sub    $0x8,%esp
  801714:	ff 75 0c             	pushl  0xc(%ebp)
  801717:	ff 75 08             	pushl  0x8(%ebp)
  80171a:	e8 0b 04 00 00       	call   801b2a <sys_getSizeOfSharedObject>
  80171f:	83 c4 10             	add    $0x10,%esp
  801722:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801725:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801729:	74 76                	je     8017a1 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80172b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801732:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801738:	01 d0                	add    %edx,%eax
  80173a:	48                   	dec    %eax
  80173b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80173e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801741:	ba 00 00 00 00       	mov    $0x0,%edx
  801746:	f7 75 ec             	divl   -0x14(%ebp)
  801749:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80174c:	29 d0                	sub    %edx,%eax
  80174e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801751:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801758:	e8 1e 06 00 00       	call   801d7b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80175d:	85 c0                	test   %eax,%eax
  80175f:	74 11                	je     801772 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801761:	83 ec 0c             	sub    $0xc,%esp
  801764:	ff 75 e4             	pushl  -0x1c(%ebp)
  801767:	e8 89 0c 00 00       	call   8023f5 <alloc_block_FF>
  80176c:	83 c4 10             	add    $0x10,%esp
  80176f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801772:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801776:	74 29                	je     8017a1 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177b:	8b 40 08             	mov    0x8(%eax),%eax
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	50                   	push   %eax
  801782:	ff 75 0c             	pushl  0xc(%ebp)
  801785:	ff 75 08             	pushl  0x8(%ebp)
  801788:	e8 ba 03 00 00       	call   801b47 <sys_getSharedObject>
  80178d:	83 c4 10             	add    $0x10,%esp
  801790:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801793:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801797:	74 08                	je     8017a1 <sget+0x9b>
				return (void *)mem_block->sva;
  801799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179c:	8b 40 08             	mov    0x8(%eax),%eax
  80179f:	eb 05                	jmp    8017a6 <sget+0xa0>
		}
	}
	return NULL;
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ae:	e8 5c fb ff ff       	call   80130f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	68 04 40 80 00       	push   $0x804004
  8017bb:	68 f7 00 00 00       	push   $0xf7
  8017c0:	68 d3 3f 80 00       	push   $0x803fd3
  8017c5:	e8 07 eb ff ff       	call   8002d1 <_panic>

008017ca <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017d0:	83 ec 04             	sub    $0x4,%esp
  8017d3:	68 2c 40 80 00       	push   $0x80402c
  8017d8:	68 0b 01 00 00       	push   $0x10b
  8017dd:	68 d3 3f 80 00       	push   $0x803fd3
  8017e2:	e8 ea ea ff ff       	call   8002d1 <_panic>

008017e7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	68 50 40 80 00       	push   $0x804050
  8017f5:	68 16 01 00 00       	push   $0x116
  8017fa:	68 d3 3f 80 00       	push   $0x803fd3
  8017ff:	e8 cd ea ff ff       	call   8002d1 <_panic>

00801804 <shrink>:

}
void shrink(uint32 newSize)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	68 50 40 80 00       	push   $0x804050
  801812:	68 1b 01 00 00       	push   $0x11b
  801817:	68 d3 3f 80 00       	push   $0x803fd3
  80181c:	e8 b0 ea ff ff       	call   8002d1 <_panic>

00801821 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801827:	83 ec 04             	sub    $0x4,%esp
  80182a:	68 50 40 80 00       	push   $0x804050
  80182f:	68 20 01 00 00       	push   $0x120
  801834:	68 d3 3f 80 00       	push   $0x803fd3
  801839:	e8 93 ea ff ff       	call   8002d1 <_panic>

0080183e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	57                   	push   %edi
  801842:	56                   	push   %esi
  801843:	53                   	push   %ebx
  801844:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801850:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801853:	8b 7d 18             	mov    0x18(%ebp),%edi
  801856:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801859:	cd 30                	int    $0x30
  80185b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80185e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801861:	83 c4 10             	add    $0x10,%esp
  801864:	5b                   	pop    %ebx
  801865:	5e                   	pop    %esi
  801866:	5f                   	pop    %edi
  801867:	5d                   	pop    %ebp
  801868:	c3                   	ret    

00801869 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	83 ec 04             	sub    $0x4,%esp
  80186f:	8b 45 10             	mov    0x10(%ebp),%eax
  801872:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801875:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	52                   	push   %edx
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	50                   	push   %eax
  801885:	6a 00                	push   $0x0
  801887:	e8 b2 ff ff ff       	call   80183e <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
}
  80188f:	90                   	nop
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_cgetc>:

int
sys_cgetc(void)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 01                	push   $0x1
  8018a1:	e8 98 ff ff ff       	call   80183e <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	52                   	push   %edx
  8018bb:	50                   	push   %eax
  8018bc:	6a 05                	push   $0x5
  8018be:	e8 7b ff ff ff       	call   80183e <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	56                   	push   %esi
  8018cc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018cd:	8b 75 18             	mov    0x18(%ebp),%esi
  8018d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	56                   	push   %esi
  8018dd:	53                   	push   %ebx
  8018de:	51                   	push   %ecx
  8018df:	52                   	push   %edx
  8018e0:	50                   	push   %eax
  8018e1:	6a 06                	push   $0x6
  8018e3:	e8 56 ff ff ff       	call   80183e <syscall>
  8018e8:	83 c4 18             	add    $0x18,%esp
}
  8018eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ee:	5b                   	pop    %ebx
  8018ef:	5e                   	pop    %esi
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    

008018f2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	52                   	push   %edx
  801902:	50                   	push   %eax
  801903:	6a 07                	push   $0x7
  801905:	e8 34 ff ff ff       	call   80183e <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	ff 75 0c             	pushl  0xc(%ebp)
  80191b:	ff 75 08             	pushl  0x8(%ebp)
  80191e:	6a 08                	push   $0x8
  801920:	e8 19 ff ff ff       	call   80183e <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 09                	push   $0x9
  801939:	e8 00 ff ff ff       	call   80183e <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 0a                	push   $0xa
  801952:	e8 e7 fe ff ff       	call   80183e <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 0b                	push   $0xb
  80196b:	e8 ce fe ff ff       	call   80183e <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	ff 75 0c             	pushl  0xc(%ebp)
  801981:	ff 75 08             	pushl  0x8(%ebp)
  801984:	6a 0f                	push   $0xf
  801986:	e8 b3 fe ff ff       	call   80183e <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
	return;
  80198e:	90                   	nop
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	ff 75 0c             	pushl  0xc(%ebp)
  80199d:	ff 75 08             	pushl  0x8(%ebp)
  8019a0:	6a 10                	push   $0x10
  8019a2:	e8 97 fe ff ff       	call   80183e <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019aa:	90                   	nop
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	ff 75 10             	pushl  0x10(%ebp)
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	ff 75 08             	pushl  0x8(%ebp)
  8019bd:	6a 11                	push   $0x11
  8019bf:	e8 7a fe ff ff       	call   80183e <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c7:	90                   	nop
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 0c                	push   $0xc
  8019d9:	e8 60 fe ff ff       	call   80183e <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	ff 75 08             	pushl  0x8(%ebp)
  8019f1:	6a 0d                	push   $0xd
  8019f3:	e8 46 fe ff ff       	call   80183e <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 0e                	push   $0xe
  801a0c:	e8 2d fe ff ff       	call   80183e <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	90                   	nop
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 13                	push   $0x13
  801a26:	e8 13 fe ff ff       	call   80183e <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	90                   	nop
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 14                	push   $0x14
  801a40:	e8 f9 fd ff ff       	call   80183e <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	90                   	nop
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_cputc>:


void
sys_cputc(const char c)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 04             	sub    $0x4,%esp
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a57:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	50                   	push   %eax
  801a64:	6a 15                	push   $0x15
  801a66:	e8 d3 fd ff ff       	call   80183e <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	90                   	nop
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 16                	push   $0x16
  801a80:	e8 b9 fd ff ff       	call   80183e <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	90                   	nop
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	ff 75 0c             	pushl  0xc(%ebp)
  801a9a:	50                   	push   %eax
  801a9b:	6a 17                	push   $0x17
  801a9d:	e8 9c fd ff ff       	call   80183e <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	52                   	push   %edx
  801ab7:	50                   	push   %eax
  801ab8:	6a 1a                	push   $0x1a
  801aba:	e8 7f fd ff ff       	call   80183e <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	52                   	push   %edx
  801ad4:	50                   	push   %eax
  801ad5:	6a 18                	push   $0x18
  801ad7:	e8 62 fd ff ff       	call   80183e <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	90                   	nop
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	52                   	push   %edx
  801af2:	50                   	push   %eax
  801af3:	6a 19                	push   $0x19
  801af5:	e8 44 fd ff ff       	call   80183e <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	90                   	nop
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	83 ec 04             	sub    $0x4,%esp
  801b06:	8b 45 10             	mov    0x10(%ebp),%eax
  801b09:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b0c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b0f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	51                   	push   %ecx
  801b19:	52                   	push   %edx
  801b1a:	ff 75 0c             	pushl  0xc(%ebp)
  801b1d:	50                   	push   %eax
  801b1e:	6a 1b                	push   $0x1b
  801b20:	e8 19 fd ff ff       	call   80183e <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	52                   	push   %edx
  801b3a:	50                   	push   %eax
  801b3b:	6a 1c                	push   $0x1c
  801b3d:	e8 fc fc ff ff       	call   80183e <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	51                   	push   %ecx
  801b58:	52                   	push   %edx
  801b59:	50                   	push   %eax
  801b5a:	6a 1d                	push   $0x1d
  801b5c:	e8 dd fc ff ff       	call   80183e <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	52                   	push   %edx
  801b76:	50                   	push   %eax
  801b77:	6a 1e                	push   $0x1e
  801b79:	e8 c0 fc ff ff       	call   80183e <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 1f                	push   $0x1f
  801b92:	e8 a7 fc ff ff       	call   80183e <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	ff 75 14             	pushl  0x14(%ebp)
  801ba7:	ff 75 10             	pushl  0x10(%ebp)
  801baa:	ff 75 0c             	pushl  0xc(%ebp)
  801bad:	50                   	push   %eax
  801bae:	6a 20                	push   $0x20
  801bb0:	e8 89 fc ff ff       	call   80183e <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	50                   	push   %eax
  801bc9:	6a 21                	push   $0x21
  801bcb:	e8 6e fc ff ff       	call   80183e <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	90                   	nop
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	50                   	push   %eax
  801be5:	6a 22                	push   $0x22
  801be7:	e8 52 fc ff ff       	call   80183e <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 02                	push   $0x2
  801c00:	e8 39 fc ff ff       	call   80183e <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 03                	push   $0x3
  801c19:	e8 20 fc ff ff       	call   80183e <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 04                	push   $0x4
  801c32:	e8 07 fc ff ff       	call   80183e <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_exit_env>:


void sys_exit_env(void)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 23                	push   $0x23
  801c4b:	e8 ee fb ff ff       	call   80183e <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	90                   	nop
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c5c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5f:	8d 50 04             	lea    0x4(%eax),%edx
  801c62:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	52                   	push   %edx
  801c6c:	50                   	push   %eax
  801c6d:	6a 24                	push   $0x24
  801c6f:	e8 ca fb ff ff       	call   80183e <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
	return result;
  801c77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c80:	89 01                	mov    %eax,(%ecx)
  801c82:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	c9                   	leave  
  801c89:	c2 04 00             	ret    $0x4

00801c8c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	ff 75 10             	pushl  0x10(%ebp)
  801c96:	ff 75 0c             	pushl  0xc(%ebp)
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	6a 12                	push   $0x12
  801c9e:	e8 9b fb ff ff       	call   80183e <syscall>
  801ca3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca6:	90                   	nop
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 25                	push   $0x25
  801cb8:	e8 81 fb ff ff       	call   80183e <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 04             	sub    $0x4,%esp
  801cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cce:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	50                   	push   %eax
  801cdb:	6a 26                	push   $0x26
  801cdd:	e8 5c fb ff ff       	call   80183e <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce5:	90                   	nop
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <rsttst>:
void rsttst()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 28                	push   $0x28
  801cf7:	e8 42 fb ff ff       	call   80183e <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cff:	90                   	nop
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 04             	sub    $0x4,%esp
  801d08:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d0e:	8b 55 18             	mov    0x18(%ebp),%edx
  801d11:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d15:	52                   	push   %edx
  801d16:	50                   	push   %eax
  801d17:	ff 75 10             	pushl  0x10(%ebp)
  801d1a:	ff 75 0c             	pushl  0xc(%ebp)
  801d1d:	ff 75 08             	pushl  0x8(%ebp)
  801d20:	6a 27                	push   $0x27
  801d22:	e8 17 fb ff ff       	call   80183e <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2a:	90                   	nop
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <chktst>:
void chktst(uint32 n)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	ff 75 08             	pushl  0x8(%ebp)
  801d3b:	6a 29                	push   $0x29
  801d3d:	e8 fc fa ff ff       	call   80183e <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
	return ;
  801d45:	90                   	nop
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <inctst>:

void inctst()
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 2a                	push   $0x2a
  801d57:	e8 e2 fa ff ff       	call   80183e <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5f:	90                   	nop
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <gettst>:
uint32 gettst()
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 2b                	push   $0x2b
  801d71:	e8 c8 fa ff ff       	call   80183e <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 2c                	push   $0x2c
  801d8d:	e8 ac fa ff ff       	call   80183e <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
  801d95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d98:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d9c:	75 07                	jne    801da5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801da3:	eb 05                	jmp    801daa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801da5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 2c                	push   $0x2c
  801dbe:	e8 7b fa ff ff       	call   80183e <syscall>
  801dc3:	83 c4 18             	add    $0x18,%esp
  801dc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dc9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dcd:	75 07                	jne    801dd6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dcf:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd4:	eb 05                	jmp    801ddb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
  801de0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 2c                	push   $0x2c
  801def:	e8 4a fa ff ff       	call   80183e <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
  801df7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dfa:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dfe:	75 07                	jne    801e07 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e00:	b8 01 00 00 00       	mov    $0x1,%eax
  801e05:	eb 05                	jmp    801e0c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 2c                	push   $0x2c
  801e20:	e8 19 fa ff ff       	call   80183e <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
  801e28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e2b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e2f:	75 07                	jne    801e38 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e31:	b8 01 00 00 00       	mov    $0x1,%eax
  801e36:	eb 05                	jmp    801e3d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	ff 75 08             	pushl  0x8(%ebp)
  801e4d:	6a 2d                	push   $0x2d
  801e4f:	e8 ea f9 ff ff       	call   80183e <syscall>
  801e54:	83 c4 18             	add    $0x18,%esp
	return ;
  801e57:	90                   	nop
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e5e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e61:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	6a 00                	push   $0x0
  801e6c:	53                   	push   %ebx
  801e6d:	51                   	push   %ecx
  801e6e:	52                   	push   %edx
  801e6f:	50                   	push   %eax
  801e70:	6a 2e                	push   $0x2e
  801e72:	e8 c7 f9 ff ff       	call   80183e <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	52                   	push   %edx
  801e8f:	50                   	push   %eax
  801e90:	6a 2f                	push   $0x2f
  801e92:	e8 a7 f9 ff ff       	call   80183e <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ea2:	83 ec 0c             	sub    $0xc,%esp
  801ea5:	68 60 40 80 00       	push   $0x804060
  801eaa:	e8 d6 e6 ff ff       	call   800585 <cprintf>
  801eaf:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801eb2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eb9:	83 ec 0c             	sub    $0xc,%esp
  801ebc:	68 8c 40 80 00       	push   $0x80408c
  801ec1:	e8 bf e6 ff ff       	call   800585 <cprintf>
  801ec6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ec9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ecd:	a1 38 51 80 00       	mov    0x805138,%eax
  801ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed5:	eb 56                	jmp    801f2d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ed7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801edb:	74 1c                	je     801ef9 <print_mem_block_lists+0x5d>
  801edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee0:	8b 50 08             	mov    0x8(%eax),%edx
  801ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee6:	8b 48 08             	mov    0x8(%eax),%ecx
  801ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eec:	8b 40 0c             	mov    0xc(%eax),%eax
  801eef:	01 c8                	add    %ecx,%eax
  801ef1:	39 c2                	cmp    %eax,%edx
  801ef3:	73 04                	jae    801ef9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ef5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efc:	8b 50 08             	mov    0x8(%eax),%edx
  801eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f02:	8b 40 0c             	mov    0xc(%eax),%eax
  801f05:	01 c2                	add    %eax,%edx
  801f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0a:	8b 40 08             	mov    0x8(%eax),%eax
  801f0d:	83 ec 04             	sub    $0x4,%esp
  801f10:	52                   	push   %edx
  801f11:	50                   	push   %eax
  801f12:	68 a1 40 80 00       	push   $0x8040a1
  801f17:	e8 69 e6 ff ff       	call   800585 <cprintf>
  801f1c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f25:	a1 40 51 80 00       	mov    0x805140,%eax
  801f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f31:	74 07                	je     801f3a <print_mem_block_lists+0x9e>
  801f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f36:	8b 00                	mov    (%eax),%eax
  801f38:	eb 05                	jmp    801f3f <print_mem_block_lists+0xa3>
  801f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3f:	a3 40 51 80 00       	mov    %eax,0x805140
  801f44:	a1 40 51 80 00       	mov    0x805140,%eax
  801f49:	85 c0                	test   %eax,%eax
  801f4b:	75 8a                	jne    801ed7 <print_mem_block_lists+0x3b>
  801f4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f51:	75 84                	jne    801ed7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f53:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f57:	75 10                	jne    801f69 <print_mem_block_lists+0xcd>
  801f59:	83 ec 0c             	sub    $0xc,%esp
  801f5c:	68 b0 40 80 00       	push   $0x8040b0
  801f61:	e8 1f e6 ff ff       	call   800585 <cprintf>
  801f66:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f69:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f70:	83 ec 0c             	sub    $0xc,%esp
  801f73:	68 d4 40 80 00       	push   $0x8040d4
  801f78:	e8 08 e6 ff ff       	call   800585 <cprintf>
  801f7d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f80:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f84:	a1 40 50 80 00       	mov    0x805040,%eax
  801f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8c:	eb 56                	jmp    801fe4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f92:	74 1c                	je     801fb0 <print_mem_block_lists+0x114>
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	8b 50 08             	mov    0x8(%eax),%edx
  801f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9d:	8b 48 08             	mov    0x8(%eax),%ecx
  801fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa3:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa6:	01 c8                	add    %ecx,%eax
  801fa8:	39 c2                	cmp    %eax,%edx
  801faa:	73 04                	jae    801fb0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fac:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb3:	8b 50 08             	mov    0x8(%eax),%edx
  801fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb9:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbc:	01 c2                	add    %eax,%edx
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	8b 40 08             	mov    0x8(%eax),%eax
  801fc4:	83 ec 04             	sub    $0x4,%esp
  801fc7:	52                   	push   %edx
  801fc8:	50                   	push   %eax
  801fc9:	68 a1 40 80 00       	push   $0x8040a1
  801fce:	e8 b2 e5 ff ff       	call   800585 <cprintf>
  801fd3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fdc:	a1 48 50 80 00       	mov    0x805048,%eax
  801fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe8:	74 07                	je     801ff1 <print_mem_block_lists+0x155>
  801fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fed:	8b 00                	mov    (%eax),%eax
  801fef:	eb 05                	jmp    801ff6 <print_mem_block_lists+0x15a>
  801ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff6:	a3 48 50 80 00       	mov    %eax,0x805048
  801ffb:	a1 48 50 80 00       	mov    0x805048,%eax
  802000:	85 c0                	test   %eax,%eax
  802002:	75 8a                	jne    801f8e <print_mem_block_lists+0xf2>
  802004:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802008:	75 84                	jne    801f8e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80200a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80200e:	75 10                	jne    802020 <print_mem_block_lists+0x184>
  802010:	83 ec 0c             	sub    $0xc,%esp
  802013:	68 ec 40 80 00       	push   $0x8040ec
  802018:	e8 68 e5 ff ff       	call   800585 <cprintf>
  80201d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802020:	83 ec 0c             	sub    $0xc,%esp
  802023:	68 60 40 80 00       	push   $0x804060
  802028:	e8 58 e5 ff ff       	call   800585 <cprintf>
  80202d:	83 c4 10             	add    $0x10,%esp

}
  802030:	90                   	nop
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802039:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802040:	00 00 00 
  802043:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80204a:	00 00 00 
  80204d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802054:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802057:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80205e:	e9 9e 00 00 00       	jmp    802101 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802063:	a1 50 50 80 00       	mov    0x805050,%eax
  802068:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206b:	c1 e2 04             	shl    $0x4,%edx
  80206e:	01 d0                	add    %edx,%eax
  802070:	85 c0                	test   %eax,%eax
  802072:	75 14                	jne    802088 <initialize_MemBlocksList+0x55>
  802074:	83 ec 04             	sub    $0x4,%esp
  802077:	68 14 41 80 00       	push   $0x804114
  80207c:	6a 46                	push   $0x46
  80207e:	68 37 41 80 00       	push   $0x804137
  802083:	e8 49 e2 ff ff       	call   8002d1 <_panic>
  802088:	a1 50 50 80 00       	mov    0x805050,%eax
  80208d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802090:	c1 e2 04             	shl    $0x4,%edx
  802093:	01 d0                	add    %edx,%eax
  802095:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80209b:	89 10                	mov    %edx,(%eax)
  80209d:	8b 00                	mov    (%eax),%eax
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	74 18                	je     8020bb <initialize_MemBlocksList+0x88>
  8020a3:	a1 48 51 80 00       	mov    0x805148,%eax
  8020a8:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020ae:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020b1:	c1 e1 04             	shl    $0x4,%ecx
  8020b4:	01 ca                	add    %ecx,%edx
  8020b6:	89 50 04             	mov    %edx,0x4(%eax)
  8020b9:	eb 12                	jmp    8020cd <initialize_MemBlocksList+0x9a>
  8020bb:	a1 50 50 80 00       	mov    0x805050,%eax
  8020c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c3:	c1 e2 04             	shl    $0x4,%edx
  8020c6:	01 d0                	add    %edx,%eax
  8020c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8020d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d5:	c1 e2 04             	shl    $0x4,%edx
  8020d8:	01 d0                	add    %edx,%eax
  8020da:	a3 48 51 80 00       	mov    %eax,0x805148
  8020df:	a1 50 50 80 00       	mov    0x805050,%eax
  8020e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e7:	c1 e2 04             	shl    $0x4,%edx
  8020ea:	01 d0                	add    %edx,%eax
  8020ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020f3:	a1 54 51 80 00       	mov    0x805154,%eax
  8020f8:	40                   	inc    %eax
  8020f9:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020fe:	ff 45 f4             	incl   -0xc(%ebp)
  802101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802104:	3b 45 08             	cmp    0x8(%ebp),%eax
  802107:	0f 82 56 ff ff ff    	jb     802063 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80210d:	90                   	nop
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	8b 00                	mov    (%eax),%eax
  80211b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80211e:	eb 19                	jmp    802139 <find_block+0x29>
	{
		if(va==point->sva)
  802120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802123:	8b 40 08             	mov    0x8(%eax),%eax
  802126:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802129:	75 05                	jne    802130 <find_block+0x20>
		   return point;
  80212b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212e:	eb 36                	jmp    802166 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	8b 40 08             	mov    0x8(%eax),%eax
  802136:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802139:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80213d:	74 07                	je     802146 <find_block+0x36>
  80213f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802142:	8b 00                	mov    (%eax),%eax
  802144:	eb 05                	jmp    80214b <find_block+0x3b>
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
  80214b:	8b 55 08             	mov    0x8(%ebp),%edx
  80214e:	89 42 08             	mov    %eax,0x8(%edx)
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	8b 40 08             	mov    0x8(%eax),%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	75 c5                	jne    802120 <find_block+0x10>
  80215b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80215f:	75 bf                	jne    802120 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802161:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80216e:	a1 40 50 80 00       	mov    0x805040,%eax
  802173:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802176:	a1 44 50 80 00       	mov    0x805044,%eax
  80217b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80217e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802181:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802184:	74 24                	je     8021aa <insert_sorted_allocList+0x42>
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	8b 50 08             	mov    0x8(%eax),%edx
  80218c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218f:	8b 40 08             	mov    0x8(%eax),%eax
  802192:	39 c2                	cmp    %eax,%edx
  802194:	76 14                	jbe    8021aa <insert_sorted_allocList+0x42>
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	8b 50 08             	mov    0x8(%eax),%edx
  80219c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219f:	8b 40 08             	mov    0x8(%eax),%eax
  8021a2:	39 c2                	cmp    %eax,%edx
  8021a4:	0f 82 60 01 00 00    	jb     80230a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ae:	75 65                	jne    802215 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b4:	75 14                	jne    8021ca <insert_sorted_allocList+0x62>
  8021b6:	83 ec 04             	sub    $0x4,%esp
  8021b9:	68 14 41 80 00       	push   $0x804114
  8021be:	6a 6b                	push   $0x6b
  8021c0:	68 37 41 80 00       	push   $0x804137
  8021c5:	e8 07 e1 ff ff       	call   8002d1 <_panic>
  8021ca:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	89 10                	mov    %edx,(%eax)
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	8b 00                	mov    (%eax),%eax
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	74 0d                	je     8021eb <insert_sorted_allocList+0x83>
  8021de:	a1 40 50 80 00       	mov    0x805040,%eax
  8021e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e6:	89 50 04             	mov    %edx,0x4(%eax)
  8021e9:	eb 08                	jmp    8021f3 <insert_sorted_allocList+0x8b>
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	a3 44 50 80 00       	mov    %eax,0x805044
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	a3 40 50 80 00       	mov    %eax,0x805040
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802205:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80220a:	40                   	inc    %eax
  80220b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802210:	e9 dc 01 00 00       	jmp    8023f1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	8b 50 08             	mov    0x8(%eax),%edx
  80221b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221e:	8b 40 08             	mov    0x8(%eax),%eax
  802221:	39 c2                	cmp    %eax,%edx
  802223:	77 6c                	ja     802291 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802225:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802229:	74 06                	je     802231 <insert_sorted_allocList+0xc9>
  80222b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80222f:	75 14                	jne    802245 <insert_sorted_allocList+0xdd>
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	68 50 41 80 00       	push   $0x804150
  802239:	6a 6f                	push   $0x6f
  80223b:	68 37 41 80 00       	push   $0x804137
  802240:	e8 8c e0 ff ff       	call   8002d1 <_panic>
  802245:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802248:	8b 50 04             	mov    0x4(%eax),%edx
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	89 50 04             	mov    %edx,0x4(%eax)
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802257:	89 10                	mov    %edx,(%eax)
  802259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225c:	8b 40 04             	mov    0x4(%eax),%eax
  80225f:	85 c0                	test   %eax,%eax
  802261:	74 0d                	je     802270 <insert_sorted_allocList+0x108>
  802263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802266:	8b 40 04             	mov    0x4(%eax),%eax
  802269:	8b 55 08             	mov    0x8(%ebp),%edx
  80226c:	89 10                	mov    %edx,(%eax)
  80226e:	eb 08                	jmp    802278 <insert_sorted_allocList+0x110>
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	a3 40 50 80 00       	mov    %eax,0x805040
  802278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227b:	8b 55 08             	mov    0x8(%ebp),%edx
  80227e:	89 50 04             	mov    %edx,0x4(%eax)
  802281:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802286:	40                   	inc    %eax
  802287:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80228c:	e9 60 01 00 00       	jmp    8023f1 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	8b 50 08             	mov    0x8(%eax),%edx
  802297:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229a:	8b 40 08             	mov    0x8(%eax),%eax
  80229d:	39 c2                	cmp    %eax,%edx
  80229f:	0f 82 4c 01 00 00    	jb     8023f1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a9:	75 14                	jne    8022bf <insert_sorted_allocList+0x157>
  8022ab:	83 ec 04             	sub    $0x4,%esp
  8022ae:	68 88 41 80 00       	push   $0x804188
  8022b3:	6a 73                	push   $0x73
  8022b5:	68 37 41 80 00       	push   $0x804137
  8022ba:	e8 12 e0 ff ff       	call   8002d1 <_panic>
  8022bf:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	89 50 04             	mov    %edx,0x4(%eax)
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	8b 40 04             	mov    0x4(%eax),%eax
  8022d1:	85 c0                	test   %eax,%eax
  8022d3:	74 0c                	je     8022e1 <insert_sorted_allocList+0x179>
  8022d5:	a1 44 50 80 00       	mov    0x805044,%eax
  8022da:	8b 55 08             	mov    0x8(%ebp),%edx
  8022dd:	89 10                	mov    %edx,(%eax)
  8022df:	eb 08                	jmp    8022e9 <insert_sorted_allocList+0x181>
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	a3 40 50 80 00       	mov    %eax,0x805040
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	a3 44 50 80 00       	mov    %eax,0x805044
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022fa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ff:	40                   	inc    %eax
  802300:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802305:	e9 e7 00 00 00       	jmp    8023f1 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80230a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802310:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802317:	a1 40 50 80 00       	mov    0x805040,%eax
  80231c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231f:	e9 9d 00 00 00       	jmp    8023c1 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	8b 00                	mov    (%eax),%eax
  802329:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	8b 50 08             	mov    0x8(%eax),%edx
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	8b 40 08             	mov    0x8(%eax),%eax
  802338:	39 c2                	cmp    %eax,%edx
  80233a:	76 7d                	jbe    8023b9 <insert_sorted_allocList+0x251>
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
  80233f:	8b 50 08             	mov    0x8(%eax),%edx
  802342:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802345:	8b 40 08             	mov    0x8(%eax),%eax
  802348:	39 c2                	cmp    %eax,%edx
  80234a:	73 6d                	jae    8023b9 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80234c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802350:	74 06                	je     802358 <insert_sorted_allocList+0x1f0>
  802352:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802356:	75 14                	jne    80236c <insert_sorted_allocList+0x204>
  802358:	83 ec 04             	sub    $0x4,%esp
  80235b:	68 ac 41 80 00       	push   $0x8041ac
  802360:	6a 7f                	push   $0x7f
  802362:	68 37 41 80 00       	push   $0x804137
  802367:	e8 65 df ff ff       	call   8002d1 <_panic>
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 10                	mov    (%eax),%edx
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	89 10                	mov    %edx,(%eax)
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	8b 00                	mov    (%eax),%eax
  80237b:	85 c0                	test   %eax,%eax
  80237d:	74 0b                	je     80238a <insert_sorted_allocList+0x222>
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	8b 00                	mov    (%eax),%eax
  802384:	8b 55 08             	mov    0x8(%ebp),%edx
  802387:	89 50 04             	mov    %edx,0x4(%eax)
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 55 08             	mov    0x8(%ebp),%edx
  802390:	89 10                	mov    %edx,(%eax)
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802398:	89 50 04             	mov    %edx,0x4(%eax)
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	8b 00                	mov    (%eax),%eax
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	75 08                	jne    8023ac <insert_sorted_allocList+0x244>
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	a3 44 50 80 00       	mov    %eax,0x805044
  8023ac:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023b1:	40                   	inc    %eax
  8023b2:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023b7:	eb 39                	jmp    8023f2 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023b9:	a1 48 50 80 00       	mov    0x805048,%eax
  8023be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c5:	74 07                	je     8023ce <insert_sorted_allocList+0x266>
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 00                	mov    (%eax),%eax
  8023cc:	eb 05                	jmp    8023d3 <insert_sorted_allocList+0x26b>
  8023ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d3:	a3 48 50 80 00       	mov    %eax,0x805048
  8023d8:	a1 48 50 80 00       	mov    0x805048,%eax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	0f 85 3f ff ff ff    	jne    802324 <insert_sorted_allocList+0x1bc>
  8023e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e9:	0f 85 35 ff ff ff    	jne    802324 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023ef:	eb 01                	jmp    8023f2 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023f1:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023f2:	90                   	nop
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
  8023f8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023fb:	a1 38 51 80 00       	mov    0x805138,%eax
  802400:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802403:	e9 85 01 00 00       	jmp    80258d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 40 0c             	mov    0xc(%eax),%eax
  80240e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802411:	0f 82 6e 01 00 00    	jb     802585 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 40 0c             	mov    0xc(%eax),%eax
  80241d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802420:	0f 85 8a 00 00 00    	jne    8024b0 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242a:	75 17                	jne    802443 <alloc_block_FF+0x4e>
  80242c:	83 ec 04             	sub    $0x4,%esp
  80242f:	68 e0 41 80 00       	push   $0x8041e0
  802434:	68 93 00 00 00       	push   $0x93
  802439:	68 37 41 80 00       	push   $0x804137
  80243e:	e8 8e de ff ff       	call   8002d1 <_panic>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 00                	mov    (%eax),%eax
  802448:	85 c0                	test   %eax,%eax
  80244a:	74 10                	je     80245c <alloc_block_FF+0x67>
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	8b 00                	mov    (%eax),%eax
  802451:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802454:	8b 52 04             	mov    0x4(%edx),%edx
  802457:	89 50 04             	mov    %edx,0x4(%eax)
  80245a:	eb 0b                	jmp    802467 <alloc_block_FF+0x72>
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	8b 40 04             	mov    0x4(%eax),%eax
  802462:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 40 04             	mov    0x4(%eax),%eax
  80246d:	85 c0                	test   %eax,%eax
  80246f:	74 0f                	je     802480 <alloc_block_FF+0x8b>
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	8b 40 04             	mov    0x4(%eax),%eax
  802477:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247a:	8b 12                	mov    (%edx),%edx
  80247c:	89 10                	mov    %edx,(%eax)
  80247e:	eb 0a                	jmp    80248a <alloc_block_FF+0x95>
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 00                	mov    (%eax),%eax
  802485:	a3 38 51 80 00       	mov    %eax,0x805138
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80249d:	a1 44 51 80 00       	mov    0x805144,%eax
  8024a2:	48                   	dec    %eax
  8024a3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	e9 10 01 00 00       	jmp    8025c0 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b9:	0f 86 c6 00 00 00    	jbe    802585 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8024c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 50 08             	mov    0x8(%eax),%edx
  8024cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d0:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d9:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024e0:	75 17                	jne    8024f9 <alloc_block_FF+0x104>
  8024e2:	83 ec 04             	sub    $0x4,%esp
  8024e5:	68 e0 41 80 00       	push   $0x8041e0
  8024ea:	68 9b 00 00 00       	push   $0x9b
  8024ef:	68 37 41 80 00       	push   $0x804137
  8024f4:	e8 d8 dd ff ff       	call   8002d1 <_panic>
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	8b 00                	mov    (%eax),%eax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	74 10                	je     802512 <alloc_block_FF+0x11d>
  802502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802505:	8b 00                	mov    (%eax),%eax
  802507:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250a:	8b 52 04             	mov    0x4(%edx),%edx
  80250d:	89 50 04             	mov    %edx,0x4(%eax)
  802510:	eb 0b                	jmp    80251d <alloc_block_FF+0x128>
  802512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802515:	8b 40 04             	mov    0x4(%eax),%eax
  802518:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80251d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802520:	8b 40 04             	mov    0x4(%eax),%eax
  802523:	85 c0                	test   %eax,%eax
  802525:	74 0f                	je     802536 <alloc_block_FF+0x141>
  802527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252a:	8b 40 04             	mov    0x4(%eax),%eax
  80252d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802530:	8b 12                	mov    (%edx),%edx
  802532:	89 10                	mov    %edx,(%eax)
  802534:	eb 0a                	jmp    802540 <alloc_block_FF+0x14b>
  802536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802539:	8b 00                	mov    (%eax),%eax
  80253b:	a3 48 51 80 00       	mov    %eax,0x805148
  802540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802543:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802553:	a1 54 51 80 00       	mov    0x805154,%eax
  802558:	48                   	dec    %eax
  802559:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 50 08             	mov    0x8(%eax),%edx
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	01 c2                	add    %eax,%edx
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 40 0c             	mov    0xc(%eax),%eax
  802575:	2b 45 08             	sub    0x8(%ebp),%eax
  802578:	89 c2                	mov    %eax,%edx
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802583:	eb 3b                	jmp    8025c0 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802585:	a1 40 51 80 00       	mov    0x805140,%eax
  80258a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802591:	74 07                	je     80259a <alloc_block_FF+0x1a5>
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	eb 05                	jmp    80259f <alloc_block_FF+0x1aa>
  80259a:	b8 00 00 00 00       	mov    $0x0,%eax
  80259f:	a3 40 51 80 00       	mov    %eax,0x805140
  8025a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	0f 85 57 fe ff ff    	jne    802408 <alloc_block_FF+0x13>
  8025b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b5:	0f 85 4d fe ff ff    	jne    802408 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8025d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d7:	e9 df 00 00 00       	jmp    8026bb <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e5:	0f 82 c8 00 00 00    	jb     8026b3 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f4:	0f 85 8a 00 00 00    	jne    802684 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fe:	75 17                	jne    802617 <alloc_block_BF+0x55>
  802600:	83 ec 04             	sub    $0x4,%esp
  802603:	68 e0 41 80 00       	push   $0x8041e0
  802608:	68 b7 00 00 00       	push   $0xb7
  80260d:	68 37 41 80 00       	push   $0x804137
  802612:	e8 ba dc ff ff       	call   8002d1 <_panic>
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	85 c0                	test   %eax,%eax
  80261e:	74 10                	je     802630 <alloc_block_BF+0x6e>
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 00                	mov    (%eax),%eax
  802625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802628:	8b 52 04             	mov    0x4(%edx),%edx
  80262b:	89 50 04             	mov    %edx,0x4(%eax)
  80262e:	eb 0b                	jmp    80263b <alloc_block_BF+0x79>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 40 04             	mov    0x4(%eax),%eax
  802636:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 40 04             	mov    0x4(%eax),%eax
  802641:	85 c0                	test   %eax,%eax
  802643:	74 0f                	je     802654 <alloc_block_BF+0x92>
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 40 04             	mov    0x4(%eax),%eax
  80264b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264e:	8b 12                	mov    (%edx),%edx
  802650:	89 10                	mov    %edx,(%eax)
  802652:	eb 0a                	jmp    80265e <alloc_block_BF+0x9c>
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 00                	mov    (%eax),%eax
  802659:	a3 38 51 80 00       	mov    %eax,0x805138
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802671:	a1 44 51 80 00       	mov    0x805144,%eax
  802676:	48                   	dec    %eax
  802677:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	e9 4d 01 00 00       	jmp    8027d1 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 40 0c             	mov    0xc(%eax),%eax
  80268a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268d:	76 24                	jbe    8026b3 <alloc_block_BF+0xf1>
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 0c             	mov    0xc(%eax),%eax
  802695:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802698:	73 19                	jae    8026b3 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80269a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	8b 40 08             	mov    0x8(%eax),%eax
  8026b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8026b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bf:	74 07                	je     8026c8 <alloc_block_BF+0x106>
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	8b 00                	mov    (%eax),%eax
  8026c6:	eb 05                	jmp    8026cd <alloc_block_BF+0x10b>
  8026c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cd:	a3 40 51 80 00       	mov    %eax,0x805140
  8026d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	0f 85 fd fe ff ff    	jne    8025dc <alloc_block_BF+0x1a>
  8026df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e3:	0f 85 f3 fe ff ff    	jne    8025dc <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026ed:	0f 84 d9 00 00 00    	je     8027cc <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026f3:	a1 48 51 80 00       	mov    0x805148,%eax
  8026f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802701:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802707:	8b 55 08             	mov    0x8(%ebp),%edx
  80270a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80270d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802711:	75 17                	jne    80272a <alloc_block_BF+0x168>
  802713:	83 ec 04             	sub    $0x4,%esp
  802716:	68 e0 41 80 00       	push   $0x8041e0
  80271b:	68 c7 00 00 00       	push   $0xc7
  802720:	68 37 41 80 00       	push   $0x804137
  802725:	e8 a7 db ff ff       	call   8002d1 <_panic>
  80272a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	85 c0                	test   %eax,%eax
  802731:	74 10                	je     802743 <alloc_block_BF+0x181>
  802733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80273b:	8b 52 04             	mov    0x4(%edx),%edx
  80273e:	89 50 04             	mov    %edx,0x4(%eax)
  802741:	eb 0b                	jmp    80274e <alloc_block_BF+0x18c>
  802743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802746:	8b 40 04             	mov    0x4(%eax),%eax
  802749:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80274e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802751:	8b 40 04             	mov    0x4(%eax),%eax
  802754:	85 c0                	test   %eax,%eax
  802756:	74 0f                	je     802767 <alloc_block_BF+0x1a5>
  802758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275b:	8b 40 04             	mov    0x4(%eax),%eax
  80275e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802761:	8b 12                	mov    (%edx),%edx
  802763:	89 10                	mov    %edx,(%eax)
  802765:	eb 0a                	jmp    802771 <alloc_block_BF+0x1af>
  802767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276a:	8b 00                	mov    (%eax),%eax
  80276c:	a3 48 51 80 00       	mov    %eax,0x805148
  802771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802774:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802784:	a1 54 51 80 00       	mov    0x805154,%eax
  802789:	48                   	dec    %eax
  80278a:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80278f:	83 ec 08             	sub    $0x8,%esp
  802792:	ff 75 ec             	pushl  -0x14(%ebp)
  802795:	68 38 51 80 00       	push   $0x805138
  80279a:	e8 71 f9 ff ff       	call   802110 <find_block>
  80279f:	83 c4 10             	add    $0x10,%esp
  8027a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a8:	8b 50 08             	mov    0x8(%eax),%edx
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	01 c2                	add    %eax,%edx
  8027b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b3:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8027bf:	89 c2                	mov    %eax,%edx
  8027c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c4:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ca:	eb 05                	jmp    8027d1 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027d1:	c9                   	leave  
  8027d2:	c3                   	ret    

008027d3 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027d3:	55                   	push   %ebp
  8027d4:	89 e5                	mov    %esp,%ebp
  8027d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027d9:	a1 28 50 80 00       	mov    0x805028,%eax
  8027de:	85 c0                	test   %eax,%eax
  8027e0:	0f 85 de 01 00 00    	jne    8029c4 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8027eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ee:	e9 9e 01 00 00       	jmp    802991 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027fc:	0f 82 87 01 00 00    	jb     802989 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 40 0c             	mov    0xc(%eax),%eax
  802808:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280b:	0f 85 95 00 00 00    	jne    8028a6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802815:	75 17                	jne    80282e <alloc_block_NF+0x5b>
  802817:	83 ec 04             	sub    $0x4,%esp
  80281a:	68 e0 41 80 00       	push   $0x8041e0
  80281f:	68 e0 00 00 00       	push   $0xe0
  802824:	68 37 41 80 00       	push   $0x804137
  802829:	e8 a3 da ff ff       	call   8002d1 <_panic>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	74 10                	je     802847 <alloc_block_NF+0x74>
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283f:	8b 52 04             	mov    0x4(%edx),%edx
  802842:	89 50 04             	mov    %edx,0x4(%eax)
  802845:	eb 0b                	jmp    802852 <alloc_block_NF+0x7f>
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 40 04             	mov    0x4(%eax),%eax
  80284d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 40 04             	mov    0x4(%eax),%eax
  802858:	85 c0                	test   %eax,%eax
  80285a:	74 0f                	je     80286b <alloc_block_NF+0x98>
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 40 04             	mov    0x4(%eax),%eax
  802862:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802865:	8b 12                	mov    (%edx),%edx
  802867:	89 10                	mov    %edx,(%eax)
  802869:	eb 0a                	jmp    802875 <alloc_block_NF+0xa2>
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	a3 38 51 80 00       	mov    %eax,0x805138
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802888:	a1 44 51 80 00       	mov    0x805144,%eax
  80288d:	48                   	dec    %eax
  80288e:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 40 08             	mov    0x8(%eax),%eax
  802899:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	e9 f8 04 00 00       	jmp    802d9e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028af:	0f 86 d4 00 00 00    	jbe    802989 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8028ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	8b 50 08             	mov    0x8(%eax),%edx
  8028c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c6:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8028cf:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028d6:	75 17                	jne    8028ef <alloc_block_NF+0x11c>
  8028d8:	83 ec 04             	sub    $0x4,%esp
  8028db:	68 e0 41 80 00       	push   $0x8041e0
  8028e0:	68 e9 00 00 00       	push   $0xe9
  8028e5:	68 37 41 80 00       	push   $0x804137
  8028ea:	e8 e2 d9 ff ff       	call   8002d1 <_panic>
  8028ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	74 10                	je     802908 <alloc_block_NF+0x135>
  8028f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802900:	8b 52 04             	mov    0x4(%edx),%edx
  802903:	89 50 04             	mov    %edx,0x4(%eax)
  802906:	eb 0b                	jmp    802913 <alloc_block_NF+0x140>
  802908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290b:	8b 40 04             	mov    0x4(%eax),%eax
  80290e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802916:	8b 40 04             	mov    0x4(%eax),%eax
  802919:	85 c0                	test   %eax,%eax
  80291b:	74 0f                	je     80292c <alloc_block_NF+0x159>
  80291d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802920:	8b 40 04             	mov    0x4(%eax),%eax
  802923:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802926:	8b 12                	mov    (%edx),%edx
  802928:	89 10                	mov    %edx,(%eax)
  80292a:	eb 0a                	jmp    802936 <alloc_block_NF+0x163>
  80292c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	a3 48 51 80 00       	mov    %eax,0x805148
  802936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802939:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802942:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802949:	a1 54 51 80 00       	mov    0x805154,%eax
  80294e:	48                   	dec    %eax
  80294f:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802957:	8b 40 08             	mov    0x8(%eax),%eax
  80295a:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 50 08             	mov    0x8(%eax),%edx
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	01 c2                	add    %eax,%edx
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 40 0c             	mov    0xc(%eax),%eax
  802976:	2b 45 08             	sub    0x8(%ebp),%eax
  802979:	89 c2                	mov    %eax,%edx
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	e9 15 04 00 00       	jmp    802d9e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802989:	a1 40 51 80 00       	mov    0x805140,%eax
  80298e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802991:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802995:	74 07                	je     80299e <alloc_block_NF+0x1cb>
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 00                	mov    (%eax),%eax
  80299c:	eb 05                	jmp    8029a3 <alloc_block_NF+0x1d0>
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a3:	a3 40 51 80 00       	mov    %eax,0x805140
  8029a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	0f 85 3e fe ff ff    	jne    8027f3 <alloc_block_NF+0x20>
  8029b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b9:	0f 85 34 fe ff ff    	jne    8027f3 <alloc_block_NF+0x20>
  8029bf:	e9 d5 03 00 00       	jmp    802d99 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029c4:	a1 38 51 80 00       	mov    0x805138,%eax
  8029c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029cc:	e9 b1 01 00 00       	jmp    802b82 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 50 08             	mov    0x8(%eax),%edx
  8029d7:	a1 28 50 80 00       	mov    0x805028,%eax
  8029dc:	39 c2                	cmp    %eax,%edx
  8029de:	0f 82 96 01 00 00    	jb     802b7a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ed:	0f 82 87 01 00 00    	jb     802b7a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029fc:	0f 85 95 00 00 00    	jne    802a97 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a06:	75 17                	jne    802a1f <alloc_block_NF+0x24c>
  802a08:	83 ec 04             	sub    $0x4,%esp
  802a0b:	68 e0 41 80 00       	push   $0x8041e0
  802a10:	68 fc 00 00 00       	push   $0xfc
  802a15:	68 37 41 80 00       	push   $0x804137
  802a1a:	e8 b2 d8 ff ff       	call   8002d1 <_panic>
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	85 c0                	test   %eax,%eax
  802a26:	74 10                	je     802a38 <alloc_block_NF+0x265>
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a30:	8b 52 04             	mov    0x4(%edx),%edx
  802a33:	89 50 04             	mov    %edx,0x4(%eax)
  802a36:	eb 0b                	jmp    802a43 <alloc_block_NF+0x270>
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 40 04             	mov    0x4(%eax),%eax
  802a3e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 40 04             	mov    0x4(%eax),%eax
  802a49:	85 c0                	test   %eax,%eax
  802a4b:	74 0f                	je     802a5c <alloc_block_NF+0x289>
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 40 04             	mov    0x4(%eax),%eax
  802a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a56:	8b 12                	mov    (%edx),%edx
  802a58:	89 10                	mov    %edx,(%eax)
  802a5a:	eb 0a                	jmp    802a66 <alloc_block_NF+0x293>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	a3 38 51 80 00       	mov    %eax,0x805138
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a79:	a1 44 51 80 00       	mov    0x805144,%eax
  802a7e:	48                   	dec    %eax
  802a7f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	8b 40 08             	mov    0x8(%eax),%eax
  802a8a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	e9 07 03 00 00       	jmp    802d9e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa0:	0f 86 d4 00 00 00    	jbe    802b7a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aa6:	a1 48 51 80 00       	mov    0x805148,%eax
  802aab:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 50 08             	mov    0x8(%eax),%edx
  802ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802aba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ac3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ac7:	75 17                	jne    802ae0 <alloc_block_NF+0x30d>
  802ac9:	83 ec 04             	sub    $0x4,%esp
  802acc:	68 e0 41 80 00       	push   $0x8041e0
  802ad1:	68 04 01 00 00       	push   $0x104
  802ad6:	68 37 41 80 00       	push   $0x804137
  802adb:	e8 f1 d7 ff ff       	call   8002d1 <_panic>
  802ae0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae3:	8b 00                	mov    (%eax),%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	74 10                	je     802af9 <alloc_block_NF+0x326>
  802ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802af1:	8b 52 04             	mov    0x4(%edx),%edx
  802af4:	89 50 04             	mov    %edx,0x4(%eax)
  802af7:	eb 0b                	jmp    802b04 <alloc_block_NF+0x331>
  802af9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afc:	8b 40 04             	mov    0x4(%eax),%eax
  802aff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b07:	8b 40 04             	mov    0x4(%eax),%eax
  802b0a:	85 c0                	test   %eax,%eax
  802b0c:	74 0f                	je     802b1d <alloc_block_NF+0x34a>
  802b0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b11:	8b 40 04             	mov    0x4(%eax),%eax
  802b14:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b17:	8b 12                	mov    (%edx),%edx
  802b19:	89 10                	mov    %edx,(%eax)
  802b1b:	eb 0a                	jmp    802b27 <alloc_block_NF+0x354>
  802b1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	a3 48 51 80 00       	mov    %eax,0x805148
  802b27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3a:	a1 54 51 80 00       	mov    0x805154,%eax
  802b3f:	48                   	dec    %eax
  802b40:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b48:	8b 40 08             	mov    0x8(%eax),%eax
  802b4b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 50 08             	mov    0x8(%eax),%edx
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	01 c2                	add    %eax,%edx
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	8b 40 0c             	mov    0xc(%eax),%eax
  802b67:	2b 45 08             	sub    0x8(%ebp),%eax
  802b6a:	89 c2                	mov    %eax,%edx
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b75:	e9 24 02 00 00       	jmp    802d9e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b7a:	a1 40 51 80 00       	mov    0x805140,%eax
  802b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b86:	74 07                	je     802b8f <alloc_block_NF+0x3bc>
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 00                	mov    (%eax),%eax
  802b8d:	eb 05                	jmp    802b94 <alloc_block_NF+0x3c1>
  802b8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b94:	a3 40 51 80 00       	mov    %eax,0x805140
  802b99:	a1 40 51 80 00       	mov    0x805140,%eax
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	0f 85 2b fe ff ff    	jne    8029d1 <alloc_block_NF+0x1fe>
  802ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802baa:	0f 85 21 fe ff ff    	jne    8029d1 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bb0:	a1 38 51 80 00       	mov    0x805138,%eax
  802bb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb8:	e9 ae 01 00 00       	jmp    802d6b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 50 08             	mov    0x8(%eax),%edx
  802bc3:	a1 28 50 80 00       	mov    0x805028,%eax
  802bc8:	39 c2                	cmp    %eax,%edx
  802bca:	0f 83 93 01 00 00    	jae    802d63 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd9:	0f 82 84 01 00 00    	jb     802d63 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 40 0c             	mov    0xc(%eax),%eax
  802be5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be8:	0f 85 95 00 00 00    	jne    802c83 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf2:	75 17                	jne    802c0b <alloc_block_NF+0x438>
  802bf4:	83 ec 04             	sub    $0x4,%esp
  802bf7:	68 e0 41 80 00       	push   $0x8041e0
  802bfc:	68 14 01 00 00       	push   $0x114
  802c01:	68 37 41 80 00       	push   $0x804137
  802c06:	e8 c6 d6 ff ff       	call   8002d1 <_panic>
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	74 10                	je     802c24 <alloc_block_NF+0x451>
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 00                	mov    (%eax),%eax
  802c19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c1c:	8b 52 04             	mov    0x4(%edx),%edx
  802c1f:	89 50 04             	mov    %edx,0x4(%eax)
  802c22:	eb 0b                	jmp    802c2f <alloc_block_NF+0x45c>
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 40 04             	mov    0x4(%eax),%eax
  802c2a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 40 04             	mov    0x4(%eax),%eax
  802c35:	85 c0                	test   %eax,%eax
  802c37:	74 0f                	je     802c48 <alloc_block_NF+0x475>
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 40 04             	mov    0x4(%eax),%eax
  802c3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c42:	8b 12                	mov    (%edx),%edx
  802c44:	89 10                	mov    %edx,(%eax)
  802c46:	eb 0a                	jmp    802c52 <alloc_block_NF+0x47f>
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 00                	mov    (%eax),%eax
  802c4d:	a3 38 51 80 00       	mov    %eax,0x805138
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c65:	a1 44 51 80 00       	mov    0x805144,%eax
  802c6a:	48                   	dec    %eax
  802c6b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 40 08             	mov    0x8(%eax),%eax
  802c76:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	e9 1b 01 00 00       	jmp    802d9e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 40 0c             	mov    0xc(%eax),%eax
  802c89:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c8c:	0f 86 d1 00 00 00    	jbe    802d63 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c92:	a1 48 51 80 00       	mov    0x805148,%eax
  802c97:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ca6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cac:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802caf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cb3:	75 17                	jne    802ccc <alloc_block_NF+0x4f9>
  802cb5:	83 ec 04             	sub    $0x4,%esp
  802cb8:	68 e0 41 80 00       	push   $0x8041e0
  802cbd:	68 1c 01 00 00       	push   $0x11c
  802cc2:	68 37 41 80 00       	push   $0x804137
  802cc7:	e8 05 d6 ff ff       	call   8002d1 <_panic>
  802ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccf:	8b 00                	mov    (%eax),%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	74 10                	je     802ce5 <alloc_block_NF+0x512>
  802cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cdd:	8b 52 04             	mov    0x4(%edx),%edx
  802ce0:	89 50 04             	mov    %edx,0x4(%eax)
  802ce3:	eb 0b                	jmp    802cf0 <alloc_block_NF+0x51d>
  802ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce8:	8b 40 04             	mov    0x4(%eax),%eax
  802ceb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf3:	8b 40 04             	mov    0x4(%eax),%eax
  802cf6:	85 c0                	test   %eax,%eax
  802cf8:	74 0f                	je     802d09 <alloc_block_NF+0x536>
  802cfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfd:	8b 40 04             	mov    0x4(%eax),%eax
  802d00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d03:	8b 12                	mov    (%edx),%edx
  802d05:	89 10                	mov    %edx,(%eax)
  802d07:	eb 0a                	jmp    802d13 <alloc_block_NF+0x540>
  802d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	a3 48 51 80 00       	mov    %eax,0x805148
  802d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d26:	a1 54 51 80 00       	mov    0x805154,%eax
  802d2b:	48                   	dec    %eax
  802d2c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d34:	8b 40 08             	mov    0x8(%eax),%eax
  802d37:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 50 08             	mov    0x8(%eax),%edx
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	01 c2                	add    %eax,%edx
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 40 0c             	mov    0xc(%eax),%eax
  802d53:	2b 45 08             	sub    0x8(%ebp),%eax
  802d56:	89 c2                	mov    %eax,%edx
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d61:	eb 3b                	jmp    802d9e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d63:	a1 40 51 80 00       	mov    0x805140,%eax
  802d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6f:	74 07                	je     802d78 <alloc_block_NF+0x5a5>
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 00                	mov    (%eax),%eax
  802d76:	eb 05                	jmp    802d7d <alloc_block_NF+0x5aa>
  802d78:	b8 00 00 00 00       	mov    $0x0,%eax
  802d7d:	a3 40 51 80 00       	mov    %eax,0x805140
  802d82:	a1 40 51 80 00       	mov    0x805140,%eax
  802d87:	85 c0                	test   %eax,%eax
  802d89:	0f 85 2e fe ff ff    	jne    802bbd <alloc_block_NF+0x3ea>
  802d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d93:	0f 85 24 fe ff ff    	jne    802bbd <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d9e:	c9                   	leave  
  802d9f:	c3                   	ret    

00802da0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802da0:	55                   	push   %ebp
  802da1:	89 e5                	mov    %esp,%ebp
  802da3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802da6:	a1 38 51 80 00       	mov    0x805138,%eax
  802dab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802dae:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802db3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802db6:	a1 38 51 80 00       	mov    0x805138,%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	74 14                	je     802dd3 <insert_sorted_with_merge_freeList+0x33>
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	8b 50 08             	mov    0x8(%eax),%edx
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	8b 40 08             	mov    0x8(%eax),%eax
  802dcb:	39 c2                	cmp    %eax,%edx
  802dcd:	0f 87 9b 01 00 00    	ja     802f6e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802dd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd7:	75 17                	jne    802df0 <insert_sorted_with_merge_freeList+0x50>
  802dd9:	83 ec 04             	sub    $0x4,%esp
  802ddc:	68 14 41 80 00       	push   $0x804114
  802de1:	68 38 01 00 00       	push   $0x138
  802de6:	68 37 41 80 00       	push   $0x804137
  802deb:	e8 e1 d4 ff ff       	call   8002d1 <_panic>
  802df0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	89 10                	mov    %edx,(%eax)
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 0d                	je     802e11 <insert_sorted_with_merge_freeList+0x71>
  802e04:	a1 38 51 80 00       	mov    0x805138,%eax
  802e09:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0c:	89 50 04             	mov    %edx,0x4(%eax)
  802e0f:	eb 08                	jmp    802e19 <insert_sorted_with_merge_freeList+0x79>
  802e11:	8b 45 08             	mov    0x8(%ebp),%eax
  802e14:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	a3 38 51 80 00       	mov    %eax,0x805138
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2b:	a1 44 51 80 00       	mov    0x805144,%eax
  802e30:	40                   	inc    %eax
  802e31:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e3a:	0f 84 a8 06 00 00    	je     8034e8 <insert_sorted_with_merge_freeList+0x748>
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	8b 50 08             	mov    0x8(%eax),%edx
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4c:	01 c2                	add    %eax,%edx
  802e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e51:	8b 40 08             	mov    0x8(%eax),%eax
  802e54:	39 c2                	cmp    %eax,%edx
  802e56:	0f 85 8c 06 00 00    	jne    8034e8 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	8b 50 0c             	mov    0xc(%eax),%edx
  802e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e65:	8b 40 0c             	mov    0xc(%eax),%eax
  802e68:	01 c2                	add    %eax,%edx
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e74:	75 17                	jne    802e8d <insert_sorted_with_merge_freeList+0xed>
  802e76:	83 ec 04             	sub    $0x4,%esp
  802e79:	68 e0 41 80 00       	push   $0x8041e0
  802e7e:	68 3c 01 00 00       	push   $0x13c
  802e83:	68 37 41 80 00       	push   $0x804137
  802e88:	e8 44 d4 ff ff       	call   8002d1 <_panic>
  802e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	85 c0                	test   %eax,%eax
  802e94:	74 10                	je     802ea6 <insert_sorted_with_merge_freeList+0x106>
  802e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e9e:	8b 52 04             	mov    0x4(%edx),%edx
  802ea1:	89 50 04             	mov    %edx,0x4(%eax)
  802ea4:	eb 0b                	jmp    802eb1 <insert_sorted_with_merge_freeList+0x111>
  802ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea9:	8b 40 04             	mov    0x4(%eax),%eax
  802eac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb4:	8b 40 04             	mov    0x4(%eax),%eax
  802eb7:	85 c0                	test   %eax,%eax
  802eb9:	74 0f                	je     802eca <insert_sorted_with_merge_freeList+0x12a>
  802ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebe:	8b 40 04             	mov    0x4(%eax),%eax
  802ec1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec4:	8b 12                	mov    (%edx),%edx
  802ec6:	89 10                	mov    %edx,(%eax)
  802ec8:	eb 0a                	jmp    802ed4 <insert_sorted_with_merge_freeList+0x134>
  802eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecd:	8b 00                	mov    (%eax),%eax
  802ecf:	a3 38 51 80 00       	mov    %eax,0x805138
  802ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee7:	a1 44 51 80 00       	mov    0x805144,%eax
  802eec:	48                   	dec    %eax
  802eed:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f0a:	75 17                	jne    802f23 <insert_sorted_with_merge_freeList+0x183>
  802f0c:	83 ec 04             	sub    $0x4,%esp
  802f0f:	68 14 41 80 00       	push   $0x804114
  802f14:	68 3f 01 00 00       	push   $0x13f
  802f19:	68 37 41 80 00       	push   $0x804137
  802f1e:	e8 ae d3 ff ff       	call   8002d1 <_panic>
  802f23:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2c:	89 10                	mov    %edx,(%eax)
  802f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f31:	8b 00                	mov    (%eax),%eax
  802f33:	85 c0                	test   %eax,%eax
  802f35:	74 0d                	je     802f44 <insert_sorted_with_merge_freeList+0x1a4>
  802f37:	a1 48 51 80 00       	mov    0x805148,%eax
  802f3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f3f:	89 50 04             	mov    %edx,0x4(%eax)
  802f42:	eb 08                	jmp    802f4c <insert_sorted_with_merge_freeList+0x1ac>
  802f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f47:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4f:	a3 48 51 80 00       	mov    %eax,0x805148
  802f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5e:	a1 54 51 80 00       	mov    0x805154,%eax
  802f63:	40                   	inc    %eax
  802f64:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f69:	e9 7a 05 00 00       	jmp    8034e8 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	8b 50 08             	mov    0x8(%eax),%edx
  802f74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f77:	8b 40 08             	mov    0x8(%eax),%eax
  802f7a:	39 c2                	cmp    %eax,%edx
  802f7c:	0f 82 14 01 00 00    	jb     803096 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f85:	8b 50 08             	mov    0x8(%eax),%edx
  802f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8e:	01 c2                	add    %eax,%edx
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	8b 40 08             	mov    0x8(%eax),%eax
  802f96:	39 c2                	cmp    %eax,%edx
  802f98:	0f 85 90 00 00 00    	jne    80302e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa1:	8b 50 0c             	mov    0xc(%eax),%edx
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802faa:	01 c2                	add    %eax,%edx
  802fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faf:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fca:	75 17                	jne    802fe3 <insert_sorted_with_merge_freeList+0x243>
  802fcc:	83 ec 04             	sub    $0x4,%esp
  802fcf:	68 14 41 80 00       	push   $0x804114
  802fd4:	68 49 01 00 00       	push   $0x149
  802fd9:	68 37 41 80 00       	push   $0x804137
  802fde:	e8 ee d2 ff ff       	call   8002d1 <_panic>
  802fe3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	89 10                	mov    %edx,(%eax)
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	8b 00                	mov    (%eax),%eax
  802ff3:	85 c0                	test   %eax,%eax
  802ff5:	74 0d                	je     803004 <insert_sorted_with_merge_freeList+0x264>
  802ff7:	a1 48 51 80 00       	mov    0x805148,%eax
  802ffc:	8b 55 08             	mov    0x8(%ebp),%edx
  802fff:	89 50 04             	mov    %edx,0x4(%eax)
  803002:	eb 08                	jmp    80300c <insert_sorted_with_merge_freeList+0x26c>
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	a3 48 51 80 00       	mov    %eax,0x805148
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301e:	a1 54 51 80 00       	mov    0x805154,%eax
  803023:	40                   	inc    %eax
  803024:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803029:	e9 bb 04 00 00       	jmp    8034e9 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  80302e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803032:	75 17                	jne    80304b <insert_sorted_with_merge_freeList+0x2ab>
  803034:	83 ec 04             	sub    $0x4,%esp
  803037:	68 88 41 80 00       	push   $0x804188
  80303c:	68 4c 01 00 00       	push   $0x14c
  803041:	68 37 41 80 00       	push   $0x804137
  803046:	e8 86 d2 ff ff       	call   8002d1 <_panic>
  80304b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	89 50 04             	mov    %edx,0x4(%eax)
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	8b 40 04             	mov    0x4(%eax),%eax
  80305d:	85 c0                	test   %eax,%eax
  80305f:	74 0c                	je     80306d <insert_sorted_with_merge_freeList+0x2cd>
  803061:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803066:	8b 55 08             	mov    0x8(%ebp),%edx
  803069:	89 10                	mov    %edx,(%eax)
  80306b:	eb 08                	jmp    803075 <insert_sorted_with_merge_freeList+0x2d5>
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	a3 38 51 80 00       	mov    %eax,0x805138
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803086:	a1 44 51 80 00       	mov    0x805144,%eax
  80308b:	40                   	inc    %eax
  80308c:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803091:	e9 53 04 00 00       	jmp    8034e9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803096:	a1 38 51 80 00       	mov    0x805138,%eax
  80309b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80309e:	e9 15 04 00 00       	jmp    8034b8 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a6:	8b 00                	mov    (%eax),%eax
  8030a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	8b 50 08             	mov    0x8(%eax),%edx
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	8b 40 08             	mov    0x8(%eax),%eax
  8030b7:	39 c2                	cmp    %eax,%edx
  8030b9:	0f 86 f1 03 00 00    	jbe    8034b0 <insert_sorted_with_merge_freeList+0x710>
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	8b 50 08             	mov    0x8(%eax),%edx
  8030c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c8:	8b 40 08             	mov    0x8(%eax),%eax
  8030cb:	39 c2                	cmp    %eax,%edx
  8030cd:	0f 83 dd 03 00 00    	jae    8034b0 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	8b 50 08             	mov    0x8(%eax),%edx
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030df:	01 c2                	add    %eax,%edx
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e4:	8b 40 08             	mov    0x8(%eax),%eax
  8030e7:	39 c2                	cmp    %eax,%edx
  8030e9:	0f 85 b9 01 00 00    	jne    8032a8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	8b 50 08             	mov    0x8(%eax),%edx
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fb:	01 c2                	add    %eax,%edx
  8030fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803100:	8b 40 08             	mov    0x8(%eax),%eax
  803103:	39 c2                	cmp    %eax,%edx
  803105:	0f 85 0d 01 00 00    	jne    803218 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310e:	8b 50 0c             	mov    0xc(%eax),%edx
  803111:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803114:	8b 40 0c             	mov    0xc(%eax),%eax
  803117:	01 c2                	add    %eax,%edx
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80311f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803123:	75 17                	jne    80313c <insert_sorted_with_merge_freeList+0x39c>
  803125:	83 ec 04             	sub    $0x4,%esp
  803128:	68 e0 41 80 00       	push   $0x8041e0
  80312d:	68 5c 01 00 00       	push   $0x15c
  803132:	68 37 41 80 00       	push   $0x804137
  803137:	e8 95 d1 ff ff       	call   8002d1 <_panic>
  80313c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	74 10                	je     803155 <insert_sorted_with_merge_freeList+0x3b5>
  803145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80314d:	8b 52 04             	mov    0x4(%edx),%edx
  803150:	89 50 04             	mov    %edx,0x4(%eax)
  803153:	eb 0b                	jmp    803160 <insert_sorted_with_merge_freeList+0x3c0>
  803155:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803160:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803163:	8b 40 04             	mov    0x4(%eax),%eax
  803166:	85 c0                	test   %eax,%eax
  803168:	74 0f                	je     803179 <insert_sorted_with_merge_freeList+0x3d9>
  80316a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316d:	8b 40 04             	mov    0x4(%eax),%eax
  803170:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803173:	8b 12                	mov    (%edx),%edx
  803175:	89 10                	mov    %edx,(%eax)
  803177:	eb 0a                	jmp    803183 <insert_sorted_with_merge_freeList+0x3e3>
  803179:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317c:	8b 00                	mov    (%eax),%eax
  80317e:	a3 38 51 80 00       	mov    %eax,0x805138
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803196:	a1 44 51 80 00       	mov    0x805144,%eax
  80319b:	48                   	dec    %eax
  80319c:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031b9:	75 17                	jne    8031d2 <insert_sorted_with_merge_freeList+0x432>
  8031bb:	83 ec 04             	sub    $0x4,%esp
  8031be:	68 14 41 80 00       	push   $0x804114
  8031c3:	68 5f 01 00 00       	push   $0x15f
  8031c8:	68 37 41 80 00       	push   $0x804137
  8031cd:	e8 ff d0 ff ff       	call   8002d1 <_panic>
  8031d2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031db:	89 10                	mov    %edx,(%eax)
  8031dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	85 c0                	test   %eax,%eax
  8031e4:	74 0d                	je     8031f3 <insert_sorted_with_merge_freeList+0x453>
  8031e6:	a1 48 51 80 00       	mov    0x805148,%eax
  8031eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ee:	89 50 04             	mov    %edx,0x4(%eax)
  8031f1:	eb 08                	jmp    8031fb <insert_sorted_with_merge_freeList+0x45b>
  8031f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fe:	a3 48 51 80 00       	mov    %eax,0x805148
  803203:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803206:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320d:	a1 54 51 80 00       	mov    0x805154,%eax
  803212:	40                   	inc    %eax
  803213:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321b:	8b 50 0c             	mov    0xc(%eax),%edx
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	8b 40 0c             	mov    0xc(%eax),%eax
  803224:	01 c2                	add    %eax,%edx
  803226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803229:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803240:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803244:	75 17                	jne    80325d <insert_sorted_with_merge_freeList+0x4bd>
  803246:	83 ec 04             	sub    $0x4,%esp
  803249:	68 14 41 80 00       	push   $0x804114
  80324e:	68 64 01 00 00       	push   $0x164
  803253:	68 37 41 80 00       	push   $0x804137
  803258:	e8 74 d0 ff ff       	call   8002d1 <_panic>
  80325d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	89 10                	mov    %edx,(%eax)
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	85 c0                	test   %eax,%eax
  80326f:	74 0d                	je     80327e <insert_sorted_with_merge_freeList+0x4de>
  803271:	a1 48 51 80 00       	mov    0x805148,%eax
  803276:	8b 55 08             	mov    0x8(%ebp),%edx
  803279:	89 50 04             	mov    %edx,0x4(%eax)
  80327c:	eb 08                	jmp    803286 <insert_sorted_with_merge_freeList+0x4e6>
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	a3 48 51 80 00       	mov    %eax,0x805148
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803298:	a1 54 51 80 00       	mov    0x805154,%eax
  80329d:	40                   	inc    %eax
  80329e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032a3:	e9 41 02 00 00       	jmp    8034e9 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ab:	8b 50 08             	mov    0x8(%eax),%edx
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b4:	01 c2                	add    %eax,%edx
  8032b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b9:	8b 40 08             	mov    0x8(%eax),%eax
  8032bc:	39 c2                	cmp    %eax,%edx
  8032be:	0f 85 7c 01 00 00    	jne    803440 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032c8:	74 06                	je     8032d0 <insert_sorted_with_merge_freeList+0x530>
  8032ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ce:	75 17                	jne    8032e7 <insert_sorted_with_merge_freeList+0x547>
  8032d0:	83 ec 04             	sub    $0x4,%esp
  8032d3:	68 50 41 80 00       	push   $0x804150
  8032d8:	68 69 01 00 00       	push   $0x169
  8032dd:	68 37 41 80 00       	push   $0x804137
  8032e2:	e8 ea cf ff ff       	call   8002d1 <_panic>
  8032e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ea:	8b 50 04             	mov    0x4(%eax),%edx
  8032ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f0:	89 50 04             	mov    %edx,0x4(%eax)
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f9:	89 10                	mov    %edx,(%eax)
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	8b 40 04             	mov    0x4(%eax),%eax
  803301:	85 c0                	test   %eax,%eax
  803303:	74 0d                	je     803312 <insert_sorted_with_merge_freeList+0x572>
  803305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803308:	8b 40 04             	mov    0x4(%eax),%eax
  80330b:	8b 55 08             	mov    0x8(%ebp),%edx
  80330e:	89 10                	mov    %edx,(%eax)
  803310:	eb 08                	jmp    80331a <insert_sorted_with_merge_freeList+0x57a>
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	a3 38 51 80 00       	mov    %eax,0x805138
  80331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331d:	8b 55 08             	mov    0x8(%ebp),%edx
  803320:	89 50 04             	mov    %edx,0x4(%eax)
  803323:	a1 44 51 80 00       	mov    0x805144,%eax
  803328:	40                   	inc    %eax
  803329:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	8b 50 0c             	mov    0xc(%eax),%edx
  803334:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803337:	8b 40 0c             	mov    0xc(%eax),%eax
  80333a:	01 c2                	add    %eax,%edx
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803342:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803346:	75 17                	jne    80335f <insert_sorted_with_merge_freeList+0x5bf>
  803348:	83 ec 04             	sub    $0x4,%esp
  80334b:	68 e0 41 80 00       	push   $0x8041e0
  803350:	68 6b 01 00 00       	push   $0x16b
  803355:	68 37 41 80 00       	push   $0x804137
  80335a:	e8 72 cf ff ff       	call   8002d1 <_panic>
  80335f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803362:	8b 00                	mov    (%eax),%eax
  803364:	85 c0                	test   %eax,%eax
  803366:	74 10                	je     803378 <insert_sorted_with_merge_freeList+0x5d8>
  803368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336b:	8b 00                	mov    (%eax),%eax
  80336d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803370:	8b 52 04             	mov    0x4(%edx),%edx
  803373:	89 50 04             	mov    %edx,0x4(%eax)
  803376:	eb 0b                	jmp    803383 <insert_sorted_with_merge_freeList+0x5e3>
  803378:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337b:	8b 40 04             	mov    0x4(%eax),%eax
  80337e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803383:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803386:	8b 40 04             	mov    0x4(%eax),%eax
  803389:	85 c0                	test   %eax,%eax
  80338b:	74 0f                	je     80339c <insert_sorted_with_merge_freeList+0x5fc>
  80338d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803390:	8b 40 04             	mov    0x4(%eax),%eax
  803393:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803396:	8b 12                	mov    (%edx),%edx
  803398:	89 10                	mov    %edx,(%eax)
  80339a:	eb 0a                	jmp    8033a6 <insert_sorted_with_merge_freeList+0x606>
  80339c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339f:	8b 00                	mov    (%eax),%eax
  8033a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8033a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8033be:	48                   	dec    %eax
  8033bf:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033dc:	75 17                	jne    8033f5 <insert_sorted_with_merge_freeList+0x655>
  8033de:	83 ec 04             	sub    $0x4,%esp
  8033e1:	68 14 41 80 00       	push   $0x804114
  8033e6:	68 6e 01 00 00       	push   $0x16e
  8033eb:	68 37 41 80 00       	push   $0x804137
  8033f0:	e8 dc ce ff ff       	call   8002d1 <_panic>
  8033f5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fe:	89 10                	mov    %edx,(%eax)
  803400:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803403:	8b 00                	mov    (%eax),%eax
  803405:	85 c0                	test   %eax,%eax
  803407:	74 0d                	je     803416 <insert_sorted_with_merge_freeList+0x676>
  803409:	a1 48 51 80 00       	mov    0x805148,%eax
  80340e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803411:	89 50 04             	mov    %edx,0x4(%eax)
  803414:	eb 08                	jmp    80341e <insert_sorted_with_merge_freeList+0x67e>
  803416:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803419:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80341e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803421:	a3 48 51 80 00       	mov    %eax,0x805148
  803426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803429:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803430:	a1 54 51 80 00       	mov    0x805154,%eax
  803435:	40                   	inc    %eax
  803436:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80343b:	e9 a9 00 00 00       	jmp    8034e9 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803440:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803444:	74 06                	je     80344c <insert_sorted_with_merge_freeList+0x6ac>
  803446:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80344a:	75 17                	jne    803463 <insert_sorted_with_merge_freeList+0x6c3>
  80344c:	83 ec 04             	sub    $0x4,%esp
  80344f:	68 ac 41 80 00       	push   $0x8041ac
  803454:	68 73 01 00 00       	push   $0x173
  803459:	68 37 41 80 00       	push   $0x804137
  80345e:	e8 6e ce ff ff       	call   8002d1 <_panic>
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	8b 10                	mov    (%eax),%edx
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	89 10                	mov    %edx,(%eax)
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	8b 00                	mov    (%eax),%eax
  803472:	85 c0                	test   %eax,%eax
  803474:	74 0b                	je     803481 <insert_sorted_with_merge_freeList+0x6e1>
  803476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803479:	8b 00                	mov    (%eax),%eax
  80347b:	8b 55 08             	mov    0x8(%ebp),%edx
  80347e:	89 50 04             	mov    %edx,0x4(%eax)
  803481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803484:	8b 55 08             	mov    0x8(%ebp),%edx
  803487:	89 10                	mov    %edx,(%eax)
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80348f:	89 50 04             	mov    %edx,0x4(%eax)
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	8b 00                	mov    (%eax),%eax
  803497:	85 c0                	test   %eax,%eax
  803499:	75 08                	jne    8034a3 <insert_sorted_with_merge_freeList+0x703>
  80349b:	8b 45 08             	mov    0x8(%ebp),%eax
  80349e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034a3:	a1 44 51 80 00       	mov    0x805144,%eax
  8034a8:	40                   	inc    %eax
  8034a9:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034ae:	eb 39                	jmp    8034e9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034b0:	a1 40 51 80 00       	mov    0x805140,%eax
  8034b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034bc:	74 07                	je     8034c5 <insert_sorted_with_merge_freeList+0x725>
  8034be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c1:	8b 00                	mov    (%eax),%eax
  8034c3:	eb 05                	jmp    8034ca <insert_sorted_with_merge_freeList+0x72a>
  8034c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ca:	a3 40 51 80 00       	mov    %eax,0x805140
  8034cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8034d4:	85 c0                	test   %eax,%eax
  8034d6:	0f 85 c7 fb ff ff    	jne    8030a3 <insert_sorted_with_merge_freeList+0x303>
  8034dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e0:	0f 85 bd fb ff ff    	jne    8030a3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034e6:	eb 01                	jmp    8034e9 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034e8:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034e9:	90                   	nop
  8034ea:	c9                   	leave  
  8034eb:	c3                   	ret    

008034ec <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8034ec:	55                   	push   %ebp
  8034ed:	89 e5                	mov    %esp,%ebp
  8034ef:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8034f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f5:	89 d0                	mov    %edx,%eax
  8034f7:	c1 e0 02             	shl    $0x2,%eax
  8034fa:	01 d0                	add    %edx,%eax
  8034fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803503:	01 d0                	add    %edx,%eax
  803505:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80350c:	01 d0                	add    %edx,%eax
  80350e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803515:	01 d0                	add    %edx,%eax
  803517:	c1 e0 04             	shl    $0x4,%eax
  80351a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80351d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803524:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803527:	83 ec 0c             	sub    $0xc,%esp
  80352a:	50                   	push   %eax
  80352b:	e8 26 e7 ff ff       	call   801c56 <sys_get_virtual_time>
  803530:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803533:	eb 41                	jmp    803576 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803535:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803538:	83 ec 0c             	sub    $0xc,%esp
  80353b:	50                   	push   %eax
  80353c:	e8 15 e7 ff ff       	call   801c56 <sys_get_virtual_time>
  803541:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803544:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803547:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354a:	29 c2                	sub    %eax,%edx
  80354c:	89 d0                	mov    %edx,%eax
  80354e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803551:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803554:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803557:	89 d1                	mov    %edx,%ecx
  803559:	29 c1                	sub    %eax,%ecx
  80355b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80355e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803561:	39 c2                	cmp    %eax,%edx
  803563:	0f 97 c0             	seta   %al
  803566:	0f b6 c0             	movzbl %al,%eax
  803569:	29 c1                	sub    %eax,%ecx
  80356b:	89 c8                	mov    %ecx,%eax
  80356d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803570:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803573:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803579:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80357c:	72 b7                	jb     803535 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80357e:	90                   	nop
  80357f:	c9                   	leave  
  803580:	c3                   	ret    

00803581 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803581:	55                   	push   %ebp
  803582:	89 e5                	mov    %esp,%ebp
  803584:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803587:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80358e:	eb 03                	jmp    803593 <busy_wait+0x12>
  803590:	ff 45 fc             	incl   -0x4(%ebp)
  803593:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803596:	3b 45 08             	cmp    0x8(%ebp),%eax
  803599:	72 f5                	jb     803590 <busy_wait+0xf>
	return i;
  80359b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80359e:	c9                   	leave  
  80359f:	c3                   	ret    

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
