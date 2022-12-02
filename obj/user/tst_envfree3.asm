
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
  800045:	68 20 36 80 00       	push   $0x803620
  80004a:	e8 06 15 00 00       	call   801555 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 ca 16 00 00       	call   80172d <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 62 17 00 00       	call   8017cd <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 30 36 80 00       	push   $0x803630
  800079:	e8 07 05 00 00       	call   800585 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 50 80 00       	mov    0x805020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 63 36 80 00       	push   $0x803663
  800099:	e8 01 19 00 00       	call   80199f <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 6c 36 80 00       	push   $0x80366c
  8000bc:	e8 de 18 00 00       	call   80199f <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 eb 18 00 00       	call   8019bd <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 0d 32 00 00       	call   8032ef <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 cd 18 00 00       	call   8019bd <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 2a 16 00 00       	call   80172d <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 78 36 80 00       	push   $0x803678
  80010c:	e8 74 04 00 00       	call   800585 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 ba 18 00 00       	call   8019d9 <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 ac 18 00 00       	call   8019d9 <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 f8 15 00 00       	call   80172d <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 90 16 00 00       	call   8017cd <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 ac 36 80 00       	push   $0x8036ac
  800153:	e8 2d 04 00 00       	call   800585 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 fc 36 80 00       	push   $0x8036fc
  800163:	6a 23                	push   $0x23
  800165:	68 32 37 80 00       	push   $0x803732
  80016a:	e8 62 01 00 00       	call   8002d1 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 48 37 80 00       	push   $0x803748
  80017a:	e8 06 04 00 00       	call   800585 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 a8 37 80 00       	push   $0x8037a8
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
  80019b:	e8 6d 18 00 00       	call   801a0d <sys_getenvindex>
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
  800206:	e8 0f 16 00 00       	call   80181a <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 0c 38 80 00       	push   $0x80380c
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
  800236:	68 34 38 80 00       	push   $0x803834
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
  800267:	68 5c 38 80 00       	push   $0x80385c
  80026c:	e8 14 03 00 00       	call   800585 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 b4 38 80 00       	push   $0x8038b4
  800288:	e8 f8 02 00 00       	call   800585 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 0c 38 80 00       	push   $0x80380c
  800298:	e8 e8 02 00 00       	call   800585 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a0:	e8 8f 15 00 00       	call   801834 <sys_enable_interrupt>

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
  8002b8:	e8 1c 17 00 00       	call   8019d9 <sys_destroy_env>
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
  8002c9:	e8 71 17 00 00       	call   801a3f <sys_exit_env>
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
  8002f2:	68 c8 38 80 00       	push   $0x8038c8
  8002f7:	e8 89 02 00 00       	call   800585 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ff:	a1 00 50 80 00       	mov    0x805000,%eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	50                   	push   %eax
  80030b:	68 cd 38 80 00       	push   $0x8038cd
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
  80032f:	68 e9 38 80 00       	push   $0x8038e9
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
  80035b:	68 ec 38 80 00       	push   $0x8038ec
  800360:	6a 26                	push   $0x26
  800362:	68 38 39 80 00       	push   $0x803938
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
  80042d:	68 44 39 80 00       	push   $0x803944
  800432:	6a 3a                	push   $0x3a
  800434:	68 38 39 80 00       	push   $0x803938
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
  80049d:	68 98 39 80 00       	push   $0x803998
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 38 39 80 00       	push   $0x803938
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
  8004f7:	e8 70 11 00 00       	call   80166c <sys_cputs>
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
  80056e:	e8 f9 10 00 00       	call   80166c <sys_cputs>
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
  8005b8:	e8 5d 12 00 00       	call   80181a <sys_disable_interrupt>
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
  8005d8:	e8 57 12 00 00       	call   801834 <sys_enable_interrupt>
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
  800622:	e8 7d 2d 00 00       	call   8033a4 <__udivdi3>
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
  800672:	e8 3d 2e 00 00       	call   8034b4 <__umoddi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	05 14 3c 80 00       	add    $0x803c14,%eax
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
  8007cd:	8b 04 85 38 3c 80 00 	mov    0x803c38(,%eax,4),%eax
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
  8008ae:	8b 34 9d 80 3a 80 00 	mov    0x803a80(,%ebx,4),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 19                	jne    8008d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b9:	53                   	push   %ebx
  8008ba:	68 25 3c 80 00       	push   $0x803c25
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
  8008d3:	68 2e 3c 80 00       	push   $0x803c2e
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
  800900:	be 31 3c 80 00       	mov    $0x803c31,%esi
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
  801326:	68 90 3d 80 00       	push   $0x803d90
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  8013d9:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ed:	83 ec 04             	sub    $0x4,%esp
  8013f0:	6a 03                	push   $0x3
  8013f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8013f5:	50                   	push   %eax
  8013f6:	e8 b5 03 00 00       	call   8017b0 <sys_allocate_chunk>
  8013fb:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013fe:	a1 20 51 80 00       	mov    0x805120,%eax
  801403:	83 ec 0c             	sub    $0xc,%esp
  801406:	50                   	push   %eax
  801407:	e8 2a 0a 00 00       	call   801e36 <initialize_MemBlocksList>
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
  801434:	68 b5 3d 80 00       	push   $0x803db5
  801439:	6a 33                	push   $0x33
  80143b:	68 d3 3d 80 00       	push   $0x803dd3
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
  8014b3:	68 e0 3d 80 00       	push   $0x803de0
  8014b8:	6a 34                	push   $0x34
  8014ba:	68 d3 3d 80 00       	push   $0x803dd3
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
  801528:	68 04 3e 80 00       	push   $0x803e04
  80152d:	6a 46                	push   $0x46
  80152f:	68 d3 3d 80 00       	push   $0x803dd3
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
  801544:	68 2c 3e 80 00       	push   $0x803e2c
  801549:	6a 61                	push   $0x61
  80154b:	68 d3 3d 80 00       	push   $0x803dd3
  801550:	e8 7c ed ff ff       	call   8002d1 <_panic>

00801555 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 18             	sub    $0x18,%esp
  80155b:	8b 45 10             	mov    0x10(%ebp),%eax
  80155e:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801561:	e8 a9 fd ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  801566:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80156a:	75 07                	jne    801573 <smalloc+0x1e>
  80156c:	b8 00 00 00 00       	mov    $0x0,%eax
  801571:	eb 14                	jmp    801587 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	68 50 3e 80 00       	push   $0x803e50
  80157b:	6a 76                	push   $0x76
  80157d:	68 d3 3d 80 00       	push   $0x803dd3
  801582:	e8 4a ed ff ff       	call   8002d1 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80158f:	e8 7b fd ff ff       	call   80130f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	68 78 3e 80 00       	push   $0x803e78
  80159c:	68 93 00 00 00       	push   $0x93
  8015a1:	68 d3 3d 80 00       	push   $0x803dd3
  8015a6:	e8 26 ed ff ff       	call   8002d1 <_panic>

008015ab <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b1:	e8 59 fd ff ff       	call   80130f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015b6:	83 ec 04             	sub    $0x4,%esp
  8015b9:	68 9c 3e 80 00       	push   $0x803e9c
  8015be:	68 c5 00 00 00       	push   $0xc5
  8015c3:	68 d3 3d 80 00       	push   $0x803dd3
  8015c8:	e8 04 ed ff ff       	call   8002d1 <_panic>

008015cd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015d3:	83 ec 04             	sub    $0x4,%esp
  8015d6:	68 c4 3e 80 00       	push   $0x803ec4
  8015db:	68 d9 00 00 00       	push   $0xd9
  8015e0:	68 d3 3d 80 00       	push   $0x803dd3
  8015e5:	e8 e7 ec ff ff       	call   8002d1 <_panic>

008015ea <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	68 e8 3e 80 00       	push   $0x803ee8
  8015f8:	68 e4 00 00 00       	push   $0xe4
  8015fd:	68 d3 3d 80 00       	push   $0x803dd3
  801602:	e8 ca ec ff ff       	call   8002d1 <_panic>

00801607 <shrink>:

}
void shrink(uint32 newSize)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	68 e8 3e 80 00       	push   $0x803ee8
  801615:	68 e9 00 00 00       	push   $0xe9
  80161a:	68 d3 3d 80 00       	push   $0x803dd3
  80161f:	e8 ad ec ff ff       	call   8002d1 <_panic>

00801624 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
  801627:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80162a:	83 ec 04             	sub    $0x4,%esp
  80162d:	68 e8 3e 80 00       	push   $0x803ee8
  801632:	68 ee 00 00 00       	push   $0xee
  801637:	68 d3 3d 80 00       	push   $0x803dd3
  80163c:	e8 90 ec ff ff       	call   8002d1 <_panic>

00801641 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	57                   	push   %edi
  801645:	56                   	push   %esi
  801646:	53                   	push   %ebx
  801647:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801650:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801653:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801656:	8b 7d 18             	mov    0x18(%ebp),%edi
  801659:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80165c:	cd 30                	int    $0x30
  80165e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801661:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	5b                   	pop    %ebx
  801668:	5e                   	pop    %esi
  801669:	5f                   	pop    %edi
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    

0080166c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801678:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	52                   	push   %edx
  801684:	ff 75 0c             	pushl  0xc(%ebp)
  801687:	50                   	push   %eax
  801688:	6a 00                	push   $0x0
  80168a:	e8 b2 ff ff ff       	call   801641 <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
}
  801692:	90                   	nop
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_cgetc>:

int
sys_cgetc(void)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 01                	push   $0x1
  8016a4:	e8 98 ff ff ff       	call   801641 <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	52                   	push   %edx
  8016be:	50                   	push   %eax
  8016bf:	6a 05                	push   $0x5
  8016c1:	e8 7b ff ff ff       	call   801641 <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	56                   	push   %esi
  8016cf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016d0:	8b 75 18             	mov    0x18(%ebp),%esi
  8016d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	56                   	push   %esi
  8016e0:	53                   	push   %ebx
  8016e1:	51                   	push   %ecx
  8016e2:	52                   	push   %edx
  8016e3:	50                   	push   %eax
  8016e4:	6a 06                	push   $0x6
  8016e6:	e8 56 ff ff ff       	call   801641 <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f1:	5b                   	pop    %ebx
  8016f2:	5e                   	pop    %esi
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    

008016f5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	52                   	push   %edx
  801705:	50                   	push   %eax
  801706:	6a 07                	push   $0x7
  801708:	e8 34 ff ff ff       	call   801641 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	ff 75 0c             	pushl  0xc(%ebp)
  80171e:	ff 75 08             	pushl  0x8(%ebp)
  801721:	6a 08                	push   $0x8
  801723:	e8 19 ff ff ff       	call   801641 <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 09                	push   $0x9
  80173c:	e8 00 ff ff ff       	call   801641 <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 0a                	push   $0xa
  801755:	e8 e7 fe ff ff       	call   801641 <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 0b                	push   $0xb
  80176e:	e8 ce fe ff ff       	call   801641 <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	ff 75 0c             	pushl  0xc(%ebp)
  801784:	ff 75 08             	pushl  0x8(%ebp)
  801787:	6a 0f                	push   $0xf
  801789:	e8 b3 fe ff ff       	call   801641 <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
	return;
  801791:	90                   	nop
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	ff 75 08             	pushl  0x8(%ebp)
  8017a3:	6a 10                	push   $0x10
  8017a5:	e8 97 fe ff ff       	call   801641 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ad:	90                   	nop
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	ff 75 10             	pushl  0x10(%ebp)
  8017ba:	ff 75 0c             	pushl  0xc(%ebp)
  8017bd:	ff 75 08             	pushl  0x8(%ebp)
  8017c0:	6a 11                	push   $0x11
  8017c2:	e8 7a fe ff ff       	call   801641 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ca:	90                   	nop
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 0c                	push   $0xc
  8017dc:	e8 60 fe ff ff       	call   801641 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	ff 75 08             	pushl  0x8(%ebp)
  8017f4:	6a 0d                	push   $0xd
  8017f6:	e8 46 fe ff ff       	call   801641 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 0e                	push   $0xe
  80180f:	e8 2d fe ff ff       	call   801641 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	90                   	nop
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 13                	push   $0x13
  801829:	e8 13 fe ff ff       	call   801641 <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	90                   	nop
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 14                	push   $0x14
  801843:	e8 f9 fd ff ff       	call   801641 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	90                   	nop
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_cputc>:


void
sys_cputc(const char c)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80185a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	50                   	push   %eax
  801867:	6a 15                	push   $0x15
  801869:	e8 d3 fd ff ff       	call   801641 <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
}
  801871:	90                   	nop
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 16                	push   $0x16
  801883:	e8 b9 fd ff ff       	call   801641 <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	90                   	nop
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	50                   	push   %eax
  80189e:	6a 17                	push   $0x17
  8018a0:	e8 9c fd ff ff       	call   801641 <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	52                   	push   %edx
  8018ba:	50                   	push   %eax
  8018bb:	6a 1a                	push   $0x1a
  8018bd:	e8 7f fd ff ff       	call   801641 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	52                   	push   %edx
  8018d7:	50                   	push   %eax
  8018d8:	6a 18                	push   $0x18
  8018da:	e8 62 fd ff ff       	call   801641 <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
}
  8018e2:	90                   	nop
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	52                   	push   %edx
  8018f5:	50                   	push   %eax
  8018f6:	6a 19                	push   $0x19
  8018f8:	e8 44 fd ff ff       	call   801641 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	90                   	nop
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	8b 45 10             	mov    0x10(%ebp),%eax
  80190c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80190f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801912:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	6a 00                	push   $0x0
  80191b:	51                   	push   %ecx
  80191c:	52                   	push   %edx
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	50                   	push   %eax
  801921:	6a 1b                	push   $0x1b
  801923:	e8 19 fd ff ff       	call   801641 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801930:	8b 55 0c             	mov    0xc(%ebp),%edx
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	52                   	push   %edx
  80193d:	50                   	push   %eax
  80193e:	6a 1c                	push   $0x1c
  801940:	e8 fc fc ff ff       	call   801641 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80194d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801950:	8b 55 0c             	mov    0xc(%ebp),%edx
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	51                   	push   %ecx
  80195b:	52                   	push   %edx
  80195c:	50                   	push   %eax
  80195d:	6a 1d                	push   $0x1d
  80195f:	e8 dd fc ff ff       	call   801641 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80196c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	52                   	push   %edx
  801979:	50                   	push   %eax
  80197a:	6a 1e                	push   $0x1e
  80197c:	e8 c0 fc ff ff       	call   801641 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 1f                	push   $0x1f
  801995:	e8 a7 fc ff ff       	call   801641 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	6a 00                	push   $0x0
  8019a7:	ff 75 14             	pushl  0x14(%ebp)
  8019aa:	ff 75 10             	pushl  0x10(%ebp)
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	50                   	push   %eax
  8019b1:	6a 20                	push   $0x20
  8019b3:	e8 89 fc ff ff       	call   801641 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	50                   	push   %eax
  8019cc:	6a 21                	push   $0x21
  8019ce:	e8 6e fc ff ff       	call   801641 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	90                   	nop
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	50                   	push   %eax
  8019e8:	6a 22                	push   $0x22
  8019ea:	e8 52 fc ff ff       	call   801641 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 02                	push   $0x2
  801a03:	e8 39 fc ff ff       	call   801641 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 03                	push   $0x3
  801a1c:	e8 20 fc ff ff       	call   801641 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 04                	push   $0x4
  801a35:	e8 07 fc ff ff       	call   801641 <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_exit_env>:


void sys_exit_env(void)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 23                	push   $0x23
  801a4e:	e8 ee fb ff ff       	call   801641 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	90                   	nop
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a5f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a62:	8d 50 04             	lea    0x4(%eax),%edx
  801a65:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	52                   	push   %edx
  801a6f:	50                   	push   %eax
  801a70:	6a 24                	push   $0x24
  801a72:	e8 ca fb ff ff       	call   801641 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
	return result;
  801a7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a80:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a83:	89 01                	mov    %eax,(%ecx)
  801a85:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	c9                   	leave  
  801a8c:	c2 04 00             	ret    $0x4

00801a8f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	ff 75 10             	pushl  0x10(%ebp)
  801a99:	ff 75 0c             	pushl  0xc(%ebp)
  801a9c:	ff 75 08             	pushl  0x8(%ebp)
  801a9f:	6a 12                	push   $0x12
  801aa1:	e8 9b fb ff ff       	call   801641 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa9:	90                   	nop
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_rcr2>:
uint32 sys_rcr2()
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 25                	push   $0x25
  801abb:	e8 81 fb ff ff       	call   801641 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ad1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	50                   	push   %eax
  801ade:	6a 26                	push   $0x26
  801ae0:	e8 5c fb ff ff       	call   801641 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae8:	90                   	nop
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <rsttst>:
void rsttst()
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 28                	push   $0x28
  801afa:	e8 42 fb ff ff       	call   801641 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
	return ;
  801b02:	90                   	nop
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	83 ec 04             	sub    $0x4,%esp
  801b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b11:	8b 55 18             	mov    0x18(%ebp),%edx
  801b14:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b18:	52                   	push   %edx
  801b19:	50                   	push   %eax
  801b1a:	ff 75 10             	pushl  0x10(%ebp)
  801b1d:	ff 75 0c             	pushl  0xc(%ebp)
  801b20:	ff 75 08             	pushl  0x8(%ebp)
  801b23:	6a 27                	push   $0x27
  801b25:	e8 17 fb ff ff       	call   801641 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2d:	90                   	nop
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <chktst>:
void chktst(uint32 n)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	ff 75 08             	pushl  0x8(%ebp)
  801b3e:	6a 29                	push   $0x29
  801b40:	e8 fc fa ff ff       	call   801641 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
	return ;
  801b48:	90                   	nop
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <inctst>:

void inctst()
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 2a                	push   $0x2a
  801b5a:	e8 e2 fa ff ff       	call   801641 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b62:	90                   	nop
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <gettst>:
uint32 gettst()
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 2b                	push   $0x2b
  801b74:	e8 c8 fa ff ff       	call   801641 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 2c                	push   $0x2c
  801b90:	e8 ac fa ff ff       	call   801641 <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
  801b98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b9b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b9f:	75 07                	jne    801ba8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ba1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba6:	eb 05                	jmp    801bad <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ba8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 2c                	push   $0x2c
  801bc1:	e8 7b fa ff ff       	call   801641 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
  801bc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bcc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bd0:	75 07                	jne    801bd9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd7:	eb 05                	jmp    801bde <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 2c                	push   $0x2c
  801bf2:	e8 4a fa ff ff       	call   801641 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
  801bfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bfd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c01:	75 07                	jne    801c0a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c03:	b8 01 00 00 00       	mov    $0x1,%eax
  801c08:	eb 05                	jmp    801c0f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 2c                	push   $0x2c
  801c23:	e8 19 fa ff ff       	call   801641 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
  801c2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c2e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c32:	75 07                	jne    801c3b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c34:	b8 01 00 00 00       	mov    $0x1,%eax
  801c39:	eb 05                	jmp    801c40 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	ff 75 08             	pushl  0x8(%ebp)
  801c50:	6a 2d                	push   $0x2d
  801c52:	e8 ea f9 ff ff       	call   801641 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5a:	90                   	nop
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	53                   	push   %ebx
  801c70:	51                   	push   %ecx
  801c71:	52                   	push   %edx
  801c72:	50                   	push   %eax
  801c73:	6a 2e                	push   $0x2e
  801c75:	e8 c7 f9 ff ff       	call   801641 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	52                   	push   %edx
  801c92:	50                   	push   %eax
  801c93:	6a 2f                	push   $0x2f
  801c95:	e8 a7 f9 ff ff       	call   801641 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ca5:	83 ec 0c             	sub    $0xc,%esp
  801ca8:	68 f8 3e 80 00       	push   $0x803ef8
  801cad:	e8 d3 e8 ff ff       	call   800585 <cprintf>
  801cb2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cb5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cbc:	83 ec 0c             	sub    $0xc,%esp
  801cbf:	68 24 3f 80 00       	push   $0x803f24
  801cc4:	e8 bc e8 ff ff       	call   800585 <cprintf>
  801cc9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ccc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cd0:	a1 38 51 80 00       	mov    0x805138,%eax
  801cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cd8:	eb 56                	jmp    801d30 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cde:	74 1c                	je     801cfc <print_mem_block_lists+0x5d>
  801ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce3:	8b 50 08             	mov    0x8(%eax),%edx
  801ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce9:	8b 48 08             	mov    0x8(%eax),%ecx
  801cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cef:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf2:	01 c8                	add    %ecx,%eax
  801cf4:	39 c2                	cmp    %eax,%edx
  801cf6:	73 04                	jae    801cfc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cf8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cff:	8b 50 08             	mov    0x8(%eax),%edx
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	8b 40 0c             	mov    0xc(%eax),%eax
  801d08:	01 c2                	add    %eax,%edx
  801d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0d:	8b 40 08             	mov    0x8(%eax),%eax
  801d10:	83 ec 04             	sub    $0x4,%esp
  801d13:	52                   	push   %edx
  801d14:	50                   	push   %eax
  801d15:	68 39 3f 80 00       	push   $0x803f39
  801d1a:	e8 66 e8 ff ff       	call   800585 <cprintf>
  801d1f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d28:	a1 40 51 80 00       	mov    0x805140,%eax
  801d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d34:	74 07                	je     801d3d <print_mem_block_lists+0x9e>
  801d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d39:	8b 00                	mov    (%eax),%eax
  801d3b:	eb 05                	jmp    801d42 <print_mem_block_lists+0xa3>
  801d3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d42:	a3 40 51 80 00       	mov    %eax,0x805140
  801d47:	a1 40 51 80 00       	mov    0x805140,%eax
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	75 8a                	jne    801cda <print_mem_block_lists+0x3b>
  801d50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d54:	75 84                	jne    801cda <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d56:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d5a:	75 10                	jne    801d6c <print_mem_block_lists+0xcd>
  801d5c:	83 ec 0c             	sub    $0xc,%esp
  801d5f:	68 48 3f 80 00       	push   $0x803f48
  801d64:	e8 1c e8 ff ff       	call   800585 <cprintf>
  801d69:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d6c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d73:	83 ec 0c             	sub    $0xc,%esp
  801d76:	68 6c 3f 80 00       	push   $0x803f6c
  801d7b:	e8 05 e8 ff ff       	call   800585 <cprintf>
  801d80:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d83:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d87:	a1 40 50 80 00       	mov    0x805040,%eax
  801d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d8f:	eb 56                	jmp    801de7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d95:	74 1c                	je     801db3 <print_mem_block_lists+0x114>
  801d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9a:	8b 50 08             	mov    0x8(%eax),%edx
  801d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da0:	8b 48 08             	mov    0x8(%eax),%ecx
  801da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da6:	8b 40 0c             	mov    0xc(%eax),%eax
  801da9:	01 c8                	add    %ecx,%eax
  801dab:	39 c2                	cmp    %eax,%edx
  801dad:	73 04                	jae    801db3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801daf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	8b 50 08             	mov    0x8(%eax),%edx
  801db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbc:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbf:	01 c2                	add    %eax,%edx
  801dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc4:	8b 40 08             	mov    0x8(%eax),%eax
  801dc7:	83 ec 04             	sub    $0x4,%esp
  801dca:	52                   	push   %edx
  801dcb:	50                   	push   %eax
  801dcc:	68 39 3f 80 00       	push   $0x803f39
  801dd1:	e8 af e7 ff ff       	call   800585 <cprintf>
  801dd6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ddf:	a1 48 50 80 00       	mov    0x805048,%eax
  801de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801deb:	74 07                	je     801df4 <print_mem_block_lists+0x155>
  801ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df0:	8b 00                	mov    (%eax),%eax
  801df2:	eb 05                	jmp    801df9 <print_mem_block_lists+0x15a>
  801df4:	b8 00 00 00 00       	mov    $0x0,%eax
  801df9:	a3 48 50 80 00       	mov    %eax,0x805048
  801dfe:	a1 48 50 80 00       	mov    0x805048,%eax
  801e03:	85 c0                	test   %eax,%eax
  801e05:	75 8a                	jne    801d91 <print_mem_block_lists+0xf2>
  801e07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e0b:	75 84                	jne    801d91 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e0d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e11:	75 10                	jne    801e23 <print_mem_block_lists+0x184>
  801e13:	83 ec 0c             	sub    $0xc,%esp
  801e16:	68 84 3f 80 00       	push   $0x803f84
  801e1b:	e8 65 e7 ff ff       	call   800585 <cprintf>
  801e20:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e23:	83 ec 0c             	sub    $0xc,%esp
  801e26:	68 f8 3e 80 00       	push   $0x803ef8
  801e2b:	e8 55 e7 ff ff       	call   800585 <cprintf>
  801e30:	83 c4 10             	add    $0x10,%esp

}
  801e33:	90                   	nop
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e3c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801e43:	00 00 00 
  801e46:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801e4d:	00 00 00 
  801e50:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801e57:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e61:	e9 9e 00 00 00       	jmp    801f04 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e66:	a1 50 50 80 00       	mov    0x805050,%eax
  801e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e6e:	c1 e2 04             	shl    $0x4,%edx
  801e71:	01 d0                	add    %edx,%eax
  801e73:	85 c0                	test   %eax,%eax
  801e75:	75 14                	jne    801e8b <initialize_MemBlocksList+0x55>
  801e77:	83 ec 04             	sub    $0x4,%esp
  801e7a:	68 ac 3f 80 00       	push   $0x803fac
  801e7f:	6a 46                	push   $0x46
  801e81:	68 cf 3f 80 00       	push   $0x803fcf
  801e86:	e8 46 e4 ff ff       	call   8002d1 <_panic>
  801e8b:	a1 50 50 80 00       	mov    0x805050,%eax
  801e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e93:	c1 e2 04             	shl    $0x4,%edx
  801e96:	01 d0                	add    %edx,%eax
  801e98:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801e9e:	89 10                	mov    %edx,(%eax)
  801ea0:	8b 00                	mov    (%eax),%eax
  801ea2:	85 c0                	test   %eax,%eax
  801ea4:	74 18                	je     801ebe <initialize_MemBlocksList+0x88>
  801ea6:	a1 48 51 80 00       	mov    0x805148,%eax
  801eab:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801eb1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801eb4:	c1 e1 04             	shl    $0x4,%ecx
  801eb7:	01 ca                	add    %ecx,%edx
  801eb9:	89 50 04             	mov    %edx,0x4(%eax)
  801ebc:	eb 12                	jmp    801ed0 <initialize_MemBlocksList+0x9a>
  801ebe:	a1 50 50 80 00       	mov    0x805050,%eax
  801ec3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec6:	c1 e2 04             	shl    $0x4,%edx
  801ec9:	01 d0                	add    %edx,%eax
  801ecb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ed0:	a1 50 50 80 00       	mov    0x805050,%eax
  801ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed8:	c1 e2 04             	shl    $0x4,%edx
  801edb:	01 d0                	add    %edx,%eax
  801edd:	a3 48 51 80 00       	mov    %eax,0x805148
  801ee2:	a1 50 50 80 00       	mov    0x805050,%eax
  801ee7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eea:	c1 e2 04             	shl    $0x4,%edx
  801eed:	01 d0                	add    %edx,%eax
  801eef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ef6:	a1 54 51 80 00       	mov    0x805154,%eax
  801efb:	40                   	inc    %eax
  801efc:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f01:	ff 45 f4             	incl   -0xc(%ebp)
  801f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f07:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f0a:	0f 82 56 ff ff ff    	jb     801e66 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f10:	90                   	nop
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	8b 00                	mov    (%eax),%eax
  801f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f21:	eb 19                	jmp    801f3c <find_block+0x29>
	{
		if(va==point->sva)
  801f23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f26:	8b 40 08             	mov    0x8(%eax),%eax
  801f29:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f2c:	75 05                	jne    801f33 <find_block+0x20>
		   return point;
  801f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f31:	eb 36                	jmp    801f69 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	8b 40 08             	mov    0x8(%eax),%eax
  801f39:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f3c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f40:	74 07                	je     801f49 <find_block+0x36>
  801f42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f45:	8b 00                	mov    (%eax),%eax
  801f47:	eb 05                	jmp    801f4e <find_block+0x3b>
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f51:	89 42 08             	mov    %eax,0x8(%edx)
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	8b 40 08             	mov    0x8(%eax),%eax
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	75 c5                	jne    801f23 <find_block+0x10>
  801f5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f62:	75 bf                	jne    801f23 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f71:	a1 40 50 80 00       	mov    0x805040,%eax
  801f76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f79:	a1 44 50 80 00       	mov    0x805044,%eax
  801f7e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f84:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f87:	74 24                	je     801fad <insert_sorted_allocList+0x42>
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	8b 50 08             	mov    0x8(%eax),%edx
  801f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f92:	8b 40 08             	mov    0x8(%eax),%eax
  801f95:	39 c2                	cmp    %eax,%edx
  801f97:	76 14                	jbe    801fad <insert_sorted_allocList+0x42>
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	8b 50 08             	mov    0x8(%eax),%edx
  801f9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa2:	8b 40 08             	mov    0x8(%eax),%eax
  801fa5:	39 c2                	cmp    %eax,%edx
  801fa7:	0f 82 60 01 00 00    	jb     80210d <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb1:	75 65                	jne    802018 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fb7:	75 14                	jne    801fcd <insert_sorted_allocList+0x62>
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	68 ac 3f 80 00       	push   $0x803fac
  801fc1:	6a 6b                	push   $0x6b
  801fc3:	68 cf 3f 80 00       	push   $0x803fcf
  801fc8:	e8 04 e3 ff ff       	call   8002d1 <_panic>
  801fcd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	89 10                	mov    %edx,(%eax)
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	8b 00                	mov    (%eax),%eax
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	74 0d                	je     801fee <insert_sorted_allocList+0x83>
  801fe1:	a1 40 50 80 00       	mov    0x805040,%eax
  801fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe9:	89 50 04             	mov    %edx,0x4(%eax)
  801fec:	eb 08                	jmp    801ff6 <insert_sorted_allocList+0x8b>
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	a3 44 50 80 00       	mov    %eax,0x805044
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	a3 40 50 80 00       	mov    %eax,0x805040
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802008:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80200d:	40                   	inc    %eax
  80200e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802013:	e9 dc 01 00 00       	jmp    8021f4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	8b 50 08             	mov    0x8(%eax),%edx
  80201e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802021:	8b 40 08             	mov    0x8(%eax),%eax
  802024:	39 c2                	cmp    %eax,%edx
  802026:	77 6c                	ja     802094 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802028:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80202c:	74 06                	je     802034 <insert_sorted_allocList+0xc9>
  80202e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802032:	75 14                	jne    802048 <insert_sorted_allocList+0xdd>
  802034:	83 ec 04             	sub    $0x4,%esp
  802037:	68 e8 3f 80 00       	push   $0x803fe8
  80203c:	6a 6f                	push   $0x6f
  80203e:	68 cf 3f 80 00       	push   $0x803fcf
  802043:	e8 89 e2 ff ff       	call   8002d1 <_panic>
  802048:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204b:	8b 50 04             	mov    0x4(%eax),%edx
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	89 50 04             	mov    %edx,0x4(%eax)
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80205a:	89 10                	mov    %edx,(%eax)
  80205c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205f:	8b 40 04             	mov    0x4(%eax),%eax
  802062:	85 c0                	test   %eax,%eax
  802064:	74 0d                	je     802073 <insert_sorted_allocList+0x108>
  802066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802069:	8b 40 04             	mov    0x4(%eax),%eax
  80206c:	8b 55 08             	mov    0x8(%ebp),%edx
  80206f:	89 10                	mov    %edx,(%eax)
  802071:	eb 08                	jmp    80207b <insert_sorted_allocList+0x110>
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	a3 40 50 80 00       	mov    %eax,0x805040
  80207b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207e:	8b 55 08             	mov    0x8(%ebp),%edx
  802081:	89 50 04             	mov    %edx,0x4(%eax)
  802084:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802089:	40                   	inc    %eax
  80208a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80208f:	e9 60 01 00 00       	jmp    8021f4 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	8b 50 08             	mov    0x8(%eax),%edx
  80209a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209d:	8b 40 08             	mov    0x8(%eax),%eax
  8020a0:	39 c2                	cmp    %eax,%edx
  8020a2:	0f 82 4c 01 00 00    	jb     8021f4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ac:	75 14                	jne    8020c2 <insert_sorted_allocList+0x157>
  8020ae:	83 ec 04             	sub    $0x4,%esp
  8020b1:	68 20 40 80 00       	push   $0x804020
  8020b6:	6a 73                	push   $0x73
  8020b8:	68 cf 3f 80 00       	push   $0x803fcf
  8020bd:	e8 0f e2 ff ff       	call   8002d1 <_panic>
  8020c2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	89 50 04             	mov    %edx,0x4(%eax)
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	8b 40 04             	mov    0x4(%eax),%eax
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	74 0c                	je     8020e4 <insert_sorted_allocList+0x179>
  8020d8:	a1 44 50 80 00       	mov    0x805044,%eax
  8020dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e0:	89 10                	mov    %edx,(%eax)
  8020e2:	eb 08                	jmp    8020ec <insert_sorted_allocList+0x181>
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	a3 40 50 80 00       	mov    %eax,0x805040
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	a3 44 50 80 00       	mov    %eax,0x805044
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020fd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802102:	40                   	inc    %eax
  802103:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802108:	e9 e7 00 00 00       	jmp    8021f4 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80210d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802110:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802113:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80211a:	a1 40 50 80 00       	mov    0x805040,%eax
  80211f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802122:	e9 9d 00 00 00       	jmp    8021c4 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212a:	8b 00                	mov    (%eax),%eax
  80212c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	8b 50 08             	mov    0x8(%eax),%edx
  802135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802138:	8b 40 08             	mov    0x8(%eax),%eax
  80213b:	39 c2                	cmp    %eax,%edx
  80213d:	76 7d                	jbe    8021bc <insert_sorted_allocList+0x251>
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	8b 50 08             	mov    0x8(%eax),%edx
  802145:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802148:	8b 40 08             	mov    0x8(%eax),%eax
  80214b:	39 c2                	cmp    %eax,%edx
  80214d:	73 6d                	jae    8021bc <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80214f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802153:	74 06                	je     80215b <insert_sorted_allocList+0x1f0>
  802155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802159:	75 14                	jne    80216f <insert_sorted_allocList+0x204>
  80215b:	83 ec 04             	sub    $0x4,%esp
  80215e:	68 44 40 80 00       	push   $0x804044
  802163:	6a 7f                	push   $0x7f
  802165:	68 cf 3f 80 00       	push   $0x803fcf
  80216a:	e8 62 e1 ff ff       	call   8002d1 <_panic>
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	8b 10                	mov    (%eax),%edx
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	89 10                	mov    %edx,(%eax)
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	8b 00                	mov    (%eax),%eax
  80217e:	85 c0                	test   %eax,%eax
  802180:	74 0b                	je     80218d <insert_sorted_allocList+0x222>
  802182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802185:	8b 00                	mov    (%eax),%eax
  802187:	8b 55 08             	mov    0x8(%ebp),%edx
  80218a:	89 50 04             	mov    %edx,0x4(%eax)
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	8b 55 08             	mov    0x8(%ebp),%edx
  802193:	89 10                	mov    %edx,(%eax)
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219b:	89 50 04             	mov    %edx,0x4(%eax)
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	8b 00                	mov    (%eax),%eax
  8021a3:	85 c0                	test   %eax,%eax
  8021a5:	75 08                	jne    8021af <insert_sorted_allocList+0x244>
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	a3 44 50 80 00       	mov    %eax,0x805044
  8021af:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021b4:	40                   	inc    %eax
  8021b5:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8021ba:	eb 39                	jmp    8021f5 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021bc:	a1 48 50 80 00       	mov    0x805048,%eax
  8021c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c8:	74 07                	je     8021d1 <insert_sorted_allocList+0x266>
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	8b 00                	mov    (%eax),%eax
  8021cf:	eb 05                	jmp    8021d6 <insert_sorted_allocList+0x26b>
  8021d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d6:	a3 48 50 80 00       	mov    %eax,0x805048
  8021db:	a1 48 50 80 00       	mov    0x805048,%eax
  8021e0:	85 c0                	test   %eax,%eax
  8021e2:	0f 85 3f ff ff ff    	jne    802127 <insert_sorted_allocList+0x1bc>
  8021e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ec:	0f 85 35 ff ff ff    	jne    802127 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021f2:	eb 01                	jmp    8021f5 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021f4:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021f5:	90                   	nop
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
  8021fb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021fe:	a1 38 51 80 00       	mov    0x805138,%eax
  802203:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802206:	e9 85 01 00 00       	jmp    802390 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80220b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220e:	8b 40 0c             	mov    0xc(%eax),%eax
  802211:	3b 45 08             	cmp    0x8(%ebp),%eax
  802214:	0f 82 6e 01 00 00    	jb     802388 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	8b 40 0c             	mov    0xc(%eax),%eax
  802220:	3b 45 08             	cmp    0x8(%ebp),%eax
  802223:	0f 85 8a 00 00 00    	jne    8022b3 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802229:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222d:	75 17                	jne    802246 <alloc_block_FF+0x4e>
  80222f:	83 ec 04             	sub    $0x4,%esp
  802232:	68 78 40 80 00       	push   $0x804078
  802237:	68 93 00 00 00       	push   $0x93
  80223c:	68 cf 3f 80 00       	push   $0x803fcf
  802241:	e8 8b e0 ff ff       	call   8002d1 <_panic>
  802246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802249:	8b 00                	mov    (%eax),%eax
  80224b:	85 c0                	test   %eax,%eax
  80224d:	74 10                	je     80225f <alloc_block_FF+0x67>
  80224f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802252:	8b 00                	mov    (%eax),%eax
  802254:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802257:	8b 52 04             	mov    0x4(%edx),%edx
  80225a:	89 50 04             	mov    %edx,0x4(%eax)
  80225d:	eb 0b                	jmp    80226a <alloc_block_FF+0x72>
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	8b 40 04             	mov    0x4(%eax),%eax
  802265:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	8b 40 04             	mov    0x4(%eax),%eax
  802270:	85 c0                	test   %eax,%eax
  802272:	74 0f                	je     802283 <alloc_block_FF+0x8b>
  802274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802277:	8b 40 04             	mov    0x4(%eax),%eax
  80227a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227d:	8b 12                	mov    (%edx),%edx
  80227f:	89 10                	mov    %edx,(%eax)
  802281:	eb 0a                	jmp    80228d <alloc_block_FF+0x95>
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	8b 00                	mov    (%eax),%eax
  802288:	a3 38 51 80 00       	mov    %eax,0x805138
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802299:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8022a5:	48                   	dec    %eax
  8022a6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	e9 10 01 00 00       	jmp    8023c3 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022bc:	0f 86 c6 00 00 00    	jbe    802388 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022c2:	a1 48 51 80 00       	mov    0x805148,%eax
  8022c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	8b 50 08             	mov    0x8(%eax),%edx
  8022d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d3:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022dc:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022e3:	75 17                	jne    8022fc <alloc_block_FF+0x104>
  8022e5:	83 ec 04             	sub    $0x4,%esp
  8022e8:	68 78 40 80 00       	push   $0x804078
  8022ed:	68 9b 00 00 00       	push   $0x9b
  8022f2:	68 cf 3f 80 00       	push   $0x803fcf
  8022f7:	e8 d5 df ff ff       	call   8002d1 <_panic>
  8022fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ff:	8b 00                	mov    (%eax),%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	74 10                	je     802315 <alloc_block_FF+0x11d>
  802305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802308:	8b 00                	mov    (%eax),%eax
  80230a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80230d:	8b 52 04             	mov    0x4(%edx),%edx
  802310:	89 50 04             	mov    %edx,0x4(%eax)
  802313:	eb 0b                	jmp    802320 <alloc_block_FF+0x128>
  802315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802318:	8b 40 04             	mov    0x4(%eax),%eax
  80231b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802323:	8b 40 04             	mov    0x4(%eax),%eax
  802326:	85 c0                	test   %eax,%eax
  802328:	74 0f                	je     802339 <alloc_block_FF+0x141>
  80232a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232d:	8b 40 04             	mov    0x4(%eax),%eax
  802330:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802333:	8b 12                	mov    (%edx),%edx
  802335:	89 10                	mov    %edx,(%eax)
  802337:	eb 0a                	jmp    802343 <alloc_block_FF+0x14b>
  802339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233c:	8b 00                	mov    (%eax),%eax
  80233e:	a3 48 51 80 00       	mov    %eax,0x805148
  802343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802346:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80234c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802356:	a1 54 51 80 00       	mov    0x805154,%eax
  80235b:	48                   	dec    %eax
  80235c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	8b 50 08             	mov    0x8(%eax),%edx
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	01 c2                	add    %eax,%edx
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	8b 40 0c             	mov    0xc(%eax),%eax
  802378:	2b 45 08             	sub    0x8(%ebp),%eax
  80237b:	89 c2                	mov    %eax,%edx
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802386:	eb 3b                	jmp    8023c3 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802388:	a1 40 51 80 00       	mov    0x805140,%eax
  80238d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802390:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802394:	74 07                	je     80239d <alloc_block_FF+0x1a5>
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 00                	mov    (%eax),%eax
  80239b:	eb 05                	jmp    8023a2 <alloc_block_FF+0x1aa>
  80239d:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a2:	a3 40 51 80 00       	mov    %eax,0x805140
  8023a7:	a1 40 51 80 00       	mov    0x805140,%eax
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	0f 85 57 fe ff ff    	jne    80220b <alloc_block_FF+0x13>
  8023b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b8:	0f 85 4d fe ff ff    	jne    80220b <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023cb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8023d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023da:	e9 df 00 00 00       	jmp    8024be <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e8:	0f 82 c8 00 00 00    	jb     8024b6 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f7:	0f 85 8a 00 00 00    	jne    802487 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802401:	75 17                	jne    80241a <alloc_block_BF+0x55>
  802403:	83 ec 04             	sub    $0x4,%esp
  802406:	68 78 40 80 00       	push   $0x804078
  80240b:	68 b7 00 00 00       	push   $0xb7
  802410:	68 cf 3f 80 00       	push   $0x803fcf
  802415:	e8 b7 de ff ff       	call   8002d1 <_panic>
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 00                	mov    (%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	74 10                	je     802433 <alloc_block_BF+0x6e>
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 00                	mov    (%eax),%eax
  802428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242b:	8b 52 04             	mov    0x4(%edx),%edx
  80242e:	89 50 04             	mov    %edx,0x4(%eax)
  802431:	eb 0b                	jmp    80243e <alloc_block_BF+0x79>
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 40 04             	mov    0x4(%eax),%eax
  802439:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 40 04             	mov    0x4(%eax),%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	74 0f                	je     802457 <alloc_block_BF+0x92>
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802451:	8b 12                	mov    (%edx),%edx
  802453:	89 10                	mov    %edx,(%eax)
  802455:	eb 0a                	jmp    802461 <alloc_block_BF+0x9c>
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	a3 38 51 80 00       	mov    %eax,0x805138
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802474:	a1 44 51 80 00       	mov    0x805144,%eax
  802479:	48                   	dec    %eax
  80247a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	e9 4d 01 00 00       	jmp    8025d4 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 40 0c             	mov    0xc(%eax),%eax
  80248d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802490:	76 24                	jbe    8024b6 <alloc_block_BF+0xf1>
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 40 0c             	mov    0xc(%eax),%eax
  802498:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80249b:	73 19                	jae    8024b6 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80249d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 40 08             	mov    0x8(%eax),%eax
  8024b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024b6:	a1 40 51 80 00       	mov    0x805140,%eax
  8024bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c2:	74 07                	je     8024cb <alloc_block_BF+0x106>
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 00                	mov    (%eax),%eax
  8024c9:	eb 05                	jmp    8024d0 <alloc_block_BF+0x10b>
  8024cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d0:	a3 40 51 80 00       	mov    %eax,0x805140
  8024d5:	a1 40 51 80 00       	mov    0x805140,%eax
  8024da:	85 c0                	test   %eax,%eax
  8024dc:	0f 85 fd fe ff ff    	jne    8023df <alloc_block_BF+0x1a>
  8024e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e6:	0f 85 f3 fe ff ff    	jne    8023df <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8024ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024f0:	0f 84 d9 00 00 00    	je     8025cf <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024f6:	a1 48 51 80 00       	mov    0x805148,%eax
  8024fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802501:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802504:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250a:	8b 55 08             	mov    0x8(%ebp),%edx
  80250d:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802510:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802514:	75 17                	jne    80252d <alloc_block_BF+0x168>
  802516:	83 ec 04             	sub    $0x4,%esp
  802519:	68 78 40 80 00       	push   $0x804078
  80251e:	68 c7 00 00 00       	push   $0xc7
  802523:	68 cf 3f 80 00       	push   $0x803fcf
  802528:	e8 a4 dd ff ff       	call   8002d1 <_panic>
  80252d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802530:	8b 00                	mov    (%eax),%eax
  802532:	85 c0                	test   %eax,%eax
  802534:	74 10                	je     802546 <alloc_block_BF+0x181>
  802536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802539:	8b 00                	mov    (%eax),%eax
  80253b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80253e:	8b 52 04             	mov    0x4(%edx),%edx
  802541:	89 50 04             	mov    %edx,0x4(%eax)
  802544:	eb 0b                	jmp    802551 <alloc_block_BF+0x18c>
  802546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802549:	8b 40 04             	mov    0x4(%eax),%eax
  80254c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802554:	8b 40 04             	mov    0x4(%eax),%eax
  802557:	85 c0                	test   %eax,%eax
  802559:	74 0f                	je     80256a <alloc_block_BF+0x1a5>
  80255b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255e:	8b 40 04             	mov    0x4(%eax),%eax
  802561:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802564:	8b 12                	mov    (%edx),%edx
  802566:	89 10                	mov    %edx,(%eax)
  802568:	eb 0a                	jmp    802574 <alloc_block_BF+0x1af>
  80256a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256d:	8b 00                	mov    (%eax),%eax
  80256f:	a3 48 51 80 00       	mov    %eax,0x805148
  802574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802577:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80257d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802580:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802587:	a1 54 51 80 00       	mov    0x805154,%eax
  80258c:	48                   	dec    %eax
  80258d:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802592:	83 ec 08             	sub    $0x8,%esp
  802595:	ff 75 ec             	pushl  -0x14(%ebp)
  802598:	68 38 51 80 00       	push   $0x805138
  80259d:	e8 71 f9 ff ff       	call   801f13 <find_block>
  8025a2:	83 c4 10             	add    $0x10,%esp
  8025a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ab:	8b 50 08             	mov    0x8(%eax),%edx
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	01 c2                	add    %eax,%edx
  8025b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b6:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8025c2:	89 c2                	mov    %eax,%edx
  8025c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c7:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cd:	eb 05                	jmp    8025d4 <alloc_block_BF+0x20f>
	}
	return NULL;
  8025cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d4:	c9                   	leave  
  8025d5:	c3                   	ret    

008025d6 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
  8025d9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025dc:	a1 28 50 80 00       	mov    0x805028,%eax
  8025e1:	85 c0                	test   %eax,%eax
  8025e3:	0f 85 de 01 00 00    	jne    8027c7 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025e9:	a1 38 51 80 00       	mov    0x805138,%eax
  8025ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f1:	e9 9e 01 00 00       	jmp    802794 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ff:	0f 82 87 01 00 00    	jb     80278c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 40 0c             	mov    0xc(%eax),%eax
  80260b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80260e:	0f 85 95 00 00 00    	jne    8026a9 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802618:	75 17                	jne    802631 <alloc_block_NF+0x5b>
  80261a:	83 ec 04             	sub    $0x4,%esp
  80261d:	68 78 40 80 00       	push   $0x804078
  802622:	68 e0 00 00 00       	push   $0xe0
  802627:	68 cf 3f 80 00       	push   $0x803fcf
  80262c:	e8 a0 dc ff ff       	call   8002d1 <_panic>
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 00                	mov    (%eax),%eax
  802636:	85 c0                	test   %eax,%eax
  802638:	74 10                	je     80264a <alloc_block_NF+0x74>
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 00                	mov    (%eax),%eax
  80263f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802642:	8b 52 04             	mov    0x4(%edx),%edx
  802645:	89 50 04             	mov    %edx,0x4(%eax)
  802648:	eb 0b                	jmp    802655 <alloc_block_NF+0x7f>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 40 04             	mov    0x4(%eax),%eax
  802650:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 40 04             	mov    0x4(%eax),%eax
  80265b:	85 c0                	test   %eax,%eax
  80265d:	74 0f                	je     80266e <alloc_block_NF+0x98>
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 40 04             	mov    0x4(%eax),%eax
  802665:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802668:	8b 12                	mov    (%edx),%edx
  80266a:	89 10                	mov    %edx,(%eax)
  80266c:	eb 0a                	jmp    802678 <alloc_block_NF+0xa2>
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	8b 00                	mov    (%eax),%eax
  802673:	a3 38 51 80 00       	mov    %eax,0x805138
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268b:	a1 44 51 80 00       	mov    0x805144,%eax
  802690:	48                   	dec    %eax
  802691:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 40 08             	mov    0x8(%eax),%eax
  80269c:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	e9 f8 04 00 00       	jmp    802ba1 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8026af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b2:	0f 86 d4 00 00 00    	jbe    80278c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8026bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 50 08             	mov    0x8(%eax),%edx
  8026c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c9:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d2:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026d9:	75 17                	jne    8026f2 <alloc_block_NF+0x11c>
  8026db:	83 ec 04             	sub    $0x4,%esp
  8026de:	68 78 40 80 00       	push   $0x804078
  8026e3:	68 e9 00 00 00       	push   $0xe9
  8026e8:	68 cf 3f 80 00       	push   $0x803fcf
  8026ed:	e8 df db ff ff       	call   8002d1 <_panic>
  8026f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f5:	8b 00                	mov    (%eax),%eax
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	74 10                	je     80270b <alloc_block_NF+0x135>
  8026fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fe:	8b 00                	mov    (%eax),%eax
  802700:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802703:	8b 52 04             	mov    0x4(%edx),%edx
  802706:	89 50 04             	mov    %edx,0x4(%eax)
  802709:	eb 0b                	jmp    802716 <alloc_block_NF+0x140>
  80270b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270e:	8b 40 04             	mov    0x4(%eax),%eax
  802711:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802719:	8b 40 04             	mov    0x4(%eax),%eax
  80271c:	85 c0                	test   %eax,%eax
  80271e:	74 0f                	je     80272f <alloc_block_NF+0x159>
  802720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802723:	8b 40 04             	mov    0x4(%eax),%eax
  802726:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802729:	8b 12                	mov    (%edx),%edx
  80272b:	89 10                	mov    %edx,(%eax)
  80272d:	eb 0a                	jmp    802739 <alloc_block_NF+0x163>
  80272f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802732:	8b 00                	mov    (%eax),%eax
  802734:	a3 48 51 80 00       	mov    %eax,0x805148
  802739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802745:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274c:	a1 54 51 80 00       	mov    0x805154,%eax
  802751:	48                   	dec    %eax
  802752:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802757:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275a:	8b 40 08             	mov    0x8(%eax),%eax
  80275d:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 50 08             	mov    0x8(%eax),%edx
  802768:	8b 45 08             	mov    0x8(%ebp),%eax
  80276b:	01 c2                	add    %eax,%edx
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 40 0c             	mov    0xc(%eax),%eax
  802779:	2b 45 08             	sub    0x8(%ebp),%eax
  80277c:	89 c2                	mov    %eax,%edx
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	e9 15 04 00 00       	jmp    802ba1 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80278c:	a1 40 51 80 00       	mov    0x805140,%eax
  802791:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802794:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802798:	74 07                	je     8027a1 <alloc_block_NF+0x1cb>
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	eb 05                	jmp    8027a6 <alloc_block_NF+0x1d0>
  8027a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a6:	a3 40 51 80 00       	mov    %eax,0x805140
  8027ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8027b0:	85 c0                	test   %eax,%eax
  8027b2:	0f 85 3e fe ff ff    	jne    8025f6 <alloc_block_NF+0x20>
  8027b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bc:	0f 85 34 fe ff ff    	jne    8025f6 <alloc_block_NF+0x20>
  8027c2:	e9 d5 03 00 00       	jmp    802b9c <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8027cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027cf:	e9 b1 01 00 00       	jmp    802985 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 50 08             	mov    0x8(%eax),%edx
  8027da:	a1 28 50 80 00       	mov    0x805028,%eax
  8027df:	39 c2                	cmp    %eax,%edx
  8027e1:	0f 82 96 01 00 00    	jb     80297d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f0:	0f 82 87 01 00 00    	jb     80297d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ff:	0f 85 95 00 00 00    	jne    80289a <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802805:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802809:	75 17                	jne    802822 <alloc_block_NF+0x24c>
  80280b:	83 ec 04             	sub    $0x4,%esp
  80280e:	68 78 40 80 00       	push   $0x804078
  802813:	68 fc 00 00 00       	push   $0xfc
  802818:	68 cf 3f 80 00       	push   $0x803fcf
  80281d:	e8 af da ff ff       	call   8002d1 <_panic>
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8b 00                	mov    (%eax),%eax
  802827:	85 c0                	test   %eax,%eax
  802829:	74 10                	je     80283b <alloc_block_NF+0x265>
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 00                	mov    (%eax),%eax
  802830:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802833:	8b 52 04             	mov    0x4(%edx),%edx
  802836:	89 50 04             	mov    %edx,0x4(%eax)
  802839:	eb 0b                	jmp    802846 <alloc_block_NF+0x270>
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 40 04             	mov    0x4(%eax),%eax
  802841:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 04             	mov    0x4(%eax),%eax
  80284c:	85 c0                	test   %eax,%eax
  80284e:	74 0f                	je     80285f <alloc_block_NF+0x289>
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	8b 40 04             	mov    0x4(%eax),%eax
  802856:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802859:	8b 12                	mov    (%edx),%edx
  80285b:	89 10                	mov    %edx,(%eax)
  80285d:	eb 0a                	jmp    802869 <alloc_block_NF+0x293>
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	8b 00                	mov    (%eax),%eax
  802864:	a3 38 51 80 00       	mov    %eax,0x805138
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287c:	a1 44 51 80 00       	mov    0x805144,%eax
  802881:	48                   	dec    %eax
  802882:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288a:	8b 40 08             	mov    0x8(%eax),%eax
  80288d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	e9 07 03 00 00       	jmp    802ba1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a3:	0f 86 d4 00 00 00    	jbe    80297d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8028ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 50 08             	mov    0x8(%eax),%edx
  8028b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ba:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028ca:	75 17                	jne    8028e3 <alloc_block_NF+0x30d>
  8028cc:	83 ec 04             	sub    $0x4,%esp
  8028cf:	68 78 40 80 00       	push   $0x804078
  8028d4:	68 04 01 00 00       	push   $0x104
  8028d9:	68 cf 3f 80 00       	push   $0x803fcf
  8028de:	e8 ee d9 ff ff       	call   8002d1 <_panic>
  8028e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	85 c0                	test   %eax,%eax
  8028ea:	74 10                	je     8028fc <alloc_block_NF+0x326>
  8028ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028f4:	8b 52 04             	mov    0x4(%edx),%edx
  8028f7:	89 50 04             	mov    %edx,0x4(%eax)
  8028fa:	eb 0b                	jmp    802907 <alloc_block_NF+0x331>
  8028fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ff:	8b 40 04             	mov    0x4(%eax),%eax
  802902:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802907:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290a:	8b 40 04             	mov    0x4(%eax),%eax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	74 0f                	je     802920 <alloc_block_NF+0x34a>
  802911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802914:	8b 40 04             	mov    0x4(%eax),%eax
  802917:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80291a:	8b 12                	mov    (%edx),%edx
  80291c:	89 10                	mov    %edx,(%eax)
  80291e:	eb 0a                	jmp    80292a <alloc_block_NF+0x354>
  802920:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	a3 48 51 80 00       	mov    %eax,0x805148
  80292a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802933:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802936:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293d:	a1 54 51 80 00       	mov    0x805154,%eax
  802942:	48                   	dec    %eax
  802943:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802948:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294b:	8b 40 08             	mov    0x8(%eax),%eax
  80294e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	8b 50 08             	mov    0x8(%eax),%edx
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	01 c2                	add    %eax,%edx
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	8b 40 0c             	mov    0xc(%eax),%eax
  80296a:	2b 45 08             	sub    0x8(%ebp),%eax
  80296d:	89 c2                	mov    %eax,%edx
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802975:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802978:	e9 24 02 00 00       	jmp    802ba1 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80297d:	a1 40 51 80 00       	mov    0x805140,%eax
  802982:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802985:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802989:	74 07                	je     802992 <alloc_block_NF+0x3bc>
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 00                	mov    (%eax),%eax
  802990:	eb 05                	jmp    802997 <alloc_block_NF+0x3c1>
  802992:	b8 00 00 00 00       	mov    $0x0,%eax
  802997:	a3 40 51 80 00       	mov    %eax,0x805140
  80299c:	a1 40 51 80 00       	mov    0x805140,%eax
  8029a1:	85 c0                	test   %eax,%eax
  8029a3:	0f 85 2b fe ff ff    	jne    8027d4 <alloc_block_NF+0x1fe>
  8029a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ad:	0f 85 21 fe ff ff    	jne    8027d4 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8029b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029bb:	e9 ae 01 00 00       	jmp    802b6e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 50 08             	mov    0x8(%eax),%edx
  8029c6:	a1 28 50 80 00       	mov    0x805028,%eax
  8029cb:	39 c2                	cmp    %eax,%edx
  8029cd:	0f 83 93 01 00 00    	jae    802b66 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029dc:	0f 82 84 01 00 00    	jb     802b66 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029eb:	0f 85 95 00 00 00    	jne    802a86 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f5:	75 17                	jne    802a0e <alloc_block_NF+0x438>
  8029f7:	83 ec 04             	sub    $0x4,%esp
  8029fa:	68 78 40 80 00       	push   $0x804078
  8029ff:	68 14 01 00 00       	push   $0x114
  802a04:	68 cf 3f 80 00       	push   $0x803fcf
  802a09:	e8 c3 d8 ff ff       	call   8002d1 <_panic>
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 00                	mov    (%eax),%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	74 10                	je     802a27 <alloc_block_NF+0x451>
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1f:	8b 52 04             	mov    0x4(%edx),%edx
  802a22:	89 50 04             	mov    %edx,0x4(%eax)
  802a25:	eb 0b                	jmp    802a32 <alloc_block_NF+0x45c>
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 04             	mov    0x4(%eax),%eax
  802a2d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 40 04             	mov    0x4(%eax),%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	74 0f                	je     802a4b <alloc_block_NF+0x475>
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 40 04             	mov    0x4(%eax),%eax
  802a42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a45:	8b 12                	mov    (%edx),%edx
  802a47:	89 10                	mov    %edx,(%eax)
  802a49:	eb 0a                	jmp    802a55 <alloc_block_NF+0x47f>
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	a3 38 51 80 00       	mov    %eax,0x805138
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a68:	a1 44 51 80 00       	mov    0x805144,%eax
  802a6d:	48                   	dec    %eax
  802a6e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	8b 40 08             	mov    0x8(%eax),%eax
  802a79:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	e9 1b 01 00 00       	jmp    802ba1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a8f:	0f 86 d1 00 00 00    	jbe    802b66 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a95:	a1 48 51 80 00       	mov    0x805148,%eax
  802a9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 50 08             	mov    0x8(%eax),%edx
  802aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aac:	8b 55 08             	mov    0x8(%ebp),%edx
  802aaf:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ab2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ab6:	75 17                	jne    802acf <alloc_block_NF+0x4f9>
  802ab8:	83 ec 04             	sub    $0x4,%esp
  802abb:	68 78 40 80 00       	push   $0x804078
  802ac0:	68 1c 01 00 00       	push   $0x11c
  802ac5:	68 cf 3f 80 00       	push   $0x803fcf
  802aca:	e8 02 d8 ff ff       	call   8002d1 <_panic>
  802acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad2:	8b 00                	mov    (%eax),%eax
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	74 10                	je     802ae8 <alloc_block_NF+0x512>
  802ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adb:	8b 00                	mov    (%eax),%eax
  802add:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae0:	8b 52 04             	mov    0x4(%edx),%edx
  802ae3:	89 50 04             	mov    %edx,0x4(%eax)
  802ae6:	eb 0b                	jmp    802af3 <alloc_block_NF+0x51d>
  802ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aeb:	8b 40 04             	mov    0x4(%eax),%eax
  802aee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af6:	8b 40 04             	mov    0x4(%eax),%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	74 0f                	je     802b0c <alloc_block_NF+0x536>
  802afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b00:	8b 40 04             	mov    0x4(%eax),%eax
  802b03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b06:	8b 12                	mov    (%edx),%edx
  802b08:	89 10                	mov    %edx,(%eax)
  802b0a:	eb 0a                	jmp    802b16 <alloc_block_NF+0x540>
  802b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	a3 48 51 80 00       	mov    %eax,0x805148
  802b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b29:	a1 54 51 80 00       	mov    0x805154,%eax
  802b2e:	48                   	dec    %eax
  802b2f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b37:	8b 40 08             	mov    0x8(%eax),%eax
  802b3a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 50 08             	mov    0x8(%eax),%edx
  802b45:	8b 45 08             	mov    0x8(%ebp),%eax
  802b48:	01 c2                	add    %eax,%edx
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 40 0c             	mov    0xc(%eax),%eax
  802b56:	2b 45 08             	sub    0x8(%ebp),%eax
  802b59:	89 c2                	mov    %eax,%edx
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b64:	eb 3b                	jmp    802ba1 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b66:	a1 40 51 80 00       	mov    0x805140,%eax
  802b6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b72:	74 07                	je     802b7b <alloc_block_NF+0x5a5>
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	eb 05                	jmp    802b80 <alloc_block_NF+0x5aa>
  802b7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b80:	a3 40 51 80 00       	mov    %eax,0x805140
  802b85:	a1 40 51 80 00       	mov    0x805140,%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	0f 85 2e fe ff ff    	jne    8029c0 <alloc_block_NF+0x3ea>
  802b92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b96:	0f 85 24 fe ff ff    	jne    8029c0 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba1:	c9                   	leave  
  802ba2:	c3                   	ret    

00802ba3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ba3:	55                   	push   %ebp
  802ba4:	89 e5                	mov    %esp,%ebp
  802ba6:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ba9:	a1 38 51 80 00       	mov    0x805138,%eax
  802bae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bb1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802bb6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bb9:	a1 38 51 80 00       	mov    0x805138,%eax
  802bbe:	85 c0                	test   %eax,%eax
  802bc0:	74 14                	je     802bd6 <insert_sorted_with_merge_freeList+0x33>
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	8b 50 08             	mov    0x8(%eax),%edx
  802bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcb:	8b 40 08             	mov    0x8(%eax),%eax
  802bce:	39 c2                	cmp    %eax,%edx
  802bd0:	0f 87 9b 01 00 00    	ja     802d71 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bda:	75 17                	jne    802bf3 <insert_sorted_with_merge_freeList+0x50>
  802bdc:	83 ec 04             	sub    $0x4,%esp
  802bdf:	68 ac 3f 80 00       	push   $0x803fac
  802be4:	68 38 01 00 00       	push   $0x138
  802be9:	68 cf 3f 80 00       	push   $0x803fcf
  802bee:	e8 de d6 ff ff       	call   8002d1 <_panic>
  802bf3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfc:	89 10                	mov    %edx,(%eax)
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	74 0d                	je     802c14 <insert_sorted_with_merge_freeList+0x71>
  802c07:	a1 38 51 80 00       	mov    0x805138,%eax
  802c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0f:	89 50 04             	mov    %edx,0x4(%eax)
  802c12:	eb 08                	jmp    802c1c <insert_sorted_with_merge_freeList+0x79>
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	a3 38 51 80 00       	mov    %eax,0x805138
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2e:	a1 44 51 80 00       	mov    0x805144,%eax
  802c33:	40                   	inc    %eax
  802c34:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c3d:	0f 84 a8 06 00 00    	je     8032eb <insert_sorted_with_merge_freeList+0x748>
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	8b 50 08             	mov    0x8(%eax),%edx
  802c49:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4f:	01 c2                	add    %eax,%edx
  802c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c54:	8b 40 08             	mov    0x8(%eax),%eax
  802c57:	39 c2                	cmp    %eax,%edx
  802c59:	0f 85 8c 06 00 00    	jne    8032eb <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	8b 50 0c             	mov    0xc(%eax),%edx
  802c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c68:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6b:	01 c2                	add    %eax,%edx
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c77:	75 17                	jne    802c90 <insert_sorted_with_merge_freeList+0xed>
  802c79:	83 ec 04             	sub    $0x4,%esp
  802c7c:	68 78 40 80 00       	push   $0x804078
  802c81:	68 3c 01 00 00       	push   $0x13c
  802c86:	68 cf 3f 80 00       	push   $0x803fcf
  802c8b:	e8 41 d6 ff ff       	call   8002d1 <_panic>
  802c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c93:	8b 00                	mov    (%eax),%eax
  802c95:	85 c0                	test   %eax,%eax
  802c97:	74 10                	je     802ca9 <insert_sorted_with_merge_freeList+0x106>
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca1:	8b 52 04             	mov    0x4(%edx),%edx
  802ca4:	89 50 04             	mov    %edx,0x4(%eax)
  802ca7:	eb 0b                	jmp    802cb4 <insert_sorted_with_merge_freeList+0x111>
  802ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cac:	8b 40 04             	mov    0x4(%eax),%eax
  802caf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb7:	8b 40 04             	mov    0x4(%eax),%eax
  802cba:	85 c0                	test   %eax,%eax
  802cbc:	74 0f                	je     802ccd <insert_sorted_with_merge_freeList+0x12a>
  802cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc1:	8b 40 04             	mov    0x4(%eax),%eax
  802cc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cc7:	8b 12                	mov    (%edx),%edx
  802cc9:	89 10                	mov    %edx,(%eax)
  802ccb:	eb 0a                	jmp    802cd7 <insert_sorted_with_merge_freeList+0x134>
  802ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd0:	8b 00                	mov    (%eax),%eax
  802cd2:	a3 38 51 80 00       	mov    %eax,0x805138
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cea:	a1 44 51 80 00       	mov    0x805144,%eax
  802cef:	48                   	dec    %eax
  802cf0:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0d:	75 17                	jne    802d26 <insert_sorted_with_merge_freeList+0x183>
  802d0f:	83 ec 04             	sub    $0x4,%esp
  802d12:	68 ac 3f 80 00       	push   $0x803fac
  802d17:	68 3f 01 00 00       	push   $0x13f
  802d1c:	68 cf 3f 80 00       	push   $0x803fcf
  802d21:	e8 ab d5 ff ff       	call   8002d1 <_panic>
  802d26:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	89 10                	mov    %edx,(%eax)
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	85 c0                	test   %eax,%eax
  802d38:	74 0d                	je     802d47 <insert_sorted_with_merge_freeList+0x1a4>
  802d3a:	a1 48 51 80 00       	mov    0x805148,%eax
  802d3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d42:	89 50 04             	mov    %edx,0x4(%eax)
  802d45:	eb 08                	jmp    802d4f <insert_sorted_with_merge_freeList+0x1ac>
  802d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d52:	a3 48 51 80 00       	mov    %eax,0x805148
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d61:	a1 54 51 80 00       	mov    0x805154,%eax
  802d66:	40                   	inc    %eax
  802d67:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d6c:	e9 7a 05 00 00       	jmp    8032eb <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	8b 50 08             	mov    0x8(%eax),%edx
  802d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7a:	8b 40 08             	mov    0x8(%eax),%eax
  802d7d:	39 c2                	cmp    %eax,%edx
  802d7f:	0f 82 14 01 00 00    	jb     802e99 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d88:	8b 50 08             	mov    0x8(%eax),%edx
  802d8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d91:	01 c2                	add    %eax,%edx
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	8b 40 08             	mov    0x8(%eax),%eax
  802d99:	39 c2                	cmp    %eax,%edx
  802d9b:	0f 85 90 00 00 00    	jne    802e31 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da4:	8b 50 0c             	mov    0xc(%eax),%edx
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	8b 40 0c             	mov    0xc(%eax),%eax
  802dad:	01 c2                	add    %eax,%edx
  802daf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db2:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dcd:	75 17                	jne    802de6 <insert_sorted_with_merge_freeList+0x243>
  802dcf:	83 ec 04             	sub    $0x4,%esp
  802dd2:	68 ac 3f 80 00       	push   $0x803fac
  802dd7:	68 49 01 00 00       	push   $0x149
  802ddc:	68 cf 3f 80 00       	push   $0x803fcf
  802de1:	e8 eb d4 ff ff       	call   8002d1 <_panic>
  802de6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	89 10                	mov    %edx,(%eax)
  802df1:	8b 45 08             	mov    0x8(%ebp),%eax
  802df4:	8b 00                	mov    (%eax),%eax
  802df6:	85 c0                	test   %eax,%eax
  802df8:	74 0d                	je     802e07 <insert_sorted_with_merge_freeList+0x264>
  802dfa:	a1 48 51 80 00       	mov    0x805148,%eax
  802dff:	8b 55 08             	mov    0x8(%ebp),%edx
  802e02:	89 50 04             	mov    %edx,0x4(%eax)
  802e05:	eb 08                	jmp    802e0f <insert_sorted_with_merge_freeList+0x26c>
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	a3 48 51 80 00       	mov    %eax,0x805148
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e21:	a1 54 51 80 00       	mov    0x805154,%eax
  802e26:	40                   	inc    %eax
  802e27:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e2c:	e9 bb 04 00 00       	jmp    8032ec <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e35:	75 17                	jne    802e4e <insert_sorted_with_merge_freeList+0x2ab>
  802e37:	83 ec 04             	sub    $0x4,%esp
  802e3a:	68 20 40 80 00       	push   $0x804020
  802e3f:	68 4c 01 00 00       	push   $0x14c
  802e44:	68 cf 3f 80 00       	push   $0x803fcf
  802e49:	e8 83 d4 ff ff       	call   8002d1 <_panic>
  802e4e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	89 50 04             	mov    %edx,0x4(%eax)
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	8b 40 04             	mov    0x4(%eax),%eax
  802e60:	85 c0                	test   %eax,%eax
  802e62:	74 0c                	je     802e70 <insert_sorted_with_merge_freeList+0x2cd>
  802e64:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e69:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6c:	89 10                	mov    %edx,(%eax)
  802e6e:	eb 08                	jmp    802e78 <insert_sorted_with_merge_freeList+0x2d5>
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	a3 38 51 80 00       	mov    %eax,0x805138
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e89:	a1 44 51 80 00       	mov    0x805144,%eax
  802e8e:	40                   	inc    %eax
  802e8f:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e94:	e9 53 04 00 00       	jmp    8032ec <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e99:	a1 38 51 80 00       	mov    0x805138,%eax
  802e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea1:	e9 15 04 00 00       	jmp    8032bb <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	8b 50 08             	mov    0x8(%eax),%edx
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	8b 40 08             	mov    0x8(%eax),%eax
  802eba:	39 c2                	cmp    %eax,%edx
  802ebc:	0f 86 f1 03 00 00    	jbe    8032b3 <insert_sorted_with_merge_freeList+0x710>
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 50 08             	mov    0x8(%eax),%edx
  802ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecb:	8b 40 08             	mov    0x8(%eax),%eax
  802ece:	39 c2                	cmp    %eax,%edx
  802ed0:	0f 83 dd 03 00 00    	jae    8032b3 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	8b 50 08             	mov    0x8(%eax),%edx
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee2:	01 c2                	add    %eax,%edx
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	8b 40 08             	mov    0x8(%eax),%eax
  802eea:	39 c2                	cmp    %eax,%edx
  802eec:	0f 85 b9 01 00 00    	jne    8030ab <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	8b 50 08             	mov    0x8(%eax),%edx
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	8b 40 0c             	mov    0xc(%eax),%eax
  802efe:	01 c2                	add    %eax,%edx
  802f00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f03:	8b 40 08             	mov    0x8(%eax),%eax
  802f06:	39 c2                	cmp    %eax,%edx
  802f08:	0f 85 0d 01 00 00    	jne    80301b <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	8b 50 0c             	mov    0xc(%eax),%edx
  802f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f17:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1a:	01 c2                	add    %eax,%edx
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f22:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f26:	75 17                	jne    802f3f <insert_sorted_with_merge_freeList+0x39c>
  802f28:	83 ec 04             	sub    $0x4,%esp
  802f2b:	68 78 40 80 00       	push   $0x804078
  802f30:	68 5c 01 00 00       	push   $0x15c
  802f35:	68 cf 3f 80 00       	push   $0x803fcf
  802f3a:	e8 92 d3 ff ff       	call   8002d1 <_panic>
  802f3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f42:	8b 00                	mov    (%eax),%eax
  802f44:	85 c0                	test   %eax,%eax
  802f46:	74 10                	je     802f58 <insert_sorted_with_merge_freeList+0x3b5>
  802f48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4b:	8b 00                	mov    (%eax),%eax
  802f4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f50:	8b 52 04             	mov    0x4(%edx),%edx
  802f53:	89 50 04             	mov    %edx,0x4(%eax)
  802f56:	eb 0b                	jmp    802f63 <insert_sorted_with_merge_freeList+0x3c0>
  802f58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5b:	8b 40 04             	mov    0x4(%eax),%eax
  802f5e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f66:	8b 40 04             	mov    0x4(%eax),%eax
  802f69:	85 c0                	test   %eax,%eax
  802f6b:	74 0f                	je     802f7c <insert_sorted_with_merge_freeList+0x3d9>
  802f6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f70:	8b 40 04             	mov    0x4(%eax),%eax
  802f73:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f76:	8b 12                	mov    (%edx),%edx
  802f78:	89 10                	mov    %edx,(%eax)
  802f7a:	eb 0a                	jmp    802f86 <insert_sorted_with_merge_freeList+0x3e3>
  802f7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	a3 38 51 80 00       	mov    %eax,0x805138
  802f86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f99:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9e:	48                   	dec    %eax
  802f9f:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  802fa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fb8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fbc:	75 17                	jne    802fd5 <insert_sorted_with_merge_freeList+0x432>
  802fbe:	83 ec 04             	sub    $0x4,%esp
  802fc1:	68 ac 3f 80 00       	push   $0x803fac
  802fc6:	68 5f 01 00 00       	push   $0x15f
  802fcb:	68 cf 3f 80 00       	push   $0x803fcf
  802fd0:	e8 fc d2 ff ff       	call   8002d1 <_panic>
  802fd5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fde:	89 10                	mov    %edx,(%eax)
  802fe0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	85 c0                	test   %eax,%eax
  802fe7:	74 0d                	je     802ff6 <insert_sorted_with_merge_freeList+0x453>
  802fe9:	a1 48 51 80 00       	mov    0x805148,%eax
  802fee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ff1:	89 50 04             	mov    %edx,0x4(%eax)
  802ff4:	eb 08                	jmp    802ffe <insert_sorted_with_merge_freeList+0x45b>
  802ff6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803001:	a3 48 51 80 00       	mov    %eax,0x805148
  803006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803009:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803010:	a1 54 51 80 00       	mov    0x805154,%eax
  803015:	40                   	inc    %eax
  803016:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 50 0c             	mov    0xc(%eax),%edx
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	8b 40 0c             	mov    0xc(%eax),%eax
  803027:	01 c2                	add    %eax,%edx
  803029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803043:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803047:	75 17                	jne    803060 <insert_sorted_with_merge_freeList+0x4bd>
  803049:	83 ec 04             	sub    $0x4,%esp
  80304c:	68 ac 3f 80 00       	push   $0x803fac
  803051:	68 64 01 00 00       	push   $0x164
  803056:	68 cf 3f 80 00       	push   $0x803fcf
  80305b:	e8 71 d2 ff ff       	call   8002d1 <_panic>
  803060:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	89 10                	mov    %edx,(%eax)
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	8b 00                	mov    (%eax),%eax
  803070:	85 c0                	test   %eax,%eax
  803072:	74 0d                	je     803081 <insert_sorted_with_merge_freeList+0x4de>
  803074:	a1 48 51 80 00       	mov    0x805148,%eax
  803079:	8b 55 08             	mov    0x8(%ebp),%edx
  80307c:	89 50 04             	mov    %edx,0x4(%eax)
  80307f:	eb 08                	jmp    803089 <insert_sorted_with_merge_freeList+0x4e6>
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	a3 48 51 80 00       	mov    %eax,0x805148
  803091:	8b 45 08             	mov    0x8(%ebp),%eax
  803094:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309b:	a1 54 51 80 00       	mov    0x805154,%eax
  8030a0:	40                   	inc    %eax
  8030a1:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8030a6:	e9 41 02 00 00       	jmp    8032ec <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	8b 50 08             	mov    0x8(%eax),%edx
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b7:	01 c2                	add    %eax,%edx
  8030b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bc:	8b 40 08             	mov    0x8(%eax),%eax
  8030bf:	39 c2                	cmp    %eax,%edx
  8030c1:	0f 85 7c 01 00 00    	jne    803243 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030cb:	74 06                	je     8030d3 <insert_sorted_with_merge_freeList+0x530>
  8030cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d1:	75 17                	jne    8030ea <insert_sorted_with_merge_freeList+0x547>
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	68 e8 3f 80 00       	push   $0x803fe8
  8030db:	68 69 01 00 00       	push   $0x169
  8030e0:	68 cf 3f 80 00       	push   $0x803fcf
  8030e5:	e8 e7 d1 ff ff       	call   8002d1 <_panic>
  8030ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ed:	8b 50 04             	mov    0x4(%eax),%edx
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	89 50 04             	mov    %edx,0x4(%eax)
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030fc:	89 10                	mov    %edx,(%eax)
  8030fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803101:	8b 40 04             	mov    0x4(%eax),%eax
  803104:	85 c0                	test   %eax,%eax
  803106:	74 0d                	je     803115 <insert_sorted_with_merge_freeList+0x572>
  803108:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310b:	8b 40 04             	mov    0x4(%eax),%eax
  80310e:	8b 55 08             	mov    0x8(%ebp),%edx
  803111:	89 10                	mov    %edx,(%eax)
  803113:	eb 08                	jmp    80311d <insert_sorted_with_merge_freeList+0x57a>
  803115:	8b 45 08             	mov    0x8(%ebp),%eax
  803118:	a3 38 51 80 00       	mov    %eax,0x805138
  80311d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803120:	8b 55 08             	mov    0x8(%ebp),%edx
  803123:	89 50 04             	mov    %edx,0x4(%eax)
  803126:	a1 44 51 80 00       	mov    0x805144,%eax
  80312b:	40                   	inc    %eax
  80312c:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	8b 50 0c             	mov    0xc(%eax),%edx
  803137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313a:	8b 40 0c             	mov    0xc(%eax),%eax
  80313d:	01 c2                	add    %eax,%edx
  80313f:	8b 45 08             	mov    0x8(%ebp),%eax
  803142:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803145:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803149:	75 17                	jne    803162 <insert_sorted_with_merge_freeList+0x5bf>
  80314b:	83 ec 04             	sub    $0x4,%esp
  80314e:	68 78 40 80 00       	push   $0x804078
  803153:	68 6b 01 00 00       	push   $0x16b
  803158:	68 cf 3f 80 00       	push   $0x803fcf
  80315d:	e8 6f d1 ff ff       	call   8002d1 <_panic>
  803162:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803165:	8b 00                	mov    (%eax),%eax
  803167:	85 c0                	test   %eax,%eax
  803169:	74 10                	je     80317b <insert_sorted_with_merge_freeList+0x5d8>
  80316b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316e:	8b 00                	mov    (%eax),%eax
  803170:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803173:	8b 52 04             	mov    0x4(%edx),%edx
  803176:	89 50 04             	mov    %edx,0x4(%eax)
  803179:	eb 0b                	jmp    803186 <insert_sorted_with_merge_freeList+0x5e3>
  80317b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317e:	8b 40 04             	mov    0x4(%eax),%eax
  803181:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803186:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803189:	8b 40 04             	mov    0x4(%eax),%eax
  80318c:	85 c0                	test   %eax,%eax
  80318e:	74 0f                	je     80319f <insert_sorted_with_merge_freeList+0x5fc>
  803190:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803193:	8b 40 04             	mov    0x4(%eax),%eax
  803196:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803199:	8b 12                	mov    (%edx),%edx
  80319b:	89 10                	mov    %edx,(%eax)
  80319d:	eb 0a                	jmp    8031a9 <insert_sorted_with_merge_freeList+0x606>
  80319f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a2:	8b 00                	mov    (%eax),%eax
  8031a4:	a3 38 51 80 00       	mov    %eax,0x805138
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031bc:	a1 44 51 80 00       	mov    0x805144,%eax
  8031c1:	48                   	dec    %eax
  8031c2:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8031c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031df:	75 17                	jne    8031f8 <insert_sorted_with_merge_freeList+0x655>
  8031e1:	83 ec 04             	sub    $0x4,%esp
  8031e4:	68 ac 3f 80 00       	push   $0x803fac
  8031e9:	68 6e 01 00 00       	push   $0x16e
  8031ee:	68 cf 3f 80 00       	push   $0x803fcf
  8031f3:	e8 d9 d0 ff ff       	call   8002d1 <_panic>
  8031f8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803201:	89 10                	mov    %edx,(%eax)
  803203:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	85 c0                	test   %eax,%eax
  80320a:	74 0d                	je     803219 <insert_sorted_with_merge_freeList+0x676>
  80320c:	a1 48 51 80 00       	mov    0x805148,%eax
  803211:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803214:	89 50 04             	mov    %edx,0x4(%eax)
  803217:	eb 08                	jmp    803221 <insert_sorted_with_merge_freeList+0x67e>
  803219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803224:	a3 48 51 80 00       	mov    %eax,0x805148
  803229:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803233:	a1 54 51 80 00       	mov    0x805154,%eax
  803238:	40                   	inc    %eax
  803239:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80323e:	e9 a9 00 00 00       	jmp    8032ec <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803243:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803247:	74 06                	je     80324f <insert_sorted_with_merge_freeList+0x6ac>
  803249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80324d:	75 17                	jne    803266 <insert_sorted_with_merge_freeList+0x6c3>
  80324f:	83 ec 04             	sub    $0x4,%esp
  803252:	68 44 40 80 00       	push   $0x804044
  803257:	68 73 01 00 00       	push   $0x173
  80325c:	68 cf 3f 80 00       	push   $0x803fcf
  803261:	e8 6b d0 ff ff       	call   8002d1 <_panic>
  803266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803269:	8b 10                	mov    (%eax),%edx
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	89 10                	mov    %edx,(%eax)
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	85 c0                	test   %eax,%eax
  803277:	74 0b                	je     803284 <insert_sorted_with_merge_freeList+0x6e1>
  803279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	8b 55 08             	mov    0x8(%ebp),%edx
  803281:	89 50 04             	mov    %edx,0x4(%eax)
  803284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803287:	8b 55 08             	mov    0x8(%ebp),%edx
  80328a:	89 10                	mov    %edx,(%eax)
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803292:	89 50 04             	mov    %edx,0x4(%eax)
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	8b 00                	mov    (%eax),%eax
  80329a:	85 c0                	test   %eax,%eax
  80329c:	75 08                	jne    8032a6 <insert_sorted_with_merge_freeList+0x703>
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a6:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ab:	40                   	inc    %eax
  8032ac:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8032b1:	eb 39                	jmp    8032ec <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8032b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032bf:	74 07                	je     8032c8 <insert_sorted_with_merge_freeList+0x725>
  8032c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c4:	8b 00                	mov    (%eax),%eax
  8032c6:	eb 05                	jmp    8032cd <insert_sorted_with_merge_freeList+0x72a>
  8032c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8032cd:	a3 40 51 80 00       	mov    %eax,0x805140
  8032d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8032d7:	85 c0                	test   %eax,%eax
  8032d9:	0f 85 c7 fb ff ff    	jne    802ea6 <insert_sorted_with_merge_freeList+0x303>
  8032df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e3:	0f 85 bd fb ff ff    	jne    802ea6 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032e9:	eb 01                	jmp    8032ec <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032eb:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032ec:	90                   	nop
  8032ed:	c9                   	leave  
  8032ee:	c3                   	ret    

008032ef <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032ef:	55                   	push   %ebp
  8032f0:	89 e5                	mov    %esp,%ebp
  8032f2:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f8:	89 d0                	mov    %edx,%eax
  8032fa:	c1 e0 02             	shl    $0x2,%eax
  8032fd:	01 d0                	add    %edx,%eax
  8032ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803306:	01 d0                	add    %edx,%eax
  803308:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80330f:	01 d0                	add    %edx,%eax
  803311:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803318:	01 d0                	add    %edx,%eax
  80331a:	c1 e0 04             	shl    $0x4,%eax
  80331d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803320:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803327:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80332a:	83 ec 0c             	sub    $0xc,%esp
  80332d:	50                   	push   %eax
  80332e:	e8 26 e7 ff ff       	call   801a59 <sys_get_virtual_time>
  803333:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803336:	eb 41                	jmp    803379 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803338:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80333b:	83 ec 0c             	sub    $0xc,%esp
  80333e:	50                   	push   %eax
  80333f:	e8 15 e7 ff ff       	call   801a59 <sys_get_virtual_time>
  803344:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803347:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80334a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334d:	29 c2                	sub    %eax,%edx
  80334f:	89 d0                	mov    %edx,%eax
  803351:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803354:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803357:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335a:	89 d1                	mov    %edx,%ecx
  80335c:	29 c1                	sub    %eax,%ecx
  80335e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803361:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803364:	39 c2                	cmp    %eax,%edx
  803366:	0f 97 c0             	seta   %al
  803369:	0f b6 c0             	movzbl %al,%eax
  80336c:	29 c1                	sub    %eax,%ecx
  80336e:	89 c8                	mov    %ecx,%eax
  803370:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803373:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803376:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80337f:	72 b7                	jb     803338 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803381:	90                   	nop
  803382:	c9                   	leave  
  803383:	c3                   	ret    

00803384 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803384:	55                   	push   %ebp
  803385:	89 e5                	mov    %esp,%ebp
  803387:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80338a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803391:	eb 03                	jmp    803396 <busy_wait+0x12>
  803393:	ff 45 fc             	incl   -0x4(%ebp)
  803396:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803399:	3b 45 08             	cmp    0x8(%ebp),%eax
  80339c:	72 f5                	jb     803393 <busy_wait+0xf>
	return i;
  80339e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033a1:	c9                   	leave  
  8033a2:	c3                   	ret    
  8033a3:	90                   	nop

008033a4 <__udivdi3>:
  8033a4:	55                   	push   %ebp
  8033a5:	57                   	push   %edi
  8033a6:	56                   	push   %esi
  8033a7:	53                   	push   %ebx
  8033a8:	83 ec 1c             	sub    $0x1c,%esp
  8033ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033bb:	89 ca                	mov    %ecx,%edx
  8033bd:	89 f8                	mov    %edi,%eax
  8033bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033c3:	85 f6                	test   %esi,%esi
  8033c5:	75 2d                	jne    8033f4 <__udivdi3+0x50>
  8033c7:	39 cf                	cmp    %ecx,%edi
  8033c9:	77 65                	ja     803430 <__udivdi3+0x8c>
  8033cb:	89 fd                	mov    %edi,%ebp
  8033cd:	85 ff                	test   %edi,%edi
  8033cf:	75 0b                	jne    8033dc <__udivdi3+0x38>
  8033d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8033d6:	31 d2                	xor    %edx,%edx
  8033d8:	f7 f7                	div    %edi
  8033da:	89 c5                	mov    %eax,%ebp
  8033dc:	31 d2                	xor    %edx,%edx
  8033de:	89 c8                	mov    %ecx,%eax
  8033e0:	f7 f5                	div    %ebp
  8033e2:	89 c1                	mov    %eax,%ecx
  8033e4:	89 d8                	mov    %ebx,%eax
  8033e6:	f7 f5                	div    %ebp
  8033e8:	89 cf                	mov    %ecx,%edi
  8033ea:	89 fa                	mov    %edi,%edx
  8033ec:	83 c4 1c             	add    $0x1c,%esp
  8033ef:	5b                   	pop    %ebx
  8033f0:	5e                   	pop    %esi
  8033f1:	5f                   	pop    %edi
  8033f2:	5d                   	pop    %ebp
  8033f3:	c3                   	ret    
  8033f4:	39 ce                	cmp    %ecx,%esi
  8033f6:	77 28                	ja     803420 <__udivdi3+0x7c>
  8033f8:	0f bd fe             	bsr    %esi,%edi
  8033fb:	83 f7 1f             	xor    $0x1f,%edi
  8033fe:	75 40                	jne    803440 <__udivdi3+0x9c>
  803400:	39 ce                	cmp    %ecx,%esi
  803402:	72 0a                	jb     80340e <__udivdi3+0x6a>
  803404:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803408:	0f 87 9e 00 00 00    	ja     8034ac <__udivdi3+0x108>
  80340e:	b8 01 00 00 00       	mov    $0x1,%eax
  803413:	89 fa                	mov    %edi,%edx
  803415:	83 c4 1c             	add    $0x1c,%esp
  803418:	5b                   	pop    %ebx
  803419:	5e                   	pop    %esi
  80341a:	5f                   	pop    %edi
  80341b:	5d                   	pop    %ebp
  80341c:	c3                   	ret    
  80341d:	8d 76 00             	lea    0x0(%esi),%esi
  803420:	31 ff                	xor    %edi,%edi
  803422:	31 c0                	xor    %eax,%eax
  803424:	89 fa                	mov    %edi,%edx
  803426:	83 c4 1c             	add    $0x1c,%esp
  803429:	5b                   	pop    %ebx
  80342a:	5e                   	pop    %esi
  80342b:	5f                   	pop    %edi
  80342c:	5d                   	pop    %ebp
  80342d:	c3                   	ret    
  80342e:	66 90                	xchg   %ax,%ax
  803430:	89 d8                	mov    %ebx,%eax
  803432:	f7 f7                	div    %edi
  803434:	31 ff                	xor    %edi,%edi
  803436:	89 fa                	mov    %edi,%edx
  803438:	83 c4 1c             	add    $0x1c,%esp
  80343b:	5b                   	pop    %ebx
  80343c:	5e                   	pop    %esi
  80343d:	5f                   	pop    %edi
  80343e:	5d                   	pop    %ebp
  80343f:	c3                   	ret    
  803440:	bd 20 00 00 00       	mov    $0x20,%ebp
  803445:	89 eb                	mov    %ebp,%ebx
  803447:	29 fb                	sub    %edi,%ebx
  803449:	89 f9                	mov    %edi,%ecx
  80344b:	d3 e6                	shl    %cl,%esi
  80344d:	89 c5                	mov    %eax,%ebp
  80344f:	88 d9                	mov    %bl,%cl
  803451:	d3 ed                	shr    %cl,%ebp
  803453:	89 e9                	mov    %ebp,%ecx
  803455:	09 f1                	or     %esi,%ecx
  803457:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80345b:	89 f9                	mov    %edi,%ecx
  80345d:	d3 e0                	shl    %cl,%eax
  80345f:	89 c5                	mov    %eax,%ebp
  803461:	89 d6                	mov    %edx,%esi
  803463:	88 d9                	mov    %bl,%cl
  803465:	d3 ee                	shr    %cl,%esi
  803467:	89 f9                	mov    %edi,%ecx
  803469:	d3 e2                	shl    %cl,%edx
  80346b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80346f:	88 d9                	mov    %bl,%cl
  803471:	d3 e8                	shr    %cl,%eax
  803473:	09 c2                	or     %eax,%edx
  803475:	89 d0                	mov    %edx,%eax
  803477:	89 f2                	mov    %esi,%edx
  803479:	f7 74 24 0c          	divl   0xc(%esp)
  80347d:	89 d6                	mov    %edx,%esi
  80347f:	89 c3                	mov    %eax,%ebx
  803481:	f7 e5                	mul    %ebp
  803483:	39 d6                	cmp    %edx,%esi
  803485:	72 19                	jb     8034a0 <__udivdi3+0xfc>
  803487:	74 0b                	je     803494 <__udivdi3+0xf0>
  803489:	89 d8                	mov    %ebx,%eax
  80348b:	31 ff                	xor    %edi,%edi
  80348d:	e9 58 ff ff ff       	jmp    8033ea <__udivdi3+0x46>
  803492:	66 90                	xchg   %ax,%ax
  803494:	8b 54 24 08          	mov    0x8(%esp),%edx
  803498:	89 f9                	mov    %edi,%ecx
  80349a:	d3 e2                	shl    %cl,%edx
  80349c:	39 c2                	cmp    %eax,%edx
  80349e:	73 e9                	jae    803489 <__udivdi3+0xe5>
  8034a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034a3:	31 ff                	xor    %edi,%edi
  8034a5:	e9 40 ff ff ff       	jmp    8033ea <__udivdi3+0x46>
  8034aa:	66 90                	xchg   %ax,%ax
  8034ac:	31 c0                	xor    %eax,%eax
  8034ae:	e9 37 ff ff ff       	jmp    8033ea <__udivdi3+0x46>
  8034b3:	90                   	nop

008034b4 <__umoddi3>:
  8034b4:	55                   	push   %ebp
  8034b5:	57                   	push   %edi
  8034b6:	56                   	push   %esi
  8034b7:	53                   	push   %ebx
  8034b8:	83 ec 1c             	sub    $0x1c,%esp
  8034bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034d3:	89 f3                	mov    %esi,%ebx
  8034d5:	89 fa                	mov    %edi,%edx
  8034d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034db:	89 34 24             	mov    %esi,(%esp)
  8034de:	85 c0                	test   %eax,%eax
  8034e0:	75 1a                	jne    8034fc <__umoddi3+0x48>
  8034e2:	39 f7                	cmp    %esi,%edi
  8034e4:	0f 86 a2 00 00 00    	jbe    80358c <__umoddi3+0xd8>
  8034ea:	89 c8                	mov    %ecx,%eax
  8034ec:	89 f2                	mov    %esi,%edx
  8034ee:	f7 f7                	div    %edi
  8034f0:	89 d0                	mov    %edx,%eax
  8034f2:	31 d2                	xor    %edx,%edx
  8034f4:	83 c4 1c             	add    $0x1c,%esp
  8034f7:	5b                   	pop    %ebx
  8034f8:	5e                   	pop    %esi
  8034f9:	5f                   	pop    %edi
  8034fa:	5d                   	pop    %ebp
  8034fb:	c3                   	ret    
  8034fc:	39 f0                	cmp    %esi,%eax
  8034fe:	0f 87 ac 00 00 00    	ja     8035b0 <__umoddi3+0xfc>
  803504:	0f bd e8             	bsr    %eax,%ebp
  803507:	83 f5 1f             	xor    $0x1f,%ebp
  80350a:	0f 84 ac 00 00 00    	je     8035bc <__umoddi3+0x108>
  803510:	bf 20 00 00 00       	mov    $0x20,%edi
  803515:	29 ef                	sub    %ebp,%edi
  803517:	89 fe                	mov    %edi,%esi
  803519:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80351d:	89 e9                	mov    %ebp,%ecx
  80351f:	d3 e0                	shl    %cl,%eax
  803521:	89 d7                	mov    %edx,%edi
  803523:	89 f1                	mov    %esi,%ecx
  803525:	d3 ef                	shr    %cl,%edi
  803527:	09 c7                	or     %eax,%edi
  803529:	89 e9                	mov    %ebp,%ecx
  80352b:	d3 e2                	shl    %cl,%edx
  80352d:	89 14 24             	mov    %edx,(%esp)
  803530:	89 d8                	mov    %ebx,%eax
  803532:	d3 e0                	shl    %cl,%eax
  803534:	89 c2                	mov    %eax,%edx
  803536:	8b 44 24 08          	mov    0x8(%esp),%eax
  80353a:	d3 e0                	shl    %cl,%eax
  80353c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803540:	8b 44 24 08          	mov    0x8(%esp),%eax
  803544:	89 f1                	mov    %esi,%ecx
  803546:	d3 e8                	shr    %cl,%eax
  803548:	09 d0                	or     %edx,%eax
  80354a:	d3 eb                	shr    %cl,%ebx
  80354c:	89 da                	mov    %ebx,%edx
  80354e:	f7 f7                	div    %edi
  803550:	89 d3                	mov    %edx,%ebx
  803552:	f7 24 24             	mull   (%esp)
  803555:	89 c6                	mov    %eax,%esi
  803557:	89 d1                	mov    %edx,%ecx
  803559:	39 d3                	cmp    %edx,%ebx
  80355b:	0f 82 87 00 00 00    	jb     8035e8 <__umoddi3+0x134>
  803561:	0f 84 91 00 00 00    	je     8035f8 <__umoddi3+0x144>
  803567:	8b 54 24 04          	mov    0x4(%esp),%edx
  80356b:	29 f2                	sub    %esi,%edx
  80356d:	19 cb                	sbb    %ecx,%ebx
  80356f:	89 d8                	mov    %ebx,%eax
  803571:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803575:	d3 e0                	shl    %cl,%eax
  803577:	89 e9                	mov    %ebp,%ecx
  803579:	d3 ea                	shr    %cl,%edx
  80357b:	09 d0                	or     %edx,%eax
  80357d:	89 e9                	mov    %ebp,%ecx
  80357f:	d3 eb                	shr    %cl,%ebx
  803581:	89 da                	mov    %ebx,%edx
  803583:	83 c4 1c             	add    $0x1c,%esp
  803586:	5b                   	pop    %ebx
  803587:	5e                   	pop    %esi
  803588:	5f                   	pop    %edi
  803589:	5d                   	pop    %ebp
  80358a:	c3                   	ret    
  80358b:	90                   	nop
  80358c:	89 fd                	mov    %edi,%ebp
  80358e:	85 ff                	test   %edi,%edi
  803590:	75 0b                	jne    80359d <__umoddi3+0xe9>
  803592:	b8 01 00 00 00       	mov    $0x1,%eax
  803597:	31 d2                	xor    %edx,%edx
  803599:	f7 f7                	div    %edi
  80359b:	89 c5                	mov    %eax,%ebp
  80359d:	89 f0                	mov    %esi,%eax
  80359f:	31 d2                	xor    %edx,%edx
  8035a1:	f7 f5                	div    %ebp
  8035a3:	89 c8                	mov    %ecx,%eax
  8035a5:	f7 f5                	div    %ebp
  8035a7:	89 d0                	mov    %edx,%eax
  8035a9:	e9 44 ff ff ff       	jmp    8034f2 <__umoddi3+0x3e>
  8035ae:	66 90                	xchg   %ax,%ax
  8035b0:	89 c8                	mov    %ecx,%eax
  8035b2:	89 f2                	mov    %esi,%edx
  8035b4:	83 c4 1c             	add    $0x1c,%esp
  8035b7:	5b                   	pop    %ebx
  8035b8:	5e                   	pop    %esi
  8035b9:	5f                   	pop    %edi
  8035ba:	5d                   	pop    %ebp
  8035bb:	c3                   	ret    
  8035bc:	3b 04 24             	cmp    (%esp),%eax
  8035bf:	72 06                	jb     8035c7 <__umoddi3+0x113>
  8035c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035c5:	77 0f                	ja     8035d6 <__umoddi3+0x122>
  8035c7:	89 f2                	mov    %esi,%edx
  8035c9:	29 f9                	sub    %edi,%ecx
  8035cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035cf:	89 14 24             	mov    %edx,(%esp)
  8035d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035da:	8b 14 24             	mov    (%esp),%edx
  8035dd:	83 c4 1c             	add    $0x1c,%esp
  8035e0:	5b                   	pop    %ebx
  8035e1:	5e                   	pop    %esi
  8035e2:	5f                   	pop    %edi
  8035e3:	5d                   	pop    %ebp
  8035e4:	c3                   	ret    
  8035e5:	8d 76 00             	lea    0x0(%esi),%esi
  8035e8:	2b 04 24             	sub    (%esp),%eax
  8035eb:	19 fa                	sbb    %edi,%edx
  8035ed:	89 d1                	mov    %edx,%ecx
  8035ef:	89 c6                	mov    %eax,%esi
  8035f1:	e9 71 ff ff ff       	jmp    803567 <__umoddi3+0xb3>
  8035f6:	66 90                	xchg   %ax,%ax
  8035f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035fc:	72 ea                	jb     8035e8 <__umoddi3+0x134>
  8035fe:	89 d9                	mov    %ebx,%ecx
  803600:	e9 62 ff ff ff       	jmp    803567 <__umoddi3+0xb3>
