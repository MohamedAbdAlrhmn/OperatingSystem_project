
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 0d 01 00 00       	call   800143 <libmain>
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
	// Testing scenario 4: Freeing the allocated semaphores
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 35 80 00       	push   $0x8035c0
  80004a:	e8 01 15 00 00       	call   801550 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 2d 17 00 00       	call   801790 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 c5 17 00 00       	call   801830 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 35 80 00       	push   $0x8035d0
  800079:	e8 b5 04 00 00       	call   800533 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	6a 64                	push   $0x64
  800091:	68 03 36 80 00       	push   $0x803603
  800096:	e8 67 19 00 00       	call   801a02 <sys_create_env>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a7:	e8 74 19 00 00       	call   801a20 <sys_run_env>
  8000ac:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000af:	90                   	nop
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	83 f8 01             	cmp    $0x1,%eax
  8000b8:	75 f6                	jne    8000b0 <_main+0x78>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ba:	e8 d1 16 00 00       	call   801790 <sys_calculate_free_frames>
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 0c 36 80 00       	push   $0x80360c
  8000c8:	e8 66 04 00 00       	call   800533 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d6:	e8 61 19 00 00       	call   801a3c <sys_destroy_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000de:	e8 ad 16 00 00       	call   801790 <sys_calculate_free_frames>
  8000e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e6:	e8 45 17 00 00       	call   801830 <sys_pf_calculate_allocated_pages>
  8000eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f4:	74 27                	je     80011d <_main+0xe5>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fc:	68 40 36 80 00       	push   $0x803640
  800101:	e8 2d 04 00 00       	call   800533 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 90 36 80 00       	push   $0x803690
  800111:	6a 1f                	push   $0x1f
  800113:	68 c6 36 80 00       	push   $0x8036c6
  800118:	e8 62 01 00 00       	call   80027f <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 e4             	pushl  -0x1c(%ebp)
  800123:	68 dc 36 80 00       	push   $0x8036dc
  800128:	e8 06 04 00 00       	call   800533 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 3c 37 80 00       	push   $0x80373c
  800138:	e8 f6 03 00 00       	call   800533 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
	return;
  800140:	90                   	nop
}
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800149:	e8 22 19 00 00       	call   801a70 <sys_getenvindex>
  80014e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800154:	89 d0                	mov    %edx,%eax
  800156:	c1 e0 03             	shl    $0x3,%eax
  800159:	01 d0                	add    %edx,%eax
  80015b:	01 c0                	add    %eax,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800166:	01 d0                	add    %edx,%eax
  800168:	c1 e0 04             	shl    $0x4,%eax
  80016b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800170:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800175:	a1 20 40 80 00       	mov    0x804020,%eax
  80017a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0f                	je     800193 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	05 5c 05 00 00       	add    $0x55c,%eax
  80018e:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800197:	7e 0a                	jle    8001a3 <libmain+0x60>
		binaryname = argv[0];
  800199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019c:	8b 00                	mov    (%eax),%eax
  80019e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	ff 75 0c             	pushl  0xc(%ebp)
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	e8 87 fe ff ff       	call   800038 <_main>
  8001b1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b4:	e8 c4 16 00 00       	call   80187d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 a0 37 80 00       	push   $0x8037a0
  8001c1:	e8 6d 03 00 00       	call   800533 <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d9:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001df:	83 ec 04             	sub    $0x4,%esp
  8001e2:	52                   	push   %edx
  8001e3:	50                   	push   %eax
  8001e4:	68 c8 37 80 00       	push   $0x8037c8
  8001e9:	e8 45 03 00 00       	call   800533 <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800212:	51                   	push   %ecx
  800213:	52                   	push   %edx
  800214:	50                   	push   %eax
  800215:	68 f0 37 80 00       	push   $0x8037f0
  80021a:	e8 14 03 00 00       	call   800533 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800222:	a1 20 40 80 00       	mov    0x804020,%eax
  800227:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	50                   	push   %eax
  800231:	68 48 38 80 00       	push   $0x803848
  800236:	e8 f8 02 00 00       	call   800533 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 a0 37 80 00       	push   $0x8037a0
  800246:	e8 e8 02 00 00       	call   800533 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024e:	e8 44 16 00 00       	call   801897 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800253:	e8 19 00 00 00       	call   800271 <exit>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	6a 00                	push   $0x0
  800266:	e8 d1 17 00 00       	call   801a3c <sys_destroy_env>
  80026b:	83 c4 10             	add    $0x10,%esp
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <exit>:

void
exit(void)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800277:	e8 26 18 00 00       	call   801aa2 <sys_exit_env>
}
  80027c:	90                   	nop
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800285:	8d 45 10             	lea    0x10(%ebp),%eax
  800288:	83 c0 04             	add    $0x4,%eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800293:	85 c0                	test   %eax,%eax
  800295:	74 16                	je     8002ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  800297:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	50                   	push   %eax
  8002a0:	68 5c 38 80 00       	push   $0x80385c
  8002a5:	e8 89 02 00 00       	call   800533 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ad:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	68 61 38 80 00       	push   $0x803861
  8002be:	e8 70 02 00 00       	call   800533 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cf:	50                   	push   %eax
  8002d0:	e8 f3 01 00 00       	call   8004c8 <vcprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	6a 00                	push   $0x0
  8002dd:	68 7d 38 80 00       	push   $0x80387d
  8002e2:	e8 e1 01 00 00       	call   8004c8 <vcprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ea:	e8 82 ff ff ff       	call   800271 <exit>

	// should not return here
	while (1) ;
  8002ef:	eb fe                	jmp    8002ef <_panic+0x70>

008002f1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fc:	8b 50 74             	mov    0x74(%eax),%edx
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	74 14                	je     80031a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	68 80 38 80 00       	push   $0x803880
  80030e:	6a 26                	push   $0x26
  800310:	68 cc 38 80 00       	push   $0x8038cc
  800315:	e8 65 ff ff ff       	call   80027f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	e9 c2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800330:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	01 d0                	add    %edx,%eax
  80033c:	8b 00                	mov    (%eax),%eax
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 08                	jne    80034a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800342:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800345:	e9 a2 00 00 00       	jmp    8003ec <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800351:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800358:	eb 69                	jmp    8003c3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035a:	a1 20 40 80 00       	mov    0x804020,%eax
  80035f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800365:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800368:	89 d0                	mov    %edx,%eax
  80036a:	01 c0                	add    %eax,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	c1 e0 03             	shl    $0x3,%eax
  800371:	01 c8                	add    %ecx,%eax
  800373:	8a 40 04             	mov    0x4(%eax),%al
  800376:	84 c0                	test   %al,%al
  800378:	75 46                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037a:	a1 20 40 80 00       	mov    0x804020,%eax
  80037f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800385:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800388:	89 d0                	mov    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	c1 e0 03             	shl    $0x3,%eax
  800391:	01 c8                	add    %ecx,%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800398:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	75 09                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003be:	eb 12                	jmp    8003d2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c0:	ff 45 e8             	incl   -0x18(%ebp)
  8003c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c8:	8b 50 74             	mov    0x74(%eax),%edx
  8003cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ce:	39 c2                	cmp    %eax,%edx
  8003d0:	77 88                	ja     80035a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d6:	75 14                	jne    8003ec <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d8:	83 ec 04             	sub    $0x4,%esp
  8003db:	68 d8 38 80 00       	push   $0x8038d8
  8003e0:	6a 3a                	push   $0x3a
  8003e2:	68 cc 38 80 00       	push   $0x8038cc
  8003e7:	e8 93 fe ff ff       	call   80027f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ec:	ff 45 f0             	incl   -0x10(%ebp)
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f5:	0f 8c 32 ff ff ff    	jl     80032d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800402:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800409:	eb 26                	jmp    800431 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040b:	a1 20 40 80 00       	mov    0x804020,%eax
  800410:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800416:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800419:	89 d0                	mov    %edx,%eax
  80041b:	01 c0                	add    %eax,%eax
  80041d:	01 d0                	add    %edx,%eax
  80041f:	c1 e0 03             	shl    $0x3,%eax
  800422:	01 c8                	add    %ecx,%eax
  800424:	8a 40 04             	mov    0x4(%eax),%al
  800427:	3c 01                	cmp    $0x1,%al
  800429:	75 03                	jne    80042e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042e:	ff 45 e0             	incl   -0x20(%ebp)
  800431:	a1 20 40 80 00       	mov    0x804020,%eax
  800436:	8b 50 74             	mov    0x74(%eax),%edx
  800439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043c:	39 c2                	cmp    %eax,%edx
  80043e:	77 cb                	ja     80040b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800443:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800446:	74 14                	je     80045c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	68 2c 39 80 00       	push   $0x80392c
  800450:	6a 44                	push   $0x44
  800452:	68 cc 38 80 00       	push   $0x8038cc
  800457:	e8 23 fe ff ff       	call   80027f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045c:	90                   	nop
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 48 01             	lea    0x1(%eax),%ecx
  80046d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800470:	89 0a                	mov    %ecx,(%edx)
  800472:	8b 55 08             	mov    0x8(%ebp),%edx
  800475:	88 d1                	mov    %dl,%cl
  800477:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80047e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	3d ff 00 00 00       	cmp    $0xff,%eax
  800488:	75 2c                	jne    8004b6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048a:	a0 24 40 80 00       	mov    0x804024,%al
  80048f:	0f b6 c0             	movzbl %al,%eax
  800492:	8b 55 0c             	mov    0xc(%ebp),%edx
  800495:	8b 12                	mov    (%edx),%edx
  800497:	89 d1                	mov    %edx,%ecx
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	83 c2 08             	add    $0x8,%edx
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	50                   	push   %eax
  8004a3:	51                   	push   %ecx
  8004a4:	52                   	push   %edx
  8004a5:	e8 25 12 00 00       	call   8016cf <sys_cputs>
  8004aa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b9:	8b 40 04             	mov    0x4(%eax),%eax
  8004bc:	8d 50 01             	lea    0x1(%eax),%edx
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d8:	00 00 00 
	b.cnt = 0;
  8004db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e5:	ff 75 0c             	pushl  0xc(%ebp)
  8004e8:	ff 75 08             	pushl  0x8(%ebp)
  8004eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f1:	50                   	push   %eax
  8004f2:	68 5f 04 80 00       	push   $0x80045f
  8004f7:	e8 11 02 00 00       	call   80070d <vprintfmt>
  8004fc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004ff:	a0 24 40 80 00       	mov    0x804024,%al
  800504:	0f b6 c0             	movzbl %al,%eax
  800507:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	50                   	push   %eax
  800511:	52                   	push   %edx
  800512:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800518:	83 c0 08             	add    $0x8,%eax
  80051b:	50                   	push   %eax
  80051c:	e8 ae 11 00 00       	call   8016cf <sys_cputs>
  800521:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800524:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <cprintf>:

int cprintf(const char *fmt, ...) {
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800539:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800540:	8d 45 0c             	lea    0xc(%ebp),%eax
  800543:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	ff 75 f4             	pushl  -0xc(%ebp)
  80054f:	50                   	push   %eax
  800550:	e8 73 ff ff ff       	call   8004c8 <vcprintf>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800566:	e8 12 13 00 00       	call   80187d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 48 ff ff ff       	call   8004c8 <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800586:	e8 0c 13 00 00       	call   801897 <sys_enable_interrupt>
	return cnt;
  80058b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	53                   	push   %ebx
  800594:	83 ec 14             	sub    $0x14,%esp
  800597:	8b 45 10             	mov    0x10(%ebp),%eax
  80059a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ae:	77 55                	ja     800605 <printnum+0x75>
  8005b0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b3:	72 05                	jb     8005ba <printnum+0x2a>
  8005b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b8:	77 4b                	ja     800605 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ba:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c8:	52                   	push   %edx
  8005c9:	50                   	push   %eax
  8005ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d0:	e8 7f 2d 00 00       	call   803354 <__udivdi3>
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	83 ec 04             	sub    $0x4,%esp
  8005db:	ff 75 20             	pushl  0x20(%ebp)
  8005de:	53                   	push   %ebx
  8005df:	ff 75 18             	pushl  0x18(%ebp)
  8005e2:	52                   	push   %edx
  8005e3:	50                   	push   %eax
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	e8 a1 ff ff ff       	call   800590 <printnum>
  8005ef:	83 c4 20             	add    $0x20,%esp
  8005f2:	eb 1a                	jmp    80060e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	ff 75 0c             	pushl  0xc(%ebp)
  8005fa:	ff 75 20             	pushl  0x20(%ebp)
  8005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800600:	ff d0                	call   *%eax
  800602:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800605:	ff 4d 1c             	decl   0x1c(%ebp)
  800608:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060c:	7f e6                	jg     8005f4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800611:	bb 00 00 00 00       	mov    $0x0,%ebx
  800616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061c:	53                   	push   %ebx
  80061d:	51                   	push   %ecx
  80061e:	52                   	push   %edx
  80061f:	50                   	push   %eax
  800620:	e8 3f 2e 00 00       	call   803464 <__umoddi3>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	05 94 3b 80 00       	add    $0x803b94,%eax
  80062d:	8a 00                	mov    (%eax),%al
  80062f:	0f be c0             	movsbl %al,%eax
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	50                   	push   %eax
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	ff d0                	call   *%eax
  80063e:	83 c4 10             	add    $0x10,%esp
}
  800641:	90                   	nop
  800642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064e:	7e 1c                	jle    80066c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	8d 50 08             	lea    0x8(%eax),%edx
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	89 10                	mov    %edx,(%eax)
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	83 e8 08             	sub    $0x8,%eax
  800665:	8b 50 04             	mov    0x4(%eax),%edx
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	eb 40                	jmp    8006ac <getuint+0x65>
	else if (lflag)
  80066c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800670:	74 1e                	je     800690 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 04             	lea    0x4(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 04             	sub    $0x4,%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	eb 1c                	jmp    8006ac <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	8d 50 04             	lea    0x4(%eax),%edx
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	89 10                	mov    %edx,(%eax)
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	83 e8 04             	sub    $0x4,%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ac:	5d                   	pop    %ebp
  8006ad:	c3                   	ret    

008006ae <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b5:	7e 1c                	jle    8006d3 <getint+0x25>
		return va_arg(*ap, long long);
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	8d 50 08             	lea    0x8(%eax),%edx
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	89 10                	mov    %edx,(%eax)
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	83 e8 08             	sub    $0x8,%eax
  8006cc:	8b 50 04             	mov    0x4(%eax),%edx
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	eb 38                	jmp    80070b <getint+0x5d>
	else if (lflag)
  8006d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d7:	74 1a                	je     8006f3 <getint+0x45>
		return va_arg(*ap, long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 04             	lea    0x4(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 04             	sub    $0x4,%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	99                   	cltd   
  8006f1:	eb 18                	jmp    80070b <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	8d 50 04             	lea    0x4(%eax),%edx
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	89 10                	mov    %edx,(%eax)
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	83 e8 04             	sub    $0x4,%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	99                   	cltd   
}
  80070b:	5d                   	pop    %ebp
  80070c:	c3                   	ret    

0080070d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	56                   	push   %esi
  800711:	53                   	push   %ebx
  800712:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800715:	eb 17                	jmp    80072e <vprintfmt+0x21>
			if (ch == '\0')
  800717:	85 db                	test   %ebx,%ebx
  800719:	0f 84 af 03 00 00    	je     800ace <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	53                   	push   %ebx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	8d 50 01             	lea    0x1(%eax),%edx
  800734:	89 55 10             	mov    %edx,0x10(%ebp)
  800737:	8a 00                	mov    (%eax),%al
  800739:	0f b6 d8             	movzbl %al,%ebx
  80073c:	83 fb 25             	cmp    $0x25,%ebx
  80073f:	75 d6                	jne    800717 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800741:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800745:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800753:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800772:	83 f8 55             	cmp    $0x55,%eax
  800775:	0f 87 2b 03 00 00    	ja     800aa6 <vprintfmt+0x399>
  80077b:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
  800782:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800784:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800788:	eb d7                	jmp    800761 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078e:	eb d1                	jmp    800761 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800790:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800797:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079a:	89 d0                	mov    %edx,%eax
  80079c:	c1 e0 02             	shl    $0x2,%eax
  80079f:	01 d0                	add    %edx,%eax
  8007a1:	01 c0                	add    %eax,%eax
  8007a3:	01 d8                	add    %ebx,%eax
  8007a5:	83 e8 30             	sub    $0x30,%eax
  8007a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b6:	7e 3e                	jle    8007f6 <vprintfmt+0xe9>
  8007b8:	83 fb 39             	cmp    $0x39,%ebx
  8007bb:	7f 39                	jg     8007f6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c0:	eb d5                	jmp    800797 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d6:	eb 1f                	jmp    8007f7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007dc:	79 83                	jns    800761 <vprintfmt+0x54>
				width = 0;
  8007de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e5:	e9 77 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ea:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f1:	e9 6b ff ff ff       	jmp    800761 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fb:	0f 89 60 ff ff ff    	jns    800761 <vprintfmt+0x54>
				width = precision, precision = -1;
  800801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800807:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080e:	e9 4e ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800813:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800816:	e9 46 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 14             	mov    %eax,0x14(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	83 e8 04             	sub    $0x4,%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	50                   	push   %eax
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			break;
  80083b:	e9 89 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	83 c0 04             	add    $0x4,%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	83 e8 04             	sub    $0x4,%eax
  80084f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800851:	85 db                	test   %ebx,%ebx
  800853:	79 02                	jns    800857 <vprintfmt+0x14a>
				err = -err;
  800855:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800857:	83 fb 64             	cmp    $0x64,%ebx
  80085a:	7f 0b                	jg     800867 <vprintfmt+0x15a>
  80085c:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  800863:	85 f6                	test   %esi,%esi
  800865:	75 19                	jne    800880 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800867:	53                   	push   %ebx
  800868:	68 a5 3b 80 00       	push   $0x803ba5
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 5e 02 00 00       	call   800ad6 <printfmt>
  800878:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087b:	e9 49 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800880:	56                   	push   %esi
  800881:	68 ae 3b 80 00       	push   $0x803bae
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	ff 75 08             	pushl  0x8(%ebp)
  80088c:	e8 45 02 00 00       	call   800ad6 <printfmt>
  800891:	83 c4 10             	add    $0x10,%esp
			break;
  800894:	e9 30 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 c0 04             	add    $0x4,%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 30                	mov    (%eax),%esi
  8008aa:	85 f6                	test   %esi,%esi
  8008ac:	75 05                	jne    8008b3 <vprintfmt+0x1a6>
				p = "(null)";
  8008ae:	be b1 3b 80 00       	mov    $0x803bb1,%esi
			if (width > 0 && padc != '-')
  8008b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b7:	7e 6d                	jle    800926 <vprintfmt+0x219>
  8008b9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bd:	74 67                	je     800926 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	50                   	push   %eax
  8008c6:	56                   	push   %esi
  8008c7:	e8 0c 03 00 00       	call   800bd8 <strnlen>
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d2:	eb 16                	jmp    8008ea <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7f e4                	jg     8008d4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f0:	eb 34                	jmp    800926 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f6:	74 1c                	je     800914 <vprintfmt+0x207>
  8008f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fb:	7e 05                	jle    800902 <vprintfmt+0x1f5>
  8008fd:	83 fb 7e             	cmp    $0x7e,%ebx
  800900:	7e 12                	jle    800914 <vprintfmt+0x207>
					putch('?', putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	6a 3f                	push   $0x3f
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	eb 0f                	jmp    800923 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	ff 4d e4             	decl   -0x1c(%ebp)
  800926:	89 f0                	mov    %esi,%eax
  800928:	8d 70 01             	lea    0x1(%eax),%esi
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
  800930:	85 db                	test   %ebx,%ebx
  800932:	74 24                	je     800958 <vprintfmt+0x24b>
  800934:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800938:	78 b8                	js     8008f2 <vprintfmt+0x1e5>
  80093a:	ff 4d e0             	decl   -0x20(%ebp)
  80093d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800941:	79 af                	jns    8008f2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800943:	eb 13                	jmp    800958 <vprintfmt+0x24b>
				putch(' ', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 20                	push   $0x20
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800955:	ff 4d e4             	decl   -0x1c(%ebp)
  800958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095c:	7f e7                	jg     800945 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095e:	e9 66 01 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 e8             	pushl  -0x18(%ebp)
  800969:	8d 45 14             	lea    0x14(%ebp),%eax
  80096c:	50                   	push   %eax
  80096d:	e8 3c fd ff ff       	call   8006ae <getint>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800978:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800981:	85 d2                	test   %edx,%edx
  800983:	79 23                	jns    8009a8 <vprintfmt+0x29b>
				putch('-', putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	6a 2d                	push   $0x2d
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800998:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099b:	f7 d8                	neg    %eax
  80099d:	83 d2 00             	adc    $0x0,%edx
  8009a0:	f7 da                	neg    %edx
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 bc 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	e8 84 fc ff ff       	call   800647 <getuint>
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d3:	e9 98 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	6a 58                	push   $0x58
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 58                	push   $0x58
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			break;
  800a08:	e9 bc 00 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 30                	push   $0x30
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 78                	push   $0x78
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a48:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4f:	eb 1f                	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 e8             	pushl  -0x18(%ebp)
  800a57:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5a:	50                   	push   %eax
  800a5b:	e8 e7 fb ff ff       	call   800647 <getuint>
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a69:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a70:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	52                   	push   %edx
  800a7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7e:	50                   	push   %eax
  800a7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a82:	ff 75 f0             	pushl  -0x10(%ebp)
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	e8 00 fb ff ff       	call   800590 <printnum>
  800a90:	83 c4 20             	add    $0x20,%esp
			break;
  800a93:	eb 34                	jmp    800ac9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			break;
  800aa4:	eb 23                	jmp    800ac9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	6a 25                	push   $0x25
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab6:	ff 4d 10             	decl   0x10(%ebp)
  800ab9:	eb 03                	jmp    800abe <vprintfmt+0x3b1>
  800abb:	ff 4d 10             	decl   0x10(%ebp)
  800abe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac1:	48                   	dec    %eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	3c 25                	cmp    $0x25,%al
  800ac6:	75 f3                	jne    800abb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac8:	90                   	nop
		}
	}
  800ac9:	e9 47 fc ff ff       	jmp    800715 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ace:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adc:	8d 45 10             	lea    0x10(%ebp),%eax
  800adf:	83 c0 04             	add    $0x4,%eax
  800ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae8:	ff 75 f4             	pushl  -0xc(%ebp)
  800aeb:	50                   	push   %eax
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	e8 16 fc ff ff       	call   80070d <vprintfmt>
  800af7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afa:	90                   	nop
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 40 08             	mov    0x8(%eax),%eax
  800b06:	8d 50 01             	lea    0x1(%eax),%edx
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	8b 10                	mov    (%eax),%edx
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	8b 40 04             	mov    0x4(%eax),%eax
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	73 12                	jae    800b30 <sprintputch+0x33>
		*b->buf++ = ch;
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	8d 48 01             	lea    0x1(%eax),%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 0a                	mov    %ecx,(%edx)
  800b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2e:	88 10                	mov    %dl,(%eax)
}
  800b30:	90                   	nop
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	01 d0                	add    %edx,%eax
  800b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b58:	74 06                	je     800b60 <vsnprintf+0x2d>
  800b5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5e:	7f 07                	jg     800b67 <vsnprintf+0x34>
		return -E_INVAL;
  800b60:	b8 03 00 00 00       	mov    $0x3,%eax
  800b65:	eb 20                	jmp    800b87 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b67:	ff 75 14             	pushl  0x14(%ebp)
  800b6a:	ff 75 10             	pushl  0x10(%ebp)
  800b6d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b70:	50                   	push   %eax
  800b71:	68 fd 0a 80 00       	push   $0x800afd
  800b76:	e8 92 fb ff ff       	call   80070d <vprintfmt>
  800b7b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b81:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b92:	83 c0 04             	add    $0x4,%eax
  800b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9e:	50                   	push   %eax
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	ff 75 08             	pushl  0x8(%ebp)
  800ba5:	e8 89 ff ff ff       	call   800b33 <vsnprintf>
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc2:	eb 06                	jmp    800bca <strlen+0x15>
		n++;
  800bc4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc7:	ff 45 08             	incl   0x8(%ebp)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	84 c0                	test   %al,%al
  800bd1:	75 f1                	jne    800bc4 <strlen+0xf>
		n++;
	return n;
  800bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be5:	eb 09                	jmp    800bf0 <strnlen+0x18>
		n++;
  800be7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bea:	ff 45 08             	incl   0x8(%ebp)
  800bed:	ff 4d 0c             	decl   0xc(%ebp)
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	74 09                	je     800bff <strnlen+0x27>
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	84 c0                	test   %al,%al
  800bfd:	75 e8                	jne    800be7 <strnlen+0xf>
		n++;
	return n;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c10:	90                   	nop
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8d 50 01             	lea    0x1(%eax),%edx
  800c17:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c20:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c23:	8a 12                	mov    (%edx),%dl
  800c25:	88 10                	mov    %dl,(%eax)
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	75 e4                	jne    800c11 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c45:	eb 1f                	jmp    800c66 <strncpy+0x34>
		*dst++ = *src;
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8d 50 01             	lea    0x1(%eax),%edx
  800c4d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c53:	8a 12                	mov    (%edx),%dl
  800c55:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	74 03                	je     800c63 <strncpy+0x31>
			src++;
  800c60:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c63:	ff 45 fc             	incl   -0x4(%ebp)
  800c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c69:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6c:	72 d9                	jb     800c47 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c83:	74 30                	je     800cb5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c85:	eb 16                	jmp    800c9d <strlcpy+0x2a>
			*dst++ = *src++;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8d 50 01             	lea    0x1(%eax),%edx
  800c8d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c96:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c99:	8a 12                	mov    (%edx),%dl
  800c9b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c9d:	ff 4d 10             	decl   0x10(%ebp)
  800ca0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca4:	74 09                	je     800caf <strlcpy+0x3c>
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	75 d8                	jne    800c87 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	29 c2                	sub    %eax,%edx
  800cbd:	89 d0                	mov    %edx,%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc4:	eb 06                	jmp    800ccc <strcmp+0xb>
		p++, q++;
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	84 c0                	test   %al,%al
  800cd3:	74 0e                	je     800ce3 <strcmp+0x22>
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 10                	mov    (%eax),%dl
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	38 c2                	cmp    %al,%dl
  800ce1:	74 e3                	je     800cc6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 d0             	movzbl %al,%edx
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	0f b6 c0             	movzbl %al,%eax
  800cf3:	29 c2                	sub    %eax,%edx
  800cf5:	89 d0                	mov    %edx,%eax
}
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cfc:	eb 09                	jmp    800d07 <strncmp+0xe>
		n--, p++, q++;
  800cfe:	ff 4d 10             	decl   0x10(%ebp)
  800d01:	ff 45 08             	incl   0x8(%ebp)
  800d04:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0b:	74 17                	je     800d24 <strncmp+0x2b>
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 0e                	je     800d24 <strncmp+0x2b>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 10                	mov    (%eax),%dl
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	38 c2                	cmp    %al,%dl
  800d22:	74 da                	je     800cfe <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d28:	75 07                	jne    800d31 <strncmp+0x38>
		return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2f:	eb 14                	jmp    800d45 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 d0             	movzbl %al,%edx
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 c0             	movzbl %al,%eax
  800d41:	29 c2                	sub    %eax,%edx
  800d43:	89 d0                	mov    %edx,%eax
}
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 04             	sub    $0x4,%esp
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d53:	eb 12                	jmp    800d67 <strchr+0x20>
		if (*s == c)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5d:	75 05                	jne    800d64 <strchr+0x1d>
			return (char *) s;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	eb 11                	jmp    800d75 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d64:	ff 45 08             	incl   0x8(%ebp)
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	75 e5                	jne    800d55 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 04             	sub    $0x4,%esp
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d83:	eb 0d                	jmp    800d92 <strfind+0x1b>
		if (*s == c)
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8d:	74 0e                	je     800d9d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d8f:	ff 45 08             	incl   0x8(%ebp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	75 ea                	jne    800d85 <strfind+0xe>
  800d9b:	eb 01                	jmp    800d9e <strfind+0x27>
		if (*s == c)
			break;
  800d9d:	90                   	nop
	return (char *) s;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800daf:	8b 45 10             	mov    0x10(%ebp),%eax
  800db2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db5:	eb 0e                	jmp    800dc5 <memset+0x22>
		*p++ = c;
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	8d 50 01             	lea    0x1(%eax),%edx
  800dbd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc5:	ff 4d f8             	decl   -0x8(%ebp)
  800dc8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcc:	79 e9                	jns    800db7 <memset+0x14>
		*p++ = c;

	return v;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de5:	eb 16                	jmp    800dfd <memcpy+0x2a>
		*d++ = *s++;
  800de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dea:	8d 50 01             	lea    0x1(%eax),%edx
  800ded:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df9:	8a 12                	mov    (%edx),%dl
  800dfb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800e00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e03:	89 55 10             	mov    %edx,0x10(%ebp)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	75 dd                	jne    800de7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e27:	73 50                	jae    800e79 <memmove+0x6a>
  800e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	01 d0                	add    %edx,%eax
  800e31:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e34:	76 43                	jbe    800e79 <memmove+0x6a>
		s += n;
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e42:	eb 10                	jmp    800e54 <memmove+0x45>
			*--d = *--s;
  800e44:	ff 4d f8             	decl   -0x8(%ebp)
  800e47:	ff 4d fc             	decl   -0x4(%ebp)
  800e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e54:	8b 45 10             	mov    0x10(%ebp),%eax
  800e57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 e3                	jne    800e44 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e61:	eb 23                	jmp    800e86 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e72:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e75:	8a 12                	mov    (%edx),%dl
  800e77:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e79:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	75 dd                	jne    800e63 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e9d:	eb 2a                	jmp    800ec9 <memcmp+0x3e>
		if (*s1 != *s2)
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 10                	mov    (%eax),%dl
  800ea4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	38 c2                	cmp    %al,%dl
  800eab:	74 16                	je     800ec3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 d0             	movzbl %al,%edx
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	29 c2                	sub    %eax,%edx
  800ebf:	89 d0                	mov    %edx,%eax
  800ec1:	eb 18                	jmp    800edb <memcmp+0x50>
		s1++, s2++;
  800ec3:	ff 45 fc             	incl   -0x4(%ebp)
  800ec6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	75 c9                	jne    800e9f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee9:	01 d0                	add    %edx,%eax
  800eeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eee:	eb 15                	jmp    800f05 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	0f b6 d0             	movzbl %al,%edx
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	0f b6 c0             	movzbl %al,%eax
  800efe:	39 c2                	cmp    %eax,%edx
  800f00:	74 0d                	je     800f0f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0b:	72 e3                	jb     800ef0 <memfind+0x13>
  800f0d:	eb 01                	jmp    800f10 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f0f:	90                   	nop
	return (void *) s;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f22:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f29:	eb 03                	jmp    800f2e <strtol+0x19>
		s++;
  800f2b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 20                	cmp    $0x20,%al
  800f35:	74 f4                	je     800f2b <strtol+0x16>
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	3c 09                	cmp    $0x9,%al
  800f3e:	74 eb                	je     800f2b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2b                	cmp    $0x2b,%al
  800f47:	75 05                	jne    800f4e <strtol+0x39>
		s++;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	eb 13                	jmp    800f61 <strtol+0x4c>
	else if (*s == '-')
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 2d                	cmp    $0x2d,%al
  800f55:	75 0a                	jne    800f61 <strtol+0x4c>
		s++, neg = 1;
  800f57:	ff 45 08             	incl   0x8(%ebp)
  800f5a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f65:	74 06                	je     800f6d <strtol+0x58>
  800f67:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6b:	75 20                	jne    800f8d <strtol+0x78>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3c 30                	cmp    $0x30,%al
  800f74:	75 17                	jne    800f8d <strtol+0x78>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	40                   	inc    %eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 78                	cmp    $0x78,%al
  800f7e:	75 0d                	jne    800f8d <strtol+0x78>
		s += 2, base = 16;
  800f80:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f84:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8b:	eb 28                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f91:	75 15                	jne    800fa8 <strtol+0x93>
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	3c 30                	cmp    $0x30,%al
  800f9a:	75 0c                	jne    800fa8 <strtol+0x93>
		s++, base = 8;
  800f9c:	ff 45 08             	incl   0x8(%ebp)
  800f9f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa6:	eb 0d                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0)
  800fa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fac:	75 07                	jne    800fb5 <strtol+0xa0>
		base = 10;
  800fae:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 2f                	cmp    $0x2f,%al
  800fbc:	7e 19                	jle    800fd7 <strtol+0xc2>
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	3c 39                	cmp    $0x39,%al
  800fc5:	7f 10                	jg     800fd7 <strtol+0xc2>
			dig = *s - '0';
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f be c0             	movsbl %al,%eax
  800fcf:	83 e8 30             	sub    $0x30,%eax
  800fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd5:	eb 42                	jmp    801019 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 60                	cmp    $0x60,%al
  800fde:	7e 19                	jle    800ff9 <strtol+0xe4>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 7a                	cmp    $0x7a,%al
  800fe7:	7f 10                	jg     800ff9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f be c0             	movsbl %al,%eax
  800ff1:	83 e8 57             	sub    $0x57,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff7:	eb 20                	jmp    801019 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 40                	cmp    $0x40,%al
  801000:	7e 39                	jle    80103b <strtol+0x126>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 5a                	cmp    $0x5a,%al
  801009:	7f 30                	jg     80103b <strtol+0x126>
			dig = *s - 'A' + 10;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 37             	sub    $0x37,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101f:	7d 19                	jge    80103a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801021:	ff 45 08             	incl   0x8(%ebp)
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102b:	89 c2                	mov    %eax,%edx
  80102d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801035:	e9 7b ff ff ff       	jmp    800fb5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103f:	74 08                	je     801049 <strtol+0x134>
		*endptr = (char *) s;
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	8b 55 08             	mov    0x8(%ebp),%edx
  801047:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801049:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80104d:	74 07                	je     801056 <strtol+0x141>
  80104f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801052:	f7 d8                	neg    %eax
  801054:	eb 03                	jmp    801059 <strtol+0x144>
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <ltostr>:

void
ltostr(long value, char *str)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801068:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80106f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801073:	79 13                	jns    801088 <ltostr+0x2d>
	{
		neg = 1;
  801075:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801082:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801085:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801090:	99                   	cltd   
  801091:	f7 f9                	idiv   %ecx
  801093:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801096:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801099:	8d 50 01             	lea    0x1(%eax),%edx
  80109c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109f:	89 c2                	mov    %eax,%edx
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	01 d0                	add    %edx,%eax
  8010a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a9:	83 c2 30             	add    $0x30,%edx
  8010ac:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b6:	f7 e9                	imul   %ecx
  8010b8:	c1 fa 02             	sar    $0x2,%edx
  8010bb:	89 c8                	mov    %ecx,%eax
  8010bd:	c1 f8 1f             	sar    $0x1f,%eax
  8010c0:	29 c2                	sub    %eax,%edx
  8010c2:	89 d0                	mov    %edx,%eax
  8010c4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ca:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010cf:	f7 e9                	imul   %ecx
  8010d1:	c1 fa 02             	sar    $0x2,%edx
  8010d4:	89 c8                	mov    %ecx,%eax
  8010d6:	c1 f8 1f             	sar    $0x1f,%eax
  8010d9:	29 c2                	sub    %eax,%edx
  8010db:	89 d0                	mov    %edx,%eax
  8010dd:	c1 e0 02             	shl    $0x2,%eax
  8010e0:	01 d0                	add    %edx,%eax
  8010e2:	01 c0                	add    %eax,%eax
  8010e4:	29 c1                	sub    %eax,%ecx
  8010e6:	89 ca                	mov    %ecx,%edx
  8010e8:	85 d2                	test   %edx,%edx
  8010ea:	75 9c                	jne    801088 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f6:	48                   	dec    %eax
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010fe:	74 3d                	je     80113d <ltostr+0xe2>
		start = 1 ;
  801100:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801107:	eb 34                	jmp    80113d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110f:	01 d0                	add    %edx,%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801116:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c2                	add    %eax,%edx
  80111e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	01 c8                	add    %ecx,%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	01 c2                	add    %eax,%edx
  801132:	8a 45 eb             	mov    -0x15(%ebp),%al
  801135:	88 02                	mov    %al,(%edx)
		start++ ;
  801137:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80113d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801143:	7c c4                	jl     801109 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801145:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801150:	90                   	nop
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801159:	ff 75 08             	pushl  0x8(%ebp)
  80115c:	e8 54 fa ff ff       	call   800bb5 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801167:	ff 75 0c             	pushl  0xc(%ebp)
  80116a:	e8 46 fa ff ff       	call   800bb5 <strlen>
  80116f:	83 c4 04             	add    $0x4,%esp
  801172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801183:	eb 17                	jmp    80119c <strcconcat+0x49>
		final[s] = str1[s] ;
  801185:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	01 c2                	add    %eax,%edx
  80118d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	01 c8                	add    %ecx,%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801199:	ff 45 fc             	incl   -0x4(%ebp)
  80119c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a2:	7c e1                	jl     801185 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b2:	eb 1f                	jmp    8011d3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d0:	ff 45 f8             	incl   -0x8(%ebp)
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c d9                	jl     8011b4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f8:	8b 00                	mov    (%eax),%eax
  8011fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801201:	8b 45 10             	mov    0x10(%ebp),%eax
  801204:	01 d0                	add    %edx,%eax
  801206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	eb 0c                	jmp    80121a <strsplit+0x31>
			*string++ = 0;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8d 50 01             	lea    0x1(%eax),%edx
  801214:	89 55 08             	mov    %edx,0x8(%ebp)
  801217:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	84 c0                	test   %al,%al
  801221:	74 18                	je     80123b <strsplit+0x52>
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	0f be c0             	movsbl %al,%eax
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	e8 13 fb ff ff       	call   800d47 <strchr>
  801234:	83 c4 08             	add    $0x8,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	75 d3                	jne    80120e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	84 c0                	test   %al,%al
  801242:	74 5a                	je     80129e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	83 f8 0f             	cmp    $0xf,%eax
  80124c:	75 07                	jne    801255 <strsplit+0x6c>
		{
			return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
  801253:	eb 66                	jmp    8012bb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	8d 48 01             	lea    0x1(%eax),%ecx
  80125d:	8b 55 14             	mov    0x14(%ebp),%edx
  801260:	89 0a                	mov    %ecx,(%edx)
  801262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801269:	8b 45 10             	mov    0x10(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801273:	eb 03                	jmp    801278 <strsplit+0x8f>
			string++;
  801275:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	84 c0                	test   %al,%al
  80127f:	74 8b                	je     80120c <strsplit+0x23>
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	0f be c0             	movsbl %al,%eax
  801289:	50                   	push   %eax
  80128a:	ff 75 0c             	pushl  0xc(%ebp)
  80128d:	e8 b5 fa ff ff       	call   800d47 <strchr>
  801292:	83 c4 08             	add    $0x8,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	74 dc                	je     801275 <strsplit+0x8c>
			string++;
	}
  801299:	e9 6e ff ff ff       	jmp    80120c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80129e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 1f                	je     8012eb <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cc:	e8 1d 00 00 00       	call   8012ee <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	68 10 3d 80 00       	push   $0x803d10
  8012d9:	e8 55 f2 ff ff       	call   800533 <cprintf>
  8012de:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e1:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e8:	00 00 00 
	}
}
  8012eb:	90                   	nop
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8012f4:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012fb:	00 00 00 
  8012fe:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801305:	00 00 00 
  801308:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80130f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801312:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801319:	00 00 00 
  80131c:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801323:	00 00 00 
  801326:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80132d:	00 00 00 
	uint32 arr_size = 0;
  801330:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801337:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80133e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801341:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801346:	2d 00 10 00 00       	sub    $0x1000,%eax
  80134b:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801350:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801357:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80135a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801361:	a1 20 41 80 00       	mov    0x804120,%eax
  801366:	c1 e0 04             	shl    $0x4,%eax
  801369:	89 c2                	mov    %eax,%edx
  80136b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	48                   	dec    %eax
  801371:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801374:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801377:	ba 00 00 00 00       	mov    $0x0,%edx
  80137c:	f7 75 ec             	divl   -0x14(%ebp)
  80137f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801382:	29 d0                	sub    %edx,%eax
  801384:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801387:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80138e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801391:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801396:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139b:	83 ec 04             	sub    $0x4,%esp
  80139e:	6a 06                	push   $0x6
  8013a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a3:	50                   	push   %eax
  8013a4:	e8 6a 04 00 00       	call   801813 <sys_allocate_chunk>
  8013a9:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ac:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b1:	83 ec 0c             	sub    $0xc,%esp
  8013b4:	50                   	push   %eax
  8013b5:	e8 df 0a 00 00       	call   801e99 <initialize_MemBlocksList>
  8013ba:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013bd:	a1 48 41 80 00       	mov    0x804148,%eax
  8013c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8013c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c8:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8013cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d2:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8013d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013dd:	75 14                	jne    8013f3 <initialize_dyn_block_system+0x105>
  8013df:	83 ec 04             	sub    $0x4,%esp
  8013e2:	68 35 3d 80 00       	push   $0x803d35
  8013e7:	6a 33                	push   $0x33
  8013e9:	68 53 3d 80 00       	push   $0x803d53
  8013ee:	e8 8c ee ff ff       	call   80027f <_panic>
  8013f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f6:	8b 00                	mov    (%eax),%eax
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	74 10                	je     80140c <initialize_dyn_block_system+0x11e>
  8013fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ff:	8b 00                	mov    (%eax),%eax
  801401:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801404:	8b 52 04             	mov    0x4(%edx),%edx
  801407:	89 50 04             	mov    %edx,0x4(%eax)
  80140a:	eb 0b                	jmp    801417 <initialize_dyn_block_system+0x129>
  80140c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140f:	8b 40 04             	mov    0x4(%eax),%eax
  801412:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141a:	8b 40 04             	mov    0x4(%eax),%eax
  80141d:	85 c0                	test   %eax,%eax
  80141f:	74 0f                	je     801430 <initialize_dyn_block_system+0x142>
  801421:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801424:	8b 40 04             	mov    0x4(%eax),%eax
  801427:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80142a:	8b 12                	mov    (%edx),%edx
  80142c:	89 10                	mov    %edx,(%eax)
  80142e:	eb 0a                	jmp    80143a <initialize_dyn_block_system+0x14c>
  801430:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801433:	8b 00                	mov    (%eax),%eax
  801435:	a3 48 41 80 00       	mov    %eax,0x804148
  80143a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801443:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801446:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80144d:	a1 54 41 80 00       	mov    0x804154,%eax
  801452:	48                   	dec    %eax
  801453:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801458:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80145c:	75 14                	jne    801472 <initialize_dyn_block_system+0x184>
  80145e:	83 ec 04             	sub    $0x4,%esp
  801461:	68 60 3d 80 00       	push   $0x803d60
  801466:	6a 34                	push   $0x34
  801468:	68 53 3d 80 00       	push   $0x803d53
  80146d:	e8 0d ee ff ff       	call   80027f <_panic>
  801472:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801478:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147b:	89 10                	mov    %edx,(%eax)
  80147d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	85 c0                	test   %eax,%eax
  801484:	74 0d                	je     801493 <initialize_dyn_block_system+0x1a5>
  801486:	a1 38 41 80 00       	mov    0x804138,%eax
  80148b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80148e:	89 50 04             	mov    %edx,0x4(%eax)
  801491:	eb 08                	jmp    80149b <initialize_dyn_block_system+0x1ad>
  801493:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801496:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80149b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149e:	a3 38 41 80 00       	mov    %eax,0x804138
  8014a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014ad:	a1 44 41 80 00       	mov    0x804144,%eax
  8014b2:	40                   	inc    %eax
  8014b3:	a3 44 41 80 00       	mov    %eax,0x804144
}
  8014b8:	90                   	nop
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014c1:	e8 f7 fd ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  8014c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014ca:	75 07                	jne    8014d3 <malloc+0x18>
  8014cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d1:	eb 61                	jmp    801534 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8014d3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014da:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e0:	01 d0                	add    %edx,%eax
  8014e2:	48                   	dec    %eax
  8014e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ee:	f7 75 f0             	divl   -0x10(%ebp)
  8014f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f4:	29 d0                	sub    %edx,%eax
  8014f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014f9:	e8 e3 06 00 00       	call   801be1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014fe:	85 c0                	test   %eax,%eax
  801500:	74 11                	je     801513 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801502:	83 ec 0c             	sub    $0xc,%esp
  801505:	ff 75 e8             	pushl  -0x18(%ebp)
  801508:	e8 4e 0d 00 00       	call   80225b <alloc_block_FF>
  80150d:	83 c4 10             	add    $0x10,%esp
  801510:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801517:	74 16                	je     80152f <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801519:	83 ec 0c             	sub    $0xc,%esp
  80151c:	ff 75 f4             	pushl  -0xc(%ebp)
  80151f:	e8 aa 0a 00 00       	call   801fce <insert_sorted_allocList>
  801524:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152a:	8b 40 08             	mov    0x8(%eax),%eax
  80152d:	eb 05                	jmp    801534 <malloc+0x79>
	}

    return NULL;
  80152f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	68 84 3d 80 00       	push   $0x803d84
  801544:	6a 6f                	push   $0x6f
  801546:	68 53 3d 80 00       	push   $0x803d53
  80154b:	e8 2f ed ff ff       	call   80027f <_panic>

00801550 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	83 ec 38             	sub    $0x38,%esp
  801556:	8b 45 10             	mov    0x10(%ebp),%eax
  801559:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80155c:	e8 5c fd ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  801561:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801565:	75 07                	jne    80156e <smalloc+0x1e>
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
  80156c:	eb 7c                	jmp    8015ea <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80156e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801575:	8b 55 0c             	mov    0xc(%ebp),%edx
  801578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157b:	01 d0                	add    %edx,%eax
  80157d:	48                   	dec    %eax
  80157e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801581:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801584:	ba 00 00 00 00       	mov    $0x0,%edx
  801589:	f7 75 f0             	divl   -0x10(%ebp)
  80158c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158f:	29 d0                	sub    %edx,%eax
  801591:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801594:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80159b:	e8 41 06 00 00       	call   801be1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	74 11                	je     8015b5 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8015a4:	83 ec 0c             	sub    $0xc,%esp
  8015a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8015aa:	e8 ac 0c 00 00       	call   80225b <alloc_block_FF>
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015b9:	74 2a                	je     8015e5 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015be:	8b 40 08             	mov    0x8(%eax),%eax
  8015c1:	89 c2                	mov    %eax,%edx
  8015c3:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015c7:	52                   	push   %edx
  8015c8:	50                   	push   %eax
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	ff 75 08             	pushl  0x8(%ebp)
  8015cf:	e8 92 03 00 00       	call   801966 <sys_createSharedObject>
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8015da:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8015de:	74 05                	je     8015e5 <smalloc+0x95>
			return (void*)virtual_address;
  8015e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e3:	eb 05                	jmp    8015ea <smalloc+0x9a>
	}
	return NULL;
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f2:	e8 c6 fc ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015f7:	83 ec 04             	sub    $0x4,%esp
  8015fa:	68 a8 3d 80 00       	push   $0x803da8
  8015ff:	68 b0 00 00 00       	push   $0xb0
  801604:	68 53 3d 80 00       	push   $0x803d53
  801609:	e8 71 ec ff ff       	call   80027f <_panic>

0080160e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801614:	e8 a4 fc ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801619:	83 ec 04             	sub    $0x4,%esp
  80161c:	68 cc 3d 80 00       	push   $0x803dcc
  801621:	68 f4 00 00 00       	push   $0xf4
  801626:	68 53 3d 80 00       	push   $0x803d53
  80162b:	e8 4f ec ff ff       	call   80027f <_panic>

00801630 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801636:	83 ec 04             	sub    $0x4,%esp
  801639:	68 f4 3d 80 00       	push   $0x803df4
  80163e:	68 08 01 00 00       	push   $0x108
  801643:	68 53 3d 80 00       	push   $0x803d53
  801648:	e8 32 ec ff ff       	call   80027f <_panic>

0080164d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	68 18 3e 80 00       	push   $0x803e18
  80165b:	68 13 01 00 00       	push   $0x113
  801660:	68 53 3d 80 00       	push   $0x803d53
  801665:	e8 15 ec ff ff       	call   80027f <_panic>

0080166a <shrink>:

}
void shrink(uint32 newSize)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801670:	83 ec 04             	sub    $0x4,%esp
  801673:	68 18 3e 80 00       	push   $0x803e18
  801678:	68 18 01 00 00       	push   $0x118
  80167d:	68 53 3d 80 00       	push   $0x803d53
  801682:	e8 f8 eb ff ff       	call   80027f <_panic>

00801687 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80168d:	83 ec 04             	sub    $0x4,%esp
  801690:	68 18 3e 80 00       	push   $0x803e18
  801695:	68 1d 01 00 00       	push   $0x11d
  80169a:	68 53 3d 80 00       	push   $0x803d53
  80169f:	e8 db eb ff ff       	call   80027f <_panic>

008016a4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	57                   	push   %edi
  8016a8:	56                   	push   %esi
  8016a9:	53                   	push   %ebx
  8016aa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016b9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016bc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016bf:	cd 30                	int    $0x30
  8016c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	5b                   	pop    %ebx
  8016cb:	5e                   	pop    %esi
  8016cc:	5f                   	pop    %edi
  8016cd:	5d                   	pop    %ebp
  8016ce:	c3                   	ret    

008016cf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	52                   	push   %edx
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	50                   	push   %eax
  8016eb:	6a 00                	push   $0x0
  8016ed:	e8 b2 ff ff ff       	call   8016a4 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	90                   	nop
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 01                	push   $0x1
  801707:	e8 98 ff ff ff       	call   8016a4 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801714:	8b 55 0c             	mov    0xc(%ebp),%edx
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	52                   	push   %edx
  801721:	50                   	push   %eax
  801722:	6a 05                	push   $0x5
  801724:	e8 7b ff ff ff       	call   8016a4 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	56                   	push   %esi
  801732:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801733:	8b 75 18             	mov    0x18(%ebp),%esi
  801736:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801739:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	56                   	push   %esi
  801743:	53                   	push   %ebx
  801744:	51                   	push   %ecx
  801745:	52                   	push   %edx
  801746:	50                   	push   %eax
  801747:	6a 06                	push   $0x6
  801749:	e8 56 ff ff ff       	call   8016a4 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801754:	5b                   	pop    %ebx
  801755:	5e                   	pop    %esi
  801756:	5d                   	pop    %ebp
  801757:	c3                   	ret    

00801758 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80175b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	52                   	push   %edx
  801768:	50                   	push   %eax
  801769:	6a 07                	push   $0x7
  80176b:	e8 34 ff ff ff       	call   8016a4 <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	ff 75 0c             	pushl  0xc(%ebp)
  801781:	ff 75 08             	pushl  0x8(%ebp)
  801784:	6a 08                	push   $0x8
  801786:	e8 19 ff ff ff       	call   8016a4 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 09                	push   $0x9
  80179f:	e8 00 ff ff ff       	call   8016a4 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 0a                	push   $0xa
  8017b8:	e8 e7 fe ff ff       	call   8016a4 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 0b                	push   $0xb
  8017d1:	e8 ce fe ff ff       	call   8016a4 <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	ff 75 08             	pushl  0x8(%ebp)
  8017ea:	6a 0f                	push   $0xf
  8017ec:	e8 b3 fe ff ff       	call   8016a4 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
	return;
  8017f4:	90                   	nop
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	ff 75 0c             	pushl  0xc(%ebp)
  801803:	ff 75 08             	pushl  0x8(%ebp)
  801806:	6a 10                	push   $0x10
  801808:	e8 97 fe ff ff       	call   8016a4 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
	return ;
  801810:	90                   	nop
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	ff 75 10             	pushl  0x10(%ebp)
  80181d:	ff 75 0c             	pushl  0xc(%ebp)
  801820:	ff 75 08             	pushl  0x8(%ebp)
  801823:	6a 11                	push   $0x11
  801825:	e8 7a fe ff ff       	call   8016a4 <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
	return ;
  80182d:	90                   	nop
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 0c                	push   $0xc
  80183f:	e8 60 fe ff ff       	call   8016a4 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	ff 75 08             	pushl  0x8(%ebp)
  801857:	6a 0d                	push   $0xd
  801859:	e8 46 fe ff ff       	call   8016a4 <syscall>
  80185e:	83 c4 18             	add    $0x18,%esp
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 0e                	push   $0xe
  801872:	e8 2d fe ff ff       	call   8016a4 <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	90                   	nop
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 13                	push   $0x13
  80188c:	e8 13 fe ff ff       	call   8016a4 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
}
  801894:	90                   	nop
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 14                	push   $0x14
  8018a6:	e8 f9 fd ff ff       	call   8016a4 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	90                   	nop
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
  8018b4:	83 ec 04             	sub    $0x4,%esp
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018bd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	50                   	push   %eax
  8018ca:	6a 15                	push   $0x15
  8018cc:	e8 d3 fd ff ff       	call   8016a4 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	90                   	nop
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 16                	push   $0x16
  8018e6:	e8 b9 fd ff ff       	call   8016a4 <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	90                   	nop
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	ff 75 0c             	pushl  0xc(%ebp)
  801900:	50                   	push   %eax
  801901:	6a 17                	push   $0x17
  801903:	e8 9c fd ff ff       	call   8016a4 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801910:	8b 55 0c             	mov    0xc(%ebp),%edx
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	52                   	push   %edx
  80191d:	50                   	push   %eax
  80191e:	6a 1a                	push   $0x1a
  801920:	e8 7f fd ff ff       	call   8016a4 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80192d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	52                   	push   %edx
  80193a:	50                   	push   %eax
  80193b:	6a 18                	push   $0x18
  80193d:	e8 62 fd ff ff       	call   8016a4 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	90                   	nop
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80194b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	52                   	push   %edx
  801958:	50                   	push   %eax
  801959:	6a 19                	push   $0x19
  80195b:	e8 44 fd ff ff       	call   8016a4 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	90                   	nop
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 04             	sub    $0x4,%esp
  80196c:	8b 45 10             	mov    0x10(%ebp),%eax
  80196f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801972:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801975:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	6a 00                	push   $0x0
  80197e:	51                   	push   %ecx
  80197f:	52                   	push   %edx
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	50                   	push   %eax
  801984:	6a 1b                	push   $0x1b
  801986:	e8 19 fd ff ff       	call   8016a4 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801993:	8b 55 0c             	mov    0xc(%ebp),%edx
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	52                   	push   %edx
  8019a0:	50                   	push   %eax
  8019a1:	6a 1c                	push   $0x1c
  8019a3:	e8 fc fc ff ff       	call   8016a4 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	51                   	push   %ecx
  8019be:	52                   	push   %edx
  8019bf:	50                   	push   %eax
  8019c0:	6a 1d                	push   $0x1d
  8019c2:	e8 dd fc ff ff       	call   8016a4 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	52                   	push   %edx
  8019dc:	50                   	push   %eax
  8019dd:	6a 1e                	push   $0x1e
  8019df:	e8 c0 fc ff ff       	call   8016a4 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 1f                	push   $0x1f
  8019f8:	e8 a7 fc ff ff       	call   8016a4 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	6a 00                	push   $0x0
  801a0a:	ff 75 14             	pushl  0x14(%ebp)
  801a0d:	ff 75 10             	pushl  0x10(%ebp)
  801a10:	ff 75 0c             	pushl  0xc(%ebp)
  801a13:	50                   	push   %eax
  801a14:	6a 20                	push   $0x20
  801a16:	e8 89 fc ff ff       	call   8016a4 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	50                   	push   %eax
  801a2f:	6a 21                	push   $0x21
  801a31:	e8 6e fc ff ff       	call   8016a4 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	90                   	nop
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	50                   	push   %eax
  801a4b:	6a 22                	push   $0x22
  801a4d:	e8 52 fc ff ff       	call   8016a4 <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 02                	push   $0x2
  801a66:	e8 39 fc ff ff       	call   8016a4 <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 03                	push   $0x3
  801a7f:	e8 20 fc ff ff       	call   8016a4 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 04                	push   $0x4
  801a98:	e8 07 fc ff ff       	call   8016a4 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_exit_env>:


void sys_exit_env(void)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 23                	push   $0x23
  801ab1:	e8 ee fb ff ff       	call   8016a4 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	90                   	nop
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ac2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ac5:	8d 50 04             	lea    0x4(%eax),%edx
  801ac8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	52                   	push   %edx
  801ad2:	50                   	push   %eax
  801ad3:	6a 24                	push   $0x24
  801ad5:	e8 ca fb ff ff       	call   8016a4 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
	return result;
  801add:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ae0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ae3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ae6:	89 01                	mov    %eax,(%ecx)
  801ae8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	c9                   	leave  
  801aef:	c2 04 00             	ret    $0x4

00801af2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 10             	pushl  0x10(%ebp)
  801afc:	ff 75 0c             	pushl  0xc(%ebp)
  801aff:	ff 75 08             	pushl  0x8(%ebp)
  801b02:	6a 12                	push   $0x12
  801b04:	e8 9b fb ff ff       	call   8016a4 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0c:	90                   	nop
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_rcr2>:
uint32 sys_rcr2()
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 25                	push   $0x25
  801b1e:	e8 81 fb ff ff       	call   8016a4 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	83 ec 04             	sub    $0x4,%esp
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b34:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	50                   	push   %eax
  801b41:	6a 26                	push   $0x26
  801b43:	e8 5c fb ff ff       	call   8016a4 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4b:	90                   	nop
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <rsttst>:
void rsttst()
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 28                	push   $0x28
  801b5d:	e8 42 fb ff ff       	call   8016a4 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
	return ;
  801b65:	90                   	nop
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 04             	sub    $0x4,%esp
  801b6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b74:	8b 55 18             	mov    0x18(%ebp),%edx
  801b77:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b7b:	52                   	push   %edx
  801b7c:	50                   	push   %eax
  801b7d:	ff 75 10             	pushl  0x10(%ebp)
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	ff 75 08             	pushl  0x8(%ebp)
  801b86:	6a 27                	push   $0x27
  801b88:	e8 17 fb ff ff       	call   8016a4 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b90:	90                   	nop
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <chktst>:
void chktst(uint32 n)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	ff 75 08             	pushl  0x8(%ebp)
  801ba1:	6a 29                	push   $0x29
  801ba3:	e8 fc fa ff ff       	call   8016a4 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bab:	90                   	nop
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <inctst>:

void inctst()
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 2a                	push   $0x2a
  801bbd:	e8 e2 fa ff ff       	call   8016a4 <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc5:	90                   	nop
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <gettst>:
uint32 gettst()
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 2b                	push   $0x2b
  801bd7:	e8 c8 fa ff ff       	call   8016a4 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 2c                	push   $0x2c
  801bf3:	e8 ac fa ff ff       	call   8016a4 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
  801bfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bfe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c02:	75 07                	jne    801c0b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c04:	b8 01 00 00 00       	mov    $0x1,%eax
  801c09:	eb 05                	jmp    801c10 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
  801c15:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 2c                	push   $0x2c
  801c24:	e8 7b fa ff ff       	call   8016a4 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
  801c2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c2f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c33:	75 07                	jne    801c3c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c35:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3a:	eb 05                	jmp    801c41 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 2c                	push   $0x2c
  801c55:	e8 4a fa ff ff       	call   8016a4 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
  801c5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c60:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c64:	75 07                	jne    801c6d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c66:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6b:	eb 05                	jmp    801c72 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 2c                	push   $0x2c
  801c86:	e8 19 fa ff ff       	call   8016a4 <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
  801c8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c91:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c95:	75 07                	jne    801c9e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c97:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9c:	eb 05                	jmp    801ca3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	ff 75 08             	pushl  0x8(%ebp)
  801cb3:	6a 2d                	push   $0x2d
  801cb5:	e8 ea f9 ff ff       	call   8016a4 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbd:	90                   	nop
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cc4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	6a 00                	push   $0x0
  801cd2:	53                   	push   %ebx
  801cd3:	51                   	push   %ecx
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	6a 2e                	push   $0x2e
  801cd8:	e8 c7 f9 ff ff       	call   8016a4 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	52                   	push   %edx
  801cf5:	50                   	push   %eax
  801cf6:	6a 2f                	push   $0x2f
  801cf8:	e8 a7 f9 ff ff       	call   8016a4 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d08:	83 ec 0c             	sub    $0xc,%esp
  801d0b:	68 28 3e 80 00       	push   $0x803e28
  801d10:	e8 1e e8 ff ff       	call   800533 <cprintf>
  801d15:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d1f:	83 ec 0c             	sub    $0xc,%esp
  801d22:	68 54 3e 80 00       	push   $0x803e54
  801d27:	e8 07 e8 ff ff       	call   800533 <cprintf>
  801d2c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d2f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d33:	a1 38 41 80 00       	mov    0x804138,%eax
  801d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d3b:	eb 56                	jmp    801d93 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d41:	74 1c                	je     801d5f <print_mem_block_lists+0x5d>
  801d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d46:	8b 50 08             	mov    0x8(%eax),%edx
  801d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4c:	8b 48 08             	mov    0x8(%eax),%ecx
  801d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d52:	8b 40 0c             	mov    0xc(%eax),%eax
  801d55:	01 c8                	add    %ecx,%eax
  801d57:	39 c2                	cmp    %eax,%edx
  801d59:	73 04                	jae    801d5f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d5b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d62:	8b 50 08             	mov    0x8(%eax),%edx
  801d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d68:	8b 40 0c             	mov    0xc(%eax),%eax
  801d6b:	01 c2                	add    %eax,%edx
  801d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d70:	8b 40 08             	mov    0x8(%eax),%eax
  801d73:	83 ec 04             	sub    $0x4,%esp
  801d76:	52                   	push   %edx
  801d77:	50                   	push   %eax
  801d78:	68 69 3e 80 00       	push   $0x803e69
  801d7d:	e8 b1 e7 ff ff       	call   800533 <cprintf>
  801d82:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d8b:	a1 40 41 80 00       	mov    0x804140,%eax
  801d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d97:	74 07                	je     801da0 <print_mem_block_lists+0x9e>
  801d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9c:	8b 00                	mov    (%eax),%eax
  801d9e:	eb 05                	jmp    801da5 <print_mem_block_lists+0xa3>
  801da0:	b8 00 00 00 00       	mov    $0x0,%eax
  801da5:	a3 40 41 80 00       	mov    %eax,0x804140
  801daa:	a1 40 41 80 00       	mov    0x804140,%eax
  801daf:	85 c0                	test   %eax,%eax
  801db1:	75 8a                	jne    801d3d <print_mem_block_lists+0x3b>
  801db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db7:	75 84                	jne    801d3d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801db9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dbd:	75 10                	jne    801dcf <print_mem_block_lists+0xcd>
  801dbf:	83 ec 0c             	sub    $0xc,%esp
  801dc2:	68 78 3e 80 00       	push   $0x803e78
  801dc7:	e8 67 e7 ff ff       	call   800533 <cprintf>
  801dcc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dcf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dd6:	83 ec 0c             	sub    $0xc,%esp
  801dd9:	68 9c 3e 80 00       	push   $0x803e9c
  801dde:	e8 50 e7 ff ff       	call   800533 <cprintf>
  801de3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801de6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dea:	a1 40 40 80 00       	mov    0x804040,%eax
  801def:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df2:	eb 56                	jmp    801e4a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801df4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801df8:	74 1c                	je     801e16 <print_mem_block_lists+0x114>
  801dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfd:	8b 50 08             	mov    0x8(%eax),%edx
  801e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e03:	8b 48 08             	mov    0x8(%eax),%ecx
  801e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e09:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0c:	01 c8                	add    %ecx,%eax
  801e0e:	39 c2                	cmp    %eax,%edx
  801e10:	73 04                	jae    801e16 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e12:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e19:	8b 50 08             	mov    0x8(%eax),%edx
  801e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e22:	01 c2                	add    %eax,%edx
  801e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e27:	8b 40 08             	mov    0x8(%eax),%eax
  801e2a:	83 ec 04             	sub    $0x4,%esp
  801e2d:	52                   	push   %edx
  801e2e:	50                   	push   %eax
  801e2f:	68 69 3e 80 00       	push   $0x803e69
  801e34:	e8 fa e6 ff ff       	call   800533 <cprintf>
  801e39:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e42:	a1 48 40 80 00       	mov    0x804048,%eax
  801e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e4e:	74 07                	je     801e57 <print_mem_block_lists+0x155>
  801e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e53:	8b 00                	mov    (%eax),%eax
  801e55:	eb 05                	jmp    801e5c <print_mem_block_lists+0x15a>
  801e57:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5c:	a3 48 40 80 00       	mov    %eax,0x804048
  801e61:	a1 48 40 80 00       	mov    0x804048,%eax
  801e66:	85 c0                	test   %eax,%eax
  801e68:	75 8a                	jne    801df4 <print_mem_block_lists+0xf2>
  801e6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e6e:	75 84                	jne    801df4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e70:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e74:	75 10                	jne    801e86 <print_mem_block_lists+0x184>
  801e76:	83 ec 0c             	sub    $0xc,%esp
  801e79:	68 b4 3e 80 00       	push   $0x803eb4
  801e7e:	e8 b0 e6 ff ff       	call   800533 <cprintf>
  801e83:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	68 28 3e 80 00       	push   $0x803e28
  801e8e:	e8 a0 e6 ff ff       	call   800533 <cprintf>
  801e93:	83 c4 10             	add    $0x10,%esp

}
  801e96:	90                   	nop
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e9f:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ea6:	00 00 00 
  801ea9:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801eb0:	00 00 00 
  801eb3:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801eba:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ebd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ec4:	e9 9e 00 00 00       	jmp    801f67 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ec9:	a1 50 40 80 00       	mov    0x804050,%eax
  801ece:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed1:	c1 e2 04             	shl    $0x4,%edx
  801ed4:	01 d0                	add    %edx,%eax
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	75 14                	jne    801eee <initialize_MemBlocksList+0x55>
  801eda:	83 ec 04             	sub    $0x4,%esp
  801edd:	68 dc 3e 80 00       	push   $0x803edc
  801ee2:	6a 46                	push   $0x46
  801ee4:	68 ff 3e 80 00       	push   $0x803eff
  801ee9:	e8 91 e3 ff ff       	call   80027f <_panic>
  801eee:	a1 50 40 80 00       	mov    0x804050,%eax
  801ef3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef6:	c1 e2 04             	shl    $0x4,%edx
  801ef9:	01 d0                	add    %edx,%eax
  801efb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f01:	89 10                	mov    %edx,(%eax)
  801f03:	8b 00                	mov    (%eax),%eax
  801f05:	85 c0                	test   %eax,%eax
  801f07:	74 18                	je     801f21 <initialize_MemBlocksList+0x88>
  801f09:	a1 48 41 80 00       	mov    0x804148,%eax
  801f0e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f14:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f17:	c1 e1 04             	shl    $0x4,%ecx
  801f1a:	01 ca                	add    %ecx,%edx
  801f1c:	89 50 04             	mov    %edx,0x4(%eax)
  801f1f:	eb 12                	jmp    801f33 <initialize_MemBlocksList+0x9a>
  801f21:	a1 50 40 80 00       	mov    0x804050,%eax
  801f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f29:	c1 e2 04             	shl    $0x4,%edx
  801f2c:	01 d0                	add    %edx,%eax
  801f2e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f33:	a1 50 40 80 00       	mov    0x804050,%eax
  801f38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3b:	c1 e2 04             	shl    $0x4,%edx
  801f3e:	01 d0                	add    %edx,%eax
  801f40:	a3 48 41 80 00       	mov    %eax,0x804148
  801f45:	a1 50 40 80 00       	mov    0x804050,%eax
  801f4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4d:	c1 e2 04             	shl    $0x4,%edx
  801f50:	01 d0                	add    %edx,%eax
  801f52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f59:	a1 54 41 80 00       	mov    0x804154,%eax
  801f5e:	40                   	inc    %eax
  801f5f:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f64:	ff 45 f4             	incl   -0xc(%ebp)
  801f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f6d:	0f 82 56 ff ff ff    	jb     801ec9 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f73:	90                   	nop
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	8b 00                	mov    (%eax),%eax
  801f81:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f84:	eb 19                	jmp    801f9f <find_block+0x29>
	{
		if(va==point->sva)
  801f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f89:	8b 40 08             	mov    0x8(%eax),%eax
  801f8c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f8f:	75 05                	jne    801f96 <find_block+0x20>
		   return point;
  801f91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f94:	eb 36                	jmp    801fcc <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	8b 40 08             	mov    0x8(%eax),%eax
  801f9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f9f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fa3:	74 07                	je     801fac <find_block+0x36>
  801fa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa8:	8b 00                	mov    (%eax),%eax
  801faa:	eb 05                	jmp    801fb1 <find_block+0x3b>
  801fac:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb4:	89 42 08             	mov    %eax,0x8(%edx)
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	8b 40 08             	mov    0x8(%eax),%eax
  801fbd:	85 c0                	test   %eax,%eax
  801fbf:	75 c5                	jne    801f86 <find_block+0x10>
  801fc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fc5:	75 bf                	jne    801f86 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fd4:	a1 40 40 80 00       	mov    0x804040,%eax
  801fd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fdc:	a1 44 40 80 00       	mov    0x804044,%eax
  801fe1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fea:	74 24                	je     802010 <insert_sorted_allocList+0x42>
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	8b 50 08             	mov    0x8(%eax),%edx
  801ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff5:	8b 40 08             	mov    0x8(%eax),%eax
  801ff8:	39 c2                	cmp    %eax,%edx
  801ffa:	76 14                	jbe    802010 <insert_sorted_allocList+0x42>
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	8b 50 08             	mov    0x8(%eax),%edx
  802002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802005:	8b 40 08             	mov    0x8(%eax),%eax
  802008:	39 c2                	cmp    %eax,%edx
  80200a:	0f 82 60 01 00 00    	jb     802170 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802010:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802014:	75 65                	jne    80207b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802016:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80201a:	75 14                	jne    802030 <insert_sorted_allocList+0x62>
  80201c:	83 ec 04             	sub    $0x4,%esp
  80201f:	68 dc 3e 80 00       	push   $0x803edc
  802024:	6a 6b                	push   $0x6b
  802026:	68 ff 3e 80 00       	push   $0x803eff
  80202b:	e8 4f e2 ff ff       	call   80027f <_panic>
  802030:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	89 10                	mov    %edx,(%eax)
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	8b 00                	mov    (%eax),%eax
  802040:	85 c0                	test   %eax,%eax
  802042:	74 0d                	je     802051 <insert_sorted_allocList+0x83>
  802044:	a1 40 40 80 00       	mov    0x804040,%eax
  802049:	8b 55 08             	mov    0x8(%ebp),%edx
  80204c:	89 50 04             	mov    %edx,0x4(%eax)
  80204f:	eb 08                	jmp    802059 <insert_sorted_allocList+0x8b>
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	a3 44 40 80 00       	mov    %eax,0x804044
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	a3 40 40 80 00       	mov    %eax,0x804040
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80206b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802070:	40                   	inc    %eax
  802071:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802076:	e9 dc 01 00 00       	jmp    802257 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	8b 50 08             	mov    0x8(%eax),%edx
  802081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802084:	8b 40 08             	mov    0x8(%eax),%eax
  802087:	39 c2                	cmp    %eax,%edx
  802089:	77 6c                	ja     8020f7 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80208b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80208f:	74 06                	je     802097 <insert_sorted_allocList+0xc9>
  802091:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802095:	75 14                	jne    8020ab <insert_sorted_allocList+0xdd>
  802097:	83 ec 04             	sub    $0x4,%esp
  80209a:	68 18 3f 80 00       	push   $0x803f18
  80209f:	6a 6f                	push   $0x6f
  8020a1:	68 ff 3e 80 00       	push   $0x803eff
  8020a6:	e8 d4 e1 ff ff       	call   80027f <_panic>
  8020ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ae:	8b 50 04             	mov    0x4(%eax),%edx
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	89 50 04             	mov    %edx,0x4(%eax)
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020bd:	89 10                	mov    %edx,(%eax)
  8020bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c2:	8b 40 04             	mov    0x4(%eax),%eax
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	74 0d                	je     8020d6 <insert_sorted_allocList+0x108>
  8020c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cc:	8b 40 04             	mov    0x4(%eax),%eax
  8020cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d2:	89 10                	mov    %edx,(%eax)
  8020d4:	eb 08                	jmp    8020de <insert_sorted_allocList+0x110>
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	a3 40 40 80 00       	mov    %eax,0x804040
  8020de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e4:	89 50 04             	mov    %edx,0x4(%eax)
  8020e7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020ec:	40                   	inc    %eax
  8020ed:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020f2:	e9 60 01 00 00       	jmp    802257 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	8b 50 08             	mov    0x8(%eax),%edx
  8020fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802100:	8b 40 08             	mov    0x8(%eax),%eax
  802103:	39 c2                	cmp    %eax,%edx
  802105:	0f 82 4c 01 00 00    	jb     802257 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80210b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80210f:	75 14                	jne    802125 <insert_sorted_allocList+0x157>
  802111:	83 ec 04             	sub    $0x4,%esp
  802114:	68 50 3f 80 00       	push   $0x803f50
  802119:	6a 73                	push   $0x73
  80211b:	68 ff 3e 80 00       	push   $0x803eff
  802120:	e8 5a e1 ff ff       	call   80027f <_panic>
  802125:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	89 50 04             	mov    %edx,0x4(%eax)
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	8b 40 04             	mov    0x4(%eax),%eax
  802137:	85 c0                	test   %eax,%eax
  802139:	74 0c                	je     802147 <insert_sorted_allocList+0x179>
  80213b:	a1 44 40 80 00       	mov    0x804044,%eax
  802140:	8b 55 08             	mov    0x8(%ebp),%edx
  802143:	89 10                	mov    %edx,(%eax)
  802145:	eb 08                	jmp    80214f <insert_sorted_allocList+0x181>
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	a3 40 40 80 00       	mov    %eax,0x804040
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	a3 44 40 80 00       	mov    %eax,0x804044
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802160:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802165:	40                   	inc    %eax
  802166:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80216b:	e9 e7 00 00 00       	jmp    802257 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802173:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802176:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80217d:	a1 40 40 80 00       	mov    0x804040,%eax
  802182:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802185:	e9 9d 00 00 00       	jmp    802227 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 00                	mov    (%eax),%eax
  80218f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	8b 50 08             	mov    0x8(%eax),%edx
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	8b 40 08             	mov    0x8(%eax),%eax
  80219e:	39 c2                	cmp    %eax,%edx
  8021a0:	76 7d                	jbe    80221f <insert_sorted_allocList+0x251>
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	8b 50 08             	mov    0x8(%eax),%edx
  8021a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ab:	8b 40 08             	mov    0x8(%eax),%eax
  8021ae:	39 c2                	cmp    %eax,%edx
  8021b0:	73 6d                	jae    80221f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b6:	74 06                	je     8021be <insert_sorted_allocList+0x1f0>
  8021b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021bc:	75 14                	jne    8021d2 <insert_sorted_allocList+0x204>
  8021be:	83 ec 04             	sub    $0x4,%esp
  8021c1:	68 74 3f 80 00       	push   $0x803f74
  8021c6:	6a 7f                	push   $0x7f
  8021c8:	68 ff 3e 80 00       	push   $0x803eff
  8021cd:	e8 ad e0 ff ff       	call   80027f <_panic>
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d5:	8b 10                	mov    (%eax),%edx
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	89 10                	mov    %edx,(%eax)
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	8b 00                	mov    (%eax),%eax
  8021e1:	85 c0                	test   %eax,%eax
  8021e3:	74 0b                	je     8021f0 <insert_sorted_allocList+0x222>
  8021e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e8:	8b 00                	mov    (%eax),%eax
  8021ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ed:	89 50 04             	mov    %edx,0x4(%eax)
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f6:	89 10                	mov    %edx,(%eax)
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fe:	89 50 04             	mov    %edx,0x4(%eax)
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	8b 00                	mov    (%eax),%eax
  802206:	85 c0                	test   %eax,%eax
  802208:	75 08                	jne    802212 <insert_sorted_allocList+0x244>
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	a3 44 40 80 00       	mov    %eax,0x804044
  802212:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802217:	40                   	inc    %eax
  802218:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80221d:	eb 39                	jmp    802258 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80221f:	a1 48 40 80 00       	mov    0x804048,%eax
  802224:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222b:	74 07                	je     802234 <insert_sorted_allocList+0x266>
  80222d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802230:	8b 00                	mov    (%eax),%eax
  802232:	eb 05                	jmp    802239 <insert_sorted_allocList+0x26b>
  802234:	b8 00 00 00 00       	mov    $0x0,%eax
  802239:	a3 48 40 80 00       	mov    %eax,0x804048
  80223e:	a1 48 40 80 00       	mov    0x804048,%eax
  802243:	85 c0                	test   %eax,%eax
  802245:	0f 85 3f ff ff ff    	jne    80218a <insert_sorted_allocList+0x1bc>
  80224b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224f:	0f 85 35 ff ff ff    	jne    80218a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802255:	eb 01                	jmp    802258 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802257:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802258:	90                   	nop
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802261:	a1 38 41 80 00       	mov    0x804138,%eax
  802266:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802269:	e9 85 01 00 00       	jmp    8023f3 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80226e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802271:	8b 40 0c             	mov    0xc(%eax),%eax
  802274:	3b 45 08             	cmp    0x8(%ebp),%eax
  802277:	0f 82 6e 01 00 00    	jb     8023eb <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 40 0c             	mov    0xc(%eax),%eax
  802283:	3b 45 08             	cmp    0x8(%ebp),%eax
  802286:	0f 85 8a 00 00 00    	jne    802316 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80228c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802290:	75 17                	jne    8022a9 <alloc_block_FF+0x4e>
  802292:	83 ec 04             	sub    $0x4,%esp
  802295:	68 a8 3f 80 00       	push   $0x803fa8
  80229a:	68 93 00 00 00       	push   $0x93
  80229f:	68 ff 3e 80 00       	push   $0x803eff
  8022a4:	e8 d6 df ff ff       	call   80027f <_panic>
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 00                	mov    (%eax),%eax
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	74 10                	je     8022c2 <alloc_block_FF+0x67>
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	8b 00                	mov    (%eax),%eax
  8022b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ba:	8b 52 04             	mov    0x4(%edx),%edx
  8022bd:	89 50 04             	mov    %edx,0x4(%eax)
  8022c0:	eb 0b                	jmp    8022cd <alloc_block_FF+0x72>
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	8b 40 04             	mov    0x4(%eax),%eax
  8022c8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	8b 40 04             	mov    0x4(%eax),%eax
  8022d3:	85 c0                	test   %eax,%eax
  8022d5:	74 0f                	je     8022e6 <alloc_block_FF+0x8b>
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 40 04             	mov    0x4(%eax),%eax
  8022dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e0:	8b 12                	mov    (%edx),%edx
  8022e2:	89 10                	mov    %edx,(%eax)
  8022e4:	eb 0a                	jmp    8022f0 <alloc_block_FF+0x95>
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 00                	mov    (%eax),%eax
  8022eb:	a3 38 41 80 00       	mov    %eax,0x804138
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802303:	a1 44 41 80 00       	mov    0x804144,%eax
  802308:	48                   	dec    %eax
  802309:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	e9 10 01 00 00       	jmp    802426 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 40 0c             	mov    0xc(%eax),%eax
  80231c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80231f:	0f 86 c6 00 00 00    	jbe    8023eb <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802325:	a1 48 41 80 00       	mov    0x804148,%eax
  80232a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 50 08             	mov    0x8(%eax),%edx
  802333:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802336:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233c:	8b 55 08             	mov    0x8(%ebp),%edx
  80233f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802342:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802346:	75 17                	jne    80235f <alloc_block_FF+0x104>
  802348:	83 ec 04             	sub    $0x4,%esp
  80234b:	68 a8 3f 80 00       	push   $0x803fa8
  802350:	68 9b 00 00 00       	push   $0x9b
  802355:	68 ff 3e 80 00       	push   $0x803eff
  80235a:	e8 20 df ff ff       	call   80027f <_panic>
  80235f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802362:	8b 00                	mov    (%eax),%eax
  802364:	85 c0                	test   %eax,%eax
  802366:	74 10                	je     802378 <alloc_block_FF+0x11d>
  802368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236b:	8b 00                	mov    (%eax),%eax
  80236d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802370:	8b 52 04             	mov    0x4(%edx),%edx
  802373:	89 50 04             	mov    %edx,0x4(%eax)
  802376:	eb 0b                	jmp    802383 <alloc_block_FF+0x128>
  802378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237b:	8b 40 04             	mov    0x4(%eax),%eax
  80237e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802386:	8b 40 04             	mov    0x4(%eax),%eax
  802389:	85 c0                	test   %eax,%eax
  80238b:	74 0f                	je     80239c <alloc_block_FF+0x141>
  80238d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802390:	8b 40 04             	mov    0x4(%eax),%eax
  802393:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802396:	8b 12                	mov    (%edx),%edx
  802398:	89 10                	mov    %edx,(%eax)
  80239a:	eb 0a                	jmp    8023a6 <alloc_block_FF+0x14b>
  80239c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239f:	8b 00                	mov    (%eax),%eax
  8023a1:	a3 48 41 80 00       	mov    %eax,0x804148
  8023a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b9:	a1 54 41 80 00       	mov    0x804154,%eax
  8023be:	48                   	dec    %eax
  8023bf:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 50 08             	mov    0x8(%eax),%edx
  8023ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cd:	01 c2                	add    %eax,%edx
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023db:	2b 45 08             	sub    0x8(%ebp),%eax
  8023de:	89 c2                	mov    %eax,%edx
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e9:	eb 3b                	jmp    802426 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8023f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f7:	74 07                	je     802400 <alloc_block_FF+0x1a5>
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 00                	mov    (%eax),%eax
  8023fe:	eb 05                	jmp    802405 <alloc_block_FF+0x1aa>
  802400:	b8 00 00 00 00       	mov    $0x0,%eax
  802405:	a3 40 41 80 00       	mov    %eax,0x804140
  80240a:	a1 40 41 80 00       	mov    0x804140,%eax
  80240f:	85 c0                	test   %eax,%eax
  802411:	0f 85 57 fe ff ff    	jne    80226e <alloc_block_FF+0x13>
  802417:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241b:	0f 85 4d fe ff ff    	jne    80226e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802421:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80242e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802435:	a1 38 41 80 00       	mov    0x804138,%eax
  80243a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243d:	e9 df 00 00 00       	jmp    802521 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802445:	8b 40 0c             	mov    0xc(%eax),%eax
  802448:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244b:	0f 82 c8 00 00 00    	jb     802519 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	8b 40 0c             	mov    0xc(%eax),%eax
  802457:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245a:	0f 85 8a 00 00 00    	jne    8024ea <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802460:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802464:	75 17                	jne    80247d <alloc_block_BF+0x55>
  802466:	83 ec 04             	sub    $0x4,%esp
  802469:	68 a8 3f 80 00       	push   $0x803fa8
  80246e:	68 b7 00 00 00       	push   $0xb7
  802473:	68 ff 3e 80 00       	push   $0x803eff
  802478:	e8 02 de ff ff       	call   80027f <_panic>
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	85 c0                	test   %eax,%eax
  802484:	74 10                	je     802496 <alloc_block_BF+0x6e>
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	8b 00                	mov    (%eax),%eax
  80248b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248e:	8b 52 04             	mov    0x4(%edx),%edx
  802491:	89 50 04             	mov    %edx,0x4(%eax)
  802494:	eb 0b                	jmp    8024a1 <alloc_block_BF+0x79>
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	8b 40 04             	mov    0x4(%eax),%eax
  80249c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	74 0f                	je     8024ba <alloc_block_BF+0x92>
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 40 04             	mov    0x4(%eax),%eax
  8024b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b4:	8b 12                	mov    (%edx),%edx
  8024b6:	89 10                	mov    %edx,(%eax)
  8024b8:	eb 0a                	jmp    8024c4 <alloc_block_BF+0x9c>
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 00                	mov    (%eax),%eax
  8024bf:	a3 38 41 80 00       	mov    %eax,0x804138
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d7:	a1 44 41 80 00       	mov    0x804144,%eax
  8024dc:	48                   	dec    %eax
  8024dd:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	e9 4d 01 00 00       	jmp    802637 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f3:	76 24                	jbe    802519 <alloc_block_BF+0xf1>
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024fe:	73 19                	jae    802519 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802500:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 40 0c             	mov    0xc(%eax),%eax
  80250d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 40 08             	mov    0x8(%eax),%eax
  802516:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802519:	a1 40 41 80 00       	mov    0x804140,%eax
  80251e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802521:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802525:	74 07                	je     80252e <alloc_block_BF+0x106>
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	eb 05                	jmp    802533 <alloc_block_BF+0x10b>
  80252e:	b8 00 00 00 00       	mov    $0x0,%eax
  802533:	a3 40 41 80 00       	mov    %eax,0x804140
  802538:	a1 40 41 80 00       	mov    0x804140,%eax
  80253d:	85 c0                	test   %eax,%eax
  80253f:	0f 85 fd fe ff ff    	jne    802442 <alloc_block_BF+0x1a>
  802545:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802549:	0f 85 f3 fe ff ff    	jne    802442 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80254f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802553:	0f 84 d9 00 00 00    	je     802632 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802559:	a1 48 41 80 00       	mov    0x804148,%eax
  80255e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802564:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802567:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80256a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256d:	8b 55 08             	mov    0x8(%ebp),%edx
  802570:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802573:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802577:	75 17                	jne    802590 <alloc_block_BF+0x168>
  802579:	83 ec 04             	sub    $0x4,%esp
  80257c:	68 a8 3f 80 00       	push   $0x803fa8
  802581:	68 c7 00 00 00       	push   $0xc7
  802586:	68 ff 3e 80 00       	push   $0x803eff
  80258b:	e8 ef dc ff ff       	call   80027f <_panic>
  802590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802593:	8b 00                	mov    (%eax),%eax
  802595:	85 c0                	test   %eax,%eax
  802597:	74 10                	je     8025a9 <alloc_block_BF+0x181>
  802599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259c:	8b 00                	mov    (%eax),%eax
  80259e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a1:	8b 52 04             	mov    0x4(%edx),%edx
  8025a4:	89 50 04             	mov    %edx,0x4(%eax)
  8025a7:	eb 0b                	jmp    8025b4 <alloc_block_BF+0x18c>
  8025a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ac:	8b 40 04             	mov    0x4(%eax),%eax
  8025af:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	74 0f                	je     8025cd <alloc_block_BF+0x1a5>
  8025be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c1:	8b 40 04             	mov    0x4(%eax),%eax
  8025c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025c7:	8b 12                	mov    (%edx),%edx
  8025c9:	89 10                	mov    %edx,(%eax)
  8025cb:	eb 0a                	jmp    8025d7 <alloc_block_BF+0x1af>
  8025cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d0:	8b 00                	mov    (%eax),%eax
  8025d2:	a3 48 41 80 00       	mov    %eax,0x804148
  8025d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8025ef:	48                   	dec    %eax
  8025f0:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025f5:	83 ec 08             	sub    $0x8,%esp
  8025f8:	ff 75 ec             	pushl  -0x14(%ebp)
  8025fb:	68 38 41 80 00       	push   $0x804138
  802600:	e8 71 f9 ff ff       	call   801f76 <find_block>
  802605:	83 c4 10             	add    $0x10,%esp
  802608:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80260b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80260e:	8b 50 08             	mov    0x8(%eax),%edx
  802611:	8b 45 08             	mov    0x8(%ebp),%eax
  802614:	01 c2                	add    %eax,%edx
  802616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802619:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80261c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261f:	8b 40 0c             	mov    0xc(%eax),%eax
  802622:	2b 45 08             	sub    0x8(%ebp),%eax
  802625:	89 c2                	mov    %eax,%edx
  802627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80262d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802630:	eb 05                	jmp    802637 <alloc_block_BF+0x20f>
	}
	return NULL;
  802632:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802637:	c9                   	leave  
  802638:	c3                   	ret    

00802639 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
  80263c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80263f:	a1 28 40 80 00       	mov    0x804028,%eax
  802644:	85 c0                	test   %eax,%eax
  802646:	0f 85 de 01 00 00    	jne    80282a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80264c:	a1 38 41 80 00       	mov    0x804138,%eax
  802651:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802654:	e9 9e 01 00 00       	jmp    8027f7 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 40 0c             	mov    0xc(%eax),%eax
  80265f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802662:	0f 82 87 01 00 00    	jb     8027ef <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 0c             	mov    0xc(%eax),%eax
  80266e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802671:	0f 85 95 00 00 00    	jne    80270c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267b:	75 17                	jne    802694 <alloc_block_NF+0x5b>
  80267d:	83 ec 04             	sub    $0x4,%esp
  802680:	68 a8 3f 80 00       	push   $0x803fa8
  802685:	68 e0 00 00 00       	push   $0xe0
  80268a:	68 ff 3e 80 00       	push   $0x803eff
  80268f:	e8 eb db ff ff       	call   80027f <_panic>
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	8b 00                	mov    (%eax),%eax
  802699:	85 c0                	test   %eax,%eax
  80269b:	74 10                	je     8026ad <alloc_block_NF+0x74>
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	8b 00                	mov    (%eax),%eax
  8026a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a5:	8b 52 04             	mov    0x4(%edx),%edx
  8026a8:	89 50 04             	mov    %edx,0x4(%eax)
  8026ab:	eb 0b                	jmp    8026b8 <alloc_block_NF+0x7f>
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 40 04             	mov    0x4(%eax),%eax
  8026b3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 40 04             	mov    0x4(%eax),%eax
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	74 0f                	je     8026d1 <alloc_block_NF+0x98>
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 40 04             	mov    0x4(%eax),%eax
  8026c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cb:	8b 12                	mov    (%edx),%edx
  8026cd:	89 10                	mov    %edx,(%eax)
  8026cf:	eb 0a                	jmp    8026db <alloc_block_NF+0xa2>
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 00                	mov    (%eax),%eax
  8026d6:	a3 38 41 80 00       	mov    %eax,0x804138
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ee:	a1 44 41 80 00       	mov    0x804144,%eax
  8026f3:	48                   	dec    %eax
  8026f4:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 40 08             	mov    0x8(%eax),%eax
  8026ff:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	e9 f8 04 00 00       	jmp    802c04 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 40 0c             	mov    0xc(%eax),%eax
  802712:	3b 45 08             	cmp    0x8(%ebp),%eax
  802715:	0f 86 d4 00 00 00    	jbe    8027ef <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80271b:	a1 48 41 80 00       	mov    0x804148,%eax
  802720:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	8b 50 08             	mov    0x8(%eax),%edx
  802729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80272f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802732:	8b 55 08             	mov    0x8(%ebp),%edx
  802735:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802738:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80273c:	75 17                	jne    802755 <alloc_block_NF+0x11c>
  80273e:	83 ec 04             	sub    $0x4,%esp
  802741:	68 a8 3f 80 00       	push   $0x803fa8
  802746:	68 e9 00 00 00       	push   $0xe9
  80274b:	68 ff 3e 80 00       	push   $0x803eff
  802750:	e8 2a db ff ff       	call   80027f <_panic>
  802755:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802758:	8b 00                	mov    (%eax),%eax
  80275a:	85 c0                	test   %eax,%eax
  80275c:	74 10                	je     80276e <alloc_block_NF+0x135>
  80275e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802761:	8b 00                	mov    (%eax),%eax
  802763:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802766:	8b 52 04             	mov    0x4(%edx),%edx
  802769:	89 50 04             	mov    %edx,0x4(%eax)
  80276c:	eb 0b                	jmp    802779 <alloc_block_NF+0x140>
  80276e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802771:	8b 40 04             	mov    0x4(%eax),%eax
  802774:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277c:	8b 40 04             	mov    0x4(%eax),%eax
  80277f:	85 c0                	test   %eax,%eax
  802781:	74 0f                	je     802792 <alloc_block_NF+0x159>
  802783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802786:	8b 40 04             	mov    0x4(%eax),%eax
  802789:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80278c:	8b 12                	mov    (%edx),%edx
  80278e:	89 10                	mov    %edx,(%eax)
  802790:	eb 0a                	jmp    80279c <alloc_block_NF+0x163>
  802792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802795:	8b 00                	mov    (%eax),%eax
  802797:	a3 48 41 80 00       	mov    %eax,0x804148
  80279c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027af:	a1 54 41 80 00       	mov    0x804154,%eax
  8027b4:	48                   	dec    %eax
  8027b5:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8027ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bd:	8b 40 08             	mov    0x8(%eax),%eax
  8027c0:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 50 08             	mov    0x8(%eax),%edx
  8027cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ce:	01 c2                	add    %eax,%edx
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dc:	2b 45 08             	sub    0x8(%ebp),%eax
  8027df:	89 c2                	mov    %eax,%edx
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ea:	e9 15 04 00 00       	jmp    802c04 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027ef:	a1 40 41 80 00       	mov    0x804140,%eax
  8027f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fb:	74 07                	je     802804 <alloc_block_NF+0x1cb>
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 00                	mov    (%eax),%eax
  802802:	eb 05                	jmp    802809 <alloc_block_NF+0x1d0>
  802804:	b8 00 00 00 00       	mov    $0x0,%eax
  802809:	a3 40 41 80 00       	mov    %eax,0x804140
  80280e:	a1 40 41 80 00       	mov    0x804140,%eax
  802813:	85 c0                	test   %eax,%eax
  802815:	0f 85 3e fe ff ff    	jne    802659 <alloc_block_NF+0x20>
  80281b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281f:	0f 85 34 fe ff ff    	jne    802659 <alloc_block_NF+0x20>
  802825:	e9 d5 03 00 00       	jmp    802bff <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80282a:	a1 38 41 80 00       	mov    0x804138,%eax
  80282f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802832:	e9 b1 01 00 00       	jmp    8029e8 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 50 08             	mov    0x8(%eax),%edx
  80283d:	a1 28 40 80 00       	mov    0x804028,%eax
  802842:	39 c2                	cmp    %eax,%edx
  802844:	0f 82 96 01 00 00    	jb     8029e0 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 40 0c             	mov    0xc(%eax),%eax
  802850:	3b 45 08             	cmp    0x8(%ebp),%eax
  802853:	0f 82 87 01 00 00    	jb     8029e0 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 40 0c             	mov    0xc(%eax),%eax
  80285f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802862:	0f 85 95 00 00 00    	jne    8028fd <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286c:	75 17                	jne    802885 <alloc_block_NF+0x24c>
  80286e:	83 ec 04             	sub    $0x4,%esp
  802871:	68 a8 3f 80 00       	push   $0x803fa8
  802876:	68 fc 00 00 00       	push   $0xfc
  80287b:	68 ff 3e 80 00       	push   $0x803eff
  802880:	e8 fa d9 ff ff       	call   80027f <_panic>
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 00                	mov    (%eax),%eax
  80288a:	85 c0                	test   %eax,%eax
  80288c:	74 10                	je     80289e <alloc_block_NF+0x265>
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 00                	mov    (%eax),%eax
  802893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802896:	8b 52 04             	mov    0x4(%edx),%edx
  802899:	89 50 04             	mov    %edx,0x4(%eax)
  80289c:	eb 0b                	jmp    8028a9 <alloc_block_NF+0x270>
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 40 04             	mov    0x4(%eax),%eax
  8028a4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 0f                	je     8028c2 <alloc_block_NF+0x289>
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 40 04             	mov    0x4(%eax),%eax
  8028b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bc:	8b 12                	mov    (%edx),%edx
  8028be:	89 10                	mov    %edx,(%eax)
  8028c0:	eb 0a                	jmp    8028cc <alloc_block_NF+0x293>
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	a3 38 41 80 00       	mov    %eax,0x804138
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028df:	a1 44 41 80 00       	mov    0x804144,%eax
  8028e4:	48                   	dec    %eax
  8028e5:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	8b 40 08             	mov    0x8(%eax),%eax
  8028f0:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	e9 07 03 00 00       	jmp    802c04 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 40 0c             	mov    0xc(%eax),%eax
  802903:	3b 45 08             	cmp    0x8(%ebp),%eax
  802906:	0f 86 d4 00 00 00    	jbe    8029e0 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80290c:	a1 48 41 80 00       	mov    0x804148,%eax
  802911:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802917:	8b 50 08             	mov    0x8(%eax),%edx
  80291a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802920:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802923:	8b 55 08             	mov    0x8(%ebp),%edx
  802926:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802929:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80292d:	75 17                	jne    802946 <alloc_block_NF+0x30d>
  80292f:	83 ec 04             	sub    $0x4,%esp
  802932:	68 a8 3f 80 00       	push   $0x803fa8
  802937:	68 04 01 00 00       	push   $0x104
  80293c:	68 ff 3e 80 00       	push   $0x803eff
  802941:	e8 39 d9 ff ff       	call   80027f <_panic>
  802946:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	85 c0                	test   %eax,%eax
  80294d:	74 10                	je     80295f <alloc_block_NF+0x326>
  80294f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802952:	8b 00                	mov    (%eax),%eax
  802954:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802957:	8b 52 04             	mov    0x4(%edx),%edx
  80295a:	89 50 04             	mov    %edx,0x4(%eax)
  80295d:	eb 0b                	jmp    80296a <alloc_block_NF+0x331>
  80295f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802962:	8b 40 04             	mov    0x4(%eax),%eax
  802965:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80296a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296d:	8b 40 04             	mov    0x4(%eax),%eax
  802970:	85 c0                	test   %eax,%eax
  802972:	74 0f                	je     802983 <alloc_block_NF+0x34a>
  802974:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802977:	8b 40 04             	mov    0x4(%eax),%eax
  80297a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80297d:	8b 12                	mov    (%edx),%edx
  80297f:	89 10                	mov    %edx,(%eax)
  802981:	eb 0a                	jmp    80298d <alloc_block_NF+0x354>
  802983:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	a3 48 41 80 00       	mov    %eax,0x804148
  80298d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802996:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802999:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a0:	a1 54 41 80 00       	mov    0x804154,%eax
  8029a5:	48                   	dec    %eax
  8029a6:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8029ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ae:	8b 40 08             	mov    0x8(%eax),%eax
  8029b1:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	8b 50 08             	mov    0x8(%eax),%edx
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	01 c2                	add    %eax,%edx
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cd:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d0:	89 c2                	mov    %eax,%edx
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029db:	e9 24 02 00 00       	jmp    802c04 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029e0:	a1 40 41 80 00       	mov    0x804140,%eax
  8029e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ec:	74 07                	je     8029f5 <alloc_block_NF+0x3bc>
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 00                	mov    (%eax),%eax
  8029f3:	eb 05                	jmp    8029fa <alloc_block_NF+0x3c1>
  8029f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fa:	a3 40 41 80 00       	mov    %eax,0x804140
  8029ff:	a1 40 41 80 00       	mov    0x804140,%eax
  802a04:	85 c0                	test   %eax,%eax
  802a06:	0f 85 2b fe ff ff    	jne    802837 <alloc_block_NF+0x1fe>
  802a0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a10:	0f 85 21 fe ff ff    	jne    802837 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a16:	a1 38 41 80 00       	mov    0x804138,%eax
  802a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1e:	e9 ae 01 00 00       	jmp    802bd1 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 50 08             	mov    0x8(%eax),%edx
  802a29:	a1 28 40 80 00       	mov    0x804028,%eax
  802a2e:	39 c2                	cmp    %eax,%edx
  802a30:	0f 83 93 01 00 00    	jae    802bc9 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a3f:	0f 82 84 01 00 00    	jb     802bc9 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4e:	0f 85 95 00 00 00    	jne    802ae9 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a58:	75 17                	jne    802a71 <alloc_block_NF+0x438>
  802a5a:	83 ec 04             	sub    $0x4,%esp
  802a5d:	68 a8 3f 80 00       	push   $0x803fa8
  802a62:	68 14 01 00 00       	push   $0x114
  802a67:	68 ff 3e 80 00       	push   $0x803eff
  802a6c:	e8 0e d8 ff ff       	call   80027f <_panic>
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 00                	mov    (%eax),%eax
  802a76:	85 c0                	test   %eax,%eax
  802a78:	74 10                	je     802a8a <alloc_block_NF+0x451>
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 00                	mov    (%eax),%eax
  802a7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a82:	8b 52 04             	mov    0x4(%edx),%edx
  802a85:	89 50 04             	mov    %edx,0x4(%eax)
  802a88:	eb 0b                	jmp    802a95 <alloc_block_NF+0x45c>
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	8b 40 04             	mov    0x4(%eax),%eax
  802a90:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 40 04             	mov    0x4(%eax),%eax
  802a9b:	85 c0                	test   %eax,%eax
  802a9d:	74 0f                	je     802aae <alloc_block_NF+0x475>
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 40 04             	mov    0x4(%eax),%eax
  802aa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa8:	8b 12                	mov    (%edx),%edx
  802aaa:	89 10                	mov    %edx,(%eax)
  802aac:	eb 0a                	jmp    802ab8 <alloc_block_NF+0x47f>
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 00                	mov    (%eax),%eax
  802ab3:	a3 38 41 80 00       	mov    %eax,0x804138
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acb:	a1 44 41 80 00       	mov    0x804144,%eax
  802ad0:	48                   	dec    %eax
  802ad1:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 40 08             	mov    0x8(%eax),%eax
  802adc:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	e9 1b 01 00 00       	jmp    802c04 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 40 0c             	mov    0xc(%eax),%eax
  802aef:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af2:	0f 86 d1 00 00 00    	jbe    802bc9 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802af8:	a1 48 41 80 00       	mov    0x804148,%eax
  802afd:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 50 08             	mov    0x8(%eax),%edx
  802b06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b09:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b12:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b19:	75 17                	jne    802b32 <alloc_block_NF+0x4f9>
  802b1b:	83 ec 04             	sub    $0x4,%esp
  802b1e:	68 a8 3f 80 00       	push   $0x803fa8
  802b23:	68 1c 01 00 00       	push   $0x11c
  802b28:	68 ff 3e 80 00       	push   $0x803eff
  802b2d:	e8 4d d7 ff ff       	call   80027f <_panic>
  802b32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b35:	8b 00                	mov    (%eax),%eax
  802b37:	85 c0                	test   %eax,%eax
  802b39:	74 10                	je     802b4b <alloc_block_NF+0x512>
  802b3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b43:	8b 52 04             	mov    0x4(%edx),%edx
  802b46:	89 50 04             	mov    %edx,0x4(%eax)
  802b49:	eb 0b                	jmp    802b56 <alloc_block_NF+0x51d>
  802b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4e:	8b 40 04             	mov    0x4(%eax),%eax
  802b51:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b59:	8b 40 04             	mov    0x4(%eax),%eax
  802b5c:	85 c0                	test   %eax,%eax
  802b5e:	74 0f                	je     802b6f <alloc_block_NF+0x536>
  802b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b63:	8b 40 04             	mov    0x4(%eax),%eax
  802b66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b69:	8b 12                	mov    (%edx),%edx
  802b6b:	89 10                	mov    %edx,(%eax)
  802b6d:	eb 0a                	jmp    802b79 <alloc_block_NF+0x540>
  802b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b72:	8b 00                	mov    (%eax),%eax
  802b74:	a3 48 41 80 00       	mov    %eax,0x804148
  802b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8c:	a1 54 41 80 00       	mov    0x804154,%eax
  802b91:	48                   	dec    %eax
  802b92:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9a:	8b 40 08             	mov    0x8(%eax),%eax
  802b9d:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 50 08             	mov    0x8(%eax),%edx
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	01 c2                	add    %eax,%edx
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb9:	2b 45 08             	sub    0x8(%ebp),%eax
  802bbc:	89 c2                	mov    %eax,%edx
  802bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc7:	eb 3b                	jmp    802c04 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bc9:	a1 40 41 80 00       	mov    0x804140,%eax
  802bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd5:	74 07                	je     802bde <alloc_block_NF+0x5a5>
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	eb 05                	jmp    802be3 <alloc_block_NF+0x5aa>
  802bde:	b8 00 00 00 00       	mov    $0x0,%eax
  802be3:	a3 40 41 80 00       	mov    %eax,0x804140
  802be8:	a1 40 41 80 00       	mov    0x804140,%eax
  802bed:	85 c0                	test   %eax,%eax
  802bef:	0f 85 2e fe ff ff    	jne    802a23 <alloc_block_NF+0x3ea>
  802bf5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf9:	0f 85 24 fe ff ff    	jne    802a23 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c04:	c9                   	leave  
  802c05:	c3                   	ret    

00802c06 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c06:	55                   	push   %ebp
  802c07:	89 e5                	mov    %esp,%ebp
  802c09:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c0c:	a1 38 41 80 00       	mov    0x804138,%eax
  802c11:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c14:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c19:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c1c:	a1 38 41 80 00       	mov    0x804138,%eax
  802c21:	85 c0                	test   %eax,%eax
  802c23:	74 14                	je     802c39 <insert_sorted_with_merge_freeList+0x33>
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	8b 50 08             	mov    0x8(%eax),%edx
  802c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2e:	8b 40 08             	mov    0x8(%eax),%eax
  802c31:	39 c2                	cmp    %eax,%edx
  802c33:	0f 87 9b 01 00 00    	ja     802dd4 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3d:	75 17                	jne    802c56 <insert_sorted_with_merge_freeList+0x50>
  802c3f:	83 ec 04             	sub    $0x4,%esp
  802c42:	68 dc 3e 80 00       	push   $0x803edc
  802c47:	68 38 01 00 00       	push   $0x138
  802c4c:	68 ff 3e 80 00       	push   $0x803eff
  802c51:	e8 29 d6 ff ff       	call   80027f <_panic>
  802c56:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	89 10                	mov    %edx,(%eax)
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	85 c0                	test   %eax,%eax
  802c68:	74 0d                	je     802c77 <insert_sorted_with_merge_freeList+0x71>
  802c6a:	a1 38 41 80 00       	mov    0x804138,%eax
  802c6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c72:	89 50 04             	mov    %edx,0x4(%eax)
  802c75:	eb 08                	jmp    802c7f <insert_sorted_with_merge_freeList+0x79>
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	a3 38 41 80 00       	mov    %eax,0x804138
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c91:	a1 44 41 80 00       	mov    0x804144,%eax
  802c96:	40                   	inc    %eax
  802c97:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca0:	0f 84 a8 06 00 00    	je     80334e <insert_sorted_with_merge_freeList+0x748>
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	8b 50 08             	mov    0x8(%eax),%edx
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb2:	01 c2                	add    %eax,%edx
  802cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb7:	8b 40 08             	mov    0x8(%eax),%eax
  802cba:	39 c2                	cmp    %eax,%edx
  802cbc:	0f 85 8c 06 00 00    	jne    80334e <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	8b 50 0c             	mov    0xc(%eax),%edx
  802cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cce:	01 c2                	add    %eax,%edx
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cda:	75 17                	jne    802cf3 <insert_sorted_with_merge_freeList+0xed>
  802cdc:	83 ec 04             	sub    $0x4,%esp
  802cdf:	68 a8 3f 80 00       	push   $0x803fa8
  802ce4:	68 3c 01 00 00       	push   $0x13c
  802ce9:	68 ff 3e 80 00       	push   $0x803eff
  802cee:	e8 8c d5 ff ff       	call   80027f <_panic>
  802cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	85 c0                	test   %eax,%eax
  802cfa:	74 10                	je     802d0c <insert_sorted_with_merge_freeList+0x106>
  802cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cff:	8b 00                	mov    (%eax),%eax
  802d01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d04:	8b 52 04             	mov    0x4(%edx),%edx
  802d07:	89 50 04             	mov    %edx,0x4(%eax)
  802d0a:	eb 0b                	jmp    802d17 <insert_sorted_with_merge_freeList+0x111>
  802d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0f:	8b 40 04             	mov    0x4(%eax),%eax
  802d12:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1a:	8b 40 04             	mov    0x4(%eax),%eax
  802d1d:	85 c0                	test   %eax,%eax
  802d1f:	74 0f                	je     802d30 <insert_sorted_with_merge_freeList+0x12a>
  802d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d24:	8b 40 04             	mov    0x4(%eax),%eax
  802d27:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2a:	8b 12                	mov    (%edx),%edx
  802d2c:	89 10                	mov    %edx,(%eax)
  802d2e:	eb 0a                	jmp    802d3a <insert_sorted_with_merge_freeList+0x134>
  802d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	a3 38 41 80 00       	mov    %eax,0x804138
  802d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4d:	a1 44 41 80 00       	mov    0x804144,%eax
  802d52:	48                   	dec    %eax
  802d53:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d70:	75 17                	jne    802d89 <insert_sorted_with_merge_freeList+0x183>
  802d72:	83 ec 04             	sub    $0x4,%esp
  802d75:	68 dc 3e 80 00       	push   $0x803edc
  802d7a:	68 3f 01 00 00       	push   $0x13f
  802d7f:	68 ff 3e 80 00       	push   $0x803eff
  802d84:	e8 f6 d4 ff ff       	call   80027f <_panic>
  802d89:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d92:	89 10                	mov    %edx,(%eax)
  802d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d97:	8b 00                	mov    (%eax),%eax
  802d99:	85 c0                	test   %eax,%eax
  802d9b:	74 0d                	je     802daa <insert_sorted_with_merge_freeList+0x1a4>
  802d9d:	a1 48 41 80 00       	mov    0x804148,%eax
  802da2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da5:	89 50 04             	mov    %edx,0x4(%eax)
  802da8:	eb 08                	jmp    802db2 <insert_sorted_with_merge_freeList+0x1ac>
  802daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dad:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db5:	a3 48 41 80 00       	mov    %eax,0x804148
  802dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc4:	a1 54 41 80 00       	mov    0x804154,%eax
  802dc9:	40                   	inc    %eax
  802dca:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dcf:	e9 7a 05 00 00       	jmp    80334e <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	8b 50 08             	mov    0x8(%eax),%edx
  802dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddd:	8b 40 08             	mov    0x8(%eax),%eax
  802de0:	39 c2                	cmp    %eax,%edx
  802de2:	0f 82 14 01 00 00    	jb     802efc <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802deb:	8b 50 08             	mov    0x8(%eax),%edx
  802dee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df1:	8b 40 0c             	mov    0xc(%eax),%eax
  802df4:	01 c2                	add    %eax,%edx
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	8b 40 08             	mov    0x8(%eax),%eax
  802dfc:	39 c2                	cmp    %eax,%edx
  802dfe:	0f 85 90 00 00 00    	jne    802e94 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e07:	8b 50 0c             	mov    0xc(%eax),%edx
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e10:	01 c2                	add    %eax,%edx
  802e12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e15:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e30:	75 17                	jne    802e49 <insert_sorted_with_merge_freeList+0x243>
  802e32:	83 ec 04             	sub    $0x4,%esp
  802e35:	68 dc 3e 80 00       	push   $0x803edc
  802e3a:	68 49 01 00 00       	push   $0x149
  802e3f:	68 ff 3e 80 00       	push   $0x803eff
  802e44:	e8 36 d4 ff ff       	call   80027f <_panic>
  802e49:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	89 10                	mov    %edx,(%eax)
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	85 c0                	test   %eax,%eax
  802e5b:	74 0d                	je     802e6a <insert_sorted_with_merge_freeList+0x264>
  802e5d:	a1 48 41 80 00       	mov    0x804148,%eax
  802e62:	8b 55 08             	mov    0x8(%ebp),%edx
  802e65:	89 50 04             	mov    %edx,0x4(%eax)
  802e68:	eb 08                	jmp    802e72 <insert_sorted_with_merge_freeList+0x26c>
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	a3 48 41 80 00       	mov    %eax,0x804148
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e84:	a1 54 41 80 00       	mov    0x804154,%eax
  802e89:	40                   	inc    %eax
  802e8a:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e8f:	e9 bb 04 00 00       	jmp    80334f <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e98:	75 17                	jne    802eb1 <insert_sorted_with_merge_freeList+0x2ab>
  802e9a:	83 ec 04             	sub    $0x4,%esp
  802e9d:	68 50 3f 80 00       	push   $0x803f50
  802ea2:	68 4c 01 00 00       	push   $0x14c
  802ea7:	68 ff 3e 80 00       	push   $0x803eff
  802eac:	e8 ce d3 ff ff       	call   80027f <_panic>
  802eb1:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	89 50 04             	mov    %edx,0x4(%eax)
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 40 04             	mov    0x4(%eax),%eax
  802ec3:	85 c0                	test   %eax,%eax
  802ec5:	74 0c                	je     802ed3 <insert_sorted_with_merge_freeList+0x2cd>
  802ec7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecf:	89 10                	mov    %edx,(%eax)
  802ed1:	eb 08                	jmp    802edb <insert_sorted_with_merge_freeList+0x2d5>
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	a3 38 41 80 00       	mov    %eax,0x804138
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eec:	a1 44 41 80 00       	mov    0x804144,%eax
  802ef1:	40                   	inc    %eax
  802ef2:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ef7:	e9 53 04 00 00       	jmp    80334f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802efc:	a1 38 41 80 00       	mov    0x804138,%eax
  802f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f04:	e9 15 04 00 00       	jmp    80331e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	8b 00                	mov    (%eax),%eax
  802f0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	8b 50 08             	mov    0x8(%eax),%edx
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	8b 40 08             	mov    0x8(%eax),%eax
  802f1d:	39 c2                	cmp    %eax,%edx
  802f1f:	0f 86 f1 03 00 00    	jbe    803316 <insert_sorted_with_merge_freeList+0x710>
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	8b 50 08             	mov    0x8(%eax),%edx
  802f2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2e:	8b 40 08             	mov    0x8(%eax),%eax
  802f31:	39 c2                	cmp    %eax,%edx
  802f33:	0f 83 dd 03 00 00    	jae    803316 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 50 08             	mov    0x8(%eax),%edx
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	8b 40 0c             	mov    0xc(%eax),%eax
  802f45:	01 c2                	add    %eax,%edx
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	8b 40 08             	mov    0x8(%eax),%eax
  802f4d:	39 c2                	cmp    %eax,%edx
  802f4f:	0f 85 b9 01 00 00    	jne    80310e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	8b 50 08             	mov    0x8(%eax),%edx
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f61:	01 c2                	add    %eax,%edx
  802f63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f66:	8b 40 08             	mov    0x8(%eax),%eax
  802f69:	39 c2                	cmp    %eax,%edx
  802f6b:	0f 85 0d 01 00 00    	jne    80307e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	8b 50 0c             	mov    0xc(%eax),%edx
  802f77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7d:	01 c2                	add    %eax,%edx
  802f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f82:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f85:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f89:	75 17                	jne    802fa2 <insert_sorted_with_merge_freeList+0x39c>
  802f8b:	83 ec 04             	sub    $0x4,%esp
  802f8e:	68 a8 3f 80 00       	push   $0x803fa8
  802f93:	68 5c 01 00 00       	push   $0x15c
  802f98:	68 ff 3e 80 00       	push   $0x803eff
  802f9d:	e8 dd d2 ff ff       	call   80027f <_panic>
  802fa2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa5:	8b 00                	mov    (%eax),%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	74 10                	je     802fbb <insert_sorted_with_merge_freeList+0x3b5>
  802fab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fae:	8b 00                	mov    (%eax),%eax
  802fb0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb3:	8b 52 04             	mov    0x4(%edx),%edx
  802fb6:	89 50 04             	mov    %edx,0x4(%eax)
  802fb9:	eb 0b                	jmp    802fc6 <insert_sorted_with_merge_freeList+0x3c0>
  802fbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbe:	8b 40 04             	mov    0x4(%eax),%eax
  802fc1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc9:	8b 40 04             	mov    0x4(%eax),%eax
  802fcc:	85 c0                	test   %eax,%eax
  802fce:	74 0f                	je     802fdf <insert_sorted_with_merge_freeList+0x3d9>
  802fd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd3:	8b 40 04             	mov    0x4(%eax),%eax
  802fd6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd9:	8b 12                	mov    (%edx),%edx
  802fdb:	89 10                	mov    %edx,(%eax)
  802fdd:	eb 0a                	jmp    802fe9 <insert_sorted_with_merge_freeList+0x3e3>
  802fdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	a3 38 41 80 00       	mov    %eax,0x804138
  802fe9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffc:	a1 44 41 80 00       	mov    0x804144,%eax
  803001:	48                   	dec    %eax
  803002:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  803007:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803011:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803014:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80301b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80301f:	75 17                	jne    803038 <insert_sorted_with_merge_freeList+0x432>
  803021:	83 ec 04             	sub    $0x4,%esp
  803024:	68 dc 3e 80 00       	push   $0x803edc
  803029:	68 5f 01 00 00       	push   $0x15f
  80302e:	68 ff 3e 80 00       	push   $0x803eff
  803033:	e8 47 d2 ff ff       	call   80027f <_panic>
  803038:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80303e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803041:	89 10                	mov    %edx,(%eax)
  803043:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	74 0d                	je     803059 <insert_sorted_with_merge_freeList+0x453>
  80304c:	a1 48 41 80 00       	mov    0x804148,%eax
  803051:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803054:	89 50 04             	mov    %edx,0x4(%eax)
  803057:	eb 08                	jmp    803061 <insert_sorted_with_merge_freeList+0x45b>
  803059:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803064:	a3 48 41 80 00       	mov    %eax,0x804148
  803069:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803073:	a1 54 41 80 00       	mov    0x804154,%eax
  803078:	40                   	inc    %eax
  803079:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	8b 50 0c             	mov    0xc(%eax),%edx
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	8b 40 0c             	mov    0xc(%eax),%eax
  80308a:	01 c2                	add    %eax,%edx
  80308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030aa:	75 17                	jne    8030c3 <insert_sorted_with_merge_freeList+0x4bd>
  8030ac:	83 ec 04             	sub    $0x4,%esp
  8030af:	68 dc 3e 80 00       	push   $0x803edc
  8030b4:	68 64 01 00 00       	push   $0x164
  8030b9:	68 ff 3e 80 00       	push   $0x803eff
  8030be:	e8 bc d1 ff ff       	call   80027f <_panic>
  8030c3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	89 10                	mov    %edx,(%eax)
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	8b 00                	mov    (%eax),%eax
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	74 0d                	je     8030e4 <insert_sorted_with_merge_freeList+0x4de>
  8030d7:	a1 48 41 80 00       	mov    0x804148,%eax
  8030dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030df:	89 50 04             	mov    %edx,0x4(%eax)
  8030e2:	eb 08                	jmp    8030ec <insert_sorted_with_merge_freeList+0x4e6>
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	a3 48 41 80 00       	mov    %eax,0x804148
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030fe:	a1 54 41 80 00       	mov    0x804154,%eax
  803103:	40                   	inc    %eax
  803104:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803109:	e9 41 02 00 00       	jmp    80334f <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	8b 50 08             	mov    0x8(%eax),%edx
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	8b 40 0c             	mov    0xc(%eax),%eax
  80311a:	01 c2                	add    %eax,%edx
  80311c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311f:	8b 40 08             	mov    0x8(%eax),%eax
  803122:	39 c2                	cmp    %eax,%edx
  803124:	0f 85 7c 01 00 00    	jne    8032a6 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80312a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80312e:	74 06                	je     803136 <insert_sorted_with_merge_freeList+0x530>
  803130:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803134:	75 17                	jne    80314d <insert_sorted_with_merge_freeList+0x547>
  803136:	83 ec 04             	sub    $0x4,%esp
  803139:	68 18 3f 80 00       	push   $0x803f18
  80313e:	68 69 01 00 00       	push   $0x169
  803143:	68 ff 3e 80 00       	push   $0x803eff
  803148:	e8 32 d1 ff ff       	call   80027f <_panic>
  80314d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803150:	8b 50 04             	mov    0x4(%eax),%edx
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	89 50 04             	mov    %edx,0x4(%eax)
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80315f:	89 10                	mov    %edx,(%eax)
  803161:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803164:	8b 40 04             	mov    0x4(%eax),%eax
  803167:	85 c0                	test   %eax,%eax
  803169:	74 0d                	je     803178 <insert_sorted_with_merge_freeList+0x572>
  80316b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316e:	8b 40 04             	mov    0x4(%eax),%eax
  803171:	8b 55 08             	mov    0x8(%ebp),%edx
  803174:	89 10                	mov    %edx,(%eax)
  803176:	eb 08                	jmp    803180 <insert_sorted_with_merge_freeList+0x57a>
  803178:	8b 45 08             	mov    0x8(%ebp),%eax
  80317b:	a3 38 41 80 00       	mov    %eax,0x804138
  803180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803183:	8b 55 08             	mov    0x8(%ebp),%edx
  803186:	89 50 04             	mov    %edx,0x4(%eax)
  803189:	a1 44 41 80 00       	mov    0x804144,%eax
  80318e:	40                   	inc    %eax
  80318f:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803194:	8b 45 08             	mov    0x8(%ebp),%eax
  803197:	8b 50 0c             	mov    0xc(%eax),%edx
  80319a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319d:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a0:	01 c2                	add    %eax,%edx
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ac:	75 17                	jne    8031c5 <insert_sorted_with_merge_freeList+0x5bf>
  8031ae:	83 ec 04             	sub    $0x4,%esp
  8031b1:	68 a8 3f 80 00       	push   $0x803fa8
  8031b6:	68 6b 01 00 00       	push   $0x16b
  8031bb:	68 ff 3e 80 00       	push   $0x803eff
  8031c0:	e8 ba d0 ff ff       	call   80027f <_panic>
  8031c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c8:	8b 00                	mov    (%eax),%eax
  8031ca:	85 c0                	test   %eax,%eax
  8031cc:	74 10                	je     8031de <insert_sorted_with_merge_freeList+0x5d8>
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d6:	8b 52 04             	mov    0x4(%edx),%edx
  8031d9:	89 50 04             	mov    %edx,0x4(%eax)
  8031dc:	eb 0b                	jmp    8031e9 <insert_sorted_with_merge_freeList+0x5e3>
  8031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e1:	8b 40 04             	mov    0x4(%eax),%eax
  8031e4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	8b 40 04             	mov    0x4(%eax),%eax
  8031ef:	85 c0                	test   %eax,%eax
  8031f1:	74 0f                	je     803202 <insert_sorted_with_merge_freeList+0x5fc>
  8031f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f6:	8b 40 04             	mov    0x4(%eax),%eax
  8031f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031fc:	8b 12                	mov    (%edx),%edx
  8031fe:	89 10                	mov    %edx,(%eax)
  803200:	eb 0a                	jmp    80320c <insert_sorted_with_merge_freeList+0x606>
  803202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803205:	8b 00                	mov    (%eax),%eax
  803207:	a3 38 41 80 00       	mov    %eax,0x804138
  80320c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803218:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321f:	a1 44 41 80 00       	mov    0x804144,%eax
  803224:	48                   	dec    %eax
  803225:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  80322a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803234:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803237:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80323e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803242:	75 17                	jne    80325b <insert_sorted_with_merge_freeList+0x655>
  803244:	83 ec 04             	sub    $0x4,%esp
  803247:	68 dc 3e 80 00       	push   $0x803edc
  80324c:	68 6e 01 00 00       	push   $0x16e
  803251:	68 ff 3e 80 00       	push   $0x803eff
  803256:	e8 24 d0 ff ff       	call   80027f <_panic>
  80325b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803261:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803264:	89 10                	mov    %edx,(%eax)
  803266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803269:	8b 00                	mov    (%eax),%eax
  80326b:	85 c0                	test   %eax,%eax
  80326d:	74 0d                	je     80327c <insert_sorted_with_merge_freeList+0x676>
  80326f:	a1 48 41 80 00       	mov    0x804148,%eax
  803274:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803277:	89 50 04             	mov    %edx,0x4(%eax)
  80327a:	eb 08                	jmp    803284 <insert_sorted_with_merge_freeList+0x67e>
  80327c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803287:	a3 48 41 80 00       	mov    %eax,0x804148
  80328c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803296:	a1 54 41 80 00       	mov    0x804154,%eax
  80329b:	40                   	inc    %eax
  80329c:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8032a1:	e9 a9 00 00 00       	jmp    80334f <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032aa:	74 06                	je     8032b2 <insert_sorted_with_merge_freeList+0x6ac>
  8032ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b0:	75 17                	jne    8032c9 <insert_sorted_with_merge_freeList+0x6c3>
  8032b2:	83 ec 04             	sub    $0x4,%esp
  8032b5:	68 74 3f 80 00       	push   $0x803f74
  8032ba:	68 73 01 00 00       	push   $0x173
  8032bf:	68 ff 3e 80 00       	push   $0x803eff
  8032c4:	e8 b6 cf ff ff       	call   80027f <_panic>
  8032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cc:	8b 10                	mov    (%eax),%edx
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	89 10                	mov    %edx,(%eax)
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	8b 00                	mov    (%eax),%eax
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	74 0b                	je     8032e7 <insert_sorted_with_merge_freeList+0x6e1>
  8032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032df:	8b 00                	mov    (%eax),%eax
  8032e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e4:	89 50 04             	mov    %edx,0x4(%eax)
  8032e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ed:	89 10                	mov    %edx,(%eax)
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f5:	89 50 04             	mov    %edx,0x4(%eax)
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	8b 00                	mov    (%eax),%eax
  8032fd:	85 c0                	test   %eax,%eax
  8032ff:	75 08                	jne    803309 <insert_sorted_with_merge_freeList+0x703>
  803301:	8b 45 08             	mov    0x8(%ebp),%eax
  803304:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803309:	a1 44 41 80 00       	mov    0x804144,%eax
  80330e:	40                   	inc    %eax
  80330f:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803314:	eb 39                	jmp    80334f <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803316:	a1 40 41 80 00       	mov    0x804140,%eax
  80331b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80331e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803322:	74 07                	je     80332b <insert_sorted_with_merge_freeList+0x725>
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	8b 00                	mov    (%eax),%eax
  803329:	eb 05                	jmp    803330 <insert_sorted_with_merge_freeList+0x72a>
  80332b:	b8 00 00 00 00       	mov    $0x0,%eax
  803330:	a3 40 41 80 00       	mov    %eax,0x804140
  803335:	a1 40 41 80 00       	mov    0x804140,%eax
  80333a:	85 c0                	test   %eax,%eax
  80333c:	0f 85 c7 fb ff ff    	jne    802f09 <insert_sorted_with_merge_freeList+0x303>
  803342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803346:	0f 85 bd fb ff ff    	jne    802f09 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80334c:	eb 01                	jmp    80334f <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80334e:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80334f:	90                   	nop
  803350:	c9                   	leave  
  803351:	c3                   	ret    
  803352:	66 90                	xchg   %ax,%ax

00803354 <__udivdi3>:
  803354:	55                   	push   %ebp
  803355:	57                   	push   %edi
  803356:	56                   	push   %esi
  803357:	53                   	push   %ebx
  803358:	83 ec 1c             	sub    $0x1c,%esp
  80335b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80335f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803363:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803367:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80336b:	89 ca                	mov    %ecx,%edx
  80336d:	89 f8                	mov    %edi,%eax
  80336f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803373:	85 f6                	test   %esi,%esi
  803375:	75 2d                	jne    8033a4 <__udivdi3+0x50>
  803377:	39 cf                	cmp    %ecx,%edi
  803379:	77 65                	ja     8033e0 <__udivdi3+0x8c>
  80337b:	89 fd                	mov    %edi,%ebp
  80337d:	85 ff                	test   %edi,%edi
  80337f:	75 0b                	jne    80338c <__udivdi3+0x38>
  803381:	b8 01 00 00 00       	mov    $0x1,%eax
  803386:	31 d2                	xor    %edx,%edx
  803388:	f7 f7                	div    %edi
  80338a:	89 c5                	mov    %eax,%ebp
  80338c:	31 d2                	xor    %edx,%edx
  80338e:	89 c8                	mov    %ecx,%eax
  803390:	f7 f5                	div    %ebp
  803392:	89 c1                	mov    %eax,%ecx
  803394:	89 d8                	mov    %ebx,%eax
  803396:	f7 f5                	div    %ebp
  803398:	89 cf                	mov    %ecx,%edi
  80339a:	89 fa                	mov    %edi,%edx
  80339c:	83 c4 1c             	add    $0x1c,%esp
  80339f:	5b                   	pop    %ebx
  8033a0:	5e                   	pop    %esi
  8033a1:	5f                   	pop    %edi
  8033a2:	5d                   	pop    %ebp
  8033a3:	c3                   	ret    
  8033a4:	39 ce                	cmp    %ecx,%esi
  8033a6:	77 28                	ja     8033d0 <__udivdi3+0x7c>
  8033a8:	0f bd fe             	bsr    %esi,%edi
  8033ab:	83 f7 1f             	xor    $0x1f,%edi
  8033ae:	75 40                	jne    8033f0 <__udivdi3+0x9c>
  8033b0:	39 ce                	cmp    %ecx,%esi
  8033b2:	72 0a                	jb     8033be <__udivdi3+0x6a>
  8033b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033b8:	0f 87 9e 00 00 00    	ja     80345c <__udivdi3+0x108>
  8033be:	b8 01 00 00 00       	mov    $0x1,%eax
  8033c3:	89 fa                	mov    %edi,%edx
  8033c5:	83 c4 1c             	add    $0x1c,%esp
  8033c8:	5b                   	pop    %ebx
  8033c9:	5e                   	pop    %esi
  8033ca:	5f                   	pop    %edi
  8033cb:	5d                   	pop    %ebp
  8033cc:	c3                   	ret    
  8033cd:	8d 76 00             	lea    0x0(%esi),%esi
  8033d0:	31 ff                	xor    %edi,%edi
  8033d2:	31 c0                	xor    %eax,%eax
  8033d4:	89 fa                	mov    %edi,%edx
  8033d6:	83 c4 1c             	add    $0x1c,%esp
  8033d9:	5b                   	pop    %ebx
  8033da:	5e                   	pop    %esi
  8033db:	5f                   	pop    %edi
  8033dc:	5d                   	pop    %ebp
  8033dd:	c3                   	ret    
  8033de:	66 90                	xchg   %ax,%ax
  8033e0:	89 d8                	mov    %ebx,%eax
  8033e2:	f7 f7                	div    %edi
  8033e4:	31 ff                	xor    %edi,%edi
  8033e6:	89 fa                	mov    %edi,%edx
  8033e8:	83 c4 1c             	add    $0x1c,%esp
  8033eb:	5b                   	pop    %ebx
  8033ec:	5e                   	pop    %esi
  8033ed:	5f                   	pop    %edi
  8033ee:	5d                   	pop    %ebp
  8033ef:	c3                   	ret    
  8033f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033f5:	89 eb                	mov    %ebp,%ebx
  8033f7:	29 fb                	sub    %edi,%ebx
  8033f9:	89 f9                	mov    %edi,%ecx
  8033fb:	d3 e6                	shl    %cl,%esi
  8033fd:	89 c5                	mov    %eax,%ebp
  8033ff:	88 d9                	mov    %bl,%cl
  803401:	d3 ed                	shr    %cl,%ebp
  803403:	89 e9                	mov    %ebp,%ecx
  803405:	09 f1                	or     %esi,%ecx
  803407:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80340b:	89 f9                	mov    %edi,%ecx
  80340d:	d3 e0                	shl    %cl,%eax
  80340f:	89 c5                	mov    %eax,%ebp
  803411:	89 d6                	mov    %edx,%esi
  803413:	88 d9                	mov    %bl,%cl
  803415:	d3 ee                	shr    %cl,%esi
  803417:	89 f9                	mov    %edi,%ecx
  803419:	d3 e2                	shl    %cl,%edx
  80341b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80341f:	88 d9                	mov    %bl,%cl
  803421:	d3 e8                	shr    %cl,%eax
  803423:	09 c2                	or     %eax,%edx
  803425:	89 d0                	mov    %edx,%eax
  803427:	89 f2                	mov    %esi,%edx
  803429:	f7 74 24 0c          	divl   0xc(%esp)
  80342d:	89 d6                	mov    %edx,%esi
  80342f:	89 c3                	mov    %eax,%ebx
  803431:	f7 e5                	mul    %ebp
  803433:	39 d6                	cmp    %edx,%esi
  803435:	72 19                	jb     803450 <__udivdi3+0xfc>
  803437:	74 0b                	je     803444 <__udivdi3+0xf0>
  803439:	89 d8                	mov    %ebx,%eax
  80343b:	31 ff                	xor    %edi,%edi
  80343d:	e9 58 ff ff ff       	jmp    80339a <__udivdi3+0x46>
  803442:	66 90                	xchg   %ax,%ax
  803444:	8b 54 24 08          	mov    0x8(%esp),%edx
  803448:	89 f9                	mov    %edi,%ecx
  80344a:	d3 e2                	shl    %cl,%edx
  80344c:	39 c2                	cmp    %eax,%edx
  80344e:	73 e9                	jae    803439 <__udivdi3+0xe5>
  803450:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803453:	31 ff                	xor    %edi,%edi
  803455:	e9 40 ff ff ff       	jmp    80339a <__udivdi3+0x46>
  80345a:	66 90                	xchg   %ax,%ax
  80345c:	31 c0                	xor    %eax,%eax
  80345e:	e9 37 ff ff ff       	jmp    80339a <__udivdi3+0x46>
  803463:	90                   	nop

00803464 <__umoddi3>:
  803464:	55                   	push   %ebp
  803465:	57                   	push   %edi
  803466:	56                   	push   %esi
  803467:	53                   	push   %ebx
  803468:	83 ec 1c             	sub    $0x1c,%esp
  80346b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80346f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803473:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803477:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80347b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80347f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803483:	89 f3                	mov    %esi,%ebx
  803485:	89 fa                	mov    %edi,%edx
  803487:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80348b:	89 34 24             	mov    %esi,(%esp)
  80348e:	85 c0                	test   %eax,%eax
  803490:	75 1a                	jne    8034ac <__umoddi3+0x48>
  803492:	39 f7                	cmp    %esi,%edi
  803494:	0f 86 a2 00 00 00    	jbe    80353c <__umoddi3+0xd8>
  80349a:	89 c8                	mov    %ecx,%eax
  80349c:	89 f2                	mov    %esi,%edx
  80349e:	f7 f7                	div    %edi
  8034a0:	89 d0                	mov    %edx,%eax
  8034a2:	31 d2                	xor    %edx,%edx
  8034a4:	83 c4 1c             	add    $0x1c,%esp
  8034a7:	5b                   	pop    %ebx
  8034a8:	5e                   	pop    %esi
  8034a9:	5f                   	pop    %edi
  8034aa:	5d                   	pop    %ebp
  8034ab:	c3                   	ret    
  8034ac:	39 f0                	cmp    %esi,%eax
  8034ae:	0f 87 ac 00 00 00    	ja     803560 <__umoddi3+0xfc>
  8034b4:	0f bd e8             	bsr    %eax,%ebp
  8034b7:	83 f5 1f             	xor    $0x1f,%ebp
  8034ba:	0f 84 ac 00 00 00    	je     80356c <__umoddi3+0x108>
  8034c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8034c5:	29 ef                	sub    %ebp,%edi
  8034c7:	89 fe                	mov    %edi,%esi
  8034c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034cd:	89 e9                	mov    %ebp,%ecx
  8034cf:	d3 e0                	shl    %cl,%eax
  8034d1:	89 d7                	mov    %edx,%edi
  8034d3:	89 f1                	mov    %esi,%ecx
  8034d5:	d3 ef                	shr    %cl,%edi
  8034d7:	09 c7                	or     %eax,%edi
  8034d9:	89 e9                	mov    %ebp,%ecx
  8034db:	d3 e2                	shl    %cl,%edx
  8034dd:	89 14 24             	mov    %edx,(%esp)
  8034e0:	89 d8                	mov    %ebx,%eax
  8034e2:	d3 e0                	shl    %cl,%eax
  8034e4:	89 c2                	mov    %eax,%edx
  8034e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ea:	d3 e0                	shl    %cl,%eax
  8034ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034f4:	89 f1                	mov    %esi,%ecx
  8034f6:	d3 e8                	shr    %cl,%eax
  8034f8:	09 d0                	or     %edx,%eax
  8034fa:	d3 eb                	shr    %cl,%ebx
  8034fc:	89 da                	mov    %ebx,%edx
  8034fe:	f7 f7                	div    %edi
  803500:	89 d3                	mov    %edx,%ebx
  803502:	f7 24 24             	mull   (%esp)
  803505:	89 c6                	mov    %eax,%esi
  803507:	89 d1                	mov    %edx,%ecx
  803509:	39 d3                	cmp    %edx,%ebx
  80350b:	0f 82 87 00 00 00    	jb     803598 <__umoddi3+0x134>
  803511:	0f 84 91 00 00 00    	je     8035a8 <__umoddi3+0x144>
  803517:	8b 54 24 04          	mov    0x4(%esp),%edx
  80351b:	29 f2                	sub    %esi,%edx
  80351d:	19 cb                	sbb    %ecx,%ebx
  80351f:	89 d8                	mov    %ebx,%eax
  803521:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803525:	d3 e0                	shl    %cl,%eax
  803527:	89 e9                	mov    %ebp,%ecx
  803529:	d3 ea                	shr    %cl,%edx
  80352b:	09 d0                	or     %edx,%eax
  80352d:	89 e9                	mov    %ebp,%ecx
  80352f:	d3 eb                	shr    %cl,%ebx
  803531:	89 da                	mov    %ebx,%edx
  803533:	83 c4 1c             	add    $0x1c,%esp
  803536:	5b                   	pop    %ebx
  803537:	5e                   	pop    %esi
  803538:	5f                   	pop    %edi
  803539:	5d                   	pop    %ebp
  80353a:	c3                   	ret    
  80353b:	90                   	nop
  80353c:	89 fd                	mov    %edi,%ebp
  80353e:	85 ff                	test   %edi,%edi
  803540:	75 0b                	jne    80354d <__umoddi3+0xe9>
  803542:	b8 01 00 00 00       	mov    $0x1,%eax
  803547:	31 d2                	xor    %edx,%edx
  803549:	f7 f7                	div    %edi
  80354b:	89 c5                	mov    %eax,%ebp
  80354d:	89 f0                	mov    %esi,%eax
  80354f:	31 d2                	xor    %edx,%edx
  803551:	f7 f5                	div    %ebp
  803553:	89 c8                	mov    %ecx,%eax
  803555:	f7 f5                	div    %ebp
  803557:	89 d0                	mov    %edx,%eax
  803559:	e9 44 ff ff ff       	jmp    8034a2 <__umoddi3+0x3e>
  80355e:	66 90                	xchg   %ax,%ax
  803560:	89 c8                	mov    %ecx,%eax
  803562:	89 f2                	mov    %esi,%edx
  803564:	83 c4 1c             	add    $0x1c,%esp
  803567:	5b                   	pop    %ebx
  803568:	5e                   	pop    %esi
  803569:	5f                   	pop    %edi
  80356a:	5d                   	pop    %ebp
  80356b:	c3                   	ret    
  80356c:	3b 04 24             	cmp    (%esp),%eax
  80356f:	72 06                	jb     803577 <__umoddi3+0x113>
  803571:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803575:	77 0f                	ja     803586 <__umoddi3+0x122>
  803577:	89 f2                	mov    %esi,%edx
  803579:	29 f9                	sub    %edi,%ecx
  80357b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80357f:	89 14 24             	mov    %edx,(%esp)
  803582:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803586:	8b 44 24 04          	mov    0x4(%esp),%eax
  80358a:	8b 14 24             	mov    (%esp),%edx
  80358d:	83 c4 1c             	add    $0x1c,%esp
  803590:	5b                   	pop    %ebx
  803591:	5e                   	pop    %esi
  803592:	5f                   	pop    %edi
  803593:	5d                   	pop    %ebp
  803594:	c3                   	ret    
  803595:	8d 76 00             	lea    0x0(%esi),%esi
  803598:	2b 04 24             	sub    (%esp),%eax
  80359b:	19 fa                	sbb    %edi,%edx
  80359d:	89 d1                	mov    %edx,%ecx
  80359f:	89 c6                	mov    %eax,%esi
  8035a1:	e9 71 ff ff ff       	jmp    803517 <__umoddi3+0xb3>
  8035a6:	66 90                	xchg   %ax,%ax
  8035a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035ac:	72 ea                	jb     803598 <__umoddi3+0x134>
  8035ae:	89 d9                	mov    %ebx,%ecx
  8035b0:	e9 62 ff ff ff       	jmp    803517 <__umoddi3+0xb3>
